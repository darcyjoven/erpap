# Prog. Version..: '5.10.00-07.05.10(00000)'     #
#
# Pattern name...: GPRebuild.4gl
# Descriptions...: TIPTOP GP 5.2 圖形化系統重建工具 (與5.1不同: 安全機制/使用GRW)
# Date & Author..: 07/03/29 Create by alex
# Modify.........: No.FUN-830038 08/03/11 By alex 修整為可令 UNIX執行
# Modify.........: No.FUN-830011 08/03/18 By alex 修改 r.l2依zz08解析
# Modify.........: No.FUN-830011 09/04/16 By alex 調整輸入介面
# Modify.........: No.FUN-A50097 10/05/19 By alex 調整簡易平行處理作法
# Modify.........: No.FUN-B50012 11/05/25 By jrg542 加入背景執行
# Modify.........: No.FUN-B60042 11/06/07 By jrg542 #修正安全機制路徑
# Modify.........: No.FUN-BA0031 11/10/06 By Hiko #調整訊息的呈現方式
# Modify.........: No.FUN-C60110 12/06/25 By laura 執行編譯ds.sch檢核並產生;By madey:1.view log改呼叫GPRebuild-view.4gl 2.zz08多筆相同時僅編譯一次
# Modify.........: No.FUN-CB0060 12/11/14 By zack  確定lib、sub、qry 要先產生42x 
# Modify.........: No.FUN-CC0114 12/12/26 By zack  rebuiild+的win title調整 
# Modify.........: No.FUN-CC0152 12/12/28 By zack  增加Rebuild tool 功能  

IMPORT os
DATABASE ds

   DEFINE g_toppath       STRING          #TOP directory
   DEFINE g_custpath      STRING               #CUST directory
   DEFINE g_dummy03       LIKE type_file.chr1  #Rebuilding Area  : Standard Cust 42X Both 編譯類別
   DEFINE g_du04_s        LIKE type_file.chr1  #r.s2 ds
   DEFINE g_du04_t        LIKE type_file.chr1  #rebuild_tool
   DEFINE g_du04_c        LIKE type_file.chr1  #r.c2
   DEFINE g_du04_l        LIKE type_file.chr1  #r.l2
   DEFINE g_du04_f        LIKE type_file.chr1  #r.f2            
   DEFINE g_dummy04_cnt   LIKE type_file.num10
   DEFINE g_dummy05       STRING          #Rebuilding Subsystems (Follow Area)
   DEFINE g_dummy05_o     STRING          
   DEFINE g_bgjob         LIKE type_file.chr1
   DEFINE g_remove        LIKE type_file.chr1
   DEFINE g_sendmail      LIKE type_file.chr1
   DEFINE g_logfilepath   STRING          #Log Directory
   DEFINE g_cmd           STRING
   DEFINE g_select        DYNAMIC ARRAY of RECORD    #右邊可選擇模組
             gao01_s         LIKE type_file.chr10
                          END RECORD
   DEFINE g_disable       DYNAMIC ARRAY of RECORD    #左邊可選擇模組           
             gao01_d        LIKE type_file.chr10
                          END RECORD
   DEFINE g_background    LIKE type_file.num10
   DEFINE g_guimode       LIKE type_file.num10
   DEFINE g_jobnow        LIKE type_file.chr1
   DEFINE g_message       DYNAMIC ARRAY OF STRING
   DEFINE g_progs01       LIKE type_file.num10         #Current Program Step Count
   DEFINE g_progs02       LIKE type_file.num10         #Current Module Step Count
   DEFINE g_workcnt       LIKE type_file.num10
   DEFINE gt_start,gt_end DATETIME HOUR TO SECOND
   DEFINE g_today         STRING #FUN-BA0031 by Hiko:避免程式執行到跨日,而導致hjr07塞入不同日期的資料
   DEFINE g_processor     LIKE type_file.num5
   DEFINE g_ver           LIKE type_file.num5
   DEFINE g_42m           LIKE type_file.chr5
   DEFINE g_hjr01         LIKE hjr_file.hjr01   #建置ID 
   DEFINE g_db_type       LIKE type_file.chr3
   #Begin:FUN-BA0031 by Hiko
   DEFINE g_log_order  SMALLINT, #log檔名內相同的PID會因為多次執行編譯而產生多個log檔.
          g_errlist_ch base.Channel
   #End:FUN-BA0031 by Hiko

MAIN

   DEFINE ls_argval       STRING
   
   IF ARG_VAL(1) IS NULL THEN 
      CLOSE WINDOW SCREEN #FUN-B50012
      OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT
   END IF  

   WHENEVER ERROR CONTINUE
   CALL GPRebuild_init()       #系統環境變數初始化
  #LET l_arg1 = "TOP='/u53/top'AREA='T'ITEM='C'DIR='aoo'" "TP"    
  #LET l_arg2 = "TP"
  DISPLAY  "ARG_VAL(1):",ARG_VAL(1)
  DISPLAY  "ARG_VAL(2):",ARG_VAL(2)
   IF ARG_VAL(1) IS NULL THEN  #未輸入參數
      CALL GPRebuild_init_window()
      CALL GPRebuild_menu()
      CLOSE WINDOW w_GPRebuild
   ELSE  #當輸入參數後, 一律不再開window出來, 做為background
         #當只輸入" " "TP"就以預設值執行         
      IF ARG_VAL(2) = "TP" THEN
         LET g_guimode    = FALSE
         LET g_background = TRUE
         LET ls_argval = ARG_VAL(1)
         CALL GPRebuild_background_init(ls_argval) #拆解參數
         CALL GPRebuild_process()
      ELSE
         CALL GPRebuild_background_explain()
      END IF
   END IF

END MAIN

#未於啟動程式時，一併帶入參數，則開啟視窗讓user輸入參數
PRIVATE FUNCTION GPRebuild_init_window()
   DEFINE lw_win           ui.Window
   DEFINE ls_tmp           STRING

   LET g_guimode = TRUE 
   LET ls_tmp = "......"
   OPEN WINDOW w_GPRebuild WITH FORM "GPRebuild"
   LET lw_win = ui.Window.getCurrent()
  # CALL lw_win.setText(LSTR("TIPTOP GP5.2X(TM) Rebuild Tool version:2.01 (C)2009,2010")) #mark FUN-CC0114 
    CALL lw_win.setText(LSTR("TIPTOP GP Rebuild Tool version:2.01 (C)2009,2010")) #FUN-CC0114
   DISPLAY g_toppath,g_custpath,g_dummy03,g_du04_c,g_du04_l,g_du04_f,
           #g_bgjob,g_processor,g_remove,g_sendmail,g_logfilepath,ls_tmp,ls_tmp #FUN-BA0031 by Hiko:log檔名不顯現
           g_bgjob,g_processor,g_remove,g_sendmail,ls_tmp,ls_tmp,g_du04_t #FUN-CC0152 add g_du04_t
        TO FORMONLY.dummy01,FORMONLY.dummy02,FORMONLY.dummy03,
           FORMONLY.du04_c,FORMONLY.du04_l,FORMONLY.du04_f,
           #FORMONLY.bgjob,FORMONLY.processor,FORMONLY.remove,FORMONLY.sendmail,FORMONLY.dummy06,FORMONLY.dummy07,FORMONLY.dummy08 #FUN-BA0031 by Hiko:log檔名不顯現
           FORMONLY.bgjob,FORMONLY.processor,FORMONLY.remove,FORMONLY.sendmail,FORMONLY.dummy07,FORMONLY.dummy08,FORMONLY.du04_t #FUN-CC0152 add FORMONLY.du04_t

END FUNCTION


