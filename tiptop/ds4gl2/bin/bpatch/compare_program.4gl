# 比對程式差異,並顯示報表 2007 by saki

# Parameter 1 : Result Log Path

IMPORT os

DEFINE   g_logpath    STRING
DEFINE   g_cur_list   DYNAMIC ARRAY OF STRING      #Current路徑下總程式列表
DEFINE   g_std_list   DYNAMIC ARRAY OF STRING      #Standard路徑下總程式列表
DEFINE   g_cur_list_f DYNAMIC ARRAY OF STRING      #Current路徑下總畫面列表
DEFINE   g_std_list_f DYNAMIC ARRAY OF STRING      #Standard路徑下總畫面列表
DEFINE   g_tiptop     STRING    #當區TIPTOP標準目錄路徑
DEFINE   g_topcust    STRING    #當區客製目錄路徑
DEFINE   g_std_dir    STRING    #標準區目錄路徑
DEFINE   g_cur_dir    STRING    #測試區目錄路徑
DEFINE   g_action     STRING

#程式
DEFINE   g_compare    DYNAMIC ARRAY OF RECORD      #差異程式列表
            cmp_path  STRING,
            cur_ver   STRING,
            std_ver   STRING,
            dif_qty   SMALLINT,
            dif_rate  DEC(10,5)
                      END RECORD
DEFINE   g_custom     DYNAMIC ARRAY OF RECORD      #客製程式列表
            cust_path STRING,
            curr_path STRING,
            cust_dif  SMALLINT,
            dif_rate  DEC(10,5)
                      END RECORD
DEFINE   g_standard   DYNAMIC ARRAY OF STRING      #只存在標準區程式列表
DEFINE   g_current    DYNAMIC ARRAY OF STRING      #只存在比對區程式列表
DEFINE   g_cmp_cnt    INTEGER

#畫面
DEFINE   g_compare_f  DYNAMIC ARRAY OF RECORD      #差異畫面列表
            cmp_path  STRING,
            dif_qty   SMALLINT,
            dif_rate  DEC(10,5)
                      END RECORD
DEFINE   g_custom_f   DYNAMIC ARRAY OF RECORD      #客製畫面列表
            cust_path STRING,
            curr_path STRING,
            cust_dif  SMALLINT,
            dif_rate  DEC(10,5)
                      END RECORD
DEFINE   g_standard_f DYNAMIC ARRAY OF STRING      #只存在標準區畫面列表
DEFINE   g_current_f  DYNAMIC ARRAY OF STRING      #只存在比對區畫面列表
DEFINE   g_cmp_cnt_f  INTEGER
DEFINE   g_os_type    STRING
DEFINE   g_pkg_prog_cnt SMALLINT
DEFINE   g_pkg_form_cnt SMALLINT
DEFINE   g_cmd          STRING

#Progress Bar
DEFINE mi_total_count INTEGER
DEFINE mi_current     INTEGER

