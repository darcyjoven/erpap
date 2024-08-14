# Prog. Version..: '6.00.04-03.01.09'     #
# Pattern name...: pf.4gl
# Descriptions...: 將程式中的對檔案的操作載入 zr_file 中
# Date & Author..: Roger (maybe), Date (unknow)
# 注意...........: 執行前應先對所有 s_xxxx() 的 sub program 執行本程式
# Modify.........: Julius 03/03/12
# Modify Desc....: 1.調整程式風格, 將保留字轉為大寫
# ...............: 2.follow 變數命名原則, function 命名改為有意義的命名
# ...............: 2.調整 shell 輸出的暫存檔位置, 及檔名

DATABASE ds
DEFINE  g_buf	CHAR(130),
        g_stmt  ARRAY[12000] of CHAR(100),
        g_prog  CHAR(20),
        g_maxi  SMALLINT,
        g_i	SMALLINT,
        g_j	SMALLINT,
        g_S	CHAR(1),
        g_b2	CHAR(10),
        g_old	ARRAY[100] of CHAR(11)

MAIN
    DEFINE l_tempfile	CHAR(20)

    WHENEVER ERROR CONTINUE

    #################################################################
    # 將 shell script pf 所產生的暫存檔的資料載入 TEMP TABLE temp_x #
    #################################################################
    LET l_tempfile = fgl_getenv("TEMPDIR") CLIPPED, "/pf.tmp"
    DROP TABLE temp_x
    FOR g_j = 1 to 100 
	LET g_old[g_j] = '#' 
    END FOR
    CREATE TEMP TABLE temp_x( statement CHAR(100))
    LET g_prog = ARG_VAL(1)
    LOAD FROM l_tempfile INSERT INTO temp_x
    DISPLAY g_prog CLIPPED, ' load STATUS:',
	    STATUS, ' ', SQLCA.sqlerrd[3], 
	    ' rows loaded'
    IF SQLCA.SQLCODE THEN
	EXIT PROGRAM
    END IF

    ###############################################################
    # 刪除舊程式資料                                              #
    ###############################################################
    DELETE FROM zr_file 
     WHERE zr01 = g_prog

    ###############################################################
    # 將 temp_x 中的資料 FOREACH 抓到 g_stmt 中處理               #
    ###############################################################
    DECLARE a CURSOR FOR
	SELECT * 
	FROM temp_x
    LET g_maxi = 1
    FOREACH a INTO g_stmt[g_maxi]
	IF STATUS THEN
	    EXIT FOREACH
	END IF
	IF g_stmt[g_maxi] IS NULL THEN
	    CONTINUE FOREACH
	END IF
      LET g_maxi = g_maxi + 1
    END FOREACH
    LET g_maxi = g_maxi - 1
    DISPLAY g_maxi, ' rows into ARRAY'
    CALL get_file()
END MAIN

FUNCTION get_file()
    DEFINE l_ii SMALLINT
    LET g_S = '0'
    ######################################################################
    # 將 g_stmt 中的資料逐筆抓到 g_buf 並交給 FUNCTION check_stmt() 處理 #
    ######################################################################
    FOR l_ii = 1 to g_maxi
	LET g_buf = g_stmt[l_ii]
	CALL check_stmt()
    END FOR
END FUNCTION

