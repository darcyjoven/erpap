# 大版更打包工具 2008/01/01 by saki

IMPORT os

DATABASE ds

DEFINE   g_old_ver   STRING
DEFINE   g_new_ver   STRING
DEFINE   g_pack_type STRING
DEFINE   g_type_name STRING
DEFINE   g_ver       STRING
DEFINE   g_sql       STRING
DEFINE   g_cmd       STRING
DEFINE   g_packpath  STRING
DEFINE   g_download_path   STRING
DEFINE   g_msg             STRING
DEFINE   g_cnt             LIKE type_file.num5
DEFINE   li_result   LIKE type_file.num5

DEFINE   g_db_type      STRING
DEFINE   g_fgldir_run   STRING
DEFINE   g_fgldir_env   STRING
DEFINE   g_ds4gl_bin    STRING
DEFINE   g_ds4gl_bpatch STRING
DEFINE   g_tempdir      STRING
DEFINE   g_top          STRING
DEFINE   g_ora_path     STRING
DEFINE   g_ifx_path     STRING
DEFINE   g_uni_path     STRING
DEFINE   g_ora_chenv    STRING
DEFINE   g_uni_chenv    STRING
DEFINE   g_ifx_chenv    STRING
DEFINE   g_ora_profile  STRING
DEFINE   g_uni_profile  STRING
DEFINE   g_b5togb       STRING
DEFINE   g_b5tou8       STRING
DEFINE   g_gbtou8       STRING

# Delete
DEFINE gs_client   STRING,
       gs_rcp      STRING,
       g_fe_ver    LIKE bnc_file.bnc06,     #No:FUN-690005  DECIMAL(3,2),
       g_dvm_ver   LIKE bnc_file.bnc06      #No:FUN-690005  DECIMAL(3,2)   #MOD-590017


MAIN
   DEFINE ls_form STRING

   #1 打包tiptop全部檔案

   #2 打包跨板時，資料庫異動清單

   #3 打包跨版時，發生在zl資料的資料同步清單

   #4 製作預設值塞入的工具程式

   #5 打包patch工具(diffdb,compare_schema,compare_program,load_program,load_data,data_fill..)

   #6 製做Patch自動執行Shell



   #設定參數、工具位置
   LET g_fgldir_run = FGL_GETENV("FGLDIR")
   LET g_fgldir_env = g_fgldir_run.subString(1,g_fgldir_run.getIndexOf(".run",1)-1),".dev"
   LET g_ds4gl_bin  = FGL_GETENV("DS4GL"),os.Path.separator(),"bin",os.Path.separator()
   LET g_ds4gl_bpatch  = FGL_GETENV("DS4GL"),os.Path.separator(),"bin",os.Path.separator(),"bpatch",os.Path.separator()
   LET g_tempdir = FGL_GETENV("TEMPDIR"),os.Path.separator()

   LET g_ora_path = "/u3/tiptopo"
   LET g_ifx_path = "/u3/tiptopi"
   LET g_uni_path = "/u3/utiptopo"
   LET g_ora_chenv = ". /u6/etc/gp.tiptop3o"
   LET g_uni_chenv = ". /u6/etc/gp.utiptop3"
   LET g_ifx_chenv = ". /u6/etc/gp.tiptop3i"
   LET g_ora_profile = "/u6/etc/fglprofile_2.0/fglprofile.tiptop3"
   LET g_uni_profile = "/u6/etc/fglprofile_2.0/fglprofile.utiptop3"
   LET g_b5togb = "big5_to_gb2312.lux"
   LET g_b5tou8 = "b5tou8"
   LET g_gbtou8 = "gbtou8"

   LET ls_form = g_ds4gl_bpatch,"bpatch_pack"
   OPEN WINDOW bpatch_pack_w WITH FORM ls_form
      ATTRIBUTE(TEXT="Pack Tool")
   CLOSE WINDOW screen
   CALL ui.Interface.loadStyles(g_ds4gl_bpatch||"bpatch.4st")
   CALL bpatch_set_comp_visible("dummy07,dummy08,download,alter_schema,data_fill,group02",FALSE)

   WHILE TRUE
      INPUT g_old_ver,g_new_ver,g_pack_type FROM old_ver,new_ver,type_sel
         ON CHANGE type_sel
            CASE
               WHEN g_pack_type MATCHES '[ABDE]'
                  LET g_top = g_ora_path
                  DISPLAY g_ora_path TO FORMONLY.progfile_path
               WHEN g_pack_type MATCHES '[CF]'
                  LET g_top = g_uni_path
                  DISPLAY g_uni_path TO FORMONLY.progfile_path
               WHEN g_pack_type MATCHES '[GHIJ]'
                  LET g_top = g_ifx_path
                  DISPLAY g_ifx_path TO FORMONLY.progfile_path
            END CASE
            
         ON ACTION alter_schema
            MESSAGE ""
            IF os.Path.exists(g_packpath||os.Path.separator()||"dbschema"||os.Path.separator()||"alter_schema_list.txt") THEN
               MESSAGE g_packpath,os.Path.separator(),"dbschema",os.Path.separator(),"alter_schema_list.txt"
               LET g_cmd = "$FGLRUN $AZZ/42r/p_view.42r ",g_packpath,os.Path.separator(),"dbschema",os.Path.separator(),"alter_schema_list.txt 66"
               RUN g_cmd
            ELSE
               MESSAGE "Not Found:",g_packpath,os.Path.separator(),"dbschema",os.Path.separator(),"alter_schema_list.txt"
            END IF

         ON ACTION data_fill
            MESSAGE ""
            IF os.Path.exists(g_packpath||os.Path.separator()||"import_default_value_"||g_ver||".txt") THEN
               MESSAGE g_packpath,os.Path.separator(),"import_default_value_",g_ver,".txt"
               LET g_cmd = "$FGLRUN $AZZ/42r/p_view.42r ",g_packpath,os.Path.separator(),"import_default_value_",g_ver,".txt 66"
               RUN g_cmd
            ELSE
               MESSAGE "Not Found:",g_packpath,os.Path.separator(),"import_default_value_",g_ver,".txt"
            END IF

         ON ACTION download
            LET g_download_path = cl_browse_dir()
            IF g_download_path IS NULL THEN
               IF g_pack_type = "Z" THEN
                  LET g_msg = g_tempdir,"bpatch_",g_ver,"_*.sh\n",
                              g_tempdir,"bpatch_",g_ver,"_*.tar"
                  DISPLAY g_msg TO FORMONLY.download_file
               ELSE
                  LET g_msg = g_tempdir,"bpatch_",g_ver,"_",g_type_name,".sh\n",
                              g_tempdir,"bpatch_",g_ver,"_",g_type_name,".tar"
                  DISPLAY g_msg TO FORMONLY.download_file
               END IF
            ELSE
               IF g_pack_type = "Z" THEN
                  LET g_msg = g_download_path,"/bpatch_",g_ver,"_*.sh\n",
                              g_download_path,"/bpatch_",g_ver,"_*.tar"
                  DISPLAY g_msg TO FORMONLY.download_file
               ELSE
                  CALL cl_download_file(g_tempdir||"bpatch_"||g_ver||"_"||g_type_name||".sh",g_download_path||"/bpatch_"||g_ver||"_"||g_type_name||".sh") RETURNING li_result
                  IF li_result THEN
                     LET g_msg = g_download_path,"/bpatch_",g_ver,"_",g_type_name,".sh"
                  END IF
                  CALL cl_download_file(g_tempdir||"bpatch_"||g_ver||"_"||g_type_name||".tar",g_download_path||"/bpatch_"||g_ver||"_"||g_type_name||".tar") RETURNING li_result
                  IF li_result THEN
                     IF g_msg IS NOT NULL THEN
                        LET g_msg = g_msg,"\n"
                     END IF
                     LET g_msg = g_msg,g_download_path,"/bpatch_",g_ver,"_",g_type_name,".tar"
                     DISPLAY g_msg TO FORMONLY.download_file
                  END IF
               END IF
            END IF
            
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT

      IF NOT INT_FLAG THEN
         IF g_old_ver IS NOT NULL AND g_new_ver IS NOT NULL THEN
            CLEAR img01,img02,img03,img04,img05,img06
            CALL bpatch_set_comp_visible("dummy07,dummy08,download,alter_schema,data_fill,group02",FALSE)

            #要分各出貨版本打包
            IF g_pack_type = "Z" THEN
               MESSAGE "Not Ready"
            ELSE
               CASE g_pack_type
                  WHEN "A"
                     LET g_type_name = "ORA_0_B5"
                  WHEN "B"
                     LET g_type_name = "ORA_0_GB"
                  WHEN "C"
                     LET g_type_name = "ORA_0_UN"
                  WHEN "D"
                     LET g_type_name = "ORA_1_B5"
                  WHEN "E"
                     LET g_type_name = "ORA_1_GB"
                  WHEN "F"
                     LET g_type_name = "ORA_1_UN"
                  WHEN "G"
                     LET g_type_name = "IFX_0_B5"
                  WHEN "H"
                     LET g_type_name = "IFX_0_GB"
                  WHEN "I"
                     LET g_type_name = "IFX_1_B5"
                  WHEN "J"
                     LET g_type_name = "IFX_1_GB"
               END CASE
               IF g_pack_type MATCHES '[ABCEDF]' THEN
                  LET g_db_type = "ORA"
               ELSE
                  LET g_db_type = "IFX"
               END IF
