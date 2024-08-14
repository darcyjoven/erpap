/*
================================================================================
檔案代號:edh_file
檔案名稱:PBI製程料件檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edh_file
(
edh01       nvarchar(20) DEFAULT ' ' NOT NULL, /*PBI單號*/
edh011      smallint DEFAULT 0 NOT NULL, /*PBI項次*/
edh013      smallint DEFAULT 0 NOT NULL, /*製程序*/
edh02       smallint DEFAULT 0 NOT NULL, /*組合項次*/
edh03       nvarchar(40) DEFAULT ' ' NOT NULL, /*元件料件編號*/
edh04       datetime NOT NULL,       /*生效日期                               */
edh05       datetime,                /*失效日期                               */
edh06       decimal(16,8),           /*組成用量                               */
edh07       decimal(16,8),           /*底數                                   */
edh08       decimal(9,4),            /*損耗率                                 */
edh081      decimal(15,3) DEFAULT '0' NOT NULL, /*固定損耗量*/
edh082      decimal(9,4),            /*損耗批量                               */
edh09       nvarchar(6),             /*作業編號                               */
edh10       nvarchar(4),             /*發料單位                               */
edh10_fac   decimal(20,8),           /*發料對料件庫存單位換算率               */
edh10_fac2  decimal(20,8),           /*發料對料件成本單位換算率               */
edh11       nvarchar(20),            /*工程圖號                               */
edh13       nvarchar(10),            /*元件插件位置                           */
edh14       nvarchar(1) DEFAULT ' ' NOT NULL, /*元件使用特性*/
edh15       nvarchar(1) DEFAULT ' ' NOT NULL, /*元件消耗特性*/
edh16       nvarchar(1) DEFAULT ' ' NOT NULL, /*取/替代特性*/
edh17       nvarchar(1) DEFAULT ' ' NOT NULL, /*特性旗標*/
edh18       smallint,                /*元件投料時距                           */
edh19       nvarchar(1) DEFAULT ' ' NOT NULL, /*工單開立展開選項*/
edh20       smallint,                /*No Use                                 */
edh21       nvarchar(1),             /*No Use                                 */
edh22       nvarchar(1),             /*No Use                                 */
edh23       decimal(9,4),            /*選中率                                 */
edh24       nvarchar(20),            /*工程變異單單號                         */
edh25       nvarchar(10),            /*倉庫別                                 */
edh26       nvarchar(10),            /*存放位置                               */
edh27       nvarchar(1) DEFAULT ' ' NOT NULL, /*元件是否軟體物件*/
edh28       decimal(9,4),            /*發料誤差允許率                         */
edh29       nvarchar(20),            /*特性代碼                               */
edh30       nvarchar(1) DEFAULT ' ' NOT NULL, /*計算方式*/
edh31       nvarchar(1) DEFAULT ' ' NOT NULL, /*代買料否*/
edh33       integer,                 /*款式BOM對應項次                        */
edhcomm     nvarchar(10),            /*更改指令來源                           */
edhdate     datetime,                /*最近修改日                             */
edhmodu     nvarchar(10)             /*資料更改者                             */
);

alter table edh_file add constraint edh_pk primary key  (edh01,edh011,edh013,edh02,edh03,edh04);
grant select on edh_file to tiptopgp;
grant update on edh_file to tiptopgp;
grant delete on edh_file to tiptopgp;
grant insert on edh_file to tiptopgp;
grant references on edh_file to tiptopgp;
grant references on edh_file to ods;
grant select on edh_file to ods;
