##############################################################
#..................PACK DATA
#.................:080121 by Mandy #p_zl Action "GP Maintain Data" add item "S"
#.................:081104 by saki  #p_zl add wsr_file,wss_file,wst_file,wgf_file
#.................:081128 by saki  #FUN-8C0005 add wsd_file--wsi_file
#.................:081216 by saki  #FUN-8C0067 add wah_file--waj_file,waa_file--wac_file
#.................:090318 by Vicky #FUN-930099 modify path /u3 => /u2
# Modify..........: No:FUN-950103 09/06/08 By joyce alter table list
# Modify..........: No:FUN-960050 09/07/07 By joyce add wad_file,wae_file,wan_file
# Modify..........: No:FUN-A10136 10/03/01 By joyce modify for GP 5.2
# Modify..........: No:FUN-A30105 10/03/25 By joyce add gee_file
# Modify..........: No:FUN-A60053 10/07/27 By joyce add zta_file
# Modify..........: No:FUN-B60112 11/07/23 By joyce chver cut for 5.3
##############################################################


DATABASE ds
 
   DEFINE   g_language   VARCHAR(1)
   DEFINE   l_gaz03      LIKE gaz_file.gaz03
   DEFINE   p_zl08       VARCHAR(10),
            p_zl09       VARCHAR(7)
   DEFINE   l_sql        STRING
   DEFINE   l_syc        DYNAMIC ARRAY OF RECORD
               syc03     VARCHAR(1),
               syc04     VARCHAR(1),
               syc05     VARCHAR(10),
               syc06     VARCHAR(50),
               syc07     VARCHAR(50)
                         END RECORD
   DEFINE   lw_zl08      DYNAMIC ARRAY OF VARCHAR(10)
   DEFINE   li_i         INTEGER
   DEFINE   l_cnt        INTEGER
   DEFINE   l_cnt2       INTEGER
   DEFINE   li_count     INTEGER
   DEFINE   lr_ze        DYNAMIC ARRAY OF RECORD LIKE ze_file.*
   DEFINE   lr_zz        DYNAMIC ARRAY OF RECORD LIKE zz_file.*
   DEFINE   lr_zm        DYNAMIC ARRAY OF RECORD LIKE zm_file.*
   DEFINE   lr_gap       DYNAMIC ARRAY OF RECORD LIKE gap_file.*
   DEFINE   lr_gbd       DYNAMIC ARRAY OF RECORD LIKE gbd_file.*
   DEFINE   lr_gaz       DYNAMIC ARRAY OF RECORD LIKE gaz_file.*
   DEFINE   lr_gao       DYNAMIC ARRAY OF RECORD LIKE gao_file.*
   DEFINE   lr_gae       DYNAMIC ARRAY OF RECORD LIKE gae_file.*
   DEFINE   lr_gav       DYNAMIC ARRAY OF RECORD LIKE gav_file.*
   DEFINE   lr_gak       DYNAMIC ARRAY OF RECORD LIKE gak_file.*
   DEFINE   lr_gal       DYNAMIC ARRAY OF RECORD LIKE gal_file.*
   DEFINE   lr_gaq       DYNAMIC ARRAY OF RECORD LIKE gaq_file.*
   DEFINE   lr_gat       DYNAMIC ARRAY OF RECORD LIKE gat_file.*
   DEFINE   lr_gab       DYNAMIC ARRAY OF RECORD LIKE gab_file.*
   DEFINE   lr_gac       DYNAMIC ARRAY OF RECORD LIKE gac_file.*
   DEFINE   lr_wsa       DYNAMIC ARRAY OF RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       DYNAMIC ARRAY OF RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       DYNAMIC ARRAY OF RECORD LIKE zaa_file.*
   DEFINE   lr_zab       DYNAMIC ARRAY OF RECORD LIKE zab_file.*
   # 2005/10/03 --start-- By saki 增加Table
   DEFINE   lr_gax       DYNAMIC ARRAY OF RECORD LIKE gax_file.*
   DEFINE   lr_gba       DYNAMIC ARRAY OF RECORD LIKE gba_file.*
   DEFINE   lr_gbb       DYNAMIC ARRAY OF RECORD LIKE gbb_file.*
   DEFINE   lr_gbf       DYNAMIC ARRAY OF RECORD LIKE gbf_file.*
   DEFINE   lc_zaa08     LIKE zaa_file.zaa08
   # 2005/10/03 ---end---
   # 2006/04/14 --start-- By saki 增加Table
   DEFINE   lr_zad       DYNAMIC ARRAY OF RECORD LIKE zad_file.*
#   DEFINE   lr_zad       DYNAMIC ARRAY OF RECORD
#               zad01     VARCHAR(10),            #程式代號
#               zad02     SMALLINT,               #序號
#               zad03     VARCHAR(1),             #語言別
#               zad04     VARCHAR(10),            #使用者
#               zad05     VARCHAR(1),             #客製否
#               zad06     VARCHAR(20),            #報表列印的樣板
#               zad07     VARCHAR(10),            #權限類別
#               zad08     SMALLINT,               #報表聯查序號
#               zad09     VARCHAR(1),             #報表聯查類型
#               zad10     VARCHAR(10),            #報表聯查內容
#               zad11     VARCHAR(255)
#                         END RECORD
   DEFINE   lr_zae       DYNAMIC ARRAY OF RECORD LIKE zae_file.*
#   DEFINE   lr_zae       DYNAMIC ARRAY OF RECORD
#               zae01     VARCHAR(10),            #報表連查sql 代號
#               zae02     VARCHAR(30),            #代號說明
#               zae03     VARCHAR(255),           #sql內容
#               zae04     SMALLINT,               #序號
#               zae05     VARCHAR(1),             #語言別
#               zae06     VARCHAR(20),            #欄位代號
#               zae07     VARCHAR(60),            #欄位說明
#               zae08     SMALLINT,               #報表下階聯查序號
#               zae09     VARCHAR(1),             #報表下階聯查類型 1:程式代號 2:sql代號
#               zae10     VARCHAR(10)             #報表下階連查內容
#                         END RECORD

   DEFINE   lc_zad10     VARCHAR(10)
   # 2006/04/14 ---end---
   # 2006/09/22 --start-- By saki 增加Table
   DEFINE   lr_wca       DYNAMIC ARRAY OF RECORD LIKE wca_file.*
#   DEFINE   lr_wca       DYNAMIC ARRAY OF RECORD
#               wca01     VARCHAR(10),            #程式代號
#               wca02     VARCHAR(1),             #是否為 hard code 程式
#               wca03     VARCHAR(1),             #no use
#               wca04     VARCHAR(1),             #no use
#               wca05     VARCHAR(1),             #no use
#               wcaacti   VARCHAR(1),             #資料有效碼
#               wcauser   VARCHAR(10),            #資料所有者
#               wcagrup   VARCHAR(6),             #資料所有群
#               wcamodu   VARCHAR(10),            #資料更改者
#               wcadate   DATE                    #最近修改日
#                         END RECORD
   DEFINE   lr_wcb       DYNAMIC ARRAY OF RECORD LIKE wcb_file.*
#   DEFINE   lr_wcb       DYNAMIC ARRAY OF RECORD
#               wcb01     VARCHAR(10),            #程式代號
#               wcb02     VARCHAR(15),            #程式使用單頭檔
#               wcb03     VARCHAR(20),            #單頭檔 key 值欄位1
#               wcb04     VARCHAR(20),            #單頭檔 key 值欄位2
#               wcb05     VARCHAR(20),            #單頭檔 key 值欄位3
#               wcb06     VARCHAR(20),            #單頭檔 key 值欄位4
#               wcb07     VARCHAR(20),            #單頭檔 key 值欄位5
#               wcb08     VARCHAR(20),            #單頭檔確認碼欄位
#               wcb09     VARCHAR(20),            #單頭檔spc拋轉碼欄位
#               wcb10     VARCHAR(1),             #no use
#               wcb11     VARCHAR(1),             #no use
#               wcb12     VARCHAR(1),             #no use
#               wcb13     VARCHAR(1),             #no use
#               wcb14     VARCHAR(1)              #no use
#                         END RECORD
   DEFINE   lr_wcc       DYNAMIC ARRAY OF RECORD LIKE wcc_file.*
#   DEFINE   lr_wcc       DYNAMIC ARRAY OF RECORD
#               wcc01     VARCHAR(10),            #程式代號
#               wcc02     VARCHAR(20),            #欄位名稱
#               wcc03     VARCHAR(1),             #更新否
#               wcc04     VARCHAR(1),             #no use
#               wcc05     VARCHAR(1),             #no use
#               wcc06     VARCHAR(1),             #no use
#               wcc07     VARCHAR(1)              #no use
#                         END RECORD
   DEFINE   lr_wcd       DYNAMIC ARRAY OF RECORD LIKE wcd_file.*

#   DEFINE   lr_wcd       DYNAMIC ARRAY OF RECORD
#               wcd01     VARCHAR(15),            #檔案代碼
#               wcd02     VARCHAR(20),            #欄位名稱
#               wcd03     VARCHAR(1),             #no use
#               wcd04     VARCHAR(1),             #no use
#               wcd05     VARCHAR(1),             #no use
#               wcd06     VARCHAR(1),             #no use
#               wcd07     VARCHAR(1)              #no use
#                         END RECORD
   # 2006/09/22 ---end---
   DEFINE   lr_zaw       DYNAMIC ARRAY OF RECORD LIKE zaw_file.*
#   DEFINE   lr_zaw       DYNAMIC ARRAY OF RECORD
#               zaw01     VARCHAR(10),            #程式代號
#               zaw02     VARCHAR(20),            #樣板代號
#               zaw03     VARCHAR(1),             #客製否
#               zaw04     VARCHAR(10),            #權限類別
#               zaw05     VARCHAR(10),            #使用者
#               zaw06     VARCHAR(1),             #語言別
#               zaw07     SMALLINT,               #序號
#               zaw08     VARCHAR(20),            #cr樣板名稱(.rpt)
#               zaw09     VARCHAR(50),            #cr樣板說明
#               zaw10     VARCHAR(1),             #no use
#               zaw11     VARCHAR(1),             #no use
#               zaw12     VARCHAR(1),             #no use
#               zawdate   DATE,                   #最近修改日
#               zawgrup   VARCHAR(6),             #資料所有部門
#               zawmodu   VARCHAR(10),            #資料修改者
#               zawuser   VARCHAR(10)             #
#                         END RECORD  
   DEFINE   lr_zav       DYNAMIC ARRAY OF RECORD LIKE zav_file.*