#系統環境變數初始化﹝由於本作業不引用
PRIVATE FUNCTION GPRebuild_init()

   DEFINE li_cnt     LIKE type_file.num10
   DEFINE lch_cmd    base.Channel 
   DEFINE l_str      STRING

   LET g_bgjob = "N"
   #LET g_dummy05 = " "

   #系統環境變數
   LET g_toppath = FGL_GETENV("TOP")
   LET g_custpath = FGL_GETENV("CUST")
   LET g_cmd = FGL_GETENV("FGLRUN")," ",os.Path.join(FGL_GETENV("DS4GL"),"bin")
   LET g_db_type = db_get_database_type()

   #LET g_dummy03 = "F"   #TIPTOP GP Full Area 全區目錄 #12/01/17 by jrg542 改預設值
   LET g_dummy03 = "T"    #TIPTOP GP Standard Area 標準目錄 

   CASE FGL_GETENV("TOPLINK")
      WHEN "Shipment"    LET g_ver = 1
      WHEN "Beta"        LET g_ver = 2
      WHEN "Development" LET g_ver = 3
      OTHERWISE          LET g_ver = 0
   END CASE

   IF g_ver > 0 THEN
      CASE DB_GET_DATABASE_TYPE()
         WHEN "MSV" LET g_42m = "42mm"
         WHEN "ASE" LET g_42m = "42ma"
         WHEN "DB2" LET g_42m = "42md"
         WHEN "IFX" LET g_42m = "42mi"
         WHEN "ORA" LET g_42m = "42m"
         OTHERWISE  LET g_42m = "42m"
      END CASE
   ELSE
      LET g_42m = "42m"
   END IF

   #執行項目設定
   LET g_du04_s = 0          #r.s2 ds
   LET g_du04_t = 0          #rebuild_tool
   LET g_du04_c = 1          #compile 4gl
   LET g_du04_l = 1          #link
   LET g_du04_f = 1          #compile 4fd
   LET g_dummy04_cnt = 3
   LET g_workcnt = 0
   CALL GPRebuild_btn05_init() #列出模組
   #報表
   #Begin:FUN-BA0031 by Hiko:因為錯誤log檔的檔名是在執行編譯時才給,所以這裡就不需要刪除,改在後面處理.
   #LET g_hjr01 = FGL_GETPID()
   #SELECT COUNT(*) INTO li_cnt FROM hjr_file WHERE hjr01 = g_hjr01
   #IF li_cnt > 0 THEN
   #   DELETE FROM hjr_file WHERE hjr01 = g_hjr01
   #END IF
   #LET g_logfilepath = os.Path.join(FGL_GETENV("TEMPDIR"),"GPRebuild_"|| g_hjr01 CLIPPED||".log")
   #End:FUN-BA0031 by Hiko

   LET g_remove = "N"
   LET g_sendmail = "N"

   LET lch_cmd = base.Channel.create()
   CALL lch_cmd.openPipe("fglWrt -a cpu", "r")
   IF lch_cmd.read(l_str) THEN
      LET g_processor = l_str
   END IF
   
   IF g_processor <= 0 THEN LET g_processor = 2 END IF
   IF g_processor > 16 THEN LET g_processor = 16 END IF
   #IF g_processor >= 16 THEN LET g_processor = 2 END IF
END FUNCTION



PRIVATE FUNCTION GPRebuild_menu()
   DEFINE ls_message      STRING
   DEFINE li_total        LIKE type_file.num5
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE l_ac_d,l_ac_s   LIKE type_file.num5
   DEFINE l_action        STRING
   DEFINE l_toppath_o     STRING               #TOP directory
   DEFINE l_custpath_o    STRING               #CUST directory
   DEFINE l_dummy03_o     LIKE type_file.chr1  #Rebuilding Area  Standard Cust Both
   DEFINE ls_top          STRING               #No.FUN-C60110
   DEFINE ls_str          STRING               #No.FUN-C60110
   DEFINE p_msg           STRING               #No.FUN-C60110

   LET l_toppath_o = g_toppath
   LET l_custpath_o = g_custpath
   LET l_dummy03_o = g_dummy03
    
   WHILE TRUE
   
   DIALOG ATTRIBUTE(UNBUFFERED,FIELD ORDER FORM)
      # dummy03:編譯類別 dummy01:toppath dummy02:custpath du04_c:Compile4gl du04_l:Link4gl du04_f:CompileForm
      INPUT g_dummy03,g_toppath,g_custpath,g_du04_c,g_du04_l,g_du04_f,
            #g_logfilepath,g_processor #FUN-BA0031 by Hiko:log檔名不顯現
            g_processor,g_du04_t #FUN-CC0152 add g_du04_t 
       FROM dummy03,dummy01,dummy02,du04_c,du04_l,du04_f,
            #dummy06,processor #FUN-BA0031 by Hiko:log檔名不顯現         
            processor,du04_t #FUN-CC0152 add du04_t          
       ATTRIBUTE(WITHOUT DEFAULTS = TRUE)
         AFTER FIELD dummy01
            IF l_toppath_o <> g_toppath AND g_dummy03 <> "C" THEN
               CALL GPRebuild_btn05_init() 
	       LET l_toppath_o = g_toppath
            END IF

         AFTER FIELD dummy02
            IF l_custpath_o <> g_custpath AND g_dummy03 <> "T" THEN
               CALL GPRebuild_btn05_init() 
	       LET l_custpath_o = g_custpath
            END IF
       
         AFTER FIELD dummy03
            IF l_dummy03_o <> g_dummy03 THEN
               CALL GPRebuild_btn05_init() 
	       LET l_dummy03_o = g_dummy03
            END IF
         #Begin:FUN-BA0031 by Hiko:改在編譯時才計算progress bar的百分比基數
         #AFTER INPUT            
         #   CALL GPRebuild_btn04()
         #End:FUN-BA0031 by Hiko
      END INPUT
    
      DISPLAY ARRAY g_disable TO s_disable.*   #左邊
          BEFORE DISPLAY
             CALL DIALOG.setCurrentRow("s_disable",l_ac_d)

          BEFORE ROW
             LET l_ac_d = DIALOG.getCurrentRow("s_disable")

          ON ACTION btn_select   #select  
             LET l_action = "btn_select"
             EXIT DIALOG

         # ON ACTION accept                   #FUN-CB0060
         #    LET l_action = "btn_select"     #FUN-CB0060
         #    EXIT DIALOG                     #FUN-CB0060

      END DISPLAY

      DISPLAY ARRAY g_select TO s_select.*   #右邊
          BEFORE DISPLAY
             CALL DIALOG.setCurrentRow("s_select",l_ac_s)

          BEFORE ROW
             LET l_ac_s = DIALOG.getCurrentRow("s_select")

          ON ACTION btn_disable
             LET l_action = "btn_disable"
             EXIT DIALOG

         # ON ACTION accept                   #FUN-CB0060  
         #    LET l_action = "btn_disable"    #FUN-CB0060
         #    EXIT DIALOG                     #FUN-CB0060

      END DISPLAY
    
      ON ACTION do_action  #execution 執行編譯
         LET l_action = "do_action"
         EXIT DIALOG

      ON ACTION OUTPUT     #查看記錄檔
         CALL GPRebuild_outmenu()
      ON ACTION btn_selall #選取全部
         IF l_dummy03_o <> g_dummy03 THEN
            CALL GPRebuild_btn05_init() 
	    LET l_dummy03_o = g_dummy03
         END IF
         LET l_action = "btn_selall"
         EXIT DIALOG

      ON ACTION btn_disall #刪除全部
         LET l_action = "btn_disall"
         EXIT DIALOG
         
      ON ACTION exit
         LET INT_FLAG = TRUE
         EXIT DIALOG
         
      ON ACTION close
         LET INT_FLAG = TRUE
         EXIT DIALOG

   END DIALOG
   IF INT_FLAG THEN
      LET INT_FLAG = TRUE
      EXIT WHILE
   END IF
   CASE l_action
      WHEN "do_action" #執行編譯
         #No.FUN-C60110--start--
         LET ls_top = FGL_GETENV("TOP") 
         LET ls_str = ls_top,"/schema/ds.sch"
         IF NOT os.Path.exists(ls_str) THEN
            IF os.Path.separator() = "/" THEN
               display  "r.s2 ds"
               RUN "r.s2 ds" 
            ELSE
               display "r.s2 ds"
               RUN "r.s2 ds"
            END IF
            IF NOT os.Path.exists(ls_str) THEN
               LET p_msg = "執行r.s2 ds異常,請排除r.s2問題!!"
               CALL GPRebuild_msg(p_msg)
            END IF
         END IF
         #No.FUN-C60110--end--
         LET g_workcnt = g_select.getLength()  #取得模組
         IF NOT g_workcnt AND NOT g_du04_s AND NOT g_du04_s THEN EXIT CASE END IF
         LET g_dummy05 = ""
         FOR li_cnt = 1 TO g_workcnt 
            LET g_dummy05 = g_dummy05," ",g_select[li_cnt].gao01_s CLIPPED
         END FOR
         CALL GPRebuild_process()
         DISPLAY gt_end TO FORMONLY.dummy08
         LET ls_message = "Rebuild Finish.Total Spent Time:",gt_end - gt_start," \n\n",
                          #"Error Log File: ",os.Path.rootname(g_logfilepath),".err \n", #FUN-B50012
                          #Begin:FUN-BA0031
                          #"Detail Log File: ",g_logfilepath
                          #by jrg542 #12/02/06 程式編譯結果寫到 GPRebuild_XXX.log
                          "Detail Log File: ",g_logfilepath,"\n",
                          #by jrg542 #12/02/06 當按查看記錄檔BUTTON   view時會把錯誤訊息寫到 GPRebuild_XX_errlist.log 寫到$TEMPDIR
                          "Error File List: ",os.Path.join(FGL_GETENV("TEMPDIR"),"GPRebuild_"||g_hjr01 CLIPPED||"_errlist.log")
                          #End:FUN-BA0031
         CALL GPRebuild_msg(ls_message)
      WHEN "btn_selall" #全部選取
         LET li_total = g_select.getLength()
         IF g_disable.getLength() > 0 THEN
            FOR li_cnt = 1 TO g_disable.getLength()
               LET g_select[li_total + li_cnt].gao01_s = g_disable[li_cnt].gao01_d
            END FOR
            CALL g_disable.clear()
         END IF

      WHEN "btn_select" #選取本項 
         IF g_disable.getLength() >= 1 THEN    #module
            LET li_total = g_select.getLength()
            LET g_select[li_total + 1].gao01_s = g_disable[l_ac_d].gao01_d     #全部模組
            CALL g_disable.deleteElement(l_ac_d)
         END IF

      WHEN "btn_disable" #刪除本項
         IF g_select.getLength() >= 1 THEN
            LET li_total = g_disable.getLength()
            LET g_disable[li_total + 1].gao01_d = g_select[l_ac_s].gao01_s
            CALL g_select.deleteElement(l_ac_s)
         END IF

      WHEN "btn_disall" #刪除全部
         LET li_total = g_disable.getLength()
         IF g_select.getLength() > 0 THEN
            FOR li_cnt = 1 TO g_select.getLength()
               LET g_disable[li_total + li_cnt].gao01_d = g_select[li_cnt].gao01_s
            END FOR
            CALL g_select.clear()
         END IF

   END CASE

   END WHILE  
