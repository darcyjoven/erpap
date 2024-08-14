/*
================================================================================
檔案代號:lmv_file
檔案名稱:商戶商品數據關聯檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmv_file
(
lmv01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lmv02       nvarchar(20) DEFAULT ' ' NOT NULL /*產品編號*/
);

alter table lmv_file add constraint lmv_pk primary key  (lmv01,lmv02) deferrable initially deferred;
grant select on lmv_file to tiptopgp;
grant update on lmv_file to tiptopgp;
grant delete on lmv_file to tiptopgp;
grant insert on lmv_file to tiptopgp;
grant references on lmv_file to tiptopgp;
grant references on lmv_file to ods;
grant select on lmv_file to ods;
