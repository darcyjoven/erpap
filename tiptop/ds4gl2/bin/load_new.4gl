MAIN
DEFINE l_db    CHAR(20)        #No:FUN-810032
DEFINE l_table STRING          #No:FUN-810032
DEFINE l_file  STRING          #No:FUN-810032
DEFINE l_fieldstr STRING       #No:FUN-810032
DEFINE l_value STRING
DEFINE ch      base.Channel
DEFINE field_buf     base.StringBuffer
DEFINE row_buf       base.StringBuffer
DEFINE tok     base.StringTokenizer
DEFINE l_row   STRING
DEFINE l_str   STRING
DEFINE l_count SMALLINT
DEFINE g_sql   STRING
DEFINE lc_log  base.Channel
DEFINE li_suc  INTEGER
DEFINE li_fail INTEGER

   WHENEVER ERROR CONTINUE

   LET l_db = ARG_VAL(1)
   LET l_table = ARG_VAL(2)
   LET l_file  = ARG_VAL(3)
   LET l_fieldstr = ARG_VAL(4)    #No:FUN-810032
   DISPLAY l_db CLIPPED , " " , l_table , " " , l_fieldstr
   DATABASE l_db
   IF SQLCA.sqlcode THEN
      DISPLAY 'Connect DB Error'
      RETURN
   END IF

   #Log
   LET lc_log = base.Channel.create()
   CALL lc_log.openFile(l_file||".log","a")
   CALL lc_log.write("INSERT INTO gae_file ERROR LOG!!!!")
   CALL lc_log.write("")
   CALL lc_log.write("")
   LET li_suc = 0
   LET li_fail = 0
   #---

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
      LET l_count=1

      IF ( l_count <  tok.countTokens()  ) THEN
         CALL field_buf.append(tok.nextToken())
#        DISPLAY field_buf.tostring()
         LET l_count = l_count +1
         LET l_str = field_buf.tostring()
         LET l_str = load_new_replace_str(l_str,"'","&$@")
         LET l_str = load_new_replace_str(l_str,"&$@","''")
         IF ( row_buf.getLength() = 0) THEN
             CALL row_buf.append("'" || l_str || "'")
         ELSE
             CALL row_buf.append("," || "'" || l_str || "'")
         END IF
      END IF
         CALL field_buf.clear()
    END WHILE
#      DISPLAY row_buf.tostring() 
       LET l_value = row_buf.tostring()
       IF l_fieldstr IS NULL THEN
          LET g_sql = "INSERT INTO " || l_table || " values (" || l_value || ")"
       ELSE
          LET g_sql = "INSERT INTO " || l_table || "(" || l_fieldstr || ") values (" || l_value || ")"
       END IF
#      DISPLAY g_sql

       PREPARE pr_ins FROM  g_sql
       #No:FUN-810032 --start--
       IF SQLCA.sqlcode THEN
          CALL lc_log.write(SQLCA.sqlcode)
          CALL lc_log.write(g_sql)
          CALL lc_log.write("")
          CALL lc_log.write("")
          LET li_fail = li_fail + 1
          CONTINUE WHILE
       END IF
       #No:FUN-810032 ---end---

       EXECUTE pr_ins 

       #log
       IF SQLCA.sqlcode THEN
          CALL lc_log.write(SQLCA.sqlcode)
          CALL lc_log.write(g_sql)
          CALL lc_log.write("")
          CALL lc_log.write("")
          LET li_fail = li_fail + 1
       ELSE
          LET li_suc = li_suc + 1
       END IF
#      IF (li_fail+li_suc) mod 1000 = 0 THEN
#         DISPLAY '.'
#      END IF
       #---
  END WHILE
  DISPLAY l_table,' Success...: ',li_suc                  #No:FUN-810032
  DISPLAY l_table,' Fail......: ',li_fail                 #No:FUN-810032
  CALL lc_log.write(l_table||" Success...: "||li_suc)     #No:FUN-810032
  CALL lc_log.write(l_table||" Fail......: "||li_fail)    #No:FUN-810032
  CALL lc_log.write("")
  CALL lc_log.write("")
  CALL lc_log.write("")
  CALL lc_log.write("")
  CALL lc_log.close()
  CALL ch.close()

END MAIN

FUNCTION load_new_replace_str(ps_source, ps_old, ps_new)
  DEFINE ps_source,ps_old,ps_new STRING
  DEFINE ls_source_left,ls_source_right,ls_result STRING
  DEFINE li_old_index  SMALLINT


  LET ps_source = ps_source.trimRight()
  LET li_old_index = ps_source.getIndexOf(ps_old, 1)

  IF (li_old_index >= 1) THEN
     IF li_old_index = 1 THEN
        LET ls_source_left = ""
     ELSE
        LET ls_source_left = ps_source.subString(1, li_old_index-1)
     END IF
     LET ls_source_right = ps_source.subString(li_old_index+ps_old.getLength(), ps_source.getLength())
     LET ls_result = ls_source_left,ps_new,ls_source_right

     LET ls_result = load_new_replace_str(ls_result, ps_old, ps_new) 
  ELSE
     LET ls_result = ps_source
  END IF

  RETURN ls_result
END FUNCTION