END FUNCTION

PRIVATE FUNCTION GPRebuild_btn01(lc_type)

   DEFINE lc_type    LIKE type_file.chr10
   DEFINE ls_path    STRING

   OPEN WINDOW w_btn01 WITH 800 ROWS, 400 COLUMNS

   CASE lc_type
      WHEN "top"  
         DISPLAY g_toppath TO FORMONLY.path
         LET ls_path = g_toppath.trim()
      WHEN "cust"
         DISPLAY g_custpath TO FORMONLY.path
         LET ls_path = g_custpath.trim()
      WHEN "log" 
         DISPLAY g_logfilepath TO FORMONLY.path
         LET ls_path = g_logfilepath.trim()
   END CASE

   INPUT ls_path WITHOUT DEFAULTS FROM path

   CASE lc_type
      WHEN "top"  LET g_toppath = ls_path.trim()
      WHEN "cust" LET g_custpath = ls_path.trim()
      WHEN "log"  LET g_logfilepath = ls_path.trim()
   END CASE

   CLOSE WINDOW w_btn01
   
END FUNCTION


PRIVATE FUNCTION GPRebuild_msg(ls_message)

   DEFINE ls_message    STRING
   OPEN WINDOW w_mseg01 WITH 400 ROWS, 200 COLUMNS
   CALL GPRebuild_msg_gen(ls_message)   #產生FORM
   DISPLAY "ls_message:",ls_message 
   MENU ""
      COMMAND "OK !" EXIT MENU 

   END MENU
   CLOSE WINDOW w_mseg01
END FUNCTION

#FUN-BA0031 by Hiko:補充說明:計算progress bar所分配的百分比基數.
PRIVATE FUNCTION GPRebuild_btn04()
  
   LET g_dummy04_cnt = g_du04_c + g_du04_l + g_du04_f    #C 、L 、F

END FUNCTION



PRIVATE FUNCTION GPRebuild_btn05_init()

   DEFINE ls_tmp1       STRING
   DEFINE ls_tmp2       STRING
   DEFINE tok           base.StringTokenizer
   DEFINE li_i          LIKE type_file.num10
   DEFINE li_workcnt    LIKE type_file.num10

   CALL g_select.clear()
   CALL g_disable.clear()

   IF g_dummy03 = "T" OR g_dummy03 = "F" THEN   #standard dir
      LET li_i = g_disable.getLength()
      CALL GPRebuild_btn05_showdir(0,g_toppath,0) RETURNING ls_tmp1,li_workcnt
      LET tok = base.StringTokenizer.create(ls_tmp1,",")
      WHILE tok.hasMoreTokens()
         LET li_i = li_i + 1
         LET ls_tmp2 = tok.nextToken()
         LET g_disable[li_i].gao01_d = ls_tmp2.trim()
      END WHILE
   END IF
   
   IF g_dummy03 = "C" OR g_dummy03 = "F" THEN   #cust
      LET li_i = g_disable.getLength()
      CALL GPRebuild_btn05_showdir(0,g_custpath,0) RETURNING ls_tmp1,li_workcnt
      LET tok = base.StringTokenizer.create(ls_tmp1,",")
      WHILE tok.hasMoreTokens()
         LET li_i = li_i + 1
         LET ls_tmp2 = tok.nextToken()
         LET g_disable[li_i].gao01_d = ls_tmp2.trim()
      END WHILE
   END IF

   IF g_dummy03 = "S" THEN   # full systematic directory
      LET g_disable[1].gao01_d = "lib"  LET g_disable[4].gao01_d = "clib"
      LET g_disable[2].gao01_d = "sub"  LET g_disable[5].gao01_d = "csub"
      LET g_disable[3].gao01_d = "qry"  LET g_disable[6].gao01_d = "cqry"
   END IF
   
END FUNCTION


PRIVATE FUNCTION GPRebuild_btn05_showdir(li_sys,ls_path,li_typ)

   DEFINE li_sys     LIKE type_file.num10    # 0=subsystem, 1=4gl 2=per 3=main prog 
   DEFINE li_typ     LIKE type_file.num10    # 0=only name, 1=full path
   DEFINE ls_path    STRING
   DEFINE ls_child   STRING
   DEFINE ls_return  STRING
   DEFINE ls_temp    STRING
   DEFINE li_h       LIKE type_file.num10
   DEFINE li_cnt     LIKE type_file.num10

   LET ls_return = ""
   LET li_cnt = 0
   CALL os.Path.dirsort("name",1)
   LET li_h = os.Path.diropen(ls_path)
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
      CASE li_sys
         WHEN "0"
            IF NOT ( (ls_child.subString(1,1) MATCHES "[AGag]" AND ls_child.getLength() = 3 )
            OR (ls_child.subString(1,1) MATCHES "[Cc]" AND
	       (ls_child.getLength() = 3 OR ls_child.getLength()= 4 or ls_child.getLength() = 5 ))
            OR (ls_child.tolowercase() = "lib" OR ls_child.tolowercase() = "sub" OR
	        ls_child.tolowercase() = "qry")) THEN
                CONTINUE WHILE
            END IF
         WHEN "1"
            LET ls_child = ls_child.trim()
            IF ls_child.getLength() <= 4 THEN CONTINUE WHILE END IF
            LET ls_temp = DOWNSHIFT(ls_child.subString(ls_child.getLength()-3,ls_child.getLength()))
            IF NOT ls_temp = ".4gl" THEN CONTINUE WHILE END IF
         WHEN "2"
            LET ls_child = ls_child.trim()
            IF ls_child.getLength() <= 4 THEN CONTINUE WHILE END IF
            LET ls_temp = DOWNSHIFT(ls_child.subString(ls_child.getLength()-3,ls_child.getLength()))
            IF NOT ls_temp = ".per" THEN CONTINUE WHILE END IF
         WHEN "3"
            IF NOT ls_child.subString(1,1) MATCHES "[AGCagc]" THEN CONTINUE WHILE END IF
      END CASE
      
      IF li_typ = 0 THEN
         LET ls_return = ls_return,", ",ls_child
      ELSE
         LET ls_return = ls_return,", ",os.Path.join(ls_path, ls_child)
      END IF
      LET li_cnt = li_cnt + 1
   END WHILE
   CALL os.Path.dirclose(li_h)
   
   RETURN ls_return.subString(3,ls_return.getLength()),li_cnt
END FUNCTION



PRIVATE FUNCTION GPRebuild_msg_gen(ls_message)

    DEFINE lw_win           ui.Window
    DEFINE lf_form          ui.Form
    DEFINE ln_win,  ln_form, ln_grid, ln_label     om.DomNode
    DEFINE ls_message    STRING
    
    LET lw_win = ui.Window.getCurrent()
    LET lf_form = lw_win.createForm("Form")
    LET ln_form = lf_form.getNode()
       LET ln_grid = ln_form.createChild("Grid")

          LET  ln_label = ln_grid.createChild("Label")
          CALL ln_label.setAttribute("text",ls_message.trim())
          CALL ln_label.setAttribute("posY",1)
    CALL lw_win.setText("Rebuilding Message")
END FUNCTION

