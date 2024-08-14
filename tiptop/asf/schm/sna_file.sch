/*
================================================================================
檔案代號:sna_file
檔案名稱:工單變更單單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sna_file
(
sna01       nvarchar(20) NOT NULL,   /*工單單號                               */
sna012a     nvarchar(10),            /*變更後製程段號                         */
sna012b     nvarchar(10),            /*變更前製程段號                         */
sna013a     smallint,                /*變更后製程序                           */
sna013b     smallint,                /*變更前製程序                           */
sna02       smallint NOT NULL,       /*變更序號                               */
sna022      datetime,                /*變更日期                               */
sna03a      nvarchar(40),            /*變更後料件編號                         */
sna03b      nvarchar(40),            /*變更前料件編號                         */
sna04       smallint NOT NULL,       /*項次                                   */
sna05a      decimal(18),             /*變更後應發數量                         */
sna05b      decimal(18),             /*變更前應發數量                         */
sna062a     decimal(18),             /*變更後超領數量                         */
sna062b     decimal(18),             /*變更前超領數量                         */
sna065a     decimal(18),             /*變更後委外代買數量                     */
sna065b     decimal(18),             /*變更前委外代買數量                     */
sna06a      decimal(18),             /*變更後已發數量                         */
sna06b      decimal(18),             /*變更前已發數量                         */
sna07a      decimal(18),             /*變更後欠料數量                         */
sna07b      decimal(18),             /*變更前欠料數量                         */
sna08a      nvarchar(6),             /*變更後作業編號                         */
sna08b      nvarchar(6),             /*變更前作業編號                         */
sna10       nvarchar(1),             /*單身變異別                             */
                                     /*單身變異別(1/2/3/4)                    */
                                     /*當單頭變更類型(snb04)='2',此欄位才可維護*/
                                     /*變更類型(snb04)='2'單頭變更,此欄位值為 */
                                     /*1.新憎 2.修改 3.取替代                 */
                                     /*變更類型(snb04)='1'單身變更,此欄位值為 */
                                     /*4.單頭變更,影響單身變更                */
sna100a     decimal(18),             /*變更後發料誤差容許率                   */
sna100b     decimal(18),             /*變更前發料誤差容許率                   */
sna11a      nvarchar(1),             /*變更後旗標                             */
sna11b      nvarchar(1),             /*變更前旗標                             */
sna12a      nvarchar(4),             /*變更後發料單位                         */
sna12b      nvarchar(4),             /*變更前發料單位                         */
sna13a      decimal(18),             /*變更後料單位/庫存單位換算率            */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sna13b      decimal(18),             /*變更發料單位/庫存單位換算率            */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sna161a     decimal(18),             /*變更後實際單位用量                     */
sna161b     decimal(18),             /*變更前實際單位用量                     */
sna26a      nvarchar(1),             /*變更後替代碼                           */
sna26b      nvarchar(1),             /*變更前替代碼                           */
sna27a      nvarchar(40),            /*變更後替代料號                         */
sna27b      nvarchar(40),            /*變更前替代料號                         */
sna28a      decimal(15,6),           /*變更後替代率                           */
sna28b      decimal(15,6),           /*變更前替代率                           */
sna30a      nvarchar(10),            /*變更後指定倉庫                         */
sna30b      nvarchar(10),            /*變更前指定倉庫                         */
sna31a      nvarchar(10),            /*變更後指定儲位                         */
sna31b      nvarchar(10),            /*變更前指定儲位                         */
sna50       nvarchar(255),           /*備註                                   */
snalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
snaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
snaud01     nvarchar(255),           /*自訂欄位-Textedit                      */
snaud02     nvarchar(40),            /*自訂欄位-文字                          */
snaud03     nvarchar(40),            /*自訂欄位-文字                          */
snaud04     nvarchar(40),            /*自訂欄位-文字                          */
snaud05     nvarchar(40),            /*自訂欄位-文字                          */
snaud06     nvarchar(40),            /*自訂欄位-文字                          */
snaud07     decimal(18),             /*自訂欄位-數值                          */
snaud08     decimal(18),             /*自訂欄位-數值                          */
snaud09     decimal(18),             /*自訂欄位-數值                          */
snaud10     integer,                 /*自訂欄位-整數                          */
snaud11     integer,                 /*自訂欄位-整數                          */
snaud12     integer,                 /*自訂欄位-整數                          */
snaud13     datetime,                /*自訂欄位-日期                          */
snaud14     datetime,                /*自訂欄位-日期                          */
snaud15     datetime                 /*自訂欄位-日期                          */
);

create        index snaplant_idx on sna_file (snaplant);
alter table sna_file add constraint sna_pk primary key  (sna01,sna02,sna04);
grant select on sna_file to tiptopgp;
grant update on sna_file to tiptopgp;
grant delete on sna_file to tiptopgp;
grant insert on sna_file to tiptopgp;
grant references on sna_file to tiptopgp;
grant references on sna_file to ods;
grant select on sna_file to ods;
