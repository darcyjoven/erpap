##################################################
# Description  	: Patch 客製打包
# Date & Author : 2005/01/10 by saki
# Parameter   	: 
# Return   	: 
# Memo        	: 打包patch程式 patch_cust.sh, patch_load_custdata.42m
# Modify   	: 2006/12/04 #FUN-6B0082 by alexstar
# Modify        : 2007/01/29 #FUN-710057 by lifeng
# Modify        : 2007/03/16 #TQC-730063 by saki
# Modify        : 2007/05/23 #CHI-750028 by saki 5X 增加p_query資料同步, 42m->42r, 4fd, sdd
# Modify        : 2007/06/15 #TQC-760113 by saki 打包不到檔案修改記錄則不產生patch檔
# Modify        : 2007/10/29 #TQC-7A0101 by saki 增加4fd與資料同步的zaw_file
# Modify        : 2007/11/02 #TQC-7B0017 by saki 開其他DB前要先CLOSE DATABASE
# Modify        : 2007/12/14 #FUN-7C0044 by saki 增加資料同步zay_file
# Modify        : 2008/02/19 #TQC-820013 by alexstar 動態抓取temporary tablespace名稱
# Modify        : 2008/09/01 #TQC-890002 by saki 若p_link有輸入第二個key值，則只抓指定的資料
# Modify        : 2008/10/27 #MOD-8A0236 by alexstar patch_cust_command的欄位長度不足 100=>180
##################################################
DATABASE ds

DEFINE   g_prog_path   STRING
DEFINE   g_wc          STRING
DEFINE   g_com         CHAR(1)
DEFINE   g_date        CHAR(12)
DEFINE   g_pack_zs     CHAR(1)
DEFINE   gc_channel    base.Channel
DEFINE   g_db_type     CHAR(3)
DEFINE   l_gzl         DYNAMIC ARRAY OF RECORD
            gzl00      LIKE gzl_file.gzl00,
            gzl01      LIKE gzl_file.gzl01,
            gzl17      LIKE gzl_file.gzl17,
            gzl02      LIKE gzl_file.gzl02,
            gzl05      LIKE gzl_file.gzl05,
            gzl16      LIKE gzl_file.gzl16
                       END RECORD
DEFINE   g_patch_path  STRING
DEFINE   g_lang        DYNAMIC ARRAY OF RECORD
            gay01      LIKE gay_file.gay01
                       END RECORD
DEFINE   g_tempdir     STRING

MAIN
   DEFINE   l_str          STRING
   DEFINE   l_ds4gl_path   STRING

   WHENEVER ERROR CONTINUE

   LET g_prog_path = ARG_VAL(1)         # 打包路徑
   LET g_wc = ARG_VAL(2)                # 打包條件
   LET g_com = ARG_VAL(3)               # 是否打包共用資料
   LET g_date = ARG_VAL(4)              # 打包時間(檔名)
   LET g_pack_zs = ARG_VAL(5)           # 打包zs紀錄

   LET g_tempdir = FGL_GETENV('TEMPDIR')
   #No:CHI-750028 --start--
   LET g_db_type = DB_GET_DATABASE_TYPE()
   LET l_ds4gl_path = FGL_GETENV('DS4GL')
   IF g_db_type = "ORA" THEN
      RUN 'custtemp.sh'
   ELSE
      #No:FUN-7C0044 --start--
      RUN 'custtemp_ifx.sh'
#     RUN "echo 'drop database custtemp'|dbaccess"
#     LET l_str="cd ",l_ds4gl_path,"/bin/;dbimport custtemp -l -d dbs1"
#     RUN l_str
      #No:FUN-7C0044 ---end---
   END IF
   #No:CHI-750028 ---end---

   IF g_prog_path IS NULL THEN
      DISPLAY '請輸入打包的程式路徑 ex. /u3/genero/topcust'
      RETURN
   END IF

   IF (g_wc IS NOT NULL) THEN
      CALL p_gzl_pack()
   END IF
END MAIN

