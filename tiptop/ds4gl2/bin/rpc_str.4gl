# replace string工具
DATABASE ds

DEFINE   g_ori_str   STRING
DEFINE   g_new_str   STRING
DEFINE   g_lang      CHAR(1)
DEFINE   g_gaz       CHAR(1)
DEFINE   g_gae       CHAR(1)
DEFINE   g_gbd       CHAR(1)
DEFINE   g_gat       CHAR(1)
DEFINE   g_gaq       CHAR(1)
DEFINE   g_ze        CHAR(1)
DEFINE   g_zaa       CHAR(1)
DEFINE   g_zab       CHAR(1)
DEFINE   g_gbf       CHAR(1)
DEFINE   g_gbp       CHAR(1)
DEFINE   g_gba       CHAR(1)
DEFINE   g_gbb       CHAR(1)
DEFINE   g_data      DYNAMIC ARRAY OF RECORD
            sel       CHAR(1),
            tab_name  STRING,
            fld_name  STRING,
            old_data  STRING,
            where_str STRING
                    END RECORD
DEFINE   ls_ds4gl    STRING

MAIN
   DEFINE   lc_gay01   LIKE gay_file.gay01
   DEFINE   lc_gay03   LIKE gay_file.gay03
   DEFINE   ls_per     STRING

   WHENEVER ERROR CONTINUE

   LET ls_ds4gl = FGL_GETENV("DS4GL")
   LET ls_per = ls_ds4gl,"/bin/rpc_str.42f"
   OPEN WINDOW rpc_str AT 1,1 WITH FORM ls_per
   CLOSE WINDOW screen

   LET g_gaz = "Y"
   LET g_gae = "Y"
   LET g_gbd = "Y"
   LET g_gat = "Y"
   LET g_gaq = "Y"
   LET g_ze  = "Y"
   LET g_zaa = "Y"
   LET g_zab = "Y"
   LET g_gbf = "Y"
   LET g_gbp = "Y"
   LET g_gba = "Y"
   LET g_gbb = "Y"

   INPUT g_ori_str,g_new_str,g_lang,
         g_gaz,g_gae,g_gbd,g_gat,g_gaq,g_ze ,
         g_zaa,g_zab,g_gbf,g_gbp,g_gba,g_gbb
   WITHOUT DEFAULTS FROM original_str,new_str,lang,
                         gaz,gae,gbd,gat,gaq,ze ,zaa,zab,gbf,gbp,gba,gbb
      ON ACTION view_list
         CALL GET_FLDBUF(original_str) RETURNING g_ori_str
         CALL GET_FLDBUF(new_str)      RETURNING g_new_str
         CALL GET_FLDBUF(lang)         RETURNING g_lang
         CALL GET_FLDBUF(gaz)          RETURNING g_gaz
         CALL GET_FLDBUF(gae)          RETURNING g_gae
         CALL GET_FLDBUF(gbd)          RETURNING g_gbd
         CALL GET_FLDBUF(gat)          RETURNING g_gat
         CALL GET_FLDBUF(gaq)          RETURNING g_gaq
         CALL GET_FLDBUF(ze)           RETURNING g_ze
         CALL GET_FLDBUF(zaa)          RETURNING g_zaa
         CALL GET_FLDBUF(zab)          RETURNING g_zab
         CALL GET_FLDBUF(gbf)          RETURNING g_gbf
         CALL GET_FLDBUF(gbp)          RETURNING g_gbp
         CALL GET_FLDBUF(gba)          RETURNING g_gba
         CALL GET_FLDBUF(gbb)          RETURNING g_gbb
         IF ((g_ori_str IS NULL) OR (g_new_str IS NULL) OR (g_lang IS NULL)) THEN
            MESSAGE "Please input all fields"
         ELSE
            CALL g_data.clear()
            CALL view_list()
         END IF

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   END IF

   CLOSE WINDOW rpc_str
END MAIN

