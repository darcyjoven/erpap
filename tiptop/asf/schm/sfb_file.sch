/*
================================================================================
檔案代號:sfb_file
檔案名稱:工單檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfb_file
(
sfb01       nvarchar(20) NOT NULL,   /*工單編號                               */
sfb02       smallint,                /*工單型態                               */
                                     /*儲存該工單所屬類別型態                 */
                                     /*正確值 1/2/5/7/11/12/13/15             */
                                     /* 1: 一般工單                           */
                                     /* 5: 再加工工單                         */
                                     /* 7: 委外工單                           */
                                     /* 8: 重工委外工單   #Add By Snow        */
                                     /*11: 拆件式工單                         */
                                     /*13: 預測工單                           */
                                     /*15: 試產工單                           */
sfb03       nvarchar(24),            /*在製品會計科目                         */
                                     /*在製品會計科目  aag01                  */
sfb04       nvarchar(1),             /*工單狀態                               */
                                     /*儲存該工單目前處理階段狀況             */
                                     /*正確值 1/2/3/4/5/6/7/8                 */
                                     /*1: 確認生產工單(firm plan)             */
                                     /*2: 工單已發放,料表尚未列印             */
                                     /*3: 工單已發放,料表已列印               */
                                     /*4: 工單已發料                          */
                                     /*5: 在製過程中                          */
                                     /*6: 工單已完工,進入F.Q.C                */
                                     /*7: 完工入庫                            */
                                     /*8: 結案                                */
sfb05       nvarchar(40),            /*料件編號                               */
                                     /*料件編號   ima01                       */
                                     /*儲存該工單將投入生產料件               */
sfb06       nvarchar(10),            /*使用製程編號                           */
                                     /*使用製程編號  ecu01                    */
                                     /*儲存該工單將投入生產料件時所用的製程編 */
                                     /*號                                     */
sfb07       nvarchar(10),            /*版本                                   */
                                     /*儲存工單投入生產的料件版本             */
sfb071      datetime,                /*產品結構指定有效日期                   */
                                     /*儲存工單投入生產的料件使用的產品結構指 */
                                     /*定有效日期                             */
sfb08       decimal(18) NOT NULL,    /*生產數量                               */
                                     /*預計投入生產的數量，單位為料件生產單位 */
sfb081      decimal(18) NOT NULL,    /*已發料套數                             */
sfb09       decimal(18) NOT NULL,    /*完工入庫數量                           */
                                     /*儲存該工單已完工入庫數量               */
sfb10       decimal(18) NOT NULL,    /*再加工數量                             */
                                     /*儲存該工單再加工數量                   */
sfb100      nvarchar(1),             /*委外型態                               */
                                     /*委外型態                        養生計劃*/
                                     /*1.委外工單對委外採購單型態為一對一     */
                                     /*2.委外工單對委外採購單型態為一對多     */
                                     /*預設 '1'                               */
                                     /*兩者的差別在於,資料的一致性            */
sfb1001     nvarchar(40),            /*保稅核准文號                           */
sfb1002     nvarchar(1),             /*保稅核銷否                             */
sfb1003     nvarchar(20),            /*保稅放行單號                           */
sfb101      smallint,                /*變更序號                               */
                                     /*變更序號                        養生計劃*/
sfb102      nvarchar(10),            /*生產線                                 */
sfb103      smallint,                /*工單製程變更序號                       */
sfb104      nvarchar(1) DEFAULT ' ' NOT NULL, /*備置否(Y/N)*/
sfb11       decimal(18) NOT NULL,    /*F.Q.C 數量                             */
                                     /*儲存該工單在全檢（檢驗）數量           */
sfb111      decimal(18) NOT NULL,    /*No Use                                 */
sfb12       decimal(18) NOT NULL,    /*報廢數量                               */
                                     /*儲存該工單報廢數量                     */
sfb121      decimal(18),             /*在製盤盈虧量                           */
                                     /*在製盤盈虧量  add 99/04/27             */
sfb122      decimal(18),             /*No Use                                 */
sfb13       datetime,                /*預計起始生產日期                       */
                                     /*儲存該工單預計投入生產日期             */
sfb14       nvarchar(5),             /*預計起始生產時間                       */
                                     /*預計起始生產時間(時:分)                */
                                     /*儲存該工單預計投入生產時間             */
sfb15       datetime,                /*預計結束生產日期                       */
                                     /*儲存該工單預計完成生產日期             */
sfb16       nvarchar(5),             /*預計結束生產時間                       */
                                     /*預計結束生產時間(時:分)                */
                                     /*儲存該工單預計完成生產時間             */
sfb17       smallint,                /*已完工製程序號                         */
                                     /*儲存該工單目前已完工的最大製程序號     */
sfb18       datetime,                /*最近一次作業完工日期                   */
                                     /*最近一次作業完工日期(天)               */
                                     /*儲存該工單 [已完工製程序號] 之完工日期 */
sfb19       nvarchar(5),             /*最近一次作業完工時間                   */
                                     /*最近一次作業完工時間(時:分)            */
                                     /*儲存該工單 [已完工製程序號] 之完工時間 */
                                     /*量產系統專用                           */
