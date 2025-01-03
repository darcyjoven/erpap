/*
================================================================================
檔案代號:ecb_file
檔案名稱:製程資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecb_file
(
ecb01       nvarchar(40) NOT NULL,   /*料件編號                               */
ecb012      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
ecb02       nvarchar(10) NOT NULL,   /*製程編號                               */
ecb03       smallint NOT NULL,       /*製程序號                               */
                                     /*料件被製作程序過程中的生產活動順序編號 */
ecb04       decimal(18),             /*完工比率                               */
ecb05       datetime,                /*No Use                                 */
ecb06       nvarchar(6),             /*作業編號                               */
                                     /*料件被製作程序過程中的生產活動編號     */
ecb07       nvarchar(10),            /*機器編號                               */
                                     /*在生產程序/作業中, 使用的機器編號      */
ecb08       nvarchar(10),            /*工作站編號                             */
                                     /*該生產程序/作業在何一工作站被生產      */
                                     /*需存在工作站資料檔中                   */
ecb09       nvarchar(1),             /*盤點作業                               */
                                     /*盤點作業(Y/N)                          */
                                     /*表示需要在此生產程序/作業完成時, 需輸入*/
                                     /*完工數量, 報廢數量及生產時間           */
                                     /*在採用量產製造系統或領料系統時, 需作此 */
                                     /*程序控制                               */
ecb10       decimal(18),             /*搬運時間                               */
                                     /*搬運時間(秒)                           */
                                     /*上下生產程序/作業間所需的搬運時間      */
                                     /*欄位值表示每一單位需多少秒             */
ecb11       decimal(18),             /*作業重疊程度                           */
                                     /*作業重疊程度(%)                        */
                                     /*表示本生產程序/作業與該製程內, 其它生產*/
                                     /*程序/作業有多少程度的重疊, 為一百分比  */
                                     /*預設值為 '零'                          */
                                     /*正確值不可大於 '100'                   */
ecb12       nvarchar(10),            /*輸出裝置編號                           */
                                     /*表示輸出的所在裝置                     */
                                     /*量產製造系統時, 可作為看板設備編號     */
ecb13       nvarchar(1),             /*成本計算基準                           */
                                     /*有關製程的作業時間使用之,由工作站預設而*/
                                     /*來,欄位值表示方式方式                  */
                                     /*正確值為 1/2                           */
                                     /*1: 表示每單位小時(小時/單位)           */
                                     /*2: 表示每小時單位(單位/小時)           */
                                     /*使用'2'時, 系統計算時會轉換為'1'之方式 */
ecb14       decimal(18),             /*變動損耗率                             */
                                     /*損耗率(%)                              */
                                     /*表示在本生產程序/作業將會發生的標準    */
                                     /*損耗率, 在對材料而言, 系統將依產品如   */
                                     /*結構中的損耗率, 為一百分比             */
ecb15       smallint,                /*人工數                                 */
                                     /*表示本生產程序/作業, 所需人工資源數目  */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為人工產能時, 此欄位必需輸入, 預設值 */
                                     /*需為 '1'                               */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為機器產能時, 此欄位尚可輸入, 預設值 */
                                     /*需為 '0'                               */
ecb16       smallint,                /*機器數                                 */
                                     /*表示本生產程序/作業, 所需機器資源數目  */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為機器產能時, 此欄位必需輸入, 預設值 */
                                     /*需為 '1'                               */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為人工產能時, 此欄位不輸入, 其值為 '0'*/
ecb17       nvarchar(80),            /*說明                                   */
                                     /*表示本生產程序/作業特質說明            */
                                     /*--------標準時間------------------------*/
ecb18       decimal(18),             /*標準人工設置時間                       */
                                     /*標準人工設置時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準人工設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費人工工時多少分鐘去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
ecb19       decimal(18),             /*標準人工生產時間                       */
                                     /*標準人工生產時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準人工生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*人工工時多少分鐘去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/分       */
                                     /* 或 分/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
ecb20       decimal(18),             /*標準機器設置時間                       */
                                     /*標準機器設置時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準機器設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費機器工時多少分鐘去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
ecb21       decimal(18),             /*標準機器生產時間                       */
                                     /*標準機器生產時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準機器生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*機器工時多少分鐘去生產, 且需依所屬的工 */
                                     /*作站的成本計算基準, 決定為 單位/分 或  */
                                     /*分/單位                                */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
ecb22       decimal(18),             /*標準廠外加工時間                       */
                                     /*標準廠外加工時間(秒)                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示每一     */
                                     /*單位所需花費標準加工工時(單位=秒)      */
                                     /*否則, 不需輸入                         */
ecb23       decimal(18),             /*標準廠外加工成本                       */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示每一     */
                                     /*單位所需花費標準加工成本               */
                                     /*否則, 不需輸入                         */
ecb24       nvarchar(40),            /*廠外加工料件                           */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示加工     */
                                     /*單/採購單上料件編號                    */
                                     /*需存在在料件基本資料主檔               */
                                     /*否則, 不需輸入                         */
ecb25       nvarchar(10),            /*廠外加工廠商                           */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示代工     */
                                     /*廠商編號需存在在供應廠商資料主檔       */
                                     /*否則, 不需輸入                         */
                                     /*---------排程時間-----------------------*/
ecb26       decimal(18),             /*排程設置時間                           */
                                     /*排程設置時間(秒)                       */
                                     /*表示在該生產程序/作業排程時, 所需花費設*/
                                     /*置工時, 其欄位值, 表示每批最少         */
                                     /*需花費多少秒去設置                     */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位不被輸入及考慮   */
