/*
================================================================================
檔案代號:pml_file
檔案名稱:請購單單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pml_file
(
pml01       nvarchar(20) NOT NULL,   /*請購單號                               */
                                     /*請購單號  pmk01                        */
pml011      nvarchar(10),            /*採購性質                               */
                                     /*單據性質                               */
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
pml02       smallint NOT NULL,       /*項次                                   */
                                     /*請購單所含蓋的項目編號                 */
pml03       nvarchar(20),            /*詢價單號                               */
                                     /*廠商詢價的詢價單單號                   */
pml04       nvarchar(40),            /*料件編號                               */
                                     /*料件編號 ima01                         */
                                     /*請購料件編號                           */
pml041      nvarchar(120),           /*品名規格                               */
                                     /*存放 MISC 料件                         */
pml05       nvarchar(32),            /*APS單據編號                            */
                                     /*APS單據編號   no.4649 02/03/15(modify) */
pml06       nvarchar(255),           /*備註                                   */
                                     /*備註                            (97/08)*/
pml07       nvarchar(4),             /*請購單位                               */
                                     /*請購單位 gfe01                         */
                                     /*請購單上請購數量單位                   */
pml08       nvarchar(4),             /*庫存單位                               */
                                     /*庫存單位 default ima25                 */
                                     /*料件庫存單位                           */
pml09       decimal(18),             /*轉換率                                 */
                                     /*請購單位/庫存單位的轉換率              */
pml10       nvarchar(10),            /*檢驗碼                                 */
                                     /*設定檢驗的類別代碼                     */
pml11       nvarchar(1),             /*凍結碼                                 */
                                     /*請購時程確定碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pml12       nvarchar(10),            /*專案代號                               */
                                     /*專案代號(00/04/15)                     */
pml121      nvarchar(30),            /*WBS編號                                */
                                     /*專案代號-順序(00/01/24)                */
pml122      nvarchar(4),             /*活動代號                               */
                                     /*專案代號-項次(00/01/24)                */
pml123      nvarchar(24),            /*廠牌                                   */
                                     /*廠牌                         (97/12 add)*/
pml13       decimal(18),             /*超/短交限率                            */
                                     /*允許可超交/短交數量比率                */
pml14       nvarchar(1),             /*部份交貨否                             */
                                     /*部份交貨否(Y/N)                        */
pml15       nvarchar(1),             /*提前交貨否                             */
                                     /*提前交貨否(Y/N)                        */
pml16       nvarchar(1),             /*狀況碼                                 */
                                     /*正確值 0/1/2/6/7/8/9                   */
                                     /*X: 計劃訂單轉入                        */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*2: 轉成採購單                          */
                                     /*6: 結案-正常                           */
                                     /*7: 結案-結長                           */
                                     /*8: 結案-結短                           */
                                     /*9: 作廢(Cancel)                        */
pml18       datetime,                /*MRP 需求日期                           */
                                     /*該請購料件的MRP/MPS計劃訂單需求日期    */
pml190      nvarchar(1),             /*統購否                                 */
pml191      nvarchar(10),            /*採購中心代碼                           */
pml192      nvarchar(1),             /*拋轉否                                 */
pml20       decimal(18),             /*訂購量                                 */
                                     /*訂購量                           (97/07)*/
                                     /*請購數量                               */
                                     /*單位為請購單位                         */
pml21       decimal(18),             /*已轉採購數量                           */
                                     /*已轉採購數量                     (97/07)*/
                                     /*被轉成採購的累計數量                   */
                                     /*單位為請購單位                         */
pml23       nvarchar(1),             /*課稅否                                 */
                                     /*該請購單項次(料伴)是否需課稅           */
                                     /*正確值 Y/N                             */
                                     /*Y: 需課稅, 稅率按請購單單頭            */
                                     /*N: 不需課稅                            */
pml24       nvarchar(20),            /*來源單號                               */
pml25       smallint,                /*來源項次                               */
pml30       decimal(18),             /*標準價格                               */
                                     /*價格單位為本幣                         */
pml31       decimal(18),             /*未稅單價                               */
                                     /*單價                                   */
                                     /*價格單位為按請購單單頭幣別             */
                                     /*匯率採用請購單單頭匯率                 */
pml31t      decimal(18),             /*含稅單價                               */
pml32       decimal(18),             /*採購價差                               */
                                     /*採購價差 - PPV                         */
                                     /*採購價差 = 單價 * 匯率 - 標準價格      */
                                     /*價差單位為本幣                         */
pml33       datetime,                /*交貨日期                               */
                                     /*預定供應廠商發貨日期                   */
pml34       datetime,                /*到廠日期                               */
                                     /*該請購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*如為部份交貨, 則記錄最近一次日期       */
pml35       datetime,                /*到庫日期                               */
                                     /*該請購單項次 入到 庫房 日期            */
                                     /*如為部份交貨, 則記錄最近一次日期       */
pml38       nvarchar(1),             /*可用/不可用                            */
                                     /*該請購單項次的料件為可用庫存或者使用者有*/
                                     /*其特殊用途可定義成不可用庫存           */
