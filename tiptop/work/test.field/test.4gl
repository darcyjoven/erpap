# Prog. Version..: '5.00.05-01.02.12'     #
#
# Pattern name...: aimi109.4gl
# Descriptions...: 料件資料 FM
# Date & Author..: 94/11/21 By Roger
#
DATABASE ds

DEFINE 
    g_ima_arrno     SMALLINT,              #程式變數的個數
    g_ima_sarrno    SMALLINT,              #螢幕變數的個數
    g_ima_pageno    SMALLINT,              #頁數
    m_ima			RECORD LIKE ima_file.*,
    g_ima           ARRAY[400] of RECORD    #程式變數(Program Variables)
{%}     ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,   #品名
        ima06       LIKE ima_file.ima06,  
        ima08       LIKE ima_file.ima08,  
        arrow       CHAR(01) 
                    END RECORD,
    g_ima_t         RECORD                 #程式變數 (舊值)
{%}     ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,   #品名
        ima06       LIKE ima_file.ima06,  
        ima08       LIKE ima_file.ima08,  
        arrow       CHAR(01) 
                    END RECORD,
    g_log         CHAR(1),
    g_wc,g_sql    CHAR(300),
    g_cmd         CHAR(100),
    g_cnt,g_rec_b   SMALLINT,              #單身筆數
    l_ac            SMALLINT,              #目前處理的ARRAY CNT
    l_sl            SMALLINT               #目前處理的SCREEN LINE

MAIN
    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
    LET g_ima_arrno  = 400                 #變數ARRAY數
{%} LET g_ima_sarrno = 5                   #螢幕ARRAY數
    OPEN WINDOW test_w AT 3,2 WITH FORM "test"
        ATTRIBUTE(BORDER,CYAN)
        CALL i109_menu()    #中文
    CLOSE WINDOW test_w                 #結束畫面
END MAIN

FUNCTION i109_menu()
   MENU ""
      COMMAND "Q.查詢" HELP 32012  CALL i109_q() 
      COMMAND "B.修改" HELP 32007  CALL i109_b() 
      COMMAND "Esc.結束" EXIT MENU
      COMMAND KEY(esc) EXIT MENU
      COMMAND KEY(INTERRUPT) LET INT_FLAG=0
   END MENU
END FUNCTION


FUNCTION i109_q()
   CALL i109_b_askkey()
   LET g_ima_pageno = 0
   CALL i109_bp('D')
END FUNCTION

