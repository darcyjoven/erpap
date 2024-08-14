/*
================================================================================
檔案代號:pmn_file
檔案名稱:採購單單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmn_file
(
pmn01       nvarchar(20) NOT NULL,   /*採購單號                               */
                                     /*採購單號 pmm01                         */
pmn011      nvarchar(10),            /*單據性質                               */
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
pmn012      nvarchar(10),            /*製程段號                               */
pmn02       smallint NOT NULL,       /*項次                                   */
                                     /*採購單所含蓋的項目編號                 */
pmn03       nvarchar(20),            /*詢價單號                               */
                                     /*廠商詢價的詢價單單號                   */
                                     /*所輸入的詢價單號其詢價單上的廠商編號需與*/
                                     /*單頭所指定的供應商編號相同             */
pmn04       nvarchar(40),            /*料件編號                               */
                                     /*料件編號 ima01                         */
                                     /*採購料件編號                           */
                                     /*使用者有輸入詢價單號時所輸入的料件需存在*/
                                     /*於所輸入的詢價單號                     */
pmn041      nvarchar(120),           /*品名規格                               */
                                     /*為MISC 料件時必須輸入品名規格          */
pmn05       nvarchar(20),            /*APS單據編號                            */
                                     /*APS單據編號 no.4650 02/03/15(modify)   */
pmn06       nvarchar(40),            /*廠商料件編號                           */
                                     /*廠商料件編號 pmh04,pmh01=pmn04,pmh02=pmm*/
                                     /*廠商可能針對料件做自已的編號, 本欄位記錄*/
                                     /*的即為廠商所編的料件編號               */
pmn07       nvarchar(4),             /*採購單位                               */
                                     /*採購單位 gfe01                         */
                                     /*本系統可使用多單位的採購               */
                                     /*當單位不同時系統會自動轉換相對應的單位數*/
                                     /*量                                     */
pmn08       nvarchar(4),             /*庫存單位                               */
                                     /*庫存單位 ima25                         */
                                     /*本欄位可比較庫存單位與採購單位是否相同 */
pmn09       decimal(18),             /*轉換因子                               */
                                     /*本欄位為採購單位/料件庫存單位的轉換率  */
                                     /*當採購收貨入庫可直接使用此轉換率       */
pmn10       nvarchar(4),             /*No Use                                 */
pmn11       nvarchar(1),             /*凍結碼                                 */
                                     /*採購時程凍結碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pmn121      decimal(18),             /*轉換因子                               */
                                     /*轉換因子                    (97/06/19) */
                                     /*本欄位為採購單位/請購單位的轉換率      */
pmn122      nvarchar(10),            /*專案代號                               */
                                     /*專案代號 (00/04/18)                    */
pmn123      nvarchar(24),            /*廠牌                                   */
                                     /*廠牌                        (97/12 add)*/
pmn13       decimal(18),             /*超/短交限率                            */
                                     /*此採購料件可超交或短交的限率           */
pmn14       nvarchar(1),             /*部份交貨                               */
                                     /*部份交貨(Y/N)                          */
                                     /*輸入後的正確值為'Y' 或 'N'             */
pmn15       nvarchar(1),             /*提前交貨                               */
                                     /*提前交貨 (Y/N)                         */
                                     /*此採購料件是否可提前交貨               */
pmn16       nvarchar(1),             /*狀況碼                                 */
                                     /*Status Flag                            */
                                     /*X :計劃工單轉入                        */
                                     /*0 :開立(Open)                          */
                                     /*1 :已核准                              */
                                     /*2 :發出採購單                          */
                                     /*6 :結案-正常                           */
                                     /*7 :結案-結長                           */
                                     /*8 :結案-結短                           */
                                     /*9 :取消(Cancel)                        */
pmn18       nvarchar(19),            /*RunCard單號(委外)                      */
pmn20       decimal(18) NOT NULL,    /*採購量                                 */
pmn23       nvarchar(10),            /*送貨地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
pmn24       nvarchar(20),            /*請購單號                               */
                                     /*請購單號 pmk01(pml01)                  */
pmn25       smallint,                /*請購單號項次                           */
                                     /*請購單號項次 pml02                     */
pmn30       decimal(18),             /*標準價格                               */
                                     /*本欄位預設值為料件主檔中的採購成本     */
