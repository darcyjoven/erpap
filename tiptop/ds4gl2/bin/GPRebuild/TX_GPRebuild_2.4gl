# Prog. Version..: '5.10.00-07.05.10(00000)'     #
#
# Pattern name...: GPRebuild.4gl
# Descriptions...: TIPTOP GP 5.2 圖形化系統重建工具 (與5.1不同: 安全機制/使用GRW)
# Date & Author..: 07/03/29 Create by alex
# Modify.........: No.FUN-830038 08/03/11 By alex 修整為可令 UNIX執行
# Modify.........: No.FUN-830011 08/03/18 By alex 修改 r.l2依zz08解析
# Modify.........: No.FUN-830011 09/04/16 By alex 調整輸入介面
# Modify.........: No.FUN-A50097 10/05/19 By alex 調整簡易平行處理作法

IMPORT os
DATABASE ds

   DEFINE g_toppath       STRING          #TOP directory
   DEFINE g_custpath      STRING               #CUST directory
   DEFINE g_dummy03       LIKE type_file.chr1  #Rebuilding Area  Standard Cust 42X Both 編譯類別
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
   DEFINE g_select        DYNAMIC ARRAY of RECORD
             gao01_s         LIKE type_file.chr10
                          END RECORD
   DEFINE g_disable       DYNAMIC ARRAY of RECORD
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
   DEFINE g_processor     LIKE type_file.num5
   DEFINE g_ver           LIKE type_file.num5
   DEFINE g_42m           LIKE type_file.chr5
   DEFINE g_hjr01         LIKE hjr_file.hjr01   #建置ID 
   DEFINE g_db_type       LIKE type_file.chr3

MAIN

   DEFINE ls_argval       STRING
   DEFINE l_arg1          STRING
   DEFINE l_arg2          STRING

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   WHENEVER ERROR CONTINUE
   CLOSE WINDOW screen

   CALL GPRebuild_init()       #系統環境變數初始化
   DISPLAY "ARG1:",ARG_VAL(1) 
   DISPLAY "ARG2:",ARG_VAL(2) 

   --LET l_arg1 = "TOP='D:\TIPTOP' AREA='F' DIR='GAP' LOG='C:\rbld.txt'"  
   --LET l_arg2 = "TP" 
    
   IF ARG_VAL(1) IS NULL THEN  #未輸入參數
   --IF l_arg1 IS NULL THEN  #未輸入參數
      CALL GPRebuild_init_window()
      CALL GPRebuild_menu()
      CLOSE WINDOW w_GPRebuild
   ELSE  #當輸入參數後, 一律不再開window出來, 做為background
      IF ARG_VAL(2) = "TP" THEN
      --IF l_arg2 = "TP" THEN
         LET g_guimode    = FALSE
         LET g_background = TRUE
         --LET ls_argval = ARG_VAL(1)
         LET ls_argval = l_arg1

         CALL GPRebuild_background_init(ls_argval)
         CALL GPRebuild_process()
         CLOSE WINDOW w_GPRebuild
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
   CALL lw_win.setText(LSTR("TIPTOP GP5.X(TM) Rebuild Tool version:2.01 (C)2009,2010"))

   DISPLAY g_toppath,g_custpath,g_dummy03,g_du04_c,g_du04_l,g_du04_f,
           g_bgjob,g_processor,g_remove,g_sendmail,g_logfilepath,ls_tmp,ls_tmp
        TO FORMONLY.dummy01,FORMONLY.dummy02,FORMONLY.dummy03,
           FORMONLY.du04_c,FORMONLY.du04_l,FORMONLY.du04_f,
           FORMONLY.bgjob,FORMONLY.processor,FORMONLY.remove,FORMONLY.sendmail,FORMONLY.dummy06,FORMONLY.dummy07,FORMONLY.dummy08 

END FUNCTION


