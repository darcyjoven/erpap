DATABASE ds
MAIN
   DEFINE l_sma892      LIKE sma_file.sma892
   DEFINE l_sma892_old  STRING
   DEFINE l_sma892_new  STRING
   DEFINE l_azw05       DYNAMIC ARRAY OF LIKE azw_file.azw05
   DEFINE l_cnt         SMALLINT
   DEFINE l_k           SMALLINT


   LET l_cnt = 1

   # ---get database list---
   DECLARE azw05_cur CURSOR FOR
   SELECT UNIQUE azw05 FROM azw_file
    WHERE azw05 = azw06

   FOREACH azw05_cur INTO l_azw05[l_cnt]
      IF SQLCA.SQLCODE THEN
         DISPLAY "Can't select any DB list from azw_file."
         EXIT PROGRAM
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_azw05.deleteElement(l_cnt)

   # ---change value of sma892---
   FOR l_k = 1 TO l_azw05.getLength()
      CLOSE DATABASE
      DISPLAY l_azw05[l_k]
      DATABASE l_azw05[l_k]

      SELECT sma892 INTO l_sma892 FROM sma_file
      LET l_sma892_old = l_sma892
      DISPLAY "DB:",l_azw05[l_k],"  sma892_old:",l_sma892_old
      LET l_sma892_new = l_sma892_old.subString(1,1),'NN',l_sma892_old.subString(4,l_sma892_old.getLength())
      DISPLAY "DB:",l_azw05[l_k],"  sma892_new:",l_sma892_new

      LET l_sma892 = l_sma892_new
      UPDATE sma_file SET sma892 = l_sma892
      IF SQLCA.SQLCODE THEN
         DISPLAY "UPDATE ERROR:",sqlca.sqlcode,"DB:",l_azw05[l_k],"old_sma892:",l_sma892_old,"new_sma892:",l_sma892_new
         EXIT PROGRAM
      END IF
   END FOR
   CLOSE DATABASE
   DATABASE ds
END MAIN