# timie record
               LET g_cmd = "echo pack ",g_packpath," start ",TODAY," ",TIME," >> ",g_ds4gl_bpatch,"bpatch_pack.txt"
               RUN g_cmd
# timie record
               CALL bpatch_pack() RETURNING li_result
# time record
               LET g_cmd = "echo pack ",g_packpath," end ",TODAY," ",TIME," >> ",g_ds4gl_bpatch,"bpatch_pack.txt"
               RUN g_cmd
# timie record
            END IF

            IF li_result THEN
               DISPLAY "Finish" TO FORMONLY.dummy07
               CALL bpatch_set_comp_visible("dummy07,dummy08,download,group02",TRUE)
            ELSE
               DISPLAY "Pack Error" TO FORMONLY.dummy07
               CALL bpatch_set_comp_visible("dummy07",TRUE)
            END IF
         END IF
      ELSE
         IF os.Path.exists(g_packpath) THEN
            LET g_cmd = "rm -rf ",g_packpath
            RUN g_cmd
         END IF
         EXIT WHILE
      END IF
   END WHILE

   CLOSE WINDOW bpatch_pack_w
END MAIN

FUNCTION bpatch_pack()

   IF g_new_ver.getIndexOf(".",1) THEN
      LET g_ver = g_new_ver.subString(1,g_new_ver.getIndexOf(".",1)-1),g_new_ver.subString(g_new_ver.getIndexOf(".",1)+1,g_new_ver.getLength())
   END IF

   LET g_packpath = FGL_GETENV("TEMPDIR"),os.Path.separator(),"bpatch_",g_ver,"_",g_type_name

   LET li_result = TRUE

   LET g_cmd = "rm -rf ",g_packpath," >/dev/null 2>&1"
   RUN g_cmd
   IF NOT os.Path.mkdir(g_packpath) THEN
      MESSAGE "Create Patch Temp Directory Error!"
      RETURN FALSE
   END IF

   #1 打包tiptop全部檔案
   CALL bpatch_pack_program() RETURNING li_result
   IF li_result THEN
      DISPLAY "accept" TO FORMONLY.img01
   ELSE
      DISPLAY "cancel" TO FORMONLY.img01
      RETURN FALSE
   END IF
   CALL ui.Interface.refresh()

   #2 打包跨板時，資料庫異動清單
   CALL bpatch_pack_zs_data() RETURNING li_result
   IF li_result THEN
      CALL bpatch_set_comp_visible("alter_schema",TRUE)
      DISPLAY "accept" TO FORMONLY.img02
   ELSE
      DISPLAY "cancel" TO FORMONLY.img02
      RETURN FALSE
   END IF
   CALL ui.Interface.refresh()

   #3 打包跨版時，發生在zl資料的資料同步清單
   CALL bpatch_pack_data() RETURNING li_result
   IF li_result THEN
      DISPLAY "accept" TO FORMONLY.img03
   ELSE
      DISPLAY "cancel" TO FORMONLY.img03
      RETURN FALSE
   END IF
   CALL ui.Interface.refresh()

   #4 製作預設值塞入的工具程式
   CALL bpatch_pack_create_data_fill() RETURNING li_result
   IF li_result THEN
      CALL bpatch_set_comp_visible("data_fill",TRUE)
      DISPLAY "accept" TO FORMONLY.img04
   ELSE
      DISPLAY "cancel" TO FORMONLY.img04
      RETURN FALSE
   END IF
   CALL ui.Interface.refresh()

   #5 打包patch工具(diffdb,compare_schema,compare_program,load_program,load_data,data_fill..)
   CALL bpatch_pack_packall() RETURNING li_result
   IF li_result THEN
      DISPLAY "accept" TO FORMONLY.img05
   ELSE
      DISPLAY "cancel" TO FORMONLY.img05
      RETURN FALSE
   END IF
   CALL ui.Interface.refresh()

   IF g_pack_type = "Z" THEN
      LET g_msg = g_tempdir,"bpatch_",g_ver,"_*.sh\n",
                  g_tempdir,"bpatch_",g_ver,"_*.tar"
      DISPLAY g_msg TO FORMONLY.download_file
   ELSE
      LET g_msg = g_tempdir,"bpatch_",g_ver,"_",g_type_name,".sh\n",
                  g_tempdir,"bpatch_",g_ver,"_",g_type_name,".tar"
      DISPLAY g_msg TO FORMONLY.download_file
   END IF

   #6 製做Patch自動執行Shell
   CALL bpatch_pack_make_shell() RETURNING li_result
   IF li_result THEN
      DISPLAY "accept" TO FORMONLY.img06
   ELSE
      DISPLAY "cancel" TO FORMONLY.img06
      RETURN FALSE
   END IF
   MESSAGE ""

   RETURN TRUE
