
DATABASE ds

DEFINE l_source DYNAMIC ARRAY OF RECORD
         tabname   VARCHAR(40),
         colname   VARCHAR(40),
         default   VARCHAR(10),
         msvdef    VARCHAR(10),
         type      VARCHAR(1),
         objectid  VARCHAR(40)
                END RECORD
DEFINE l_tabname   VARCHAR(40)
DEFINE l_colname   VARCHAR(40)
DEFINE l_objectid  VARCHAR(40)
DEFINE l_default   VARCHAR(10)                
DEFINE l_temp   STRING
DEFINE l_cnt    INTEGER
DEFINE l_p      INTEGER
DEFINE l_sql    STRING
DEFINE l_arg1   VARCHAR(10)
DEFINE l_arg2   VARCHAR(10)

MAIN

   LET l_arg1 = ARG_VAL(1)

   CLOSE DATABASE
   DATABASE top30_ds

   LET l_sql = " SELECT lower(table_name),lower(column_name),data_default,'','','' FROM all_tab_columns ",
                " WHERE owner='",UPSHIFT(l_arg1 CLIPPED),"' AND data_default IS NOT NULL ORDER BY table_name,column_name"
   PREPARE p_zz011_pre FROM l_sql 
   DECLARE p_zz011_cur CURSOR FOR p_zz011_pre

   LET l_cnt = 1
   FOREACH p_zz011_cur INTO l_source[l_cnt].*
      LET l_temp = DOWNSHIFT(l_source[l_cnt].default) CLIPPED
      IF l_temp.getIndexOf("sysdate",1) THEN
         LET l_source[l_cnt].default = "getdate()"
      END IF
      LET l_cnt = l_cnt + 1  
   END FOREACH
   CALL l_source.deleteElement(l_cnt)
   
   CLOSE DATABASE
   DATABASE l_arg1

   LET l_sql = " SELECT a.name,c.name,convert(varchar,b.definition),b.name ",
                 " FROM sys.objects a, sys.default_constraints b, sys.columns c ", 
                " WHERE a.object_id = b.parent_object_id AND c.object_id = b.parent_object_id ",
                  " AND c.column_id = b.parent_column_id ",
                " ORDER BY a.name,b.name "
   PREPARE p_zz012_pre FROM l_sql 
   DECLARE p_zz012_cur CURSOR FOR p_zz012_pre

   FOREACH p_zz012_cur INTO l_tabname,l_colname,l_default,l_objectid
      FOR l_cnt = 1 TO l_source.getLength()
         IF l_source[l_cnt].tabname = l_tabname AND
            l_source[l_cnt].colname = l_colname THEN

            #FOUND and DO Something

            LET l_source[l_cnt].type = "Y"
            LET l_source[l_cnt].msvdef = l_default
            LET l_source[l_cnt].objectid = l_objectid
            CONTINUE FOREACH
         END IF
      END FOR
 
      #排除 rowid
      IF l_colname = "rowid" THEN
         CONTINUE FOREACH
      END IF
      DISPLAY "ALTER TABLE ",l_tabname CLIPPED," DROP CONSTRAINT [",l_objectid CLIPPED,"];"
   END FOREACH

   #補constrant
   FOR l_cnt = 1 TO l_source.getLength()
      IF l_source[l_cnt].type is null THEN
         DISPLAY "ALTER TABLE ",l_source[l_cnt].tabname CLIPPED,
                 " ADD CONSTRAINT [DF__",l_source[l_cnt].tabname CLIPPED,"__",l_source[l_cnt].colname CLIPPED,"__tiptopgp52]",
                 " DEFAULT (",l_source[l_cnt].default CLIPPED,") FOR ",l_source[l_cnt].colname CLIPPED,";"
      END IF
   END FOR
   
   #改constrant
   FOR l_cnt = 1 TO l_source.getLength()
      IF l_source[l_cnt].type = "Y" THEN
         LET l_default = "(",l_source[l_cnt].default CLIPPED,")"
         IF l_default = "(0)" THEN LET l_default = "((0))" END IF
         IF l_default = "(1)" THEN LET l_default = "((1))" END IF

         IF l_default CLIPPED <> l_source[l_cnt].msvdef CLIPPED THEN
            DISPLAY "ALTER TABLE ",l_source[l_cnt].tabname CLIPPED," DROP CONSTRAINT [",l_source[l_cnt].objectid CLIPPED,"];"
            DISPLAY "ALTER TABLE ",l_source[l_cnt].tabname CLIPPED,
                    " ADD CONSTRAINT [",l_source[l_cnt].objectid CLIPPED,"]",
                    " DEFAULT (",l_source[l_cnt].default CLIPPED,") FOR ",l_source[l_cnt].colname CLIPPED,";"
         END IF
      END IF
   END FOR
END MAIN
