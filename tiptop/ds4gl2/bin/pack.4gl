##################################################
# Description  	: Patch 打包
# Date & Author : 2004/09/01 by saki
# Parameter   	: 
# Return   	: 
# Memo        	: 打包patch程式 patch.sh, patch_load_data.42m, 
# Modify   	: 2004/12/03 by saki 修改可打包單一BUG單號patch
# Modify        : 2005/12/12 by saki zl增加key值zl09
# Modify        : 2006/04/14 by saki 增加zad_file、zae_file，1X2X不可與3X互co
# Modify        : 2006/08/02 by saki 增加一個外部參數接收版號
# Modify        : 2006/09/22 by saki 增加資料同步aws_spccfg資料
# Modify        : 2007/03/16 by saki TQC-730063 預防切錯資料庫
# Modify        : No:FUN-730071 07/03/30 By alexstar 需新增zaw的資料同步選項，key值為zaw01
# Modify        : No:TQC-740038 07/04/09 By saki 資料同步增加zav_file
# Modify        : No:FUN-740054 07/04/13 By saki 資料同步增加p_query的項目跟aws項目
# Modify        : No:CHI-750028 07/05/29 By saki 包per時，連帶4fd及sdd
# Modify        : No:FUN-7A0026 07/10/19 By joyce 修改zln04欄寬，改char(4)為char(5)，並新增bn5及bn6兩個for MSV區的工具類路徑
# Modify        :               08/05/13 By saki 可包多單號, 版本控制都拿掉
##################################################
DATABASE ds

DEFINE   g_d01        DATE,
         g_d02        DATE,
         g_bugno      VARCHAR(10),
         g_vername    VARCHAR(07)
DEFINE   p_str1       STRING
DEFINE   g_bug_flag   SMALLINT
DEFINE   g_packall    VARCHAR(1)
DEFINE   gc_channel   base.Channel
DEFINE   g_db_type    VARCHAR(3)
DEFINE   g_prog_path  STRING
DEFINE   g_temp_path  STRING
DEFINE   g_convert    VARCHAR(1)
DEFINE   g_ver_main   VARCHAR(5)
DEFINE   g_zae_where  STRING           #2006/04/14
DEFINE   g_zae01      DYNAMIC ARRAY OF VARCHAR(10)  #2006/04/14
DEFINE   g_zae_cnt    SMALLINT         #2006/04/14
DEFINE   g_conv_tool  STRING
DEFINE   g_bugwhere   STRING           #2008/05/13

MAIN
   DEFINE   l_str          STRING
   DEFINE   l_ds4gl_path   STRING
   DEFINE   li_result      SMALLINT
   DEFINE   ls_ver         STRING
   DEFINE   lch_cmd        base.Channel
   DEFINE   os_type        STRING
   #2008/05/13 --start--
   DEFINE   lst_bugno      base.stringTokenizer
   DEFINE   ls_result      STRING
   #2008/05/13 ---end---


   WHENEVER ERROR CONTINUE
   LET p_str1 = ""
   LET g_bug_flag = ""
   LET g_prog_path = ARG_VAL(1)
   LET p_str1 = ARG_VAL(2)
   LET g_vername = ARG_VAL(3)
   LET g_packall = ARG_VAL(4)
   LET g_convert = ARG_VAL(5)
   LET l_ds4gl_path = FGL_GETENV('DS4GL')
   LET g_temp_path = FGL_GETENV("TEMPDIR")
   LET g_db_type = DB_GET_DATABASE_TYPE()
   IF g_db_type = "ORA" THEN
      RUN 'patchtemp.sh'
   ELSE
      RUN "echo 'drop database patchtemp'|dbaccess"
      LET l_str="cd ",l_ds4gl_path,"/bin/;dbimport patchtemp -l -d dbs1"
      RUN l_str
   END IF

   IF (p_str1 IS NOT NULL) THEN
      IF g_vername IS NULL THEN
         RETURN
      END IF

      #2008/05/13 --start--
      IF p_str1.getIndexOf(",",1) THEN
         LET g_bug_flag = FALSE
         LET lst_bugno = base.stringTokenizer.create(p_str1,",")
         WHILE lst_bugno.hasMoreTokens()
            LET ls_result = lst_bugno.nextToken()
            IF g_bugwhere IS NULL THEN
               LET g_bugwhere = "zl08='",ls_result.trim(),"'"
            ELSE
               LET g_bugwhere = g_bugwhere," OR zl08='",ls_result.trim(),"'"
            END IF
         END WHILE
      ELSE
      #2008/05/13 ---end---
         LET g_bug_flag = TRUE
         LET g_bugno = p_str1
         LET g_ver_main = g_vername[1,3]
      END IF   #2008/05/13
   ELSE
      LET g_bug_flag = FALSE

      CLOSE WINDOW screen
      LET l_str = l_ds4gl_path,"/bin/pack"
      OPEN WINDOW pack_w AT 1,1 WITH FORM l_str

      LET g_packall = "N"
      LET g_d01 = ""
      LET g_d02 = TODAY

      # 2005/11/01 show所有還在測試中的單子，選擇continue或cancel
      CALL pack_show_testing_bugno() RETURNING li_result
      IF (NOT li_result) THEN
         RETURN
      END IF
      # 2005/11/01 ---end---

      DISPLAY g_packall,g_d01,g_d02 TO packall,d01,d02
      INPUT g_prog_path,ls_ver,g_d01,g_d02,g_packall WITHOUT DEFAULTS FROM path,ver,d01,d02,packall
         ON CHANGE packall
            IF g_packall = "Y" THEN
               IF g_db_type = "ORA" THEN
                  LET g_prog_path = "/u1/topfinalo"
               ELSE
                  LET g_prog_path = "/u1/topfinali"
               END IF
            ELSE
               LET g_prog_path = ""
            END IF
            DISPLAY g_prog_path TO path

         ON ACTION accept
            CALL GET_FLDBUF(path) RETURNING g_prog_path
            CALL GET_FLDBUF(d01) RETURNING g_d01
            CALL GET_FLDBUF(d02) RETURNING g_d02
            CALL GET_FLDBUF(packall) RETURNING g_packall
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         CLOSE WINDOW pack_w
         EXIT PROGRAM
      END IF

      #如果版本別輸入*的話，就用LIKE方式
      IF ls_ver.getIndexOf("*",1) THEN
         LET g_vername = ""
         LET g_ver_main = ls_ver.subString(1,ls_ver.getIndexOf("*",1)-1)
      ELSE
         LET g_vername = ls_ver
         LET g_ver_main = ls_ver.subString(1,3)
      END IF

      CLOSE WINDOW pack_w
   END IF

   IF g_prog_path IS NULL THEN
      DISPLAY '請輸入打包的程式路徑 ex. /u1/tiptopo'
      RETURN
   END IF

   LET g_packall = UPSHIFT(g_packall)
   IF g_packall IS NULL THEN
      LET g_packall = "N"
   END IF

   LET g_convert = UPSHIFT(g_convert)
   IF g_convert IS NULL THEN
      LET g_convert = "N"
   ELSE
      LET g_conv_tool = NULL
      LET lch_cmd = base.Channel.create()
      CALL lch_cmd.openPipe("uname -s", "r")
      WHILE lch_cmd.read(os_type)
      END WHILE
      CALL lch_cmd.close()
      LET os_type = os_type.toUpperCase()
      CASE
          WHEN os_type MATCHES "AIX*"
               LET g_conv_tool="big5_to_gb2312.ibm"
          WHEN os_type MATCHES "LINUX*"
               LET g_conv_tool="big5_to_gb2312.lux"
          WHEN os_type MATCHES "HP-UX*"
               LET g_conv_tool="big5_to_gb2312.hp"
          WHEN os_type MATCHES "SUNOS*"
               LET g_conv_tool="big5_to_gb2312.sun"
      END CASE
   END IF

   DISPLAY "開始打包"
   CALL p_zl_pack()
END MAIN