#   DEFINE   lr_zav       DYNAMIC ARRAY OF RECORD
#               zav01     VARCHAR(1),             #p_per/p_query
#               zav02     VARCHAR(40),            #畫面代碼
#               zav03     VARCHAR(20),            #欄位代碼
#               zav04     VARCHAR(1),             #客製碼
#               zav05     VARCHAR(10),            #行業別代碼
#               zav06     VARCHAR(1),             #是否需要CONSTRUCT
#               zav07     VARCHAR(255),           #額外查詢條件
#               zav08     VARCHAR(5),             #預設值自選或固定值
#               zav09     VARCHAR(50),            #預設值1
#               zav10     VARCHAR(50),            #預設值2
#               zav11     VARCHAR(50),            #預設值3
#               zav12     VARCHAR(50),            #預設值4
#               zav13     VARCHAR(50),            #預設值5
#               zav14     VARCHAR(9),             #參數自選或固定值
#               zav15     VARCHAR(50),            #參數1
#               zav16     VARCHAR(50),            #參數2
#               zav17     VARCHAR(50),            #參數3
#               zav18     VARCHAR(50),            #參數4
#               zav19     VARCHAR(50),            #參數5
#               zav20     VARCHAR(50),            #參數6
#               zav21     VARCHAR(50),            #參數7
#               zav22     VARCHAR(50),            #參數8
#               zav23     VARCHAR(50),            #參數9
#               zav24     VARCHAR(1)              #input/construct用
#                         END RECORD
   DEFINE   lr_zai       DYNAMIC ARRAY OF RECORD LIKE zai_file.*
#   DEFINE   lr_zai       DYNAMIC ARRAY OF RECORD
#               zai01     VARCHAR(40),            #查詢單id
#               zai02     VARCHAR(100),           #查詢單名稱
#               zai03     VARCHAR(255),           #說明
#               zaiuser   VARCHAR(10),            #資料所有者
#               zaigrup   VARCHAR(6),             #資料所有群
#               zaimodu   VARCHAR(10),            #資料更改者
#               zaidate   DATE,                   #最近修改日
#               zai04     VARCHAR(1),             #查詢報表時是否需輸入查詢條件
#               zai05     VARCHAR(1)              #客製否
#                         END RECORD
   DEFINE   lr_zaj       DYNAMIC ARRAY OF RECORD LIKE zaj_file.*
#   DEFINE   lr_zaj       DYNAMIC ARRAY OF RECORD
#               zaj01     VARCHAR(40),            #查詢單id
#               zaj02     SMALLINT,               #執行順序
#               zaj03     VARCHAR(1),             #啟動否
#               zaj04     VARCHAR(1),             #來源類別
#               zaj05     VARCHAR(255),           #執行命令
#               zaj06     VARCHAR(255)            #備註
#                         END RECORD
   DEFINE   lr_zak       DYNAMIC ARRAY OF RECORD LIKE zak_file.*
#   DEFINE   lr_zak       DYNAMIC ARRAY OF RECORD
#               zak01     VARCHAR(40),            #查詢單id
#               zak02     VARCHAR(2000),          #sql命令
#               zak03     VARCHAR(2000),          #table list
#               zak04     VARCHAR(2000),          #field list
#               zak05     VARCHAR(2000),          #where 條件
#               zak06     VARCHAR(1)              #SQL是否由Wizard產生
#                         END RECORD
   DEFINE   lr_zal       DYNAMIC ARRAY OF RECORD LIKE zal_file.*
#   DEFINE   lr_zal       DYNAMIC ARRAY OF RECORD
#               zal01     VARCHAR(40),            #查詢單id                               */
#               zal02     SMALLINT,               #序號                                   */
#               zal03     VARCHAR(1),             #語言別                                 */
#               zal04     VARCHAR(60),            #欄位代號                               */
#               zal05     VARCHAR(40),            #顯示名稱                               */
#               zal06     VARCHAR(255)            #備註                                   */
#                         END RECORD
   DEFINE   lr_zam        DYNAMIC ARRAY OF RECORD LIKE zam_file.*
#   DEFINE   lr_zam       DYNAMIC ARRAY OF RECORD
#               zam01     VARCHAR(40),            #查詢單id                               */
#               zam02     SMALLINT,               #序號                                   */
#               zam03     VARCHAR(1),             #group否                                */
#               zam04     VARCHAR(1),             #排序否                                 */
#               zam05     SMALLINT,               #排序順序                               */
#               zam06     VARCHAR(255),           #備註                                   */
#               zam07     VARCHAR(1),             #是否BY Group跳頁                       */
#               zam08     VARCHAR(1)              #排序方式                               */
#                         END RECORD
   DEFINE   lr_zan       DYNAMIC ARRAY OF RECORD LIKE zan_file.*
#   DEFINE   lr_zan       DYNAMIC ARRAY OF RECORD
#               zan01     VARCHAR(40),            #查詢單id                               */
#               zan02     SMALLINT,               #序號                                   */
#               zan03     VARCHAR(1),             #計算式-aggr                            */
#               zan04     VARCHAR(1),             #依group欄位                            */
#               zan05     VARCHAR(40),            #group欄位序                            */
#               zan06     VARCHAR(255),           #備註                                   */
#               zan07     VARCHAR(1)              #顯示方式                               */
#                         END RECORD
   DEFINE   lr_zao       DYNAMIC  ARRAY OF RECORD LIKE zao_file.*
#   DEFINE   lr_zao       DYNAMIC ARRAY OF RECORD
#               zao01     VARCHAR(40),            #查詢單id                               */
#               zao02     VARCHAR(1),             #layout 項目                            */
#               zao03     VARCHAR(1),             #輸入格式                               */
#               zao04     VARCHAR(1)              #執行否                                 */
#                         END RECORD
   DEFINE   lr_zap       DYNAMIC ARRAY OF RECORD LIKE zap_file.*
#   DEFINE   lr_zap       DYNAMIC ARRAY OF RECORD
#               zap01     VARCHAR(40),            #查詢單id                               */
#               zap02     SMALLINT,               #page length                            */
#               zap03     SMALLINT,               #top margin                             */
#               zap04     SMALLINT,               #left margin                            */
#               zap05     SMALLINT,               #bottom margin                          */
#               zap06     INTEGER                 #報表最大查詢筆數                       */
#                         END RECORD
   DEFINE   lr_zaq       DYNAMIC ARRAY OF RECORD LIKE zaq_file.*
#   DEFINE   lr_zaq       DYNAMIC ARRAY OF RECORD
#               zaq01     VARCHAR(40),            #查詢單ID                               */
#               zaq02     VARCHAR(15),            #檔案代碼                               */
#               zaq03     VARCHAR(1),             #outer                                  */
#               zaq04     SMALLINT                #序號                                   */
#                         END RECORD
   DEFINE   lr_zar       DYNAMIC ARRAY OF RECORD LIKE zar_file.*
#   DEFINE   lr_zar       DYNAMIC ARRAY OF RECORD
#               zar01     VARCHAR(40),            #查詢單id                               */
#               zar02     VARCHAR(15),            #檔案代碼                               */
#               zar03     VARCHAR(20),            #欄位代碼                               */
#               zar04     SMALLINT                #序號                                   */
#                         END RECORD
   DEFINE   lr_zas       DYNAMIC ARRAY OF RECORD LIKE zas_file.*
#   DEFINE   lr_zas       DYNAMIC ARRAY OF RECORD
#               zas01     VARCHAR(40),            #查詢單id                               */
#               zas02     SMALLINT,               #條件式序號                             */
#               zas03     VARCHAR(5),             #(                                      */
#               zas04     VARCHAR(15),            #檔案代碼                               */
#               zas05     VARCHAR(20),            #欄位代碼                               */
#               zas06     VARCHAR(5),             #條件式                                 */
#               zas07     VARCHAR(20),            #檔案代碼                               */
#               zas08     VARCHAR(50),            #欄位代碼/數值                          */
#               zas09     VARCHAR(5),             #)                                      */
#               zas10     VARCHAR(1)              #or/and                                 */
#                         END RECORD
   DEFINE   lr_zat       DYNAMIC ARRAY OF RECORD LIKE zat_file.*
#   DEFINE   lr_zat       DYNAMIC ARRAY OF RECORD
#               zat01     VARCHAR(40),            #查詢單id                               */
#               zat02     DECIMAL(5,0),           #序號                                   */
#               zat03     VARCHAR(1),             #列印顯示設定                           */
#               zat04     SMALLINT,               #查詢視窗顯示順序                       */
#               zat05     VARCHAR(1),             #開窗(qbe)                              */
#               zat06     VARCHAR(20),            #查詢程式代碼                           */
#               zat07     VARCHAR(1),             #小數位設定                             */
#               zat08     VARCHAR(1),             #欄位屬性                               */
#               zat09     VARCHAR(20)             #幣別欄位/小數位                        */
#                         END RECORD
   DEFINE   lr_zau       DYNAMIC ARRAY OF RECORD LIKE zau_file.*
#   DEFINE   lr_zau       DYNAMIC ARRAY OF RECORD
#               zau01     VARCHAR(40),            #查詢單id                               */
#               zau02     VARCHAR(20),            #資料所有者欄位                         */
#               zau03     VARCHAR(20)             #資料群組欄位                           */
#                         END RECORD                                                  
   DEFINE   lr_zay       DYNAMIC ARRAY OF RECORD LIKE zay_file.*
