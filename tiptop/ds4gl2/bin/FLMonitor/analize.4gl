# Prog. Version..: '5.00.02-07.06.21(00000)'     #
# Pattern name...: analize.4gl
# Descriptions...: Monitor FLM and TIPTOP Status Tool
# Date & Author..: 07/05/31 by alex
# Modify.........: No:FUN-770085 07/07/24 By hjwang 新增detail記錄供分析參考

DATABASE ds

   DEFINE g_hja      DYNAMIC ARRAY OF RECORD
            hja01    LIKE hja_file.hja01,
            hja02    DATETIME YEAR TO SECOND,
            hja03    LIKE hja_file.hja03,
            hja06    LIKE hja_file.hja06,
            hja20    LIKE hja_file.hja20,
            hja21    LIKE hja_file.hja21,
            hja19    LIKE hja_file.hja19
	             END RECORD
   DEFINE l_ac       SMALLINT
   DEFINE g_cnt      INTEGER
   DEFINE g_rec_b    SMALLINT
   DEFINE g_start    DATE
   DEFINE g_type     SMALLINT
   DEFINE g_sninit   INTEGER

MAIN

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   WHENEVER ERROR CONTINUE
   CLOSE WINDOW screen

   LET g_start = TODAY
   LET g_type = 0
   OPEN WINDOW w_analize WITH FORM "analize" 
   CALL analize_menu()

   CLOSE WINDOW w_analize

END MAIN


FUNCTION analize_i()

   DEFINE ls_sql     STRING
   DEFINE li_i       SMALLINT

   DISPLAY g_start,g_type TO start, type
   INPUT g_start,g_type WITHOUT DEFAULTS FROM start, type

   LET ls_sql = " SELECT hja01,hja02,hja03,hja06,hja20,hja21,hja19 ",
                  " FROM hja_file ",
                 " WHERE hja02 >= TO_DATE('",g_start - g_type ," 00:00:00','yy/mm/dd hh24:mi:ss') ",
                   " AND hja02 <= TO_DATE('",g_start," 23:59:59','yy/mm/dd hh24:mi:ss') ",
                 " ORDER BY hja01 "

   PREPARE analize_prep FROM ls_sql
   DECLARE analize_curs CURSOR FOR analize_prep

   CALL g_hja.clear()

   LET g_cnt = 1
   LET g_rec_b = 0
   LET g_sninit = 0

   FOREACH analize_curs INTO g_hja[g_cnt].*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         DISPLAY "Query Error!"
         EXIT FOREACH
      ELSE
         IF g_cnt = 1 THEN
            LET g_sninit = g_hja[1].hja01
            LET g_hja[1].hja01 = 0
         ELSE
            LET g_hja[g_cnt].hja01 = g_hja[g_cnt].hja01 - g_sninit 
         END IF 
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_hja.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

#  FOR li_i = g_hja.getLength() TO 2 STEP -1
#     IF g_hja[li_i].hja03 - g_hja[li_i-1].hja03 >= 0 THEN 
#        LET g_hja[li_i].hja03 = g_hja[li_i].hja03 - g_hja[li_i-1].hja03 
#        LET g_hja[li_i].hja06 = g_hja[li_i].hja06 - g_hja[li_i-1].hja06 
#     ELSE
#        LET g_hja[li_i].hja19 = "FLM restart"
#     END IF
#  END FOR

   CALL g_hja.deleteElement(1)
   LET g_rec_b = g_cnt - 1

END FUNCTION


FUNCTION analize_menu()

    DISPLAY ARRAY g_hja TO s_hja.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

       ON ACTION btn01   #Query
          CALL analize_i()
          CALL analize_plot("c")
          CALL analize_plot("r")
          CALL analize_plot("u")

       ON ACTION accept
          LET l_ac = ARR_CURR()
          CALL analize_detail()

       ON ACTION detail
          LET l_ac = ARR_CURR()
          CALL analize_detail()

       ON ACTION btnex
          EXIT PROGRAM

       ON ACTION exit
          EXIT PROGRAM

    END DISPLAY
END FUNCTION

