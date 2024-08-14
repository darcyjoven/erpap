/*
================================================================================
檔案代號:imz_file
檔案名稱:料件分類基本資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imz_file
(
imz01       nvarchar(10) NOT NULL,   /*料件分群碼                             */
imz02       nvarchar(80),            /*說明                                   */
imz03       nvarchar(20),            /*目錄參考號碼                           */
                                     /*料件所屬的目錄編號                     */
imz04       nvarchar(20),            /*工程圖號                               */
                                     /*該料件所在的主要工程圖號               */
imz07       nvarchar(1),             /*ABC碼                                  */
imz08       nvarchar(1),             /*來源碼                                 */
                                     /*C:規格組件                             */
                                     /*T:最後規格料件                         */
                                     /*D:特性料件                             */
                                     /*A:族群料件                             */
                                     /*M:自製料件                             */
                                     /*P:採購料件                             */
                                     /*X:虛擬料件                             */
                                     /*K:配件虛擬料件                         */
                                     /*U:自製大宗料件                         */
                                     /*V:採購大宗料件                         */
                                     /*R:在製途料件                           */
                                     /*Z:雜項料件                             */
                                     /*S:廠外加工料件                         */
imz09       nvarchar(10),            /*其他分群碼 一                          */
                                     /*使用者自行定義                         */
imz10       nvarchar(10),            /*其他分群碼 二                          */
                                     /*使用者自行定義                         */
imz100      nvarchar(1),             /*檢驗程度                               */
                                     /*檢驗程度                         no:6843*/
                                     /*N.正常檢驗 T.加嚴檢驗 R.減量檢驗       */
imz101      nvarchar(1),             /*檢驗水準                               */
                                     /*檢驗水準                         no:6843*/
                                     /*1.一般    2.特殊                       */
imz102      nvarchar(1),             /*級數                                   */
                                     /*級數                             no:6843*/
imz103      nvarchar(1),             /*採購特性                               */
                                     /*採購特性                         no:6843*/
                                     /*分類此採購料件特性                     */
                                     /*'0':內購 '1':外購 '2':其它             */
imz105      nvarchar(1),             /*是否為軟體物件                         */
                                     /*是否為軟體物件                   no:6843*/
imz106      nvarchar(1),             /*保稅料件型態                           */
                                     /*保稅料件型態 (1.原料 2.半成品 3.成品)  */
                                     /*no:6843                                */
imz107      nvarchar(1),             /*插件位置                               */
                                     /*插件位置   #No:6542              no:6843*/
                                     /*Y:  自動開窗輸入插件位置               */
                                     /*N:不自動開窗輸入插件位置               */
imz108      nvarchar(1),             /*工單發料前調撥否                       */
                                     /*工單發料前調撥否(Y/N)            no:6843*/
                                     /*Y:工單發料前須先依批量及最小發料量,針  */
                                     /*    對WIP倉庫存不足量, 以調撥方式調撥至*/
                                     /*    WIP倉(線上倉)補充之                */
                                     /*    但工單備料/發料時則不考慮發料倍量  */
                                     /*    N/Null:不調自動調撥(Default)       */
                                     /*    SMT料判斷此欄位 Y:發SMT料 N:非SMT料*/
imz109      nvarchar(10),            /*材料類別                               */
                                     /*材料類別                         no:6843*/
imz11       nvarchar(10),            /*其他分群碼 三                          */
                                     /*使用者自行定義                         */
imz110      nvarchar(1),             /*工單開立展開選項                       */
                                     /*工單開立展開選項                 no:6843*/
                                     /*1.不展開                               */
                                     /*2.不展開, 但自動開立工單               */
                                     /*3.展開                                 */
                                     /*4.開窗詢問是否展開                     */
imz12       nvarchar(10),            /*其他分群碼 四                          */
                                     /*使用者自行定義                         */
imz130      nvarchar(1),             /*產品銷售特性                           */
                                     /*產品銷售特性                     #MOD-660068*/
                                     /*  0.非產品, 不可銷售                   */
                                     /*  1.一般產品, 可直接銷售               */
                                     /*  2.MISC 類                            */
                                     /*  3.CSD類                              */
imz131      nvarchar(10),            /*產品分類編號                           */
                                     /*產品分類編號                     no:6843*/
imz132      nvarchar(24),            /*費用科目編號                           */
                                     /*費用科目編號                     no:6843*/
imz1321     nvarchar(24),            /*費用科目二                             */
imz133      nvarchar(40),            /*產品預測料號                           */
                                     /*產品預測料號                     no:6843*/
imz134      nvarchar(15),            /*主要包裝方式編號                       */
                                     /*主要包裝方式編號                 no:6843*/
imz136      nvarchar(10),            /*主要WIP 倉庫                           */
imz137      nvarchar(10),            /*主要WIP 儲位                           */
imz14       nvarchar(1),             /*是否為工程料件                         */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 工程料件                            */
                                     /*N: 非工程料件                          */
imz147      nvarchar(1),             /*插件位置與QPA是否要勾稽                */
                                     /*插件位置與QPA是否要勾稽 #NO:6542       */