MAIN
   DEFINE   li_i         SMALLINT
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_cmd       STRING

   LET g_logpath = ARG_VAL(1)
   IF g_logpath IS NULL THEN
      LET g_logpath = FGL_GETENV("TEMPDIR"),os.Path.separator()
   END IF
   LET g_tiptop = FGL_GETENV("TOP")
   LET g_topcust = FGL_GETENV("CUST")
   LET g_cur_dir = os.Path.dirname(g_tiptop)
   LET g_std_dir = os.Path.dirname(g_cur_dir),"/topstd"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe("uname -s", "r")
   WHILE lc_channel.read(g_os_type)
   END WHILE
   CALL lc_channel.close()
   LET g_os_type = g_os_type.toUpperCase()

   OPEN WINDOW compare_program_w WITH FORM "compare_program"
     ATTRIBUTE (STYLE="sm3")
   CLOSE WINDOW screen
   CALL ui.Interface.loadStyles(g_tiptop||"/config/4st/tiptop.4st")

   WHILE TRUE
   INPUT g_cur_dir,g_std_dir WITHOUT DEFAULTS FROM cur_path,std_path
      AFTER INPUT
         LET g_cur_dir = GET_FLDBUF(formonly.cur_path)
         LET g_std_dir = GET_FLDBUF(formonly.std_path)
   END INPUT
   IF NOT INT_FLAG THEN
      IF g_cur_dir IS NOT NULL AND g_std_dir IS NOT NULL AND
         os.Path.diropen(g_cur_dir) AND os.Path.diropen(g_std_dir) THEN
         #找出所有比對區程式
         CALL g_current.clear()
         CALL g_cur_list.clear()
         CALL program_list(g_cur_dir,"cur","4gl")
         FOR li_i = 1 TO g_cur_list.getLength()
             LET g_current[li_i]=g_cur_list[li_i]
         END FOR

         #找出所有比對區畫面檔
         CALL g_current_f.clear()
         CALL g_cur_list_f.clear()
         CALL program_list(g_cur_dir,"cur","4fd")
         FOR li_i = 1 TO g_cur_list_f.getLength()
             LET g_current_f[li_i]=g_cur_list_f[li_i]
         END FOR

         #找出所有標準區程式
         CALL g_standard.clear()
         CALL g_std_list.clear()
         CALL program_list(g_std_dir,"std","4gl")

         #找出所有標準區畫面檔
         CALL g_standard_f.clear()
         CALL g_std_list_f.clear()
         CALL program_list(g_std_dir,"std","4fd")

         DISPLAY g_cur_list.getLength() TO FORMONLY.cur_cnt
         DISPLAY g_std_list.getLength() TO FORMONLY.std_cnt
         DISPLAY g_cur_list_f.getLength() TO FORMONLY.cur_cnt_f
         DISPLAY g_std_list_f.getLength() TO FORMONLY.std_cnt_f
         CALL g_compare.clear()

         #比對兩區程式與畫面檔
         CALL program_compare()
      ELSE
         MESSAGE "Path Wrong..,Just list costomize file"
      END IF

      #找出package總程式量
      LET g_cmd = "find $TOP/*/4gl -name '*.4gl' > $TEMPDIR/compare_program_file_count.txt"
      RUN g_cmd
      LET lc_channel = base.Channel.create()
      LET g_cmd = "wc -l $TEMPDIR/compare_program_file_count.txt|awk '{print $1}'"
      CALL lc_channel.openPipe(g_cmd,"r")
      IF lc_channel.read(ls_result) THEN
         LET g_pkg_prog_cnt = ls_result
      END IF
      CALL lc_channel.close()
      
      #找出package總畫面量
      LET g_cmd = "find $TOP/*/4fd -name '*.4fd' > $TEMPDIR/compare_program_file_count.txt"
      RUN g_cmd
      LET lc_channel = base.Channel.create()
      LET g_cmd = "wc -l $TEMPDIR/compare_program_file_count.txt|awk '{print $1}'"
      CALL lc_channel.openPipe(g_cmd,"r")
      IF lc_channel.read(ls_result) THEN
         LET g_pkg_form_cnt = ls_result
      END IF
      CALL lc_channel.close()
      LET g_cmd = "rm $TEMPDIR/compare_program_file_count.txt"
      RUN g_cmd

      #找出客製區程式
      CALL g_custom.clear()
      CALL program_list(g_topcust,"cust","4gl")

      #找出客製區畫面檔
      CALL g_custom_f.clear()
      CALL program_list(g_topcust,"cust","4fd")

      CALL cl_progress_bar(g_custom.getLength()+g_custom_f.getLength())
      CALL cust_compare(g_custom)
      CALL cust_compare(g_custom_f)
      IF mi_current < mi_total_count THEN
         CALL cl_close_progress_bar()
      END IF
      MESSAGE "Report Creating..."
      CALL program_compare_output()
      MESSAGE ""
   ELSE
      LET INT_FLAG = FALSE
      CLOSE WINDOW compare_program_w
      EXIT PROGRAM
   END IF

   WHILE TRUE
      CASE g_action
         WHEN "compare"
            CALL compare_display_array()
         WHEN "current"
            CALL current_display_array()
         WHEN "standard"
            CALL standard_display_array()
         WHEN "custom"
            CALL custom_display_array()
         WHEN "cmp_prog"
            CALL compare_display_array()
         WHEN "cmp_form"
            CALL compare_form_display_array()
         WHEN "curr_prog"
            CALL current_display_array()
         WHEN "curr_form"
            CALL current_form_display_array()
         WHEN "std_prog"
            CALL standard_display_array()
         WHEN "std_form"
            CALL standard_form_display_array()
         WHEN "cust_prog"
            CALL custom_display_array()
         WHEN "cust_form"
            CALL custom_form_display_array()
         WHEN "output"
            LET ls_cmd = "$FGLRUN $AZZ/42r/p_view.42r ",g_logpath,"compare_program.txt 66"
            RUN ls_cmd
            LET g_action = NULL
         OTHERWISE
            CALL compare_display_array()
      END CASE

      IF g_action = "exit" OR g_action = "restart" THEN
         LET INT_FLAG = FALSE
         EXIT WHILE
      END IF
   END WHILE
      IF g_action = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE

   CLOSE WINDOW compare_program_w
END MAIN

FUNCTION program_list(ps_path,ps_list,ps_subname)
   DEFINE   ps_path    STRING
   DEFINE   ps_list    STRING
   DEFINE   ps_subname STRING
   DEFINE   ls_str     STRING
   DEFINE   ls_child   STRING
   DEFINE   li_i       INTEGER

   IF NOT os.Path.exists(ps_path) THEN
      RETURN
   END IF
   LET ls_str = ".",ps_subname
   IF NOT os.Path.isdirectory(ps_path) AND ps_path.subString(ps_path.getLength()-3,ps_path.getLength()) = ls_str THEN
      CASE ps_subname
         WHEN "4gl"
            CASE ps_list
               WHEN "cur"
                  LET g_cur_list[g_cur_list.getLength()+1] = ps_path
               WHEN "std"
                  LET g_std_list[g_std_list.getLength()+1] = ps_path
               WHEN "cust"
                  LET g_custom[g_custom.getLength()+1].cust_path = ps_path
            END CASE
         WHEN "4fd"
            CASE ps_list
               WHEN "cur"
                  LET g_cur_list_f[g_cur_list_f.getLength()+1] = ps_path
               WHEN "std"
                  LET g_std_list_f[g_std_list_f.getLength()+1] = ps_path
               WHEN "cust"
                  LET g_custom_f[g_custom_f.getLength()+1].cust_path = ps_path
            END CASE
      END CASE
      RETURN
   END IF
   CALL os.Path.dirsort("name", 1)
   LET li_i = os.Path.diropen(ps_path)
   WHILE li_i > 0
      LET ls_child = os.Path.dirnext(li_i)
      IF ls_child IS NULL THEN
         EXIT WHILE
      END IF
      IF ls_child = "." OR ls_child = ".." THEN
         CONTINUE WHILE
      END IF
      CASE
         WHEN #li_i = 1 AND 
              (ls_child = "lib" OR ls_child = "sub" OR ls_child = "qry" OR
               ls_child.subString(1,1) = "a" OR ls_child.subString(1,1) = "g" OR
               ls_child.subString(1,1) = "c")
            CALL program_list( os.Path.join( ps_path, ls_child ) ,ps_list,ps_subname)
         WHEN li_i >= 1 AND (ls_child = ps_subname)
            CALL program_list( os.Path.join( ps_path, ls_child ) ,ps_list,ps_subname)
         WHEN li_i != 1 AND (ls_child.getIndexOf(ls_str,1))
            CALL program_list( os.Path.join( ps_path, ls_child ) ,ps_list,ps_subname)
      END CASE
   END WHILE
   CALL os.Path.dirclose(li_i)
