
DATABASE ds

DEFINE l_source DYNAMIC ARRAY OF RECORD
         tabname   VARCHAR(40),
         idxname   VARCHAR(40),
         colpos    SMALLINT,   
         colname   VARCHAR(40)
                END RECORD
DEFINE l_target DYNAMIC ARRAY OF RECORD
         tabname   VARCHAR(40),
         idxname   VARCHAR(40),
         colpos    SMALLINT,   
         colname   VARCHAR(40)
                END RECORD
DEFINE l_comp DYNAMIC ARRAY OF RECORD
         tabname   VARCHAR(40),
         idxname   VARCHAR(40),
         ora       STRING,
         orapk     VARCHAR(1),
         msv       STRING, 
         msvpk     VARCHAR(1)
                END RECORD
DEFINE l_tabname   VARCHAR(40)
DEFINE l_colname   VARCHAR(40)
DEFINE l_objectid  VARCHAR(40)
DEFINE l_default   VARCHAR(10)                
DEFINE l_temp   STRING
DEFINE l_cnt    INTEGER
DEFINE l_cnt2   INTEGER
DEFINE l_chk    INTEGER
DEFINE l_sql    STRING
DEFINE l_arg1   VARCHAR(10)
DEFINE l_unique   VARCHAR(10)

MAIN
   LET l_arg1 = ARG_VAL(1)

   CLOSE DATABASE
   DATABASE top30_ds

   LET l_sql = " SELECT lower(table_name),lower(index_name),column_position,lower(column_name) ",
                 " FROM sys.all_ind_columns ",
                " WHERE table_owner='",UPSHIFT(l_arg1 CLIPPED),"' ORDER BY table_name,index_name,column_position "
   PREPARE p_zz011_pre FROM l_sql 
   DECLARE p_zz011_cur CURSOR FOR p_zz011_pre

   LET l_cnt = 1
   FOREACH p_zz011_cur INTO l_source[l_cnt].*
#     if l_source[l_cnt].tabname='nmv_file' then
#     display l_source[l_cnt].colpos,'tab:',l_source[l_cnt].tabname,' idx:',l_source[l_cnt].idxname,' col:',l_source[l_cnt].colname
#     end if
      LET l_cnt = l_cnt + 1  
   END FOREACH
   CALL l_source.deleteElement(l_cnt)
   
   #組合
   LET l_cnt = 0
   WHILE TRUE
      LET l_cnt = l_cnt + 1
      IF l_cnt > l_source.getLength() THEN EXIT WHILE END IF
      IF l_cnt = 1 THEN
         LET l_comp[1].tabname = l_source[1].tabname 
         LET l_comp[1].idxname = l_source[1].idxname 
         LET l_comp[1].ora = l_source[1].colname 
         CONTINUE WHILE
      END IF
      FOR l_cnt2 = 1 TO l_comp.getLength()
         IF l_comp[l_cnt2].tabname = l_source[l_cnt].tabname AND 
            l_comp[l_cnt2].idxname = l_source[l_cnt].idxname THEN
            LET l_comp[l_cnt2].ora = l_comp[l_cnt2].ora,",",l_source[l_cnt].colname
            CONTINUE WHILE
         END IF
      END FOR
      LET l_comp[l_comp.getLength() + 1].tabname = l_source[l_cnt].tabname 
      LET l_comp[l_comp.getLength()].idxname = l_source[l_cnt].idxname 
      LET l_comp[l_comp.getLength()].ora = l_source[l_cnt].colname 
   END WHILE

   LET l_sql = " SELECT count(*) FROM user_constraints ",
                " WHERE lower(owner) = ? AND constraint_type = 'P' AND lower(table_name) = ? AND lower(constraint_name) = ? "
   PREPARE p_ora_pk FROM l_sql 

   LET l_sql = " SELECT SUBSTR(UNIQUENESS,1,10) FROM user_indexes ",
                " WHERE lower(table_name) = ? AND lower(index_name) = ? "
   PREPARE p_ora_unique FROM l_sql 

   FOR l_cnt = 1 TO l_comp.getLength()
      EXECUTE p_ora_pk USING l_arg1,l_comp[l_cnt].tabname,l_comp[l_cnt].idxname INTO l_chk
      IF l_chk THEN
         LET l_comp[l_cnt].orapk = "Y"
      ELSE
         EXECUTE p_ora_unique USING l_comp[l_cnt].tabname,l_comp[l_cnt].idxname INTO l_unique
         IF l_unique = "UNIQUE" THEN
            LET l_comp[l_cnt].orapk = "U"
         END IF
      END IF
   END FOR
   
   FREE p_ora_pk

   CLOSE DATABASE
   DATABASE l_arg1

   LET l_sql = " SELECT a.name,d.name,key_ordinal,c.name ",
                 " FROM sys.objects a, sys.index_columns b, sys.columns c, sys.indexes d ", 
                " WHERE a.object_id = b.object_id AND a.object_id = c.object_id and b.column_id = c.column_id ",
                  " AND d.object_id = a.object_id and d.index_id = b.index_id ",
                " ORDER BY a.name,d.name,key_ordinal "
   PREPARE p_zz012_pre FROM l_sql 
   DECLARE p_zz012_cur CURSOR FOR p_zz012_pre

   LET l_cnt = 1
   FOREACH p_zz012_cur INTO l_target[l_cnt].*
