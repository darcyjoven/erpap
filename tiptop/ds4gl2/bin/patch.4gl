##################################################
# Description  	: Patch 更新
# Date & Author : 2004/09/01 by saki
# Parameter   	: 
# Return   	: 
# Memo        	:
# Modify   	: 2004/12/03 by saki 修改可打包單一BUG單號patch
# Modify        : 2006/04/14 by saki 增加zad_file、zae_file
# Modify        : No:FUN-750075 2007/05/18 by alexstar For AP DB分開環境
# Modify        : No:TQC-820013 2008/02/20 by alexstar 動態抓取temporary tablespace名稱
##################################################
DATABASE ds

DEFINE   gc_channel   base.Channel
DEFINE   g_dir        STRING
DEFINE   g_db_type    CHAR(3)
DEFINE   g_dbs        CHAR(10)
DEFINE   g_top        STRING
DEFINE   g_do_rebuild CHAR(1)
DEFINE   g_ver_main   CHAR(5)          # 2006/04/14

MAIN
   DEFINE   p_str         STRING
   DEFINE   l_str         STRING
   DEFINE   l_result      SMALLINT
   DEFINE   l_result_idx  SMALLINT
   DEFINE   l_dbpath      STRING
   DEFINE   l_cmd         STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_result     STRING
   DEFINE   l_char        CHAR(1)
   DEFINE   li_index      SMALLINT
   DEFINE   l_bug_flag    SMALLINT


   WHENEVER ERROR CONTINUE
   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET g_top = FGL_GETENV("TOP")
   LET p_str = ARG_VAL(1)
   LET g_do_rebuild = ARG_VAL(2)
   LET g_ver_main = ARG_VAL(3)
   LET g_do_rebuild = UPSHIFT(g_do_rebuild)
   IF (g_do_rebuild IS NULL) OR (g_do_rebuild NOT MATCHES '[YN]') THEN
      LET g_do_rebuild = "N"
   END IF
   
   IF p_str IS NULL THEN
      RETURN
   END IF
   LET lc_channel = base.Channel.create()
   LET l_cmd = "pwd"
   CALL lc_channel.openPipe(l_cmd,"r")
   WHILE (lc_channel.read(ls_result))
      LET li_index = ls_result.getIndexOf("patch_",1)
      LET l_str = ls_result.subString(li_index + 6,ls_result.getLength())
      IF l_str != p_str THEN
         DISPLAY 'patch參數錯誤, ex. 041103 or BUG-4A0078'
         RETURN
      END IF
   END WHILE
   CALL lc_channel.close()
   LET g_dir = p_str

   # 判斷是否為BUG單號, 直接執行資料跟程式的更新
   IF ((g_dir.subString(1,3) = "MOD") OR (g_dir.subString(1,3) = "FUN") OR
      (g_dir.subString(1,3) = "CHI") OR (g_dir.subString(1,3) = "EXT") OR
      (g_dir.subString(1,3) = "TQC")) THEN
      LET l_bug_flag = TRUE
   ELSE
      LET l_bug_flag = FALSE
   END IF

   IF (NOT l_bug_flag) THEN
      OPEN WINDOW patch_w AT 1,1 WITH FORM "patch.42f"
      CLOSE WINDOW screen
      DISPLAY l_char TO sel
      INPUT l_char,g_dbs WITHOUT DEFAULTS FROM sel,dbspace
         AFTER FIELD sel
            CALL GET_FLDBUF(sel) RETURNING l_char
         ON ACTION accept
            CALL GET_FLDBUF(sel) RETURNING l_char
            IF NOT (l_char MATCHES "[13456]") THEN
               DISPLAY "無此選項"
            END IF

            IF g_dbs IS NULL THEN
               LET g_dbs="dbs1"
            END IF
            CALL patch(l_char,l_bug_flag)
            CONTINUE INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   ELSE
      IF g_dbs IS NULL THEN
         LET g_dbs="dbs1"
      END IF
      CALL patch("",l_bug_flag)
   END IF
END MAIN

FUNCTION patch(pc_char,ps_bug_flag)
   DEFINE   pc_char       CHAR(1)
   DEFINE   ps_bug_flag   SMALLINT
   DEFINE   ls_module     STRING
   DEFINE   ls_dir        STRING
   DEFINE   ls_prog       STRING
   DEFINE   li_index      SMALLINT
   DEFINE   li_index2     SMALLINT
   DEFINE   li_link_flag  SMALLINT
   DEFINE   lr_module     DYNAMIC ARRAY OF STRING
   DEFINE   lr_prog       DYNAMIC ARRAY OF RECORD
               prog_name  STRING,
               mod_name   STRING
                          END RECORD
   DEFINE   lr_per        DYNAMIC ARRAY OF RECORD
               per_name   STRING,
               mod_name   STRING
                          END RECORD
   DEFINE   li_cnt        INTEGER
   DEFINE   li_cnt2       INTEGER
   DEFINE   li_i          INTEGER
   DEFINE   l_patch_all   SMALLINT
   DEFINE   l_cmd         STRING
   DEFINE   ls_result     SMALLINT
   DEFINE   l_ds4gl       STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_str        STRING


   LET l_ds4gl = FGL_GETENV("DS4GL")

   # qazzaq function - schema produce