END FUNCTION

FUNCTION program_compare()
   DEFINE   li_i              INTEGER
   DEFINE   li_j              INTEGER
   DEFINE   ls_prog_cmp       STRING
   DEFINE   ls_cmd            STRING
   DEFINE   li_cnt            SMALLINT
   DEFINE   li_cmp_cnt        INTEGER
   DEFINE   li_compare        SMALLINT

   CALL cl_progress_bar(g_std_list.getLength()+g_std_list_f.getLength())
   FOR li_i = 1 TO g_std_list.getLength()
       LET ls_prog_cmp = g_std_list[li_i].subString(g_std_list[li_i].getIndexOf(g_std_dir,1)+g_std_dir.getLength(),g_std_list[li_i].getLength())
       FOR li_j = 1 TO g_current.getLength()
           IF g_current[li_j].equals(g_cur_dir||ls_prog_cmp) THEN
              CASE
                 WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
                    LET ls_cmd = "diff ",g_std_list[li_i]," ",g_current[li_j]," > /dev/null 2>&1"
                 OTHERWISE
                    LET ls_cmd = "diff -q ",g_std_list[li_i]," ",g_current[li_j]," > /dev/null 2>&1"
              END CASE
              RUN ls_cmd RETURNING li_cnt
              IF li_cnt THEN
                 LET li_cmp_cnt = li_cmp_cnt + 1
                 LET g_compare[li_cmp_cnt].cmp_path = ls_prog_cmp
                 #將差異內容放入table中
                 CALL program_difference(g_std_list[li_i],g_current[li_j],li_cmp_cnt)
              END IF
              CALL g_current.deleteElement(li_j)
              LET li_compare = TRUE
              EXIT FOR
           END IF
       END FOR
       IF li_compare THEN
          LET li_compare = FALSE
       ELSE
          LET g_standard[g_standard.getLength()+1]=g_std_list[li_i]
       END IF
       CALL cl_progressing("Standard Compare...")
   END FOR
   LET li_cmp_cnt = 0
   FOR li_i = 1 TO g_std_list_f.getLength()
       LET ls_prog_cmp = g_std_list_f[li_i].subString(g_std_list_f[li_i].getIndexOf(g_std_dir,1)+g_std_dir.getLength(),g_std_list_f[li_i].getLength())
       FOR li_j = 1 TO g_current_f.getLength()
           IF g_current_f[li_j].equals(g_cur_dir||ls_prog_cmp) THEN
              CASE
                 WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
                    LET ls_cmd = "diff ",g_std_list_f[li_i]," ",g_current_f[li_j]," > /dev/null 2>&1"
                 OTHERWISE
                    LET ls_cmd = "diff -q ",g_std_list_f[li_i]," ",g_current_f[li_j]," > /dev/null 2>&1"
              END CASE
              RUN ls_cmd RETURNING li_cnt
              IF li_cnt THEN
                 LET li_cmp_cnt = li_cmp_cnt + 1
                 LET g_compare_f[li_cmp_cnt].cmp_path = ls_prog_cmp
                 #將差異內容放入table中
                 CALL form_difference(g_std_list_f[li_i],g_current_f[li_j],li_cmp_cnt)
              END IF
              CALL g_current_f.deleteElement(li_j)
              LET li_compare = TRUE
              EXIT FOR
           END IF
       END FOR
       IF li_compare THEN
          LET li_compare = FALSE
       ELSE
          LET g_standard_f[g_standard_f.getLength()+1]=g_std_list_f[li_i]
       END IF
       CALL cl_progressing("Standard Compare...")
   END FOR
   IF mi_current < mi_total_count THEN
      CALL cl_close_progress_bar()
   END IF
END FUNCTION