FUNCTION p_zl_pack()
   DEFINE   l_sql          STRING
   DEFINE   l_file         STRING
   DEFINE   l_top          STRING,
            l_final_top    STRING,
            l_tempdir      STRING,
            l_ds4gl_path   STRING,
            l_dbpath       STRING
   DEFINE   l_cmd          STRING
   DEFINE   l_date         VARCHAR(8)
   DEFINE   l_cnt          INTEGER
   DEFINE   li_i           SMALLINT
   DEFINE   li_j           INTEGER
   DEFINE   li_k           INTEGER
   DEFINE   l_str          STRING
   DEFINE   l_result       STRING
   DEFINE   l_zl           DYNAMIC ARRAY OF RECORD
               zl05        VARCHAR(10),
               zl06        VARCHAR(1000),
               zl08        VARCHAR(10),
               zl09        VARCHAR(7),
               zl15        VARCHAR(1000)
                           END RECORD
   DEFINE   l_zln          DYNAMIC ARRAY OF RECORD
               zln03       VARCHAR(3),
               zln04       VARCHAR(5),        # No:FUN-7A0026
               zln05       VARCHAR(100)
                           END RECORD
   DEFINE   l_config       STRING
   DEFINE   l_lang         DYNAMIC ARRAY OF RECORD
               gay01       LIKE gay_file.gay01
                           END RECORD
   DEFINE   l_path         STRING
   DEFINE   l_patch_path   STRING
   DEFINE   l_patch_dir    STRING
   DEFINE   li_inx         INTEGER
   DEFINE   li_result      SMALLINT
   DEFINE   ls_path_str    STRING


   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET l_top = FGL_GETENV('TOP')
   LET g_db_type = DB_GET_DATABASE_TYPE()
   LET l_final_top = g_prog_path
   LET l_ds4gl_path = FGL_GETENV('DS4GL')
   LET l_dbpath = FGL_GETENV('FGLDBPATH')
   LET l_date = TODAY USING "yymmdd"

   # 預先刪除patchtemp資料庫內的資料
   CALL pack_delete_patchdb_data()

   DATABASE ds
   IF (NOT g_bug_flag) THEN
      IF g_bugwhere IS NULL THEN   #2008/05/13
         IF g_db_type = "ORA" THEN
            LET l_sql = "SELECT zl05,zl06,zl08,zl09,zl15 FROM zl_file",
                        " WHERE zl301 BETWEEN '",g_d01,"' AND '",g_d02,"'"
            IF g_vername IS NOT NULL THEN
               LET l_sql = l_sql,"   AND zl02 = '8' AND zl09 = '",g_vername,"'"
            ELSE
               LET l_sql = l_sql,"   AND zl02 = '8' AND zl09 LIKE '",g_ver_main,"%'"
            END IF
         ELSE
            LET l_sql = "SELECT zl05,zl06,zl08,zl09,zl15 FROM zl_file",
                        " WHERE zl301 BETWEEN '",g_d01,"' AND '",g_d02,"'"
            IF g_vername IS NOT NULL THEN
               LET l_sql = l_sql,"   AND zl02 = '8' AND zl09 = '",g_vername,"'"
            ELSE
               LET l_sql = l_sql,"   AND zl02 = '8' AND zl09 MATCHES '",g_ver_main,"*'"
            END IF
         END IF
      #2008/05/13 --start--
      ELSE
         LET l_sql = "SELECT zl05,zl06,zl08,zl09,zl15 FROM zl_file",
                     " WHERE zl09 = '",g_vername,"'",
                     "   AND (",g_bugwhere,")"
      END IF
      #2008/05/13 ---end---
   ELSE
      LET l_sql = "SELECT zl05,zl06,zl08,zl09,zl15 FROM zl_file",
                  " WHERE zl08 = '",g_bugno CLIPPED,"' AND zl02 = '8'",
                  "   AND zl09 = '",g_vername,"'"
   END IF
   DISPLAY "搜尋資料 : ",l_sql
   PREPARE zl08_pre FROM l_sql
   DECLARE zl08_curs CURSOR  FOR zl08_pre

   LET l_cnt = 1
   FOREACH zl08_curs INTO l_zl[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_zl.deleteElement(l_cnt)

   IF l_zl.getLength() <= 0 THEN
      DISPLAY 'no patch produce...'
      RETURN
   END IF

   # 建立temp資料夾在$TEMPDIR下
   IF (NOT g_bug_flag) THEN
      LET l_cmd = "rm -rf ",g_temp_path CLIPPED,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd RETURNING l_result
      IF l_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET l_cmd = "mkdir ",g_temp_path CLIPPED,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd
      LET l_patch_path = g_temp_path CLIPPED,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED
      LET l_patch_dir = "patch_",l_date CLIPPED,"_",g_vername CLIPPED
   ELSE
      LET l_cmd = "rm -rf ",g_temp_path CLIPPED,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd RETURNING l_result
      IF l_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET l_cmd = "mkdir ",g_temp_path CLIPPED,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd
      LET l_patch_path = g_temp_path CLIPPED,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED
      LET l_patch_dir = "patch_",g_bugno CLIPPED,"_",g_vername CLIPPED
   END IF

   # 打包清單 info.txt開頭，若是要打包整份系統則不做此檔案
   IF g_packall = "N" THEN
      LET gc_channel = base.Channel.create()
      LET l_cmd = l_patch_path,"/info.txt"
      CALL gc_channel.openFile(l_cmd,"w")
      CALL gc_channel.setDelimiter("")
      IF (NOT g_bug_flag) THEN
         LET l_str = "Patch of Complete Date:",g_d01,"~",g_d02
      ELSE
         LET l_str = "~~~~Only One Bug List~~~~"
      END IF
      CALL gc_channel.write(l_str)
      LET l_str = ""
      CALL gc_channel.write(l_str)
      LET l_str = ""
      CALL gc_channel.write(l_str)
   END IF

   # Source 檔案路徑
   IF (NOT g_bug_flag) AND g_packall != "N" THEN
      CALL p_zl_pack_alldata()
   END IF

   DATABASE ds
   CALL l_lang.clear()
   LET l_cnt = 1
   DECLARE gay_curs CURSOR FOR
           SELECT UNIQUE gay01 FROM gay_file
   FOREACH gay_curs INTO l_lang[l_cnt].gay01
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_lang.deleteElement(l_cnt)
   IF (l_lang.getLength() <= 0) THEN
      RETURN
   END IF

   LET l_config = "config"
   IF g_packall = "N" THEN
      LET l_cmd = "rm -rf ",l_patch_path,"/tiptop"
      RUN l_cmd
      LET l_cmd = "mkdir ",l_patch_path,"/tiptop"
      RUN l_cmd
   END IF

   DISPLAY "開始打包程式及資料"
   FOR li_i = 1 TO l_zl.getLength()
      # 若打包全系統則不做info.txt
      IF g_packall = "N" THEN
         LET l_str = l_zl[li_i].zl08 CLIPPED,"   Program Name:",l_zl[li_i].zl05 CLIPPED
         CALL gc_channel.write(l_str)
         LET l_str = "Bug Content :"
         CALL gc_channel.write(l_str)
         LET l_str = l_zl[li_i].zl15
         CALL gc_channel.write(l_str)
         LET l_str = "Update Content :"
         CALL gc_channel.write(l_str)
         LET l_str = l_zl[li_i].zl06
         CALL gc_channel.write(l_str)
         LET l_str = ""
         CALL gc_channel.write(l_str)
         LET l_str = ""
         CALL gc_channel.write(l_str)

      # 若打包全系統則不用管程式清單
         DATABASE ds
         LET l_sql = "SELECT zln03,zln04,zln05 FROM zln_file",
                     " WHERE zln00 = '",l_zl[li_i].zl09 CLIPPED,"'",
                     "   AND zln01 = '",l_zl[li_i].zl08 CLIPPED,"'"
         PREPARE zln_pre FROM l_sql
         DECLARE zln_curs CURSOR FOR zln_pre

         CALL l_zln.clear()
         LET l_cnt = 1
         FOREACH zln_curs INTO l_zln[l_cnt].*
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_zln.deleteElement(l_cnt)

         FOR li_j = 1 TO l_zln.getLength()
             IF l_zln[li_j].zln03 CLIPPED = "top" THEN
                CASE
                   WHEN (l_zln[li_j].zln04 CLIPPED = "top")
                      LET l_path = l_patch_path,"/tiptop/",l_config
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_config CLIPPED,"/top.global|",g_conv_tool," > ",l_path,"/top.global 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,"/top.global ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "4ad") OR (l_zln[li_j].zln04 CLIPPED = "4sm")
                      FOR li_k = 1 TO l_lang.getLength()
                          LET l_path = l_patch_path,"/tiptop/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                       l_lang[li_k].gay01 CLIPPED
                          CALL pack_chk_and_add_dir(l_path)
                          IF g_convert = "Y" THEN
                             LET l_cmd = "cat ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                          l_lang[li_k].gay01 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                          ELSE
                             LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                          l_lang[li_k].gay01 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                          END IF
                          RUN l_cmd
                      END FOR
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn1")
                      LET l_path = l_patch_path,"/tiptop/ds4gl2/bin"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/ds4gl2/bin/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/ds4gl2/bin/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn2")
                      LET l_path = l_patch_path,"/tiptop/bin"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/bin/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/bin/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn3")
                      LET l_path = l_patch_path,"/tiptop/ora/bin"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/ora/bin/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/ora/bin/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn4")
                      LET l_path = l_patch_path,"/tiptop/ora/work"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/ora/work/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/ora/work/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn5")
                      LET ls_path_str = l_zln[li_j].zln05
                      LET li_inx = 1
                      WHILE TRUE
                         IF ls_path_str.getIndexOf("/",li_inx) <= 0 THEN
                            EXIT WHILE
                         ELSE
                            LET li_inx = 1 + ls_path_str.getIndexOf("/",li_inx)
                         END IF
                      END WHILE
                      LET l_path = l_patch_path,"/tiptop/",ls_path_str.subString(1,li_inx - 1)
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn6")    # No:FUN-7A0026
                      LET l_path = l_patch_path,"/tiptop/msv/bin"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/msv/bin/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/msv/bin/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   WHEN (l_zln[li_j].zln04 CLIPPED = "bn7")    # No:FUN-7A0026
                      LET l_path = l_patch_path,"/tiptop/msv/work"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/msv/work/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/msv/work/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   OTHERWISE
                      LET l_path = l_patch_path,"/tiptop/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                      l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                      l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                END CASE
             ELSE
                CASE
                   WHEN (l_zln[li_j].zln04 CLIPPED = "4ad")
                      FOR li_k = 1 TO l_lang.getLength()
                          LET l_path = l_patch_path,"/tiptop/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                       l_lang[li_k].gay01 CLIPPED,"/",l_zln[li_j].zln03 CLIPPED
                          CALL pack_chk_and_add_dir(l_path)
                          IF g_convert = "Y" THEN
                             LET l_cmd = "cat ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                          l_lang[li_k].gay01 CLIPPED,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                          ELSE
                             LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                          l_lang[li_k].gay01 CLIPPED,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                          END IF
                          RUN l_cmd
                      END FOR
                   WHEN (l_zln[li_j].zln04 CLIPPED = "4tm")
                      LET l_path = l_patch_path,"/tiptop/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                   l_zln[li_j].zln03 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                      l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                      l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   #No:CHI-750028 --start--
                   WHEN (l_zln[li_j].zln04 CLIPPED = "per")
                      # per
                      LET l_path = l_patch_path,"/tiptop/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                     l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                     l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                      # 4fd
                      LET ls_path_str = l_zln[li_j].zln05
                      LET ls_path_str = ls_path_str.subString(1,ls_path_str.getIndexOf(".per",1)-1)
                      LET l_path = l_patch_path,"/tiptop/",l_zln[li_j].zln03 CLIPPED,"/4fd"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/4fd/",
                                     ls_path_str,".4fd|",g_conv_tool," > ",l_path,"/",ls_path_str,".4fd 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/4fd/",
                                     ls_path_str,".4fd ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                      # sdd
                      LET l_path = l_patch_path,"/tiptop/",l_zln[li_j].zln03 CLIPPED,"/sdd"
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/sdd/",
                                     ls_path_str,".sdd|",g_conv_tool," > ",l_path,"/",ls_path_str,".sdd 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/sdd/",
                                     ls_path_str,".sdd ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                   #No:CHI-750028 ---end---
                   OTHERWISE
                      LET l_path = l_patch_path,"/tiptop/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      IF g_convert = "Y" THEN
                         LET l_cmd = "cat ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                     l_zln[li_j].zln05 CLIPPED,"|",g_conv_tool," > ",l_path,"/",l_zln[li_j].zln05 CLIPPED," 2>/dev/null"
                      ELSE
                         LET l_cmd = "cp ",l_final_top,"/",l_zln[li_j].zln03 CLIPPED,"/",l_zln[li_j].zln04 CLIPPED,"/",
                                     l_zln[li_j].zln05 CLIPPED," ",l_path," 2>/dev/null"
                      END IF
                      RUN l_cmd
                END CASE
             END IF
         END FOR
      END IF

      CALL p_zl_pack_data(l_zl[li_i].zl08 CLIPPED,l_zl[li_i].zl09 CLIPPED)

   END FOR
   # 打包全系統不會有info.txt
   IF g_packall = "N" THEN
      LET l_str = "==================",l_zl.getLength()," data"
      CALL gc_channel.write(l_str)
      CALL gc_channel.close()
   END IF

   # 依照資料庫打包資料
   IF g_db_type = "IFX" THEN
      LET l_cmd = "export DBDATE=Y4MD/;dbexport patchtemp"
      RUN l_cmd
   ELSE
      IF g_ver_main MATCHES '1*' THEN
         LET l_cmd = "exp patchtemp/patchtemp tables=ze_file, zz_file, zm_file, ",
                     "gap_file, gbd_file, gae_file, gak_file, gal_file, gaq_file, ",
                     "gab_file, gac_file, gav_file, gat_file, gaz_file, wsa_file, ",
                     "wsb_file, zaa_file, zab_file, gao_file, gba_file, gbb_file, ",
                     "gax_file, gbf_file, wsm_file, wsn_file, wso_file, wsp_file  file=/tmp/patchtemp.dmp"
      ELSE
         # 2006/09/22 --start--
#        IF g_ver_main = "5.0" OR g_ver_main = "3.5" THEN
            LET l_cmd = "exp patchtemp/patchtemp tables=ze_file, zz_file, zm_file, ",
                        "gap_file, gbd_file, gae_file, gak_file, gal_file, gaq_file, ",
                        "gab_file, gac_file, gav_file, gat_file, gaz_file, wsa_file, ",
                        "wsb_file, zaa_file, zab_file, gao_file, gba_file, gbb_file, ",
                        "gax_file, gbf_file, zad_file, zae_file, wca_file, wcb_file, ",
                        "wcc_file, wcd_file, zaw_file, zav_file, zai_file, zaj_file, ",
                        "zak_file, zal_file, zam_file, zan_file, zao_file, zap_file, ",
                        "zaq_file, zar_file, zas_file, zat_file, zau_file  file=/tmp/patchtemp.dmp"   #FUN-730071 add zaw_file  #No:TQC-740038
#        ELSE
#        # 2006/09/22 ---end---
#           LET l_cmd = "exp patchtemp/patchtemp tables=ze_file, zz_file, zm_file, ",
#                       "gap_file, gbd_file, gae_file, gak_file, gal_file, gaq_file, ",
#                       "gab_file, gac_file, gav_file, gat_file, gaz_file, wsa_file, ",
#                       "wsb_file, zaa_file, zab_file, gao_file, gba_file, gbb_file, ",
#                       "gax_file, gbf_file, zad_file, zae_file, wsm_file, wsn_file, ",
#                       "wso_file, wsp_file  file=/tmp/patchtemp.dmp"
#        END IF
      END IF
      RUN l_cmd
   END IF

   # Unpack 程式路徑
   IF g_convert = "Y" THEN
      LET l_cmd = "cat ",l_ds4gl_path,"/bin/patch.4gl|",g_conv_tool," > ",
                  l_patch_path,"/patch.4gl"
      RUN l_cmd
   ELSE
      LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch.4gl ",l_patch_path
      RUN l_cmd
   END IF
   LET l_file = l_file," ",l_patch_dir,"/patch.4gl"
   LET l_cmd = "cd ",l_patch_path,";export FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev;fglcomp patch.4gl"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch.42m"
   LET l_cmd = "cd ",l_patch_path,";export FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev;fgl2p -o patch.42r patch.42m"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch.42r"

   IF g_convert = "Y" THEN
      LET l_cmd = "cat ",l_ds4gl_path,"/bin/patch.per|",g_conv_tool," > ",
                  l_patch_path,"/patch.per"
      RUN l_cmd
   ELSE
      LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch.per ",l_patch_path
      RUN l_cmd
   END IF
   LET l_file = l_file," ",l_patch_dir,"/patch.per"
   LET l_cmd = "cd ",l_patch_path,";fglform patch.per"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch.42f"

   IF g_convert = "Y" THEN
      LET l_cmd = "cat ",l_ds4gl_path,"/bin/patch_view.per|",g_conv_tool," > ",
                  l_patch_path,"/patch_view.per"
      RUN l_cmd
   ELSE
      LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_view.per ",l_patch_path
      RUN l_cmd
   END IF
   LET l_file = l_file," ",l_patch_dir,"/patch_view.per"
   LET l_cmd = "cd ",l_patch_path,";fglform patch_view.per"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch_view.42f"

   LET l_cmd = "cp ",l_ds4gl_path,"/bin/r.gfall ",l_patch_path
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/r.gfall"

   # Data dmp 路徑
   IF g_db_type = "IFX" THEN
      LET l_cmd = "cp -rf patchtemp.exp ",l_patch_path
      RUN l_cmd
      LET l_file = l_file," ",l_patch_dir,"/patchtemp.exp"
      LET l_cmd = "rm dbexport.out"
      RUN l_cmd
      LET l_cmd = "rm -rf patchtemp.exp"
      RUN l_cmd
   ELSE
      LET l_cmd = "cp /tmp/patchtemp.dmp ",l_patch_path
      RUN l_cmd
      LET l_file = l_file," ",l_patch_dir,"/patchtemp.dmp"
   END IF

   IF g_convert = "Y" THEN
      LET l_cmd = "cat ",l_ds4gl_path,"/bin/patch_load_data.4gl|",g_conv_tool," > ",
                  l_patch_path,"/patch_load_data.4gl"
      RUN l_cmd
   ELSE
      LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_load_data.4gl ",l_patch_path
      RUN l_cmd
   END IF
   LET l_file = l_file," ",l_patch_dir,"/patch_load_data.4gl"
   LET l_cmd = "cd ",l_patch_path,";export FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev;fglcomp patch_load_data.4gl"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch_load_data.42m"
   LET l_cmd = "cd ",l_patch_path,";export FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev;fgl2p -o patch_load_data.42r patch_load_data.42m"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/patch_load_data.42r"

   LET l_cmd = "cp ",l_dbpath,"/ds.sch ",l_patch_path,"/ds.sch"
   RUN l_cmd
   LET l_file = l_file," ",l_patch_dir,"/ds.sch"

   # 2005/06/14 資料庫相關暫時都不使用
   # Schema 檔案路徑