#  IF (((pc_char = "1") OR (pc_char = "2")) AND (NOT ps_bug_flag)) THEN
#     LET l_dbpath = FGL_GETENV("FGLDBPATH")
#     LET l_cmd = "cp std.sch ",l_dbpath
#     RUN l_cmd
#     CALL gencmd()
#     CALL patch_index(g_dir)
#     IF g_db_type='IFX' THEN
#        LET l_cmd="$FGLRUN execmd.42m ",g_db_type," ",g_dir
#        RUN l_cmd
#     ELSE
#        LET l_cmd="export FGLPROFILE=$FGLDIR/etc/fglprofile.qaz;$FGLRUN execmd.42m ",g_db_type," ",g_dir,";rm $FGLPROFILE"
#        RUN l_cmd
#     END IF
#     RUN "test -s $TEMPDIR/result" RETURNING l_result
#     IF not l_result THEN
#        DISPLAY '資料庫未更新,程式資料也未更新'
#        RETURN
#     END IF
#      if l_result_idx=0 then
#         display "建立index時發生錯誤, 請查看$TEMPDIR/",g_dir,"下的sqlerr_index.log"
#      end if
#     IF g_db_type="IFX" THEN
#        RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
#     ELSE
#        RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
#     END IF
#  END IF

   # Data upload
   IF (pc_char = "1") OR (pc_char = "3") OR (ps_bug_flag) THEN
      # check 客戶端客製碼是否有值
      DISPLAY "開始更新資料"
      CALL patch_check_cust_data()

      # 若是ORA的話，要export有patchtemp user的profile
      CALL patch_data_start()

      IF g_db_type='IFX' THEN
         LET l_cmd="$FGLRUN patch_load_data.42r ",g_dir," ",g_dbs," ",g_ver_main
         RUN l_cmd
      ELSE
         LET l_cmd="FGLPROFILE=$TEMPDIR/fglprofile.patchtemp;export FGLPROFILE;$FGLRUN patch_load_data.42r ",g_dir," ",g_dbs," ",g_ver_main,";rm $FGLPROFILE"
         RUN l_cmd
      END IF
   END IF

   # Source upload
   IF (pc_char = "1") OR (pc_char = "4") OR (ps_bug_flag) THEN
      #判斷是固定版本程式更新(tiptop.tar)或是區間版本更新(patch_xxxxx_source.tar)
      LET l_cmd = "cd ",g_top,"/patch_",g_dir,";test -s patch_",g_dir,"_source.tar"
      RUN l_cmd RETURNING ls_result
      IF ls_result THEN
         LET l_cmd = "test -s ",g_top,"/tiptop.tar"
         RUN l_cmd RETURNING ls_result
         IF ls_result THEN
            RETURN
         ELSE
            LET l_patch_all = TRUE
         END IF
      ELSE
         LET l_patch_all = FALSE
      END IF

      IF (NOT l_patch_all) THEN
         # 區間版本程式更新
         LET l_cmd = "cp patch_",g_dir,"_source.tar ",g_top,
                     ";cd ",g_top,";tar xvf patch_",g_dir,"_source.tar;rm ",
                      g_top,"/patch_",g_dir,"_source.tar"
         RUN l_cmd

         LET lc_channel = base.Channel.create()
         LET l_cmd = "tar tvf patch_",g_dir,"_source.tar|awk '{print $NF}'"
         CALL lc_channel.openPipe(l_cmd,"r")

         LET li_cnt = 1
         CALL lr_prog.clear()
         WHILE (lc_channel.read(ls_str))
            LET li_index = ls_str.getIndexOf("/",1)
            LET ls_module = ls_str.subString(1,li_index-1)
            IF ls_module.equals("config") THEN
               CONTINUE WHILE
            END IF
            LET li_index2 = ls_str.getIndexOf("/",li_index + 1)
            LET ls_dir = ls_str.subString(li_index+1,li_index2-1)
            LET li_index = ls_str.getIndexOf("." || ls_dir,li_index2 + 1)
            LET ls_prog = ls_str.subString(li_index2+1,li_index -1)
            IF (ls_module IS NULL) OR (ls_dir IS NULL) OR (ls_prog IS NULL) THEN
               CONTINUE WHILE
            END IF
            IF ls_dir = "4gl" THEN
               LET l_cmd = "cd ",g_top,"/",ls_module,"/4gl;r.c2 ",ls_prog
               RUN l_cmd
            END IF
            IF ls_dir = "per" THEN
               LET l_cmd = "cd ",g_top,"/",ls_module,"/per;r.f2 ",ls_prog
               RUN l_cmd
            END IF
            IF ls_dir = "za" THEN
               LET l_cmd = "cd ",g_top,"/",ls_module,"/za;load-za ",ls_prog
               RUN l_cmd
            END IF
            LET lr_prog[li_cnt].prog_name = ls_prog
            LET li_cnt = li_cnt + 1
         END WHILE

         IF g_do_rebuild = "Y" THEN
            CALL patch_rebuild_lib("lib")
            CALL patch_rebuild_lib("sub")
            CALL patch_rebuild_lib("qry")
         END IF

         FOR li_cnt = 1 TO lr_prog.getLength()
             LET l_cmd = "r.l2 ",lr_prog[li_cnt].prog_name
             RUN l_cmd
         END FOR
         CALL lc_channel.close()
      ELSE
         # 固定版本程式更新
         # 解開tiptop.tar到$TOP目錄下
         LET l_cmd = "cd ",g_top,";tar xvf tiptop.tar;cd ",
                     g_top,"/tiptop;mv -f * ../;cd ",g_top,";rm -rfd tiptop"
         RUN l_cmd

         # chmod 檔案目錄
         LET l_cmd = "cd ",g_top,";chmod -R 775 *;chmod -R 777 log p_cron"
         RUN l_cmd

         # rebuild 
         LET lc_channel = base.Channel.create()
         LET l_cmd = "cd $TOP;ls -d a?? g??"
         CALL lc_channel.openPipe(l_cmd,"r")

         LET li_cnt = 1
         CALL lr_module.clear()
         WHILE (lc_channel.read(ls_str))
            LET lr_module[li_cnt] = ls_str
            LET li_cnt = li_cnt + 1
         END WHILE
         CALL lc_channel.close()

         LET li_cnt = 1
         LET li_cnt2= 1
         CALL lr_prog.clear()
         CALL lr_per.clear()
         FOR li_i = 1 TO lr_module.getLength()
             LET lc_channel = base.Channel.create()
             LET l_cmd = "cd ",g_top,"/",lr_module[li_i],"/4gl;ls"
             CALL lc_channel.openPipe(l_cmd,"r")
             WHILE (lc_channel.read(ls_str))
                LET li_index = ls_str.getIndexOf(".4gl",1)
                LET lr_prog[li_cnt].prog_name = ls_str.subString(1,li_index - 1)
                LET lr_prog[li_cnt].mod_name = lr_module[li_i]
                LET li_cnt = li_cnt + 1
             END WHILE
             CALL lc_channel.close()

             LET lc_channel = base.Channel.create()
             LET l_cmd = "cd ",g_top,"/",lr_module[li_i],"/per;ls"
             CALL lc_channel.openPipe(l_cmd,"r")
             WHILE (lc_channel.read(ls_str))
                LET li_index = ls_str.getIndexOf(".per",1)
                LET lr_per[li_cnt2].per_name = ls_str.subString(1,li_index - 1)
                LET lr_per[li_cnt2].mod_name = lr_module[li_i]
                LET li_cnt2 = li_cnt2 + 1
             END WHILE
             CALL lc_channel.close()
         END FOR

         # r.c2 package program
         FOR li_i = 1 TO lr_prog.getLength()
             LET l_cmd = "cd ",g_top,"/",lr_prog[li_i].mod_name,"/4gl;r.c2 ",lr_prog[li_i].prog_name
             RUN l_cmd
         END FOR

         # r.c2 r.gx lib sub qry
         CALL patch_rebuild_lib("lib")
         CALL patch_rebuild_lib("sub")
         CALL patch_rebuild_lib("qry")

         # r.l2 package program
         FOR li_i = 1 TO lr_prog.getLength()
             LET l_cmd = "cd ",g_top,"/",lr_prog[li_i].mod_name,"/4gl;r.l2 ",lr_prog[li_i].prog_name
             RUN l_cmd
         END FOR

         # r.f2 package per
         FOR li_i = 1 TO lr_per.getLength()
             LET l_cmd = "cd ",g_top,"/",lr_per[li_i].mod_name,"/per;r.f2 ",lr_per[li_i].per_name
             RUN l_cmd
         END FOR
      END IF
   END IF

   # 將p_link垃圾資料刪除
   IF ((pc_char = "1") OR (pc_char = "5")) AND (NOT ps_bug_flag) THEN
      DISPLAY "開始刪除link垃圾資料"
      CALL patch_delete_link_trash()
   END IF

   # 做r.gfall確保per 相關Table資料欄位沒有null
   IF ((pc_char = "1") OR (pc_char = "6")) AND (NOT ps_bug_flag) THEN
      LET l_cmd = "cp ",g_top,"/patch_",g_dir,"/r.gfall ",
                  l_ds4gl,"/bin/.;r.gfall"
      RUN l_cmd
   END IF

   # 上載結果 
   IF ((pc_char = "1") OR (pc_char = "3")) THEN
      IF (NOT ps_bug_flag) THEN
         DATABASE ds
         IF SQLCA.SQLCODE THEN
            DISPLAY "資料庫切換錯誤,無法切回ds資料庫"
         END IF
      END IF
   
      LET l_cmd= "test -s $TEMPDIR/",g_dir,"/patch_",g_dir,".log" 
      RUN l_cmd RETURNING ls_result
      IF NOT ls_result THEN
         DISPLAY "資料上載到DB時曾產生錯誤, 請查看視窗內容或$TEMPDIR/",g_dir,"下的patch_",g_dir,".log檔"
         MESSAGE "資料上載到DB時曾產生錯誤, 請查看視窗內容或$TEMPDIR/",g_dir,"下的patch_",g_dir,".log檔"
         # 開啟訊息視窗
         CALL patch_view_log()
      ELSE
         DISPLAY "資料上載成功"
         MESSAGE "資料上載成功"
      END IF
      CALL patch_delete_tempdb()
   END IF
   DISPLAY "更新完畢"
   CLOSE WINDOW patch_w