FUNCTION check_stmt()
    DEFINE  l_sub_p   CHAR(10),
            l_b	    CHAR(10),
            l_i1      SMALLINT,
            l_i2      SMALLINT,
            l_i3      SMALLINT,
            l_i5      SMALLINT,
            l_i6      SMALLINT,
            l_i7      SMALLINT,
            l_ix	    SMALLINT,
            l_zr    RECORD LIKE zr_file.*

    LET g_i = 0
    WHILE TRUE
	IF g_i > 74 THEN
	    RETURN
	END IF
	LET g_i = g_i + 1
	IF g_buf[g_i, g_i] = ' ' THEN
	    RETURN
	END IF
	LET l_i1 = g_i + 1
	LET l_i2 = g_i + 2
	IF g_buf[g_i, l_i1] = 's_' OR g_buf[g_i, l_i2] = 'cl_' THEN
	    LET l_ix = 0
	    FOR g_j = l_i1 TO 70
		IF g_j > l_i1 + 10 THEN
		    EXIT FOR
		END IF
		IF g_buf[g_j, g_j] = '(' THEN
		    LET l_ix = g_j - 1
		    EXIT FOR
		END IF
	    END FOR
	    IF l_ix > 0 THEN
		LET l_sub_p = g_buf[g_i, l_ix]
		DECLARE pf_c2 CURSOR FOR
		    SELECT *
		      FROM zr_file
		     WHERE zr01 = l_sub_p
		FOREACH pf_c2 INTO l_zr.*
		    DISPLAY l_sub_p clipped, ' ', l_zr.zr02, ' ', l_zr.zr03
		    LET l_zr.zr01 = g_prog
		    INSERT INTO zr_file VALUES( l_zr.* )
		END FOREACH
	    END IF
	    CONTINUE WHILE
	END IF
	IF g_buf[g_i, g_i] MATCHES '[()-+*/{}="]' THEN
	    CONTINUE WHILE
	END IF
	LET l_i5 = g_i + 5
	CASE g_buf[g_i, l_i5]
	    WHEN 'SELECT'
		LET g_S = 'S'
		LET g_i = g_i + 5
		CONTINUE WHILE
	    WHEN 'UPDATE'
		LET g_S = 'U'
		LET g_i = g_i + 5
		CONTINUE WHILE
	    WHEN 'DELETE'
		LET g_S = 'D'
		LET g_i = g_i + 5
		CONTINUE WHILE
	    WHEN 'INSERT'
		LET g_S = 'I'
		LET g_i = g_i + 5
		CONTINUE WHILE
	    WHEN 'agl_st'
		CALL i_zr('aaz_file','S')
		RETURN
	    WHEN 'anm_st'
		CALL i_zr('nmz_file','S')
		RETURN
	    WHEN 'aap_st'
		CALL i_zr('apz_file','S')
		RETURN
	    WHEN 'axm_st'
		CALL i_zr('oaz_file','S')
		RETURN
	    WHEN 'axr_st'
		CALL i_zr('ooz_file','S')
		RETURN
	    WHEN '_stup('
		CALL i_zr('aza_file','S')
		RETURN
	    WHEN 'ENDFUN'
		LET g_S='0'
		RETURN
	END CASE
	LET l_i3 = g_i + 3
        LET l_i7 = g_i + 7
	LET l_i6 = g_i + 6
	LET l_b = g_buf[l_i3, l_i7]
	LET g_b2 = g_buf[g_i, l_i7]
	IF g_S != '0' THEN
        CASE 
	    WHEN l_b = '_file' AND
		 (g_b2[1, 1] >= 'a' AND g_b2[1, 1] <= 'z')
		CALL i_zr(g_b2, g_S)
	    WHEN g_buf[g_i,l_i3] = 'aps_' AND g_buf[l_i7,l_i7] <> '.'
		CALL i_zr(g_buf[g_i, l_i6], g_S)
        END CASE
     END IF
    END WHILE
END FUNCTION

FUNCTION i_zr(l_file_name, l_cmd)
    DEFINE l_file_name CHAR(10),
           l_cmd       CHAR(1),
           l_t         CHAR(11)

    FOR g_j = 1 to 100
	LET l_t = l_file_name, l_cmd
	IF g_old[g_j] = l_t THEN
	    EXIT FOR
	END IF
	IF g_old[g_j] = '#' THEN
	    LET g_old[g_j] = l_t
	    DISPLAY g_i, " : ", g_prog clipped, ' ', l_t
	    INSERT INTO zr_file VALUES(g_prog, l_file_name, l_cmd)
	    EXIT FOR
	END IF
    END FOR
END FUNCTION
