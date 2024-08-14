/*
================================================================================
檔案代號:oey_file
檔案名稱:訂單(合約)單頭暫存檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oey_file
(
oey00       nvarchar(1),             /*類別                                   */
                                     /*類別 (0.合約 1.正常訂單 2.換貨訂單)    */
                                     /*  換貨訂單為銷退不追訂單而再開立者,    */
                                     /*  換貨訂單不計入銷貨統計               */
oey01       nvarchar(20) NOT NULL,   /*訂單單號/合約單號                      */
oey02       datetime,                /*訂單日期/合約日期                      */
oey03       nvarchar(10),            /*帳款客戶編號                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oey032      nvarchar(40),            /*帳款客戶簡稱                           */
oey033      nvarchar(20),            /*帳款客戶統一編號                       */
oey04       nvarchar(10),            /*送貨客戶編號                           */
                                     /*送貨客戶編號 occ01                     */
oey044      nvarchar(10),            /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oep_file)*/
oey05       nvarchar(5),             /*發票別                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oey06       nvarchar(10),            /*修改版本                               */
oey07       nvarchar(1),             /*出貨是否計入未開發票的銷貨             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oey08       nvarchar(1),             /*1.內銷 2.外銷 3.視同外銷訂單           */
oey09       smallint NOT NULL,       /*允許超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oey10       nvarchar(20),            /*客戶訂單單號                           */
oey11       nvarchar(1),             /*訂單來源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
oey12       nvarchar(20),            /*銷退單號/合約單號                      */
                                     /*銷退單號/合約單號oha01/oey01,oey00='0' */
oey14       nvarchar(10),            /*人員編號                               */
                                     /*人員編號   gen01                       */
oey15       nvarchar(10),            /*部門編號                               */
                                     /*部門編號   gem01                       */
oey161      smallint,                /*訂金應收比率                           */
oey162      smallint,                /*出貨應收比率                           */
oey163      smallint,                /*尾款應收比率                           */
oey17       nvarchar(10),            /*收款客戶編號                           */
                                     /*收款客戶編號 occ01                     */
oey18       nvarchar(1),             /*是否採用訂單匯率立帳                   */
oey19       nvarchar(80),            /*NOTIFY                                 */
oey20       nvarchar(1),             /*是否直接送貨至客戶                     */
oey21       nvarchar(4),             /*稅別                                   */
                                     /*稅別       gec01                       */
oey211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oey212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oey213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oey23       nvarchar(4),             /*幣別                                   */
                                     /*幣別   azi01                           */
oey24       decimal(18),             /*匯率                                   */
oey25       nvarchar(10),            /*銷售分類一                             */
                                     /*銷售分類一 oab01                       */
oey26       nvarchar(10),            /*銷售分類二                             */
                                     /*銷售分類二 oab01                       */
oey27       nvarchar(1),             /*No Use                                 */
oey28       nvarchar(1),             /*No Use                                 */
oey29       nvarchar(1),             /*No Use                                 */
oey30       nvarchar(1),             /*No Use                                 */
oey31       nvarchar(6),             /*價格條件編號                           */
                                     /*價格條件編號 oah01                     */
oey32       nvarchar(6),             /*收款條件編號                           */
                                     /*收款條件編號 oag01                     */
oey33       nvarchar(80),            /*其它條件                               */
oey34       decimal(18),             /*佣金率%或佣金金額                      */
oey35       nvarchar(10),            /*卸貨港                                 */
                                     /*卸貨港 oac01                           */
oey36       nvarchar(10),            /*產證                                   */
oey37       nvarchar(1),             /*佣金方式                               */
                                     /*佣金方式 1:比率->佣金=金額*oey34/100   */
                                     /*         2:金額->佣金=oey34            */
oey38       nvarchar(10),            /*forwader                               */
oey39       nvarchar(4),             /*佣金幣別                               */
oey40       nvarchar(10),            /*佣金對象                               */
oey41       nvarchar(10),            /*起運地                                 */
                                     /*起運地  oac01                          */
