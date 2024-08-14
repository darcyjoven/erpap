# 執行時，轉換多行業別執行檔
# No:FUN-760049 07/06/21 by saki 行業別代碼更動
# No:FUN-750068 07/07/26 by saki 一開始無使用者的db, 要得到後才可抓sma_file的值
# No:TQC-870015 08/08/15 by saki 取消使用zxx_file
# No:TQC-880043 08/08/22 by saki 取消使用zxx_file

DATABASE ds

DEFINE   mi_gui_type   LIKE type_file.num5
DEFINE   mi_user       LIKE type_file.chr10
DEFINE   mi_plant      LIKE type_file.chr10
DEFINE   mi_bgjob      LIKE type_file.chr1

MAIN
   DEFINE   lc_prog      LIKE zz_file.zz01
   DEFINE   ls_tool      STRING
   DEFINE   l_argument   STRING
   DEFINE   l_i          LIKE type_file.num10
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_path      STRING
   DEFINE   lc_sma124    LIKE sma_file.sma124
#  DEFINE   lc_smb04     LIKE smb_file.smb04      #No:FUN-760049
   DEFINE   lc_std_id    LIKE smb_file.smb01
   DEFINE   li_cnt       LIKE type_file.num5
   DEFINE   lc_dbs       LIKE type_file.chr21     #No:FUN-750068
   DEFINE   ls_sql       STRING                   #No:FUN-750068

   LET ls_tool = ARG_VAL(1)
   LET ls_path = ARG_VAL(2)
   LET lc_prog = ARG_VAL(3)

   FOR l_i = 4 TO NUM_ARGS()
       LET l_argument = l_argument, " '", ARG_VAL(l_i), "'"
   END FOR

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe("cd "||ls_path||";pwd;cd "||FGL_GETENV('TEMPDIR'),"r")
   WHILE lc_channel.read(ls_result)
   END WHILE

   CASE ls_tool
      WHEN "r.r2"
         LET ls_cmd = "$FGLRUN "
      WHEN "r.d2"
         LET ls_cmd = "$FGLRUN -d "
      WHEN "r.d2+"
         LET ls_cmd = "$FGLRUN $DS4GL/fgldeb/fgldeb "
   END CASE

   LET lc_dbs = industry_run_get_dbs()    #No:FUN-750068

   #一般行業代號
#  SELECT smb01 INTO lc_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"   #No:FUN-760049 mark
   LET lc_std_id = "std"

   #No:FUN-760049 --start--
#  SELECT sma124,smb04 INTO lc_sma124,lc_smb04 FROM sma_file,smb_file
#   WHERE sma00='0' AND sma124=smb01 AND smb02='0'
#  SELECT sma124 INTO lc_sma124 FROM sma_file WHERE sma00='0'  #No:FUN-750068 mark
   #No:FUN-760049 ---end---
   #No:FUN-750068 --start--
   IF DB_GET_DATABASE_TYPE() = "ORA" THEN
      LET ls_sql = "SELECT sma124 FROM ",lc_dbs CLIPPED,".sma_file WHERE sma00='0'"
   ELSE
      LET ls_sql = "SELECT sma124 FROM ",lc_dbs CLIPPED,":sma_file WHERE sma00='0'"
   END IF
   PREPARE sma124_pre FROM ls_sql
   EXECUTE sma124_pre INTO lc_sma124
   #No:FUN-750068 ---end---

   IF lc_sma124 != lc_std_id THEN
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01 = lc_prog AND gav11 = lc_sma124
      IF li_cnt > 0 THEN
         LET ls_path = ls_result,"/../42r/",lc_prog CLIPPED,"_",lc_sma124 CLIPPED,".42r"  #No:FUN-760049
         DISPLAY "EXECUTE ../42r/",lc_prog CLIPPED,"_",lc_sma124 CLIPPED,".42r"           #No:FUN-760049
      ELSE
         LET ls_path = ls_result,"/../42r/",lc_prog CLIPPED,".42r"
         DISPLAY "EXECUTE ../42r/",lc_prog CLIPPED,".42r"
      END IF
   ELSE
      LET ls_path = ls_result,"/../42r/",lc_prog CLIPPED,".42r"
      DISPLAY "EXECUTE ../42r/",lc_prog CLIPPED,".42r"
   END IF
   LET ls_cmd = ls_cmd,ls_path
   IF l_argument IS NOT NULL THEN
      LET ls_cmd = ls_cmd," ",l_argument
   END IF

   RUN ls_cmd
