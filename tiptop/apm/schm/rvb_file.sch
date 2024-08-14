/*
================================================================================
檔案代號:rvb_file
檔案名稱:收貨單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvb_file
(
rvb01       nvarchar(20) NOT NULL,   /*收貨單號                               */
                                     /*收貨單號  rva01                        */
                                     /*儲存該次的採購收貨收貨單號。           */
rvb02       smallint NOT NULL,       /*收貨單項次                             */
                                     /*儲存該次的採購收貨收貨單的收貨項次。   */
rvb03       smallint,                /*採購單項次                             */
                                     /*採購單項次 pmn02                       */
                                     /*儲存該次的採購收貨收貨單的收貨項次的對 */
                                     /*應採購單的採購項次。                   */
                                     /*如為「委外代買料件」收貨時，則其項次固 */
                                     /*定為「0」。                            */
rvb04       nvarchar(20),            /*採購單號                               */
                                     /*採購單號  pmm01(pmn01)                 */
                                     /*儲存該次的採購收貨收貨單的收貨項次的對 */
                                     /*應採購單號。                           */
rvb05       nvarchar(40),            /*料件代碼                               */
                                     /*料件編號  ima01 -->pmn041              */
                                     /*儲存該次的採購收貨料件的編號。         */
rvb051      nvarchar(120),           /*品名規格                               */
rvb06       decimal(18) NOT NULL,    /*已請款量                               */
                                     /*儲存該次的採購收貨收貨量中已被請款的數 */
                                     /*量。                                   */
                                     /*該量=rvv23(已請款批配量)               */
rvb07       decimal(18) NOT NULL,    /*實收數量                               */
                                     /*儲存該次的採購收貨收貨的實際數量。     */
rvb08       decimal(18) NOT NULL,    /*收貨數量                               */
                                     /*儲存該次的採購收貨收貨單上的註明數量。 */
rvb09       decimal(18) NOT NULL,    /*允請款量                               */
                                     /*儲存該次的採購收貨收貨量中被認可允許請 */
                                     /*款量。                                 */
rvb10       decimal(18) NOT NULL,    /*收料單價                               */
                                     /*收料單價(原幣)                         */
                                     /*儲存該次的採購收貨料件的原幣單價。     */
rvb10t      decimal(18),             /*含稅單價                               */
rvb11       smallint,                /*代買項次                               */
                                     /*如為「委外代買料件」收貨時的對應代買項 */
                                     /*次。                                   */
                                     /*如為非「委外代買料件」收貨時，則固定為 */
                                     /*「0」。                                */
rvb12       datetime,                /*收貨應完成日期                         */
                                     /*儲存該次的採購收貨料件需完成驗驗的最遲 */
                                     /*日期。                                 */
rvb13       nvarchar(24),            /*廠商批號                               */
                                     /*儲存該次的採購收貨料件的廠商出廠批號； */
                                     /*如該廠商無此產品管制批號，則為「空白」。*/
rvb14       nvarchar(10),            /*容器代號                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器種 */
                                     /*類代號；如箱、筐、籮。                 */
rvb15       decimal(18),             /*容器裝數                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器的 */
                                     /*裝貨量（計量單位為採購單位）。         */
rvb16       decimal(18),             /*容器數目                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器數。*/
                                     /*容器數量*容器數目=實收數量             */
rvb17       nvarchar(24),            /*檢驗批號                               */
                                     /*儲存該次的採購收貨料件的設定檢驗批號， */
                                     /*裝貨量（計量單位為採購單位）。         */
rvb18       nvarchar(2),             /*收貨狀況                               */
                                     /*儲存該收貨料件目前處理狀況。           */
                                     /*系統自行維護。                         */
                                     /*正確值可區分為三階段，「10/20/30」。   */
                                     /*10: 在「收貨檢驗區」中                 */
                                     /*20: 在「會驗區（MRB）」中(已無此狀況)  */
                                     /*30: 入「庫存」                         */
rvb19       nvarchar(1),             /*收貨性質                               */
                                     /*儲存該收貨依據來源。                   */
                                     /*系統自行維護。                         */
                                     /*正確值為「1/2」。                      */
                                     /*1: 採購單收貨                          */
                                     /*2: 委外代買料件收貨                    */
rvb20       nvarchar(10),            /*料件無法入庫是否繼續執行               */
rvb21       smallint,                /*保稅過帳否                             */
                                     /*0:未確認                               */
                                     /*1:確認                                 */
rvb22       nvarchar(20),            /*發票編號                               */
                                     /*儲存該筆收貨項次對應之發票號碼         */
rvb25       nvarchar(20),            /*手冊編號                               */
                                     /*手冊編號  (A050)                       */