END FUNCTION

#打包程式, GB碼不做
FUNCTION bpatch_pack_program()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_path      STRING
   DEFINE   ls_root      STRING
   DEFINE   ls_chmodtool STRING

   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"tiptop") THEN
      RETURN FALSE
   END IF

   LET ls_chmodtool = FGL_GETENV("TOP"),os.Path.separator(),"bin",os.Path.separator(),"sbin",os.Path.separator(),"ch_file_mode_gp"

   MESSAGE "開始複製tiptop所有程式"
   CALL ui.Interface.refresh()
   LET lc_channel = base.Channel.create()
   CASE
      WHEN g_pack_type MATCHES '[AD]'
         CALL lc_channel.openPipe("cd "||g_ora_path||";ls","r")
         WHILE lc_channel.read(ls_result)
            IF ls_result = "ain" THEN
               CONTINUE WHILE
            END IF
            LET ls_path = g_ora_path,os.Path.separator(),ls_result
            IF os.Path.isdirectory(ls_path) THEN
               LET g_cmd = "cd ",g_ora_path,";cp -r ",ls_path," ",g_packpath,os.Path.separator(),"tiptop"
               RUN g_cmd
               LET g_cmd = ls_chmodtool," ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result," to_tiptop_per_list"
               RUN g_cmd
               LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,";rm -rf rpt"
               RUN g_cmd
            END IF
         END WHILE
      WHEN g_pack_type MATCHES '[BE]'
      WHEN g_pack_type MATCHES '[CF]'
         CALL lc_channel.openPipe("cd "||g_uni_path||";ls","r")
         WHILE lc_channel.read(ls_result)
            IF ls_result = "ain" THEN
               CONTINUE WHILE
            END IF
            LET ls_path = g_uni_path,os.Path.separator(),ls_result
            IF os.Path.isdirectory(ls_path) THEN
               LET g_cmd = "cd ",g_uni_path,";cp -r ",ls_path," ",g_packpath,os.Path.separator(),"tiptop"
               RUN g_cmd
               LET g_cmd = ls_chmodtool," ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result," to_tiptop_per_list"
               RUN g_cmd
               LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,";rm -rf rpt"
               RUN g_cmd
            END IF
         END WHILE
      WHEN g_pack_type MATCHES '[GI]'
         CALL lc_channel.openPipe("cd "||g_ifx_path||";ls","r")
         WHILE lc_channel.read(ls_result)
            IF ls_result = "ain" THEN
               CONTINUE WHILE
            END IF
            LET ls_path = g_ifx_path,os.Path.separator(),ls_result
            IF os.Path.isdirectory(ls_path) THEN
               LET g_cmd = "cd ",g_ifx_path,";cp -r ",ls_path," ",g_packpath,os.Path.separator(),"tiptop"
               RUN g_cmd
               LET g_cmd = ls_chmodtool," ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result," to_tiptop_per_list"
               RUN g_cmd
               LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,";rm -rf rpt"
               RUN g_cmd
            END IF
         END WHILE
      WHEN g_pack_type MATCHES '[HJ]'
   END CASE
   CALL lc_channel.close()

   #清除rpt目錄
#  MESSAGE "清除rpt目錄"
#  CALL ui.Interface.refresh()
#  CALL lc_channel.openPipe("cd "||g_packpath||os.Path.separator()||"tiptop;

   #清除 42m,42r,42f 資料夾下內容
   MESSAGE "清除 42m,42r,42f 資料夾下內容"
   CALL ui.Interface.refresh()
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe("cd "||g_packpath||os.Path.separator()||"tiptop;find . -name 42[mrf]","r")
   WHILE lc_channel.read(ls_result)
      LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop;cd ",ls_result,";rm -rf *;cd ~-"
      RUN g_cmd
   END WHILE
   CALL lc_channel.close()

   #清除 core
   MESSAGE "清除 不必要檔案"
   CALL ui.Interface.refresh()
   LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop;find . -name core.* -exec rm {} \\;"
   RUN g_cmd

   #移除 dc2 目錄
   LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop;find . -name dc2 -type d -prune -exec rm -rf {} \\;"
   RUN g_cmd

   #清除 4gl,4fd及per目錄下的bak檔
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe("cd "||g_packpath||os.Path.separator()||"tiptop;ls -d a?? g?? lib sub qry","r")
   WHILE lc_channel.read(ls_result)
      LET g_cmd = "rm -rf ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,os.Path.separator(),"4gl",os.Path.separator(),"*.bak"
      RUN g_cmd
      LET g_cmd = "rm -rf ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,os.Path.separator(),"4fd",os.Path.separator(),"*.bak"
      RUN g_cmd
      LET g_cmd = "rm -rf ",g_packpath,os.Path.separator(),"tiptop",os.Path.separator(),ls_result,os.Path.separator(),"per",os.Path.separator(),"*.bak"
      RUN g_cmd
   END WHILE
   CALL lc_channel.close()

   MESSAGE "打包TIPTOP檔案"
   CALL ui.Interface.refresh()
   LET g_cmd = "cd ",g_packpath,os.Path.separator(),"tiptop;tar cf ",g_packpath,os.Path.separator(),"tiptop.tar *;cd ",g_packpath,";rm -rf tiptop"
   RUN g_cmd

   IF NOT os.Path.exists(g_packpath||os.Path.separator()||"tiptop.tar") THEN
      RETURN FALSE
   END IF

   #打包安全機制檔案
   MESSAGE "打包安全機制檔案"
   CALL ui.Interface.refresh()
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"azz") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"azz"||os.Path.separator()||"42m") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"lib") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"lib"||os.Path.separator()||"42m") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"qry") THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"security"||os.Path.separator()||"qry"||os.Path.separator()||"42m") THEN
      RETURN FALSE
   END IF

   #GB碼的安全機制檔案是不是和BIG5一樣?
   CASE
      WHEN g_pack_type MATCHES '[AD]'
         LET ls_root = g_ora_path
      WHEN g_pack_type MATCHES '[BE]'
      WHEN g_pack_type MATCHES '[CF]'
         LET ls_root = g_uni_path
      WHEN g_pack_type MATCHES '[GI]'
         LET ls_root = g_ifx_path
      WHEN g_pack_type MATCHES '[HJ]'
   END CASE
   LET g_cmd = "cd ",ls_root,";cp azz",os.Path.separator(),"42m",os.Path.separator(),"azz_p_go.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"azz",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp lib",os.Path.separator(),"42m",os.Path.separator(),"lib_cl_cmdrun.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"lib",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp lib",os.Path.separator(),"42m",os.Path.separator(),"lib_cl_contview.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"lib",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp lib",os.Path.separator(),"42m",os.Path.separator(),"lib_cl_err3.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"lib",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp lib",os.Path.separator(),"42m",os.Path.separator(),"lib_cl_qbe.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"lib",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp qry",os.Path.separator(),"42m",os.Path.separator(),"qry_q_contview.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"qry",os.Path.separator(),"42m"
   RUN g_cmd
   LET g_cmd = "cd ",ls_root,";cp qry",os.Path.separator(),"42m",os.Path.separator(),"qry_q_contview2.42m ",
               g_packpath,os.Path.separator(),"security",os.Path.separator(),"qry",os.Path.separator(),"42m"
   RUN g_cmd

   LET g_cmd = "cd ",g_packpath,os.Path.separator(),"security;tar cf ",g_packpath,os.Path.separator(),"security.tar *;cd ",g_packpath,";rm -rf security"
   RUN g_cmd
   IF NOT os.Path.exists(g_packpath||os.Path.separator()||"security.tar") THEN
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION

#打包alter 指令
FUNCTION bpatch_pack_zs_data()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING

   MESSAGE "打包資料庫Alter清單"
   CALL ui.Interface.refresh()
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_packpath||os.Path.separator()||"pack_zs.sh","w")
   CALL lc_channel.setDelimiter("")
   CASE
      WHEN g_pack_type MATCHES '[ABDECF]'
         CALL lc_channel.write(g_ora_chenv)
         LET ls_str = "FGLPROFILE=",g_ora_profile,";export FGLPROFILE"
         CALL lc_channel.write(ls_str)
         LET ls_str = "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
         CALL lc_channel.write(ls_str)
         LET ls_str = "cd $FGLDBPATH;fgldbsch -db ds1 -ow ds1 -ie"
         CALL lc_channel.write(ls_str)
      WHEN g_pack_type MATCHES '[GHIJ]'
         LET ls_str = "unset FGLPROFILE"
         CALL lc_channel.write(ls_str)
         CALL lc_channel.write(g_ifx_chenv)
         LET ls_str = "cd $FGLDBPATH;fgldbsch -db ds -ie"
         CALL lc_channel.write(ls_str)
         LET ls_str = "cd $FGLDBPATH;fgldbsch -db ds1 -ie"
         CALL lc_channel.write(ls_str)
   END CASE

   LET ls_str = "$FGLRUN $DS4GL/bin/gen_index.42r ds"
   CALL lc_channel.write(ls_str)
   LET ls_str = "$FGLRUN $DS4GL/bin/gen_index.42r ds1"
   CALL lc_channel.write(ls_str)
   IF g_pack_type MATCHES '[CF]' THEN
      LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"bpatch_pack_zs.42r '",g_old_ver,"' '",g_new_ver,"' '",g_packpath,"' '",g_b5tou8,"'"
   ELSE
      LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"bpatch_pack_zs.42r '",g_old_ver,"' '",g_new_ver,"' '",g_packpath,"' "
   END IF
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   LET g_cmd = ". ",g_packpath,os.Path.separator(),"pack_zs.sh"
   RUN g_cmd
   IF os.Path.delete(g_packpath||os.Path.separator()||"pack_zs.sh") THEN
   END IF

   IF NOT os.Path.exists(g_packpath||os.Path.separator()||"dbschema"||os.Path.separator()||"alter_schema_list.txt") THEN
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION

#打包程式基本資料
FUNCTION bpatch_pack_data()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING

   MESSAGE "打包資料同步清單"
   CALL ui.Interface.refresh()
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_packpath||os.Path.separator()||"pack_data.sh","w")
   CALL lc_channel.setDelimiter("")
   CASE
      WHEN g_pack_type MATCHES '[ABDE]'
         CALL lc_channel.write(g_ora_chenv)
         LET ls_str = "FGLPROFILE=",g_ora_profile,";export FGLPROFILE"
         CALL lc_channel.write(ls_str)
      WHEN g_pack_type MATCHES '[CF]'
         CALL lc_channel.write(g_uni_chenv)
         LET ls_str = "FGLPROFILE=",g_uni_profile,";export FGLPROFILE"
         CALL lc_channel.write(ls_str)
         LET ls_str = "LANG=en_US.utf8;export LANG"
         CALL lc_channel.write(ls_str)
      WHEN g_pack_type MATCHES '[GHIJ]'
         LET ls_str = "unset FGLPROFILE"
         CALL lc_channel.write(ls_str)
         CALL lc_channel.write(g_ifx_chenv)
   END CASE

   LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"bpatch_pack_data.42r '",g_old_ver,"' '",g_new_ver,"' '",g_pack_type,"' '",g_db_type,"' '",g_packpath,"'"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   LET g_cmd = ". ",g_packpath,os.Path.separator(),"pack_data.sh"
   RUN g_cmd
   IF os.Path.delete(g_packpath||os.Path.separator()||"pack_data.sh") THEN
   END IF

   CASE
      WHEN g_pack_type MATCHES '[ACDF]'      #Oracle Big5 & Unicode
         #檢查dmp檔
         IF NOT os.Path.exists(g_packpath||os.Path.separator()||"patchtemp.dmp") THEN
            RETURN FALSE
         END IF
      WHEN g_pack_type MATCHES '[GI]'        #Informix Big5
         #檢查exp資料夾
         IF NOT os.Path.exists(g_packpath||os.Path.separator()||"patchtemp.exp") THEN
            RETURN FALSE
         END IF
      WHEN g_pack_type MATCHES '[BEHJ]'      #GB
         #檢查tar檔
         IF NOT os.Path.exists(g_packpath||os.Path.separator()||"patchtemp_data.tar") THEN
            RETURN FALSE
         END IF
      OTHERWISE
         RETURN FALSE
   END CASE

   RETURN TRUE
END FUNCTION