END FUNCTION

FUNCTION patch_check_cust_data()
   DEFINE   li_cnt   SMALLINT


   SELECT COUNT(*) INTO li_cnt FROM gab_file WHERE gab11 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gab_file SET gab11 = 'Y' WHERE gab11 IS NULL AND gab01 MATCHES 'c*'
      UPDATE gab_file SET gab11 = 'N' WHERE gab11 IS NULL AND gab01 NOT MATCHES 'c*'
   END IF

   SELECT COUNT(*) INTO li_cnt FROM gac_file WHERE gac12 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gac_file SET gac12 = 'Y' WHERE gac12 IS NULL AND gac01 MATCHES 'c*'
      UPDATE gac_file SET gac12 = 'N' WHERE gac12 IS NULL AND gac01 NOT MATCHES 'c*'
   END IF

   SELECT COUNT(*) INTO li_cnt FROM gae_file WHERE gae11 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gae_file SET gae11 = 'N' WHERE gae11 IS NULL AND gae01 MATCHES 'cl_*'
      UPDATE gae_file SET gae11 = 'Y' WHERE gae11 IS NULL AND gae01 MATCHES 'c*'
      UPDATE gae_file SET gae11 = 'N' WHERE gae11 IS NULL 
   END IF

   SELECT COUNT(*) INTO li_cnt FROM gav_file WHERE gav08 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gav_file SET gav08 = 'N' WHERE gav08 IS NULL AND gav01 MATCHES 'cl_*'
      UPDATE gav_file SET gav08 = 'Y' WHERE gav08 IS NULL AND gav01 MATCHES 'c*'
      UPDATE gav_file SET gav08 = 'N' WHERE gav08 IS NULL
   END IF

   SELECT COUNT(*) INTO li_cnt FROM gbd_file WHERE gbd07 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gbd_file SET gbd07 = 'N' WHERE gbd07 IS NULL
   END IF

   SELECT COUNT(*) INTO li_cnt FROM gaz_file WHERE gaz05 IS NULL
   IF li_cnt > 0 THEN
      UPDATE gaz_file SET gaz05 = 'Y' WHERE gaz05 IS NULL AND gaz01 MATCHES 'c*'
      UPDATE gaz_file SET gaz05 = 'N' WHERE gaz05 IS NULL AND gaz01 NOT MATCHES 'c*'
   END IF

   UPDATE zaa_file SET zaa17 = "default" WHERE zaa17 IS NULL