pml40       nvarchar(24),            /*會計科目                               */
                                     /*會計科目 aag01                         */
                                     /*該筆請購單項次所屬會計科目             */
                                     /*當請購單性質為 EXP/SER/CAP 時需輸入    */
pml401      nvarchar(24),            /*會計科目二                             */
pml41       nvarchar(20),            /*PLP NO(MRP版本+序)                     */
                                     /*當請購單為MRP/PLP轉入時,儲存原MRP版本+序*/
pml42       nvarchar(1) NOT NULL,    /*替代碼                                 */
                                     /*儲存該工單備料的料件為原始組合的下階料 */
                                     /*件或採用取﹧替代料件                      */
                                     /*正確值 0/1/2/S/U                       */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
                                     /*U: 取代料件                            */
pml43       smallint,                /*作業序號                               */
                                     /*如為專屬的廠外加工則本欄位值為0        */
pml431      smallint,                /*下一站之作業序號                       */
                                     /*如為專屬的廠外加工則本欄位值為0        */
pml44       decimal(18),             /*本幣單價                               */
                                     /*如幣別非本幣時, 本幣單價 <> 單價       */
                                     /*價格單位為本幣                         */
                                     /*匯率為請購單單頭匯率                   */
                                     /*系統維護                               */
pml45       nvarchar(20),            /*制單號                                 */
pml46       nvarchar(10),            /*No Use                                 */
pml47       nvarchar(40),            /*商品條碼                               */
pml48       nvarchar(10),            /*供應商代碼                             */
pml49       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營方式 1-經銷,2-成本代銷,3- */
                                     /*經營方式 1:經銷 2:成本代銷 3:扣率代銷 4:聯營*/
pml50       nvarchar(1) DEFAULT '1' NOT NULL, /*採購類型 1-自訂貨,2-統採直供,*/
pml51       nvarchar(10),            /*源頭營運中心                           */
pml52       nvarchar(20),            /*源頭單號                               */
pml53       smallint,                /*源頭項次                               */
pml54       nvarchar(1) DEFAULT ' ' NOT NULL, /*需求類型 1.補貨 2.訂貨*/
pml55       nvarchar(8),             /*交貨時間                               */
pml56       nvarchar(1) DEFAULT ' ' NOT NULL, /*轉出狀態1-未轉出 2-已轉出 3-  */
pml66       nvarchar(10),            /*預算編號                               */
                                     /*預算編號  (For 請採購預算)             */
pml67       nvarchar(10),            /*部門編號                               */
                                     /*部門編號  (For 請採購預算)             */
pml80       nvarchar(4),             /*單位一                                 */
pml81       decimal(18),             /*單位一換算率(與採購單位)               */
pml82       decimal(18),             /*單位一數量                             */
pml83       nvarchar(4),             /*單位二                                 */
pml84       decimal(18),             /*單位二換算率(與採購單位)               */
pml85       decimal(18),             /*單位二數量                             */
pml86       nvarchar(4),             /*計價單位                               */
pml87       decimal(18),             /*計價數量                               */
pml88       decimal(18),             /*未稅金額                               */
pml88t      decimal(18),             /*含稅金額                               */
pml90       nvarchar(10),            /*費用原因                               */
pml91       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否急料*/
pml919      nvarchar(50),            /*計畫批號                               */
pml92       nvarchar(1) DEFAULT 'N' NOT NULL, /*電子採購否*/
pml93       nvarchar(15),            /*電子採購序號                           */
pml930      nvarchar(10),            /*成本中心                               */
pmllegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pmlplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
pmlud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pmlud02     nvarchar(40),            /*自訂欄位-文字                          */
pmlud03     nvarchar(40),            /*自訂欄位-文字                          */
pmlud04     nvarchar(40),            /*自訂欄位-文字                          */
pmlud05     nvarchar(40),            /*自訂欄位-文字                          */
pmlud06     nvarchar(40),            /*自訂欄位-文字                          */
pmlud07     decimal(18),             /*自訂欄位-數值                          */
pmlud08     decimal(18),             /*自訂欄位-數值                          */
pmlud09     decimal(18),             /*自訂欄位-數值                          */
pmlud10     integer,                 /*自訂欄位-整數                          */
pmlud11     integer,                 /*自訂欄位-整數                          */
pmlud12     integer,                 /*自訂欄位-整數                          */
pmlud13     datetime,                /*自訂欄位-日期                          */
pmlud14     datetime,                /*自訂欄位-日期                          */
pmlud15     datetime                 /*自訂欄位-日期                          */
);

create        index pml_02 on pml_file (pml04);
create        index pml_03 on pml_file (pml41);
create        index pmlplant_idx on pml_file (pmlplant);
alter table pml_file add constraint pml_pk primary key  (pml01,pml02);
grant select on pml_file to tiptopgp;
grant update on pml_file to tiptopgp;
grant delete on pml_file to tiptopgp;
grant insert on pml_file to tiptopgp;
grant references on pml_file to tiptopgp;
grant references on pml_file to ods;
grant select on pml_file to ods;
