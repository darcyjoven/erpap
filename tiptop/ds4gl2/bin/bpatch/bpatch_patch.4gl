# 大版更解包工具 2008/01/01 by saki
#1 建議先比對各資料庫與將要更新的Schema差異, 將未參照客製規範的部分調整

#2 若有標準區存在, 可比對出貨程式與測試區程式、客製程式差異

#3 更新Schema, 先將ds更新完成後, 再更新其他資料庫
   #3-1 備份所有資料庫                    (已備份不重做)
   #3-2 alter ds table                    (備份,#3-1 必要)
   #3-3 fill default value - ds           (備份,#3-1,#3-2 必要)
   #3-4 alter ds index                    (備份,#3-1,#3-2 必要)
   #3-5 alter other db table              (備份,#3-2 必要)
   #3-6 fill default value - ds           (備份,#3-5 必要)
   #3-7 alter other db index              (備份,#3-4,#3-5 必要)

#4 更新資料, 非轉GB碼的資料都用patchtemp資料庫更新, GB碼用load_new更新
   #4-1 import patchtemp db
   #4-2 update ds data                    (備份,#3-1,#3-2,#3-4,#4-1 必要)

#5 更新檔案, 將tiptop.tar,security.tar整個解包至$TOP, then rebuild

#6 Rebuild
   #6-1 compile all program               (#3-2,#3-4,#4-2,#5 必要)
   #6-2 link all program                  (#6-1 必要)
   #6-3 compile all form                  (#3-2,#3-4,#4-2,#5 必要)

# Parameter 1 : Pack File Name


IMPORT os

DATABASE ds

DEFINE   g_patchname   STRING
DEFINE   g_patchpath   STRING
DEFINE   g_logpath     STRING
DEFINE   g_backuppath  STRING
DEFINE   g_ver         STRING
DEFINE   g_db          STRING
DEFINE   g_lang        STRING
DEFINE   g_code        STRING
DEFINE   g_tempdir     STRING
DEFINE   g_dbs         LIKE type_file.chr10
DEFINE   g_db_type     STRING
DEFINE   g_center      STRING
DEFINE   gr_dblist     DYNAMIC ARRAY OF RECORD   #TIPTOP db list
            chk        LIKE type_file.chr1,
            azp03      LIKE azp_file.azp03
                       END RECORD
DEFINE   gr_cmd        DYNAMIC ARRAY OF RECORD   # alter ds schema command list
            exe        LIKE type_file.chr1,
            cmd        STRING
                       END RECORD
DEFINE   gr_idxcmd     DYNAMIC ARRAY OF RECORD   # alter ds index command list
            exe        LIKE type_file.chr1,
            cmd        STRING
                       END RECORD
DEFINE   gr_cmd_o      DYNAMIC ARRAY OF STRING   # alter other schema command list
DEFINE   gr_idxcmd_o   DYNAMIC ARRAY OF STRING   # alter other index command list
DEFINE   gr_noexecmd   DYNAMIC ARRAY OF STRING   # 記錄ds未執行的sqlcmd, 其他資料庫也不用執行
DEFINE   gr_noexeicmd  DYNAMIC ARRAY OF STRING   # 記錄ds未執行的index sqlcmd, 其他資料庫也不用執行
DEFINE   gr_dropcmd    DYNAMIC ARRAY OF RECORD   # drop table column command list
            exe        LIKE type_file.chr1,
            cmd        STRING,
            relate     LIKE type_file.num10
                       END RECORD
DEFINE   gr_defcmd     DYNAMIC ARRAY OF RECORD   # deflate table column size command list
            exe        LIKE type_file.chr1,
            cmd        STRING,
            relate     LIKE type_file.num10
                       END RECORD
DEFINE   gr_ds_sch     DYNAMIC ARRAY OF RECORD
            tab_name   STRING,
            col_name   STRING,
            col_type   STRING,
            col_size   STRING,
            nullable   STRING,
            default    STRING,
            position   STRING
                       END RECORD
DEFINE   gr_ds_idxsch  DYNAMIC ARRAY OF RECORD
            idx_name   STRING,
            unique     STRING,
            col_list   STRING,
            tab_name   STRING
                       END RECORD
DEFINE   gr_module     DYNAMIC ARRAY OF STRING
DEFINE   g_rebuild     base.Channel
DEFINE   g_steprecord  base.Channel
DEFINE   g_startlog    LIKE type_file.num5
DEFINE   g_endlog      LIKE type_file.num5
DEFINE   g_c01         STRING
DEFINE   g_c02         STRING
DEFINE   g_c03         STRING
DEFINE   g_c04         STRING
DEFINE   g_c05         STRING
DEFINE   g_c06         STRING
DEFINE   g_c07         STRING
DEFINE   g_c08         STRING
DEFINE   g_c09         STRING
DEFINE   g_c10         STRING
DEFINE   g_c11         STRING
DEFINE   g_str         STRING
DEFINE   g_cmd         STRING
DEFINE   g_file        STRING
DEFINE   g_cnt         LIKE type_file.num5

CONSTANT MAX_LINE   INTEGER = 660

DEFINE   g_page_line   LIKE type_file.num5
DEFINE   g_content     STRING                 # Page Content
DEFINE   g_report      STRING                 # Report File Name(After Process)
DEFINE   g_curr_page   LIKE type_file.num10   # Current Page Number
DEFINE   g_total_page  LIKE type_file.num10   # Total Pages
DEFINE   g_total_line  LIKE type_file.num10   # Total Lines of Report
DEFINE   g_showline    LIKE type_file.num10   # Show Line Number or not
DEFINE   g_error_line  LIKE type_file.num10   # indicate where possibly contains invalid character

MAIN
   DEFINE   ls_choice    STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   l_sql        STRING


   WHENEVER ERROR CONTINUE

   LET g_patchname = ARG_VAL(1)
   IF g_patchname IS NULL THEN
      DISPLAY "No Patch Name, can't continue..."
      RETURN
   END IF

   #擷取patch版本各項資訊
   LET g_str  = g_patchname.subString(g_patchname.getIndexOf("bpatch_",1)+7,g_patchname.getLength())
   LET g_ver  = g_str.subString(1,g_str.getIndexOf("_",1)-1)
   LET g_str  = g_str.subString(g_ver.getLength()+2,g_str.getLength())
   LET g_db   = g_str.subString(1,g_str.getIndexOf("_",1)-1)
   LET g_str  = g_str.subString(g_db.getLength()+2,g_str.getLength())
   LET g_lang = g_str.subString(1,g_str.getIndexOf("_",1)-1)
   LET g_code = g_str.subString(g_lang.getLength()+2,g_str.getLength())

   #產生log、備份資料夾
   LET g_patchpath = FGL_GETENV("TOP"),os.Path.separator(),"pack",os.Path.separator(),g_patchname
   LET g_tempdir = FGL_GETENV("TEMPDIR"),os.Path.separator()
   IF os.Path.mkdir(FGL_GETENV("TOP")||os.Path.separator()||"unpack"||os.Path.separator()||g_patchname) THEN END IF
   IF os.Path.mkdir(FGL_GETENV("TOP")||os.Path.separator()||"unpack"||os.Path.separator()||g_patchname||os.Path.separator()||"log") THEN END IF
   IF os.Path.mkdir(FGL_GETENV("TOP")||os.Path.separator()||"unpack"||os.Path.separator()||g_patchname||os.Path.separator()||"backup") THEN END IF
   LET g_logpath = FGL_GETENV("TOP"),os.Path.separator(),"unpack",os.Path.separator(),g_patchname,os.Path.separator(),"log",os.Path.separator()
   LET g_backuppath = FGL_GETENV("TOP"),os.Path.separator(),"unpack",os.Path.separator(),g_patchname,os.Path.separator(),"backup",os.Path.separator()

   LET g_db_type = DB_GET_DATABASE_TYPE()

   #尋找TIPTOP DB
   IF g_db_type="ORA" THEN
      LET l_sql="SELECT 'N',azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                " AND UPPER(azp03) in (select username from all_users)"
   ELSE
      LET l_sql="SELECT 'N',azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                " AND azp03 in (select name from sysdatabases)"
   END IF
   DECLARE patch_sel_db CURSOR FROM l_sql
   CALL gr_dblist.clear()
   LET gr_dblist[1].chk   = "Y"
   LET gr_dblist[1].azp03 = "ds"
   LET g_cnt = 2
   FOREACH patch_sel_db INTO gr_dblist[g_cnt].*
      IF gr_dblist[g_cnt].azp03 = "ds" THEN
         CONTINUE FOREACH
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL gr_dblist.deleteElement(g_cnt)

   # open patch step record
   LET g_steprecord = base.Channel.create()
   CALL g_steprecord.openFile(g_logpath||"patch_step_record.log","a")
   CALL g_steprecord.setDelimiter("")

   #將最新的diffdb工具先放到客戶端
   LET g_cmd = "cp diffdb.* $DS4GL/bin/"
   RUN g_cmd

   OPEN WINDOW bpatch_patch_w WITH FORM "bpatch_patch"
      ATTRIBUTE(TEXT="Patch Tool")
   CLOSE WINDOW screen
   CALL ui.Interface.loadStyles("bpatch.4st")

   LET g_str = "比對客戶端目前Schema與",g_ver.subString(1,1),".",g_ver.subString(2,g_ver.getLength()),"版更Schema的差異"
   DISPLAY g_str TO FORMONLY.dummy01
   WHILE TRUE
      INPUT g_dbs,g_logpath,g_backuppath WITHOUT DEFAULTS
       FROM formonly.dbspace,formonly.log_path,formonly.backup_path
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_dbs IS NULL THEN
               NEXT FIELD dbspace
            END IF
            IF g_logpath IS NULL OR NOT os.Path.exists(g_logpath) THEN
               MESSAGE "Can't find this folder"
               NEXT FIELD log_path
            END IF
            IF g_backuppath IS NULL OR NOT os.Path.exists(g_backuppath) THEN
               MESSAGE "Can't find this folder"
               NEXT FIELD backup_path
            END IF

         ON ACTION del_unpack
            CALL bpatch_confirm("將會刪除"||g_ver||"版更執行過的備份檔及log檔, 是否確定要刪除?") RETURNING li_result
            IF li_result THEN
               LET g_cmd = "cd ",g_logpath,";rm -rf *"
               RUN g_cmd
               LET g_cmd = "cd ",g_backuppath,";rm -rf *"
               RUN g_cmd
            END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         EXIT WHILE
      END IF

      # get all modules
      CALL gr_module.clear()
      LET lc_channel = base.Channel.create()
      LET g_cmd = "cd $TOP;ls -ld lib sub qry a?? g??|awk '{print $9}'"
      CALL lc_channel.openPipe(g_cmd,"r")
      WHILE lc_channel.read(ls_result)
         LET gr_module[gr_module.getLength()+1] = ls_result
      END WHILE
      CALL lc_channel.close()
      LET lc_channel = base.Channel.create()
      LET g_cmd = "cd $CUST;ls -ld c?? c???|awk '{print $9}'"
      CALL lc_channel.openPipe(g_cmd,"r")
      WHILE lc_channel.read(ls_result)
         LET gr_module[gr_module.getLength()+1] = ls_result
      END WHILE
      CALL lc_channel.close()

      INPUT g_c01,g_c02,g_c03,g_c04,g_c05,g_c06,g_c07,g_c08,g_c09,g_c10,g_c11
       FROM formonly.c01,formonly.c02,formonly.c03,formonly.c04,formonly.c05,
            formonly.c06,formonly.c07,formonly.c08,formonly.c09,formonly.c10,
            formonly.c11
         BEFORE INPUT
            CALL bpatch_set_action_active("sch_rep,prog_rep,ds_tb_log,fill_ds_log,ds_idx_log,other_tb_log,fill_other_log,other_idx_log,data_log,rebuild_log",FALSE)
            #打開已有的log連結Button
            CALL bpatch_open_log_view(g_logpath||"compare_schema.txt","sch_rep")
            CALL bpatch_open_log_view(g_logpath||"compare_program.txt","prog_rep")
            CALL bpatch_open_log_view(g_logpath||"patch_ds_alter_table.log,"||g_logpath||"patch_alter_table_noexe.log","ds_tb_log")
            CALL bpatch_open_log_view(g_logpath||"patch_data_fill.log","fill_ds_log")
            CALL bpatch_open_log_view(g_logpath||"patch_ds_alter_index.log,"||g_logpath||"patch_alter_index_noexe.log","ds_idx_log")
            CALL bpatch_open_log_view(g_logpath||"patch_otherdb_alter_table.log,"||g_logpath||"patch_alter_table_noexe.log","other_tb_log")
            CALL bpatch_open_log_view(g_logpath||"patch_data_fill.log","fill_other_log")
            CALL bpatch_open_log_view(g_logpath||"patch_otherdb_alter_index.log,"||g_logpath||"patch_alter_index_noexe.log","other_idx_log")
            CALL bpatch_open_log_view(g_logpath||"patch_update_data.log","data_log")
            CALL bpatch_open_log_view(g_logpath||"patch_rebuild.log","rebuild_log")

         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               EXIT INPUT
            END IF

         ON ACTION btn01  #1
            MESSAGE ""
            CALL bpatch_clear_img()
            LET g_cmd = "$FGLRUN compare_schema 'ds_patch.sch' 'ds_idx_patch.sch' '",g_logpath,"'"
            RUN g_cmd
            CALL bpatch_open_log_view(g_logpath||"compare_schema.txt","sch_rep")

         ON ACTION btn02  #2
            MESSAGE ""
            CALL bpatch_clear_img()
            LET g_cmd = "$FGLRUN compare_program '",g_logpath,"'"
            RUN g_cmd
            CALL bpatch_open_log_view(g_logpath||"compare_program.txt","prog_rep")

         ON ACTION btn03  #3
            MESSAGE ""
            CALL bpatch_clear_img()
            LET g_c01 = GET_FLDBUF(formonly.c01)
            LET g_c02 = GET_FLDBUF(formonly.c02)
            LET g_c03 = GET_FLDBUF(formonly.c03)
            LET g_c04 = GET_FLDBUF(formonly.c04)
            LET g_c05 = GET_FLDBUF(formonly.c05)
            LET g_c06 = GET_FLDBUF(formonly.c06)
            CALL bpatch_patch_schema()
            CALL bpatch_open_log_view(g_logpath||"patch_ds_alter_table.log","ds_tb_log")
            CALL bpatch_open_log_view(g_logpath||"patch_data_fill.log","fill_ds_log")
            CALL bpatch_open_log_view(g_logpath||"patch_ds_alter_index.log","ds_idx_log")
            CALL bpatch_open_log_view(g_logpath||"patch_otherdb_alter_table.log","other_tb_log")
            CALL bpatch_open_log_view(g_logpath||"patch_data_fill.log","fill_other_log")
            CALL bpatch_open_log_view(g_logpath||"patch_otherdb_alter_index.log","other_idx_log")

         ON ACTION btn04  #4
            MESSAGE ""
            CALL bpatch_clear_img()
            LET g_c07 = GET_FLDBUF(formonly.c07)
            LET g_c08 = GET_FLDBUF(formonly.c08)
            CALL bpatch_patch_data()
            CALL bpatch_open_log_view(g_logpath||"patch_update_data.log","data_log")

         ON ACTION btn05  #5
            MESSAGE ""
            CALL bpatch_clear_img()
            CALL bpatch_patch_update_program()

         ON ACTION btn06  #6
            MESSAGE ""
            CALL bpatch_clear_img()
            LET g_c09 = GET_FLDBUF(formonly.c09)
            LET g_c10 = GET_FLDBUF(formonly.c10)
            LET g_c11 = GET_FLDBUF(formonly.c11)
            CALL bpatch_patch_rebuild_all()
            CALL bpatch_open_log_view(g_logpath||"patch_rebuild.log","rebuild_log")

         ON ACTION diff_db
            CALL bpatch_patch_schema_diffdb_alter()

         ON ACTION sch_rep
            LET g_file = g_logpath,"compare_schema.txt"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION prog_rep
            LET g_file = g_logpath,"compare_program.txt"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION alter_list
            LET g_file = g_patchpath,os.Path.separator(),"dbschema",os.Path.separator(),"alter_schema_list.txt"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION data_fill
            LET g_file = g_patchpath,os.Path.separator(),"import_default_value_",g_ver,".txt"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION ds_tb_log
            LET g_cmd = "cat ",g_logpath,"patch_alter_table_noexe.log ",g_logpath,"patch_ds_alter_table.log > ",g_logpath,"temp.log"
            RUN g_cmd
            LET g_file = g_logpath,"temp.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION fill_ds_log
            LET g_file = g_logpath,"patch_data_fill.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION ds_idx_log
            LET g_cmd = "cat ",g_logpath,"patch_alter_index_noexe.log ",g_logpath,"patch_ds_alter_index.log > ",g_logpath,"temp.log"
            RUN g_cmd
            LET g_file = g_logpath,"temp.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION other_tb_log
            LET g_cmd = "cat ",g_logpath,"patch_alter_table_noexe.log ",g_logpath,"patch_otherdb_alter_table.log > ",g_logpath,"temp.log"
            RUN g_cmd
            LET g_file = g_logpath,"temp.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION fill_other_log
            LET g_file = g_logpath,"patch_data_fill.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION other_idx_log
            LET g_cmd = "cat ",g_logpath,"patch_alter_index_noexe.log ",g_logpath,"patch_otherdb_alter_index.log > ",g_logpath,"temp.log"
            RUN g_cmd
            LET g_file = g_logpath,"temp.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION data_log
            LET g_file = g_logpath,"patch_update_data.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION rebuild_log
            LET g_file = g_logpath,"patch_rebuild.log"
            CALL bpatch_patch_show_file(g_file)

         ON ACTION exit
            LET ls_choice = "exit"
            EXIT INPUT
      END INPUT
      IF ls_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
   CALL g_steprecord.close()

   CLOSE WINDOW bpatch_patch_w
END MAIN

# 檢查log存在後,用p_view開啟
FUNCTION bpatch_patch_show_file(ps_filepath)
   DEFINE   ps_filepath   STRING
   DEFINE   g_logstart    LIKE type_file.num5

   IF os.Path.exists(ps_filepath) THEN
      MESSAGE ps_filepath
      CALL ui.Interface.refresh()
#     LET g_cmd = "$FGLRUN $AZZ/42r/p_view.42r ",ps_filepath," 66 WITHOUT WAITING"
#     RUN g_cmd
      CALL bpatch_patch_view_file(ps_filepath)
   ELSE
      MESSAGE "Not exists:",ps_filepath
   END IF
END FUNCTION