sfb20       datetime,                /*MPS/MRP 需求日期                       */
                                     /*儲存該工單之預計 MPS/MPR 需求日期      */
sfb21       nvarchar(5),             /*MPS/MRP 需求時間                       */
                                     /*MPS/MRP 需求時間(時:分)                */
                                     /*儲存該工單之預計 MPS/MPR 需求時間      */
                                     /*量產系統專用                           */
sfb22       nvarchar(20),            /*訂單編號/預測工單編號                  */
                                     /*儲存該工單之指定生產供給的訂單單號     */
sfb221      smallint,                /*訂單項次/預測工單項次                  */
                                     /*儲存該工單之指定生產供給的訂單項次     */
sfb222      nvarchar(20),            /*APS 單據編號                           */
                                     /*APS 單據編號  no.4651 02/03/14(modify) */
sfb23       nvarchar(1),             /*備料檔產生否                           */
                                     /*儲存該工單是否已產生備料資料           */
                                     /*正確值 Y/N                             */
                                     /*Y: 該工單已產生備料資料                */
                                     /*N: 該工單尚未產生備料資料              */
sfb24       nvarchar(1),             /*製程追蹤檔產生否                       */
                                     /*儲存該工單是否已產生製程追蹤資料       */
                                     /*正確值 Y/N                             */
                                     /*Y: 該工單已產生製程追蹤資料            */
                                     /*N: 該工單尚未產生製程追蹤資料          */
sfb25       datetime,                /*實際開工日                             */
                                     /*儲存該工單第一次發料日期, 於發料作業更新*/
sfb251      datetime,                /*預計發放日期                           */
sfb26       nvarchar(5),             /*發料日期                               */
sfb27       nvarchar(10),            /*專案號碼                               */
                                     /*儲存該工單所屬專案號碼                 */
sfb271      nvarchar(30),            /*WBS編碼                                */
                                     /*專案號碼-順序                          */
                                     /*儲存該工單所屬專案號碼-順序            */
sfb28       nvarchar(1),             /*工單結案狀態                           */
                                     /*正確值 1/2/3                           */
                                     /*1: 發料已結束,不能再發料               */
                                     /*2: 生產工時已結束,不能再發料及輸入工時 */
                                     /*3: 成本會計已結束,此工單不能再重新開啟 */
                                     /*   ，可轉入歷史檔                      */
sfb29       nvarchar(1),             /*可用否                                 */
                                     /*儲存執行主排程計劃或料需求計劃時，是否 */
                                     /*可考慮將該工單完工數量列入需求之供給   */
                                     /*正確值 Y/N                             */
                                     /*Y: 可考慮為供給                        */
                                     /*N: 不可考慮為供給                      */
sfb30       nvarchar(10),            /*預計工單完工入庫倉庫別                 */
                                     /*儲存該工單完工後，預計存放的倉庫別     */
sfb31       nvarchar(10),            /*預計工單完工入庫儲位                   */
                                     /*儲存該工單完工後，預計存放的儲位       */
sfb32       nvarchar(2),             /*起始排程方法                           */
                                     /*正確值 1/2/3/4/5                       */
                                     /*1: window scheduling forward           */
                                     /*2: window scheduling backward          */
                                     /*3: weighted window scheduling          */
                                     /*4: tracking scheduling forward         */
                                     /*5: tracking scheduling backward        */
sfb33       nvarchar(2),             /*最近排程方法                           */
                                     /*正確值 1/2/3/4/5                       */
                                     /*1: window scheduling forward           */
                                     /*2: window scheduling backward          */
                                     /*3: weighted window scheduling          */
                                     /*4: tracking scheduling forward         */
                                     /*5: tracking scheduling backward        */
sfb34       decimal(18),             /*C/R 比率                               */
                                     /*C/R 比率(%)                            */
                                     /*儲存該工單緊急比率                     */
                                     /*開始時應設定為 '1'，可透過工單緊急比率 */
                                     /*重新計算作業重新設定                   */
                                     /*其值愈小者，賦予愈高的分派優先順序     */
sfb35       nvarchar(1),             /*異動碼                                 */
                                     /*異動碼(Y/N)                            */
                                     /*儲存該工單自上次料需求計劃後，如有變動 */
                                     /*時，則需在此備註                       */
                                     /*提供 nettable change MRP 使用          */
sfb36       datetime,                /*工單發料結束日期                       */
                                     /*按工單結案狀況，會有各階段結束日期；而 */
                                     /*本欄位記錄料帳結束日期，即在工單經過此 */
                                     /*階段後，系統即便不可再發料給該工單     */
                                     /*如需再發料，則需作工單的重新開啟作業， */
                                     /*才被允許可再發料給該工單               */
sfb37       datetime,                /*工單發料及工時結束日                   */
                                     /*按工單結案狀況，會有各階段結束日期；而 */
                                     /*本欄位記錄料帳及人工帳（工時）結束日期 */
                                     /*，簡而言之即在工單經過此階段後，系統即 */
                                     /*便不可再對該工單收集工時               */
                                     /*如需再收集工時，則需作工單的重新開啟作 */
                                     /*業，才被允許可再收集工時給該工單       */
