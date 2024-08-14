/*
================================================================================
檔案代號:edd_file
檔案名稱:合拼版製程料件檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edd_file
(
edd01       nvarchar(20) DEFAULT ' ' NOT NULL, /*合拼版號*/
edd011      smallint DEFAULT 0 NOT NULL, /*合拼序*/
edd013      smallint DEFAULT 0 NOT NULL, /*製程序*/
edd02       smallint DEFAULT 0 NOT NULL, /*組合項次*/
edd03       nvarchar(40) DEFAULT ' ' NOT NULL, /*元件料件編號*/
edd04       datetime NOT NULL,       /*生效日期                               */
edd05       datetime,                /*失效日期                               */
edd06       decimal(16,8),           /*組成用量                               */
edd07       decimal(16,8),           /*底數                                   */
edd08       decimal(9,4),            /*損耗率                                 */
edd081      decimal(15,3),           /*固定損耗量                             */
edd082      decimal(9,4),            /*損耗批量                               */
edd09       nvarchar(6),             /*作業編號                               */
edd10       nvarchar(4),             /*發料單位                               */
edd10_fac   decimal(20,8),           /*發料對料件庫存單位換算率               */
edd10_fac2  decimal(20,8),           /*發料對料件成本單位換算率               */
edd11       nvarchar(20),            /*工程圖號                               */
edd13       nvarchar(10),            /*元件插件位置                           */
edd14       nvarchar(1),             /*元件使用特性                           */
edd15       nvarchar(1),             /*元件消耗特性                           */
edd16       nvarchar(1),             /*取/替代特性                            */
edd17       nvarchar(1),             /*特性旗標                               */
edd18       smallint,                /*元件投料時距                           */
edd19       nvarchar(1),             /*工單開立展開選項                       */
edd20       smallint,                /*No Use                                 */
edd21       nvarchar(1),             /*No Use                                 */
edd22       nvarchar(1),             /*No Use                                 */
edd23       decimal(9,4),            /*選中率                                 */
edd24       nvarchar(20),            /*工程變異單單號                         */
edd25       nvarchar(10),            /*倉庫別                                 */
edd26       nvarchar(10),            /*存放位置                               */
edd27       nvarchar(1),             /*元件是否軟體物件                       */
edd28       decimal(9,4),            /*發料誤差允許率                         */
edd29       nvarchar(20) DEFAULT ' ' NOT NULL, /*特性代碼*/
edd30       nvarchar(1),             /*計算方式                               */
edd31       nvarchar(1),             /*代買料否                               */
edd33       integer,                 /*款式BOM對應項次                        */
eddcomm     nvarchar(10),            /*修改指令來源                           */
edddate     datetime,                /*單身最近一次修改日期                   */
eddmodu     nvarchar(10)             /*資料更改者                             */
);

alter table edd_file add constraint edd_pk primary key  (edd01,edd011,edd013,edd02,edd03,edd04);
grant select on edd_file to tiptopgp;
grant update on edd_file to tiptopgp;
grant delete on edd_file to tiptopgp;
grant insert on edd_file to tiptopgp;
grant references on edd_file to tiptopgp;
grant references on edd_file to ods;
grant select on edd_file to ods;