#3 Schema 更新 (全步驟)
FUNCTION bpatch_patch_schema()
   DEFINE   ls_msg      STRING
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_dblist   STRING
   DEFINE   li_cnt      LIKE type_file.num5

   IF g_c04 = "Y" OR g_c05 = "Y" OR g_c06 = "Y" THEN
      #選擇要更新哪些資料庫, ds必要
      OPEN WINDOW db_w WITH FORM "bpatch_patch_schema.42f"
      INPUT ARRAY gr_dblist WITHOUT DEFAULTS FROM s_azp03.*
         ATTRIBUTE(COUNT=gr_dblist.getLength(),MAXCOUNT=gr_dblist.getLength(),UNBUFFERED,
                   INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)
         BEFORE FIELD chk
            IF gr_dblist[ARR_CURR()].azp03 = "ds" THEN
               NEXT FIELD azp03
            END IF
      END INPUT
      CLOSE WINDOW db_w
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         MESSAGE "取消繼續執行"
         RETURN
      END IF
      LET li_result = FALSE
      FOR g_cnt = 1 TO gr_dblist.getLength()
          IF gr_dblist[g_cnt].chk = "Y" AND gr_dblist[g_cnt].azp03 != "ds" THEN
             LET li_result = TRUE
             EXIT FOR
          END IF
      END FOR
      IF NOT li_result THEN
         MESSAGE "未選擇非ds資料庫的其他資料庫, 取消繼續執行"
         RETURN
      END IF
   END IF

   # 記錄當次選擇的DB列表
   LET ls_dblist = NULL
   FOR g_cnt = 1 TO gr_dblist.getLength()
       IF gr_dblist[g_cnt].chk = "Y" THEN
          LET ls_dblist = ls_dblist,gr_dblist[g_cnt].azp03,","
       END IF
   END FOR
   LET ls_dblist = ls_dblist.subString(1,ls_dblist.getLength()-1)
   CALL g_steprecord.write("#3 ------- "||ls_dblist||" ("||TODAY||" "||TIME(CURRENT)||")")

   #開始備份選擇的資料庫
   MESSAGE "開始備份選擇的資料庫"
   CALL ui.Interface.refresh()
   CALL bpatch_step_check("3-1") RETURNING li_result
   IF NOT li_result THEN
      RETURN
   END IF
   #備份未存在的資料庫備份
   LET li_result = TRUE
   LET g_str = ""
   CLOSE DATABASE
   FOR g_cnt = 1 TO gr_dblist.getLength()
       IF gr_dblist[g_cnt].chk = "Y" THEN
          IF g_db_type = "ORA" THEN
             IF NOT os.Path.exists(g_backuppath||gr_dblist[g_cnt].azp03 CLIPPED||".dmp") THEN
                LET g_cmd = "exp ",gr_dblist[g_cnt].azp03 CLIPPED,"/",gr_dblist[g_cnt].azp03 CLIPPED,
                            " file=",g_backuppath,gr_dblist[g_cnt].azp03 CLIPPED,".dmp"
                RUN g_cmd
                LET g_str = g_str,gr_dblist[g_cnt].azp03 CLIPPED,","
             END IF
             IF NOT os.Path.exists(g_backuppath||gr_dblist[g_cnt].azp03 CLIPPED||".dmp") THEN
                LET li_result = FALSE
             END IF
          ELSE
             IF NOT os.Path.exists(g_backuppath||gr_dblist[g_cnt].azp03 CLIPPED||".exp") THEN
                LET g_cmd = "dbexport ",gr_dblist[g_cnt].azp03 CLIPPED," -o ",g_backuppath
                RUN g_cmd
                LET g_str = g_str,gr_dblist[g_cnt].azp03 CLIPPED,","
             END IF
             IF NOT os.Path.exists(g_backuppath||gr_dblist[g_cnt].azp03 CLIPPED||".exp") THEN
                LET li_result = FALSE
             END IF
          END IF
       END IF
   END FOR
   DATABASE ds
   LET g_str = g_str.subString(1,g_str.getLength()-1)
   IF g_str IS NOT NULL THEN
      CALL g_steprecord.write("#3-1 ------- "||g_str||" ("||TODAY||" "||TIME(CURRENT)||")")
   END IF
   IF li_result THEN
      DISPLAY "accept" TO FORMONLY.img01
   ELSE
      CALL bpatch_show_msg("有資料庫未備份成功, 請檢查"||g_backuppath||"後再繼續")
      DISPLAY "cancel" TO FORMONLY.img01
      RETURN
   END IF
   CALL ui.Interface.refresh()

   #解析Alter清單, 按取消就不繼續alter db
   IF g_c01 = "Y" OR g_c03 = "Y" OR g_c04 = "Y" OR g_c06 = "Y" THEN
      MESSAGE "解析Alter清單"
      CALL ui.Interface.refresh()
      CALL bpatch_patch_schema_sel_cmd()
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         MESSAGE "取消繼續執行"
         RETURN
      END IF
      DISPLAY "gr_cmd no exe:"
      FOR g_cnt = 1 TO gr_cmd.getLength()
          IF gr_cmd[g_cnt].exe = "N" THEN
          DISPLAY gr_cmd[g_cnt].cmd
          END IF
      END FOR
      DISPLAY "gr_idxcmd no exe:"
      FOR g_cnt = 1 TO gr_idxcmd.getLength()
          IF gr_idxcmd[g_cnt].exe = "N" THEN
          DISPLAY gr_idxcmd[g_cnt].cmd
          END IF
      END FOR
   END IF

   # alter ds table
   IF g_c01 = "Y" THEN
      CALL bpatch_step_check("3-2") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "Alter ds資料庫Table"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-2"||" ("||TODAY||" "||TIME(CURRENT)||")")
      CALL bpatch_patch_schema_alter_table("ds") RETURNING li_result
      IF g_db_type="ORA" THEN
         RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
      ELSE
         RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
      END IF
      IF li_result THEN
         DISPLAY "accept" TO FORMONLY.img02
      ELSE
         DISPLAY "cancel" TO FORMONLY.img02
         CALL bpatch_show_msg("alter ds資料庫有誤, 請查看log, 手動更新完畢後再繼續更新其他資料庫")
         RETURN
      END IF
      CALL ui.Interface.refresh()
   END IF

   # fill ds default value
   IF g_c02 = "Y" THEN
      CALL bpatch_step_check("3-3") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "調整ds資料庫的欄位資料"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-3"||" ("||TODAY||" "||TIME(CURRENT)||")")
      LET g_cmd = "$FGLRUN import_default_value_",g_ver,".42r ds ",g_logpath,"patch_data_fill.log"
      RUN g_cmd
      DISPLAY "accept" TO FORMONLY.img03
      IF g_c03 = "Y" THEN
         LET g_file = g_logpath,"patch_data_fill.log"
         CALL bpatch_patch_show_file(g_file)
         CALL bpatch_confirm("請查看log, 欄位資料更新不成功可能導致index無法alter,\n是否要繼續更新?") RETURNING li_result
         IF NOT li_result THEN
            MESSAGE "取消繼續執行"
            RETURN
         END IF
      END IF
   END IF

   # alter ds index
   IF g_c03 = "Y" THEN
      CALL bpatch_step_check("3-4") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "Alter ds資料庫Index"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-4"||" ("||TODAY||" "||TIME(CURRENT)||")")
      CALL bpatch_patch_schema_alter_index("ds") RETURNING li_result
      IF li_result THEN
         DISPLAY "accept" TO FORMONLY.img04
      ELSE
         DISPLAY "cancel" TO FORMONLY.img04
         CALL bpatch_show_msg("alter ds資料庫的index有誤, 請查看log, 手動更新完畢後再繼續更新其他資料庫")
         RETURN
      END IF
      CALL ui.Interface.refresh()
   END IF

   # alter other db table
   IF g_c04 = "Y" THEN
      CALL bpatch_step_check("3-5") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "Alter 其他資料庫Table"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-5 ------- "||ls_dblist||" ("||TODAY||" "||TIME(CURRENT)||")")
      LET g_startlog = TRUE
      FOR li_cnt = 1 TO gr_dblist.getLength()
          IF gr_dblist[li_cnt].chk = "Y" AND gr_dblist[li_cnt].azp03 != "ds" THEN
             CALL bpatch_patch_schema_alter_table(gr_dblist[li_cnt].azp03 CLIPPED) RETURNING li_result
          END IF
          IF g_db_type="ORA" THEN
             LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",gr_dblist[li_cnt].azp03 CLIPPED," -ow ",gr_dblist[li_cnt].azp03 CLIPPED," -ie"
             RUN g_cmd
          ELSE
             LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",gr_dblist[li_cnt].azp03 CLIPPED," -ie"
             RUN g_cmd
          END IF
          IF li_cnt = gr_dblist.getLength() THEN
             LET g_endlog = TRUE
          END IF
      END FOR
      IF NOT os.Path.size(g_logpath||"patch_otherdb_alter_table.log") THEN
         DISPLAY "accept" TO FORMONLY.img05
      ELSE
         DISPLAY "cancel" TO FORMONLY.img05
         CALL bpatch_show_msg("alter 其他資料庫有誤, 請查看log, 手動更新完畢後再繼續更新資料庫的Index")
         RETURN
      END IF
      CALL ui.Interface.refresh()
   END IF

   # fill other db default value
   IF g_c05 = "Y" THEN
      CALL bpatch_step_check("3-6") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "調整其他資料庫的欄位資料"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-6 ------- "||ls_dblist||" ("||TODAY||" "||TIME(CURRENT)||")")
      FOR li_cnt = 1 TO gr_dblist.getLength()
          IF gr_dblist[li_cnt].chk = "Y" AND gr_dblist[li_cnt].azp03 != "ds" THEN
             LET g_cmd = "$FGLRUN import_default_value_",g_ver,".42r ",gr_dblist[li_cnt].azp03 CLIPPED," ",g_logpath,"patch_data_fill.log"
             RUN g_cmd
          END IF
      END FOR
      DISPLAY "accept" TO FORMONLY.img06
      IF g_c06 = "Y" THEN
         LET g_file = g_logpath,"patch_data_fill.log"
         CALL bpatch_patch_show_file(g_file)
         CALL bpatch_confirm("請查看log, 欄位資料更新不成功可能導致index無法alter,\n是否要繼續更新?") RETURNING li_result
         IF NOT li_result THEN
            MESSAGE "取消繼續執行"
            RETURN
         END IF
      END IF
   END IF

   # alter other db index
   IF g_c06 = "Y" THEN
      CALL bpatch_step_check("3-7") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      MESSAGE "Alter 其他資料庫Index"
      CALL ui.Interface.refresh()
      CALL g_steprecord.write("#3-7 ------- "||ls_dblist||" ("||TODAY||" "||TIME(CURRENT)||")")
      FOR li_cnt = 1 TO gr_dblist.getLength()
          IF gr_dblist[li_cnt].chk = "Y" AND gr_dblist[li_cnt].azp03 != "ds" THEN
             CALL bpatch_patch_schema_alter_index(gr_dblist[li_cnt].azp03 CLIPPED) RETURNING li_result
          END IF
      END FOR
      IF NOT os.Path.size(g_logpath||"patch_otherdb_alter_index.log") THEN
         DISPLAY "accept" TO FORMONLY.img07
      ELSE
         DISPLAY "cancel" TO FORMONLY.img07
         CALL bpatch_show_msg("alter 其他資料庫的index有誤, 請查看log, 手動更新")
         RETURN
      END IF
      CALL ui.Interface.refresh()
   END IF
END FUNCTION

#由patchtemp匯入系統資料到ds資料庫 (全步驟)
FUNCTION bpatch_patch_data()
   DEFINE   li_result   LIKE type_file.num5

   IF g_c07 = "Y" THEN
      CALL g_steprecord.write("#4-1"||" ("||TODAY||" "||TIME(CURRENT)||")")
      # 解出上資料patch的資料庫或檔案
      # ORA,IFX,UNI為B5版本的話, import patch內附加的patchtemp資料庫
      # ORA,IFX 為GB版本的話, 先解壓縮patch內的patchtemp_data.tar, 再load txt檔案進patchtemp
      LET li_result = FALSE
      CASE
         WHEN g_db = "ORA" AND (g_code = "B5" OR g_code = "UN")
            CALL bpatch_patch_data_start() RETURNING li_result
         WHEN g_db = "ORA" AND g_code = "GB"
            LET g_cmd = "cd ",g_patchpath,";tar xvf patchtemp_data.tar"
            RUN g_cmd
            IF os.Path.exists(g_patchpath||os.Path.separator()||"patchtemp_data") THEN
               LET li_result = TRUE
            END IF
            CALL bpatch_patch_data_create_patchtemp() RETURNING li_result
            IF li_result THEN
               CALL bpatch_patch_data_load_data() RETURNING li_result
            END IF
         WHEN g_db = "IFX" AND g_code = "B5"
            CALL bpatch_patch_data_start() RETURNING li_result
         WHEN g_db = "IFX" AND g_code = "GB"
            LET g_cmd = "cd ",g_patchpath,";tar xvf patchtemp_data.tar"
            RUN g_cmd
            IF os.Path.exists(g_patchpath||os.Path.separator()||"patchtemp_data") THEN
               LET li_result = TRUE
            END IF
            CALL bpatch_patch_data_create_patchtemp() RETURNING li_result
            IF li_result THEN
               CALL bpatch_patch_data_load_data() RETURNING li_result
            END IF
      END CASE
      IF li_result THEN
         DISPLAY "accept" TO FORMONLY.img08
      ELSE
         DISPLAY "cancel" TO FORMONLY.img08
         RETURN
      END IF
      CALL ui.Interface.refresh()
   END IF

   IF g_c08 = "Y" THEN
      CALL bpatch_step_check("4-2") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      CALL g_steprecord.write("#4-2"||" ("||TODAY||" "||TIME(CURRENT)||")")
      # 將資料更新到ds資料庫, B5,GB,UNICODE所有版本資料目前都在patchtemp內
      LET li_result = FALSE
      CALL bpatch_patch_data_db_update() RETURNING li_result
      IF li_result THEN
         DISPLAY "accept" TO FORMONLY.img09
      ELSE
         DISPLAY "cancel" TO FORMONLY.img09
      END IF
      CALL ui.Interface.refresh()
   END IF
END FUNCTION

#更新TIPTOP所有檔案 (全步驟)
FUNCTION bpatch_patch_update_program()
   DEFINE   li_result   LIKE type_file.num5

   CALL bpatch_step_check("5") RETURNING li_result
   IF NOT li_result THEN
      RETURN
   END IF
   CALL g_steprecord.write("#5"||" ("||TODAY||" "||TIME(CURRENT)||")")
   #備份TIPTOP系統
   IF NOT os.Path.exists(g_backuppath||"tiptop.tar") THEN
      LET g_cmd = "cd $TOP;tar cf ",g_backuppath,"tiptop.tar *"
      RUN g_cmd
   END IF
   IF NOT os.Path.exists(g_backuppath||"tiptop_cust.tar") THEN
      LET g_cmd = "cd $CUST;tar cf ",g_backuppath,"tiptop_cust.tar *"
      RUN g_cmd
   END IF
   IF os.Path.exists(g_backuppath||"tiptop.tar") AND os.Path.exists(g_backuppath||"tiptop_cust.tar") THEN
      DISPLAY "accept" TO FORMONLY.img10
   ELSE
      CALL bpatch_show_msg("程式備份不成功, 請檢查空間是否足夠再重新執行, 或手動備份於其他區域")
      DISPLAY "cancel" TO FORMONLY.img10
      RETURN
   END IF
   CALL ui.Interface.refresh()

   #Unzip
   LET g_cmd = "cd ",g_patchpath,";cp tiptop.tar $TOP;cd $TOP;tar xf tiptop.tar"
   RUN g_cmd
   IF os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"tiptop.tar") THEN
      IF os.Path.delete(FGL_GETENV("TOP")||os.Path.separator()||"tiptop.tar") THEN END IF
   END IF
   DISPLAY "accept" TO FORMONLY.img11
   CALL ui.Interface.refresh()
END FUNCTION

#全系統rebuild
FUNCTION bpatch_patch_rebuild_all()
   DEFINE   li_result   LIKE type_file.num5

   IF g_db_type="ORA" THEN
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
   ELSE
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
   END IF
   IF NOT os.Path.exists(FGL_GETENV("FGLDBPATH")||os.Path.separator()||"ds.sch") THEN
      CALL bpatch_show_msg("未成功產生ds.sch, 請確認原因後再繼續往下動作")
      RETURN
   END IF

   IF g_c09 = "Y" OR g_c10 = "Y" OR g_c11 = "Y" THEN
      LET g_rebuild = base.Channel.create()
      CALL g_rebuild.openFile(g_logpath||"patch_rebuild.log","w")
      CALL g_rebuild.setDelimiter("")
      CALL g_rebuild.write("=======Rebuild Start At "||TODAY||" "||TIME(CURRENT)||"=======")
      CALL g_rebuild.write("")
   END IF

   IF g_c09 = "Y" THEN
      CALL bpatch_step_check("6-1") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      CALL g_steprecord.write("#6-1"||" ("||TODAY||" "||TIME(CURRENT)||")")
      CALL g_rebuild.write("=======Program Compile Error List============")
      CALL bpatch_patch_program_rebuild_rc2()
      DISPLAY "accept" TO FORMONLY.img12
      CALL ui.Interface.refresh()
      CALL g_rebuild.write("")
   END IF

   IF g_c10 = "Y" THEN
      CALL bpatch_step_check("6-2") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      CALL g_steprecord.write("#6-2"||" ("||TODAY||" "||TIME(CURRENT)||")")
      CALL g_rebuild.write("=======Program link Error List===============")
      CALL bpatch_patch_program_rebuild_rl2() RETURNING li_result
      IF li_result THEN
         DISPLAY "accept" TO FORMONLY.img13
      ELSE
         DISPLAY "cancel" TO FORMONLY.img13
         RETURN
      END IF
      CALL ui.Interface.refresh()
      CALL g_rebuild.write("")
   END IF

   IF g_c11 = "Y" THEN
      CALL bpatch_step_check("6-3") RETURNING li_result
      IF NOT li_result THEN
         RETURN
      END IF
      CALL g_steprecord.write("#6-3"||" ("||TODAY||" "||TIME(CURRENT)||")")
      CALL g_rebuild.write("=======Form Compile Error List===============")
      CALL bpatch_patch_program_rebuild_rf2()
      DISPLAY "accept" TO FORMONLY.img14
      CALL ui.Interface.refresh()
      CALL g_rebuild.write("")
   END IF

   IF g_c09 = "Y" OR g_c10 = "Y" OR g_c11 = "Y" THEN
      CALL g_rebuild.write("=======Rebuild End At "||TODAY||" "||TIME(CURRENT)||"=======")
      CALL g_rebuild.close()
   END IF
END FUNCTION

#列出drop column, deflate size, index 三種有疑慮的command, 選擇是否要更新
FUNCTION bpatch_patch_schema_sel_cmd()
   DEFINE   ls_action   STRING
   DEFINE   lc_channel  base.Channel

   CALL bpatch_patch_schema_cmd_analyze()
   OPEN WINDOW alter_cmd_w WITH FORM "bpatch_patch_schema_cmd.42f"
   LET ls_action = "dropcmd"
   IF g_c01 = "N" AND g_c04 = "N" THEN
      CALL bpatch_set_comp_visible("page01,page02",FALSE)
      LET ls_action = "idxcmd"
   END IF
   IF g_c03 = "N" AND g_c06 = "N" THEN
      CALL bpatch_set_comp_visible("page03",FALSE)
      LET ls_action = "dropcmd"
   END IF
   WHILE TRUE
      IF ls_action = "dropcmd" THEN
         INPUT ARRAY gr_dropcmd WITHOUT DEFAULTS FROM s_drop.*
            ATTRIBUTE(COUNT=gr_dropcmd.getLength(),MAXCOUNT=gr_dropcmd.getLength(),UNBUFFERED,
                      INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)
            ON ACTION dropcmd
               LET ls_action = "dropcmd"
               EXIT INPUT
            ON ACTION defcmd
               LET ls_action = "defcmd"
               EXIT INPUT
            ON ACTION idxcmd
               LET ls_action = "idxcmd"
               EXIT INPUT
            AFTER INPUT
               LET ls_action = "exit"
               EXIT INPUT
         END INPUT
         IF ls_action = "exit" THEN
            EXIT WHILE
         END IF
      END IF
      IF ls_action = "defcmd" THEN
         INPUT ARRAY gr_defcmd WITHOUT DEFAULTS FROM s_def.*
            ATTRIBUTE(COUNT=gr_defcmd.getLength(),MAXCOUNT=gr_defcmd.getLength(),UNBUFFERED,
                      INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)
            ON ACTION dropcmd
               LET ls_action = "dropcmd"
               EXIT INPUT
            ON ACTION defcmd
               LET ls_action = "defcmd"
               EXIT INPUT
            ON ACTION idxcmd
               LET ls_action = "idxcmd"
               EXIT INPUT
            AFTER INPUT
               LET ls_action = "exit"
               EXIT INPUT
         END INPUT
         IF ls_action = "exit" THEN
            EXIT WHILE
         END IF
      END IF
      IF ls_action = "idxcmd" THEN
         INPUT ARRAY gr_idxcmd WITHOUT DEFAULTS FROM s_index.*
            ATTRIBUTE(COUNT=gr_idxcmd.getLength(),MAXCOUNT=gr_idxcmd.getLength(),UNBUFFERED,
                      INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)
            ON ACTION dropcmd
               LET ls_action = "dropcmd"
               EXIT INPUT
            ON ACTION defcmd
               LET ls_action = "defcmd"
               EXIT INPUT
            ON ACTION idxcmd
               LET ls_action = "idxcmd"
               EXIT INPUT
            AFTER INPUT
               LET ls_action = "exit"
               EXIT INPUT
         END INPUT
         IF ls_action = "exit" THEN
            EXIT WHILE
         END IF
      END IF
   END WHILE
   CLOSE WINDOW alter_cmd_w

   IF NOT INT_FLAG THEN
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(g_logpath||"patch_alter_table_noexe.log","w")
      CALL lc_channel.setDelimiter("")
      CALL lc_channel.write("以下為選擇不更新的alter table清單 : ")
      CALL lc_channel.write("(若日後要更新請查看"||g_logpath||"patch_alter_table_noexe.log)")
      FOR g_cnt = 1 TO gr_dropcmd.getLength()
          IF gr_dropcmd[g_cnt].exe = "N" THEN
             LET gr_noexecmd[gr_noexecmd.getLength()+1] = gr_dropcmd[g_cnt].cmd
             LET gr_cmd[gr_dropcmd[g_cnt].relate].exe = "N"
             CALL lc_channel.write(gr_dropcmd[g_cnt].cmd)
          END IF
      END FOR

      FOR g_cnt = 1 TO gr_defcmd.getLength()
          IF gr_defcmd[g_cnt].exe = "N" THEN
             LET gr_noexecmd[gr_noexecmd.getLength()+1] = gr_defcmd[g_cnt].cmd
             LET gr_cmd[gr_defcmd[g_cnt].relate].exe = "N"
             CALL lc_channel.write(gr_defcmd[g_cnt].cmd)
          END IF
      END FOR
      CALL lc_channel.write("")
      CALL lc_channel.close()

      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(g_logpath||"patch_alter_index_noexe.log","w")
      CALL lc_channel.setDelimiter("")
      CALL lc_channel.write("以下為選擇不更新的alter index清單 : ")
      CALL lc_channel.write("(若日後要更新請查看"||g_logpath||"patch_alter_index_noexe.log)")
      FOR g_cnt = 1 TO gr_idxcmd.getLength()
          IF gr_idxcmd[g_cnt].exe = "N" THEN
             LET gr_noexeicmd[gr_noexeicmd.getLength()+1] = gr_idxcmd[g_cnt].cmd
             CALL lc_channel.write(gr_idxcmd[g_cnt].cmd)
          END IF
      END FOR
      CALL lc_channel.write("")
      CALL lc_channel.close()
   END IF
END FUNCTION

#用zs資料處理alter清單, 但步驟順序不可略過, 會有問題
#解析patch所有更新的SQL command與新版schema, 與客戶端資料庫比對, 若相同則不進行
FUNCTION bpatch_patch_schema_cmd_analyze()
   DEFINE   lc_channel   base.Channel
   DEFINE   lc_writenew1 base.Channel
   DEFINE   lc_writenew2 base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_cmd       STRING
   DEFINE   li_dropcnt   LIKE type_file.num10
   DEFINE   li_sizecnt   LIKE type_file.num10
   DEFINE   lc_db_type   CHAR(15)
   DEFINE   ls_db_size   STRING
   DEFINE   lc_nullable  LIKE type_file.chr1
   DEFINE   lc_default   LIKE type_file.chr1000
   DEFINE   ls_table     STRING
   DEFINE   ls_column    STRING
   DEFINE   ls_type      STRING
   DEFINE   ls_size      STRING
   DEFINE   li_size      LIKE type_file.num5
   DEFINE   ls_other     STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   ls_sql       STRING
   DEFINE   li_db_cnt    LIKE type_file.num5
   DEFINE   li_cnt       LIKE type_file.num5

   # 讀檔 ds table alter file 指令進gr_cmd array
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||"table_alter_ds.txt","r")
   LET g_cnt = 1
   LET li_dropcnt = 1
   LET li_sizecnt = 1
   WHILE lc_channel.read(ls_result)
      IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
         LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
      END IF

      LET gr_cmd[g_cnt].exe = "Y"
      LET gr_cmd[g_cnt].cmd = ls_result

      CASE
         WHEN ls_result.getIndexOf(" drop(",1)
            LET gr_dropcmd[li_dropcnt].exe = "Y"
            LET gr_dropcmd[li_dropcnt].cmd = ls_result
            LET gr_dropcmd[li_dropcnt].relate = g_cnt
            LET li_dropcnt = li_dropcnt + 1
         WHEN ls_result.getIndexOf(" drop column ",1)
            LET gr_dropcmd[li_dropcnt].exe = "Y"
            LET gr_dropcmd[li_dropcnt].cmd = ls_result
            LET gr_dropcmd[li_dropcnt].relate = g_cnt
            LET li_dropcnt = li_dropcnt + 1
         WHEN ls_result.getIndexOf("modify(",1)
            LET ls_table = ls_result.subString(ls_result.getIndexOf("alter table ",1)+12,ls_result.getLength())
            LET ls_table = ls_table.subString(1,ls_table.getIndexOf("modify(",1)-2)
            LET ls_column = ls_result.subString(ls_result.getIndexOf("modify(",1)+7,ls_result.getLength())
            LET ls_column = ls_column.subString(1,ls_column.getIndexOf(" ",1)-1)
            LET ls_type = ls_result.subString(ls_result.getIndexOf(ls_column,1)+ls_column.getLength(),ls_result.getLength())
            LET ls_type = ls_type.subString(1,ls_type.getIndexOf("(",1)-1)
            LET ls_type = ls_type.trim()
            LET ls_size = ls_result.subString(ls_result.getIndexOf(ls_type,1)+ls_type.getLength(),ls_result.getLength())
            IF ls_size.subString(1,1) = "(" THEN
               LET ls_size = ls_size.subString(2,ls_size.getIndexOf(")",1)-1)
            ELSE
               LET ls_size = NULL
            END IF
            LET li_size = ls_size
            CALL cl_get_column_info("ds",ls_table,ls_column) RETURNING lc_db_type,ls_db_size,lc_nullable,lc_default
            IF ls_type != lc_db_type CLIPPED OR ls_size < ls_db_size THEN
               LET gr_defcmd[li_sizecnt].exe = "Y"
               LET gr_defcmd[li_sizecnt].cmd = ls_result
               LET gr_defcmd[li_sizecnt].relate = g_cnt
               LET li_sizecnt = li_sizecnt + 1
            END IF
      END CASE
      LET g_cnt = g_cnt + 1
   END WHILE
   CALL lc_channel.close()

   # 讀檔 ds index alter file 指令進gr_idxcmd array
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||"index_alter_ds.txt","r")
   LET g_cnt = 1
   WHILE lc_channel.read(ls_result)
      IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
         LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
      END IF
      LET gr_idxcmd[g_cnt].exe = "Y"
      LET gr_idxcmd[g_cnt].cmd = ls_result
      LET g_cnt = g_cnt + 1
   END WHILE
   CALL lc_channel.close()

   # 讀檔 other table alter file 指令進gr_cmd_o array
   LET li_db_cnt = gr_dblist.getLength()-1
   LET ls_sql = "SELECT COUNT(*) FROM all_synonyms WHERE table_name=?"
   PREPARE synonym_pre FROM ls_sql

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||"table_alter_other.txt","r")
   LET g_cnt = 1
   WHILE lc_channel.read(ls_result)
      IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
         LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
      END IF
      LET gr_cmd_o[g_cnt] = ls_result
      LET g_cnt = g_cnt + 1
   END WHILE
   CALL lc_channel.close()

   # 讀檔 other index alter file 指令進gr_idxcmd_o array
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||"index_alter_other.txt","r")
   LET g_cnt = 1
   WHILE lc_channel.read(ls_result)
      IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
         LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
      END IF
      LET gr_idxcmd_o[g_cnt] = ls_result
      LET g_cnt = g_cnt + 1
   END WHILE
   CALL lc_channel.close()