FUNCTION program_difference(ps_std_path,ps_cur_path,pi_cmpcnt)
   DEFINE   ps_std_path   STRING
   DEFINE   ps_cur_path   STRING
   DEFINE   pi_cmpcnt     INTEGER
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_std_ver    STRING
   DEFINE   ls_cur_ver    STRING
   DEFINE   ls_cmd        STRING
   DEFINE   ls_str        STRING
   DEFINE   li_prog_line  SMALLINT

   #取Standard Program的Version字串
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_std_path,"r")
   WHILE lc_channel.read(ls_std_ver)
      IF ls_std_ver.getIndexOf("Version",1) OR ls_std_ver.getIndexOf("version",1) THEN
         LET ls_std_ver = ls_std_ver.subString(ls_std_ver.getIndexOf("'",1)+1,ls_std_ver.getLength())
         LET ls_std_ver = ls_std_ver.subString(1,ls_std_ver.getIndexOf("'",1)-1)
         EXIT WHILE
      END IF
   END WHILE
   CALL lc_channel.close()

   #取Current Program的Version字串
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_cur_path,"r")
   WHILE lc_channel.read(ls_cur_ver)
      IF ls_cur_ver.getIndexOf("Version",1) OR ls_cur_ver.getIndexOf("version",1) THEN
         LET ls_cur_ver = ls_cur_ver.subString(ls_cur_ver.getIndexOf("'",1)+1,ls_cur_ver.getLength())
         LET ls_cur_ver = ls_cur_ver.subString(1,ls_cur_ver.getIndexOf("'",1)-1)
         EXIT WHILE
      END IF
   END WHILE
   CALL lc_channel.close()

   #比對兩者的Version
   IF ls_std_ver != ls_cur_ver OR ls_std_ver IS NULL OR ls_cur_ver IS NULL THEN
      LET g_compare[pi_cmpcnt].cur_ver = ls_cur_ver
      LET g_compare[pi_cmpcnt].std_ver = ls_std_ver
   END IF

   #得到程式差異量, current比對standard以後的差異量
   CASE
      WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
         LET ls_cmd = "diff -be ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                      "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
      OTHERWISE
         LET ls_cmd = "diff -bEBe ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                      "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
   END CASE
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   IF lc_channel.read(ls_str) THEN
      LET g_compare[pi_cmpcnt].dif_qty = ls_str
   END IF
   CALL lc_channel.close()

   #得到程式差異比例
   LET ls_cmd = "wc -l ",ps_cur_path,"|awk '{print $1}'"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   IF lc_channel.read(ls_str) THEN
      LET li_prog_line = ls_str
      LET g_compare[pi_cmpcnt].dif_rate = g_compare[pi_cmpcnt].dif_qty / li_prog_line * 100
   END IF
   CALL lc_channel.close()
END FUNCTION

FUNCTION form_difference(ps_std_path,ps_cur_path,pi_cmpcnt)
   DEFINE   ps_std_path   STRING
   DEFINE   ps_cur_path   STRING
   DEFINE   pi_cmpcnt     INTEGER
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_std_ver    STRING
   DEFINE   ls_cur_ver    STRING
   DEFINE   ls_cmd        STRING
   DEFINE   ls_str        STRING
   DEFINE   li_prog_line  SMALLINT


   #得到程式差異量, current比對standard以後的差異量
   CASE
      WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
         LET ls_cmd = "diff -be ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                      "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
      OTHERWISE
         LET ls_cmd = "diff -bEBe ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                      "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
   END CASE
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   IF lc_channel.read(ls_str) THEN
      LET g_compare_f[pi_cmpcnt].dif_qty = ls_str
   END IF
   CALL lc_channel.close()

   #得到程式差異比例
   LET ls_cmd = "wc -l ",ps_cur_path,"|awk '{print $1}'"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   IF lc_channel.read(ls_str) THEN
      LET li_prog_line = ls_str
      LET g_compare_f[pi_cmpcnt].dif_rate = g_compare_f[pi_cmpcnt].dif_qty / li_prog_line * 100
   END IF
   CALL lc_channel.close()
END FUNCTION

FUNCTION program_compare_view(ps_std_path,ps_cur_path)
   DEFINE   ps_std_path  STRING
   DEFINE   ps_cur_path  STRING
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_diff_str  STRING


   IF NOT os.Path.exists(ps_std_path) OR NOT os.Path.exists(ps_cur_path) THEN
      RETURN
   END IF
   OPEN WINDOW program_compare_view WITH FORM "compare_program_viewer"
      ATTRIBUTE (STYLE="viewer")

   DISPLAY ps_std_path TO formonly.std_path
   DISPLAY ps_cur_path TO formonly.cur_path
   CASE
      WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
         LET ls_cmd = "diff -b ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt"
      OTHERWISE
         LET ls_cmd = "diff -bEB ",ps_std_path," ",ps_cur_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt"
   END CASE
   RUN ls_cmd
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(FGL_GETENV("TEMPDIR")||"/diff_prog.txt","r")
   WHILE lc_channel.read(ls_result)
      LET ls_diff_str = ls_diff_str,"\n",ls_result
   END WHILE
   DISPLAY ls_diff_str TO formonly.show_diff
   MENU ""
      ON ACTION exit
         EXIT MENU
   END MENU

   CLOSE WINDOW program_compare_view
END FUNCTION

