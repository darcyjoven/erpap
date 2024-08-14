
DATABASE ds

DEFINE l_source DYNAMIC ARRAY OF RECORD
         name   VARCHAR(20),
         type   VARCHAR(10)
                END RECORD
DEFINE l_name   VARCHAR(20)
DEFINE l_type   VARCHAR(10)                
DEFINE l_cnt    INTEGER
DEFINE l_sql    STRING
DEFINE l_arg1   VARCHAR(10)
DEFINE l_arg2   VARCHAR(10)

MAIN

   LET l_arg1 = ARG_VAL(1)
   LET l_arg2 = ARG_VAL(2)
   IF l_arg2 IS NULL OR l_arg1 = l_arg2 THEN EXIT PROGRAM END IF 

   LET l_sql = " SELECT name,type FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg1 CLIPPED),".sys.all_objects ", 
                " WHERE type = 'U' OR type = 'SN' ORDER BY name"
   PREPARE p_zz011_pre FROM l_sql 
   DECLARE p_zz011_cur CURSOR FOR p_zz011_pre

   LET l_cnt = 1
   FOREACH p_zz011_cur INTO l_source[l_cnt].*
      LET l_cnt = l_cnt + 1  
   END FOREACH
   
   LET l_sql = " SELECT name,type FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg2 CLIPPED),".sys.all_objects ", 
                " WHERE type = 'U' OR type = 'SN' ORDER BY name"
   PREPARE p_zz012_pre FROM l_sql 
   DECLARE p_zz012_cur CURSOR FOR p_zz012_pre

   FOREACH p_zz012_cur INTO l_name,l_type
      FOR l_cnt = 1 TO l_source.getLength()
         IF l_source[l_cnt].name = l_name THEN
            IF l_source[l_cnt].type <> l_type THEN
               DISPLAY "Table:",l_name," Type Different:",l_type," Should be:",l_source[l_cnt].type
               CONTINUE FOREACH
            ELSE
               CONTINUE FOREACH
            END IF
         END IF
         IF l_cnt = l_source.getLength() THEN
            DISPLAY "Table:",l_name," Not Exists! Should be:",l_source[l_cnt].type
         END IF
      END FOR
   END FOREACH
   
END MAIN