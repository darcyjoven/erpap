/*
================================================================================
檔案代號:sgm_file
檔案名稱:Run Card 製程追蹤檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgm_file
(
sgm01       nvarchar(19) NOT NULL,   /*Run Card                               */
sgm011      nvarchar(10),            /*上製程段號                             */
sgm012      nvarchar(10) NOT NULL,   /*製程段號                               */
sgm02       nvarchar(20),            /*工單單號                               */
sgm03       smallint NOT NULL,       /*製程序號                               */
                                     /*料件被製作程序過程中的生產活動順序編號 */
sgm03_par   nvarchar(40),            /*料件編號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
sgm04       nvarchar(6),             /*作業編號                               */
                                     /*料件被製作程序過程中的生產活動編號     */
sgm05       nvarchar(10),            /*機器編號                               */
                                     /*在生產程序/作業中, 使用的機器編號      */
sgm06       nvarchar(10),            /*工作中心編號                           */
                                     /*該生產程序/作業在何一工作站被生產      */
sgm07       decimal(18),             /*最早起始前置時間調整                   */
                                     /*最早起始前置時間調整(天)               */
                                     /*此欄位由系統直接維護,                  */
                                     /*代表自工單完工日倒算那一天就要起始動工 */
                                     /*時間含固定與變動時間                   */
sgm08       decimal(18),             /*最遲起始前置時間調整                   */
                                     /*最遲起始前置時間調整(天)               */
                                     /*此欄位由系統直接維護,                  */
                                     /*代表自工單完工日倒算那一天就要起始動工 */
                                     /*時間,但不包括固定前置時間              */
sgm09       decimal(18),             /*最早完工前置時間調整                   */
                                     /*最早完工前置時間調整(天)               */
                                     /*此欄位由系統直接維護,                  */
                                     /*代表自工單開工日往前算那一天此作業就   */
                                     /*該結束時間,不含固定前置時間            */
sgm10       decimal(18),             /*最遲完工前置時間調整                   */
                                     /*最遲完工前置時間調整(天)               */
                                     /*此欄位由系統直接維護,                  */
                                     /*代表自工單開工日往前算那一天此作業就   */
                                     /*該結束時間,含固定與前置時間時間        */
sgm11       nvarchar(10),            /*製程編號                               */
sgm12       decimal(18),             /*損耗率                                 */
                                     /*損耗率(%)                              */
                                     /*表示在本生產程序/作業將會發生的標準    */
                                     /*損耗率, 在對材料而言, 系統將依產品如   */
                                     /*結構中的損耗率, 為一百分比             */
                                     /*yield                                  */
                                     /*存放-percent 值                        */
sgm121      nvarchar(1),             /*盤點作業                               */
                                     /*盤點作業(Y/N)                          */
                                     /*表示需要在此生產程序/作業完成時, 需輸入*/
                                     /*完工數量, 報廢數量及生產時間           */
                                     /*在採用量產製造系統或領料系統時, 需作此 */
                                     /*程序控制                               */
                                     /*----------標準時間----------------------*/
sgm13       decimal(18),             /*標準人工設置時間                       */
                                     /*標準人工設置時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準人工設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費人工工時多少小時去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
sgm14       decimal(18),             /*標準人工生產時間                       */
                                     /*標準人工生產時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準人工生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*人工工時多少小時去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/時       */
                                     /* 或 時/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
sgm15       decimal(18),             /*標準機器設置時間                       */
                                     /*標準機器設置時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準機器設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費機器工時多少小時去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
sgm16       decimal(18),             /*標準機器生產時間                       */
                                     /*標準機器生產時間(秒)                   */
                                     /*表示在該生產程序/作業, 所需標準機器生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*機器工時多少小時去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/時 或    */
                                     /* 或 時/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
sgm17       decimal(18),             /*標準廠外加工時間                       */
                                     /*標準廠外加工時間(分)                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示每一     */
                                     /*單位所需花費標準加工工時(單位=時)      */
                                     /*否則, 不需輸入                         */
sgm18       decimal(18),             /*標準等待時間                           */
                                     /*標準搬運時間(分)                       */
                                     /*上下生產程序/作業間所需的搬運時間      */
                                     /*欄位值表示每一單位需多少小時           */
sgm19       decimal(18),             /*標準等待時間                           */
                                     /*標準等待時間(分)                       */
                                     /*上下工作站之間的平均等待時間,          */
                                     /*時間單位為時                           */
                                     /*----------實際時間----------------------*/
                                     /*實際時間為總值,不是以一單位來表示      */
                                     /*且不受成本計算基準所影響   93/09/01    */
                                     /*表示方式為實際發生時間(單位為分)       */