FUNCTION cust_compare(ps_custom)
   DEFINE   ps_custom    DYNAMIC ARRAY OF RECORD
               cust_path STRING,
               curr_path STRING,
               cust_dif  SMALLINT,
               dif_rate  DEC(10,5)
                         END RECORD
   DEFINE   li_i           SMALLINT
   DEFINE   ls_cust_prog   STRING
   DEFINE   ls_pack_prog   STRING
   DEFINE   ls_cust_module STRING
   DEFINE   ls_pack_module STRING
   DEFINE   ls_cust_middle STRING
   DEFINE   ls_cmd         STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   ls_str         STRING
   DEFINE   li_prog_line   SMALLINT

   FOR li_i = 1 TO ps_custom.getLength()
       LET ls_cust_prog = os.Path.basename(ps_custom[li_i].cust_path)
       IF ps_custom[li_i].cust_path.getIndexOf(g_topcust,1) = 1 THEN
          LET ls_cust_middle = ps_custom[li_i].cust_path.subString(1+g_topcust.getLength()+1,ps_custom[li_i].cust_path.getLength())
          LET ls_cust_module = ls_cust_middle.subString(1,ls_cust_middle.getIndexOf("/",1)-1)
          LET ls_cust_middle = ls_cust_middle.subString(1+ls_cust_module.getLength(),ls_cust_middle.getIndexOf(ls_cust_prog,1)-1)
       END IF
       CASE
          # ls_cust_module = clib, csub, cqry, cggl, cgpy...
          WHEN ls_cust_module.getLength() = 4 AND ls_cust_module.subString(1,1) = "c"
             LET ls_pack_module = ls_cust_module.subString(2,4)
          # ls_cust_module = coo, czz, cpm....
          WHEN ls_cust_module.getLength() = 3 AND ls_cust_module.subString(1,1) = "c"
             LET ls_pack_module = "a", ls_cust_module.subString(2,3)
          # ls_cust_module = other...
          OTHERWISE
             LET ls_pack_module = "a", ls_cust_module.subString(2,3)
       END CASE
       CASE
          WHEN ls_cust_prog.subString(1,3)="cl_" OR ls_cust_prog.subString(1,2)="s_" OR
               ls_cust_prog.subString(1,2)="q_" OR ls_cust_prog.subString(1,2)="p_" OR
               ls_cust_prog.subString(1,2)="sa" OR ls_cust_prog.subString(1,2)="sg" OR
               ls_cust_prog.subString(1,1)="a" 
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, ls_cust_prog
          WHEN ls_cust_prog.subString(1,4)="ccl_" OR ls_cust_prog.subString(1,3)="cs_" OR
               ls_cust_prog.subString(1,3)="cq_" OR ls_cust_prog.subString(1,3)="cp_"
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, ls_cust_prog.subString(2,ls_cust_prog.getLength())
          WHEN ls_cust_prog.subString(1,1)="c"
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, "a", ls_cust_prog.subString(2,ls_cust_prog.getLength())
          WHEN ls_cust_prog.subString(1,2)="sc" AND ls_pack_module.getLength() = 3
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, "sa", ls_cust_prog.subString(3,ls_cust_prog.getLength())
          WHEN ls_cust_prog.subString(1,2)="sc" AND ls_pack_module.getLength() = 4
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, "s", ls_pack_module, ls_cust_prog.subString(ls_cust_prog.getIndexOf(ls_pack_module,1)+ls_pack_module.getLength(),ls_cust_prog.getLength())
          OTHERWISE
             LET ls_pack_prog = g_tiptop, "/", ls_pack_module, ls_cust_middle, ls_cust_prog
       END CASE
       IF os.Path.exists(ls_pack_prog) THEN
          LET ps_custom[li_i].curr_path = ls_pack_prog

          #得到程式差異量, current比對standard以後的差異量
          CASE
             WHEN g_os_type MATCHES "AIX*" OR g_os_type MATCHES "SUN*"
                LET ls_cmd = "diff -be ",ps_custom[li_i].curr_path," ",ps_custom[li_i].cust_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                             "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
             OTHERWISE
                LET ls_cmd = "diff -bEBe ",ps_custom[li_i].curr_path," ",ps_custom[li_i].cust_path," > ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt;",
                             "wc -l ",FGL_GETENV("TEMPDIR"),"/diff_prog.txt|awk '{print $1}'"
          END CASE
          LET lc_channel = base.Channel.create()
          CALL lc_channel.openPipe(ls_cmd,"r")
          IF lc_channel.read(ls_str) THEN
             LET ps_custom[li_i].cust_dif = ls_str
          END IF
          CALL lc_channel.close()

          #得到差異量比例
          LET ls_cmd = "wc -l ",ps_custom[li_i].cust_path,"|awk '{print $1}'"
          LET lc_channel = base.Channel.create()
          CALL lc_channel.openPipe(ls_cmd,"r")
          IF lc_channel.read(ls_str) THEN
             LET li_prog_line = ls_str
             LET ps_custom[li_i].dif_rate = ps_custom[li_i].cust_dif / li_prog_line * 100
          END IF
          CALL lc_channel.close()
       END IF
       CALL cl_progressing("Custom Check...")
   END FOR
END FUNCTION