#自動產生Data Fill程式
FUNCTION bpatch_pack_create_data_fill()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING
   DEFINE   li_result    LIKE type_file.num5

   MESSAGE "製作資料預設值程式"
   CALL ui.Interface.refresh()
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_packpath||os.Path.separator()||"data_fill.sh","w")
   CALL lc_channel.setDelimiter("")

   #p_alt資料只存在ORA測試區
   LET ls_str = "/u6/etc/gp.top3o"
   CALL lc_channel.write(ls_str)
   LET ls_str = "FGLPROFILE=/u6/etc/fglprofile_2.0/fglprofile.top3;export FGLPROFILE"
   CALL lc_channel.write(ls_str)
   CASE
      WHEN g_pack_type MATCHES '[ADGI]'
         LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"create_imp_default_val_process.42r '",g_old_ver,"' '",g_new_ver,"' '",g_packpath,os.Path.separator(),"' ''"
         CALL lc_channel.write(ls_str)

      WHEN g_pack_type MATCHES '[BEHJ]'
         LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"create_imp_default_val_process.42r '",g_old_ver,"' '",g_new_ver,"' '",g_packpath,os.Path.separator(),"' '",g_b5togb,"'"
         CALL lc_channel.write(ls_str)

      WHEN g_pack_type MATCHES '[CF]'
         LET ls_str = "$FGLRUN ",g_ds4gl_bpatch,"create_imp_default_val_process.42r '",g_old_ver,"' '",g_new_ver,"' '",g_packpath,os.Path.separator(),"' '",g_b5tou8,"'"
         CALL lc_channel.write(ls_str)
   END CASE
   CALL lc_channel.close()

   LET g_cmd = ". ",g_packpath,os.Path.separator(),"data_fill.sh"
   RUN g_cmd
   IF os.Path.delete(g_packpath||os.Path.separator()||"data_fill.sh") THEN
   END IF

   IF os.Path.exists(g_packpath||os.Path.separator()||"import_default_value_"||g_ver||".42r") THEN
      CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"import_default_value.per") RETURNING li_result
      IF NOT li_result THEN
         RETURN FALSE
      END IF
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION

#打包patch全部工具檔案
FUNCTION bpatch_pack_packall()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING

   MESSAGE "處理patch工具"
   CALL ui.Interface.refresh()
   LET li_result = TRUE

   #Patch主工具
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch.4st") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch_patch.4gl") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch_patch.per") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch_view.per") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF

   #資料庫比對工具 (compare_schema, ds_patch.sch, ds_idx_patch.sch diffdb.sh)
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"compare_schema.4gl") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   IF NOT os.Path.copy(g_top||os.Path.separator()||"schema"||os.Path.separator()||"ds.sch",g_packpath||os.Path.separator()||"ds_patch.sch") THEN
      RETURN FALSE
   ELSE
      IF NOT os.Path.copy(g_top||os.Path.separator()||"schema"||os.Path.separator()||"ds_idx.sch",g_packpath||os.Path.separator()||"ds_idx_patch.sch") THEN
         RETURN FALSE
      ELSE
         IF NOT os.Path.copy(g_top||os.Path.separator()||"schema"||os.Path.separator()||"ds1.sch",g_packpath||os.Path.separator()||"ds1_patch.sch") THEN
            RETURN FALSE
         ELSE
            IF NOT os.Path.copy(g_top||os.Path.separator()||"schema"||os.Path.separator()||"ds1_idx.sch",g_packpath||os.Path.separator()||"ds1_idx_patch.sch") THEN
               RETURN FALSE
            END IF
         END IF
      END IF
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bin,"diffdb.sh") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bin,"diffdb.4gl") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF

   #程式比對工具
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"compare_program.4gl") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"compare_program.4fd") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"compare_program_viewer.4fd") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF

   #資料庫Patch工具 (選擇資料庫, SQL command畫面.  data_fill, ds_patch.sch, ds_idx_patch.sch已經在資料夾內)
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch_patch_schema.per") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bpatch,"bpatch_patch_schema_cmd.per") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF

   #資料Patch工具 (*選擇語言別畫面* 幹嘛要選擇?, 程式)
   #load_new有資料換行無法成功的問題, 如果都能解決的話才可使用, 先包出去沒關係
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bin,"load_new") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF
   CALL bpatch_pack_file_compile_processing(g_ds4gl_bin,"load_new.4gl") RETURNING li_result
   IF NOT li_result THEN
      RETURN FALSE
   END IF

   #製做modify_fglprofile.sh, 只限ORACLE
   IF g_db_type = "ORA" THEN
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(g_tempdir||"bpatch_"||g_ver||"_"||g_type_name||os.Path.separator()||"modify_fglprofile.sh","w")
      CALL lc_channel.setDelimiter("")
      LET ls_str = "#!/bin/ksh"
      CALL lc_channel.write(ls_str)
      LET ls_str = "grep patchtemp $FGLPROFILE >/dev/null 2>/dev/null"
      CALL lc_channel.write(ls_str)
      LET ls_str = "if [ $? -eq 0 ]"
      CALL lc_channel.write(ls_str)
      LET ls_str = "   then"
      CALL lc_channel.write(ls_str)
      LET ls_str = "   echo 'have patchtemp'"
      CALL lc_channel.write(ls_str)
      LET ls_str = "else"
      CALL lc_channel.write(ls_str)
      LET ls_str = "ex $FGLPROFILE <<%%"
      CALL lc_channel.write(ls_str)
      LET ls_str = "g/ds2.source"
      CALL lc_channel.write(ls_str)
      CALL lc_channel.write("-1")
      CALL lc_channel.write("a")
      LET ls_str = "dbi.database.patchtemp.source= \"`echo ${ORACLE_SID}`\""
      CALL lc_channel.write(ls_str)
      LET ls_str = "dbi.database.patchtemp.username= \"patchtemp\""
      CALL lc_channel.write(ls_str)
      LET ls_str = "dbi.database.patchtemp.password= \"patchtemp\""
      CALL lc_channel.write(ls_str)
      LET ls_str = "dbi.database.patchtemp.schema= \"patchtemp\""
      CALL lc_channel.write(ls_str)
      LET ls_str = "dbi.database.patchtemp.ora.prefetch.rows = 1"
      CALL lc_channel.write(ls_str)
      CALL lc_channel.write("")
      CALL lc_channel.write(".")
      CALL lc_channel.write("w")
      CALL lc_channel.write("q")
      CALL lc_channel.write("%%")
      CALL lc_channel.write("fi")
      CALL lc_channel.close()
   END IF

   MESSAGE "patch整體打包"
   CALL ui.Interface.refresh()
   LET g_cmd = "cd $TEMPDIR;tar cvf bpatch_",g_ver,"_",g_type_name,".tar bpatch_",g_ver,"_",g_type_name
   RUN g_cmd

   RETURN TRUE
END FUNCTION

