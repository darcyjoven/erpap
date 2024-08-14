# Prog. Version..: '5.30.01-12.03.23(00003)'     #
#
# Pattern name...: GPRebuild_view.4gl
# Descriptions...: Report Viewer for TIPTOP
# Date & Author..: 12/03/27 By madey (copy from p_view)
# Modify.........: No.FUN-C60110 12/06/25 By laura action中文由 GPRebuild-view.4ad載入

IMPORT os        
DATABASE ds

CONSTANT MAX_LINE   INTEGER = 660

GLOBALS
DEFINE   g_idle_seconds    LIKE type_file.num5   #INPUT or INPUT ARRAY 時允許Idle的秒數
DEFINE g_page_line  LIKE type_file.num5   #Report lines for each page
END GLOBALS


DEFINE g_content    STRING,                # Page Content
       g_filename   STRING,                # Report File Name(Original One)
       g_report     STRING,                # Report File Name(After Process)
       g_curr_page  LIKE type_file.num10,  # Current Page Number
       g_total_page LIKE type_file.num10,  # Total Pages 
       g_total_line LIKE type_file.num10,  # Total Lines of Report
       g_showline   LIKE type_file.num10   # Show Line Number or not
DEFINE g_error_line LIKE type_file.num10   # indicate where possibly contains invalid character 

MAIN
   DEFINE l_ch               base.Channel
   DEFINE l_cmd              STRING
   DEFINE l_status           LIKE type_file.num10   
   DEFINE l_window           ui.Window
   DEFINE l_i                LIKE type_file.num10   
   DEFINE l_buf              STRING                 
   DEFINE prog_idle_seconds  LIKE type_file.num10   
   DEFINE l_report           STRING                 
   DEFINE l_tok              base.StringTokenizer   
   DEFINE lw_win             ui.Window
  
 
   
    OPTIONS
       INPUT NO WRAP
       DEFER INTERRUPT                # Supress DEL key function
    WHENEVER ERROR CONTINUE
    
    #NO:FUN-C60110--start--
    CALL ui.Interface.loadActionDefaults("GPRebuild-view")    
    #NO:FUN-C60110--end--
    LET g_filename = ARG_VAL(1)    # Report File Name

    IF g_filename IS NULL THEN
       DISPLAY "You need to specify a report file as parameter."
       EXIT PROGRAM
    END IF

    LET prog_idle_seconds = ARG_VAL(3)    # Program Idle Seconds
 
    IF NOT os.Path.exists(g_filename CLIPPED) THEN
       DISPLAY "Report file doesn't exist."
       EXIT PROGRAM
    END IF
 
    IF prog_idle_seconds IS NOT NULL THEN     
       LET g_idle_seconds = prog_idle_seconds
    END IF                                     

   # OPEN WINDOW p_view_w WITH FORM "azz/42f/p_view"
    OPEN WINDOW w_GPRebuild_view WITH FORM "GPRebuild-view"
   #    ATTRIBUTE(STYLE="reportViewer")
   CLOSE WINDOW screen    #laura
   LET lw_win = ui.Window.getCurrent()
    CALL lw_win.setText(LSTR("TIPTOP GP5.2X(TM) Rebuild Tool version:2.01 (C)2009,2010"))
    
# Adding Delimiter to End of Report File(Temporary)
    
    LET g_report = g_filename CLIPPED, ".tmp"
    LET l_report = g_filename CLIPPED,".bak"
    IF os.Path.separator() = "/" THEN 
       LET l_cmd = "cat ", g_filename CLIPPED, " | sed -e 's/$//' > ", g_report
    ELSE
       LET l_cmd = "cat ", g_filename CLIPPED, " > ", l_report
       RUN l_cmd 
       LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),   
                   ' "$" "" ', l_report ," ", g_report
    END IF
    RUN l_cmd
   
    IF os.Path.chrwx(g_report,511) THEN #chmod 777 => 7*8^2 +7*8^1 +7*8^
    END IF

# Calculate Total Lines of Report
    LET l_ch = base.Channel.create()
    # Unset LANG locale setting before counter line numbers
   
    IF os.Path.separator() = "/" THEN 
       LET l_cmd = "unset LANG; wc -l ", g_report CLIPPED, " | awk ' { print $1 }'"
       CALL l_ch.openPipe(l_cmd, "r")
       WHILE l_ch.read(g_total_line)
       END WHILE
    ELSE
       #無法使用 awk，則改自行抓取第一個值
       LET l_cmd = "wc -l ", g_report CLIPPED, " > ", l_report
       RUN l_cmd
       CALL l_ch.openFile(l_report, "r")
       WHILE l_ch.read(l_buf)
             LET l_tok = base.StringTokenizer.createExt(l_buf.trim()," ","",TRUE)
             WHILE l_tok.hasMoreTokens()
                   LET g_total_line=l_tok.nextToken()
                   EXIT WHILE
             END WHILE          
       END WHILE
    END IF

    CALL l_ch.close()  

