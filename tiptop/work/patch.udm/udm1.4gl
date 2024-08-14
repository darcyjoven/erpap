# Prog. Version..: '5.00.06-01.03.16'     #
#
# Pattern name...: udmenu.4gl
# Descriptions...: 使用者自定目錄(左右兩排式)
# Date & Author..: 91/11/20 By LYS 
# 1992/02/18(Lee): 使用遞迴法來呼叫下層的選單(若該選單在程式基本資料
#      定義時, 不定義呼叫方式) 如此可以減少process的產生數, 並加快執
#      行速度.
# 1994/08/18(Lee): 若執行內容(zz08)為空白時, 不為任何反應
# Modify.........: 96/01/19 by danny 防止user按del鍵跳開 
#
DATABASE ds

GLOBALS "dsz_r.4gl"
    DEFINE g_zz_arrno,g_zz_sarrno	SMALLINT
    DEFINE g_bookno		 VARCHAR(2)

MAIN
    DEFER INTERRUPT         #96/01/19 by danny
    WHENEVER ERROR CONTINUE
    IF NOT dsz_stup('udm1') THEN {EXIT PROGRAM} END IF
    SET ISOLATION TO DIRTY READ
    CALL s_udsday()
    CALL udmenu(0,0,ARG_VAL(1))
END MAIN

FUNCTION udmenu(p_row,p_col,p_menu)
DEFINE
    p_row,p_col    SMALLINT,
    p_menu VARCHAR(10),
    l_zx05    LIKE zx_file.zx05,
    l_time    VARCHAR(8)

    WHENEVER ERROR CONTINUE

    IF p_menu = " " OR p_menu IS NULL
      THEN
        SELECT zx05,zx06 INTO l_zx05,g_lang FROM zx_file
           	WHERE zx01 = g_user
          IF SQLCA.sqlcode OR l_zx05 IS NULL THEN EXIT PROGRAM END IF
      ELSE
        LET l_zx05 = p_menu
    END IF

    IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF

    CALL cl_used('udmenu',l_time,1) RETURNING l_time

    CALL cl_dsmark()
    IF fgl_getenv('BDLASCII')='Y'
       THEN
       OPEN FORM udmenu_srn FROM 'azz/frm/udmenu1a'
    ELSE
       OPEN FORM udmenu_srn FROM 'azz/frm/udmenu1'
    END IF
    DISPLAY FORM udmenu_srn ATTRIBUTE(CYAN)
    CALL udm(p_row,p_col,l_zx05,0,0)
    CLOSE FORM udmenu_w
    CALL cl_used('udmenu',l_time,2) RETURNING l_time
END FUNCTION

# Recursively call myselef if it's a menu selection
FUNCTION udm(p_row,p_col,p_menu,p_x,p_level)
DEFINE
    p_row,p_col	SMALLINT,
    p_menu LIKE zx_file.zx05,
    p_x,p_level		 SMALLINT,
    l_zz03 LIKE zz_file.zz03,
    l_zz08 LIKE zz_file.zz08,
    l_zz02h		LIKE zz_file.zz02,
    l_zz02e		LIKE zz_file.zz02,
    l_zz17		LIKE zz_file.zz17,
    l_zx05		LIKE zx_file.zx05,
    g_zz_pageno	SMALLINT,
    g_zz ARRAY[60] of RECORD
    	x     SMALLINT,
    	zz01 LIKE zz_file.zz01,
    	zz02 LIKE zz_file.zz02,
    	zz03 LIKE zz_file.zz03
    	END RECORD,
    l_zz15		 VARCHAR(01),
    l_cmd		 VARCHAR(40),
    l_ans,l_seq			SMALLINT,
    l_i,l_j,l_n,l_ac,l_sl,m	SMALLINT,
    l_exit,l_i2 SMALLINT,
    l_display SMALLINT,
    l_cnt		SMALLINT,
    i                   SMALLINT,
    l_arrno,l_maxac	SMALLINT

    LET p_level=p_level+1
    SELECT COUNT(*) INTO l_cnt FROM zm_file, OUTER zz_file
    	WHERE zm01 = p_menu AND zm04 = zz_file.zz01
    IF g_lang='0' THEN
    	SELECT zz02 INTO l_zz02h FROM zz_file WHERE zz01 = p_menu
    ELSE
    	SELECT zz02e INTO l_zz02h FROM zz_file WHERE zz01 = p_menu
    END IF

    {
    DECLARE zz_curs CURSOR FOR
    	SELECT zm03,'',zz01,zz02,zz03,zz02e,zz17
                 FROM zm_file, OUTER zz_file
    		WHERE zm01 = p_menu AND zm04 = zz_file.zz01
    		  AND zm04 IN (SELECT zy02 FROM zy_file
                            WHERE zy01 = g_clas AND zy02 = zm04)
    		ORDER BY zm03
    }
