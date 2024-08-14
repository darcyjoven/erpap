# 大版更zs資料打包工具 (呼叫此程式時, 環境已經切換) 2008 by saki
# A : ORACLE Chinese Big5
# B : ORACLE Chinese GB
# C : ORACLE Chinese Unicode         # G : Informix Chinese Big5
# D : ORACLE Ch & En Big5            # H : Informix Chinese GB
# E : ORACLE Ch & En GB              # I : Informix Ch & En Big5
# F : ORACLE Ch & En Unicode         # J : Informix Ch & En GB

# Parameter 1 : Old Version
# Parameter 2 : New Version
# Parameter 3 : Pack Folder Path
# Parameter 4 : Convert Tool

IMPORT os

DATABASE ds

DEFINE   g_old_ver   STRING
DEFINE   g_new_ver   STRING
DEFINE   g_db_type   STRING
DEFINE   g_convert   STRING
DEFINE   g_packpath  STRING
DEFINE   g_cmd       STRING
DEFINE   g_sql       STRING
DEFINE   g_center    STRING
DEFINE   g_cnt       LIKE type_file.num5

MAIN
   DEFINE   lr_zs        RECORD
               zs01      LIKE zs_file.zs01,
               zs04      LIKE zs_file.zs04,
               zs06      LIKE zs_file.zs06,
               zs12      LIKE zs_file.zs12
                         END RECORD
   DEFINE   lc_zta07     LIKE zta_file.zta07
   DEFINE   li_cnt       LIKE type_file.num5
   DEFINE   ls_cmd       STRING
   DEFINE   ls_file      STRING
   DEFINE   ls_table     STRING
   DEFINE   ls_module    STRING
   DEFINE   lc_channel   base.Channel     #ds的table alter
   DEFINE   lc_channel2  base.Channel     #其他資料庫的table alter
   DEFINE   lc_channel3  base.Channel     #ds的index alter
   DEFINE   lc_channel4  base.Channel     #其他資料庫的index alter
   DEFINE   lc_list      base.Channel
   DEFINE   lr_indexcmd  DYNAMIC ARRAY OF RECORD
               cmd       STRING,
               date      date,
               zta07     LIKE zta_file.zta07
                         END RECORD
   DEFINE   li_indexcnt  LIKE type_file.num5
   DEFINE   li_write     LIKE type_file.num5

   WHENEVER ERROR CONTINUE

   LET g_old_ver = ARG_VAL(1)
   LET g_new_ver = ARG_VAL(2)
   LET g_packpath = ARG_VAL(3)
   LET g_convert = ARG_VAL(4)
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"dbschema") THEN
      RETURN
   END IF
   LET g_packpath = g_packpath,os.Path.separator(),"dbschema",os.Path.separator()

   LET lc_channel = base.Channel.create()
   LET lc_channel2= base.Channel.create()
   LET lc_channel3= base.Channel.create()
   LET lc_channel4= base.Channel.create()
   CALL lc_channel.openFile(g_packpath||"table_alter_ds.txt","w")
   CALL lc_channel2.openFile(g_packpath||"table_alter_other.txt","w")
   CALL lc_channel3.openFile(g_packpath||"index_alter_ds.txt","w")
   CALL lc_channel4.openFile(g_packpath||"index_alter_other.txt","w")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel2.setDelimiter("")
   CALL lc_channel3.setDelimiter("")
   CALL lc_channel4.setDelimiter("")

   LET lc_list = base.Channel.create()
   CALL lc_list.openFile(g_packpath||"alter_schema_list.txt","w")
   CALL lc_list.setDelimiter("")

   LET g_sql = "SELECT zta07 FROM zta_file WHERE zta01=? AND zta02='ds1'"
   PREPARE zta07_pre FROM g_sql

   LET g_sql = "SELECT zs01,zs04,zs06,zs12 FROM zs_file ",
               " WHERE zs12 BETWEEN '",g_old_ver,"' AND '",g_new_ver,"0.00'",
               "   AND zs02 = 'ds' AND zs05 = 'p' ORDER BY zs01,zs03"
   PREPARE zs_pre FROM g_sql
   DECLARE zs_curs CURSOR FOR zs_pre

   LET li_indexcnt = 1
   FOREACH zs_curs INTO lr_zs.*
      IF lr_zs.zs06 = "load from systables" THEN
         CONTINUE FOREACH
      END IF
      CALL lc_list.write(lr_zs.zs12 CLIPPED||"     "||lr_zs.zs06 CLIPPED)
      #其他資料庫create方式
      EXECUTE zta07_pre USING lr_zs.zs01 INTO lc_zta07

      LET ls_cmd = lr_zs.zs06 CLIPPED
      CASE
         WHEN ls_cmd.getIndexOf("create table ",1)
            CALL lc_channel.write(ls_cmd)
            #複製.sch檔
            LET ls_file = ls_cmd.subString(ls_cmd.getIndexOf("{",1)+1,ls_cmd.getIndexOf("}",1)-1)
            LET ls_module = ls_file.subString(ls_file.getIndexOf("$",1)+1,ls_file.getIndexOf("/",1)-1)
            LET ls_module = FGL_GETENV(ls_module)
            LET li_cnt = 0
            WHILE ls_file.getIndexOf("/",li_cnt+1)
               LET li_cnt = ls_file.getIndexOf("/",li_cnt+1)
            END WHILE
            LET ls_file = ls_file.subString(li_cnt+1,ls_file.getLength())
            IF os.Path.exists(ls_module||os.Path.separator()||"sch"||os.Path.separator()||ls_file) THEN
               IF g_convert IS NOT NULL THEN
                  LET g_cmd = "cat ",ls_module,os.Path.separator(),"sch",os.Path.separator(),ls_file,"|",g_convert," > ",g_packpath,ls_file
                  RUN g_cmd
               ELSE
                  IF os.Path.copy(ls_module||os.Path.separator()||"sch"||os.Path.separator()||ls_file,
                                  g_packpath||ls_file) THEN END IF
               END IF
            ELSE
               LET ls_file = ls_file.subString(1,ls_file.getIndexOf(".src",1)-1)
               IF g_convert IS NOT NULL THEN
                  LET g_cmd = "cat ",ls_module,os.Path.separator(),"sch",os.Path.separator(),ls_file,"|",g_convert," > ",g_packpath,ls_file
                  RUN g_cmd
               ELSE
                  IF os.Path.copy(ls_module||os.Path.separator()||"sch"||os.Path.separator()||ls_file,
                                  g_packpath||ls_file) THEN END IF
               END IF
            END IF
            IF lc_zta07 = "S" THEN
               LET ls_table = ls_cmd.subString(14,ls_cmd.getIndexOf("{",1)-1)
               CALL lc_channel2.write("create synonym "||ls_table.trim()||" for ds."||ls_table.trim()||";")
            ELSE
               CALL lc_channel2.write(ls_cmd)
            END IF
         WHEN ls_cmd.getIndexOf("alter table ",1)
            CASE
               WHEN ls_cmd.getIndexOf(" add constraint ",1)
                  LET li_write = FALSE
                  FOR li_cnt = 1 TO lr_indexcmd.getLength()
                      IF (lr_indexcmd[li_cnt].cmd.subString(1,lr_indexcmd[li_cnt].cmd.getIndexOf(" primary key ",1)-1) = 
                         ls_cmd.subString(1,ls_cmd.getIndexOf(" primary key ",1)-1)) AND
                         lr_zs.zs04 > lr_indexcmd[li_cnt].date THEN
                         LET lr_indexcmd[li_cnt].cmd = ls_cmd
                         LET lr_indexcmd[li_cnt].date = lr_zs.zs04
                         LET li_write = TRUE
                         EXIT FOR
                      END IF
                  END FOR
                  IF NOT li_write THEN
                     LET lr_indexcmd[li_indexcnt].cmd = ls_cmd
                     LET lr_indexcmd[li_indexcnt].date = lr_zs.zs04
                     LET lr_indexcmd[li_indexcnt].zta07 = lc_zta07
                     LET li_indexcnt = li_indexcnt + 1
                  END IF
               WHEN ls_cmd.getIndexOf(" drop constraint ",1)
                  LET li_write = FALSE
                  FOR li_cnt = 1 TO lr_indexcmd.getLength()
                      IF (lr_indexcmd[li_cnt].cmd = ls_cmd) AND
                         lr_zs.zs04 > lr_indexcmd[li_cnt].date THEN
                         LET lr_indexcmd[li_cnt].cmd = ls_cmd
                         LET lr_indexcmd[li_cnt].date = lr_zs.zs04
                         LET li_write = TRUE
                         EXIT FOR
                      END IF
                  END FOR
                  IF NOT li_write THEN
                     LET lr_indexcmd[li_indexcnt].cmd = ls_cmd
                     LET lr_indexcmd[li_indexcnt].date = lr_zs.zs04
                     LET lr_indexcmd[li_indexcnt].zta07 = lc_zta07
                     LET li_indexcnt = li_indexcnt + 1
                  END IF
               OTHERWISE
                  CALL lc_channel.write(ls_cmd)
                  IF lc_zta07 = "T" THEN
                     CALL lc_channel2.write(ls_cmd)
                  END IF
            END CASE
         WHEN ls_cmd.getIndexOf("create index ",1)
            LET li_write = FALSE
            FOR li_cnt = 1 TO lr_indexcmd.getLength()
                IF (lr_indexcmd[li_cnt].cmd.subString(1,lr_indexcmd[li_cnt].cmd.getIndexOf(" (",1)-1) = 
                   ls_cmd.subString(1,ls_cmd.getIndexOf(" (",1)-1)) AND
                   lr_zs.zs04 > lr_indexcmd[li_cnt].date THEN
                   LET lr_indexcmd[li_cnt].cmd = ls_cmd
                   LET lr_indexcmd[li_cnt].date = lr_zs.zs04
                   LET li_write = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_write THEN
               LET lr_indexcmd[li_indexcnt].cmd = ls_cmd
               LET lr_indexcmd[li_indexcnt].date = lr_zs.zs04
               LET lr_indexcmd[li_indexcnt].zta07 = lc_zta07
               LET li_indexcnt = li_indexcnt + 1
            END IF
         WHEN ls_cmd.getIndexOf("drop index ",1)
            LET li_write = FALSE
            FOR li_cnt = 1 TO lr_indexcmd.getLength()
                IF (lr_indexcmd[li_cnt].cmd = ls_cmd) AND
                   lr_zs.zs04 > lr_indexcmd[li_cnt].date THEN
                   LET lr_indexcmd[li_cnt].cmd = ls_cmd
                   LET lr_indexcmd[li_cnt].date = lr_zs.zs04
                   LET li_write = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_write THEN
               LET lr_indexcmd[li_indexcnt].cmd = ls_cmd
               LET lr_indexcmd[li_indexcnt].date = lr_zs.zs04
               LET lr_indexcmd[li_indexcnt].zta07 = lc_zta07
               LET li_indexcnt = li_indexcnt + 1
            END IF
         WHEN ls_cmd.getIndexOf("create unique index ",1)
            LET li_write = FALSE
            FOR li_cnt = 1 TO lr_indexcmd.getLength()
                IF (lr_indexcmd[li_cnt].cmd.subString(1,lr_indexcmd[li_cnt].cmd.getIndexOf(" (",1)-1) = 
                   ls_cmd.subString(1,ls_cmd.getIndexOf(" (",1)-1)) AND
                   lr_zs.zs04 > lr_indexcmd[li_cnt].date THEN
                   LET lr_indexcmd[li_cnt].cmd = ls_cmd
                   LET lr_indexcmd[li_cnt].date = lr_zs.zs04
                   LET li_write = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_write THEN
               LET lr_indexcmd[li_indexcnt].cmd = ls_cmd
               LET lr_indexcmd[li_indexcnt].date = lr_zs.zs04
               LET lr_indexcmd[li_indexcnt].zta07 = lc_zta07
               LET li_indexcnt = li_indexcnt + 1
            END IF
      END CASE
   END FOREACH

   CALL lc_channel.close()
   CALL lc_channel2.close()

   FOR li_cnt = 1 TO lr_indexcmd.getLength()
       CALL lc_channel3.write(lr_indexcmd[li_cnt].cmd)
       IF lr_indexcmd[li_cnt].zta07 = "T" THEN
          CALL lc_channel4.write(lr_indexcmd[li_cnt].cmd)
       END IF
   END FOR
   CALL lc_channel3.close()
   CALL lc_channel4.close()
   CALL lc_list.close()
END MAIN
