/*
================================================================================
檔案代號:ede_file
檔案名稱:報工時單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ede_file
(
ede01       nvarchar(20) DEFAULT ' ' NOT NULL, /*報工時單號*/
ede02       datetime,                /*單據日期                               */
edeacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
edeconf     nvarchar(1) DEFAULT ' ' NOT NULL, /*確認否*/
ededate     datetime,                /*最近修改日                             */
edegrup     nvarchar(10),            /*資料所有群                             */
edelegal    nvarchar(10),            /*所屬法人                               */
edemodu     nvarchar(10),            /*資料更改者                             */
edeorig     nvarchar(10),            /*資料建立部門                           */
edeoriu     nvarchar(10),            /*資料建立者                             */
edeplant    nvarchar(10),            /*所屬工廠                               */
edeuser     nvarchar(10)             /*資料所有者                             */
);

alter table ede_file add constraint ede_pk primary key  (ede01);
grant select on ede_file to tiptopgp;
grant update on ede_file to tiptopgp;
grant delete on ede_file to tiptopgp;
grant insert on ede_file to tiptopgp;
grant references on ede_file to tiptopgp;
grant references on ede_file to ods;
grant select on ede_file to ods;
