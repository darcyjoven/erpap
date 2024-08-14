##################################################
# Description  	: Patch 資料
# Date & Author : 2004/09/01 by saki
# Parameter   	: 
# Return   	: 
# Memo        	: 解patch內資料到目的地
# Modify        : 2006/04/14 by saki 增加zad_file、zae_file
# Modify        : 2006/09/22 by saki 增加資料同步aws_spccfg資料
# Modify        : No:FUN-730071 07/03/30 By alexstar 需新增zaw的資料同步選項，key值為zaw01
# Modify        : No:TQC-740038 07/04/09 By saki 資料同步增加zav_file
# Modify        : No:FUN-740054 07/04/13 By saki 資料同步增加p_query的項目
# Modify        : No:FUN-750075 07/05/18 by alexstar For AP DB分開環境
# Modify        : No:TQC-820013 08/02/19 by alexstar 動態抓取temporary tablespace名稱
##################################################
DATABASE ds

MAIN
   DEFINE   g_dir        STRING
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
   DEFINE   lr_gae       RECORD LIKE gae_file.*
   DEFINE   lr_gak       RECORD LIKE gak_file.*
   DEFINE   lr_gal       RECORD LIKE gal_file.*
   DEFINE   lr_gaq       RECORD LIKE gaq_file.*
   DEFINE   lr_gab       RECORD LIKE gab_file.*
   DEFINE   lr_gac       RECORD LIKE gac_file.*
   DEFINE   lr_gav       RECORD LIKE gav_file.*
   DEFINE   lr_gat       RECORD LIKE gat_file.*
   DEFINE   lr_gaz       RECORD LIKE gaz_file.*
   DEFINE   lr_wsa       RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       RECORD LIKE zaa_file.*
   DEFINE   lr_zab       RECORD LIKE zab_file.*
   DEFINE   lr_gao       RECORD LIKE gao_file.*
   # 2006/04/14 --start--
   DEFINE   lr_gax       RECORD LIKE gax_file.*
   DEFINE   lr_gba       RECORD LIKE gba_file.*
   DEFINE   lr_gbb       RECORD LIKE gbb_file.*
   DEFINE   lr_gbf       RECORD LIKE gbf_file.*
   DEFINE   lr_zad       RECORD
               zad01     VARCHAR(10),            #程式代號
               zad02     SMALLINT,               #序號
               zad03     VARCHAR(1),             #語言別
               zad04     VARCHAR(10),            #使用者
               zad05     VARCHAR(1),             #客製否
               zad06     VARCHAR(20),            #報表列印的樣板
               zad07     VARCHAR(10),            #權限類別
               zad08     SMALLINT,               #報表聯查序號
               zad09     VARCHAR(1),             #報表聯查類型
               zad10     VARCHAR(10),            #報表聯查內容
               zad11     VARCHAR(255)
                         END RECORD
   DEFINE   lr_zae       RECORD
               zae01     VARCHAR(10),            #報表連查sql 代號
               zae02     VARCHAR(30),            #代號說明
               zae03     VARCHAR(255),           #sql內容
               zae04     SMALLINT,               #序號
               zae05     VARCHAR(1),             #語言別
               zae06     VARCHAR(20),            #欄位代號
               zae07     VARCHAR(60),            #欄位說明
               zae08     SMALLINT,               #報表下階聯查序號
               zae09     VARCHAR(1),             #報表下階聯查類型 1:程式代號 2:sql代號
               zae10     VARCHAR(10)             #報表下階連查內容
                         END RECORD
   # 2006/04/14 ---end---
   # 2006/09/22 --start--
   DEFINE   lr_wca       RECORD
               wca01     VARCHAR(10),            #程式代號
               wca02     VARCHAR(1),             #是否為 hard code 程式
               wca03     VARCHAR(1),             #no use
               wca04     VARCHAR(1),             #no use
               wca05     VARCHAR(1),             #no use
               wcaacti   VARCHAR(1),             #資料有效碼
               wcauser   VARCHAR(10),            #資料所有者
               wcagrup   VARCHAR(6),             #資料所有群
               wcamodu   VARCHAR(10),            #資料更改者
               wcadate   DATE                    #最近修改日
                         END RECORD
   DEFINE   lr_wcb       RECORD
               wcb01     VARCHAR(10),            #程式代號
               wcb02     VARCHAR(15),            #程式使用單頭檔
               wcb03     VARCHAR(20),            #單頭檔 key 值欄位1
               wcb04     VARCHAR(20),            #單頭檔 key 值欄位2
               wcb05     VARCHAR(20),            #單頭檔 key 值欄位3
               wcb06     VARCHAR(20),            #單頭檔 key 值欄位4
               wcb07     VARCHAR(20),            #單頭檔 key 值欄位5
               wcb08     VARCHAR(20),            #單頭檔確認碼欄位
               wcb09     VARCHAR(20),            #單頭檔spc拋轉碼欄位
               wcb10     VARCHAR(1),             #no use
               wcb11     VARCHAR(1),             #no use
               wcb12     VARCHAR(1),             #no use
               wcb13     VARCHAR(1),             #no use
               wcb14     VARCHAR(1)              #no use
                         END RECORD
   DEFINE   lr_wcc       RECORD
               wcc01     VARCHAR(10),            #程式代號
               wcc02     VARCHAR(20),            #欄位名稱
               wcc03     VARCHAR(1),             #更新否
               wcc04     VARCHAR(1),             #no use
               wcc05     VARCHAR(1),             #no use
               wcc06     VARCHAR(1),             #no use
               wcc07     VARCHAR(1)              #no use
                         END RECORD
   DEFINE   lr_wcd       RECORD
               wcd01     VARCHAR(15),            #檔案代碼
               wcd02     VARCHAR(20),            #欄位名稱
               wcd03     VARCHAR(1),             #no use
               wcd04     VARCHAR(1),             #no use
               wcd05     VARCHAR(1),             #no use
               wcd06     VARCHAR(1),             #no use
               wcd07     VARCHAR(1)              #no use
                         END RECORD
   # 2006/09/22 ---end---
   #FUN-730071 ---start---
   DEFINE   lr_zaw       RECORD
               zaw01     VARCHAR(10),            #程式代號
               zaw02     VARCHAR(20),            #樣板代號
               zaw03     VARCHAR(1),             #客製否
               zaw04     VARCHAR(10),            #權限類別
               zaw05     VARCHAR(10),            #使用者
               zaw06     VARCHAR(1),             #語言別
               zaw07     SMALLINT,               #序號
               zaw08     VARCHAR(20),            #cr樣板名稱(.rpt)
               zaw09     VARCHAR(50),            #cr樣板說明
               zaw10     VARCHAR(1),             #no use
               zaw11     VARCHAR(1),             #no use
               zaw12     VARCHAR(1),             #no use
               zawdate   DATE,                   #最近修改日
               zawgrup   VARCHAR(6),             #資料所有部門
               zawmodu   VARCHAR(10),            #資料修改者
               zawuser   VARCHAR(10)             #
                         END RECORD
   #FUN-730071 ---end---
   #No:TQC-740038 --start--
   DEFINE   lr_zav       RECORD
               zav01     VARCHAR(1),             #p_per/p_query
               zav02     VARCHAR(40),            #畫面代碼
               zav03     VARCHAR(20),            #欄位代碼
               zav04     VARCHAR(1),             #客製碼
               zav05     VARCHAR(10),            #行業別代碼
               zav06     VARCHAR(1),             #是否需要CONSTRUCT
               zav07     VARCHAR(255),           #額外查詢條件
               zav08     VARCHAR(5),             #預設值自選或固定值
               zav09     VARCHAR(50),            #預設值1
               zav10     VARCHAR(50),            #預設值2
               zav11     VARCHAR(50),            #預設值3
               zav12     VARCHAR(50),            #預設值4
               zav13     VARCHAR(50),            #預設值5
               zav14     VARCHAR(9),             #參數自選或固定值
               zav15     VARCHAR(50),            #參數1
               zav16     VARCHAR(50),            #參數2
               zav17     VARCHAR(50),            #參數3
               zav18     VARCHAR(50),            #參數4
               zav19     VARCHAR(50),            #參數5
               zav20     VARCHAR(50),            #參數6
               zav21     VARCHAR(50),            #參數7
               zav22     VARCHAR(50),            #參數8
               zav23     VARCHAR(50),            #參數9
               zav24     VARCHAR(1)              #input/construct用
                         END RECORD
   #No:TQC-740038 ---end---
   #No:FUN-740054 --start--
   DEFINE   lr_zai       RECORD
               zai01     VARCHAR(40),            #查詢單id
               zai02     VARCHAR(100),           #查詢單名稱
               zai03     VARCHAR(255),           #說明
               zaiuser   VARCHAR(10),            #資料所有者
               zaigrup   VARCHAR(6),             #資料所有群
               zaimodu   VARCHAR(10),            #資料更改者
               zaidate   DATE,                   #最近修改日
               zai04     VARCHAR(1),             #查詢報表時是否需輸入查詢條件
               zai05     VARCHAR(1)              #客製否
                         END RECORD
   DEFINE   lr_zaj       RECORD
               zaj01     VARCHAR(40),            #查詢單id
               zaj02     SMALLINT,               #執行順序
               zaj03     VARCHAR(1),             #啟動否
               zaj04     VARCHAR(1),             #來源類別
               zaj05     VARCHAR(255),           #執行命令
               zaj06     VARCHAR(255)            #備註
                         END RECORD
   DEFINE   lr_zak       RECORD
               zak01     VARCHAR(40),            #查詢單id
               zak02     VARCHAR(2000),          #sql命令
               zak03     VARCHAR(2000),          #table list
               zak04     VARCHAR(2000),          #field list
               zak05     VARCHAR(2000),          #where 條件
               zak06     VARCHAR(1)              #SQL是否由Wizard產生
                         END RECORD
   DEFINE   lr_zal       RECORD
               zal01     VARCHAR(40),            #查詢單id                               */
               zal02     SMALLINT,               #序號                                   */
               zal03     VARCHAR(1),             #語言別                                 */
               zal04     VARCHAR(60),            #欄位代號                               */
               zal05     VARCHAR(40),            #顯示名稱                               */
               zal06     VARCHAR(255)            #備註                                   */
                         END RECORD
   DEFINE   lr_zam       RECORD
               zam01     VARCHAR(40),            #查詢單id                               */
               zam02     SMALLINT,               #序號                                   */
               zam03     VARCHAR(1),             #group否                                */
               zam04     VARCHAR(1),             #排序否                                 */
               zam05     SMALLINT,               #排序順序                               */
               zam06     VARCHAR(255),           #備註                                   */
               zam07     VARCHAR(1),             #是否BY Group跳頁                       */
               zam08     VARCHAR(1)              #排序方式                               */
                         END RECORD
   DEFINE   lr_zan       RECORD
               zan01     VARCHAR(40),            #查詢單id                               */
               zan02     SMALLINT,               #序號                                   */
               zan03     VARCHAR(1),             #計算式-aggr                            */
               zan04     VARCHAR(1),             #依group欄位                            */
               zan05     VARCHAR(40),            #group欄位序                            */
               zan06     VARCHAR(255),           #備註                                   */
               zan07     VARCHAR(1)              #顯示方式                               */
                         END RECORD
   DEFINE   lr_zao       RECORD
               zao01     VARCHAR(40),            #查詢單id                               */
               zao02     VARCHAR(1),             #layout 項目                            */
               zao03     VARCHAR(1),             #輸入格式                               */
               zao04     VARCHAR(1)              #執行否                                 */
                         END RECORD
   DEFINE   lr_zap       RECORD
               zap01     VARCHAR(40),            #查詢單id                               */
               zap02     SMALLINT,               #page length                            */
               zap03     SMALLINT,               #top margin                             */
               zap04     SMALLINT,               #left margin                            */
               zap05     SMALLINT,               #bottom margin                          */
               zap06     INTEGER                 #報表最大查詢筆數                       */
                         END RECORD
   DEFINE   lr_zaq       RECORD
               zaq01     VARCHAR(40),            #查詢單ID                               */
               zaq02     VARCHAR(15),            #檔案代碼                               */
               zaq03     VARCHAR(1),             #outer                                  */
               zaq04     SMALLINT                #序號                                   */
                         END RECORD
   DEFINE   lr_zar       RECORD
               zar01     VARCHAR(40),            #查詢單id                               */
               zar02     VARCHAR(15),            #檔案代碼                               */
               zar03     VARCHAR(20),            #欄位代碼                               */
               zar04     SMALLINT                #序號                                   */
                         END RECORD
   DEFINE   lr_zas       RECORD
               zas01     VARCHAR(40),            #查詢單id                               */
               zas02     SMALLINT,               #條件式序號                             */
               zas03     VARCHAR(5),             #(                                      */
               zas04     VARCHAR(15),            #檔案代碼                               */
               zas05     VARCHAR(20),            #欄位代碼                               */
               zas06     VARCHAR(5),             #條件式                                 */
               zas07     VARCHAR(20),            #檔案代碼                               */
               zas08     VARCHAR(50),            #欄位代碼/數值                          */
               zas09     VARCHAR(5),             #)                                      */
               zas10     VARCHAR(1)              #or/and                                 */
                         END RECORD
   DEFINE   lr_zat       RECORD
               zat01     VARCHAR(40),            #查詢單id                               */
               zat02     DECIMAL(5,0),           #序號                                   */
               zat03     VARCHAR(1),             #列印顯示設定                           */
               zat04     SMALLINT,               #查詢視窗顯示順序                       */
               zat05     VARCHAR(1),             #開窗(qbe)                              */
               zat06     VARCHAR(20),            #查詢程式代碼                           */
               zat07     VARCHAR(1),             #小數位設定                             */
               zat08     VARCHAR(1),             #欄位屬性                               */
               zat09     VARCHAR(20)             #幣別欄位/小數位                        */
                         END RECORD
   DEFINE   lr_zau       RECORD
               zau01     VARCHAR(40),            #查詢單id                               */
               zau02     VARCHAR(20),            #資料所有者欄位                         */
               zau03     VARCHAR(20)             #資料群組欄位                           */
                         END RECORD
   DEFINE   lr_wsm       RECORD LIKE wsm_file.*
   DEFINE   lr_wsn       RECORD LIKE wsn_file.*
   DEFINE   lr_wso       RECORD LIKE wso_file.*
   DEFINE   lr_wsp       RECORD LIKE wsp_file.*
   #No:FUN-740054 ---end---
   
   DEFINE   lc_zz011     LIKE zz_file.zz011
   DEFINE   ls_zz011     STRING
   DEFINE   l_tempdir    STRING
   DEFINE   readfile_channel   base.Channel
   DEFINE   li_count     INTEGER               # 為了要計算一個table做了幾筆資料
   DEFINE   g_ver_main   CHAR(5)               # 2006/04/14
   DEFINE   l_tmp_name   CHAR(20)  #TQC-820013


   LET l_result = TRUE

   WHENEVER ERROR CONTINUE
   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET g_dir = ARG_VAL(1)
   LET g_dbs = ARG_VAL(2)
   LET g_ver_main = ARG_VAL(3)

   LET l_cmd = "mkdir -p $TEMPDIR/",g_dir
   RUN l_cmd
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
      RUN "echo 'drop database patchtemp'|dbaccess"
      LET l_cmd="dbimport patchtemp -l -d ",g_dbs CLIPPED
      RUN l_cmd
   ELSE
      SELECT property_value INTO l_tmp_name FROM database_properties   #TQC-820013
       WHERE property_name='DEFAULT_TEMP_TABLESPACE'

      CALL lc_channel.write("ex - <<%%")
      CALL lc_channel.write("a")
      CALL lc_channel.write("conn system/manager@`echo $ORACLE_SID`;")
      CALL lc_channel.write("drop user patchtemp cascade;")
      CALL lc_channel.write("create user patchtemp identified by patchtemp")
      LET l_cmd="default tablespace ",g_dbs CLIPPED
      CALL lc_channel.write(l_cmd)
      CALL lc_channel.write("temporary tablespace " || l_tmp_name CLIPPED || ";")  #TQC-820013
      CALL lc_channel.write("grant create session,create table to patchtemp;")
      CALL lc_channel.write("grant resource to patchtemp;")
      CALL lc_channel.write("grant create synonym to patchtemp;")
      CALL lc_channel.write("conn sys/change_on_install as sysdba;")   #FUN-750075
      CALL lc_channel.write("grant select on sys.v_\\$session to patchtemp;")
      CALL lc_channel.write("exit;")
      CALL lc_channel.write(".")
      CALL fgl_getenv("TEMPDIR") RETURNING l_str
      LET l_str="w! ",l_str CLIPPED,"/createdb.sql"
      CALL lc_channel.write(l_str CLIPPED)
      CALL lc_channel.write("q")
      CALL lc_channel.write("%%")
      CALL lc_channel.write("sqlplus system/manager@$ORACLE_SID < $TEMPDIR/createdb.sql")   #FUN-750075
      CALL lc_channel.write("cd $TOP/ora/work")
      CALL fgl_getenv("TOP") RETURNING l_str
      LET l_str="imp patchtemp/patchtemp@$ORACLE_SID file=",l_str,"/patch_",g_dir,"/patchtemp.dmp ignore=y"   #FUN-750075
      CALL lc_channel.write(l_str)
      #CALL lc_channel.write("sqlplus system/manager < $TEMPDIR/createdb1.sql")
      CALL lc_channel.close() 
      RUN "chmod 777 $TEMPDIR/createdb.sql"
      RUN "chmod 777 import_data.sh"
      RUN "import_data.sh"
   END IF
   CALL lc_channel.close()

   EXECUTE IMMEDIATE "grant select on zaa_file to public"
   EXECUTE IMMEDIATE "grant insert on zaa_file to public"
   EXECUTE IMMEDIATE "grant update on zaa_file to public"
   EXECUTE IMMEDIATE "grant delete on zaa_file to public"
   EXECUTE IMMEDIATE "grant index  on zaa_file to public"

   EXECUTE IMMEDIATE "grant select on zab_file to public"
   EXECUTE IMMEDIATE "grant insert on zab_file to public"
   EXECUTE IMMEDIATE "grant update on zab_file to public"
   EXECUTE IMMEDIATE "grant delete on zab_file to public"
   EXECUTE IMMEDIATE "grant index  on zab_file to public"

   EXECUTE IMMEDIATE "grant select on wsa_file to public"
   EXECUTE IMMEDIATE "grant insert on wsa_file to public"
   EXECUTE IMMEDIATE "grant update on wsa_file to public"
   EXECUTE IMMEDIATE "grant delete on wsa_file to public"
   EXECUTE IMMEDIATE "grant index  on wsa_file to public"

   EXECUTE IMMEDIATE "grant select on wsb_file to public"
   EXECUTE IMMEDIATE "grant insert on wsb_file to public"
   EXECUTE IMMEDIATE "grant update on wsb_file to public"
   EXECUTE IMMEDIATE "grant delete on wsb_file to public"
   EXECUTE IMMEDIATE "grant index  on wsb_file to public"

   IF g_db_type = "IFX" THEN
      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      DECLARE ze_curs CURSOR FOR
              SELECT * FROM patchtemp:ze_file
      FOREACH ze_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file patchtemp FOREACH 資料時產生錯誤，ze資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:ze_file VALUES(lr_ze.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:ze_file SET ds:ze_file.* = lr_ze.*
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
      DECLARE zz_curs CURSOR FOR
              SELECT * FROM patchtemp:zz_file
      FOREACH zz_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file patchtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds:zz_file WHERE zz01 = lr_zz.zz01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds:zz_file SET ds:zz_file.* = lr_zz.*
                WHERE zz01 = lr_zz.zz01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "更新 zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      DECLARE gaz_curs CURSOR FOR
              SELECT * FROM patchtemp:gaz_file
      FOREACH gaz_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file patchtemp FOREACH 資料時產生錯誤，gaz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gaz_file VALUES(lr_gaz.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaz_file SET ds:gaz_file.* = lr_gaz.* 
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
      DECLARE zm_curs CURSOR FOR
              SELECT * FROM patchtemp:zm_file
      FOREACH zm_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file patchtemp FOREACH 資料時產生錯誤，zm資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zm_file data error:",SQLCA.sqlerrd[2]," ",lr_zm.*
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
              SELECT * FROM patchtemp:gap_file
      FOREACH gap_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gap_file patchtemp FOREACH 資料時產生錯誤，gap資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gap_file VALUES(lr_gap.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gap_file SET ds:gap_file.* = lr_gap.*
             WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gap_file data error:",SQLCA.sqlerrd[2]," ",lr_gap.*
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
              SELECT * FROM patchtemp:gbd_file
      FOREACH gbd_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file patchtemp FOREACH 資料時產生錯誤，gbd資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gbd_file VALUES(lr_gbd.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbd_file SET ds:gbd_file.* = lr_gbd.*
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
      DECLARE gae_curs CURSOR FOR
              SELECT * FROM patchtemp:gae_file
      FOREACH gae_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file patchtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gae_file SET ds:gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11
               AND gae12 = lr_gae.gae12
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gae_file data error:",SQLCA.sqlerrd[2]," ",lr_gae.*
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
              SELECT * FROM patchtemp:gak_file
      FOREACH gak_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file patchtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds:zz_file WHERE zz01 = lr_gak.gak01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds:gak_file SET ds:gak_file.* = lr_gak.*
                WHERE gak01 = lr_gak.gak01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      DECLARE gal_curs CURSOR FOR
              SELECT * FROM patchtemp:gal_file
      FOREACH gal_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file patchtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gal_file VALUES(lr_gal.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds:zz_file WHERE zz01 = lr_gal.gal01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds:gal_file SET ds:gal_file.* = lr_gal.*
                WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      DECLARE gaq_curs CURSOR FOR
              SELECT * FROM patchtemp:gaq_file
      FOREACH gaq_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file patchtemp FOREACH 資料時產生錯誤，gaq資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gaq_file VALUES(lr_gaq.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gaq_file SET ds:gaq_file.* = lr_gaq.*
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
      DECLARE gab_curs CURSOR FOR
              SELECT * FROM patchtemp:gab_file
      FOREACH gab_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file patchtemp FOREACH 資料時產生錯誤，gab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gab_file VALUES(lr_gab.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gab_file SET ds:gab_file.* = lr_gab.*
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
      DECLARE gac_curs CURSOR FOR
              SELECT * FROM patchtemp:gac_file
      FOREACH gac_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file patchtemp FOREACH 資料時產生錯誤，gac資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gac_file VALUES(lr_gac.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gac_file SET ds:gac_file.* = lr_gac.*
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
      DECLARE gav_curs CURSOR FOR
              SELECT * FROM patchtemp:gav_file
      FOREACH gav_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file patchtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gav_file SET ds:gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02
               AND gav08 = lr_gav.gav08 AND gav11 = lr_gav.gav11
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
      DECLARE gat_curs CURSOR FOR
              SELECT * FROM patchtemp:gat_file
      FOREACH gat_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file patchtemp FOREACH 資料時產生錯誤，gat資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gat_file VALUES(lr_gat.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gat_file SET ds:gat_file.* = lr_gat.*
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
      DECLARE wsa_curs CURSOR FOR
              SELECT * FROM patchtemp:wsa_file
      FOREACH wsa_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file patchtemp FOREACH 資料時產生錯誤，wsa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsa_file VALUES(lr_wsa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsa_file SET ds:wsa_file.* = lr_wsa.*
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
      DECLARE wsb_curs CURSOR FOR
              SELECT * FROM patchtemp:wsb_file
      FOREACH wsb_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file patchtemp FOREACH 資料時產生錯誤，wsb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsb_file VALUES(lr_wsb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsb_file SET ds:wsb_file.* = lr_wsb.*
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
      DECLARE zaa_curs CURSOR FOR
              SELECT * FROM patchtemp:zaa_file
      FOREACH zaa_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file patchtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zaa_file VALUES(lr_zaa.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:zaa_file SET ds:zaa_file.* = lr_zaa.*
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
      DECLARE zab_curs CURSOR FOR
              SELECT * FROM patchtemp:zab_file
      FOREACH zab_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file patchtemp FOREACH 資料時產生錯誤，zab資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:zab_file VALUES(lr_zab.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zab_file data error:",SQLCA.sqlerrd[2]," ",lr_zab.*
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
              SELECT * FROM patchtemp:gao_file
      FOREACH gao_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gao_file patchtemp FOREACH 資料時產生錯誤，gao資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gao_file VALUES(lr_gao.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gao_file SET ds:gao_file.* = lr_gao.*
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


      # 2006/04/14 --start--
      DISPLAY "開始更新gax_file資料"
      LET li_count = 0
      DECLARE gax_curs CURSOR FOR
              SELECT * FROM patchtemp:gax_file
      FOREACH gax_curs INTO lr_gax.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gax_file patchtemp FOREACH 資料時產生錯誤，gax資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gax_file VALUES(lr_gax.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gax_file SET ds:gax_file.* = lr_gax.*
             WHERE gax01 = lr_gax.gax01 AND gax02 = lr_gax.gax02
               AND gax05 = lr_gax.gax05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gax_file data error:",SQLCA.sqlerrd[2]," ",lr_gax.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gax_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gba_file資料"
      LET li_count = 0
      DECLARE gba_curs CURSOR FOR
              SELECT * FROM patchtemp:gba_file
      FOREACH gba_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gba_file patchtemp FOREACH 資料時產生錯誤，gba資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gba_file VALUES(lr_gba.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gba_file SET ds:gba_file.* = lr_gba.*
             WHERE gba01 = lr_gba.gba01 AND gba02 = lr_gba.gba02
               AND gba03 = lr_gba.gba03 AND gba04 = lr_gba.gba04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gba_file data error:",SQLCA.sqlerrd[2]," ",lr_gba.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gba_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbb_file資料"
      LET li_count = 0
      DECLARE gbb_curs CURSOR FOR
              SELECT * FROM patchtemp:gbb_file
      FOREACH gbb_curs INTO lr_gbb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbb_file patchtemp FOREACH 資料時產生錯誤，gbb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gbb_file VALUES(lr_gbb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbb_file SET ds:gbb_file.* = lr_gbb.*
             WHERE gbb01 = lr_gbb.gbb01 AND gbb02 = lr_gbb.gbb02
               AND gbb03 = lr_gbb.gbb03 AND gbb04 = lr_gbb.gbb04
               AND gbb05 = lr_gbb.gbb05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbb_file data error:",SQLCA.sqlerrd[2]," ",lr_gbb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbf_file資料"
      LET li_count = 0
      DECLARE gbf_curs CURSOR FOR
              SELECT * FROM patchtemp:gbf_file
      FOREACH gbf_curs INTO lr_gbf.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbf_file patchtemp FOREACH 資料時產生錯誤，gbf資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:gbf_file VALUES(lr_gbf.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:gbf_file SET ds:gbf_file.* = lr_gbf.*
             WHERE gbf01 = lr_gbf.gbf01 AND gbf02 = lr_gbf.gbf02
               AND gbf03 = lr_gbf.gbf03 AND gbf04 = lr_gbf.gbf04
               AND gbf06 = lr_gbf.gbf06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbf_file data error:",SQLCA.sqlerrd[2]," ",lr_gbf.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbf_file 更新完畢，共更新 ",li_count,"筆資料"


      IF g_ver_main NOT MATCHES '1*' THEN
         DISPLAY "開始更新zad_file資料"
         LET li_count = 0
         DECLARE zad_curs CURSOR FOR
                 SELECT * FROM patchtemp:zad_file
         FOREACH zad_curs INTO lr_zad.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zad_file patchtemp FOREACH 資料時產生錯誤，zad資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zad_file VALUES(lr_zad.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zad_file SET zad01 = lr_zad.zad01,zad02 = lr_zad.zad02,
                                      zad03 = lr_zad.zad03,zad04 = lr_zad.zad04,
                                      zad05 = lr_zad.zad05,zad06 = lr_zad.zad06,
                                      zad07 = lr_zad.zad07,zad08 = lr_zad.zad08,
                                      zad09 = lr_zad.zad09,zad10 = lr_zad.zad10,
                                      zad11 = lr_zad.zad11
                WHERE zad01 = lr_zad.zad01 AND zad02 = lr_zad.zad02
                  AND zad03 = lr_zad.zad03 AND zad04 = lr_zad.zad04
                  AND zad05 = lr_zad.zad05 AND zad06 = lr_zad.zad06
                  AND zad07 = lr_zad.zad07 AND zad08 = lr_zad.zad08
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zad_file data error:",SQLCA.sqlerrd[2]," ",lr_zad.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "zad_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新zae_file資料"
         LET li_count = 0
         DECLARE zae_curs CURSOR FOR
                 SELECT * FROM patchtemp:zae_file
         FOREACH zae_curs INTO lr_zae.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zae_file patchtemp FOREACH 資料時產生錯誤，zae資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zae_file VALUES(lr_zae.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zae_file SET zae01 = lr_zae.zae01,zae02 = lr_zae.zae02,
                                      zae03 = lr_zae.zae03,zae04 = lr_zae.zae04,
                                      zae05 = lr_zae.zae05,zae06 = lr_zae.zae06,
                                      zae07 = lr_zae.zae07,zae08 = lr_zae.zae08,
                                      zae09 = lr_zae.zae09,zae10 = lr_zae.zae10
                WHERE zae01 = lr_zae.zae01 AND zae04 = lr_zae.zae04
                  AND zae05 = lr_zae.zae05 AND zae08 = lr_zae.zae08
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zae_file data error:",SQLCA.sqlerrd[2]," ",lr_zae.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "zae_file 更新完畢，共更新 ",li_count,"筆資料"
      END IF
      # 2006/04/14 ---end---


      # 2006/09/22 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新wca_file資料"
         LET li_count = 0
         DECLARE wca_curs CURSOR FOR
                 SELECT * FROM patchtemp:wca_file
         FOREACH wca_curs INTO lr_wca.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wca_file patchtemp FOREACH 資料時產生錯誤，wca資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:wca_file VALUES(lr_wca.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:wca_file SET wca01 = lr_wca.wca01,wca02 = lr_wca.wca02,
                                      wca03 = lr_wca.wca03,wca04 = lr_wca.wca04,
                                      wca05 = lr_wca.wca05,wcaacti = lr_wca.wcaacti,
                                      wcauser = lr_wca.wcauser,wcagrup = lr_wca.wcagrup,
                                      wcamodu = lr_wca.wcamodu,wcadate = lr_wca.wcadate
                WHERE wca01 = lr_wca.wca01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wca_file data error:",SQLCA.sqlerrd[2]," ",lr_wca.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wca_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcb_file資料"
         LET li_count = 0
         DECLARE wcb_curs CURSOR FOR
                 SELECT * FROM patchtemp:wcb_file
         FOREACH wcb_curs INTO lr_wcb.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcb_file patchtemp FOREACH 資料時產生錯誤，wcb資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:wcb_file VALUES(lr_wcb.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:wcb_file SET wcb01 = lr_wcb.wcb01,wcb02 = lr_wcb.wcb02,
                                      wcb03 = lr_wcb.wcb03,wcb04 = lr_wcb.wcb04,
                                      wcb05 = lr_wcb.wcb05,wcb06 = lr_wcb.wcb06,
                                      wcb07 = lr_wcb.wcb07,wcb08 = lr_wcb.wcb08,
                                      wcb09 = lr_wcb.wcb09,wcb10 = lr_wcb.wcb10,
                                      wcb11 = lr_wcb.wcb11,wcb12 = lr_wcb.wcb12,
                                      wcb13 = lr_wcb.wcb13,wcb14 = lr_wcb.wcb14
                WHERE wcb01 = lr_wcb.wcb01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcb_file data error:",SQLCA.sqlerrd[2]," ",lr_wcb.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcb_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcc_file資料"
         LET li_count = 0
         DECLARE wcc_curs CURSOR FOR
                 SELECT * FROM patchtemp:wcc_file
         FOREACH wcc_curs INTO lr_wcc.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcc_file patchtemp FOREACH 資料時產生錯誤，wcc資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:wcc_file VALUES(lr_wcc.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:wcc_file SET wcc01 = lr_wcc.wcc01,wcc02 = lr_wcc.wcc02,
                                      wcc03 = lr_wcc.wcc03,wcc04 = lr_wcc.wcc04,
                                      wcc05 = lr_wcc.wcc05,wcc06 = lr_wcc.wcc06,
                                      wcc07 = lr_wcc.wcc07
                WHERE wcc01 = lr_wcc.wcc01 AND wcc02 = lr_wcc.wcc02
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcc_file data error:",SQLCA.sqlerrd[2]," ",lr_wcc.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcc_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcd_file資料"
         LET li_count = 0
         DECLARE wcd_curs CURSOR FOR
                 SELECT * FROM patchtemp:wcd_file
         FOREACH wcd_curs INTO lr_wcd.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcd_file patchtemp FOREACH 資料時產生錯誤，wcd資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:wcd_file VALUES(lr_wcd.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:wcd_file SET wcd01 = lr_wcd.wcd01,wcd02 = lr_wcd.wcd02,
                                      wcd03 = lr_wcd.wcd03,wcd04 = lr_wcd.wcd04,
                                      wcd05 = lr_wcd.wcd05,wcd06 = lr_wcd.wcd06,
                                      wcd07 = lr_wcd.wcd07
                WHERE wcd01 = lr_wcd.wcd01 AND wcd02 = lr_wcd.wcd02
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcd_file data error:",SQLCA.sqlerrd[2]," ",lr_wcd.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcd_file 更新完畢，共更新 ",li_count,"筆資料"
      END IF
      # 2006/09/22 ---end---
      #FUN-730071 ---start---   
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zaw_file資料"
         LET li_count = 0
         DECLARE zaw_curs CURSOR FOR
                 SELECT * FROM patchtemp:zaw_file
         FOREACH zaw_curs INTO lr_zaw.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaw_file patchtemp FOREACH 資料時產生錯誤，zaw資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zaw_file VALUES(lr_zaw.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zaw_file SET zaw01 = lr_zaw.zaw01,zaw02 = lr_zaw.zaw02,
                                      zaw03 = lr_zaw.zaw03,zaw04 = lr_zaw.zaw04,
                                      zaw05 = lr_zaw.zaw05,zaw06 = lr_zaw.zaw06,
                                      zaw07 = lr_zaw.zaw07,zaw08 = lr_zaw.zaw08,
                                      zaw09 = lr_zaw.zaw09,zaw10 = lr_zaw.zaw10,
                                      zaw11 = lr_zaw.zaw11,zaw12 = lr_zaw.zaw12,
                                      zawdate = lr_zaw.zawdate,
                                      zawgrup = lr_zaw.zawgrup,
                                      zawmodu = lr_zaw.zawmodu,
                                      zawuser = lr_zaw.zawuser
                WHERE zaw01 = lr_zaw.zaw01
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
      END IF
      #FUN-730071 ---end---   

      #No:TQC-740038 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zav_file資料"
         LET li_count = 0
         DECLARE zav_curs CURSOR FOR
                 SELECT * FROM patchtemp:zav_file
         FOREACH zav_curs INTO lr_zav.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zav_file patchtemp FOREACH 資料時產生錯誤，zav資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zav_file VALUES(lr_zav.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zav_file SET zav01 = lr_zav.zav01,zav02 = lr_zav.zav02,
                                      zav03 = lr_zav.zav03,zav04 = lr_zav.zav04,
                                      zav05 = lr_zav.zav05,zav06 = lr_zav.zav06,
                                      zav07 = lr_zav.zav07,zav08 = lr_zav.zav08,
                                      zav09 = lr_zav.zav09,zav10 = lr_zav.zav10,
                                      zav11 = lr_zav.zav11,zav12 = lr_zav.zav12,
                                      zav13 = lr_zav.zav13,zav14 = lr_zav.zav14,
                                      zav15 = lr_zav.zav15,zav16 = lr_zav.zav16,
                                      zav17 = lr_zav.zav17,zav18 = lr_zav.zav18,
                                      zav19 = lr_zav.zav19,zav20 = lr_zav.zav20,
                                      zav21 = lr_zav.zav21,zav22 = lr_zav.zav22,
                                      zav23 = lr_zav.zav23,zav24 = lr_zav.zav24
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
      END IF
      #No:TQC-740038 ---end---
      #No:FUN-740054 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zai_file資料"
         LET li_count = 0
         DECLARE zai_curs CURSOR FOR
                 SELECT * FROM patchtemp:zai_file
         FOREACH zai_curs INTO lr_zai.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zai_file patchtemp FOREACH 資料時產生錯誤，zai資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zai_file VALUES(lr_zai.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zai_file SET zai01 = lr_zai.zai01,zai02 = lr_zai.zai02,
                                      zai03 = lr_zai.zai03,zai04 = lr_zai.zai04,
                                      zai05 = lr_zai.zai05,zaiuser = lr_zai.zaiuser,
                                      zaigrup = lr_zai.zaigrup,zaimodu = lr_zai.zaimodu,
                                      zaidate = lr_zai.zaidate
                WHERE zai01 = lr_zai.zai01
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
         DECLARE zaj_curs CURSOR FOR
                 SELECT * FROM patchtemp:zaj_file
         FOREACH zaj_curs INTO lr_zaj.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaj_file patchtemp FOREACH 資料時產生錯誤，zaj資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zaj_file VALUES(lr_zaj.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zaj_file SET zaj01 = lr_zaj.zaj01,zaj02 = lr_zaj.zaj02,
                                      zaj03 = lr_zaj.zaj03,zaj04 = lr_zaj.zaj04,
                                      zaj05 = lr_zaj.zaj05,zaj06 = lr_zaj.zaj06
                WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02
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
         DECLARE zak_curs CURSOR FOR
                 SELECT * FROM patchtemp:zak_file
         FOREACH zak_curs INTO lr_zak.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zak_file patchtemp FOREACH 資料時產生錯誤，zak資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zak_file VALUES(lr_zak.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zak_file SET zak01 = lr_zak.zak01,zak02 = lr_zak.zak02,
                                      zak03 = lr_zak.zak03,zak04 = lr_zak.zak04,
                                      zak05 = lr_zak.zak05,zak06 = lr_zak.zak06
                WHERE zak01 = lr_zak.zak01
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
         DECLARE zal_curs CURSOR FOR
                 SELECT * FROM patchtemp:zal_file
         FOREACH zal_curs INTO lr_zal.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zal_file patchtemp FOREACH 資料時產生錯誤，zal資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zal_file VALUES(lr_zal.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zal_file SET zal01 = lr_zal.zal01,zal02 = lr_zal.zal02,
                                      zal03 = lr_zal.zal03,zal04 = lr_zal.zal04,
                                      zal05 = lr_zal.zal05,zal06 = lr_zal.zal06
                WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
                  AND zal03 = lr_zal.zal03
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
         DECLARE zam_curs CURSOR FOR
                 SELECT * FROM patchtemp:zam_file
         FOREACH zam_curs INTO lr_zam.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zam_file patchtemp FOREACH 資料時產生錯誤，zam資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zam_file VALUES(lr_zam.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zam_file SET zam01 = lr_zam.zam01,zam02 = lr_zam.zam02,
                                      zam03 = lr_zam.zam03,zam04 = lr_zam.zam04,
                                      zam05 = lr_zam.zam05,zam06 = lr_zam.zam06,
                                      zam07 = lr_zam.zam07,zam08 = lr_zam.zam08
                WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02
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
         DECLARE zan_curs CURSOR FOR
                 SELECT * FROM patchtemp:zan_file
         FOREACH zan_curs INTO lr_zan.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zan_file patchtemp FOREACH 資料時產生錯誤，zan資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zan_file VALUES(lr_zan.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zan_file SET zan01 = lr_zan.zan01,zan02 = lr_zan.zan02,
                                      zan03 = lr_zan.zan03,zan04 = lr_zan.zan04,
                                      zan05 = lr_zan.zan05,zan06 = lr_zan.zan06,
                                      zan07 = lr_zan.zan07
                WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02
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
         DECLARE zao_curs CURSOR FOR
                 SELECT * FROM patchtemp:zao_file
         FOREACH zao_curs INTO lr_zao.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zao_file patchtemp FOREACH 資料時產生錯誤，zao資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zao_file VALUES(lr_zao.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zao_file SET zao01 = lr_zao.zao01,zao02 = lr_zao.zao02,
                                      zao03 = lr_zao.zao03,zao04 = lr_zao.zao04
                WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
                  AND zao03 = lr_zao.zao03
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
         DECLARE zap_curs CURSOR FOR
                 SELECT * FROM patchtemp:zap_file
         FOREACH zap_curs INTO lr_zap.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zap_file patchtemp FOREACH 資料時產生錯誤，zap資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zap_file VALUES(lr_zap.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zap_file SET zap01 = lr_zap.zap01,zap02 = lr_zap.zap02,
                                      zap03 = lr_zap.zap03,zap04 = lr_zap.zap04,
                                      zap05 = lr_zap.zap05,zap06 = lr_zap.zap06
                WHERE zap01 = lr_zap.zap01
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
         DECLARE zaq_curs CURSOR FOR
                 SELECT * FROM patchtemp:zaq_file
         FOREACH zaq_curs INTO lr_zaq.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaq_file patchtemp FOREACH 資料時產生錯誤，zaq資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zaq_file VALUES(lr_zaq.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zaq_file SET zaq01 = lr_zaq.zaq01,zaq02 = lr_zaq.zaq02,
                                      zaq03 = lr_zaq.zaq03,zaq04 = lr_zaq.zaq04
                WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02
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
         DECLARE zar_curs CURSOR FOR
                 SELECT * FROM patchtemp:zar_file
         FOREACH zar_curs INTO lr_zar.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zar_file patchtemp FOREACH 資料時產生錯誤，zar資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zar_file VALUES(lr_zar.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zar_file SET zar01 = lr_zar.zar01,zar02 = lr_zar.zar02,
                                      zar03 = lr_zar.zar03,zar04 = lr_zar.zar04
                WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
                  AND zar03 = lr_zar.zar03
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
         DECLARE zas_curs CURSOR FOR
                 SELECT * FROM patchtemp:zas_file
         FOREACH zas_curs INTO lr_zas.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zas_file patchtemp FOREACH 資料時產生錯誤，zas資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zas_file VALUES(lr_zas.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zas_file SET zas01 = lr_zas.zas01,zas02 = lr_zas.zas02,
                                      zas03 = lr_zas.zas03,zas04 = lr_zas.zas04,
                                      zas05 = lr_zas.zas05,zas06 = lr_zas.zas06,
                                      zas07 = lr_zas.zas07,zas08 = lr_zas.zas08,
                                      zas09 = lr_zas.zas09,zas10 = lr_zas.zas10
                WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02
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
         DECLARE zat_curs CURSOR FOR
                 SELECT * FROM patchtemp:zat_file
         FOREACH zat_curs INTO lr_zat.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zat_file patchtemp FOREACH 資料時產生錯誤，zat資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zat_file VALUES(lr_zat.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zat_file SET zat01 = lr_zat.zat01,zat02 = lr_zat.zat02,
                                      zat03 = lr_zat.zat03,zat04 = lr_zat.zat04,
                                      zat05 = lr_zat.zat05,zat06 = lr_zat.zat06,
                                      zat07 = lr_zat.zat07,zat08 = lr_zat.zat08,
                                      zat09 = lr_zat.zat09
                WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
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
         DECLARE zau_curs CURSOR FOR
                 SELECT * FROM patchtemp:zau_file
         FOREACH zau_curs INTO lr_zau.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zau_file patchtemp FOREACH 資料時產生錯誤，zau資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds:zau_file VALUES(lr_zau.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds:zau_file SET zau01 = lr_zau.zau01,zau02 = lr_zau.zau02,
                                      zau03 = lr_zau.zau03
                WHERE zau01 = lr_zau.zau01
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
      END IF

      DISPLAY "開始更新wsm_file資料"
      LET li_count = 0
      DECLARE wsm_curs CURSOR FOR
              SELECT * FROM patchtemp:wsm_file
      FOREACH wsm_curs INTO lr_wsm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsm_file patchtemp FOREACH 資料時產生錯誤，wsm資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsm_file VALUES(lr_wsm.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsm_file SET wsm01 = lr_wsm.wsm01,wsm02 = lr_wsm.wsm02,
                                   wsmacti = lr_wsm.wsmacti, wsmdate = lr_wsm.wsmdate,
                                   wsmgrup = lr_wsm.wsmgrup, wsmmodu = lr_wsm.wsmmodu,
                                   wsmuser = lr_wsm.wsmuser
             WHERE wsm01 = lr_wsm.wsm01 AND wsm02 = lr_wsm.wsm02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsm_file data error:",SQLCA.sqlerrd[2]," ",lr_wsm.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsm_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wsn_file資料"
      LET li_count = 0
      DECLARE wsn_curs CURSOR FOR
              SELECT * FROM patchtemp:wsn_file
      FOREACH wsn_curs INTO lr_wsn.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsn_file patchtemp FOREACH 資料時產生錯誤，wsn資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsn_file VALUES(lr_wsn.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsn_file SET wsn01 = lr_wsn.wsn01,wsn02 = lr_wsn.wsn02,
                                   wsn03 = lr_wsn.wsn03,wsn04 = lr_wsn.wsn04
             WHERE wsn01 = lr_wsn.wsn01 AND wsn02 = lr_wsn.wsn02 AND wsn03 = lr_wsn.wsn03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsn_file data error:",SQLCA.sqlerrd[2]," ",lr_wsn.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsn_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wso_file資料"
      LET li_count = 0
      DECLARE wso_curs CURSOR FOR
              SELECT * FROM patchtemp:wso_file
      FOREACH wso_curs INTO lr_wso.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wso_file patchtemp FOREACH 資料時產生錯誤，wso資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wso_file VALUES(lr_wso.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wso_file SET wso01 = lr_wso.wso01,wso02 = lr_wso.wso02,
                                   wso03 = lr_wso.wso03,wso04 = lr_wso.wso04,
                                   wso05 = lr_wso.wso05
             WHERE wso01 = lr_wso.wso01 AND wso02 = lr_wso.wso02 AND wso03 = lr_wso.wso03 AND wso04 = lr_wso.wso04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wso_file data error:",SQLCA.sqlerrd[2]," ",lr_wso.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wso_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wsp_file資料"
      LET li_count = 0
      DECLARE wsp_curs CURSOR FOR
              SELECT * FROM patchtemp:wsp_file
      FOREACH wsp_curs INTO lr_wsp.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsp_file patchtemp FOREACH 資料時產生錯誤，wsp資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds:wsp_file VALUES(lr_wsp.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds:wsp_file SET wsp01 = lr_wsp.wsp01,wsp02 = lr_wsp.wsp02,
                                   wsp03 = lr_wsp.wsp03,wsp04 = lr_wsp.wsp04,
                                   wsp05 = lr_wsp.wsp05
             WHERE wsp01 = lr_wsp.wsp01 AND wsp02 = lr_wsp.wsp02 AND wsp03 = lr_wsp.wsp03 AND wsp04 = lr_wsp.wsp04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsp_file data error:",SQLCA.sqlerrd[2]," ",lr_wsp.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsp_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-740054 ---end---
   ELSE
      DISPLAY "開始更新ze_file資料"
      LET li_count = 0
      DECLARE ze_o_curs CURSOR FOR
              SELECT * FROM patchtemp.ze_file
      FOREACH ze_o_curs INTO lr_ze.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "ze_file patchtemp FOREACH 資料時產生錯誤，ze資料無更新"
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
      DECLARE zz_o_curs CURSOR FOR
              SELECT * FROM patchtemp.zz_file
      FOREACH zz_o_curs INTO lr_zz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zz_file patchtemp FOREACH 資料時產生錯誤，zz資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.zz_file VALUES(lr_zz.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds.zz_file SET zz_file.* = lr_zz.*
                WHERE zz01 = lr_zz.zz01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaz_file資料"
      LET li_count = 0
      DECLARE gaz_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gaz_file
      FOREACH gaz_o_curs INTO lr_gaz.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaz_file patchtemp FOREACH 資料時產生錯誤，gaz資料無更新"
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
              SELECT * FROM patchtemp.zm_file
      FOREACH zm_o_curs INTO lr_zm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zm_file patchtemp FOREACH 資料時產生錯誤，zm資料無更新"
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
              SELECT * FROM patchtemp.gap_file
      FOREACH gap_o_curs INTO lr_gap.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gap_file patchtemp FOREACH 資料時產生錯誤，gap資料無更新"
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
              SELECT * FROM patchtemp.gbd_file
      FOREACH gbd_o_curs INTO lr_gbd.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gbd_file patchtemp FOREACH 資料時產生錯誤，gbd資料無更新"
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
              SELECT * FROM patchtemp.gae_file
      FOREACH gae_o_curs INTO lr_gae.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gae_file patchtemp FOREACH 資料時產生錯誤，gae資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gae_file VALUES(lr_gae.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gae_file SET gae_file.* = lr_gae.*
             WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
               AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11
               AND gae12 = lr_gae.gae12
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
              SELECT * FROM patchtemp.gak_file
      FOREACH gak_o_curs INTO lr_gak.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gak_file patchtemp FOREACH 資料時產生錯誤，gak資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gak_file VALUES(lr_gak.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_gak.gak01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
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
               LET l_cmd = "insert gak_file data error:",SQLCA.sqlcode," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gal_file資料"
      LET li_count = 0
      DECLARE gal_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gal_file
      FOREACH gal_o_curs INTO lr_gal.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gal_file patchtemp FOREACH 資料時產生錯誤，gal資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gal_file VALUES(lr_gal.*)
         IF SQLCA.sqlcode THEN
            SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_gal.gal01
            LET ls_zz011 = lc_zz011
            IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
               UPDATE ds.gal_file SET gal_file.* = lr_gal.*
                WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gaq_file資料"
      LET li_count = 0
      DECLARE gaq_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gaq_file
      FOREACH gaq_o_curs INTO lr_gaq.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gaq_file patchtemp FOREACH 資料時產生錯誤，gaq資料無更新"
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
              SELECT * FROM patchtemp.gab_file
      FOREACH gab_o_curs INTO lr_gab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gab_file patchtemp FOREACH 資料時產生錯誤，gab資料無更新"
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
              SELECT * FROM patchtemp.gac_file
      FOREACH gac_o_curs INTO lr_gac.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gac_file patchtemp FOREACH 資料時產生錯誤，gac資料無更新"
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
              SELECT * FROM patchtemp.gav_file
      FOREACH gav_o_curs INTO lr_gav.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gav_file patchtemp FOREACH 資料時產生錯誤，gav資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gav_file VALUES(lr_gav.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gav_file SET gav_file.* = lr_gav.*
             WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02
               AND gav08 = lr_gav.gav08 AND gav11 = lr_gav.gav11
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
              SELECT * FROM patchtemp.gat_file
      FOREACH gat_o_curs INTO lr_gat.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "gat_file patchtemp FOREACH 資料時產生錯誤，gat資料無更新"
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
              SELECT * FROM patchtemp.wsa_file
      FOREACH wsa_o_curs INTO lr_wsa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsa_file patchtemp FOREACH 資料時產生錯誤，wsa資料無更新"
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
              SELECT * FROM patchtemp.wsb_file
      FOREACH wsb_o_curs INTO lr_wsb.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsb_file patchtemp FOREACH 資料時產生錯誤，wsb資料無更新"
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
              SELECT * FROM patchtemp.zaa_file
      FOREACH zaa_o_curs INTO lr_zaa.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zaa_file patchtemp FOREACH 資料時產生錯誤，zaa資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

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
              SELECT * FROM patchtemp.zab_file
      FOREACH zab_o_curs INTO lr_zab.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "zab_file patchtemp FOREACH 資料時產生錯誤，zab資料無更新"
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
              SELECT * FROM patchtemp.gao_file
      FOREACH gao_o_curs INTO lr_gao.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gao_file patchtemp FOREACH 資料時產生錯誤，gao資料無更新"
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


      DISPLAY "開始更新gax_file資料"
      LET li_count = 0
      DECLARE gax_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gax_file
      FOREACH gax_o_curs INTO lr_gax.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gax_file patchtemp FOREACH 資料時產生錯誤，gax資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gax_file VALUES(lr_gax.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gax_file SET gax_file.* = lr_gax.*
             WHERE gax01 = lr_gax.gax01 AND gax02 = lr_gax.gax02
               AND gax05 = lr_gax.gax05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gax_file data error:",SQLCA.sqlerrd[2]," ",lr_gax.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gax_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gba_file資料"
      LET li_count = 0
      DECLARE gba_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gba_file
      FOREACH gba_o_curs INTO lr_gba.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gba_file patchtemp FOREACH 資料時產生錯誤，gba資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gba_file VALUES(lr_gba.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gba_file SET gba_file.* = lr_gba.*
             WHERE gba01 = lr_gba.gba01 AND gba02 = lr_gba.gba02
               AND gba03 = lr_gba.gba03 AND gba04 = lr_gba.gba04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gba_file data error:",SQLCA.sqlerrd[2]," ",lr_gba.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gba_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbb_file資料"
      LET li_count = 0
      DECLARE gbb_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gbb_file
      FOREACH gbb_o_curs INTO lr_gbb.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbb_file patchtemp FOREACH 資料時產生錯誤，gbb資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gbb_file VALUES(lr_gbb.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbb_file SET gbb_file.* = lr_gbb.*
             WHERE gbb01 = lr_gbb.gbb01 AND gbb02 = lr_gbb.gbb02
               AND gbb03 = lr_gbb.gbb03 AND gbb04 = lr_gbb.gbb04
               AND gbb05 = lr_gbb.gbb05
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbb_file data error:",SQLCA.sqlerrd[2]," ",lr_gbb.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbb_file 更新完畢，共更新 ",li_count,"筆資料"


      DISPLAY "開始更新gbf_file資料"
      LET li_count = 0
      DECLARE gbf_o_curs CURSOR FOR
              SELECT * FROM patchtemp.gbf_file
      FOREACH gbf_o_curs INTO lr_gbf.*
         IF SQLCA.sqlcode THEN
	    LET l_cmd = "gbf_file patchtemp FOREACH 資料時產生錯誤，gbf資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.gbf_file VALUES(lr_gbf.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.gbf_file SET gbf_file.* = lr_gbf.*
             WHERE gbf01 = lr_gbf.gbf01 AND gbf02 = lr_gbf.gbf02
               AND gbf03 = lr_gbf.gbf03 AND gbf04 = lr_gbf.gbf04
               AND gbf06 = lr_gbf.gbf06
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gbf_file data error:",SQLCA.sqlerrd[2]," ",lr_gbf.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "gbf_file 更新完畢，共更新 ",li_count,"筆資料"


      # 2006/04/14 --start--
      IF g_ver_main NOT MATCHES '1*' THEN
         DISPLAY "開始更新zad_file資料"
         LET li_count = 0
         DECLARE zad_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.zad_file
         FOREACH zad_o_curs INTO lr_zad.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zad_file patchtemp FOREACH 資料時產生錯誤，zad資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zad_file VALUES(lr_zad.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zad_file SET zad01 = lr_zad.zad01,zad02 = lr_zad.zad02,
                                      zad03 = lr_zad.zad03,zad04 = lr_zad.zad04,
                                      zad05 = lr_zad.zad05,zad06 = lr_zad.zad06,
                                      zad07 = lr_zad.zad07,zad08 = lr_zad.zad08,
                                      zad09 = lr_zad.zad09,zad10 = lr_zad.zad10,
                                      zad11 = lr_zad.zad11
                WHERE zad01 = lr_zad.zad01 AND zad02 = lr_zad.zad02
                  AND zad03 = lr_zad.zad03 AND zad04 = lr_zad.zad04
                  AND zad05 = lr_zad.zad05 AND zad06 = lr_zad.zad06
                  AND zad07 = lr_zad.zad07 AND zad08 = lr_zad.zad08
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zad_file data error:",SQLCA.sqlerrd[2]," ",lr_zad.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "zad_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新zae_file資料"
         LET li_count = 0
         DECLARE zae_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.zae_file
         FOREACH zae_o_curs INTO lr_zae.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zae_file patchtemp FOREACH 資料時產生錯誤，zae資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zae_file VALUES(lr_zae.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zae_file SET zae01 = lr_zae.zae01,zae02 = lr_zae.zae02,
                                      zae03 = lr_zae.zae03,zae04 = lr_zae.zae04,
                                      zae05 = lr_zae.zae05,zae06 = lr_zae.zae06,
                                      zae07 = lr_zae.zae07,zae08 = lr_zae.zae08,
                                      zae09 = lr_zae.zae09,zae10 = lr_zae.zae10
                WHERE zae01 = lr_zae.zae01 AND zae04 = lr_zae.zae04
                  AND zae05 = lr_zae.zae05 AND zae08 = lr_zae.zae08
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload zae_file data error:",SQLCA.sqlerrd[2]," ",lr_zae.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "zae_file 更新完畢，共更新 ",li_count,"筆資料"
      END IF
      # 2006/04/14 ---end---


      # 2006/09/22 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新wca_file資料"
         LET li_count = 0
         DECLARE wca_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.wca_file
         FOREACH wca_o_curs INTO lr_wca.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wca_file patchtemp FOREACH 資料時產生錯誤，wca資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.wca_file VALUES(lr_wca.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.wca_file SET wca01 = lr_wca.wca01,wca02 = lr_wca.wca02,
                                      wca03 = lr_wca.wca03,wca04 = lr_wca.wca04,
                                      wca05 = lr_wca.wca05,wcaacti = lr_wca.wcaacti,
                                      wcauser = lr_wca.wcauser,wcagrup = lr_wca.wcagrup,
                                      wcamodu = lr_wca.wcamodu,wcadate = lr_wca.wcadate
                WHERE wca01 = lr_wca.wca01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wca_file data error:",SQLCA.sqlerrd[2]," ",lr_wca.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wca_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcb_file資料"
         LET li_count = 0
         DECLARE wcb_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.wcb_file
         FOREACH wcb_o_curs INTO lr_wcb.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcb_file patchtemp FOREACH 資料時產生錯誤，wcb資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.wcb_file VALUES(lr_wcb.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.wcb_file SET wcb01 = lr_wcb.wcb01,wcb02 = lr_wcb.wcb02,
                                      wcb03 = lr_wcb.wcb03,wcb04 = lr_wcb.wcb04,
                                      wcb05 = lr_wcb.wcb05,wcb06 = lr_wcb.wcb06,
                                      wcb07 = lr_wcb.wcb07,wcb08 = lr_wcb.wcb08,
                                      wcb09 = lr_wcb.wcb09,wcb10 = lr_wcb.wcb10,
                                      wcb11 = lr_wcb.wcb11,wcb12 = lr_wcb.wcb12,
                                      wcb13 = lr_wcb.wcb13,wcb14 = lr_wcb.wcb14
                WHERE wcb01 = lr_wcb.wcb01
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcb_file data error:",SQLCA.sqlerrd[2]," ",lr_wcb.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcb_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcc_file資料"
         LET li_count = 0
         DECLARE wcc_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.wcc_file
         FOREACH wcc_o_curs INTO lr_wcc.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcc_file patchtemp FOREACH 資料時產生錯誤，wcc資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.wcc_file VALUES(lr_wcc.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.wcc_file SET wcc01 = lr_wcc.wcc01,wcc02 = lr_wcc.wcc02,
                                      wcc03 = lr_wcc.wcc03,wcc04 = lr_wcc.wcc04,
                                      wcc05 = lr_wcc.wcc05,wcc06 = lr_wcc.wcc06,
                                      wcc07 = lr_wcc.wcc07
                WHERE wcc01 = lr_wcc.wcc01 AND wcc02 = lr_wcc.wcc02
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcc_file data error:",SQLCA.sqlerrd[2]," ",lr_wcc.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcc_file 更新完畢，共更新 ",li_count,"筆資料"


         DISPLAY "開始更新wcd_file資料"
         LET li_count = 0
         DECLARE wcd_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.wcd_file
         FOREACH wcd_o_curs INTO lr_wcd.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "wcd_file patchtemp FOREACH 資料時產生錯誤，wcd資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.wcd_file VALUES(lr_wcd.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.wcd_file SET wcd01 = lr_wcd.wcd01,wcd02 = lr_wcd.wcd02,
                                      wcd03 = lr_wcd.wcd03,wcd04 = lr_wcd.wcd04,
                                      wcd05 = lr_wcd.wcd05,wcd06 = lr_wcd.wcd06,
                                      wcd07 = lr_wcd.wcd07
                WHERE wcd01 = lr_wcd.wcd01 AND wcd02 = lr_wcd.wcd02
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload wcd_file data error:",SQLCA.sqlerrd[2]," ",lr_wcd.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         END FOREACH
         DISPLAY "wcd_file 更新完畢，共更新 ",li_count,"筆資料"
      END IF
      # 2006/09/22 ---end---

      #FUN-730071 ---start---   
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zaw_file資料"
         LET li_count = 0
         DECLARE zaw_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.zaw_file
         FOREACH zaw_o_curs INTO lr_zaw.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaw_file patchtemp FOREACH 資料時產生錯誤，zaw資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zaw_file VALUES(lr_zaw.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zaw_file SET zaw01 = lr_zaw.zaw01,zaw02 = lr_zaw.zaw02,
                                      zaw03 = lr_zaw.zaw03,zaw04 = lr_zaw.zaw04,
                                      zaw05 = lr_zaw.zaw05,zaw06 = lr_zaw.zaw06,
                                      zaw07 = lr_zaw.zaw07,zaw08 = lr_zaw.zaw08,
                                      zaw09 = lr_zaw.zaw09,zaw10 = lr_zaw.zaw10,
                                      zaw11 = lr_zaw.zaw11,zaw12 = lr_zaw.zaw12,
                                      zawdate = lr_zaw.zawdate,
                                      zawgrup = lr_zaw.zawgrup,
                                      zawmodu = lr_zaw.zawmodu,
                                      zawuser = lr_zaw.zawuser
                WHERE zaw01 = lr_zaw.zaw01
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
      END IF
      #FUN-730071 ---end---   

      #No:TQC-740038 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zav_file資料"
         LET li_count = 0
         DECLARE zav_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.zav_file
         FOREACH zav_o_curs INTO lr_zav.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zav_file patchtemp FOREACH 資料時產生錯誤，zav資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zav_file VALUES(lr_zav.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zav_file SET zav01 = lr_zav.zav01,zav02 = lr_zav.zav02,
                                      zav03 = lr_zav.zav03,zav04 = lr_zav.zav04,
                                      zav05 = lr_zav.zav05,zav06 = lr_zav.zav06,
                                      zav07 = lr_zav.zav07,zav08 = lr_zav.zav08,
                                      zav09 = lr_zav.zav09,zav10 = lr_zav.zav10,
                                      zav11 = lr_zav.zav11,zav12 = lr_zav.zav12,
                                      zav13 = lr_zav.zav13,zav14 = lr_zav.zav14,
                                      zav15 = lr_zav.zav15,zav16 = lr_zav.zav16,
                                      zav17 = lr_zav.zav17,zav18 = lr_zav.zav18,
                                      zav19 = lr_zav.zav19,zav20 = lr_zav.zav20,
                                      zav21 = lr_zav.zav21,zav22 = lr_zav.zav22,
                                      zav23 = lr_zav.zav23,zav24 = lr_zav.zav24
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
      END IF
      #No:TQC-740038 ---end---
      #No:FUN-740054 --start--
      IF g_ver_main = "5.0" THEN
         DISPLAY "開始更新zai_file資料"
         LET li_count = 0
         DECLARE zai_o_curs CURSOR FOR
                 SELECT * FROM patchtemp.zai_file
         FOREACH zai_o_curs INTO lr_zai.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zai_file patchtemp FOREACH 資料時產生錯誤，zai資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zai_file VALUES(lr_zai.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zai_file SET zai01 = lr_zai.zai01,zai02 = lr_zai.zai02,
                                      zai03 = lr_zai.zai03,zai04 = lr_zai.zai04,
                                      zai05 = lr_zai.zai05,zaiuser = lr_zai.zaiuser,
                                      zaigrup = lr_zai.zaigrup,zaimodu = lr_zai.zaimodu,
                                      zaidate = lr_zai.zaidate
                WHERE zai01 = lr_zai.zai01
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
                 SELECT * FROM patchtemp.zaj_file
         FOREACH zaj_o_curs INTO lr_zaj.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaj_file patchtemp FOREACH 資料時產生錯誤，zaj資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zaj_file VALUES(lr_zaj.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zaj_file SET zaj01 = lr_zaj.zaj01,zaj02 = lr_zaj.zaj02,
                                      zaj03 = lr_zaj.zaj03,zaj04 = lr_zaj.zaj04,
                                      zaj05 = lr_zaj.zaj05,zaj06 = lr_zaj.zaj06
                WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02
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
                 SELECT * FROM patchtemp.zak_file
         FOREACH zak_o_curs INTO lr_zak.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zak_file patchtemp FOREACH 資料時產生錯誤，zak資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zak_file VALUES(lr_zak.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zak_file SET zak01 = lr_zak.zak01,zak02 = lr_zak.zak02,
                                      zak03 = lr_zak.zak03,zak04 = lr_zak.zak04,
                                      zak05 = lr_zak.zak05,zak06 = lr_zak.zak06
                WHERE zak01 = lr_zak.zak01
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
                 SELECT * FROM patchtemp.zal_file
         FOREACH zal_o_curs INTO lr_zal.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zal_file patchtemp FOREACH 資料時產生錯誤，zal資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zal_file VALUES(lr_zal.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zal_file SET zal01 = lr_zal.zal01,zal02 = lr_zal.zal02,
                                      zal03 = lr_zal.zal03,zal04 = lr_zal.zal04,
                                      zal05 = lr_zal.zal05,zal06 = lr_zal.zal06
                WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
                  AND zal03 = lr_zal.zal03
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
                 SELECT * FROM patchtemp.zam_file
         FOREACH zam_o_curs INTO lr_zam.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zam_file patchtemp FOREACH 資料時產生錯誤，zam資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zam_file VALUES(lr_zam.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zam_file SET zam01 = lr_zam.zam01,zam02 = lr_zam.zam02,
                                      zam03 = lr_zam.zam03,zam04 = lr_zam.zam04,
                                      zam05 = lr_zam.zam05,zam06 = lr_zam.zam06,
                                      zam07 = lr_zam.zam07,zam08 = lr_zam.zam08
                WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02
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
                 SELECT * FROM patchtemp.zan_file
         FOREACH zan_o_curs INTO lr_zan.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zan_file patchtemp FOREACH 資料時產生錯誤，zan資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zan_file VALUES(lr_zan.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zan_file SET zan01 = lr_zan.zan01,zan02 = lr_zan.zan02,
                                      zan03 = lr_zan.zan03,zan04 = lr_zan.zan04,
                                      zan05 = lr_zan.zan05,zan06 = lr_zan.zan06,
                                      zan07 = lr_zan.zan07
                WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02
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
                 SELECT * FROM patchtemp.zao_file
         FOREACH zao_o_curs INTO lr_zao.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zao_file patchtemp FOREACH 資料時產生錯誤，zao資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zao_file VALUES(lr_zao.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zao_file SET zao01 = lr_zao.zao01,zao02 = lr_zao.zao02,
                                      zao03 = lr_zao.zao03,zao04 = lr_zao.zao04
                WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
                  AND zao03 = lr_zao.zao03
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
                 SELECT * FROM patchtemp.zap_file
         FOREACH zap_o_curs INTO lr_zap.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zap_file patchtemp FOREACH 資料時產生錯誤，zap資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zap_file VALUES(lr_zap.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zap_file SET zap01 = lr_zap.zap01,zap02 = lr_zap.zap02,
                                      zap03 = lr_zap.zap03,zap04 = lr_zap.zap04,
                                      zap05 = lr_zap.zap05,zap06 = lr_zap.zap06
                WHERE zap01 = lr_zap.zap01
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
                 SELECT * FROM patchtemp.zaq_file
         FOREACH zaq_o_curs INTO lr_zaq.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zaq_file patchtemp FOREACH 資料時產生錯誤，zaq資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zaq_file VALUES(lr_zaq.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zaq_file SET zaq01 = lr_zaq.zaq01,zaq02 = lr_zaq.zaq02,
                                      zaq03 = lr_zaq.zaq03,zaq04 = lr_zaq.zaq04
                WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02
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
                 SELECT * FROM patchtemp.zar_file
         FOREACH zar_o_curs INTO lr_zar.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zar_file patchtemp FOREACH 資料時產生錯誤，zar資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zar_file VALUES(lr_zar.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zar_file SET zar01 = lr_zar.zar01,zar02 = lr_zar.zar02,
                                      zar03 = lr_zar.zar03,zar04 = lr_zar.zar04
                WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
                  AND zar03 = lr_zar.zar03
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
                 SELECT * FROM patchtemp.zas_file
         FOREACH zas_o_curs INTO lr_zas.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zas_file patchtemp FOREACH 資料時產生錯誤，zas資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zas_file VALUES(lr_zas.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zas_file SET zas01 = lr_zas.zas01,zas02 = lr_zas.zas02,
                                      zas03 = lr_zas.zas03,zas04 = lr_zas.zas04,
                                      zas05 = lr_zas.zas05,zas06 = lr_zas.zas06,
                                      zas07 = lr_zas.zas07,zas08 = lr_zas.zas08,
                                      zas09 = lr_zas.zas09,zas10 = lr_zas.zas10
                WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02
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
                 SELECT * FROM patchtemp.zat_file
         FOREACH zat_o_curs INTO lr_zat.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zat_file patchtemp FOREACH 資料時產生錯誤，zat資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zat_file VALUES(lr_zat.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zat_file SET zat01 = lr_zat.zat01,zat02 = lr_zat.zat02,
                                      zat03 = lr_zat.zat03,zat04 = lr_zat.zat04,
                                      zat05 = lr_zat.zat05,zat06 = lr_zat.zat06,
                                      zat07 = lr_zat.zat07,zat08 = lr_zat.zat08,
                                      zat09 = lr_zat.zat09
                WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
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
                 SELECT * FROM patchtemp.zau_file
         FOREACH zau_o_curs INTO lr_zau.*
            IF SQLCA.sqlcode THEN
               LET l_cmd = "zau_file patchtemp FOREACH 資料時產生錯誤，zau資料無更新"
               CALL gc_channel.write(l_cmd)
               EXIT FOREACH
            END IF

            INSERT INTO ds.zau_file VALUES(lr_zau.*)
            IF SQLCA.sqlcode THEN
               UPDATE ds.zau_file SET zau01 = lr_zau.zau01,zau02 = lr_zau.zau02,
                                      zau03 = lr_zau.zau03
                WHERE zau01 = lr_zau.zau01
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
      END IF

      DISPLAY "開始更新wsm_file資料"
      LET li_count = 0
      DECLARE wsm_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsm_file
      FOREACH wsm_o_curs INTO lr_wsm.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsm_file patchtemp FOREACH 資料時產生錯誤，wsm資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wsm_file VALUES(lr_wsm.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsm_file SET wsm01 = lr_wsm.wsm01,wsm02 = lr_wsm.wsm02,
                                   wsmacti = lr_wsm.wsmacti, wsmdate = lr_wsm.wsmdate,
                                   wsmgrup = lr_wsm.wsmgrup, wsmmodu = lr_wsm.wsmmodu,
                                   wsmuser = lr_wsm.wsmuser
             WHERE wsm01 = lr_wsm.wsm01 AND wsm02 = lr_wsm.wsm02
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsm_file data error:",SQLCA.sqlerrd[2]," ",lr_wsm.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsm_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wsn_file資料"
      LET li_count = 0
      DECLARE wsn_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsn_file
      FOREACH wsn_o_curs INTO lr_wsn.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsn_file patchtemp FOREACH 資料時產生錯誤，wsn資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wsn_file VALUES(lr_wsn.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsn_file SET wsn01 = lr_wsn.wsn01,wsn02 = lr_wsn.wsn02,
                                   wsn03 = lr_wsn.wsn03,wsn04 = lr_wsn.wsn04
             WHERE wsn01 = lr_wsn.wsn01 AND wsn02 = lr_wsn.wsn02 AND wsn03 = lr_wsn.wsn03
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsn_file data error:",SQLCA.sqlerrd[2]," ",lr_wsn.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsn_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wso_file資料"
      LET li_count = 0
      DECLARE wso_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wso_file
      FOREACH wso_o_curs INTO lr_wso.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wso_file patchtemp FOREACH 資料時產生錯誤，wso資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wso_file VALUES(lr_wso.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wso_file SET wso01 = lr_wso.wso01,wso02 = lr_wso.wso02,
                                   wso03 = lr_wso.wso03,wso04 = lr_wso.wso04,
                                   wso05 = lr_wso.wso05
             WHERE wso01 = lr_wso.wso01 AND wso02 = lr_wso.wso02 AND wso03 = lr_wso.wso03 AND wso04 = lr_wso.wso04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wso_file data error:",SQLCA.sqlerrd[2]," ",lr_wso.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wso_file 更新完畢，共更新 ",li_count,"筆資料"

      DISPLAY "開始更新wsp_file資料"
      LET li_count = 0
      DECLARE wsp_o_curs CURSOR FOR
              SELECT * FROM patchtemp.wsp_file
      FOREACH wsp_o_curs INTO lr_wsp.*
         IF SQLCA.sqlcode THEN
            LET l_cmd = "wsp_file patchtemp FOREACH 資料時產生錯誤，wsp資料無更新"
            CALL gc_channel.write(l_cmd)
            EXIT FOREACH
         END IF

         INSERT INTO ds.wsp_file VALUES(lr_wsp.*)
         IF SQLCA.sqlcode THEN
            UPDATE ds.wsp_file SET wsp01 = lr_wsp.wsp01,wsp02 = lr_wsp.wsp02,
                                   wsp03 = lr_wsp.wsp03,wsp04 = lr_wsp.wsp04,
                                   wsp05 = lr_wsp.wsp05
             WHERE wsp01 = lr_wsp.wsp01 AND wsp02 = lr_wsp.wsp02 AND wsp03 = lr_wsp.wsp03 AND wsp04 = lr_wsp.wsp04
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload wsp_file data error:",SQLCA.sqlerrd[2]," ",lr_wsp.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      END FOREACH
      DISPLAY "wsp_file 更新完畢，共更新 ",li_count,"筆資料"
      #No:FUN-740054 ---end---
   END IF

   IF NOT l_result THEN
      LET l_cmd = ""
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "zz_file,zm_file,gak_file,gal_file上述幾個table若資料無法LOAD"
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "可能客戶端已更改成客製資料, 請手動查看是否需更新"
      CALL gc_channel.write(l_cmd)
   END IF

   CALL gc_channel.close()
END MAIN
