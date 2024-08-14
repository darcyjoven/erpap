##################################################
# Description  	: Download/Upload File
# Date & Author : 2008/12/01 By alexstar
# Parameter   	: 
# Return   	: 
# Memo        	: Only can be used in Genero 2.0 upward
##################################################
IMPORT os
DATABASE ds

DEFINE g_argv1    STRING
DEFINE g_argv2    STRING
DEFINE g_status   LIKE type_file.num10
DEFINE gs_result  STRING
DEFINE gs_location  STRING
DEFINE g_lang     CHAR(1)

MAIN
   DEFINE   p_row,p_col    SMALLINT

   WHENEVER ERROR CONTINUE

   LET p_row = 1 LET p_col = 8
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   CLOSE WINDOW screen
   OPEN WINDOW transfer_file AT p_row,p_col WITH 5000 ROWS, 200 COLUMNS

   LET g_lang = '0'
   
   CALL p_status_welcome() RETURNING gs_result
   DISPLAY gs_result at 10,10

   WHILE TRUE

     IF g_lang = "0" THEN GOTO: lang_0 END IF

     LABEL lang_1: 

     MENU ""
       COMMAND "D.Download_file to Windows"
         CALL gdc_download_file(g_argv1) 

       COMMAND "U.Upload file from Windows to TIPTOP"
         CALL gdc_upload_file(g_argv1) 

       COMMAND "L.Change to Chinese"
         LET g_lang = "0"
         LET gs_result = ""
         CALL p_status_welcome() RETURNING gs_result
         DISPLAY gs_result at 10,10
         CONTINUE WHILE
  
       COMMAND "X.Exit The Program"
         EXIT WHILE

       COMMAND KEY(INTERRUPT)
         EXIT WHILE

     END MENU

     LABEL lang_0:

     MENU ""
       COMMAND "D.下載檔案到 Windows"
         CALL gdc_download_file(g_argv1) 

       COMMAND "U.從 Windows 上傳檔案到 TIPTOP"
         CALL gdc_upload_file(g_argv1) 

       COMMAND "L.切換成英文"
          LET g_lang = "1"
          LET gs_result = ""
          CALL p_status_welcome() RETURNING gs_result
          DISPLAY gs_result at 10,10
          CONTINUE WHILE

       COMMAND "X.結束程式"
         EXIT WHILE

       COMMAND KEY(INTERRUPT)
         EXIT WHILE

     END MENU
   END WHILE 

   CLOSE WINDOW transfer_file
   EXIT PROGRAM
   
END MAIN  

FUNCTION gdc_download_file(p_source)
  DEFINE p_source      STRING
  DEFINE p_destination STRING
  DEFINE lch_ch        base.Channel
  DEFINE ls_str        STRING
  DEFINE l_chkstatus   SMALLINT

  IF cl_null(p_source) THEN
     IF g_lang = "0" THEN 
       LET ls_str = "檔案位置(Server端/TIPTOP端)"
     ELSE
       LET ls_str = "File Location(Server side/TIPTOP side):"
     END IF
     WHILE TRUE
       PROMPT ls_str CLIPPED FOR p_source 
           ATTRIBUTE(WITHOUT DEFAULTS)

           ON ACTION accept
               EXIT WHILE

           ON ACTION cancel
               LET p_source = ""
               EXIT WHILE

       END PROMPT
     END WHILE
  END IF 

  IF p_source.getIndexOf("$", 1) THEN
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("echo \"" || p_source CLIPPED || "\"", "r")
     WHILE lch_ch.read(p_source)
     END WHILE 
     CALL lch_ch.close()
  END IF

  IF NOT cl_null(p_source) THEN
    LET p_destination = os.Path.basename(p_source)
    LET p_destination = "C:\\",p_destination
  ELSE
    IF g_lang = "0" THEN 
      ERROR "動作取消!檔案是空的!!" ATTRIBUTE (RED)
    ELSE
      ERROR "Canceled!! File name is empty!" ATTRIBUTE (RED)
    END IF
    RETURN
  END IF

  CALL check_file_priviledge(p_source,0) RETURNING l_chkstatus
  IF NOT l_chkstatus THEN RETURN END IF
  
  CALL FGL_PUTFILE(p_source,p_destination)
  IF STATUS THEN
     IF g_lang = "0" THEN 
       MESSAGE "下載失敗!" ATTRIBUTE (RED)
     ELSE
       MESSAGE "Download failed!" ATTRIBUTE (RED)
     END IF
  ELSE
     IF g_lang = "0" THEN 
       MESSAGE "下載成功!" ATTRIBUTE (BLUE) 
     ELSE
       MESSAGE "Download successfully!" ATTRIBUTE (BLUE) 
     END IF
  END IF
END FUNCTION