#   DEFINE   lr_zay       DYNAMIC ARRAY OF RECORD 
#               zay01     VARCHAR(40),
#               zay02     SMALLINT,
#               zay03     VARCHAR(1),
#               zay04     VARCHAR(1),
#               zay05     VARCHAR(40),
#               zay06     VARCHAR(1),
#               zay07     VARCHAR(80)
#                         END RECORD 
   DEFINE   lr_wsm       DYNAMIC ARRAY OF RECORD LIKE wsm_file.*
   DEFINE   lr_wsn       DYNAMIC ARRAY OF RECORD LIKE wsn_file.*
   DEFINE   lr_wso       DYNAMIC ARRAY OF RECORD LIKE wso_file.*
   DEFINE   lr_wsp       DYNAMIC ARRAY OF RECORD LIKE wsp_file.*
   #081104 --start--
   DEFINE   lr_wsr       DYNAMIC ARRAY OF RECORD LIKE wsr_file.*
   DEFINE   lr_wss       DYNAMIC ARRAY OF RECORD LIKE wss_file.*
   DEFINE   lr_wst       DYNAMIC ARRAY OF RECORD LIKE wst_file.*
   DEFINE   lr_wgf       DYNAMIC ARRAY OF RECORD LIKE wgf_file.*
   #081104 ---end---
   #No:FUN-8C0005 --start--
   DEFINE   lr_wsd       DYNAMIC ARRAY OF RECORD LIKE wsd_file.*
   DEFINE   lr_wse       DYNAMIC ARRAY OF RECORD LIKE wse_file.*
   DEFINE   lr_wsf       DYNAMIC ARRAY OF RECORD LIKE wsf_file.*
   DEFINE   lr_wsg       DYNAMIC ARRAY OF RECORD LIKE wsg_file.*
   DEFINE   lr_wsh       DYNAMIC ARRAY OF RECORD LIKE wsh_file.*
   DEFINE   lr_wsi       DYNAMIC ARRAY OF RECORD LIKE wsi_file.*
   #No:FUN-8C0005 ---end---
   #No:FUN-8C0067 --start--
   DEFINE   lr_wah       DYNAMIC ARRAY OF RECORD LIKE wah_file.*
   DEFINE   lr_wai       DYNAMIC ARRAY OF RECORD LIKE wai_file.*
   DEFINE   lr_waj       DYNAMIC ARRAY OF RECORD LIKE waj_file.*
   DEFINE   lr_waa       DYNAMIC ARRAY OF RECORD LIKE waa_file.*
   DEFINE   lr_wab       DYNAMIC ARRAY OF RECORD LIKE wab_file.*
   DEFINE   lr_wac       DYNAMIC ARRAY OF RECORD LIKE wac_file.*
   #No:FUN-8C0067 ---end---
   # No:FUN-960050 ---start---
   DEFINE   lr_wad       DYNAMIC ARRAY OF RECORD LIKE wad_file.*
   DEFINE   lr_wae       DYNAMIC ARRAY OF RECORD LIKE wae_file.*
   DEFINE   lr_wan       DYNAMIC ARRAY OF RECORD LIKE wan_file.*
   # No:FUN-960050 --- end ---
   DEFINE   lr_gee       DYNAMIC ARRAY OF RECORD LIKE gee_file.*     # No:FUN-A30105
   DEFINE   lr_zta       DYNAMIC ARRAY OF RECORD LIKE zta_file.*     # No:FUN-A60053
   DEFINE   lc_channel   base.Channel
   DEFINE   lc_czl       base.Channel
   DEFINE   l_tempdir    STRING
   DEFINE   l_cmd        STRING
   DEFINE   lr_str       STRING
   DEFINE   lr_syc       STRING
   DEFINE   lt_syc       base.StringTokenizer    
   DEFINE   g_bug_flag   SMALLINT                    
   DEFINE   g_ver_main   VARCHAR(3)
   DEFINE   g_zae_where  STRING  
   DEFINE   g_zae01      DYNAMIC ARRAY OF VARCHAR(10)  
   DEFINE   g_zae_cnt    SMALLINT         
                    
   
   

MAIN 
 
   WHENEVER ERROR CONTINUE
  
   LET l_cmd = "cd /u53/tiptop/ds4gl2/bin "   # No:FUN-A10136
   RUN l_cmd
#  RUN "patchtemp.sh"   # No:FUN-A10136
#  DISPLAY "Create patchtemp ok !"   # No:FUN-A10136
   LET l_tempdir = FGL_GETENV("TEMPDIR")
   LET lc_channel = base.Channel.create()
   LET l_cmd = l_tempdir,"/tm_syc.tmp"        #FUN-930099 modify tempdir path
   CALL lc_channel.openFile(l_cmd,"r")
   LET g_bug_flag = 0
   LET g_ver_main = '5.3'      #FUN-930099 5.1=>5.2   # No:FUN-B60112
   LET g_language = '1'


   
   LET li_i = 1
   WHILE lc_channel.read(lr_str)
   #    LET lr_str = lc_channel.readLine()
       LET lt_syc = base.StringTokenizer.createExt(lr_str,",","|",1)
       LET l_syc[li_i].syc03 = lt_syc.nextToken() 
       LET l_syc[li_i].syc04 = lt_syc.nextToken()
       LET l_syc[li_i].syc05 = lt_syc.nextToken()
       LET l_syc[li_i].syc06 = lt_syc.nextToken()
       LET l_syc[li_i].syc07 = lt_syc.nextToken()
       LET li_i = li_i + 1
   END WHILE      
   CALL l_syc.deleteElement(li_i)
   CALL lc_channel.close() 

#   LET lc_channel = base.Channel.create()
#   LET l_cmd = "/u7/out3/tm_zl08.tmp"
#   CALL lc_channel.openFile(l_cmd,"r")   
   
