/*
================================================================================
檔案代號:pon_file
檔案名稱:無交期性採購單單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pon_file
(
pon01       nvarchar(20) NOT NULL,   /*採購單號                               */
                                     /*採購單號 pmm01                         */
pon011      nvarchar(10),            /*單據性質                               */
                                     /*正確值 REG/EXP/SER/CAP/BKR/SUB/DAS/IPO */
                                     /* /RTN                                  */
                                     /*REG:REGular          一般性  採購      */
                                     /*EXP:EXPensed         消耗性  採購      */
                                     /*SER:SERvice          服務性  採購      */
                                     /*CAP:CAPital          資材性  採購      */
                                     /*BKR:BlanKet Regular  無交期性採購      */
                                     /*SUB:SUBcontracted    廠外加工採購      */
                                     /*DAS:De-assembly      套件    採購      */
                                     /*IPO:InterLogistics       多營運中心  採購*/
                                     /*RTN:Returned         退貨補貨採購      */
pon02       smallint NOT NULL,       /*項次                                   */
                                     /*採購單所含蓋的項目編號                 */
pon03       nvarchar(20),            /*詢價單號                               */
                                     /*廠商詢價的詢價單單號                   */
                                     /*所輸入的詢價單號其詢價單上的廠商編號需與*/
                                     /*單頭所指定的供應商編號相同             */
pon04       nvarchar(40),            /*料件編號                               */
                                     /*料件編號 ima01                         */
                                     /*採購料件編號                           */
                                     /*使用者有輸入詢價單號時所輸入的料件需存在*/
                                     /*於所輸入的詢價單號                     */
pon041      nvarchar(120),           /*品名規格                               */
                                     /*為MISC 料件時必須輸入品名規格          */
pon05       nvarchar(20),            /*APS單據編號                            */
                                     /*APS單據編號   no.4649 02/03/15(modify) */
pon06       nvarchar(40),            /*廠商料件編號                           */
                                     /*廠商料件編號 pmh04,pmh01=pon04,pmh02=pmm*/
                                     /*廠商可能針對料件做自已的編號, 本欄位記錄*/
                                     /*的即為廠商所編的料件編號               */
pon07       nvarchar(4),             /*採購單位                               */
                                     /*採購單位 gfe01                         */
                                     /*本系統可使用多單位的採購               */
                                     /*當單位不同時系統會自動轉換相對應的單位數*/
                                     /*量                                     */
pon08       nvarchar(4),             /*庫存單位                               */
                                     /*庫存單位 ima25                         */
                                     /*本欄位可比較庫存單位與採購單位是否相同 */
pon09       decimal(18),             /*轉換因子                               */
                                     /*本欄位為採購單位/料件庫存單位的轉換率  */
                                     /*當採購收貨入庫可直接使用此轉換率       */
pon10       nvarchar(10),            /*檢驗碼                                 */
                                     /*為此批採購料件的檢驗理由               */
pon11       nvarchar(1),             /*凍結碼                                 */
                                     /*採購時程凍結碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pon121      decimal(18),             /*轉換因子                               */
                                     /*轉換因子                    (97/06/19) */
                                     /*本欄位為採購單位/請購單位的轉換率      */
pon122      nvarchar(10),            /*No Use                                 */
pon123      nvarchar(24),            /*廠牌                                   */
                                     /*廠牌                        (97/12 add)*/
pon13       decimal(18),             /*超/短交限率                            */
                                     /*此採購料件可超交或短交的限率           */
pon14       nvarchar(1),             /*部份交貨                               */
                                     /*部份交貨(Y/N)                          */
                                     /*輸入後的正確值為'Y' 或 'N'             */
pon15       nvarchar(1),             /*提前交貨                               */
                                     /*提前交貨 (Y/N)                         */
                                     /*此採購料件是否可提前交貨               */
pon16       nvarchar(1),             /*狀況碼                                 */
                                     /*Status Flag                            */
                                     /*X :計劃工單轉入                        */
                                     /*0 :開立(Open)                          */
                                     /*1 :已核准                              */
                                     /*2 :已轉採購單                          */
                                     /*6 :結案-正常                           */
                                     /*7 :結案-結長                           */
                                     /*8 :結案-結短                           */
                                     /*9 :取消(Cancel)                        */
pon18       datetime,                /*MRP 需求日期                           */
pon19       datetime,                /*截止日期                               */
pon20       decimal(18) NOT NULL,    /*採購量                                 */
pon21       decimal(18),             /*已轉量                                 */
pon23       nvarchar(10),            /*送貨地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
pon24       nvarchar(20),            /*請購單號                               */
                                     /*請購單號 pmk01(pml01)                  */
pon25       smallint,                /*請購單號項次                           */
                                     /*請購單號項次 pml02                     */
pon30       decimal(18),             /*標準價格                               */
                                     /*本欄位預設值為料件主檔中的採購成本     */
pon31       decimal(18) NOT NULL,    /*單價                                   */
                                     /*此料件的採購單價                       */
pon31t      decimal(18),             /*含稅單價                               */
pon32       decimal(18),             /*採購價差                               */
                                     /*採購價差(PPV)                          */
                                     /*採購價差 = 單價 * 匯率 - 標準價格      */
                                     /*價差單位為本幣                         */
pon33       datetime,                /*原始交貨日期                           */
                                     /*預定供應廠商發貨日期                   */
                                     /*本欄位為輸入時的原始確定的交貨日期     */
pon34       datetime,                /*原始到廠日期                           */
                                     /*該採購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*本欄位為輸入時的原始確定的到到廠日期   */