END MAIN

#No:FUN-750068 --start--
FUNCTION industry_run_get_dbs()
   DEFINE   lc_dbs        LIKE type_file.chr21
   DEFINE   l_zx07        LIKE zx_file.zx07
#  DEFINE   lc_tty_no     LIKE zxx_file.zxx02   #No:TQC-880043 mark
   DEFINE   ls_tty_no     STRING
   DEFINE   li_cnt        LIKE type_file.num5
   DEFINE   ls_fglserver  STRING
   DEFINE   ls_sql        STRING
   DEFINE   ls_gbq10      STRING
   DEFINE   lc_gbq10      LIKE gbq_file.gbq10

   SELECT azz04 INTO lc_dbs FROM azz_file WHERE azz01 = '0'
   IF (SQLCA.SQLCODE) THEN
      RETURN lc_dbs
   END IF

   CASE 
      WHEN FGL_GETENV('FGLGUI') = '1' AND FGL_GETENV('WEBMODE') = '1'
         LET mi_gui_type = 3   #WEB(ActiveX, Java)
      WHEN FGL_GETENV('FGLGUI') = '1' AND FGL_GETENV('GWC') = '1'
         LET mi_gui_type = 2   #WEB(Browser)
      WHEN FGL_GETENV('FGLGUI') = '1'
         LET mi_gui_type = 1   #WINDOWS(GUI)  
      WHEN FGL_GETENV('FGLGUI') = '0'
         LET mi_gui_type = 0   #ASCII(TEXT) 
   END CASE

   CASE
      WHEN (mi_gui_type = 0) AND (FGL_GETENV("BGJOB") = '1') AND (FGL_GETENV("WEBMODE") = '1')
         LET mi_user = FGL_GETENV("WEBUSER")
      WHEN (mi_gui_type = 0) OR (mi_gui_type = 1)
         LET mi_user = FGL_GETENV("LOGNAME")
      WHEN (mi_gui_type = 2) OR (mi_gui_type = 3)
         LET mi_user = FGL_GETENV("WEBUSER")
   END CASE

   IF ( mi_gui_type = 0 ) AND 
      ((FGL_GETENV("BGJOB")='1') OR (FGL_GETENV("EASYFLOW")='1')  #FUN-640184
    OR (FGL_GETENV("SPC")='1'))
   THEN                                                     
      LET lc_dbs = FGL_GETENV("DB")
   ELSE
      #No:TQC-870015 --start--
      SELECT zx07,zx08 INTO l_zx07,mi_plant FROM zx_file WHERE zx01=mi_user
      IF (SQLCA.SQLCODE) THEN
         RETURN lc_dbs
      END IF
 
      IF (l_zx07 = 'Y') THEN
      #No:TQC-870015 ---end---
         #查process裡面是否有記錄最後選擇的資料庫，沒有的話代表第一次進來，還是抓zx設定
         LET ls_fglserver = FGL_GETENV("FGLSERVER")
         LET ls_fglserver = industry_run_chg_iprec(ls_fglserver)

         LET ls_sql = "SELECT COUNT(*) FROM gbq_file ",
                      " WHERE gbq02 = '",ls_fglserver,"' AND gbq10 IS NOT NULL",
                      "   AND gbq03 = '",mi_user,"'"
         PREPARE gbq_cnt_pre FROM ls_sql
         EXECUTE gbq_cnt_pre INTO li_cnt
         IF li_cnt > 0 THEN
            LET ls_sql = "SELECT gbq10 FROM gbq_file ",
                         " WHERE gbq02 = '",ls_fglserver,"' AND gbq10 IS NOT NULL",
                         "   AND gbq03 = '",mi_user,"'"
            PREPARE gbq10_pre FROM ls_sql
            DECLARE gbq10_curs CURSOR FOR gbq10_pre
            FOREACH gbq10_curs INTO lc_gbq10
               LET ls_gbq10 = lc_gbq10 CLIPPED
               LET ls_gbq10 = ls_gbq10.subString(ls_gbq10.getIndexOf("/",1) + 1,ls_gbq10.getLength())
               LET mi_plant = ls_gbq10
               EXIT FOREACH
            END FOREACH
