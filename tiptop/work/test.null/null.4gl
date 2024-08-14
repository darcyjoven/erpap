DATABASE ds_init
MAIN
  DEFINE l_tmp01   VARCHAR(10)
  DEFINE l_tmp02   VARCHAR(10)
  DEFINE l_tmp03   VARCHAR(10)
  DEFINE l_msg     VARCHAR(80)
  DELETE FROM tmp_file
  INSERT INTO tmp_file VALUES ('1','1','1')
  INSERT INTO tmp_file VALUES ('2','','2')
  INSERT INTO tmp_file VALUES ('3','','')
  DISPLAY "Test: SCROLL cursor + OPEN-FETCH "
    DECLARE cur_1 SCROLL CURSOR FOR
     SELECT tmp01,tmp02,tmp03 FROM tmp_file ORDER BY tmp01
    OPEN cur_1
    FETCH cur_1 INTO l_tmp01,l_tmp02,l_tmp03
    LET l_msg="'",l_tmp01,"',","'",l_tmp02,"',","'",l_tmp03,"'"
    DISPLAY l_msg
    FETCH cur_1 INTO l_tmp01,l_tmp02,l_tmp03
    LET l_msg="'",l_tmp01,"',","'",l_tmp02,"',","'",l_tmp03,"'"
    DISPLAY l_msg
    FETCH cur_1 INTO l_tmp01,l_tmp02,l_tmp03
    LET l_msg="'",l_tmp01,"',","'",l_tmp02,"',","'",l_tmp03,"'"
    DISPLAY l_msg
    CLOSE cur_1
  DISPLAY "Test: SCROLL cursor + FOREACH + the Last field's value IS NOT NULL"
    DECLARE cur_2 SCROLL CURSOR FOR
     SELECT tmp01,tmp02,tmp03 FROM tmp_file WHERE tmp01 IN ('1','2') ORDER 
BY tmp01
  FOREACH cur_2 INTO l_tmp01,l_tmp02,l_tmp03
    LET l_msg="'",l_tmp01,"',","'",l_tmp02,"',","'",l_tmp03,"'"
    DISPLAY l_msg
  END FOREACH
  DISPLAY "Test: SCROLL cursor + FOREACH + the Last field's value IS NULL"
    DECLARE cur_3 SCROLL CURSOR FOR
     SELECT tmp01,tmp02,tmp03 FROM tmp_file ORDER BY tmp01
  FOREACH cur_3 INTO l_tmp01,l_tmp02,l_tmp03
    LET l_msg="'",l_tmp01,"',","'",l_tmp02,"',","'",l_tmp03,"'"
    DISPLAY l_msg
  END FOREACH
END MAIN