#  IF (NOT g_bug_flag) THEN
#     LET l_cmd = "cp ",l_ds4gl_path,"/bin/execmd.42m ",l_patch_path
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/execmd.42m"
#     IF g_db_type="IFX" THEN
#        RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
#     ELSE
#        RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
#     END IF
#     LET l_cmd = "cp ",l_dbpath,"/ds.sch ",l_patch_path,"/std.sch"
#     RUN l_cmd
#     LET l_cmd = "$FGLRUN gen_index.42m ds"
#     RUN l_cmd
#     LET l_cmd = "cp ",l_dbpath,"/ds_idx.sch ",l_patch_path,"/std_idx.sch"
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/std.sch"
#     LET l_file = l_file," ",l_patch_dir,"/std_idx.sch"
#     LET l_cmd = "cp ",l_top,"/ora/work/synonym.sql ",l_patch_path,"/synonym_ora.sql"
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/synonym_ora.sql"
#     LET l_cmd = "cp ",l_top,"/bin/synonym.sql ",l_patch_path,"/synonym_ifx.sql"
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/synonym_ifx.sql"
#  END IF

# index_file 暫用
#  IF (NOT g_bug_flag) THEN
#     LET l_cmd = "cp ",l_ds4gl_path,"/bin/gen_index.42m ",l_patch_path
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/gen_index.42m"
#     LET l_cmd = "cp ",l_ds4gl_path,"/bin/cmd4nds.sh ",l_patch_path
#     RUN l_cmd
#     LET l_file = l_file," ",l_patch_dir,"/cmd4nds.sh"
#  END IF
#  2005/06/14 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   # 打包source檔
   IF (NOT g_bug_flag) THEN
      IF g_packall = "N" THEN
         LET l_cmd = "cd ",l_patch_path,"/tiptop;tar cvf ",l_patch_path,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED,"_source.tar * 2>/dev/null"
         RUN l_cmd
         LET l_cmd = "cd ",l_patch_path,";rm -rf tiptop"
         RUN l_cmd
      END IF
   ELSE
      LET l_cmd = "cd ",l_patch_path,"/tiptop;tar cvf ",l_patch_path,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,"_source.tar * 2>/dev/null"
      RUN l_cmd
      LET l_cmd = "cd ",l_patch_path,";rm -rf tiptop"
      RUN l_cmd
   END IF

   # 將所有東西都打包成patch_xxxx.tar
   IF (NOT g_bug_flag) THEN
      LET l_cmd = "cd ",g_temp_path CLIPPED,";tar cvf ",
                   l_tempdir,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED,".tar ",
                  " patch_",l_date CLIPPED,"_",g_vername CLIPPED," 2>/dev/null"
   ELSE
      LET l_cmd = "cd ",g_temp_path CLIPPED,";tar cvf ",
                   l_tempdir,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".tar ",
                  " patch_",g_bugno CLIPPED,"_",g_vername CLIPPED," 2>/dev/null"
   END IF
   RUN l_cmd

   IF (NOT g_bug_flag) THEN
      LET l_cmd = "chmod 777 ",l_tempdir,"/","patch_",l_date CLIPPED,"_",g_vername CLIPPED,".tar 2>/dev/null"
      RUN l_cmd

      LET l_cmd = "rm -rf ",g_temp_path CLIPPED,"/patch_",l_date CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd

      LET l_cmd = "test -s ",g_temp_path CLIPPED,"/","patch_",l_date CLIPPED,"_",g_vername CLIPPED,".tar"
      RUN l_cmd RETURNING li_result
   ELSE
      LET l_cmd = "chmod 777 ",l_tempdir,"/","patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".tar 2>/dev/null"
      RUN l_cmd

      LET l_cmd = "rm -rf ",g_temp_path CLIPPED,"/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED
      RUN l_cmd

      LET l_cmd = "test -s ",g_temp_path CLIPPED,"/","patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".tar"
      RUN l_cmd RETURNING li_result
   END IF

   IF NOT li_result THEN
      IF (NOT g_bug_flag) THEN
         CALL pack_mk_patch_shell(l_date CLIPPED || "_" || g_vername CLIPPED)
         DISPLAY "產生 patch_",l_date CLIPPED,"_",g_vername CLIPPED,".sh及patch_",l_date CLIPPED,"_",g_vername CLIPPED,".tar 在$TEMPDIR下"
         DISPLAY "位置:$TEMPDIR/patch_",l_date CLIPPED,"_",g_vername CLIPPED,".*"   #add by alexstar
      ELSE
         CALL pack_mk_patch_shell(g_bugno CLIPPED || "_" || g_vername CLIPPED)
         DISPLAY "產生 patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".sh及patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".tar 在$TEMPDIR下"
         DISPLAY "位置:$TEMPDIR/patch_",g_bugno CLIPPED,"_",g_vername CLIPPED,".*"   #add by alexstar
      END IF
   END IF
END FUNCTION

FUNCTION pack_chk_and_add_dir(p_path)
   DEFINE   p_path   STRING
   DEFINE   l_result SMALLINT
   DEFINE   l_cmd    STRING


   LET l_cmd = "test -s ",p_path
   RUN l_cmd RETURNING l_result
   IF l_result THEN
      LET l_cmd = "mkdir -p ",p_path
      RUN l_cmd
   END IF

END FUNCTION

