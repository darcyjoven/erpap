/*
================================================================================
檔案代號:luf_file
檔案名稱:正式商戶品牌資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table luf_file
(
luf00       nvarchar(10),            /*來源門店編號                           */
luf01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
luf02       nvarchar(20) DEFAULT ' ' NOT NULL, /*版本號*/
luf03       nvarchar(10) DEFAULT ' ' NOT NULL, /*品牌號*/
luf04       nvarchar(10)             /*產地編號                               */
);

alter table luf_file add constraint luf_pk primary key  (luf01,luf02,luf03) deferrable initially deferred;
grant select on luf_file to tiptopgp;
grant update on luf_file to tiptopgp;
grant delete on luf_file to tiptopgp;
grant insert on luf_file to tiptopgp;
grant references on luf_file to tiptopgp;
grant references on luf_file to ods;
grant select on luf_file to ods;