END FUNCTION

FUNCTION patch_data_start()
   DEFINE   l_cmd   STRING
   DEFINE   l_sql   STRING
   DEFINE   l_result   SMALLINT
   DEFINE   lc_channel   base.Channel
   DEFINE   l_str        STRING
   DEFINE   l_tempdir     STRING
   DEFINE   readfile_channel   base.Channel


   IF g_db_type = "ORA" THEN
      RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.patchtemp"
      RUN "chmod 777 $TEMPDIR/fglprofile.patchtemp"
      CALL fgl_getenv("TEMPDIR") RETURNING l_str
      LET l_str=l_str CLIPPED,"/fglprofile2.script"
      LET readfile_channel=base.channel.create()
      CALL readfile_channel.setdelimiter("")
      CALL readfile_channel.openfile(l_str CLIPPED, "w" )
      CALL readfile_channel.write("ex $TEMPDIR/fglprofile.patchtemp <<%%")
      CALL readfile_channel.write("g/ds2\.source")
      CALL readfile_channel.write("-1")
      CALL readfile_channel.write("a")
      
      CALL readfile_channel.write('dbi.database.patchtemp.source= "`echo ${ORACLE_SID}`"')
      CALL readfile_channel.write('dbi.database.patchtemp.username= "patchtemp"')
      CALL readfile_channel.write('dbi.database.patchtemp.password= "patchtemp"')
      CALL readfile_channel.write('dbi.database.patchtemp.schema= "patchtemp"')
      CALL readfile_channel.write('dbi.database.patchtemp.ora.prefetch.rows = 1')
      CALL readfile_channel.write("")
      CALL readfile_channel.write(".")
      CALL readfile_channel.write("w")
      CALL readfile_channel.write("q")
      CALL readfile_channel.write("%%")
      CALL readfile_channel.close() 
      RUN "chmod 777 $TEMPDIR/fglprofile2.script"
      RUN "$TEMPDIR/fglprofile2.script"
   END IF

END FUNCTION

FUNCTION patch_delete_link_trash()
   DEFINE   ls_sql   STRING
   DEFINE   lr_gak   RECORD LIKE gak_file.*
   DEFINE   lr_gal   RECORD LIKE gal_file.*
   DEFINE   ls_cmd   STRING
   DEFINE   ls_file  STRING
   DEFINE   li_cnt   SMALLINT
   DEFINE   li_result SMALLINT

   DECLARE gak_curs CURSOR FROM "SELECT * FROM gak_file ORDER BY gak01"
   FOREACH gak_curs INTO lr_gak.*
      IF SQLCA.sqlcode THEN
         DISPLAY "搜尋link資料有問題，不做刪除垃圾資料動作"
         EXIT FOREACH
      END IF

      LET ls_sql = "SELECT * FROM gal_file WHERE gal01 = '",lr_gak.gak01,"' ORDER BY gal01"
      DECLARE gal_curs CURSOR FROM ls_sql
         
      FOREACH gal_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF

         IF lr_gal.gal02[1,1] = "C" OR lr_gal.gal02[1,1] = "c" THEN
            CONTINUE FOREACH
         ELSE
            #安全機制補上
            IF (lr_gal.gal01 = "lib" AND lr_gal.gal02 = "LIB" AND
                (lr_gal.gal03 = "cl_cmdrun" OR lr_gal.gal03 = "cl_contview" OR
                 lr_gal.gal03 = "cl_err3" OR lr_gal.gal03 = "cl_qbe")) OR
               (lr_gal.gal01 = "qry" AND lr_gal.gal02 = "QRY" AND
                (lr_gal.gal03 = "q_contview" OR lr_gal.gal03 = "q_contview2")) OR
               (lr_gal.gal01 = "p_go" AND lr_gal.gal02 = "AZZ" AND
                lr_gal.gal03 = "p_go") THEN
               CONTINUE FOREACH
            ELSE
               LET ls_file = fgl_getenv("TOP") CLIPPED,'/',DOWNSHIFT(lr_gal.gal02) CLIPPED,'/4gl/',lr_gal.gal03 CLIPPED,'.4gl'
            END IF
         END IF

         LET ls_cmd = "test -s ",ls_file
         RUN ls_cmd RETURNING li_result
         IF li_result THEN
            DELETE FROM gal_file WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
         END IF
      END FOREACH

      SELECT COUNT(*) INTO li_cnt FROM gal_file WHERE gal01 = lr_gak.gak01
      IF li_cnt <= 0 THEN
         DELETE FROM gak_file WHERE gak01 = lr_gak.gak01
      END IF
   END FOREACH
