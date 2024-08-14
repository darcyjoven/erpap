##################################################
# Description  	: 匯客製資料
# Date & Author : 2005/01/10 by saki
# Parameter   	: 
# Return   	: 
# Memo        	: 只匯客製資料
# Modify   	: No:FUN-660021 06/06/27 By saki link資料更新方式
# Modify   	: 2006/12/04 FUN-6B0082 by alexstar   
# Modify   	: 2007/03/28 FUN-730047 by alexstar   
# Modify   	: 2007/05/17 TQC-750087 by alexstar   
# Modify        : No:FUN-750075 2007/05/18 by alexstar For AP DB分開環境
# Modify        : No:CHI-750028 2007/05/23 by saki 5X功能
# Modify        : No:TQC-7A0101 2007/10/29 by saki 資料同步增加zaw_file
# Modify        : No:TQC-7B0017 2007/11/02 by saki 開其他DB前要先CLOSE DATABASE
# Modify        : No:FUN-7C0044 2007/12/18 by saki 增加資料同步zay_file
# Modify        : No:TQC-820013 2008/02/20 by alexstar 動態抓取temporary tablespace名稱
# Modify        : No:FUN-840067 2008/04/22 by saki 上傳相關文件
# Modify        : No:CHI-AB0034 2010/12/31 by joyce 承接user輸入的sys及system密碼
##################################################
IMPORT os     #No:FUN-840067

DATABASE ds

DEFINE   g_syspass    STRING   #FUN-730047
DEFINE   g_systempass STRING   #FUN-730047
DEFINE   g_dir        STRING   #No:FUN-840067

MAIN
   DEFINE   g_ora_sid    STRING    #FUN-6B0082 
   DEFINE   g_dbs        CHAR(10)
   DEFINE   g_db_type    CHAR(3)
   DEFINE   l_cmd        STRING
   DEFINE   l_result     SMALLINT
   DEFINE   lc_channel   base.Channel
   DEFINE   gc_channel   base.Channel
   DEFINE   l_str        STRING
   DEFINE   lr_ze        RECORD LIKE ze_file.*
   DEFINE   lr_zz        RECORD LIKE zz_file.*
   DEFINE   lr_zm        RECORD LIKE zm_file.*
   DEFINE   lr_gap       RECORD LIKE gap_file.*
   DEFINE   lr_gbd       RECORD LIKE gbd_file.*
   DEFINE   lr_gao       RECORD LIKE gao_file.*
   DEFINE   lr_gae       RECORD LIKE gae_file.*
   DEFINE   lr_gak       RECORD LIKE gak_file.*
   DEFINE   lr_gal       RECORD LIKE gal_file.*
   DEFINE   lr_gaq       RECORD LIKE gaq_file.*
   DEFINE   lr_gab       RECORD LIKE gab_file.*
   DEFINE   lr_gac       RECORD LIKE gac_file.*
   DEFINE   lr_gav       RECORD LIKE gav_file.*
   DEFINE   lr_gat       RECORD LIKE gat_file.*
   DEFINE   lr_wsa       RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       RECORD LIKE zaa_file.*
   DEFINE   lr_zab       RECORD LIKE zab_file.*
   DEFINE   lr_gaz       RECORD LIKE gaz_file.*
   DEFINE   lr_zai       RECORD LIKE zai_file.*
   DEFINE   lr_zaj       RECORD LIKE zaj_file.*
   DEFINE   lr_zak       RECORD LIKE zak_file.*
   DEFINE   lr_zal       RECORD LIKE zal_file.*
   DEFINE   lr_zam       RECORD LIKE zam_file.*
   DEFINE   lr_zan       RECORD LIKE zan_file.*
   DEFINE   lr_zao       RECORD LIKE zao_file.*
   DEFINE   lr_zap       RECORD LIKE zap_file.*
   DEFINE   lr_zaq       RECORD LIKE zaq_file.*
   DEFINE   lr_zar       RECORD LIKE zar_file.*
   DEFINE   lr_zas       RECORD LIKE zas_file.*
   DEFINE   lr_zat       RECORD LIKE zat_file.*
   DEFINE   lr_zau       RECORD LIKE zau_file.*
   DEFINE   lr_zav       RECORD LIKE zav_file.*
   DEFINE   lr_zaw       RECORD LIKE zaw_file.*    #No:TQC-7A0101
   DEFINE   lr_zay       RECORD LIKE zay_file.*    #No:FUN-7C0044
   DEFINE   lr_gzl       RECORD LIKE gzl_file.*
   DEFINE   lr_gzln      RECORD LIKE gzln_file.*
   DEFINE   lr_gsyc      RECORD LIKE gsyc_file.*
   DEFINE   lr_gfb       RECORD LIKE gfb_file.*    #No:FUN-840067
   DEFINE   lr_gfc       RECORD LIKE gfc_file.*    #No:FUN-840067
   DEFINE   lr_gfd       RECORD LIKE gfd_file.*    #No:FUN-840067
   DEFINE   lr_gca       RECORD LIKE gca_file.*    #No:FUN-840067
   DEFINE   lr_gcb       RECORD LIKE gcb_file.*    #No:FUN-840067
   DEFINE   lc_zz08      LIKE zz_file.zz08
   DEFINE   l_tempdir    STRING
   DEFINE   li_count     INTEGER               # 為了要計算一個table做了幾筆資料
   DEFINE   ls_sql       STRING
   DEFINE   lc_zaa11     LIKE zaa_file.zaa11
   DEFINE   lr_4sm       DYNAMIC ARRAY OF RECORD
               zz01      LIKE zz_file.zz01,
               old_str   STRING,
               new_str   STRING
                         END RECORD
   DEFINE   li_i         SMALLINT
   DEFINE   li_cnt       SMALLINT              #No:FUN-660021
   DEFINE   l_tmp_name   CHAR(20)  #TQC-820013


   LET l_result = TRUE

   WHENEVER ERROR CONTINUE
   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET g_dir = ARG_VAL(1)
   LET g_dbs = ARG_VAL(2)
   LET g_syspass = ARG_VAL(3)   # No:CHI-AB0034
   LET g_systempass = ARG_VAL(4)   # No:CHI-AB0034
   LET g_ora_sid = FGL_GETENV("ORACLE_SID") #FUN-6B0082