# Check if any line contains invalid character
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

    IF ARG_VAL(2) IS NULL THEN
       LET g_page_line = 66
    ELSE
       IF ARG_VAL(3) = '1' THEN
          LET g_page_line = g_total_line
       ELSE
          CASE
              WHEN ( ( ARG_VAL(2) <= MAX_LINE ) AND ( ARG_VAL(2) > g_total_line ) ) OR
                   ( ( ARG_VAL(2) > MAX_LINE ) AND ( g_total_line <= MAX_LINE ) )
                   LET g_page_line = g_total_line
              WHEN ( ARG_VAL(2) <= MAX_LINE ) AND ( ARG_VAL(2) <= g_total_line )
                   LET g_page_line = ARG_VAL(2)
              WHEN ( ARG_VAL(2) > MAX_LINE ) AND ( g_total_line > MAX_LINE )
                   LET g_page_line = MAX_LINE
              OTHERWISE
                   LET g_page_line = MAX_LINE
          END CASE
       END IF
    END IF

    LET l_window = ui.Window.getCurrent()
    CALL l_window.setText(g_filename)
    CALL GPRebuild_view_showPage()

    CALL os.Path.delete(g_report) RETURNING l_status   # Remove Temporary File 
    CALL os.Path.delete(l_report) RETURNING l_status   # Remove Temporary File 
END MAIN
 

FUNCTION GPRebuild_view_showPage()
    DEFINE l_page LIKE type_file.num10  

    CALL GPRebuild_view_calculatePage()
    LET g_showline = 0

    WHILE TRUE

        CALL GPRebuild_view_loadPage()
 
        LET l_page = g_curr_page
        INPUT g_content, l_page WITHOUT DEFAULTS
              FROM FORMONLY.content, FORMONLY.curr
              ATTRIBUTE(UNBUFFERED)

            BEFORE INPUT
                DISPLAY g_total_page TO FORMONLY.total
                CALL GPRebuild_view_disableAction(DIALOG)
               
              # Prompt which line might contain invalid character
                IF g_error_line != 0 THEN
                   DISPLAY "error:","Illegal character found in the first line %1 in the report file!"
                   LET g_error_line = 0   #Shows in first time
                END IF

            AFTER FIELD curr
# Change Current Display Page, MUST Equal to/Less than Total Pages
                IF g_curr_page != l_page THEN
                   IF ( l_page <= 0 ) OR ( l_page > g_total_page ) THEN
                      LET l_page = g_curr_page
                   ELSE
                      LET g_curr_page = l_page
                      EXIT INPUT
                   END IF
                END IF
            
           ON IDLE 30 
           #CALL cl_on_idle()
           CONTINUE INPUT   

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

            ON ACTION option       # Options for Line setting
                IF GPRebuild_view_lineOption() THEN
                   EXIT INPUT
                END IF
        END INPUT
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           EXIT WHILE
        END IF
    END WHILE
END FUNCTION


FUNCTION GPRebuild_view_loadPage()
    DEFINE l_ch           base.Channel,
           l_buf          STRING
    DEFINE l_i            LIKE type_file.num10  
    DEFINE l_offset_begin LIKE type_file.num10, 
           l_offset_end   LIKE type_file.num10  
    DEFINE l_str          STRING


    LET g_content = NULL   # Initialize Page Content
    LET l_i = 0

# Calculate Offset for this Page of Report; Begin Line & End Line
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


FUNCTION GPRebuild_view_disableAction(pd_dialog)
    DEFINE pd_dialog ui.Dialog
     
       CALL pd_dialog.setActionHidden("accept", TRUE)

# If on First Page, disable "First_Page" & "Prev_Page" Action
    IF g_curr_page = 1 THEN
       CALL pd_dialog.setActionActive("first_page", FALSE)
       CALL pd_dialog.setActionActive("prev_page", FALSE)
    END IF

# If on Last Page, disable "Lastt_Page" & "Next_Page" Action
    IF g_curr_page = g_total_page THEN
       CALL pd_dialog.setActionActive("last_page", FALSE)
       CALL pd_dialog.setActionActive("next_page", FALSE)
    END IF
###
END FUNCTION

FUNCTION GPRebuild_view_calculatePage()
    LET g_curr_page = 1
    LET g_total_page = g_total_line / g_page_line
    IF (g_total_line MOD g_page_line) THEN
       LET g_total_page = g_total_page + 1
    END IF
END FUNCTION


FUNCTION GPRebuild_view_lineOption()
    DEFINE l_line   LIKE type_file.num10 
    DEFINE l_status LIKE type_file.num10 
    DEFINE l_msg    STRING               
 
 
    LET l_status = FALSE
    MENU "" ATTRIBUTE(STYLE = "popup")
         ON IDLE 30   
       #    #CALL cl_on_idle()
         CONTINUE MENU        

         ON ACTION line1
             WHILE TRUE
                 LET l_line = g_page_line
                 LET l_msg = "Number of Lines Per Page", "(Max = ", MAX_LINE USING '<<<', ") "
                 PROMPT l_msg FOR l_line
                        ATTRIBUTE(WITHOUT DEFAULTS)
                        ON IDLE 30   
                      #   #CALL cl_on_idle()    
                 END PROMPT
              
                 IF INT_FLAG THEN
                    LET INT_FLAG = FALSE
                    EXIT WHILE
                 ELSE
                    IF g_page_line != l_line THEN
                       IF ( l_line <= 0 ) OR ( l_line > MAX_LINE ) THEN
                          CONTINUE WHILE
                       ELSE
                          IF l_line > g_total_line THEN
                             LET g_page_line = g_total_line
                          ELSE
                             LET g_page_line = l_line
                          END IF
                          CALL GPRebuild_view_calculatePage()
                          LET l_status = TRUE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 END IF
             END WHILE
             EXIT MENU

         ON ACTION line2
             IF g_showline THEN
                LET g_showline = 0
             ELSE
                LET g_showline = 1
             END IF
             LET l_status = TRUE
             EXIT MENU
    END MENU
    RETURN l_status
END FUNCTION