rvb26       datetime,                /*No Use                                 */
rvb27       decimal(18),             /*No Use                                 */
rvb28       decimal(18),             /*No Use                                 */
rvb29       decimal(18) NOT NULL,    /*退貨量                                 */
                                     /*儲存該收貨被「退貨」量                 */
rvb30       decimal(18) NOT NULL,    /*入庫量                                 */
                                     /*儲存該收貨已檢驗「入庫」的數量。       */
rvb31       decimal(18) NOT NULL,    /*可入庫量                               */
                                     /*儲存該收貨尚可被「入庫」的數量，亦即為 */
                                     /*rvb07-rvb29-rvb30                      */
rvb32       decimal(18),             /*退扣                                   */
rvb33       decimal(18),             /*允收數量                               */
                                     /*允收數量 (由QC人員於輸入檢驗結果時輸入)*/
rvb331      decimal(18),             /*允收數量一                             */
rvb332      decimal(18),             /*允收數量二                             */
rvb34       nvarchar(20),            /*工單號碼                               */
                                     /*工單號碼(97/05/01) sfb01               */
rvb35       nvarchar(1),             /*樣品否                                 */
                                     /*樣品否(97/05/09)                       */
rvb36       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫  (97/07/21) imd01(img02)(imf02)   */
rvb37       nvarchar(10),            /*儲位                                   */
                                     /*儲位  (97/07/21) ime01(img03)No.+024   */
rvb38       nvarchar(24),            /*批號                                   */
                                     /*批號  (97/07/21)       img04  No.+024  */
rvb39       nvarchar(1),             /*檢驗否                                 */
                                     /*檢驗否   NO:7143                       */
rvb40       datetime,                /*檢驗日期                               */
                                     /*檢驗日期 NO:7143                       */
rvb41       nvarchar(40),            /*檢驗結果                               */
                                     /*檢驗結果 NO:7143                       */
rvb42       nvarchar(1) DEFAULT ' ' NOT NULL, /*取價類型 1-搭贈,2-促銷協議,3- */
rvb43       nvarchar(20),            /*價格來源                               */
rvb44       nvarchar(20),            /*來源單號                               */
rvb45       smallint,                /*來源項次                               */
rvb80       nvarchar(4),             /*單位一                                 */
rvb81       decimal(18),             /*單位一換算率(與採購單位)               */
rvb82       decimal(18),             /*單位一數量                             */
rvb83       nvarchar(4),             /*單位二                                 */
rvb84       decimal(18),             /*單位二換算率(與採購單位)               */
rvb85       decimal(18),             /*單位二數量                             */
rvb86       nvarchar(4),             /*計價單位                               */
rvb87       decimal(18),             /*計價數量                               */
rvb88       decimal(18),             /*未稅金額                               */
rvb88t      decimal(18),             /*含稅金額                               */
rvb89       nvarchar(1) DEFAULT 'N', /*VMI收貨否                              */
rvb90       nvarchar(4),             /*收貨單位                               */
rvb90_fac   decimal(18),             /*收貨單位與庫存單位間的轉換             */
rvb919      nvarchar(50),            /*計畫批號                               */
rvb93       nvarchar(15),            /*電子交貨序號                           */
rvb930      nvarchar(10),            /*成本中心                               */
rvblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
rvbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
rvbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
rvbud02     nvarchar(40),            /*自訂欄位-文字                          */
rvbud03     nvarchar(40),            /*自訂欄位-文字                          */
rvbud04     nvarchar(40),            /*自訂欄位-文字                          */
rvbud05     nvarchar(40),            /*自訂欄位-文字                          */
rvbud06     nvarchar(40),            /*自訂欄位-文字                          */
rvbud07     decimal(18),             /*自訂欄位-數值                          */
rvbud08     decimal(18),             /*自訂欄位-數值                          */
rvbud09     decimal(18),             /*自訂欄位-數值                          */
rvbud10     integer,                 /*自訂欄位-整數                          */
rvbud11     integer,                 /*自訂欄位-整數                          */
rvbud12     integer,                 /*自訂欄位-整數                          */
rvbud13     datetime,                /*自訂欄位-日期                          */
rvbud14     datetime,                /*自訂欄位-日期                          */
rvbud15     datetime                 /*自訂欄位-日期                          */
);

create        index rvb_02 on rvb_file (rvb04,rvb03);
create        index rvb_03 on rvb_file (rvb05);
create        index rvbplant_idx on rvb_file (rvbplant);
alter table rvb_file add constraint rvb_pk primary key  (rvb01,rvb02);
grant select on rvb_file to tiptopgp;
grant update on rvb_file to tiptopgp;
grant delete on rvb_file to tiptopgp;
grant insert on rvb_file to tiptopgp;
grant references on rvb_file to tiptopgp;
grant references on rvb_file to ods;
grant select on rvb_file to ods;