ecb27       decimal(18),             /*排程生產時間                           */
                                     /*排程生產時間(秒)                       */
                                     /*表示在該生產程序/作業排程時, 所需花費生*/
                                     /*產工時, 其欄位值, 表示每生產一單位最少 */
                                     /*需花費多少分鐘去生產, 且需依所屬的工作 */
                                     /*站的成本計算基準, 決定為 單位/秒 或    */
                                     /* 或 秒/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位不被輸入及考慮   */
ecb28       decimal(18),             /*排程廠外加工時間                       */
                                     /*排程廠外加工時間(秒)                   */
                                     /*表示在該生產程序/作業排程時, 所需花費廠*/
                                     /*外加工工時, 其欄位值, 表示每加工生產一 */
                                     /*單位最少需花費多少秒                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位將被輸入及考慮   */
                                     /*---------預設時間-----------------------*/
ecb30       decimal(18),             /*預設人工設置時間(分)                   */
                                     /*表示在該生產程序/作業, 所需預設人工設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費人工工時多少分鐘去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
ecb31       decimal(18),             /*預設人工生產時間(分)                   */
                                     /*表示在該生產程序/作業, 所需預設人工生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*人工工時多少分鐘去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/分 或    */
                                     /* 或 分/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
ecb32       decimal(18),             /*預設機器設置時間(分)                   */
                                     /*表示在該生產程序/作業, 所需預設機器設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費機器工時多少分鐘去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
ecb33       decimal(18),             /*預設機器生產時間(分)                   */
                                     /*表示在該生產程序/作業, 所需預設機器生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*機器工時多少分鐘去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/分 或    */
                                     /* 或 分/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
ecb34       decimal(18),             /*預設廠外加工時間                       */
                                     /*預設廠外加工時間(分)                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示每一     */
                                     /*單位所需花費預設加工工時(單位=分)      */
                                     /*否則, 不需輸入                         */
ecb35       decimal(18),             /*預設廠外加工成本                       */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位表示每一單位所需花*/
                                     /*費預設加工成本                         */
                                     /*否則, 不需輸入                         */
ecb36       nvarchar(40),            /*規格組件編號                           */
                                     /*如果該料件為最後規格料件時, 需輸入此欄位*/
                                     /*且所有的製程資料應經由'最後規格組件製程*/
                                     /*產生作業'而來                          */
                                     /*否則應為'空白', 不使用                 */
ecb37       nvarchar(5),             /*作業選擇                               */
                                     /*如果該料件為最後規格料件時, 需輸入此欄位*/
                                     /*且所有的製程資料應經由'最後規格組件製程*/
                                     /*產生作業'而來, 記錄其選擇何一'作業選擇'*/
                                     /*否則應為'空白', 不使用                 */
ecb38       decimal(18),             /*單位人力                               */
ecb39       nvarchar(1),             /*委外否                                 */
ecb40       nvarchar(1),             /*PQC 否                                 */
ecb41       nvarchar(1),             /*Check in 否                            */
ecb42       nvarchar(10),            /*Check in hold                          */
ecb43       nvarchar(10),            /*Check out Hold留置碼                   */
ecb44       nvarchar(4),             /*NO USE                                 */
ecb45       nvarchar(4),             /*轉出單位                               */
ecb46       decimal(18),             /*组成用量                               */
ecb47       smallint,                /*單元變更序號                           */
ecb48       decimal(18),             /*加工單價                               */
ecb49       nvarchar(10),            /*主供應商                               */
ecb51       decimal(18),             /*底數                                   */
ecb52       decimal(18),             /*固定損耗量                             */
ecb53       decimal(18),             /*損耗批量                               */
ecb66       nvarchar(1) DEFAULT ' ' NOT NULL, /*報工點否*/
ecbacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
ecbdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
ecbgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
ecbmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
ecborig     nvarchar(10),            /*資料建立部門                           */
ecboriu     nvarchar(10),            /*資料建立者                             */
ecbslk01    nvarchar(1),             /*裁片管理否                             */
ecbslk02    decimal(18),             /*現實工時                               */
ecbslk03    decimal(18),             /*延後上工序開工天數                     */
ecbslk04    decimal(18),             /*標准工價                               */
ecbslk05    decimal(18),             /*現實工價                               */
ecbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
ecbud02     nvarchar(40),            /*自訂欄位-文字                          */
ecbud03     nvarchar(40),            /*自訂欄位-文字                          */
ecbud04     nvarchar(40),            /*自訂欄位-文字                          */
ecbud05     nvarchar(40),            /*自訂欄位-文字                          */
ecbud06     nvarchar(40),            /*自訂欄位-文字                          */
ecbud07     decimal(18),             /*自訂欄位-數值                          */
ecbud08     decimal(18),             /*自訂欄位-數值                          */
ecbud09     decimal(18),             /*自訂欄位-數值                          */
ecbud10     integer,                 /*自訂欄位-整數                          */
ecbud11     integer,                 /*自訂欄位-整數                          */
ecbud12     integer,                 /*自訂欄位-整數                          */
ecbud13     datetime,                /*自訂欄位-日期                          */
ecbud14     datetime,                /*自訂欄位-日期                          */
ecbud15     datetime,                /*自訂欄位-日期                          */
ecbuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

alter table ecb_file add constraint ecb_pk primary key  (ecb01,ecb02,ecb03,ecb012);
grant select on ecb_file to tiptopgp;
grant update on ecb_file to tiptopgp;
grant delete on ecb_file to tiptopgp;
grant insert on ecb_file to tiptopgp;
grant references on ecb_file to tiptopgp;
grant references on ecb_file to ods;
grant select on ecb_file to ods;