#檔案複製, 轉碼, 編譯
FUNCTION bpatch_pack_file_compile_processing(ps_path,ps_prog)
   DEFINE   ps_path      STRING
   DEFINE   ps_prog      STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING
   DEFINE   ls_result    LIKE type_file.num5

   LET li_result = TRUE
   CASE
      WHEN g_pack_type MATCHES '[BEHJ]'
         LET g_cmd = "cat ",ps_path,ps_prog,"|",g_b5togb," > ",
                     g_packpath,os.Path.separator(),ps_prog
         RUN g_cmd
         IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog) THEN
            LET li_result = FALSE
            EXIT CASE
         END IF
         CASE
            WHEN ps_prog.getIndexOf(".4gl",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4gl",1)-1)
               LET g_cmd = "cd ",g_packpath,";export FGLDIR=",g_fgldir_env,
                           ";fglcomp ",ps_prog
               RUN g_cmd
               IF os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".err") OR
                  NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42m") THEN
                  LET li_result = FALSE
               ELSE
                  LET g_cmd = "cd ",g_packpath,";fgl2p -o ",ps_prog,".42r ",ps_prog,".42m"
                  RUN g_cmd
                  IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42r") THEN
                     LET li_result = FALSE
                  END IF
               END IF
            WHEN ps_prog.getIndexOf(".per",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".per",1)-1)
               LET g_cmd = "cd ",g_packpath,";fglform ",ps_prog
               RUN g_cmd
               IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                  LET li_result = FALSE
               END IF
            WHEN ps_prog.getIndexOf(".4fd",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4fd",1)-1)
               LET g_cmd = "cd ",g_packpath,";gsform ",ps_prog
               RUN g_cmd
               IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                  LET li_result = FALSE
               END IF
         END CASE
      WHEN g_pack_type MATCHES '[CF]'
         LET g_cmd = "cat ",ps_path,ps_prog,"|",g_b5tou8," > ",
                     g_packpath,os.Path.separator(),ps_prog
         RUN g_cmd
         IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog) THEN
            LET li_result = FALSE
            EXIT CASE
         END IF
         IF ps_prog.getIndexOf(".4gl",1) OR ps_prog.getIndexOf(".per",1) OR
            ps_prog.getIndexOf(".4fd",1) THEN
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile(g_packpath||os.Path.separator()||"unicode_compile.sh","w")
            CALL lc_channel.setDelimiter("")
            CALL lc_channel.write(g_uni_chenv)
            LET ls_str = "FGLPROFILE=",g_uni_profile,";export FGLPROFILE"
            CALL lc_channel.write(ls_str)
            LET ls_str = "LANG=en_US.utf8;export LANG"
            CALL lc_channel.write(ls_str)
         END IF
         CASE
            WHEN ps_prog.getIndexOf(".4gl",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4gl",1)-1)
               LET ls_str = "cd ",g_packpath,";export FGLDIR=",g_fgldir_env,
                            ";fglcomp ",ps_prog
               CALL lc_channel.write(ls_str)
               LET ls_str = "cd ",g_packpath,";fgl2p -o ",ps_prog,".42r ",ps_prog,".42m"
               CALL lc_channel.write(ls_str)
               CALL lc_channel.close()
               LET g_cmd = ". ",g_packpath,os.Path.separator(),"unicode_compile.sh"
               RUN g_cmd
               IF os.Path.delete(g_packpath||os.Path.separator()||"unicode_compile.sh") THEN END IF
               IF os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".err") OR
                  NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42m") THEN
                  LET li_result = FALSE
               ELSE
                  IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42r") THEN
                     LET li_result = FALSE
                  END IF
               END IF
            WHEN ps_prog.getIndexOf(".per",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".per",1)-1)
               LET ls_str = "cd ",g_packpath,";fglform ",ps_prog
               CALL lc_channel.write(ls_str)
               CALL lc_channel.close()
               LET g_cmd = ". ",g_packpath,os.Path.separator(),"unicode_compile.sh"
               RUN g_cmd
               IF os.Path.delete(g_packpath||os.Path.separator()||"unicode_compile.sh") THEN END IF
               IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                  LET li_result = FALSE
               END IF
            WHEN ps_prog.getIndexOf(".4fd",1)
               LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4fd",1)-1)
               LET ls_str = "cd ",g_packpath,";gsform ",ps_prog
               CALL lc_channel.write(ls_str)
               CALL lc_channel.close()
               LET g_cmd = ". ",g_packpath,os.Path.separator(),"unicode_compile.sh"
               RUN g_cmd
               IF os.Path.delete(g_packpath||os.Path.separator()||"unicode_compile.sh") THEN END IF
               IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                  LET li_result = FALSE
               END IF
         END CASE
      OTHERWISE
         IF os.Path.copy(ps_path||ps_prog,g_packpath||os.Path.separator()||ps_prog) THEN
            CASE
               WHEN ps_prog.getIndexOf(".4gl",1)
                  LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4gl",1)-1)
                  LET g_cmd = "cd ",g_packpath,";export FGLDIR=",g_fgldir_env,
                              ";fglcomp ",ps_prog
                  RUN g_cmd
                  IF os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".err") OR
                     NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42m") THEN
                     LET li_result = FALSE
                  ELSE
                     LET g_cmd = "cd ",g_packpath,";fgl2p -o ",ps_prog,".42r ",ps_prog,".42m"
                     RUN g_cmd
                     IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42r") THEN
                        LET li_result = FALSE
                     END IF
                  END IF
               WHEN ps_prog.getIndexOf(".per",1)
                  LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".per",1)-1)
                  LET g_cmd = "cd ",g_packpath,";fglform ",ps_prog
                  RUN g_cmd
                  IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                     LET li_result = FALSE
                  END IF
               WHEN ps_prog.getIndexOf(".4fd",1)
                  LET ps_prog = ps_prog.subString(1,ps_prog.getIndexOf(".4fd",1)-1)
                  LET g_cmd = "cd ",g_packpath,";gsform ",ps_prog
                  RUN g_cmd
                  IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog||".42f") THEN
                     LET li_result = FALSE
                  END IF
               OTHERWISE
                  IF NOT os.Path.exists(g_packpath||os.Path.separator()||ps_prog) THEN
                     LET li_result = FALSE
                  END IF
            END CASE
         ELSE
            LET li_result = FALSE
         END IF
   END CASE

   RETURN li_result
END FUNCTION