FUNCTION compare_display_array()
   DISPLAY g_compare.getLength() TO formonly.cmp_cnt
      DISPLAY ARRAY g_compare TO s_compare.*
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION accept
         LET g_cmp_cnt = ARR_CURR()
         CALL program_compare_view(g_std_dir||g_compare[g_cmp_cnt].cmp_path,g_cur_dir||g_compare[g_cmp_cnt].cmp_path)
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION current_display_array()
   DISPLAY g_current.getLength() TO formonly.dif_cur_cnt
   DISPLAY ARRAY g_current TO s_current.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION standard_display_array()
   DISPLAY g_standard.getLength() TO formonly.dif_std_cnt
   DISPLAY ARRAY g_standard TO s_standard.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION custom_display_array()
   DISPLAY g_custom.getLength() TO formonly.cust_cnt
   DISPLAY ARRAY g_custom TO s_custom.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION accept
         CALL program_compare_view(g_custom[ARR_CURR()].cust_path,g_custom[ARR_CURR()].curr_path)
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION compare_form_display_array()
   DISPLAY g_compare_f.getLength() TO formonly.cmp_cnt_f
      DISPLAY ARRAY g_compare_f TO s_compare_f.*
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION accept
         LET g_cmp_cnt = ARR_CURR()
         CALL program_compare_view(g_std_dir||g_compare_f[g_cmp_cnt].cmp_path,g_cur_dir||g_compare_f[g_cmp_cnt].cmp_path)
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION current_form_display_array()
   DISPLAY g_current_f.getLength() TO formonly.dif_cur_cnt_f
   DISPLAY ARRAY g_current_f TO s_current_f.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION standard_form_display_array()
   DISPLAY g_standard_f.getLength() TO formonly.dif_std_cnt_f
   DISPLAY ARRAY g_standard_f TO s_standard_f.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION custom_form_display_array()
   DISPLAY g_custom_f.getLength() TO formonly.cust_cnt_f
   DISPLAY ARRAY g_custom_f TO s_custom_f.* ATTRIBUTE(UNBUFFERED)
      ON ACTION output
         LET g_action = "output"
         EXIT DISPLAY
      ON ACTION compare
         LET g_action = "compare"
         EXIT DISPLAY
      ON ACTION current
         LET g_action = "current"
         EXIT DISPLAY
      ON ACTION standard
         LET g_action = "standard"
         EXIT DISPLAY
      ON ACTION custom
         LET g_action = "custom"
         EXIT DISPLAY
      ON ACTION cmp_prog
         LET g_action = "cmp_prog"
         EXIT DISPLAY
      ON ACTION cmp_form
         LET g_action = "cmp_form"
         EXIT DISPLAY
      ON ACTION curr_prog
         LET g_action = "curr_prog"
         EXIT DISPLAY
      ON ACTION curr_form
         LET g_action = "curr_form"
         EXIT DISPLAY
      ON ACTION std_prog
         LET g_action = "std_prog"
         EXIT DISPLAY
      ON ACTION std_form
         LET g_action = "std_form"
         EXIT DISPLAY
      ON ACTION cust_prog
         LET g_action = "cust_prog"
         EXIT DISPLAY
      ON ACTION cust_form
         LET g_action = "cust_form"
         EXIT DISPLAY
      ON ACTION accept
         CALL program_compare_view(g_custom_f[ARR_CURR()].cust_path,g_custom_f[ARR_CURR()].curr_path)
      ON ACTION restart
         LET g_action = "restart"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION program_compare_output()
   DEFINE   ls_name      STRING
   DEFINE   ls_cmd       STRING
   DEFINE   li_i         INTEGER
   DEFINE   sr           RECORD      #差異程式列表
               cmp_path  STRING,
               cur_ver   STRING,
               std_ver   STRING,
               dif_qty   SMALLINT,
               dif_rate  DEC(10,5)
                         END RECORD
   DEFINE   ls_path      STRING

   LET ls_name = g_logpath,"compare_program.txt"
   START REPORT program_compare_rep TO ls_name

   FOR li_i = 1 TO g_compare.getLength()
       LET sr.* = g_compare[li_i].*
       OUTPUT TO REPORT program_compare_rep(sr.*,"1")
   END FOR

   FOR li_i = 1 TO g_compare_f.getLength()
       INITIALIZE sr.* TO NULL
       LET sr.cmp_path = g_compare_f[li_i].cmp_path
       LET sr.dif_qty  = g_compare_f[li_i].dif_qty
       LET sr.dif_rate = g_compare_f[li_i].dif_rate
       OUTPUT TO REPORT program_compare_rep(sr.*,"2")
   END FOR

   INITIALIZE sr.* TO NULL
   IF g_current.getLength() > g_current_f.getLength() THEN
      FOR li_i = 1 TO g_current.getLength()
          INITIALIZE sr.* TO NULL
          LET sr.cur_ver = g_current[li_i]
          IF li_i <= g_current_f.getLength() THEN
             LET sr.std_ver = g_current_f[li_i]
          END IF
          OUTPUT TO REPORT program_compare_rep(sr.*,"3")
      END FOR
   ELSE
      FOR li_i = 1 TO g_current_f.getLength()
          INITIALIZE sr.* TO NULL
          IF li_i <= g_current.getLength() THEN
             LET sr.cur_ver = g_current[li_i]
          END IF
          LET sr.std_ver = g_current_f[li_i]
          OUTPUT TO REPORT program_compare_rep(sr.*,"3")
      END FOR
   END IF

   IF g_standard.getLength() > g_standard_f.getLength() THEN
      FOR li_i = 1 TO g_standard.getLength()
          INITIALIZE sr.* TO NULL
          LET sr.cur_ver = g_standard[li_i]
          IF li_i <= g_standard_f.getLength() THEN
             LET sr.std_ver = g_standard_f[li_i]
          END IF
          OUTPUT TO REPORT program_compare_rep(sr.*,"4")
      END FOR
   ELSE
      FOR li_i = 1 TO g_standard_f.getLength()
          INITIALIZE sr.* TO NULL
          IF li_i <= g_standard.getLength() THEN
             LET sr.cur_ver = g_standard[li_i]
          END IF
          LET sr.std_ver = g_standard_f[li_i]
          OUTPUT TO REPORT program_compare_rep(sr.*,"4")
      END FOR
   END IF

   FOR li_i = 1 TO g_custom.getLength()
       INITIALIZE sr.* TO NULL
       LET sr.cur_ver = g_custom[li_i].cust_path
       LET sr.std_ver = g_custom[li_i].curr_path
       LET sr.dif_qty = g_custom[li_i].cust_dif
       LET sr.dif_rate = g_custom[li_i].dif_rate
       OUTPUT TO REPORT program_compare_rep(sr.*,"5")
   END FOR

   FOR li_i = 1 TO g_custom_f.getLength()
       INITIALIZE sr.* TO NULL
       LET sr.cur_ver = g_custom_f[li_i].cust_path
       LET sr.std_ver = g_custom_f[li_i].curr_path
       LET sr.dif_qty = g_custom_f[li_i].cust_dif
       LET sr.dif_rate = g_custom_f[li_i].dif_rate
       OUTPUT TO REPORT program_compare_rep(sr.*,"5")
   END FOR

   FINISH REPORT program_compare_rep
