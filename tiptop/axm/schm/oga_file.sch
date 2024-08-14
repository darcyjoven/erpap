/*
================================================================================
檔案代號:oga_file
檔案名稱:出貨單單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oga_file
(
oga00       nvarchar(1),             /*出貨別                                 */
                                     /* 1.正常出貨:沖正常訂單                 */
                                     /* 2.換貨出貨:沖換貨訂單                 */
                                     /* 3.出至境外倉                          */
                                     /* 4.境外倉出貨                          */
                                     /* 5.BU 間銷售                           */
                                     /* 6.調貨訂單                            */
                                     /* 7.寄銷訂單                            */
                                     /* A.借貨出貨                            */
                                     /* B.借貨償價                            */
                                     /*欄位值:                                */
                                     /*  1.一般出貨                           */
                                     /*  2.換貨出貨                           */
                                     /*  3.出至境外倉                         */
                                     /*  4.境外倉出貨                         */
                                     /*  5.BU間銷售                           */
                                     /*  6.調貨出貨                           */
                                     /*  7.寄銷出貨                           */
                                     /*  A.借貨出貨                           */
                                     /*  B.借貨償價                           */
oga01       nvarchar(20) NOT NULL,   /*出貨單號                               */
oga011      nvarchar(20),            /*出貨通知單號                           */
                                     /*出貨通知單號 oga01,oga09='1'           */
oga02       datetime,                /*出貨日期                               */
oga021      datetime,                /*結關日期                               */
oga022      datetime,                /*裝船日期                               */
oga03       nvarchar(10),            /*帳款客戶編號                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oga032      nvarchar(40),            /*帳款客戶簡稱                           */
oga033      nvarchar(20),            /*帳款客戶統一編號                       */
oga04       nvarchar(10),            /*送貨客戶編號                           */
                                     /*送貨客戶編號   occ1                    */
oga044      nvarchar(10),            /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時輸入送貨地址 (oap_file)    */
oga05       nvarchar(5),             /*發票別                                 */
                                     /*發票別(自動發票開窗時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oga06       nvarchar(1),             /*修改版本                               */
oga07       nvarchar(1),             /*出貨是否計入未開發票的銷貨             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oga08       nvarchar(1),             /*1.內銷 2.外銷  3.視同外銷              */
                                     /*1.內銷 2.外銷  3.視同外銷->no.A047     */
                                     /*欄位值:                                */
                                     /*  1.內銷                               */
                                     /*  2.外銷                               */
                                     /*  3.視同外銷(合約系統使用)             */
oga09       nvarchar(1),             /*單據別                                 */
                                     /*單據別(1.出貨通知單 2.一般出貨單       */
                                     /*       3.無訂單出貨單 4.三角貿易出貨單 */
                                     /*       5.三角貿易出貨通知單            */
                                     /*       6.代採買出貨單                  */
                                     /*       8.客戶驗收單                    */
                                     /*       9.客戶驗退單                    */
                                     /*       A.借貨出貨單                    */
oga10       nvarchar(20),            /*帳單編號                               */
                                     /*帳單編號 oma01                         */
oga1001     nvarchar(10),            /*收款客戶代號                           */
oga1002     nvarchar(10),            /*債權代碼                               */
oga1003     nvarchar(10),            /*業績歸屬組織                           */
oga1004     nvarchar(10),            /*調貨客戶                               */
oga1005     nvarchar(1),             /*是否計算業績                           */
oga1006     decimal(18),             /*折扣金額(未稅)                         */
oga1007     decimal(18),             /*折扣金額(含稅)                         */
oga1008     decimal(18),             /*出貨總含稅金額                         */
oga1009     nvarchar(10),            /*客戶所屬通路                           */
oga1010     nvarchar(10),            /*客戶所屬組織                           */
oga1011     nvarchar(10),            /*開票客戶                               */
oga1012     nvarchar(20),            /*銷退單單號                             */
oga1013     nvarchar(1),             /*已列印提單否                           */
oga1014     nvarchar(1),             /*調貨銷退單所自動產生否                 */
oga1015     nvarchar(1),             /*導物流狀況碼                           */
                                     /*欄位值:                                */
                                     /*  0.未導出                             */
                                     /*  1.已導3C                             */
                                     /*  2.3C回饋                             */
                                     /*  3.已導2E                             */
                                     /*  4.2E回饋                             */
                                     /*  5.已導2C                             */
                                     /*  6.2C回饋                             */