FUNCTION view_list()
   DEFINE   ls_sql   STRING
   DEFINE   li_cnt   SMALLINT
   DEFINE   li_i     SMALLINT
   DEFINE   lr_gaz    RECORD LIKE gaz_file.*
   DEFINE   lr_gae    RECORD LIKE gae_file.*
   DEFINE   lr_gbd    RECORD LIKE gbd_file.*
   DEFINE   lr_gat    RECORD LIKE gat_file.*
   DEFINE   lr_gaq    RECORD LIKE gaq_file.*
   DEFINE   lr_ze     RECORD LIKE ze_file.*
   DEFINE   lr_zaa    RECORD LIKE zaa_file.*
   DEFINE   lr_zab    RECORD LIKE zab_file.*
   DEFINE   lr_gbf    RECORD LIKE gbf_file.*
   DEFINE   lr_gbp    RECORD LIKE gbp_file.*
   DEFINE   lr_gba    RECORD LIKE gba_file.*
   DEFINE   lr_gbb    RECORD LIKE gbb_file.*
   DEFINE   ls_per    STRING

   LET li_cnt = 1
   IF g_gaz = "Y" THEN
      LET ls_sql = "SELECT * FROM gaz_file WHERE gaz02 = '",g_lang,"' AND gaz03 MATCHES '*",g_ori_str,"*'"
      DECLARE gaz03_curs CURSOR FROM ls_sql
      FOREACH gaz03_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gaz_file"
         LET g_data[li_cnt].fld_name  = "gaz03"
         LET g_data[li_cnt].old_data  = lr_gaz.gaz03 CLIPPED
         LET g_data[li_cnt].where_str = "gaz01 = '",lr_gaz.gaz01 CLIPPED,"' AND ",
                                        "gaz02 = '",lr_gaz.gaz02 CLIPPED,"' AND ",
                                        "gaz05 = '",lr_gaz.gaz05 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gaz_file WHERE gaz02 = '",g_lang,"' AND gaz04 MATCHES '*",g_ori_str,"*'"
      DECLARE gaz04_curs CURSOR FROM ls_sql
      FOREACH gaz04_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gaz_file"
         LET g_data[li_cnt].fld_name  = "gaz04"
         LET g_data[li_cnt].old_data  = lr_gaz.gaz04 CLIPPED
         LET g_data[li_cnt].where_str = "gaz01 = '",lr_gaz.gaz01 CLIPPED,"' AND ",
                                        "gaz02 = '",lr_gaz.gaz02 CLIPPED,"' AND ",
                                        "gaz05 = '",lr_gaz.gaz05 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gae = "Y" THEN
      LET ls_sql = "SELECT * FROM gae_file WHERE gae03 = '",g_lang,"' AND gae04 MATCHES '*",g_ori_str,"*'"
      DECLARE gae04_curs CURSOR FROM ls_sql
      FOREACH gae04_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gae_file"
         LET g_data[li_cnt].fld_name  = "gae04"
         LET g_data[li_cnt].old_data  = lr_gae.gae04 CLIPPED
         LET g_data[li_cnt].where_str = "gae01 = '",lr_gae.gae01 CLIPPED,"' AND ",
                                        "gae02 = '",lr_gae.gae02 CLIPPED,"' AND ",
                                        "gae03 = '",lr_gae.gae03 CLIPPED,"' AND ",
                                        "gae11 = '",lr_gae.gae11 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gbd = "Y" THEN
      LET ls_sql = "SELECT * FROM gbd_file WHERE gbd03 = '",g_lang,"' AND gbd04 MATCHES '*",g_ori_str,"*'"
      DECLARE gbd04_curs CURSOR FROM ls_sql
      FOREACH gbd04_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gbd_file"
         LET g_data[li_cnt].fld_name  = "gbd04"
         LET g_data[li_cnt].old_data  = lr_gbd.gbd04 CLIPPED
         LET g_data[li_cnt].where_str = "gbd01 = '",lr_gbd.gbd01 CLIPPED,"' AND ",
                                        "gbd02 = '",lr_gbd.gbd02 CLIPPED,"' AND ",
                                        "gbd03 = '",lr_gbd.gbd03 CLIPPED,"' AND ",
                                        "gbd07 = '",lr_gbd.gbd07 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gbd_file WHERE gbd03 = '",g_lang,"' AND gbd05 MATCHES '*",g_ori_str,"*'"
      DECLARE gbd05_curs CURSOR FROM ls_sql
      FOREACH gbd05_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gbd_file"
         LET g_data[li_cnt].fld_name  = "gbd05"
         LET g_data[li_cnt].old_data  = lr_gbd.gbd05 CLIPPED
         LET g_data[li_cnt].where_str = "gbd01 = '",lr_gbd.gbd01 CLIPPED,"' AND ",
                                        "gbd02 = '",lr_gbd.gbd02 CLIPPED,"' AND ",
                                        "gbd03 = '",lr_gbd.gbd03 CLIPPED,"' AND ",
                                        "gbd07 = '",lr_gbd.gbd07 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gat = "Y" THEN
      LET ls_sql = "SELECT * FROM gat_file WHERE gat02 = '",g_lang,"' AND gat03 MATCHES '*",g_ori_str,"*'"
      DECLARE gat03_curs CURSOR FROM ls_sql
      FOREACH gat03_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gat_file"
         LET g_data[li_cnt].fld_name  = "gat03"
         LET g_data[li_cnt].old_data  = lr_gat.gat03 CLIPPED
         LET g_data[li_cnt].where_str = "gat01 = '",lr_gat.gat01 CLIPPED,"' AND ",
                                        "gat02 = '",lr_gat.gat02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gat_file WHERE gat02 = '",g_lang,"' AND gat04 MATCHES '*",g_ori_str,"*'"
      DECLARE gat04_curs CURSOR FROM ls_sql
      FOREACH gat04_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gat_file"
         LET g_data[li_cnt].fld_name  = "gat04"
         LET g_data[li_cnt].old_data  = lr_gat.gat04 CLIPPED
         LET g_data[li_cnt].where_str = "gat01 = '",lr_gat.gat01 CLIPPED,"' AND ",
                                        "gat02 = '",lr_gat.gat02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gaq = "Y" THEN
      LET ls_sql = "SELECT * FROM gaq_file WHERE gaq02 = '",g_lang,"' AND gaq03 MATCHES '*",g_ori_str,"*'"
      DECLARE gaq03_curs CURSOR FROM ls_sql
      FOREACH gaq03_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gaq_file"
         LET g_data[li_cnt].fld_name  = "gaq03"
         LET g_data[li_cnt].old_data  = lr_gaq.gaq03 CLIPPED
         LET g_data[li_cnt].where_str = "gaq01 = '",lr_gaq.gaq01 CLIPPED,"' AND ",
                                        "gaq02 = '",lr_gaq.gaq02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gaq_file WHERE gaq02 = '",g_lang,"' AND gaq04 MATCHES '*",g_ori_str,"*'"
      DECLARE gaq04_curs CURSOR FROM ls_sql
      FOREACH gaq04_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gaq_file"
         LET g_data[li_cnt].fld_name  = "gaq04"
         LET g_data[li_cnt].old_data  = lr_gaq.gaq04 CLIPPED
         LET g_data[li_cnt].where_str = "gaq01 = '",lr_gaq.gaq01 CLIPPED,"' AND ",
                                        "gaq02 = '",lr_gaq.gaq02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_ze = "Y" THEN
      LET ls_sql = "SELECT * FROM ze_file WHERE ze02 = '",g_lang,"' AND ze03 MATCHES '*",g_ori_str,"*'"
      DECLARE ze03_curs CURSOR FROM ls_sql
      FOREACH ze03_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "ze_file"
         LET g_data[li_cnt].fld_name  = "ze03"
         LET g_data[li_cnt].old_data  = lr_ze.ze03 CLIPPED
         LET g_data[li_cnt].where_str = "ze01 = '",lr_ze.ze01 CLIPPED,"' AND ",
                                        "ze02 = '",lr_ze.ze02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_zaa = "Y" THEN
      LET ls_sql = "SELECT * FROM zaa_file WHERE zaa03 = '",g_lang,"' AND zaa08 MATCHES '*",g_ori_str,"*'"
      DECLARE zaa08_curs CURSOR FROM ls_sql
      FOREACH zaa08_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "zaa_file"
         LET g_data[li_cnt].fld_name  = "zaa08"
         LET g_data[li_cnt].old_data  = lr_zaa.zaa08 CLIPPED
         LET g_data[li_cnt].where_str = "zaa01 = '",lr_zaa.zaa01 CLIPPED,"' AND ",
                                        "zaa02 = '",lr_zaa.zaa02 CLIPPED,"' AND ",
                                        "zaa03 = '",lr_zaa.zaa03 CLIPPED,"' AND ",
                                        "zaa04 = '",lr_zaa.zaa04 CLIPPED,"' AND ",
                                        "zaa10 = '",lr_zaa.zaa10 CLIPPED,"' AND ",
                                        "zaa11 = '",lr_zaa.zaa11 CLIPPED,"'"