FUNCTION p_gzl_pack()
   DEFINE   l_sql          STRING,
            l_sql2         STRING
   DEFINE   l_final_top    STRING,
            l_ds4gl_path   STRING
   DEFINE   l_cmd          STRING
   DEFINE   l_cnt          INTEGER
   DEFINE   li_i           SMALLINT
   DEFINE   li_j           INTEGER
   DEFINE   li_k           INTEGER
   DEFINE   l_str          STRING
   DEFINE   l_result       STRING
   DEFINE   l_gzln         DYNAMIC ARRAY OF RECORD
               gzln03      LIKE gzln_file.gzln03,
               gzln04      LIKE gzln_file.gzln04,
               gzln05      LIKE gzln_file.gzln05
                           END RECORD
   DEFINE   l_config       STRING
   DEFINE   l_path         STRING
   DEFINE   li_result      SMALLINT
   DEFINE   ls_pack_prog   STRING
   DEFINE   li_inx_s       SMALLINT
   DEFINE   li_sch_noexist SMALLINT    #No:TQC-760113


   LET g_db_type = DB_GET_DATABASE_TYPE()
   LET l_final_top = g_prog_path
   LET l_ds4gl_path = FGL_GETENV('DS4GL')

   # 預先刪除temp資料庫內的資料
   CALL pack_delete_tempdb_data()

   # 找出要打包的所有gzl_file資料
   CLOSE DATABASE                #No:TQC-7B0017
   DATABASE ds
   LET l_sql = "SELECT gzl00,gzl01,gzl17,gzl02,gzl05,gzl16 FROM gzl_file",
               " WHERE ",g_wc," AND gzl18 = '3'",
               " ORDER BY gzl00,gzl01,gzl17"
   DISPLAY 'l_sql=',l_sql
   PREPARE zl00_pre FROM l_sql
   DECLARE zl00_curs CURSOR  FOR zl00_pre

   LET l_cnt = 1
   FOREACH zl00_curs INTO l_gzl[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gzl.deleteElement(l_cnt)

   IF l_gzl.getLength() <= 0 THEN
      DISPLAY 'no patch produce...'
      RETURN
   END IF

   # 製造patch的temp目錄在$TEMPDIR下
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm -rf ",g_tempdir,"/patch_",g_date,"_tab"
      RUN l_cmd
      LET l_cmd = "mkdir ",g_tempdir,"/patch_",g_date,"_tab"
      RUN l_cmd RETURNING l_result
      IF l_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET g_patch_path = g_tempdir,"/patch_",g_date,"_tab"
      CALL pack_gen_cmdfile(g_patch_path)
   ELSE
      LET l_cmd = "rm -rf ",g_tempdir,"/patch_",g_date
      RUN l_cmd
      LET l_cmd = "mkdir ",g_tempdir,"/patch_",g_date
      RUN l_cmd RETURNING l_result
      IF l_result != '0' THEN
         DISPLAY "error while create temp directory"
      END IF
      LET g_patch_path = g_tempdir,"/patch_",g_date
   END IF


   IF (g_pack_zs != 'Y') OR (g_pack_zs IS NULL) THEN

      # 記錄包了哪些單號、內容
      LET gc_channel = base.Channel.create()
      LET l_cmd = g_patch_path,"/info.txt"
      CALL gc_channel.openFile(l_cmd,"w")
      CALL gc_channel.setDelimiter("")
      LET l_str = "Patch of Condition:",g_wc
      CALL gc_channel.write(l_str)
      LET l_str = ""
      CALL gc_channel.write(l_str)
      LET l_str = ""
      CALL gc_channel.write(l_str)

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
      LET l_cmd = "rm -rf ",g_patch_path,"/tiptop"
      RUN l_cmd
      LET l_cmd = "mkdir ",g_patch_path,"/tiptop"
      RUN l_cmd

      FOR li_i = 1 TO l_gzl.getLength()
         LET l_str = l_gzl[li_i].gzl00,"   Item : ",l_gzl[li_i].gzl01,"   Program Name : ",l_gzl[li_i].gzl05
         CALL gc_channel.write(l_str)
         LET l_str = "Confirm No : ",l_gzl[li_i].gzl02
         CALL gc_channel.write(l_str)
         LET l_str = "Bug Content :"
         CALL gc_channel.write(l_str)
         LET l_str = l_gzl[li_i].gzl16
         CALL gc_channel.write(l_str)
         LET l_str = ""
         CALL gc_channel.write(l_str)
         LET l_str = ""
         CALL gc_channel.write(l_str)

         CALL p_gzl_pack_gzldata(l_gzl[li_i].gzl00,l_gzl[li_i].gzl01,l_gzl[li_i].gzl17)

         CLOSE DATABASE       #No:TQC-7B0017
         DATABASE ds
         LET l_sql2 = "SELECT gzln03,gzln04,gzln05 FROM gzln_file",
                      " WHERE gzln00 = '",l_gzl[li_i].gzl00,"'",
                      "   AND gzln01 = '",l_gzl[li_i].gzl01,"'",
                      "   AND gzln07 = '",l_gzl[li_i].gzl17,"'",
                      " ORDER BY gzln03"
         PREPARE gzln_pre FROM l_sql2
         DECLARE gzln_curs CURSOR FOR gzln_pre

         CALL l_gzln.clear()
         LET l_cnt = 1
         FOREACH gzln_curs INTO l_gzln[l_cnt].*
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_gzln.deleteElement(l_cnt)

         FOR li_j = 1 TO l_gzln.getLength()
            CASE
               WHEN (l_gzln[li_j].gzln04 = "4gl")
                  LET ls_pack_prog = l_gzln[li_j].gzln05 CLIPPED
                  LET li_inx_s = ls_pack_prog.getIndexOf(".4gl",1)
                  LET ls_pack_prog = ls_pack_prog.subString(1,li_inx_s - 1)

                  LET l_path = g_patch_path,"/tiptop/",l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                              l_gzln[li_j].gzln05 CLIPPED," ",l_path
                  RUN l_cmd

                  # 打包4gl所屬4ad檔
                  FOR li_k = 1 TO g_lang.getLength()
                      LET l_path = g_patch_path,"/tiptop/",l_config CLIPPED,'/4ad/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gzln[li_j].gzln03 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,'/4ad/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gzln[li_j].gzln03 CLIPPED,'/',ls_pack_prog,".4ad ",l_path
                      RUN l_cmd
                  END FOR

                  # 打包4gl所屬4tm檔
                  LET l_path = g_patch_path,"/tiptop/",l_config CLIPPED,'/4tm/',
                               l_gzln[li_j].gzln03 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,'/4tm/',
                               l_gzln[li_j].gzln03 CLIPPED,'/',ls_pack_prog,".4tm ",l_path
                  RUN l_cmd

                  # 打包4gl相關gap_file,gbd_file資料
                  CALL p_gzl_pack_data_relate_4gl(l_gzln[li_j].gzln03,ls_pack_prog)

               #No:CHI-750028 --start--
               WHEN (l_gzln[li_j].gzln04 = "per") OR (l_gzln[li_j].gzln04 = "4fd")     #No:TQC-7A0101
                  LET ls_pack_prog = l_gzln[li_j].gzln05 CLIPPED
                  #No:TQC-7A0101 --start--
                  IF l_gzln[li_j].gzln04 = "per" THEN
                     LET li_inx_s = ls_pack_prog.getIndexOf(".per",1)
                  ELSE
                     LET li_inx_s = ls_pack_prog.getIndexOf(".4fd",1)
                  END IF
                  #No:TQC-7A0101 ---end---
                  LET ls_pack_prog = ls_pack_prog.subString(1,li_inx_s - 1)

                  # per
                  LET l_path = g_patch_path,"/tiptop/",l_gzln[li_j].gzln03 CLIPPED,'/per'   #No:TQC-7A0101
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_gzln[li_j].gzln03 CLIPPED,'/per/',    #No:TQC-7A0101
                              ls_pack_prog,".per ",l_path  #No:TQC-7A0101
                  RUN l_cmd
                  #4fd
                  LET l_path = g_patch_path,"/tiptop/",l_gzln[li_j].gzln03 CLIPPED,'/4fd'
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_gzln[li_j].gzln03 CLIPPED,'/4fd/',
                              ls_pack_prog,".4fd ",l_path
                  RUN l_cmd
                  #sdd
                  LET l_path = g_patch_path,"/tiptop/",l_gzln[li_j].gzln03 CLIPPED,'/sdd'
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_gzln[li_j].gzln03 CLIPPED,'/sdd/',
                              ls_pack_prog,".sdd ",l_path
                  RUN l_cmd
               #No:CHI-750028 ---end---
                  
               WHEN (l_gzln[li_j].gzln04 = "4ad")
                  FOR li_k = 1 TO g_lang.getLength()
                      LET l_path = g_patch_path,"/tiptop/",l_config CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gzln[li_j].gzln03 CLIPPED
                      CALL pack_chk_and_add_dir(l_path)
                      LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                                   g_lang[li_k].gay01 CLIPPED,'/',l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln05 CLIPPED," ",l_path
                      RUN l_cmd
                  END FOR
               WHEN (l_gzln[li_j].gzln04 = "4tm")
                  LET l_path = g_patch_path,"/tiptop/",l_config CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                               l_gzln[li_j].gzln03 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_config CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                               l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln05 CLIPPED," ",l_path
                  RUN l_cmd
               OTHERWISE
                  LET l_path = g_patch_path,"/tiptop/",l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED
                  CALL pack_chk_and_add_dir(l_path)
                  LET l_cmd = "cp ",l_final_top,"/",l_gzln[li_j].gzln03 CLIPPED,'/',l_gzln[li_j].gzln04 CLIPPED,'/',
                              l_gzln[li_j].gzln05 CLIPPED," ",l_path
                  RUN l_cmd
            END CASE
         END FOR

         CALL p_gzl_pack_data(l_gzl[li_i].gzl00,l_gzl[li_i].gzl01,l_gzl[li_i].gzl17)

      END FOR

      IF g_com = "Y" THEN
         CALL p_gzl_pack_common_data()
      END IF

      LET l_str = "==================",l_gzl.getLength()," data"
      CALL gc_channel.write(l_str)
      CALL gc_channel.close()

      # 依照資料庫打包資料
      IF g_db_type = "IFX" THEN
         LET l_cmd = "cd ",g_patch_path,";rm -rf custtemp.exp"   #No:FUN-7C0044
         RUN l_cmd
         LET l_cmd = "cd ",g_patch_path,";export DBDATE=Y4MD/;dbexport custtemp"  #No:FUN-7C0044
         RUN l_cmd
      ELSE
         LET l_cmd = "exp custtemp/custtemp@$ORACLE_SID tables=ze_file, zz_file, ", #FUN-6B0082
                     "gap_file, gbd_file, gao_file, gae_file, gak_file, gal_file, ",
                     "gaq_file, gab_file, gac_file, gav_file, gat_file, gaz_file, ",
                     "wsa_file, wsb_file, zaa_file, zab_file, zai_file, zaj_file, ",
                     "zak_file, zal_file, zam_file, zan_file, zao_file, zap_file, ",
                     "zaq_file, zar_file, zas_file, zat_file, zau_file, zav_file, ",
                     "zaw_file, zay_file, gzl_file, gzln_file, gsyc_file file=",g_patch_path,"/custtemp.dmp"   #No:TQC-7A0101  #No:FUN-7C0044
         RUN l_cmd
      END IF
   END IF 

   # Unpack 程式路徑
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",l_ds4gl_path,   #No:CHI-750028
#              ";fglcomp -M patch_cust"        #No.FUN-710057
               "/bin;fglcomp -M patch_cust"    #NO.FUN-710057
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.42r ",g_patch_path
   RUN l_cmd
#  LET l_cmd = "cd ",l_ds4gl_path,";fglform patch_cust"      #No.FUN-710057
   LET l_cmd = "cd ",l_ds4gl_path,"/bin;fglform patch_cust"  #No.FUN-710057
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.per ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.42f ",g_patch_path
   RUN l_cmd
   LET l_cmd = "FGLDIR=`echo $FGLDIR|cut -d . -f1`.dev; export FGLDIR;cd ",l_ds4gl_path,"/bin",   #No:CHI-750028
               ";fglcomp -M patch_load_custdata"
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_load_custdata.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_load_custdata.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_load_custdata.42r ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/patch_cust.sh ",g_patch_path
   RUN l_cmd

   # Schema 檔案路徑
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/execmd_cust.4gl ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/execmd_cust.42m ",g_patch_path
   RUN l_cmd
   LET l_cmd = "cp ",l_ds4gl_path,"/bin/execmd_cust.42r ",g_patch_path
   RUN l_cmd
   IF g_db_type="IFX" THEN
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
   ELSE
      RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
   END IF

   # 打包source檔,打包zs時不打包source
   IF (g_pack_zs != 'Y') OR (g_pack_zs IS NULL) THEN
      LET l_cmd = "cd ",g_patch_path,"/tiptop;tar cvf ",g_patch_path,"/patch_",g_date,"_source.tar *"
      RUN l_cmd
      LET l_cmd = "cd ",g_patch_path,";rm -rf tiptop"
      RUN l_cmd
   END IF

   # schema,data,source.tar,patch.42m,patch.sh打包
   IF g_pack_zs = "Y" THEN
      #No:TQC-760113 --start--
      LET l_cmd = "cd ",g_tempdir,"/patch_",g_date,"_tab;test -s patch_cust_command"
      RUN l_cmd RETURNING li_sch_noexist
      IF NOT li_sch_noexist THEN
         LET l_cmd = "cd ",g_tempdir,";tar cvf ",
                      g_tempdir,"/","patch_",g_date,"_tab.tar patch_",g_date,"_tab",
                      " 2>/dev/null"
         RUN l_cmd
      END IF
      #No:TQC-760113 ---end---
   ELSE
      LET l_cmd = "cd ",g_tempdir,";tar cvf ",
                   g_tempdir,"/","patch_",g_date,".tar patch_",g_date,
                   " 2>/dev/null"
      RUN l_cmd   #No:TQC-760113
   END IF

   # 放大tar檔的權限
   IF g_pack_zs = "Y" THEN
      IF NOT li_sch_noexist THEN
         LET l_cmd = "chmod 777 ",g_tempdir,"/","patch_",g_date,"_tab.tar 2>/dev/null"
      END IF
   ELSE
      LET l_cmd = "chmod 777 ",g_tempdir,"/","patch_",g_date,".tar 2>/dev/null"
   END IF
   RUN l_cmd

   # 將原本暫存的patch資料夾砍掉
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm -rf ",g_tempdir,"/patch_",g_date,"_tab"
   ELSE
      LET l_cmd = "rm -rf ",g_tempdir,"/patch_",g_date
   END IF
   RUN l_cmd

   # 確認tar檔有沒有產生，有產生就一併做shell檔案
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "test -s ",g_tempdir,"/","patch_",g_date,"_tab.tar"
   ELSE
      LET l_cmd = "test -s ",g_tempdir,"/","patch_",g_date,".tar"
   END IF
   RUN l_cmd RETURNING li_result

   IF NOT li_result THEN
      CALL pack_mk_patch_shell(g_date)
   END IF

END FUNCTION

# 由修改清單建立暫存patch/tiptop資料夾下的目錄
FUNCTION pack_chk_and_add_dir(p_path)
   DEFINE   p_path   STRING
   DEFINE   l_result SMALLINT
   DEFINE   l_cmd    STRING


   LET l_cmd = "test -s ",p_path
   RUN l_cmd RETURNING l_result
   IF l_result THEN
      LET l_cmd = "mkdir -p ",p_path
      RUN l_cmd
   END IF

END FUNCTION

# 由修改清單的4gl選項，自動抓取gap_file,gbd_file資料
FUNCTION p_gzl_pack_data_relate_4gl(ps_system,ps_filename)
   DEFINE   ps_system   STRING
   DEFINE   ps_filename LIKE gap_file.gap01
   DEFINE   l_sql       STRING
   DEFINE   l_cnt       INTEGER
   DEFINE   lr_gap      DYNAMIC ARRAY OF RECORD LIKE gap_file.*
   DEFINE   lr_gbd      DYNAMIC ARRAY OF RECORD LIKE gbd_file.*


   # 由4gl自動抓取gap_file,程式名稱對應的Action資料
   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE ds
   LET l_sql = "SELECT * FROM gap_file WHERE gap01 = '",ps_filename,"'"
   PREPARE gap_pre FROM l_sql
   DECLARE gap_curs CURSOR FOR gap_pre
   LET l_cnt = 1
   CALL lr_gap.clear()
   FOREACH gap_curs INTO lr_gap[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gap.deleteElement(l_cnt)
   IF lr_gap.getLength() <= 0 THEN
      DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 無法找到gap_file的資料"
   ELSE
      DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 抓到gap_file ",lr_gap.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gap.getLength()
      INSERT INTO gap_file VALUES(lr_gap[l_cnt].*)
      IF SQLCA.sqlcode THEN
         DISPLAY SQLCA.sqlcode," gap_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
         CONTINUE FOR
      END IF
   END FOR
   CLOSE DATABASE
   
   # 由4gl自動抓取gbd_file,程式名稱對應的Action多語言資料
   DATABASE ds
   LET l_sql = "SELECT gbd_file.* FROM gap_file,gbd_file",
               " WHERE gap01 = '",ps_filename,"' AND gap02 = gbd01"
   PREPARE gbd_pre FROM l_sql
   DECLARE gbd_curs CURSOR FOR gbd_pre
   LET l_cnt = 1
   CALL lr_gbd.clear()
   FOREACH gbd_curs INTO lr_gbd[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gbd.deleteElement(l_cnt)
   IF lr_gbd.getLength() <= 0 THEN
      DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED,"無法找到gbd_file的資料"
   ELSE
      DISPLAY "由修改清單",ps_system,"/",ps_filename CLIPPED," 抓到gbd_file ",lr_gbd.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gbd.getLength()
      INSERT INTO gbd_file VALUES(lr_gbd[l_cnt].*)
      IF SQLCA.sqlcode THEN
         DISPLAY SQLCA.sqlcode," gbd_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
         CONTINUE FOR
      END IF
   END FOR
   CLOSE DATABASE
END FUNCTION

# 打包單號群下面的gsyc_file所填的對應資料
FUNCTION p_gzl_pack_data(p_gzl00,p_gzl01,p_gzl17)
   DEFINE   p_gzl00      LIKE gzl_file.gzl00,
            p_gzl01      LIKE gzl_file.gzl01,
            p_gzl17      LIKE gzl_file.gzl17
   DEFINE   l_sql        STRING
   DEFINE   l_gsyc       DYNAMIC ARRAY OF RECORD
               gsyc04    LIKE gsyc_file.gsyc04,
               gsyc05    LIKE gsyc_file.gsyc05,
               gsyc06    LIKE gsyc_file.gsyc06,
               gsyc07    LIKE gsyc_file.gsyc07
                         END RECORD
   DEFINE   l_cmd        STRING
   DEFINE   li_i         INTEGER
   DEFINE   li_k         INTEGER
   DEFINE   l_cnt        INTEGER
   DEFINE   l_count      INTEGER
   DEFINE   l_path       STRING
   DEFINE   l_cust       STRING
   DEFINE   ls_where     STRING
   DEFINE   ls_feld_name CHAR(15)
   DEFINE   lr_zz        DYNAMIC ARRAY OF RECORD LIKE zz_file.*
   DEFINE   lr_zm        DYNAMIC ARRAY OF RECORD LIKE zm_file.*
   DEFINE   lr_gbd       DYNAMIC ARRAY OF RECORD LIKE gbd_file.*
   DEFINE   lr_gaz       DYNAMIC ARRAY OF RECORD LIKE gaz_file.*
   DEFINE   lr_gao       DYNAMIC ARRAY OF RECORD LIKE gao_file.*
   DEFINE   lr_gae       DYNAMIC ARRAY OF RECORD LIKE gae_file.*
   DEFINE   lr_gav       DYNAMIC ARRAY OF RECORD LIKE gav_file.*
   DEFINE   lr_gak       DYNAMIC ARRAY OF RECORD LIKE gak_file.*
   DEFINE   lr_gal       DYNAMIC ARRAY OF RECORD LIKE gal_file.*
   DEFINE   lr_gaq       DYNAMIC ARRAY OF RECORD LIKE gaq_file.*
   DEFINE   lr_gat       DYNAMIC ARRAY OF RECORD LIKE gat_file.*
   DEFINE   lr_ze        DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_gab       DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac       DYNAMIC ARRAY OF RECORD LIKE gac_file.*
   DEFINE   lr_wsa       DYNAMIC ARRAY OF RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       DYNAMIC ARRAY OF RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       DYNAMIC ARRAY OF RECORD LIKE zaa_file.*
   DEFINE   lr_zab       DYNAMIC ARRAY OF RECORD LIKE zab_file.*
   #No:CHI-750028 --start--
   DEFINE   lr_zai       DYNAMIC ARRAY OF RECORD LIKE zai_file.*
   DEFINE   lr_zaj       DYNAMIC ARRAY OF RECORD LIKE zaj_file.*
   DEFINE   lr_zak       DYNAMIC ARRAY OF RECORD LIKE zak_file.*
   DEFINE   lr_zal       DYNAMIC ARRAY OF RECORD LIKE zal_file.*
   DEFINE   lr_zam       DYNAMIC ARRAY OF RECORD LIKE zam_file.*
   DEFINE   lr_zan       DYNAMIC ARRAY OF RECORD LIKE zan_file.*
   DEFINE   lr_zao       DYNAMIC ARRAY OF RECORD LIKE zao_file.*
   DEFINE   lr_zap       DYNAMIC ARRAY OF RECORD LIKE zap_file.*
   DEFINE   lr_zaq       DYNAMIC ARRAY OF RECORD LIKE zaq_file.*
   DEFINE   lr_zar       DYNAMIC ARRAY OF RECORD LIKE zar_file.*
   DEFINE   lr_zas       DYNAMIC ARRAY OF RECORD LIKE zas_file.*
   DEFINE   lr_zat       DYNAMIC ARRAY OF RECORD LIKE zat_file.*
   DEFINE   lr_zau       DYNAMIC ARRAY OF RECORD LIKE zau_file.*
   DEFINE   lr_zav       DYNAMIC ARRAY OF RECORD LIKE zav_file.*
   #No:CHI-750028 ---end---
   DEFINE   lr_zaw       DYNAMIC ARRAY OF RECORD LIKE zaw_file.*    #No:TQC-7A0101
   DEFINE   lr_zay       DYNAMIC ARRAY OF RECORD LIKE zay_file.*    #No:FUN-7C0044


   LET l_cust = FGL_GETENV('CUST')

   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE ds
   LET l_sql = "SELECT gsyc04,gsyc05,gsyc06,gsyc07 FROM gsyc_file",
               " WHERE gsyc00 = '",p_gzl00 CLIPPED,"'",
               "   AND gsyc01 = '",p_gzl01 CLIPPED,"'",
               "   AND gsyc08 = '",p_gzl17 CLIPPED,"'"
   PREPARE gsyc_pre FROM l_sql
   DECLARE gsyc_curs CURSOR FOR gsyc_pre

   CALL l_gsyc.clear()
   LET l_cnt = 1
   FOREACH gsyc_curs INTO l_gsyc[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gsyc.deleteElement(l_cnt)

   FOR li_i = 1 TO l_gsyc.getLength()
       LET l_cmd = NULL
       IF l_gsyc[li_i].gsyc04 IS NULL THEN
          DISPLAY "Bug No:",p_gzl00,"  此筆資料中table狀態不明"
       END IF
       IF l_gsyc[li_i].gsyc06 IS NULL THEN
          DISPLAY "Bug No:",p_gzl00,"  ",l_gsyc[li_i].gsyc04 CLIPPED,":資料主key值null,無法篩選資料"
          CONTINUE FOR
       END IF
       
       CLOSE DATABASE     #No:TQC-7B0017
       DATABASE ds
       CASE l_gsyc[li_i].gsyc04
          WHEN "2"
             LET l_sql = "SELECT COUNT(*) FROM zz_file WHERE zz01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "6"
             LET l_sql = "SELECT COUNT(*) FROM gao_file WHERE gao01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "7"
             IF l_gsyc[li_i].gsyc07 IS NULL THEN
                LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "' AND gae11 = 'Y'"
             ELSE
                LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "' AND gae02 = '" || l_gsyc[li_i].gsyc07 CLIPPED || "' AND gae11 = 'Y'"
             END IF
          WHEN "8"
             LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "' AND gae11 = 'Y'"
          WHEN "9"
             LET l_sql = "SELECT COUNT(*) FROM gak_file WHERE gak01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "A"
             LET l_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "G"
             LET l_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "H"
             LET l_sql = "SELECT COUNT(*) FROM wsa_file WHERE wsa01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          WHEN "I"
             LET l_sql = "SELECT COUNT(*) FROM zaa_file WHERE zaa01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "'"
          #No:CHI-750028 --start--
          WHEN "Q"
             LET l_sql = "SELECT COUNT(*) FROM zai_file WHERE zai01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "' AND zai05 = 'Y'"
          #No:CHI-750028 ---end---
          #No:TQC-7A0101 --start--
          WHEN "P"
             LET l_sql = "SELECT COUNT(*) FROM zaw_file WHERE zaw01 = '" || l_gsyc[li_i].gsyc06 CLIPPED || "' AND zaw03 = 'Y'"
          #No:TQC-7A0101 ---end---
       END CASE
       PREPARE count_pre FROM l_sql
       EXECUTE count_pre INTO l_count
       IF l_count <= 0 THEN
          DISPLAY "BugNo.",p_gzl00," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : ",l_gsyc[li_i].gsyc06 CLIPPED," 沒有抓到資料"
          CONTINUE FOR
       END IF

       CASE l_gsyc[li_i].gsyc04
          WHEN "2"
             IF l_gsyc[li_i].gsyc05 != "zz_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM zz_file WHERE zz01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE zz_pre FROM l_sql
             DECLARE zz_curs CURSOR FOR zz_pre
             LET l_cnt = 1
             CALL lr_zz.clear()
             FOREACH zz_curs INTO lr_zz[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zz.deleteElement(l_cnt)
             IF lr_zz.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_zz.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zz.getLength()
                INSERT INTO zz_file VALUES(lr_zz[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 附加gaz_file資料
             DATABASE ds
             LET l_sql = "SELECT * FROM gaz_file ",
                         "WHERE gaz01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gaz05 = 'Y'"
             PREPARE gaz_pre FROM l_sql
             DECLARE gaz_curs CURSOR FOR gaz_pre
             LET l_cnt = 1
             CALL lr_gaz.clear()
             FOREACH gaz_curs INTO lr_gaz[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gaz.deleteElement(l_cnt)
             IF lr_gaz.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gaz_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gaz_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gaz.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gaz.getLength()
                INSERT INTO gaz_file VALUES(lr_gaz[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," gaz_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "7"
             IF l_gsyc[li_i].gsyc05 != "gae_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gae_file "
             IF l_gsyc[li_i].gsyc07 IS NULL THEN
                LET l_sql = l_sql," WHERE gae01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gae11 = 'Y'"
             ELSE
                LET l_sql = l_sql," WHERE gae01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gae02 = '",l_gsyc[li_i].gsyc07 CLIPPED,"' AND gae11='Y'"
             END IF
             PREPARE gae_pre FROM l_sql
             DECLARE gae_curs CURSOR FOR gae_pre
             LET l_cnt = 1
             CALL lr_gae.clear()
             FOREACH gae_curs INTO lr_gae[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gae.deleteElement(l_cnt)
             IF lr_gae.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gae.getLength()
                INSERT INTO gae_file VALUES(lr_gae[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 自動抓取gav_file資料
             DATABASE ds
             LET l_sql = "SELECT * FROM gav_file "
             IF l_gsyc[li_i].gsyc07 IS NULL THEN
                LET l_sql = l_sql," WHERE gav01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gav08 = 'Y'"
             ELSE
                LET l_sql = l_sql," WHERE gav01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gav02 = '",l_gsyc[li_i].gsyc07 CLIPPED,"' AND gav08='Y'"
             END IF
             PREPARE gav_pre FROM l_sql
             DECLARE gav_curs CURSOR FOR gav_pre
             LET l_cnt = 1
             CALL lr_gav.clear()
             FOREACH gav_curs INTO lr_gav[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gav.deleteElement(l_cnt)
             IF lr_gav.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gav.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gav.getLength()
                INSERT INTO gav_file VALUES(lr_gav[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "8"
             IF l_gsyc[li_i].gsyc05 != "gae_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gae_file ",
                         " WHERE gae01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gae11 = 'Y'"
             PREPARE gae_8_pre FROM l_sql
             DECLARE gae_8_curs CURSOR FOR gae_8_pre
             LET l_cnt = 1
             CALL lr_gae.clear()
             FOREACH gae_8_curs INTO lr_gae[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gae.deleteElement(l_cnt)
             IF lr_gae.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gae.getLength()
                INSERT INTO gae_file VALUES(lr_gae[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 自動抓取gav_file資料
             DATABASE ds
             LET l_sql = "SELECT * FROM gav_file WHERE gav01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gav08 = 'Y'"
             PREPARE gav_8_pre FROM l_sql
             DECLARE gav_8_curs CURSOR FOR gav_8_pre
             LET l_cnt = 1
             CALL lr_gav.clear()
             FOREACH gav_curs INTO lr_gav[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gav.deleteElement(l_cnt)
             IF lr_gav.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gav.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gav.getLength()
                INSERT INTO gav_file VALUES(lr_gav[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zav_file",
                         " WHERE zav01 = '1' AND zav02 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zav04 = 'Y'"
             PREPARE zav_8_pre FROM l_sql
             DECLARE zav_8_curs CURSOR FOR zav_8_pre
             LET l_cnt = 1
             CALL lr_zav.clear()
             FOREACH zav_8_curs INTO lr_zav[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zav.deleteElement(l_cnt)
             IF lr_zav.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zav_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zav_file 抓到 ",lr_zav.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zav.getLength()
                INSERT INTO zav_file VALUES(lr_zav[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "9"
             IF l_gsyc[li_i].gsyc05 != "gak_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             # 單頭檔 gak_file
             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gak_file WHERE gak01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE gak_pre FROM l_sql
             DECLARE gak_curs CURSOR FOR gak_pre
             LET l_cnt = 1
             CALL lr_gak.clear()
             FOREACH gak_curs INTO lr_gak[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gak.deleteElement(l_cnt)
             IF lr_gak.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gak.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gak.getLength()
                INSERT INTO gak_file VALUES(lr_gak[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 單身檔 gal_file
             DATABASE ds
             #No:TQC-890002 --start--
             IF l_gsyc[li_i].gsyc07 IS NOT NULL THEN
                LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND gal03 = '",l_gsyc[li_i].gsyc07 CLIPPED,"'"
             ELSE
             #No:TQC-890002 ---end---
                LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             END IF   #No:TQC-890002
             PREPARE gal_pre FROM l_sql
             DECLARE gal_curs CURSOR FOR gal_pre
             LET l_cnt = 1
             CALL lr_gal.clear()
             FOREACH gal_curs INTO lr_gal[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gal.deleteElement(l_cnt)
             IF lr_gal.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gal_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gal_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gal.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gal.getLength()
                INSERT INTO gal_file VALUES(lr_gal[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," gal_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "A"
             IF l_gsyc[li_i].gsyc05 != "gaq_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gaq_file WHERE gaq01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE gaq_pre FROM l_sql
             DECLARE gaq_curs CURSOR FOR gaq_pre
             LET l_cnt = 1
             CALL lr_gaq.clear()
             FOREACH gaq_curs INTO lr_gaq[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gaq.deleteElement(l_cnt)
             IF lr_gaq.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gaq.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gaq.getLength()
                INSERT INTO gaq_file VALUES(lr_gaq[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "G"
             IF l_gsyc[li_i].gsyc05 != "gat_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gat_file WHERE gat01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE gat_pre FROM l_sql
             DECLARE gat_curs CURSOR FOR gat_pre
             LET l_cnt = 1
             CALL lr_gat.clear()
             FOREACH gat_curs INTO lr_gat[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gat.deleteElement(l_cnt)
             IF lr_gat.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gat.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gat.getLength()
                INSERT INTO gat_file VALUES(lr_gat[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 自動抓取新增的table name下的所有在gaq_file內的field
             DATABASE ds
             IF g_db_type = "ORA" THEN
                LET l_sql = "SELECT LOWER(column_name) FROM user_tab_columns",
                            " WHERE LOWER(table_name) = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             ELSE
                LET l_sql = "SELECT b.colname FROM systables a,syscolumns b",
                            " WHERE a.tabid = b.tabid AND a.tabname = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
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

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gaq_file WHERE ",ls_where
             PREPARE gaq_g_pre FROM l_sql
             DECLARE gaq_g_curs CURSOR FOR gaq_g_pre
             LET l_cnt = 1
             CALL lr_gaq.clear()
             FOREACH gaq_g_curs INTO lr_gaq[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gaq.deleteElement(l_cnt)
             IF lr_gaq.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gaq_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," gaq_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gaq.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gaq.getLength()
                INSERT INTO gaq_file VALUES(lr_gaq[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," gaq_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "H"
             IF l_gsyc[li_i].gsyc05 != "wsa_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             # 單頭檔 wsa_file
             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM wsa_file WHERE wsa01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE wsa_pre FROM l_sql
             DECLARE wsa_curs CURSOR FOR wsa_pre
             LET l_cnt = 1
             CALL lr_wsa.clear()
             FOREACH wsa_curs INTO lr_wsa[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_wsa.deleteElement(l_cnt)
             IF lr_wsa.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_wsa.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_wsa.getLength()
                INSERT INTO wsa_file VALUES(lr_wsa[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 單身檔 wsb_file
             DATABASE ds
             LET l_sql = "SELECT * FROM wsb_file WHERE wsb01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE wsb_pre FROM l_sql
             DECLARE wsb_curs CURSOR FOR wsb_pre
             LET l_cnt = 1
             CALL lr_wsb.clear()
             FOREACH wsb_curs INTO lr_wsb[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_wsb.deleteElement(l_cnt)
             IF lr_wsb.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," wsb_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," wsb_file key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_wsb.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_wsb.getLength()
                INSERT INTO wsb_file VALUES(lr_wsb[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," wsb_file資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "I"
             IF l_gsyc[li_i].gsyc05 != "zaa_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             # 報表頭 zaa_file
             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM zaa_file WHERE zaa01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zaa10 = 'Y'"
             PREPARE zaa_pre FROM l_sql
             DECLARE zaa_curs CURSOR FOR zaa_pre
             LET l_cnt = 1
             CALL lr_zaa.clear()
             FOREACH zaa_curs INTO lr_zaa[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zaa.deleteElement(l_cnt)
             IF lr_zaa.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_zaa.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zaa.getLength()
                INSERT INTO zaa_file VALUES(lr_zaa[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 報表備註 zab_file
             DATABASE ds
             LET l_sql = "SELECT * FROM zab_file",
                         " WHERE zab01 = (SELECT UNIQUE zaa08 FROM zaa_file ",
                         " WHERE zaa01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'",
                         "   AND (zaa14 = 'H' OR zaa14 = 'J'))"
             PREPARE zab_pre FROM l_sql
             DECLARE zab_curs CURSOR FOR zab_pre
             LET l_cnt = 1
             CALL lr_zab.clear()
             FOREACH zab_curs INTO lr_zab[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zab.deleteElement(l_cnt)
             IF lr_zab.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zab_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zab_file 抓到 ",lr_zab.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zab.getLength()
                INSERT INTO zab_file VALUES(lr_zab[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," zab_file 資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          WHEN "J"
             IF l_gsyc[li_i].gsyc05 != "gao_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM gao_file WHERE gao01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"'"
             PREPARE gao_pre FROM l_sql
             DECLARE gao_curs CURSOR FOR gao_pre
             LET l_cnt = 1
             CALL lr_gao.clear()
             FOREACH gao_curs INTO lr_gao[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_gao.deleteElement(l_cnt)
             IF lr_gao.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_gao.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_gao.getLength()
                INSERT INTO gao_file VALUES(lr_gao[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             # 有p_zmd資料, 確認資料夾是否存在
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/4gl"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/per"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/42m"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/42f"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/42r"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/za"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/sql"
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/",l_gsyc[li_i].gsyc06 CLIPPED,"/sch"
             CALL pack_chk_and_add_dir(l_path)
             FOR li_k = 1 TO g_lang.getLength()
                 LET l_path = g_patch_path,"/tiptop/config/4ad/",g_lang[li_k].gay01 CLIPPED,"/",l_gsyc[li_i].gsyc06 CLIPPED
                 CALL pack_chk_and_add_dir(l_path)
             END FOR
             LET l_path = g_patch_path,"/tiptop/config/4tm/",l_gsyc[li_i].gsyc06 CLIPPED
             CALL pack_chk_and_add_dir(l_path)
             LET l_path = g_patch_path,"/tiptop/bin"
             CALL pack_chk_and_add_dir(l_path)
             LET l_cmd = "cp ",l_cust CLIPPED,"/bin/cust_sys ",g_patch_path,"/tiptop/bin"
             RUN l_cmd

          #No:CHI-750028 --start--
          WHEN "Q"
             IF l_gsyc[li_i].gsyc05 != "zai_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM zai_file WHERE zai01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zai05 = 'Y'"
             PREPARE zai_pre FROM l_sql
             DECLARE zai_curs CURSOR FOR zai_pre
             LET l_cnt = 1
             CALL lr_zai.clear()
             FOREACH zai_curs INTO lr_zai[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zai.deleteElement(l_cnt)
             IF lr_zai.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_zai.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zai.getLength()
                INSERT INTO zai_file VALUES(lr_zai[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zaj_file WHERE zaj01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zaj07 = 'Y'"
             PREPARE zaj_pre FROM l_sql
             DECLARE zaj_curs CURSOR FOR zaj_pre
             LET l_cnt = 1
             CALL lr_zaj.clear()
             FOREACH zaj_curs INTO lr_zaj[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zaj.deleteElement(l_cnt)
             IF lr_zaj.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zaj_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zaj_file 抓到 ",lr_zaj.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zaj.getLength()
                INSERT INTO zaj_file VALUES(lr_zaj[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zak_file WHERE zak01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zak07 = 'Y'"
             PREPARE zak_pre FROM l_sql
             DECLARE zak_curs CURSOR FOR zak_pre
             LET l_cnt = 1
             CALL lr_zak.clear()
             FOREACH zak_curs INTO lr_zak[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zak.deleteElement(l_cnt)
             IF lr_zak.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zak_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zak_file 抓到 ",lr_zak.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zak.getLength()
                INSERT INTO zak_file VALUES(lr_zak[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zal_file WHERE zal01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zal07 = 'Y'"
             PREPARE zal_pre FROM l_sql
             DECLARE zal_curs CURSOR FOR zal_pre
             LET l_cnt = 1
             CALL lr_zal.clear()
             FOREACH zal_curs INTO lr_zal[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zal.deleteElement(l_cnt)
             IF lr_zal.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zal_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zal_file 抓到 ",lr_zal.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zal.getLength()
                INSERT INTO zal_file VALUES(lr_zal[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zam_file WHERE zam01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zam09 = 'Y'"
             PREPARE zam_pre FROM l_sql
             DECLARE zam_curs CURSOR FOR zam_pre
             LET l_cnt = 1
             CALL lr_zam.clear()
             FOREACH zam_curs INTO lr_zam[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zam.deleteElement(l_cnt)
             IF lr_zam.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zam_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zam_file 抓到 ",lr_zam.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zam.getLength()
                INSERT INTO zam_file VALUES(lr_zam[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zan_file WHERE zan01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zan08 = 'Y'"
             PREPARE zan_pre FROM l_sql
             DECLARE zan_curs CURSOR FOR zan_pre
             LET l_cnt = 1
             CALL lr_zan.clear()
             FOREACH zan_curs INTO lr_zan[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zan.deleteElement(l_cnt)
             IF lr_zan.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zan_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zan_file 抓到 ",lr_zan.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zan.getLength()
                INSERT INTO zan_file VALUES(lr_zan[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zao_file WHERE zao01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zao05 = 'Y'"
             PREPARE zao_pre FROM l_sql
             DECLARE zao_curs CURSOR FOR zao_pre
             LET l_cnt = 1
             CALL lr_zao.clear()
             FOREACH zao_curs INTO lr_zao[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zao.deleteElement(l_cnt)
             IF lr_zao.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zao_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zao_file 抓到 ",lr_zao.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zao.getLength()
                INSERT INTO zao_file VALUES(lr_zao[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zap_file WHERE zap01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zap07 = 'Y'"
             PREPARE zap_pre FROM l_sql
             DECLARE zap_curs CURSOR FOR zap_pre
             LET l_cnt = 1
             CALL lr_zap.clear()
             FOREACH zap_curs INTO lr_zap[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zap.deleteElement(l_cnt)
             IF lr_zap.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zap_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zap_file 抓到 ",lr_zap.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zap.getLength()
                INSERT INTO zap_file VALUES(lr_zap[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zaq_file WHERE zaq01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zaq05 = 'Y'"
             PREPARE zaq_pre FROM l_sql
             DECLARE zaq_curs CURSOR FOR zaq_pre
             LET l_cnt = 1
             CALL lr_zaq.clear()
             FOREACH zaq_curs INTO lr_zaq[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zaq.deleteElement(l_cnt)
             IF lr_zaq.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zaq_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zaq_file 抓到 ",lr_zaq.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zaq.getLength()
                INSERT INTO zaq_file VALUES(lr_zaq[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zar_file WHERE zar01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zar05 = 'Y'"
             PREPARE zar_pre FROM l_sql
             DECLARE zar_curs CURSOR FOR zar_pre
             LET l_cnt = 1
             CALL lr_zar.clear()
             FOREACH zar_curs INTO lr_zar[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zar.deleteElement(l_cnt)
             IF lr_zar.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zar_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zar_file 抓到 ",lr_zar.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zar.getLength()
                INSERT INTO zar_file VALUES(lr_zar[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zas_file WHERE zas01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zas11 = 'Y'"
             PREPARE zas_pre FROM l_sql
             DECLARE zas_curs CURSOR FOR zas_pre
             LET l_cnt = 1
             CALL lr_zas.clear()
             FOREACH zas_curs INTO lr_zas[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zas.deleteElement(l_cnt)
             IF lr_zas.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zas_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zas_file 抓到 ",lr_zas.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zas.getLength()
                INSERT INTO zas_file VALUES(lr_zas[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zat_file WHERE zat01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zat10 = 'Y'"
             PREPARE zat_pre FROM l_sql
             DECLARE zat_curs CURSOR FOR zat_pre
             LET l_cnt = 1
             CALL lr_zat.clear()
             FOREACH zat_curs INTO lr_zat[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zat.deleteElement(l_cnt)
             IF lr_zat.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zat_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zat_file 抓到 ",lr_zat.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zat.getLength()
                INSERT INTO zat_file VALUES(lr_zat[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zau_file WHERE zau01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zau04 = 'Y'"
             PREPARE zau_pre FROM l_sql
             DECLARE zau_curs CURSOR FOR zau_pre
             LET l_cnt = 1
             CALL lr_zau.clear()
             FOREACH zau_curs INTO lr_zau[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zau.deleteElement(l_cnt)
             IF lr_zau.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zau_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zau_file 抓到 ",lr_zau.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zau.getLength()
                INSERT INTO zau_file VALUES(lr_zau[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE

             DATABASE ds
             LET l_sql = "SELECT * FROM zav_file ",
                         " WHERE zav01 = '2' AND zav02 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zav04 = 'Y'"
             PREPARE zav_pre FROM l_sql
             DECLARE zav_curs CURSOR FOR zav_pre
             LET l_cnt = 1
             CALL lr_zav.clear()
             FOREACH zav_curs INTO lr_zav[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zav.deleteElement(l_cnt)
             IF lr_zav.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zav_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zav_file 抓到 ",lr_zav.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zav.getLength()
                INSERT INTO zav_file VALUES(lr_zav[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          #No:CHI-750028 ---end---

             #No:FUN-7C0044 --start--
             DATABASE ds
             LET l_sql = "SELECT * FROM zay_file ",
                         " WHERE zay01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zay03 = 'Y'"
             PREPARE zay_pre FROM l_sql
             DECLARE zay_curs CURSOR FOR zay_pre
             LET l_cnt = 1
             CALL lr_zay.clear()
             FOREACH zay_curs INTO lr_zay[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zay.deleteElement(l_cnt)
             IF lr_zay.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zay_file 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," zay_file 抓到 ",lr_zay.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zay.getLength()
                INSERT INTO zay_file VALUES(lr_zay[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
             #No:FUN-7C0044 ---end---

          #No:TQC-7A0101 --start--
          WHEN "P"
             IF l_gsyc[li_i].gsyc05 != "zaw_file" THEN
                DISPLAY p_gzl00,"  ",l_gsyc[li_i].gsyc04,"與",l_gsyc[li_i].gsyc05,"不符"
                CONTINUE FOR
             END IF

             CLOSE DATABASE     #No:TQC-7B0017
             DATABASE ds
             LET l_sql = "SELECT * FROM zaw_file WHERE zaw01 = '",l_gsyc[li_i].gsyc06 CLIPPED,"' AND zaw03 = 'Y'"
             PREPARE zaw_pre FROM l_sql
             DECLARE zaw_curs CURSOR FOR zaw_pre
             LET l_cnt = 1
             CALL lr_zaw.clear()
             FOREACH zaw_curs INTO lr_zaw[l_cnt].*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
             END FOREACH
             CALL lr_zaw.deleteElement(l_cnt)
             IF lr_zaw.getLength() <= 0 THEN
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 沒有抓到資料"
             ELSE
                DISPLAY "BugNo.",p_gzl00 CLIPPED," ",l_gsyc[li_i].gsyc05 CLIPPED," key值 : '",l_gsyc[li_i].gsyc06 CLIPPED,"' 抓到 ",lr_zaw.getLength(),"筆資料"
             END IF
             CLOSE DATABASE
             DATABASE custtemp
             FOR l_cnt = 1 TO lr_zaw.getLength()
                INSERT INTO zaw_file VALUES(lr_zaw[l_cnt].*)
                IF SQLCA.sqlcode THEN
                   DISPLAY SQLCA.sqlcode," ",l_gsyc[li_i].gsyc05 CLIPPED,"資料倒至custtemp時，發生錯誤，若key值重複情況可忽略"
                   CONTINUE FOR
                END IF
             END FOR
             CLOSE DATABASE
          #No:TQC-7A0101 ---end---
       END CASE
   END FOR
END FUNCTION

# 若選擇打包共用資料，就抓gab_file、gac_file、ze_file資料
FUNCTION p_gzl_pack_common_data()
   DEFINE   l_sql   STRING
   DEFINE   l_cnt   INTEGER
   DEFINE   lr_ze   DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_gab  DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac  DYNAMIC ARRAY OF RECORD LIKE gac_file.*


   DISPLAY "打包共用資料中，會花費一段長久的時間"
   # ze_file中為TSD開頭的資料抓取
   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE ds
   LET l_sql = "SELECT * FROM ze_file WHERE ze01 MATCHES 'TSD*'"
   PREPARE ze_pre FROM l_sql
   DECLARE ze_curs CURSOR FOR ze_pre
   LET l_cnt = 1
   CALL lr_ze.clear()
   FOREACH ze_curs INTO lr_ze[l_cnt].*
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
   PREPARE gab_pre FROM l_sql
   DECLARE gab_curs CURSOR FOR gab_pre
   LET l_cnt = 1
   CALL lr_gab.clear()
   FOREACH gab_curs INTO lr_gab[l_cnt].*
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
   PREPARE gac_pre FROM l_sql
   DECLARE gac_curs CURSOR FOR gac_pre
   LET l_cnt = 1
   CALL lr_gac.clear()
   FOREACH gac_curs INTO lr_gac[l_cnt].*
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

# 打包此次單號群的gzl_file、gzln_file、gsyc_file資料
FUNCTION p_gzl_pack_gzldata(p_gzl00,p_gzl01,p_gzl17)
   DEFINE   p_gzl00      LIKE gzl_file.gzl00,
            p_gzl01      LIKE gzl_file.gzl01,
            p_gzl17      LIKE gzl_file.gzl17
   DEFINE   l_sql        STRING
   DEFINE   l_cnt        SMALLINT
   DEFINE   lr_gzl       DYNAMIC ARRAY OF RECORD LIKE gzl_file.*
   DEFINE   lr_gzln      DYNAMIC ARRAY OF RECORD LIKE gzln_file.*
   DEFINE   lr_gsyc      DYNAMIC ARRAY OF RECORD LIKE gsyc_file.*


   # gzl_file
   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE ds
   LET l_sql = "SELECT * FROM gzl_file ",
               " WHERE gzl00 = '",p_gzl00 CLIPPED,"' AND gzl01 = '",p_gzl01 CLIPPED,"'",
               "   AND gzl17 = '",p_gzl17 CLIPPED,"'"
   PREPARE gzl_pre FROM l_sql
   DECLARE gzl_curs CURSOR FOR gzl_pre
   LET l_cnt = 1
   CALL lr_gzl.clear()
   FOREACH gzl_curs INTO lr_gzl[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gzl.deleteElement(l_cnt)
   IF lr_gzl.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gzl_file的資料"
   ELSE
      DISPLAY "gzl_file抓取到",lr_gzl.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gzl.getLength()
      INSERT INTO gzl_file VALUES(lr_gzl[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_gzl.getLength(),"筆資料到custtemp.gzl_file "
   CLOSE DATABASE

   # gzln_file
   DATABASE ds
   LET l_sql = "SELECT * FROM gzln_file ",
               " WHERE gzln00 = '",p_gzl00 CLIPPED,"' AND gzln01 = '",p_gzl01 CLIPPED,"'",
               "   AND gzln07 = '",p_gzl17 CLIPPED,"'"
   PREPARE gzln_all_pre FROM l_sql
   DECLARE gzln_all_curs CURSOR FOR gzln_all_pre
   LET l_cnt = 1
   CALL lr_gzln.clear()
   FOREACH gzln_all_curs INTO lr_gzln[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gzln.deleteElement(l_cnt)
   IF lr_gzln.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gzln_file的資料"
   ELSE
      DISPLAY "gzln_file抓取到",lr_gzln.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gzln.getLength()
      INSERT INTO gzln_file VALUES(lr_gzln[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_gzln.getLength(),"筆資料到custtemp.gzln_file "
   CLOSE DATABASE

   # gsyc_file
   DATABASE ds
   LET l_sql = "SELECT * FROM gsyc_file ",
               " WHERE gsyc00 = '",p_gzl00 CLIPPED,"' AND gsyc01 = '",p_gzl01 CLIPPED,"'",
               "   AND gsyc08 = '",p_gzl17 CLIPPED,"'"
   PREPARE gsyc_all_pre FROM l_sql
   DECLARE gsyc_all_curs CURSOR FOR gsyc_all_pre
   LET l_cnt = 1
   CALL lr_gsyc.clear()
   FOREACH gsyc_all_curs INTO lr_gsyc[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL lr_gsyc.deleteElement(l_cnt)
   IF lr_gsyc.getLength() <= 0 THEN
      DISPLAY "沒有抓取到gsyc_file的資料"
   ELSE
      DISPLAY "gsyc_file抓取到",lr_gsyc.getLength(),"筆資料"
   END IF
   CLOSE DATABASE
   DATABASE custtemp
   FOR l_cnt = 1 TO lr_gsyc.getLength()
      INSERT INTO gsyc_file VALUES(lr_gsyc[l_cnt].*)
      IF SQLCA.sqlcode THEN
         CONTINUE FOR
      END IF
   END FOR
   DISPLAY "匯入 ",lr_gsyc.getLength(),"筆資料到custtemp.gsyc_file "
   CLOSE DATABASE
END FUNCTION

# No.FUN-710057  --start
# 確保custtemp存在
FUNCTION pack_create_custtemp()
   DEFINE l_cmd STRING
   DEFINE l_tmp_name CHAR(20)  #TQC-820013

   IF g_db_type = "ORA" THEN
      SELECT property_value INTO l_tmp_name FROM database_properties   #TQC-820013
       WHERE property_name='DEFAULT_TEMP_TABLESPACE'

      LET l_cmd = "sqlplus system/manager@`echo $ORACLE_SID` <<%%\n",
                  "create user custtemp identified by custtemp\n",
                  "default tablespace dbs1 temporary tablespace " || l_tmp_name CLIPPED || ";\n",   #TQC-820013
                  "grant create session,create table to custtemp;\n",
                  "grant resource to custtemp;\n",
                  "grant create synonym to custtemp;\n%%\n"
      RUN l_cmd
      LET l_cmd = 'sqlplus "/as sysdba" <<%%\n',
                  'grant select on sys.v_\\$session to custtemp;\n%%\n'
      RUN l_cmd
   ELSE
      LET l_cmd = "echo 'create database custtemp in dbs1 with log' | dbaccess >/dev/null 2>&1 "
      RUN l_cmd
   END IF
END FUNCTION
# No.FUN-710057  --end

# pack前先將custtemp資料庫內資料清空
FUNCTION pack_delete_tempdb_data()

   CALL pack_create_custtemp()   #No.FUN-710057  Add

   CLOSE DATABASE     #No:TQC-7B0017
   DATABASE custtemp
   IF STATUS THEN
      DISPLAY 'Connect custtemp db error~'
      EXIT PROGRAM
   END IF
   #No:TQC-730063 --start--
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
      #No:CHI-750028 --start--
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
      #No:CHI-750028 ---end---
      #No:FUN-7C0044 --start--
      DELETE FROM custtemp.zay_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zay_file error!"
      END IF
      #No:FUN-7C0044 ---end---
      #No:TQC-7A0101 --start--
      DELETE FROM custtemp.zaw_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaw_file error!"
      END IF
      #No:TQC-7A0101 ---end---
      DELETE FROM custtemp.gzl_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gzl_file error!"
      END IF
      DELETE FROM custtemp.gzln_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gzln_file error!"
      END IF
      DELETE FROM custtemp.gsyc_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gsyc_file error!"
      END IF
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
      #No:CHI-750028 --start--
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
      #No:CHI-750028 ---end---
      #No:FUN-7C0044 --start--
      DELETE FROM custtemp:zay_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zay_file error!"
      END IF
      #No:FUN-7C0044 ---end---
      #No:TQC-7A0101 --start--
      DELETE FROM custtemp:zaw_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp zaw_file error!"
      END IF
      #No:TQC-7A0101 ---end---
      DELETE FROM custtemp:gzl_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gzl_file error!"
      END IF
      DELETE FROM custtemp:gzln_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gzln_file error!"
      END IF
      DELETE FROM custtemp:gsyc_file
      IF SQLCA.sqlcode THEN
         DISPLAY "delete db_temp gsyc_file error!"
      END IF
   END IF
   #No:TQC-730063 ---end---
   
END FUNCTION

# 製作執行的shell
FUNCTION pack_mk_patch_shell(p_date)
   DEFINE   p_date        STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_str        STRING
   DEFINE   l_cmd         STRING


   LET lc_channel = base.Channel.create()
   IF g_pack_zs = "Y" THEN
      LET l_cmd = "rm ",g_tempdir,"/patch_",p_date,"_tab.sh 2>/dev/null"
      RUN l_cmd
      LET ls_str = g_tempdir,"/patch_",p_date,"_tab.sh"
   ELSE
      LET l_cmd = "rm ",g_tempdir,"/patch_",p_date,".sh 2>/dev/null"
      RUN l_cmd
      LET ls_str = g_tempdir,"/patch_",p_date,".sh"
   END IF
   CALL lc_channel.openFile(ls_str,"w")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("#!/bin/ksh")
   IF g_pack_zs = "Y" THEN
      LET ls_str = "tar xvf patch_",p_date,"_tab.tar"
   ELSE
      LET ls_str = "tar xvf patch_",p_date,".tar"
   END IF
   CALL lc_channel.write(ls_str)
   IF g_pack_zs='Y' THEN
      LET ls_str = "cd patch_",p_date,"_tab"
   ELSE
      LET ls_str = "cd patch_",p_date
   END IF
   CALL lc_channel.write(ls_str)
   LET ls_str = "patch_cust.sh ",p_date
   CALL lc_channel.write(ls_str)
   LET ls_str = "cd ../"
   CALL lc_channel.write(ls_str)
   IF g_pack_zs='Y' THEN
      LET ls_str = "rm -rf patch_",p_date,"_tab"
   ELSE
      LET ls_str = "rm -rf patch_",p_date
   END IF
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()

   IF g_pack_zs = "Y" THEN
      LET l_cmd = "chmod 777 ",g_tempdir,"/patch_",p_date,"_tab.sh"
   ELSE
      LET l_cmd = "chmod 777 ",g_tempdir,"/patch_",p_date,".sh"
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
       l_gzl01            STRING,
       l_gzl17            STRING,
       l_zs01             LIKE zs_file.zs01,
       l_zs02             LIKE zs_file.zs02,
       l_zs03             LIKE zs_file.zs03,
       l_cs               STRING,
       l_command          CHAR(180),  #MOD-8A0236 100=>180
       l_result           SMALLINT,
       l_fn_start         SMALLINT

      LET readfile_channel=base.channel.create()
      CALL readfile_channel.setdelimiter("")
      LET l_path=p_path CLIPPED,"/patch_cust_command"
      CALL readfile_channel.openfile(l_path CLIPPED, "w" )
      FOR l_k=1 TO l_gzl.getLength()
          LET l_gzl01=l_gzl[l_k].gzl01
          LET l_gzl17=l_gzl[l_k].gzl17
          LET l_sql="select zs01,zs02,zs03,zs06 from zs_file where zs08 like '",
                    l_gzl[l_k].gzl00 CLIPPED,"-",l_gzl01,"-",
                    l_gzl17,"' AND zs11!='Y' ORDER BY zs01,zs03"
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
                FOR l_i=1 TO 180   #MOD-8A0236 100=>180
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
              WHERE zs01=l_zs01 
                AND zs02=l_zs02
                AND zs03=l_zs03
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
