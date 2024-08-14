# Modify.........: No:TQC-B50098 11/05/31 By tsai_yen sid太小,重新定義sid DECIMAL(20,0)
# Modify.........: No:TQC-C50171 12/05/21 By andyhuang 取得Table的all_users改為user_table
# Modify.........: No:TQC-D40013 13/04/02 By andyhuang 加入recyclebin off by session
MAIN
  DEFINE sid DECIMAL(20,0)   #TQC-B50098
  DEFINE idx INTEGER
  DEFINE str, tn STRING
  DEFINE o, t, tname VARCHAR(30)
  DEFINE db, un, up VARCHAR(100)
  DEFINE cnt INTEGER 

  IF num_args()!=1 AND num_args()!=3 THEN
    DISPLAY "Usage: fglrun newcleanttabs dbname [username password]"
    EXIT PROGRAM 1
  END IF
  LET db = arg_val(1)
  IF num_args()==1 THEN
    CONNECT TO db
  ELSE
    LET un = arg_val(2)
    LET up = arg_val(3)
    CONNECT TO db USER un USING up
  END IF

  EXECUTE IMMEDIATE "alter session set recyclebin = off"        #TQC-D40013

  WHENEVER ANY ERROR continue
  DROP TABLE ttab
  WHENEVER ANY ERROR stop

  EXECUTE IMMEDIATE "create table ttab as select upper('"||db||"') as owner, table_name from user_tables where tablespace_name = 'TEMPTABS' "   #TQC-C50171
   
  DECLARE c1 CURSOR
    FROM "select audsid from v$session where audsid>0"
  BEGIN WORK
  FOREACH c1 INTO sid
    DECLARE c2 CURSOR FOR 
      SELECT table_name FROM ttab FOR UPDATE
    FOREACH c2 INTO tname
      LET tn = tname
      LET idx = tn.getIndexOf("_",1)
      LET str = tn.subString(3,idx-1)
      IF str = sid THEN
        DELETE FROM ttab WHERE CURRENT OF c2
      END IF
    END FOREACH
  END FOREACH
  COMMIT WORK
  
  DECLARE c3 CURSOR FOR
    SELECT owner, table_name FROM ttab 
  LET cnt = 0
  FOREACH c3 INTO o, t
    DISPLAY "Dropping table: "||o||"."||t
    WHENEVER ERROR CONTINUE
    EXECUTE IMMEDIATE "drop sequence "||o||"."||t||"_srl"
    EXECUTE IMMEDIATE "drop table "||o||"."||t
    IF status!=0 THEN
      DISPLAY "   ERROR: Could not drop table..."
    ELSE
      LET cnt = cnt + 1
    END IF
    WHENEVER ERROR STOP
  END FOREACH

  DISPLAY "Number of tables dropped: ", cnt  

  DROP TABLE ttab
END MAIN