#                                       "zaa11 = '",lr_zaa.zaa11 CLIPPED,"' AND ",
#                                       "zaa17 = '",lr_zaa.zaa17 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_zab = "Y" THEN
      LET ls_sql = "SELECT * FROM zab_file WHERE zab04 = '",g_lang,"' AND zab05 MATCHES '*",g_ori_str,"*'"
      DECLARE zab05_curs CURSOR FROM ls_sql
      FOREACH zab05_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "zab_file"
         LET g_data[li_cnt].fld_name  = "zab05"
         LET g_data[li_cnt].old_data  = lr_zab.zab05 CLIPPED
         LET g_data[li_cnt].where_str = "zab01 = '",lr_zab.zab01 CLIPPED,"' AND ",
                                        "zab03 = '",lr_zab.zab03 CLIPPED,"' AND ",
                                        "zab04 = '",lr_zab.zab04 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gbf = "Y" THEN
      LET ls_sql = "SELECT * FROM gbf_file WHERE gbf02 = '",g_lang,"' AND gbf05 MATCHES '*",g_ori_str,"*'"
      DECLARE gbf05_curs CURSOR FROM ls_sql
      FOREACH gbf05_curs INTO lr_gbf.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gbf_file"
         LET g_data[li_cnt].fld_name  = "gbf05"
         LET g_data[li_cnt].old_data  = lr_gbf.gbf05 CLIPPED
         LET g_data[li_cnt].where_str = "gbf01 = '",lr_gbf.gbf01 CLIPPED,"' AND ",
                                        "gbf02 = '",lr_gbf.gbf02 CLIPPED,"' AND ",
                                        "gbf03 = '",lr_gbf.gbf03 CLIPPED,"' AND ",
                                        "gbf04 = '",lr_gbf.gbf04 CLIPPED,"' AND ",
                                        "gbf06 = '",lr_gbf.gbf06 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gbp = "Y" THEN
      LET ls_sql = "SELECT * FROM gbp_file WHERE gbp02 = '",g_lang,"' AND gbp03 MATCHES '*",g_ori_str,"*'"
      DECLARE gbp03_curs CURSOR FROM ls_sql
      FOREACH gbp03_curs INTO lr_gbp.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gbp_file"
         LET g_data[li_cnt].fld_name  = "gbp03"
         LET g_data[li_cnt].old_data  = lr_gbp.gbp03 CLIPPED
         LET g_data[li_cnt].where_str = "gbp01 = '",lr_gbp.gbp01 CLIPPED,"' AND ",
                                        "gbp02 = '",lr_gbp.gbp02 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gba = "Y" THEN
      LET ls_sql = "SELECT * FROM gba_file WHERE gba04 = '",g_lang,"' AND gba011 MATCHES '*",g_ori_str,"*'"
      DECLARE gba011_curs CURSOR FROM ls_sql
      FOREACH gba011_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gba_file"
         LET g_data[li_cnt].fld_name  = "gba011"
         LET g_data[li_cnt].old_data  = lr_gba.gba011 CLIPPED
         LET g_data[li_cnt].where_str = "gba01 = '",lr_gba.gba01 CLIPPED,"' AND ",
                                        "gba02 = '",lr_gba.gba02 CLIPPED,"' AND ",
                                        "gba03 = '",lr_gba.gba03 CLIPPED,"' AND ",
                                        "gba04 = '",lr_gba.gba04 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gba_file WHERE gba04 = '",g_lang,"' AND gba021 MATCHES '*",g_ori_str,"*'"
      DECLARE gba021_curs CURSOR FROM ls_sql
      FOREACH gba021_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gba_file"
         LET g_data[li_cnt].fld_name  = "gba021"
         LET g_data[li_cnt].old_data  = lr_gba.gba021 CLIPPED
         LET g_data[li_cnt].where_str = "gba01 = '",lr_gba.gba01 CLIPPED,"' AND ",
                                        "gba02 = '",lr_gba.gba02 CLIPPED,"' AND ",
                                        "gba03 = '",lr_gba.gba03 CLIPPED,"' AND ",
                                        "gba04 = '",lr_gba.gba04 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)

      LET ls_sql = "SELECT * FROM gba_file WHERE gba04 = '",g_lang,"' AND gba05 MATCHES '*",g_ori_str,"*'"
      DECLARE gba05_curs CURSOR FROM ls_sql
      FOREACH gba05_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gba_file"
         LET g_data[li_cnt].fld_name  = "gba05"
         LET g_data[li_cnt].old_data  = lr_gba.gba05 CLIPPED
         LET g_data[li_cnt].where_str = "gba01 = '",lr_gba.gba01 CLIPPED,"' AND ",
                                        "gba02 = '",lr_gba.gba02 CLIPPED,"' AND ",
                                        "gba03 = '",lr_gba.gba03 CLIPPED,"' AND ",
                                        "gba04 = '",lr_gba.gba04 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   IF g_gbb = "Y" THEN
      LET ls_sql = "SELECT * FROM gbb_file WHERE gbb04 = '",g_lang,"' AND gbb09 MATCHES '*",g_ori_str,"*'"
      DECLARE gbb09_curs CURSOR FROM ls_sql
      FOREACH gbb09_curs INTO lr_gbb.*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET g_data[li_cnt].tab_name  = "gbb_file"
         LET g_data[li_cnt].fld_name  = "gbb09"
         LET g_data[li_cnt].old_data  = lr_gbb.gbb09 CLIPPED
         LET g_data[li_cnt].where_str = "gbb01 = '",lr_gbb.gbb01 CLIPPED,"' AND ",
                                        "gbb02 = '",lr_gbb.gbb02 CLIPPED,"' AND ",
                                        "gbb03 = '",lr_gbb.gbb03 CLIPPED,"' AND ",
                                        "gbb04 = '",lr_gbb.gbb04 CLIPPED,"' AND ",
                                        "gbb05 = '",lr_gbb.gbb05 CLIPPED,"'"
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL g_data.deleteElement(li_cnt)
   END IF

   LET ls_per = ls_ds4gl,"/bin/rpc_str_list.42f"
   OPEN WINDOW view_list AT 1,1 WITH FORM ls_per

   DISPLAY ARRAY g_data TO s_data.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   INPUT ARRAY g_data WITHOUT DEFAULTS FROM s_data.*
      ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)

      BEFORE INPUT
         IF g_data.getLength() <= 0 THEN
            MESSAGE "Have no matches data"
         ELSE
            FOR li_i = 1 TO g_data.getLength()
                LET g_data[li_i].sel = "N"
            END FOR
         END IF

      BEFORE ROW
         CALL fgl_set_arr_curr(ARR_CURR())
         CALL cl_show_textEdit_comment()

      AFTER ROW
         CALL GET_FLDBUF(s_data.sel) RETURNING g_data[ARR_CURR()].sel

      ON ACTION select_all
         FOR li_i = 1 TO g_data.getLength()
             LET g_data[li_i].sel = "Y"
         END FOR

      ON ACTION select_none
         FOR li_i = 1 TO g_data.getLength()
             LET g_data[li_i].sel = "N"
         END FOR

      ON ACTION accept
         IF ((g_ori_str IS NULL) OR (g_new_str IS NULL) OR
             (g_lang IS NULL)) THEN
         ELSE
            MESSAGE "Updating...."
            CALL update()
         END IF
         EXIT INPUT

      ON ACTION cancel
         EXIT INPUT

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   END IF

   CLOSE WINDOW view_list
