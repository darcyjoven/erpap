
DATABASE ds

DEFINE l_dblist DYNAMIC ARRAY OF RECORD
         name   VARCHAR(20),
         type   VARCHAR(10)
                END RECORD
DEFINE l_collist DYNAMIC ARRAY OF RECORD
         name   VARCHAR(20),
         colid  VARCHAR(10)
                END RECORD
DEFINE l_name   VARCHAR(20)
DEFINE l_colid   VARCHAR(10)                
DEFINE li_cnt    INTEGER
DEFINE li_pos    INTEGER
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

   LET li_cnt = 1
   FOREACH p_zz011_cur INTO l_dblist[li_cnt].*
      LET li_cnt = li_cnt + 1  
   END FOREACH
   CALL l_dblist.deleteElement(li_cnt)
   
   LET l_sql = " SELECT a.name,a.column_id ",
                 " FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg1 CLIPPED),".sys.all_columns a,", 
                          FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg1 CLIPPED),".sys.all_objects b ", 
                " WHERE b.object_id = a.object_id AND b.name = ? ORDER BY a.column_id ASC"
   PREPARE col_src_pre FROM l_sql 
   DECLARE col_src_cur CURSOR FOR col_src_pre

   LET l_sql = " SELECT a.name,a.column_id ",
                 " FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg2 CLIPPED),".sys.all_columns a,", 
                          FGL_GETENV("MSSQLAREA") CLIPPED,"_",DOWNSHIFT(l_arg2 CLIPPED),".sys.all_objects b ", 
                " WHERE b.object_id = a.object_id AND b.name = ? ORDER BY a.column_id ASC"
   PREPARE col_tgt_pre FROM l_sql 
   DECLARE col_tgt_cur CURSOR FOR col_tgt_pre

   FOR li_pos = 1 TO l_dblist.getLength()

      LET li_cnt = 1
      CALL l_collist.clear()
      FOREACH col_src_cur USING l_dblist[li_pos].name INTO l_collist[li_cnt].*
         LET li_cnt = li_cnt + 1  
      END FOREACH
      CALL l_collist.deleteElement(li_cnt)

      FOREACH col_tgt_cur USING l_dblist[li_pos].name INTO l_name, l_colid
         FOR li_cnt = 1 TO l_collist.getLength()
            IF l_collist[li_cnt].name = l_name THEN
               IF l_collist[li_cnt].colid = l_colid THEN 
               ELSE
                  DISPLAY l_dblist[li_pos].name,".",l_name," Serial Not Match:",l_collist[li_cnt].colid," vs ",l_colid
               END IF
               CONTINUE FOREACH
            END IF
         END FOR
         DISPLAY l_dblist[li_pos].name,".",l_name," Column Not Exist"
      END FOREACH
   END FOR
   
END MAIN