#  LET ls_path = program_compare_browse()
#  IF cl_download_file(FGL_GETENV("TEMPDIR")||"/"||ls_name,ls_path||"/"||ls_name) THEN
#     MESSAGE "Result report download successfully..."
#  ELSE
#     MESSAGE "Result report download fail..."
#  END IF
END FUNCTION

REPORT program_compare_rep(sr,ps_work)
   DEFINE   sr           RECORD
               cmp_path  STRING,
               cur_ver   STRING,
               std_ver   STRING,
               dif_qty   SMALLINT,
               dif_rate  DEC(10,5)
                         END RECORD
   DEFINE   ps_work      CHAR(1)
   DEFINE   li_last_flag SMALLINT
   DEFINE   li_rate      DEC(5,2)
   DEFINE   li_skipline  SMALLINT

   OUTPUT
      TOP MARGIN 1
      LEFT MARGIN 5
      BOTTOM MARGIN 5
      PAGE LENGTH 66

   FORMAT
      PAGE HEADER
         IF ps_work = "1" THEN
            LET li_rate = (g_compare.getLength()/g_std_list.getLength())
            PRINT COLUMN 30,"程式比對結果"
            PRINT "標準區總程式量 : ",g_std_list.getLength()
            PRINT "比對區總程式量 : ",g_cur_list.getLength()
            PRINT "差異比 (差異程式量/標準區總程式量) : ",li_rate*100," %"
            PRINT ""
            PRINT "程式路徑",COLUMN 32,"比對區版本",COLUMN 63,"標準區版本",COLUMN 94,"差異量",COLUMN 101,"差異比 (%)"
            PRINT "============================== ============================== ============================== ",
                  "====== ============"
         ELSE
            IF ps_work = "2" THEN
            LET li_rate = (g_compare_f.getLength()/g_std_list_f.getLength())
               PRINT COLUMN 30,"畫面比對結果"
               PRINT "標準區總畫面量 : ",g_std_list_f.getLength()
               PRINT "比對區總畫面量 : ",g_cur_list_f.getLength()
               PRINT "差異比 (差異畫面量/標準區總畫面量) : ",li_rate*100," %"
               PRINT ""
               PRINT "畫面路徑",COLUMN 22,"差異量",COLUMN 29,"差異比 (%)"
               PRINT "==================== ====== ============"
            ELSE
               IF ps_work = "3" THEN
                  PRINT COLUMN 30,"只存在比對區標準目錄內的檔案列表"
                  PRINT "比對區程式量 : ",g_current.getLength()
                  PRINT "比對區畫面量 : ",g_current_f.getLength()
                  PRINT ""
                  PRINT ""
                  PRINT "程式",COLUMN 52,"畫面"
                  PRINT "================================================== ",
                        "=================================================="
               ELSE
                  IF ps_work = "4" THEN
                     PRINT COLUMN 30,"只存在標準區標準目錄內的檔案列表"
                     PRINT "標準區程式量 : ",g_standard.getLength()
                     PRINT "標準區畫面量 : ",g_standard_f.getLength()
                     PRINT ""
                     PRINT ""
                     PRINT "程式",COLUMN 52,"畫面"
                     PRINT "================================================== ",
                           "=================================================="
                  ELSE
                     IF ps_work = "5" THEN
                        PRINT COLUMN 30,"比對區客製目錄下的檔案列表"
                        PRINT "客製程式量 : ",g_custom.getLength()
                        PRINT "客製畫面量 : ",g_custom_f.getLength()
                        LET li_rate = g_custom.getLength() / g_pkg_prog_cnt
                        PRINT "客製程式比 (比對區客製量/比對區總程式量) : ",li_rate*100," %     ";
                        LET li_rate = g_custom_f.getLength() / g_pkg_form_cnt
                        PRINT "畫面比 : ",li_rate*100," %"
                        PRINT ""
                        PRINT "檔案路徑",COLUMN 52,"推測對應標準程式路徑",COLUMN 103,"客製量",COLUMN 110,"客製比 (%)"
                        PRINT "================================================== ",
                              "================================================== ",
                              "====== ============"
                     ELSE
                        SKIP 7 LINE
                     END IF
                  END IF
               END IF
            END IF
         END IF

      BEFORE GROUP OF ps_work
         IF ps_work >= "2" THEN
            SKIP TO TOP OF PAGE
         END IF

      ON EVERY ROW
         CASE 
            WHEN ps_work = "1"
               PRINT sr.cmp_path,
                     COLUMN 32,sr.cur_ver,
                     COLUMN 63,sr.std_ver,
                     COLUMN 94,sr.dif_qty,
                     COLUMN 101,sr.dif_rate
            WHEN ps_work = "2"
               PRINT sr.cmp_path,
                     COLUMN 22,sr.dif_qty,
                     COLUMN 29,sr.dif_rate
            WHEN ps_work = "3" OR ps_work = "4"
               PRINT sr.cur_ver,
                     COLUMN 52,sr.std_ver
            WHEN ps_work = "5"
               IF NOT li_skipline THEN
                  IF sr.cur_ver.getIndexOf(".4fd",1) > 0 THEN
                     SKIP 3 LINE
                     LET li_skipline = TRUE
                  END IF
               END IF
               PRINT sr.cur_ver,
                     COLUMN 52,sr.std_ver,
                     COLUMN 103,sr.dif_qty,
                     COLUMN 109,sr.dif_rate
         END CASE

      AFTER GROUP OF ps_work
         CASE
            WHEN ps_work = "1"
               PRINT "============================== ============================== ============================== ",
                     "====== ============"
               LET li_last_flag = TRUE
               PRINT ""
               PRINT "程式總差異量 : ",g_compare.getLength()
            WHEN ps_work = "2"
               PRINT "==================== ====== ============"
               LET li_last_flag = TRUE
               PRINT ""
               PRINT "畫面總差異量 : ",g_compare_f.getLength()
            WHEN ps_work = "3" OR ps_work = "4"
               PRINT "================================================== ",
                     "=================================================="
               LET li_last_flag = TRUE
            WHEN ps_work = "5"
               PRINT "================================================== ",
                     "================================================== ",
                     "====== ============"
               LET li_last_flag = TRUE
         END CASE

      PAGE TRAILER
         IF NOT li_last_flag THEN
            IF ps_work = "1" THEN
               PRINT "============================== ============================== ============================== ",
                     "====== ============"
            ELSE
               IF ps_work = "2" THEN
                  PRINT "==================== ====== ============"
               ELSE
                  IF ps_work = "3" OR ps_work = "4" THEN
                     PRINT "================================================== ",
                           "=================================================="
                  ELSE
                     IF ps_work = "5" THEN         
                        PRINT "================================================== ",
                              "================================================== ",
                              "====== ============"
                     ELSE
                        SKIP 1 LINE                   
                     ENd IF
                  END IF                           
               END IF
            END IF
         ELSE
            SKIP 1 LINE
            LET li_last_flag = FALSE
         END IF