END FUNCTION

FUNCTION patch_rebuild_lib(p_dir)
   DEFINE   p_dir        STRING
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_top_path  STRING
   DEFINE   ls_prog      STRING
   DEFINE   ls_path      STRING
   DEFINE   li_s_inx     SMALLINT
   DEFINE   li_e_inx     SMALLINT


   LET ls_top_path = FGL_GETENV('TOP')
   LET lc_channel = base.Channel.create()
   #因為安全機制的程式，所以不能刪
#  LET ls_cmd = "rm -f ",ls_top_path,"/",p_dir,"/42m/*.42m"
#  RUN ls_cmd
   LET ls_cmd = "ls ",ls_top_path,"/",p_dir,"/4gl/*.4gl"
   CALL lc_channel.openPipe(ls_cmd,"r")
   WHILE lc_channel.read(ls_result)
      LET ls_path = ls_top_path,"/",p_dir,"/4gl/"
      LET li_s_inx = ls_path.getLength()
      LET li_e_inx = ls_result.getIndexOf(".4gl",1)
      LET ls_prog = ls_result.subString(li_s_inx + 1,li_e_inx - 1)
      LET ls_cmd = "cd ",ls_top_path,"/",p_dir,"/4gl/;r.c2 ",ls_prog
      RUN ls_cmd
   END WHILE
   CALL lc_channel.close()

   LET ls_cmd = "r.gx ",p_dir
   RUN ls_cmd
END FUNCTION

FUNCTION patch_view_log()
   DEFINE   ls_log_name   STRING
   DEFINE   ls_msg        STRING
   DEFINE   l_cmd         STRING
   DEFINE   ls_temp       STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_result     STRING


   OPEN WINDOW log_view_w AT 1,1 WITH FORM "patch_view.42f"
      ATTRIBUTE(STYLE="dialog")

   LET lc_channel = base.Channel.create()
   LET ls_temp = FGL_GETENV("TEMPDIR")
   LET l_cmd= ls_temp,"/",g_dir,"/patch_",g_dir,".log" 
   CALL lc_channel.openFile(l_cmd,"r")
   WHILE (lc_channel.read(ls_result))
      LET ls_msg = ls_msg,ls_result,'\n'
   END WHILE
   CALL lc_channel.close()

   MENU 
      BEFORE MENU
         DISPLAY ls_msg TO FORMONLY.view_log
      ON ACTION ok
         EXIT MENU
   END MENU

   CLOSE WINDOW log_view_w
END FUNCTION

FUNCTION patch_delete_tempdb()
   DISPLAY "刪除資料暫存的資料庫,依資料庫的大小時間會為之增減,請耐心等候..."
   IF g_db_type='IFX' THEN
      RUN "echo 'drop database patchtemp'|dbaccess > /dev/null 2>&1"
   ELSE
     #RUN "echo 'drop user patchtemp cascade;'|sqlplus '/as sysdba' > /dev/null 2>&1"    #FUN-750075 mark
      RUN "echo 'drop user patchtemp cascade;'|sqlplus system/manager > /dev/null 2>&1"  #FUN-750075
   END IF
END FUNCTION

FUNCTION gencmd()
define readfile_channel   base.channel,
       l_str              char(1000),
       l_right            char(1),
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_command_max      integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       l_command   dynamic array of varchar(1000),
       l_std       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   command char(1000),
                   check  char(1)
                   end record,
       l_cus       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   command char(1000),
                   check  char(1)
                   end record
DEFINE tok     base.StringTokenizer,
       tabn    base.StringTokenizer