imz148      smallint,                /*保證期                                 */
                                     /*保證期(天)              #NO:7181(養生) */
imz15       nvarchar(1),             /*保稅與否                               */
                                     /*正確值 Y/N                             */
                                     /*Y: 保稅                                */
                                     /*N: 非保稅                              */
imz150      nvarchar(1) DEFAULT ' ' NOT NULL, /*收貨替代方式*/
imz152      nvarchar(1) DEFAULT ' ' NOT NULL, /*PO對Blanket PO替代方式*/
imz153      decimal(18),             /*工單完工誤差率                         */
imz156      nvarchar(1) DEFAULT ' ' NOT NULL, /*號機自動編碼否*/
imz157      nvarchar(10),            /*號機編碼原則                           */
imz158      nvarchar(1) DEFAULT ' ' NOT NULL, /*號機庫存管理*/
imz17       nvarchar(4),             /*銷售統計單位                           */
imz19       nvarchar(4),             /*保稅料件進出口分類統計用類             */
imz21       nvarchar(4),             /*保稅料件稅則編號                       */
imz23       nvarchar(10),            /*倉管員                                 */
imz24       nvarchar(1),             /*檢驗否                                 */
imz25       nvarchar(4),             /*庫存單位                               */
imz27       decimal(18),             /*安全庫存量                             */
imz28       decimal(18),             /*安全庫存期間                           */
imz31       nvarchar(4),             /*銷售單位                               */
imz31_fac   decimal(18),             /*銷售單位/庫存單位換算率                */
imz34       nvarchar(10),            /*成本中心                               */
imz35       nvarchar(10),            /*主要倉庫別                             */
imz36       nvarchar(10),            /*主要儲位別                             */
imz37       nvarchar(1),             /*補貨策略碼                             */
                                     /*正確值 0/1/2/3/4/5                     */
                                     /*0: 再訂購點    Reorder point parts     */
                                     /*1: MRP         MRP parts               */
                                     /*2: MPS         MPS parts               */
                                     /*3: FAS         FAS parts               */
                                     /*4: 訂單式生產  On-order parts          */
                                     /*5: 期間採購    Fixed interval parts    */
imz38       decimal(18),             /*再補貨點                               */
imz39       nvarchar(24),            /*料件所屬會計科目                       */
imz391      nvarchar(24),            /*會計科目二                             */
imz42       nvarchar(1),             /*批號追蹤方式                           */
                                     /*正確值 0/1/2                           */
                                     /*0: 無                                  */
                                     /*1: 軟性                                */
                                     /*2: 硬性                                */
imz43       nvarchar(10),            /*採購員                                 */
imz44       nvarchar(4),             /*採購單位                               */
imz44_fac   decimal(18),             /*採購單位/庫存單位換算率                */
imz45       decimal(18),             /*採購單位倍量                           */
imz46       decimal(18),             /*最少採購數量                           */
                                     /*採購此料件時, 最少需採購數量           */
imz47       decimal(18),             /*採購損耗率                             */
imz48       decimal(18),             /*採購安全期                             */
imz49       decimal(18),             /*到廠前置期                             */
imz491      decimal(18),             /*入庫前置期                             */
imz50       decimal(18),             /*請購安全期                             */
imz51       decimal(18),             /*經濟訂購量                             */
imz52       decimal(18),             /*平均訂購量                             */
imz54       nvarchar(10),            /*主要供應廠商                           */
                                     /*需存在採購管理子系統中的供應廠商       */
imz55       nvarchar(4),             /*生產單位                               */
imz55_fac   decimal(18),             /*生產單位/庫存單位換算率                */
imz56       decimal(18),             /*生產單位倍量                           */
imz561      decimal(18),             /*最少生產數量                           */
imz562      decimal(18),             /*生產損耗率                             */
imz571      nvarchar(40),            /*主製程料件                             */
imz59       decimal(18),             /*固定前置時間                           */
imz60       decimal(18),             /*變動前置時間                           */
imz601      decimal(18),             /*變動前置時間批量                       */
imz61       decimal(18),             /*QC 前置時間                            */
imz62       decimal(18),             /*累計前置時間                           */
imz63       nvarchar(4),             /*發料單位                               */
imz63_fac   decimal(18),             /*發料單位/庫存單位換算率                */
imz64       decimal(18),             /*發料單位倍量                           */
imz641      decimal(18),             /*最少發料數量                           */
imz65       decimal(18),             /*發料安全存量                           */
imz66       decimal(18),             /*發料安全期                             */
imz67       nvarchar(10),            /*計劃員                                 */
imz68       decimal(18),             /*需求時距                               */
imz69       decimal(18),             /*計劃時距                               */
imz70       nvarchar(1),             /*消秏料件                               */
                                     /*正確值 Y/N                             */
imz71       smallint,                /*儲存有效天數                           */
imz72       nvarchar(1) DEFAULT '0' NOT NULL, /*是否需做供應商的管制*/
                                     /*0.不管制                               */
                                     /*1.請購單需管制                         */
                                     /*2.採購單需管制                         */
                                     /*3.二者皆需管制                         */