#### dennon lai
    DECLARE zz_curs CURSOR FOR
    SELECT zm03,'',zz01,zz02,zz03,zz02e,zz17
    FROM zm_file, OUTER zz_file
        WHERE zm01 =p_menu AND zm04 = zz_file.zz01
        ORDER BY zm03
## Dennon Lai 00/09/26 End of modify


    LET l_arrno = 60
    LET g_zz_arrno = 60
    LET g_zz_sarrno= 20
    LET g_zz_pageno= 0

    FOR l_ac = 1 TO g_zz_arrno LET g_zz[l_ac].x = NULL END FOR

    LET l_ac = 1
    FOREACH zz_curs INTO l_n,g_zz[l_ac].*,l_zz02e,l_zz17
    	IF SQLCA.sqlcode != 0 THEN
    		CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
      #No.B514 Add by Dennon 01/05/14
       SELECT COUNT(*) INTO l_cnt FROM zy_file,zxw_file
           WHERE zy01 = zxw04 AND zxw01=g_user AND zxw03='1'
             AND zy02 = g_zz[l_ac].zz01
       IF l_cnt IS NULL OR l_cnt=0 THEN
          SELECT COUNT(*) INTO l_cnt FROM zxw_file
          WHERE zxw01=g_user AND zxw03='2'
            AND zxw04=g_zz[l_ac].zz01
         #IF l_cnt IS NULL OR l_cnt=0 THEN CONTINUE FOREACH END IF
         IF l_cnt IS NULL OR l_cnt=0 THEN
            #判斷若是不存在zxw_file,則再讀取zx_file的權限 linda
            SELECT COUNT(*) INTO i FROM zxw_file WHERE zxw01=g_user
            IF i IS NULL OR i=0 THEN 
               SELECT COUNT(*) INTO l_cnt FROM zx_file,zy_file
               WHERE zy01 = zx04 AND zx01=g_user 
                AND zy02 = g_zz[l_ac].zz01
            END IF
            IF l_cnt IS NULL OR l_cnt=0 THEN CONTINUE FOREACH END IF
          END IF 
       END IF
     #End Dennon Lai 01/05/14

    	IF g_lang!='0' AND NOT cl_null(l_zz02e) THEN
    		LET g_zz[l_ac].zz02=l_zz02e
    	END IF
    	IF g_zz[l_ac].zz02 IS NULL THEN LET g_zz[l_ac].zz02 = '?' END IF
    	IF g_zz[l_ac].zz01[4]='r' THEN
           LET g_zz[l_ac].zz02=g_zz[l_ac].zz02 CLIPPED,
                               '(',l_zz17 USING '<<<',')'
        END IF
    #LET g_zz[l_ac].x = l_ac
     LET g_zz[l_ac].x = l_n
    	IF l_ac >= l_arrno THEN EXIT FOREACH END IF
    	LET l_ac = l_ac + 1
    END FOREACH
#Add by Dennon 00/10/06
    INITIALIZE g_zz[l_ac].* TO NULL
#end

    LET l_maxac = l_ac-1
    LET g_zz_pageno=0

    LET l_display=p_x
    WHILE TRUE
    	CALL SET_COUNT(l_maxac)
    	DISPLAY l_cnt TO cnt
    	DISPLAY p_menu,l_zz02h TO zz01h,zz02h ATTRIBUTE(YELLOW)
    	IF g_zz_pageno < g_zz_arrno/g_zz_sarrno THEN
    		LET g_zz_pageno = g_zz_pageno + 1