#製作執行Patch的Shell
FUNCTION bpatch_pack_make_shell()
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_str       STRING

   MESSAGE "產生patch shell"
   CALL ui.Interface.refresh()
   #製做bpatch_X_X_X_X.sh
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_tempdir||"bpatch_"||g_ver||"_"||g_type_name||".sh","w")
   CALL lc_channel.setDelimiter("")
   LET ls_str = "#!/bin/ksh"
   CALL lc_channel.write(ls_str)
   LET ls_str = "f1=bpatch_",g_ver,"_",g_type_name
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("")
   LET ls_str = "if [[ -e \"$f1\" ]] ; then"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   echo \"Un-Compress bpatch_",g_ver,"_",g_type_name,".tar?(y/n) : \\c\";read unzip"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   if [ \"$unzip\" = \"\" ] ; then"
   CALL lc_channel.write(ls_str)
   LET ls_str = "      unzip=n"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   fi"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("fi")
   CALL lc_channel.write("")
   LET ls_str = "if [ \"$unzip\" = \"y\"  -o \"$unzip\" = \"Y\" -o \"$unzip\" = \"\" ] ; then"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   tar xvf bpatch_",g_ver,"_",g_type_name,".tar"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fi"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("")
   LET ls_str = "if [[ ! -e \"$f1\" ]] ; then"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   echo \"folder not exist\""
   CALL lc_channel.write(ls_str)
   LET ls_str = "else"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   cd bpatch_",g_ver,"_",g_type_name
   CALL lc_channel.write(ls_str)
   IF g_db_type = "ORA" THEN
      LET ls_str = "   . modify_fglprofile.sh"
      CALL lc_channel.write(ls_str)
   END IF
   LET ls_str = "   $FGLRUN bpatch_patch 'bpatch_",g_ver,"_",g_type_name,"'"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("")
   LET ls_str = "   echo \"\""
   CALL lc_channel.write(ls_str)
   LET ls_str = "   echo \"(1) Move bpatch_",g_ver,"_",g_type_name,".* to unpack folder (if finish patch)?\""
   CALL lc_channel.write(ls_str)
   LET ls_str = "   echo \"(2) Keep bpatch_",g_ver,"_",g_type_name," in pack folder (if finish patch not yet)?\""
   CALL lc_channel.write(ls_str)
   LET ls_str = "   echo \"Default(2) : \";read sel"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   case $sel in"
   CALL lc_channel.write(ls_str)
   LET ls_str = "     1) cd ../;rm -rf bpatch_",g_ver,"_",g_type_name,";"
   CALL lc_channel.write(ls_str)
   LET ls_str = "        mv bpatch_",g_ver,"_",g_type_name,".* $TOP/unpack ;;"
   CALL lc_channel.write(ls_str)
   LET ls_str = "   esac"
   CALL lc_channel.write(ls_str)
   LET ls_str = "fi"
   CALL lc_channel.write(ls_str)
   LET ls_str = "cd $TOP/pack"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   RETURN TRUE
END FUNCTION

#隱藏欄位
FUNCTION bpatch_set_comp_visible(ps_fields, pi_visible)
   DEFINE   ps_fields       STRING,
            pi_visible      LIKE type_file.num5
   DEFINE   lst_fields      base.StringTokenizer,
            ls_field_name   STRING  
   DEFINE   lnode_root      om.DomNode,
            llst_items      om.NodeList,
            li_i            LIKE type_file.num5,
            lnode_item      om.DomNode,
            lnode_prev      om.DomNode,
            ls_item_name    STRING,
            ls_prev_name    STRING,
            ls_item_tag     STRING,
            ls_prev_tag     STRING
   DEFINE   lwin_curr       ui.Window,
            lfrm_curr       ui.Form
   DEFINE   lnode_frm       om.DomNode
   DEFINE   ls_formName     STRING
   DEFINE   li_idx          LIKE type_file.num5
   DEFINE   li_gav_cnt      LIKE type_file.num5
   DEFINE   lc_cust_flag    LIKE type_file.chr1
   DEFINE   ls_gav09        LIKE gav_file.gav09
   DEFINE   ls_notNull      STRING,
            ls_required     STRING
   DEFINE   ls_gav01        LIKE gav_file.gav01,
            ls_gav02        LIKE gav_file.gav02
           
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_frm = lfrm_curr.getNode()
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_frm.selectByPath("//Form//*")
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")

   LET ls_formName = lnode_frm.getAttribute("name")
   LET li_idx = ls_formName.getIndexOf("T", 1)
   IF li_idx != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_idx - 1)
   END IF
   LET ls_gav01 = ls_formName
 
   SELECT COUNT(*) INTO li_gav_cnt FROM gav_file
    WHERE gav01 = ls_gav01 AND gav08 = 'Y'
   IF li_gav_cnt > 0 THEN
      LET lc_cust_flag = "Y"
   ELSE
      LET lc_cust_flag = "N"
   END IF

   WHILE lst_fields.hasMoreTokens() 
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_name = ls_field_name.trim()
      LET ls_gav02 = ls_field_name
      
      FOR li_i = 1 TO llst_items.getLength()
         LET lnode_item = llst_items.item(li_i)
         LET ls_item_name = lnode_item.getAttribute("colName")
      
         IF (ls_item_name IS NULL) THEN
            LET ls_item_name = lnode_item.getAttribute("name")
      
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
         END IF
      
         IF (ls_item_name.equals(ls_field_name)) THEN
            LET ls_item_tag = lnode_item.getTagName()
            
            IF (ls_item_tag.equals("Group") OR
                ls_item_tag.equals("Grid") OR
                ls_item_tag.equals("Folder") OR
                ls_item_tag.equals("Page") OR
                ls_item_tag.equals("Label") OR
                ls_item_tag.equals("Button") OR
                ls_item_tag.equals("Image"))THEN
               IF (pi_visible) THEN
                  CALL lfrm_curr.setElementHidden(ls_field_name,0)   
               ELSE
                  CALL lfrm_curr.setElementHidden(ls_field_name,1)
               END IF
               EXIT FOR
            END IF
      
            IF (pi_visible) THEN
               CALL lfrm_curr.setFieldHidden(ls_field_name,0)      
               IF (ls_item_tag.equals("FormField")) THEN
                  LET lnode_prev = lnode_item.getPrevious()
                  IF lnode_prev IS NOT NULL THEN
                     LET ls_prev_tag = lnode_prev.getTagName()
                     LET ls_prev_name = lnode_prev.getAttribute("name")   #No:FUN-570225
                     IF ls_prev_tag = "Button" AND lnode_prev.getAttribute("tag") = "+" THEN
                        CALL lnode_prev.setAttribute("hidden",0)
                        LET lnode_prev = lnode_prev.getPrevious()
                        IF lnode_prev IS NOT NULL THEN
                           LET ls_prev_tag = lnode_prev.getTagName()
                        END IF
                     END IF
                     IF (ls_prev_tag.equals("Label")) AND 
                        (ls_prev_name NOT MATCHES "dummy*" OR ls_prev_name IS NULL) THEN   #No:FUN-570225
                        CALL lnode_prev.setAttribute("hidden",0)
                     END IF
                  END IF
               END IF
            ELSE
               CALL lfrm_curr.setFieldHidden(ls_field_name,1)
               IF (ls_item_tag.equals("FormField")) THEN
                  LET lnode_prev = lnode_item.getPrevious()
                  IF lnode_prev IS NOT NULL THEN
                     LET ls_prev_tag = lnode_prev.getTagName()
                     LET ls_prev_name = lnode_prev.getAttribute("name")   #No:FUN-570225
                     IF ls_prev_tag = "Button" AND lnode_prev.getAttribute("tag") = "+" THEN
                        CALL lnode_prev.setAttribute("hidden",1)
                        LET lnode_prev = lnode_prev.getPrevious()
                        IF lnode_prev IS NOT NULL THEN
                           LET ls_prev_tag = lnode_prev.getTagName()
                        END IF
                     END IF
                     IF (ls_prev_tag.equals("Label")) AND 
                        (ls_prev_name NOT MATCHES "dummy*" OR ls_prev_name IS NULL) THEN   #No:FUN-570225
                        CALL lnode_prev.setAttribute("hidden",1)
                     END IF
                  END IF
               END IF
            END IF
      
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION

#選擇download資料夾
FUNCTION cl_browse_dir()
  DEFINE ls_dir   STRING


  CALL ui.Interface.frontCall("standard",
                              "opendir",
                              ["C:", "Directory Browser"],
                              [ls_dir])

  IF STATUS THEN
     RETURN NULL
  END IF

  RETURN ls_dir
END FUNCTION

#Download檔案
FUNCTION cl_download_file(ps_source, ps_target)
  DEFINE ps_source    STRING,
         ps_target    STRING
  DEFINE ls_command   STRING
  DEFINE li_status    LIKE type_file.num10      #No:FUN-690005 INTEGER
  DEFINE lch_ch       base.Channel   #MOD-590017


  IF (ps_source IS NULL) OR (ps_target IS NULL) THEN
     RETURN FALSE
  END IF

  CALL cl_transferPrepare()

  IF ps_source.getIndexOf("$", 1) THEN
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("echo \"" || ps_source CLIPPED || "\"", "r")
     WHILE lch_ch.read(ps_source)
     END WHILE
     CALL lch_ch.close()
  END IF

  IF g_dvm_ver >= 1.32 AND g_fe_ver >= 1.32 THEN   #MOD-590017
     CALL FGL_PUTFILE(ps_source, ps_target)
     IF STATUS THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  ELSE
     IF NOT cl_startRcpDaemon() THEN
        RETURN FALSE
     END IF
     LET ls_command = gs_rcp, " ", ps_source, " ", gs_client, ":\"", ps_target, "\" >/dev/null 2>&1"
     RUN ls_command RETURNING li_status
     CALL cl_stopRcpDaemon()
     IF li_status > 0 THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  END IF
END FUNCTION

FUNCTION cl_transferPrepare()
  DEFINE li_idx     LIKE type_file.num10       #No:FUN-690005 INTEGER
  DEFINE lch_ch     base.Channel
  DEFINE ls_str     STRING,
         ls_fe_ver  STRING,
         ls_dvm_ver STRING,   #MOD-590017
         ls_ver     STRING
  DEFINE lst_tok    base.StringTokenizer
  DEFINE li_cnt     LIKE type_file.num10       #No:FUN-690005 INTEGER

 
  LET ls_fe_ver = cl_get_gdc_version()
  LET lst_tok = base.StringTokenizer.create(ls_fe_ver, ".")
  LET li_cnt = 1
  INITIALIZE ls_ver TO NULL
  WHILE lst_tok.hasMoreTokens()
      IF li_cnt > 2 THEN
         EXIT WHILE
      END IF
      IF li_cnt != 1 THEN
         LET ls_ver = ls_ver CLIPPED, "."
      END IF
      LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
      LET li_cnt = li_cnt + 1
  END WHILE
  LET g_fe_ver = ls_ver

  INITIALIZE ls_ver TO NULL
   LET ls_dvm_ver = cl_get_dvm_version()
     
   LET lst_tok = base.StringTokenizer.create(ls_dvm_ver, ".")
   LET li_cnt = 1
   WHILE lst_tok.hasMoreTokens()
       IF li_cnt > 2 THEN
          EXIT WHILE
       END IF
       IF li_cnt != 1 THEN
          LET ls_ver = ls_ver CLIPPED, "."
       END IF
       LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
       LET li_cnt = li_cnt + 1
   END WHILE
  LET g_dvm_ver = ls_ver

  IF g_dvm_ver < 1.32 OR g_fe_ver < 1.32 THEN   #MOD-590017
     LET gs_client = cl_getClientIP()
  
     LET gs_rcp = "rcp"
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("uname -a", "r")
     IF NOT STATUS THEN
        WHILE lch_ch.read(ls_str)
        END WHILE
        CALL lch_ch.close()
  
        LET ls_str = ls_str.toUpperCase()
        CASE
            WHEN ls_str.getIndexOf("AIX", 1) != 0
                 LET gs_rcp = "rcp.aix"
            WHEN ls_str.getIndexOf("SUNOS", 1) != 0
                 LET gs_rcp = "rcp.sun"
        END CASE
     END IF
  END IF
END FUNCTION

FUNCTION cl_startRcpDaemon()
  DEFINE li_status   LIKE type_file.num10       #No:FUN-690005 INTEGER

 
  CALL ui.Interface.frontCall("rcpd", "isStarted", [], [li_status])  
  IF NOT li_status THEN
     CALL ui.Interface.frontCall("rcpd", "start", [], [li_status])
     IF ( STATUS ) OR ( NOT li_status ) THEN
        RETURN FALSE
     END IF
  END IF
 
  RETURN TRUE
END FUNCTION

FUNCTION cl_get_gdc_version()
    DEFINE ls_version STRING

 
    INITIALIZE ls_version TO NULL
    LET ls_version = ui.Interface.getFrontEndVersion()

    RETURN ls_version
END FUNCTION

FUNCTION cl_getClientIP()
  DEFINE li_idx      LIKE type_file.num10       #No:FUN-690005 INTEGER
  DEFINE ls_client   STRING
  

  LET ls_client = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") 
  IF (ls_client IS NULL) THEN
     LET ls_client = FGL_GETENV("FGLSERVER")
  END IF
  LET li_idx = ls_client.getIndexOf(":", 1)
  IF li_idx != 0 THEN
     LET ls_client = ls_client.subString(1, li_idx - 1)
  END IF
  
  RETURN ls_client
END FUNCTION

FUNCTION cl_get_dvm_version()
    DEFINE li_idx     INTEGER
    DEFINE lch_cmd    base.Channel
    DEFINE ls_buf     STRING,
           ls_version STRING,
           ls_str     STRING

 
    #---------------------------------------------------------------------------
    # 利用 'fpi' 指令擷取 DVM 版本
    #---------------------------------------------------------------------------
    INITIALIZE ls_version TO NULL
    LET lch_cmd = base.Channel.create()
    CALL lch_cmd.openPipe("fpi", "r")
    WHILE lch_cmd.read(ls_buf)
        LET ls_str = ls_buf
        LET ls_buf = ls_buf.toUpperCase()
        IF ( li_idx := ls_buf.getIndexOf("VERSION", 1) ) THEN
           LET ls_version = ls_str.subString(li_idx + 7, ls_str.getLength())
           LET ls_version = ls_version.trim()
           EXIT WHILE
        END IF
    END WHILE
    CALL lch_cmd.close()
     
    RETURN ls_version
END FUNCTION

FUNCTION cl_stopRcpDaemon()
  DEFINE li_status   LIKE type_file.num10       #No:FUN-690005 INTEGER


  CALL ui.Interface.frontCall("rcpd", "stop", [], [li_status])
END FUNCTION