FUNCTION i109_b()
DEFINE
    l_ac_t          SMALLINT,              #未取消的ARRAY CNT
    l_n             SMALLINT,              #檢查重複用
    l_modify_flag   CHAR(1),               #單身更改否
    l_lock_sw       CHAR(1),               #單身鎖住否
    l_exit_sw       CHAR(1),               #Esc結束INPUT ARRAY 否
    p_cmd           CHAR(1),               #處理狀態
    l_insert        CHAR(01),              #可新增否
    l_update        CHAR(01),              #可更改否 (含取消)
    l_possible SMALLINT, #用來設定判斷重複的可能性
    l_jump          SMALLINT               #判斷是否跳過AFTER ROW的處理

    LET l_insert='Y'
    LET l_update='Y'

    DECLARE i109_bcl CURSOR FOR      # LOCK CURSOR
{%}     SELECT * FROM ima_file WHERE ima01=g_ima_t.ima01 FOR UPDATE

    LET l_ac_t = 0
    WHILE TRUE
        LET l_exit_sw = "y"                #正常結束,除非 ^N
        LET g_ima_pageno = 1
        INPUT ARRAY g_ima
            WITHOUT DEFAULTS
            FROM s_ima.*
            ATTRIBUTE (YELLOW)
            HELP 1
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
            IF l_ac < l_ac_t THEN
                let l_jump = 1
                NEXT FIELD arrow           #跳下一ROW
            ELSE
                LET l_ac_t = 0
                let l_jump = 0
            END IF
            LET l_modify_flag = 'N'        #DEFAULT
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_sl = SCR_LINE()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_ima_t.ima01 IS NOT NULL THEN
                LET p_cmd='u'
                OPEN i109_bcl               #表示更改狀態
                FETCH i109_bcl INTO m_ima.*
                IF STATUS THEN
                 LET l_lock_sw = "Y"
                ELSE
                LET g_ima[l_ac].ima01 = m_ima.ima01
                LET g_ima[l_ac].ima02 = m_ima.ima02
                LET g_ima[l_ac].ima021 = m_ima.ima021
                LET g_ima[l_ac].ima06 = m_ima.ima06
                LET g_ima[l_ac].ima08 = m_ima.ima08
                END IF
            ELSE
                LET p_cmd='a'  #輸入新資料
{%}             INITIALIZE g_ima[l_ac].* TO NULL  #900423
                INITIALIZE m_ima.* TO NULL  #900423
            END IF

            NEXT FIELD ima01
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
{%}             INITIALIZE g_ima[l_ac].* TO NULL      #900423
                INITIALIZE m_ima.* TO NULL  #900423
            LET g_ima_t.* = g_ima[l_ac].*         #新輸入資料
            DISPLAY g_ima[l_ac].* TO s_ima[l_sl].* ATTRIBUTE (YELLOW)
            DISPLAY '>' TO s_ima[l_sl].arrow ATTRIBUTE(REVERSE)

            NEXT FIELD ima01

        AFTER FIELD ima01                        #check 編號是否重複
            IF g_ima[l_ac].ima01 != g_ima_t.ima01 OR
               (g_ima[l_ac].ima01 IS NOT NULL AND g_ima_t.ima01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ima_file
                    WHERE ima01 = g_ima[l_ac].ima01
                IF l_n > 0 THEN
                    LET g_ima[l_ac].ima01 = g_ima_t.ima01
                    NEXT FIELD ima01
                END IF
            END IF
            
        BEFORE FIELD ima02
            IF g_ima[l_ac].ima01 IS NULL THEN NEXT FIELD ima01 END IF
            LET l_modify_flag = 'Y'
            IF (l_lock_sw = 'Y') THEN            #已鎖住
                LET l_modify_flag = 'N'
            END IF
            IF (l_modify_flag = 'N') THEN
                LET g_ima[l_ac].ima01 = g_ima_t.ima01
                DISPLAY g_ima[l_ac].ima01 TO s_ima[l_sl].ima01
#               NEXT FIELD ima01
                NEXT FIELD arrow
            END IF  
            IF cl_ku() then next field previous end if
 
        #BEFORE FIELD ima06
         #   IF cl_ku() then next field previous end if

        AFTER FIELD ima06
            IF cl_ku() then next field previous end if
                

        END INPUT

        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE

    CLOSE i109_bcl
    IF g_log = 'Y' THEN COMMIT WORK END IF
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION


FUNCTION i109_b_askkey()
    CLEAR FORM
{%} CONSTRUCT g_wc ON ima01,ima02,ima021,ima06,ima08
            FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021,s_ima[1].ima06,s_ima[1].ima08
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET g_ima_pageno = 1
    CALL i109_b_fill(g_wc)
END FUNCTION

FUNCTION i109_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           CHAR(200)

    LET g_sql =
        "SELECT ima01,ima02,ima021,ima06,ima08,''",
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED," AND imaacti='Y'",
        " ORDER BY 1"
    PREPARE i109_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i109_pb

    FOR g_cnt = 1 TO g_ima_arrno           #單身 ARRAY 乾洗
       INITIALIZE g_ima[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" ATTRIBUTE(REVERSE)
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN   EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_ima_arrno THEN  EXIT FOREACH END IF
    END FOREACH
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    CALL SET_COUNT(g_rec_b)               #告訴I.單身筆數
END FUNCTION

FUNCTION i109_bp(p_ud)
DEFINE
    p_ud            CHAR(1),
    l_i,l_j         SMALLINT

    CASE p_ud
        WHEN 'U'
            IF g_ima_pageno > 1 THEN
                LET g_ima_pageno = g_ima_pageno - 1
                FOR l_i = 1 TO g_ima_sarrno
                    LET l_j = g_ima_sarrno * (g_ima_pageno - 1) + l_i
                    DISPLAY g_ima[l_j].* TO s_ima[l_i].* ATTRIBUTE (YELLOW)
                END FOR
            END IF
        WHEN 'D'
            IF g_ima_pageno < g_ima_arrno/g_ima_sarrno THEN
                LET g_ima_pageno = g_ima_pageno + 1
                FOR l_i = 1 TO g_ima_sarrno
                    LET l_j = g_ima_sarrno * (g_ima_pageno - 1) + l_i
                    DISPLAY g_ima[l_j].* TO s_ima[l_i].* ATTRIBUTE (YELLOW)
                END FOR
            END IF
        WHEN 'N'
            CALL i109_b_askkey()
            LET g_ima_pageno = 1
            FOR l_i = 1 TO g_ima_sarrno
                LET l_j = g_ima_sarrno * (g_ima_pageno - 1) + l_i
                DISPLAY g_ima[l_j].* TO s_ima[l_i].* ATTRIBUTE (YELLOW)
            END FOR
    END CASE
END FUNCTION


FUNCTION cl_ku()                # Is Last Key <cursor up> or <cursor left> ?
   IF FGL_LASTKEY() = 2000 OR FGL_LASTKEY() = 2002
      THEN RETURN 1
      ELSE RETURN 0
   END IF
END FUNCTION