#   LET li_i = 1
#   WHILE lc_channel.read(lr_str)
#      LET lw_zl08[li_i] = lr_str
#      LET li_i = li_i + 1
#   END WHILE 
#   CALL lw_zl08.deleteElement(li_i)
#   CALL lc_channel.close()
   
       
#   CALL insert_pzs()  
   
   FOR li_i = 1 TO l_syc.getLength()     
       IF l_syc[li_i].syc04 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  此筆資料中table狀態不明"
       END IF
       IF l_syc[li_i].syc06 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  ",l_syc[li_i].syc04 CLIPPED,":資料主key值null,無法篩選資料"
          CONTINUE FOR
       END IF
       IF l_syc[li_i].syc03 IS NULL THEN
          DISPLAY "Bug No:",p_zl08 CLIPPED,"  ",l_syc[li_i].syc05 CLIPPED,": insert或delete動作不明"
          CONTINUE FOR
       END IF
       
    #  DATABASE ds   # No:FUN-A10136
       IF l_syc[li_i].syc03 = "I" THEN
          CASE l_syc[li_i].syc04
             WHEN "1"
                LET l_sql = "SELECT COUNT(*) FROM ze_file WHERE ze01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "2"
                LET l_sql = "SELECT COUNT(*) FROM zz_file WHERE zz01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "3"
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT COUNT(*) FROM zm_file WHERE zm01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM zm_file WHERE zm01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND zm03 = '" || l_syc[li_i].syc07 CLIPPED || "'"
                END IF
             WHEN "4"
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gap02 = '" || l_syc[li_i].syc07 CLIPPED || "'"
                END IF
             WHEN "5"
                LET l_sql = "SELECT COUNT(*) FROM gbd_file WHERE gbd01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gbd07 = 'N'"
             WHEN "6"
                LET l_sql = "SELECT COUNT(*) FROM gaz_file WHERE gaz01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gaz05 = 'N'"
             WHEN "7"
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae11 = 'N'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae02 = '" || l_syc[li_i].syc07 CLIPPED || "' AND gae11 = 'N'"
                END IF
             WHEN "8"

                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae11 = 'N'"
                ELSE
                   LET l_sql = "SELECT COUNT(*) FROM gae_file WHERE gae01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gae02 = '" || l_syc[li_i].syc07 CLIPPED || "' AND gae11 = 'N'"
                END IF
             WHEN "9"
                LET l_sql = "SELECT COUNT(*) FROM gak_file WHERE gak01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "A"
                LET l_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "B"
                LET l_sql = "SELECT COUNT(*) FROM gap_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "C"
                LET l_sql = "SELECT COUNT(*) FROM gap_file,gbd_file WHERE gap01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gap02 = gbd01 AND gbd07 = 'N'"
             WHEN "D"
                LET l_sql = "SELECT COUNT(*) FROM gab_file WHERE gab01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gab11 = 'N'"
             WHEN "E"
                LET l_sql = "SELECT COUNT(*) FROM gav_file WHERE gav01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gav08 = 'N'"
             WHEN "G"
                LET l_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "H"
                LET l_sql = "SELECT COUNT(*) FROM wsa_file WHERE wsa01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "I"
                LET l_sql = "SELECT COUNT(*) FROM zaa_file WHERE zaa01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND zaa10 = 'N'"
             WHEN "J"
                LET l_sql = "SELECT COUNT(*) FROM gao_file WHERE gao01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "K"
                LET l_sql = "SELECT COUNT(*) FROM gba_file WHERE gba01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "L"
                LET l_sql = "SELECT COUNT(*) FROM gax_file WHERE gax01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND gax05 = 'N'"
             WHEN "M"
                LET l_sql = "SELECT COUNT(*) FROM gbf_file WHERE gbf01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             # 2006/09/22 --start--
             WHEN "N"
                LET l_sql = "SELECT COUNT(*) FROM wca_file WHERE wca01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "O"
                LET l_sql = "SELECT COUNT(*) FROM wcd_file WHERE wcd01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             # 2006/09/22 ---end---
             WHEN "P"   
                LET l_sql = "SELECT COUNT(*) FROM zaw_file WHERE zaw01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             WHEN "Q"
                LET l_sql = "SELECT COUNT(*) FROM zai_file WHERE zai01 = '" || l_syc[li_i].syc06 CLIPPED || "'"   
             WHEN "R"
                LET l_sql = "SELECT COUNT(*) FROM wsm_file WHERE wsm01 = '" || l_syc[li_i].syc06 CLIPPED || "'" 
             #080121---add---str---
             WHEN "S"
                LET l_sql = "SELECT COUNT(*) FROM gak_file WHERE gak01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             #080121---add---end---
             #081104 --start--
             WHEN "T"
                LET l_sql = "SELECT COUNT(*) FROM wgf_file WHERE wgf01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             #081104 ---end---
             #No:FUN-8C0067 --start--
             WHEN "U"
                LET l_sql = "SELECT COUNT(*) FROM wah_file WHERE wah01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND wah02 = '" || l_syc[li_i].syc07 CLIPPED || "'"
             WHEN "V"
                LET l_sql = "SELECT COUNT(*) FROM waa_file WHERE waa01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
             #No:FUN-8C0067 ---end---
             # No:FUN-960050 ---start---
             WHEN "W"
                LET l_sql = "SELECT COUNT(*) FROM wad_file WHERE wad01 = '" || l_syc[li_i].syc06 CLIPPED || "' AND wad04 = 'default'"
             # No:FUN-960050 --- end ---
          END CASE
          PREPARE count_pre FROM l_sql
          EXECUTE count_pre INTO li_count
          IF li_count <= 0 THEN
             #No:FUN-8C0005 --start--
             CASE l_syc[li_i].syc04
                WHEN "H"
                   LET l_sql = "SELECT COUNT(*) FROM wsd_file WHERE wsd01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                   PREPARE count_wsd_pre FROM l_sql
                   EXECUTE count_wsd_pre INTO li_count
                   IF li_count <= 0 THEN
                   #  CLOSE DATABASE    # No:FUN-A10136
                      DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED,"&wsd_file Key值為'",l_syc[li_i].syc06 CLIPPED,"', 但dstest資料庫沒資料可下載"
                      CONTINUE FOR
                   END IF
                WHEN "R"
                   LET l_sql = "SELECT COUNT(*) FROM wsr_file WHERE wsr01 = '" || l_syc[li_i].syc06 CLIPPED || "'"
                   PREPARE count_wsr_pre FROM l_sql
                   EXECUTE count_wsr_pre INTO li_count
                   IF li_count <= 0 THEN
                   #  CLOSE DATABASE    # No:FUN-A10136
                      DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED,"&wsr_file Key值為'",l_syc[li_i].syc06 CLIPPED,"', 但dstest資料庫沒資料可下載"
                      CONTINUE FOR
                   END IF
                OTHERWISE
             #No:FUN-8C0005 ---end---
                #  CLOSE DATABASE    # No:FUN-A10136
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," Key值為'",l_syc[li_i].syc06 CLIPPED,"', 但dstest資料庫沒資料可下載"
                   CONTINUE FOR
             END CASE    #No:FUN-8C0005
          END IF
       END IF
    #  CLOSE DATABASE    # No:FUN-A10136
       
       CASE l_syc[li_i].syc04
          WHEN "1"
             IF l_syc[li_i].syc05 != "ze_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM ze_file WHERE ze01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND ze02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND ze02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_ze.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_ze.getLength()
                   INSERT INTO patchtemp.ze_file VALUES(lr_ze[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
                
             END IF
          WHEN "2"
             # zz_file 對客製程式不做update動作
             IF l_syc[li_i].syc05 != "zz_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zz_file WHERE zz01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zz.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136
             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zz.getLength()
                   INSERT INTO patchtemp.zz_file VALUES(lr_zz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE  # No:FUN-A10136

                # 附加gaz_file資料
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gaz_file ",
                            "WHERE gaz01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gaz05 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaz02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaz02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gaz_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gaz_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaz.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gaz.getLength()
                   INSERT INTO patchtemp.gaz_file VALUES(lr_gaz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gaz_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "3"
             IF l_syc[li_i].syc05 != "zm_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT * FROM zm_file WHERE zm01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                ELSE
                   LET l_sql = "SELECT * FROM zm_file WHERE zm01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zm03 = '",l_syc[li_i].syc07 CLIPPED,"'"
                END IF
                PREPARE zm_pre FROM l_sql
                DECLARE zm_curs CURSOR FOR zm_pre
                LET l_cnt = 1
                CALL lr_zm.clear()
                FOREACH zm_curs INTO lr_zm[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zm.deleteElement(l_cnt)
                IF lr_zm.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zm.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zm.getLength()
                   INSERT INTO patchtemp.zm_file VALUES(lr_zm[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "4"
             IF l_syc[li_i].syc05 != "gap_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gap_file "
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = l_sql," WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                ELSE
                   LET l_sql = l_sql," WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gap02 = '",l_syc[li_i].syc07 CLIPPED,"'"
                END IF
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gap.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gap.getLength()
                   INSERT INTO patchtemp.gap_file VALUES(lr_gap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "5"
             IF l_syc[li_i].syc05 != "gbd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gbd_file ",
                            " WHERE gbd01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gbd07 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbd03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbd03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbd.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gbd.getLength()
                   INSERT INTO patchtemp.gbd_file VALUES(lr_gbd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "6"
             IF l_syc[li_i].syc05 != "gaz_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gaz_file ",
                            "WHERE gaz01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gaz05 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaz02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaz02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE gaz_6_pre FROM l_sql
                DECLARE gaz_6_curs CURSOR FOR gaz_6_pre
                LET l_cnt = 1
                CALL lr_gaz.clear()
                FOREACH gaz_6_curs INTO lr_gaz[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gaz.deleteElement(l_cnt)
                IF lr_gaz.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaz.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gaz.getLength()
                   INSERT INTO patchtemp.gaz_file VALUES(lr_gaz[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "7"
             IF l_syc[li_i].syc05 != "gae_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gae_file "
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae11 = 'N'"
                ELSE
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae02 = '",l_syc[li_i].syc07 CLIPPED,"' AND gae11='N'"
                END IF
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gae03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gae03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gae.getLength()
                   INSERT INTO patchtemp.gae_file VALUES(lr_gae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "8"
             IF l_syc[li_i].syc05 != "gae_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gae_file "
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae11 = 'N'"
                ELSE
                   LET l_sql = l_sql," WHERE gae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gae02 = '",l_syc[li_i].syc07 CLIPPED,"' AND gae11='N'"
                END IF
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gae03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gae03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gae.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gae.getLength()
                   INSERT INTO patchtemp.gae_file VALUES(lr_gae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "9"
             IF l_syc[li_i].syc05 != "gak_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 單頭檔 gak_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gak_file WHERE gak01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gak.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gak.getLength()
                   INSERT INTO patchtemp.gak_file VALUES(lr_gak[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 單身檔 gal_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gal.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gal.getLength()
                   INSERT INTO patchtemp.gal_file VALUES(lr_gal[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gal_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          #080121----add---str---
          WHEN "S"
             IF l_syc[li_i].syc05 != "gak_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 單頭檔 gak_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gak_file WHERE gak01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gak_pre_s FROM l_sql
                DECLARE gak_curs_s CURSOR FOR gak_pre_s
                LET l_cnt = 1
                CALL lr_gak.clear()
                FOREACH gak_curs_s INTO lr_gak[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gak.deleteElement(l_cnt)
                IF lr_gak.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gak.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gak.getLength()
                   INSERT INTO patchtemp.gak_file VALUES(lr_gak[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 單身檔 gal_file
             #  DATABASE ds   # No:FUN-A10136
               #080121----mod----str---
                IF l_syc[li_i].syc07 = " " THEN
                   LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                ELSE
                   LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gal03 = '",l_syc[li_i].syc07 CLIPPED,"'"
                END IF
               #LET l_sql = "SELECT * FROM gal_file WHERE gal01 = '",l_syc[li_i].syc06 CLIPPED,"'"
               #080121----mod----end---
                PREPARE gal_pre_s FROM l_sql
                DECLARE gal_curs_s CURSOR FOR gal_pre_s
                LET l_cnt = 1
                CALL lr_gal.clear()
                FOREACH gal_curs_s INTO lr_gal[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gal.deleteElement(l_cnt)
                IF lr_gal.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gal.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gal.getLength()
                   INSERT INTO patchtemp.gal_file VALUES(lr_gal[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gal_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          #080121----add---end---
          WHEN "A"
             IF l_syc[li_i].syc05 != "gaq_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gaq_file WHERE gaq01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaq02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gaq02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gaq.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gaq.getLength()
                   INSERT INTO patchtemp.gaq_file VALUES(lr_gaq[l_cnt].*)
                   # 因為包區間有打包全部gaq_file，所以暫時忽略此錯誤，
                   # 等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
                   # -----------------------------------------------------------------------------
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "B"
             IF l_syc[li_i].syc05 != "gap_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gap_file WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE gap_b_pre FROM l_sql
                DECLARE gap_b_curs CURSOR FOR gap_b_pre
                LET l_cnt = 1
                CALL lr_gap.clear()
                FOREACH gap_b_curs INTO lr_gap[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gap.deleteElement(l_cnt)
                IF lr_gap.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gap.getLength(),"筆資料"
                END IF
            #   CLOSE DATABASE   # No:FUN-A10136

            #   DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gap.getLength()
                   INSERT INTO patchtemp.gap_file VALUES(lr_gap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "C"
             IF l_syc[li_i].syc05 != "gbd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT gbd_file.* FROM gap_file,gbd_file",
                            " WHERE gap01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gap02 = gbd01 AND gbd07 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbd03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbd03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE gbd_c_pre FROM l_sql
                DECLARE gbd_c_curs CURSOR FOR gbd_c_pre
                LET l_cnt = 1
                CALL lr_gbd.clear()
                FOREACH gbd_c_curs INTO lr_gbd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbd.deleteElement(l_cnt)
                IF lr_gbd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbd.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gbd.getLength()
                   INSERT INTO patchtemp.gbd_file VALUES(lr_gbd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "D"
             IF l_syc[li_i].syc05 != "gab_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 動態開窗查詢單頭檔 gab_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gab_file WHERE gab01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gab11 = 'N'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gab.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gab.getLength()
                   INSERT INTO patchtemp.gab_file VALUES(lr_gab[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 動態開窗查詢單身檔 gac_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gac_file WHERE gac01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gac12 = 'N'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gac.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gac.getLength()
                   INSERT INTO patchtemp.gac_file VALUES(lr_gac[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gac_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "E"
             IF l_syc[li_i].syc05 != "gav_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gav_file WHERE gav01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gav08 = 'N'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gav.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gav.getLength()
                   INSERT INTO patchtemp.gav_file VALUES(lr_gav[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "G"
             IF l_syc[li_i].syc05 != "gat_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gat_file WHERE gat01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gat02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gat02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gat.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gat.getLength()
                   INSERT INTO patchtemp.gat_file VALUES(lr_gat[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "H"
             IF l_syc[li_i].syc05 != "wsa_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 單頭檔 wsa_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsa_file WHERE wsa01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsa.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsa.getLength()
                   INSERT INTO patchtemp.wsa_file VALUES(lr_wsa[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 單身檔 wsb_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsb_file WHERE wsb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsb_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsb_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsb.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsb.getLength()
                   INSERT INTO patchtemp.wsb_file VALUES(lr_wsb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsb_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #No:FUN-8C0005 --start--
                #wsd_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsd_file WHERE wsd01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsd_pre FROM l_sql
                DECLARE wsd_curs CURSOR FOR wsd_pre
                LET l_cnt = 1
                CALL lr_wsd.clear()
                FOREACH wsd_curs INTO lr_wsd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsd.deleteElement(l_cnt)
                IF lr_wsd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsd_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsd_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsd.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsd.getLength()
                   INSERT INTO patchtemp.wsd_file VALUES(lr_wsd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsd_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wse_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wse_file WHERE wse01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wse_pre FROM l_sql
                DECLARE wse_curs CURSOR FOR wse_pre
                LET l_cnt = 1
                CALL lr_wse.clear()
                FOREACH wse_curs INTO lr_wse[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wse.deleteElement(l_cnt)
                IF lr_wse.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wse_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wse_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wse.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wse.getLength()
                   INSERT INTO patchtemp.wse_file VALUES(lr_wse[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wse_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wsf_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsf_file WHERE wsf01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsf_pre FROM l_sql
                DECLARE wsf_curs CURSOR FOR wsf_pre
                LET l_cnt = 1
                CALL lr_wsf.clear()
                FOREACH wsf_curs INTO lr_wsf[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsf.deleteElement(l_cnt)
                IF lr_wsf.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsf_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsf_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsf.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsf.getLength()
                   INSERT INTO patchtemp.wsf_file VALUES(lr_wsf[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsf_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wsg_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsg_file WHERE wsg01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsg_pre FROM l_sql
                DECLARE wsg_curs CURSOR FOR wsg_pre
                LET l_cnt = 1
                CALL lr_wsg.clear()
                FOREACH wsg_curs INTO lr_wsg[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsg.deleteElement(l_cnt)
                IF lr_wsg.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsg_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsg_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsg.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsg.getLength()
                   INSERT INTO patchtemp.wsg_file VALUES(lr_wsg[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsg_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wsh_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsh_file WHERE wsh01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsh_pre FROM l_sql
                DECLARE wsh_curs CURSOR FOR wsh_pre
                LET l_cnt = 1
                CALL lr_wsh.clear()
                FOREACH wsh_curs INTO lr_wsh[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsh.deleteElement(l_cnt)
                IF lr_wsh.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsh_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsh_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsh.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsh.getLength()
                   INSERT INTO patchtemp.wsh_file VALUES(lr_wsh[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsh_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wsi_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsi_file WHERE wsi01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsi_pre FROM l_sql
                DECLARE wsi_curs CURSOR FOR wsi_pre
                LET l_cnt = 1
                CALL lr_wsi.clear()
                FOREACH wsi_curs INTO lr_wsi[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsi.deleteElement(l_cnt)
                IF lr_wsi.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsi_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsi_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsi.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136
             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsi.getLength()
                   INSERT INTO patchtemp.wsi_file VALUES(lr_wsi[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsi_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
                #No:FUN-8C0005 ---end---
             END IF
          WHEN "I"
             IF l_syc[li_i].syc05 != "zaa_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # 報表頭 zaa_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zaa_file WHERE zaa01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zaa10 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zaa03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zaa03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaa.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zaa.getLength()
                   INSERT INTO patchtemp.zaa_file VALUES(lr_zaa[l_cnt].*)
                   # 因為包區間有打包全部zaa_file，所以暫時忽略此錯誤，
                   # 等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
                   # -----------------------------------------------------------------------------
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 報表備註 zab_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zab_file",
                            " WHERE zab01 = (SELECT UNIQUE zaa08 FROM zaa_file ",
                            " WHERE zaa01 = '",l_syc[li_i].syc06 CLIPPED,"'",
                            "   AND (zaa14 = 'H' OR zaa14 = 'J'))"

                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zab04 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zab04 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                        
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zab_file 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zab_file 抓到 ",lr_zab.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zab.getLength()
                   INSERT INTO patchtemp.zab_file VALUES(lr_zab[l_cnt].*)
                   # 因為包區間有打包全部zab_file，所以暫時忽略此錯誤，
                   # 等到不呼叫p_zl_pack_alldata再開放給包全區間的
                   IF (g_bug_flag) THEN
                      IF SQLCA.sqlcode THEN
                         DISPLAY SQLCA.sqlcode," zab_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                         CONTINUE FOR
                      END IF
                   END IF
                   # -----------------------------------------------------------------------------
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # 報表連查 zad_file 2006/04/14 --start--
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zad_file WHERE zad01 = '",l_syc[li_i].syc06 CLIPPED,"' AND zad05 = 'N'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zad03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND zad03 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE zad_pre FROM l_sql
                DECLARE zad_curs CURSOR FOR zad_pre
                LET l_cnt = 1
                CALL lr_zad.clear()
                FOREACH zad_curs INTO lr_zad[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zad.deleteElement(l_cnt)
                IF lr_zad.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zad_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zad_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zad.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zad.getLength()
                   INSERT INTO patchtemp.zad_file VALUES(lr_zad[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zad_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET g_zae_where = ""
                LET l_sql = "SELECT zad10 FROM zad_file",
                            " WHERE zad01 ='",l_syc[li_i].syc06,"' ",
                            "   AND zad05 = 'N' AND zad09 = '2'"
                PREPARE zae_zad_pre FROM l_sql
                DECLARE zae_zad_curs CURSOR FOR zae_zad_pre
                FOREACH zae_zad_curs INTO lc_zad10
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET g_zae_cnt = 1
                   CALL p_zl_unload_zae_file(lc_zad10)
                END FOREACH
                LET g_zae_where = g_zae_where.subString(1,g_zae_where.getLength() - 3)

                IF g_zae_where.getLength() = 0  THEN 
                   LET g_zae_where = "1=1"
                END IF

                LET l_sql = "SELECT * FROM zae_file WHERE ",g_zae_where
                PREPARE zae_pre FROM l_sql
                DECLARE zae_curs CURSOR FOR zae_pre
                LET l_cnt = 1
                CALL lr_zae.clear()
                FOREACH zae_curs INTO lr_zae[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zae.deleteElement(l_cnt)
                IF lr_zae.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zae.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zae.getLength()
                   INSERT INTO patchtemp.zae_file VALUES(lr_zae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zae_file 資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
                 # 2006/04/14 ---end---

             END IF
          WHEN "J"
             IF l_syc[li_i].syc05 != "gao_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gao_file WHERE gao01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gao.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gao.getLength()
                   INSERT INTO patchtemp.gao_file VALUES(lr_gao[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          # 2005/10/03 --start-- By saki 增加Table
          WHEN "K"
             IF l_syc[li_i].syc05 != "gba_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                # SOP單頭檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gba_file WHERE gba01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gba04 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gba04 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE gba_pre FROM l_sql
                DECLARE gba_curs CURSOR FOR gba_pre
                LET l_cnt = 1
                CALL lr_gba.clear()
                FOREACH gba_curs INTO lr_gba[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gba.deleteElement(l_cnt)
                IF lr_gba.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gba.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gba.getLength()
                   INSERT INTO patchtemp.gba_file VALUES(lr_gba[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                # SOP單身檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gbb_file WHERE gbb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbb04 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbb04 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE gbb_pre FROM l_sql
                DECLARE gbb_curs CURSOR FOR gbb_pre
                LET l_cnt = 1
                CALL lr_gbb.clear()
                FOREACH gbb_curs INTO lr_gbb[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbb.deleteElement(l_cnt)
                IF lr_gbb.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbb.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gbb.getLength()
                   INSERT INTO patchtemp.gbb_file VALUES(lr_gbb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "L"
             IF l_syc[li_i].syc05 != "gax_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gax_file WHERE gax01 = '",l_syc[li_i].syc06 CLIPPED,"' AND gax05 = 'N'"
                PREPARE gax_pre FROM l_sql
                DECLARE gax_curs CURSOR FOR gax_pre
                LET l_cnt = 1
                CALL lr_gax.clear()
                FOREACH gax_curs INTO lr_gax[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gax.deleteElement(l_cnt)
                IF lr_gax.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gax.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gax.getLength()
                   INSERT INTO patchtemp.gax_file VALUES(lr_gax[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "M"
             IF l_syc[li_i].syc05 != "gbf_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM gbf_file WHERE gbf01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                #061204----add--------------------str------------
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbf02 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gbf02 IN ('0','1','2') "
                END IF
                #061204----add--------------------end------------
                PREPARE gbf_pre FROM l_sql
                DECLARE gbf_curs CURSOR FOR gbf_pre
                LET l_cnt = 1
                CALL lr_gbf.clear()
                FOREACH gbf_curs INTO lr_gbf[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gbf.deleteElement(l_cnt)
                IF lr_gbf.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gbf.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gbf.getLength()
                   INSERT INTO patchtemp.gbf_file VALUES(lr_gbf[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          # 2005/10/03 ---end---
          # 2006/09/22 --start--
          WHEN "N"
             IF l_syc[li_i].syc05 != "wca_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wca_file WHERE wca01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wca_pre FROM l_sql
                DECLARE wca_curs CURSOR FOR wca_pre
                LET l_cnt = 1
                CALL lr_wca.clear()
                FOREACH wca_curs INTO lr_wca[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wca.deleteElement(l_cnt)
                IF lr_wca.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wca.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wca.getLength()
                   INSERT INTO patchtemp.wca_file VALUES(lr_wca[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wcb_file WHERE wcb01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcb_pre FROM l_sql
                DECLARE wcb_curs CURSOR FOR wcb_pre
                LET l_cnt = 1
                CALL lr_wcb.clear()
                FOREACH wcb_curs INTO lr_wcb[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcb.deleteElement(l_cnt)
                IF lr_wcb.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcb.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wcb.getLength()
                   INSERT INTO patchtemp.wcb_file VALUES(lr_wcb[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wcc_file WHERE wcc01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcc_pre FROM l_sql
                DECLARE wcc_curs CURSOR FOR wcc_pre
                LET l_cnt = 1
                CALL lr_wcc.clear()
                FOREACH wcc_curs INTO lr_wcc[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcc.deleteElement(l_cnt)
                IF lr_wcc.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcc.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wcc.getLength()
                   INSERT INTO patchtemp.wcc_file VALUES(lr_wcc[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "O"
             IF l_syc[li_i].syc05 != "wcd_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wcd_file WHERE wcd01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wcd_pre FROM l_sql
                DECLARE wcd_curs CURSOR FOR wcd_pre
                LET l_cnt = 1
                CALL lr_wcd.clear()
                FOREACH wcd_curs INTO lr_wcd[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wcd.deleteElement(l_cnt)
                IF lr_wcd.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wcd.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wcd.getLength()
                   INSERT INTO patchtemp.wcd_file VALUES(lr_wcd[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          # 2006/09/22 ---end---
          WHEN "P"
             IF l_syc[li_i].syc05 != "zaw_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zaw_file WHERE zaw01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaw.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zaw.getLength()
                   INSERT INTO patchtemp.zaw_file VALUES(lr_zaw[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "Q"
             IF l_syc[li_i].syc05 != "zai_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                #自定義查詢設定主頁
             #  DATABASE ds  # No:FUN-A10136
                LET l_sql = "SELECT * FROM zai_file WHERE zai01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zai.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zai.getLength()
                   INSERT INTO patchtemp.zai_file VALUES(lr_zai[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #定義執行query前應執行的process
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zaj_file WHERE zaj01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaj.getLength(),"筆資料"
                END IF
            #   CLOSE DATABASE  # No:FUN-A10136

            #   DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zaj.getLength()
                   INSERT INTO patchtemp.zaj_file VALUES(lr_zaj[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zaj_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #定義設定查詢的sql
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zak_file WHERE zak01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zak_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zak_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zak.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zak.getLength()
                   INSERT INTO patchtemp.zak_file VALUES(lr_zak[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zak_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
                #設定SQL欄位資料
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zal_file WHERE zal01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zal_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zal.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zal.getLength()
                   INSERT INTO patchtemp.zal_file VALUES(lr_zal[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zal_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #定義查詢分群(Group)
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zam_file WHERE zam01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zam_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zam_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zam.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zam.getLength()
                   INSERT INTO patchtemp.zam_file VALUES(lr_zam[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zam_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE

                #定義查詢計算(Sum)
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zan_file WHERE zan01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zan.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zan.getLength()
                   INSERT INTO patchtemp.zan_file VALUES(lr_zan[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zan_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #定義查詢輸出格式(Layout)
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zao_file WHERE zao01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zao_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zao_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zao.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zao.getLength()
                   INSERT INTO patchtemp.zao_file VALUES(lr_zao[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zao_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #定義查詢 output
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zap_file WHERE zap01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zap_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zap_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zap.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zap.getLength()
                   INSERT INTO zap_file VALUES(lr_zap[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zap_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #SQL Wizard  Table 記錄檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zaq_file WHERE zaq01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaq_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zaq_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zaq.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zaq.getLength()
                   INSERT INTO patchtemp.zaq_file VALUES(lr_zaq[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zaq_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #SQL Wizard  Field 記錄檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zar_file WHERE zar01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zar_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zar_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zar.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zar.getLength()
                   INSERT INTO patchtemp.zar_file VALUES(lr_zar[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zar_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #SQL Wizard 條件式記錄檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zas_file WHERE zas01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zas_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zas_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zas.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zas.getLength()
                   INSERT INTO patchtemp.zas_file VALUES(lr_zas[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zas_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #動態查詢參數設定檔案
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zat_file WHERE zat01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zat_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zat_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zat.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zat.getLength()
                   INSERT INTO patchtemp.zat_file VALUES(lr_zat[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zat_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #自定義查詢權限設定檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zau_file WHERE zau01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zau_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zau_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zau.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zau.getLength()
                   INSERT INTO patchtemp.zau_file VALUES(lr_zau[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zau_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zay_file WHERE zay01 = '",l_syc[li_i].syc06 CLIPPED,"'"
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
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zay_file key   : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料 "
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zay_file key   : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zay.getLength(),"資料 "
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zay.getLength()
                   INSERT INTO patchtemp.zay_file VALUES(lr_zay[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zay_file資料倒至patchtemp時，發生錯誤，若key重復情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #自定義動態查詢設定檔
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM zav_file WHERE zav01 = '2' AND zav02 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE zav_Q_pre FROM l_sql
                DECLARE zav_Q_curs CURSOR FOR zav_Q_pre
                LET l_cnt = 1
                CALL lr_zav.clear()
                FOREACH zav_Q_curs INTO lr_zav[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zav.deleteElement(l_cnt)
                IF lr_zav.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zav_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zav_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zav.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zav.getLength()
                   INSERT INTO patchtemp.zav_file VALUES(lr_zav[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zav_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "R"
             IF l_syc[li_i].syc05 != "wsm_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsm_file WHERE wsm01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsm_pre FROM l_sql
                DECLARE wsm_curs CURSOR FOR wsm_pre
                LET l_cnt = 1
                CALL lr_wsm.clear()
                FOREACH wsm_curs INTO lr_wsm[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsm.deleteElement(l_cnt)
                IF lr_wsm.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsm.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsm.getLength()
                   INSERT INTO patchtemp.wsm_file VALUES(lr_wsm[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsn_file WHERE wsn01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsn_pre FROM l_sql
                DECLARE wsn_curs CURSOR FOR wsn_pre
                LET l_cnt = 1
                CALL lr_wsn.clear()
                FOREACH wsn_curs INTO lr_wsn[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsn.deleteElement(l_cnt)
                IF lr_wsn.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsn_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsn_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsn.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsn.getLength()
                   INSERT INTO patchtemp.wsn_file VALUES(lr_wsn[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsn_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wso_file WHERE wso01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wso_pre FROM l_sql
                DECLARE wso_curs CURSOR FOR wso_pre
                LET l_cnt = 1
                CALL lr_wso.clear()
                FOREACH wso_curs INTO lr_wso[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wso.deleteElement(l_cnt)
                IF lr_wso.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wso_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wso_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wso.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wso.getLength()
                   INSERT INTO patchtemp.wso_file VALUES(lr_wso[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wso_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsp_file WHERE wsp01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsp_pre FROM l_sql
                DECLARE wsp_curs CURSOR FOR wsp_pre
                LET l_cnt = 1
                CALL lr_wsp.clear()
                FOREACH wsp_curs INTO lr_wsp[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsp.deleteElement(l_cnt)
                IF lr_wsp.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsp_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsp_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsp.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsp.getLength()
                   INSERT INTO patchtemp.wsp_file VALUES(lr_wsp[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsp_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #081104 --start--
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wsr_file WHERE wsr01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wsr_pre FROM l_sql
                DECLARE wsr_curs CURSOR FOR wsr_pre
                LET l_cnt = 1
                CALL lr_wsr.clear()
                FOREACH wsr_curs INTO lr_wsr[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wsr.deleteElement(l_cnt)
                IF lr_wsr.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsr_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wsr_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wsr.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wsr.getLength()
                   INSERT INTO patchtemp.wsr_file VALUES(lr_wsr[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wsr_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wss_file WHERE wss01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wss_pre FROM l_sql
                DECLARE wss_curs CURSOR FOR wss_pre
                LET l_cnt = 1
                CALL lr_wss.clear()
                FOREACH wss_curs INTO lr_wss[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wss.deleteElement(l_cnt)
                IF lr_wss.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wss_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wss_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wss.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wss.getLength()
                   INSERT INTO patchtemp.wss_file VALUES(lr_wss[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wss_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wst_file WHERE wst01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wst_pre FROM l_sql
                DECLARE wst_curs CURSOR FOR wst_pre
                LET l_cnt = 1
                CALL lr_wst.clear()
                FOREACH wst_curs INTO lr_wst[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wst.deleteElement(l_cnt)
                IF lr_wst.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wst_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wst_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wst.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wst.getLength()
                   INSERT INTO patchtemp.wst_file VALUES(lr_wst[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wst_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
                #081104 ---end---
             END IF                         
          #081104 --start--
          WHEN "T"
             IF l_syc[li_i].syc05 != "wgf_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wgf_file WHERE wgf01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wgf_pre FROM l_sql
                DECLARE wgf_curs CURSOR FOR wgf_pre
                LET l_cnt = 1
                CALL lr_wgf.clear()
                FOREACH wgf_curs INTO lr_wgf[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wgf.deleteElement(l_cnt)
                IF lr_wgf.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wgf.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wgf.getLength()
                   INSERT INTO patchtemp.wgf_file VALUES(lr_wgf[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          #081104 ---end---
          #No:FUN-8C0067 --start--
          WHEN "U"
             IF l_syc[li_i].syc05 != "wah_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wah_file WHERE wah01 = '",l_syc[li_i].syc06 CLIPPED,"' AND wah02 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE wah_pre FROM l_sql
                DECLARE wah_curs CURSOR FOR wah_pre
                LET l_cnt = 1
                CALL lr_wah.clear()
                FOREACH wah_curs INTO lr_wah[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wah.deleteElement(l_cnt)
                IF lr_wah.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wah.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wah.getLength()
                   INSERT INTO patchtemp.wah_file VALUES(lr_wah[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wai_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wai_file WHERE wai01 = '",l_syc[li_i].syc06 CLIPPED,"' AND wai02 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE wai_pre FROM l_sql
                DECLARE wai_curs CURSOR FOR wai_pre
                LET l_cnt = 1
                CALL lr_wai.clear()
                FOREACH wai_curs INTO lr_wai[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wai.deleteElement(l_cnt)
                IF lr_wai.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wai_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wai_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wai.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wai.getLength()
                   INSERT INTO patchtemp.wai_file VALUES(lr_wai[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wai_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #waj_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM waj_file WHERE waj01 = '",l_syc[li_i].syc06 CLIPPED,"' AND waj02 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE waj_pre FROM l_sql
                DECLARE waj_curs CURSOR FOR waj_pre
                LET l_cnt = 1
                CALL lr_waj.clear()
                FOREACH waj_curs INTO lr_waj[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_waj.deleteElement(l_cnt)
                IF lr_waj.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," waj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," waj_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_waj.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_waj.getLength()
                   INSERT INTO patchtemp.waj_file VALUES(lr_waj[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," waj_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #waa_file
             #  DATABASE ds    # No:FUN-A10136
                LET l_sql = "SELECT * FROM waa_file WHERE waa01 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE waa_u_pre FROM l_sql
                DECLARE waa_u_curs CURSOR FOR waa_u_pre
                LET l_cnt = 1
                CALL lr_waa.clear()
                FOREACH waa_u_curs INTO lr_waa[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_waa.deleteElement(l_cnt)
                IF lr_waa.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," waa_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," waa_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_waa.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_waa.getLength()
                   INSERT INTO patchtemp.waa_file VALUES(lr_waa[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," waa_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wab_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wab_file WHERE wab01 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE wab_u_pre FROM l_sql
                DECLARE wab_u_curs CURSOR FOR wab_u_pre
                LET l_cnt = 1
                CALL lr_wab.clear()
                FOREACH wab_u_curs INTO lr_wab[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wab.deleteElement(l_cnt)
                IF lr_wab.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wab_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wab_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wab.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wab.getLength()
                   INSERT INTO patchtemp.wab_file VALUES(lr_wab[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wab_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wac_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wac_file WHERE wac01 = '",l_syc[li_i].syc07 CLIPPED,"'"
                PREPARE wac_u_pre FROM l_sql
                DECLARE wac_u_curs CURSOR FOR wac_u_pre
                LET l_cnt = 1
                CALL lr_wac.clear()
                FOREACH wac_u_curs INTO lr_wac[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wac.deleteElement(l_cnt)
                IF lr_wac.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wac.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wac.getLength()
                   INSERT INTO patchtemp.wac_file VALUES(lr_wac[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wac_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          WHEN "V"
             IF l_syc[li_i].syc05 != "waa_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM waa_file WHERE waa01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE waa_v_pre FROM l_sql
                DECLARE waa_v_curs CURSOR FOR waa_v_pre
                LET l_cnt = 1
                CALL lr_waa.clear()
                FOREACH waa_v_curs INTO lr_waa[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_waa.deleteElement(l_cnt)
                IF lr_waa.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_waa.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_waa.getLength()
                   INSERT INTO patchtemp.waa_file VALUES(lr_waa[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wab_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wab_file WHERE wab01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wab_v_pre FROM l_sql
                DECLARE wab_v_curs CURSOR FOR wab_v_pre
                LET l_cnt = 1
                CALL lr_wab.clear()
                FOREACH wab_v_curs INTO lr_wab[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wab.deleteElement(l_cnt)
                IF lr_wab.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wab_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wab_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wab.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wab.getLength()
                   INSERT INTO patchtemp.wab_file VALUES(lr_wab[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wab_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

                #wac_file
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wac_file WHERE wac01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE wac_v_pre FROM l_sql
                DECLARE wac_v_curs CURSOR FOR wac_v_pre
                LET l_cnt = 1
                CALL lr_wac.clear()
                FOREACH wac_v_curs INTO lr_wac[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wac.deleteElement(l_cnt)
                IF lr_wac.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wac_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wac.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wac.getLength()
                   INSERT INTO patchtemp.wac_file VALUES(lr_wac[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wac_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          #No:FUN-8C0067 ---end---

          # No:FUN-960050 ---start---
          WHEN "W"
             IF l_syc[li_i].syc05 != "wad_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wad_file WHERE wad01 = '",l_syc[li_i].syc06 CLIPPED,"' AND wad04 = 'default'"
                PREPARE wad_w_pre FROM l_sql
                DECLARE wad_w_curs CURSOR FOR wad_w_pre
                LET l_cnt = 1
                CALL lr_wad.clear()
                FOREACH wad_w_curs INTO lr_wad[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wad.deleteElement(l_cnt)
                IF lr_wad.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," ",l_syc[li_i].syc05 CLIPPED," key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wad.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wad.getLength()
                   INSERT INTO patchtemp.wad_file VALUES(lr_wad[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," ",l_syc[li_i].syc05 CLIPPED,"資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wae_file WHERE wae01 = '",l_syc[li_i].syc06 CLIPPED,"' AND wae13 = 'default'"
                PREPARE wae_w_pre FROM l_sql
                DECLARE wae_w_curs CURSOR FOR wae_w_pre
                LET l_cnt = 1
                CALL lr_wae.clear()
                FOREACH wae_w_curs INTO lr_wae[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wae.deleteElement(l_cnt)
                IF lr_wad.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wae_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wae.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136
             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wae.getLength()
                   INSERT INTO patchtemp.wae_file VALUES(lr_wae[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wae_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE ds   # No:FUN-A10136
                LET l_sql = "SELECT * FROM wan_file WHERE wan03 = '",l_syc[li_i].syc06 CLIPPED,"' AND wan01 = 'wae_file' AND wan02 = 'wae04'"
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND wan05 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND wan05 IN ('0','1','2') "
                END IF
                PREPARE wan_w_pre FROM l_sql
                DECLARE wan_w_curs CURSOR FOR wan_w_pre
                LET l_cnt = 1
                CALL lr_wan.clear()
                FOREACH wan_w_curs INTO lr_wan[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_wan.deleteElement(l_cnt)
                IF lr_wan.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," wan_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_wan.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_wan.getLength()
                   INSERT INTO patchtemp.wan_file VALUES(lr_wan[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," wan_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             #  CLOSE DATABASE   # No:FUN-A10136
             END IF
          # No:FUN-960050 --- end ---

          # No:FUN-A30105 ---start---
          WHEN "X"
             IF l_syc[li_i].syc05 != "gee_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                LET l_sql = "SELECT * FROM gee_file WHERE gee01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                IF g_language='0' THEN #中文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gee03 IN ('0','2') "
                ELSE                   #中英文版
                    LET l_sql = l_sql CLIPPED,
                                " AND gee03 IN ('0','1','2') "
                END IF
                PREPARE gee_x_pre FROM l_sql
                DECLARE gee_x_curs CURSOR FOR gee_x_pre
                LET l_cnt = 1
                CALL lr_gee.clear()
                FOREACH gee_x_curs INTO lr_gee[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_gee.deleteElement(l_cnt)
                IF lr_gee.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gee_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," gee_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_gee.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_gee.getLength()
                   INSERT INTO patchtemp.gee_file VALUES(lr_gee[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," gee_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             END IF
          # No:FUN-A30105 --- end ---

          # No:FUN-A60053 ---start---
          WHEN "Y"
             IF l_syc[li_i].syc05 != "zta_file" THEN
                DISPLAY p_zl08 CLIPPED,"  ",l_syc[li_i].syc04,"與",l_syc[li_i].syc05,"不符"
                CONTINUE FOR
             END IF

             IF l_syc[li_i].syc03 = "I" THEN
                LET l_sql = "SELECT * FROM zta_file WHERE zta01 = '",l_syc[li_i].syc06 CLIPPED,"'"
                PREPARE zta_y_pre FROM l_sql
                DECLARE zta_y_curs CURSOR FOR zta_y_pre
                LET l_cnt = 1
                CALL lr_zta.clear()
                FOREACH zta_y_curs INTO lr_zta[l_cnt].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_cnt = l_cnt + 1
                END FOREACH
                CALL lr_zta.deleteElement(l_cnt)
                IF lr_zta.getLength() <= 0 THEN
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zta_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 沒有抓到資料"
                ELSE                                                                                                      
                   DISPLAY "BugNo.",p_zl08 CLIPPED," zta_file key值 : '",l_syc[li_i].syc06 CLIPPED,"' 抓到 ",lr_zta.getLength(),"筆資料"
                END IF
             #  CLOSE DATABASE   # No:FUN-A10136

             #  DATABASE patchtemp   # No:FUN-A10136
                FOR l_cnt = 1 TO lr_zta.getLength()
                   INSERT INTO patchtemp.zta_file VALUES(lr_zta[l_cnt].*)
                   IF SQLCA.sqlcode THEN
                      DISPLAY SQLCA.sqlcode," zta_file資料倒至patchtemp時，發生錯誤，若key值重複情況可忽略"
                      CONTINUE FOR
                   END IF
                END FOR
             END IF
          # No:FUN-A60053 --- end ---
       END CASE
   END FOR
       DISPLAY "UNLOAD file..."
           #  DATABASE patchtemp   # No:FUN-A10136
              LET l_cmd = "cd ",l_tempdir CLIPPED,";rm patch_*.txt 2> /dev/null "
              RUN l_cmd
              UNLOAD TO "patch_ze.txt"   SELECT * FROM  patchtemp.ze_file 
              UNLOAD TO "patch_zz.txt"   SELECT * FROM  patchtemp.zz_file
              UNLOAD TO "patch_zm.txt"   SELECT * FROM  patchtemp.zm_file
              UNLOAD TO "patch_gap.txt"  SELECT * FROM  patchtemp.gap_file
              UNLOAD TO "patch_gbd.txt"  SELECT * FROM  patchtemp.gbd_file 
              UNLOAD TO "patch_gae.txt"  SELECT * FROM  patchtemp.gae_file 
              UNLOAD TO "patch_gak.txt"  SELECT * FROM  patchtemp.gak_file 
              UNLOAD TO "patch_gal.txt"  SELECT * FROM  patchtemp.gal_file
              UNLOAD TO "patch_gaq.txt"  SELECT * FROM  patchtemp.gaq_file 
              UNLOAD TO "patch_gab.txt"  SELECT * FROM  patchtemp.gab_file
              UNLOAD TO "patch_gac.txt"  SELECT * FROM  patchtemp.gac_file
              UNLOAD TO "patch_gav.txt"  SELECT * FROM  patchtemp.gav_file
              UNLOAD TO "patch_gat.txt"  SELECT * FROM  patchtemp.gat_file 
              UNLOAD TO "patch_gaz.txt"  SELECT * FROM  patchtemp.gaz_file 
              UNLOAD TO "patch_wsa.txt"  SELECT * FROM  patchtemp.wsa_file
              UNLOAD TO "patch_wsb.txt"  SELECT * FROM  patchtemp.wsb_file
              UNLOAD TO "patch_zaa.txt"  SELECT * FROM  patchtemp.zaa_file 
              UNLOAD TO "patch_zab.txt"  SELECT * FROM  patchtemp.zab_file 
              UNLOAD TO "patch_gao.txt"  SELECT * FROM  patchtemp.gao_file
              UNLOAD TO "patch_gba.txt"  SELECT * FROM  patchtemp.gba_file 
              UNLOAD TO "patch_gbb.txt"  SELECT * FROM  patchtemp.gbb_file 
              UNLOAD TO "patch_gax.txt"  SELECT * FROM  patchtemp.gax_file
              UNLOAD TO "patch_gbf.txt"  SELECT * FROM  patchtemp.gbf_file 
              UNLOAD TO "patch_zad.txt"  SELECT * FROM  patchtemp.zad_file 
              UNLOAD TO "patch_zae.txt"  SELECT * FROM  patchtemp.zae_file 
              UNLOAD TO "patch_wca.txt"  SELECT * FROM  patchtemp.wca_file
              UNLOAD TO "patch_wcb.txt"  SELECT * FROM  patchtemp.wcb_file
              UNLOAD TO "patch_wcc.txt"  SELECT * FROM  patchtemp.wcc_file
              UNLOAD TO "patch_wcd.txt"  SELECT * FROM  patchtemp.wcd_file
              UNLOAD TO "patch_zaw.txt"  SELECT * FROM  patchtemp.zaw_file 
              UNLOAD TO "patch_zav.txt"  SELECT * FROM  patchtemp.zav_file
              UNLOAD TO "patch_zai.txt"  SELECT * FROM  patchtemp.zai_file
              UNLOAD TO "patch_zaj.txt"  SELECT * FROM  patchtemp.zaj_file
              UNLOAD TO "patch_zak.txt"  SELECT * FROM  patchtemp.zak_file
              UNLOAD TO "patch_zal.txt"  SELECT * FROM  patchtemp.zal_file 
              UNLOAD TO "patch_zam.txt"  SELECT * FROM  patchtemp.zam_file
              UNLOAD TO "patch_zan.txt"  SELECT * FROM  patchtemp.zan_file
              UNLOAD TO "patch_zao.txt"  SELECT * FROM  patchtemp.zao_file
              UNLOAD TO "patch_zap.txt"  SELECT * FROM  patchtemp.zap_file 
              UNLOAD TO "patch_zaq.txt"  SELECT * FROM  patchtemp.zaq_file
              UNLOAD TO "patch_zar.txt"  SELECT * FROM  patchtemp.zar_file
              UNLOAD TO "patch_zas.txt"  SELECT * FROM  patchtemp.zas_file
              UNLOAD TO "patch_zat.txt"  SELECT * FROM  patchtemp.zat_file
              UNLOAD TO "patch_zau.txt"  SELECT * FROM  patchtemp.zau_file
              UNLOAD TO "patch_zay.txt"  SELECT * FROM  patchtemp.zay_file
              UNLOAD TO "patch_wsm.txt"  SELECT * FROM  patchtemp.wsm_file
              UNLOAD TO "patch_wsn.txt"  SELECT * FROM  patchtemp.wsn_file
              UNLOAD TO "patch_wso.txt"  SELECT * FROM  patchtemp.wso_file
              UNLOAD TO "patch_wsp.txt"  SELECT * FROM  patchtemp.wsp_file  
              #081104 --start--
              UNLOAD TO "patch_wsr.txt"  SELECT * FROM  patchtemp.wsr_file  
              UNLOAD TO "patch_wss.txt"  SELECT * FROM  patchtemp.wss_file  
              UNLOAD TO "patch_wst.txt"  SELECT * FROM  patchtemp.wst_file  
              UNLOAD TO "patch_wgf.txt"  SELECT * FROM  patchtemp.wgf_file  
              #081104 ---end---
              #No:FUN-8C0005 --start--
              UNLOAD TO "patch_wsd.txt"  SELECT * FROM  patchtemp.wsd_file  
              UNLOAD TO "patch_wse.txt"  SELECT * FROM  patchtemp.wse_file  
              UNLOAD TO "patch_wsf.txt"  SELECT * FROM  patchtemp.wsf_file  
              UNLOAD TO "patch_wsg.txt"  SELECT * FROM  patchtemp.wsg_file  
              UNLOAD TO "patch_wsh.txt"  SELECT * FROM  patchtemp.wsh_file  
              UNLOAD TO "patch_wsi.txt"  SELECT * FROM  patchtemp.wsi_file  
              #No:FUN-8C0005 ---end---
              #No:FUN-8C0067 --start--
              UNLOAD TO "patch_wah.txt"  SELECT * FROM  patchtemp.wah_file  
              UNLOAD TO "patch_wai.txt"  SELECT * FROM  patchtemp.wai_file  
              UNLOAD TO "patch_waj.txt"  SELECT * FROM  patchtemp.waj_file  
              UNLOAD TO "patch_waa.txt"  SELECT * FROM  patchtemp.waa_file  
              UNLOAD TO "patch_wab.txt"  SELECT * FROM  patchtemp.wab_file  
              UNLOAD TO "patch_wac.txt"  SELECT * FROM  patchtemp.wac_file  
              #No:FUN-8C0067 ---end---
              # No:FUN-960050 ---start---
              UNLOAD TO "patch_wad.txt"  SELECT * FROM  patchtemp.wad_file  
              UNLOAD TO "patch_wae.txt"  SELECT * FROM  patchtemp.wae_file  
              UNLOAD TO "patch_wan.txt"  SELECT * FROM  patchtemp.wan_file  
              # No:FUN-960050 --- end ---
              UNLOAD TO "patch_gee.txt"  SELECT * FROM  patchtemp.gee_file    # No:FUN-A30105
              UNLOAD TO "patch_zta.txt"  SELECT * FROM  patchtemp.zta_file    # No:FUN-A60053
           #  CLOSE DATABASE   # No:FUN-A10136
              LET l_cmd = " mv patch_*.txt ",l_tempdir CLIPPED
              RUN l_cmd
              
   
END MAIN 
FUNCTION p_zl_unload_zae_file(p_zae01)
   DEFINE   p_zae01   VARCHAR(10)
   DEFINE   lc_zae10  VARCHAR(10)
   DEFINE   ls_sql    STRING
   DEFINE   li_i      SMALLINT
   DEFINE   li_ins    SMALLINT

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
      LET ls_sql = "SELECT zae10 FROM zae_file ",
                   " WHERE zae01 = '",p_zae01,"' AND zae09 = '2'"
      PREPARE unload_zae_pre FROM ls_sql
      DECLARE unload_zae_curs CURSOR FOR unload_zae_pre
      FOREACH unload_zae_curs INTO lc_zae10
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         CALL p_zl_unload_zae_file(lc_zae10)
      END FOREACH
   END IF
END FUNCTION
{
FUNCTION insert_pzs()
  DEFINE   l_gaz03        LIKE gaz_file.gaz03
  DEFINE   l_cnt          INTEGER
  DEFINE   l_ac           INTEGER      
  DEFINE   l_sql          STRING
  DEFINE   l_zs06         STRING
  DEFINE   li_b           INTEGER
  DEFINE   li_e           INTEGER
  DEFINE   l_str          STRING
  DEFINE   li_sy          INTEGER
  DEFINE   lc_zs06        CHAR(180) 
  DEFINE   l_show_alter_list DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                             zs01 CHAR(15),
                             zs06 CHAR(180), 
                             zs08 CHAR(30),           
                             zs04 DATE,
                             zs03 SMALLINT 
                             END RECORD         
    
DATABASE ds

    CALL l_show_alter_list.clear()  
    LET l_cnt = 1    
    FOR l_ac = 1 TO lw_zl08.getlength()      

         LET l_sql = " SELECT zs01,zs06,zs08,zs04,zs03 FROM zs_file",
                     " WHERE zs08='",lw_zl08[l_ac],"'",
                     " AND zs02 ='ds' ",
                     " AND zs05 ='p'  ",
                     " ORDER BY zs01,zs04,zs03 " #071221 mod
                    #" ORDER BY zs04,zs03,zs01 " #071221 mod
          PREPARE alter_list_pzs FROM l_sql
          DECLARE alter_list_cs CURSOR FOR alter_list_pzs
          
                      
          FOREACH alter_list_cs INTO l_show_alter_list[l_cnt].*
              IF SQLCA.sqlcode THEN 
                  EXIT FOREACH 
              END IF
              
              LET l_zs06 = l_show_alter_list[l_cnt].zs06 
}
#              LET li_b = l_zs06.getIndexOf('{',1)
#              LET li_e = l_zs06.getIndexOf('}',1)
#              IF li_b != 0 THEN 
#                LET l_str = l_zs06.subString(li_b+1,li_e-1)
#                LET l_cmd = "cp ",l_str," ./ctfile "
#                RUN l_cmd 
#              END IF

{
              LET li_sy = l_zs06.getIndexOf('create table',1) 
              IF li_sy != 0 THEN
                SELECT zs06 INTO lc_zs06 FROM zs_file 
                 WHERE zs01 = l_show_alter_list[l_cnt].zs01
                 AND   zs02 = 'ds1'
                 AND   zs03 = l_show_alter_list[l_cnt].zs03
                 
                LET l_zs06 = lc_zs06 CLIPPED
                IF l_zs06.getIndexOf("synonym",1) THEN 
                   
                   LET l_sql = " SELECT zs01,zs06,zs08,zs04,zs03 FROM zs_file",
                              " WHERE zs03='",l_show_alter_list[l_cnt].zs03,"'",
                              " AND zs02 ='ds1' ",
                              " AND zs01 = '",l_show_alter_list[l_cnt].zs01,"'"
                   LET l_cnt = l_cnt + 1            
                   PREPARE zs_pre FROM l_sql
                   EXECUTE zs_pre INTO l_show_alter_list[l_cnt].*
                END IF               
                      
              END IF    
              LET l_cnt = l_cnt + 1
          END FOREACH 
          CALL l_show_alter_list.deleteElement(l_cnt)         
    END FOR 
CLOSE DATABASE     
DATABASE patchtemp
   FOR l_cnt = 1 TO l_show_alter_list.getlength()
       INSERT INTO pzs_file VALUES(l_show_alter_list[l_cnt].*)
   END FOR 
CLOSE DATABASE        
END FUNCTION 
}
