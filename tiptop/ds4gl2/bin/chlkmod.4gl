# Pattern name...: chlkmod.4gl
# Descriptions...: CHANGE TABLE LOCK MODE
# Input parameter: No
# Return code....: No
# Date & Author..: 96/07/05 By Chet

# DATABASE ds

# GLOBALS "chl.4gl"

DEFINE tm  RECORD    dbs  CHAR(10),              # Data Base Name
                     b    CHAR(01)               # 是否確定
           END RECORD

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT                               # Supress DEL key function
   WHENEVER ERROR CONTINUE

   LET tm.dbs   = ARG_VAL(3)
   LET tm.b     = ARG_VAL(4)

   CALL chlkmod_tm(0,0)                          # Input print condition
END MAIN

FUNCTION chlkmod_tm(p_row,p_col)
   DEFINE p_row,p_col    SMALLINT,
          l_dbs          CHAR(10),
          l_yn           CHAR(01)

   WHILE TRUE
      PROMPT " Input Data Base Name : " FOR l_dbs
      PROMPT " Are you sure ? (Y/N)" FOR l_yn
      IF l_yn = 'N' THEN
         EXIT PROGRAM
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE DATABASE
         EXIT PROGRAM
      END IF

      CALL chlkmod(l_dbs)
      LET l_yn = ' '
      PROMPT " Do you want to leave ? (Y/N)" FOR l_yn
      IF l_yn = 'y' OR l_yn = 'Y' THEN
         CLOSE DATABASE
         EXIT PROGRAM
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW chlkmod_w
END FUNCTION

FUNCTION chlkmod(l_dbs)
   DEFINE l_name    CHAR(20),               # External(Disk) file name
          l_sql     CHAR(600),              # RDSQL STATEMENT
          l_dbs     CHAR(10),               # Data Base Name
          sr        RECORD    tabid     SMALLINT,
                              tabname   CHAR(18)
                    END RECORD

     LET l_dbs = l_dbs CLIPPED
     DISPLAY ' Please wait ...'
     SLEEP 2

     CLOSE DATABASE
     DATABASE l_dbs
     IF SQLCA.SQLCODE THEN
        ERROR '(error no:',SQLCA.sqlcode,')[dbs:',tm.dbs CLIPPED,
              '] Database open error!'
        Sleep 2
        EXIT PROGRAM
     END IF

     START REPORT chlkmod_rep TO 'chlkmod.sql'

     LET l_sql = " SELECT tabid, tabname",
                 " FROM   systables",
                 " WHERE  tabid > 99 AND tabtype<>'S'"

     PREPARE chlkmod_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        ERROR 'prepare:',SQLCA.sqlcode
        EXIT PROGRAM
     END IF

     DECLARE chlkmod_curs1 CURSOR
                           FOR chlkmod_prepare1

     FOREACH chlkmod_curs1 INTO sr.*
             IF SQLCA.sqlcode != 0 THEN
                ERROR 'foreach:',SQLCA.sqlcode
                EXIT FOREACH
             END IF
             OUTPUT TO REPORT chlkmod_rep(sr.*)
     END FOREACH

     FINISH REPORT chlkmod_rep
END FUNCTION

REPORT chlkmod_rep(sr)
   DEFINE l_last_sw    CHAR(1),
          sr           RECORD tabid   SMALLINT,
                              tabname CHAR(18)
                       END RECORD
   OUTPUT TOP MARGIN 0
          LEFT MARGIN 0
          BOTTOM MARGIN 0
          PAGE LENGTH 1

   ORDER BY sr.tabid

   FORMAT
   #  PAGE HEADER

      ON EVERY ROW
         PRINT
               ' alter table ',
               sr.tabname CLIPPED,
               ' lock mode(row)',';'

   #  ON LAST ROW

   #  PAGE TRAILER
END REPORT