oga1016     nvarchar(10),            /*代送商                                 */
oga11       datetime,                /*應收款日                               */
oga12       datetime,                /*容許票據到期日                         */
oga13       nvarchar(10),            /*科目分類碼                             */
oga14       nvarchar(10),            /*人員編號                               */
                                     /*人員編號 gen01                         */
oga15       nvarchar(10),            /*部門編號                               */
                                     /*部門編號 gem01                         */
oga16       nvarchar(20),            /*訂單單號                               */
                                     /*訂單單號 oea01                         */
                                     /*  有預收訂金時, 本單號一定要輸入       */
                                     /*  有預收訂金時, 一張出貨僅可沖一張訂單 */
oga161      smallint NOT NULL,       /*訂金應收比率                           */
oga162      smallint NOT NULL,       /*出貨應收比率                           */
oga163      smallint NOT NULL,       /*尾款應收比率                           */
oga17       smallint,                /*排貨模擬順序                           */
oga18       nvarchar(10),            /*收款客戶編號                           */
                                     /*收款客戶編號 occ01                     */
oga19       nvarchar(20),            /*待抵帳款-預收單號                      */
                                     /*待抵帳款-預收單號 (No-Entry)           */
                                     /*  有預收訂金時, 會由訂單單號帶出本單號 */
oga20       nvarchar(1),             /*分錄底稿是否可重新產生                 */
                                     /*分錄底稿是否可重新產生(Y/N)            */
                                     /*  設為'N'時表示分錄底稿有經過人為修改, */
                                     /*  當執行'分錄產生'時, 不可再產生       */
oga21       nvarchar(4),             /*稅別                                   */
                                     /*稅別 gec01                             */
oga211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改) gec04     */
oga212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改) gec05     */
                                     /*欄位值:                                */
                                     /*  0.園區收據                           */
                                     /*  2.二聯                               */
                                     /*  3.三聯                               */
                                     /*  X.不申報                             */
oga213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改) gec07     */
oga23       nvarchar(4),             /*幣別                                   */
                                     /*幣別 azi01                             */
oga24       decimal(18),             /*匯率                                   */
oga25       nvarchar(10),            /*銷售分類一                             */
                                     /*銷售分類一 oab01                       */
oga26       nvarchar(10),            /*銷售分類二                             */
                                     /*銷售分類二 oab01                       */
oga27       nvarchar(20),            /*Invoice No.                            */
                                     /*Invoice#                        98/11/01*/
oga28       nvarchar(1),             /*立帳時採用訂單匯率                     */
                                     /*立帳時採用訂單匯率              98/11/01*/
oga29       decimal(18),             /*信用額度餘額                           */
                                     /*信用額度餘額 (於確認時更新)            */
oga30       nvarchar(1),             /*包裝單確認碼                           */
                                     /*包裝單確認碼 (Y/N)                     */
oga31       nvarchar(6),             /*價格條件編號                           */
                                     /*價格條件編號 oah01                     */
oga32       nvarchar(6),             /*收款條件編號                           */
                                     /*收款條件編號 oag01                     */
oga33       nvarchar(255),           /*其它條件                               */
oga34       smallint,                /*佣金率                                 */
oga35       nvarchar(1),             /*外銷方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7/8)              */
                                     /*1.外銷貨物。                           */
                                     /*2.與外銷有關之勞務,或在國內提供而在國外*/
                                     /*  使用之勞務。                         */
                                     /*3.依法設立之免稅商店銷售與過境旅客之貨物*/
                                     /*4.銷售與免稅出口內之外銷事業,科學工業園*/
                                     /*  區內之園區事業,海關管理保稅營運中心或保稅*/
                                     /*  營運中心或保稅倉庫之機器設備,原料,物料,燃*/
                                     /*  料,半製品。                          */
                                     /*5.國際間之運輸.但外國國際運輸事業在國內*/
                                     /*  境內經營國際運輸業者,應以各該國對國內*/
                                     /*  國際運輸事業予以相等待遇或免徵類似稅 */
                                     /*  捐者為限。                           */
                                     /*6.國際運輸用之船舶,航空器及遠洋漁船。  */
                                     /*7.銷售與國際運輸用之船舶,航空器及遠洋漁*/
                                     /*  船所使用之貨物或修繕勞務。           */
                                     /*8.外銷不申報                           */