sgm20       decimal(18),             /*實際人工生產時間                       */
                                     /*實際人工設置時間(分)                   */
                                     /*表示在該生產程序/作業, 實際發生人工設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費人工工時多少小時去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
sgm21       decimal(18),             /*實際人工生產時間                       */
                                     /*實際人工生產時間(分)                   */
                                     /*表示在該生產程序/作業, 實際發生人工生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*人工工時多少小時去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/時       */
                                     /* 或 時/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位亦可允許輸入, 系統*/
                                     /*將會同時考慮                           */
sgm22       decimal(18),             /*實際機器設置時間                       */
                                     /*實際機器設置時間(分)                   */
                                     /*表示在該生產程序/作業, 實際發生機器設置*/
                                     /*花費時間, 其欄位值, 表示每一生產批量需 */
                                     /*花費機器工時多少小時去設置             */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
sgm23       decimal(18),             /*實際機器生產時間                       */
                                     /*實際機器生產時間(分)                   */
                                     /*表示在該生產程序/作業, 實際發生機器生產*/
                                     /*花費時間, 其欄位值, 表示每一單位所需花費*/
                                     /*機器工時多少小時去生產, 且需依所屬的工作*/
                                     /*站的成本計算基準, 決定為 單位/時 或    */
                                     /* 或 時/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為機器產能時, 則此欄位可輸入           */
                                     /*若該生產程序/作業, 所屬工作站為產能型態*/
                                     /*為人工產能時, 則此欄位不允許輸入       */
sgm24       decimal(18),             /*實際廠外加工時間                       */
                                     /*實際廠外加工時間(分)                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/   */
                                     /*廠外加工工作站時, 則此欄位表示總共     */
                                     /*花多少設置及生產時間(單位=分)          */
                                     /*----------賺得時間----------------------*/
sgm25       decimal(18),             /*賺得標準人工設置時間                   */
                                     /*賺得標準人工設置時間(分)               */
                                     /*此欄位由系統自動維護                   */
                                     /*當一個單位數量完工時,即已賺得標準人工  */
                                     /*設置時間.                              */
sgm26       decimal(18),             /*賺得標準人工生產時間                   */
                                     /*賺得標準人工生產時間(分)               */
                                     /*此欄位由系統自動維護                   */
                                     /*其計算式為:                            */
                                     /*每單位小時或每小時單位時間乘上已完工數量*/
sgm27       decimal(18),             /*賺得標準機器設置時間                   */
                                     /*賺得標準機器設置時間(分)               */
                                     /*此欄位由系統自動維護                   */
                                     /*當一個單位數量完工時,即已賺得標準機器  */
                                     /*設置時間.                              */
sgm28       decimal(18),             /*賺得標準機器生產時間                   */
                                     /*賺得標準機器生產時間(分)               */
sgm291      decimal(18),             /*Check in Qty                           */
sgm292      decimal(18),             /*盤點量                                 */
sgm301      decimal(18),             /*良品轉入量       (+)                   */
sgm302      decimal(18),             /*重工轉入量       (+)                   */
sgm303      decimal(18),             /*分割轉入量       (+)                   */
sgm304      decimal(18),             /*合併轉入量       (+)                   */
sgm311      decimal(18),             /*良品轉出量       (-)                   */
sgm312      decimal(18),             /*重工轉出         (-)                   */
sgm313      decimal(18),             /*當站報廢量       (-)                   */
sgm314      decimal(18),             /*當站下線量(入庫) (-)                   */
sgm315      decimal(18),             /*Bonus Qty        (-)                   */
sgm316      decimal(18),             /*分割轉出量       (-)                   */
sgm317      decimal(18),             /*合併轉出量       (-)                   */
sgm321      decimal(18),             /*委外加工量                             */
sgm322      decimal(18),             /*委外完工量                             */
sgm34       decimal(18),             /*實際損耗率                             */
sgm35       decimal(18),             /*C/R 比率                               */
                                     /*C/R 比率%                              */
                                     /*做為分派工單生產優先順序依据           */
                                     /*其值愈小表此工單愈優先生產             */
sgm36       decimal(18),             /*報廢平均人工分攤比率                   */
                                     /*報廢平均人工分攤比率%                  */
                                     /*-------排程時間-------------------------*/
sgm37       decimal(18),             /*排程人工設置時間                       */
                                     /*排程人工設置時間(分)                   */
                                     /*表示在該生產程序/作業排程時, 所需花費設*/
                                     /*置工時, 其欄位值, 表示每生產一單位最少 */
                                     /*需花費多少小時去設置                   */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位不被輸入及考慮   */
