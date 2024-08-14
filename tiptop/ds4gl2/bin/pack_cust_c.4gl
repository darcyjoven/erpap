##################################################
# Description  	: 客戶客製打包程式
# Date & Author : 2007/09/26 by saki
# Parameter   	: g_prog_path  ARG_VAL(1) 打包路徑
#               : g_patch_no   ARG_VAL(2) 打包單號
#               : g_patch_name ARG_VAL(3) 打包檔名
#               : g_pack_zs    ARG_VAL(4) 打包zs記錄
# Return   	: 
# Memo        	: 打包patch程式 patch_cust_c.sh, patch_load_custdata.42m
# Modify        : No:FUN-840067 08/04/22 by saki 若有相關文件則打包
# Modify        : No:FUN-8B0037 08/11/17 by saki 相關文件打包修正
##################################################
IMPORT os

DATABASE ds

DEFINE   g_prog_path   STRING
DEFINE   g_patch_no    STRING
DEFINE   g_patch_name  STRING
DEFINE   g_pack_zs     CHAR(1)
DEFINE   gc_channel    base.Channel
DEFINE   g_db_type     CHAR(3)
DEFINE   g_gfb         DYNAMIC ARRAY OF RECORD
            gfb01      LIKE gfb_file.gfb01,
            gfb02      LIKE gfb_file.gfb02,
            gfb04      LIKE gfb_file.gfb04,
            gfb11      LIKE gfb_file.gfb11
                       END RECORD
DEFINE   g_patch_path  STRING
DEFINE   g_lang        DYNAMIC ARRAY OF RECORD
            gay01      LIKE gay_file.gay01
                       END RECORD
DEFINE   g_tempdir     STRING
DEFINE   g_ds4gl_path  STRING
DEFINE   g_unload_db   STRING
DEFINE   g_load_db     STRING

MAIN
   DEFINE   l_str          STRING

   WHENEVER ERROR CONTINUE

   LET g_prog_path = ARG_VAL(1)         # 打包路徑
   LET g_patch_no = ARG_VAL(2)          # 打包單號
   LET g_patch_name = ARG_VAL(3)        # 打包檔名
   LET g_pack_zs = ARG_VAL(4)           # 打包zs紀錄

   LET g_tempdir = FGL_GETENV('TEMPDIR')
   LET g_db_type = DB_GET_DATABASE_TYPE()
   LET g_ds4gl_path = FGL_GETENV('DS4GL')
   IF g_db_type = "ORA" THEN
      RUN 'custtemp.sh'

      LET g_unload_db = "ds."
      LET g_load_db   = "custtemp."
   ELSE
      RUN 'custtemp_ifx.sh'   #No:FUN-8B0037

      LET g_unload_db = "ds:"
      LET g_load_db   = "custtemp:"
   END IF


   IF g_pack_zs IS NULL THEN
      LET g_pack_zs = "N"
   END IF

   IF (g_prog_path IS NOT NULL) AND (g_patch_name IS NOT NULL) THEN
      CALL p_develop_pack()
   END IF
END MAIN

