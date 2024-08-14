# 大版更資料打包工具 (呼叫此程式時, 環境已經切換) 2008 by saki
# A : ORACLE Chinese Big5
# B : ORACLE Chinese GB
# C : ORACLE Chinese Unicode         # G : Informix Chinese Big5
# D : ORACLE Ch & En Big5            # H : Informix Chinese GB
# E : ORACLE Ch & En GB              # I : Informix Ch & En Big5
# F : ORACLE Ch & En Unicode         # J : Informix Ch & En GB

# Parameter 1 : Old Version
# Parameter 2 : New Version
# Parameter 3 : Language Version
# Parameter 4 : Database Version
# Parameter 5 : Pack Folder Path

IMPORT os

DATABASE ds

DEFINE   g_old_ver   STRING
DEFINE   g_new_ver   STRING
DEFINE   g_pack_type STRING
DEFINE   g_db_type   STRING
DEFINE   g_packpath  STRING
DEFINE   g_cmd       STRING
DEFINE   g_sql       STRING
DEFINE   g_center    STRING
DEFINE   g_cnt       LIKE type_file.num5
DEFINE   g_zae_where STRING
DEFINE   g_zae_cnt   SMALLINT
DEFINE   g_zae01     DYNAMIC ARRAY OF LIKE zae_file.zae01

MAIN
   DEFINE   lr_zl     RECORD
               zl08   CHAR(10),
               zl09   CHAR(07)
                      END RECORD
   DEFINE   lr_syc    DYNAMIC ARRAY OF RECORD
               syc03  VARCHAR(1),
               syc04  VARCHAR(1),
               syc05  VARCHAR(10),
               syc06  VARCHAR(50),
               syc07  VARCHAR(50)
                      END RECORD
   DEFINE   li_cnt    LIKE type_file.num5
   DEFINE   lr_ze     DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_zz     DYNAMIC ARRAY OF RECORD LIKE zz_file.*
   DEFINE   lr_zm     DYNAMIC ARRAY OF RECORD LIKE zm_file.*
   DEFINE   lr_gap    DYNAMIC ARRAY OF RECORD LIKE gap_file.*
   DEFINE   lr_gbd    DYNAMIC ARRAY OF RECORD LIKE gbd_file.*
   DEFINE   lr_gaz    DYNAMIC ARRAY OF RECORD LIKE gaz_file.*
   DEFINE   lr_gao    DYNAMIC ARRAY OF RECORD LIKE gao_file.*
   DEFINE   lr_gae    DYNAMIC ARRAY OF RECORD LIKE gae_file.*
   DEFINE   lr_gav    DYNAMIC ARRAY OF RECORD LIKE gav_file.*
   DEFINE   lr_gak    DYNAMIC ARRAY OF RECORD LIKE gak_file.*
   DEFINE   lr_gal    DYNAMIC ARRAY OF RECORD LIKE gal_file.*
   DEFINE   lr_gaq    DYNAMIC ARRAY OF RECORD LIKE gaq_file.*
   DEFINE   lr_gat    DYNAMIC ARRAY OF RECORD LIKE gat_file.*
   DEFINE   lr_gab    DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac    DYNAMIC ARRAY OF RECORD LIKE gac_file.*
   DEFINE   lr_wsa    DYNAMIC ARRAY OF RECORD LIKE wsa_file.*
   DEFINE   lr_wsb    DYNAMIC ARRAY OF RECORD LIKE wsb_file.*
   DEFINE   lr_zaa    DYNAMIC ARRAY OF RECORD LIKE zaa_file.*
   DEFINE   lr_zab    DYNAMIC ARRAY OF RECORD LIKE zab_file.*
   DEFINE   lr_gax    DYNAMIC ARRAY OF RECORD LIKE gax_file.*
   DEFINE   lr_gba    DYNAMIC ARRAY OF RECORD LIKE gba_file.*
   DEFINE   lr_gbb    DYNAMIC ARRAY OF RECORD LIKE gbb_file.*
   DEFINE   lr_gbf    DYNAMIC ARRAY OF RECORD LIKE gbf_file.*
   DEFINE   lc_zaa08  LIKE zaa_file.zaa08
   DEFINE   lr_zad    DYNAMIC ARRAY OF RECORD LIKE zad_file.*
   DEFINE   lr_zae    DYNAMIC ARRAY OF RECORD LIKE zae_file.*
   DEFINE   lc_zad10  LIKE zad_file.zad10
   DEFINE   lr_wca    DYNAMIC ARRAY OF RECORD LIKE wca_file.*
   DEFINE   lr_wcb    DYNAMIC ARRAY OF RECORD LIKE wcb_file.*
   DEFINE   lr_wcc    DYNAMIC ARRAY OF RECORD LIKE wcc_file.*
   DEFINE   lr_wcd    DYNAMIC ARRAY OF RECORD LIKE wcd_file.*
   DEFINE   lr_zaw    DYNAMIC ARRAY OF RECORD LIKE zaw_file.*
   DEFINE   lr_zav    DYNAMIC ARRAY OF RECORD LIKE zav_file.*
   DEFINE   lr_zai    DYNAMIC ARRAY OF RECORD LIKE zai_file.*
   DEFINE   lr_zaj    DYNAMIC ARRAY OF RECORD LIKE zaj_file.*
   DEFINE   lr_zak    DYNAMIC ARRAY OF RECORD LIKE zak_file.*
   DEFINE   lr_zal    DYNAMIC ARRAY OF RECORD LIKE zal_file.*   
   DEFINE   lr_zam    DYNAMIC ARRAY OF RECORD LIKE zam_file.*
   DEFINE   lr_zan    DYNAMIC ARRAY OF RECORD LIKE zan_file.*
   DEFINE   lr_zao    DYNAMIC ARRAY OF RECORD LIKE zao_file.*
   DEFINE   lr_zap    DYNAMIC ARRAY OF RECORD LIKE zap_file.*
   DEFINE   lr_zaq    DYNAMIC ARRAY OF RECORD LIKE zaq_file.*
   DEFINE   lr_zar    DYNAMIC ARRAY OF RECORD LIKE zar_file.*
   DEFINE   lr_zas    DYNAMIC ARRAY OF RECORD LIKE zas_file.*
   DEFINE   lr_zat    DYNAMIC ARRAY OF RECORD LIKE zat_file.*   
   DEFINE   lr_zau    DYNAMIC ARRAY OF RECORD LIKE zau_file.*
   DEFINE   lr_zay    DYNAMIC ARRAY OF RECORD LIKE zay_file.*
   DEFINE   lr_wsm    DYNAMIC ARRAY OF RECORD LIKE wsm_file.*
   DEFINE   lr_wsn    DYNAMIC ARRAY OF RECORD LIKE wsn_file.*
   DEFINE   lr_wso    DYNAMIC ARRAY OF RECORD LIKE wso_file.*
   DEFINE   lr_wsp    DYNAMIC ARRAY OF RECORD LIKE wsp_file.*
   DEFINE   ls_file   STRING

   WHENEVER ERROR CONTINUE

   LET g_old_ver = ARG_VAL(1)
   LET g_new_ver = ARG_VAL(2)
   LET g_pack_type = ARG_VAL(3)
   LET g_db_type = ARG_VAL(4)
   LET g_packpath = ARG_VAL(5)

   LET g_sql = "SELECT syc03,syc04,syc05,syc06,syc07 FROM syc_file",
               " WHERE syc00 = ? AND syc01 = ?",
               "   AND syc03 = 'I'"
   PREPARE syc_pre FROM g_sql
   DECLARE syc_curs CURSOR FOR syc_pre

   LET g_sql = "SELECT UNIQUE zl08,zl09 FROM zl_file,syc_file ",
               " WHERE zl09 BETWEEN '",g_old_ver,"' AND '",g_new_ver,"0.00'",
               "   AND zl02 = '8' AND zl08 = syc01 AND zl09 = syc00"
   PREPARE zl_pre FROM g_sql
   DECLARE zl_curs CURSOR FOR zl_pre

   LET g_cnt = 1
   FOREACH zl_curs INTO lr_zl.*
      FOREACH syc_curs USING lr_zl.zl09,lr_zl.zl08 INTO lr_syc[g_cnt].*
         LET g_cnt = g_cnt + 1
      END FOREACH
      CALL lr_syc.deleteElement(g_cnt)
   END FOREACH

   IF g_db_type = "ORA" THEN