oga36       nvarchar(8),             /*非經海關証明文件名稱                   */
oga37       nvarchar(16),            /*非經海關証明文件號碼                   */
oga38       nvarchar(10),            /*出口報單類別                           */
oga39       nvarchar(30),            /*出口報單號碼                           */
oga40       nvarchar(1),             /*NOTIFY                                 */
                                     /*NOTIFY                          98/11/01*/
oga41       nvarchar(10),            /*起運地                                 */
                                     /*起運地 oac01                           */
oga42       nvarchar(10),            /*到達地                                 */
                                     /*到達地 oac01                           */
oga43       nvarchar(15),            /*交運方式                               */
oga44       nvarchar(10),            /*嘜頭編號                               */
                                     /*嘜頭編號 ocf02,ocf01=oga03             */
oga45       nvarchar(40),            /*聯絡人                                 */
oga46       nvarchar(10),            /*專案編號                               */
oga47       nvarchar(20),            /*船名/車號                              */
oga48       nvarchar(20),            /*航次                                   */
oga49       datetime,                /*Sailing Date                           */
oga50       decimal(18) NOT NULL,    /*原幣出貨金額                           */
                                     /*原幣出貨金額(未稅)                     */
oga501      decimal(18),             /*本幣出貨金額                           */
                                     /*nouse  #No.9347                        */
oga51       decimal(18),             /*原幣出貨金額                           */
                                     /*原幣出貨金額(含稅)              98/11/01*/
oga511      decimal(18),             /*本幣出貨金額                           */
                                     /*nouse  #No.9347                        */
oga52       decimal(18) NOT NULL,    /*原幣預收訂金轉銷貨收入金額             */
oga53       decimal(18) NOT NULL,    /*原幣應開發票未稅金額                   */
oga54       decimal(18) NOT NULL,    /*原幣已開發票未稅金額                   */
oga55       nvarchar(1),             /*狀況碼                                 */
                                     /*No use                                 */
                                     /*欄位值:                                */
                                     /*  0.開立                               */
                                     /*  1.已核准                             */
                                     /*  9.作廢                               */
                                     /*  R.送簽退回                           */
                                     /*  S.送簽中                             */
                                     /*  W.抽單                               */
oga65       nvarchar(1),             /*客戶出貨簽收否                         */
oga66       nvarchar(10),            /*出貨簽收在途/驗退倉庫                  */
oga67       nvarchar(10),            /*出貨簽收在途/驗退儲位                  */
oga68       nvarchar(10),            /*No Use                                 */
oga69       datetime,                /*輸入日期                               */
oga70       nvarchar(20),            /*調撥單號                               */
oga71       nvarchar(20),            /*申報統編                               */
oga72       datetime,                /*預計簽收日                             */
oga83       nvarchar(10),            /*銷貨營運中心                           */
oga84       nvarchar(10),            /*取貨營運中心                           */
oga85       nvarchar(1) DEFAULT ' ' NOT NULL, /*結算方式*/
oga86       nvarchar(10),            /*客層代碼                               */
oga87       nvarchar(20),            /*會員卡號                               */
oga88       nvarchar(10),            /*顧客姓名                               */
oga89       nvarchar(20),            /*聯系電話                               */
oga90       nvarchar(10),            /*證件類型                               */
oga901      nvarchar(1),             /*post to abx system flag                */
                                     /*'Y':確認                               */
                                     /*'N':未確認                             */
oga902      nvarchar(10),            /*信用超限留置代碼                       */
                                     /*保稅異動原因                           */
oga903      nvarchar(1),             /*信用查核放行否                         */
                                     /*信用查核放行否(Y/N)                    */
oga904      nvarchar(15),            /*No Use                                 */
oga905      nvarchar(1),             /*已轉三角貿易出貨單否                   */
oga906      nvarchar(1),             /*起始出貨單否                           */
oga907      nvarchar(20),            /*傳票號碼                               */
                                     /*傳票號碼          99/06/28 modify      */