#     if l_target[l_cnt].tabname='nmv_file' then
#     display l_target[l_cnt].colpos,'tab:',l_target[l_cnt].tabname,' idx:',l_target[l_cnt].idxname,' col:',l_target[l_cnt].colname
#     end if
      LET l_cnt = l_cnt + 1  
   END FOREACH
   CALL l_target.deleteElement(l_cnt)

   #組合msv idx
   LET l_cnt = 0
   WHILE TRUE
      LET l_cnt = l_cnt + 1
      IF l_cnt > l_target.getLength() THEN EXIT WHILE END IF
      FOR l_cnt2 = 1 TO l_comp.getLength()
         IF l_comp[l_cnt2].tabname = l_target[l_cnt].tabname AND 
            l_comp[l_cnt2].idxname = l_target[l_cnt].idxname THEN

            LET l_comp[l_cnt2].msv = l_comp[l_cnt2].msv,",",l_target[l_cnt].colname

            CONTINUE WHILE
         END IF
      END FOR
      LET l_comp[l_comp.getLength() + 1].tabname = l_target[l_cnt].tabname 
      LET l_comp[l_comp.getLength()].idxname = l_target[l_cnt].idxname 
      LET l_comp[l_comp.getLength()].msv = l_target[l_cnt].colname 
      LET l_comp[l_comp.getLength()].orapk = "X" 
   END WHILE

   LET l_sql = " SELECT count(*) FROM sys.objects WHERE type = 'PK' AND name = ? "
   PREPARE p_msv_pk FROM l_sql 

   LET l_sql = " SELECT d.is_unique FROM sys.objects a, sys.indexes d WHERE a.type = 'PK' AND a.name = ? AND a.object_id = d.object_id "
   PREPARE p_msv_unique FROM l_sql 

   FOR l_cnt = 1 TO l_comp.getLength()
      IF l_comp[l_cnt].msv IS NOT NULL THEN
         EXECUTE p_msv_pk USING l_comp[l_cnt].idxname INTO l_chk
         IF l_chk THEN
            LET l_comp[l_cnt].msvpk = "Y"
         ELSE
            EXECUTE p_msv_unique USING l_comp[l_cnt].idxname INTO l_cnt2
            IF l_cnt2 = "1" THEN
               LET l_comp[l_cnt].msvpk = "U"
            END IF
         END IF
         LET l_temp = l_comp[l_cnt].msv
         IF l_temp.substring(1,1) = "," THEN
            LET l_temp = l_temp.substring(2, l_temp.getLength())
            LET l_comp[l_cnt].msv = l_temp
         END IF
      ELSE
         LET l_comp[l_cnt].msvpk = "X"
      END IF
   END FOR

   #匯整報告
   FOR l_cnt = 1 TO l_comp.getLength()

      #若MSV沒idx
      IF l_comp[l_cnt].msvpk = "X" THEN
         #判段ORA標記orapk是什麼
         CASE l_comp[l_cnt].orapk
            WHEN "Y"   #建constraint
               DISPLAY "ALTER TABLE ",l_comp[l_cnt].tabname CLIPPED," ADD CONSTRAINT ",l_comp[l_cnt].idxname CLIPPED," PRIMARY KEY(",l_comp[l_cnt].ora CLIPPED,");"
            WHEN "U"   #建unique index
               DISPLAY "CREATE UNIQUE INDEX ",l_comp[l_cnt].idxname CLIPPED," ON ",l_comp[l_cnt].tabname CLIPPED,"(",l_comp[l_cnt].ora CLIPPED,");"
            WHEN "X"   #不作
            OTHERWISE
               DISPLAY "CREATE INDEX ",l_comp[l_cnt].idxname CLIPPED," ON ",l_comp[l_cnt].tabname CLIPPED,"(",l_comp[l_cnt].ora CLIPPED,");"
         END CASE
         CONTINUE FOR
      END IF 

      #MSV有
      IF l_comp[l_cnt].msvpk = "X" OR l_comp[l_cnt].ora <> l_comp[l_cnt].msv THEN
         #判斷MSV標記msvpk是什麼 
         IF l_comp[l_cnt].msvpk = "Y" THEN    #msv為pk 則須 alter table drop constrant
            DISPLAY "ALTER TABLE ",l_comp[l_cnt].tabname CLIPPED," DROP CONSTRAINT ",l_comp[l_cnt].idxname CLIPPED,";"
         ELSE
            IF l_comp[l_cnt].msvpk <> "X" THEN  #未標且msv內有值的當 idx 來砍
               DISPLAY "DROP INDEX ",l_comp[l_cnt].tabname CLIPPED,".",l_comp[l_cnt].idxname CLIPPED,";"
            END IF
         END IF

         #判段ORA標記orapk是什麼
         CASE l_comp[l_cnt].orapk
            WHEN "Y"   #建constraint
               DISPLAY "ALTER TABLE ",l_comp[l_cnt].tabname CLIPPED," ADD CONSTRAINT ",l_comp[l_cnt].idxname CLIPPED," PRIMARY KEY(",l_comp[l_cnt].ora CLIPPED,");"
            WHEN "U"   #建unique index
               DISPLAY "CREATE UNIQUE INDEX ",l_comp[l_cnt].idxname CLIPPED," ON ",l_comp[l_cnt].tabname CLIPPED,"(",l_comp[l_cnt].ora CLIPPED,");"
            WHEN "X"   #不作
            OTHERWISE
               DISPLAY "CREATE INDEX ",l_comp[l_cnt].idxname CLIPPED," ON ",l_comp[l_cnt].tabname CLIPPED,"(",l_comp[l_cnt].ora CLIPPED,");"
         END CASE
      END IF
   END FOR

END MAIN

