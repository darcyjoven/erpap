/*
================================================================================
檔案代號:oea_file
檔案名稱:訂單(合約)單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oea_file
(
oea00       nvarchar(1),             /*類別                                   */
                                     /* 0.合約       1.正常訂單   2.換貨訂單  */
                                     /* 3:出至境外倉 4:境外倉出貨 5:BU間銷售  */
                                     /* 6:調貨訂單     7:寄銷訂單  8.借貨出貨 */
                                     /* 9.借貨償價                            */
                                     /*  換貨訂單為銷退不追訂單而再開立者,    */
                                     /*  換貨訂單不計入銷貨統計               */
oea01       nvarchar(20) NOT NULL,   /*訂單單號/合約單號                      */
oea02       datetime,                /*訂單日期/合約日期                      */
oea03       nvarchar(10),            /*帳款客戶編號                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oea032      nvarchar(40),            /*帳款客戶簡稱                           */
oea033      nvarchar(20),            /*帳款客戶統一編號                       */
oea04       nvarchar(10),            /*送貨客戶編號                           */
                                     /*送貨客戶編號 occ01                     */
oea044      nvarchar(10),            /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oap_file)*/
oea05       nvarchar(5),             /*發票別                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oea06       smallint,                /*修改版本                               */
                                     /*修改版本    (modify in 99/10/11)       */
oea07       nvarchar(1),             /*出貨是否計入未開發票的銷貨             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oea08       nvarchar(1),             /*訂單性質                               */
                                     /*1.內銷 2.外銷 3.視同外銷訂單           */
oea09       smallint NOT NULL,       /*允許超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oea10       nvarchar(30),            /*客戶訂單單號                           */
oea1001     nvarchar(10),            /*收款客戶編號                           */
oea1002     nvarchar(10),            /*債權代碼                               */
oea1003     nvarchar(10),            /*業績歸屬組織                           */
oea1004     nvarchar(10),            /*調貨客戶                               */
oea1005     nvarchar(1),             /*是否計算業績                           */
oea1006     decimal(18),             /*折扣金額(未稅)                         */
oea1007     decimal(18),             /*折扣金額(含稅)                         */
oea1008     decimal(18),             /*訂單總含稅金額                         */
oea1009     nvarchar(10),            /*客戶所屬通路                           */
oea1010     nvarchar(10),            /*客戶所屬組織                           */
oea1011     nvarchar(10),            /*開票客戶                               */
oea1012     nvarchar(1),             /*自提否                                 */
oea1013     decimal(18),             /*重量                                   */
oea1014     decimal(18),             /*體積                                   */
oea1015     nvarchar(10),            /*代送商                                 */
oea11       nvarchar(1),             /*訂單來源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
                                     /*         (4.估價單轉入            )    */
                                     /*         (5.報價單轉入            )    */
                                     /*         (6.多角代採買            )    */
                                     /*         (7.境外倉出貨單 no.7175  )    */
oea12       nvarchar(20),            /*銷退單號/合約單號/估價單號             */
oea14       nvarchar(10),            /*人員編號                               */
                                     /*人員編號   gen01                       */
oea15       nvarchar(10),            /*部門編號                               */
                                     /*部門編號   gem01                       */
oea161      smallint,                /*訂金應收比率                           */
oea162      smallint,                /*出貨應收比率                           */
oea163      smallint,                /*尾款應收比率                           */
oea17       nvarchar(10),            /*收款客戶編號                           */
                                     /*收款客戶編號 occ01                     */
oea18       nvarchar(1),             /*是否採用訂單匯率立帳                   */
oea19       nvarchar(80),            /*通知                                   */
oea20       nvarchar(1),             /*是否直接送貨至客戶                     */
oea21       nvarchar(4),             /*稅別                                   */
                                     /*稅別       gec01                       */
oea211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oea212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oea213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oea23       nvarchar(4),             /*幣別                                   */
                                     /*幣別   azi01                           */
oea24       decimal(18),             /*匯率                                   */
oea25       nvarchar(10),            /*銷售分類一                             */
                                     /*銷售分類一 oab01                       */
oea26       nvarchar(10),            /*銷售分類二                             */
                                     /*銷售分類二 oab01                       */
