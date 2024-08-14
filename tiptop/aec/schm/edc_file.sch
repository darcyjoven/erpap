/*
================================================================================
檔案代號:edc_file
檔案名稱:合拼版製程檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edc_file
(
edc01       nvarchar(20) DEFAULT ' ' NOT NULL, /*合拼版號*/
edc02       smallint DEFAULT 0 NOT NULL, /*合拼序*/
edc03       smallint DEFAULT 0 NOT NULL, /*製程序*/
edc031      nvarchar(40),            /*料件編號                               */
edc04       nvarchar(6),             /*作業編號                               */
edc05       nvarchar(10),            /*機器編號                               */
edc06       nvarchar(10),            /*工作站編號                             */
edc07       decimal(15,3) DEFAULT '0' NOT NULL, /*最早起始前置時間調整	*/
edc08       decimal(15,3) DEFAULT '0' NOT NULL, /*最遲起始前置時間調整	*/
edc09       decimal(15,3) DEFAULT '0' NOT NULL, /*最早完工前置時間調整	*/
edc10       decimal(15,3) DEFAULT '0' NOT NULL, /*最遲完工前置時間調整	*/
edc11       nvarchar(10),            /*製程編號            	                    */
edc12       decimal(9,4),            /*固定損耗率                             */
edc121      nvarchar(1) DEFAULT ' ' NOT NULL, /*盤點作業            	*/
edc13       decimal(15,3),           /*標準人工設置時間                       */
edc14       decimal(15,3),           /*標準人工生產時間                       */
edc15       decimal(15,3),           /*標準機器設置時間                       */
edc16       decimal(15,3),           /*標準機器生產時間                       */
edc17       decimal(15,3) DEFAULT '0' NOT NULL, /*標準廠外加工時間    	*/
edc18       decimal(15,3) DEFAULT '0' NOT NULL, /*標準等待時間        	*/
edc19       decimal(15,3) DEFAULT '0' NOT NULL, /*標準等待時間        	*/
edc20       decimal(15,3) DEFAULT '0' NOT NULL, /*實際人工生產時間    	*/
edc21       decimal(15,3) DEFAULT '0' NOT NULL, /*實際人工生產時間    	*/
edc22       decimal(15,3) DEFAULT '0' NOT NULL, /*實際機器設置時間    	*/
edc23       decimal(15,3) DEFAULT '0' NOT NULL, /*實際機器生產時間    	*/
edc24       decimal(15,3) DEFAULT '0' NOT NULL, /*實際廠外加工時間    	*/
edc25       nvarchar(5),             /*開工時間            	                    */
edc26       nvarchar(5),             /*完工時間            	                    */
edc27       decimal(9,4),            /*No Use              	                    */
edc28       decimal(9,4),            /*No Use              	                    */
edc291      decimal(15,3) DEFAULT '0' NOT NULL, /*Check in Qty        	*/
edc292      decimal(15,3) DEFAULT '0' NOT NULL, /*盤點量              	*/
edc301      decimal(15,3) DEFAULT '0' NOT NULL, /*良品轉入量       (+)	*/
edc302      decimal(15,3) DEFAULT '0' NOT NULL, /*重工轉入量       (+)	*/
edc303      decimal(15,3) DEFAULT '0' NOT NULL, /*工單轉入量       (+)	*/
edc311      decimal(15,3) DEFAULT '0' NOT NULL, /*良品轉出量       (-)	*/
edc312      decimal(15,3) DEFAULT '0' NOT NULL, /*重工轉出         (-)	*/
edc313      decimal(15,3) DEFAULT '0' NOT NULL, /*當站報廢量       (-)	*/
edc314      decimal(15,3) DEFAULT '0' NOT NULL, /*當站下線量(入庫) (-)	*/
edc315      decimal(15,3) DEFAULT '0' NOT NULL, /*Check in Qty    (-)	*/
edc316      decimal(15,3) DEFAULT '0' NOT NULL, /*工單轉出量       (-)	*/
edc321      decimal(15,3) DEFAULT '0' NOT NULL, /*委外加工量          	*/
edc322      decimal(15,3) DEFAULT '0' NOT NULL, /*委外完工量          	*/
edc34       decimal(15,3),           /*變動損耗率                             */
edc35       decimal(9,4),            /*C/R 比率            	                    */
edc36       decimal(9,4),            /*報廢平均人工分攤比率	                    */
edc37       decimal(15,3) DEFAULT '0' NOT NULL, /*排程人工設置時間    	*/
edc38       decimal(15,3) DEFAULT '0' NOT NULL, /*排程人工生產時間    	*/
edc39       decimal(15,3) DEFAULT '0' NOT NULL, /*排程廠外加工時間    	*/
edc40       smallint,                /*人工數目            	                    */
edc41       smallint,                /*機器數目            	                    */
edc42       decimal(9,4),            /*作業重疊程度        	                    */
edc43       nvarchar(1) DEFAULT ' ' NOT NULL, /*成本計算基準        	*/
edc45       nvarchar(80),            /*作業名稱            	                    */
edc49       decimal(15,3),           /*單位人力                               */
edc50       datetime,                /*製程開工日          	                    */
edc51       datetime,                /*製程完工日          	                    */
edc52       nvarchar(1),             /*委外否                                 */
edc53       nvarchar(1),             /*PQC 否                                 */
edc54       nvarchar(1),             /*Check in 否                            */
edc55       nvarchar(10),            /*Check in 留置碼     	                    */
edc56       nvarchar(10),            /*Check out 留置碼    	                    */
edc57       nvarchar(4),             /*no use              	                    */
edc58       nvarchar(4),             /*單位                                   */
edc59       decimal(20,8),           /*單位轉換率                             */
edc60       smallint,                /*單元變更序號        	                    */
edc61       nvarchar(1) DEFAULT ' ' NOT NULL, /*平行加工否          	*/
edc62       decimal(16,8),           /*組成用量                               */
edc63       decimal(16,8),           /*底數                                   */
edc64       decimal(9,4),            /*損耗批量                               */
edc65       decimal(15,3),           /*標準產出量                             */
edc66       nvarchar(1) DEFAULT ' ' NOT NULL, /*報工點否*/
edc67       nvarchar(10),            /*委外廠商                               */
edcacti     nvarchar(1),             /*資料有效碼                             */
edcconf     nvarchar(1),             /*資料確認碼                             */
edcdate     datetime,                /*最近修改日                             */
edcgrup     nvarchar(10),            /*資料所有群                             */
edcmodu     nvarchar(10),            /*資料更改者                             */
edcorig     nvarchar(10),            /*資料建立部門                           */
edcoriu     nvarchar(10),            /*資料建立者                             */
edcslk01    nvarchar(1) DEFAULT ' ' NOT NULL, /*裁片管理否          	*/
edcslk02    decimal(15,3) DEFAULT '0' NOT NULL, /*現實工時            	*/
edcslk03    decimal(15,3) DEFAULT '0' NOT NULL, /*標準工價            	*/
edcslk04    decimal(15,3) DEFAULT '0' NOT NULL, /*現實工價            	*/
edcuser     nvarchar(10)             /*資料所有者                             */
);

alter table edc_file add constraint edc_pk primary key  (edc01,edc02,edc03) deferrable initially deferred;
grant select on edc_file to tiptopgp;
grant update on edc_file to tiptopgp;
grant delete on edc_file to tiptopgp;
grant insert on edc_file to tiptopgp;
grant references on edc_file to tiptopgp;
grant references on edc_file to ods;
grant select on edc_file to ods;
