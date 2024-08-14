DATABASE ds


MAIN
   DEFINE l_txt        STRING
   DEFINE l_top        STRING
   DEFINE l_cmd        STRING
   DEFINE l_file       DYNAMIC ARRAY OF VARCHAR(10)
   DEFINE l_cnt        SMALLINT
   DEFINE l_file1      VARCHAR(10)
   DEFINE l_k          SMALLINT
   DEFINE l_i          SMALLINT
   DEFINE g_dbs        VARCHAR(10)
   DEFINE l_azp03      DYNAMIC ARRAY OF VARCHAR(10)


   LET l_top = FGL_GETENV('TOP')
   LET l_txt = l_top,"/tmp/get_ds_synonym_list.txt"
   LET l_cmd = "rm ",l_txt
   RUN l_cmd

   # get ds synonym table list
   DECLARE ds_synonym_list_curs CURSOR FOR
     SELECT object_name FROM user_objects WHERE object_type ='SYNONYM'

   LET l_cnt = 1
   FOREACH ds_synonym_list_curs INTO l_file[l_cnt]
      LET l_cmd = "echo '",l_file[l_cnt],"' >> ",l_txt
      RUN l_cmd
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_file.deleteElement(l_cnt)

   # get db list
   DECLARE db_list_curs CURSOR FOR
      SELECT UNIQUE azp03 FROM azp_file ORDER BY azp03 DESC

   LET l_cnt = 1
   FOREACH db_list_curs INTO l_azp03[l_cnt]
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_azp03.deleteElement(l_cnt)


   FOR l_i = 1 TO l_azp03.getLength()
      CLOSE DATABASE
      LET g_dbs = l_azp03[l_i]
      DATABASE g_dbs
      IF SQLCA.SQLCODE THEN
         DISPLAY "trans DB to be ",g_dbs," error!"
      ELSE
         FOR l_k = 1 TO l_file.getLength()
            LET l_file1 = DOWNSHIFT(l_file[l_k])
            DISPLAY "synonym table:",l_file1
            SELECT COUNT(*) INTO l_cnt FROM zta_file
             WHERE zta01 = l_file1
            IF l_cnt > 0 THEN
               DELETE FROM zta_file WHERE zta01 = l_file1 AND zta02 = g_dbs
               IF SQLCA.SQLCODE THEN
                  DISPLAY "zta_file data delete error --> DB:",g_dbs," table:",l_file1
               END IF
            END IF

            SELECT COUNT(*) INTO l_cnt FROM user_synonyms WHERE synonym_name = l_file[l_k]
            IF l_cnt > 0 THEN
               LET l_cmd = "drop synonym ",l_file1
               DISPLAY g_dbs
               DISPLAY l_cmd
               EXECUTE IMMEDIATE l_cmd
               IF SQLCA.SQLCODE THEN
                  DISPLAY "DB synonym drop error --> DB:",g_dbs," table:",l_file1
               END IF
            END IF
         END FOR
      END IF
   END FOR
   CLOSE DATABASE
   DATABASE ds
END MAIN