#        ELSE      #No:TQC-870015 --mark--
         END IF    #No:TQC-870015
#No:TQC-870015 --mark start--
#        SELECT zx07,zx08 INTO l_zx07,mi_plant FROM zx_file WHERE zx01=mi_user
#        IF (SQLCA.SQLCODE) THEN
#           RETURN lc_dbs
#        END IF
#
#        # Mark By Raymon 多工廠的切換機制需要再調整(1. 取消 zxx_file 2.預設工廠 ...)
#        IF (l_zx07 = 'Y') THEN
#           CASE
#              WHEN (mi_gui_type = 0) OR (mi_gui_type = 1)
#                 LET lc_tty_no = FGL_GETENV('LOGTTY')
#              WHEN (mi_gui_type = 2) OR (mi_gui_type = 3)
#                 LET ls_tty_no = FGL_GETENV('FGLSERVER')
#                 LET lc_tty_no = ls_tty_no.trim()
#           END CASE

#           IF (lc_tty_no IS NULL) THEN
#              LET lc_tty_no = '-'
#           END IF
#           SELECT zxx03 INTO mi_plant FROM zxx_file
#            WHERE zxx01=mi_user AND zxx02=lc_tty_no
#           IF (mi_plant IS NULL) THEN
#              RETURN lc_dbs
#           ELSE
#              SELECT * FROM azp_file WHERE azp01=mi_plant
#              IF SQLCA.SQLCODE THEN
#                 SELECT zx08 INTO mi_plant FROM zx_file WHERE zx01=mi_user
#              END IF
#           END IF
#        END IF
#No:TQC-870015 ---mark end---
      END IF

      SELECT azp03 INTO lc_dbs FROM azp_file WHERE azp01=mi_plant
   END IF

   RETURN lc_dbs
END FUNCTION

FUNCTION industry_run_chg_iprec(ps_fglserver)
   DEFINE   ps_fglserver   STRING
   DEFINE   ls_logtty      STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   ls_cmd         STRING
   DEFINE   ls_serverip    STRING
   DEFINE   li_cnt         LIKE type_file.num5

   CASE
      WHEN mi_gui_type = "1"
         LET ls_logtty = FGL_GETENV("LOGTTY")
         IF ls_logtty.getIndexOf("/dev/",1) THEN
            LET ls_logtty = ls_logtty.subString(6,ls_logtty.getLength())
         END IF
         LET ps_fglserver = ps_fglserver," [",ls_logtty,"]"
      WHEN mi_gui_type = "2" OR mi_gui_type = "3"
         LET ls_cmd = "grep -i `hostname` /etc/hosts | head -1 | cut -f1"
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openPipe(ls_cmd,"r")
         WHILE (lc_channel.read(ls_serverip))
         END WHILE
         CALL lc_channel.close()
         IF (ps_fglserver.getIndexOf("127.0.0.1", 1) > 0 OR
             ps_fglserver.getIndexOf(ls_serverip,1)) AND
            FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") IS NOT NULL THEN
            LET li_cnt = ps_fglserver.getIndexOf(":", 1)
            LET ps_fglserver = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR"), ps_fglserver.subString(li_cnt, ps_fglserver.getLength())
         END IF
   END CASE
   RETURN ps_fglserver
END FUNCTION
#No:FUN-750068 ---end---