END FUNCTION

FUNCTION update()
   DEFINE   ls_sql    STRING
   DEFINE   ls_result STRING
   DEFINE   li_i      SMALLINT

   FOR li_i = 1 TO g_data.getLength()
       IF g_data[li_i].sel = "Y" THEN
          CALL cl_replace_str(g_data[li_i].old_data,g_ori_str,g_new_str) RETURNING ls_result
          CALL cl_replace_str(ls_result,"'","''") RETURNING ls_result
          LET ls_sql = "UPDATE ",g_data[li_i].tab_name," SET ",g_data[li_i].fld_name," = '",ls_result,"'",
                       " WHERE ",g_data[li_i].where_str
          PREPARE update_pre FROM ls_sql
          EXECUTE update_pre
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             DISPLAY SQLCA.sqlcode," Update Error"
             DISPLAY ls_sql
             CONTINUE FOR
          END IF
          FREE update_pre
       END IF
   END FOR
END FUNCTION

FUNCTION cl_replace_str(ps_source, ps_old, ps_new)
  DEFINE ps_source,ps_old,ps_new STRING
  DEFINE ls_source_left,ls_source_right,ls_result STRING
  DEFINE li_old_index SMALLINT


  LET ps_source = ps_source.trimRight()
  LET li_old_index = ps_source.getIndexOf(ps_old, 1)

  IF (li_old_index >= 1) THEN
     LET ls_source_left = ps_source.subString(1, li_old_index-1)
     LET ls_source_right = ps_source.subString(li_old_index+ps_old.getLength(), ps_source.getLength())
     LET ls_source_right = cl_replace_str(ls_source_right,ps_old,ps_new)
     LET ps_source = ls_source_left,ps_new,ls_source_right
  END IF

  RETURN ps_source