sgm38       decimal(18),             /*排程人工生產時間                       */
                                     /*排程人工生產時間(分)                   */
                                     /*表示在該生產程序/作業排程時, 所需花費生*/
                                     /*產工時, 其欄位值, 表示每生產一單位最少 */
                                     /*需花費多少小時去生產, 且需依所屬的工作 */
                                     /*站的成本計算基準, 決定為 單位/時 或    */
                                     /* 或 時/單位                            */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位不被輸入及考慮   */
sgm39       decimal(18),             /*排程廠外加工時間                       */
                                     /*排程廠外加工時間(分)                   */
                                     /*表示在該生產程序/作業排程時, 所需花費廠*/
                                     /*外加工工時, 其欄位值, 表示每加工生產一 */
                                     /*單位最少需花費多少小時                 */
                                     /*若該生產程序/作業, 所屬工作站為廠內/廠外*/
                                     /*加工工作站時, 則此欄位將被輸入及考慮   */
sgm40       smallint,                /*人工數目                               */
                                     /*表示本生產程序/作業, 所需人工資源數目  */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為人工產能時, 此欄位必需輸入, 預設值 */
                                     /*需為 '1'                               */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為機器產能時, 此欄位尚可輸入, 預設值 */
                                     /*需為 '0'                               */
sgm41       smallint,                /*機器數目                               */
                                     /*表示本生產程序/作業, 所需機器資源數目  */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為機器產能時, 此欄位必需輸入, 預設值 */
                                     /*需為 '1'                               */
                                     /*如該生產程序/作業, 所屬的工作站的產能型*/
                                     /*態為人工產能時, 此欄位不輸入, 其值為 '0'*/
sgm42       decimal(18),             /*作業重疊程度                           */
                                     /*作業重疊程度(%)                        */
                                     /*表示本生產程序/作業與該製程內, 其它生產*/
                                     /*程序/作業有多少程度的重疊, 為一百分比  */
                                     /*預設值為 '零'                          */
                                     /*正確值不可大於 '100'                   */
sgm43       nvarchar(1),             /*成本計算基準                           */
                                     /*有關工作站的成本率或製程的標準作業時間 */
                                     /*欄位值表示方式方式                     */
                                     /*正確值為 1/2                           */
                                     /*1: 表示每單位小時(小時/單位)           */
                                     /*2: 表示每小時單位(單位/小時)           */
                                     /*使用'2'時, 系統計算時會轉換為'1'之方式 */
sgm45       nvarchar(80),            /*作業名稱                               */
                                     /*作業名稱  add 99/04/28                 */
sgm49       decimal(18),             /*單位人力                               */
                                     /*單位人力  add 99/04/28                 */
sgm50       datetime,                /*製程開工日                             */
                                     /*製程開工日 add 99/04/28                */
sgm51       datetime,                /*製程完工日                             */
                                     /*製程完工日 add 99/04/28                */
sgm52       nvarchar(1),             /*委外否                                 */
sgm53       nvarchar(1),             /*PQC 否                                 */
sgm54       nvarchar(1),             /*Check in 否                            */
sgm55       nvarchar(10),            /*Check in 留置碼                        */
sgm56       nvarchar(10),            /*Check out 留置碼                       */
sgm57       nvarchar(4),             /*轉入單位                               */
sgm58       nvarchar(4),             /*轉出單位                               */
sgm59       decimal(18),             /*單位轉換率                             */
sgm62       decimal(18),             /*組成用量                               */
sgm63       decimal(18),             /*底數                                   */
sgm64       decimal(18),             /*損耗批量                               */
sgm65       decimal(18),             /*標準產出量                             */
sgm66       nvarchar(1) DEFAULT ' ' NOT NULL, /*報工點否*/
sgm67       nvarchar(10),            /*委外廠商                               */
sgmacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
sgmdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
sgmgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
sgmlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sgmmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
sgmorig     nvarchar(10),            /*資料建立部門                           */
sgmoriu     nvarchar(10),            /*資料建立者                             */
sgmplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sgmuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

create        index sgmplant_idx on sgm_file (sgmplant);
alter table sgm_file add constraint sgm_pk primary key  (sgm01,sgm03,sgm012);
grant select on sgm_file to tiptopgp;
grant update on sgm_file to tiptopgp;
grant delete on sgm_file to tiptopgp;
grant insert on sgm_file to tiptopgp;
grant references on sgm_file to tiptopgp;
grant references on sgm_file to ods;
grant select on sgm_file to ods;