FUNCTION p_develop_pack()
   DEFINE   l_sql          STRING
   DEFINE   l_cmd          STRING
   DEFINE   l_cnt          INTEGER
   DEFINE   li_i           SMALLINT
   DEFINE   li_j           INTEGER
   DEFINE   li_k           INTEGER
   DEFINE   l_str          STRING
   DEFINE   l_gfc          DYNAMIC ARRAY OF RECORD
               gfc03       LIKE gfc_file.gfc03,
               gfc04       LIKE gfc_file.gfc04,
               gfc05       LIKE gfc_file.gfc05
                           END RECORD
   DEFINE   l_config       STRING
   DEFINE   l_path         STRING
   DEFINE   li_result      SMALLINT
   DEFINE   ls_pack_prog   STRING
   DEFINE   li_inx_s       SMALLINT
   DEFINE   li_sch_noexist SMALLINT
   DEFINE   lc_zs08        LIKE zs_file.zs08
   DEFINE   ls_file        STRING


   # 預先刪除temp資料庫內的資料
   CALL pack_delete_tempdb_data()

   # 找出要打包的所有gfb_file資料
   LET l_sql = "SELECT gfb01,gfb02,gfb04,gfb11 FROM gfb_file",
               " WHERE gfb02 = '4' AND gfb01 = '",g_patch_no,"'"
   PREPARE pack_pre FROM l_sql
   DECLARE pack_curs CURSOR FOR pack_pre

   LET l_cnt = 1
   FOREACH pack_curs INTO g_gfb[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_gfb.deleteElement(l_cnt)

   IF g_gfb.getLength() <= 0 THEN
      DISPLAY 'no patch produce...'
      RETURN
   END IF

   # 製造patch的temp目錄在$TEMPDIR下
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm -rf ",g_tempdir,"/",g_patch_name,"_tab"
      RUN l_cmd
      LET l_cmd = "mkdir ",g_tempdir,"/",g_patch_name,"_tab"
      RUN l_cmd RETURNING li_result
      IF li_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET g_patch_path = g_tempdir,"/",g_patch_name,"_tab"
      CALL pack_gen_cmdfile(g_patch_path)
   ELSE
      LET l_cmd = "rm -rf ",g_tempdir,"/",g_patch_name
      RUN l_cmd
      LET l_cmd = "mkdir ",g_tempdir,"/",g_patch_name
      RUN l_cmd RETURNING li_result
      IF li_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET g_patch_path = g_tempdir,"/",g_patch_name
   END IF


   IF (g_pack_zs != 'Y') OR (g_pack_zs IS NULL) THEN
      # 記錄包了哪些單號、內容
      LET gc_channel = base.Channel.create()
      LET l_cmd = g_patch_path,"/info.txt"
      CALL gc_channel.openFile(l_cmd,"w")
      CALL gc_channel.setDelimiter("")

      # Source 檔案路徑
      CALL g_lang.clear()
      LET l_cnt = 1
      DECLARE gay_curs CURSOR FOR
              SELECT UNIQUE gay01 FROM gay_file
      FOREACH gay_curs INTO g_lang[l_cnt].gay01
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL g_lang.deleteElement(l_cnt)

      LET l_config = "config"
      LET l_cmd = "rm -rf ",g_patch_path,"/topcust"
      RUN l_cmd
      LET l_cmd = "mkdir ",g_patch_path,"/topcust"
      RUN l_cmd

      FOR li_i = 1 TO g_gfb.getLength()
         LET l_str = "No : ",g_gfb[li_i].gfb01 CLIPPED,"   Program Name : ",g_gfb[li_i].gfb04 CLIPPED
         CALL gc_channel.write(l_str)
         LET l_str = "Bug Content :"
         CALL gc_channel.write(l_str)
         LET l_str = g_gfb[li_i].gfb11 CLIPPED
         CALL gc_channel.write(l_str)

         CALL p_develop_pack_devdata(g_gfb[li_i].gfb01 CLIPPED)   #打包開發記錄

         CALL p_develop_pack_datalist(g_gfb[li_i].gfb01 CLIPPED)  #打包資料同步清單

         LET l_sql = "SELECT gfc03,gfc04,gfc05 FROM gfc_file",
                     " WHERE gfc01 = '",g_gfb[li_i].gfb01 CLIPPED,"' ORDER BY gfc03"
         PREPARE gfc_pre FROM l_sql
         DECLARE gfc_curs CURSOR FOR gfc_pre

         CALL l_gfc.clear()
         LET l_cnt = 1
         FOREACH gfc_curs INTO l_gfc[l_cnt].*
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_gfc.deleteElement(l_cnt)

         FOR li_j = 1 TO l_gfc.getLength()
            CASE
               WHEN (l_gfc[li_j].gfc04 = "4gl")
                  LET ls_pack_prog = l_gfc[li_j].gfc05 CLIPPED
                  LET li_inx_s = ls_pack_prog.getIndexOf(".4gl",1)
                  LET ls_pack_prog = ls_pack_prog.subString(1,li_inx_s - 1)

                  LET l_path = g_patch_path,"/topcust/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED,'/',
                              l_gfc[li_j].gfc05 CLIPPED," ",l_path
                  RUN l_cmd

                  # 打包4gl所屬4ad檔
                  FOR li_k = 1 TO g_lang.getLength()
                      LET l_path = g_patch_path,"/topcust/",l_config CLIPPED,'/4ad/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gfc[li_j].gfc03 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      LET l_cmd = "cp ",g_prog_path,"/",l_config CLIPPED,'/4ad/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gfc[li_j].gfc03 CLIPPED,'/',ls_pack_prog,".4ad ",l_path
                      RUN l_cmd
                  END FOR

                  # 打包4gl所屬4tm檔
                  LET l_path = g_patch_path,"/topcust/",l_config CLIPPED,'/4tm/',
                               l_gfc[li_j].gfc03 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_config CLIPPED,'/4tm/',
                               l_gfc[li_j].gfc03 CLIPPED,'/',ls_pack_prog,".4tm ",l_path
                  RUN l_cmd

                  # 打包4gl相關gap_file,gbd_file,gaz_file,gak_file,gal_file資料
                  CALL p_develop_pack_data_relate_4gl(l_gfc[li_j].gfc03,ls_pack_prog)

               WHEN (l_gfc[li_j].gfc04 = "4fd")
                  LET ls_pack_prog = l_gfc[li_j].gfc05 CLIPPED
                  LET li_inx_s = ls_pack_prog.getIndexOf(".4fd",1)
                  LET ls_pack_prog = ls_pack_prog.subString(1,li_inx_s - 1)

                  # 4fd
                  LET l_path = g_patch_path,"/topcust/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED,'/',
                              l_gfc[li_j].gfc05 CLIPPED," ",l_path
                  RUN l_cmd
                  # per
                  LET l_path = g_patch_path,"/topcust/",l_gfc[li_j].gfc03 CLIPPED,'/per'
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_gfc[li_j].gfc03 CLIPPED,'/per/',
                              ls_pack_prog,".per ",l_path
                  RUN l_cmd
                  #sdd
                  LET l_path = g_patch_path,"/topcust/",l_gfc[li_j].gfc03 CLIPPED,'/sdd'
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_gfc[li_j].gfc03 CLIPPED,'/sdd/',
                              ls_pack_prog,".sdd ",l_path
                  RUN l_cmd
                  
                  # 打包4fd相關gae_file,gav_file
                  CALL p_develop_pack_data_relate_4fd(l_gfc[li_j].gfc03,ls_pack_prog)

               OTHERWISE
                  LET l_path = g_patch_path,"/topcust/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",g_prog_path,"/",l_gfc[li_j].gfc03 CLIPPED,'/',l_gfc[li_j].gfc04 CLIPPED,'/',
                              l_gfc[li_j].gfc05 CLIPPED," ",l_path
                  RUN l_cmd
            END CASE
         END FOR

      END FOR

      CALL p_develop_pack_related_document()     #No:FUN-840067

#     IF g_com = "Y" THEN
#        CALL p_develop_pack_common_data()
#     END IF

      LET l_str = "==================",g_gfb.getLength()," data"
      CALL gc_channel.write(l_str)
      CALL gc_channel.close()

      # 依照資料庫打包資料
      IF g_db_type = "IFX" THEN
         CLOSE DATABASE
         LET l_cmd = "rm -rf custtemp.exp"
         RUN l_cmd
         LET l_cmd = "export DBDATE=Y4MD/;dbexport custtemp"
         RUN l_cmd
      ELSE
         LET l_cmd = "exp custtemp/custtemp@$ORACLE_SID tables=ze_file, zz_file, ",
                     "gap_file, gbd_file, gao_file, gae_file, gak_file, gal_file, ",
                     "gaq_file, gab_file, gac_file, gav_file, gat_file, gaz_file, ",
                     "wsa_file, wsb_file, zaa_file, zab_file, zai_file, zaj_file, ",
                     "zak_file, zal_file, zam_file, zan_file, zao_file, zap_file, ",
                     "zaq_file, zar_file, zas_file, zat_file, zau_file, zav_file, ",
                     "zay_file, zaw_file, gfb_file, gfc_file, gfd_file, gca_file, ",
                     "gcb_file file=/tmp/custtemp.dmp"  #No:FUN-840067
         RUN l_cmd
      END IF
   END IF 

   # 打包檔案修改記錄, 順便加入zs資料
   IF (g_pack_zs = 'Y') THEN
      LET lc_zs08 = g_patch_no
      LET ls_file = g_patch_path,"/patch_zs_file.txt"
      UNLOAD TO ls_file
         SELECT * FROM zs_file
          WHERE zs08=lc_zs08
      IF SQLCA.sqlcode THEN
         DISPLAY g_patch_no," 未成功打包檔案修改記錄"
      ELSE
         DISPLAY g_patch_no," 打包檔案修改記錄於patch_zs_file.txt"
      END IF
   END IF

   # Unpack 程式路徑
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",g_ds4gl_path,
               "/bin;fglcomp -M patch_cust_c;fgl2p -o patch_cust_c.42r patch_cust_c.42m"
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust_c.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust_c.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust_c.42r ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cd ",g_ds4gl_path,"/bin;fglform patch_cust"
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust.per ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust.42f ",g_patch_path
   RUN l_cmd
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",g_ds4gl_path,"/bin",
               ";fglcomp -M patch_load_custdata;fgl2p -o patch_load_custdata.42r patch_load_custdata.42m"
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_load_custdata.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_load_custdata.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_load_custdata.42r ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_cust_c.sh ",g_patch_path
   RUN l_cmd
   #No:FUN-840067 --start--
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",g_ds4gl_path,"/bin",
               ";fglcomp -M patch_import_doc;fgl2p -o patch_import_doc.42r patch_import_doc.42m"
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_import_doc.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_import_doc.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/patch_import_doc.42r ",g_patch_path
   RUN l_cmd
   #No:FUN-840067 ---end---

   # Data dmp 路徑
   IF (g_pack_zs != 'Y') OR (g_pack_zs IS NULL) THEN
      IF g_db_type = "IFX" THEN
         LET l_cmd = "cp -rf custtemp.exp ",g_patch_path
         RUN l_cmd
      ELSE
         LET l_cmd = "cp /tmp/custtemp.dmp ",g_patch_path
         RUN l_cmd
      END IF
   END IF

   # Schema 檔案路徑
   #No:FUN-8B0037 --start--
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",g_ds4gl_path,"/bin",
               ";fglcomp -M execmd_cust;fgl2p -o execmd_cust.42r execmd_cust.42m"
   RUN l_cmd
   #No:FUN-8B0037 ---end---
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/execmd_cust.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/execmd_cust.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",g_ds4gl_path,"/bin/execmd_cust.42r ",g_patch_path
   RUN l_cmd
   IF g_db_type="IFX" THEN
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
   ELSE
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
   END IF

   # 打包source檔,打包zs時不打包source
   IF (g_pack_zs != 'Y') OR (g_pack_zs IS NULL) THEN
      LET l_cmd = "cd ",g_patch_path,"/topcust;tar cvf ",g_patch_path,"/",g_patch_name,"_source.tar *"
      RUN l_cmd
      LET l_cmd = "cd ",g_patch_path,";rm -rf topcust"
      RUN l_cmd
   END IF

   # schema,data,source.tar,patch.42m,patch.sh打包
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "cd ",g_tempdir,"/",g_patch_name,"_tab;test -s patch_cust_command"
      RUN l_cmd RETURNING li_sch_noexist
      IF NOT li_sch_noexist THEN
         LET l_cmd = "cd ",g_tempdir,";tar cvf ",
                      g_tempdir,"/",g_patch_name,"_tab.tar ",g_patch_name,"_tab",
                      " 2>/dev/null"
         RUN l_cmd
      END IF
   ELSE
      LET l_cmd = "cd ",g_tempdir,";tar cvf ",
                   g_tempdir,"/",g_patch_name,".tar ",g_patch_name,
                   " 2>/dev/null"
      RUN l_cmd
   END IF

   # 放大tar檔的權限
   IF g_pack_zs = "Y" THEN
      IF NOT li_sch_noexist THEN
         LET l_cmd = "chmod 777 ",g_tempdir,"/",g_patch_name,"_tab.tar 2>/dev/null"
      END IF
   ELSE
      LET l_cmd = "chmod 777 ",g_tempdir,"/",g_patch_name,".tar 2>/dev/null"
   END IF
   RUN l_cmd

   # 將原本暫存的patch資料夾砍掉
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm -rf ",g_tempdir,"/",g_patch_name,"_tab"
   ELSE
      LET l_cmd = "rm -rf ",g_tempdir,"/",g_patch_name
   END IF
   RUN l_cmd

   # 確認tar檔有沒有產生，有產生就一併做shell檔案
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "test -s ",g_tempdir,"/",g_patch_name,"_tab.tar"
   ELSE
      LET l_cmd = "test -s ",g_tempdir,"/",g_patch_name,".tar"
   END IF
   RUN l_cmd RETURNING li_result

   IF NOT li_result THEN
      CALL pack_mk_patch_shell(g_patch_name)
   END IF

END FUNCTION

# 由修改清單建立暫存patch/topcust資料夾下的目錄
FUNCTION pack_chk_and_add_dir(p_path)
   DEFINE   p_path   STRING
   DEFINE   l_cmd    STRING


   IF NOT os.Path.exists(p_path) THEN
      IF NOT os.Path.mkdir(p_path) THEN
         LET l_cmd = "mkdir -p ",p_path
         RUN l_cmd
      END IF
   END IF

END FUNCTION

# 由修改清單的4gl選項，自動抓取zz_file,gap_file,gbd_file,gaz_file,gak_file,gal_file資料
FUNCTION p_develop_pack_data_relate_4gl(ps_system,ps_filename)
   DEFINE   ps_system   STRING
   DEFINE   ps_filename LIKE gap_file.gap01
   DEFINE   l_sql       STRING
   DEFINE   l_cnt       INTEGER
   DEFINE   lr_zz       RECORD LIKE zz_file.*
   DEFINE   lr_gaz      RECORD LIKE gaz_file.*
   DEFINE   lr_gap      RECORD LIKE gap_file.*
   DEFINE   lr_gbd      RECORD LIKE gbd_file.*
   DEFINE   lr_gak      RECORD LIKE gak_file.*
   DEFINE   lr_gal      RECORD LIKE gal_file.*


   # zz_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"zz_file WHERE zz01='",ps_filename,"'"
   PREPARE fgl_zz_pre FROM l_sql
   EXECUTE fgl_zz_pre INTO lr_zz.*
   IF g_db_type = "ORA" THEN
      INSERT INTO custtemp.zz_file VALUES(lr_zz.*)
   ELSE
      INSERT INTO custtemp:zz_file VALUES(lr_zz.*)
   END IF
   IF NOT SQLCA.sqlcode THEN
      DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到zz_file   1筆資料"
   END IF
      
   # gaz_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gaz_file ",
               " WHERE gaz01='",ps_filename,"' AND gaz05='Y'"
   PREPARE fgl_gaz_pre FROM l_sql
   DECLARE fgl_gaz_curs CURSOR FOR fgl_gaz_pre
   LET l_cnt = 0
   FOREACH fgl_gaz_curs INTO lr_gaz.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gaz_file VALUES(lr_gaz.*)
      ELSE
         INSERT INTO custtemp:gaz_file VALUES(lr_gaz.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gaz_file",l_cnt,"筆資料"
   
   # 由4gl自動抓取gap_file,程式名稱對應的Action資料
   LET l_sql = "SELECT * FROM ",g_unload_db,"gap_file WHERE gap01='",ps_filename,"'"
   PREPARE fgl_gap_pre FROM l_sql
   DECLARE fgl_gap_curs CURSOR FOR fgl_gap_pre
   LET l_cnt = 0
   FOREACH fgl_gap_curs INTO lr_gap.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gap_file VALUES(lr_gap.*)
      ELSE
         INSERT INTO custtemp:gap_file VALUES(lr_gap.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gap_file ",l_cnt,"筆資料"

   # 由4gl自動抓取gbd_file,程式名稱對應的Action多語言資料
   LET l_sql = "SELECT gbd_file.* FROM ",g_unload_db,"gap_file,",g_unload_db,"gbd_file",
               " WHERE gap01='",ps_filename,"' AND gap02=gbd01"
   PREPARE fgl_gbd_pre FROM l_sql
   DECLARE fgl_gbd_curs CURSOR FOR fgl_gbd_pre
   LET l_cnt = 0
   FOREACH fgl_gbd_curs INTO lr_gbd.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gbd_file VALUES(lr_gbd.*)
      ELSE
         INSERT INTO custtemp:gbd_file VALUES(lr_gbd.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gbd_file ",l_cnt,"筆資料"

   # 由4gl自動抓取gak_file
   IF ps_filename = "cl_" OR ps_filename = "ccl_" THEN
      LET ps_filename = "lib"
   END IF
   IF ps_filename = "s_" OR ps_filename = "cs_" THEN
      LET ps_filename = "sub"
   END IF
   IF ps_filename = "q_" OR ps_filename = "cq_" THEN
      LET ps_filename = "qry"
   END IF
   LET l_sql = "SELECT * FROM ",g_unload_db,"gak_file WHERE gak01='",ps_filename,"'"
   PREPARE fgl_gak_pre FROM l_sql
   DECLARE fgl_gak_curs CURSOR FOR fgl_gak_pre
   LET l_cnt = 0
   FOREACH fgl_gak_curs INTO lr_gak.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gak_file VALUES(lr_gak.*)
      ELSE
         INSERT INTO custtemp:gak_file VALUES(lr_gak.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gak_file ",l_cnt,"筆資料"

   # 由4gl自動抓取gal_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gal_file WHERE gal01='",ps_filename,"'"
   PREPARE fgl_gal_pre FROM l_sql
   DECLARE fgl_gal_curs CURSOR FOR fgl_gal_pre
   LET l_cnt = 0
   FOREACH fgl_gal_curs INTO lr_gal.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gal_file VALUES(lr_gal.*)
      ELSE
         INSERT INTO custtemp:gal_file VALUES(lr_gal.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gal_file ",l_cnt,"筆資料"
END FUNCTION

# 由修改清單的4fd選項，自動抓取gae_file,gav_file
FUNCTION p_develop_pack_data_relate_4fd(ps_system,ps_filename)
   DEFINE   ps_system   STRING
   DEFINE   ps_filename LIKE gap_file.gap01
   DEFINE   l_sql       STRING
   DEFINE   l_cnt       INTEGER
   DEFINE   lr_gae      RECORD LIKE gae_file.*
   DEFINE   lr_gav      RECORD LIKE gav_file.*


   # gae_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gae_file ",
               " WHERE gae01='",ps_filename,"' AND gae11='Y'"
   PREPARE fgl_gae_pre FROM l_sql
   DECLARE fgl_gae_curs CURSOR FOR fgl_gae_pre
   LET l_cnt = 0
   FOREACH fgl_gae_curs INTO lr_gae.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gae_file VALUES(lr_gae.*)
      ELSE
         INSERT INTO custtemp:gae_file VALUES(lr_gae.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gae_file",l_cnt,"筆資料"

   # gav_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gav_file ",
               " WHERE gav01='",ps_filename,"' AND gav08='Y'"
   PREPARE fgl_gav_pre FROM l_sql
   DECLARE fgl_gav_curs CURSOR FOR fgl_gav_pre
   LET l_cnt = 0
   FOREACH fgl_gav_curs INTO lr_gav.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gav_file VALUES(lr_gav.*)
      ELSE
         INSERT INTO custtemp:gav_file VALUES(lr_gav.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET l_cnt = l_cnt + 1
      END IF
   END FOREACH
   DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 補抓到gav_file",l_cnt,"筆資料"
END FUNCTION

# 打包單號群下面的gfd_file所填的對應資料
FUNCTION p_develop_pack_datalist(p_gfb01)
   DEFINE   p_gfb01      LIKE gfb_file.gfb01
   DEFINE   l_sql        STRING
   DEFINE   l_gfd        DYNAMIC ARRAY OF RECORD
               gfd02     LIKE gfd_file.gfd02,
               gfd04     LIKE gfd_file.gfd04,
               gfd05     LIKE gfd_file.gfd05,
               gfd06     LIKE gfd_file.gfd06
                         END RECORD
   DEFINE   l_cmd        STRING
   DEFINE   li_i         INTEGER
   DEFINE   li_k         INTEGER
   DEFINE   l_cnt        INTEGER
   DEFINE   l_count      INTEGER
   DEFINE   l_path       STRING
   DEFINE   l_cust       STRING
   DEFINE   ls_where     STRING
   DEFINE   ls_feld_name VARCHAR(15)
   DEFINE   lr_zz        RECORD LIKE zz_file.*
   DEFINE   lr_gaz       RECORD LIKE gaz_file.*
   DEFINE   lr_gap       RECORD LIKE gap_file.*
   DEFINE   lr_gbd       RECORD LIKE gbd_file.*
   DEFINE   lr_gak       RECORD LIKE gak_file.*
   DEFINE   lr_gal       RECORD LIKE gal_file.*
   DEFINE   lr_ze        RECORD LIKE ze_file.*
   DEFINE   lr_gao       RECORD LIKE gao_file.*
   DEFINE   lr_gae       RECORD LIKE gae_file.*
   DEFINE   lr_gav       RECORD LIKE gav_file.*
   DEFINE   lr_gab       RECORD LIKE gab_file.*
   DEFINE   lr_gac       RECORD LIKE gac_file.*
   DEFINE   lr_gat       RECORD LIKE gat_file.*
   DEFINE   lr_gaq       RECORD LIKE gaq_file.*
   DEFINE   lr_zaa       RECORD LIKE zaa_file.*
   DEFINE   lr_zab       RECORD LIKE zab_file.*
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
   DEFINE   lr_zay       RECORD LIKE zay_file.*
   DEFINE   lr_zaw       RECORD LIKE zaw_file.*


   LET l_cust = FGL_GETENV('CUST')

   LET l_sql = "SELECT gfd02,gfd04,gfd05,gfd06 FROM ",g_unload_db,"gfd_file",
               " WHERE gfd01 = '",p_gfb01 CLIPPED,"'"
   PREPARE gfd_pre FROM l_sql
   DECLARE gfd_curs CURSOR FOR gfd_pre

   CALL l_gfd.clear()
   LET l_cnt = 1
   FOREACH gfd_curs INTO l_gfd[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gfd.deleteElement(l_cnt)

   FOR li_i = 1 TO l_gfd.getLength()
       LET l_cmd = NULL
       IF l_gfd[li_i].gfd04 IS NULL THEN
          DISPLAY "Bug No:",p_gfb01," Item:",l_gfd[li_i].gfd02,"  此筆資料中table狀態不明"
       END IF
       IF l_gfd[li_i].gfd06 IS NULL THEN
          DISPLAY "Bug No:",p_gfb01," Item:",l_gfd[li_i].gfd02,"  ",l_gfd[li_i].gfd04 CLIPPED,":資料主key值null,無法篩選資料"
          CONTINUE FOR
       END IF
       
       CASE l_gfd[li_i].gfd04
          WHEN "1"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"zz_file WHERE zz01='",l_gfd[li_i].gfd06 CLIPPED,"'"
          WHEN "2"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"ze_file WHERE ze01='",l_gfd[li_i].gfd06 CLIPPED,"'"
          WHEN "3"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"gao_file WHERE gao01='",UPSHIFT(l_gfd[li_i].gfd06 CLIPPED),"'"
          WHEN "4"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"gae_file WHERE gae01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gae11='Y'"
          WHEN "5"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"gab_file WHERE gab01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gab11='Y'"
          WHEN "6"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"gat_file WHERE gat01='",l_gfd[li_i].gfd06 CLIPPED,"'"
          WHEN "7"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"gaq_file WHERE gaq01='",l_gfd[li_i].gfd06 CLIPPED,"'"
          WHEN "8"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"zaa_file WHERE zaa01='",l_gfd[li_i].gfd06 CLIPPED,"'"
          WHEN "9"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"zai_file WHERE zai01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zai05='Y'"
          WHEN "A"
             LET l_sql = "SELECT COUNT(*) FROM ",g_unload_db,"zaw_file WHERE zaw01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zaw03='Y'"
       END CASE
       PREPARE count_pre FROM l_sql
       EXECUTE count_pre INTO l_count
       IF l_count <= 0 THEN
          DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 沒有抓到資料"
          CONTINUE FOR
       END IF

       CASE l_gfd[li_i].gfd04
          WHEN "1"
             IF l_gfd[li_i].gfd05 != "zz_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             # zz_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zz_file WHERE zz01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE zz_pre FROM l_sql
             DECLARE zz_curs CURSOR FOR zz_pre
             LET l_cnt = 0
             FOREACH zz_curs INTO lr_zz.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zz_file VALUES(lr_zz.*)
                ELSE
                   INSERT INTO custtemp:zz_file VALUES(lr_zz.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 附加gaz_file資料
             LET l_sql = "SELECT * FROM ",g_unload_db,"gaz_file ",
                         " WHERE gaz01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gaz05='Y'"
             PREPARE gaz_pre FROM l_sql
             DECLARE gaz_curs CURSOR FOR gaz_pre
             LET l_cnt = 0
             FOREACH gaz_curs INTO lr_gaz.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gaz_file VALUES(lr_gaz.*)
                ELSE
                   INSERT INTO custtemp:gaz_file VALUES(lr_gaz.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gaz_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 附加gap_file資料
             LET l_sql = "SELECT * FROM ",g_unload_db,"gap_file ",
                         " WHERE gap01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gap_pre FROM l_sql
             DECLARE gap_curs CURSOR FOR gap_pre
             LET l_cnt = 0
             FOREACH gap_curs INTO lr_gap.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gap_file VALUES(lr_gap.*)
                ELSE
                   INSERT INTO custtemp:gap_file VALUES(lr_gap.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gap_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 附加gbd_file資料
             LET l_sql = "SELECT gbd_file.* FROM ",g_unload_db,"gap_file,",g_unload_db,"gbd_file",
                         " WHERE gap01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gap02=gbd01"
             PREPARE gbd_pre FROM l_sql
             DECLARE gbd_curs CURSOR FOR gbd_pre
             LET l_cnt = 0
             FOREACH gbd_curs INTO lr_gbd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gbd_file VALUES(lr_gbd.*)
                ELSE
                   INSERT INTO custtemp:gbd_file VALUES(lr_gbd.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gbd_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 附加gak_file資料
             LET l_sql = "SELECT * FROM ",g_unload_db,"gak_file ",
                         " WHERE gak01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gak_pre FROM l_sql
             DECLARE gak_curs CURSOR FOR gak_pre
             LET l_cnt = 0
             FOREACH gak_curs INTO lr_gak.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gak_file VALUES(lr_gak.*)
                ELSE
                   INSERT INTO custtemp:gak_file VALUES(lr_gak.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gak_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 附加gal_file資料
             LET l_sql = "SELECT * FROM ",g_unload_db,"gal_file ",
                         " WHERE gal01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gal_pre FROM l_sql
             DECLARE gal_curs CURSOR FOR gal_pre
             LET l_cnt = 0
             FOREACH gal_curs INTO lr_gal.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gal_file VALUES(lr_gal.*)
                ELSE
                   INSERT INTO custtemp:gal_file VALUES(lr_gal.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gal_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "2"
             IF l_gfd[li_i].gfd05 != "ze_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"ze_file WHERE ze01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE ze_pre FROM l_sql
             DECLARE ze_curs CURSOR FOR ze_pre
             LET l_cnt = 0
             FOREACH ze_curs INTO lr_ze.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.ze_file VALUES(lr_ze.*)
                ELSE
                   INSERT INTO custtemp:ze_file VALUES(lr_ze.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "3"
             IF l_gfd[li_i].gfd05 != "gao_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"gao_file WHERE gao01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gao_pre FROM l_sql
             DECLARE gao_curs CURSOR FOR gao_pre
             LET l_cnt = 0
             FOREACH gao_curs INTO lr_gao.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gao_file VALUES(lr_gao.*)
                ELSE
                   INSERT INTO custtemp:gao_file VALUES(lr_gao.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 有p_zmd資料, 確認資料夾是否存在
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/4gl"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/4fd"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/per"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/sdd"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/42m"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/42f"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/42r"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/sql"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED),"/sch"
             CALL pack_chk_and_add_dir(l_path)
             FOR li_k = 1 TO g_lang.getLength()
                 LET l_path = g_patch_path,"/topcust/config/4ad/",g_lang[li_k].gay01 CLIPPED,"/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED)
                 CALL pack_chk_and_add_dir(l_path)
             END FOR
             LET l_path = g_patch_path,"/topcust/config/4tm/",DOWNSHIFT(l_gfd[li_i].gfd06 CLIPPED)
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/topcust/bin"
             CALL pack_chk_and_add_dir(l_path)
             LET l_cmd = "cp ",l_cust CLIPPED,"/bin/cust_sys ",g_patch_path,"/topcust/bin"
             RUN l_cmd

          WHEN "4"
             IF l_gfd[li_i].gfd05 != "gae_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             # gae_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"gae_file",
                         " WHERE gae01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gae11='Y'"
             PREPARE gae_pre FROM l_sql
             DECLARE gae_curs CURSOR FOR gae_pre
             LET l_cnt = 0
             FOREACH gae_curs INTO lr_gae.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gae_file VALUES(lr_gae.*)
                ELSE
                   INSERT INTO custtemp:gae_file VALUES(lr_gae.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 自動抓取gav_file資料
             LET l_sql = "SELECT * FROM ",g_unload_db,"gav_file ",
                         " WHERE gav01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gav08='Y'"
             PREPARE gav_pre FROM l_sql
             DECLARE gav_curs CURSOR FOR gav_pre
             LET l_cnt = 0
             FOREACH gav_curs INTO lr_gav.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gav_file VALUES(lr_gav.*)
                ELSE
                   INSERT INTO custtemp:gav_file VALUES(lr_gav.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gav_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zav_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zav_file",
                         " WHERE zav01='1' AND zav02='",l_gfd[li_i].gfd06 CLIPPED,"' AND zav04='Y'"
             PREPARE zav_4_pre FROM l_sql
             DECLARE zav_4_curs CURSOR FOR zav_4_pre
             LET l_cnt = 0
             FOREACH zav_4_curs INTO lr_zav.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zav_file VALUES(lr_zav.*)
                ELSE
                   INSERT INTO custtemp:zav_file VALUES(lr_zav.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zav_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "5"
             IF l_gfd[li_i].gfd05 != "gab_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             # gab_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"gab_file",
                         " WHERE gab01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gab11='Y'"
             PREPARE gab_pre FROM l_sql
             DECLARE gab_curs CURSOR FOR gab_pre
             LET l_cnt = 0
             FOREACH gab_curs INTO lr_gab.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gab_file VALUES(lr_gab.*)
                ELSE
                   INSERT INTO custtemp:gab_file VALUES(lr_gab.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # gac_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"gac_file",
                         " WHERE gac01='",l_gfd[li_i].gfd06 CLIPPED,"' AND gac12='Y'"
             PREPARE gac_pre FROM l_sql
             DECLARE gac_curs CURSOR FOR gac_pre
             LET l_cnt = 0
             FOREACH gac_curs INTO lr_gac.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gac_file VALUES(lr_gac.*)
                ELSE
                   INSERT INTO custtemp:gac_file VALUES(lr_gac.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gac_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "6"
             IF l_gfd[li_i].gfd05 != "gat_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"gat_file WHERE gat01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gat_pre FROM l_sql
             DECLARE gat_curs CURSOR FOR gat_pre
             LET l_cnt = 0
             FOREACH gat_curs INTO lr_gat.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gat_file VALUES(lr_gat.*)
                ELSE
                   INSERT INTO custtemp:gat_file VALUES(lr_gat.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 自動抓取新增的table name下的所有在gaq_file內的field
             IF g_db_type = "ORA" THEN
                LET l_sql = "SELECT LOWER(column_name) FROM user_tab_columns",
                            " WHERE LOWER(table_name) = '",l_gfd[li_i].gfd06 CLIPPED,"'"
             ELSE
                LET l_sql = "SELECT b.colname FROM systables a,syscolumns b",
                            " WHERE a.tabid = b.tabid AND a.tabname = '",l_gfd[li_i].gfd06 CLIPPED,"'"
             END IF
             PREPARE col_pre FROM l_sql
             DECLARE col_curs CURSOR FOR col_pre
             LET ls_where = ""
             FOREACH col_curs INTO ls_feld_name
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_where IS NULL THEN
                   LET ls_where = "gaq01 = '",ls_feld_name CLIPPED,"'"
                ELSE
                   LET ls_where = ls_where," OR gaq01 = '",ls_feld_name CLIPPED,"'"
                END IF
             END FOREACH

             LET l_sql = "SELECT * FROM ",g_unload_db,"gaq_file WHERE ",ls_where
             PREPARE gaq_6_pre FROM l_sql
             DECLARE gaq_6_curs CURSOR FOR gaq_6_pre
             LET l_cnt = 0
             FOREACH gaq_6_curs INTO lr_gaq.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gaq_file VALUES(lr_gaq.*)
                ELSE
                   INSERT INTO custtemp:gaq_file VALUES(lr_gaq.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 gaq_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "7"
             IF l_gfd[li_i].gfd05 != "gaq_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"gaq_file WHERE gaq01='",l_gfd[li_i].gfd06 CLIPPED,"'"
             PREPARE gaq_pre FROM l_sql
             DECLARE gaq_curs CURSOR FOR gaq_pre
             LET l_cnt = 0
             FOREACH gaq_curs INTO lr_gaq.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.gaq_file VALUES(lr_gaq.*)
                ELSE
                   INSERT INTO custtemp:gaq_file VALUES(lr_gaq.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "8"
             IF l_gfd[li_i].gfd05 != "zaa_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             # 報表頭 zaa_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zaa_file ",
                         " WHERE zaa01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zaa10='Y'"
             PREPARE zaa_pre FROM l_sql
             DECLARE zaa_curs CURSOR FOR zaa_pre
             LET l_cnt = 0
             FOREACH zaa_curs INTO lr_zaa.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zaa_file VALUES(lr_zaa.*)
                ELSE
                   INSERT INTO custtemp:zaa_file VALUES(lr_zaa.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # 報表備註 zab_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zab_file",
                         " WHERE zab01 = (SELECT UNIQUE zaa08 FROM zaa_file ",
                         " WHERE zaa01 = '",l_gfd[li_i].gfd06 CLIPPED,"'",
                         "   AND (zaa14 = 'H' OR zaa14 = 'J'))"
             PREPARE zab_pre FROM l_sql
             DECLARE zab_curs CURSOR FOR zab_pre
             LET l_cnt = 0
             FOREACH zab_curs INTO lr_zab.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zab_file VALUES(lr_zab.*)
                ELSE
                   INSERT INTO custtemp:zab_file VALUES(lr_zab.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zab_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "9"
             IF l_gfd[li_i].gfd05 != "zai_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"zai_file ",
                         " WHERE zai01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zai05='Y'"
             PREPARE zai_pre FROM l_sql
             DECLARE zai_curs CURSOR FOR zai_pre
             LET l_cnt = 0
             FOREACH zai_curs INTO lr_zai.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zai_file VALUES(lr_zai.*)
                ELSE
                   INSERT INTO custtemp:zai_file VALUES(lr_zai.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zaj_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zaj_file ",
                         " WHERE zaj01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zaj07='Y'"
             PREPARE zaj_pre FROM l_sql
             DECLARE zaj_curs CURSOR FOR zaj_pre
             LET l_cnt = 0
             FOREACH zaj_curs INTO lr_zaj.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zaj_file VALUES(lr_zaj.*)
                ELSE
                   INSERT INTO custtemp:zaj_file VALUES(lr_zaj.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zaj_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zak_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zak_file ",
                         " WHERE zak01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zak07='Y'"
             PREPARE zak_pre FROM l_sql
             DECLARE zak_curs CURSOR FOR zak_pre
             LET l_cnt = 0
             FOREACH zak_curs INTO lr_zak.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zak_file VALUES(lr_zak.*)
                ELSE
                   INSERT INTO custtemp:zak_file VALUES(lr_zak.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zak_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zal_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zal_file ",
                         " WHERE zal01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zal07='Y'"
             PREPARE zal_pre FROM l_sql
             DECLARE zal_curs CURSOR FOR zal_pre
             LET l_cnt = 0
             FOREACH zal_curs INTO lr_zal.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zal_file VALUES(lr_zal.*)
                ELSE
                   INSERT INTO custtemp:zal_file VALUES(lr_zal.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zal_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zlm_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zam_file ",
                         " WHERE zam01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zam09='Y'"
             PREPARE zam_pre FROM l_sql
             DECLARE zam_curs CURSOR FOR zam_pre
             LET l_cnt = 0
             FOREACH zam_curs INTO lr_zam.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zam_file VALUES(lr_zam.*)
                ELSE
                   INSERT INTO custtemp:zam_file VALUES(lr_zam.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zam_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zan_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zan_file ",
                         " WHERE zan01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zan08='Y'"
             PREPARE zan_pre FROM l_sql
             DECLARE zan_curs CURSOR FOR zan_pre
             LET l_cnt = 0
             FOREACH zan_curs INTO lr_zan.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zan_file VALUES(lr_zan.*)
                ELSE
                   INSERT INTO custtemp:zan_file VALUES(lr_zan.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zan_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zao_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zao_file ",
                         " WHERE zao01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zao05='Y'"
             PREPARE zao_pre FROM l_sql
             DECLARE zao_curs CURSOR FOR zao_pre
             LET l_cnt = 0
             FOREACH zao_curs INTO lr_zao.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zao_file VALUES(lr_zao.*)
                ELSE
                   INSERT INTO custtemp:zao_file VALUES(lr_zao.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zao_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zap_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zap_file ",
                         " WHERE zap01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zap07='Y'"
             PREPARE zap_pre FROM l_sql
             DECLARE zap_curs CURSOR FOR zap_pre
             LET l_cnt = 0
             FOREACH zap_curs INTO lr_zap.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zap_file VALUES(lr_zap.*)
                ELSE
                   INSERT INTO custtemp:zap_file VALUES(lr_zap.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zap_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zaq_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zaq_file ",
                         " WHERE zaq01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zaq05='Y'"
             PREPARE zaq_pre FROM l_sql
             DECLARE zaq_curs CURSOR FOR zaq_pre
             LET l_cnt = 0
             FOREACH zaq_curs INTO lr_zaq.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zaq_file VALUES(lr_zaq.*)
                ELSE
                   INSERT INTO custtemp:zaq_file VALUES(lr_zaq.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zap_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zar_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zar_file ",
                         " WHERE zar01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zar05='Y'"
             PREPARE zar_pre FROM l_sql
             DECLARE zar_curs CURSOR FOR zar_pre
             LET l_cnt = 0
             FOREACH zar_curs INTO lr_zar.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zar_file VALUES(lr_zar.*)
                ELSE
                   INSERT INTO custtemp:zar_file VALUES(lr_zar.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zar_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zas_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zas_file ",
                         " WHERE zas01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zas11='Y'"
             PREPARE zas_pre FROM l_sql
             DECLARE zas_curs CURSOR FOR zas_pre
             LET l_cnt = 0
             FOREACH zas_curs INTO lr_zas.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zas_file VALUES(lr_zas.*)
                ELSE
                   INSERT INTO custtemp:zas_file VALUES(lr_zas.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zas_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zat_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zat_file ",
                         " WHERE zat01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zat10='Y'"
             PREPARE zat_pre FROM l_sql
             DECLARE zat_curs CURSOR FOR zat_pre
             LET l_cnt = 0
             FOREACH zat_curs INTO lr_zat.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zat_file VALUES(lr_zat.*)
                ELSE
                   INSERT INTO custtemp:zat_file VALUES(lr_zat.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zat_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zau_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zau_file ",
                         " WHERE zau01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zau04='Y'"
             PREPARE zau_pre FROM l_sql
             DECLARE zau_curs CURSOR FOR zau_pre
             LET l_cnt = 0
             FOREACH zau_curs INTO lr_zau.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zau_file VALUES(lr_zau.*)
                ELSE
                   INSERT INTO custtemp:zau_file VALUES(lr_zau.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zau_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zav_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zav_file ",
                         " WHERE zav01='2' AND zav02='",l_gfd[li_i].gfd06 CLIPPED,"' AND zav04='Y'"
             PREPARE zav_pre FROM l_sql
             DECLARE zav_curs CURSOR FOR zav_pre
             LET l_cnt = 0
             FOREACH zav_curs INTO lr_zav.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zav_file VALUES(lr_zav.*)
                ELSE
                   INSERT INTO custtemp:zav_file VALUES(lr_zav.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zav_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

             # zay_file
             LET l_sql = "SELECT * FROM ",g_unload_db,"zay_file ",
                         " WHERE zay01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zay03='Y'"
             PREPARE zay_pre FROM l_sql
             DECLARE zay_curs CURSOR FOR zay_pre
             LET l_cnt = 0
             FOREACH zay_curs INTO lr_zay.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zay_file VALUES(lr_zay.*)
                ELSE
                   INSERT INTO custtemp:zay_file VALUES(lr_zay.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 zay_file key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

          WHEN "A"
             IF l_gfd[li_i].gfd05 != "zaw_file" THEN
                DISPLAY p_gfb01,"  ",l_gfd[li_i].gfd04,"與",l_gfd[li_i].gfd05,"不符"
                CONTINUE FOR
             END IF

             LET l_sql = "SELECT * FROM ",g_unload_db,"zaw_file ",
                         " WHERE zaw01='",l_gfd[li_i].gfd06 CLIPPED,"' AND zaw03='Y'"
             PREPARE zaw_pre FROM l_sql
             DECLARE zaw_curs CURSOR FOR zaw_pre
             LET l_cnt = 0
             FOREACH zaw_curs INTO lr_zaw.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF g_db_type = "ORA" THEN
                   INSERT INTO custtemp.zaw_file VALUES(lr_zaw.*)
                ELSE
                   INSERT INTO custtemp:zaw_file VALUES(lr_zaw.*)
                END IF
                IF NOT SQLCA.sqlcode THEN
                   LET l_cnt = l_cnt + 1
                END IF
             END FOREACH
             DISPLAY "由資料清單 ",l_gfd[li_i].gfd05 CLIPPED," key值 : '",l_gfd[li_i].gfd06 CLIPPED,"' 抓到 ",l_cnt,"筆資料"

       END CASE
   END FOR
END FUNCTION

# 若選擇打包共用資料，就抓gab_file、gac_file、ze_file資料
FUNCTION p_develop_pack_common_data()
   DEFINE   l_sql   STRING
   DEFINE   l_cnt   INTEGER
   DEFINE   lr_ze   DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_gab  DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac  DYNAMIC ARRAY OF RECORD LIKE gac_file.*


   DISPLAY "打包共用資料中，會花費一段長久的時間"
   # ze_file中為TSD開頭的資料抓取
   DATABASE ds
   LET l_sql = "SELECT * FROM ze_file WHERE ze01 MATCHES 'TSD*'"
   PREPARE ze_c_pre FROM l_sql
   DECLARE ze_c_curs CURSOR FOR ze_c_pre
   LET l_cnt = 1
   CALL lr_ze.clear()
   FOREACH ze_c_curs INTO lr_ze[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_ze.deleteElement(l_cnt)
   IF lr_ze.getLength() <= 0 THEN
      DISPLAY "沒有抓取到共用資料ze_file(TSD*)"
   ELSE
      DISPLAY "共用資料ze_file(TSD*)抓取到",lr_ze.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_ze.getLength()
      INSERT INTO ze_file VALUES(lr_ze[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_ze.getLength(),"筆資料到custtemp.ze_file "
   CLOSE DATABASE

   # gab_file,gac_file中客製碼為Y的共用資料抓取
   # 動態開窗查詢單頭檔
   DATABASE ds
   LET l_sql = "SELECT * FROM gab_file WHERE gab11 = 'Y'"
   PREPARE gab_c_pre FROM l_sql
   DECLARE gab_c_curs CURSOR FOR gab_c_pre
   LET l_cnt = 1
   CALL lr_gab.clear()
   FOREACH gab_c_curs INTO lr_gab[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gab.deleteElement(l_cnt)
   IF lr_gab.getLength() <= 0 THEN
      DISPLAY "沒有抓取到共用資料gab_file(gab11='Y')"
   ELSE
      DISPLAY "共用資料gab_file(gab11='Y')抓取到",lr_gab.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gab.getLength()
      INSERT INTO gab_file VALUES(lr_gab[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_gab.getLength(),"筆資料到custtemp.gab_file "
   CLOSE DATABASE

   # 動態開窗查詢單身檔
   DATABASE ds
   LET l_sql = "SELECT * FROM gac_file WHERE gac12 = 'Y'"
   PREPARE gac_c_pre FROM l_sql
   DECLARE gac_c_curs CURSOR FOR gac_c_pre
   LET l_cnt = 1
   CALL lr_gac.clear()
   FOREACH gac_c_curs INTO lr_gac[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gac.deleteElement(l_cnt)
   IF lr_gac.getLength() <= 0 THEN
      DISPLAY "沒有抓取到共用資料gac_file(gac12='Y')"
   ELSE
      DISPLAY "共用資料gac_file(gac12='Y')抓取到",lr_gac.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gac.getLength()
      INSERT INTO gac_file VALUES(lr_gac[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_gac.getLength(),"筆資料到custtemp.gac_file "
   CLOSE DATABASE
END FUNCTION

# 打包此次單號群的gfb_file、gfc_file、gfd_file資料
FUNCTION p_develop_pack_devdata(p_gfb01)
   DEFINE   p_gfb01     LIKE gfb_file.gfb01
   DEFINE   l_sql       STRING
   DEFINE   l_cnt       SMALLINT
   DEFINE   li_i        SMALLINT
   DEFINE   lr_gfb      DYNAMIC ARRAY OF RECORD LIKE gfb_file.*
   DEFINE   lr_gfc      DYNAMIC ARRAY OF RECORD LIKE gfc_file.*
   DEFINE   lr_gfd      DYNAMIC ARRAY OF RECORD LIKE gfd_file.*


   # gfb_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gfb_file ",
               " WHERE gfb01 = '",p_gfb01 CLIPPED,"'"
   PREPARE gfb_pre FROM l_sql
   DECLARE gfb_curs CURSOR FOR gfb_pre
   LET l_cnt = 1
   CALL lr_gfb.clear()
   FOREACH gfb_curs INTO lr_gfb[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gfb.deleteElement(l_cnt)
   IF lr_gfb.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gfb_file的資料"
   ELSE
      DISPLAY "gfb_file抓取到",lr_gfb.getLength(),"筆資料"
   END IF

   LET li_i = 0
   FOR l_cnt = 1 TO lr_gfb.getLength()
       IF g_db_type = "ORA" THEN
          INSERT INTO custtemp.gfb_file VALUES(lr_gfb[l_cnt].*)
       ELSE
          INSERT INTO custtemp:gfb_file VALUES(lr_gfb[l_cnt].*)
       END IF
       IF NOT SQLCA.sqlcode THEN
          LET li_i = li_i + 1
       END IF
   END FOR
   DISPLAY "匯入 ",li_i,"筆資料到custtemp.gfb_file "

   # gfc_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gfc_file ",
               " WHERE gfc01 = '",p_gfb01 CLIPPED,"'"
   PREPARE gfc_all_pre FROM l_sql
   DECLARE gfc_all_curs CURSOR FOR gfc_all_pre
   LET l_cnt = 1
   CALL lr_gfc.clear()
   FOREACH gfc_all_curs INTO lr_gfc[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gfc.deleteElement(l_cnt)
   IF lr_gfc.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gfc_file的資料"
   ELSE
      DISPLAY "gfc_file抓取到",lr_gfc.getLength(),"筆資料"
   END IF

   LET li_i = 0
   FOR l_cnt = 1 TO lr_gfc.getLength()
       IF g_db_type = "ORA" THEN
          INSERT INTO custtemp.gfc_file VALUES(lr_gfc[l_cnt].*)
       ELSE
          INSERT INTO custtemp:gfc_file VALUES(lr_gfc[l_cnt].*)
       END IF
       IF NOT SQLCA.sqlcode THEN
          LET li_i = li_i + 1
       END IF
   END FOR
   DISPLAY "匯入 ",li_i,"筆資料到custtemp.gfc_file "

   # gfd_file
   LET l_sql = "SELECT * FROM ",g_unload_db,"gfd_file ",
               " WHERE gfd01 = '",p_gfb01 CLIPPED,"'"
   PREPARE gfd_all_pre FROM l_sql
   DECLARE gfd_all_curs CURSOR FOR gfd_all_pre
   LET l_cnt = 1
   CALL lr_gfd.clear()
   FOREACH gfd_all_curs INTO lr_gfd[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gfd.deleteElement(l_cnt)
   IF lr_gfd.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gfd_file的資料"
   ELSE
      DISPLAY "gfd_file抓取到",lr_gfd.getLength(),"筆資料"
   END IF

   LET li_i = 0
   FOR l_cnt = 1 TO lr_gfd.getLength()
       IF g_db_type = "ORA" THEN
          INSERT INTO custtemp.gfd_file VALUES(lr_gfd[l_cnt].*)
       ELSE
          INSERT INTO custtemp:gfd_file VALUES(lr_gfd[l_cnt].*)
       END IF
       IF NOT SQLCA.sqlcode THEN
          LET li_i = li_i + 1
       END IF
   END FOR
   DISPLAY "匯入 ",li_i,"筆資料到custtemp.gfd_file "
END FUNCTION

# 確保custtemp存在
FUNCTION pack_create_custtemp()
   DEFINE l_cmd STRING

   IF g_db_type ="ORA" THEN
      LET l_cmd = "sqlplus system/manager@`echo $ORACLE_SID` <<%%\n",
                  "create user custtemp identified by custtemp\n",
                  "default tablespace dbs1 temporary tablespace temp;\n",
                  "grant create session,create table to custtemp;\n",
                  "grant resource to custtemp;\n",
                  "grant create synonym to custtemp;\n%%\n"
      RUN l_cmd
      LET l_cmd = 'sqlplus "/as sysdba" <<%%\n',
                  'grant select on sys.v_\\$session to custtemp;\n%%\n'
      RUN l_cmd
   #No:FUN-8B0037 --mark start--
#  ELSE
#     LET l_cmd = "echo 'create database custtemp in dbs1 with log' | dbaccess >/dev/null 2>&1 "
#     RUN l_cmd
   #No:FUN-8B0037 ---mark end---
   END IF
END FUNCTION

# pack前先將custtemp資料庫內資料清空
FUNCTION pack_delete_tempdb_data()

   CALL pack_create_custtemp()

   IF g_db_type = "ORA" THEN
      DELETE FROM custtemp.ze_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp ze_file error!"
      END IF
      DELETE FROM custtemp.zz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zz_file error!"
      END IF
      DELETE FROM custtemp.gap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gap_file error!"
      END IF
      DELETE FROM custtemp.gbd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gbd_file error!"
      END IF
      DELETE FROM custtemp.gae_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gae_file error!"
      END IF
      DELETE FROM custtemp.gak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gak_file error!"
      END IF
      DELETE FROM custtemp.gal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gal_file error!"
      END IF
      DELETE FROM custtemp.gaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gaq_file error!"
      END IF
      DELETE FROM custtemp.gab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gab_file error!"
      END IF
      DELETE FROM custtemp.gac_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gac_file error!"
      END IF
      DELETE FROM custtemp.gav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gav_file error!"
      END IF
      DELETE FROM custtemp.gat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gat_file error!"
      END IF
      DELETE FROM custtemp.gaz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gaz_file error!"
      END IF
      DELETE FROM custtemp.gao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gao_file error!"
      END IF
      DELETE FROM custtemp.wsa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp wsa_file error!"
      END IF
      DELETE FROM custtemp.wsb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp wsb_file error!"
      END IF
      DELETE FROM custtemp.zaa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaa_file error!"
      END IF
      DELETE FROM custtemp.zab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zab_file error!"
      END IF
      DELETE FROM custtemp.zai_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zai_file error!"
      END IF
      DELETE FROM custtemp.zaj_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaj_file error!"
      END IF
      DELETE FROM custtemp.zak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zak_file error!"
      END IF
      DELETE FROM custtemp.zal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zal_file error!"
      END IF
      DELETE FROM custtemp.zam_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zam_file error!"
      END IF
      DELETE FROM custtemp.zan_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zan_file error!"
      END IF
      DELETE FROM custtemp.zao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zao_file error!"
      END IF
      DELETE FROM custtemp.zap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zap_file error!"
      END IF
      DELETE FROM custtemp.zaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaq_file error!"
      END IF
      DELETE FROM custtemp.zar_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zar_file error!"
      END IF
      DELETE FROM custtemp.zas_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zas_file error!"
      END IF
      DELETE FROM custtemp.zat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zat_file error!"
      END IF
      DELETE FROM custtemp.zau_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zau_file error!"
      END IF
      DELETE FROM custtemp.zav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zav_file error!"
      END IF
      DELETE FROM custtemp.zay_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zay_file error!"
      END IF
      DELETE FROM custtemp.zaw_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaw_file error!"
      END IF
      DELETE FROM custtemp.gfb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfb_file error!"
      END IF
      DELETE FROM custtemp.gfc_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfc_file error!"
      END IF
      DELETE FROM custtemp.gfd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfd_file error!"
      END IF
      #No:FUN-8B0037 --start--
      DELETE FROM custtemp.gca_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gca_file error!"
      END IF
      DELETE FROM custtemp.gcb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gcb_file error!"
      END IF
      #No:FUN-8B0037 ---end---
   ELSE
      DELETE FROM custtemp:ze_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp ze_file error!"
      END IF
      DELETE FROM custtemp:zz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zz_file error!"
      END IF
      DELETE FROM custtemp:gap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gap_file error!"
      END IF
      DELETE FROM custtemp:gbd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gbd_file error!"
      END IF
      DELETE FROM custtemp:gae_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gae_file error!"
      END IF
      DELETE FROM custtemp:gak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gak_file error!"
      END IF
      DELETE FROM custtemp:gal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gal_file error!"
      END IF
      DELETE FROM custtemp:gaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gaq_file error!"
      END IF
      DELETE FROM custtemp:gab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gab_file error!"
      END IF
      DELETE FROM custtemp:gac_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gac_file error!"
      END IF
      DELETE FROM custtemp:gav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gav_file error!"
      END IF
      DELETE FROM custtemp:gat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gat_file error!"
      END IF
      DELETE FROM custtemp:gaz_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gaz_file error!"
      END IF
      DELETE FROM custtemp:gao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gao_file error!"
      END IF
      DELETE FROM custtemp:wsa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp wsa_file error!"
      END IF
      DELETE FROM custtemp:wsb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp wsb_file error!"
      END IF
      DELETE FROM custtemp:zaa_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaa_file error!"
      END IF
      DELETE FROM custtemp:zab_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zab_file error!"
      END IF
      DELETE FROM custtemp:zai_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zai_file error!"
      END IF
      DELETE FROM custtemp:zaj_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaj_file error!"
      END IF
      DELETE FROM custtemp:zak_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zak_file error!"
      END IF
      DELETE FROM custtemp:zal_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zal_file error!"
      END IF
      DELETE FROM custtemp:zam_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zam_file error!"
      END IF
      DELETE FROM custtemp:zan_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zan_file error!"
      END IF
      DELETE FROM custtemp:zao_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zao_file error!"
      END IF
      DELETE FROM custtemp:zap_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zap_file error!"
      END IF
      DELETE FROM custtemp:zaq_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaq_file error!"
      END IF
      DELETE FROM custtemp:zar_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zar_file error!"
      END IF
      DELETE FROM custtemp:zas_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zas_file error!"
      END IF
      DELETE FROM custtemp:zat_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zat_file error!"
      END IF
      DELETE FROM custtemp:zau_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zau_file error!"
      END IF
      DELETE FROM custtemp:zav_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zav_file error!"
      END IF
      DELETE FROM custtemp:zay_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zay_file error!"
      END IF
      DELETE FROM custtemp:zaw_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaw_file error!"
      END IF
      DELETE FROM custtemp:gfb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfb_file error!"
      END IF
      DELETE FROM custtemp:gfc_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfc_file error!"
      END IF
      DELETE FROM custtemp:gfd_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gfd_file error!"
      END IF
      #No:FUN-8B0037 --start--
      DELETE FROM custtemp:gca_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gca_file error!"
      END IF
      DELETE FROM custtemp:gcb_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gcb_file error!"
      END IF
      #No:FUN-8B0037 ---end---
   END IF
END FUNCTION

# 製作執行的shell
FUNCTION pack_mk_patch_shell(p_patch_name)
   DEFINE   p_patch_name  STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_str        STRING
   DEFINE   l_cmd         STRING


   LET lc_channel = base.Channel.create()
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm ",g_tempdir,"/",p_patch_name,"_tab.sh 2>/dev/null"
      RUN l_cmd
      LET ls_str = g_tempdir,"/",p_patch_name,"_tab.sh"
   ELSE
      LET l_cmd = "rm ",g_tempdir,"/",p_patch_name,".sh 2>/dev/null"
      RUN l_cmd
      LET ls_str = g_tempdir,"/",p_patch_name,".sh"
   END IF
   CALL lc_channel.openFile(ls_str,"w")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("#!/bin/ksh")
   IF g_pack_zs = "Y" THEN
      LET ls_str = "tar xvf ",p_patch_name,"_tab.tar"
   ELSE
      LET ls_str = "tar xvf ",p_patch_name,".tar"
   END IF
   CALL lc_channel.write(ls_str)
   IF g_pack_zs='Y' THEN
      LET ls_str = "cd ",p_patch_name,"_tab"
   ELSE
      LET ls_str = "cd ",p_patch_name
   END IF
   CALL lc_channel.write(ls_str)
   LET ls_str = "patch_cust_c.sh ",p_patch_name
   CALL lc_channel.write(ls_str)
   LET ls_str = "cd ../"
   CALL lc_channel.write(ls_str)
   IF g_pack_zs='Y' THEN
      LET ls_str = "rm -rf ",p_patch_name,"_tab"
   ELSE
      LET ls_str = "rm -rf ",p_patch_name
   END IF
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   IF g_pack_zs = "Y" THEN
      LET l_cmd = "chmod 777 ",g_tempdir,"/",p_patch_name,"_tab.sh"
   ELSE
      LET l_cmd = "chmod 777 ",g_tempdir,"/",p_patch_name,".sh"
   END IF
   RUN l_cmd
      
END FUNCTION

FUNCTION pack_gen_cmdfile(p_path)
   DEFINE readfile_channel   base.channel,
          l_k                SMALLINT,
          l_i                SMALLINT,
          l_start            SMALLINT,
          l_stop             SMALLINT,
          p_path             STRING,
          l_sql              STRING,
          l_path             STRING,
          g_gfb01            STRING,
          l_zs01             LIKE zs_file.zs01,
          l_zs02             LIKE zs_file.zs02,
          l_zs03             LIKE zs_file.zs03,
          l_command          CHAR(100),
          l_result           SMALLINT,
          l_fn_start         SMALLINT

   LET readfile_channel=base.channel.create()
   CALL readfile_channel.setdelimiter("")
   LET l_path=p_path CLIPPED,"/patch_cust_command"
   CALL readfile_channel.openfile(l_path CLIPPED, "w" )
   FOR l_k=1 TO g_gfb.getLength()
       LET g_gfb01=g_gfb[l_k].gfb01 CLIPPED
       LET l_sql="SELECT zs01,zs02,zs03,zs06 FROM zs_file ",
                 " WHERE zs08='",g_gfb[l_k].gfb01 CLIPPED,"' AND zs11!='Y'",
                 " ORDER BY zs01,zs03"
display l_sql
       PREPARE pack_gencmd_pre FROM l_sql
       DECLARE pack_gencmd CURSOR FOR pack_gencmd_pre
       FOREACH pack_gencmd INTO l_zs01,l_zs02,l_zs03,l_command
          IF SQLCA.SQLCODE THEN
             DISPLAY "gen command error!!"
             RETURN
          END IF
          CALL readfile_channel.write(l_command CLIPPED)
display l_command CLIPPED
          IF l_command[1,12]="create table" THEN
             FOR l_i=1 TO 100
                 CASE l_command[l_i,l_i]
                    WHEN '{' 
                         LET l_start=l_i+1
                    WHEN '}' 
                         LET l_stop=l_i-1
                    WHEN '/'
                         LET l_fn_start=l_i+1
                 END CASE
             END FOR
             LET l_sql="cp ",l_command[l_start,l_stop]," ",p_path,
                       "/",l_command[l_fn_start,l_stop]
display "l_sql:",l_sql
                RUN l_sql
          END IF
          UPDATE zs_file SET zs11='Y'
           WHERE zs01=l_zs01 AND zs02=l_zs02 AND zs03=l_zs03
       END FOREACH
   END FOR
   CALL readfile_channel.close()
   LET l_sql="uniq ",p_path CLIPPED,"/patch_cust_command ",p_path CLIPPED,"/patch_cust_command1"
   RUN l_sql RETURNING l_result
   IF l_result=0 THEN
      LET l_sql="mv ",p_path CLIPPED,"/patch_cust_command1 ",p_path CLIPPED,"/patch_cust_command"
      RUN l_sql 
   END IF
END FUNCTION

#No:FUN-840067 --start-- 打包相關文件
FUNCTION p_develop_pack_related_document()
   DEFINE   ls_where      STRING
   DEFINE   ls_sql        STRING
   DEFINE   lr_gca        RECORD LIKE gca_file.*
   DEFINE   lr_gcb        RECORD LIKE gcb_file.*
   DEFINE   ls_filename   STRING
   DEFINE   ls_ext        STRING
   DEFINE   li_cnt        LIKE type_file.num5

   FOR li_cnt = 1 TO g_gfb.getLength()
       IF ls_where IS NULL THEN
          LET ls_where = "gca01='gfb01=",g_gfb[li_cnt].gfb01,"'"
       ELSE
          LET ls_where = " OR gca01='gfb01=",g_gfb[li_cnt].gfb01,"'"
       END IF
   END FOR

   LET ls_sql = "SELECT * FROM ",g_unload_db,"gca_file WHERE ",ls_where
   LET ls_filename = g_patch_path,os.Path.separator(),"gca_file.txt"
   UNLOAD TO ls_filename ls_sql

   # gca_file, gcb_file
   LET ls_sql = "SELECT * FROM ",g_unload_db,"gca_file ",
                " WHERE ",ls_where
   PREPARE gfb_gca_pre FROM ls_sql
   DECLARE gfb_gca_curs CURSOR FOR gfb_gca_pre
   LET li_cnt = 0
   FOREACH gfb_gca_curs INTO lr_gca.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gca_file VALUES(lr_gca.*)
      ELSE
         INSERT INTO custtemp:gca_file VALUES(lr_gca.*)
      END IF
      IF NOT SQLCA.sqlcode THEN
         LET li_cnt = li_cnt + 1
      END IF
      #No:FUN-8B0037 --modify start--
      LOCATE lr_gcb.gcb09 IN MEMORY
      LET ls_sql = "SELECT * FROM ",g_unload_db,"gcb_file ",
                   " WHERE gcb01='",lr_gca.gca07,"' AND gcb02='",lr_gca.gca08,"'",
                   "   AND gcb03='",lr_gca.gca09,"' AND gcb04='",lr_gca.gca10,"'"
      PREPARE gfb_gcb_pre FROM ls_sql
      EXECUTE gfb_gcb_pre INTO lr_gcb.*
      IF g_db_type = "ORA" THEN
         INSERT INTO custtemp.gcb_file VALUES(lr_gcb.*)
      ELSE
         INSERT INTO custtemp:gcb_file VALUES(lr_gcb.*)
      END IF
      LET ls_ext = lr_gcb.gcb07
      WHILE ls_ext.getIndexOf(".",1)
         LET ls_ext = ls_ext.subString(ls_ext.getIndexOf(".",1)+1,ls_ext.getLength())
      END WHILE
      LET ls_filename = g_patch_path,"/",lr_gcb.gcb01 CLIPPED,".",ls_ext
      FREE lr_gcb.gcb09

      LOCATE lr_gcb.gcb09 IN FILE ls_filename
      SELECT gcb09 INTO lr_gcb.gcb09 FROM gcb_file 
       WHERE gcb01 = lr_gca.gca07 AND gcb02 = lr_gca.gca08
         AND gcb03 = lr_gca.gca09 AND gcb04 = lr_gca.gca10
      #No:FUN-8B0037 ---modify end---
   END FOREACH
END FUNCTION
#No:FUN-840067 ---end---