oea261      decimal(18),             /*訂金金額                               */
oea262      decimal(18),             /*出貨金額                               */
oea263      decimal(18),             /*尾款金額                               */
oea27       nvarchar(1),             /*No Use                                 */
oea28       nvarchar(1),             /*No Use                                 */
oea29       nvarchar(1),             /*No Use                                 */
oea30       nvarchar(1),             /*No Use                                 */
oea31       nvarchar(6),             /*價格條件編號                           */
                                     /*價格條件編號 oah01                     */
oea32       nvarchar(6),             /*收款條件編號                           */
                                     /*收款條件編號 oag01                     */
oea33       nvarchar(80),            /*其它條件                               */
oea34       decimal(18),             /*佣金率%或佣金金額                      */
                                     /*佣金率%或佣金金額 modify 99/05/01      */
oea35       nvarchar(10),            /*卸貨港                                 */
                                     /*卸貨港 oac01      modify 99/05/01      */
oea36       nvarchar(40),            /*產證                                   */
                                     /*產證              modify 99/05/01      */
oea37       nvarchar(1),             /*訂單分配否                             */
oea38       nvarchar(10),            /*forwader                               */
oea39       nvarchar(1),             /*No Use                                 */
oea40       nvarchar(20),            /*拋轉請購單號                           */
                                     /*拋轉請購單號     modify 01/04/27 No.B457*/
oea41       nvarchar(10),            /*起運地                                 */
                                     /*起運地  oac01                          */
oea42       nvarchar(10),            /*到達地                                 */
                                     /*到達地  oac01                          */
oea43       nvarchar(20),            /*交運方式                               */
oea44       nvarchar(10),            /*嘜頭代號                               */
                                     /*嘜頭代號 ocf02,ocf01=oea03             */
oea45       nvarchar(40),            /*聯絡人                                 */
oea46       nvarchar(10),            /*專案編號                               */
oea47       nvarchar(10),            /*代理商編號                             */
                                     /*代理商編號                         A045*/
oea48       nvarchar(10),            /*佣金代號                               */
                                     /*佣金代號                           A045*/
oea49       nvarchar(1),             /*狀況碼                                 */
                                     /*狀況碼:                                */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                 #No.6686       */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
oea50       nvarchar(1),             /*是否作CSD展開                          */
oea51       nvarchar(40),            /*CSD:產品品號                           */
oea52       datetime,                /*CSD:BOM 有效日期                       */
oea53       decimal(18),             /*CSD:套數                               */
oea54       decimal(18),             /*CSD:原幣售價                           */
oea55       decimal(18),             /*CSD:原幣金額                           */
oea56       nvarchar(10),            /*CSD:出貨營運中心                       */
oea57       nvarchar(10),            /*CSD:出貨倉庫                           */
oea58       nvarchar(10),            /*CSD:出貨儲位                           */
oea59       datetime,                /*CSD:預計交貨日                         */
oea61       decimal(18) NOT NULL,    /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oea62       decimal(18) NOT NULL,    /*已出貨未稅金額                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oea63       decimal(18) NOT NULL,    /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oea65       nvarchar(1),             /*客戶出貨簽收否                         */
oea68       nvarchar(10),            /*No Use                                 */
oea71       nvarchar(4),             /*No Use                                 */
oea72       datetime,                /*確認日                                 */
                                     /*首次確認日 (第一次確認時更新)          */
oea80       nvarchar(6),             /*訂金收款條件                           */
oea81       nvarchar(6),             /*尾款收款條件                           */
oea82       nvarchar(1),             /*借貨償價                               */
oea83       nvarchar(10),            /*銷貨營運中心                           */
oea84       nvarchar(10),            /*取貨營運中心                           */
oea85       nvarchar(1) DEFAULT ' ' NOT NULL, /*結算方式*/
oea86       nvarchar(10),            /*客層代碼                               */
oea87       nvarchar(20),            /*會員卡號                               */
oea88       nvarchar(10),            /*顧客姓名                               */
oea89       nvarchar(20),            /*聯系電話                               */
oea90       nvarchar(10),            /*證件類型                               */
oea901      nvarchar(1),             /*多角貿易否                             */
oea902      nvarchar(1),             /*最終訂單否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oea903      nvarchar(1),             /*營業額申報方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oea904      nvarchar(8),             /*多角貿易流程代碼                       */
                                     /*多角貿易流程代碼->oai_file  oai01No.7946*/