pmn31       decimal(18) NOT NULL,    /*單價                                   */
                                     /*單價              #未稅單價 Bug No.7259*/
                                     /*此料件的採購單價                       */
pmn31t      decimal(18),             /*含稅單價                               */
                                     /*含稅單價          #含稅單價 Bug No.7259*/
                                     /*此料件的採購單價，依據公式新增pmn31時計*/
                                     /*算： pmn31t= pmn31*(1+pmm43/100)       */
pmn32       smallint,                /*RunCard委外製程序                      */
pmn33       datetime,                /*原始交貨日期                           */
                                     /*預定供應廠商發貨日期                   */
                                     /*本欄位為輸入時的原始確定的交貨日期     */
pmn34       datetime,                /*原始到廠日期                           */
                                     /*該採購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*本欄位為輸入時的原始確定的到到廠日期   */
pmn35       datetime,                /*原始到庫日期                           */
                                     /*該採購單項次 入到 庫房 日期            */
                                     /*本欄位為輸入時的原始確定的到庫日期     */
pmn36       datetime,                /*最近確認交貨日期                       */
                                     /*與廠商確認的最近一次交貨日期           */
pmn37       datetime,                /*最後一次到廠日期                       */
                                     /*與廠商確認的最後一次到廠日期           */
pmn38       nvarchar(1),             /*可用/不可用                            */
                                     /*該採購單項次的料件為可用庫存或者使用者有*/
                                     /*其特殊用途可定義成不可用庫存           */
pmn40       nvarchar(24),            /*會計科目                               */
                                     /*會計科目 aag01                         */
pmn401      nvarchar(24),            /*會計科目二                             */
pmn41       nvarchar(20),            /*工單號碼                               */
                                     /*工單號碼 sfb01                         */
                                     /*單據性質為廠外加工 (SUB) 時本欄位需輸入*/
                                     /*且製程序號需輸入                       */
pmn42       nvarchar(1) NOT NULL,    /*替代碼                                 */
                                     /*替代碼 (0/1/2/S/U)                     */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
pmn43       smallint,                /*本製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pmn431      smallint,                /*下製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pmn44       decimal(18),             /*本幣單價                               */
                                     /*本幣單價 = 單價 * 匯率                 */
pmn45       smallint,                /*無交期性採購單項次                     */
pmn46       smallint,                /*製程序號                               */
                                     /*製程序號 ecm03                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
pmn50       decimal(18) NOT NULL,    /*交貨量                                 */
                                     /*=>未交=訂購  - (已交 - 驗退量)         */
                                     /*      (pmn20 - (pmn50 - pmn55)         */
                                     /*報表或查詢作業的已交量= 交貨量-驗退量  */
pmn51       decimal(18) NOT NULL,    /*在驗量                                 */
pmn52       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫imd01(img02)(imf02)           (8608)*/
pmn53       decimal(18) NOT NULL,    /*入庫量                                 */
pmn54       nvarchar(10),            /*儲位                                   */
                                     /*儲位ime01(img03)(imf03)           (8608)*/
pmn55       decimal(18) NOT NULL,    /*驗退量                                 */
pmn56       nvarchar(24),            /*批號                                   */
                                     /*批號     img04                    (8608)*/
pmn57       decimal(18) NOT NULL,    /*超短交量                               */
                                     /*超短交量 (= pmn50 - pmn20-pmn55)       */
                                     /*結案時計算, 短交為負值, 超交為正值     */
pmn58       decimal(18),             /*退貨換貨量                             */
                                     /*倉退量                            (8704)*/
pmn59       nvarchar(20),            /*退貨單號                               */
pmn60       smallint,                /*項次                                   */
pmn61       nvarchar(40) NOT NULL,   /*被替代料號                             */
                                     /*當 pmn42='0/1/2'時,本欄位儲存料號同pmn04*/
                                     /*當 pmn42='S'    時,本欄位儲存被替代料號*/
pmn62       decimal(18) NOT NULL,    /*替代率                                 */
                                     /*當 pmn42='0/1/2'時,本欄位=1            */
                                     /*當 pmn42='S'    時,本欄位儲存替代率    */
pmn63       nvarchar(1),             /*急料否                                 */
pmn64       nvarchar(1),             /*保稅否                                 */
pmn65       nvarchar(1),             /*代買性質                               */
                                     /*代買性質 1.一般採購 2.代買採購         */