FUNCTION analize_plot(lc_type)

   DEFINE li_max       INTEGER
   DEFINE li_mbackup   INTEGER
   DEFINE li_i         SMALLINT 
   DEFINE lc_type      VARCHAR(1)
   DEFINE lc_peakline  VARCHAR(1)
   DEFINE li_xstep     SMALLINT
   DEFINE li_xstart    SMALLINT
   DEFINE li_ystart    SMALLINT
   DEFINE li_yend      SMALLINT
   DEFINE li_xtemp     SMALLINT
   DEFINE li_ytemp     SMALLINT
   DEFINE ls_string    STRING
   DEFINE ls_color     STRING
   DEFINE ls_locate    STRING

   FOR li_i = 1 TO g_hja.getLength()
      CASE lc_type 
         WHEN "r"
	    IF li_max < g_hja[li_i].hja03 THEN
	       LET li_max = g_hja[li_i].hja03
	    END IF
            LET li_mbackup = li_max 
         WHEN "c"
	    IF li_max < g_hja[li_i].hja06 THEN 
	       LET li_max = g_hja[li_i].hja06 
	    END IF
            LET li_mbackup = li_max 
         WHEN "u"
	    IF li_max < g_hja[li_i].hja21 THEN 
	       LET li_max = g_hja[li_i].hja21 
	    END IF
	    IF li_mbackup < g_hja[li_i].hja20 THEN 
	       LET li_mbackup = g_hja[li_i].hja20
	    END IF
      END CASE
   END FOR

   CASE lc_type 
      WHEN "r"
         LET li_max = (( li_max / 100 ) + 1) 
         LET li_max = li_max * 100
         LET ls_locate="canvas01"
      WHEN "c"
         LET li_max = (( li_max / 100 ) + 1) 
         LET li_max = li_max * 100
	 LET ls_locate="canvas02"
      WHEN "u"
         LET ls_locate="canvas03"
   END CASE
   
   LET li_xstep = 900 / g_hja.getLength()

   CALL analize_clearplot(ls_locate.trim())
   CALL analize_xyplotprep(ls_locate.trim(),li_max)

   LET li_xstart = 75
   LET li_ystart = 100
   FOR li_i = 1 TO g_hja.getLength()

      LET lc_peakline = "n"
      CASE lc_type 
         WHEN "r"
            LET li_yend = g_hja[li_i].hja03 * 900 / li_max + 100
	    LET ls_color="red"
            IF g_hja[li_i].hja03 = li_mbackup THEN LET lc_peakline="y" END IF
         WHEN "c"
            LET li_yend = g_hja[li_i].hja06 * 900 / li_max + 100
	    LET ls_color="blue"
            IF g_hja[li_i].hja06 = li_mbackup THEN LET lc_peakline="y" END IF
         WHEN "u"
            LET li_yend = g_hja[li_i].hja20 * 900 / li_max + 100
	    IF g_hja[li_i].hja20 > li_max * 0.8 THEN
	       LET ls_color="red"
	    ELSE
	       LET ls_color="green"
	    END IF
            IF g_hja[li_i].hja20 = li_mbackup THEN LET lc_peakline="y" END IF
      END CASE
      CALL analize_linesection(ls_locate.trim(),li_xstart,li_ystart,
                (li_xstart+li_xstep) ,li_yend,2,ls_color.trim())
		
      IF lc_peakline <> "n" AND li_mbackup > 0 THEN
         CALL analize_linesection(ls_locate.trim(),
	        (li_xstart+li_xstep), 100, (li_xstart+li_xstep),li_yend,1,"GRAY")

	 IF li_yend + 35 >= 990 THEN 
	    LET li_ytemp = li_yend - 40 
	 ELSE 
	    LET li_ytemp = li_yend + 35 
	 END IF 
	 IF li_xstart + li_xstep + 75 >= 995 THEN
	    LET li_xtemp = 840   #
	 ELSE
	    LET li_xtemp = li_xstart + li_xstep - 75
	 END IF 
         CALL analize_text(ls_locate.trim(),li_xtemp,li_ytemp,
	                   g_hja[li_i].hja02||" Count:"||li_mbackup ,"MAGENTA","n")
      END IF

      LET ls_string = g_hja[li_i].hja02
      IF ls_string.subString(15,16) = "01" THEN
         LET ls_string = ls_string.subString(12,13)
         CALL analize_text(ls_locate.trim(),li_xstart,90, ls_string ,"BLACK","n")
      END IF

      LET li_xstart = li_xstart + li_xstep
      LET li_ystart = li_yend
   
   END FOR

END FUNCTION


FUNCTION analize_xyplotprep(lc_locate,li_max)

   DEFINE li_max       INTEGER
   DEFINE lc_locate    VARCHAR(20)

   CALL analize_linesection(lc_locate,75,100,975,100,2,"BLACK") 
   CALL analize_linesection(lc_locate,75,100, 75,1000,2,"BLACK") 
   CALL analize_linesection(lc_locate,75,550,975,550,2,"GRAY") 
   CALL analize_text(lc_locate,0,970, li_max ,"BLACK","w")
   LET li_max = li_max / 2
   CALL analize_text(lc_locate,0,550, li_max ,"BLACK","w")

END FUNCTION


FUNCTION analize_text(lc_locate,li_x,li_y,ls_text,lc_color,lc_anchor)
   DEFINE c, s         om.DomNode
   DEFINE w            ui.Window
   DEFINE li_x         SMALLINT
   DEFINE li_y         SMALLINT
   DEFINE lc_color     VARCHAR(20)
   DEFINE lc_anchor    VARCHAR(1) 
   DEFINE ls_text      STRING
   DEFINE lc_locate    VARCHAR(20)

   LET w = ui.Window.getCurrent()
   LET c = w.findNode("Canvas",lc_locate)
   LET s = c.createChild("CanvasText")
   #BLACK, BLUE, CYAN, GREEN, MAGENTA, RED, WHITE, and YELLOW
   CALL s.setAttribute( "fillColor", lc_color CLIPPED )
   CALL s.setAttribute( "startX", li_x )
   CALL s.setAttribute( "startY", li_y )
   CALL s.setAttribute( "anchor", lc_anchor CLIPPED )
   CALL s.setAttribute( "text", ls_text.trim() )