FUNCTION p_zl_pack_data(p_zl08,p_zl09)
   DEFINE   p_zl08       VARCHAR(10),
            p_zl09       VARCHAR(7)
   DEFINE   l_sql        STRING
   DEFINE   l_syc        DYNAMIC ARRAY OF RECORD
               syc03     VARCHAR(1),
               syc04     VARCHAR(1),
               syc05     VARCHAR(10),
               syc06     VARCHAR(50),
               syc07     VARCHAR(50)
                         END RECORD
   DEFINE   li_i         INTEGER
   DEFINE   l_cnt        INTEGER
   DEFINE   l_cnt2       INTEGER
   DEFINE   li_count     INTEGER
   DEFINE   lr_ze        DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_zz        DYNAMIC ARRAY OF RECORD LIKE zz_file.*
   DEFINE   lr_zm        DYNAMIC ARRAY OF RECORD LIKE zm_file.*
   DEFINE   lr_gap       DYNAMIC ARRAY OF RECORD LIKE gap_file.*
   DEFINE   lr_gbd       DYNAMIC ARRAY OF RECORD LIKE gbd_file.*
   DEFINE   lr_gaz       DYNAMIC ARRAY OF RECORD LIKE gaz_file.*
   DEFINE   lr_gao       DYNAMIC ARRAY OF RECORD LIKE gao_file.*
   DEFINE   lr_gae       DYNAMIC ARRAY OF RECORD LIKE gae_file.*
   DEFINE   lr_gav       DYNAMIC ARRAY OF RECORD LIKE gav_file.*
   DEFINE   lr_gak       DYNAMIC ARRAY OF RECORD LIKE gak_file.*
   DEFINE   lr_gal       DYNAMIC ARRAY OF RECORD LIKE gal_file.*
   DEFINE   lr_gaq       DYNAMIC ARRAY OF RECORD LIKE gaq_file.*
   DEFINE   lr_gat       DYNAMIC ARRAY OF RECORD LIKE gat_file.*
   DEFINE   lr_gab       DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac       DYNAMIC ARRAY OF RECORD LIKE gac_file.*
   DEFINE   lr_wsa       DYNAMIC ARRAY OF RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       DYNAMIC ARRAY OF RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       DYNAMIC ARRAY OF RECORD LIKE zaa_file.*
   DEFINE   lr_zab       DYNAMIC ARRAY OF RECORD LIKE zab_file.*
   # 2005/10/03 --start-- By saki 增加Table
   DEFINE   lr_gax       DYNAMIC ARRAY OF RECORD LIKE gax_file.*
   DEFINE   lr_gba       DYNAMIC ARRAY OF RECORD LIKE gba_file.*
   DEFINE   lr_gbb       DYNAMIC ARRAY OF RECORD LIKE gbb_file.*
   DEFINE   lr_gbf       DYNAMIC ARRAY OF RECORD LIKE gbf_file.*
   DEFINE   lc_zaa08     LIKE zaa_file.zaa08
   # 2005/10/03 ---end---
   # 2006/04/14 --start-- By saki 增加Table
   DEFINE   lr_zad       DYNAMIC ARRAY OF RECORD
               zad01     VARCHAR(10),            #程式代號
               zad02     SMALLINT,               #序號
               zad03     VARCHAR(1),             #語言別
               zad04     VARCHAR(10),            #使用者
               zad05     VARCHAR(1),             #客製否
               zad06     VARCHAR(20),            #報表列印的樣板
               zad07     VARCHAR(10),            #權限類別
               zad08     SMALLINT,               #報表聯查序號
               zad09     VARCHAR(1),             #報表聯查類型
               zad10     VARCHAR(10),            #報表聯查內容
               zad11     VARCHAR(255)
                         END RECORD
   DEFINE   lr_zae       DYNAMIC ARRAY OF RECORD
               zae01     VARCHAR(10),            #報表連查sql 代號
               zae02     VARCHAR(30),            #代號說明
               zae03     VARCHAR(255),           #sql內容
               zae04     SMALLINT,               #序號
               zae05     VARCHAR(1),             #語言別
               zae06     VARCHAR(20),            #欄位代號
               zae07     VARCHAR(60),            #欄位說明
               zae08     SMALLINT,               #報表下階聯查序號
               zae09     VARCHAR(1),             #報表下階聯查類型 1:程式代號 2:sql代號
               zae10     VARCHAR(10)             #報表下階連查內容
                         END RECORD
   DEFINE   lc_zad10     VARCHAR(10)
   # 2006/04/14 ---end---
   # 2006/09/22 --start-- By saki 增加Table
   DEFINE   lr_wca       DYNAMIC ARRAY OF RECORD
               wca01     VARCHAR(10),            #程式代號
               wca02     VARCHAR(1),             #是否為 hard code 程式
               wca03     VARCHAR(1),             #no use
               wca04     VARCHAR(1),             #no use
               wca05     VARCHAR(1),             #no use
               wcaacti   VARCHAR(1),             #資料有效碼
               wcauser   VARCHAR(10),            #資料所有者
               wcagrup   VARCHAR(6),             #資料所有群
               wcamodu   VARCHAR(10),            #資料更改者
               wcadate   DATE                    #最近修改日
                         END RECORD
   DEFINE   lr_wcb       DYNAMIC ARRAY OF RECORD
               wcb01     VARCHAR(10),            #程式代號
               wcb02     VARCHAR(15),            #程式使用單頭檔
               wcb03     VARCHAR(20),            #單頭檔 key 值欄位1
               wcb04     VARCHAR(20),            #單頭檔 key 值欄位2
               wcb05     VARCHAR(20),            #單頭檔 key 值欄位3
               wcb06     VARCHAR(20),            #單頭檔 key 值欄位4
               wcb07     VARCHAR(20),            #單頭檔 key 值欄位5
               wcb08     VARCHAR(20),            #單頭檔確認碼欄位
               wcb09     VARCHAR(20),            #單頭檔spc拋轉碼欄位
               wcb10     VARCHAR(1),             #no use
               wcb11     VARCHAR(1),             #no use
               wcb12     VARCHAR(1),             #no use
               wcb13     VARCHAR(1),             #no use
               wcb14     VARCHAR(1)              #no use
                         END RECORD
   DEFINE   lr_wcc       DYNAMIC ARRAY OF RECORD
               wcc01     VARCHAR(10),            #程式代號
               wcc02     VARCHAR(20),            #欄位名稱
               wcc03     VARCHAR(1),             #更新否
               wcc04     VARCHAR(1),             #no use
               wcc05     VARCHAR(1),             #no use
               wcc06     VARCHAR(1),             #no use
               wcc07     VARCHAR(1)              #no use
                         END RECORD
   DEFINE   lr_wcd       DYNAMIC ARRAY OF RECORD
               wcd01     VARCHAR(15),            #檔案代碼
               wcd02     VARCHAR(20),            #欄位名稱
               wcd03     VARCHAR(1),             #no use
               wcd04     VARCHAR(1),             #no use
               wcd05     VARCHAR(1),             #no use
               wcd06     VARCHAR(1),             #no use
               wcd07     VARCHAR(1)              #no use
                         END RECORD
   # 2006/09/22 ---end---
 
   #FUN-730071 ---start---
   DEFINE   lr_zaw       DYNAMIC ARRAY OF RECORD
               zaw01     VARCHAR(10),            #程式代號
               zaw02     VARCHAR(20),            #樣板代號
               zaw03     VARCHAR(1),             #客製否
               zaw04     VARCHAR(10),            #權限類別
               zaw05     VARCHAR(10),            #使用者
               zaw06     VARCHAR(1),             #語言別
               zaw07     SMALLINT,               #序號
               zaw08     VARCHAR(20),            #cr樣板名稱(.rpt)
               zaw09     VARCHAR(50),            #cr樣板說明
               zaw10     VARCHAR(1),             #no use
               zaw11     VARCHAR(1),             #no use
               zaw12     VARCHAR(1),             #no use
               zawdate   DATE,                   #最近修改日
               zawgrup   VARCHAR(6),             #資料所有部門
               zawmodu   VARCHAR(10),            #資料修改者
               zawuser   VARCHAR(10)             #
                         END RECORD
   #FUN-730071 ---end---
   #No:TQC-740038 --start--
   DEFINE   lr_zav       DYNAMIC ARRAY OF RECORD
               zav01     VARCHAR(1),             #p_per/p_query
               zav02     VARCHAR(40),            #畫面代碼
               zav03     VARCHAR(20),            #欄位代碼
               zav04     VARCHAR(1),             #客製碼
               zav05     VARCHAR(10),            #行業別代碼
               zav06     VARCHAR(1),             #是否需要CONSTRUCT
               zav07     VARCHAR(255),           #額外查詢條件
               zav08     VARCHAR(5),             #預設值自選或固定值
               zav09     VARCHAR(50),            #預設值1
               zav10     VARCHAR(50),            #預設值2
               zav11     VARCHAR(50),            #預設值3
               zav12     VARCHAR(50),            #預設值4
               zav13     VARCHAR(50),            #預設值5
               zav14     VARCHAR(9),             #參數自選或固定值
               zav15     VARCHAR(50),            #參數1
               zav16     VARCHAR(50),            #參數2
               zav17     VARCHAR(50),            #參數3
               zav18     VARCHAR(50),            #參數4
               zav19     VARCHAR(50),            #參數5
               zav20     VARCHAR(50),            #參數6
               zav21     VARCHAR(50),            #參數7
               zav22     VARCHAR(50),            #參數8
               zav23     VARCHAR(50),            #參數9
               zav24     VARCHAR(1)              #input/construct用
                         END RECORD
   #No:TQC-740038 ---end---
   #No:FUN-740054 --start--
   DEFINE   lr_zai       DYNAMIC ARRAY OF RECORD
               zai01     VARCHAR(40),            #查詢單id
               zai02     VARCHAR(100),           #查詢單名稱
               zai03     VARCHAR(255),           #說明
               zaiuser   VARCHAR(10),            #資料所有者
               zaigrup   VARCHAR(6),             #資料所有群
               zaimodu   VARCHAR(10),            #資料更改者
               zaidate   DATE,                   #最近修改日
               zai04     VARCHAR(1),             #查詢報表時是否需輸入查詢條件
               zai05     VARCHAR(1)              #客製否
                         END RECORD
   DEFINE   lr_zaj       DYNAMIC ARRAY OF RECORD
               zaj01     VARCHAR(40),            #查詢單id
               zaj02     SMALLINT,               #執行順序
               zaj03     VARCHAR(1),             #啟動否
               zaj04     VARCHAR(1),             #來源類別
               zaj05     VARCHAR(255),           #執行命令
               zaj06     VARCHAR(255)            #備註
                         END RECORD
   DEFINE   lr_zak       DYNAMIC ARRAY OF RECORD
               zak01     VARCHAR(40),            #查詢單id
               zak02     VARCHAR(2000),          #sql命令
               zak03     VARCHAR(2000),          #table list
               zak04     VARCHAR(2000),          #field list
               zak05     VARCHAR(2000),          #where 條件
               zak06     VARCHAR(1)              #SQL是否由Wizard產生
                         END RECORD
   DEFINE   lr_zal       DYNAMIC ARRAY OF RECORD
               zal01     VARCHAR(40),            #查詢單id                               */
               zal02     SMALLINT,               #序號                                   */
               zal03     VARCHAR(1),             #語言別                                 */
               zal04     VARCHAR(60),            #欄位代號                               */
               zal05     VARCHAR(40),            #顯示名稱                               */
               zal06     VARCHAR(255)            #備註                                   */
                         END RECORD
   DEFINE   lr_zam       DYNAMIC ARRAY OF RECORD
               zam01     VARCHAR(40),            #查詢單id                               */
               zam02     SMALLINT,               #序號                                   */
               zam03     VARCHAR(1),             #group否                                */
               zam04     VARCHAR(1),             #排序否                                 */
               zam05     SMALLINT,               #排序順序                               */
               zam06     VARCHAR(255),           #備註                                   */
               zam07     VARCHAR(1),             #是否BY Group跳頁                       */
               zam08     VARCHAR(1)              #排序方式                               */
                         END RECORD
   DEFINE   lr_zan       DYNAMIC ARRAY OF RECORD
               zan01     VARCHAR(40),            #查詢單id                               */
               zan02     SMALLINT,               #序號                                   */
               zan03     VARCHAR(1),             #計算式-aggr                            */
               zan04     VARCHAR(1),             #依group欄位                            */
               zan05     VARCHAR(40),            #group欄位序                            */
               zan06     VARCHAR(255),           #備註                                   */
               zan07     VARCHAR(1)              #顯示方式                               */
                         END RECORD
   DEFINE   lr_zao       DYNAMIC ARRAY OF RECORD
               zao01     VARCHAR(40),            #查詢單id                               */
               zao02     VARCHAR(1),             #layout 項目                            */
               zao03     VARCHAR(1),             #輸入格式                               */
               zao04     VARCHAR(1)              #執行否                                 */
                         END RECORD
   DEFINE   lr_zap       DYNAMIC ARRAY OF RECORD
               zap01     VARCHAR(40),            #查詢單id                               */
               zap02     SMALLINT,               #page length                            */
               zap03     SMALLINT,               #top margin                             */
               zap04     SMALLINT,               #left margin                            */
               zap05     SMALLINT,               #bottom margin                          */
               zap06     INTEGER                 #報表最大查詢筆數                       */
                         END RECORD
   DEFINE   lr_zaq       DYNAMIC ARRAY OF RECORD
               zaq01     VARCHAR(40),            #查詢單ID                               */
               zaq02     VARCHAR(15),            #檔案代碼                               */
               zaq03     VARCHAR(1),             #outer                                  */
               zaq04     SMALLINT                #序號                                   */
                         END RECORD
   DEFINE   lr_zar       DYNAMIC ARRAY OF RECORD
               zar01     VARCHAR(40),            #查詢單id                               */
               zar02     VARCHAR(15),            #檔案代碼                               */
               zar03     VARCHAR(20),            #欄位代碼                               */
               zar04     SMALLINT                #序號                                   */
                         END RECORD
   DEFINE   lr_zas       DYNAMIC ARRAY OF RECORD
               zas01     VARCHAR(40),            #查詢單id                               */
               zas02     SMALLINT,               #條件式序號                             */
               zas03     VARCHAR(5),             #(                                      */
               zas04     VARCHAR(15),            #檔案代碼                               */
               zas05     VARCHAR(20),            #欄位代碼                               */
               zas06     VARCHAR(5),             #條件式                                 */
               zas07     VARCHAR(20),            #檔案代碼                               */
               zas08     VARCHAR(50),            #欄位代碼/數值                          */
               zas09     VARCHAR(5),             #)                                      */
               zas10     VARCHAR(1)              #or/and                                 */
                         END RECORD
   DEFINE   lr_zat       DYNAMIC ARRAY OF RECORD
               zat01     VARCHAR(40),            #查詢單id                               */
               zat02     DECIMAL(5,0),           #序號                                   */
               zat03     VARCHAR(1),             #列印顯示設定                           */
               zat04     SMALLINT,               #查詢視窗顯示順序                       */
               zat05     VARCHAR(1),             #開窗(qbe)                              */
               zat06     VARCHAR(20),            #查詢程式代碼                           */
               zat07     VARCHAR(1),             #小數位設定                             */
               zat08     VARCHAR(1),             #欄位屬性                               */
               zat09     VARCHAR(20)             #幣別欄位/小數位                        */
                         END RECORD
   DEFINE   lr_zau       DYNAMIC ARRAY OF RECORD
               zau01     VARCHAR(40),            #查詢單id                               */
               zau02     VARCHAR(20),            #資料所有者欄位                         */
               zau03     VARCHAR(20)             #資料群組欄位                           */
                         END RECORD
   DEFINE   lr_wsm       DYNAMIC ARRAY OF RECORD LIKE wsm_file.*
   DEFINE   lr_wsn       DYNAMIC ARRAY OF RECORD LIKE wsn_file.*
   DEFINE   lr_wso       DYNAMIC ARRAY OF RECORD LIKE wso_file.*
   DEFINE   lr_wsp       DYNAMIC ARRAY OF RECORD LIKE wsp_file.*
   #No:FUN-740054 ---end---

   DATABASE ds
   LET l_sql = "SELECT syc03,syc04,syc05,syc06,syc07 FROM syc_file",
               " WHERE syc00 = '",p_zl09 CLIPPED,"' AND syc01 = '",p_zl08 CLIPPED,"'"
   PREPARE syc_pre FROM l_sql
   DECLARE syc_curs CURSOR FOR syc_pre

   CALL l_syc.clear()
   LET l_cnt = 1
   FOREACH syc_curs INTO l_syc[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_syc.deleteElement(l_cnt)

   FOR li_i = 1 TO l_syc.getLength()
       IF l_syc[li_i].syc04 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  此筆資料中table狀態不明"
       END IF
       IF l_syc[li_i].syc06 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  ",l_syc[li_i].syc04 CLIPPED,":資料主key值null,無法篩選資料"
          CONTINUE FOR
       END IF
       IF l_syc[li_i].syc03 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  ",l_syc[li_i].syc05 CLIPPED,": insert或delete動作不明"
          CONTINUE FOR
       END IF
       
       DATABASE ds
       IF l_syc[li_i].syc03 = "I" THEN
          CASE l_syc[li_i].syc04
             WHEN "1"
                LET l_sql = "SELECT COUNT(*) FROM ze_file WHERE ze01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "2"
                LET l_sql = "SELECT COUNT(*) FROM zz_file WHERE zz01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "3"
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = "SELECT COUNT(*) FROM zm_file WHERE zm01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM zm_file WHERE zm01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND zm03 = '" || l_syc[li_i].syc07 CLIPPED || "'"
                END IF
             WHEN "4"
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gap02 = '" || l_syc[li_i].syc07 CLIPPED || "'"
                END IF
             WHEN "5"
                LET l_sql = "SELECT COUNT(*) FROM gbd_file WHERE gbd01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gbd07 = 'N'"
             WHEN "6"
                LET l_sql = "SELECT COUNT(*) FROM gaz_file WHERE gaz01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gaz05 = 'N'"
             WHEN "7"
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae11 = 'N'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae02 = '" || l_syc[li_i].syc07 CLIPPED || "' AND gae11 = 'N'"
                END IF
             WHEN "8"
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae11 = 'N'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae02 = '" || l_syc[li_i].syc07 CLIPPED || "' AND gae11 = 'N'"
                END IF
             WHEN "9"
                LET l_sql = "SELECT COUNT(*) FROM gak_file WHERE gak01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "A"
                LET l_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "B"
                LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "C"
                LET l_sql = "SELECT COUNT(*) FROM gap_file,gbd_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gap02 = gbd01 AND gbd07 = 'N'"
             WHEN "D"
                LET l_sql = "SELECT COUNT(*) FROM gab_file WHERE gab01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gab11 = 'N'"
             WHEN "E"
                LET l_sql = "SELECT COUNT(*) FROM gav_file WHERE gav01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gav08 = 'N'"
             WHEN "G"
                LET l_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "H"
                LET l_sql = "SELECT COUNT(*) FROM wsa_file WHERE wsa01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "I"
                LET l_sql = "SELECT COUNT(*) FROM zaa_file WHERE zaa01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND zaa10 = 'N'"
             WHEN "J"
                LET l_sql = "SELECT COUNT(*) FROM gao_file WHERE gao01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "K"
                LET l_sql = "SELECT COUNT(*) FROM gba_file WHERE gba01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "L"
                LET l_sql = "SELECT COUNT(*) FROM gax_file WHERE gax01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gax05 = 'N'"
             WHEN "M"
                LET l_sql = "SELECT COUNT(*) FROM gbf_file WHERE gbf01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             # 2006/09/22 --start--
             WHEN "N"
                LET l_sql = "SELECT COUNT(*) FROM wca_file WHERE wca01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "O"
                LET l_sql = "SELECT COUNT(*) FROM wcd_file WHERE wcd01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             # 2006/09/22 ---end---
             WHEN "P"   #FUN-730071
                LET l_sql = "SELECT COUNT(*) FROM zaw_file WHERE zaw01 = '" || l_syc[li_i].syc06 CLIPPED || "'" 
             #No:FUN-740054 --start--
             WHEN "Q"
                LET l_sql = "SELECT COUNT(*) FROM zai_file WHERE zai01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND zai05 = 'N'"   #No:CHI-750028
             #No:FUN-740054 ---end---
          END CASE
          PREPARE count_pre FROM l_sql
          EXECUTE count_pre INTO li_count
          IF li_count <= 0 THEN
             DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," Key值為'",l_syc[li_i].syc06 CLIPPED,"', 但dstest資料庫沒資料可下載"
             CONTINUE FOR
          END IF
       END IF

       CASE l_syc[li_i].syc04
          WHEN "1"
             IF l_syc[li_i].syc05 != "ze_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM ze_file WHERE ze01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE ze_pre FROM l_sql
                DECLARE ze_curs CURSOR FOR ze_pre
                LET l_cnt = 1
                CALL lr_ze.clear()
                FOREACH ze_curs INTO lr_ze[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_ze.deleteElement(l_cnt)
                IF lr_ze.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_ze.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_ze.getLength()
                   INSERT INTO ze_file VALUES(lr_ze[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "2"
             # zz_file 對客製程式不做update動作
             IF l_syc[li_i].syc05 != "zz_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM zz_file WHERE zz01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE zz_pre FROM l_sql
                DECLARE zz_curs CURSOR FOR zz_pre
                LET l_cnt = 1
                CALL lr_zz.clear()
                FOREACH zz_curs INTO lr_zz[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zz.deleteElement(l_cnt)
                IF lr_zz.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zz.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zz.getLength()
                   INSERT INTO zz_file VALUES(lr_zz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                # 附加gaz_file資料
                DATABASE ds
                LET l_sql = "SELECT * FROM gaz_file ",
                            "WHERE gaz01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gaz05 = 'N'"
                PREPARE gaz_pre FROM l_sql
                DECLARE gaz_curs CURSOR FOR gaz_pre
                LET l_cnt = 1
                CALL lr_gaz.clear()
                FOREACH gaz_curs INTO lr_gaz[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gaz.deleteElement(l_cnt)
                IF lr_gaz.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gaz_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gaz_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaz.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gaz.getLength()
                   INSERT INTO gaz_file VALUES(lr_gaz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gaz_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "3"
             IF l_syc[li_i].syc05 != "zm_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = "SELECT * FROM zm_file WHERE zm01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                ELSE
                   LET l_sql = "SELECT * FROM zm_file WHERE zm01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zm03 = '",l_syc[li_i].syc07 CLIPPED,"'"
                END IF
                PREPARE zm_pre FROM l_sql
                DECLARE zm_curs CURSOR FOR zm_pre
                LET l_cnt = 1
                CALL lr_zm.clear()
                FOREACH zm_curs INTO lr_zm[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zm.deleteElement(l_cnt)
                IF lr_zm.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zm.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zm.getLength()
                   INSERT INTO zm_file VALUES(lr_zm[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "4"
             IF l_syc[li_i].syc05 != "gap_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gap_file "
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = l_sql," WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                ELSE
                   LET l_sql = l_sql," WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gap02 = '",l_syc[li_i].syc07 CLIPPED,"'"
                END IF
                PREPARE gap_pre FROM l_sql
                DECLARE gap_curs CURSOR FOR gap_pre
                LET l_cnt = 1
                CALL lr_gap.clear()
                FOREACH gap_curs INTO lr_gap[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gap.deleteElement(l_cnt)
                IF lr_gap.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gap.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gap.getLength()
                   INSERT INTO gap_file VALUES(lr_gap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "5"
             IF l_syc[li_i].syc05 != "gbd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gbd_file ",
                            " WHERE gbd01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gbd07 = 'N'"
                PREPARE gbd_pre FROM l_sql
                DECLARE gbd_curs CURSOR FOR gbd_pre
                LET l_cnt = 1
                CALL lr_gbd.clear()
                FOREACH gbd_curs INTO lr_gbd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbd.deleteElement(l_cnt)
                IF lr_gbd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbd.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gbd.getLength()
                   INSERT INTO gbd_file VALUES(lr_gbd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "6"
             IF l_syc[li_i].syc05 != "gaz_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gaz_file ",
                            "WHERE gaz01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gaz05 = 'N'"
                PREPARE gaz_6_pre FROM l_sql
                DECLARE gaz_6_curs CURSOR FOR gaz_6_pre
                LET l_cnt = 1
                CALL lr_gaz.clear()
                FOREACH gaz_6_curs INTO lr_gaz[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gaz.deleteElement(l_cnt)
                IF lr_gaz.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaz.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gaz.getLength()
                   INSERT INTO gaz_file VALUES(lr_gaz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "7"
             IF l_syc[li_i].syc05 != "gae_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gae_file "
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae11 = 'N'"
                ELSE
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae02 = '",l_syc[li_i].syc07 CLIPPED,"' AND gae11='N'"
                END IF
                PREPARE gae_pre FROM l_sql
                DECLARE gae_curs CURSOR FOR gae_pre
                LET l_cnt = 1
                CALL lr_gae.clear()
                FOREACH gae_curs INTO lr_gae[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gae.deleteElement(l_cnt)
                IF lr_gae.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gae.getLength()
                   INSERT INTO gae_file VALUES(lr_gae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "8"
             IF l_syc[li_i].syc05 != "gae_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gae_file "
                IF l_syc[li_i].syc07 IS NULL THEN
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae11 = 'N'"
                ELSE
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae02 = '",l_syc[li_i].syc07 CLIPPED,"' AND gae11='N'"
                END IF
                PREPARE gae_8_pre FROM l_sql
                DECLARE gae_8_curs CURSOR FOR gae_8_pre
                LET l_cnt = 1
                CALL lr_gae.clear()
                FOREACH gae_8_curs INTO lr_gae[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gae.deleteElement(l_cnt)
                IF lr_gae.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gae.getLength()
                   INSERT INTO gae_file VALUES(lr_gae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "9"
             IF l_syc[li_i].syc05 != "gak_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 單頭檔 gak_file
                DATABASE ds
                LET l_sql = "SELECT * FROM gak_file WHERE gak01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gak_pre FROM l_sql
                DECLARE gak_curs CURSOR FOR gak_pre
                LET l_cnt = 1
                CALL lr_gak.clear()
                FOREACH gak_curs INTO lr_gak[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gak.deleteElement(l_cnt)
                IF lr_gak.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gak.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gak.getLength()
                   INSERT INTO gak_file VALUES(lr_gak[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                # 單身檔 gal_file
                DATABASE ds
                LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gal_pre FROM l_sql
                DECLARE gal_curs CURSOR FOR gal_pre
                LET l_cnt = 1
                CALL lr_gal.clear()
                FOREACH gal_curs INTO lr_gal[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gal.deleteElement(l_cnt)
                IF lr_gal.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gal.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gal.getLength()
                   INSERT INTO gal_file VALUES(lr_gal[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gal_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "A"
             IF l_syc[li_i].syc05 != "gaq_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gaq_file WHERE gaq01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gaq_pre FROM l_sql
                DECLARE gaq_curs CURSOR FOR gaq_pre
                LET l_cnt = 1
                CALL lr_gaq.clear()
                FOREACH gaq_curs INTO lr_gaq[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gaq.deleteElement(l_cnt)
                IF lr_gaq.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaq.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gaq.getLength()
                   INSERT INTO gaq_file VALUES(lr_gaq[l_cnt].*)
# 因為包區間有打包全部gaq_file，所以暫時忽略此錯誤，等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
# -----------------------------------------------------------------------------
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "B"
             IF l_syc[li_i].syc05 != "gap_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gap_file WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gap_b_pre FROM l_sql
                DECLARE gap_b_curs CURSOR FOR gap_b_pre
                LET l_cnt = 1
                CALL lr_gap.clear()
                FOREACH gap_b_curs INTO lr_gap[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gap.deleteElement(l_cnt)
                IF lr_gap.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gap.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gap.getLength()
                   INSERT INTO gap_file VALUES(lr_gap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "C"
             IF l_syc[li_i].syc05 != "gbd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT gbd_file.* FROM gap_file,gbd_file",
                            " WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gap02 = gbd01 AND gbd07 = 'N'"
                PREPARE gbd_c_pre FROM l_sql
                DECLARE gbd_c_curs CURSOR FOR gbd_c_pre
                LET l_cnt = 1
                CALL lr_gbd.clear()
                FOREACH gbd_c_curs INTO lr_gbd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbd.deleteElement(l_cnt)
                IF lr_gbd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbd.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gbd.getLength()
                   INSERT INTO gbd_file VALUES(lr_gbd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "D"
             IF l_syc[li_i].syc05 != "gab_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 動態開窗查詢單頭檔 gab_file
                DATABASE ds
                LET l_sql = "SELECT * FROM gab_file WHERE gab01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gab11 = 'N'"
                PREPARE gab_pre FROM l_sql
                DECLARE gab_curs CURSOR FOR gab_pre
                LET l_cnt = 1
                CALL lr_gab.clear()
                FOREACH gab_curs INTO lr_gab[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gab.deleteElement(l_cnt)
                IF lr_gab.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gab.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gab.getLength()
                   INSERT INTO gab_file VALUES(lr_gab[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                # 動態開窗查詢單身檔 gac_file
                DATABASE ds
                LET l_sql = "SELECT * FROM gac_file WHERE gac01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gac12 = 'N'"
                PREPARE gac_pre FROM l_sql
                DECLARE gac_curs CURSOR FOR gac_pre
                LET l_cnt = 1
                CALL lr_gac.clear()
                FOREACH gac_curs INTO lr_gac[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gac.deleteElement(l_cnt)
                IF lr_gac.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gac.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gac.getLength()
                   INSERT INTO gac_file VALUES(lr_gac[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gac_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "E"
             IF l_syc[li_i].syc05 != "gav_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gav_file WHERE gav01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gav08 = 'N'"
                PREPARE gav_pre FROM l_sql
                DECLARE gav_curs CURSOR FOR gav_pre
                LET l_cnt = 1
                CALL lr_gav.clear()
                FOREACH gav_curs INTO lr_gav[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gav.deleteElement(l_cnt)
                IF lr_gav.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gav.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gav.getLength()
                   INSERT INTO gav_file VALUES(lr_gav[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                #No:TQC-740038 --start--
                #開窗參數設定
                DATABASE ds
                LET l_sql = "SELECT * FROM zav_file WHERE zav01 = '1' AND zav02 = '",l_syc[li_i].syc06 CLIPPED,"' AND zav04 = 'N'"
                PREPARE zav_pre FROM l_sql
                DECLARE zav_curs CURSOR FOR zav_pre
                LET l_cnt = 1
                CALL lr_zav.clear()
                FOREACH zav_curs INTO lr_zav[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zav.deleteElement(l_cnt)
                IF lr_zav.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zav.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zav.getLength()
                   INSERT INTO zav_file VALUES(lr_zav[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #No:TQC-740038 ---end---
             END IF
          WHEN "G"
             IF l_syc[li_i].syc05 != "gat_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gat_file WHERE gat01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gat_pre FROM l_sql
                DECLARE gat_curs CURSOR FOR gat_pre
                LET l_cnt = 1
                CALL lr_gat.clear()
                FOREACH gat_curs INTO lr_gat[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gat.deleteElement(l_cnt)
                IF lr_gat.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gat.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gat.getLength()
                   INSERT INTO gat_file VALUES(lr_gat[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "H"
             IF l_syc[li_i].syc05 != "wsa_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 單頭檔 wsa_file
                DATABASE ds
                LET l_sql = "SELECT * FROM wsa_file WHERE wsa01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsa_pre FROM l_sql
                DECLARE wsa_curs CURSOR FOR wsa_pre
                LET l_cnt = 1
                CALL lr_wsa.clear()
                FOREACH wsa_curs INTO lr_wsa[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsa.deleteElement(l_cnt)
                IF lr_wsa.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsa.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wsa.getLength()
                   INSERT INTO wsa_file VALUES(lr_wsa[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                # 單身檔 wsb_file
                DATABASE ds
                LET l_sql = "SELECT * FROM wsb_file WHERE wsb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsb_pre FROM l_sql
                DECLARE wsb_curs CURSOR FOR wsb_pre
                LET l_cnt = 1
                CALL lr_wsb.clear()
                FOREACH wsb_curs INTO lr_wsb[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsb.deleteElement(l_cnt)
                IF lr_wsb.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsb_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsb_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsb.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wsb.getLength()
                   INSERT INTO wsb_file VALUES(lr_wsb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsb_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "I"
             IF l_syc[li_i].syc05 != "zaa_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 報表頭 zaa_file
                DATABASE ds
                LET l_sql = "SELECT * FROM zaa_file WHERE zaa01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zaa10 = 'N'"
                PREPARE zaa_pre FROM l_sql
                DECLARE zaa_curs CURSOR FOR zaa_pre
                LET l_cnt = 1
                CALL lr_zaa.clear()
                FOREACH zaa_curs INTO lr_zaa[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zaa.deleteElement(l_cnt)
                IF lr_zaa.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaa.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zaa.getLength()
                   INSERT INTO zaa_file VALUES(lr_zaa[l_cnt].*)
# 因為包區間有打包全部zaa_file，所以暫時忽略此錯誤，等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
# -----------------------------------------------------------------------------
                END FOR
                CLOSE DATABASE

                # 報表備註 zab_file
                DATABASE ds
                LET l_sql = "SELECT * FROM zab_file",
                            " WHERE zab01 = (SELECT UNIQUE zaa08 FROM zaa_file ",
                            " WHERE zaa01 = '",l_syc[li_i].syc06 CLIPPED,"'",
                            "   AND (zaa14 = 'H' OR zaa14 = 'J'))"
                        
                PREPARE zab_pre FROM l_sql
                DECLARE zab_curs CURSOR FOR zab_pre
                LET l_cnt = 1
                CALL lr_zab.clear()
                FOREACH zab_curs INTO lr_zab[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zab.deleteElement(l_cnt)
                IF lr_zab.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zab_file 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zab_file 抓到 ",lr_zab.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zab.getLength()
                   INSERT INTO zab_file VALUES(lr_zab[l_cnt].*)
# 因為包區間有打包全部zab_file，所以暫時忽略此錯誤，等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," zab_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
# -----------------------------------------------------------------------------
                END FOR
                CLOSE DATABASE

                # 報表連查 zad_file 2006/04/14 --start--
                IF g_ver_main NOT MATCHES '1*' THEN
                   DATABASE ds
                   LET l_sql = "SELECT * FROM zad_file WHERE zad01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zad05 = 'N'"
                   PREPARE zad_pre FROM l_sql
                   DECLARE zad_curs CURSOR FOR zad_pre
                   LET l_cnt = 1
                   CALL lr_zad.clear()
                   FOREACH zad_curs INTO lr_zad[l_cnt].*
                      IF SQLCA.sqlcode THEN
                         EXIT FOREACH
                      END IF
                      LET l_cnt = l_cnt + 1
                   END FOREACH
                   CALL lr_zad.deleteElement(l_cnt)
                   IF lr_zad.getLength() <= 0 THEN
                      DISPLAY "BugNo.",p_zl08 CLIPPED," zad_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                   ELSE
                      DISPLAY "BugNo.",p_zl08 CLIPPED," zad_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zad.getLength(),"筆資料"
                   END IF
                   CLOSE DATABASE
                   IF g_db_type = "ORA" THEN
                      DATABASE patchtemp
                   ELSE
                      DATABASE patchtemp@gp3x_tiptop
                   END IF
                   FOR l_cnt = 1 TO lr_zad.getLength()
                      INSERT INTO zad_file VALUES(lr_zad[l_cnt].*)
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," zad_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END FOR
                   CLOSE DATABASE

                   DATABASE ds
                   LET g_zae_where = ""
                   LET l_sql = "SELECT zad10 FROM zad_file",
                               " WHERE zad01 ='",l_syc[li_i].syc06,"' ",
                               "   AND zad05 = 'N' AND zad09 = '2'"
                   PREPARE zae_zad_pre FROM l_sql
                   DECLARE zae_zad_curs CURSOR FOR zae_zad_pre
                   FOREACH zae_zad_curs INTO lc_zad10
                      IF SQLCA.sqlcode THEN
                         EXIT FOREACH
                      END IF
                      LET g_zae_cnt = 1
                      CALL p_zl_unload_zae_file(lc_zad10)
                   END FOREACH
                   LET g_zae_where = g_zae_where.subString(1,g_zae_where.getLength() - 3)
                   LET l_sql = "SELECT * FROM zae_file WHERE ",g_zae_where
                   PREPARE zae_pre FROM l_sql
                   DECLARE zae_curs CURSOR FOR zae_pre
                   LET l_cnt = 1
                   CALL lr_zae.clear()
                   FOREACH zae_curs INTO lr_zae[l_cnt].*
                      IF SQLCA.sqlcode THEN
                         EXIT FOREACH
                      END IF
                      LET l_cnt = l_cnt + 1
                   END FOREACH
                   CALL lr_zae.deleteElement(l_cnt)
                   IF lr_zae.getLength() <= 0 THEN
                      DISPLAY "BugNo.",p_zl08 CLIPPED," zae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                   ELSE
                      DISPLAY "BugNo.",p_zl08 CLIPPED," zae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zae.getLength(),"筆資料"
                   END IF
                   CLOSE DATABASE
                   IF g_db_type = "ORA" THEN
                      DATABASE patchtemp
                   ELSE
                      DATABASE patchtemp@gp3x_tiptop
                   END IF
                   FOR l_cnt = 1 TO lr_zae.getLength()
                      INSERT INTO zae_file VALUES(lr_zae[l_cnt].*)
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," zae_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END FOR
                   CLOSE DATABASE
                 END IF
                 # 2006/04/14 ---end---

             END IF
          WHEN "J"
             IF l_syc[li_i].syc05 != "gao_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gao_file WHERE gao01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gao_pre FROM l_sql
                DECLARE gao_curs CURSOR FOR gao_pre
                LET l_cnt = 1
                CALL lr_gao.clear()
                FOREACH gao_curs INTO lr_gao[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gao.deleteElement(l_cnt)
                IF lr_gao.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gao.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gao.getLength()
                   INSERT INTO gao_file VALUES(lr_gao[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          # 2005/10/03 --start-- By saki 增加Table
          WHEN "K"
             IF l_syc[li_i].syc05 != "gba_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # SOP單頭檔
                DATABASE ds
                LET l_sql = "SELECT * FROM gba_file WHERE gba01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gba_pre FROM l_sql
                DECLARE gba_curs CURSOR FOR gba_pre
                LET l_cnt = 1
                CALL lr_gba.clear()
                FOREACH gba_curs INTO lr_gba[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gba.deleteElement(l_cnt)
                IF lr_gba.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gba.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gba.getLength()
                   INSERT INTO gba_file VALUES(lr_gba[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                # SOP單身檔
                DATABASE ds
                LET l_sql = "SELECT * FROM gbb_file WHERE gbb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gbb_pre FROM l_sql
                DECLARE gbb_curs CURSOR FOR gbb_pre
                LET l_cnt = 1
                CALL lr_gbb.clear()
                FOREACH gbb_curs INTO lr_gbb[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbb.deleteElement(l_cnt)
                IF lr_gbb.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbb.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gbb.getLength()
                   INSERT INTO gbb_file VALUES(lr_gbb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "L"
             IF l_syc[li_i].syc05 != "gax_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gax_file WHERE gax01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gax05 = 'N'"
                PREPARE gax_pre FROM l_sql
                DECLARE gax_curs CURSOR FOR gax_pre
                LET l_cnt = 1
                CALL lr_gax.clear()
                FOREACH gax_curs INTO lr_gax[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gax.deleteElement(l_cnt)
                IF lr_gax.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gax.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gax.getLength()
                   INSERT INTO gax_file VALUES(lr_gax[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "M"
             IF l_syc[li_i].syc05 != "gbf_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM gbf_file WHERE gbf01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gbf_pre FROM l_sql
                DECLARE gbf_curs CURSOR FOR gbf_pre
                LET l_cnt = 1
                CALL lr_gbf.clear()
                FOREACH gbf_curs INTO lr_gbf[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbf.deleteElement(l_cnt)
                IF lr_gbf.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbf.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_gbf.getLength()
                   INSERT INTO gbf_file VALUES(lr_gbf[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          # 2005/10/03 ---end---
          # 2006/09/22 --start--
          WHEN "N"
             IF l_syc[li_i].syc05 != "wca_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM wca_file WHERE wca01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wca_pre FROM l_sql
                DECLARE wca_curs CURSOR FOR wca_pre
                LET l_cnt = 1
                CALL lr_wca.clear()
                FOREACH wca_curs INTO lr_wca[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wca.deleteElement(l_cnt)
                IF lr_wca.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wca.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wca.getLength()
                   INSERT INTO wca_file VALUES(lr_wca[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                DATABASE ds
                LET l_sql = "SELECT * FROM wcb_file WHERE wcb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcb_pre FROM l_sql
                DECLARE wcb_curs CURSOR FOR wcb_pre
                LET l_cnt = 1
                CALL lr_wcb.clear()
                FOREACH wcb_curs INTO lr_wcb[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcb.deleteElement(l_cnt)
                IF lr_wcb.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcb.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wcb.getLength()
                   INSERT INTO wcb_file VALUES(lr_wcb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                DATABASE ds
                LET l_sql = "SELECT * FROM wcc_file WHERE wcc01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcc_pre FROM l_sql
                DECLARE wcc_curs CURSOR FOR wcc_pre
                LET l_cnt = 1
                CALL lr_wcc.clear()
                FOREACH wcc_curs INTO lr_wcc[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcc.deleteElement(l_cnt)
                IF lr_wcc.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcc.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wcc.getLength()
                   INSERT INTO wcc_file VALUES(lr_wcc[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "O"
             IF l_syc[li_i].syc05 != "wcd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM wcd_file WHERE wcd01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcd_pre FROM l_sql
                DECLARE wcd_curs CURSOR FOR wcd_pre
                LET l_cnt = 1
                CALL lr_wcd.clear()
                FOREACH wcd_curs INTO lr_wcd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcd.deleteElement(l_cnt)
                IF lr_wcd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcd.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wcd.getLength()
                   INSERT INTO wcd_file VALUES(lr_wcd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          # 2006/09/22 ---end---

          #FUN-730071 ---start---
          WHEN "P"
             IF l_syc[li_i].syc05 != "zaw_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM zaw_file WHERE zaw01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE zaw_pre FROM l_sql
                DECLARE zaw_curs CURSOR FOR zaw_pre
                LET l_cnt = 1
                CALL lr_zaw.clear()
                FOREACH zaw_curs INTO lr_zaw[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zaw.deleteElement(l_cnt)
                IF lr_zaw.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaw.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zaw.getLength()
                   INSERT INTO zaw_file VALUES(lr_zaw[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          #FUN-730071 ---end---
          #No:FUN-740054 --start--
          WHEN "Q"
             IF l_syc[li_i].syc05 != "zai_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                #自定義查詢設定主頁
                DATABASE ds
                LET l_sql = "SELECT * FROM zai_file WHERE zai01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zai05 = 'N'"
                PREPARE zai_pre FROM l_sql
                DECLARE zai_curs CURSOR FOR zai_pre
                LET l_cnt = 1
                CALL lr_zai.clear()
                FOREACH zai_curs INTO lr_zai[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zai.deleteElement(l_cnt)
                IF lr_zai.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zai.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zai.getLength()
                   INSERT INTO zai_file VALUES(lr_zai[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義執行query前應執行的process
                DATABASE ds
                LET l_sql = "SELECT * FROM zaj_file WHERE zaj01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zaj07 = 'N'"
                PREPARE zaj_pre FROM l_sql
                DECLARE zaj_curs CURSOR FOR zaj_pre
                LET l_cnt = 1
                CALL lr_zaj.clear()
                FOREACH zaj_curs INTO lr_zaj[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zaj.deleteElement(l_cnt)
                IF lr_zaj.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaj.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zaj.getLength()
                   INSERT INTO zaj_file VALUES(lr_zaj[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zaj_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義設定查詢的sql
                DATABASE ds
                LET l_sql = "SELECT * FROM zak_file WHERE zak01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zak07 = 'N'"
                PREPARE zak_pre FROM l_sql
                DECLARE zak_curs CURSOR FOR zak_pre
                LET l_cnt = 1
                CALL lr_zak.clear()
                FOREACH zak_curs INTO lr_zak[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zak.deleteElement(l_cnt)
                IF lr_zak.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zak_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zak_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zak.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zak.getLength()
                   INSERT INTO zak_file VALUES(lr_zak[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zak_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #設定SQL欄位資料
                DATABASE ds
                LET l_sql = "SELECT * FROM zal_file WHERE zal01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zal07 = 'N'"
                PREPARE zal_pre FROM l_sql
                DECLARE zal_curs CURSOR FOR zal_pre
                LET l_cnt = 1
                CALL lr_zal.clear()
                FOREACH zal_curs INTO lr_zal[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zal.deleteElement(l_cnt)
                IF lr_zal.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zal.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zal.getLength()
                   INSERT INTO zal_file VALUES(lr_zal[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zal_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義查詢分群(Group)
                DATABASE ds
                LET l_sql = "SELECT * FROM zam_file WHERE zam01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zam09 = 'N'"
                PREPARE zam_pre FROM l_sql
                DECLARE zam_curs CURSOR FOR zam_pre
                LET l_cnt = 1
                CALL lr_zam.clear()
                FOREACH zam_curs INTO lr_zam[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zam.deleteElement(l_cnt)
                IF lr_zam.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zam_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zam_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zam.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zam.getLength()
                   INSERT INTO zam_file VALUES(lr_zam[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zam_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義查詢計算(Sum)
                DATABASE ds
                LET l_sql = "SELECT * FROM zan_file WHERE zan01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zan08= 'N'"
                PREPARE zan_pre FROM l_sql
                DECLARE zan_curs CURSOR FOR zan_pre
                LET l_cnt = 1
                CALL lr_zan.clear()
                FOREACH zan_curs INTO lr_zan[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zan.deleteElement(l_cnt)
                IF lr_zan.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zan.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zan.getLength()
                   INSERT INTO zan_file VALUES(lr_zan[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zan_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義查詢輸出格式(Layout)
                DATABASE ds
                LET l_sql = "SELECT * FROM zao_file WHERE zao01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zao05 = 'N'"
                PREPARE zao_pre FROM l_sql
                DECLARE zao_curs CURSOR FOR zao_pre
                LET l_cnt = 1
                CALL lr_zao.clear()
                FOREACH zao_curs INTO lr_zao[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zao.deleteElement(l_cnt)
                IF lr_zao.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zao_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zao_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zao.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zao.getLength()
                   INSERT INTO zao_file VALUES(lr_zao[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zao_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #定義查詢 output
                DATABASE ds
                LET l_sql = "SELECT * FROM zap_file WHERE zap01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zap07 = 'N'"
                PREPARE zap_pre FROM l_sql
                DECLARE zap_curs CURSOR FOR zap_pre
                LET l_cnt = 1
                CALL lr_zap.clear()
                FOREACH zap_curs INTO lr_zap[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zap.deleteElement(l_cnt)
                IF lr_zap.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zap_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zap_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zap.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zap.getLength()
                   INSERT INTO zap_file VALUES(lr_zap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zap_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #SQL Wizard  Table 記錄檔
                DATABASE ds
                LET l_sql = "SELECT * FROM zaq_file WHERE zaq01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zaq05 = 'N'"
                PREPARE zaq_pre FROM l_sql
                DECLARE zaq_curs CURSOR FOR zaq_pre
                LET l_cnt = 1
                CALL lr_zaq.clear()
                FOREACH zaq_curs INTO lr_zaq[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zaq.deleteElement(l_cnt)
                IF lr_zaq.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaq_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaq_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaq.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zaq.getLength()
                   INSERT INTO zaq_file VALUES(lr_zaq[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zaq_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #SQL Wizard  Field 記錄檔
                DATABASE ds
                LET l_sql = "SELECT * FROM zar_file WHERE zar01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zar05 = 'N'"
                PREPARE zar_pre FROM l_sql
                DECLARE zar_curs CURSOR FOR zar_pre
                LET l_cnt = 1
                CALL lr_zar.clear()
                FOREACH zar_curs INTO lr_zar[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zar.deleteElement(l_cnt)
                IF lr_zar.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zar_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zar_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zar.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zar.getLength()
                   INSERT INTO zar_file VALUES(lr_zar[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zar_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #SQL Wizard 條件式記錄檔
                DATABASE ds
                LET l_sql = "SELECT * FROM zas_file WHERE zas01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zas11 = 'N'"
                PREPARE zas_pre FROM l_sql
                DECLARE zas_curs CURSOR FOR zas_pre
                LET l_cnt = 1
                CALL lr_zas.clear()
                FOREACH zas_curs INTO lr_zas[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zas.deleteElement(l_cnt)
                IF lr_zas.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zas_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zas_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zas.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zas.getLength()
                   INSERT INTO zas_file VALUES(lr_zas[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zas_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #動態查詢參數設定檔案
                DATABASE ds
                LET l_sql = "SELECT * FROM zat_file WHERE zat01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zat10 = 'N'"
                PREPARE zat_pre FROM l_sql
                DECLARE zat_curs CURSOR FOR zat_pre
                LET l_cnt = 1
                CALL lr_zat.clear()
                FOREACH zat_curs INTO lr_zat[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zat.deleteElement(l_cnt)
                IF lr_zat.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zat_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zat_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zat.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zat.getLength()
                   INSERT INTO zat_file VALUES(lr_zat[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zat_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #自定義查詢權限設定檔
                DATABASE ds
                LET l_sql = "SELECT * FROM zau_file WHERE zau01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zau04 = 'N'"
                PREPARE zau_pre FROM l_sql
                DECLARE zau_curs CURSOR FOR zau_pre
                LET l_cnt = 1
                CALL lr_zau.clear()
                FOREACH zau_curs INTO lr_zau[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zau.deleteElement(l_cnt)
                IF lr_zau.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zau_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zau_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zau.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zau.getLength()
                   INSERT INTO zau_file VALUES(lr_zau[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zau_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
                #自定義動態查詢設定檔
                DATABASE ds
                LET l_sql = "SELECT * FROM zav_file WHERE zav01 = '2' AND zav02 = '",l_syc[li_i].syc06 CLIPPED,"' AND zav04 = 'N'"
                PREPARE zav_Q_pre FROM l_sql
                DECLARE zav_Q_curs CURSOR FOR zav_Q_pre
                LET l_cnt = 1
                CALL lr_zav.clear()
                FOREACH zav_Q_curs INTO lr_zav[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zav.deleteElement(l_cnt)
                IF lr_zav.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zav_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zav_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zav.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_zav.getLength()
                   INSERT INTO zav_file VALUES(lr_zav[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zav_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          WHEN "R"
             IF l_syc[li_i].syc05 != "wsm_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                DATABASE ds
                LET l_sql = "SELECT * FROM wsm_file WHERE wsm01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsm_pre FROM l_sql
                DECLARE wsm_curs CURSOR FOR wsm_pre
                LET l_cnt = 1
                CALL lr_wsm.clear()
                FOREACH wsm_curs INTO lr_wsm[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsm.deleteElement(l_cnt)
                IF lr_wsm.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsm.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wsm.getLength()
                   INSERT INTO wsm_file VALUES(lr_wsm[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                DATABASE ds
                LET l_sql = "SELECT * FROM wsn_file WHERE wsn01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsn_pre FROM l_sql
                DECLARE wsn_curs CURSOR FOR wsn_pre
                LET l_cnt = 1
                CALL lr_wsn.clear()
                FOREACH wsn_curs INTO lr_wsn[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsn.deleteElement(l_cnt)
                IF lr_wsn.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsn_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsn_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsn.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wsn.getLength()
                   INSERT INTO wsn_file VALUES(lr_wsn[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsn_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                DATABASE ds
                LET l_sql = "SELECT * FROM wso_file WHERE wso01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wso_pre FROM l_sql
                DECLARE wso_curs CURSOR FOR wso_pre
                LET l_cnt = 1
                CALL lr_wso.clear()
                FOREACH wso_curs INTO lr_wso[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wso.deleteElement(l_cnt)
                IF lr_wso.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wso_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wso_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wso.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wso.getLength()
                   INSERT INTO wso_file VALUES(lr_wso[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wso_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE

                DATABASE ds
                LET l_sql = "SELECT * FROM wsp_file WHERE wsp01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsp_pre FROM l_sql
                DECLARE wsp_curs CURSOR FOR wsp_pre
                LET l_cnt = 1
                CALL lr_wsp.clear()
                FOREACH wsp_curs INTO lr_wsp[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsp.deleteElement(l_cnt)
                IF lr_wsp.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsp_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsp_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsp.getLength(),"筆資料"
                END IF
                CLOSE DATABASE
                IF g_db_type = "ORA" THEN
                   DATABASE patchtemp
                ELSE
                   DATABASE patchtemp@gp3x_tiptop
                END IF
                FOR l_cnt = 1 TO lr_wsp.getLength()
                   INSERT INTO wsp_file VALUES(lr_wsp[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsp_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
                CLOSE DATABASE
             END IF
          #No:FUN-740054 ---end---
       END CASE
   END FOR
END FUNCTION

FUNCTION pack_delete_patchdb_data()

   IF g_db_type = "ORA" THEN
      DATABASE patchtemp
   ELSE
      DATABASE patchtemp@gp3x_tiptop
   END IF
   IF STATUS THEN
      DISPLAY 'Connect temp db error~'
      EXIT PROGRAM
   END IF
   #No:TQC-730063 --start--
   IF g_db_type = "ORA" THEN
      DELETE FROM patchtemp.ze_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp ze_file error!"
      END IF
      DELETE FROM patchtemp.zz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zz_file error!"
      END IF
      DELETE FROM patchtemp.zm_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zm_file error!"
      END IF
      DELETE FROM patchtemp.gap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gap_file error!"
      END IF
      DELETE FROM patchtemp.gbd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbd_file error!"
      END IF
      DELETE FROM patchtemp.gae_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gae_file error!"
      END IF
      DELETE FROM patchtemp.gak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gak_file error!"
      END IF
      DELETE FROM patchtemp.gal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gal_file error!"
      END IF
      DELETE FROM patchtemp.gaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gaq_file error!"
      END IF
      DELETE FROM patchtemp.gab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gab_file error!"
      END IF
      DELETE FROM patchtemp.gac_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gac_file error!"
      END IF
      DELETE FROM patchtemp.gav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gav_file error!"
      END IF
      DELETE FROM patchtemp.gat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gat_file error!"
      END IF
      DELETE FROM patchtemp.gaz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gaz_file error!"
      END IF
      DELETE FROM patchtemp.wsa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsa_file error!"
      END IF
      DELETE FROM patchtemp.wsb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsb_file error!"
      END IF
      DELETE FROM patchtemp.zaa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zaa_file error!"
      END IF
      DELETE FROM patchtemp.zab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zab_file error!"
      END IF
      DELETE FROM patchtemp.gao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gao_file error!"
      END IF
      # 2005/10/06 --start-- By saki 增加Table
      DELETE FROM patchtemp.gba_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gba_file error!"
      END IF
      DELETE FROM patchtemp.gbb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbb_file error!"
      END IF
      DELETE FROM patchtemp.gax_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gax_file error!"
      END IF
      DELETE FROM patchtemp.gbf_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbf_file error!"
      END IF
      # 2005/10/06 ---end---
      #No:FUN-740054 --start--
      DELETE FROM patchtemp.wsm_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsm_file error!"
      END IF
      DELETE FROM patchtemp.wsn_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsn_file error!"
      END IF
      DELETE FROM patchtemp.wso_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wso_file error!"
      END IF
      DELETE FROM patchtemp.wsp_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsp_file error!"
      END IF
      #No:FUN-740054 ---end---
      # 2006/04/14 --start-- By saki 增加Table
      IF g_ver_main NOT MATCHES '1*' THEN
         DELETE FROM patchtemp.zad_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zad_file error!"
         END IF
         DELETE FROM patchtemp.zae_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zae_file error!"
         END IF
      END IF
      # 2006/04/14 ---end---
      # 2006/09/22 --start--
#     IF g_ver_main = '5.0' OR g_ver_main = '3.5' THEN
         DELETE FROM patchtemp.wca_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wca_file error!"
         END IF
         DELETE FROM patchtemp.wcb_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcb_file error!"
         END IF
         DELETE FROM patchtemp.wcc_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcc_file error!"
         END IF
         DELETE FROM patchtemp.wcd_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcd_file error!"
         END IF
        #FUN-730071 ---start---   
         DELETE FROM patchtemp.zaw_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaw_file error!"
         END IF
        #FUN-730071 ---end---   
         #No:TQC-740038 --start--
         DELETE FROM patchtemp.zav_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zav_file error!"
         END IF
         #No:TQC-740038 ---end---
         #No:FUN-740054 --start--
         DELETE FROM patchtemp.zai_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zai_file error!"
         END IF
         DELETE FROM patchtemp.zaj_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaj_file error!"
         END IF
         DELETE FROM patchtemp.zak_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zak_file error!"
         END IF
         DELETE FROM patchtemp.zal_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zal_file error!"
         END IF
         DELETE FROM patchtemp.zam_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zam_file error!"
         END IF
         DELETE FROM patchtemp.zan_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zan_file error!"
         END IF
         DELETE FROM patchtemp.zao_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zao_file error!"
         END IF
         DELETE FROM patchtemp.zap_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zap_file error!"
         END IF
         DELETE FROM patchtemp.zaq_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaq_file error!"
         END IF
         DELETE FROM patchtemp.zar_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zar_file error!"
         END IF
         DELETE FROM patchtemp.zas_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zas_file error!"
         END IF
         DELETE FROM patchtemp.zat_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zat_file error!"
         END IF
         DELETE FROM patchtemp.zau_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zau_file error!"
         END IF
         #No:FUN-740054 ---end---
#     END IF
      # 2006/09/22 ---end---
   ELSE
      DELETE FROM patchtemp:ze_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp ze_file error!"
      END IF
      DELETE FROM patchtemp:zz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zz_file error!"
      END IF
      DELETE FROM patchtemp:zm_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zm_file error!"
      END IF
      DELETE FROM patchtemp:gap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gap_file error!"
      END IF
      DELETE FROM patchtemp:gbd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbd_file error!"
      END IF
      DELETE FROM patchtemp:gae_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gae_file error!"
      END IF
      DELETE FROM patchtemp:gak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gak_file error!"
      END IF
      DELETE FROM patchtemp:gal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gal_file error!"
      END IF
      DELETE FROM patchtemp:gaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gaq_file error!"
      END IF
      DELETE FROM patchtemp:gab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gab_file error!"
      END IF
      DELETE FROM patchtemp:gac_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gac_file error!"
      END IF
      DELETE FROM patchtemp:gav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gav_file error!"
      END IF
      DELETE FROM patchtemp:gat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gat_file error!"
      END IF
      DELETE FROM patchtemp:gaz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gaz_file error!"
      END IF
      DELETE FROM patchtemp:wsa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsa_file error!"
      END IF
      DELETE FROM patchtemp:wsb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsb_file error!"
      END IF
      DELETE FROM patchtemp:zaa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zaa_file error!"
      END IF
      DELETE FROM patchtemp:zab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp zab_file error!"
      END IF
      DELETE FROM patchtemp:gao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gao_file error!"
      END IF
      # 2005/10/06 --start-- By saki 增加Table
      DELETE FROM patchtemp:gba_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gba_file error!"
      END IF
      DELETE FROM patchtemp:gbb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbb_file error!"
      END IF
      DELETE FROM patchtemp:gax_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gax_file error!"
      END IF
      DELETE FROM patchtemp:gbf_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp gbf_file error!"
      END IF
      # 2005/10/06 ---end---
      #No:FUN-740054 --start--
      DELETE FROM patchtemp:wsm_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsm_file error!"
      END IF
      DELETE FROM patchtemp:wsn_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsn_file error!"
      END IF
      DELETE FROM patchtemp:wso_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wso_file error!"
      END IF
      DELETE FROM patchtemp:wsp_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_patchtemp wsp_file error!"
      END IF
      #No:FUN-740054 ---end---
      # 2006/04/14 --start-- By saki 增加Table
      IF g_ver_main NOT MATCHES '1*' THEN
         DELETE FROM patchtemp:zad_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zad_file error!"
         END IF
         DELETE FROM patchtemp:zae_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zae_file error!"
         END IF
      END IF
      # 2006/04/14 ---end---
      # 2006/09/22 --start--
#     IF g_ver_main = '5.0' OR g_ver_main = '3.5' THEN
         DELETE FROM patchtemp:wca_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wca_file error!"
         END IF
         DELETE FROM patchtemp:wcb_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcb_file error!"
         END IF
         DELETE FROM patchtemp:wcc_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcc_file error!"
         END IF
         DELETE FROM patchtemp:wcd_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp wcd_file error!"
         END IF
        #FUN-730071 ---start---   
         DELETE FROM patchtemp:zaw_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaw_file error!"
         END IF
        #FUN-730071 ---end---   
         #No:TQC-740038 --start--
         DELETE FROM patchtemp:zav_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zav_file error!"
         END IF
         #No:TQC-740038 ---end---
         #No:FUN-740054 --start--
         DELETE FROM patchtemp:zai_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zai_file error!"
         END IF
         DELETE FROM patchtemp:zaj_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaj_file error!"
         END IF
         DELETE FROM patchtemp:zak_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zak_file error!"
         END IF
         DELETE FROM patchtemp:zal_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zal_file error!"
         END IF
         DELETE FROM patchtemp:zam_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zam_file error!"
         END IF
         DELETE FROM patchtemp:zan_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zan_file error!"
         END IF
         DELETE FROM patchtemp:zao_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zao_file error!"
         END IF
         DELETE FROM patchtemp:zap_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zap_file error!"
         END IF
         DELETE FROM patchtemp:zaq_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zaq_file error!"
         END IF
         DELETE FROM patchtemp:zar_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zar_file error!"
         END IF
         DELETE FROM patchtemp:zas_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zas_file error!"
         END IF
         DELETE FROM patchtemp:zat_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zat_file error!"
         END IF
         DELETE FROM patchtemp:zau_file
         IF SQLCA.sqlcode THEN
            DISPLAY "delete db_patchtemp zau_file error!"
         END IF
         #No:FUN-740054 ---end---
#     END IF
      # 2006/09/22 ---end---
   END IF
   #No:TQC-730063 ---end---
   
END FUNCTION

FUNCTION pack_mk_patch_shell(p_str)
   DEFINE   p_str         STRING
   DEFINE   p_ver         STRING
   DEFINE   l_temp_path   STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_str        STRING
   DEFINE   l_cmd         STRING


   LET l_temp_path = FGL_GETENV("TEMPDIR")

   LET lc_channel = base.Channel.create()
   LET l_cmd = "rm ",l_temp_path CLIPPED,"/patch_",p_str,".sh 2>/dev/null"
   RUN l_cmd
   LET ls_str = l_temp_path CLIPPED,"/patch_",p_str,".sh"
   CALL lc_channel.openFile(ls_str,"w")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("#!/bin/ksh")
   LET ls_str = "tar xvf patch_",p_str,".tar"
   CALL lc_channel.write(ls_str)
   LET ls_str = "cd patch_",p_str
   CALL lc_channel.write(ls_str)
   LET ls_str = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev;export FGLDIR"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fglcomp patch.4gl"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fgl2p -o patch.42r patch.42m"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fglcomp patch_load_data.4gl"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fgl2p -o patch_load_data.42r patch_load_data.42m"
   CALL lc_channel.write(ls_str)
   IF (g_bug_flag) THEN
      LET ls_str = "echo '是否要進行lib,sub,qry共用模組的rebuild?(y/n 預設為n)'"
      CALL lc_channel.write(ls_str)
      LET ls_str = "read do_rebuild"
      CALL lc_channel.write(ls_str)
      LET ls_str = "$FGLRUN patch.42r ",p_str," $do_rebuild ",g_ver_main  # 2006/04/14
      CALL lc_channel.write(ls_str)
   ELSE
      LET ls_str = "$FGLRUN patch.42r ",p_str," 'Y' ",g_ver_main          # 2006/04/14
      CALL lc_channel.write(ls_str)
   END IF
   LET ls_str = "cd ../"
   CALL lc_channel.write(ls_str)
   LET ls_str = "rm -rf patch_",p_str
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   LET l_cmd = "chmod 777 ",g_temp_path,"/patch_",p_str,".sh"
   RUN l_cmd
      
END FUNCTION

#升級報表功能
FUNCTION p_zl_pack_alldata()
   DEFINE l_sql   STRING
   DEFINE l_cnt   INTEGER
   DEFINE lr_gaq  RECORD LIKE gaq_file.*
   DEFINE lr_zaa  RECORD LIKE zaa_file.*
   DEFINE lr_zab  RECORD LIKE zab_file.*


   DISPLAY "打包共用資料中，會花費一段長久的時間"

   IF g_db_type = "ORA" THEN
      # 抓取gaq_file資料
      LET l_cnt = 1
      DECLARE gaq_all_curs CURSOR FOR
              SELECT * FROM ds.gaq_file
      FOREACH gaq_all_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF

         INSERT INTO patchtemp.gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.gaq_file "

      # 抓取zaa_file資料
      LET l_cnt = 1
      DECLARE zaa_all_curs CURSOR FOR
              SELECT * FROM ds.zaa_file
      FOREACH zaa_all_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF

         INSERT INTO patchtemp.zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.zaa_file "

      # 抓取zab_file資料
      LET l_cnt = 1
      DECLARE zab_all_curs CURSOR FOR
              SELECT * FROM ds.zab_file
      FOREACH zab_all_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         INSERT INTO patchtemp.zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.zab_file "
   ELSE
      # 抓取gaq_file資料
      LET l_cnt = 1
      DECLARE gaq_all_i_curs CURSOR FOR
              SELECT * FROM ds:gaq_file
      FOREACH gaq_all_i_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF

         INSERT INTO patchtemp:gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.gaq_file "

      # 抓取zaa_file資料
      LET l_cnt = 1
      DECLARE zaa_all_i_curs CURSOR FOR
              SELECT * FROM ds:zaa_file
      FOREACH zaa_all_i_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF

         INSERT INTO patchtemp:zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.zaa_file "

      # 抓取zab_file資料
      LET l_cnt = 1
      DECLARE zab_all_i_curs CURSOR FOR
              SELECT * FROM ds:zab_file
      FOREACH zab_all_i_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         INSERT INTO patchtemp:zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      DISPLAY "LOAD ",l_cnt -1 ,"筆資料到patchtemp.zab_file "
   END IF

   DISPLAY "打包共用資料結束"
END FUNCTION

# 2005/11/01 --start--
FUNCTION pack_show_testing_bugno()
   DEFINE   li_result   SMALLINT
   DEFINE   lr_bugno    DYNAMIC ARRAY OF RECORD
               status   STRING,
               bugno    VARCHAR(10),
               testemp  STRING
                        END RECORD
   DEFINE   ls_sql      STRING
   DEFINE   li_cnt      SMALLINT
   DEFINE   lc_zl02     VARCHAR(5)
   DEFINE   lc_zl30     VARCHAR(10)
   DEFINE   lc_gen02    VARCHAR(8)
   DEFINE   l_ds4gl_path   STRING
   DEFINE   l_str       STRING

   LET ls_sql = "SELECT zl02,zl08,zl30 FROM zl_file WHERE zl02 = '6'"
   PREPARE testbug_pre FROM ls_sql
   DECLARE testbug_curs CURSOR FOR testbug_pre
  
   CALL lr_bugno.clear()
   LET li_cnt = 1 
   FOREACH testbug_curs INTO lc_zl02,lr_bugno[li_cnt].bugno,lc_zl30
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF

      LET lr_bugno[li_cnt].status = lc_zl02,".測試中"
      SELECT gen02 INTO lc_gen02 FROM gen_file WHERE gen01=lc_zl30
      LET lr_bugno[li_cnt].testemp = "[",lc_zl30,"]",lc_gen02
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_bugno.deleteElement(li_cnt)

   IF lr_bugno.getLength() > 0 THEN
      LET l_ds4gl_path = FGL_GETENV('DS4GL')
      LET l_str = l_ds4gl_path,"/bin/pack_testno"
      OPEN WINDOW testno_w AT 1,1 WITH FORM l_str

      DISPLAY ARRAY lr_bugno TO s_bug.* ATTRIBUTE(UNBUFFERED)
         ON ACTION accept
            LET li_result = TRUE
            EXIT DISPLAY
         ON ACTION cancel
            LET li_result = FALSE
            EXIT DISPLAY
      END DISPLAY
      CLOSE WINDOW testno_w

      RETURN li_result
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
# 2005/11/01 ---end---

# 2006/04/14 --start--
FUNCTION p_zl_unload_zae_file(p_zae01)
   DEFINE   p_zae01   VARCHAR(10)
   DEFINE   lc_zae10  VARCHAR(10)
   DEFINE   ls_sql    STRING
   DEFINE   li_i      SMALLINT
   DEFINE   li_ins    SMALLINT

   LET li_ins = TRUE
   IF p_zae01 IS NOT NULL THEN
      FOR li_i = 1 TO g_zae01.getLength()
          IF g_zae01[li_i] CLIPPED = p_zae01 CLIPPED THEN
             LET li_ins = FALSE
             EXIT FOR
          END IF
      END FOR
      IF NOT li_ins THEN
         RETURN
      ELSE
         LET g_zae01[g_zae_cnt] = p_zae01
         LET g_zae_cnt = g_zae_cnt + 1
      END IF
      LET g_zae_where = g_zae_where," zae01='",p_zae01,"' OR"
      LET ls_sql = "SELECT zae10 FROM zae_file ",
                   " WHERE zae01 = '",p_zae01,"' AND zae09 = '2'"
      PREPARE unload_zae_pre FROM ls_sql
      DECLARE unload_zae_curs CURSOR FOR unload_zae_pre
      FOREACH unload_zae_curs INTO lc_zae10
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         CALL p_zl_unload_zae_file(lc_zae10)
      END FOREACH
   END IF
END FUNCTION
# 2006/04/14 ---end---