#    		CALL udmenu_bp('D', g_zz_pageno)
            FOR l_i = 1 TO g_zz_sarrno
                LET l_j = g_zz_sarrno * (g_zz_pageno - 1) + l_i
                IF l_i <= 10
                   THEN LET m = l_i * 2 - 1
                   ELSE LET m = (l_i-10) * 2
                END IF
                DISPLAY g_zz[l_j].x,g_zz[l_j].zz02 TO s_zz[m].*
                IF g_zz[l_j].zz03='M' THEN
                   DISPLAY g_zz[l_j].x TO s_zz[m].x ATTRIBUTE(REVERSE)
                END IF
            END FOR
    	END IF
    	IF NOT l_display THEN
            LET l_exit=TRUE
            INPUT BY NAME l_ans WITHOUT DEFAULTS ATTRIBUTE (YELLOW)
            	AFTER FIELD l_ans
                    IF l_ans = 0 THEN EXIT INPUT END IF
                    IF l_ans IS NULL THEN NEXT FIELD l_ans END IF
                    LET l_seq=61
                    FOR l_j=1 TO 60
                       IF l_ans=g_zz[l_j].x THEN LET l_seq=l_j EXIT FOR END IF
                    END FOR
                    IF l_seq < 1 OR l_seq > 60 THEN NEXT FIELD l_ans END IF
                    IF g_zz[l_seq].zz01 IS NULL THEN NEXT FIELD l_ans END IF
                    SELECT zz03,zz08,zz15 INTO l_zz03,l_zz08,l_zz15
                    	FROM zz_file
                    	WHERE zz01=g_zz[l_seq].zz01
                    IF SQLCA.SQLCODE THEN NEXT FIELD l_ans END IF
                    IF cl_null(l_zz08) THEN NEXT FIELD l_ans END IF
                    IF l_zz03='M' # AND (l_zz08 IS NULL OR l_zz08=' ')
                    THEN
                    	IF g_zz_pageno>0 THEN
                    		LET g_zz_pageno=g_zz_pageno-1 END IF
                    	LET l_j=(p_level-1)*3+1
                    	DISPLAY l_ans USING '##' AT 20,l_j ATTRIBUTE(REVERSE)
                    	IF l_j>1 THEN LET l_j=l_j-1 DISPLAY '-' AT 20,l_j END IF
                    	CALL udm(p_row,p_col,g_zz[l_seq].zz01,0,p_level)
                    	DISPLAY '   ' AT 20,l_j
                    	CALL SET_COUNT(l_maxac)
                    	LET l_exit=FALSE
                    	EXIT INPUT
                    ELSE
                 	IF l_zz15='Y'
                    	   THEN LET l_cmd=g_zz[l_seq].zz01,' ',g_bookno
                    	   ELSE LET l_cmd=g_zz[l_seq].zz01
                    	END IF
                    	CALL cl_cmdrun(l_cmd)
                    END IF
                    NEXT FIELD l_ans
                ON KEY(CONTROL-P)
                   CALL cl_cmdrun('aoos901')
                   IF NOT dsz_stup("udm1") THEN EXIT PROGRAM END IF
                   CALL cl_dsmark()
    LET g_version = '5.00.06-01.03.16'            
                ON KEY(CONTROL-Y)
 	    	   CALL s_selact(0,0,g_lang) RETURNING g_bookno
                ON KEY(F3)
                    IF g_zz_pageno < g_zz_arrno/g_zz_sarrno THEN
                       LET g_zz_pageno = g_zz_pageno + 1
                    END IF
