/*
================================================================================
檔案代號:oew_file
檔案名稱:訂單(合約)單頭暫存檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oew_file
(
oew00       nvarchar(1),             /*類別                                   */
                                     /*類別 (0.合約 1.正常訂單 2.換貨訂單)    */
                                     /*  換貨訂單為銷退不追訂單而再開立者,    */
                                     /*  換貨訂單不計入銷貨統計               */
oew01       nvarchar(20) NOT NULL,   /*訂單單號/合約單號                      */
oew02       datetime,                /*訂單日期/合約日期                      */
oew03       nvarchar(10),            /*帳款客戶編號                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oew032      nvarchar(40),            /*帳款客戶簡稱                           */
oew033      nvarchar(20),            /*帳款客戶統一編號                       */
oew04       nvarchar(10),            /*送貨客戶編號                           */
                                     /*送貨客戶編號 occ01                     */
oew044      nvarchar(10),            /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oep_file)*/
oew05       nvarchar(5),             /*發票別                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oew06       nvarchar(10),            /*修改版本                               */
oew07       nvarchar(1),             /*出貨是否計入未開發票的銷貨             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oew08       nvarchar(1),             /*1.內銷 2.外銷 3.視同外銷訂單           */
oew09       smallint NOT NULL,       /*允許超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oew10       nvarchar(20),            /*客戶訂單單號                           */
oew11       nvarchar(1),             /*訂單來源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
oew12       nvarchar(20),            /*銷退單號/合約單號                      */
                                     /*銷退單號/合約單號oha01/oew01,oew00='0' */
oew14       nvarchar(10),            /*人員編號                               */
                                     /*人員編號   gen01                       */
oew15       nvarchar(10),            /*部門編號                               */
                                     /*部門編號   gem01                       */
oew161      smallint,                /*訂金應收比率                           */
oew162      smallint,                /*出貨應收比率                           */
oew163      smallint,                /*尾款應收比率                           */
oew17       nvarchar(10),            /*收款客戶編號                           */
                                     /*收款客戶編號 occ01                     */
oew18       nvarchar(1),             /*是否採用訂單匯率立帳                   */
oew19       nvarchar(80),            /*NOTIFY                                 */
oew20       nvarchar(1),             /*是否直接送貨至客戶                     */
oew21       nvarchar(4),             /*稅別                                   */
                                     /*稅別       gec01                       */
oew211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oew212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oew213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oew23       nvarchar(4),             /*幣別                                   */
                                     /*幣別   azi01                           */
oew24       decimal(18),             /*匯率                                   */
oew25       nvarchar(10),            /*銷售分類一                             */
                                     /*銷售分類一 oab01                       */
oew26       nvarchar(10),            /*銷售分類二                             */
                                     /*銷售分類二 oab01                       */
oew27       nvarchar(1),             /*No Use                                 */
oew28       nvarchar(1),             /*No Use                                 */
oew29       nvarchar(1),             /*No Use                                 */
oew30       nvarchar(1),             /*No Use                                 */
oew31       nvarchar(6),             /*價格條件編號                           */
                                     /*價格條件編號 oah01                     */
oew32       nvarchar(6),             /*收款條件編號                           */
                                     /*收款條件編號 oag01                     */
oew33       nvarchar(80),            /*其它條件                               */
oew34       decimal(18),             /*佣金率%或佣金金額                      */
oew35       nvarchar(10),            /*卸貨港                                 */
                                     /*卸貨港 oac01                           */
oew36       nvarchar(10),            /*產證                                   */
oew37       nvarchar(1),             /*佣金方式                               */
                                     /*佣金方式 1:比率->佣金=金額*oew34/100   */
                                     /*         2:金額->佣金=oew34            */
oew38       nvarchar(10),            /*forwader                               */
oew39       nvarchar(4),             /*佣金幣別                               */
oew40       nvarchar(10),            /*佣金對象                               */
oew41       nvarchar(10),            /*起運地                                 */
                                     /*起運地  oac01                          */