oey42       nvarchar(10),            /*到達地                                 */
                                     /*到達地  oac01                          */
oey43       nvarchar(20),            /*交運方式                               */
oey44       nvarchar(10),            /*嘜頭代號                               */
                                     /*嘜頭代號 ocf02,ocf01=oey03             */
oey45       nvarchar(40),            /*聯絡人                                 */
oey46       nvarchar(10),            /*專案編號                               */
oey47       nvarchar(1),             /*No Use                                 */
oey48       nvarchar(1),             /*No Use                                 */
oey49       nvarchar(1),             /*No Use                                 */
oey50       nvarchar(1),             /*是否作CSD展開                          */
oey51       nvarchar(40),            /*CSD:產品品號                           */
oey52       datetime,                /*CSD:BOM 有效日期                       */
oey53       decimal(18),             /*CSD:套數                               */
oey54       decimal(18),             /*CSD:原幣售價                           */
oey55       decimal(18),             /*CSD:原幣金額                           */
oey56       nvarchar(10),            /*CSD:出貨營運中心                       */
oey57       nvarchar(10),            /*CSD:出貨倉庫                           */
oey58       nvarchar(10),            /*CSD:出貨儲位                           */
oey59       datetime,                /*CSD:預計交貨日                         */
oey61       decimal(18) NOT NULL,    /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oey62       decimal(18) NOT NULL,    /*已出貨未稅金額                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oey63       decimal(18) NOT NULL,    /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oey71       nvarchar(4),             /*No Use                                 */
oey72       datetime,                /*首次確認日                             */
                                     /*首次確認日 (第一次確認時更新)          */
oey901      nvarchar(1),             /*三角貿易否                             */
oey902      nvarchar(1),             /*最終訂單否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oey903      nvarchar(1),             /*營業額申報方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oey904      nvarchar(2),             /*三角貿易流程代碼                       */
                                     /*三角貿易流程代碼->oai_file             */
oey905      nvarchar(1),             /*三角貿易拋轉否                         */
oey906      nvarchar(1),             /*三角貿易來源訂單否                     */
oey907      nvarchar(1),             /*No Use                                 */
oey908      nvarchar(1),             /*No Use                                 */
oey909      nvarchar(1),             /*No Use                                 */
oey911      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai11對應)      */
oey912      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai21對應)      */
oey913      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai31對應)      */
oey914      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai41對應)      */
oey915      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai51對應)      */
oey916      nvarchar(10),            /*下游廠商對應客戶編號                   */
                                     /*下游廠商對應客戶編號(與oai61對應)      */
oeyconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否 (Y/N)                           */
oeydate     datetime,                /*最近修改日                             */
oeydays     smallint,                /*簽核完成天數                           */
oeygrup     nvarchar(10),            /*資料所有部門                           */
oeyhold     nvarchar(10),            /*留置原因碼                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oeylegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oeymksg     nvarchar(1),             /*是否簽核                               */
                                     /*本欄位可控制此張訂購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oeymodu     nvarchar(10),            /*資料修改者                             */
oeyorig     nvarchar(10),            /*資料建立部門                           */
oeyoriu     nvarchar(10),            /*資料建立者                             */
oeyplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oeyprit     smallint,                /*簽核優先等級                           */
oeyprsw     smallint,                /*訂單列印次數                           */
oeysign     nvarchar(4),             /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeysmax     smallint,                /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeysseq     smallint,                /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeyuser     nvarchar(10)             /*資料所有者                             */
);

alter table oey_file add constraint oey_pk primary key  (oey01);
grant select on oey_file to tiptopgp;
grant update on oey_file to tiptopgp;
grant delete on oey_file to tiptopgp;
grant insert on oey_file to tiptopgp;
grant references on oey_file to tiptopgp;
grant references on oey_file to ods;
grant select on oey_file to ods;