#系統環境變數初始化﹝由於本作業不引用
PRIVATE FUNCTION GPRebuild_init()

   DEFINE li_cnt     LIKE type_file.num10
   DEFINE lch_cmd    base.Channel 
   DEFINE l_str      STRING

   LET g_bgjob = "N"

   #系統環境變數
   LET g_toppath = FGL_GETENV("TOP")
   LET g_custpath = FGL_GETENV("CUST")
   LET g_cmd = FGL_GETENV("FGLRUN")," ",os.Path.join(FGL_GETENV("DS4GL"),"bin")
   LET g_db_type = db_get_database_type()

   LET g_dummy03 = "F"       #TIPTOP GP Full Area 全區目錄

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
   CALL GPRebuild_btn05_init() 

   #報表
   LET g_hjr01 = FGL_GETPID()
   SELECT COUNT(*) INTO li_cnt FROM hjr_file WHERE hjr01 = g_hjr01
   IF li_cnt > 0 THEN
      DELETE FROM hjr_file WHERE hjr01 = g_hjr01
   END IF
   LET g_logfilepath = os.Path.join(FGL_GETENV("TEMPDIR"),"GPRebuild_"|| g_hjr01 CLIPPED||".log")
   LET g_remove = "N"
   LET g_sendmail = "N"

   LET lch_cmd = base.Channel.create()
   CALL lch_cmd.openPipe("fglWrt -a cpu", "r")
   IF lch_cmd.read(l_str) THEN
      LET g_processor = l_str
   END IF
   IF g_processor <= 0 THEN LET g_processor = 2 END IF
   #IF g_processor > 16 THEN LET g_processor = 16 END IF
   IF g_processor >= 16 THEN LET g_processor = 2 END IF

END FUNCTION



PRIVATE FUNCTION GPRebuild_menu()
   DEFINE ls_message      STRING
   DEFINE li_total        LIKE type_file.num5
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE l_ac_d,l_ac_s   LIKE type_file.num5
   DEFINE l_action        STRING
   DEFINE l_toppath_o     STRING          #TOP directory
   DEFINE l_custpath_o    STRING               #CUST directory
   DEFINE l_dummy03_o     LIKE type_file.chr1  #Rebuilding Area  Standard Cust Both

   LET l_toppath_o = g_toppath
   LET l_custpath_o = g_custpath
   LET l_dummy03_o = g_dummy03

   WHILE TRUE
   DIALOG ATTRIBUTE(UNBUFFERED=TRUE, FIELD ORDER FORM)

      INPUT g_dummy03,g_toppath,g_custpath,g_du04_c,g_du04_l,g_du04_f,
            g_logfilepath,g_processor 
       FROM dummy03,dummy01,dummy02,du04_c,du04_l,du04_f,
            dummy06,processor 
       ATTRIBUTE(WITHOUT DEFAULTS =TRUE)

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
       
         AFTER INPUT            
            CALL GPRebuild_btn04()
      END INPUT

      DISPLAY ARRAY g_disable TO s_disable.*
          BEFORE DISPLAY
             CALL DIALOG.setCurrentRow("s_disable",l_ac_d)

          BEFORE ROW
             LET l_ac_d = DIALOG.getCurrentRow("s_disable")

          ON ACTION btn_select   #select  
             LET l_action = "btn_select"
             EXIT DIALOG

          ON ACTION accept
             LET l_action = "btn_select"
             EXIT DIALOG

      END DISPLAY

      DISPLAY ARRAY g_select TO s_select.*
          BEFORE DISPLAY
             CALL DIALOG.setCurrentRow("s_select",l_ac_s)

          BEFORE ROW
             LET l_ac_s = DIALOG.getCurrentRow("s_select")

          ON ACTION btn_disable
             LET l_action = "btn_disable"
             EXIT DIALOG

          ON ACTION accept
             LET l_action = "btn_disable"
             EXIT DIALOG

      END DISPLAY

      ON ACTION do_action           #execution 執行編譯
         LET l_action = "do_action"
         EXIT DIALOG

      ON ACTION output
         CALL GPRebuild_outmenu()

      ON ACTION btn_selall
         IF l_dummy03_o <> g_dummy03 THEN
            CALL GPRebuild_btn05_init() 
	    LET l_dummy03_o = g_dummy03
         END IF
         LET l_action = "btn_selall"
         EXIT DIALOG

      ON ACTION btn_disall
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
      WHEN "do_action"
         LET g_workcnt = g_select.getLength()  #選哪些模組
         IF NOT g_workcnt AND NOT g_du04_s AND NOT g_du04_s THEN EXIT CASE END IF
         LET g_dummy05 = ""
         FOR li_cnt = 1 TO g_workcnt 
            LET g_dummy05 = g_dummy05," ",g_select[li_cnt].gao01_s CLIPPED
         END FOR
         CALL GPRebuild_process()
         DISPLAY gt_end TO FORMONLY.dummy08
         LET ls_message = "Rebuild Finish.Total Spent Time:",gt_end - gt_start," \n\n",
                          "Error Log File: ",os.Path.rootname(g_logfilepath),".err \n",
                          "Detail Log File: ",g_logfilepath
         CALL GPRebuild_msg(ls_message)

      WHEN "btn_selall"
         LET li_total = g_select.getLength()
         IF g_disable.getLength() > 0 THEN
            FOR li_cnt = 1 TO g_disable.getLength()
               LET g_select[li_total + li_cnt].gao01_s = g_disable[li_cnt].gao01_d
            END FOR
            CALL g_disable.clear()
         END IF

      WHEN "btn_select"
         IF g_disable.getLength() >= 1 THEN    #module
            LET li_total = g_select.getLength()
            LET g_select[li_total + 1].gao01_s = g_disable[l_ac_d].gao01_d
            CALL g_disable.deleteElement(l_ac_d)
         END IF

      WHEN "btn_disable"
         IF g_select.getLength() >= 1 THEN
            LET li_total = g_disable.getLength()
            LET g_disable[li_total + 1].gao01_d = g_select[l_ac_s].gao01_s
            CALL g_select.deleteElement(l_ac_s)
         END IF

      WHEN "btn_disall"
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
   CALL GPRebuild_msg_gen(ls_message)

   MENU ""
      COMMAND "OK !" EXIT MENU 

   END MENU

   CLOSE WINDOW w_mseg01
   