oea905      nvarchar(1),             /*多角貿易拋轉否                         */
oea906      nvarchar(1),             /*多角貿易來源訂單否                     */
oea907      nvarchar(10),            /*RMA NO                                 */
oea908      datetime,                /*信用超限放行有效日期                   */
oea909      nvarchar(1),             /*No Use                                 */
oea91       nvarchar(40),            /*證件號碼                               */
oea911      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai11對應)      */
oea912      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai21對應)      */
oea913      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai31對應)      */
oea914      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai41對應)      */
oea915      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai51對應)      */
oea916      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai61對應)      */
oea917      nvarchar(1),             /*二維輸入                               */
oea918      nvarchar(1) DEFAULT 'n', /*訂金立帳分期                           */
oea919      nvarchar(1) DEFAULT 'n', /*尾款立帳分期                           */
oea92       nvarchar(20),            /*贈品發放單號                           */
oea93       nvarchar(20),            /*返券發放單號                           */
oea94       nvarchar(20),            /*POS單號                                */
oea99       nvarchar(17),            /*多角貿易流程序號                       */
                                     /*多角貿易流程序號 No.7946 03/08/27 Kammy*/
oeaconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否 (Y/N/X)                         */
oeacont     nvarchar(8),             /*審核時間                               */
oeaconu     nvarchar(10),            /*審核人員                               */
oeadate     datetime,                /*最近修改日                             */
oeadays     smallint,                /*簽核完成天數                           */
oeagrup     nvarchar(10),            /*資料所有部門                           */
oeahold     nvarchar(10),            /*留置原因碼                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oealegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oeamksg     nvarchar(1),             /*是否簽核                               */
                                     /*本欄位可控制此張採購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oeamodu     nvarchar(10),            /*資料修改者                             */
oeaorig     nvarchar(10),            /*資料建立部門                           */
oeaoriu     nvarchar(10),            /*資料建立者                             */
oeaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oeaprit     smallint,                /*簽核優先等級                           */
oeaprsw     smallint,                /*訂單列印次數                           */
oeasign     nvarchar(4),             /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeaslk01    nvarchar(20),            /*出口國                                 */
oeaslk02    nvarchar(1) DEFAULT 'N' NOT NULL, /*款式明細*/
oeasmax     smallint,                /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeasseq     smallint,                /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeaud01     nvarchar(255),           /*自訂欄位                               */
oeaud02     nvarchar(40),            /*自訂欄位                               */
oeaud03     nvarchar(40),            /*自訂欄位                               */
oeaud04     nvarchar(40),            /*自訂欄位                               */
oeaud05     nvarchar(40),            /*自訂欄位                               */
oeaud06     nvarchar(40),            /*自訂欄位                               */
oeaud07     decimal(18),             /*自訂欄位                               */
oeaud08     decimal(18),             /*自訂欄位                               */
oeaud09     decimal(18),             /*自訂欄位                               */
oeaud10     integer,                 /*自訂欄位                               */
oeaud11     integer,                 /*自訂欄位                               */
oeaud12     integer,                 /*自訂欄位                               */
oeaud13     datetime,                /*自訂欄位                               */
oeaud14     datetime,                /*自訂欄位                               */
oeaud15     datetime,                /*自訂欄位                               */
oeauser     nvarchar(10)             /*資料所有者                             */
);

create        index oea99 on oea_file (oea99);
create        index oea_02 on oea_file (oea02);
create        index oea_03 on oea_file (oea03);
alter table oea_file add constraint oea_pk primary key  (oea01);
grant select on oea_file to tiptopgp;
grant update on oea_file to tiptopgp;
grant delete on oea_file to tiptopgp;
grant insert on oea_file to tiptopgp;
grant references on oea_file to tiptopgp;
grant references on oea_file to ods;
grant select on oea_file to ods;