pon35       datetime,                /*原始到庫日期                           */
                                     /*該採購單項次 入到 庫房 日期            */
                                     /*本欄位為輸入時的原始確定的到庫日期     */
pon36       datetime,                /*最近確認交貨日期                       */
                                     /*與廠商確認的最近一次交貨日期           */
pon37       datetime,                /*最後一次到廠日期                       */
                                     /*與廠商確認的最後一次到廠日期           */
pon38       nvarchar(1),             /*可用/不可用                            */
                                     /*該採購單項次的料件為可用庫存或者使用者有*/
                                     /*其特殊用途可定義成不可用庫存           */
pon40       nvarchar(24),            /*會計科目                               */
                                     /*會計科目 aag01                         */
pon41       nvarchar(20),            /*工單號碼                               */
                                     /*工單號碼 sfb01                         */
                                     /*單據性質為廠外加工 (SUB) 時本欄位需輸入*/
                                     /*且製程序號需輸入                       */
pon42       nvarchar(1),             /*替代碼                                 */
                                     /*替代碼 (0/1/2/S/U)                     */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
pon43       smallint,                /*本製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pon431      smallint,                /*下製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pon44       decimal(18),             /*本幣單價                               */
                                     /*本幣單價 = 單價 * 匯率                 */
pon45       smallint,                /*無交期性採購單項次                     */
pon46       smallint,                /*製程序號                               */
                                     /*製程序號 ecm03                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
pon50       decimal(18) NOT NULL,    /*已轉採購量                             */
pon51       decimal(18) NOT NULL,    /*在驗量                                 */
pon52       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫imd01(img02)(imf02)           (8608)*/
pon53       decimal(18) NOT NULL,    /*入庫量                                 */
pon54       nvarchar(10),            /*儲位                                   */
                                     /*儲位ime01(img03)(imf03)           (8608)*/
pon55       decimal(18) NOT NULL,    /*驗退量                                 */
pon56       nvarchar(24),            /*批號                                   */
                                     /*批號     img04                    (8608)*/
pon57       decimal(18) NOT NULL,    /*超短交量                               */
                                     /*超短交量 (= pon50 - pon20)             */
                                     /*結案時計算, 短交為負值, 超交為正值     */
pon58       decimal(18),             /*倉退量                                 */
                                     /*倉退量                            (8704)*/
pon59       nvarchar(20),            /*退貨單號                               */
pon60       smallint,                /*項次                                   */
pon61       nvarchar(40) NOT NULL,   /*被替代料號                             */
                                     /*當 pon42='0/1/2'時,本欄位儲存料號同pon04*/
                                     /*當 pon42='S'    時,本欄位儲存被替代料號*/
pon62       decimal(18) NOT NULL,    /*替代率                                 */
                                     /*當 pon42='0/1/2'時,本欄位=1            */
                                     /*當 pon42='S'    時,本欄位儲存替代率    */
pon63       nvarchar(1),             /*急料否                                 */
pon64       nvarchar(1),             /*保稅否                                 */
pon65       nvarchar(1),             /*代買性質                               */
                                     /*代買性質 1.一般採購 2.代買採購         */
pon66       nvarchar(10),            /*預算編號                               */
                                     /*預算編號   (For 請採購預算)            */
pon67       nvarchar(10),            /*部門編號                               */
                                     /*部門編號   (For 請採購預算)            */
pon80       nvarchar(4),             /*單位一                                 */
pon81       decimal(18),             /*單位一換算率(與採購單位)               */
pon82       decimal(18),             /*單位一數量                             */
pon83       nvarchar(4),             /*單位二                                 */
pon84       decimal(18),             /*單位二換算率(與採購單位)               */
pon85       decimal(18),             /*單位二數量                             */
pon86       nvarchar(4),             /*計價單位                               */
pon87       decimal(18),             /*計價數量                               */
pon88       decimal(18),             /*未稅金額                               */
pon88t      decimal(18),             /*含稅金額                               */
ponlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ponplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ponud01     nvarchar(255),           /*自訂欄位-Textedit                      */
ponud02     nvarchar(40),            /*自訂欄位-文字                          */
ponud03     nvarchar(40),            /*自訂欄位-文字                          */
ponud04     nvarchar(40),            /*自訂欄位-文字                          */
ponud05     nvarchar(40),            /*自訂欄位-文字                          */
ponud06     nvarchar(40),            /*自訂欄位-文字                          */
ponud07     decimal(18),             /*自訂欄位-數值                          */
ponud08     decimal(18),             /*自訂欄位-數值                          */
ponud09     decimal(18),             /*自訂欄位-數值                          */
ponud10     integer,                 /*自訂欄位-整數                          */
ponud11     integer,                 /*自訂欄位-整數                          */
ponud12     integer,                 /*自訂欄位-整數                          */
ponud13     datetime,                /*自訂欄位-日期                          */
ponud14     datetime,                /*自訂欄位-日期                          */
ponud15     datetime                 /*自訂欄位-日期                          */
);

create        index pon_02 on pon_file (pon04);
create        index pon_03 on pon_file (pon41);
create        index pon_04 on pon_file (pon24,pon25);
create        index ponplant_idx on pon_file (ponplant);
alter table pon_file add constraint pon_pk primary key  (pon01,pon02);
grant select on pon_file to tiptopgp;
grant update on pon_file to tiptopgp;
grant delete on pon_file to tiptopgp;
grant insert on pon_file to tiptopgp;
grant references on pon_file to tiptopgp;
grant references on pon_file to ods;
grant select on pon_file to ods;