imz73       nvarchar(24),            /*代銷科目                               */
imz731      nvarchar(24),            /*代銷科目二                             */
imz86       nvarchar(4),             /*成本單位                               */
imz86_fac   decimal(18),             /*成本/庫存單位換算                      */
imz87       nvarchar(10),            /*成本項目                               */
imz871      decimal(18),             /*材料製造費用分攤率                     */
imz872      nvarchar(10),            /*材料製造費用成本項目                   */
imz873      decimal(18),             /*人工製造費用分攤率                     */
imz874      nvarchar(10),            /*人工製造費用成本項目                   */
imz88       decimal(18),             /*期間採購數量                           */
imz89       smallint,                /*期間採購使用的期間                     */
                                     /*期間採購使用的期間(月)                 */
imz90       smallint,                /*期間採購使用的期間                     */
                                     /*期間採購使用的期間(日)                 */
imz903      nvarchar(1),             /*可否做聯產品入庫                       */
                                     /*可否做聯產品入庫#NO:6872               */
imz906      nvarchar(1),             /*單位使用方式1.單一單位2.母子           */
imz907      nvarchar(4),             /*第二單位(母單位/參考單位)              */
imz908      nvarchar(4),             /*計價單位                               */
imz909      smallint,                /*MRP匯總時距(天)(預留欄位)              */
imz911      nvarchar(1),             /*是否為重覆性生產料件 (Y/N)             */
imz918      nvarchar(1),             /*製造批號管理否                         */
imz919      nvarchar(1),             /*製造批號自動編碼否                     */
imz920      nvarchar(10),            /*製造批號編碼原則                       */
imz921      nvarchar(1),             /*序號管理否                             */
imz922      nvarchar(1),             /*序號自動編碼否                         */
imz923      nvarchar(10),            /*序號編碼原則                           */
imz924      nvarchar(1),             /*序號唯一否                             */
imz925      nvarchar(1),             /*排序方式                               */
imz926      nvarchar(1) DEFAULT ' ' NOT NULL, /*AVL否*/
imz94       nvarchar(10),            /*預設製程編號 (工單開立時預             */
                                     /*預設製程編號 (工單開立時預設之)  no:6843*/
imz99       decimal(18),             /*再補貨量                               */
imzacti     nvarchar(1),             /*資料有效碼                             */
imzdate     datetime,                /*最近修改日                             */
imzgrup     nvarchar(10),            /*資料所有群                             */
imzicd01    nvarchar(40),            /*母體料號                               */
imzicd02    nvarchar(40),            /*外編母體                               */
imzicd03    nvarchar(40),            /*外編子體                               */
imzicd04    nvarchar(1),             /*料件狀態                               */
imzicd05    nvarchar(1),             /*料件特性                               */
imzicd06    nvarchar(40),            /*內編子體                               */
imzicd07    nvarchar(1),             /*RoHs                                   */
imzicd08    nvarchar(1),             /*刻號/BIN管理                           */
imzicd09    nvarchar(1),             /*Date Code 否                           */
imzicd10    nvarchar(10),            /*作業群組                               */
imzicd12    decimal(18),             /*備品比率                               */
imzicd13    nvarchar(1),             /*批號管控否                             */
imzicd79    nvarchar(80),            /*ICD 群組                               */
imzmodu     nvarchar(10),            /*資料更改者                             */
imzorig     nvarchar(10),            /*資料建立部門                           */
imzoriu     nvarchar(10),            /*資料建立者                             */
imzud01     nvarchar(255),           /*自訂欄位-Textedit                      */
imzud02     nvarchar(40),            /*自訂欄位-文字                          */
imzud03     nvarchar(40),            /*自訂欄位-文字                          */
imzud04     nvarchar(40),            /*自訂欄位-文字                          */
imzud05     nvarchar(40),            /*自訂欄位-文字                          */
imzud06     nvarchar(40),            /*自訂欄位-文字                          */
imzud07     decimal(18),             /*自訂欄位-數值                          */
imzud08     decimal(18),             /*自訂欄位-數值                          */
imzud09     decimal(18),             /*自訂欄位-數值                          */
imzud10     integer,                 /*自訂欄位-整數                          */
imzud11     integer,                 /*自訂欄位-整數                          */
imzud12     integer,                 /*自訂欄位-整數                          */
imzud13     datetime,                /*自訂欄位-日期                          */
imzud14     datetime,                /*自訂欄位-日期                          */
imzud15     datetime,                /*自訂欄位-日期                          */
imzuser     nvarchar(10)             /*資料所有者                             */
);

alter table imz_file add constraint imz_pk primary key  (imz01);
grant select on imz_file to tiptopgp;
grant update on imz_file to tiptopgp;
grant delete on imz_file to tiptopgp;
grant insert on imz_file to tiptopgp;
grant references on imz_file to tiptopgp;
grant references on imz_file to ods;
grant select on imz_file to ods;