FUNCTION gdc_upload_file(p_source)
  DEFINE p_source      STRING
  DEFINE p_destination STRING
  DEFINE lch_ch        base.Channel
  DEFINE ls_str        STRING
  DEFINE l_chkstatus   SMALLINT

  IF cl_null(p_source) THEN
     IF g_lang = "0" THEN 
       LET ls_str = "Windows檔案位置(使用者電腦端)"
     ELSE
       LET ls_str = "Windows File Location:(Client Side)"
     END IF
     WHILE TRUE
       PROMPT ls_str CLIPPED FOR p_source 
           ATTRIBUTE(WITHOUT DEFAULTS)

           ON ACTION accept
               EXIT WHILE

           ON ACTION cancel
               LET p_source = ""
               EXIT WHILE
           
           ON ACTION browsedocument
               LET p_source = to_browse_file()

       END PROMPT
     END WHILE
  END IF 

  IF NOT cl_null(p_source) THEN
    LET p_destination = os.Path.basename(p_source)
    IF os.Path.writable(FGL_GETENV("PWD")) THEN
       LET p_destination = FGL_GETENV("PWD") || "/" || p_destination
    ELSE 
       MESSAGE "No priviledge,using default '/tmp'" ATTRIBUTE (RED)
       LET p_destination = "/tmp/",p_destination
    END IF
  ELSE
    IF g_lang = "0" THEN 
      ERROR "動作取消!檔案是空的!!" ATTRIBUTE (RED)
    ELSE
      ERROR "Canceled!! File name is empty!" ATTRIBUTE (RED)
    END IF
    RETURN
  END IF

  CALL check_file_priviledge(p_destination,1) RETURNING l_chkstatus
  IF NOT l_chkstatus THEN RETURN END IF

  CALL FGL_GETFILE(p_source,p_destination)
  IF STATUS THEN
     IF g_lang = "0" THEN 
       MESSAGE "上傳失敗!" ATTRIBUTE (RED)
     ELSE
       MESSAGE "Upload failed!" ATTRIBUTE (RED)
     END IF
  ELSE
     IF g_lang = "0" THEN 
       MESSAGE "上傳成功!" ATTRIBUTE (BLUE) 
     ELSE
       MESSAGE "Upload successfully!" ATTRIBUTE (BLUE) 
     END IF
  END IF
END FUNCTION

FUNCTION cl_null(ps_source)    
  DEFINE   ps_source    STRING
  DEFINE   li_is_null   LIKE type_file.num5     

  IF (ps_source IS NULL) THEN
     LET li_is_null = TRUE
  ELSE
     LET ps_source = ps_source.trim()
     IF (ps_source.getLength() = 0) THEN
        LET li_is_null = TRUE
     END IF
  END IF

  RETURN li_is_null
END FUNCTION

FUNCTION p_status_welcome()
   DEFINE lw_window    ui.Window
   DEFINE ls_result    STRING
   DEFINE ls_each      STRING

   LET lw_window = ui.Window.getCurrent()
   LET ls_result = ""
   
   IF g_lang = "0" THEN
     LET ls_result = ASCII 10,ASCII 10,ASCII 10,
                     "歡迎使用 TIPTOP GP 5 檔案 上傳/下載 工具",ASCII 10,ASCII 10,
                     "鼎新電腦 @ 2007-2008",20 SPACES,
                     ASCII 10,ASCII 10,ASCII 10
     CALL lw_window.setText("TIPTOP GP 檔案傳輸工具")
   ELSE
     LET ls_result = ASCII 10,ASCII 10,ASCII 10,
                     "Welcome to Use TIPTOP GP 5 File download/upload Tool",ASCII 10,ASCII 10,
                     "Data Systems @ 2007-2008",20 SPACES,
                     ASCII 10,ASCII 10,ASCII 10
     CALL lw_window.setText("TIPTOP GP file transfer tool")
   END IF 

   LET ls_result=ls_result.trim(),ASCII 10,ASCII 10,ASCII 10,ASCII 10, ASCII 10
   RETURN ls_result
END FUNCTION

FUNCTION check_file_priviledge(p_filename,p_choice)
  DEFINE p_filename    STRING
  DEFINE p_choice      SMALLINT
  DEFINE l_filecheck   SMALLINT

  CASE p_choice
     WHEN 0   #Download
       CALL os.Path.exists(p_filename) RETURNING l_filecheck
       IF NOT l_filecheck THEN
          IF g_lang = "0" THEN 
             ERROR "檔案 '" || p_filename || "' 不存在!" ATTRIBUTE (RED)
          ELSE
             ERROR "File '" || p_filename || "' not existed!" ATTRIBUTE (RED)
          END IF
          RETURN FALSE
       ELSE
          CALL os.Path.readable(p_filename) RETURNING l_filecheck
          IF NOT l_filecheck THEN
             IF g_lang = "0" THEN 
                ERROR "您沒有權限讀取該檔案!" ATTRIBUTE (RED)
             ELSE
                ERROR "You have no right to read the file!" ATTRIBUTE (RED)
             END IF
             RETURN FALSE
          END IF    
       END IF

     WHEN 1   #Upload
       CALL os.Path.exists(p_filename) RETURNING l_filecheck
       IF l_filecheck THEN
          CALL os.Path.writable(p_filename) RETURNING l_filecheck
          IF NOT l_filecheck THEN
             IF g_lang = "0" THEN 
                ERROR "您沒有權限覆蓋該已存在的檔案!" ATTRIBUTE (RED)
             ELSE
                ERROR "You have no right to override the file!" ATTRIBUTE (RED)
             END IF
             RETURN FALSE
          END IF
       END IF
  END CASE

  RETURN TRUE
END FUNCTION

FUNCTION to_browse_file() 
  DEFINE ls_file   STRING

  CALL ui.Interface.frontCall("standard",
                              "openfile",
                              ["C:", "All Files", "*.*", "File Browser"],
                              [ls_file])
  IF STATUS THEN
     RETURN NULL
  END IF

  RETURN ls_file
END FUNCTION