END FUNCTION


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
   DISPLAY "Usage:   %FGLRUN% GPRebuild \"Execute_Condition\" \"TP\""
   DISPLAY "Sample0: %FGLRUN% GPRebuild \"\" \"TP\""
   DISPLAY "Sample1: %FGLRUN% GPRebuild \"TOP=\'D:\\TIPTOP\' AREA=\'T\'\" \"TP\""
   DISPLAY "Sample2: %FGLRUN% GPRebuild \"TOP=\'D:\\TIPTOP\' AREA=\'F\' LOG=\'C:\\rbld.txt\' \"TP\""
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

   LET li_check = TRUE
   #TOP
   IF ls_tmp.getIndexOf("TOP='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("TOP='",1)
      LET g_toppath = ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1)
      IF NOT os.Path.exists(g_toppath) THEN
         DISPLAY "Error: TOP Path Not Exists:",g_toppath
         CALL GPRebuild_background_explain()
      END IF
      LET g_cmd = os.Path.join(g_toppath,"msv")
      LET li_check = FALSE
   END IF

   #CUST
   IF ls_tmp.getIndexOf("CUST='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("CUST='",1)
      LET g_custpath = ls_tmp.subString(li_pos+6,ls_tmp.getIndexOf("'",li_pos+7)-1)
      IF NOT os.Path.exists(g_custpath) THEN
         DISPLAY "Error: CUST Path Not Exists:",g_custpath
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF

   #AREA
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

   #ITEM
   IF ls_tmp.getIndexOf("ITEM='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("ITEM='",1)
      LET ls_tmp1 = ls_tmp.subString(li_pos+6,ls_tmp.getIndexOf("'",li_pos+7)-1)
      IF ls_tmp1.getIndexOf("C",1) THEN LET g_du04_c = 1 END IF
      IF ls_tmp1.getIndexOf("L",1) THEN LET g_du04_l = 1 END IF
      IF ls_tmp1.getIndexOf("F",1) THEN LET g_du04_f = 1 END IF
      IF g_du04_c + g_du04_l + g_du04_f = 0 THEN
         DISPLAY "Error: ITEM Type Not Exists:",ls_tmp1
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF
   
   #DIR
   IF ls_tmp.getIndexOf("DIR='",1) THEN
      LET li_pos = ls_tmp.getIndexOf("DIR='",1)
      LET g_dummy05 = ls_tmp.subString(li_pos+5,ls_tmp.getIndexOf("'",li_pos+6)-1)
      IF g_dummy05.getLength() < 3 THEN
         DISPLAY "Error: Parameters of DIR Not Exists:",g_dummy05
         CALL GPRebuild_background_explain()
      END IF
      LET li_check = FALSE
   END IF

   #LOG
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
      IF ls_tmp1 = "0" THEN
         CALL GPRebuild_init_window()
         DISPLAY g_toppath,g_custpath,g_dummy03,g_du04_c,g_du04_l,g_du04_f,
                 g_dummy05,g_logfilepath
              TO FORMONLY.dummy01,FORMONLY.dummy02,FORMONLY.dummy03,FORMONLY.du04_c,FORMONLY.du04_l,FORMONLY.du04_f,
                 FORMONLY.dummy05,FORMONLY.dummy06  
      END IF
   END IF

   IF li_check THEN DISPLAY "Warning: No Any Parameters Been Sat, Using Default Values." END IF

END FUNCTION

PRIVATE FUNCTION GPRebuild_process()

   DEFINE ls_temp    STRING

   LET g_progs02 = 0   #program(01) start from 1, module(02) start from 0 
   LET gt_start = CURRENT HOUR TO SECOND 
   IF g_guimode THEN
      DISPLAY gt_start TO FORMONLY.dummy07
   END IF

   CASE g_dummy03
      WHEN "T" LET ls_temp = " TIPTOP GP Standard Area"
      WHEN "C" LET ls_temp = " TIPTOP GP Customized Area"
      WHEN "S" LET ls_temp = " TIPTOP GP 42x System Only"
      WHEN "F" LET ls_temp = " TIPTOP GP Full Area"
   END CASE
   LET g_message[1] = "Rebuild Aimd Area:",ls_temp

   IF g_du04_c THEN
      LET ls_temp = ls_temp, ", Compile 4gl "
   END IF
   IF g_du04_f THEN
      LET ls_temp = ls_temp, ", Compile per "
   END IF
   IF g_du04_l THEN
      LET ls_temp = ls_temp, ", Link Programs "
   END IF
   LET ls_temp = ls_temp.subString(2,ls_temp.getLength())     
   
   LET g_message[2] = "Rebuild Aimd Function:",ls_temp  

   IF g_du04_s = 1 THEN
      CALL GPRebuild_process_rs2ds()       # r.s2 ds
   END IF
   IF g_du04_t = 1 THEN
      CALL GPRebuild_process_rebuildtool() # rebuild_tool ds4gl2/bin 及 ora/4gl
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

   CASE 
      WHEN g_dummy03 = "T"
         LET ls_path = g_toppath.trim()
         CALL GPRebuild_process_working(ls_path)
      WHEN g_dummy03 = "C"
         LET ls_path = g_custpath.trim()
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
   
   LET li_h = os.Path.diropen(ls_path) #所有目錄  
   WHILE li_h > 0
      LET ls_child = os.Path.dirnext(li_h)
      LET ls_child = ls_child.trim()
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
      IF NOT g_dummy05.getIndexOf(" "||ls_child.trim(),1) THEN
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

      CALL GPRebuild_process_dir(ls_target) RETURNING li_cnt
      IF g_jobnow = "C" THEN
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
  
   CALL os.Path.dirsort("name", 1)
   LET li_h = os.Path.diropen(ls_path)
   IF NOT os.Path.chdir(ls_path) THEN
      DISPLAY "Error: Cannot change to ",ls_path.trim()
      RETURN 0
   END IF

   #取模組名
   LET l_mod = os.Path.dirname(ls_path)
   LET l_mod = UPSHIFT(os.Path.basename(l_mod))
   
   # Count File
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
   LET g_progs01 = li_cnt 
   WHILE li_h > 0
      IF INT_FLAG THEN CALL GPRebuild_suspend() END IF
      LET ls_child = os.Path.dirnext(li_h)
      IF ls_child IS NULL THEN EXIT WHILE END IF
      IF ls_child == "." OR ls_child == ".." THEN CONTINUE WHILE END IF
     
      CASE 
         WHEN g_jobnow = "C"
            IF os.path.extension(ls_child) = "4gl" THEN
               LET ls_temp = "Compile 4gl: ",os.path.rootname(ls_child),
	                     " ( ",g_progs01 USING "##&","/",li_filecnt USING "##&",")",
			     (g_progs01 * 100 / li_filecnt) USING "##&.&&","%"
	       IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF
	       IF NOT g_background THEN DISPLAY ls_temp END IF

               LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42m ",
	                    os.path.rootname(ls_child)," tiptop"
               CALL GPRebuild_process_execute(g_jobnow,l_mod,li_cnt,ls_cmd)
               LET li_cnt = li_cnt + 1
            END IF

         WHEN g_jobnow = "F"    #因應新板 gsform可以一次輸入多個畫面檔 (節省讀取sch檔時間)並加入平行作業概念
                                #取消在此執行指令, 只做組字串
            IF os.path.extension(ls_child) = "4fd" THEN
               LET ls_temp = "Compile 4fd: ",os.path.rootname(ls_child),
	                     " ( ",g_progs01 USING "##&","/",li_filecnt USING "##&",")",
			     (g_progs01 * 100 / li_filecnt) USING "##&.&&","%"
	       IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF
	       IF NOT g_background THEN DISPLAY ls_temp END IF
               LET li_pos = li_cnt MOD g_processor + 1
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
      FOR li_pos = 1 TO g_processor 
         LET ls_temp = l_file[li_pos]
         LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42f '",ls_temp.subString(2,ls_temp.getLength()),"' tiptop"
         CALL GPRebuild_process_execute("F",l_mod,li_pos,ls_cmd)
      END FOR
   END IF

   RETURN li_cnt
END FUNCTION

PRIVATE FUNCTION GPRebuild_process_execute(l_hjr02,l_hjr03,l_hjr04,ls_cmd)

   DEFINE l_hjr02     LIKE hjr_file.hjr02   #建置項目 C,L,F  
   DEFINE l_hjr03     LIKE hjr_file.hjr03   #建至模組 
   DEFINE l_hjr04     LIKE hjr_file.hjr04   #建置序號 
   DEFINE ls_cmd      STRING                #指令
   DEFINE ls_run      STRING
   DEFINE l_hjr07     LIKE hjr_file.hjr07   #start time

   LET ls_run = '"',g_hjr01 CLIPPED,'" "',l_hjr02 CLIPPED,'" "',l_hjr03 CLIPPED,
                '" ',l_hjr04 USING "<<<<<<<",' "',ls_cmd.trim(),'"'
   LET l_hjr07 = TODAY USING "yyyy-mm-dd"," ",gt_start 

   INSERT INTO hjr_file(hjr01,hjr02,hjr03,hjr04,hjr07)
    VALUES(g_hjr01,l_hjr02,l_hjr03,l_hjr04,l_hjr07)

   LET ls_run = FGL_GETENV("FGLRUN")," ",FGL_GETENV("DS4GL"),os.Path.separator(),"bin",os.Path.separator(),
                "GPRebuild",os.Path.separator(),"GPRebuild-itm ",ls_run

   IF os.Path.separator() = "/" THEN
      LET ls_run = ls_run," 2>&1"
   END IF

   IF l_hjr04 MOD g_processor = 0 THEN
      RUN ls_run
   ELSE
      RUN ls_run WITHOUT WAITING
   END IF
 
   RETURN
   
END FUNCTION


PRIVATE FUNCTION GPRebuild_process_42x(ls_module)

   DEFINE ls_module    STRING
   DEFINE ls_cmd       STRING

   IF ls_module.subString(1,1) = "c" THEN LET ls_module = ls_module.subString(2,ls_module.getLength()) END IF
   LET ls_cmd = g_cmd.trim(),os.path.separator(),"gen42r ",ls_module.trim()," tiptop"
   CALL GPRebuild_process_execute("X",ls_module,"1",ls_cmd)

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
   LET ls_srcpath = os.Path.join(ls_srcpath,g_db_type CLIPPED)

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
   DEFINE lc_child      LIKE type_file.chr50    #FUN-830011
   DEFINE li_filecnt    LIKE type_file.num10
   DEFINE li_cnt        LIKE type_file.num10
   DEFINE li_s,li_e     LIKE type_file.num10
   DEFINE ls_temp       STRING

   LET lc_module = UPSHIFT(lc_module CLIPPED)
   SELECT COUNT(*) INTO li_filecnt FROM zz_file WHERE zz011 = lc_module 

   DECLARE gprbd_zz011_cs CURSOR FOR
     SELECT zz08 FROM zz_file
      WHERE zz011 = lc_module AND zz08 IS NOT NULL

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
         LET lc_child = ls_temp.subString(li_s,li_e)
      ELSE
         LET lc_child = ls_temp.subString(li_s,li_e-1)
      END IF

      LET ls_temp = "Link Program: ",lc_child CLIPPED,
                    " ( ",li_cnt USING "##&","/",li_filecnt USING "##&",")",
       	     (li_cnt * 100 / li_filecnt) USING "##&.&&","%"
      IF g_guimode THEN DISPLAY ls_temp to FORMONLY.curr01 END IF
      IF NOT g_background THEN DISPLAY ls_temp END IF

      LET ls_temp = g_cmd.trim(),os.path.separator(),"gen42r ",lc_child CLIPPED," tiptop"
      CALL GPRebuild_process_execute("L",lc_module,li_cnt,ls_temp)

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

   CLOSE WINDOW w_GPRebu_om
END FUNCTION

#查看報告的功能
PRIVATE FUNCTION GPRebuild_output(l_hjr01)

   DEFINE l_sql   STRING
   DEFINE sr      RECORD LIKE hjr_file.*
   DEFINE l_hjr01 LIKE hjr_file.hjr01
   DEFINE l_name  STRING

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

   LET l_sql = FGL_GETENV("FGLRUN")," ",os.Path.join(FGL_GETENV("AZZi"),"p_view")," ",l_name CLIPPED
   RUN l_sql WITHOUT WAITING

END FUNCTION


REPORT GPRebuild_log(sr)

   DEFINE sr      RECORD LIKE hjr_file.*
   DEFINE li_cnt_func   LIKE type_file.num10
   DEFINE li_cnt_mod    LIKE type_file.num10

   ORDER EXTERNAL BY sr.hjr02,sr.hjr03

   FORMAT
      BEFORE GROUP OF sr.hjr02
         LET li_cnt_func = 0
         PRINT "==================================================================="

      BEFORE GROUP OF sr.hjr03
         LET li_cnt_mod = 0

      ON EVERY ROW
         LET li_cnt_func = li_cnt_func + 1
         LET li_cnt_mod = li_cnt_mod + 1
         PRINT sr.hjr03, COLUMN 5, sr.hjr05

      AFTER GROUP OF sr.hjr03
         PRINT '== Error Count By Module:',li_cnt_mod USING "<<<<", " Row(s) =========="

      AFTER GROUP OF sr.hjr02
         PRINT '= Total Fail:',li_cnt_func USING "<<<<<", " Row(s) ==============="

END REPORT