#測試用, 要拿掉mark
#     RUN 'patchtemp.sh'
      LET g_center = "."
   ELSE
#     RUN 'patchtemp_info.sh'
      LET g_center = ":"
   END IF

   DATABASE patchtemp
   IF SQLCA.sqlcode THEN
      DISPLAY "產生patchtemp 資料庫錯誤, 無法打包資料"
      RETURN
   END IF
   CLOSE DATABASE
   DATABASE ds

   #先把要上的資料倒入patchtemp中
   FOR g_cnt = 1 TO lr_syc.getLength()
       IF lr_syc[g_cnt].syc03 IS NULL OR lr_syc[g_cnt].syc04 IS NULL OR
          lr_syc[g_cnt].syc06 IS NULL THEN
          DISPLAY "基本資料不足"
          CONTINUE FOR
       END IF

       CASE lr_syc[g_cnt].syc04
          WHEN "1"
             LET g_sql = "SELECT * FROM ds",g_center,"ze_file WHERE ze01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND ze02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND ze02 IN ('0','1','2')"
             END CASE
             PREPARE ze_pre FROM g_sql
             DECLARE ze_curs CURSOR FOR ze_pre
             LET li_cnt = 1
             CALL lr_ze.clear()
             FOREACH ze_curs INTO lr_ze[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_ze.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_ze.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.ze_file VALUES(lr_ze[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:ze_file VALUES(lr_ze[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR
                
          WHEN "2"
             LET g_sql = "SELECT * FROM ds",g_center,"zz_file WHERE zz01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zz_pre FROM g_sql
             DECLARE zz_curs CURSOR FOR zz_pre
             LET li_cnt = 1
             CALL lr_zz.clear()
             FOREACH zz_curs INTO lr_zz[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zz.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zz.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zz_file VALUES(lr_zz[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zz_file VALUES(lr_zz[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 附加gaz_file資料
             LET g_sql = "SELECT * FROM ds",g_center,"gaz_file WHERE gaz01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gaz05 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gaz02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gaz02 IN ('0','1','2')"
             END CASE
             PREPARE gaz_pre FROM g_sql
             DECLARE gaz_curs CURSOR FOR gaz_pre
             LET li_cnt = 1
             CALL lr_gaz.clear()
             FOREACH gaz_curs INTO lr_gaz[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gaz.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gaz.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gaz_file VALUES(lr_gaz[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gaz_file VALUES(lr_gaz[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "3"
             IF lr_syc[g_cnt].syc07 IS NULL THEN
                LET g_sql = "SELECT * FROM ds",g_center,"zm_file WHERE zm01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             ELSE
                LET g_sql = "SELECT * FROM ds",g_center,"zm_file WHERE zm01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND zm03 = '",lr_syc[g_cnt].syc07 CLIPPED,"'"
             END IF
             PREPARE zm_pre FROM g_sql
             DECLARE zm_curs CURSOR FOR zm_pre
             LET li_cnt = 1
             CALL lr_zm.clear()
             FOREACH zm_curs INTO lr_zm[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zm.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zm.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zm_file VALUES(lr_zm[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zm_file VALUES(lr_zm[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "4"
             IF lr_syc[g_cnt].syc07 IS NULL THEN
                LET g_sql = "SELECT * FROM ds",g_center,"gap_file WHERE gap01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             ELSE
                LET g_sql = "SELECT * FROM ds",g_center,"gap_file WHERE gap01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gap02 = '",lr_syc[g_cnt].syc07 CLIPPED,"'"
             END IF
             PREPARE gap_pre FROM g_sql
             DECLARE gap_curs CURSOR FOR gap_pre
             LET li_cnt = 1
             CALL lr_gap.clear()
             FOREACH gap_curs INTO lr_gap[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gap.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gap.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gap_file VALUES(lr_gap[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gap_file VALUES(lr_gap[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "5"
             LET g_sql = "SELECT * FROM ds",g_center,"gbd_file WHERE gbd01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gbd07 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gbd03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gbd03 IN ('0','1','2')"
             END CASE
             PREPARE gbd_pre FROM g_sql
             DECLARE gbd_curs CURSOR FOR gbd_pre
             LET li_cnt = 1
             CALL lr_gbd.clear()
             FOREACH gbd_curs INTO lr_gbd[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gbd.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gbd.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gbd_file VALUES(lr_gbd[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gbd_file VALUES(lr_gbd[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "6"
             LET g_sql = "SELECT * FROM ds",g_center,"gaz_file WHERE gaz01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gaz05 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gaz02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gaz02 IN ('0','1','2')"
             END CASE
             PREPARE gaz_6_pre FROM g_sql
             DECLARE gaz_6_curs CURSOR FOR gaz_6_pre
             LET li_cnt = 1
             CALL lr_gaz.clear()
             FOREACH gaz_6_curs INTO lr_gaz[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gaz.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gaz.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gaz_file VALUES(lr_gaz[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gaz_file VALUES(lr_gaz[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "7"
             IF lr_syc[g_cnt].syc07 IS NULL THEN
                LET g_sql = "SELECT * FROM ds",g_center,"gae_file WHERE gae01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gae11 = 'N'"
             ELSE
                LET g_sql = "SELECT * FROM ds",g_center,"gae_file WHERE gae01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gae02 = '",lr_syc[g_cnt].syc07 CLIPPED,"' AND gae11='N'"
             END IF
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gae03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gae03 IN ('0','1','2')"
             END CASE
             PREPARE gae_pre FROM g_sql
             DECLARE gae_curs CURSOR FOR gae_pre
             LET li_cnt = 1
             CALL lr_gae.clear()
             FOREACH gae_curs INTO lr_gae[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gae.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gae.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gae_file VALUES(lr_gae[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gae_file VALUES(lr_gae[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "8"
             IF lr_syc[g_cnt].syc07 IS NULL THEN
                LET g_sql = "SELECT * FROM ds",g_center,"gae_file WHERE gae01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gae11 = 'N'"
             ELSE
                LET g_sql = "SELECT * FROM ds",g_center,"gae_file WHERE gae01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gae02 = '",lr_syc[g_cnt].syc07 CLIPPED,"' AND gae11='N'"
             END IF
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gae03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gae03 IN ('0','1','2')"
             END CASE
             PREPARE gae_8_pre FROM g_sql
             DECLARE gae_8_curs CURSOR FOR gae_8_pre
             LET li_cnt = 1
             CALL lr_gae.clear()
             FOREACH gae_8_curs INTO lr_gae[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gae.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gae.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gae_file VALUES(lr_gae[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gae_file VALUES(lr_gae[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "9"
             # 單頭檔 gak_file
             LET g_sql = "SELECT * FROM ds",g_center,"gak_file WHERE gak01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE gak_pre FROM g_sql
             DECLARE gak_curs CURSOR FOR gak_pre
             LET li_cnt = 1
             CALL lr_gak.clear()
             FOREACH gak_curs INTO lr_gak[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gak.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gak.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gak_file VALUES(lr_gak[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gak_file VALUES(lr_gak[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 單身檔 gal_file
             LET g_sql = "SELECT * FROM ds",g_center,"gal_file WHERE gal01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE gal_pre FROM g_sql
             DECLARE gal_curs CURSOR FOR gal_pre
             LET li_cnt = 1
             CALL lr_gal.clear()
             FOREACH gal_curs INTO lr_gal[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gal.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gal.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gal_file VALUES(lr_gal[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gal_file VALUES(lr_gal[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "A"
             LET g_sql = "SELECT * FROM ds",g_center,"gaq_file WHERE gaq01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gaq02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gaq02 IN ('0','1','2')"
             END CASE
             PREPARE gaq_pre FROM g_sql
             DECLARE gaq_curs CURSOR FOR gaq_pre
             LET li_cnt = 1
             CALL lr_gaq.clear()
             FOREACH gaq_curs INTO lr_gaq[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gaq.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gaq.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gaq_file VALUES(lr_gaq[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gaq_file VALUES(lr_gaq[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "B"
             LET g_sql = "SELECT * FROM ds",g_center,"gap_file WHERE gap01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE gap_b_pre FROM g_sql
             DECLARE gap_b_curs CURSOR FOR gap_b_pre
             LET li_cnt = 1
             CALL lr_gap.clear()
             FOREACH gap_b_curs INTO lr_gap[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gap.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gap.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gap_file VALUES(lr_gap[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gap_file VALUES(lr_gap[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "C"
             LET g_sql = "SELECT ds",g_center,"gbd_file.* FROM ds",g_center,"gap_file,ds",g_center,"gbd_file",
                         " WHERE gap01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gap02 = gbd01 AND gbd07 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gbd03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gbd03 IN ('0','1','2')"
             END CASE
             PREPARE gbd_c_pre FROM g_sql
             DECLARE gbd_c_curs CURSOR FOR gbd_c_pre
             LET li_cnt = 1
             CALL lr_gbd.clear()
             FOREACH gbd_c_curs INTO lr_gbd[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gbd.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gbd.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gbd_file VALUES(lr_gbd[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gbd_file VALUES(lr_gbd[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "D"
             # 動態開窗查詢單頭檔 gab_file
             LET g_sql = "SELECT * FROM ds",g_center,"gab_file WHERE gab01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gab11 = 'N'"
             PREPARE gab_pre FROM g_sql
             DECLARE gab_curs CURSOR FOR gab_pre
             LET li_cnt = 1
             CALL lr_gab.clear()
             FOREACH gab_curs INTO lr_gab[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gab.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gab.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gab_file VALUES(lr_gab[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gab_file VALUES(lr_gab[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 動態開窗查詢單身檔 gac_file
             LET g_sql = "SELECT * FROM ds",g_center,"gac_file WHERE gac01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gac12 = 'N'"
             PREPARE gac_pre FROM g_sql
             DECLARE gac_curs CURSOR FOR gac_pre
             LET li_cnt = 1
             CALL lr_gac.clear()
             FOREACH gac_curs INTO lr_gac[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gac.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gac.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gac_file VALUES(lr_gac[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gac_file VALUES(lr_gac[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "E"
             LET g_sql = "SELECT * FROM ds",g_center,"gav_file WHERE gav01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gav08 = 'N'"
             PREPARE gav_pre FROM g_sql
             DECLARE gav_curs CURSOR FOR gav_pre
             LET li_cnt = 1
             CALL lr_gav.clear()
             FOREACH gav_curs INTO lr_gav[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gav.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gav.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gav_file VALUES(lr_gav[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gav_file VALUES(lr_gav[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "G"
             LET g_sql = "SELECT * FROM ds",g_center,"gat_file WHERE gat01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gat02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gat02 IN ('0','1','2')"
             END CASE
             PREPARE gat_pre FROM g_sql
             DECLARE gat_curs CURSOR FOR gat_pre
             LET li_cnt = 1
             CALL lr_gat.clear()
             FOREACH gat_curs INTO lr_gat[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gat.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gat.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gat_file VALUES(lr_gat[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gat_file VALUES(lr_gat[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "H"
             # 單頭檔 wsa_file
             LET g_sql = "SELECT * FROM ds",g_center,"wsa_file WHERE wsa01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wsa_pre FROM g_sql
             DECLARE wsa_curs CURSOR FOR wsa_pre
             LET li_cnt = 1
             CALL lr_wsa.clear()
             FOREACH wsa_curs INTO lr_wsa[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wsa.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wsa.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wsa_file VALUES(lr_wsa[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wsa_file VALUES(lr_wsa[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 單身檔 wsb_file
             LET g_sql = "SELECT * FROM ds",g_center,"wsb_file WHERE wsb01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wsb_pre FROM g_sql
             DECLARE wsb_curs CURSOR FOR wsb_pre
             LET li_cnt = 1
             CALL lr_wsb.clear()
             FOREACH wsb_curs INTO lr_wsb[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wsb.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wsb.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wsb_file VALUES(lr_wsb[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wsb_file VALUES(lr_wsb[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "I"
             # 報表頭 zaa_file
             LET g_sql = "SELECT * FROM ds",g_center,"zaa_file WHERE zaa01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND zaa10 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND zaa03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND zaa03 IN ('0','1','2')"
             END CASE
             PREPARE zaa_pre FROM g_sql
             DECLARE zaa_curs CURSOR FOR zaa_pre
             LET li_cnt = 1
             CALL lr_zaa.clear()
             FOREACH zaa_curs INTO lr_zaa[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zaa.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zaa.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zaa_file VALUES(lr_zaa[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zaa_file VALUES(lr_zaa[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 報表備註 zab_file
             LET g_sql = "SELECT * FROM ds",g_center,"zab_file",
                         " WHERE zab01 = (SELECT UNIQUE zaa08 FROM zaa_file ",
                         " WHERE zaa01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'",
                         "   AND (zaa14 = 'H' OR zaa14 = 'J'))"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND zab04 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND zab04 IN ('0','1','2')"
             END CASE
             PREPARE zab_pre FROM g_sql
             DECLARE zab_curs CURSOR FOR zab_pre
             LET li_cnt = 1
             CALL lr_zab.clear()
             FOREACH zab_curs INTO lr_zab[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zab.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zab.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zab_file VALUES(lr_zab[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zab_file VALUES(lr_zab[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # 報表連查 zad_file
             LET g_sql = "SELECT * FROM ds",g_center,"zad_file WHERE zad01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND zad05 = 'N'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND zad03 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND zad03 IN ('0','1','2')"
             END CASE
             PREPARE zad_pre FROM g_sql
             DECLARE zad_curs CURSOR FOR zad_pre
             LET li_cnt = 1
             CALL lr_zad.clear()
             FOREACH zad_curs INTO lr_zad[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zad.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zad.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zad_file VALUES(lr_zad[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zad_file VALUES(lr_zad[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_zae_where = ""
             LET g_sql = "SELECT zad10 FROM ds",g_center,"zad_file",
                         " WHERE zad01 ='",lr_syc[g_cnt].syc06,"' ",
                         "   AND zad05 = 'N' AND zad09 = '2'"
             PREPARE zae_zad_pre FROM g_sql
             DECLARE zae_zad_curs CURSOR FOR zae_zad_pre
             FOREACH zae_zad_curs INTO lc_zad10
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET g_zae_cnt = 1
                CALL bpatch_pack_data_unload_zae_file(lc_zad10)
             END FOREACH
             LET g_zae_where = g_zae_where.subString(1,g_zae_where.getLength() - 3)
             IF g_zae_where.getLength() = 0 THEN 
                LET g_zae_where = "1=1"
             END IF
             LET g_sql = "SELECT * FROM ds",g_center,"zae_file WHERE ",g_zae_where
             PREPARE zae_pre FROM g_sql
             DECLARE zae_curs CURSOR FOR zae_pre
             LET li_cnt = 1
             CALL lr_zae.clear()
             FOREACH zae_curs INTO lr_zae[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zae.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zae.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zae_file VALUES(lr_zae[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zae_file VALUES(lr_zae[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "J"
             LET g_sql = "SELECT * FROM ds",g_center,"gao_file WHERE gao01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE gao_pre FROM g_sql
             DECLARE gao_curs CURSOR FOR gao_pre
             LET li_cnt = 1
             CALL lr_gao.clear()
             FOREACH gao_curs INTO lr_gao[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gao.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gao.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gao_file VALUES(lr_gao[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gao_file VALUES(lr_gao[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "K"
             # SOP單頭檔
             LET g_sql = "SELECT * FROM ds",g_center,"gba_file WHERE gba01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gba04 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gba04 IN ('0','1','2')"
             END CASE
             PREPARE gba_pre FROM g_sql
             DECLARE gba_curs CURSOR FOR gba_pre
             LET li_cnt = 1
             CALL lr_gba.clear()
             FOREACH gba_curs INTO lr_gba[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gba.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gba.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gba_file VALUES(lr_gba[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gba_file VALUES(lr_gba[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             # SOP單身檔
             LET g_sql = "SELECT * FROM ds",g_center,"gbb_file WHERE gbb01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gbb04 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gbb04 IN ('0','1','2')"
             END CASE
             PREPARE gbb_pre FROM g_sql
             DECLARE gbb_curs CURSOR FOR gbb_pre
             LET li_cnt = 1
             CALL lr_gbb.clear()
             FOREACH gbb_curs INTO lr_gbb[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gbb.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gbb.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gbb_file VALUES(lr_gbb[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gbb_file VALUES(lr_gbb[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "L"
             LET g_sql = "SELECT * FROM ds",g_center,"gax_file WHERE gax01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gax05 = 'N'"
             PREPARE gax_pre FROM g_sql
             DECLARE gax_curs CURSOR FOR gax_pre
             LET li_cnt = 1
             CALL lr_gax.clear()
             FOREACH gax_curs INTO lr_gax[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gax.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gax.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gax_file VALUES(lr_gax[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gax_file VALUES(lr_gax[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "M"
             LET g_sql = "SELECT * FROM ds",g_center,"gbf_file WHERE gbf01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             CASE
                WHEN g_pack_type MATCHES '[ABCGH]'
                   LET g_sql = g_sql CLIPPED," AND gbf02 IN ('0','2')"
                WHEN g_pack_type MATCHES '[DEFIJ]'
                   LET g_sql = g_sql CLIPPED," AND gbf02 IN ('0','1','2')"
             END CASE
             PREPARE gbf_pre FROM g_sql
             DECLARE gbf_curs CURSOR FOR gbf_pre
             LET li_cnt = 1
             CALL lr_gbf.clear()
             FOREACH gbf_curs INTO lr_gbf[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_gbf.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_gbf.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.gbf_file VALUES(lr_gbf[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:gbf_file VALUES(lr_gbf[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "N"
             LET g_sql = "SELECT * FROM ds",g_center,"wca_file WHERE wca01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wca_pre FROM g_sql
             DECLARE wca_curs CURSOR FOR wca_pre
             LET li_cnt = 1
             CALL lr_wca.clear()
             FOREACH wca_curs INTO lr_wca[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wca.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wca.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wca_file VALUES(lr_wca[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wca_file VALUES(lr_wca[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_sql = "SELECT * FROM ds",g_center,"wcb_file WHERE wcb01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wcb_pre FROM g_sql
             DECLARE wcb_curs CURSOR FOR wcb_pre
             LET li_cnt = 1
             CALL lr_wcb.clear()
             FOREACH wcb_curs INTO lr_wcb[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wcb.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wcb.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wcb_file VALUES(lr_wcb[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wcb_file VALUES(lr_wcb[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_sql = "SELECT * FROM ds",g_center,"wcc_file WHERE wcc01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wcc_pre FROM g_sql
             DECLARE wcc_curs CURSOR FOR wcc_pre
             LET li_cnt = 1
             CALL lr_wcc.clear()
             FOREACH wcc_curs INTO lr_wcc[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wcc.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wcc.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wcc_file VALUES(lr_wcc[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wcc_file VALUES(lr_wcc[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "O"
             LET g_sql = "SELECT * FROM ds",g_center,"wcd_file WHERE wcd01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wcd_pre FROM g_sql
             DECLARE wcd_curs CURSOR FOR wcd_pre
             LET li_cnt = 1
             CALL lr_wcd.clear()
             FOREACH wcd_curs INTO lr_wcd[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wcd.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wcd.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wcd_file VALUES(lr_wcd[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wcd_file VALUES(lr_wcd[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "P"
             LET g_sql = "SELECT * FROM ds",g_center,"zaw_file WHERE zaw01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zaw_pre FROM g_sql
             DECLARE zaw_curs CURSOR FOR zaw_pre
             LET li_cnt = 1
             CALL lr_zaw.clear()
             FOREACH zaw_curs INTO lr_zaw[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zaw.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zaw.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zaw_file VALUES(lr_zaw[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zaw_file VALUES(lr_zaw[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "Q"
             #自定義查詢設定主頁
             LET g_sql = "SELECT * FROM ds",g_center,"zai_file WHERE zai01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zai_pre FROM g_sql
             DECLARE zai_curs CURSOR FOR zai_pre
             LET li_cnt = 1
             CALL lr_zai.clear()
             FOREACH zai_curs INTO lr_zai[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zai.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zai.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zai_file VALUES(lr_zai[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zai_file VALUES(lr_zai[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義執行query前應執行的process
             LET g_sql = "SELECT * FROM ds",g_center,"zaj_file WHERE zaj01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zaj_pre FROM g_sql
             DECLARE zaj_curs CURSOR FOR zaj_pre
             LET li_cnt = 1
             CALL lr_zaj.clear()
             FOREACH zaj_curs INTO lr_zaj[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zaj.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zaj.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zaj_file VALUES(lr_zaj[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zaj_file VALUES(lr_zaj[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義設定查詢的sql
             LET g_sql = "SELECT * FROM ds",g_center,"zak_file WHERE zak01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zak_pre FROM g_sql
             DECLARE zak_curs CURSOR FOR zak_pre
             LET li_cnt = 1
             CALL lr_zak.clear()
             FOREACH zak_curs INTO lr_zak[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zak.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zak.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zak_file VALUES(lr_zak[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zak_file VALUES(lr_zak[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #設定SQL欄位資料
             LET g_sql = "SELECT * FROM ds",g_center,"zal_file WHERE zal01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zal_pre FROM g_sql
             DECLARE zal_curs CURSOR FOR zal_pre
             LET li_cnt = 1
             CALL lr_zal.clear()
             FOREACH zal_curs INTO lr_zal[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zal.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zal.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zal_file VALUES(lr_zal[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zal_file VALUES(lr_zal[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義查詢分群(Group)
             LET g_sql = "SELECT * FROM ds",g_center,"zam_file WHERE zam01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zam_pre FROM g_sql
             DECLARE zam_curs CURSOR FOR zam_pre
             LET li_cnt = 1
             CALL lr_zam.clear()
             FOREACH zam_curs INTO lr_zam[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zam.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zam.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zam_file VALUES(lr_zam[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zam_file VALUES(lr_zam[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義查詢計算(Sum)
             LET g_sql = "SELECT * FROM ds",g_center,"zan_file WHERE zan01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zan_pre FROM g_sql
             DECLARE zan_curs CURSOR FOR zan_pre
             LET li_cnt = 1
             CALL lr_zan.clear()
             FOREACH zan_curs INTO lr_zan[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zan.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zan.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zan_file VALUES(lr_zan[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zan_file VALUES(lr_zan[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義查詢輸出格式(Layout)
             LET g_sql = "SELECT * FROM ds",g_center,"zao_file WHERE zao01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zao_pre FROM g_sql
             DECLARE zao_curs CURSOR FOR zao_pre
             LET li_cnt = 1
             CALL lr_zao.clear()
             FOREACH zao_curs INTO lr_zao[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zao.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zao.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zao_file VALUES(lr_zao[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zao_file VALUES(lr_zao[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #定義查詢 output
             LET g_sql = "SELECT * FROM ds",g_center,"zap_file WHERE zap01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zap_pre FROM g_sql
             DECLARE zap_curs CURSOR FOR zap_pre
             LET li_cnt = 1
             CALL lr_zap.clear()
             FOREACH zap_curs INTO lr_zap[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zap.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zap.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zap_file VALUES(lr_zap[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zap_file VALUES(lr_zap[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #SQL Wizard  Table 記錄檔
             LET g_sql = "SELECT * FROM ds",g_center,"zaq_file WHERE zaq01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zaq_pre FROM g_sql
             DECLARE zaq_curs CURSOR FOR zaq_pre
             LET li_cnt = 1
             CALL lr_zaq.clear()
             FOREACH zaq_curs INTO lr_zaq[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zaq.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zaq.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zaq_file VALUES(lr_zaq[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zaq_file VALUES(lr_zaq[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #SQL Wizard  Field 記錄檔
             LET g_sql = "SELECT * FROM ds",g_center,"zar_file WHERE zar01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zar_pre FROM g_sql
             DECLARE zar_curs CURSOR FOR zar_pre
             LET li_cnt = 1
             CALL lr_zar.clear()
             FOREACH zar_curs INTO lr_zar[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zar.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zar.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zar_file VALUES(lr_zar[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zar_file VALUES(lr_zar[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #SQL Wizard 條件式記錄檔
             LET g_sql = "SELECT * FROM ds",g_center,"zas_file WHERE zas01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zas_pre FROM g_sql
             DECLARE zas_curs CURSOR FOR zas_pre
             LET li_cnt = 1
             CALL lr_zas.clear()
             FOREACH zas_curs INTO lr_zas[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zas.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zas.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zas_file VALUES(lr_zas[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zas_file VALUES(lr_zas[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #動態查詢參數設定檔案
             LET g_sql = "SELECT * FROM ds",g_center,"zat_file WHERE zat01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zat_pre FROM g_sql
             DECLARE zat_curs CURSOR FOR zat_pre
             LET li_cnt = 1
             CALL lr_zat.clear()
             FOREACH zat_curs INTO lr_zat[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zat.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zat.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zat_file VALUES(lr_zat[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zat_file VALUES(lr_zat[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             #自定義查詢權限設定檔
             LET g_sql = "SELECT * FROM ds",g_center,"zau_file WHERE zau01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zau_pre FROM g_sql
             DECLARE zau_curs CURSOR FOR zau_pre
             LET li_cnt = 1
             CALL lr_zau.clear()
             FOREACH zau_curs INTO lr_zau[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zau.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zau.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zau_file VALUES(lr_zau[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zau_file VALUES(lr_zau[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR
             
             LET g_sql = "SELECT * FROM ds",g_center,"zay_file WHERE zay01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zay_pre FROM g_sql
             DECLARE zay_curs CURSOR FOR zay_pre
             LET li_cnt = 1
             CALL lr_zay.clear()
             FOREACH zay_curs INTO lr_zay[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zay.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zay.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zay_file VALUES(lr_zay[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zay_file VALUES(lr_zay[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR
             
             #自定義動態查詢設定檔
             LET g_sql = "SELECT * FROM ds",g_center,"zav_file WHERE zav01 = '2' AND zav02 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE zav_Q_pre FROM g_sql
             DECLARE zav_Q_curs CURSOR FOR zav_Q_pre
             LET li_cnt = 1
             CALL lr_zav.clear()
             FOREACH zav_Q_curs INTO lr_zav[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_zav.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_zav.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.zav_file VALUES(lr_zav[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:zav_file VALUES(lr_zav[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "R"
             LET g_sql = "SELECT * FROM ds",g_center,"wsm_file WHERE wsm01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wsm_pre FROM g_sql
             DECLARE wsm_curs CURSOR FOR wsm_pre
             LET li_cnt = 1
             CALL lr_wsm.clear()
             FOREACH wsm_curs INTO lr_wsm[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wsm.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wsm.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wsm_file VALUES(lr_wsm[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wsm_file VALUES(lr_wsm[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_sql = "SELECT * FROM ds",g_center,"wsn_file WHERE wsn01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wsn_pre FROM g_sql
             DECLARE wsn_curs CURSOR FOR wsn_pre
             LET li_cnt = 1
             CALL lr_wsn.clear()
             FOREACH wsn_curs INTO lr_wsn[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wsn.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wsn.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wsn_file VALUES(lr_wsn[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wsn_file VALUES(lr_wsn[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_sql = "SELECT * FROM ds",g_center,"wso_file WHERE wso01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wso_pre FROM g_sql
             DECLARE wso_curs CURSOR FOR wso_pre
             LET li_cnt = 1
             CALL lr_wso.clear()
             FOREACH wso_curs INTO lr_wso[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wso.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wso.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wso_file VALUES(lr_wso[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wso_file VALUES(lr_wso[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

             LET g_sql = "SELECT * FROM ds",g_center,"wsp_file WHERE wsp01 = '",lr_syc[g_cnt].syc06 CLIPPED,"'"
             PREPARE wsp_pre FROM g_sql
             DECLARE wsp_curs CURSOR FOR wsp_pre
             LET li_cnt = 1
             CALL lr_wsp.clear()
             FOREACH wsp_curs INTO lr_wsp[li_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET li_cnt = li_cnt + 1
             END FOREACH
             CALL lr_wsp.deleteElement(li_cnt)

             FOR li_cnt = 1 TO lr_wsp.getLength()
                IF g_db_type = "ORA" THEN
                   INSERT INTO patchtemp.wsp_file VALUES(lr_wsp[li_cnt].*)
                ELSE
                   INSERT INTO patchtemp:wsp_file VALUES(lr_wsp[li_cnt].*)
                END IF
                IF SQLCA.sqlcode THEN
                   CONTINUE FOR
                END IF
             END FOR

          WHEN "S"
             # 單身檔 gal_file, 當lib,sub,qry有新增程式時
             IF lr_syc[g_cnt].syc07 IS NOT NULL THEN
                LET g_sql = "SELECT * FROM ds",g_center,"gal_file WHERE gal01 = '",lr_syc[g_cnt].syc06 CLIPPED,"' AND gal03 = '",lr_syc[g_cnt].syc07 CLIPPED,"'"
                PREPARE gal_s_pre FROM g_sql
                DECLARE gal_s_curs CURSOR FOR gal_s_pre
                LET li_cnt = 1
                CALL lr_gal.clear()
                FOREACH gal_curs INTO lr_gal[li_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET li_cnt = li_cnt + 1
                END FOREACH
                CALL lr_gal.deleteElement(li_cnt)

                FOR li_cnt = 1 TO lr_gal.getLength()
                   IF g_db_type = "ORA" THEN
                      INSERT INTO patchtemp.gal_file VALUES(lr_gal[li_cnt].*)
                   ELSE
                      INSERT INTO patchtemp:gal_file VALUES(lr_gal[li_cnt].*)
                   END IF
                   IF SQLCA.sqlcode THEN
                      CONTINUE FOR
                   END IF
                END FOR
             END IF
       END CASE
   END FOR

   DISPLAY '倒資料到patchtemp完成'

   #若資料要轉GB碼, 提供各txt檔, 在客戶端用load_new上資料
   CASE
      WHEN g_pack_type MATCHES '[ACDF]'
         LET g_cmd = "exp patchtemp/patchtemp@$ORACLE_SID tables=ze_file,zz_file,zm_file,",
                     "gap_file,gbd_file,gaz_file,gao_file,gae_file,gav_file,",
                     "gak_file,gal_file,gaq_file,gat_file,gab_file,gac_file,",
                     "wsa_file,wsb_file,zaa_file,zab_file,gax_file,gba_file,",
                     "gbb_file,gbf_file,zad_file,zae_file,wca_file,wcb_file,",
                     "wcc_file,wcd_file,zaw_file,zav_file,zai_file,zaj_file,",
                     "zak_file,zal_file,zam_file,zan_file,zao_file,zap_file,",
                     "zaq_file,zar_file,zas_file,zat_file,zau_file,zay_file,",
                     "wsm_file,wsn_file,wso_file,wsp_file  file=",g_packpath,"/patchtemp.dmp"
         RUN g_cmd
      WHEN g_pack_type MATCHES '[GI]'
         CLOSE DATABASE
         LET g_cmd = "cd ",g_packpath,";rm -rf patchtemp.exp"
         RUN g_cmd
         LET g_cmd = "cd ",g_packpath,";export DBDATE=Y4MD/;dbexport patchtemp"
         RUN g_cmd
      WHEN g_pack_type MATCHES '[BEHJ]'
         DATABASE patchtemp
         IF SQLCA.sqlcode THEN
            RETURN
         END IF
         IF os.Path.exists(g_packpath||os.Path.separator()||"patchtemp_data"||os.Path.separator()) THEN
            LET g_cmd = "rm -rf ",g_packpath,os.Path.separator(),"patchtemp_data"
            RUN g_cmd
         END IF
         IF NOT os.Path.mkdir(g_packpath||os.Path.separator()||"patchtemp_data") THEN
            RETURN
         END IF

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_ze.txt"
         UNLOAD TO ls_file SELECT * FROM ze_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zm.txt"
         UNLOAD TO ls_file SELECT * FROM zm_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zz.txt"
         UNLOAD TO ls_file SELECT * FROM zz_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gap.txt"
         UNLOAD TO ls_file SELECT * FROM gap_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gbd.txt"
         UNLOAD TO ls_file SELECT * FROM gbd_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gaz.txt"
         UNLOAD TO ls_file SELECT * FROM gaz_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gao.txt"
         UNLOAD TO ls_file SELECT * FROM gao_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gae.txt"
         UNLOAD TO ls_file SELECT * FROM gae_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gav.txt"
         UNLOAD TO ls_file SELECT * FROM gav_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gak.txt"
         UNLOAD TO ls_file SELECT * FROM gak_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gal.txt"
         UNLOAD TO ls_file SELECT * FROM gal_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gaq.txt"
         UNLOAD TO ls_file SELECT * FROM gaq_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gat.txt"
         UNLOAD TO ls_file SELECT * FROM gat_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gab.txt"
         UNLOAD TO ls_file SELECT * FROM gab_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gac.txt"
         UNLOAD TO ls_file SELECT * FROM gac_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wsa.txt"
         UNLOAD TO ls_file SELECT * FROM wsa_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wsb.txt"
         UNLOAD TO ls_file SELECT * FROM wsb_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zaa.txt"
         UNLOAD TO ls_file SELECT * FROM zaa_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zab.txt"
         UNLOAD TO ls_file SELECT * FROM zab_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gax.txt"
         UNLOAD TO ls_file SELECT * FROM gax_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gba.txt"
         UNLOAD TO ls_file SELECT * FROM gba_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gbb.txt"
         UNLOAD TO ls_file SELECT * FROM gbb_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_gbf.txt"
         UNLOAD TO ls_file SELECT * FROM gbf_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zad.txt"
         UNLOAD TO ls_file SELECT * FROM zad_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zae.txt"
         UNLOAD TO ls_file SELECT * FROM zae_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wca.txt"
         UNLOAD TO ls_file SELECT * FROM wca_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wcb.txt"
         UNLOAD TO ls_file SELECT * FROM wcb_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wcc.txt"
         UNLOAD TO ls_file SELECT * FROM wcc_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wcd.txt"
         UNLOAD TO ls_file SELECT * FROM wcd_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zaw.txt"
         UNLOAD TO ls_file SELECT * FROM zaw_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zav.txt"
         UNLOAD TO ls_file SELECT * FROM zav_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zai.txt"
         UNLOAD TO ls_file SELECT * FROM zai_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zaj.txt"
         UNLOAD TO ls_file SELECT * FROM zaj_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zak.txt"
         UNLOAD TO ls_file SELECT * FROM zak_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zal.txt"
         UNLOAD TO ls_file SELECT * FROM zal_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zam.txt"
         UNLOAD TO ls_file SELECT * FROM zam_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zan.txt"
         UNLOAD TO ls_file SELECT * FROM zan_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zao.txt"
         UNLOAD TO ls_file SELECT * FROM zao_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zap.txt"
         UNLOAD TO ls_file SELECT * FROM zap_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zaq.txt"
         UNLOAD TO ls_file SELECT * FROM zaq_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zar.txt"
         UNLOAD TO ls_file SELECT * FROM zar_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zas.txt"
         UNLOAD TO ls_file SELECT * FROM zas_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zat.txt"
         UNLOAD TO ls_file SELECT * FROM zat_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zau.txt"
         UNLOAD TO ls_file SELECT * FROM zau_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_zay.txt"
         UNLOAD TO ls_file SELECT * FROM zay_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wsm.txt"
         UNLOAD TO ls_file SELECT * FROM wsm_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wsn.txt"
         UNLOAD TO ls_file SELECT * FROM wsn_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wso.txt"
         UNLOAD TO ls_file SELECT * FROM wso_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         LET ls_file = g_packpath,os.Path.separator(),"patchtemp_data",os.Path.separator(),"bpatch_wsp.txt"
         UNLOAD TO ls_file SELECT * FROM wsp_file
         LET g_cmd = "cat ",ls_file,"|big5_to_gb2312 > ",ls_file,".tmp;",
                     "mv ",ls_file,".tmp ",ls_file
         RUN g_cmd

         CLOSE DATABASE

         LET g_cmd = "cd ",g_packpath,";tar cvf patchtemp_data.tar patchtemp_data;rm -rf patchtemp_data"
         RUN g_cmd
   END CASE
END MAIN

FUNCTION bpatch_pack_data_unload_zae_file(p_zae01)
   DEFINE   p_zae01   LIKE zae_file.zae01
   DEFINE   lc_zae10  LIKE zae_file.zae10
   DEFINE   ls_sql    STRING
   DEFINE   li_i      LIKE type_file.num5
   DEFINE   li_ins    LIKE type_file.num5

   LET li_ins = TRUE
   IF p_zae01 IS NOT NULL THEN
      FOR li_i = 1 TO g_zae01.getLength()
          IF g_zae01[li_i] CLIPPED = p_zae01 CLIPPED THEN
             LET li_ins = FALSE
             EXIT FOR
          END IF
      END FOR
      IF NOT li_ins THEN
         RETURN
      ELSE
         LET g_zae01[g_zae_cnt] = p_zae01
         LET g_zae_cnt = g_zae_cnt + 1
      END IF
      LET g_zae_where = g_zae_where," zae01='",p_zae01,"' OR"
      LET ls_sql = "SELECT zae10 FROM ds",g_center,"zae_file ",
                   " WHERE zae01 = '",p_zae01,"' AND zae09 = '2'"
      PREPARE unload_zae_pre FROM ls_sql
      DECLARE unload_zae_curs CURSOR FOR unload_zae_pre
      FOREACH unload_zae_curs INTO lc_zae10
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         CALL bpatch_pack_data_unload_zae_file(lc_zae10)
      END FOREACH
   END IF
END FUNCTION