PRIVATE FUNCTION GPRebuild_background_explain()

   DISPLAY " "
   #DISPLAY "Usage:   %FGLRUN% GPRebuild \"Execute_Condition\" \"TP\""
   #DISPLAY "Sample0: %FGLRUN% GPRebuild \"\" \"TP\""
   #DISPLAY "Sample1: %FGLRUN% GPRebuild \"TOP=\'D:\\TIPTOP\' AREA=\'T\'\" \"TP\""
   #DISPLAY "Sample2: %FGLRUN% GPRebuild \"TOP=\'D:\\TIPTOP\' AREA=\'F\' LOG=\'C:\\rbld.txt\' \"TP\""
   
   DISPLAY "Usage:   rebuild+ ","\"arg1\""," ", "\"arg2\""
   DISPLAY "Sample0: rebuild+ ","\"TOP\"" ," ", "\"TP\"" ," all default value"
   DISPLAY "Sample1: rebuild+ ", "\"TOP='/u1/topprod/tiptop'AREA='T'ITEM='C'DIR='gap'\" ","\"TP\""
   DISPLAY " "
   DISPLAY "Parameter: (Sample0 means using all default value)"
   DISPLAY " TOP=\'Redefine TIPTOP GP Standard System Real Path\'"
   DISPLAY " CUST=\'Redefine TIPTOP GP Customized System Real Path\'"
   DISPLAY " ITEM=\'Define Rebuild Item\'                (Default:CLF)"
   DISPLAY "      C=Compile 4gl,    L=Link Program,      F=Compile 4fd "
   DISPLAY " AREA=\'Define System Compile or Link Mode\' (Default:C)"
   DISPLAY "      T=TIPTOP GP Standard Only,        C=TIPTOP GP Customize Only "
   DISPLAY "      S=TIPTOP GP Systemetric Path Only F=TIPTOP GP Full System "
   DISPLAY " DIR=\'List Each Subsystem ID, devide by common(,)\'"
   DISPLAY "      When Using DIR, Rebuild-Tool will Restrict to AREA Setting."
   DISPLAY " LOG=\'Define Rebuild Log Real Path\'"
   DISPLAY " BG=\'Background Mode Setting.\'             (Default:1) "
   DISPLAY "      0=Show On GUI,                    1=Silent Mode"
   DISPLAY " "
   EXIT PROGRAM

END FUNCTION