DEFINE             l_tmp_name CHAR(20)  #TQC-820013


    IF g_db_type="IFX" THEN
       RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
    ELSE
       RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
    END IF
    RUN "cd $FGLDBPATH;diff ds.sch std.sch >$TEMPDIR/diff.out;chmod 777 $TEMPDIR/diff.out"
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diff.out"
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_cus[l_i].tabname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_cus[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
#display l_cus[l_i].tabname CLIPPED," _>2"
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
#                              FOR x=1 TO 5
#                                  IF l_tabn_chk.a[x,x] matches "[0123456789]" THEN
#display l_cus[l_i].tabname CLIPPED," name error"
#                                     LET l_right='N'
#                                     CONTINUE WHILE
#                                  END IF
#                              END FOR
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='< aps' THEN
#display l_cus[l_i].tabname CLIPPED," not _file or aps"
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_cus[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_cus[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].tabname)
                      LET l_cus[l_i].tabname=l_cus[l_i].tabname[3,l_k]    
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
#已到一個穩定度,暫時拿掉
#    ELSE
#       display l_cus[1].tabname,l_cus[1].fldname,l_cus[1].type,l_cus[1].length,l_cus[1].serial
#       display l_cus[l_cus_max].tabname,l_cus[l_cus_max].fldname,l_cus[l_cus_max].type,l_cus[l_cus_max].length,l_cus[l_cus_max].serial
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diff.out"
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_std[l_i].tabname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_std[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
#display l_std[l_i].tabname CLIPPED," _>2"
                      LET l_right='N'
#                      CONTINUE WHILE 
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
#                              FOR x=1 TO 5
#                                  IF l_tabn_chk.a[x,x] matches "[0123456789]" THEN
#display l_std[l_i].tabname CLIPPED," name error"
#                                     LET l_right='N'
#                                     CONTINUE WHILE
#                                  END IF
#                              END FOR
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='> aps' THEN
#display l_std[l_i].tabname CLIPPED," not _file or aps"
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_std[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_std[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].tabname)
                      LET l_std[l_i].tabname=l_std[l_i].tabname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()
    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
#已到一個穩定度,暫時拿掉
#    ELSE
#       display l_std[1].tabname,l_std[1].fldname,l_std[1].type,l_std[1].length,l_std[1].serial
#       display l_std[l_std_max].tabname,l_std[l_std_max].fldname,l_std[l_std_max].type,l_std[l_std_max].length,l_std[l_std_max].serial
    END IF

    LET l_k=1 #紀錄command數目
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].fldname=l_cus[l_j].fldname AND 
               l_std[l_i].tabname=l_cus[l_j].tabname THEN
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].type=l_cus[l_j].type THEN
                  IF l_std[l_i].type='7' OR l_std[l_i].type='11' OR
                     l_std[l_i].type='1' OR l_std[l_i].type='2' THEN
                     CONTINUE FOR
                  ELSE
                     IF l_std[l_i].length=l_cus[l_j].length THEN
                        CONTINUE FOR
                     ELSE
                        CASE l_std[l_i].type
                            WHEN 0 
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 1 
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                                 ELSE
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 2 
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                                 ELSE
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 5 
                                 LET x=l_std[l_i].length/256
                                 LET l_str=x
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                 ELSE
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                 END IF
                                 LET l_str=l_std[l_i].length mod 256
                                 LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 7
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                 LET l_k=l_k+1
                            WHEN 11
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte)'
                                 ELSE
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 13
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                                 ELSE
                                    LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                 END IF
                                 LET l_k=l_k+1
                            OTHERWISE
                                 LET x=l_std[l_i].type-256
                                 CASE x
                                     WHEN 0 
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 1 
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 2 
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 5 
                                          LET x=l_std[l_i].length/256
                                          LET l_str=x
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                          END IF
                                          LET l_str=l_std[l_i].length mod 256
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 7
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 11
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 13
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                 END CASE
                        END CASE
                     END IF
                  END IF
               ELSE
                  CASE l_std[l_i].type
                      WHEN 0
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 1
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 2 
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 5 
                           LET x=l_std[l_i].length/256
                           LET l_str=x
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                           ELSE
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                              ELSE
                                 LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 7
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 11
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 13
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 14 THEN
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                 LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      OTHERWISE
                           LET x=l_std[l_i].type-256
                           IF l_cus[l_j].type < 14 THEN
                              CASE x
                                  WHEN 0 
                                       LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 7
                                       LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       LET l_k=l_k+1
                                  WHEN 11
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                       END IF
                                       LET l_k=l_k+1
                              END CASE
                           ELSE
                              CASE x
                                  WHEN 0 
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 7
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 11
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                              END CASE
                           END IF
                  END CASE
               END IF
            END IF
        END FOR
    END FOR
    LET l_loop='N' 
    FOR l_i=1 TO l_std_max
        IF l_std[l_i].check='N' THEN
           LET l_std[l_i].check='Y'
           IF l_std[l_i].serial=1 THEN
              IF l_loop='Y' THEN
                 LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                 LET l_k=l_k+1
                 LET l_loop='N'
              END IF
              LET l_loop='Y'
              LET l_tabname=l_std[l_i].tabname
              CASE l_std[l_i].type
                  WHEN 0 
                       LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                  WHEN 1 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' smallint'
                       ELSE
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(5)'
                       END IF
                  WHEN 2 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' integer'
                       ELSE
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(10)'
                       END IF
                  WHEN 5 
                       LET x=l_std[l_i].length/256
                       LET l_str=x
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                       ELSE
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                       END IF
                       LET l_str=l_std[l_i].length mod 256
                       LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,')'
                  WHEN 7
                       LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' date'
                  WHEN 11
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' byte'
                       ELSE
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' blob'
                       END IF
                  WHEN 13
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                       ELSE
                          LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                       END IF
                  OTHERWISE
                       LET x=l_std[l_i].type-256
                       CASE x
                           WHEN 0 
                                LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                           WHEN 1
                                IF g_db_type='IFX' THEN 
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' smallint not null'
                                ELSE
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(5) not null'
                                END IF
                           WHEN 2 
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' integer not null'
                                ELSE
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                END IF
                           WHEN 5 
                                LET x=l_std[l_i].length/256
                                LET l_str=x
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                ELSE
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                END IF
                                LET l_str=l_std[l_i].length mod 256
                                LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null'
                           WHEN 7
                                LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' date not null'
                           WHEN 11
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' byte not null'
                                ELSE
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' blob not null'
                                END IF
                           WHEN 13
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                ELSE
                                   LET l_command[l_k]='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                END IF
                       END CASE
              END CASE
           ELSE
              IF l_loop='Y' THEN
                 IF l_tabname=l_std[l_i].tabname THEN
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                        WHEN 1
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' smallint'
                             ELSE
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(5)'
                             END IF
                        WHEN 2
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' integer'
                             ELSE
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(10)'
                             END IF
                        WHEN 5 
                             LET x=l_std[l_i].length/256
                             LET l_str=x
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,')'
                        WHEN 7
                             LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' date'
                        WHEN 11
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' byte'
                             ELSE
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' blob'
                             END IF
                        WHEN 13
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                             ELSE
                                LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                             END IF
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                                 WHEN 1 
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' smallint not null'
                                      ELSE
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(5) not null'
                                      END IF
                                 WHEN 2
                                      IF g_db_type='IFX' THEN 
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' integer not null'
                                      ELSE
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                      END IF
                                 WHEN 5 
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null'
                                 WHEN 7
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' date not null'
                                 WHEN 11
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' byte not null'
                                      ELSE
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' blob not null'
                                      END IF
                                 WHEN 13
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                      ELSE
                                         LET l_command[l_k]=l_command[l_k] CLIPPED,', ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                      END IF
                             END CASE
                    END CASE
                 ELSE
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 1 
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                             ELSE
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 2 
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                             ELSE
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 5 
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             LET x=l_std[l_i].length/256
                             LET l_str=x
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 7
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 11
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                             ELSE
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 13
                             LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                             ELSE
                                LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 1 
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                      ELSE
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 2 
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                      ELSE
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 5 
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 7
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 11
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                      ELSE
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 13
                                      LET l_command[l_k]=l_command[l_k] CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                      ELSE
                                         LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                             END CASE
                    END CASE
                 END IF
              ELSE
                 CASE l_std[l_i].type
                     WHEN 0 
                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 1 
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                          ELSE
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 2
                          IF g_db_type='IFX' THEN 
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                          ELSE
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 5 
                          LET x=l_std[l_i].length/256
                          LET l_str=x
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                          ELSE
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                          END IF
                          LET l_str=l_std[l_i].length mod 256
                          LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 7
                          LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                          LET l_k=l_k+1
                     WHEN 11
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                          ELSE
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                          END IF
                          LET l_k=l_k+1
                     WHEN 13
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                          ELSE
                             LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                          END IF
                          LET l_k=l_k+1
                     OTHERWISE
                          LET x=l_std[l_i].type-256
                          CASE x
                              WHEN 0 
                                   LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 1 
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                   ELSE
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 2 
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                   ELSE
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 5 
                                   LET x=l_std[l_i].length/256
                                   LET l_str=x
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                   ELSE
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                   END IF
                                   LET l_str=l_std[l_i].length mod 256
                                   LET l_command[l_k]=l_command[l_k] CLIPPED,',',l_str CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 7
                                   LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                   LET l_k=l_k+1
                              WHEN 11
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                   ELSE
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 13
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                   ELSE
                                      LET l_command[l_k]='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                   END IF
                                   LET l_k=l_k+1
                          END CASE
                 END CASE
              END IF
           END IF
        END IF
    END FOR
    IF l_loop='Y' THEN 
       LET l_command[l_k]=l_command[l_k] CLIPPED,')'
       LET l_k=l_k+1
    END IF
    LET l_tabname=''