#  LET g_syspass    = "change_on_install"     #FUN-730047       #Set default value   # No:CHI-AB0034
#  LET g_systempass = "manager"               #FUN-730047       #Set default value   # No:CHI-AB0034

   # No:CHI-AB0034 ---start---
   IF g_db_type="ORA" THEN    #FUN-730047
   #  CALL patch_get_custpass()

      IF g_syspass IS NULL THEN
         LET g_syspass = "change_on_install"
      END IF

      IF g_systempass IS NULL THEN
         LET g_systempass = "manager"
      END IF
   END IF
   # No:CHI-AB0034 --- end ---

   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET gc_channel = base.Channel.create()
   LET l_cmd = l_tempdir,"/",g_dir,"/patch_",g_dir,".log"
   CALL gc_channel.openFile(l_cmd,"w")
   CALL gc_channel.setDelimiter("")

   LET lc_channel = base.Channel.create()
   LET l_str = "import_data.sh"
   CALL lc_channel.openFile(l_str,"w")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("#!/bin/ksh")
   IF g_db_type = "IFX" THEN
      RUN "echo 'drop database custtemp'|dbaccess"
      LET l_cmd="dbimport custtemp -l -d ",g_dbs CLIPPED
      RUN l_cmd
   ELSE
      SELECT property_value INTO l_tmp_name FROM database_properties   #TQC-820013
       WHERE property_name='DEFAULT_TEMP_TABLESPACE'

      CALL lc_channel.write("ex - <<%%")
      CALL lc_channel.write("a")
      CALL lc_channel.write("conn system/" || g_systempass || "@`echo $ORACLE_SID`;")   #FUN-730047
      CALL lc_channel.write("drop user custtemp cascade;")
      CALL lc_channel.write("create user custtemp identified by custtemp")
      LET l_cmd="default tablespace ",g_dbs CLIPPED
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write("temporary tablespace " || l_tmp_name CLIPPED || ";")  #TQC-820013
      CALL lc_channel.write("grant create session,create table to custtemp;")
      CALL lc_channel.write("grant resource to custtemp;")
      CALL lc_channel.write("grant create synonym to custtemp;")
      CALL lc_channel.write("conn sys/" || g_syspass || "@`echo $ORACLE_SID` as sysdba;")   
      CALL lc_channel.write("grant select on sys.v_\\$session to custtemp;")  
      CALL lc_channel.write("exit;")
      CALL lc_channel.write(".")
      CALL fgl_getenv("TEMPDIR") RETURNING l_str
      LET l_str="w! ",l_str CLIPPED,"/createdb.sql"
      CALL lc_channel.write(l_str CLIPPED)
      CALL lc_channel.write("q")
      CALL lc_channel.write("%%")
      CALL lc_channel.write("sqlplus system/" || g_systempass || "@$ORACLE_SID < $TEMPDIR/createdb.sql") #FUN-6B0082   #FUN-730047
      CALL lc_channel.write("cd $TOP/ora/work")
      CALL fgl_getenv("CUST") RETURNING l_str
      LET l_str="imp custtemp/custtemp@$ORACLE_SID file=",l_str,"/",g_dir,"/custtemp.dmp ignore=y"
      CALL lc_channel.write(l_str)
      CALL lc_channel.close() 
      RUN "chmod 777 $TEMPDIR/createdb.sql"
      RUN "chmod 777 import_data.sh"
      RUN "import_data.sh"
   END IF
   CALL lc_channel.close()

   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE custtemp
   IF g_db_type = "IFX" THEN
      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      DECLARE ze_curs CURSOR FOR
              SELECT * FROM custtemp:ze_file
      FOREACH ze_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file custtemp FOREACH 資料時產生錯誤，ze資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:ze_file VALUES(lr_ze.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:ze_file SET ds:ze_file.* = lr_ze.*
             WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload ze_file data error:",SQLCA.sqlcode," ",lr_ze.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "ze_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新zz_file資料"
      LET li_count = 0
      LET li_i = 1
      DECLARE zz_curs CURSOR FOR
              SELECT * FROM custtemp:zz_file
      FOREACH zz_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file custtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zz_file SET ds:zz_file.* = lr_zz.*
             WHERE zz01 = lr_zz.zz01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               SELECT zz08 INTO lc_zz08 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
               LET lr_4sm[li_i].zz01 = lr_zz.zz01
               LET lr_4sm[li_i].old_str = lc_zz08
               LET lr_4sm[li_i].new_str = lr_zz.zz08
               LET li_i = li_i + 1
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            SELECT zz08 INTO lc_zz08 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
            LET lr_4sm[li_i].zz01 = lr_zz.zz01
            LET lr_4sm[li_i].old_str = lc_zz08
            LET lr_4sm[li_i].new_str = lr_zz.zz08
            LET li_i = li_i + 1
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      CLOSE DATABASE
      DATABASE ds
      FOR li_i = 1 TO lr_4sm.getLength()
          CALL patch_update_4sm(lr_4sm[li_i].zz01,lr_4sm[li_i].old_str,lr_4sm[li_i].new_str)
      END FOR
      CLOSE DATABASE
      DATABASE custtemp
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      DECLARE gaz_curs CURSOR FOR
              SELECT * FROM custtemp:gaz_file
      FOREACH gaz_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file custtemp FOREACH 資料時產生錯誤，gaz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gaz_file VALUES(lr_gaz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaz_file SET ds:gaz_file.* = lr_gaz.* 
             WHERE gaz01 = lr_gaz.gaz01 AND gaz02 = lr_gaz.gaz02 AND gaz05 = lr_gaz.gaz05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaz_file data error:",SQLCA.sqlcode," ",lr_gaz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gaz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zm_file資料"
      LET li_count = 0
      DECLARE zm_curs CURSOR FOR
              SELECT * FROM custtemp:zm_file
      FOREACH zm_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file custtemp FOREACH 資料時產生錯誤，zm資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zm_file data error:",SQLCA.sqlcode," ",lr_zm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gap_file資料"
      LET li_count = 0
      DECLARE gap_curs CURSOR FOR
              SELECT * FROM custtemp:gap_file
      FOREACH gap_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gap_file custtemp FOREACH 資料時產生錯誤，gap資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gap_file VALUES(lr_gap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gap_file SET ds:gap_file.* = lr_gap.*
             WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gap_file data error:",SQLCA.sqlcode," ",lr_gap.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbd_file資料"
      LET li_count = 0
      DECLARE gbd_curs CURSOR FOR
              SELECT * FROM custtemp:gbd_file
      FOREACH gbd_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file custtemp FOREACH 資料時產生錯誤，gbd資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gbd_file VALUES(lr_gbd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbd_file SET ds:gbd_file.* = lr_gbd.*
             WHERE gbd01 = lr_gbd.gbd01 AND gbd02 = lr_gbd.gbd02
               AND gbd03 = lr_gbd.gbd03 AND gbd07 = lr_gbd.gbd07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbd_file data error:",SQLCA.sqlcode," ",lr_gbd.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gae_file資料"
      LET li_count = 0
      DECLARE gae_curs CURSOR FOR
              SELECT * FROM custtemp:gae_file
      FOREACH gae_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file custtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gae_file SET ds:gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gae_file data error:",SQLCA.sqlcode," ",lr_gae.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gae_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gak_file資料"
      LET li_count = 0
      DECLARE gak_curs CURSOR FOR
              SELECT * FROM custtemp:gak_file
      FOREACH gak_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file custtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gak_file SET ds:gak_file.* = lr_gak.*
             WHERE gak01 = lr_gak.gak01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gak_file data error:",SQLCA.sqlcode," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      DECLARE gal_curs CURSOR FOR
              SELECT * FROM custtemp:gal_file
      FOREACH gal_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file custtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         #No:FUN-660021 --start--
         #先確認程式代碼下有沒有同樣的連結程式
         SELECT COUNT(*) INTO li_cnt FROM ds:gal_file
          WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
         IF li_cnt > 0 THEN
            #如果是lib,sub,qry共用程式，先將原有程式update成不連結，再上新程式
            IF lr_gal.gal01 = "lib" OR lr_gal.gal01 = "sub" OR lr_gal.gal01 = "qry" THEN
               UPDATE ds:gal_file SET ds:gal_file.gal04 = "N"
                WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02 
                  AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "change ",lr_gal.gal01," package to custom error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  INSERT INTO ds:gal_file VALUES(lr_gal.*)
                  IF SQLCA.sqlcode THEN
                     UPDATE ds:gal_file SET ds:gal_file.* = lr_gal.*
                      WHERE gal01 = lr_gal.gal01 AND gal02 = lr_gal.gal02
                        AND gal03 = lr_gal.gal03
                     IF SQLCA.sqlcode THEN
                        LET l_cmd = "update gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                        CALL gc_channel.write(l_cmd)
                        LET l_result = FALSE
                     ELSE
                        LET li_count = li_count + SQLCA.sqlerrd[3]
                     END IF
                  ELSE
                     LET li_count = li_count + SQLCA.sqlerrd[3]
                  END IF
               END IF
            ELSE
            #一般作業將原先系統代碼換為客製代碼
              #TQC-750087 mark
              #DELETE FROM ds:gal_file
              # WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02
              #   AND gal03 = lr_gal.gal03
             #TQC-750087 add
               UPDATE ds:gal_file SET ds:gal_file.gal04 = "N"
                WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02
                  AND gal03 = lr_gal.gal03

               IF SQLCA.sqlcode THEN    #TQC-750087 
                  LET l_cmd = "change ",lr_gal.gal01," package to custom error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               END IF
               INSERT INTO ds:gal_file VALUES(lr_gal.*)
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            END IF
         ELSE
            INSERT INTO ds:gal_file VALUES(lr_gal.*)
            IF SQLCA.sqlcode THEN
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END IF
         #No:FUN-660021 ---end---
      END FOREACH
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      DECLARE gaq_curs CURSOR FOR
              SELECT * FROM custtemp:gaq_file
      FOREACH gaq_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file custtemp FOREACH 資料時產生錯誤，gaq資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaq_file SET ds:gaq_file.* = lr_gaq.*
             WHERE gaq01 = lr_gaq.gaq01 AND gaq02 = lr_gaq.gaq02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaq_file data error:",SQLCA.sqlcode," ",lr_gaq.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gab_file資料"
      LET li_count = 0
      DECLARE gab_curs CURSOR FOR
              SELECT * FROM custtemp:gab_file
      FOREACH gab_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file custtemp FOREACH 資料時產生錯誤，gab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gab_file VALUES(lr_gab.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gab_file SET ds:gab_file.* = lr_gab.*
             WHERE gab01 = lr_gab.gab01 AND gab11 = lr_gab.gab11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gab_file data error:",SQLCA.sqlcode," ",lr_gab.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gac_file資料"
      LET li_count = 0
      DECLARE gac_curs CURSOR FOR
              SELECT * FROM custtemp:gac_file
      FOREACH gac_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file custtemp FOREACH 資料時產生錯誤，gac資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gac_file VALUES(lr_gac.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gac_file SET ds:gac_file.* = lr_gac.*
             WHERE gac01 = lr_gac.gac01 AND gac02 = lr_gac.gac02
               AND gac03 = lr_gac.gac03 AND gac12 = lr_gac.gac12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gac_file data error:",SQLCA.sqlcode," ",lr_gac.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gac_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gav_file資料"
      LET li_count = 0
      DECLARE gav_curs CURSOR FOR
              SELECT * FROM custtemp:gav_file
      FOREACH gav_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file custtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gav_file SET ds:gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02 AND gav08 = lr_gav.gav08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gav_file data error:",SQLCA.sqlcode," ",lr_gav.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gav_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gat_file資料"
      LET li_count = 0
      DECLARE gat_curs CURSOR FOR
              SELECT * FROM custtemp:gat_file
      FOREACH gat_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file custtemp FOREACH 資料時產生錯誤，gat資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gat_file VALUES(lr_gat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gat_file SET ds:gat_file.* = lr_gat.*
             WHERE gat01 = lr_gat.gat01 AND gat02 = lr_gat.gat02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gat_file data error:",SQLCA.sqlcode," ",lr_gat.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsa_file資料"
      LET li_count = 0
      DECLARE wsa_curs CURSOR FOR
              SELECT * FROM custtemp:wsa_file
      FOREACH wsa_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file custtemp FOREACH 資料時產生錯誤，wsa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsa_file VALUES(lr_wsa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsa_file SET ds:wsa_file.* = lr_wsa.*
             WHERE wsa01 = lr_wsa.wsa01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsa_file data error:",SQLCA.sqlcode," ",lr_wsa.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsb_file資料"
      LET li_count = 0
      DECLARE wsb_curs CURSOR FOR
              SELECT * FROM custtemp:wsb_file
      FOREACH wsb_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file custtemp FOREACH 資料時產生錯誤，wsb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsb_file VALUES(lr_wsb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsb_file SET ds:wsb_file.* = lr_wsb.*
             WHERE wsb01 = lr_wsb.wsb01 AND wsb02 = lr_wsb.wsb02
               AND wsb03 = lr_wsb.wsb03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsb_file data error:",SQLCA.sqlcode," ",lr_wsb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaa_file資料"
      LET li_count = 0
      DECLARE zaa_curs CURSOR FOR
              SELECT * FROM custtemp:zaa_file
      FOREACH zaa_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file custtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         # 2005/08/19 saki for 憑證報表的樣板voucher以後都取消
         IF lr_zaa.zaa11 != "voucher" THEN
            LET ls_sql = "SELECT zaa11 FROM ds:zaa_file ",
                         " WHERE zaa01 = '",lr_zaa.zaa01 CLIPPED,"'",
                         "   AND zaa02 = '",lr_zaa.zaa02 CLIPPED,"'",
                         "   AND zaa03 = '",lr_zaa.zaa03 CLIPPED,"'",
                         "   AND zaa04 = '",lr_zaa.zaa04 CLIPPED,"'",
                         "   AND zaa10 = '",lr_zaa.zaa10 CLIPPED,"'",
                         "   AND zaa11 = '",lr_zaa.zaa11 CLIPPED,"'",
                         "   AND zaa17 = '",lr_zaa.zaa17 CLIPPED,"'"
            DECLARE voucher_curs CURSOR FROM ls_sql
            FOREACH voucher_curs INTO lc_zaa11
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF

               IF lc_zaa11 = "voucher" THEN
                  DELETE FROM ds:zaa_file
                   WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
                     AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
                     AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
                     AND zaa17 = lr_zaa.zaa17
               END IF
            END FOREACH
         END IF
         # ---end---

         INSERT INTO ds:zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaa_file SET ds:zaa_file.* = lr_zaa.*
             WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
               AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
               AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
               AND zaa17 = lr_zaa.zaa17
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaa_file data error:",SQLCA.sqlcode," ",lr_zaa.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zab_file資料"
      LET li_count = 0
      DECLARE zab_curs CURSOR FOR
              SELECT * FROM custtemp:zab_file
      FOREACH zab_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file custtemp FOREACH 資料時產生錯誤，zab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zab_file data error:",SQLCA.sqlcode," ",lr_zab.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gao_file資料"
      LET li_count = 0
      DECLARE gao_curs CURSOR FOR
              SELECT * FROM custtemp:gao_file
      FOREACH gao_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gao_file custtemp FOREACH 資料時產生錯誤，gao資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gao_file VALUES(lr_gao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gao_file SET ds:gao_file.* = lr_gao.*
             WHERE gao01 = lr_gao.gao01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gao_file data error:",SQLCA.sqlcode," ",lr_gao.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gao_file 更新完畢，共更新 ",li_count,"筆資料"


      #No:CHI-750028 --start--
      DISPLAY "開始更新zai_file資料"
      LET li_count = 0
      DECLARE zai_curs CURSOR FOR
              SELECT * FROM custtemp:zai_file
      FOREACH zai_curs INTO lr_zai.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zai_file custtemp FOREACH 資料時產生錯誤，zai資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zai_file VALUES(lr_zai.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zai_file SET ds:zai_file.* = lr_zai.*
             WHERE zai01 = lr_zai.zai01 AND zai05 = lr_zai.zai05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zai_file data error:",SQLCA.sqlcode," ",lr_zai.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zai_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaj_file資料"
      LET li_count = 0
      DECLARE zaj_curs CURSOR FOR
              SELECT * FROM custtemp:zaj_file
      FOREACH zaj_curs INTO lr_zaj.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaj_file custtemp FOREACH 資料時產生錯誤，zaj資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zaj_file VALUES(lr_zaj.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaj_file SET ds:zaj_file.* = lr_zaj.*
             WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02
               AND zaj07 = lr_zaj.zaj07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaj_file data error:",SQLCA.sqlcode," ",lr_zaj.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaj_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zak_file資料"
      LET li_count = 0
      DECLARE zak_curs CURSOR FOR
              SELECT * FROM custtemp:zak_file
      FOREACH zak_curs INTO lr_zak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zak_file custtemp FOREACH 資料時產生錯誤，zak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zak_file VALUES(lr_zak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zak_file SET ds:zak_file.* = lr_zak.*
             WHERE zak01 = lr_zak.zak01 AND zak07 = lr_zak.zak07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zak_file data error:",SQLCA.sqlcode," ",lr_zak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zal_file資料"
      LET li_count = 0
      DECLARE zal_curs CURSOR FOR
              SELECT * FROM custtemp:zal_file
      FOREACH zal_curs INTO lr_zal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zal_file custtemp FOREACH 資料時產生錯誤，zal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zal_file VALUES(lr_zal.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zal_file SET ds:zal_file.* = lr_zal.*
             WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
               AND zal03 = lr_zal.zal03 AND zal07 = lr_zal.zal07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zal_file data error:",SQLCA.sqlcode," ",lr_zal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zam_file資料"
      LET li_count = 0
      DECLARE zam_curs CURSOR FOR
              SELECT * FROM custtemp:zam_file
      FOREACH zam_curs INTO lr_zam.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zam_file custtemp FOREACH 資料時產生錯誤，zam資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zam_file VALUES(lr_zam.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zam_file SET ds:zam_file.* = lr_zam.*
             WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02
               AND zam09 = lr_zam.zam09
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zam_file data error:",SQLCA.sqlcode," ",lr_zam.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zam_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zan_file資料"
      LET li_count = 0
      DECLARE zan_curs CURSOR FOR
              SELECT * FROM custtemp:zan_file
      FOREACH zan_curs INTO lr_zan.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zan_file custtemp FOREACH 資料時產生錯誤，zan資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zan_file VALUES(lr_zan.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zan_file SET ds:zan_file.* = lr_zan.*
             WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02
               AND zan08 = lr_zan.zan08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zan_file data error:",SQLCA.sqlcode," ",lr_zan.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zan_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zao_file資料"
      LET li_count = 0
      DECLARE zao_curs CURSOR FOR
              SELECT * FROM custtemp:zao_file
      FOREACH zao_curs INTO lr_zao.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zao_file custtemp FOREACH 資料時產生錯誤，zao資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zao_file VALUES(lr_zao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zao_file SET ds:zao_file.* = lr_zao.*
             WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
               AND zao03 = lr_zao.zao03 AND zao05 = lr_zao.zao05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zao_file data error:",SQLCA.sqlcode," ",lr_zao.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zap_file資料"
      LET li_count = 0
      DECLARE zap_curs CURSOR FOR
              SELECT * FROM custtemp:zap_file
      FOREACH zap_curs INTO lr_zap.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zap_file custtemp FOREACH 資料時產生錯誤，zap資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zap_file VALUES(lr_zap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zap_file SET ds:zap_file.* = lr_zap.*
             WHERE zap01 = lr_zap.zap01 AND zap07 = lr_zap.zap07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zap_file data error:",SQLCA.sqlcode," ",lr_zap.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaq_file資料"
      LET li_count = 0
      DECLARE zaq_curs CURSOR FOR
              SELECT * FROM custtemp:zaq_file
      FOREACH zaq_curs INTO lr_zaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaq_file custtemp FOREACH 資料時產生錯誤，zaq資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zaq_file VALUES(lr_zaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaq_file SET ds:zaq_file.* = lr_zaq.*
             WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02
               AND zaq05 = lr_zaq.zaq05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaq_file data error:",SQLCA.sqlcode," ",lr_zaq.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zar_file資料"
      LET li_count = 0
      DECLARE zar_curs CURSOR FOR
              SELECT * FROM custtemp:zar_file
      FOREACH zar_curs INTO lr_zar.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zar_file custtemp FOREACH 資料時產生錯誤，zar資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zar_file VALUES(lr_zar.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zar_file SET ds:zar_file.* = lr_zar.*
             WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
               AND zar03 = lr_zar.zar03 AND zar05 = lr_zar.zar05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zar_file data error:",SQLCA.sqlcode," ",lr_zar.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zar_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zas_file資料"
      LET li_count = 0
      DECLARE zas_curs CURSOR FOR
              SELECT * FROM custtemp:zas_file
      FOREACH zas_curs INTO lr_zas.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zas_file custtemp FOREACH 資料時產生錯誤，zas資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zas_file VALUES(lr_zas.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zas_file SET ds:zas_file.* = lr_zas.*
             WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02
               AND zas11 = lr_zas.zas11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zas_file data error:",SQLCA.sqlcode," ",lr_zas.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zas_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zat_file資料"
      LET li_count = 0
      DECLARE zat_curs CURSOR FOR
              SELECT * FROM custtemp:zat_file
      FOREACH zat_curs INTO lr_zat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zat_file custtemp FOREACH 資料時產生錯誤，zat資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zat_file VALUES(lr_zat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zat_file SET ds:zat_file.* = lr_zat.*
             WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
               AND zat10 = lr_zat.zat10
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zat_file data error:",SQLCA.sqlcode," ",lr_zat.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zau_file資料"
      LET li_count = 0
      DECLARE zau_curs CURSOR FOR
              SELECT * FROM custtemp:zau_file
      FOREACH zau_curs INTO lr_zau.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zau_file custtemp FOREACH 資料時產生錯誤，zau資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zau_file VALUES(lr_zau.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zau_file SET ds:zau_file.* = lr_zau.*
             WHERE zau01 = lr_zau.zau01 AND zau04 = lr_zau.zau04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zau_file data error:",SQLCA.sqlcode," ",lr_zau.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zau_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zav_file資料"
      LET li_count = 0
      DECLARE zav_curs CURSOR FOR
              SELECT * FROM custtemp:zav_file
      FOREACH zav_curs INTO lr_zav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zav_file custtemp FOREACH 資料時產生錯誤，zav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zav_file VALUES(lr_zav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zav_file SET ds:zav_file.* = lr_zav.*
             WHERE zav01 = lr_zav.zav01 AND zav02 = lr_zav.zav02
               AND zav03 = lr_zav.zav03 AND zav04 = lr_zav.zav04
               AND zav05 = lr_zav.zav05 AND zav24 = lr_zav.zav24
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zav_file data error:",SQLCA.sqlcode," ",lr_zav.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zav_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:CHI-750028 ---end---


      #No:TQC-7A0101 --start--
      DISPLAY "開始更新zaw_file資料"
      LET li_count = 0
      DECLARE zaw_curs CURSOR FOR
              SELECT * FROM custtemp:zaw_file
      FOREACH zaw_curs INTO lr_zaw.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaw_file custtemp FOREACH 資料時產生錯誤，zaw資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zaw_file VALUES(lr_zaw.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaw_file SET ds:zaw_file.* = lr_zaw.*
             WHERE zaw01 = lr_zaw.zaw01 AND zaw02 = lr_zaw.zaw02
               AND zaw03 = lr_zaw.zaw03 AND zaw04 = lr_zaw.zaw04
               AND zaw05 = lr_zaw.zaw05 AND zaw06 = lr_zaw.zaw06
               AND zaw07 = lr_zaw.zaw07 AND zaw10 = lr_zaw.zaw10
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaw_file data error:",SQLCA.sqlcode," ",lr_zaw.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaw_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:TQC-7A0101 ---end---


      #No:FUN-7C0044 --start--
      DISPLAY "開始更新zay_file資料"
      LET li_count = 0
      DECLARE zay_curs CURSOR FOR
              SELECT * FROM custtemp:zay_file
      FOREACH zay_curs INTO lr_zay.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zay_file custtemp FOREACH 資料時產生錯誤，zay資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zay_file VALUES(lr_zay.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zay_file SET ds:zay_file.* = lr_zay.*
             WHERE zay01 = lr_zay.zay01 AND zay02 = lr_zay.zay02
               AND zay03 = lr_zay.zay03 AND zay05 = lr_zay.zay05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zay_file data error:",SQLCA.sqlcode," ",lr_zay.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zay_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-7C0044 ---end---


      DISPLAY "開始更新gzl_file資料"
      LET li_count = 0
      DECLARE gzl_curs CURSOR FOR
              SELECT * FROM custtemp:gzl_file
      FOREACH gzl_curs INTO lr_gzl.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gzl_file custtemp FOREACH 資料時產生錯誤，gzl資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gzl_file VALUES(lr_gzl.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gzl_file SET ds:gzl_file.* = lr_gzl.*
             WHERE gzl00 = lr_gzl.gzl00 AND gzl01 = lr_gzl.gzl01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gzl_file data error:",SQLCA.sqlcode," ",lr_gzl.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gzl_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gzln_file資料"
      LET li_count = 0
      DECLARE gzln_curs CURSOR FOR
              SELECT * FROM custtemp:gzln_file
      FOREACH gzln_curs INTO lr_gzln.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gzln_file custtemp FOREACH 資料時產生錯誤，gzln資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gzln_file VALUES(lr_gzln.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gzln_file SET ds:gzln_file.* = lr_gzln.*
             WHERE gzln00 = lr_gzln.gzln00 AND gzln01 = lr_gzln.gzln01
               AND gzln02 = lr_gzln.gzln02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gzln_file data error:",SQLCA.sqlcode," ",lr_gzln.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gzln_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gsyc_file資料"
      LET li_count = 0
      DECLARE gsyc_curs CURSOR FOR
              SELECT * FROM custtemp:gsyc_file
      FOREACH gsyc_curs INTO lr_gsyc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gsyc_file custtemp FOREACH 資料時產生錯誤，gsyc資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gsyc_file VALUES(lr_gsyc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gsyc_file SET ds:gsyc_file.* = lr_gsyc.*
             WHERE gsyc00 = lr_gsyc.gsyc00 AND gsyc01 = lr_gsyc.gsyc01
               AND gsyc02 = lr_gsyc.gsyc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gsyc_file data error:",SQLCA.sqlcode," ",lr_gsyc.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gsyc_file 更新完畢，共更新 ",li_count,"筆資料"

      #No:FUN-840067 --start--
      DISPLAY "開始更新gfb_file資料"
      LET li_count = 0
      DECLARE gfb_curs CURSOR FOR
              SELECT * FROM custtemp:gfb_file
      FOREACH gfb_curs INTO lr_gfb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfb_file custtemp FOREACH 資料時產生錯誤，gfb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gfb_file VALUES(lr_gfb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gfb_file SET ds:gfb_file.* = lr_gfb.*
             WHERE gfb01 = lr_gfb.gfb01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfb_file data error:",SQLCA.sqlcode," ",lr_gfb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfb_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gfc_file資料"
      LET li_count = 0
      DECLARE gfc_curs CURSOR FOR
              SELECT * FROM custtemp:gfc_file
      FOREACH gfc_curs INTO lr_gfc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfc_file custtemp FOREACH 資料時產生錯誤，gfc資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gfc_file VALUES(lr_gfc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gfc_file SET ds:gfc_file.* = lr_gfc.*
             WHERE gfc01 = lr_gfc.gfc01 AND gfc02 = lr_gfc.gfc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfc_file data error:",SQLCA.sqlcode," ",lr_gfc.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfc_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gfd_file資料"
      LET li_count = 0
      DECLARE gfd_curs CURSOR FOR
              SELECT * FROM custtemp:gfd_file
      FOREACH gfd_curs INTO lr_gfd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfd_file custtemp FOREACH 資料時產生錯誤，gfd資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gfd_file VALUES(lr_gfd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gfd_file SET ds:gfd_file.* = lr_gfd.*
             WHERE gfd01 = lr_gfd.gfd01 AND gfd02 = lr_gfd.gfd02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfd_file data error:",SQLCA.sqlcode," ",lr_gfd.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfd_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gca_file資料"
      LET li_count = 0
      DECLARE gca_curs CURSOR FOR
              SELECT * FROM custtemp:gca_file
      FOREACH gca_curs INTO lr_gca.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gca_file custtemp FOREACH 資料時產生錯誤，gca資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gca_file VALUES(lr_gca.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gca_file SET ds:gca_file.* = lr_gca.*
             WHERE gca01 = lr_gca.gca01 AND gca02 = lr_gca.gca02
               AND gca03 = lr_gca.gca03 AND gca04 = lr_gca.gca04
               AND gca05 = lr_gca.gca05 AND gca06 = lr_gca.gca06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gca_file data error:",SQLCA.sqlcode," ",lr_gca.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gca_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gcb_file資料"
      LET li_count = 0
      DECLARE gcb_curs CURSOR FOR
              SELECT * FROM custtemp:gcb_file
      FOREACH gcb_curs INTO lr_gcb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gcb_file custtemp FOREACH 資料時產生錯誤，gcb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gcb_file VALUES(lr_gcb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gcb_file SET ds:gcb_file.* = lr_gcb.*
             WHERE gcb01 = lr_gcb.gcb01 AND gcb02 = lr_gcb.gcb02
               AND gcb03 = lr_gcb.gcb03 AND gcb04 = lr_gcb.gcb04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gcb_file data error:",SQLCA.sqlcode," ",lr_gcb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
               CALL patch_import_doc(lr_gcb.*)
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
            CALL patch_import_doc(lr_gcb.*)
         END IF
      END FOREACH
      DISPLAY "gcb_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-840067 ---end---
   ELSE
      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      DECLARE ze_o_curs CURSOR FOR
              SELECT * FROM custtemp.ze_file
      FOREACH ze_o_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file custtemp FOREACH 資料時產生錯誤，ze資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.ze_file VALUES(lr_ze.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.ze_file SET ze_file.* = lr_ze.*
             WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload ze_file data error:",SQLCA.sqlerrd[2]," ",lr_ze.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "ze_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zz_file資料"
      LET li_count = 0
      LET li_i = 1
      DECLARE zz_o_curs CURSOR FOR
              SELECT * FROM custtemp.zz_file
      FOREACH zz_o_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file custtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zz_file SET zz_file.* = lr_zz.*
             WHERE zz01 = lr_zz.zz01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               SELECT zz08 INTO lc_zz08 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
               LET lr_4sm[li_i].zz01 = lr_zz.zz01
               LET lr_4sm[li_i].old_str = lc_zz08
               LET lr_4sm[li_i].new_str = lr_zz.zz08
               LET li_i = li_i + 1
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            SELECT zz08 INTO lc_zz08 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
            LET lr_4sm[li_i].zz01 = lr_zz.zz01
            LET lr_4sm[li_i].old_str = lc_zz08
            LET lr_4sm[li_i].new_str = lr_zz.zz08
            LET li_i = li_i + 1
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      CLOSE DATABASE
      DATABASE ds
      FOR li_i = 1 TO lr_4sm.getLength()
          CALL patch_update_4sm(lr_4sm[li_i].zz01,lr_4sm[li_i].old_str,lr_4sm[li_i].new_str)
      END FOR
      CLOSE DATABASE
      DATABASE custtemp
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      DECLARE gaz_o_curs CURSOR FOR
              SELECT * FROM custtemp.gaz_file
      FOREACH gaz_o_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file custtemp FOREACH 資料時產生錯誤，gaz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gaz_file VALUES(lr_gaz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gaz_file SET gaz_file.* = lr_gaz.* 
             WHERE gaz01 = lr_gaz.gaz01 AND gaz02 = lr_gaz.gaz02 AND gaz05 = lr_gaz.gaz05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaz_file data error:",SQLCA.sqlerrd[2]," ",lr_gaz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gaz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zm_file資料"
      LET li_count = 0
      DECLARE zm_o_curs CURSOR FOR
              SELECT * FROM custtemp.zm_file
      FOREACH zm_o_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file custtemp FOREACH 資料時產生錯誤，zm資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zm_file data error:",SQLCA.sqlerrd[2]," ",lr_zm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zm_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gap_file資料"
      LET li_count = 0
      DECLARE gap_o_curs CURSOR FOR
              SELECT * FROM custtemp.gap_file
      FOREACH gap_o_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gap_file custtemp FOREACH 資料時產生錯誤，gap資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gap_file VALUES(lr_gap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gap_file SET gap_file.* = lr_gap.*
             WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "insert gap_file data error:",SQLCA.sqlerrd[2]," ",lr_gap.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbd_file資料"
      LET li_count = 0
      DECLARE gbd_o_curs CURSOR FOR
              SELECT * FROM custtemp.gbd_file
      FOREACH gbd_o_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file custtemp FOREACH 資料時產生錯誤，gbd資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gbd_file VALUES(lr_gbd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbd_file SET gbd_file.* = lr_gbd.*
             WHERE gbd01 = lr_gbd.gbd01 AND gbd02 = lr_gbd.gbd02
               AND gbd03 = lr_gbd.gbd03 AND gbd07 = lr_gbd.gbd07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbd_file data error:",SQLCA.sqlerrd[2]," ",lr_gbd.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbd_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gae_file資料"
      LET li_count = 0
      DECLARE gae_o_curs CURSOR FOR
              SELECT * FROM custtemp.gae_file
      FOREACH gae_o_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file custtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gae_file SET gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gae_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gae_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gak_file資料"
      LET li_count = 0
      DECLARE gak_o_curs CURSOR FOR
              SELECT * FROM custtemp.gak_file
      FOREACH gak_o_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file custtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gak_file SET gak_file.* = lr_gak.*
             WHERE gak01 = lr_gak.gak01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      DECLARE gal_o_curs CURSOR FOR
              SELECT * FROM custtemp.gal_file
      FOREACH gal_o_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file custtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         #No:FUN-660021 --start--
         #先確認程式代碼下有沒有同樣的連結程式
         SELECT COUNT(*) INTO li_cnt FROM ds.gal_file
          WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
         IF li_cnt > 0 THEN
            #如果是lib,sub,qry共用程式，先將原有程式update成不連結，再上新程式
            IF lr_gal.gal01 = "lib" OR lr_gal.gal01 = "sub" OR lr_gal.gal01 = "qry" THEN
               UPDATE ds.gal_file SET gal04 = "N"
                WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02 
                  AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "change ",lr_gal.gal01," package to custom error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  INSERT INTO ds.gal_file VALUES(lr_gal.*)
                  IF SQLCA.sqlcode THEN
                     UPDATE ds.gal_file SET gal_file.* = lr_gal.*
                      WHERE gal01 = lr_gal.gal01 AND gal02 = lr_gal.gal02
                        AND gal03 = lr_gal.gal03
                     IF SQLCA.sqlcode THEN
                        LET l_cmd = "update gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                        CALL gc_channel.write(l_cmd)
                        LET l_result = FALSE
                     ELSE
                        LET li_count = li_count + SQLCA.sqlerrd[3]
                     END IF
                  ELSE
                     LET li_count = li_count + SQLCA.sqlerrd[3]
                  END IF
               END IF
            ELSE
            #一般作業將原先系統代碼換為客製代碼
              #TQC-750087 mark
              #DELETE FROM ds.gal_file
              # WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02
              #   AND gal03 = lr_gal.gal03
             #TQC-750087 add
               UPDATE ds.gal_file SET gal04 = "N"
                WHERE gal01 = lr_gal.gal01 AND gal02 != lr_gal.gal02
                  AND gal03 = lr_gal.gal03

               IF SQLCA.sqlcode THEN    #TQC-750087 
                  LET l_cmd = "change ",lr_gal.gal01," package to custom error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               END IF
               INSERT INTO ds.gal_file VALUES(lr_gal.*)
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            END IF
         ELSE
            INSERT INTO ds.gal_file VALUES(lr_gal.*)
            IF SQLCA.sqlcode THEN
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END IF
         #No:FUN-660021 ---end---
      END FOREACH
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      DECLARE gaq_o_curs CURSOR FOR
              SELECT * FROM custtemp.gaq_file
      FOREACH gaq_o_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file custtemp FOREACH 資料時產生錯誤，gaq資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gaq_file SET gaq_file.* = lr_gaq.*
             WHERE gaq01 = lr_gaq.gaq01 AND gaq02 = lr_gaq.gaq02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gaq_file data error:",SQLCA.sqlerrd[2]," ",lr_gaq.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gab_file資料"
      LET li_count = 0
      DECLARE gab_o_curs CURSOR FOR
              SELECT * FROM custtemp.gab_file
      FOREACH gab_o_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file custtemp FOREACH 資料時產生錯誤，gab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gab_file VALUES(lr_gab.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gab_file SET gab_file.* = lr_gab.*
             WHERE gab01 = lr_gab.gab01 AND gab11 = lr_gab.gab11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gab_file data error:",SQLCA.sqlerrd[2]," ",lr_gab.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gac_file資料"
      LET li_count = 0
      DECLARE gac_o_curs CURSOR FOR
              SELECT * FROM custtemp.gac_file
      FOREACH gac_o_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file custtemp FOREACH 資料時產生錯誤，gac資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gac_file VALUES(lr_gac.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gac_file SET gac_file.* = lr_gac.*
             WHERE gac01 = lr_gac.gac01 AND gac02 = lr_gac.gac02
               AND gac03 = lr_gac.gac03 AND gac12 = lr_gac.gac12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gac_file data error:",SQLCA.sqlerrd[2]," ",lr_gac.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gac_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gav_file資料"
      LET li_count = 0
      DECLARE gav_o_curs CURSOR FOR
              SELECT * FROM custtemp.gav_file
      FOREACH gav_o_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file custtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gav_file SET gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02 AND gav08 = lr_gav.gav08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gav_file data error:",SQLCA.sqlerrd[2]," ",lr_gav.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gav_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gat_file資料"
      LET li_count = 0
      DECLARE gat_o_curs CURSOR FOR
              SELECT * FROM custtemp.gat_file
      FOREACH gat_o_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file custtemp FOREACH 資料時產生錯誤，gat資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gat_file VALUES(lr_gat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gat_file SET gat_file.* = lr_gat.*
             WHERE gat01 = lr_gat.gat01 AND gat02 = lr_gat.gat02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gat_file data error:",SQLCA.sqlerrd[2]," ",lr_gat.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsa_file資料"
      LET li_count = 0
      DECLARE wsa_o_curs CURSOR FOR
              SELECT * FROM custtemp.wsa_file
      FOREACH wsa_o_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file custtemp FOREACH 資料時產生錯誤，wsa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wsa_file VALUES(lr_wsa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsa_file SET wsa_file.* = lr_wsa.*
             WHERE wsa01 = lr_wsa.wsa01 
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsa_file data error:",SQLCA.sqlerrd[2]," ",lr_wsa.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新wsb_file資料"
      LET li_count = 0
      DECLARE wsb_o_curs CURSOR FOR
              SELECT * FROM custtemp.wsb_file
      FOREACH wsb_o_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file custtemp FOREACH 資料時產生錯誤，wsb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wsb_file VALUES(lr_wsb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsb_file SET wsb_file.* = lr_wsb.*
             WHERE wsb01 = lr_wsb.wsb01 AND wsb02 = lr_wsb.wsb02
               AND wsb03 = lr_wsb.wsb03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsb_file data error:",SQLCA.sqlerrd[2]," ",lr_wsb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaa_file資料"
      LET li_count = 0
      DECLARE zaa_o_curs CURSOR FOR
              SELECT * FROM custtemp.zaa_file
      FOREACH zaa_o_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file custtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         # 2005/08/19 saki for 憑證報表的樣板voucher以後都取消
         IF lr_zaa.zaa11 != "voucher" THEN
            LET ls_sql = "SELECT zaa11 FROM ds.zaa_file ",
                         " WHERE zaa01 = '",lr_zaa.zaa01 CLIPPED,"'",
                         "   AND zaa02 = '",lr_zaa.zaa02 CLIPPED,"'",
                         "   AND zaa03 = '",lr_zaa.zaa03 CLIPPED,"'",
                         "   AND zaa04 = '",lr_zaa.zaa04 CLIPPED,"'",
                         "   AND zaa10 = '",lr_zaa.zaa10 CLIPPED,"'",
                         "   AND zaa11 = '",lr_zaa.zaa11 CLIPPED,"'",
                         "   AND zaa17 = '",lr_zaa.zaa17 CLIPPED,"'"
            DECLARE voucher_o_curs CURSOR FROM ls_sql
            FOREACH voucher_o_curs INTO lc_zaa11
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF

               IF lc_zaa11 = "voucher" THEN
                  DELETE FROM ds.zaa_file
                   WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
                     AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
                     AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
                     AND zaa17 = lr_zaa.zaa17
               END IF
            END FOREACH
         END IF
         # ---end---

         INSERT INTO ds.zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaa_file SET zaa_file.* = lr_zaa.*
             WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
               AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
               AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
               AND zaa17 = lr_zaa.zaa17
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaa_file data error:",SQLCA.sqlerrd[2]," ",lr_zaa.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaa_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zab_file資料"
      LET li_count = 0
      DECLARE zab_o_curs CURSOR FOR
              SELECT * FROM custtemp.zab_file
      FOREACH zab_o_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file custtemp FOREACH 資料時產生錯誤，zab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zab_file data error:",SQLCA.sqlerrd[2]," ",lr_zab.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zab_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gao_file資料"
      LET li_count = 0
      DECLARE gao_o_curs CURSOR FOR
              SELECT * FROM custtemp.gao_file
      FOREACH gao_o_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gao_file custtemp FOREACH 資料時產生錯誤，gao資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gao_file VALUES(lr_gao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gao_file SET gao_file.* = lr_gao.*
             WHERE gao01 = lr_gao.gao01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gao_file data error:",SQLCA.sqlerrd[2]," ",lr_gao.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gao_file 更新完畢，共更新 ",li_count,"筆資料"


      #No:CHI-750028 --start--
      DISPLAY "開始更新zai_file資料"
      LET li_count = 0
      DECLARE zai_o_curs CURSOR FOR
              SELECT * FROM custtemp.zai_file
      FOREACH zai_o_curs INTO lr_zai.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zai_file custtemp FOREACH 資料時產生錯誤，zai資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zai_file VALUES(lr_zai.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zai_file SET zai_file.* = lr_zai.*
             WHERE zai01 = lr_zai.zai01 AND zai05 = lr_zai.zai05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zai_file data error:",SQLCA.sqlerrd[2]," ",lr_zai.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zai_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaj_file資料"
      LET li_count = 0
      DECLARE zaj_o_curs CURSOR FOR
              SELECT * FROM custtemp.zaj_file
      FOREACH zaj_o_curs INTO lr_zaj.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zaj_file custtemp FOREACH 資料時產生錯誤，zaj資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zaj_file VALUES(lr_zaj.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaj_file SET zaj_file.* = lr_zaj.*
             WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02
               AND zaj07 = lr_zaj.zaj07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaj_file data error:",SQLCA.sqlerrd[2]," ",lr_zaj.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaj_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zak_file資料"
      LET li_count = 0
      DECLARE zak_o_curs CURSOR FOR
              SELECT * FROM custtemp.zak_file
      FOREACH zak_o_curs INTO lr_zak.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zak_file custtemp FOREACH 資料時產生錯誤，zak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zak_file VALUES(lr_zak.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zak_file SET zak_file.* = lr_zak.*
             WHERE zak01 = lr_zak.zak01 AND zak07 = lr_zak.zak07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zak_file data error:",SQLCA.sqlerrd[2]," ",lr_zak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zal_file資料"
      LET li_count = 0
      DECLARE zal_o_curs CURSOR FOR
              SELECT * FROM custtemp.zal_file
      FOREACH zal_o_curs INTO lr_zal.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zal_file custtemp FOREACH 資料時產生錯誤，zal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zal_file VALUES(lr_zal.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zal_file SET zal_file.* = lr_zal.*
             WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
               AND zal03 = lr_zal.zal03 AND zal07 = lr_zal.zal07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zal_file data error:",SQLCA.sqlerrd[2]," ",lr_zal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zam_file資料"
      LET li_count = 0
      DECLARE zam_o_curs CURSOR FOR
              SELECT * FROM custtemp.zam_file
      FOREACH zam_o_curs INTO lr_zam.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zam_file custtemp FOREACH 資料時產生錯誤，zam資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zam_file VALUES(lr_zam.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zam_file SET zam_file.* = lr_zam.*
             WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02
               AND zam09 = lr_zam.zam09
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zam_file data error:",SQLCA.sqlerrd[2]," ",lr_zam.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zam_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zan_file資料"
      LET li_count = 0
      DECLARE zan_o_curs CURSOR FOR
              SELECT * FROM custtemp.zan_file
      FOREACH zan_o_curs INTO lr_zan.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zan_file custtemp FOREACH 資料時產生錯誤，zan資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zan_file VALUES(lr_zan.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zan_file SET zan_file.* = lr_zan.*
             WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02
               AND zan08 = lr_zan.zan08
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zan_file data error:",SQLCA.sqlerrd[2]," ",lr_zan.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zan_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zao_file資料"
      LET li_count = 0
      DECLARE zao_o_curs CURSOR FOR
              SELECT * FROM custtemp.zao_file
      FOREACH zao_o_curs INTO lr_zao.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zao_file custtemp FOREACH 資料時產生錯誤，zao資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zao_file VALUES(lr_zao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zao_file SET zao_file.* = lr_zao.*
             WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
               AND zao03 = lr_zao.zao03 AND zao05 = lr_zao.zao05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zao_file data error:",SQLCA.sqlerrd[2]," ",lr_zao.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zao_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zap_file資料"
      LET li_count = 0
      DECLARE zap_o_curs CURSOR FOR
              SELECT * FROM custtemp.zap_file
      FOREACH zap_o_curs INTO lr_zap.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zap_file custtemp FOREACH 資料時產生錯誤，zap資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zap_file VALUES(lr_zap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zap_file SET zap_file.* = lr_zap.*
             WHERE zap01 = lr_zap.zap01 AND zap07 = lr_zap.zap07
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zap_file data error:",SQLCA.sqlerrd[2]," ",lr_zap.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zap_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zaq_file資料"
      LET li_count = 0
      DECLARE zaq_o_curs CURSOR FOR
              SELECT * FROM custtemp.zaq_file
      FOREACH zaq_o_curs INTO lr_zaq.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zaq_file custtemp FOREACH 資料時產生錯誤，zaq資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zaq_file VALUES(lr_zaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaq_file SET zaq_file.* = lr_zaq.*
             WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02
               AND zaq05 = lr_zaq.zaq05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaq_file data error:",SQLCA.sqlerrd[2]," ",lr_zaq.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaq_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zar_file資料"
      LET li_count = 0
      DECLARE zar_o_curs CURSOR FOR
              SELECT * FROM custtemp.zar_file
      FOREACH zar_o_curs INTO lr_zar.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zar_file custtemp FOREACH 資料時產生錯誤，zar資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zar_file VALUES(lr_zar.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zar_file SET zar_file.* = lr_zar.*
             WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
               AND zar03 = lr_zar.zar03 AND zar05 = lr_zar.zar05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zar_file data error:",SQLCA.sqlerrd[2]," ",lr_zar.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zar_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zas_file資料"
      LET li_count = 0
      DECLARE zas_o_curs CURSOR FOR
              SELECT * FROM custtemp.zas_file
      FOREACH zas_o_curs INTO lr_zas.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zas_file custtemp FOREACH 資料時產生錯誤，zas資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zas_file VALUES(lr_zas.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zas_file SET zas_file.* = lr_zas.*
             WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02
               AND zas11 = lr_zas.zas11
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zas_file data error:",SQLCA.sqlerrd[2]," ",lr_zas.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zas_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zat_file資料"
      LET li_count = 0
      DECLARE zat_o_curs CURSOR FOR
              SELECT * FROM custtemp.zat_file
      FOREACH zat_o_curs INTO lr_zat.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zat_file custtemp FOREACH 資料時產生錯誤，zat資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zat_file VALUES(lr_zat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zat_file SET zat_file.* = lr_zat.*
             WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
               AND zat10 = lr_zat.zat10
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zat_file data error:",SQLCA.sqlerrd[2]," ",lr_zat.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zat_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zau_file資料"
      LET li_count = 0
      DECLARE zau_o_curs CURSOR FOR
              SELECT * FROM custtemp.zau_file
      FOREACH zau_o_curs INTO lr_zau.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zau_file custtemp FOREACH 資料時產生錯誤，zau資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zau_file VALUES(lr_zau.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zau_file SET zau_file.* = lr_zau.*
             WHERE zau01 = lr_zau.zau01 AND zau04 = lr_zau.zau04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zau_file data error:",SQLCA.sqlerrd[2]," ",lr_zau.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zau_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新zav_file資料"
      LET li_count = 0
      DECLARE zav_o_curs CURSOR FOR
              SELECT * FROM custtemp.zav_file
      FOREACH zav_o_curs INTO lr_zav.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zav_file custtemp FOREACH 資料時產生錯誤，zav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zav_file VALUES(lr_zav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zav_file SET zav_file.* = lr_zav.*
             WHERE zav01 = lr_zav.zav01 AND zav02 = lr_zav.zav02
               AND zav03 = lr_zav.zav03 AND zav04 = lr_zav.zav04
               AND zav05 = lr_zav.zav05 AND zav24 = lr_zav.zav24
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zav_file data error:",SQLCA.sqlerrd[2]," ",lr_zav.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zav_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:CHI-750028 ---end---


      #No:TQC-7A0101 --start--
      DISPLAY "開始更新zaw_file資料"
      LET li_count = 0
      DECLARE zaw_o_curs CURSOR FOR
              SELECT * FROM custtemp.zaw_file
      FOREACH zaw_o_curs INTO lr_zaw.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zaw_file custtemp FOREACH 資料時產生錯誤，zaw資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zaw_file VALUES(lr_zaw.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zaw_file SET zaw_file.* = lr_zaw.*
             WHERE zaw01 = lr_zaw.zaw01 AND zaw02 = lr_zaw.zaw02
               AND zaw03 = lr_zaw.zaw03 AND zaw04 = lr_zaw.zaw04
               AND zaw05 = lr_zaw.zaw05 AND zaw06 = lr_zaw.zaw06
               AND zaw07 = lr_zaw.zaw07 AND zaw10 = lr_zaw.zaw10
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zaw_file data error:",SQLCA.sqlerrd[2]," ",lr_zaw.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zaw_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:TQC-7A0101 ---end---


      #No:FUN-7C0044 --start--
      DISPLAY "開始更新zay_file資料"
      LET li_count = 0
      DECLARE zay_o_curs CURSOR FOR
              SELECT * FROM custtemp.zay_file
      FOREACH zay_o_curs INTO lr_zay.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "zay_file custtemp FOREACH 資料時產生錯誤，zay資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zay_file VALUES(lr_zay.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.zay_file SET zay_file.* = lr_zay.*
             WHERE zay01 = lr_zay.zay01 AND zay02 = lr_zay.zay02
               AND zay03 = lr_zay.zay03 AND zay05 = lr_zay.zay05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zay_file data error:",SQLCA.sqlerrd[2]," ",lr_zay.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zay_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-7C0044 ---end---


      DISPLAY "開始更新gzl_file資料"
      LET li_count = 0
      DECLARE gzl_o_curs CURSOR FOR
              SELECT * FROM custtemp.gzl_file
      FOREACH gzl_o_curs INTO lr_gzl.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gzl_file custtemp FOREACH 資料時產生錯誤，gzl資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gzl_file VALUES(lr_gzl.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gzl_file SET gzl_file.* = lr_gzl.*
             WHERE gzl00 = lr_gzl.gzl00 AND gzl01 = lr_gzl.gzl01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gzl_file data error:",SQLCA.sqlcode," ",lr_gzl.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gzl_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gzln_file資料"
      LET li_count = 0
      DECLARE gzln_o_curs CURSOR FOR
              SELECT * FROM custtemp.gzln_file
      FOREACH gzln_o_curs INTO lr_gzln.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gzln_file custtemp FOREACH 資料時產生錯誤，gzln資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gzln_file VALUES(lr_gzln.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gzln_file SET gzln_file.* = lr_gzln.*
             WHERE gzln00 = lr_gzln.gzln00 AND gzln01 = lr_gzln.gzln01
               AND gzln02 = lr_gzln.gzln02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gzln_file data error:",SQLCA.sqlcode," ",lr_gzln.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gzln_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gsyc_file資料"
      LET li_count = 0
      DECLARE gsyc_o_curs CURSOR FOR
              SELECT * FROM custtemp.gsyc_file
      FOREACH gsyc_o_curs INTO lr_gsyc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gsyc_file custtemp FOREACH 資料時產生錯誤，gsyc資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gsyc_file VALUES(lr_gsyc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gsyc_file SET gsyc_file.* = lr_gsyc.*
             WHERE gsyc00 = lr_gsyc.gsyc00 AND gsyc01 = lr_gsyc.gsyc01
               AND gsyc02 = lr_gsyc.gsyc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gsyc_file data error:",SQLCA.sqlcode," ",lr_gsyc.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gsyc_file 更新完畢，共更新 ",li_count,"筆資料"

      #No:FUN-840067 --start--
      DISPLAY "開始更新gfb_file資料"
      LET li_count = 0
      DECLARE gfb_o_curs CURSOR FOR
              SELECT * FROM custtemp.gfb_file
      FOREACH gfb_o_curs INTO lr_gfb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfb_file custtemp FOREACH 資料時產生錯誤，gfb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gfb_file VALUES(lr_gfb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gfb_file SET gfb_file.* = lr_gfb.*
             WHERE gfb01 = lr_gfb.gfb01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfb_file data error:",SQLCA.sqlcode," ",lr_gfb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfb_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gfc_file資料"
      LET li_count = 0
      DECLARE gfc_o_curs CURSOR FOR
              SELECT * FROM custtemp.gfc_file
      FOREACH gfc_o_curs INTO lr_gfc.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfc_file custtemp FOREACH 資料時產生錯誤，gfc資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gfc_file VALUES(lr_gfc.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gfc_file SET gfc_file.* = lr_gfc.*
             WHERE gfc01 = lr_gfc.gfc01 AND gfc02 = lr_gfc.gfc02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfc_file data error:",SQLCA.sqlcode," ",lr_gfc.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfc_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gfd_file資料"
      LET li_count = 0
      DECLARE gfd_o_curs CURSOR FOR
              SELECT * FROM custtemp.gfd_file
      FOREACH gfd_o_curs INTO lr_gfd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gfd_file custtemp FOREACH 資料時產生錯誤，gfd資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gfd_file VALUES(lr_gfd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gfd_file SET gfd_file.* = lr_gfd.*
             WHERE gfd01 = lr_gfd.gfd01 AND gfd02 = lr_gfd.gfd02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gfd_file data error:",SQLCA.sqlcode," ",lr_gfd.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gfd_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gca_file資料"
      LET li_count = 0
      DECLARE gca_o_curs CURSOR FOR
              SELECT * FROM custtemp.gca_file
      FOREACH gca_o_curs INTO lr_gca.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gca_file custtemp FOREACH 資料時產生錯誤，gca資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gca_file VALUES(lr_gca.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gca_file SET gca_file.* = lr_gca.*
             WHERE gca01 = lr_gca.gca01 AND gca02 = lr_gca.gca02
               AND gca03 = lr_gca.gca03 AND gca04 = lr_gca.gca04
               AND gca05 = lr_gca.gca05 AND gca06 = lr_gca.gca06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gca_file data error:",SQLCA.sqlcode," ",lr_gca.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gca_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新gcb_file資料"
      LET li_count = 0
      DECLARE gcb_o_curs CURSOR FOR
              SELECT * FROM custtemp.gcb_file
      FOREACH gcb_o_curs INTO lr_gcb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gcb_file custtemp FOREACH 資料時產生錯誤，gcb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gcb_file VALUES(lr_gcb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gcb_file SET gcb_file.* = lr_gcb.*
             WHERE gcb01 = lr_gcb.gcb01 AND gcb02 = lr_gcb.gcb02
               AND gcb03 = lr_gcb.gcb03 AND gcb04 = lr_gcb.gcb04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gcb_file data error:",SQLCA.sqlcode," ",lr_gcb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
               CALL patch_import_doc(lr_gcb.*)
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
            CALL patch_import_doc(lr_gcb.*)
         END IF
      END FOREACH
      DISPLAY "gcb_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-840067 ---end---
   END IF
   CLOSE DATABASE

   IF NOT l_result THEN
      LET l_cmd = ""
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "上述資料除了ze_file只做insert動作外,其餘table insert不成功則會update"
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "若有資料無法更新請手動處理"
      CALL gc_channel.write(l_cmd)
   END IF

   CALL gc_channel.close()
END MAIN

FUNCTION patch_update_4sm(p_zz01,p_old_str,p_new_str)
   DEFINE   p_zz01       LIKE zz_file.zz01
   DEFINE   p_old_str    STRING
   DEFINE   p_new_str    STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_cmd       STRING
   DEFINE   ls_result    STRING
   DEFINE   lr_gay       DYNAMIC ARRAY OF RECORD
               gay01     LIKE gay_file.gay01
                         END RECORD
   DEFINE   li_cnt       INTEGER
   DEFINE   li_top       STRING
   DEFINE   li_i         INTEGER


   DECLARE gay_curs CURSOR FOR
      SELECT UNIQUE gay01 FROM gay_file

   LET li_cnt = 1
   FOREACH gay_curs INTO lr_gay[li_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_gay.deleteElement(li_cnt)

   LET lc_channel = base.Channel.create()

   LET li_top = FGL_GETENV("TOP")
   FOR li_i = 1 TO lr_gay.getLength()
       # BUG-4C0167
       LET ls_cmd = "find ",li_top,"/config/4sm/",lr_gay[li_i].gay01," -name \"*.4sm\" -exec grep -l '", p_old_str, "' {} \\;"
       CALL lc_channel.openPipe(ls_cmd,"r")
       WHILE (lc_channel.read(ls_result))
          CALL patch_replace_4sm(p_zz01,p_old_str,p_new_str,ls_result)
          DISPLAY 'update 4sm=',ls_result
       END WHILE
   END FOR
END FUNCTION

FUNCTION patch_replace_4sm(pc_zz01,ps_old_str,ps_rpc_str,ps_file)
   DEFINE   pc_zz01      LIKE zz_file.zz01
   DEFINE   ps_old_str   STRING
   DEFINE   ps_rpc_str   STRING
   DEFINE   ps_file      STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_cmd       STRING
   DEFINE   ls_result    STRING
   DEFINE   rpc_channel  base.Channel
   DEFINE   li_inx_s     INTEGER
   DEFINE   li_inx_e     INTEGER
   DEFINE   ls_temp_path STRING
   DEFINE   ls_tmp_file  STRING
   DEFINE   l_result     SMALLINT
   DEFINE   ls_substr1   STRING
   DEFINE   ls_substr2   STRING
   DEFINE   ls_prog      STRING


   IF (pc_zz01 IS NULL) OR (ps_old_str IS NULL) OR (ps_rpc_str IS NULL) OR (ps_file IS NULL) THEN
      RETURN
   END IF

   LET lc_channel = base.Channel.create()
   LET ls_cmd = "ls ",ps_file
   CALL lc_channel.openPipe(ls_cmd,"r")
   IF NOT (lc_channel.read(ls_result)) THEN
      DISPLAY ps_file," not found"
      RETURN
   END IF
   CALL lc_channel.close()

   LET ls_temp_path = FGL_GETENV("TEMPDIR")
   LET ls_tmp_file = ls_temp_path,"/temp_4sm.4sm"
   
   LET ls_cmd = "chmod 775 ",ps_file
   RUN ls_cmd

   LET rpc_channel = base.Channel.create()
   CALL rpc_channel.openFile(ls_tmp_file,"w")
   CALL rpc_channel.setDelimiter("")

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_file,"r")
   WHILE (lc_channel.read(ls_result))
      # BUG-4C0167
      LET li_inx_s = ls_result.getIndexOf("name=",1)
      LET li_inx_e = ls_result.getIndexOf("\"",li_inx_s + 6)
      LET ls_prog = ls_result.subString(li_inx_s + 6,li_inx_e - 1)
         LET li_inx_s = ls_result.getIndexOf(ps_old_str,1)
         IF li_inx_s = 0 THEN
            CALL rpc_channel.write(ls_result)
         ELSE
            IF ls_prog = pc_zz01 CLIPPED THEN
               LET li_inx_e = li_inx_s - 1 + ps_old_str.getLength()
               LET ls_substr1 = ls_result.subString(1,li_inx_s - 1)
               LET ls_substr2 = ls_result.subString(li_inx_e + 1,ls_result.getLength())
               LET ls_result = ls_substr1,ps_rpc_str,ls_substr2
               CALL rpc_channel.write(ls_result)
            ELSE
               CALL rpc_channel.write(ls_result)
            END IF
         END IF
   END WHILE

   CALL lc_channel.close()
   CALL rpc_channel.close()

   LET ls_cmd = "mv ",ls_tmp_file," ",ps_file
   RUN ls_cmd
   LET ls_cmd = "chmod 775 ",ps_file
   RUN ls_cmd
END FUNCTION

FUNCTION patch_get_custpass()   #FUN-730047
  DEFINE lch_file       base.channel
  DEFINE l_fname        STRING
  DEFINE l_plist        STRING
  DEFINE l_db_buf       STRING
  DEFINE l_pass_buf     STRING

  LET l_fname = FGL_GETENV("TOP")
  LET l_fname = l_fname,"/ds4gl2/bin/plist"

  LET lch_file = base.channel.create()
  CALL lch_file.openFile(l_fname,"r")
  IF STATUS THEN
     CALL lch_file.close()
  ELSE
     WHILE lch_file.read(l_plist)
       IF l_plist.getIndexOf(":",1) THEN                
          LET l_db_buf = l_plist.subString(1,l_plist.getIndexOf(":",1)-1)
          LET l_db_buf = l_db_buf.trim()
          LET l_pass_buf = l_plist.subString(l_plist.getIndexOf(":",1)+1,l_plist.getLength())
          LET l_pass_buf = l_pass_buf.trim()

          IF l_db_buf = "sys" THEN
             LET g_syspass = l_pass_buf
          END IF

          IF l_db_buf = "system" THEN
             LET g_systempass = l_pass_buf
          END IF

       END IF 
     END WHILE
     CALL lch_file.close()
  END IF
 
END FUNCTION

#No:FUN-840067 --start--
FUNCTION patch_import_doc(pr_gcb)
   DEFINE   pr_gcb   RECORD LIKE gcb_file.*
   DEFINE   ls_file  STRING
   DEFINE   ls_ext   STRING
   DEFINE   ls_cmd   STRING

   LET ls_ext = pr_gcb.gcb07
   WHILE ls_ext.getIndexOf(".",1)
      LET ls_ext = ls_ext.subString(ls_ext.getIndexOf(".",1)+1,ls_ext.getLength())
   END WHILE
   LET ls_file = FGL_GETENV("CUST"),os.Path.separator(),g_dir,os.Path.separator(),pr_gcb.gcb01 CLIPPED,".",ls_ext
   IF os.Path.exists(ls_file) THEN
      LET ls_cmd = "$FGLRUN patch_import_doc.42r ",ls_file," ",pr_gcb.gcb01 CLIPPED," ",pr_gcb.gcb02 CLIPPED," ",pr_gcb.gcb03 CLIPPED," ",pr_gcb.gcb04 CLIPPED
      RUN ls_cmd
   END IF
END FUNCTION
#No:FUN-840067 ---end---