END FUNCTION

#指定資料庫進行alter table
FUNCTION bpatch_patch_schema_alter_table(ps_dbs)
   DEFINE   ps_dbs           LIKE azp_file.azp03
   DEFINE   lc_channel       base.Channel
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   li_exe           LIKE type_file.num5
   DEFINE   lc_createtb      base.Channel
   DEFINE   ls_result        STRING
   DEFINE   ls_cmd           STRING
   DEFINE   li_createstart   LIKE type_file.num5
   DEFINE   ls_memostr       STRING
   DEFINE   li_result        LIKE type_file.num5
   DEFINE   lc_chr10         LIKE type_file.chr10  #固定格式用
   DEFINE   lc_chr14         LIKE type_file.chr14

   IF g_db_type = "ORA" THEN
      LET ls_memostr = "/*"
   ELSE
      LET ls_memostr = "{"
   END IF

   LET li_result = TRUE
   #ds與其他資料庫的分開處理
   IF ps_dbs = "ds" THEN
      DATABASE ds
      IF SQLCA.sqlcode THEN
         RETURN FALSE
      END IF
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(g_logpath||"patch_ds_alter_table.log","w")
      CALL lc_channel.setDelimiter("")
      FOR g_cnt = 1 TO gr_cmd.getLength()
          IF gr_cmd[g_cnt].exe = "Y" THEN
             IF gr_cmd[g_cnt].cmd.getIndexOf("create table",1) THEN
                LET li_cnt = 0
                WHILE gr_cmd[g_cnt].cmd.getIndexOf("/",li_cnt+1)
                   LET li_cnt = gr_cmd[g_cnt].cmd.getIndexOf("/",li_cnt+1)
                END WHILE
                LET g_file = gr_cmd[g_cnt].cmd.subString(li_cnt+1,gr_cmd[g_cnt].cmd.getIndexOf("}",1)-1)
                IF NOT os.Path.exists(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file) THEN
                   LET g_file = g_file.subString(1,g_file.getIndexOf(".src",1)-1)
                END IF
                LET li_createstart = FALSE
                LET ls_cmd = ""
                LET lc_createtb = base.Channel.create()
                CALL lc_createtb.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file,"r")
                WHILE lc_createtb.read(ls_result)
                   LET ls_result = ls_result.trim()
                   IF ls_result.getIndexOf(ls_memostr,1) > 1 THEN
                      LET ls_result = ls_result.subString(1,ls_result.getIndexOf(ls_memostr,1)-1)
                   END IF
                   CASE
                      WHEN ls_result.getIndexOf("create table",1)
                         LET li_createstart = TRUE
                         LET ls_cmd = ls_result
                      WHEN ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";"
                         IF li_createstart THEN
                            LET ls_cmd = ls_cmd," ",ls_result
                            LET li_createstart = FALSE
                         ELSE
                            LET ls_cmd = ls_result
                         END IF
                         LET ls_cmd = ls_cmd.subString(1,ls_cmd.getLength()-1)
                         EXECUTE IMMEDIATE ls_cmd
                         IF SQLCA.sqlcode THEN
                            IF li_result THEN
                               CALL lc_channel.write("以下為alter不成功的txt行數,錯誤碼與指令 : ")
                               CALL lc_channel.write("(記錄於"||g_logpath||"patch_ds_alter_table.log)")
                               CALL lc_channel.write("")
                               CALL lc_channel.write("原始檔行數  錯誤碼          指令內容")
                               LET li_result = FALSE
                            END IF
                            LET lc_chr10 = g_cnt USING "##########"
                            IF g_db_type = "ORA" THEN
                               LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                            ELSE
                               LET lc_chr14 = SQLCA.sqlcode USING "-----"
                            END IF
                            CALL lc_channel.write(lc_chr10||"  "||lc_chr14||"  "||ls_cmd)
                         END IF
                      OTHERWISE
                         IF li_createstart THEN
                            LET ls_cmd = ls_cmd," ",ls_result
                         END IF
                   END CASE
                END WHILE
                CALL lc_createtb.close()
             ELSE
                EXECUTE IMMEDIATE gr_cmd[g_cnt].cmd
                IF SQLCA.sqlcode THEN
                   IF li_result THEN
                      CALL lc_channel.write("以下為alter不成功的txt行數,錯誤碼與指令 : ")
                      CALL lc_channel.write("(記錄於"||g_logpath||"patch_ds_alter_table.log)")
                      CALL lc_channel.write("")
                      CALL lc_channel.write("原始檔行數  錯誤碼          指令內容")
                      LET li_result = FALSE
                   END IF
                   LET lc_chr10 = g_cnt USING "##########"
                   IF g_db_type = "ORA" THEN
                      LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                   ELSE
                      LET lc_chr14 = SQLCA.sqlcode USING "-----"
                   END IF
                   CALL lc_channel.write(lc_chr10||"  "||lc_chr14||"  "||gr_cmd[g_cnt].cmd)
                END IF
             END IF
          END IF
      END FOR
      CALL lc_channel.write("")
      CALL lc_channel.close()
   ELSE
      DATABASE ps_dbs
      IF SQLCA.sqlcode THEN
         RETURN FALSE
      END IF
      IF g_startlog THEN
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openFile(g_logpath||"patch_otherdb_alter_table.log","w")
         CALL lc_channel.setDelimiter("")
         LET g_startlog = FALSE
      ELSE
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openFile(g_logpath||"patch_otherdb_alter_table.log","a")
         CALL lc_channel.setDelimiter("")
      END IF

      FOR g_cnt = 1 TO gr_cmd_o.getLength()
          LET li_exe = TRUE
          FOR li_cnt = 1 TO gr_noexecmd.getLength()
              IF gr_cmd_o[g_cnt] = gr_noexecmd[li_cnt] THEN
                 LET li_exe = FALSE
                 EXIT FOR
              END IF
          END FOR
          IF NOT li_exe THEN
             CONTINUE FOR
          END IF
          IF gr_cmd_o[g_cnt].getIndexOf("create table",1) THEN
             LET li_cnt = 0
             WHILE gr_cmd_o[g_cnt].getIndexOf("/",li_cnt+1)
                LET li_cnt = gr_cmd_o[g_cnt].getIndexOf("/",li_cnt+1)
             END WHILE
             LET g_file = gr_cmd_o[g_cnt].subString(li_cnt+1,gr_cmd_o[g_cnt].getIndexOf("}",1)-1)
             IF NOT os.Path.exists(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file) THEN
                LET g_file = g_file.subString(1,g_file.getIndexOf(".src",1)-1)
             END IF
             LET lc_createtb = base.Channel.create()
             CALL lc_createtb.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file,"r")
             WHILE lc_createtb.read(ls_result)
                   LET ls_result = ls_result.trim()
                IF ls_result.getIndexOf(ls_memostr,1) > 1 THEN
                   LET ls_result = ls_result.subString(1,ls_result.getIndexOf(ls_memostr,1)-1)
                END IF
                CASE
                   WHEN ls_result.getIndexOf("create table",1)
                      LET li_createstart = TRUE
                      LET ls_cmd = ls_result
                   WHEN ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";"
                      IF li_createstart THEN
                         LET ls_cmd = ls_cmd," ",ls_result
                         LET li_createstart = FALSE
                      ELSE
                         LET ls_cmd = ls_result
                      END IF
                      LET ls_cmd = ls_cmd.subString(1,ls_cmd.getLength()-1)
                      EXECUTE IMMEDIATE ls_cmd
                      IF SQLCA.sqlcode THEN
                         IF li_result THEN
                            CALL lc_channel.write("")
                            CALL lc_channel.write("")
                            CALL lc_channel.write("以下為"||ps_dbs||" alter不成功的txt行數,錯誤碼與指令 : ")
                            CALL lc_channel.write("(記錄於"||g_logpath||"patch_ds_alter_table.log)")
                            CALL lc_channel.write("")
                            CALL lc_channel.write("原始檔行數  錯誤碼          指令內容")
                            LET li_result = FALSE
                         END IF
                         LET lc_chr10 = g_cnt USING "##########"
                         IF g_db_type = "ORA" THEN
                            LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                         ELSE
                            LET lc_chr14 = SQLCA.sqlcode USING "-----"
                         END IF
                         CALL lc_channel.write(lc_chr10||"  "||lc_chr14||"  "||ls_cmd)
                      END IF
                   OTHERWISE
                      IF li_createstart THEN
                         LET ls_cmd = ls_cmd," ",ls_result
                      END IF
                END CASE
             END WHILE
             CALL lc_createtb.close()
          ELSE
             EXECUTE IMMEDIATE gr_cmd_o[g_cnt]
             IF SQLCA.sqlcode THEN
                IF li_result THEN
                   CALL lc_channel.write("以下為"||ps_dbs||" alter不成功的txt行數,錯誤碼與指令 : ")
                   CALL lc_channel.write("(記錄於"||g_logpath||"patch_otherdb_alter_table.log)")
                   CALL lc_channel.write("")
                   CALL lc_channel.write("原始檔行數  錯誤碼          指令內容")
                   LET li_result = FALSE
                END IF
                LET lc_chr10 = g_cnt USING "##########"
                IF g_db_type = "ORA" THEN
                   LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                ELSE
                   LET lc_chr14 = SQLCA.sqlcode USING "-----"
                END IF
                CALL lc_channel.write(lc_chr10||"  "||lc_chr14||"  "||gr_cmd_o[g_cnt])
             END IF
          END IF
      END FOR
      IF g_endlog THEN
         CALL lc_channel.write("")
         CALL lc_channel.close()
         LET g_endlog = FALSE
      END IF
      CLOSE DATABASE
      DATABASE ds
   END IF

   RETURN li_result
END FUNCTION

#指定資料庫進行alter index
FUNCTION bpatch_patch_schema_alter_index(ps_dbs)
   DEFINE   ps_dbs           LIKE azp_file.azp03
   DEFINE   lc_channel       base.Channel
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   li_exe           LIKE type_file.num5
   DEFINE   lc_createtb      base.Channel
   DEFINE   ls_result        STRING
   DEFINE   ls_cmd           STRING
   DEFINE   li_createstart   LIKE type_file.num5
   DEFINE   li_result        LIKE type_file.num5

   LET li_result = TRUE
   #也是分ds跟其他資料庫進行
   IF ps_dbs = "ds" THEN
      DATABASE ds
      IF SQLCA.sqlcode THEN
         RETURN FALSE
      END IF
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(g_logpath||"patch_ds_alter_index.log","w")
      CALL lc_channel.setDelimiter("")
      FOR g_cnt = 1 TO gr_idxcmd.getLength()
          IF gr_idxcmd[g_cnt].exe = "Y" THEN
             EXECUTE IMMEDIATE gr_idxcmd[g_cnt].cmd
             IF SQLCA.sqlcode THEN
                IF li_result THEN
                   CALL lc_channel.write("以下為alter不成功的txt行數,錯誤碼與指令 : ")
                   CALL lc_channel.write("(記錄於"||g_logpath||"patch_ds_alter_index.log)")
                   LET li_result = FALSE
                END IF
                IF g_db_type = "ORA" THEN
                   CALL lc_channel.write(g_cnt||"     "||SQLCA.sqlcode||"("||SQLCA.sqlerrd[2]||")     "||gr_idxcmd[g_cnt].cmd)
                ELSE
                   CALL lc_channel.write(g_cnt||"     "||SQLCA.sqlcode||"     "||gr_idxcmd[g_cnt].cmd)
                END IF
             END IF
          END IF
      END FOR
      CALL lc_channel.write("")
      CALL lc_channel.close()
   ELSE
      DATABASE ps_dbs
      IF SQLCA.sqlcode THEN
         RETURN FALSE
      END IF
      IF g_startlog THEN
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openFile(g_logpath||"patch_otherdb_alter_index.log","a")
         CALL lc_channel.setDelimiter("")
         LET g_startlog = FALSE
      END IF

      FOR g_cnt = 1 TO gr_idxcmd_o.getLength()
          LET li_exe = TRUE
          FOR li_cnt = 1 TO gr_noexeicmd.getLength()
              IF gr_idxcmd_o[g_cnt] = gr_noexeicmd[li_cnt] THEN
                 LET li_exe = FALSE
                 EXIT FOR
              END IF
          END FOR
          IF NOT li_exe THEN
             CONTINUE FOR
          END IF
          EXECUTE IMMEDIATE gr_idxcmd_o[g_cnt]
          IF SQLCA.sqlcode THEN
             IF li_result THEN
                CALL lc_channel.write("以下為"||ps_dbs||" alter不成功的txt行數,錯誤碼與指令 : ")
                CALL lc_channel.write("(記錄於"||g_logpath||"patch_otherdb_alter_index.log)")
                LET li_result = FALSE
             END IF
             IF g_db_type = "ORA" THEN
                CALL lc_channel.write(g_cnt||"     "||SQLCA.sqlcode||"("||SQLCA.sqlerrd[2]||")     "||gr_idxcmd_o[g_cnt])
             ELSE
                CALL lc_channel.write(g_cnt||"     "||SQLCA.sqlcode||"     "||gr_idxcmd_o[g_cnt])
             END IF
          END IF
      END FOR
      IF g_endlog THEN
         CALL lc_channel.write("")
         CALL lc_channel.close()
         LET g_endlog = FALSE
      END IF
      CLOSE DATABASE
      DATABASE ds
   END IF

   RETURN li_result
END FUNCTION

FUNCTION bpatch_patch_schema_diffdb_alter()
   DEFINE   lc_dbs      LIKE azp_file.azp03
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_memostr  STRING
   DEFINE   lc_channel  base.Channel
   DEFINE   lc_writelog base.Channel
   DEFINE   ls_result   STRING
   DEFINE   lc_chr14    LIKE type_file.chr14
   DEFINE   li_cb_flag  LIKE type_file.num5
   DEFINE   ls_cb_cmd   STRING

   PROMPT '請指定資料庫代碼: ' FOR lc_dbs
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
   LET li_result = FALSE
   FOR g_cnt = 1 TO gr_dblist.getLength()
       IF lc_dbs CLIPPED = gr_dblist[g_cnt].azp03 CLIPPED THEN
          LET li_result = TRUE
          EXIT FOR
       END IF
   END FOR
   IF NOT li_result THEN
      CALL bpatch_show_msg("你選擇的資料庫代碼不在列表中")
      RETURN
   END IF

   IF lc_dbs = "ds" THEN
      LET g_cmd = "diffdb.sh ds_patch ds 5 ",g_patchpath,os.Path.separator(),"ds_patch.sch $FGLDBPATH",os.Path.separator(),"ds.sch"
   ELSE
      LET g_cmd = "diffdb.sh ds1_patch ",lc_dbs CLIPPED," 5 ",g_patchpath,os.Path.separator(),"ds1_patch.sch $FGLDBPATH",os.Path.separator(),lc_dbs CLIPPED,".sch"
   END IF
   RUN g_cmd

   IF NOT os.Path.exists(g_tempdir||lc_dbs CLIPPED||"_command.sql") THEN
      CALL bpatch_show_msg("未產生比對後資料, 不進行Alter")
      RETURN
   END IF

   IF g_db_type = "ORA" THEN
      LET ls_memostr = "/*"
   ELSE
      LET ls_memostr = "{"
   END IF

   LET li_result = TRUE
   CLOSE DATABASE
   DATABASE lc_dbs
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_tempdir||lc_dbs CLIPPED||"_command.sql","r")
   LET lc_writelog = base.Channel.create()
   CALL lc_writelog.openFile(g_logpath||"diffdb_"||lc_dbs CLIPPED||"_alter_table.log","w")
   CALL lc_writelog.setDelimiter("")
   WHILE lc_channel.read(ls_result)
      IF ls_result.getIndexOf(ls_memostr,1) THEN
         LET ls_result = ls_result.subString(1,ls_result.getIndexOf(ls_memostr,1)-1)
      END IF
      IF ls_result.trim() IS NULL THEN
         CONTINUE WHILE
      END IF
      IF ls_result.getIndexOf("create table",1) THEN
         LET li_cb_flag = TRUE
         LET ls_cb_cmd = ls_result
         CONTINUE WHILE
      END IF
      IF li_cb_flag THEN
         IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
            LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
            LET li_cb_flag = FALSE
            LET ls_cb_cmd = ls_cb_cmd," ",ls_result
            LET ls_result = ls_cb_cmd
            LET ls_cb_cmd = ""
         ELSE
            LET ls_cb_cmd = ls_cb_cmd," ",ls_result
            CONTINUE WHILE
         END IF
      ELSE
         IF ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";" THEN
            LET ls_result = ls_result.subString(1,ls_result.getLength()-1)
         END IF
      END IF
      EXECUTE IMMEDIATE ls_result
      IF SQLCA.sqlcode THEN
         IF li_result THEN
            CALL lc_writelog.write("以下為使用diffdb工具alter不成功的錯誤碼與指令 : ")
            CALL lc_writelog.write("(記錄於"||g_logpath||"diffdb_"||lc_dbs CLIPPED||"_alter_table.log)")
            CALL lc_writelog.write("")
            CALL lc_writelog.write("錯誤碼          指令內容")
            LET li_result = FALSE
         END IF
         IF g_db_type = "ORA" THEN
            LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
         ELSE
            LET lc_chr14 = SQLCA.sqlcode USING "-----"
         END IF
         CALL lc_writelog.write(lc_chr14||"  "||ls_result)
      END IF
   END WHILE
   CALL lc_channel.close()
   CALL lc_writelog.close()
   CLOSE DATABASE
   DATABASE ds

   IF g_db_type="ORA" THEN
      LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",lc_dbs CLIPPED," -ow ",lc_dbs CLIPPED," -ie"
      RUN g_cmd
   ELSE
      LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",lc_dbs CLIPPED," -ie"
      RUN g_cmd
   END IF
   CALL bpatch_patch_view_file(g_logpath||"diffdb_"||lc_dbs CLIPPED||"_alter_table.log")
END FUNCTION

#import patchtemp資料庫, 當碼別為B5與UN時的處理方式
FUNCTION bpatch_patch_data_start()
   DEFINE   l_cmd              STRING
   DEFINE   l_sql              STRING
   DEFINE   l_result           SMALLINT
   DEFINE   lc_channel         base.Channel
   DEFINE   l_str              STRING
   DEFINE   l_tempdir          STRING
   DEFINE   readfile_channel   base.Channel

   IF g_db_type = "ORA" THEN
      LET lc_channel = base.Channel.create()
      LET l_str = "import_data.sh"
      CALL lc_channel.openFile(l_str,"w")
      CALL lc_channel.setDelimiter("")
      CALL lc_channel.write("#!/bin/ksh")
      CALL lc_channel.write("ex - <<%%")
      CALL lc_channel.write("a")
      CALL lc_channel.write("conn system/manager@`echo $ORACLE_SID`;")
      CALL lc_channel.write("drop user patchtemp cascade;")
      CALL lc_channel.write("create user patchtemp identified by patchtemp")
      LET l_cmd="default tablespace ",g_dbs CLIPPED
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write("temporary tablespace temp;")
      CALL lc_channel.write("grant create session,create table to patchtemp;")
      CALL lc_channel.write("grant resource to patchtemp;")
      CALL lc_channel.write("grant create synonym to patchtemp;")
      CALL lc_channel.write("conn sys/change_on_install@`echo $ORACLE_SID` as sysdba;")   
      CALL lc_channel.write("grant select on sys.v_\\$session to patchtemp;")  
      CALL lc_channel.write("exit;")
      CALL lc_channel.write(".")
      CALL fgl_getenv("TEMPDIR") RETURNING l_str
      LET l_str="w! ",l_str CLIPPED,"/createdb.sql"
      CALL lc_channel.write(l_str CLIPPED)
      CALL lc_channel.write("q")
      CALL lc_channel.write("%%")
      CALL lc_channel.write("sqlplus system/manager@$ORACLE_SID < $TEMPDIR/createdb.sql")
      CALL lc_channel.write("cd $TOP/ora/work")
      CALL fgl_getenv("TOP") RETURNING l_str
      LET l_str="imp patchtemp/patchtemp@$ORACLE_SID file=",g_patchpath,os.Path.separator(),"patchtemp.dmp ignore=y"
      CALL lc_channel.write(l_str)
      CALL lc_channel.close() 
      RUN "chmod 777 $TEMPDIR/createdb.sql"
      RUN "chmod 777 import_data.sh"
      RUN "import_data.sh"
   ELSE
      RUN "echo 'drop database patchtemp'|dbaccess"
      LET l_cmd="dbimport patchtemp -l -d ",g_dbs CLIPPED
      RUN l_cmd
   END IF

   DATABASE patchtemp
   IF SQLCA.sqlcode THEN
      CALL bpatch_show_msg("Create patchtemp DB error!")
      RETURN FALSE
   END IF
   CLOSE DATABASE
   DATABASE ds

   RETURN TRUE