END FUNCTION

FUNCTION analize_linesection(lc_locate,li_xstart,li_ystart,li_xend,li_yend,li_width,lc_color)
   DEFINE c, s         om.DomNode
   DEFINE w            ui.Window
   DEFINE li_xstart    SMALLINT
   DEFINE li_ystart    SMALLINT
   DEFINE li_xend      SMALLINT
   DEFINE li_yend      SMALLINT
   DEFINE li_width     SMALLINT
   DEFINE lc_locate    VARCHAR(20)
   DEFINE lc_color     VARCHAR(20)

   LET w = ui.Window.getCurrent()
   LET c = w.findNode("Canvas",lc_locate)
   LET s = c.createChild("CanvasLine")
   #BLACK, BLUE, CYAN, GREEN, MAGENTA, RED, WHITE, and YELLOW
   CALL s.setAttribute( "fillColor", lc_color CLIPPED )
   CALL s.setAttribute( "startX", li_xstart )
   CALL s.setAttribute( "startY", li_ystart )
   CALL s.setAttribute( "endX", li_xend )
   CALL s.setAttribute( "endY", li_yend )
   CALL s.setAttribute( "width", li_width )
END FUNCTION


FUNCTION analize_clearplot(lc_locate)
   DEFINE c, s         om.DomNode
   DEFINE w            ui.Window
   DEFINE lc_locate    VARCHAR(20)

   LET w = ui.Window.getCurrent()
   LET c = w.findNode("Canvas",lc_locate)
   LET s = c.getFirstChild()
   
   WHILE s IS NOT NULL
     CALL c.removeChild(s)
     LET s = c.getFirstChild()
   END WHILE
END FUNCTION


FUNCTION analize_detail()

   DEFINE li_count     INTEGER
   DEFINE li_hja01     LIKE hja_file.hja01
   DEFINE la_hjc       DYNAMIC ARRAY OF RECORD
             hjc02     LIKE hjc_file.hjc02,
             hjc03     LIKE hjc_file.hjc03,
             hjc04     LIKE hjc_file.hjc04,
             zx02      LIKE zx_file.zx02,
             zx03      LIKE zx_file.zx03,
             gem02     LIKE gem_file.gem02,
             hjc05     LIKE hjc_file.hjc05
                       END RECORD
   DEFINE ls_sql       STRING
   DEFINE li_cnt       INTEGER
   DEFINE li_rec_b     INTEGER

   LET li_hja01 = g_hja[l_ac].hja01 + g_sninit

   SELECT COUNT(*) INTO li_count FROM hjc_file WHERE hjc01 = li_hja01
   IF li_count < 1 THEN
      LET ls_sql = " System Not Existed Logon Users Log on This Time.\n",
                   " \n",
                   " If You Want to Know Detail Logon Users Data,\n",
                   " Please Notice System Administrator Add 'detail'\n",
                   " Parameter After 'FlmWriteData' Program."
      MENU "Warning" ATTRIBUTE (STYLE="dialog", COMMENT=ls_sql.trim(),
                               IMAGE="question")
         ON ACTION accept
            EXIT MENU
         ON ACTION cancel
            EXIT MENU
      END MENU

      RETURN
   END IF

   OPEN WINDOW w_analize_01 WITH FORM "analize_01" 

   LET ls_sql = " SELECT hjc02,hjc03,hjc04,'','','',hjc05 ",
                  " FROM hjc_file ",
                 " WHERE hjc01 = '",li_hja01,"' ",
                 " ORDER BY hjc03 "

   PREPARE analize01_prep FROM ls_sql
   DECLARE analize01_curs CURSOR FOR analize01_prep

   CALL la_hjc.clear()

   LET li_cnt = 1
   LET li_rec_b = 0

   FOREACH analize01_curs INTO la_hjc[li_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      ELSE
         SELECT zx02,zx03 INTO la_hjc[li_cnt].zx02,la_hjc[li_cnt].zx03
           FROM zx_file
          WHERE zx01 = la_hjc[li_cnt].hjc04
         SELECT gem02 INTO la_hjc[li_cnt].gem02
           FROM gem_file
          WHERE gem01 = la_hjc[li_cnt].zx03
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL la_hjc.deleteElement(li_cnt)
   LET li_rec_b = li_cnt - 1

   DISPLAY ARRAY la_hjc TO s_hjc.* ATTRIBUTE(COUNT=li_rec_b,UNBUFFERED)

      ON ACTION exit
         EXIT DISPLAY

   END DISPLAY

   CLOSE WINDOW w_analize_01

END FUNCTION
