/*
================================================================================
檔案代號:edg_file
檔案名稱:PBI製程檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edg_file
(
edg01       nvarchar(20) DEFAULT ' ' NOT NULL, /*PBI單號*/
edg02       smallint DEFAULT 0 NOT NULL, /*PBI項次*/
edg03       smallint DEFAULT 0 NOT NULL, /*製程序*/
edg031      nvarchar(40),            /*料件編號                               */
edg04       nvarchar(6),             /*作業編號                               */
edg05       nvarchar(10),            /*機器編號                               */
edg06       nvarchar(10),            /*工作站編號                             */
edg07       decimal(15,3) DEFAULT '0' NOT NULL, /*最早起始前置時間調整*/
edg08       decimal(15,3) DEFAULT '0' NOT NULL, /*最遲起始前置時間調整*/
edg09       decimal(15,3) DEFAULT '0' NOT NULL, /*最早完工前置時間調整*/
edg10       decimal(15,3) DEFAULT '0' NOT NULL, /*最遲完工前置時間調整*/
edg11       nvarchar(10),            /*製程編號                               */
edg12       decimal(9,4),            /*固定損耗量                             */
edg121      nvarchar(1) DEFAULT ' ' NOT NULL, /*盤點作業*/
edg13       decimal(15,3) DEFAULT '0' NOT NULL, /*標準人工設置時間*/
edg14       decimal(15,3) DEFAULT '0' NOT NULL, /*標準人工生產時間*/
edg15       decimal(15,3) DEFAULT '0' NOT NULL, /*標準機器設置時間*/
edg16       decimal(15,3) DEFAULT '0' NOT NULL, /*標準機器生產時間*/
edg17       decimal(15,3) DEFAULT '0' NOT NULL, /*標準廠外加工時間*/
edg18       decimal(15,3) DEFAULT '0' NOT NULL, /*標準等待時間*/
edg19       decimal(15,3) DEFAULT '0' NOT NULL, /*標準等待時間*/
edg20       decimal(15,3) DEFAULT '0' NOT NULL, /*實際人工生產時間*/
edg21       decimal(15,3) DEFAULT '0' NOT NULL, /*實際人工生產時間*/
edg22       decimal(15,3) DEFAULT '0' NOT NULL, /*實際機器設置時間*/
edg23       decimal(15,3) DEFAULT '0' NOT NULL, /*實際機器生產時間*/
edg24       decimal(15,3) DEFAULT '0' NOT NULL, /*實際廠外加工時間*/
edg25       nvarchar(5),             /*開工時間                               */
edg26       nvarchar(5),             /*完工時間                               */
edg27       decimal(9,4),            /*No Use                                 */
edg28       decimal(9,4),            /*No Use                                 */
edg291      decimal(15,3) DEFAULT '0' NOT NULL, /*Check in Qty*/
edg292      decimal(15,3) DEFAULT '0' NOT NULL, /*盤點量*/
edg301      decimal(15,3) DEFAULT '0' NOT NULL, /*良品轉入量       (+)*/
edg302      decimal(15,3) DEFAULT '0' NOT NULL, /*重工轉入量       (+)*/
edg303      decimal(15,3) DEFAULT '0' NOT NULL, /*工單轉入量       (+)*/
edg311      decimal(15,3) DEFAULT '0' NOT NULL, /*良品轉出量       (-)*/
edg312      decimal(15,3) DEFAULT '0' NOT NULL, /*重工轉出         (-)*/
edg313      decimal(15,3) DEFAULT '0' NOT NULL, /*當站報廢量       (-)*/
edg314      decimal(15,3) DEFAULT '0' NOT NULL, /*當站下線量(入庫) (-)*/
edg315      decimal(15,3) DEFAULT '0' NOT NULL, /*Bonus Qty        (-)*/
edg316      decimal(15,3) DEFAULT '0' NOT NULL, /*工單轉出量       (-)*/
edg321      decimal(15,3) DEFAULT '0' NOT NULL, /*委外加工量*/
edg322      decimal(15,3) DEFAULT '0' NOT NULL, /*委外完工量*/
edg34       decimal(15,3) DEFAULT '0' NOT NULL, /*變動損耗率*/
edg35       decimal(9,4),            /*C/R 比率                               */
edg36       decimal(9,4),            /*報廢平均人工分攤比率                   */
edg37       decimal(15,3) DEFAULT '0' NOT NULL, /*排程人工設置時間*/
edg38       decimal(15,3) DEFAULT '0' NOT NULL, /*排程人工生產時間*/
edg39       decimal(15,3) DEFAULT '0' NOT NULL, /*排程廠外加工時間*/
edg40       decimal(15,3) DEFAULT '0' NOT NULL, /*人工數目*/
edg41       smallint,                /*機器數目                               */
edg42       decimal(9,4),            /*作業重疊程度                           */
edg43       nvarchar(1) DEFAULT ' ' NOT NULL, /*成本計算基準*/
edg45       nvarchar(80),            /*作業名稱                               */
edg49       decimal(15,3) NOT NULL,  /*單位人力                               */
edg50       datetime,                /*製程開工日                             */
edg51       datetime,                /*製程完工日                             */
edg52       nvarchar(1) DEFAULT ' ' NOT NULL, /*委外否*/
edg53       nvarchar(1) DEFAULT ' ' NOT NULL, /*PQC 否*/
edg54       nvarchar(1) DEFAULT ' ' NOT NULL, /*Check in 否*/
edg55       nvarchar(10),            /*Check in 留置碼                        */
edg56       nvarchar(10),            /*Check out 留置碼                       */
edg57       nvarchar(4),             /*no use                                 */
edg58       nvarchar(4),             /*單位                                   */
edg59       decimal(20,8),           /*no use                                 */
edg60       smallint,                /*單元變更序號                           */
edg61       nvarchar(1) NOT NULL,    /*平行加工否                             */
edg62       decimal(16,8),           /*組成用量                               */
edg63       decimal(16,8),           /*底數                                   */
edg64       decimal(9,4),            /*損耗批量                               */
edg65       decimal(15,3) DEFAULT '0' NOT NULL, /*標準產出量*/
edg66       nvarchar(1) DEFAULT ' ' NOT NULL, /*報工點否*/
edg67       nvarchar(10),            /*委外廠商                               */
edgacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
edgconf     nvarchar(1) DEFAULT ' ' NOT NULL, /*確認否*/
edgdate     datetime,                /*最近修改日                             */
edggrup     nvarchar(10),            /*資料所有群                             */
edgmodu     nvarchar(10),            /*資料更改者                             */
edgorig     nvarchar(10),            /*資料建立部門                           */
edgoriu     nvarchar(10),            /*資料建立者                             */
edgslk01    nvarchar(1) DEFAULT ' ' NOT NULL, /*裁片管理否*/
edgslk02    decimal(15,3) DEFAULT '0' NOT NULL, /*現實工時*/
edgslk03    decimal(15,3) DEFAULT '0' NOT NULL, /*標準工價*/
edgslk04    decimal(15,3) DEFAULT '0' NOT NULL, /*現實工價*/
edguser     nvarchar(10)             /*資料所有者                             */
);

alter table edg_file add constraint edg_pk primary key  (edg01,edg02,edg03) deferrable initially deferred;
grant select on edg_file to tiptopgp;
grant update on edg_file to tiptopgp;
grant delete on edg_file to tiptopgp;
grant insert on edg_file to tiptopgp;
grant references on edg_file to tiptopgp;
grant references on edg_file to ods;
grant select on edg_file to ods;