END FUNCTION

#create patchtemp資料庫, 當碼別為GB時的處理步驟 1
FUNCTION bpatch_patch_data_create_patchtemp()
   IF g_db_type = "ORA" THEN
      RUN 'patchtemp.sh'
      LET g_center = "."
   ELSE
      RUN 'patchtemp_info.sh'
      LET g_center = ":"
   END IF

   DATABASE patchtemp
   IF SQLCA.sqlcode THEN
      CALL bpatch_show_msg("Create patchtemp DB error!")
      RETURN FALSE
   END IF
   CLOSE DATABASE
   DATABASE ds

   RETURN TRUE
END FUNCTION

#load patch內的txt檔進patchtemp資料庫, 當碼別為GB的處理步驟 2
FUNCTION bpatch_patch_data_load_data()
   LOAD FROM "bpatch_ze.txt"    INSERT INTO patchtemp.ze_file 
   LOAD FROM "bpatch_zz.txt"    INSERT INTO patchtemp.zz_file 
   LOAD FROM "bpatch_zm.txt"    INSERT INTO patchtemp.zm_file 
   LOAD FROM "bpatch_gap.txt"   INSERT INTO patchtemp.gap_file
   LOAD FROM "bpatch_gbd.txt"   INSERT INTO patchtemp.gbd_file
   LOAD FROM "bpatch_gae.txt"   INSERT INTO patchtemp.gae_file
   LOAD FROM "bpatch_gak.txt"   INSERT INTO patchtemp.gak_file
   LOAD FROM "bpatch_gal.txt"   INSERT INTO patchtemp.gal_file
   LOAD FROM "bpatch_gaq.txt"   INSERT INTO patchtemp.gaq_file
   LOAD FROM "bpatch_gab.txt"   INSERT INTO patchtemp.gab_file
   LOAD FROM "bpatch_gac.txt"   INSERT INTO patchtemp.gac_file
   LOAD FROM "bpatch_gav.txt"   INSERT INTO patchtemp.gav_file
   LOAD FROM "bpatch_gat.txt"   INSERT INTO patchtemp.gat_file
   LOAD FROM "bpatch_gaz.txt"   INSERT INTO patchtemp.gaz_file
   LOAD FROM "bpatch_wsa.txt"   INSERT INTO patchtemp.wsa_file
   LOAD FROM "bpatch_wsb.txt"   INSERT INTO patchtemp.wsb_file
   LOAD FROM "bpatch_zaa.txt"   INSERT INTO patchtemp.zaa_file
   LOAD FROM "bpatch_zab.txt"   INSERT INTO patchtemp.zab_file
   LOAD FROM "bpatch_gao.txt"   INSERT INTO patchtemp.gao_file
   LOAD FROM "bpatch_gba.txt"   INSERT INTO patchtemp.gba_file
   LOAD FROM "bpatch_gbb.txt"   INSERT INTO patchtemp.gbb_file
   LOAD FROM "bpatch_gax.txt"   INSERT INTO patchtemp.gax_file
   LOAD FROM "bpatch_gbf.txt"   INSERT INTO patchtemp.gbf_file
   LOAD FROM "bpatch_zad.txt"   INSERT INTO patchtemp.zad_file
   LOAD FROM "bpatch_zae.txt"   INSERT INTO patchtemp.zae_file
   LOAD FROM "bpatch_wca.txt"   INSERT INTO patchtemp.wca_file
   LOAD FROM "bpatch_wcb.txt"   INSERT INTO patchtemp.wcb_file
   LOAD FROM "bpatch_wcc.txt"   INSERT INTO patchtemp.wcc_file
   LOAD FROM "bpatch_wcd.txt"   INSERT INTO patchtemp.wcd_file
   LOAD FROM "bpatch_zaw.txt"   INSERT INTO patchtemp.zaw_file
   LOAD FROM "bpatch_zav.txt"   INSERT INTO patchtemp.zav_file
   LOAD FROM "bpatch_zai.txt"   INSERT INTO patchtemp.zai_file
   LOAD FROM "bpatch_zaj.txt"   INSERT INTO patchtemp.zaj_file
   LOAD FROM "bpatch_zak.txt"   INSERT INTO patchtemp.zak_file
   LOAD FROM "bpatch_zal.txt"   INSERT INTO patchtemp.zal_file
   LOAD FROM "bpatch_zam.txt"   INSERT INTO patchtemp.zam_file
   LOAD FROM "bpatch_zan.txt"   INSERT INTO patchtemp.zan_file
   LOAD FROM "bpatch_zao.txt"   INSERT INTO patchtemp.zao_file
   LOAD FROM "bpatch_zap.txt"   INSERT INTO patchtemp.zap_file
   LOAD FROM "bpatch_zaq.txt"   INSERT INTO patchtemp.zaq_file
   LOAD FROM "bpatch_zar.txt"   INSERT INTO patchtemp.zar_file
   LOAD FROM "bpatch_zas.txt"   INSERT INTO patchtemp.zas_file
   LOAD FROM "bpatch_zat.txt"   INSERT INTO patchtemp.zat_file
   LOAD FROM "bpatch_zau.txt"   INSERT INTO patchtemp.zau_file
   LOAD FROM "bpatch_zay.txt"   INSERT INTO patchtemp.zay_file
   LOAD FROM "bpatch_wsm.txt"   INSERT INTO patchtemp.wsm_file
   LOAD FROM "bpatch_wsn.txt"   INSERT INTO patchtemp.wsn_file
   LOAD FROM "bpatch_wso.txt"   INSERT INTO patchtemp.wso_file
   LOAD FROM "bpatch_wsp.txt"   INSERT INTO patchtemp.wsp_file

   RETURN TRUE
END FUNCTION

