# Modify        : No:TQC-820013 2008/02/19 by alexstar 動態抓取temporary tablespace名稱

DATABASE ds
DEFINE   g_dir        STRING
DEFINE   g_db_type    CHAR(3)
DEFINE   g_dbs        CHAR(10)
DEFINE   g_tempdir    STRING
DEFINE   g_system_pwd CHAR(20)

MAIN
   DEFINE readfile_channel   base.channel
   DEFINE   p_str         STRING
   DEFINE   l_str         STRING
   DEFINE   l_rec_b       SMALLINT
   DEFINE   l_max_rec     SMALLINT
   DEFINE   l_result      SMALLINT
   DEFINE   l_result_idx  SMALLINT
   DEFINE   l_cust        CHAR(30)
   DEFINE   l_dbpath      CHAR(50)
   DEFINE   l_cmd         STRING
   DEFINE   l_sql         STRING
   DEFINE   l_msg         CHAR(100)
   DEFINE   l_char        CHAR(1)
   DEFINE   l_bug_flag    SMALLINT
   DEFINE   l_database    DYNAMIC ARRAY OF RECORD
                          patch   CHAR(1),
                          backup  CHAR(1),
                          name    CHAR(20)
                          END RECORD
   DEFINE   l_n           SMALLINT
   DEFINE   l_i           SMALLINT
   DEFINE   l_ac          SMALLINT
   DEFINE   l_cmdfile_loc CHAR(100)


   WHENEVER ERROR CONTINUE
   DEFER INTERRUPT
   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET g_dir=YEAR(TODAY)||MONTH(TODAY)||DAY(TODAY)
display "g_dir:",g_dir
   CALL fgl_getenv("TEMPDIR") RETURNING g_tempdir
   LET l_result=1
   WHILE l_result
         PROMPT "please input the password of user system : " FOR g_system_pwd
         IF g_system_pwd is null or g_system_pwd=' ' THEN
            LET l_result=1
         ELSE
            LET l_cmd="sqlplus system/",g_system_pwd CLIPPED," <<%%\n\n\n%%"
            RUN l_cmd RETURNING l_result
         END IF
         IF l_result=1 THEN
            DISPLAY "password error!!"
         END IF
         IF INT_FLAG THEN
            EXIT PROGRAM
         END IF
   END WHILE
   LET l_result=1
   WHILE l_result
         PROMPT "please input the command file name : " FOR l_cmdfile_loc
         IF l_cmdfile_loc is null or l_cmdfile_loc=' ' THEN
            LET l_result=1
         ELSE
            LET l_cmd="test -s ",l_cmdfile_loc
            RUN l_cmd RETURNING l_result
         END IF
         IF l_result=1 THEN
            DISPLAY "command file not exist!!"
         END IF
         IF INT_FLAG THEN
            EXIT PROGRAM
         END IF
   END WHILE
   IF l_result = 0 THEN
      IF g_db_type="IFX" THEN
         LET l_sql="SELECT azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                   " AND azp03 in (select name from sysdatabases)"
         DATABASE sysmaster
      ELSE
         LET l_sql="SELECT azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                   " AND UPPER(azp03) in (select username from all_users)"
      END IF
      DECLARE patch_sel_db CURSOR FROM l_sql
      LET l_database[1].name="ds"
      LET l_database[1].backup='Y'
      LET l_database[1].patch='Y'
      LET l_i=2
      FOREACH patch_sel_db INTO l_database[l_i].name
         LET l_database[l_i].backup='N'
         LET l_database[l_i].patch='N'
         -- ds重覆就不再放了
         IF l_database[l_i].name != 'ds' THEN
            LET l_i=l_i+1
         END IF
      END FOREACH
      IF g_db_type="IFX" THEN
         DATABASE ds
      END IF
      CALL l_database.deleteElement(l_i)
      OPEN WINDOW db_backup AT 10,10 WITH FORM "patch_cust.42f"
      INPUT ARRAY l_database WITHOUT DEFAULTS FROM s_check.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=l_max_rec,UNBUFFERED)
          BEFORE INPUT
              CALL fgl_set_arr_curr(l_ac)

          BEFORE ROW
              LET l_ac = ARR_CURR()
              LET l_n  = ARR_COUNT()

          BEFORE FIELD a
              IF l_database[l_ac].name="ds" THEN
                 NEXT FIELD azp03
              END IF
      END INPUT
      CLOSE WINDOW db_backup
      IF INT_FLAG=1 THEN
         DISPLAY "patch中斷!!"
         RETURN
      END IF
      FOR l_i=1 TO l_database.getLength()
      IF l_database[l_i].patch='Y' THEN
         IF g_db_type="IFX" THEN
         DATABASE sysmaster
            IF SQLCA.SQLCODE THEN
               DISPLAY SQLCA.SQLCODE,"切換資料庫發生錯誤,異常中止!!"
               EXIT PROGRAM
            END IF
            select count(*) INTO l_n
              from sysdatabases
             where name=l_database[l_i].name
            IF l_n=0 THEN
               CONTINUE FOR
            END IF
         ELSE
            SELECT COUNT(1) INTO l_n
              FROM all_users
             WHERE lower(username)=l_database[l_i].name
            IF l_n=0 THEN
               DISPLAY l_database[l_i].name CLIPPED,"不存在，略過不予處理!!"
               CONTINUE FOR
            END IF
         END IF
         IF l_database[l_i].backup='Y' THEN
            CALL gencmd(l_database[l_i].name)
         ELSE
            RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.qaz"
            RUN "chmod 777 $TEMPDIR/fglprofile.qaz"
            LET l_str=g_tempdir CLIPPED,"/fglprofile.script"
            LET readfile_channel=base.channel.create()
            CALL readfile_channel.setdelimiter("")
            CALL readfile_channel.openfile(l_str CLIPPED, "w" )
            CALL readfile_channel.write("ex $TEMPDIR/fglprofile.qaz <<%%")
            CALL readfile_channel.write("g/ds2\.source")
            CALL readfile_channel.write("-1")
            CALL readfile_channel.write("a")
            
            CALL readfile_channel.write('dbi.database.qazzaq.source= "`echo ${ORACLE_SID}`" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.username= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.password= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.schema= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.ora.prefetch.rows = 1 # Add by Raymon 02/02')
            CALL readfile_channel.write("")
            CALL readfile_channel.write(".")
            CALL readfile_channel.write("w")
            CALL readfile_channel.write("q")
            CALL readfile_channel.write("%%")
            CALL readfile_channel.close() 
            RUN "chmod 777 $TEMPDIR/fglprofile.script"
            RUN "$TEMPDIR/fglprofile.script"
         END IF
         IF g_db_type='IFX' THEN
            LET l_cmd="$FGLRUN runcmd_execmd.42m ",g_db_type CLIPPED," ",
                      g_dir CLIPPED," ",l_database[l_i].name CLIPPED," ",
                      l_database[l_i].backup CLIPPED," ",l_cmdfile_loc CLIPPED
            RUN l_cmd
         ELSE
            LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;$FGLRUN runcmd_execmd.42m ",g_db_type CLIPPED," ",g_dir CLIPPED," ",l_database[l_i].name CLIPPED," ",l_database[l_i].backup CLIPPED," ",l_cmdfile_loc CLIPPED