END REPORT




#Progress Bar
FUNCTION cl_progress_bar(pi_total_count)
  DEFINE pi_total_count  INTEGER

  LET mi_total_count = pi_total_count
  LET mi_current = 0

  OPEN WINDOW w_progbar WITH FORM "lib/42f/cl_progress_bar"
                        ATTRIBUTE(STYLE="progress_bar", TEXT="PROGRESSING")
END FUNCTION

FUNCTION cl_progressing(ps_log)
  DEFINE ps_log STRING
  DEFINE li_progbar,li_percent   INTEGER

  LET mi_current = mi_current + 1
  LET li_percent = mi_current * 100 / mi_total_count
  LET li_progbar = li_percent

  DISPLAY ps_log,li_progbar,mi_current,mi_total_count,li_percent
       TO proc,progbar,curr,total,p

  CALL ui.Interface.refresh()

  IF (mi_current = mi_total_count) THEN
     CALL cl_close_progress_bar()
  END IF
END FUNCTION

FUNCTION cl_close_progress_bar()
   CLOSE WINDOW w_progbar
END FUNCTION

FUNCTION cl_download_file(ps_source, ps_target)
   DEFINE ps_source    STRING,
          ps_target    STRING
   DEFINE ls_command   STRING
   DEFINE li_status    INTEGER
   DEFINE lch_ch       base.Channel

   IF ps_source IS NULL OR ps_target IS NULL THEN
      RETURN FALSE
   END IF

   IF ps_source.getIndexOf("$", 1) THEN
      LET lch_ch = base.Channel.create()
      CALL lch_ch.openPipe("echo \"" || ps_source CLIPPED || "\"", "r")
      WHILE lch_ch.read(ps_source)
      END WHILE
      CALL lch_ch.close()
   END IF

   CALL FGL_PUTFILE(ps_source, ps_target)
   IF STATUS THEN
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