#將patchtemp內的資料放入ds資料庫, 所有patch工具的老做法
FUNCTION bpatch_patch_data_db_update()
   DEFINE   l_cmd        STRING
   DEFINE   l_result     LIKE type_file.num5
   DEFINE   lc_channel   base.Channel
   DEFINE   l_str        STRING
   DEFINE   lr_ze        RECORD LIKE ze_file.*
   DEFINE   lr_zz        RECORD LIKE zz_file.*
   DEFINE   lr_zm        RECORD LIKE zm_file.*
   DEFINE   lr_gap       RECORD LIKE gap_file.*
   DEFINE   lr_gbd       RECORD LIKE gbd_file.*
   DEFINE   lr_gae       RECORD LIKE gae_file.*
   DEFINE   lr_gak       RECORD LIKE gak_file.*
   DEFINE   lr_gal       RECORD LIKE gal_file.*
   DEFINE   lr_gaq       RECORD LIKE gaq_file.*
   DEFINE   lr_gab       RECORD LIKE gab_file.*
   DEFINE   lr_gac       RECORD LIKE gac_file.*
   DEFINE   lr_gav       RECORD LIKE gav_file.*
   DEFINE   lr_gat       RECORD LIKE gat_file.*
   DEFINE   lr_gaz       RECORD LIKE gaz_file.*
   DEFINE   lr_wsa       RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       RECORD LIKE zaa_file.*
   DEFINE   lr_zab       RECORD LIKE zab_file.*
   DEFINE   lr_gao       RECORD LIKE gao_file.*
   DEFINE   lr_gax       RECORD LIKE gax_file.*
   DEFINE   lr_gba       RECORD LIKE gba_file.*
   DEFINE   lr_gbb       RECORD LIKE gbb_file.*
   DEFINE   lr_gbf       RECORD LIKE gbf_file.*
   DEFINE   lr_zad       RECORD LIKE zad_file.*
   DEFINE   lr_zae       RECORD LIKE zae_file.*   
   DEFINE   lr_wca       RECORD LIKE wca_file.*
   DEFINE   lr_wcb       RECORD LIKE wcb_file.*
   DEFINE   lr_wcc       RECORD LIKE wcc_file.*
   DEFINE   lr_wcd       RECORD LIKE wcd_file.*
   DEFINE   lr_zaw       RECORD LIKE zaw_file.*
   DEFINE   lr_zav       RECORD LIKE zav_file.*
   DEFINE   lr_zai       RECORD LIKE zai_file.*
   DEFINE   lr_zaj       RECORD LIKE zaj_file.*
   DEFINE   lr_zak       RECORD LIKE zak_file.*
   DEFINE   lr_zal       RECORD LIKE zal_file.*
   DEFINE   lr_zam       RECORD LIKE zam_file.*
   DEFINE   lr_zan       RECORD LIKE zan_file.*
   DEFINE   lr_zao       RECORD LIKE zao_file.*
   DEFINE   lr_zap       RECORD LIKE zap_file.*
   DEFINE   lr_zaq       RECORD LIKE zaq_file.*
   DEFINE   lr_zar       RECORD LIKE zar_file.*
   DEFINE   lr_zas       RECORD LIKE zas_file.*
   DEFINE   lr_zat       RECORD LIKE zat_file.*
   DEFINE   lr_zau       RECORD LIKE zau_file.*
   DEFINE   lr_zay       RECORD LIKE zay_file.*
   DEFINE   lr_wsm       RECORD LIKE wsm_file.*
   DEFINE   lr_wsn       RECORD LIKE wsn_file.*
   DEFINE   lr_wso       RECORD LIKE wso_file.*
   DEFINE   lr_wsp       RECORD LIKE wsp_file.*

   DEFINE   lc_zz011     LIKE zz_file.zz011
   DEFINE   lc_gal02     LIKE gal_file.gal02
   DEFINE   ls_zz011     STRING
   DEFINE   li_count     LIKE type_file.num10    # 為了要計算一個table做了幾筆資料
   DEFINE   li_count2    LIKE type_file.num10    # 計算patchtemp提供筆數
   DEFINE   ls_msg       STRING

   LET l_result = TRUE   
   LET lc_channel = base.Channel.create()
   LET l_cmd = g_logpath,"patch_update_data.log"
   CALL lc_channel.openFile(l_cmd,"w")
   CALL lc_channel.setDelimiter("")
 
   IF g_db_type = "ORA" THEN 
      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE ze_o_curs CURSOR FOR
              SELECT * FROM patchtemp.ze_file
      FOREACH ze_o_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file patchtemp FOREACH 資料時產生錯誤，ze資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.ze_file VALUES(lr_ze.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.ze_file SET ze_file.* = lr_ze.*
             WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
            IF SQLCA.sqlcode THEN    
               LET l_cmd = "upload ze_file data error:",SQLCA.sqlerrd[2]," ",lr_ze.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"ze_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "ze_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zz_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zz_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zz_file
      FOREACH zz_o_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file patchtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds.zz_file SET zz_file.* = lr_zz.*
                WHERE zz01 = lr_zz.zz01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zz_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gaz_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gaz_file
      FOREACH gaz_o_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file patchtemp FOREACH 資料時產生錯誤，gaz資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gaz_file VALUES(lr_gaz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gaz_file SET gaz_file.* = lr_gaz.* 
             WHERE gaz01 = lr_gaz.gaz01 AND gaz02 = lr_gaz.gaz02 AND gaz05 = lr_gaz.gaz05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaz_file data error:",SQLCA.sqlerrd[2]," ",lr_gaz.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gaz_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gaz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zm_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zm_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zm_file
      FOREACH zm_o_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file patchtemp FOREACH 資料時產生錯誤，zm資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zm_file data error:",SQLCA.sqlerrd[2],"   SQL: UPDATE zm_file SET",
                     " zm01 = '",lr_zm.zm01,"', zm03 = '",lr_zm.zm03,"', zm04 = '",lr_zm.zm04,"' WHERE ",
                     " zm01 = '",lr_zm.zm01,"' AND zm03 ='",lr_zm.zm03,"';"
            CALL lc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zm_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gap_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gap_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gap_file
      FOREACH gap_o_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gap_file patchtemp FOREACH 資料時產生錯誤，gap資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gap_file VALUES(lr_gap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gap_file SET gap_file.* = lr_gap.*
             WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "insert gap_file data error:",SQLCA.sqlerrd[2]," ",lr_gap.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gap_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbd_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbd_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gbd_file
      FOREACH gbd_o_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file patchtemp FOREACH 資料時產生錯誤，gbd資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gbd_file VALUES(lr_gbd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbd_file SET gbd_file.* = lr_gbd.*
             WHERE gbd01 = lr_gbd.gbd01 AND gbd02 = lr_gbd.gbd02
               AND gbd03 = lr_gbd.gbd03 AND gbd07 = lr_gbd.gbd07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbd_file data error:",SQLCA.sqlerrd[2]," ",lr_gbd.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbd_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gae_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gae_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gae_file
      FOREACH gae_o_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file patchtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gae_file SET gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11 AND gae12 = lr_gae.gae12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gae_file data error:",SQLCA.sqlerrd[2]," ",lr_gae.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gae_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gae_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gak_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gak_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gak_file
      FOREACH gak_o_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file patchtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_gak.gak01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds.gak_file SET gak_file.* = lr_gak.*
                WHERE gak01 = lr_gak.gak01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert gak_file data error:",SQLCA.sqlcode," ",lr_gak.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gak_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gal_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gal_file
      FOREACH gal_o_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file patchtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM ds.gal_file
          WHERE gal01 = lr_gal.gal01 #鏈結檔案
            AND gal03 = lr_gal.gal03 #程式代碼
         IF g_cnt >=1 THEN
            #==>存在相同的程式代碼時
            SELECT gal02 INTO lc_gal02
              FROM ds.gal_file
             WHERE gal01 = lr_gal.gal01 
               AND gal03 = lr_gal.gal03
            LET ls_zz011 = lc_gal02 #系統名
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               #不為客製==>更新
               UPDATE ds.gal_file SET gal_file.* = lr_gal.*
                WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               #為客製==>不做任何事
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            INSERT INTO ds.gal_file VALUES(lr_gal.*)
            IF SQLCA.sqlcode THEN
                LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                CALL lc_channel.write(l_cmd)
                LET l_result = FALSE
            ELSE
                LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gal_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gaq_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gaq_file
      FOREACH gaq_o_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file patchtemp FOREACH 資料時產生錯誤，gaq資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gaq_file SET gaq_file.* = lr_gaq.*
             WHERE gaq01 = lr_gaq.gaq01 AND gaq02 = lr_gaq.gaq02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaq_file data error:",SQLCA.sqlerrd[2]," ",lr_gaq.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gaq_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gab_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gab_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gab_file
      FOREACH gab_o_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file patchtemp FOREACH 資料時產生錯誤，gab資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gab_file VALUES(lr_gab.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gab_file SET gab_file.* = lr_gab.*
             WHERE gab01 = lr_gab.gab01 AND gab11 = lr_gab.gab11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gab_file data error:",SQLCA.sqlerrd[2]," ",lr_gab.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gab_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gac_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gac_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gac_file
      FOREACH gac_o_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file patchtemp FOREACH 資料時產生錯誤，gac資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gac_file VALUES(lr_gac.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gac_file SET gac_file.* = lr_gac.*
             WHERE gac01 = lr_gac.gac01 AND gac02 = lr_gac.gac02
               AND gac03 = lr_gac.gac03 AND gac12 = lr_gac.gac12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gac_file data error:",SQLCA.sqlerrd[2]," ",lr_gac.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gac_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gac_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gav_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gav_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gav_file
      FOREACH gav_o_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file patchtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gav_file SET gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02
               AND gav08 = lr_gav.gav08 AND gav11 = lr_gav.gav11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gav_file data error:",SQLCA.sqlerrd[2]," ",lr_gav.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gav_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gav_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gat_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gat_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gat_file
      FOREACH gat_o_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file patchtemp FOREACH 資料時產生錯誤，gat資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gat_file VALUES(lr_gat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gat_file SET gat_file.* = lr_gat.*
             WHERE gat01 = lr_gat.gat01 AND gat02 = lr_gat.gat02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gat_file data error:",SQLCA.sqlerrd[2]," ",lr_gat.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gat_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsa_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsa_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsa_file
      FOREACH wsa_o_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file patchtemp FOREACH 資料時產生錯誤，wsa資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wsa_file VALUES(lr_wsa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsa_file SET wsa_file.* = lr_wsa.*
             WHERE wsa01 = lr_wsa.wsa01 
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsa_file data error:",SQLCA.sqlerrd[2]," ",lr_wsa.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsa_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsb_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsb_file
      FOREACH wsb_o_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file patchtemp FOREACH 資料時產生錯誤，wsb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wsb_file VALUES(lr_wsb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsb_file SET wsb_file.* = lr_wsb.*
             WHERE wsb01 = lr_wsb.wsb01 AND wsb02 = lr_wsb.wsb02
               AND wsb03 = lr_wsb.wsb03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsb_file data error:",SQLCA.sqlerrd[2]," ",lr_wsb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaa_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaa_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zaa_file
      FOREACH zaa_o_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file patchtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaa_file SET zaa_file.* = lr_zaa.*
             WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
               AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
               AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
               AND zaa17 = lr_zaa.zaa17
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaa_file data error:",SQLCA.sqlerrd[2]," ",lr_zaa.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaa_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zab_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zab_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zab_file
      FOREACH zab_o_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file patchtemp FOREACH 資料時產生錯誤，zab資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zab_file data error:",SQLCA.sqlerrd[2]," ",lr_zab.*
            CALL lc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zab_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gao_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gao_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gao_file
      FOREACH gao_o_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gao_file patchtemp FOREACH 資料時產生錯誤，gao資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gao_file VALUES(lr_gao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gao_file SET gao_file.* = lr_gao.*
             WHERE gao01 = lr_gao.gao01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gao_file data error:",SQLCA.sqlerrd[2]," ",lr_gao.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gao_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gax_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gax_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gax_file
      FOREACH gax_o_curs INTO lr_gax.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gax_file patchtemp FOREACH 資料時產生錯誤，gax資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gax_file VALUES(lr_gax.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gax_file SET gax_file.* = lr_gax.*
             WHERE gax01 = lr_gax.gax01 AND gax02 = lr_gax.gax02
               AND gax05 = lr_gax.gax05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gax_file data error:",SQLCA.sqlerrd[2]," ",lr_gax.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gax_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gax_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gba_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gba_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gba_file
      FOREACH gba_o_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gba_file patchtemp FOREACH 資料時產生錯誤，gba資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gba_file VALUES(lr_gba.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gba_file SET gba_file.* = lr_gba.*
             WHERE gba01 = lr_gba.gba01 AND gba02 = lr_gba.gba02
               AND gba03 = lr_gba.gba03 AND gba04 = lr_gba.gba04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gba_file data error:",SQLCA.sqlerrd[2]," ",lr_gba.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gba_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gba_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbb_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gbb_file
      FOREACH gbb_o_curs INTO lr_gbb.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbb_file patchtemp FOREACH 資料時產生錯誤，gbb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gbb_file VALUES(lr_gbb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbb_file SET gbb_file.* = lr_gbb.*
             WHERE gbb01 = lr_gbb.gbb01 AND gbb02 = lr_gbb.gbb02
               AND gbb03 = lr_gbb.gbb03 AND gbb04 = lr_gbb.gbb04
               AND gbb05 = lr_gbb.gbb05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbb_file data error:",SQLCA.sqlerrd[2]," ",lr_gbb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbf_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbf_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gbf_file
      FOREACH gbf_o_curs INTO lr_gbf.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbf_file patchtemp FOREACH 資料時產生錯誤，gbf資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.gbf_file VALUES(lr_gbf.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbf_file SET gbf_file.* = lr_gbf.*
             WHERE gbf01 = lr_gbf.gbf01 AND gbf02 = lr_gbf.gbf02
               AND gbf03 = lr_gbf.gbf03 AND gbf04 = lr_gbf.gbf04
               AND gbf06 = lr_gbf.gbf06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbf_file data error:",SQLCA.sqlerrd[2]," ",lr_gbf.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbf_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbf_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zad_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zad_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zad_file
      FOREACH zad_o_curs INTO lr_zad.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zad_file patchtemp FOREACH 資料時產生錯誤，zad資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zad_file VALUES(lr_zad.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zad_file SET zad01 = lr_zad.zad01,zad02 = lr_zad.zad02,
                                   zad03 = lr_zad.zad03,zad04 = lr_zad.zad04,
                                   zad05 = lr_zad.zad05,zad06 = lr_zad.zad06,
                                   zad07 = lr_zad.zad07,zad08 = lr_zad.zad08,
                                   zad09 = lr_zad.zad09,zad10 = lr_zad.zad10,
                                   zad11 = lr_zad.zad11
             WHERE zad01 = lr_zad.zad01 AND zad02 = lr_zad.zad02
               AND zad03 = lr_zad.zad03 AND zad04 = lr_zad.zad04
               AND zad05 = lr_zad.zad05 AND zad06 = lr_zad.zad06
               AND zad07 = lr_zad.zad07 AND zad08 = lr_zad.zad08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zad_file data error:",SQLCA.sqlerrd[2]," ",lr_zad.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zad_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zad_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zae_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zae_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zae_file
      FOREACH zae_o_curs INTO lr_zae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zae_file patchtemp FOREACH 資料時產生錯誤，zae資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zae_file VALUES(lr_zae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zae_file SET zae01 = lr_zae.zae01,zae02 = lr_zae.zae02,
                                   zae03 = lr_zae.zae03,zae04 = lr_zae.zae04,
                                   zae05 = lr_zae.zae05,zae06 = lr_zae.zae06,
                                   zae07 = lr_zae.zae07,zae08 = lr_zae.zae08,
                                   zae09 = lr_zae.zae09,zae10 = lr_zae.zae10
             WHERE zae01 = lr_zae.zae01 AND zae04 = lr_zae.zae04
               AND zae05 = lr_zae.zae05 AND zae08 = lr_zae.zae08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zae_file data error:",SQLCA.sqlerrd[2]," ",lr_zae.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zae_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zae_file 更新完畢，共更新 ",li_count,"筆資料"

     
      DISPLAY "開始更新wca_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wca_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wca_file
      FOREACH wca_o_curs INTO lr_wca.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wca_file patchtemp FOREACH 資料時產生錯誤，wca資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wca_file VALUES(lr_wca.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wca_file SET wca01 = lr_wca.wca01,wca02 = lr_wca.wca02,
                                   wca03 = lr_wca.wca03,wca04 = lr_wca.wca04,
                                   wca05 = lr_wca.wca05,wcaacti = lr_wca.wcaacti,
                                   wcauser = lr_wca.wcauser,wcagrup = lr_wca.wcagrup,
                                   wcamodu = lr_wca.wcamodu,wcadate = lr_wca.wcadate
             WHERE wca01 = lr_wca.wca01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wca_file data error:",SQLCA.sqlerrd[2]," ",lr_wca.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wca_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wca_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcb_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wcb_file
      FOREACH wcb_o_curs INTO lr_wcb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcb_file patchtemp FOREACH 資料時產生錯誤，wcb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wcb_file VALUES(lr_wcb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wcb_file SET wcb01 = lr_wcb.wcb01,wcb02 = lr_wcb.wcb02,
                                   wcb03 = lr_wcb.wcb03,wcb04 = lr_wcb.wcb04,
                                   wcb05 = lr_wcb.wcb05,wcb06 = lr_wcb.wcb06,
                                   wcb07 = lr_wcb.wcb07,wcb08 = lr_wcb.wcb08,
                                   wcb09 = lr_wcb.wcb09,wcb10 = lr_wcb.wcb10,
                                   wcb11 = lr_wcb.wcb11,wcb12 = lr_wcb.wcb12,
                                   wcb13 = lr_wcb.wcb13,wcb14 = lr_wcb.wcb14
             WHERE wcb01 = lr_wcb.wcb01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcb_file data error:",SQLCA.sqlerrd[2]," ",lr_wcb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcc_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcc_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wcc_file
      FOREACH wcc_o_curs INTO lr_wcc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcc_file patchtemp FOREACH 資料時產生錯誤，wcc資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wcc_file VALUES(lr_wcc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wcc_file SET wcc01 = lr_wcc.wcc01,wcc02 = lr_wcc.wcc02,
                                   wcc03 = lr_wcc.wcc03,wcc04 = lr_wcc.wcc04,
                                   wcc05 = lr_wcc.wcc05,wcc06 = lr_wcc.wcc06,
                                   wcc07 = lr_wcc.wcc07
             WHERE wcc01 = lr_wcc.wcc01 AND wcc02 = lr_wcc.wcc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcc_file data error:",SQLCA.sqlerrd[2]," ",lr_wcc.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcc_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcc_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcd_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcd_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wcd_file
      FOREACH wcd_o_curs INTO lr_wcd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcd_file patchtemp FOREACH 資料時產生錯誤，wcd資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wcd_file VALUES(lr_wcd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wcd_file SET wcd01 = lr_wcd.wcd01,wcd02 = lr_wcd.wcd02,
                                   wcd03 = lr_wcd.wcd03,wcd04 = lr_wcd.wcd04,
                                   wcd05 = lr_wcd.wcd05,wcd06 = lr_wcd.wcd06,
                                   wcd07 = lr_wcd.wcd07
             WHERE wcd01 = lr_wcd.wcd01 AND wcd02 = lr_wcd.wcd02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcd_file data error:",SQLCA.sqlerrd[2]," ",lr_wcd.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcd_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaw_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaw_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zaw_file
      FOREACH zaw_o_curs INTO lr_zaw.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaw_file patchtemp FOREACH 資料時產生錯誤，zaw資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1
      
         INSERT INTO ds.zaw_file VALUES(lr_zaw.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaw_file SET zaw01 = lr_zaw.zaw01,zaw02 = lr_zaw.zaw02,
                                   zaw03 = lr_zaw.zaw03,zaw04 = lr_zaw.zaw04,
                                   zaw05 = lr_zaw.zaw05,zaw06 = lr_zaw.zaw06,
                                   zaw07 = lr_zaw.zaw07,zaw08 = lr_zaw.zaw08,
                                   zaw09 = lr_zaw.zaw09,zaw10 = lr_zaw.zaw10,
                                   zaw11 = lr_zaw.zaw11,zaw12 = lr_zaw.zaw12,
                                   zawdate = lr_zaw.zawdate,
                                   zawgrup = lr_zaw.zawgrup,
                                   zawmodu = lr_zaw.zawmodu,
                                   zawuser = lr_zaw.zawuser
             WHERE zaw01 = lr_zaw.zaw01 AND zaw02 = lr_zaw.zaw02
               AND zaw03 = lr_zaw.zaw03 AND zaw04 = lr_zaw.zaw04
               AND zaw05 = lr_zaw.zaw05 AND zaw06 = lr_zaw.zaw06
               AND zaw07 = lr_zaw.zaw07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaw_file data error:",SQLCA.sqlerrd[2]," ",lr_zaw.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaw_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaw_file 更新完畢，共更新 ",li_count,"筆資料"

      
      DISPLAY "開始更新zav_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zav_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zav_file
      FOREACH zav_o_curs INTO lr_zav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zav_file patchtemp FOREACH 資料時產生錯誤，zav資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zav_file VALUES(lr_zav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zav_file SET zav01 = lr_zav.zav01,zav02 = lr_zav.zav02,
                                   zav03 = lr_zav.zav03,zav04 = lr_zav.zav04,
                                   zav05 = lr_zav.zav05,zav06 = lr_zav.zav06,
                                   zav07 = lr_zav.zav07,zav08 = lr_zav.zav08,
                                   zav09 = lr_zav.zav09,zav10 = lr_zav.zav10,
                                   zav11 = lr_zav.zav11,zav12 = lr_zav.zav12,
                                   zav13 = lr_zav.zav13,zav14 = lr_zav.zav14,
                                   zav15 = lr_zav.zav15,zav16 = lr_zav.zav16,
                                   zav17 = lr_zav.zav17,zav18 = lr_zav.zav18,
                                   zav19 = lr_zav.zav19,zav20 = lr_zav.zav20,
                                   zav21 = lr_zav.zav21,zav22 = lr_zav.zav22,
                                   zav23 = lr_zav.zav23,zav24 = lr_zav.zav24
             WHERE zav01 = lr_zav.zav01 AND zav02 = lr_zav.zav02
               AND zav03 = lr_zav.zav03 AND zav04 = lr_zav.zav04
               AND zav05 = lr_zav.zav05 AND zav24 = lr_zav.zav24
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zav_file data error:",SQLCA.sqlerrd[2]," ",lr_zav.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zav_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zav_file 更新完畢，共更新 ",li_count,"筆資料"

      
      DISPLAY "開始更新zai_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zai_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zai_file
      FOREACH zai_o_curs INTO lr_zai.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zai_file patchtemp FOREACH 資料時產生錯誤，zai資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zai_file VALUES(lr_zai.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zai_file SET zai01 = lr_zai.zai01,zai02 = lr_zai.zai02,
                                   zai03 = lr_zai.zai03,zai04 = lr_zai.zai04,
                                   zai05 = lr_zai.zai05,zaiuser = lr_zai.zaiuser,
                                   zaigrup = lr_zai.zaigrup,zaimodu = lr_zai.zaimodu,
                                   zaidate = lr_zai.zaidate,zai06 = lr_zai.zai06
                                   
             WHERE zai01 = lr_zai.zai01 AND zai05 = lr_zai.zai05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zai_file data error:",SQLCA.sqlerrd[2]," ",lr_zai.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zai_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zai_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaj_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaj_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zaj_file
      FOREACH zaj_o_curs INTO lr_zaj.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaj_file patchtemp FOREACH 資料時產生錯誤，zaj資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zaj_file VALUES(lr_zaj.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaj_file SET zaj01 = lr_zaj.zaj01,zaj02 = lr_zaj.zaj02,
                                   zaj03 = lr_zaj.zaj03,zaj04 = lr_zaj.zaj04,
                                   zaj05 = lr_zaj.zaj05,zaj06 = lr_zaj.zaj06,
                                   zaj07 = lr_zaj.zaj07
             WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02 AND zaj07 = lr_zaj.zaj07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaj_file data error:",SQLCA.sqlerrd[2]," ",lr_zaj.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaj_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaj_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zak_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zak_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zak_file
      FOREACH zak_o_curs INTO lr_zak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zak_file patchtemp FOREACH 資料時產生錯誤，zak資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zak_file VALUES(lr_zak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zak_file SET zak01 = lr_zak.zak01,zak02 = lr_zak.zak02,
                                   zak03 = lr_zak.zak03,zak04 = lr_zak.zak04,
                                   zak05 = lr_zak.zak05,zak06 = lr_zak.zak06,
                                   zak07 = lr_zak.zak07,zak08 = lr_zak.zak08
             WHERE zak01 = lr_zak.zak01 AND zak07 = lr_zak.zak07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zak_file data error:",SQLCA.sqlerrd[2]," ",lr_zak.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zak_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zal_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zal_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zal_file
      FOREACH zal_o_curs INTO lr_zal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zal_file patchtemp FOREACH 資料時產生錯誤，zal資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zal_file VALUES(lr_zal.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zal_file SET zal01 = lr_zal.zal01,zal02 = lr_zal.zal02,
                                   zal03 = lr_zal.zal03,zal04 = lr_zal.zal04,
                                   zal05 = lr_zal.zal05,zal06 = lr_zal.zal06,
                                   zal07 = lr_zal.zal07,zal08 = lr_zal.zal08
             WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
               AND zal03 = lr_zal.zal03 AND zal07 = lr_zal.zal07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zal_file data error:",SQLCA.sqlerrd[2]," ",lr_zal.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zal_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zam_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zam_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zam_file
      FOREACH zam_o_curs INTO lr_zam.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zam_file patchtemp FOREACH 資料時產生錯誤，zam資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zam_file VALUES(lr_zam.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zam_file SET zam01 = lr_zam.zam01,zam02 = lr_zam.zam02,
                                   zam03 = lr_zam.zam03,zam04 = lr_zam.zam04,
                                   zam05 = lr_zam.zam05,zam06 = lr_zam.zam06,
                                   zam07 = lr_zam.zam07,zam08 = lr_zam.zam08,
                                   zam09 = lr_zam.zam09
             WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02 AND zam09=lr_zam.zam09
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zam_file data error:",SQLCA.sqlerrd[2]," ",lr_zam.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zam_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zam_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zan_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zan_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zan_file
      FOREACH zan_o_curs INTO lr_zan.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zan_file patchtemp FOREACH 資料時產生錯誤，zan資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zan_file VALUES(lr_zan.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zan_file SET zan01 = lr_zan.zan01,zan02 = lr_zan.zan02,
                                   zan03 = lr_zan.zan03,zan04 = lr_zan.zan04,
                                   zan05 = lr_zan.zan05,zan06 = lr_zan.zan06,
                                   zan07 = lr_zan.zan07,zan08 = lr_zan.zan08
             WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02 AND zan08 = lr_zan.zan08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zan_file data error:",SQLCA.sqlerrd[2]," ",lr_zan.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zan_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zan_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zao_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zao_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zao_file
      FOREACH zao_o_curs INTO lr_zao.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zao_file patchtemp FOREACH 資料時產生錯誤，zao資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zao_file VALUES(lr_zao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zao_file SET zao01 = lr_zao.zao01,zao02 = lr_zao.zao02,
                                   zao03 = lr_zao.zao03,zao04 = lr_zao.zao04,
                                   zao05 = lr_zao.zao05
             WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
               AND zao03 = lr_zao.zao03 AND zao05 = lr_zao.zao05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zao_file data error:",SQLCA.sqlerrd[2]," ",lr_zao.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zao_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zap_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zap_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zap_file
      FOREACH zap_o_curs INTO lr_zap.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zap_file patchtemp FOREACH 資料時產生錯誤，zap資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zap_file VALUES(lr_zap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zap_file SET zap01 = lr_zap.zap01,zap02 = lr_zap.zap02,
                                   zap03 = lr_zap.zap03,zap04 = lr_zap.zap04,
                                   zap05 = lr_zap.zap05,zap06 = lr_zap.zap06,
                                   zap07 = lr_zap.zap07
             WHERE zap01 = lr_zap.zap01 AND zap07 = lr_zap.zap07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zap_file data error:",SQLCA.sqlerrd[2]," ",lr_zap.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zap_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaq_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaq_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zaq_file
      FOREACH zaq_o_curs INTO lr_zaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaq_file patchtemp FOREACH 資料時產生錯誤，zaq資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zaq_file VALUES(lr_zaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaq_file SET zaq01 = lr_zaq.zaq01,zaq02 = lr_zaq.zaq02,
                                   zaq03 = lr_zaq.zaq03,zaq04 = lr_zaq.zaq04,
                                   zaq05 = lr_zaq.zaq05
             WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02 AND zaq05 = lr_zaq.zaq05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaq_file data error:",SQLCA.sqlerrd[2]," ",lr_zaq.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaq_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zar_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zar_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zar_file
      FOREACH zar_o_curs INTO lr_zar.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zar_file patchtemp FOREACH 資料時產生錯誤，zar資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zar_file VALUES(lr_zar.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zar_file SET zar01 = lr_zar.zar01,zar02 = lr_zar.zar02,
                                   zar03 = lr_zar.zar03,zar04 = lr_zar.zar04,
                                   zar05 = lr_zar.zar05
             WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
               AND zar03 = lr_zar.zar03 AND zar05 = lr_zar.zar05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zar_file data error:",SQLCA.sqlerrd[2]," ",lr_zar.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zar_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zar_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zas_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zas_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zas_file
      FOREACH zas_o_curs INTO lr_zas.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zas_file patchtemp FOREACH 資料時產生錯誤，zas資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zas_file VALUES(lr_zas.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zas_file SET zas01 = lr_zas.zas01,zas02 = lr_zas.zas02,
                                   zas03 = lr_zas.zas03,zas04 = lr_zas.zas04,
                                   zas05 = lr_zas.zas05,zas06 = lr_zas.zas06,
                                   zas07 = lr_zas.zas07,zas08 = lr_zas.zas08,
                                   zas09 = lr_zas.zas09,zas10 = lr_zas.zas10,
                                   zas11 = lr_zas.zas11
             WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02 AND zas11 = lr_zas.zas11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zas_file data error:",SQLCA.sqlerrd[2]," ",lr_zas.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zas_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zas_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zat_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zat_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zat_file
      FOREACH zat_o_curs INTO lr_zat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zat_file patchtemp FOREACH 資料時產生錯誤，zat資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zat_file VALUES(lr_zat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zat_file SET zat01 = lr_zat.zat01,zat02 = lr_zat.zat02,
                                   zat03 = lr_zat.zat03,zat04 = lr_zat.zat04,
                                   zat05 = lr_zat.zat05,zat06 = lr_zat.zat06,
                                   zat07 = lr_zat.zat07,zat08 = lr_zat.zat08,
                                   zat09 = lr_zat.zat09,zat10 = lr_zat.zat10,
                                   zat11 = lr_zat.zat11
             WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
               AND zat10 = lr_zat.zat10
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zat_file data error:",SQLCA.sqlerrd[2]," ",lr_zat.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zat_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zau_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zau_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zau_file
      FOREACH zau_o_curs INTO lr_zau.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zau_file patchtemp FOREACH 資料時產生錯誤，zau資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zau_file VALUES(lr_zau.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zau_file SET zau01 = lr_zau.zau01,zau02 = lr_zau.zau02,
                                   zau03 = lr_zau.zau03,zau04 = lr_zau.zau04
             WHERE zau01 = lr_zau.zau01 AND zau04 = lr_zau.zau04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zau_file data error:",SQLCA.sqlerrd[2]," ",lr_zau.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zau_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zau_file 更新完畢，共更新 ",li_count,"筆資料"                                 
      
      
      DISPLAY "開始更新zay_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zay_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zay_file
      FOREACH zay_o_curs INTO lr_zay.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zay_file patchtemp FOREACH 資料時產生錯誤，zay資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.zay_file VALUES(lr_zay.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zay_file SET zay01 = lr_zay.zay01,zay02 = lr_zay.zay02,
                                   zay03 = lr_zay.zay03,zay04 = lr_zay.zay04,
                                   zay05 = lr_zay.zay05,zay06 = lr_zay.zay06,
                                   zay07 = lr_zay.zay07
             WHERE zay01 = lr_zay.zay01 AND zay02 = lr_zay.zay02
               AND zay03 = lr_zay.zay03 AND zay05 = lr_zay.zay05                
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zay_file data error:",SQLCA.sqlerrd[2]," ",lr_zay.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zay_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zay_file 更新完畢，共更新 ",li_count,"筆資料"                                 


      DISPLAY "開始更新wsm_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsm_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsm_file
      FOREACH wsm_o_curs INTO lr_wsm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsm_file patchtemp FOREACH 資料時產生錯誤，wsm資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wsm_file VALUES(lr_wsm.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsm_file SET wsm01 = lr_wsm.wsm01,wsm02 = lr_wsm.wsm02,
                                   wsmacti = lr_wsm.wsmacti, wsmdate = lr_wsm.wsmdate,
                                   wsmgrup = lr_wsm.wsmgrup, wsmmodu = lr_wsm.wsmmodu,
                                   wsmuser = lr_wsm.wsmuser
             WHERE wsm01 = lr_wsm.wsm01 AND wsm02 = lr_wsm.wsm02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsm_file data error:",SQLCA.sqlerrd[2]," ",lr_wsm.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsm_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsn_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsn_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsn_file
      FOREACH wsn_o_curs INTO lr_wsn.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsn_file patchtemp FOREACH 資料時產生錯誤，wsn資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wsn_file VALUES(lr_wsn.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsn_file SET wsn01 = lr_wsn.wsn01,wsn02 = lr_wsn.wsn02,
                                   wsn03 = lr_wsn.wsn03,wsn04 = lr_wsn.wsn04
             WHERE wsn01 = lr_wsn.wsn01 AND wsn02 = lr_wsn.wsn02 AND wsn03 = lr_wsn.wsn03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsn_file data error:",SQLCA.sqlerrd[2]," ",lr_wsn.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsn_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsn_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wso_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wso_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wso_file
      FOREACH wso_o_curs INTO lr_wso.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wso_file patchtemp FOREACH 資料時產生錯誤，wso資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wso_file VALUES(lr_wso.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wso_file SET wso01 = lr_wso.wso01,wso02 = lr_wso.wso02,
                                   wso03 = lr_wso.wso03,wso04 = lr_wso.wso04,
                                   wso05 = lr_wso.wso05
             WHERE wso01 = lr_wso.wso01 AND wso02 = lr_wso.wso02 AND wso03 = lr_wso.wso03 AND wso04 = lr_wso.wso04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wso_file data error:",SQLCA.sqlerrd[2]," ",lr_wso.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wso_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wso_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsp_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsp_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsp_file
      FOREACH wsp_o_curs INTO lr_wsp.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsp_file patchtemp FOREACH 資料時產生錯誤，wsp資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds.wsp_file VALUES(lr_wsp.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsp_file SET wsp01 = lr_wsp.wsp01,wsp02 = lr_wsp.wsp02,
                                   wsp03 = lr_wsp.wsp03,wsp04 = lr_wsp.wsp04,
                                   wsp05 = lr_wsp.wsp05
             WHERE wsp01 = lr_wsp.wsp01 AND wsp02 = lr_wsp.wsp02 AND wsp03 = lr_wsp.wsp03 AND wsp04 = lr_wsp.wsp04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsp_file data error:",SQLCA.sqlerrd[2]," ",lr_wsp.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsp_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsp_file 更新完畢，共更新 ",li_count,"筆資料"      

   ELSE 

      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE ze_curs CURSOR FOR
              SELECT * FROM patchtemp:ze_file
      FOREACH ze_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file patchtemp FOREACH 資料時產生錯誤，ze資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:ze_file VALUES(lr_ze.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:ze_file SET ze_file.* = lr_ze.*
             WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
            IF SQLCA.sqlcode THEN    
               LET l_cmd = "upload ze_file data error:",SQLCA.sqlerrd[2]," ",lr_ze.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"ze_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "ze_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zz_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zz_curs CURSOR FOR
              SELECT * FROM patchtemp:zz_file
      FOREACH zz_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file patchtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds:zz_file WHERE zz01 = lr_zz.zz01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds:zz_file SET zz_file.* = lr_zz.*
                WHERE zz01 = lr_zz.zz01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zz_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gaz_curs CURSOR FOR
              SELECT * FROM patchtemp:gaz_file
      FOREACH gaz_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file patchtemp FOREACH 資料時產生錯誤，gaz資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gaz_file VALUES(lr_gaz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaz_file SET gaz_file.* = lr_gaz.* 
             WHERE gaz01 = lr_gaz.gaz01 AND gaz02 = lr_gaz.gaz02 AND gaz05 = lr_gaz.gaz05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaz_file data error:",SQLCA.sqlerrd[2]," ",lr_gaz.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gaz_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gaz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zm_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zm_curs CURSOR FOR
              SELECT * FROM patchtemp.zm_file
      FOREACH zm_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file patchtemp FOREACH 資料時產生錯誤，zm資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zm_file data error:",SQLCA.sqlerrd[2],"   SQL: UPDATE zm_file SET",
                     " zm01 = '",lr_zm.zm01,"', zm03 = '",lr_zm.zm03,"', zm04 = '",lr_zm.zm04,"' WHERE ",
                     " zm01 = '",lr_zm.zm01,"' AND zm03 ='",lr_zm.zm03,"';"
            CALL lc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zm_file   Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gap_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gap_curs CURSOR FOR
              SELECT * FROM patchtemp:gap_file
      FOREACH gap_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gap_file patchtemp FOREACH 資料時產生錯誤，gap資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gap_file VALUES(lr_gap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gap_file SET gap_file.* = lr_gap.*
             WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "insert gap_file data error:",SQLCA.sqlerrd[2]," ",lr_gap.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gap_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbd_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbd_curs CURSOR FOR
              SELECT * FROM patchtemp:gbd_file
      FOREACH gbd_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file patchtemp FOREACH 資料時產生錯誤，gbd資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gbd_file VALUES(lr_gbd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbd_file SET gbd_file.* = lr_gbd.*
             WHERE gbd01 = lr_gbd.gbd01 AND gbd02 = lr_gbd.gbd02
               AND gbd03 = lr_gbd.gbd03 AND gbd07 = lr_gbd.gbd07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbd_file data error:",SQLCA.sqlerrd[2]," ",lr_gbd.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbd_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gae_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gae_curs CURSOR FOR
              SELECT * FROM patchtemp:gae_file
      FOREACH gae_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file patchtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gae_file SET gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11 AND gae12=lr_gae.gae12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gae_file data error:",SQLCA.sqlerrd[2]," ",lr_gae.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gae_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gae_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gak_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gak_curs CURSOR FOR
              SELECT * FROM patchtemp:gak_file
      FOREACH gak_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file patchtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds:zz_file WHERE zz01 = lr_gak.gak01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds:gak_file SET gak_file.* = lr_gak.*
                WHERE gak01 = lr_gak.gak01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert gak_file data error:",SQLCA.sqlcode," ",lr_gak.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gak_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gal_curs CURSOR FOR
              SELECT * FROM patchtemp:gal_file
      FOREACH gal_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file patchtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM ds:gal_file
          WHERE gal01 = lr_gal.gal01 #鏈結檔案
            AND gal03 = lr_gal.gal03 #程式代碼
         IF g_cnt >=1 THEN
            #==>存在相同的程式代碼時
            SELECT gal02 INTO lc_gal02
              FROM ds:gal_file
             WHERE gal01 = lr_gal.gal01 
               AND gal03 = lr_gal.gal03
            LET ls_zz011 = lc_gal02 #系統名
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               #不為客製==>更新
               UPDATE ds:gal_file SET gal_file.* = lr_gal.*
                WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
                  CALL lc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               #為客製==>不做任何事
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
             INSERT INTO ds:gal_file VALUES(lr_gal.*)
             IF SQLCA.sqlcode THEN
                 LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                 CALL lc_channel.write(l_cmd)
                 LET l_result = FALSE
             ELSE
                 LET li_count = li_count + SQLCA.sqlerrd[3]
             END IF
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gal_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gaq_curs CURSOR FOR
              SELECT * FROM patchtemp:gaq_file
      FOREACH gaq_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file patchtemp FOREACH 資料時產生錯誤，gaq資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaq_file SET gaq_file.* = lr_gaq.*
             WHERE gaq01 = lr_gaq.gaq01 AND gaq02 = lr_gaq.gaq02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaq_file data error:",SQLCA.sqlerrd[2]," ",lr_gaq.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gaq_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gab_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gab_curs CURSOR FOR
              SELECT * FROM patchtemp:gab_file
      FOREACH gab_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file patchtemp FOREACH 資料時產生錯誤，gab資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gab_file VALUES(lr_gab.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gab_file SET gab_file.* = lr_gab.*
             WHERE gab01 = lr_gab.gab01 AND gab11 = lr_gab.gab11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gab_file data error:",SQLCA.sqlerrd[2]," ",lr_gab.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gab_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gac_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gac_curs CURSOR FOR
              SELECT * FROM patchtemp:gac_file
      FOREACH gac_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file patchtemp FOREACH 資料時產生錯誤，gac資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gac_file VALUES(lr_gac.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gac_file SET gac_file.* = lr_gac.*
             WHERE gac01 = lr_gac.gac01 AND gac02 = lr_gac.gac02
               AND gac03 = lr_gac.gac03 AND gac12 = lr_gac.gac12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gac_file data error:",SQLCA.sqlerrd[2]," ",lr_gac.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gac_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gac_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gav_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gav_curs CURSOR FOR
              SELECT * FROM patchtemp:gav_file
      FOREACH gav_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file patchtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gav_file SET gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02 
               AND gav08 = lr_gav.gav08 AND gav11 = lr_gav.gav11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gav_file data error:",SQLCA.sqlerrd[2]," ",lr_gav.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gav_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gav_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gat_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gat_curs CURSOR FOR
              SELECT * FROM patchtemp:gat_file
      FOREACH gat_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file patchtemp FOREACH 資料時產生錯誤，gat資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gat_file VALUES(lr_gat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gat_file SET gat_file.* = lr_gat.*
             WHERE gat01 = lr_gat.gat01 AND gat02 = lr_gat.gat02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gat_file data error:",SQLCA.sqlerrd[2]," ",lr_gat.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gat_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsa_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsa_curs CURSOR FOR
              SELECT * FROM patchtemp:wsa_file
      FOREACH wsa_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file patchtemp FOREACH 資料時產生錯誤，wsa資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wsa_file VALUES(lr_wsa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsa_file SET wsa_file.* = lr_wsa.*
             WHERE wsa01 = lr_wsa.wsa01 
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsa_file data error:",SQLCA.sqlerrd[2]," ",lr_wsa.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsa_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsb_curs CURSOR FOR
              SELECT * FROM patchtemp:wsb_file
      FOREACH wsb_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file patchtemp FOREACH 資料時產生錯誤，wsb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wsb_file VALUES(lr_wsb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsb_file SET wsb_file.* = lr_wsb.*
             WHERE wsb01 = lr_wsb.wsb01 AND wsb02 = lr_wsb.wsb02
               AND wsb03 = lr_wsb.wsb03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsb_file data error:",SQLCA.sqlerrd[2]," ",lr_wsb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaa_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaa_curs CURSOR FOR
              SELECT * FROM patchtemp:zaa_file
      FOREACH zaa_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file patchtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaa_file SET zaa_file.* = lr_zaa.*
             WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
               AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
               AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
               AND zaa17 = lr_zaa.zaa17
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaa_file data error:",SQLCA.sqlerrd[2]," ",lr_zaa.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaa_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zab_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zab_curs CURSOR FOR
              SELECT * FROM patchtemp:zab_file
      FOREACH zab_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file patchtemp FOREACH 資料時產生錯誤，zab資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zab_file data error:",SQLCA.sqlerrd[2]," ",lr_zab.*
            CALL lc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zab_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gao_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gao_curs CURSOR FOR
              SELECT * FROM patchtemp:gao_file
      FOREACH gao_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gao_file patchtemp FOREACH 資料時產生錯誤，gao資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gao_file VALUES(lr_gao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gao_file SET gao_file.* = lr_gao.*
             WHERE gao01 = lr_gao.gao01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gao_file data error:",SQLCA.sqlerrd[2]," ",lr_gao.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gao_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gax_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gax_curs CURSOR FOR
              SELECT * FROM patchtemp:gax_file
      FOREACH gax_curs INTO lr_gax.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gax_file patchtemp FOREACH 資料時產生錯誤，gax資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gax_file VALUES(lr_gax.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gax_file SET gax_file.* = lr_gax.*
             WHERE gax01 = lr_gax.gax01 AND gax02 = lr_gax.gax02
               AND gax05 = lr_gax.gax05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gax_file data error:",SQLCA.sqlerrd[2]," ",lr_gax.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gax_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gax_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gba_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gba_curs CURSOR FOR
              SELECT * FROM patchtemp:gba_file
      FOREACH gba_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gba_file patchtemp FOREACH 資料時產生錯誤，gba資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gba_file VALUES(lr_gba.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gba_file SET gba_file.* = lr_gba.*
             WHERE gba01 = lr_gba.gba01 AND gba02 = lr_gba.gba02
               AND gba03 = lr_gba.gba03 AND gba04 = lr_gba.gba04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gba_file data error:",SQLCA.sqlerrd[2]," ",lr_gba.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gba_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gba_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbb_curs CURSOR FOR
              SELECT * FROM patchtemp:gbb_file
      FOREACH gbb_curs INTO lr_gbb.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbb_file patchtemp FOREACH 資料時產生錯誤，gbb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gbb_file VALUES(lr_gbb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbb_file SET gbb_file.* = lr_gbb.*
             WHERE gbb01 = lr_gbb.gbb01 AND gbb02 = lr_gbb.gbb02
               AND gbb03 = lr_gbb.gbb03 AND gbb04 = lr_gbb.gbb04
               AND gbb05 = lr_gbb.gbb05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbb_file data error:",SQLCA.sqlerrd[2]," ",lr_gbb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbf_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE gbf_curs CURSOR FOR
              SELECT * FROM patchtemp:gbf_file
      FOREACH gbf_curs INTO lr_gbf.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbf_file patchtemp FOREACH 資料時產生錯誤，gbf資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:gbf_file VALUES(lr_gbf.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbf_file SET gbf_file.* = lr_gbf.*
             WHERE gbf01 = lr_gbf.gbf01 AND gbf02 = lr_gbf.gbf02
               AND gbf03 = lr_gbf.gbf03 AND gbf04 = lr_gbf.gbf04
               AND gbf06 = lr_gbf.gbf06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbf_file data error:",SQLCA.sqlerrd[2]," ",lr_gbf.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"gbf_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "gbf_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zad_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zad_curs CURSOR FOR
              SELECT * FROM patchtemp:zad_file
      FOREACH zad_curs INTO lr_zad.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zad_file patchtemp FOREACH 資料時產生錯誤，zad資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zad_file VALUES(lr_zad.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zad_file SET zad01 = lr_zad.zad01,zad02 = lr_zad.zad02,
                                   zad03 = lr_zad.zad03,zad04 = lr_zad.zad04,
                                   zad05 = lr_zad.zad05,zad06 = lr_zad.zad06,
                                   zad07 = lr_zad.zad07,zad08 = lr_zad.zad08,
                                   zad09 = lr_zad.zad09,zad10 = lr_zad.zad10,
                                   zad11 = lr_zad.zad11
             WHERE zad01 = lr_zad.zad01 AND zad02 = lr_zad.zad02
               AND zad03 = lr_zad.zad03 AND zad04 = lr_zad.zad04
               AND zad05 = lr_zad.zad05 AND zad06 = lr_zad.zad06
               AND zad07 = lr_zad.zad07 AND zad08 = lr_zad.zad08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zad_file data error:",SQLCA.sqlerrd[2]," ",lr_zad.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zad_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zad_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zae_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zae_curs CURSOR FOR
              SELECT * FROM patchtemp:zae_file
      FOREACH zae_curs INTO lr_zae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zae_file patchtemp FOREACH 資料時產生錯誤，zae資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zae_file VALUES(lr_zae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zae_file SET zae01 = lr_zae.zae01,zae02 = lr_zae.zae02,
                                   zae03 = lr_zae.zae03,zae04 = lr_zae.zae04,
                                   zae05 = lr_zae.zae05,zae06 = lr_zae.zae06,
                                   zae07 = lr_zae.zae07,zae08 = lr_zae.zae08,
                                   zae09 = lr_zae.zae09,zae10 = lr_zae.zae10
             WHERE zae01 = lr_zae.zae01 AND zae04 = lr_zae.zae04
               AND zae05 = lr_zae.zae05 AND zae08 = lr_zae.zae08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zae_file data error:",SQLCA.sqlerrd[2]," ",lr_zae.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zae_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zae_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wca_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wca_curs CURSOR FOR
              SELECT * FROM patchtemp:wca_file
      FOREACH wca_curs INTO lr_wca.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wca_file patchtemp FOREACH 資料時產生錯誤，wca資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wca_file VALUES(lr_wca.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wca_file SET wca01 = lr_wca.wca01,wca02 = lr_wca.wca02,
                                   wca03 = lr_wca.wca03,wca04 = lr_wca.wca04,
                                   wca05 = lr_wca.wca05,wcaacti = lr_wca.wcaacti,
                                   wcauser = lr_wca.wcauser,wcagrup = lr_wca.wcagrup,
                                   wcamodu = lr_wca.wcamodu,wcadate = lr_wca.wcadate
             WHERE wca01 = lr_wca.wca01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wca_file data error:",SQLCA.sqlerrd[2]," ",lr_wca.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wca_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wca_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcb_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcb_curs CURSOR FOR
              SELECT * FROM patchtemp:wcb_file
      FOREACH wcb_curs INTO lr_wcb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcb_file patchtemp FOREACH 資料時產生錯誤，wcb資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wcb_file VALUES(lr_wcb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wcb_file SET wcb01 = lr_wcb.wcb01,wcb02 = lr_wcb.wcb02,
                                   wcb03 = lr_wcb.wcb03,wcb04 = lr_wcb.wcb04,
                                   wcb05 = lr_wcb.wcb05,wcb06 = lr_wcb.wcb06,
                                   wcb07 = lr_wcb.wcb07,wcb08 = lr_wcb.wcb08,
                                   wcb09 = lr_wcb.wcb09,wcb10 = lr_wcb.wcb10,
                                   wcb11 = lr_wcb.wcb11,wcb12 = lr_wcb.wcb12,
                                   wcb13 = lr_wcb.wcb13,wcb14 = lr_wcb.wcb14
             WHERE wcb01 = lr_wcb.wcb01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcb_file data error:",SQLCA.sqlerrd[2]," ",lr_wcb.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcb_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcc_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcc_curs CURSOR FOR
              SELECT * FROM patchtemp:wcc_file
      FOREACH wcc_curs INTO lr_wcc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcc_file patchtemp FOREACH 資料時產生錯誤，wcc資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wcc_file VALUES(lr_wcc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wcc_file SET wcc01 = lr_wcc.wcc01,wcc02 = lr_wcc.wcc02,
                                   wcc03 = lr_wcc.wcc03,wcc04 = lr_wcc.wcc04,
                                   wcc05 = lr_wcc.wcc05,wcc06 = lr_wcc.wcc06,
                                   wcc07 = lr_wcc.wcc07
             WHERE wcc01 = lr_wcc.wcc01 AND wcc02 = lr_wcc.wcc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcc_file data error:",SQLCA.sqlerrd[2]," ",lr_wcc.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcc_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcc_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wcd_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wcd_curs CURSOR FOR
              SELECT * FROM patchtemp:wcd_file
      FOREACH wcd_curs INTO lr_wcd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wcd_file patchtemp FOREACH 資料時產生錯誤，wcd資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wcd_file VALUES(lr_wcd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wcd_file SET wcd01 = lr_wcd.wcd01,wcd02 = lr_wcd.wcd02,
                                   wcd03 = lr_wcd.wcd03,wcd04 = lr_wcd.wcd04,
                                   wcd05 = lr_wcd.wcd05,wcd06 = lr_wcd.wcd06,
                                   wcd07 = lr_wcd.wcd07
             WHERE wcd01 = lr_wcd.wcd01 AND wcd02 = lr_wcd.wcd02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wcd_file data error:",SQLCA.sqlerrd[2]," ",lr_wcd.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wcd_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wcd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaw_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaw_curs CURSOR FOR
              SELECT * FROM patchtemp:zaw_file
      FOREACH zaw_curs INTO lr_zaw.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaw_file patchtemp FOREACH 資料時產生錯誤，zaw資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1
      
         INSERT INTO ds:zaw_file VALUES(lr_zaw.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaw_file SET zaw01 = lr_zaw.zaw01,zaw02 = lr_zaw.zaw02,
                                   zaw03 = lr_zaw.zaw03,zaw04 = lr_zaw.zaw04,
                                   zaw05 = lr_zaw.zaw05,zaw06 = lr_zaw.zaw06,
                                   zaw07 = lr_zaw.zaw07,zaw08 = lr_zaw.zaw08,
                                   zaw09 = lr_zaw.zaw09,zaw10 = lr_zaw.zaw10,
                                   zaw11 = lr_zaw.zaw11,zaw12 = lr_zaw.zaw12,
                                   zawdate = lr_zaw.zawdate,
                                   zawgrup = lr_zaw.zawgrup,
                                   zawmodu = lr_zaw.zawmodu,
                                   zawuser = lr_zaw.zawuser
             WHERE zaw01 = lr_zaw.zaw01 AND zaw02 = lr_zaw.zaw02
               AND zaw03 = lr_zaw.zaw03 AND zaw04 = lr_zaw.zaw04
               AND zaw05 = lr_zaw.zaw05 AND zaw06 = lr_zaw.zaw06
               AND zaw07 = lr_zaw.zaw07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaw_file data error:",SQLCA.sqlerrd[2]," ",lr_zaw.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaw_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaw_file 更新完畢，共更新 ",li_count,"筆資料"

      
      DISPLAY "開始更新zav_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zav_curs CURSOR FOR
              SELECT * FROM patchtemp:zav_file
      FOREACH zav_curs INTO lr_zav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zav_file patchtemp FOREACH 資料時產生錯誤，zav資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zav_file VALUES(lr_zav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zav_file SET zav01 = lr_zav.zav01,zav02 = lr_zav.zav02,
                                   zav03 = lr_zav.zav03,zav04 = lr_zav.zav04,
                                   zav05 = lr_zav.zav05,zav06 = lr_zav.zav06,
                                   zav07 = lr_zav.zav07,zav08 = lr_zav.zav08,
                                   zav09 = lr_zav.zav09,zav10 = lr_zav.zav10,
                                   zav11 = lr_zav.zav11,zav12 = lr_zav.zav12,
                                   zav13 = lr_zav.zav13,zav14 = lr_zav.zav14,
                                   zav15 = lr_zav.zav15,zav16 = lr_zav.zav16,
                                   zav17 = lr_zav.zav17,zav18 = lr_zav.zav18,
                                   zav19 = lr_zav.zav19,zav20 = lr_zav.zav20,
                                   zav21 = lr_zav.zav21,zav22 = lr_zav.zav22,
                                   zav23 = lr_zav.zav23,zav24 = lr_zav.zav24
             WHERE zav01 = lr_zav.zav01 AND zav02 = lr_zav.zav02
               AND zav03 = lr_zav.zav03 AND zav04 = lr_zav.zav04
               AND zav05 = lr_zav.zav05 AND zav24 = lr_zav.zav24
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zav_file data error:",SQLCA.sqlerrd[2]," ",lr_zav.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zav_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zav_file 更新完畢，共更新 ",li_count,"筆資料"

      
      DISPLAY "開始更新zai_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zai_curs CURSOR FOR
              SELECT * FROM patchtemp:zai_file
      FOREACH zai_curs INTO lr_zai.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zai_file patchtemp FOREACH 資料時產生錯誤，zai資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zai_file VALUES(lr_zai.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zai_file SET zai01 = lr_zai.zai01,zai02 = lr_zai.zai02,
                                   zai03 = lr_zai.zai03,zai04 = lr_zai.zai04,
                                   zai05 = lr_zai.zai05,zaiuser = lr_zai.zaiuser,
                                   zaigrup = lr_zai.zaigrup,zaimodu = lr_zai.zaimodu,
                                   zaidate = lr_zai.zaidate
             WHERE zai01 = lr_zai.zai01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zai_file data error:",SQLCA.sqlerrd[2]," ",lr_zai.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zai_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zai_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaj_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaj_curs CURSOR FOR
              SELECT * FROM patchtemp:zaj_file
      FOREACH zaj_curs INTO lr_zaj.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaj_file patchtemp FOREACH 資料時產生錯誤，zaj資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zaj_file VALUES(lr_zaj.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaj_file SET zaj01 = lr_zaj.zaj01,zaj02 = lr_zaj.zaj02,
                                   zaj03 = lr_zaj.zaj03,zaj04 = lr_zaj.zaj04,
                                   zaj05 = lr_zaj.zaj05,zaj06 = lr_zaj.zaj06
             WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaj_file data error:",SQLCA.sqlerrd[2]," ",lr_zaj.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaj_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaj_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zak_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zak_curs CURSOR FOR
              SELECT * FROM patchtemp:zak_file
      FOREACH zak_curs INTO lr_zak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zak_file patchtemp FOREACH 資料時產生錯誤，zak資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zak_file VALUES(lr_zak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zak_file SET zak01 = lr_zak.zak01,zak02 = lr_zak.zak02,
                                   zak03 = lr_zak.zak03,zak04 = lr_zak.zak04,
                                   zak05 = lr_zak.zak05,zak06 = lr_zak.zak06
             WHERE zak01 = lr_zak.zak01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zak_file data error:",SQLCA.sqlerrd[2]," ",lr_zak.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zak_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zal_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zal_curs CURSOR FOR
              SELECT * FROM patchtemp:zal_file
      FOREACH zal_curs INTO lr_zal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zal_file patchtemp FOREACH 資料時產生錯誤，zal資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zal_file VALUES(lr_zal.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zal_file SET zal01 = lr_zal.zal01,zal02 = lr_zal.zal02,
                                   zal03 = lr_zal.zal03,zal04 = lr_zal.zal04,
                                   zal05 = lr_zal.zal05,zal06 = lr_zal.zal06
             WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
               AND zal03 = lr_zal.zal03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zal_file data error:",SQLCA.sqlerrd[2]," ",lr_zal.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zal_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zam_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zam_curs CURSOR FOR
              SELECT * FROM patchtemp:zam_file
      FOREACH zam_curs INTO lr_zam.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zam_file patchtemp FOREACH 資料時產生錯誤，zam資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zam_file VALUES(lr_zam.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zam_file SET zam01 = lr_zam.zam01,zam02 = lr_zam.zam02,
                                   zam03 = lr_zam.zam03,zam04 = lr_zam.zam04,
                                   zam05 = lr_zam.zam05,zam06 = lr_zam.zam06,
                                   zam07 = lr_zam.zam07,zam08 = lr_zam.zam08
             WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zam_file data error:",SQLCA.sqlerrd[2]," ",lr_zam.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zam_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zam_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zan_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zan_curs CURSOR FOR
              SELECT * FROM patchtemp:zan_file
      FOREACH zan_curs INTO lr_zan.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zan_file patchtemp FOREACH 資料時產生錯誤，zan資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zan_file VALUES(lr_zan.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zan_file SET zan01 = lr_zan.zan01,zan02 = lr_zan.zan02,
                                   zan03 = lr_zan.zan03,zan04 = lr_zan.zan04,
                                   zan05 = lr_zan.zan05,zan06 = lr_zan.zan06,
                                   zan07 = lr_zan.zan07
             WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zan_file data error:",SQLCA.sqlerrd[2]," ",lr_zan.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zan_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zan_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zao_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zao_curs CURSOR FOR
              SELECT * FROM patchtemp:zao_file
      FOREACH zao_curs INTO lr_zao.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zao_file patchtemp FOREACH 資料時產生錯誤，zao資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zao_file VALUES(lr_zao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zao_file SET zao01 = lr_zao.zao01,zao02 = lr_zao.zao02,
                                   zao03 = lr_zao.zao03,zao04 = lr_zao.zao04
             WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
               AND zao03 = lr_zao.zao03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zao_file data error:",SQLCA.sqlerrd[2]," ",lr_zao.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zao_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zap_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zap_curs CURSOR FOR
              SELECT * FROM patchtemp:zap_file
      FOREACH zap_curs INTO lr_zap.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zap_file patchtemp FOREACH 資料時產生錯誤，zap資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zap_file VALUES(lr_zap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zap_file SET zap01 = lr_zap.zap01,zap02 = lr_zap.zap02,
                                   zap03 = lr_zap.zap03,zap04 = lr_zap.zap04,
                                   zap05 = lr_zap.zap05,zap06 = lr_zap.zap06
             WHERE zap01 = lr_zap.zap01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zap_file data error:",SQLCA.sqlerrd[2]," ",lr_zap.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zap_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaq_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zaq_curs CURSOR FOR
              SELECT * FROM patchtemp:zaq_file
      FOREACH zaq_curs INTO lr_zaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaq_file patchtemp FOREACH 資料時產生錯誤，zaq資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zaq_file VALUES(lr_zaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaq_file SET zaq01 = lr_zaq.zaq01,zaq02 = lr_zaq.zaq02,
                                   zaq03 = lr_zaq.zaq03,zaq04 = lr_zaq.zaq04
             WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaq_file data error:",SQLCA.sqlerrd[2]," ",lr_zaq.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zaq_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zar_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zar_curs CURSOR FOR
              SELECT * FROM patchtemp:zar_file
      FOREACH zar_curs INTO lr_zar.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zar_file patchtemp FOREACH 資料時產生錯誤，zar資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zar_file VALUES(lr_zar.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zar_file SET zar01 = lr_zar.zar01,zar02 = lr_zar.zar02,
                                   zar03 = lr_zar.zar03,zar04 = lr_zar.zar04
             WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
               AND zar03 = lr_zar.zar03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zar_file data error:",SQLCA.sqlerrd[2]," ",lr_zar.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zar_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zar_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zas_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zas_curs CURSOR FOR
              SELECT * FROM patchtemp:zas_file
      FOREACH zas_curs INTO lr_zas.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zas_file patchtemp FOREACH 資料時產生錯誤，zas資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zas_file VALUES(lr_zas.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zas_file SET zas01 = lr_zas.zas01,zas02 = lr_zas.zas02,
                                   zas03 = lr_zas.zas03,zas04 = lr_zas.zas04,
                                   zas05 = lr_zas.zas05,zas06 = lr_zas.zas06,
                                   zas07 = lr_zas.zas07,zas08 = lr_zas.zas08,
                                   zas09 = lr_zas.zas09,zas10 = lr_zas.zas10
             WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zas_file data error:",SQLCA.sqlerrd[2]," ",lr_zas.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zas_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zas_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zat_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zat_curs CURSOR FOR
              SELECT * FROM patchtemp:zat_file
      FOREACH zat_curs INTO lr_zat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zat_file patchtemp FOREACH 資料時產生錯誤，zat資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zat_file VALUES(lr_zat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zat_file SET zat01 = lr_zat.zat01,zat02 = lr_zat.zat02,
                                   zat03 = lr_zat.zat03,zat04 = lr_zat.zat04,
                                   zat05 = lr_zat.zat05,zat06 = lr_zat.zat06,
                                   zat07 = lr_zat.zat07,zat08 = lr_zat.zat08,
                                   zat09 = lr_zat.zat09
             WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zat_file data error:",SQLCA.sqlerrd[2]," ",lr_zat.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zat_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zau_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE zau_curs CURSOR FOR
              SELECT * FROM patchtemp:zau_file
      FOREACH zau_curs INTO lr_zau.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zau_file patchtemp FOREACH 資料時產生錯誤，zau資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:zau_file VALUES(lr_zau.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zau_file SET zau01 = lr_zau.zau01,zau02 = lr_zau.zau02,
                                   zau03 = lr_zau.zau03
             WHERE zau01 = lr_zau.zau01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zau_file data error:",SQLCA.sqlerrd[2]," ",lr_zau.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"zau_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "zau_file 更新完畢，共更新 ",li_count,"筆資料"                                          


      DISPLAY "開始更新wsm_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsm_curs CURSOR FOR
              SELECT * FROM patchtemp:wsm_file
      FOREACH wsm_curs INTO lr_wsm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsm_file patchtemp FOREACH 資料時產生錯誤，wsm資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wsm_file VALUES(lr_wsm.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsm_file SET wsm01 = lr_wsm.wsm01,wsm02 = lr_wsm.wsm02,
                                   wsmacti = lr_wsm.wsmacti, wsmdate = lr_wsm.wsmdate,
                                   wsmgrup = lr_wsm.wsmgrup, wsmmodu = lr_wsm.wsmmodu,
                                   wsmuser = lr_wsm.wsmuser
             WHERE wsm01 = lr_wsm.wsm01 AND wsm02 = lr_wsm.wsm02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsm_file data error:",SQLCA.sqlerrd[2]," ",lr_wsm.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsm_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsn_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsn_curs CURSOR FOR
              SELECT * FROM patchtemp:wsn_file
      FOREACH wsn_curs INTO lr_wsn.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsn_file patchtemp FOREACH 資料時產生錯誤，wsn資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wsn_file VALUES(lr_wsn.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsn_file SET wsn01 = lr_wsn.wsn01,wsn02 = lr_wsn.wsn02,
                                   wsn03 = lr_wsn.wsn03,wsn04 = lr_wsn.wsn04
             WHERE wsn01 = lr_wsn.wsn01 AND wsn02 = lr_wsn.wsn02 AND wsn03 = lr_wsn.wsn03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsn_file data error:",SQLCA.sqlerrd[2]," ",lr_wsn.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsn_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsn_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wso_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wso_curs CURSOR FOR
              SELECT * FROM patchtemp:wso_file
      FOREACH wso_curs INTO lr_wso.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wso_file patchtemp FOREACH 資料時產生錯誤，wso資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wso_file VALUES(lr_wso.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wso_file SET wso01 = lr_wso.wso01,wso02 = lr_wso.wso02,
                                   wso03 = lr_wso.wso03,wso04 = lr_wso.wso04,
                                   wso05 = lr_wso.wso05
             WHERE wso01 = lr_wso.wso01 AND wso02 = lr_wso.wso02 AND wso03 = lr_wso.wso03 AND wso04 = lr_wso.wso04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wso_file data error:",SQLCA.sqlerrd[2]," ",lr_wso.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wso_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wso_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsp_file資料"
      LET li_count = 0
      LET li_count2= 0
      DECLARE wsp_curs CURSOR FOR
              SELECT * FROM patchtemp:wsp_file
      FOREACH wsp_curs INTO lr_wsp.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsp_file patchtemp FOREACH 資料時產生錯誤，wsp資料無更新"
            CALL lc_channel.write(l_cmd)
            EXIT FOREACH
         END IF
         LET li_count2 = li_count2 + 1

         INSERT INTO ds:wsp_file VALUES(lr_wsp.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsp_file SET wsp01 = lr_wsp.wsp01,wsp02 = lr_wsp.wsp02,
                                   wsp03 = lr_wsp.wsp03,wsp04 = lr_wsp.wsp04,
                                   wsp05 = lr_wsp.wsp05
             WHERE wsp01 = lr_wsp.wsp01 AND wsp02 = lr_wsp.wsp02 AND wsp03 = lr_wsp.wsp03 AND wsp04 = lr_wsp.wsp04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsp_file data error:",SQLCA.sqlerrd[2]," ",lr_wsp.*
               CALL lc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      LET ls_msg = ls_msg,"wsp_file  Patch提供",li_count2,"筆資料, 共成功更新",li_count,"筆資料\n"
      DISPLAY "wsp_file 更新完畢，共更新 ",li_count,"筆資料"      
   END IF       	   

   IF NOT l_result THEN
      CALL lc_channel.write("")
      LET l_cmd = "以上為各Table更新不成功的錯誤碼及資料內容."
      CALL lc_channel.write(l_cmd)
      LET l_cmd = "zz_file,zm_file,gak_file,gal_file上述幾個table若資料無法LOAD,"
      CALL lc_channel.write(l_cmd)
      LET l_cmd = "可能客戶端已更改成客制資料, 請手動查看是否需更新."
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write("")
      LET l_cmd = "===================================================================="
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write("")
      LET l_cmd = "以下為所有Table更新記錄 :"
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write(ls_msg)
   END IF

   CALL lc_channel.close()

   RETURN TRUE
END FUNCTION

#rebuild的4gl compile
FUNCTION bpatch_patch_program_rebuild_rc2()
   DEFINE   ls_root      STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   li_result    LIKE type_file.num5

   FOR g_cnt = 1 TO gr_module.getLength()
       CALL g_rebuild.write("     ==========="||gr_module[g_cnt]||"===============================")
       IF gr_module[g_cnt].subString(1,1) = "c" THEN
          LET ls_root = FGL_GETENV("CUST"),os.Path.separator()
       ELSE
          LET ls_root = FGL_GETENV("TOP"),os.Path.separator()
       END IF
       LET g_cmd = "rm -f ",ls_root,gr_module[g_cnt],os.Path.separator(),"42m",os.Path.separator(),"*.42m"
       RUN g_cmd
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";ls *.4gl >/dev/null 2>&1"
       RUN g_cmd RETURNING li_result
       IF li_result THEN
          CONTINUE FOR
       END IF

       LET lc_channel = base.Channel.create()
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";ls *.4gl"
       CALL lc_channel.openPipe(g_cmd,"r")
       WHILE lc_channel.read(ls_result)
          LET ls_result = ls_result.subString(1,ls_result.getIndexOf(".4gl",1)-1)
          LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";r.c2 ",ls_result
          RUN g_cmd
          IF os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"42m"||os.Path.separator()||gr_module[g_cnt]||"_"||ls_result||".err") OR 
             NOT os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"42m"||os.Path.separator()||gr_module[g_cnt]||"_"||ls_result||".42m") THEN
             CALL g_rebuild.write("     "||ls_result)
          END IF
       END WHILE
       CALL lc_channel.close()
   END FOR

   #安全機制程式解包
   LET g_cmd = "cd ",g_patchpath,";cp security.tar $TOP;cd $TOP;tar xf security.tar"
   RUN g_cmd
   IF os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"security.tar") THEN
      IF os.Path.delete(FGL_GETENV("TOP")||os.Path.separator()||"security.tar") THEN END IF
   END IF
END FUNCTION

#rebuild的4gl link
FUNCTION bpatch_patch_program_rebuild_rl2()
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   ls_root      STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   li_cnt       LIKE type_file.num5
   DEFINE   lc_zz01      LIKE zz_file.zz01

   LET li_result = TRUE
   #先做共用程式的r.l2
   LET g_cmd = "rm $TOP",os.Path.separator(),"lib",os.Path.separator(),"42m",os.Path.separator()||"*.42x;r.l2 lib"
   RUN g_cmd
   IF NOT os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"lib"||os.Path.separator()||"42m"||os.Path.separator()||"lib"||".42x") THEN
      CALL g_rebuild.write("     Generate lib.42x error!")
      LET li_result = FALSE
   END IF
   LET g_cmd = "rm $TOP",os.Path.separator(),"sub",os.Path.separator(),"42m",os.Path.separator()||"*.42x;r.l2 sub"
   RUN g_cmd
   IF NOT os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"sub"||os.Path.separator()||"42m"||os.Path.separator()||"sub"||".42x") THEN
      CALL g_rebuild.write("     Generate sub.42x error!")
      LET li_result = FALSE
   END IF
   LET g_cmd = "rm $TOP",os.Path.separator(),"qry",os.Path.separator(),"42m",os.Path.separator()||"*.42x;r.l2 qry"
   RUN g_cmd
   IF NOT os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"qry"||os.Path.separator()||"42m"||os.Path.separator()||"qry"||".42x") THEN
      CALL g_rebuild.write("     Generate qry.42x error!")
      LET li_result = FALSE
   END IF
   IF NOT li_result THEN
      CALL g_rebuild.write("     共用程式42x產生錯誤, 建議修正完畢後再執行其他模組的rebuild")
      RETURN li_result
   END IF

   # exe2工具的link
   LET g_cmd = "r.l2 p_go"
   RUN g_cmd
   IF NOT os.Path.exists(FGL_GETENV("TOP")||os.Path.separator()||"azz"||os.Path.separator()||"42r"||os.Path.separator()||"p_go"||".42r") THEN
      CALL g_rebuild.write("     Generate p_go.42r error! (exe2會無法執行)")
      RETURN li_result
   END IF

   #其他模組的r.l2
   FOR g_cnt = 1 TO gr_module.getLength()
       IF gr_module[g_cnt] = "lib" OR gr_module[g_cnt] = "sub" OR gr_module[g_cnt] = "qry" OR
          gr_module[g_cnt] = "clib" OR gr_module[g_cnt] = "csub" OR gr_module[g_cnt] = "cqry" THEN
          CONTINUE FOR
       END IF
       CALL g_rebuild.write("     ==========="||gr_module[g_cnt]||"===============================")
       IF gr_module[g_cnt].subString(1,1) = "c" THEN
          LET ls_root = FGL_GETENV("CUST"),os.Path.separator()
       ELSE
          LET ls_root = FGL_GETENV("TOP"),os.Path.separator()
       END IF
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";ls *.4gl >/dev/null 2>&1"
       RUN g_cmd RETURNING li_result
       IF li_result THEN
          CONTINUE FOR
       END IF

       LET lc_channel = base.Channel.create()
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";ls *.4gl"
       CALL lc_channel.openPipe(g_cmd,"r")
       WHILE lc_channel.read(ls_result)
          LET ls_result = ls_result.subString(1,ls_result.getIndexOf(".4gl",1)-1)
          LET lc_zz01 = ls_result
          SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01=lc_zz01
          IF li_cnt <= 0 THEN
             CONTINUE WHILE
          END IF
          LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),"4gl",os.Path.separator(),";r.l2 ",ls_result
          RUN g_cmd
          IF NOT os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"42r"||os.Path.separator()||ls_result||".42r") THEN
             CALL g_rebuild.write("     "||ls_result)
          END IF
       END WHILE
       CALL lc_channel.close()
   END FOR

   RETURN TRUE
END FUNCTION

#rebuild的4fd compile
FUNCTION bpatch_patch_program_rebuild_rf2()
   DEFINE   ls_root      STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_folder    STRING
   DEFINE   li_result    LIKE type_file.num5

   FOR g_cnt = 1 TO gr_module.getLength()
       CALL g_rebuild.write("     ==========="||gr_module[g_cnt]||"===============================")
       IF gr_module[g_cnt].subString(1,1) = "c" THEN
          LET ls_root = FGL_GETENV("CUST"),os.Path.separator()
       ELSE
          LET ls_root = FGL_GETENV("TOP"),os.Path.separator()
       END IF
       LET g_cmd = "rm -f ",ls_root,gr_module[g_cnt],os.Path.separator(),"42f",os.Path.separator(),"*.42f"
       RUN g_cmd
       #預防沒有4fd資料夾
       IF os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"4fd") THEN
          LET ls_folder = "4fd"
       ELSE
          IF os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"per") THEN
             LET ls_folder = "per"
          ELSE
             CALL g_rebuild.write("     Can't find form folder")
             CONTINUE FOR
          END IF
       END IF
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),ls_folder,os.Path.separator(),";ls *.",ls_folder," >/dev/null 2>&1"
       RUN g_cmd RETURNING li_result
       IF li_result THEN
          CONTINUE FOR
       END IF

       LET lc_channel = base.Channel.create()
       LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),ls_folder,os.Path.separator(),";ls *.",ls_folder
       CALL lc_channel.openPipe(g_cmd,"r")
       WHILE lc_channel.read(ls_result)
          LET ls_result = ls_result.subString(1,ls_result.getIndexOf("."||ls_folder,1)-1)
          LET g_cmd = "cd ",ls_root,gr_module[g_cnt],os.Path.separator(),ls_folder,os.Path.separator(),";r.f2 ",ls_result
          RUN g_cmd
          IF NOT os.Path.exists(ls_root||gr_module[g_cnt]||os.Path.separator()||"42f"||os.Path.separator()||ls_result||".42f") THEN
             CALL g_rebuild.write("     "||ls_result)
          END IF
       END WHILE
       CALL lc_channel.close()
   END FOR
END FUNCTION

#檢查patch每個步驟是否可以進行, 請看程式最上方註解
FUNCTION bpatch_step_check(ps_step)
   DEFINE   ps_step     STRING
   DEFINE   ls_msg      STRING
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_time     STRING

   LET li_result = TRUE
   CASE
      WHEN ps_step = "3-1"
         LET ls_msg = ""
         FOR g_cnt = 1 TO gr_dblist.getLength()
             IF gr_dblist[g_cnt].chk = "Y" THEN
                CALL bpatch_step_check_db_backup(gr_dblist[g_cnt].azp03 CLIPPED) RETURNING li_result
                IF li_result THEN
                   LET ls_msg = ls_msg,gr_dblist[g_cnt].azp03 CLIPPED,","
                END IF
             END IF
         END FOR
         IF ls_msg IS NOT NULL THEN
            LET ls_msg = ls_msg.subString(1,ls_msg.getLength()-1)
            CALL bpatch_confirm(ls_msg||"\n以上資料庫已備份過, 請自行手動備份於其他資料夾\n是否要繼續?") RETURNING li_result
            IF NOT li_result THEN
               EXIT CASE
            END IF
         ELSE
            LET li_result = TRUE
         END IF
      WHEN ps_step = "3-2"
         CALL bpatch_step_check_db_backup("ds") RETURNING li_result
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫備份不存在, 無法繼續進行")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm("ds資料庫的table在 "||ls_time||" 已alter過,\n重新執行可能有誤, 先前log檔也會被覆蓋,\n是否確定要執行?") RETURNING li_result
         ELSE
            LET li_result = TRUE
         END IF
         EXIT CASE
      WHEN ps_step = "3-3"
         CALL bpatch_step_check_db_backup("ds") RETURNING li_result
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫備份不存在, 無法繼續進行")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
      WHEN ps_step = "3-4"
         CALL bpatch_step_check_db_backup("ds") RETURNING li_result
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫備份不存在, 無法繼續進行")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-4") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm("ds資料庫的index在 "||ls_time||" 已alter過,\n重新執行可能有誤, 先前log檔也會被覆蓋,\n是否確定要執行?") RETURNING li_result
         ELSE
            LET li_result = TRUE
         END IF
         EXIT CASE
      WHEN ps_step = "3-5"
         LET ls_msg = ""
         FOR g_cnt = 1 TO gr_dblist.getLength()
             IF gr_dblist[g_cnt].chk = "Y" THEN
                CALL bpatch_step_check_db_backup(gr_dblist[g_cnt].azp03 CLIPPED) RETURNING li_result
                IF NOT li_result THEN
                   LET ls_msg = ls_msg,gr_dblist[g_cnt].azp03 CLIPPED,","
                END IF
             END IF
         END FOR
         IF ls_msg IS NOT NULL THEN
            LET ls_msg = ls_msg.subString(1,ls_msg.getLength()-1)
            CALL bpatch_show_msg(ls_msg||"\n以上資料庫未備份, 請確認後再繼續 ")
            LET li_result = FALSE
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-5") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm(ls_msg||" 這些資料庫的table在 "||ls_time||" 已alter過,\n重新執行可能有誤, 先前log檔也會被覆蓋,\n是否確定要執行?") RETURNING li_result
         ELSE
            LET li_result = TRUE
         END IF
         EXIT CASE
      WHEN ps_step = "3-6"
         LET ls_msg = ""
         FOR g_cnt = 1 TO gr_dblist.getLength()
             IF gr_dblist[g_cnt].chk = "Y" THEN
                CALL bpatch_step_check_db_backup(gr_dblist[g_cnt].azp03 CLIPPED) RETURNING li_result
                IF NOT li_result THEN
                   LET ls_msg = ls_msg,gr_dblist[g_cnt].azp03 CLIPPED,","
                END IF
             END IF
         END FOR
         IF ls_msg IS NOT NULL THEN
            LET ls_msg = ls_msg.subString(1,ls_msg.getLength()-1)
            CALL bpatch_show_msg(ls_msg||"\n以上資料庫未備份, 請確認後再繼續 ")
            LET li_result = FALSE
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-5") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("非ds資料庫尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
      WHEN ps_step = "3-7"
         LET ls_msg = ""
         FOR g_cnt = 1 TO gr_dblist.getLength()
             IF gr_dblist[g_cnt].chk = "Y" THEN
                CALL bpatch_step_check_db_backup(gr_dblist[g_cnt].azp03 CLIPPED) RETURNING li_result
                IF NOT li_result THEN
                   LET ls_msg = ls_msg,gr_dblist[g_cnt].azp03 CLIPPED,","
                END IF
             END IF
         END FOR
         IF ls_msg IS NOT NULL THEN
            LET ls_msg = ls_msg.subString(1,ls_msg.getLength()-1)
            CALL bpatch_show_msg(ls_msg||"\n以上資料庫未備份, 請確認後再繼續 ")
            LET li_result = FALSE
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-4") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫的index尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-5") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("非ds資料庫尚未alter, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-7") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm(ls_msg||" 這些資料庫的index在 "||ls_time||" 已alter過,\n重新執行可能有誤, 先前log檔也會被覆蓋,\n是否確定要執行?") RETURNING li_result
         ELSE
            LET li_result = TRUE
         END IF
         EXIT CASE
      WHEN ps_step = "4-2"
         CALL bpatch_step_check_step_log("4-1") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("基本資料暫存的patchtemp資料庫未建立, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_db_backup("ds") RETURNING li_result
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫備份不存在, 無法繼續進行")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter table, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-4") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter index, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("4-2") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm("在 "||ls_time||" 已更新過基本資料, 是否確定要執行?") RETURNING li_result
         ELSE
            LET li_result = TRUE
         END IF
         EXIT CASE
      WHEN ps_step = "5"
         CALL bpatch_step_check_step_log("5") RETURNING li_result,ls_msg,ls_time
         IF li_result THEN
            CALL bpatch_confirm("在 "||ls_time||" 已更新過TIPTOP程式, 是否確定要執行?") RETURNING li_result
            IF NOT li_result THEN
               EXIT CASE
            END IF
         ELSE
            LET li_result = TRUE
         END IF
         IF os.Path.exists(g_backuppath||"tiptop.tar") AND os.Path.exists(g_backuppath||"tiptop_cust.tar") THEN
            CALL bpatch_confirm("備份已存在, 請手動備份於其他區域, 是否繼續?") RETURNING li_result
            IF NOT li_result THEN
               EXIT CASE
            END IF
         ELSE
            LET li_result = TRUE
         END IF
      WHEN ps_step = "6-1"
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter table, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-4") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter index, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("4-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("基本資料尚未更新, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("5") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("TIPTOP程式尚未更新, 請執行後再繼續")
            EXIT CASE
         END IF
         IF NOT os.Path.exists(FGL_GETENV("FGLDBPATH")||os.Path.separator()||"ds.sch") THEN
            CALL bpatch_show_msg("ds.sch不存在, 無法compile")
            LET li_result = FALSE
            EXIT CASE
         END IF
      WHEN ps_step = "6-2"
         CALL bpatch_step_check_step_log("6-1") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("全系統尚未編譯過, 請執行後再繼續")
            EXIT CASE
         END IF
      WHEN ps_step = "6-3"
         CALL bpatch_step_check_step_log("3-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter table, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("3-4") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("ds資料庫尚未alter index, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("4-2") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("基本資料尚未更新, 請執行後再繼續")
            EXIT CASE
         END IF
         CALL bpatch_step_check_step_log("5") RETURNING li_result,ls_msg,ls_time
         IF NOT li_result THEN
            CALL bpatch_show_msg("TIPTOP程式尚未更新, 請執行後再繼續")
            EXIT CASE
         END IF
         IF NOT os.Path.exists(FGL_GETENV("FGLDBPATH")||os.Path.separator()||"ds.sch") THEN
            CALL bpatch_show_msg("ds.sch不存在, 無法compile")
            LET li_result = FALSE
            EXIT CASE
         END IF
   END CASE
   IF NOT li_result THEN
      MESSAGE "取消繼續執行"
   END IF

   RETURN li_result
END FUNCTION

#檢查指定資料庫是否存在備份
FUNCTION bpatch_step_check_db_backup(ps_dbs)
   DEFINE   ps_dbs      STRING
   DEFINE   li_result   LIKE type_file.num5

   LET li_result = TRUE
   CASE
      WHEN g_db_type = "ORA"
         IF NOT os.Path.exists(g_backuppath||ps_dbs||".dmp") THEN
            LET li_result = FALSE
         END IF
      WHEN g_db_type = "IFX"
         IF NOT os.Path.exists(g_backuppath||ps_dbs||".exp") THEN
            LET li_result = FALSE
         END IF
   END CASE
   RETURN li_result
END FUNCTION

#檢查指定步驟是否存在log檔中, 判斷是否執行過的依據
FUNCTION bpatch_step_check_step_log(ps_step)
   DEFINE   ps_step     STRING
   DEFINE   lc_channel  base.Channel
   DEFINE   ls_result   STRING
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_msg      STRING
   DEFINE   ls_time     STRING

   LET li_result = FALSE
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_logpath||"patch_step_record.log","r")
   WHILE lc_channel.read(ls_result)
      IF ls_result.getIndexOf("#"||ps_step||" ",1) THEN
         LET li_result = TRUE
         IF ls_result.getIndexOf(" ------- ",1) AND ls_result.getIndexOf(" (",1) THEN
            LET ls_msg = ls_result.subString(ls_result.getIndexOf(" ------- ",1)+9,ls_result.getIndexOf(" (",1)-1)
         END IF
         IF ls_result.getIndexOf(" (",1) AND ls_result.getIndexOf(")",1) THEN
            LET ls_time = ls_result.subString(ls_result.getIndexOf(" (",1)+2,ls_result.getIndexOf(")",1)-1)
         END IF
      END IF
   END WHILE

   RETURN li_result,ls_msg,ls_time
END FUNCTION

#指定檔案若存在, 則開啟指定action的按鍵
FUNCTION bpatch_open_log_view(ps_files,ps_action)
   DEFINE   ps_files    STRING
   DEFINE   ps_action   STRING
   DEFINE   lst_files   base.StringTokenizer
   DEFINE   ls_file     STRING
   DEFINE   li_result   LIKE type_file.num5

   LET lst_files = base.StringTokenizer.create(ps_files, ",")
   WHILE lst_files.hasMoreTokens() 
      LET ls_file = lst_files.nextToken()
      LET ls_file = ls_file.trim()
      IF os.Path.exists(ls_file) THEN
         LET li_result = TRUE
         EXIT WHILE
      END IF
   END WHILE
   IF li_result THEN
      CALL bpatch_set_action_active(ps_action,TRUE)
   END IF
END FUNCTION

#清空patch畫面上的執行圖示
FUNCTION bpatch_clear_img()
   DISPLAY "" TO FORMONLY.img01
   DISPLAY "" TO FORMONLY.img02
   DISPLAY "" TO FORMONLY.img03
   DISPLAY "" TO FORMONLY.img04
   DISPLAY "" TO FORMONLY.img05
   DISPLAY "" TO FORMONLY.img06
   DISPLAY "" TO FORMONLY.img07
   DISPLAY "" TO FORMONLY.img08
   DISPLAY "" TO FORMONLY.img09
   DISPLAY "" TO FORMONLY.img10
   DISPLAY "" TO FORMONLY.img11
   DISPLAY "" TO FORMONLY.img12
   DISPLAY "" TO FORMONLY.img13
   DISPLAY "" TO FORMONLY.img14
END FUNCTION

#開啟視窗顯示訊息
FUNCTION bpatch_show_msg(ps_msg)
   DEFINE   ps_msg   STRING
 
   MENU "Message" ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
   END MENU

   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END FUNCTION

#開啟視窗詢問問題
FUNCTION bpatch_confirm(ps_msg)
   DEFINE   ps_msg      STRING
   DEFINE   li_result   LIKE type_file.num5

   LET li_result = FALSE 
   MENU "Message" ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION yes
         LET li_result = TRUE
         EXIT MENU
      ON ACTION no
         EXIT MENU
   END MENU

   IF INT_FLAG THEN
      LET li_result = FALSE
      LET INT_FLAG = 0
   END IF

   RETURN li_result
END FUNCTION

#設定Action顯不顯示
FUNCTION bpatch_set_action_active(ps_actions, pi_active)
   DEFINE ps_actions    STRING,
          pi_active     LIKE type_file.num10
   DEFINE la_act_type   DYNAMIC ARRAY OF STRING
   DEFINE lwin_curr     ui.Window  
   DEFINE lnl_actions   om.NodeList
   DEFINE ln_action     om.DomNode,
          ln_win        om.DomNode
   DEFINE lst_actions   base.StringTokenizer
   DEFINE ls_action     STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE li_j          LIKE type_file.num10

   
   IF (ps_actions IS NULL) THEN
      RETURN
   ELSE
      LET ps_actions = ps_actions.toLowerCase()
   END IF
  
   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   LET la_act_type[4] = "MenuAction"

   FOR li_j = 1 TO la_act_type.getLength()
       LET lwin_curr = ui.Window.getCurrent()
       LET ln_win = lwin_curr.getNode()
       LET lnl_actions = ln_win.selectByTagName(la_act_type[li_j])
       IF lnl_actions.getLength() <= 0 THEN
          CONTINUE FOR
       END IF
       
       LET lst_actions = base.StringTokenizer.create(ps_actions, ",")
       WHILE lst_actions.hasMoreTokens() 
          LET ls_action = lst_actions.nextToken()
          LET ls_action = ls_action.trim()
          
          FOR li_i = 1 TO lnl_actions.getLength()
              LET ln_action = lnl_actions.item(li_i)

              IF ls_action = ln_action.getAttribute("name") THEN
                 IF pi_active THEN
                    CALL ln_action.setAttribute("active", 1)
                    CALL ln_action.setAttribute("hidden", "0")
                    CALL ln_action.setAttribute("active", "1")
                 ELSE
                    CALL ln_action.setAttribute("active", 0)
                    CALL ln_action.setAttribute("hidden", "1")
                    CALL ln_action.setAttribute("active", "0")
                 END IF
                 EXIT FOR
              END IF
          END FOR
       END WHILE
   END FOR
END FUNCTION

#設定元件顯不顯示
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

#抓column的資訊, type, size, not null, default
FUNCTION cl_get_column_info(p_dbname,p_tabname,p_colname)
   DEFINE p_dbname    LIKE type_file.chr20
   DEFINE p_tabname   LIKE type_file.chr20
   DEFINE p_colname   LIKE type_file.chr20
   DEFINE l_db_type   LIKE type_file.chr3
   DEFINE l_sql       STRING
   DEFINE l_datatype  LIKE ahe_file.ahe04
   DEFINE l_length1   LIKE type_file.num5
   DEFINE l_length2   LIKE type_file.num5
   DEFINE l_length    STRING
   DEFINE l_tmp       STRING
   DEFINE l_nullable  LIKE type_file.chr1
   DEFINE l_default   LIKE type_file.chr1000

   LET l_db_type = DB_GET_DATABASE_TYPE()

   CASE
   WHEN l_db_type="IFX" 
      LET l_sql=" SELECT coltype,collength,'','',default ",
                  " FROM ",p_dbname CLIPPED,":systables a, ",
                           p_dbname CLIPPED,":syscolumns b ",
                           p_dbname CLIPPED,":sysdefaults c ",
                 " WHERE a.tabname='",p_tabname CLIPPED,"' ",
                   " AND a.tabid=b.tabid AND a.tabid=b.tabid ",
                   " AND b.colname='",p_colname CLIPPED,"' ",
                   " AND c.colno=b.colname"
   WHEN l_db_type="ORA" 
      LET l_sql=" SELECT lower(data_type),to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
                       " data_scale , nullable, data_default ",
                  " FROM all_tab_columns ",
                 " WHERE lower(table_name)='",p_tabname CLIPPED,"' ",
                   " AND lower(column_name)='",p_colname CLIPPED,"' ",
                   " AND lower(owner)='",p_dbname CLIPPED,"' "
   END CASE

   PREPARE cl_get_column_info_p FROM l_sql
   EXECUTE cl_get_column_info_p INTO l_datatype,l_length1,l_length2,l_nullable,l_default
   CASE
   WHEN l_db_type="IFX" 
      IF l_datatype >= 256 THEN
         LET l_nullable = "N"
      END IF
      CALL cl_ifx_datatype_parse(l_datatype,l_length1)
      RETURNING l_datatype,l_length
   WHEN l_db_type="ORA" 
      IF l_length2 is not null THEN
         LET l_tmp=l_length1
         LET l_length=l_tmp CLIPPED,','
         LET l_tmp=l_length2 
         LET l_length=l_length CLIPPED,l_tmp
      ELSE
         LET l_tmp=l_length1
         LET l_length=l_tmp CLIPPED
      END IF
   END CASE
   RETURN l_datatype,l_length,l_nullable,l_default
END FUNCTION

FUNCTION cl_ifx_datatype_parse(p_datatype,p_length)
DEFINE p_datatype   LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE p_length     LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE l_datatype   STRING
DEFINE l_length     STRING
DEFINE l_tmp        STRING
DEFINE l_i          LIKE type_file.num5

   IF p_datatype>=256 THEN
      LET p_datatype=p_datatype-256
   END IF
   CASE WHEN p_datatype = 0
             LET l_tmp=p_length CLIPPED
             LET l_datatype = "char"
             LET l_length = l_tmp CLIPPED
        WHEN p_datatype = 1 LET l_datatype = "smallint"
        WHEN p_datatype = 2 LET l_datatype = "integer"
        WHEN p_datatype = 5
             LET l_tmp=p_length/256
             LET p_length=p_length mod 256 CLIPPED
             IF l_tmp<p_length THEN
                LET l_length=l_tmp.subString(1,l_tmp.getIndexOf('.',1)-1)
             ELSE
                LET l_datatype=l_tmp.subString(1,l_tmp.getIndexOf('.',1)-1),','
                LET l_tmp=p_length CLIPPED
                LET l_datatype = l_datatype CLIPPED,l_tmp CLIPPED
             END IF
             LET l_length = l_datatype CLIPPED
             LET l_datatype = "decimal"
        WHEN p_datatype = 7 LET l_datatype = "date"
             LET l_length = 4
        WHEN p_datatype = 10 LET l_datatype = "datetime"
             LET l_length=p_length mod 514
             CASE
                WHEN l_length=510
                     LET l_length="year to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"year"
                        WHEN p_length=2
                             LET l_length=l_length,"month"
                        WHEN p_length=3
                             LET l_length=l_length,"day"
                        WHEN p_length=4
                             LET l_length=l_length,"hour"
                        WHEN p_length=5
                             LET l_length=l_length,"minute"
                        WHEN p_length=6
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=32
                     LET l_length="month to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"month"
                        WHEN p_length=2
                             LET l_length=l_length,"day"
                        WHEN p_length=3
                             LET l_length=l_length,"hour"
                        WHEN p_length=4
                             LET l_length=l_length,"minute"
                        WHEN p_length=5
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=66
                     LET l_length="day to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"day"
                        WHEN p_length=2
                             LET l_length=l_length,"hour"
                        WHEN p_length=3
                             LET l_length=l_length,"minute"
                        WHEN p_length=4
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=100
                     LET l_length="hour to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"hour"
                        WHEN p_length=2
                             LET l_length=l_length,"minute"
                        WHEN p_length=3
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=134
                     LET l_length="minute to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"minute"
                        WHEN p_length=2
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=168
                     LET l_length="second to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"second"
                     END CASE
             END CASE
        WHEN p_datatype = 11 LET l_datatype = "byte"
        OTHERWISE LET p_datatype = l_datatype
   END CASE
   RETURN l_datatype,l_length
END FUNCTION

#查看檔案, 用p_view, 不用他們的是因為有時候版更過程中, 程式可能開不起來
FUNCTION bpatch_patch_view_file(ps_filename)
   DEFINE   ps_filename   STRING
   DEFINE   l_ch          base.Channel
   DEFINE   l_window      ui.Window
   DEFINE   l_i           LIKE type_file.num10
   DEFINE   l_buf         STRING

   IF ps_filename IS NULL THEN
      DISPLAY "You need to specify a report file as parameter."
      RETURN
   END IF
 
   OPEN WINDOW bpatch_view_w WITH FORM "bpatch_view" ATTRIBUTE(STYLE="reportViewer")
 
   LET g_report = ps_filename CLIPPED, ".tmp"
   LET g_cmd = "cat ", ps_filename CLIPPED, " | sed -e 's/$//' > ", g_report
   RUN g_cmd
   LET g_cmd = "chmod a+wx ", g_report
   RUN g_cmd
   LET l_ch = base.Channel.create()
   LET g_cmd = "unset LANG; wc -l ", g_report CLIPPED, " | awk ' { print $1 }'"
   CALL l_ch.openPipe(g_cmd, "r")
   WHILE l_ch.read(g_total_line)
   END WHILE
   CALL l_ch.close()

   CALL l_ch.openFile(g_report, "r")
   LET l_i = 0
   WHILE l_ch.read(l_buf)
       LET l_i = l_i + 1
   END WHILE
   IF l_i != g_total_line THEN
      LET l_i = l_i + 1
      LET g_error_line = l_i
   ELSE
      LET g_error_line = 0
   END IF
   CALL l_ch.close()

   LET g_page_line = 37

   LET l_window = ui.Window.getCurrent()
   CALL l_window.setText(ps_filename)
   CALL p_view_showPage()
   CLOSE WINDOW bpatch_view_w

   LET g_cmd = "rm -f ", g_report
   RUN g_cmd
END FUNCTION
 
FUNCTION p_view_showPage()
   DEFINE l_page LIKE type_file.num10

   CALL p_view_calculatePage()
   LET g_showline = 0

   WHILE TRUE
      CALL p_view_loadPage()
 
      LET l_page = g_curr_page
      INPUT g_content, l_page WITHOUT DEFAULTS FROM FORMONLY.content,FORMONLY.curr ATTRIBUTE(UNBUFFERED)
         BEFORE INPUT
            DISPLAY g_total_page TO FORMONLY.total
            CALL p_view_disableAction(DIALOG)
            IF g_error_line != 0 THEN
               CALL bpatch_show_msg("此報表檔在第"||g_error_line||"行可能有不合法字元!")
               LET g_error_line = 0   #Shows in first time
            END IF
         AFTER FIELD curr
            IF g_curr_page != l_page THEN
               IF ( l_page <= 0 ) OR ( l_page > g_total_page ) THEN
                  LET l_page = g_curr_page
               ELSE
                  LET g_curr_page = l_page
                  EXIT INPUT
               END IF
            END IF
         ON ACTION first_page   # Jump to First Page
             LET g_curr_page = 1
             EXIT INPUT
         ON ACTION next_page    # Jump to Next Page
             LET g_curr_page = g_curr_page + 1
             EXIT INPUT
         ON ACTION prev_page    # Jump to Previous Page
             LET g_curr_page = g_curr_page - 1
             EXIT INPUT
         ON ACTION last_page    # Jump to Last Page
             LET g_curr_page = g_total_page
             EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION p_view_loadPage()
   DEFINE l_ch           base.Channel,
          l_buf          STRING
   DEFINE l_i            LIKE type_file.num10
   DEFINE l_offset_begin LIKE type_file.num10,
          l_offset_end   LIKE type_file.num10
   DEFINE l_str          STRING

   LET g_content = NULL   # Initialize Page Content
   LET l_i = 0

   LET l_offset_begin = ( ( g_curr_page - 1 ) * g_page_line ) + 1
   LET l_offset_end = ( l_offset_begin + g_page_line ) - 1
   IF l_offset_end > g_total_line THEN
      LET l_offset_end = g_total_line
   END IF
 
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(g_report, "r")
   IF STATUS THEN
      DISPLAY "Can't open/read report file."
      EXIT PROGRAM
   END IF
   CALL l_ch.setDelimiter("")
   WHILE l_ch.read(l_buf)
       LET l_i = l_i + 1
       IF l_i < l_offset_begin THEN   # If Current Line Less than Begin of Offset, Continue Loop
          CONTINUE WHILE
       END IF
       IF l_i > l_offset_end THEN     # If Current Line Great than End of Offset, Exit Loop
          EXIT WHILE
       END IF
       IF g_showline THEN             # Put Line Number to Begin of Line
          LET l_buf = l_i USING '########', ": ", l_buf
       END IF
       IF l_i < l_offset_end THEN
          LET l_buf = l_buf.append("\n")
       END IF
       LET g_content = g_content.append(l_buf)
   END WHILE
   CALL l_ch.close()
END FUNCTION

FUNCTION p_view_disableAction(pd_dialog)
   DEFINE pd_dialog ui.Dialog

   IF g_curr_page = 1 THEN
      CALL pd_dialog.setActionActive("first_page", FALSE)
      CALL pd_dialog.setActionActive("prev_page", FALSE)
   END IF

   IF g_curr_page = g_total_page THEN
      CALL pd_dialog.setActionActive("last_page", FALSE)
      CALL pd_dialog.setActionActive("next_page", FALSE)
   END IF
END FUNCTION

FUNCTION p_view_calculatePage()
   LET g_curr_page = 1
   LET g_total_page = g_total_line / g_page_line
   IF (g_total_line MOD g_page_line) THEN
      LET g_total_page = g_total_page + 1
   END IF
END FUNCTION

#檢查提供的create table SQL command是否與目前資料庫一致 (目前沒用)
FUNCTION bpatch_patch_schema_cmd_analyze_table(ps_dbs,ps_cmd)
   DEFINE   ps_dbs           STRING
   DEFINE   ps_cmd           STRING
   DEFINE   li_result        LIKE type_file.num5
   DEFINE   ls_cmd           STRING
   DEFINE   ls_memostr       STRING
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   li_createstart   LIKE type_file.num5
   DEFINE   lc_createtb      base.Channel
   DEFINE   ls_result        STRING
   DEFINE   lc_db_type       CHAR(15)
   DEFINE   ls_db_size       STRING
   DEFINE   lc_nullable      LIKE type_file.chr1
   DEFINE   lc_default       LIKE type_file.chr1000
   DEFINE   ls_table         STRING
   DEFINE   ls_column        STRING

   IF g_db_type = "ORA" THEN
      LET ls_memostr = "/*"
   ELSE
      LET ls_memostr = "{"
   END IF

   LET li_cnt = 0
   WHILE ps_cmd.getIndexOf("/",li_cnt+1)
      LET li_cnt = ps_cmd.getIndexOf("/",li_cnt+1)
   END WHILE
   LET g_file = ps_cmd.subString(li_cnt+1,ps_cmd.getIndexOf("}",1)-1)
   IF NOT os.Path.exists(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file) THEN
      LET g_file = g_file.subString(1,g_file.getIndexOf(".src",1)-1)
      IF NOT os.Path.exists(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file) THEN
         RETURN TRUE,ps_cmd
      END IF
   END IF
   LET li_createstart = FALSE
   LET ls_cmd = ""
   LET lc_createtb = base.Channel.create()
   CALL lc_createtb.openFile(g_patchpath||os.Path.separator()||"dbschema"||os.Path.separator()||g_file,"r")
   WHILE lc_createtb.read(ls_result)
      LET ls_result = ls_result.trim()
      IF ls_result.getIndexOf(ls_memostr,1) > 1 THEN
         LET ls_result = ls_result.subString(1,ls_result.getIndexOf(ls_memostr,1)-1)
      END IF
      CASE
         WHEN ls_result.getIndexOf("create table",1)
            LET li_createstart = TRUE
            LET ls_cmd = ls_result
            LET ls_table = ls_result.subString(ls_result.getIndexOf("create table ",1)+13,ls_result.getLength())
            LET ls_table = ls_table.trim()
         WHEN ls_result.subString(ls_result.getLength(),ls_result.getLength()) = ";"
            IF li_createstart THEN
               LET ls_cmd = ls_cmd," ",ls_result
               LET li_createstart = FALSE
            ELSE
               LET ls_cmd = ls_cmd,"\n",ls_result
            END IF
         OTHERWISE
            IF li_createstart THEN
               LET ls_cmd = ls_cmd," ",ls_result
               #必須為固定格式, 否則容易判斷錯
               IF ls_result.subString(1,1) != "(" AND ls_result.subString(1,1) != ")" THEN
                  LET ls_column = ls_result.subString(1,ls_result.getIndexOf(" ",1)-1)
                  LET ls_column = ls_column.trim()
                  CALL cl_get_column_info(ps_dbs,ls_table,ls_column) RETURNING lc_db_type,ls_db_size,lc_nullable,lc_default
                  CASE
                     WHEN lc_db_type CLIPPED = "varchar2" OR lc_db_type CLIPPED = "char" OR lc_db_type CLIPPED = "decimal"
                        IF NOT ls_result.getIndexOf(lc_db_type CLIPPED||"("||ls_db_size||")",1) THEN
                           LET li_result = TRUE
                        END IF
                     WHEN lc_db_type CLIPPED = "number"
                        IF NOT ls_result.getIndexOf(lc_db_type CLIPPED||"("||ls_db_size||")",1) THEN
                           IF ls_db_size.getIndexOf(",0",1) THEN
                              LET ls_db_size = ls_db_size.subString(1,ls_db_size.getIndexOf(",0",1)-1)
                              IF NOT ls_result.getIndexOf(lc_db_type CLIPPED||"("||ls_db_size||")",1) THEN
                                 LET li_result = TRUE
                              END IF
                           END IF
                        END IF
                     OTHERWISE
                        IF NOT ls_result.getIndexOf(lc_db_type CLIPPED,1) THEN
                           LET li_result = TRUE
                        END IF
                  END CASE
                  IF lc_nullable IS NOT NULL AND lc_nullable = "N" THEN
                     IF NOT ls_result.getIndexOf(" not null",1) AND NOT ls_result.getIndexOf(" NOT NULL",1) THEN
                        LET li_result = TRUE
                     END IF
                  END IF
                  IF lc_default IS NOT NULL THEN
                     IF NOT ls_result.getIndexOf(" default "||lc_default CLIPPED,1) AND
                        NOT ls_result.getIndexOf(" DEFAULT "||lc_default CLIPPED,1) THEN
                        LET li_result = TRUE
                     END IF
                  END IF
               END IF
            END IF
      END CASE
   END WHILE
   CALL lc_createtb.close()

   RETURN li_result,ls_cmd
END FUNCTION