oga908      nvarchar(10),            /*L/C NO                                 */
oga909      nvarchar(1),             /*三角貿易否                             */
                                     /*三角貿易否                      99/05/01*/
oga91       nvarchar(40),            /*證件號碼                               */
oga910      nvarchar(10),            /*境外倉庫                               */
                                     /*境外倉庫                        99/05/07*/
oga911      nvarchar(10),            /*境外儲位                               */
                                     /*境外儲位 No.+024                99/05/07*/
oga912      nvarchar(10),            /*保稅異動原因代碼                       */
oga913      datetime,                /*保稅報單日期                           */
oga914      nvarchar(20),            /*入庫單號                               */
oga92       nvarchar(20),            /*贈品發放單號                           */
oga93       nvarchar(20),            /*返券發放單號                           */
oga94       nvarchar(1) DEFAULT 'N' NOT NULL, /*POS銷售否 Y-是,N-否*/
oga95       smallint,                /*本次積分                               */
oga96       nvarchar(10),            /*收銀機號                               */
oga97       smallint,                /*交易序號                               */
oga98       nvarchar(20),            /*POS單號                                */
oga99       nvarchar(17),            /*多角貿易流程序號                       */
                                     /*多角貿易流程序號 No.7992 03/08/30 Kammy*/
ogacond     datetime,                /*審核日期                               */
ogaconf     nvarchar(1),             /*確認否/作廢碼                          */
                                     /*確認否/作廢碼 (Y/N/X)                  */
                                     /*欄位值:                                */
                                     /*  N.未確認                             */
                                     /*  X.作廢                               */
                                     /*  Y.已確認                             */
ogacont     nvarchar(8),             /*審核時間                               */
ogaconu     nvarchar(10),            /*審核人員                               */
ogadate     datetime,                /*最近修改日                             */
ogagrup     nvarchar(10),            /*資料所有部門                           */
ogalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ogamksg     nvarchar(1),             /*簽核                                   */
ogamodu     nvarchar(10),            /*資料修改者                             */
ogaorig     nvarchar(10),            /*資料建立部門                           */
ogaoriu     nvarchar(10),            /*資料建立者                             */
ogaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ogapost     nvarchar(1),             /*出貨扣帳否                             */
                                     /*出貨扣帳否 (Y.已出貨扣帳 N.尚未)       */
ogaprsw     smallint,                /*列印次數                               */
ogaspc      nvarchar(1),             /*SPC拋轉碼 0/1/2                        */
ogaud01     nvarchar(255),           /*自訂欄位-Textedit                      */
ogaud02     nvarchar(40),            /*自訂欄位-文字                          */
ogaud03     nvarchar(40),            /*自訂欄位-文字                          */
ogaud04     nvarchar(40),            /*自訂欄位-文字                          */
ogaud05     nvarchar(40),            /*自訂欄位-文字                          */
ogaud06     nvarchar(40),            /*自訂欄位-文字                          */
ogaud07     decimal(18),             /*自訂欄位-數值                          */
ogaud08     decimal(18),             /*自訂欄位-數值                          */
ogaud09     decimal(18),             /*自訂欄位-數值                          */
ogaud10     integer,                 /*自訂欄位-整數                          */
ogaud11     integer,                 /*自訂欄位-整數                          */
ogaud12     integer,                 /*自訂欄位-整數                          */
ogaud13     datetime,                /*自訂欄位-日期                          */
ogaud14     datetime,                /*自訂欄位-日期                          */
ogaud15     datetime,                /*自訂欄位-日期                          */
ogauser     nvarchar(10)             /*資料所有者                             */
);

create        index oga99 on oga_file (oga99);
create        index oga_02 on oga_file (oga02);
create        index oga_03 on oga_file (oga03);
create        index oga_04 on oga_file (oga907);
create        index oga_05 on oga_file (oga10);
create        index oga_06 on oga_file (oga011);
alter table oga_file add constraint oga_pk primary key  (oga01);
grant select on oga_file to tiptopgp;
grant update on oga_file to tiptopgp;
grant delete on oga_file to tiptopgp;
grant insert on oga_file to tiptopgp;
grant references on oga_file to tiptopgp;
grant references on oga_file to ods;
grant select on oga_file to ods;