#                   CALL udmenu_bp('D', g_zz_pageno)
                    FOR l_i = 1 TO g_zz_sarrno
                        LET l_j = g_zz_sarrno * (g_zz_pageno - 1) + l_i
                        IF l_i <= 10
                           THEN LET m = l_i * 2 - 1
                           ELSE LET m = (l_i-10) * 2
                        END IF
                        DISPLAY g_zz[l_j].x,g_zz[l_j].zz02 TO s_zz[m].*
                        IF g_zz[l_j].zz03='M' THEN
                           DISPLAY g_zz[l_j].x TO s_zz[m].x ATTRIBUTE(REVERSE)
                        END IF
                    END FOR
                ON KEY(F4)
                    IF g_zz_pageno > 1 THEN
                       LET g_zz_pageno = g_zz_pageno - 1
                    END IF
#                   CALL udmenu_bp('U', g_zz_pageno)
                    FOR l_i = 1 TO g_zz_sarrno
                        LET l_j = g_zz_sarrno * (g_zz_pageno - 1) + l_i
                        IF l_i <= 10
                           THEN LET m = l_i * 2 - 1
                           ELSE LET m = (l_i-10) * 2
                        END IF
                        DISPLAY g_zz[l_j].x,g_zz[l_j].zz02 TO s_zz[m].*
                        IF g_zz[l_j].zz03='M' THEN
                           DISPLAY g_zz[l_j].x TO s_zz[m].x ATTRIBUTE(REVERSE)
                        END IF
                    END FOR
                ON KEY(CONTROL-G) CALL cl_cmdask()
            END INPUT
#96/01/19 by danny 防止USER按DEL鍵跳開
#           IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               LET l_exit = FALSE
            END IF
            IF l_ans = 0 THEN LET l_exit = TRUE END IF
            IF g_zz_pageno>0 THEN LET g_zz_pageno=g_zz_pageno-1 END IF
#######
            IF l_exit THEN EXIT WHILE END IF
        END IF

        IF l_display AND NOT l_exit THEN
            LET l_exit=TRUE
            INPUT ARRAY g_zz WITHOUT DEFAULTS FROM s_zz.*
                BEFORE ROW
                    LET l_i=ARR_CURR()
                    IF l_i<l_i2 THEN
                    	NEXT FIELD zz02
                    ELSE
                    	LET l_i2=0
                    END IF
                    LET l_j=SCR_LINE()
                    IF l_i>l_maxac THEN NEXT FIELD x END IF
                    DISPLAY g_zz[l_i].* TO s_zz[l_j].*
                    	ATTRIBUTE(REVERSE)
                AFTER ROW
                    DISPLAY g_zz[l_i].* TO s_zz[l_j].*
                ON KEY(CONTROL-M)
                    LET l_ans=ARR_CURR()
                    IF g_zz[l_ans].zz01 IS NOT NULL THEN
                    	SELECT zz03,zz08,zz15 INTO l_zz03,l_zz08,l_zz15
                    		FROM zz_file
                    		WHERE zz01=g_zz[l_ans].zz01
                    	IF SQLCA.SQLCODE THEN NEXT FIELD l_ans END IF
                    	IF cl_null(l_zz08) THEN NEXT FIELD l_ans END IF
                    	IF l_zz03='M' # AND (l_zz08 IS NULL OR l_zz08=' ')
                    	THEN
                    		IF g_zz_pageno>0 THEN
                    			LET g_zz_pageno=g_zz_pageno-1 END IF
                    		CALL udm(p_row,p_col,g_zz[l_ans].zz01,1,p_level)
                    		CALL SET_COUNT(l_maxac)
                    		LET l_exit=FALSE
                    		LET l_i2=l_ans
                    		EXIT INPUT
                    	ELSE
                    	   IF l_zz15='Y'
                    	      THEN LET l_cmd=g_zz[l_ans].zz01,' ',g_bookno
                    	      ELSE LET l_cmd=g_zz[l_ans].zz01
                    	   END IF
                    	   CALL cl_cmdrun(l_cmd)
                    	END IF
                    END IF
                ON KEY(CONTROL-P)
                    IF g_zz_pageno>0 THEN LET g_zz_pageno=g_zz_pageno-1 END IF
                    LET l_display=FALSE
                    LET l_exit=FALSE EXIT INPUT
            END INPUT
            IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            IF l_exit THEN EXIT WHILE END IF
        END IF
    END WHILE
END FUNCTION