display l_cmd
            RUN l_cmd
         END IF
         IF l_database[l_i].name='ds' THEN
            RUN "test -s $TEMPDIR/result" RETURNING l_result
            IF not l_result THEN
               DISPLAY '資料庫未更新,程式資料也未更新'
               IF g_db_type="ORA" THEN
                  LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;rm $FGLPROFILE"
                  RUN l_cmd
               END IF
               RETURN
            END IF
         END IF
      END IF
      END FOR
DATABASE ds
       IF g_db_type="ORA" THEN
          LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;rm $FGLPROFILE"
          RUN l_cmd
       END IF
       IF g_db_type="IFX" THEN
          RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
       ELSE
          RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
       END IF
   ELSE
       DISPLAY "command file not exist!!"
   END IF
END MAIN


FUNCTION gencmd(p_database)
define readfile_channel   base.channel,
       l_str              string,
       l_right            char(1),
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       p_database  char(20)
DEFINE l_tmp_name  CHAR(20)  #TQC-820013


#產生shell要將ds複製一份出來模擬
    IF g_db_type='IFX' THEN
       LET l_str=g_tempdir CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       CALL readfile_channel.write("cd $TOP/tmp")
       CALL readfile_channel.write("if [[ -d qazzaq.exp ]] then")
       CALL readfile_channel.write("rm -rf qazzaq.exp")
       CALL readfile_channel.write("fi")
       LET l_str="if [[ -d ",p_database CLIPPED,".exp ]] then"
       CALL readfile_channel.write(l_str)
       LET l_str="rm -rf ",p_database CLIPPED,".exp"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("fi")
       CALL readfile_channel.write('echo "select name from sysdatabases"|dbaccess sysmaster|grep qazzaq > /dev/null 2>&1')
       CALL readfile_channel.write("if [[ $? = 0 ]] then")
       CALL readfile_channel.write('echo "drop database qazzaq"|dbaccess > /dev/null 2>&1')
       CALL readfile_channel.write("fi")
       CALL readfile_channel.write("export DBDATE=Y4MD/")
       LET l_str="dbexport ",p_database CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="ex $TOP/tmp/",p_database CLIPPED,".exp/",
                 p_database CLIPPED,".sql <<%%"
       CALL readfile_channel.write(l_str)
       LET l_str="g/DATABASE ",p_database CLIPPED,"/s//DATABASE qazzaq/g"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("wq")
       CALL readfile_channel.write("%%")
       LET l_str="mv $TOP/tmp/",p_database CLIPPED,".exp/",p_database CLIPPED,
                 ".sql $TOP/tmp/",p_database CLIPPED,".exp/qazzaq.sql"
       CALL readfile_channel.write(l_str)
       LET l_str="mv ",p_database CLIPPED,".exp qazzaq.exp"
       CALL readfile_channel.write(l_str)
       LET l_str="dbimport qazzaq -d ",g_dbs CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="mv qazzaq.exp ",p_database CLIPPED,".exp"
       CALL readfile_channel.write(l_str)
       LET l_str="mv $TOP/tmp/",p_database CLIPPED,".exp/qazzaq.sql $TOP/tmp/",
                 p_database CLIPPED,".exp/",p_database CLIPPED,".sql"
       CALL readfile_channel.write(l_str)
       LET l_str="ex $TOP/tmp/",p_database CLIPPED,".exp/",
                 p_database CLIPPED,".sql <<%%"
       CALL readfile_channel.write(l_str)
       LET l_str="g/DATABASE qazzaq/s//DATABASE ",p_database CLIPPED,"/g"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("wq")
       CALL readfile_channel.write("%%")
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/exp.sh"
CLOSE DATABASE
       RUN "$TEMPDIR/exp.sh"
    ELSE
       SELECT property_value INTO l_tmp_name FROM database_properties   #TQC-820013
        WHERE property_name='DEFAULT_TEMP_TABLESPACE'

       LET l_str=g_tempdir CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       LET l_str="#up_priv.sh ",p_database CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="exp ",p_database CLIPPED,"/",p_database CLIPPED,
                 " owner=",p_database CLIPPED," file='",g_tempdir CLIPPED,
                 "/",p_database CLIPPED,".dmp' direct=y"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       LET l_str="conn system/",g_system_pwd CLIPPED,"@`echo $ORACLE_SID`;"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("create user qazzaq identified by qazzaq")
       LET l_str="default tablespace ",g_dbs CLIPPED
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("temporary tablespace " || l_tmp_name CLIPPED || ";")  #TQC-820013
       CALL readfile_channel.write("grant create session,create table to qazzaq;")
       CALL readfile_channel.write("grant resource to qazzaq;")
       CALL readfile_channel.write("grant create synonym to qazzaq;")
       CALL readfile_channel.write("conn / as sysdba;")
       CALL readfile_channel.write("grant select on sys.v_\\$session to qazzaq;")
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       LET l_str="w! ",g_tempdir CLIPPED,"/createdb.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       CALL readfile_channel.write("conn qazzaq/qazzaq@`echo $ORACLE_SID`;")
       CALL readfile_channel.write("@alterazo;")
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       LET l_str="w! ",g_tempdir CLIPPED,"/createdb1.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       LET l_str="sqlplus system/",g_system_pwd CLIPPED," < $TEMPDIR/createdb.sql"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("cd $TOP/ora/work")
       LET l_str="imp system/manager fromuser=",p_database CLIPPED,
                 " touser=qazzaq file='",g_tempdir CLIPPED,"/",p_database CLIPPED,".dmp' ignore=y"
       CALL readfile_channel.write(l_str)
       LET l_str="sqlplus system/",g_system_pwd CLIPPED," < $TEMPDIR/createdb1.sql"
       CALL readfile_channel.write(l_str)
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/exp.sh"
       RUN "$TEMPDIR/exp.sh"
       RUN "chmod 777 $TEMPDIR/createdb.sql"
       RUN "chmod 777 $TEMPDIR/createdb1.sql"
       RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.qaz"
       RUN "chmod 777 $TEMPDIR/fglprofile.qaz"
       LET l_str=g_tempdir CLIPPED,"/fglprofile.script"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("ex $TEMPDIR/fglprofile.qaz <<%%")
       CALL readfile_channel.write("g/ds2\.source")
       CALL readfile_channel.write("-1")
       CALL readfile_channel.write("a")
       
       CALL readfile_channel.write('dbi.database.qazzaq.source= "`echo ${ORACLE_SID}`" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.username= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.password= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.schema= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.ora.prefetch.rows = 1 # Add by Raymon 02/02')
       CALL readfile_channel.write("")
       CALL readfile_channel.write(".")
       CALL readfile_channel.write("w")
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/fglprofile.script"
       RUN "$TEMPDIR/fglprofile.script"
    END IF
END FUNCTION