sfb38       datetime,                /*工單成本會計結束日期                   */
                                     /*按工單結案狀況，會有各階段結束日期；而 */
                                     /*本欄位記錄該工單已在最後確定的階段日期 */
                                     /*，簡而言之即在工單經過此階段後，系統即 */
                                     /*便不可再對該工單發料及收集工時，而且亦 */
                                     /*無法再重新開啟                         */
sfb39       nvarchar(1),             /*完工方式                               */
                                     /*儲存該工單在料帳上，使用撿料及發料系統 */
                                     /*或使用領料及事後扣帳系統               */
                                     /*正確值 1/2                             */
                                     /*1: 撿料及發料系統                      */
                                     /*   Picking List 與 Push System         */
                                     /*2: 領料及事後扣帳系統                  */
                                     /*   Pull List 與 Backflush System       */
sfb40       smallint,                /*優先順序                               */
                                     /*儲存該工單派工的優先順序               */
                                     /*正確值 應不小於零                      */
                                     /*其值愈小者順序愈高                     */
sfb41       nvarchar(1),             /*凍結碼                                 */
                                     /*凍結碼(frozen flag)                    */
                                     /*儲存該工單為需求之供給時，是否可更動其 */
                                     /*時程，以利需求之取得                   */
                                     /*正確值 Y/N                             */
                                     /*Y: 時程已被固定之工單                  */
                                     /*N: 時程尚未被固定之工單                */
sfb42       smallint,                /*工單展開階數                           */
                                     /*儲存該工單對下階自動產生工單的往下階數 */
sfb43       nvarchar(1),             /*簽核狀況                               */
sfb44       nvarchar(10),            /*申請人                                 */
sfb50       nvarchar(4),             /*活動代號                               */
sfb51       nvarchar(10),            /*理由碼                                 */
sfb81       datetime,                /*輸入日期                               */
                                     /*儲存工單輸入日期                       */
sfb82       nvarchar(10),            /*製造部門/委外廠商                      */
sfb85       nvarchar(20),            /*PBI NO(Picking Batch ID)               */
sfb86       nvarchar(20),            /*母工單號碼                             */
sfb87       nvarchar(1),             /*確認否                                 */
                                     /*確認否(Y/N/X)                          */
sfb88       nvarchar(20),            /*料表編號                               */
sfb91       nvarchar(20),            /*製造通知單                             */
sfb919      nvarchar(50),            /*計畫批號                               */
sfb92       smallint,                /*項次                                   */
sfb93       nvarchar(1),             /*製程否                                 */
sfb94       nvarchar(1),             /*FQC否                                  */
sfb95       nvarchar(20),            /*特性代碼                               */
sfb96       nvarchar(255),           /*備註                                   */
sfb97       nvarchar(20),            /*手冊編號                               */
                                     /*手冊編號   (A050)                      */
sfb98       nvarchar(10),            /*成本中心                               */
sfb99       nvarchar(1),             /*重工否                                 */
                                     /*重工否(Y/N)                            */
sfbacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
sfbdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
sfbgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
sfblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sfbmksg     nvarchar(1),             /*是否簽核                               */
sfbmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
sfborig     nvarchar(10),            /*資料建立部門                           */
sfboriu     nvarchar(10),            /*資料建立者                             */
sfbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sfbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
sfbud02     nvarchar(40),            /*自訂欄位-文字                          */
sfbud03     nvarchar(40),            /*自訂欄位-文字                          */
sfbud04     nvarchar(40),            /*自訂欄位-文字                          */
sfbud05     nvarchar(40),            /*自訂欄位-文字                          */
sfbud06     nvarchar(40),            /*自訂欄位-文字                          */
sfbud07     decimal(18),             /*自訂欄位-數值                          */
sfbud08     decimal(18),             /*自訂欄位-數值                          */
sfbud09     decimal(18),             /*自訂欄位-數值                          */
sfbud10     integer,                 /*自訂欄位-整數                          */
sfbud11     integer,                 /*自訂欄位-整數                          */
sfbud12     integer,                 /*自訂欄位-整數                          */
sfbud13     datetime,                /*自訂欄位-日期                          */
sfbud14     datetime,                /*自訂欄位-日期                          */
sfbud15     datetime,                /*自訂欄位-日期                          */
sfbuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

create        index sfb_02 on sfb_file (sfb05);
create        index sfb_03 on sfb_file (sfb22,sfb221);
create        index sfbplant_idx on sfb_file (sfbplant);
alter table sfb_file add constraint sfb_pk primary key  (sfb01);
grant select on sfb_file to tiptopgp;
grant update on sfb_file to tiptopgp;
grant delete on sfb_file to tiptopgp;
grant insert on sfb_file to tiptopgp;
grant references on sfb_file to tiptopgp;
grant references on sfb_file to ods;
grant select on sfb_file to ods;