END FUNCTION

FUNCTION cl_show_textEdit_comment()
   DEFINE lwin_curr        ui.Window
   DEFINE lfrm_curr        ui.Form
   DEFINE lnode_item       om.DomNode
   DEFINE ls_item_tag      STRING
   DEFINE lnode_value_list om.DomNode,
          lnode_value      om.DomNode,
          lst_value        om.NodeList 
   DEFINE lnode_parent     om.DomNode
   DEFINE lnode_child      om.DomNode
   DEFINE li_curr          SMALLINT
   DEFINE li_show_curr     SMALLINT
   DEFINE li_offset        SMALLINT
   DEFINE li_pagesize      SMALLINT
   DEFINE ls_node_val      STRING
   DEFINE ls_node_comt     STRING
   DEFINE li_inx_e         SMALLINT


   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
   LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.old_data")

   IF (lnode_item IS NOT NULL) THEN
      LET ls_item_tag = lnode_item.getTagName()

      IF ls_item_tag.equals("TableColumn") THEN
         LET lnode_value_list = lnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = lnode_item.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET ls_node_val = lnode_value.getAttribute("value")
         END IF
      END IF

      LET lnode_child = lnode_item.getFirstChild()
      LET ls_node_comt = lnode_child.getAttribute("comment")
      LET li_inx_e = ls_node_comt.getIndexOf(" \n --(",1)
      IF li_inx_e != 0 THEN
         LET ls_node_comt = ls_node_comt.subString(1,li_inx_e - 1)
      END IF
      
      IF (ls_node_val IS NOT NULL) THEN
         LET ls_node_comt = ls_node_comt," \n --(",ls_node_val.trim(),")--"
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      ELSE
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      END IF
   END IF
END FUNCTION