pmn66       nvarchar(10),            /*預算編號                               */
                                     /*預算編號   (For 請採購預算)            */
pmn67       nvarchar(10),            /*部門編號                               */
                                     /*部門編號   (For 請採購預算)            */
pmn68       nvarchar(20),            /*Blanket PO 單號                        */
                                     /*Blanket PO 單號   add 01/09/04         */
pmn69       smallint,                /*Blanket PO 項次                        */
                                     /*Blanket PO 項次   add 01/09/04         */
pmn70       decimal(18),             /*轉換因子                               */
                                     /*轉換因子          add 01/09/04         */
                                     /*本欄位為採購單位/Blanket PO單位的轉換率*/
pmn71       nvarchar(20),            /*海關手冊編號                           */
                                     /*海關手冊編號  add 02/11/12             */
pmn72       nvarchar(40),            /*商品條碼                               */
pmn73       nvarchar(1) DEFAULT ' ' NOT NULL, /*取價類型 1-搭贈,2-促銷協議,3- */
pmn74       nvarchar(20),            /*價格來源                               */
pmn75       nvarchar(20),            /*來源單號                               */
pmn76       smallint,                /*來源項次                               */
pmn77       nvarchar(10),            /*來源營運中心                           */
pmn80       nvarchar(4),             /*單位一                                 */
pmn81       decimal(18),             /*單位一換算率(與採購單位)               */
pmn82       decimal(18),             /*單位一數量                             */
pmn83       nvarchar(4),             /*單位二                                 */
pmn84       decimal(18),             /*單位二換算率(與採購單位)               */
pmn85       decimal(18),             /*單位二數量                             */
pmn86       nvarchar(4),             /*計價單位                               */
pmn87       decimal(18),             /*計價數量                               */
pmn88       decimal(18),             /*未稅金額                               */
pmn88t      decimal(18),             /*含稅金額                               */
pmn89       nvarchar(1) DEFAULT 'N', /*VMI采購                                */
pmn90       decimal(18),             /*取出單價                               */
pmn91       nvarchar(10),            /*單元編號                               */
pmn919      nvarchar(50),            /*計畫批號                               */
pmn930      nvarchar(10),            /*採購成本中心                           */
pmn94       nvarchar(16),            /*no use                                 */
pmn95       smallint,                /*no use                                 */
pmn96       nvarchar(30),            /*WBS編號                                */
pmn97       nvarchar(4),             /*活動代號                               */
pmn98       nvarchar(10),            /*費用原因                               */
pmn99       nvarchar(15),            /*電子采購序號                           */
pmnlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pmnplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
pmnud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pmnud02     nvarchar(40),            /*自訂欄位-文字                          */
pmnud03     nvarchar(40),            /*自訂欄位-文字                          */
pmnud04     nvarchar(40),            /*自訂欄位-文字                          */
pmnud05     nvarchar(40),            /*自訂欄位-文字                          */
pmnud06     nvarchar(40),            /*自訂欄位-文字                          */
pmnud07     decimal(18),             /*自訂欄位-數值                          */
pmnud08     decimal(18),             /*自訂欄位-數值                          */
pmnud09     decimal(18),             /*自訂欄位-數值                          */
pmnud10     integer,                 /*自訂欄位-整數                          */
pmnud11     integer,                 /*自訂欄位-整數                          */
pmnud12     integer,                 /*自訂欄位-整數                          */
pmnud13     datetime,                /*自訂欄位-日期                          */
pmnud14     datetime,                /*自訂欄位-日期                          */
pmnud15     datetime                 /*自訂欄位-日期                          */
);

create        index pmn_02 on pmn_file (pmn04);
create        index pmn_03 on pmn_file (pmn41);
create        index pmn_04 on pmn_file (pmn24,pmn25);
create        index pmnplant_idx on pmn_file (pmnplant);
alter table pmn_file add constraint pmn_pk primary key  (pmn01,pmn02) deferrable initially deferred;
grant select on pmn_file to tiptopgp;
grant update on pmn_file to tiptopgp;
grant delete on pmn_file to tiptopgp;
grant insert on pmn_file to tiptopgp;
grant references on pmn_file to tiptopgp;
grant references on pmn_file to ods;
grant select on pmn_file to ods;