PRIVATE FUNCTION GPRebuild_background_init(ls_tmp)
   DEFINE ls_tmp      STRING
   DEFINE ls_tmp1     STRING
   DEFINE li_pos      LIKE type_file.num10
   DEFINE li_check    LIKE type_file.num10
   DEFINE li_cnt      LIKE type_file.num5

   LET li_check = TRUE
   #TOP #正式目錄
   IF ls_tmp.getIndexOf("TOP='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("TOP='",1)
      LET g_toppath = ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1)
      IF NOT os.Path.exists(g_toppath) THEN
         DISPLAY "Error: TOP Path Not Exists:",g_toppath
         CALL GPRebuild_background_explain()
      END IF
      #LET g_cmd = os.Path.join(g_toppath,"msv") #FUN-B50012 先註解再問鴻傑
      LET li_check = FALSE
   END IF
   #CUST #客製目錄
   IF ls_tmp.getIndexOf("CUST='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("CUST='",1)
      LET g_custpath = ls_tmp.subString(li_pos+6,ls_tmp.getIndexOf("'",li_pos+7)-1)
      IF NOT os.Path.exists(g_custpath) THEN
         DISPLAY "Error: CUST Path Not Exists:",g_custpath
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF
   #AREA #編譯設定  #g_dummy03 (T ,C ,S ,F) 
   IF ls_tmp.getIndexOf("AREA='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("AREA='",1)
      LET g_dummy03 = ls_tmp.subString(li_pos+6,li_pos+6)
      LET g_dummy03 = UPSHIFT(g_dummy03)
      IF g_dummy03 <> "T" AND g_dummy03 <> "C" AND g_dummy03 <> "F" AND g_dummy03 <> "S" THEN
         DISPLAY "Error: AREA Type Not Exists:",g_dummy03
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
      CALL GPRebuild_btn05_init() 
   END IF
   #ITEM #編譯種類勾選
   IF ls_tmp.getIndexOf("ITEM='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("ITEM='",1)
      LET ls_tmp1 = ls_tmp.subString(li_pos+6,ls_tmp.getIndexOf("'",li_pos+7)-1)
      #IF ls_tmp1.getIndexOf("C",1) THEN LET g_du04_c = 1 END IF  #Compile 4gl  #FUN-B50012
      #IF ls_tmp1.getIndexOf("L",1) THEN LET g_du04_l = 1 END IF  #Link         #FUN-B50012
      #IF ls_tmp1.getIndexOf("F",1) THEN LET g_du04_f = 1 END IF  #Compile 4fd  #FUN-B50012
      #FUN-B50012 -- start 
      IF ls_tmp1.getIndexOf("C",1) THEN 
        LET g_du04_c = 1 
      ELSE 
        LET g_du04_c = 0 
      END IF  #Compile 4gl
      IF ls_tmp1.getIndexOf("L",1) THEN 
        LET g_du04_l = 1 
      ELSE 
        LET g_du04_l = 0
      END IF  #Link  
      IF ls_tmp1.getIndexOf("F",1) THEN 
        LET g_du04_f = 1 
      ELSE 
        LET g_du04_f = 0
      END IF  #Compile 4fd      
      #FUN-B50012 -- end 
      IF g_du04_c + g_du04_l + g_du04_f = 0 THEN
         DISPLAY "Error: ITEM Type Not Exists:",ls_tmp1
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF
   #DIR  #模組名稱 #g_dummy05:模組
   IF ls_tmp.getIndexOf("DIR='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("DIR='",1)
      #FUN-B50012 --start 
      #LET g_dummy05 = ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1)
      LET  g_dummy05 = ""
      LET g_dummy05 = g_dummy05," ",ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1) CLIPPED 
      #FUN-B50012 --end    
      
      IF g_dummy05.getLength() < 3 THEN
         DISPLAY "Error: Parameters of DIR Not Exists:",g_dummy05
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF
   
   #LOG  #log
   IF ls_tmp.getIndexOf("LOG='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("LOG='",1)
      LET g_logfilepath = ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1)
      IF NOT os.Path.exists(g_logfilepath) THEN
         DISPLAY "Error: LOG Path Not Exists:",g_logfilepath
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF
   #BG
   IF ls_tmp.getIndexOf("BG='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("BG='",1)
      LET ls_tmp1 = ls_tmp.subString(li_pos+4,li_pos+4)
      IF ls_tmp1 = "0" THEN    #0:GUI Mode  #1:Silent Mode(Default)    
         CALL GPRebuild_init_window()
         DISPLAY g_toppath,g_custpath,g_dummy03,g_du04_c,g_du04_l,g_du04_f,
                 g_dummy05,g_logfilepath
              TO FORMONLY.dummy01,FORMONLY.dummy02,FORMONLY.dummy03,FORMONLY.du04_c,FORMONLY.du04_l,FORMONLY.du04_f,
                 FORMONLY.dummy05,FORMONLY.dummy06  
      END IF
   END IF
   
   IF li_check THEN
      LET g_workcnt = g_disable.getLength()  #取得模組
         
      LET g_dummy05 = ""
      FOR li_cnt = 1 TO g_workcnt 
          LET g_dummy05 = g_dummy05," ",g_disable[li_cnt].gao01_d CLIPPED
      END FOR
      DISPLAY "Warning: No Any Parameters Been Sat, Using Default Values." 
   END IF
   
END FUNCTION

PRIVATE FUNCTION GPRebuild_process()
   DEFINE ls_temp    STRING
   DEFINE ls_log_order STRING #FUN-BA0031 by Hiko

   LET g_progs02 = 0   #program(01) start from 1, module(02) start from 0 
   LET gt_start = CURRENT HOUR TO SECOND 
   LET g_today = TODAY USING "yyyy-mm-dd" #FUN-BA0031 by Hiko
   IF g_guimode THEN
      DISPLAY gt_start TO FORMONLY.dummy07
   END IF

   #Begin:FUN-BA0031 by Hiko
   LET g_log_order = g_log_order + 1 #每次按下編譯時,就自動將順序加上1.
   LET ls_log_order = g_log_order USING "&&&"
   LET g_hjr01 = FGL_GETPID() || ls_log_order #改變hjr01
   LET g_logfilepath = os.Path.join(FGL_GETENV("TEMPDIR"),"GPRebuild_"||g_hjr01 CLIPPED||".log")
   CALL GPRebuild_btn04() #從原本的AFTER INPUT移植過來,重新計算progress bar所分配的百分比基數.
   #End:FUN-BA0031 by Hiko

   CASE g_dummy03
      WHEN "T" LET ls_temp = " TIPTOP GP Standard Area"
      WHEN "C" LET ls_temp = " TIPTOP GP Customized Area"
      WHEN "S" LET ls_temp = " TIPTOP GP 42x System Only"
      WHEN "F" LET ls_temp = " TIPTOP GP Full Area"       #預設
   END CASE
   LET g_message[1] = "Rebuild Aimd Area:",ls_temp

   IF g_du04_c THEN
      LET ls_temp = ls_temp, ", Compile 4gl "  #預設
   END IF
   IF g_du04_f THEN
      LET ls_temp = ls_temp, ", Compile per "  #預設
   END IF
   IF g_du04_l THEN
      LET ls_temp = ls_temp, ", Link Programs "  #預設
   END IF
   LET ls_temp = ls_temp.subString(2,ls_temp.getLength())
 
   LET g_message[2] = "Rebuild Aimd Function:",ls_temp

   IF g_du04_s = 1 THEN
      CALL GPRebuild_process_rs2ds()       # r.s2 ds #預設沒有
   END IF
   IF g_du04_t = 1 THEN
      CALL GPRebuild_process_rebuildtool() # rebuild_tool ds4gl2/bin 及 ora/4gl  #預設沒有
   END IF
   IF g_du04_c = 1 THEN
      LET g_jobnow = "C" #Compile 4GL
      CALL GPRebuild_process_init() # 
   END IF
   IF g_du04_l = 1 THEN
      LET g_jobnow = "L" #Link Programs
      CALL GPRebuild_process_init()
   END IF
   IF g_du04_f = 1 THEN  #Compile Form
      LET g_jobnow = "F"
      CALL GPRebuild_process_init()
   END IF

   LET gt_end = CURRENT HOUR TO SECOND 

END FUNCTION

PRIVATE FUNCTION GPRebuild_process_rs2ds()   # r.s2 ds

   DEFINE ls_cmd   STRING

#  LET ls_cmd = FGL_GETENV("FGLRUN")," ",os.Path.join(FGL_GETENV("AZZi"),"p_dbbackup"),' "',FGL_GETENV("FGLDBPATH"),'" "ds" "5"'
#  CALL GPRebuild_process_execute("S","sys","1",ls_cmd)

   RUN "r.s2 ds"

END FUNCTION


PRIVATE FUNCTION GPRebuild_process_rebuildtool()    # rebuild_tool ds4gl2/bin 及 ora/4gl msv/4gl
 
   RUN "rebuild_tool" 

END FUNCTION


PRIVATE FUNCTION GPRebuild_process_init()

   DEFINE ls_path   STRING
   display 'g_dummy03=',g_dummy03
   CASE 
      WHEN g_dummy03 = "T"
         LET ls_path = g_toppath.trim()
         CALL GPRebuild_process_working(ls_path)
      WHEN g_dummy03 = "C"
         LET ls_path = g_custpath.trim()
         #display 'here'
         CALL GPRebuild_process_working(ls_path)
      WHEN g_dummy03 = "F" OR g_dummy03 = "S"
         LET ls_path = g_toppath.trim()
         CALL GPRebuild_process_working(ls_path)
         LET ls_path = g_custpath.trim()
         CALL GPRebuild_process_working(ls_path)
   END CASE
END FUNCTION


PRIVATE FUNCTION GPRebuild_process_working(ls_path)

   DEFINE li_h      LIKE type_file.num10
   DEFINE li_i      LIKE type_file.num10
   DEFINE ls_path   STRING
   DEFINE ls_child  STRING
   DEFINE ls_target STRING
   DEFINE li_cnt    LIKE type_file.num10
   DEFINE ls_temp   STRING
   DEFINE li_modcnt LIKE type_file.num10

   LET li_modcnt = g_workcnt * g_dummy04_cnt

   CALL os.Path.dirsort("name",-1)     #逆向排序, 確保先作qry/sub/lib  clib/cqry/csub因歸屬於 lib/sub/qry 沒有排序先後問題
   LET li_h = os.Path.diropen(ls_path) #TOP 所有目錄  
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      LET ls_child = ls_child.trim()
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
      IF NOT g_dummy05.getIndexOf(" "||ls_child.trim(),1) THEN   #模處名稱
         CONTINUE WHILE
      END IF
      LET ls_target = os.Path.join(ls_path,ls_child)  
      CASE g_jobnow
         WHEN "C"  #編譯4gl
            IF g_guimode THEN
                LET ls_temp = "Compile Program Module:",ls_target.trim(),
	                     " ( ",g_progs02 USING "##&","/",li_modcnt USING "##&",") ",
			     (g_progs02 * 100 /li_modcnt) USING "##&.&&","%"
	        DISPLAY ls_temp.trim() TO FORMONLY.curr02
	    END IF
            LET ls_target = os.Path.join(ls_target,"4gl")
         WHEN "F" #編譯4fd
            IF g_guimode THEN
                LET ls_temp = "Compile Form Module:",ls_target.trim(),
	                     " ( ",g_progs02 USING "##&" ,"/",li_modcnt USING "##&",")",
			     (g_progs02 * 100 /li_modcnt) USING "##&.&&","%"
                DISPLAY ls_temp.trim() TO FORMONLY.curr02
	    END IF
            LET ls_target = os.Path.join(ls_target,"4fd")
         WHEN "L"  #link 
            IF g_guimode THEN
                LET ls_temp = "Link Module:",ls_target.trim(),
	                     " ( ",g_progs02 USING "##&","/",li_modcnt USING "##&",")",
			     (g_progs02 * 100 /li_modcnt) USING "##&.&&","%"
                DISPLAY ls_temp.trim() TO FORMONLY.curr02
            END IF
            IF ( g_dummy05.getIndexOf(" lib",1) AND ls_child = "lib" ) OR
               ( g_dummy05.getIndexOf(" sub",1) AND ls_child = "sub" ) OR
               ( g_dummy05.getIndexOf(" qry",1) AND ls_child = "qry" ) OR
               ( g_dummy05.getIndexOf(" clib",1) AND ls_child = "clib" )  OR
               ( g_dummy05.getIndexOf(" csub",1) AND ls_child = "csub" )  OR
               ( g_dummy05.getIndexOf(" cqry",1) AND ls_child = "cqry" )  THEN
               CALL GPRebuild_process_42x(ls_child.trim())
            ELSE
                LET ls_target = os.Path.join(ls_target,"4gl")
                CALL GPRebuild_process_42r(ls_child.trim())
            END IF
            LET g_progs02 = g_progs02 + 1
            IF g_guimode THEN
                LET ls_temp = "Link Finish ( ",g_progs02 USING "##&","/",li_modcnt USING "##&",")",
			     (g_progs02 * 100 /li_modcnt) USING "##&.&&","%"
                DISPLAY ls_temp.trim() TO FORMONLY.curr02
                DISPLAY ( g_progs02 * 100 / li_modcnt ) USING "##&" TO FORMONLY.progs02
                CALL ui.Interface.refresh()
            END IF 
        
        CONTINUE WHILE
      END CASE
      #開始處理 編譯4gl 4fd
      CALL GPRebuild_process_dir(ls_target) RETURNING li_cnt
      IF g_jobnow = "C" THEN
         #安全機制的搬移
         CALL GPRebuild_process_security(os.Path.join(ls_path,ls_child)) RETURNING li_cnt 
      END IF

      LET g_progs02 = g_progs02 + 1
      IF g_guimode THEN
        LET ls_temp = "Compile Finish ( ", g_progs02 USING "##&","/",li_modcnt USING "##&",") ",
	     (g_progs02 * 100 /li_modcnt) USING "##&.&&","%"
        DISPLAY ls_temp.trim() TO FORMONLY.curr02
        DISPLAY ( g_progs02 * 100 / li_modcnt ) USING "##&" TO FORMONLY.progs02
        CALL ui.Interface.refresh()
      END IF
   END WHILE
END FUNCTION


PRIVATE FUNCTION GPRebuild_process_dir(ls_path)
   DEFINE ls_path      STRING
   DEFINE ls_child     STRING
   DEFINE ls_target    STRING
   DEFINE li_h         LIKE type_file.num10
   DEFINE li_cnt       LIKE type_file.num10
   DEFINE li_filecnt   LIKE type_file.num10
   DEFINE ls_cmd       STRING
   DEFINE ls_temp      STRING
   DEFINE li_pos       LIKE type_file.num5
   DEFINE l_file       DYNAMIC ARRAY OF STRING
   DEFINE l_mod        STRING
   #Begin:FUN-BA0031 by Hiko
   DEFINE l_4fd_arr  DYNAMIC ARRAY OF STRING,
          l_4fd_idx  SMALLINT,
          l_mod_path STRING, 
          l_42f_path STRING,
          l_42f_arr  DYNAMIC ARRAY OF STRING,
          l_42f_idx  SMALLINT,
          l_4fd_name STRING,
          l_42f_name STRING,
          l_hjr03    LIKE hjr_file.hjr03, #模組別
          l_hjr06    LIKE hjr_file.hjr06, #是否完成處理
          l_hjr07    LIKE hjr_file.hjr07, #處理時間
          l_hjr08    LIKE hjr_file.hjr08  #程式代碼
   #End:FUN-BA0031 by Hiko

   CALL os.Path.dirsort("name", 1)
   LET li_h = os.Path.diropen(ls_path)
   IF NOT os.Path.chdir(ls_path) THEN
      DISPLAY "Error: Cannot change to ",ls_path.trim()
      RETURN 0
   END IF

   #取模組名
   LET l_mod = os.Path.dirname(ls_path)
   LET l_mod = UPSHIFT(os.Path.basename(l_mod))
   
   # Count File 計算 4gl   
   LET li_filecnt = 0
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child = "." OR ls_child = ".." THEN CONTINUE WHILE END IF
      CASE 
         WHEN g_jobnow = "C" OR g_jobnow = "L"
            IF os.path.extension(ls_child.trim()) = "4gl" THEN
	       LET li_filecnt = li_filecnt + 1
	    END IF
         WHEN g_jobnow = "F" 
            IF os.path.extension(ls_child.trim()) = "4fd" THEN
	       LET li_filecnt = li_filecnt + 1
	    END IF
      END CASE
   END WHILE
   CALL os.Path.dirclose(li_h)
   #Real Job
   LET li_h = os.Path.diropen(ls_path)

   LET li_cnt = 1   #Program start from 1 , module start from 0
   LET g_progs01 = li_cnt #程式筆數
   WHILE li_h > 0
      IF INT_FLAG THEN CALL GPRebuild_suspend() END IF
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
     
      CASE 
         WHEN g_jobnow = "C" #編譯4gl
            IF os.path.extension(ls_child) = "4gl" THEN
               LET ls_temp = "Compile 4gl: ",os.path.rootname(ls_child),
	                     " ( ",g_progs01 USING "##&","/",li_filecnt USING "##&",")",
			     (g_progs01 * 100 / li_filecnt) USING "##&.&&","%"
	       IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF
	       IF NOT g_background THEN DISPLAY ls_temp END IF #顯示編譯過程
               LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42m ",
	                    #os.path.rootname(ls_child) 
                        os.path.rootname(ls_child)," tiptop"
               #CALL GPRebuild_process_execute(g_jobnow,l_mod,li_cnt,ls_cmd) #執行 #FUN-BA0031 by Hiko
               CALL GPRebuild_process_execute("C",l_mod,ls_child,li_cnt,ls_cmd) #執行 #FUN-BA0031 by Hiko:參數增加程式代碼
               LET li_cnt = li_cnt + 1
            END IF

         WHEN g_jobnow = "F"    #因應新板 gsform可以一次輸入多個畫面檔 (節省讀取sch檔時間)並加入平行作業概念
                                #取消在此執行指令, 只做組字串
           
           IF os.path.extension(ls_child) = "4fd" THEN
               LET ls_temp = "Compile 4fd: ",os.path.rootname(ls_child),
	                     " ( ",g_progs01 USING "##&","/",li_filecnt USING "##&",")",
			     (g_progs01 * 100 / li_filecnt) USING "##&.&&","%"
	       IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF
	       IF NOT g_background THEN DISPLAY ls_temp END IF #顯示編譯過程
               IF li_cnt MOD g_processor = 0 THEN 
                  LET li_pos = li_cnt MOD g_processor + 1
               ELSE 
                  LET li_pos = li_cnt MOD g_processor   
               END IF 
               #LET li_pos = li_cnt MOD g_processor + 1 #11/09/26 li_pos = 1 MOD 16 + 1  → li_pos = 2
               LET l_file[li_pos] = l_file[li_pos],",",os.path.rootname(ls_child) 
               LET li_cnt = li_cnt + 1
            END IF
      END CASE
      LET g_progs01 = li_cnt 
      IF g_guimode THEN
         DISPLAY (g_progs01 * 100 / li_filecnt) USING "##&" TO FORMONLY.progs01 
	 CALL ui.Interface.refresh()
      END IF
   END WHILE
   CALL os.Path.dirclose(li_h)

   #若是做畫面, 則command是在畫面分配完後才一次送出, 進行平行處理 compile
   IF g_jobnow = "F" THEN
      #FOR li_pos = 1 TO g_processor #11/09/26 r.f2 以l_file[li_pos] 為主不是g_processor
      FOR li_pos = 1 TO l_file.getLength()
         LET ls_temp = l_file[li_pos] #FUN-BA0031 by Hiko:這裡的檔名是一長串的,例如aooi010,aooi020
         LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42f '",ls_temp.subString(2,ls_temp.getLength()),"' tiptop"
         #CALL GPRebuild_process_execute("F",l_mod,li_pos,ls_cmd) #FUN-BA0031 by Hiko
         CALL GPRebuild_process_execute("F",l_mod,ls_temp,li_pos,ls_cmd) #FUN-BA0031 by Hiko:參數增加程式代碼
      END FOR
   END IF

   #Begin:FUN-BA0031 by Hiko:因為編譯4fd是整批處理,加上gsform指令並沒有將錯誤訊息導出檔案,因此本作業產生的log檔並沒有包含4fd編譯錯誤的訊息.
                            #所以為了將編譯錯誤的4fd程式代號記錄下來,因此透過比對4fd與42f內的檔案做比對,沒有產生出來的就是失敗.
   IF g_jobnow = "F" THEN
      #取得4fd的程式清單
      LET li_h = os.Path.diropen(ls_path)
      LET l_4fd_idx = 0
      WHILE li_h > 0
         LET ls_child = os.Path.dirnext(li_h)
         IF ls_child IS NULL THEN EXIT WHILE END IF
         IF ls_child = "." OR ls_child = ".." THEN CONTINUE WHILE END IF
         IF os.path.extension(ls_child.trim()) = "4fd" THEN
            LET l_4fd_idx = l_4fd_idx + 1
            LET l_4fd_name = os.Path.rootname(ls_child)
            LET l_4fd_arr[l_4fd_idx] = l_4fd_name
         END IF
      END WHILE
      CALL os.Path.dirclose(li_h)
      #取得42f的程式清單
      #舉例ls_path=$TOP/AOO/4fd
      #取模組名路徑
      LET l_mod_path = os.Path.dirname(ls_path) #$TOP/AOO
      LET l_42f_path = os.Path.join(l_mod_path,"42f")

      LET li_h = os.Path.diropen(l_42f_path)
      LET l_42f_idx = 0
      WHILE li_h > 0
         LET ls_child = os.Path.dirnext(li_h)
         IF ls_child IS NULL THEN EXIT WHILE END IF
         IF ls_child = "." OR ls_child = ".." THEN CONTINUE WHILE END IF
         IF os.path.extension(ls_child.trim()) = "42f" THEN
            LET l_42f_idx = l_42f_idx + 1
            LET l_42f_name = os.Path.rootname(ls_child)
            LET l_42f_arr[l_42f_idx] = l_42f_name
         END IF
      END WHILE
      CALL os.Path.dirclose(li_h)

      #由4fd的清單逐一比對42f的清單,找不到就代表gsform編譯失敗.
      LET l_hjr07 = g_today," ",gt_start
      FOR l_4fd_idx=1 TO l_4fd_arr.getLength()
         LET l_4fd_name = l_4fd_arr[l_4fd_idx]
         LET l_hjr06 = "N" 
         FOR l_42f_idx=1 TO l_42f_arr.getLength()
            IF l_42f_arr[l_42f_idx].equals(l_4fd_name) THEN
               CALL l_42f_arr.deleteElement(l_42f_idx) #將找到對應的42f從清單移除,這樣可以增加比對的速度.
               LET l_hjr06 = "Y" #表示42f有產生
               EXIT FOR
            END IF
         END FOR

         #hjr01:建置ID #hjr02:建置項目(C,L,F) #hjr03:建至模組 #hjr04:建置序號 
         #hjr05:錯誤訊息 #hjr06:是否完成處理 #hjr07:時間 #hjr08:程式代號
         LET l_hjr03 = l_mod #要轉型態才可以直接新增
         LET l_hjr08 = l_4fd_name,".4fd" #加上副檔名在顯現報表時會比較清楚
         INSERT INTO hjr_file(hjr01,hjr02,hjr03,hjr04,hjr05,hjr06,hjr07,hjr08)
              VALUES(g_hjr01,"F",l_hjr03,l_4fd_idx,NULL,l_hjr06,l_hjr07,l_hjr08)
      END FOR
   END IF
   #End:FUN-BA0031 by Hiko

   RETURN li_cnt
END FUNCTION

#呼叫 GPRebuild-itm 執行 
#PRIVATE FUNCTION GPRebuild_process_execute(l_hjr02,l_hjr03,l_hjr04,ls_cmd) #FUN-BA0031 by Hiko
PRIVATE FUNCTION GPRebuild_process_execute(l_hjr02,l_hjr03,l_hjr08,l_hjr04,ls_cmd) #FUN-BA0031 by Hiko:參數增加程式代碼

   DEFINE l_hjr02     LIKE hjr_file.hjr02   #建置項目 C,L,F  
   DEFINE l_hjr03     LIKE hjr_file.hjr03   #建至模組 
   DEFINE l_hjr04     LIKE hjr_file.hjr04   #建置序號 
   DEFINE ls_cmd      STRING                #指令
   DEFINE ls_run      STRING
   DEFINE l_hjr07     LIKE hjr_file.hjr07   #start time
   DEFINE l_hjr08     LIKE hjr_file.hjr08   #FUN-BA0031 by Hiko:程式代號

   LET ls_run = '"',g_hjr01 CLIPPED,'" "',l_hjr02 CLIPPED,'" "',l_hjr03 CLIPPED,
                '" ',l_hjr04 USING "<<<<<<<",' "',ls_cmd.trim(),'"'
   #LET l_hjr07 = TODAY USING "yyyy-mm-dd"," ",gt_start #FUN-BA0031 by Hiko
   LET l_hjr07 = g_today," ",gt_start #FUN-BA0031 by Hiko

   #hjr01:建置ID #hjr02:建置項目(C,L,F) #hjr03:建至模組 
   #hjr04:建置序號 #hjr07:時間 #hjr08:程式代號
   IF g_jobnow != "F" THEN #FUN-BA0031 by Hiko
      INSERT INTO hjr_file(hjr01,hjr02,hjr03,hjr04,hjr07,hjr08)
       VALUES(g_hjr01,l_hjr02,l_hjr03,l_hjr04,l_hjr07,l_hjr08)
   END IF

   LET ls_run = FGL_GETENV("FGLRUN")," ",FGL_GETENV("DS4GL"),os.Path.separator(),"bin",os.Path.separator(),
                "GPRebuild",os.Path.separator(),"GPRebuild-itm ",ls_run
   
   IF os.Path.separator() = "/" THEN #if 是 unix 
      #LET ls_run = ls_run," 2>&1" #FUN-B50012 
      #LET ls_run = ls_run," > ",g_logfilepath CLIPPED," 2>&1 " 
      LET ls_run = ls_run," >> ",g_logfilepath CLIPPED," 2>&1 " 
   END IF
   #DISPLAY "ls_run=",ls_run 
  
    IF l_hjr02 = "X" THEN                   #FUN-CB0060    
       RUN ls_run                           #FUN-CB0060 
    ELSE                                    #FUN-CB0060 
      IF l_hjr04 MOD g_processor = 0 THEN
         RUN ls_run
       ELSE
         RUN ls_run WITHOUT WAITING
       END IF
    END IF                                   #FUN-CB0060
 
   RETURN
   
END FUNCTION


PRIVATE FUNCTION GPRebuild_process_42x(ls_module)

   DEFINE ls_module    STRING
   DEFINE ls_cmd       STRING

   IF ls_module.subString(1,1) = "c" THEN LET ls_module = ls_module.subString(2,ls_module.getLength()) END IF
   LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42r ",ls_module.trim()," tiptop"
   #CALL GPRebuild_process_execute("X",ls_module,"1",ls_cmd) #FUN-BA0031 by Hiko
   CALL GPRebuild_process_execute("X",ls_module,NULL,"1",ls_cmd) #FUN-BA0031 by Hiko

END FUNCTION

#安全機制的搬移
PRIVATE FUNCTION GPRebuild_process_security(ls_aimpath)

   DEFINE ls_module    STRING
   DEFINE ls_srcpath   STRING
   DEFINE ls_aimpath   STRING
   DEFINE ls_child     STRING
   DEFINE li_h         LIKE type_file.num10

   LET ls_module = os.Path.basename(ls_aimpath)
   IF NOT (ls_module = "lib" OR ls_module = "qry" OR ls_module = "azz") THEN
      RETURN TRUE
   END IF
   LET ls_module = ls_module.trim(),"_"

   #安全機制路徑
   LET ls_srcpath = os.Path.join(FGL_GETENV("DS4GL"),"bin")
   #LET ls_srcpath = os.Path.join(ls_srcpath,g_db_type CLIPPED)  #FUN-B60042 
   LET ls_srcpath = os.Path.join(ls_srcpath,DOWNSHIFT(g_db_type) CLIPPED)

   #複製路徑
   LET ls_aimpath = os.Path.join(ls_aimpath,g_42m CLIPPED)

   LET li_h = os.Path.diropen(ls_srcpath)
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
      IF NOT os.Path.isfile(os.Path.join(ls_srcpath,ls_child)) THEN
         CONTINUE WHILE
      END IF
      IF ls_child.subString(1,ls_module.getLength()) = ls_module.trim() THEN
         IF os.Path.copy(os.Path.join(ls_srcpath,ls_child),
                         os.Path.join(ls_aimpath,ls_child)) THEN
         END IF
      END IF 
   END WHILE 
   CALL os.Path.dirclose(li_h)

   RETURN TRUE
END FUNCTION

PRIVATE FUNCTION GPRebuild_suspend() 
   EXIT PROGRAM
END FUNCTION



PRIVATE FUNCTION GPRebuild_process_42r(lc_module)

   DEFINE lc_module     LIKE type_file.chr10
   DEFINE lc_child      LIKE type_file.chr50,    #FUN-830011
          ls_child      STRING #FUN-BA0031 by Hiko
   DEFINE ls_child_old  STRING,             #FUN-C60110  skip duplicate
          lc_duplicate  LIKE type_file.chr1 #FUN-C60110
   DEFINE li_filecnt    LIKE type_file.num10
   DEFINE li_cnt        LIKE type_file.num10
   DEFINE li_s,li_e     LIKE type_file.num10
   DEFINE ls_temp       STRING

   LET ls_child_old = '' #FUN-C60110
   LET lc_module = UPSHIFT(lc_module CLIPPED)
   SELECT COUNT(*) INTO li_filecnt FROM zz_file WHERE zz011 = lc_module 

   DECLARE gprbd_zz011_cs CURSOR FOR
     SELECT zz08 FROM zz_file
     #WHERE zz011 = lc_module AND zz08 IS NOT NULL               #mark by FUN-C60110
      WHERE zz011 = lc_module AND zz08 IS NOT NULL ORDER BY zz08 #FUN-C60110

   LET li_cnt = 1
   FOREACH gprbd_zz011_cs INTO lc_child
      LET ls_temp = lc_child CLIPPED

      #排除掉動態報表會一直r.l2 p_query的問題
      IF lc_module <> "AZZ" AND ls_temp.getIndexOf("p_query",7) THEN
         CONTINUE FOREACH
      END IF

      #作業系統差異
      IF os.Path.separator() = "/" THEN
         LET li_s = ls_temp.getIndexOf("i/",1) + 2
      ELSE
         LET li_s = ls_temp.getIndexOf("i%/",1) + 3
      END IF

      LET li_e = ls_temp.getIndexOf(" ",li_s)
      IF li_e = 0 THEN
         LET li_e = ls_temp.getLength()
         #LET lc_child = ls_temp.subString(li_s,li_e) #FUN-BA0031 by Hiko
         LET ls_child = ls_temp.subString(li_s,li_e)  #FUN-BA0031 by Hiko
      ELSE
         #LET lc_child = ls_temp.subString(li_s,li_e-1) #FUN-BA0031 by Hiko
         LET ls_child = ls_temp.subString(li_s,li_e-1)  #FUN-BA0031 by Hiko
      END IF

      LET ls_child = ls_child.trim() #FUN-BA0031 by Hiko
      #LET ls_temp = "Link Program: ",lc_child CLIPPED, #FUN-BA0031 by Hiko
      LET ls_temp = "Link Program: ",ls_child, #FUN-BA0031 by Hiko
                    " ( ",li_cnt USING "##&","/",li_filecnt USING "##&",")",
       	     (li_cnt * 100 / li_filecnt) USING "##&.&&","%"
      IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF

      #FUN-C60110 --start--
      IF ls_child = ls_child_old THEN
         #LET ls_temp = ls_temp," --- SKIP ---" 
         LET ls_temp = ls_temp #FUN-CC0152 
         LET lc_duplicate = "Y"
      ELSE LET lc_duplicate = "N"
      END IF
      LET ls_child_old = ls_child 
      #FUN-C60110 --end--

      IF NOT g_background THEN DISPLAY ls_temp END IF
      
      IF lc_duplicate = "Y" THEN #FUN-C60110 skip duplicate 
      ELSE                       #FUN-C60110
         #Begin:FUN-BA0031 by Hiko
         #LET ls_temp = g_cmd.trim(),os.path.separator(),"gen42r ",lc_child CLIPPED," tiptop"
         LET ls_temp = g_cmd.trim(),os.path.separator(),"gen42r ",ls_child," tiptop"
         #CALL GPRebuild_process_execute("L",lc_module,li_cnt,ls_temp) 
         LET ls_child = ls_child,".42r" #FUN-BA0031 by Hiko:補上附檔名在報表呈現上會比較清楚.
         CALL GPRebuild_process_execute("L",lc_module,ls_child,li_cnt,ls_temp)
         #End:FUN-BA0031 by Hiko
      END IF #FUN-C60110

      LET g_progs01 = li_cnt 
      IF g_guimode THEN
         DISPLAY (g_progs01 * 100 / li_filecnt) USING "##&" TO FORMONLY.progs01 
         CALL ui.Interface.refresh()
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH

END FUNCTION


#單純由MENU選擇查看報告的清單
PRIVATE FUNCTION GPRebuild_outmenu()
   
   DEFINE l_sql   STRING
   DEFINE l_hjr   DYNAMIC ARRAY OF RECORD
            hjr01 LIKE hjr_file.hjr01,
            hjr07 LIKE hjr_file.hjr07
                  END RECORD
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_ac    LIKE type_file.num10

   LET l_sql = " SELECT DISTINCT hjr01,hjr07 FROM hjr_file ORDER BY hjr07,hjr01 "
   PREPARE gprebuild_om_pre FROM l_sql      
   DECLARE gprebuild_om_cs CURSOR FOR gprebuild_om_pre

   CALL l_hjr.clear()

   LET l_cnt = 1 
   FOREACH gprebuild_om_cs INTO l_hjr[l_cnt].*       #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         DISPLAY "Error:FOREACH--",SQLCA.sqlcode
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_hjr.deleteElement(l_cnt)

   LET l_cnt = l_hjr.getLength()
   IF l_cnt = 0 THEN
      CALL GPRebuild_msg("Error: No Data Can to Generate Reports!")
      RETURN
   END IF
   LET l_sql = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("DS4GL"),"bin"),"GPRebuild"),"GPRebuild-om")
   OPEN WINDOW w_GPRebu_om WITH FORM l_sql 
    
   DISPLAY ARRAY l_hjr TO s_hjr.* ATTRIBUTE(COUNT = l_cnt,UNBUFFERED)
   
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
  
      ON ACTION remove_data     #清除不要留的LOG檔
         LET l_ac = ARR_CURR()
         DELETE FROM hjr_file WHERE hjr01=l_hjr[l_ac].hjr01
         IF NOT SQLCA.SQLCODE THEN
            CALL l_hjr.deleteElement(l_ac)
         END IF

      ON ACTION cancel
         LET l_ac = 0 
         EXIT DISPLAY
   END DISPLAY
   IF l_ac <> 0 THEN
      CALL GPRebuild_output(l_hjr[l_ac].hjr01)
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE 
   END IF

   CLOSE WINDOW w_GPRebu_om
END FUNCTION

#查看報告的功能
PRIVATE FUNCTION GPRebuild_output(l_hjr01)

   DEFINE l_sql   STRING
   DEFINE sr      RECORD LIKE hjr_file.*
   DEFINE l_hjr01 LIKE hjr_file.hjr01
   DEFINE l_name  STRING
   DEFINE l_errlist_file STRING, #FUN-BA0031 by Hiko:將錯誤的程式清單導入一個log檔,可讓使用者下載.
          l_errlist_path STRING  #FUN-BA0031 by Hiko

   LET l_name = os.Path.join(FGL_GETENV("TEMPDIR"),"GPRebuild.out")

   LET l_sql=" SELECT * FROM hjr_file WHERE hjr01='",l_hjr01 CLIPPED,"' AND hjr06='N' ORDER BY hjr02,hjr03 "
   PREPARE rebuild_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      DISPLAY "Error: PREPARE-",SQLCA.sqlcode
      RETURN
   END IF

   DECLARE rebuild_cs CURSOR FOR rebuild_pre
   IF SQLCA.sqlcode THEN
      DISPLAY "Error: DECLARE-",SQLCA.sqlcode
      RETURN
   END IF

   #Begin:FUN-BA0031 by Hiko
   LET l_errlist_file = "GPRebuild_",l_hjr01 CLIPPED,"_errlist.log"
   LET l_errlist_path = os.Path.join(FGL_GETENV("TEMPDIR"),l_errlist_file)
   LET g_errlist_ch = base.Channel.create()
   CALL g_errlist_ch.openFile(l_errlist_path, "w")
   #End:FUN-BA0031 by Hiko

   START REPORT GPRebuild_log TO l_name

   FOREACH rebuild_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         DISPLAY "Error: Error in output Report, Please redo once or contact with MIS!"
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT GPRebuild_log(sr.*)
   END FOREACH

   FINISH REPORT GPRebuild_log
   CLOSE rebuild_cs

   CALL g_errlist_ch.close() #FUN-BA0031 by Hiko
   #NO:FUN-C60110--start--
   IF os.Path.separator() = "/" THEN
     RUN  "chmod 777 " || l_name CLIPPED || " 2>/dev/null"
   ELSE
     RUN "attrib -r " || l_name CLIPPED || " >nul 2>nul"   
   END IF
   IF NOT os.Path.chdir(FGL_GETENV("DS4GL") || "/bin/GPRebuild") THEN
      DISPLAY "Path: ",FGL_GETENV("DS4GL") || "/bin/GPRebuild"," NOT FOUND"
      EXIT PROGRAM
   END IF
   #NO:FUN-C60110--end--
   # LET l_sql = FGL_GETENV("FGLRUN")," ",os.Path.join(FGL_GETENV("AZZi"),"p_view")," ",l_name CLIPPED #mark by FUN-C60110
   LET l_sql = FGL_GETENV("FGLRUN")," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("DS4GL"),"bin"),"GPRebuild"),"GPRebuild-view")," ",l_name CLIPPED #FUN-C60110
   #DISPLAY  l_sql #FUN-BA0031
   RUN l_sql WITHOUT WAITING

END FUNCTION

#當按查看記錄檔BUTTON   view時會把錯誤訊息寫到 GPRebuild_XX_errlist.log 寫到$TEMPDIR  by jrg542 #12/02/06
REPORT GPRebuild_log(sr)
   DEFINE sr      RECORD LIKE hjr_file.*
   DEFINE li_cnt_func   LIKE type_file.num10
   DEFINE li_cnt_mod    LIKE type_file.num10
   DEFINE ls_print_str  STRING #FUN-BA0031 by Hiko
   #hjr02:建置項目 C,L,F  #hjr03:建置模組  #hjr05:錯誤訊息

   ORDER EXTERNAL BY sr.hjr02,sr.hjr03

   FORMAT
      BEFORE GROUP OF sr.hjr02
         LET li_cnt_func = 0
         #Begin:FUN-BA0031 by Hiko
         #PRINT "==================================================================="
         LET ls_print_str = "==================================================================="
         PRINT ls_print_str
         CALL g_errlist_ch.writeLine(ls_print_str)
         #End:FUN-BA0031 by Hiko

      BEFORE GROUP OF sr.hjr03
         LET li_cnt_mod = 0

      ON EVERY ROW
         LET li_cnt_func = li_cnt_func + 1
         LET li_cnt_mod = li_cnt_mod + 1
         #Begin:FUN-BA0031 by Hiko
         IF sr.hjr08 IS NULL THEN #這是為了支援舊log資料
            #PRINT sr.hjr03, COLUMN 5, sr.hjr05 
            LET ls_print_str = sr.hjr03, COLUMN 5, sr.hjr05
         ELSE
            LET ls_print_str = sr.hjr02 CLIPPED, COLUMN 5, sr.hjr03 CLIPPED, COLUMN 11, sr.hjr08 CLIPPED
         END IF
         PRINT ls_print_str
         CALL g_errlist_ch.writeLine(ls_print_str)
         #End:FUN-BA0031 by Hiko
      AFTER GROUP OF sr.hjr03
         #Begin:FUN-BA0031 by Hiko
         #PRINT '== Error Count By Module:',li_cnt_mod USING "<<<<", " Row(s) =========="
         LET ls_print_str = "== Error Count By Module:",li_cnt_mod USING "<<<<", " Row(s) =========="
         PRINT ls_print_str
         CALL g_errlist_ch.writeLine(ls_print_str)
         #End:FUN-BA0031 by Hiko

      AFTER GROUP OF sr.hjr02
         #Begin:FUN-BA0031 by Hiko
         #PRINT '= Total Fail:',li_cnt_func USING "<<<<<", " Row(s) ==============="
         LET ls_print_str = "= Total Fail:",li_cnt_func USING "<<<<<", " Row(s) ==============="
         PRINT ls_print_str
         CALL g_errlist_ch.writeLine(ls_print_str)
         #End:FUN-BA0031 by Hiko

END REPORT