oew42       nvarchar(10),            /*到達地                                 */
                                     /*到達地  oac01                          */
oew43       nvarchar(20),            /*交運方式                               */
oew44       nvarchar(10),            /*嘜頭代號                               */
                                     /*嘜頭代號 ocf02,ocf01=oew03             */
oew45       nvarchar(40),            /*聯絡人                                 */
oew46       nvarchar(10),            /*專案編號                               */
oew47       nvarchar(1),             /*No Use                                 */
oew48       nvarchar(1),             /*No Use                                 */
oew49       nvarchar(1),             /*No Use                                 */
oew50       nvarchar(1),             /*是否作CSD展開                          */
oew51       nvarchar(40),            /*CSD:產品品號                           */
oew52       datetime,                /*CSD:BOM 有效日期                       */
oew53       decimal(18),             /*CSD:套數                               */
oew54       decimal(18),             /*CSD:原幣售價                           */
oew55       decimal(18),             /*CSD:原幣金額                           */
oew56       nvarchar(10),            /*CSD:出貨營運中心                       */
oew57       nvarchar(10),            /*CSD:出貨倉庫                           */
oew58       nvarchar(10),            /*CSD:出貨儲位                           */
oew59       datetime,                /*CSD:預計交貨日                         */
oew61       decimal(18) NOT NULL,    /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oew62       decimal(18) NOT NULL,    /*已出貨未稅金額                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oew63       decimal(18) NOT NULL,    /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oew71       nvarchar(4),             /*是否轉入正式訂單                       */
                                     /*是否轉入正式訂單(Y/N)   add 與oea不同  */
oew72       datetime,                /*首次確認日                             */
                                     /*首次確認日 (第一次確認時更新)          */
oew901      nvarchar(1),             /*角貿易否                               */
oew902      nvarchar(1),             /*最終訂單否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oew903      nvarchar(1),             /*營業額申報方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oew904      nvarchar(2),             /*三角貿易流程代碼                       */
                                     /*三角貿易流程代碼->oai_file             */
oew905      nvarchar(1),             /*三角貿易拋轉否                         */
oew906      nvarchar(1),             /*三角貿易來源訂單否                     */
oew907      nvarchar(1),             /*No Use                                 */
oew908      nvarchar(1),             /*No Use                                 */
oew909      nvarchar(1),             /*No Use                                 */
oew911      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai11對應)      */
oew912      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai21對應)      */
oew913      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai31對應)      */
oew914      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai41對應)      */
oew915      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai51對應)      */
oew916      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai61對應)      */
oewconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否 (Y/N)                           */
oewdate     datetime,                /*最近修改日                             */
oewdays     smallint,                /*簽核完成天數                           */
oewgrup     nvarchar(10),            /*資料所有部門                           */
oewhold     nvarchar(10),            /*留置原因碼                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oewlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oewmksg     nvarchar(1),             /*是否簽核                               */
                                     /*本欄位可控制此張訂購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oewmodu     nvarchar(10),            /*資料修改者                             */
oeworig     nvarchar(10),            /*資料建立部門                           */
oeworiu     nvarchar(10),            /*資料建立者                             */
oewplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oewprit     smallint,                /*簽核優先等級                           */
oewprsw     smallint,                /*訂單列印次數                           */
oewsign     nvarchar(4),             /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewsmax     smallint,                /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewsseq     smallint,                /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewuser     nvarchar(10)             /*資料所有者                             */
);

alter table oew_file add constraint oew_pk primary key  (oew01);
grant select on oew_file to tiptopgp;
grant update on oew_file to tiptopgp;
grant delete on oew_file to tiptopgp;
grant insert on oew_file to tiptopgp;
grant references on oew_file to tiptopgp;
grant references on oew_file to ods;
grant select on oew_file to ods;
