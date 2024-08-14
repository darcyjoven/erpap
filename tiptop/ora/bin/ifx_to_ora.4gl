MAIN
DEFINE l_db    VARCHAR(20)
DEFINE l_table VARCHAR(20)
DEFINE l_file  VARCHAR(20)
#DEFINE l_value VARCHAR(10000)
DEFINE l_value STRING
DEFINE ch      base.Channel
DEFINE field_buf     base.StringBuffer
DEFINE row_buf       base.StringBuffer
DEFINE tok     base.StringTokenizer
DEFINE l_row   STRING
DEFINE l_str   STRING
DEFINE i,l_pos,l_count SMALLINT
#DEFINE g_sql   VARCHAR(200)
DEFINE g_sql   STRING

   LET l_db = ARG_VAL(1)
   LET l_table = ARG_VAL(2)
   LET l_file  = ARG_VAL(3)
   DISPLAY l_db ||""|| l_table
   DATABASE l_db
   LET ch = base.Channel.create()   
   LET field_buf = base.StringBuffer.create()
   LET row_buf   = base.StringBuffer.create()
   CALL ch.setdelimiter("")
   CALL ch.openfile(l_file,"r")
  WHILE  ch.read(l_row)
     LET tok = base.StringTokenizer.createExt(l_row,"","\\\\",TRUE)
     CALL field_buf.clear()
     CALL row_buf.clear()
    WHILE tok.hasMoreTokens()
     # LET l_ct = tok.countTokens()
      LET l_count=1

      IF ( l_count <  tok.countTokens()  ) THEN
         CALL field_buf.append(tok.nextToken())
         DISPLAY field_buf.tostring()
         LET l_count = l_count +1
         #FOR i =1 to 20
         #WHILE field_buf.equalsIgnoreCase('\\\\') = 1
           #LET l_pos = field_buf.getIndexOf("'",1)
    
           #CALL field_buf.replaceat(l_pos,l_pos,"\\'")
         #END WHILE
         #DISPLAY field_buf.tostring()
         #END FOR
         LET l_str = field_buf.tostring()
         IF ( row_buf.getLength() = 0) THEN
             CALL row_buf.append("'" || l_str || "'")
             #CALL row_buf.append('"' || l_str || '"')
         ELSE
             CALL row_buf.append("," || "'" || l_str || "'")
             #CALL row_buf.append("," || '"' || l_str || '"')
         END IF
      END IF
         CALL field_buf.clear()
    END WHILE
       DISPLAY row_buf.tostring() 
       LET l_value = row_buf.tostring()
       LET g_sql = "INSERT INTO " || l_table || " values (" || l_value || ")"
       #LET g_sql = 'INSERT INTO ' || l_table || ' values (' || l_value || ')'
       DISPLAY g_sql
       PREPARE pr_ins FROM  g_sql
       EXECUTE pr_ins 
  END WHILE



END MAIN