#drop的部份,暫時先拿掉,要用時再去除mark,且需再經過測試
{    FOR l_j=1 TO l_cus_max
        IF l_cus[l_j].check='N' THEN
           LET l_cus[l_j].check='Y'
           IF l_cus[l_j].serial=1 THEN
              LET l_tabname=l_cus[l_i].tabname
              LET l_command[l_k]='drop table ',l_cus[l_j].tabname CLIPPED
              LET l_k=l_k+1
           ELSE
              IF l_tabname!=l_cus[l_j].tabname OR l_tabname is null THEN
                 LET l_command[l_k]='alter table ',l_cus[l_j].tabname CLIPPED,' drop(',l_cus[l_j].fldname CLIPPED,')'
                 LET l_k=l_k+1
              END IF
           END IF
        END IF
    END FOR
}
    LET l_command_max=l_k-1


LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/",g_dir,"/command"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    CALL readfile_channel.write(l_command[l_k] CLIPPED)
    display l_command[l_k] CLIPPED
END FOR
CALL readfile_channel.close()

LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/",g_dir,"/command.sql"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    LET l_command[l_k]=l_command[l_k] CLIPPED,';'
    CALL readfile_channel.write(l_command[l_k] CLIPPED)
    display l_command[l_k] CLIPPED
END FOR
CALL readfile_channel.close()

