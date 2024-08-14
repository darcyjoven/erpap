/*
================================================================================
檔案代號:bnd_file
檔案名稱:保稅產品結構資料單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bnd_file
(
bnd01       nvarchar(40) NOT NULL,   /*主件料號                               */
bnd02       datetime NOT NULL,       /*生效日期                               */
bnd03       datetime,                /*失效日期                               */
bnd04       nvarchar(30),            /*BOM編號                                */
bnd101      nvarchar(40),            /*NO USE                                 */
bnd102      nvarchar(1),             /*保稅BOM列印否(Y/N)                     */
bndud01     nvarchar(255),           /*自訂欄位-Textedit                      */
bndud02     nvarchar(40),            /*自訂欄位-文字                          */
bndud03     nvarchar(40),            /*自訂欄位-文字                          */
bndud04     nvarchar(40),            /*自訂欄位-文字                          */
bndud05     nvarchar(40),            /*自訂欄位-文字                          */
bndud06     nvarchar(40),            /*自訂欄位-文字                          */
bndud07     decimal(18),             /*自訂欄位-數值                          */
bndud08     decimal(18),             /*自訂欄位-數值                          */
bndud09     decimal(18),             /*自訂欄位-數值                          */
bndud10     integer,                 /*自訂欄位-整數                          */
bndud11     integer,                 /*自訂欄位-整數                          */
bndud12     integer,                 /*自訂欄位-整數                          */
bndud13     datetime,                /*自訂欄位-日期                          */
bndud14     datetime,                /*自訂欄位-日期                          */
bndud15     datetime                 /*自訂欄位-日期                          */
);

alter table bnd_file add constraint bnd_pk primary key  (bnd01,bnd02);
grant select on bnd_file to tiptopgp;
grant update on bnd_file to tiptopgp;
grant delete on bnd_file to tiptopgp;
grant insert on bnd_file to tiptopgp;
grant references on bnd_file to tiptopgp;
grant references on bnd_file to ods;
grant select on bnd_file to ods;
