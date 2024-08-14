/*
================================================================================
檔案代號:imaa_file
檔案名稱:料件申請資料主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imaa_file
(
imaa00      nvarchar(1),             /*申請類別(I:新增 U:修改)                */
imaa01      nvarchar(40) NOT NULL,   /*料件編號                               */
imaa011     nvarchar(40),            /*申請料件編號                           */
imaa02      nvarchar(120),           /*品名                                   */
imaa021     nvarchar(120),           /*規格                                   */
imaa03      nvarchar(40),            /*目錄參考號碼                           */
imaa04      nvarchar(255),           /*工程圖號                               */
imaa05      nvarchar(2),             /*No Use                                 */
imaa06      nvarchar(10),            /*分群碼0:表由其他相關系統而             */
imaa07      nvarchar(1),             /*abc碼                                  */
imaa08      nvarchar(1),             /*來源碼                                 */
imaa09      nvarchar(10),            /*其他分群碼                             */
imaa10      nvarchar(10),            /*其他分群碼 二                          */
imaa100     nvarchar(1),             /*檢驗程度                               */
imaa1001    nvarchar(100),           /*中文名稱(全稱)                         */
imaa1002    nvarchar(80),            /*英文名稱                               */
imaa1003    nvarchar(20),            /*No Use                                 */
imaa1004    nvarchar(10),            /*品類                                   */
imaa1005    nvarchar(10),            /*品牌                                   */
imaa1006    nvarchar(10),            /*系列                                   */
imaa1007    nvarchar(10),            /*型別                                   */
imaa1008    nvarchar(10),            /*規格                                   */
imaa1009    nvarchar(10),            /*屬性                                   */
imaa101     nvarchar(1),             /*檢驗水準                               */
imaa1010    nvarchar(1),             /*狀態碼                                 */
imaa1011    decimal(18),             /*單位體積                               */
imaa1012    datetime,                /*No Use                                 */
imaa1013    datetime,                /*No Use                                 */
imaa1014    nvarchar(1),             /*產品週期狀態                           */
imaa1015    datetime,                /*預計停產日                             */
imaa1016    nvarchar(40),            /*箱條碼                                 */
imaa1017    decimal(18),             /*料件標準寬                             */
imaa1018    decimal(18),             /*料件標準秤量                           */
imaa1019    decimal(18),             /*零只長度                               */
imaa102     nvarchar(1),             /*級數                                   */
imaa1020    decimal(18),             /*零只寬度                               */
imaa1021    decimal(18),             /*零只高度                               */
imaa1022    decimal(18),             /*零只體積                               */
imaa1023    decimal(18),             /*零只重量                               */
imaa1024    decimal(18),             /*整箱長度                               */
imaa1025    decimal(18),             /*整箱寬度                               */
imaa1026    decimal(18),             /*整箱高度                               */
imaa1027    decimal(18),             /*整箱體積                               */
imaa1028    decimal(18),             /*整箱重量                               */
imaa1029    nvarchar(1),             /*是否秤重控管                           */
imaa103     nvarchar(1),             /*採購特性                               */
imaa104     decimal(18),             /*廠商分配起始量                         */
imaa105     nvarchar(1),             /*是否為軟體物件                         */
imaa106     nvarchar(1),             /*保稅料件型態                           */
imaa107     nvarchar(1),             /*插件位置                               */
imaa108     nvarchar(1),             /*工單發料前調撥否                       */
imaa109     nvarchar(10),            /*材料類別                               */
imaa11      nvarchar(10),            /*其他分群碼 三                          */
imaa110     nvarchar(1),             /*工單開立展開選項                       */
imaa111     nvarchar(5),             /*預設工單單別                           */
imaa12      nvarchar(10),            /*其他分群碼 四                          */
imaa120     nvarchar(1) DEFAULT ' ' NOT NULL, /*料件性質*/
imaa121     decimal(18),             /*單位材料成本                           */
imaa122     decimal(18),             /*單位人工成本                           */
imaa123     decimal(18),             /*單位製造費用                           */
imaa124     decimal(18),             /*單位管銷成本                           */
imaa125     decimal(18),             /*單位成本                               */
imaa126     decimal(18),             /*基本利潤率                             */
imaa127     decimal(18),             /*未稅訂價                               */
imaa128     decimal(18),             /*含稅訂價                               */
imaa129     decimal(18),             /*轉撥計價加計百分比                     */
imaa13      nvarchar(40),            /*規格組件料件編號                       */
imaa130     nvarchar(1),             /*產品銷售特性                           */
imaa131     nvarchar(10),            /*產品分類編號                           */
imaa132     nvarchar(24),            /*費用科目編號                           */
imaa1321    nvarchar(24),            /*費用科目二                             */
imaa133     nvarchar(40),            /*產品預測料號                           */
imaa134     nvarchar(15),            /*主要包裝方式編號                       */
imaa135     nvarchar(40),            /*產品條碼編號                           */
imaa136     nvarchar(10),            /*主要wip 倉庫                           */
imaa137     nvarchar(10),            /*主要wip 儲位                           */
imaa138     nvarchar(40),            /*FCC No.                                */
imaa139     nvarchar(1),             /*mps 計算否                             */
imaa14      nvarchar(1),             /*是否為工程料件                         */
imaa140     nvarchar(1),             /*No Use                                 */
imaa141     nvarchar(1),             /*產品序號控制方式                       */
imaa142     smallint,                /*產品序號之固定長度                     */
imaa143     smallint,                /*產品序號之字首固定長度                 */
imaa144     nvarchar(10),            /*產品序號之字首固定字                   */
imaa145     nvarchar(1),             /*產品序號是否為固定長度                 */
imaa146     nvarchar(1),             /*bom異動否                              */
imaa147     nvarchar(1),             /*插件位置與qpa是否要勾稽                */
imaa148     smallint,                /*保證期                                 */
imaa15      nvarchar(1),             /*保稅與否                               */
imaa153     decimal(18),             /*工單完工誤差率                         */
imaa16      smallint,                /*No Use                                 */
imaa17      nvarchar(4),             /*No Use                                 */
imaa17_fac  decimal(18),             /*No Use                                 */
imaa18      decimal(18),             /*單位重量                               */
imaa19      nvarchar(4),             /*保稅料件進出口分類統計用類             */
imaa20      decimal(18),             /*保稅料件年度盤差容許率                 */
imaa21      nvarchar(4),             /*保稅料件稅則編號                       */
imaa22      decimal(18),             /*保稅料件應補稅稅率                     */
imaa23      nvarchar(10),            /*倉管員                                 */
imaa24      nvarchar(1),             /*檢驗碼                                 */
imaa25      nvarchar(4),             /*庫存單位                               */
imaa26      decimal(18) NOT NULL,    /*No Use                                 */
imaa261     decimal(18) NOT NULL,    /*No Use                                 */
imaa262     decimal(18) NOT NULL,    /*No Use                                 */
imaa27      decimal(18),             /*安全庫存量                             */
imaa271     decimal(18),             /*最高儲存數量                           */
imaa28      decimal(18),             /*安全庫存期間                           */
imaa29      datetime,                /*No Use                                 */
imaa30      datetime,                /*No Use                                 */
imaa31      nvarchar(4),             /*銷售單位                               */
imaa31_fac  decimal(18),             /*銷售單位/庫存單位換算率                */
imaa32      decimal(18),             /*標準銷售訂價                           */
imaa33      decimal(18),             /*最近銷售單價                           */
imaa34      nvarchar(10),            /*成本中心                               */
imaa35      nvarchar(10),            /*主要倉庫別                             */
imaa36      nvarchar(10),            /*主要儲位別                             */
imaa37      nvarchar(1),             /*補貨策略碼                             */
imaa38      decimal(18),             /*再補貨點                               */
imaa39      nvarchar(24),            /*料件所屬會計科目                       */
imaa391     nvarchar(24),            /*會計科目二                             */
imaa40      decimal(18),             /*No Use                                 */
imaa41      decimal(18),             /*No Use                                 */
imaa42      nvarchar(1),             /*批號追蹤方式                           */
imaa43      nvarchar(10),            /*採購員                                 */
imaa44      nvarchar(4),             /*採購單位                               */
imaa44_fac  decimal(18),             /*採購單位/庫存單位換算率                */
imaa45      decimal(18),             /*採購單位倍量                           */
imaa46      decimal(18),             /*最少採購數量                           */
imaa47      decimal(18),             /*採購損耗率                             */
imaa48      decimal(18),             /*採購安全期                             */
imaa49      decimal(18),             /*到廠前置期                             */
imaa491     decimal(18),             /*入庫前置期                             */
imaa50      decimal(18),             /*請購安全期                             */
imaa51      decimal(18),             /*經濟訂購量                             */
imaa52      decimal(18),             /*No Use                                 */
imaa53      decimal(18),             /*No Use                                 */
imaa531     decimal(18),             /*市價                                   */
imaa532     datetime,                /*No Use                                 */
imaa54      nvarchar(10),            /*主要供應廠商                           */
imaa55      nvarchar(4),             /*生產單位                               */
imaa55_fac  decimal(18),             /*生產單位/庫存單位換算率                */
imaa56      decimal(18),             /*生產單位倍量                           */
imaa561     decimal(18),             /*最少生產數量                           */
imaa562     decimal(18),             /*生產損耗率                             */
imaa57      smallint,                /*主製程序號                             */
imaa571     nvarchar(40),            /*主製程料件                             */
imaa58      decimal(18),             /*最後人工工時                           */
imaa59      decimal(18),             /*固定前置時間                           */
imaa60      decimal(18),             /*變動前置時間                           */
imaa601     decimal(18),             /*變動前置時間批量                       */
imaa61      decimal(18),             /*qc 前置時間                            */
imaa62      decimal(18),             /*最大累計前置時間                       */
imaa63      nvarchar(4),             /*發料單位                               */
imaa63_fac  decimal(18),             /*發料單位/庫存單位換算率                */
imaa64      decimal(18),             /*發料單位倍量                           */
imaa641     decimal(18),             /*最少發料數量                           */
imaa65      decimal(18),             /*發料安全存量                           */
imaa66      decimal(18),             /*發料安全期                             */
imaa67      nvarchar(10),            /*計劃員                                 */
imaa68      decimal(18),             /*需求時距                               */
imaa69      decimal(18),             /*計劃時距                               */
imaa70      nvarchar(1),             /*消秏料件                               */
imaa71      smallint,                /*儲存有效天數                           */
imaa72      decimal(18),             /*成本單位的庫存數量                     */
imaa73      datetime,                /*No Use                                 */
imaa74      datetime,                /*No Use                                 */
imaa75      nvarchar(15),            /*No Use                                 */
imaa76      nvarchar(10),            /*No Use                                 */
imaa77      decimal(18),             /*No Use                                 */
imaa78      smallint,                /*預算成本階數                           */
imaa79      smallint,                /*No Use                                 */
imaa80      smallint,                /*發料低階碼                             */
imaa81      smallint,                /*No Use                                 */
imaa82      smallint,                /*No Use                                 */
imaa83      smallint,                /*No Use                                 */
imaa84      smallint,                /*No Use                                 */
imaa85      smallint,                /*No Use                                 */
imaa851     nvarchar(10),            /*預設工作區                             */
imaa852     nvarchar(1),             /*是否為量產料件                         */
imaa853     nvarchar(1),             /*No Use                                 */
imaa86      nvarchar(4),             /*成本單位                               */
imaa86_fac  decimal(18),             /*成本/庫存單位換算率                    */
imaa87      nvarchar(10),            /*成本項目-材料                          */
imaa871     decimal(18),             /*間接物料分攤率                         */
imaa872     nvarchar(10),            /*材料製造費用成本項目                   */
imaa873     decimal(18),             /*間接人工分攤率                         */
imaa874     nvarchar(10),            /*人工製造費用成本項目                   */
imaa88      decimal(18),             /*期間採購數量                           */
imaa881     datetime,                /*No Use                                 */
imaa89      smallint,                /*期間採購使用的期間                     */
imaa90      smallint,                /*期間採購使用的期間                     */
imaa901     datetime,                /*No Use                                 */
imaa902     datetime,                /*No Use                                 */
imaa903     nvarchar(1),             /*可否做聯產品入庫                       */
imaa904     nvarchar(1),             /*No Use                                 */
imaa905     nvarchar(1),             /*當月是否入聯產品                       */
imaa906     nvarchar(1),             /*單位使用方式                           */
imaa907     nvarchar(4),             /*第二單位(母單位/參考單位)              */
imaa908     nvarchar(4),             /*計價單位                               */
imaa909     smallint,                /*mrp匯總時距(天)(預留欄位)              */
imaa91      decimal(18),             /*No Use                                 */
imaa910     nvarchar(20),            /*主特性代碼                             */
imaa911     nvarchar(1),             /*是否為重覆性生產料件 (y/n)             */
imaa912     decimal(18),             /*標準機器工時                           */
imaa913     nvarchar(1),             /*統購否                                 */
imaa914     nvarchar(10),            /*採購中心代碼                           */
imaa915     nvarchar(1) DEFAULT '0', /*是否需做供應商的管制                   */
imaa918     nvarchar(1),             /*製造批號管理否                         */
imaa919     nvarchar(1),             /*製造批號自動編碼否                     */
imaa92      nvarchar(1),             /*是否簽核                               */
imaa920     nvarchar(10),            /*製造批號編碼原則                       */
imaa921     nvarchar(1),             /*序號管理否                             */
imaa922     nvarchar(1),             /*序號自動編碼否                         */
imaa923     nvarchar(10),            /*序號編碼原則                           */
imaa924     nvarchar(1),             /*序號唯一否                             */
imaa925     nvarchar(1),             /*排序方式                               */
imaa926     nvarchar(1) DEFAULT 'N' NOT NULL, /*AVL否*/
imaa93      nvarchar(8),             /*No Use                                 */
imaa94      nvarchar(10),            /*預設製程編號                           */
imaa95      decimal(18),             /*保稅單價                               */
imaa96      smallint,                /*No Use                                 */
imaa97      smallint,                /*No Use                                 */
imaa98      decimal(18),             /*No Use                                 */
imaa99      decimal(18),             /*再補貨量                               */
imaaacti    nvarchar(1),             /*資料有效碼                             */
imaaag      nvarchar(10),            /*屬性群組代碼                           */
imaaag1     nvarchar(10),            /*母料件屬性群組代碼                     */
imaadate    datetime,                /*最近修改日                             */
imaagrup    nvarchar(10),            /*資料所有群                             */
imaamodu    nvarchar(10),            /*資料更改者                             */
imaano      nvarchar(80) NOT NULL,   /*申請單號                               */
imaaorig    nvarchar(10),            /*資料建立部門                           */
imaaoriu    nvarchar(10),            /*資料建立者                             */
imaaud01    nvarchar(255),           /*自訂欄位                               */
imaaud02    nvarchar(40),            /*自訂欄位                               */
imaaud03    nvarchar(40),            /*自訂欄位                               */
imaaud04    nvarchar(40),            /*自訂欄位                               */
imaaud05    nvarchar(40),            /*自訂欄位                               */
imaaud06    nvarchar(40),            /*自訂欄位                               */
imaaud07    decimal(18),             /*自訂欄位                               */
imaaud08    decimal(18),             /*自訂欄位                               */
imaaud09    decimal(18),             /*自訂欄位                               */
imaaud10    integer,                 /*自訂欄位                               */
imaaud11    integer,                 /*自訂欄位                               */
imaaud12    integer,                 /*自訂欄位                               */
imaaud13    datetime,                /*自訂欄位                               */
imaaud14    datetime,                /*自訂欄位                               */
imaaud15    datetime,                /*自訂欄位                               */
imaauser    nvarchar(10)             /*資料所有者                             */
);

alter table imaa_file add constraint imaa_pk primary key  (imaano) deferrable initially deferred;
grant select on imaa_file to tiptopgp;
grant update on imaa_file to tiptopgp;
grant delete on imaa_file to tiptopgp;
grant insert on imaa_file to tiptopgp;
grant references on imaa_file to tiptopgp;
grant references on imaa_file to ods;
grant select on imaa_file to ods;