#產生shell要將ds複製一份出來模擬
    IF g_db_type='IFX' THEN
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str=l_str CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       CALL readfile_channel.write("cd $TOP/tmp")
       CALL readfile_channel.write("dbexport ds")
       CALL readfile_channel.write("ex $TOP/tmp/ds.exp/ds.sql <<%%")
       CALL readfile_channel.write("g/DATABASE ds/s//DATABASE qazzaq/g")
       CALL readfile_channel.write("wq")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("mv ds.exp qazzaq.exp")
       CALL readfile_channel.write("dbimport qazzaq -d dbs1")
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
#       RUN "chmod 777 $TEMPDIR/exp.sh"
#       RUN "$TEMPDIR/exp.sh"
    ELSE
       SELECT property_value INTO l_tmp_name FROM database_properties   #TQC-820013
        WHERE property_name='DEFAULT_TEMP_TABLESPACE'

       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str=l_str CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       CALL readfile_channel.write("#up_priv.sh ds")
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str="exp ds/ds@$ORACLE_SID owner=ds file='",l_str CLIPPED,"/ds.dmp' direct=y"   #FUN-750075
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       CALL readfile_channel.write("conn system/manager@`echo $ORACLE_SID`;")
       CALL readfile_channel.write("create user qazzaq identified by qazzaq")
       LET l_str="default tablespace ",g_dbs CLIPPED
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("temporary tablespace " || l_tmp_name CLIPPED || ";")  #TQC-820013
       CALL readfile_channel.write("grant create session,create table to qazzaq;")
       CALL readfile_channel.write("grant resource to qazzaq;")
       CALL readfile_channel.write("grant create synonym to qazzaq;")
       CALL readfile_channel.write("conn sys/change_on_install as sysdba;")   #FUN-750075 
       CALL readfile_channel.write("grant select on sys.v_\\$session to qazzaq;")   #FUN-750075
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str="w! ",l_str CLIPPED,"/createdb.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       CALL readfile_channel.write("conn qazzaq/qazzaq@`echo $ORACLE_SID`;")
       CALL readfile_channel.write("@alterazo;")
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str="w! ",l_str CLIPPED,"/createdb1.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("sqlplus system/manager@$ORACLE_SID < $TEMPDIR/createdb.sql")   #FUN-750075
       CALL readfile_channel.write("cd $TOP/ora/work")
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str="imp system/manager@$ORACLE_SID fromuser=ds touser=qazzaq file='",l_str CLIPPED,"/ds.dmp' ignore=y"   #FUN-750075
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("sqlplus system/manager@$ORACLE_SID < $TEMPDIR/createdb1.sql")   #FUN-750075
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/exp.sh"
       RUN "$TEMPDIR/exp.sh"
       RUN "chmod 777 $TEMPDIR/createdb.sql"
       RUN "chmod 777 $TEMPDIR/createdb1.sql"
       RUN "cp $FGLPROFILE $FGLDIR/etc/fglprofile.qaz"
       RUN "chmod 777 $FGLDIR/etc/fglprofile.qaz"
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str=l_str CLIPPED,"/fglprofile.script"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("ex $FGLDIR/etc/fglprofile.qaz <<%%")
       CALL readfile_channel.write("g/ds2\.source")
       CALL readfile_channel.write("-1")
       CALL readfile_channel.write("a")
       
       CALL readfile_channel.write('dbi.database.qazzaq.source= "`echo ${ORACLE_SID}`" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.username= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.password= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.schema= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.ora.prefetch.rows = 1 # Add by Raymon 02/02')
       CALL readfile_channel.write("")
       CALL readfile_channel.write(".")
       CALL readfile_channel.write("w")
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/fglprofile.script"
       RUN "$TEMPDIR/fglprofile.script"
    END IF
END FUNCTION
FUNCTION patch_index(p_dir)
DEFINE readfile_channel   base.channel,
       tok                base.StringTokenizer,
       l_str              CHAR(1000),
       l_right            CHAR(1),
       l_std              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          command char(1000),
                          check  char(1)
                          end record,
       l_cus              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          command char(1000),
                          check  char(1)
                          end record,
       l_cus_max          INTEGER,
       l_std_max          INTEGER,
       l_i                INTEGER,
       l_j                INTEGER,
       l_k                INTEGER,
       l_length           SMALLINT,
       l_command_max      INTEGER,
       l_command          dynamic array of varchar(1000),
       p_dir              STRING

    LET l_str="$FGLRUN gen_index.42m ds;diff $FGLDBPATH/ds_idx.sch std_idx.sch >$TEMPDIR/",p_dir,"/diff_idx.out;chmod 777 $TEMPDIR/",p_dir,"/diff_idx.out"
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_dir,"/diff_idx.out" 
    LET readfile_channel=base.channel.create() 
    CALL readfile_channel.openfile( l_str, "r" ) 
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].idxname=tok.nextToken()
                   IF l_cus[l_i].idxname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_cus[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].idxname)
                      LET l_cus[l_i].idxname=l_cus[l_i].idxname[3,l_k]
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_dir,"/diff_idx.out"
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].idxname=tok.nextToken()
                   IF l_std[l_i].idxname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_std[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].idxname)
                      LET l_std[l_i].idxname=l_std[l_i].idxname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()

    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
    END IF
    LET l_k=1
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].idxname=l_cus[l_j].idxname THEN 
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].unique=l_cus[l_j].unique THEN
                  IF l_std[l_i].columns=l_cus[l_j].columns THEN
                     CONTINUE FOR
                  ELSE
                     LET l_command[l_k]="drop index ",l_cus[l_j].idxname CLIPPED
                     LET l_k=l_k+1
                     IF l_std[l_i].unique='U' THEN
                        LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                     ELSE
                        LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                     END IF
                     LET l_k=l_k+1
                  END IF
               ELSE
                  LET l_command[l_k]="drop index ",l_cus[l_j].idxname CLIPPED
                  LET l_k=l_k+1
                  IF l_std[l_i].unique='U' THEN
                     LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                  ELSE
                     LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                  END IF
                  LET l_k=l_k+1
               END IF
            END IF
        END FOR
    END FOR
    FOR l_i=1 TO l_std_max 
        IF l_std[l_i].check='N' THEN
           LET l_std[l_i].check='Y' 
           IF l_std[l_i].unique='U' THEN
              LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
           ELSE
              LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
           END IF
           LET l_k=l_k+1
        END IF
    END FOR
    LET l_command_max=l_k-1
                     
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_dir,"/index"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        CALL readfile_channel.write(l_command[l_k] CLIPPED)
        display l_command[l_k] CLIPPED
    END FOR
    CALL readfile_channel.close()

    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_dir,"/index.sql"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        LET l_command[l_k]=l_command[l_k] CLIPPED,';'
        CALL readfile_channel.write(l_command[l_k] CLIPPED)
        display l_command[l_k] CLIPPED
    END FOR
    CALL readfile_channel.close()

END FUNCTION
