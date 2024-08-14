/*
================================================================================
檔案代號:lmw_file
檔案名稱:商戶密碼檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmw_file
(
lmw01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lmw02       nvarchar(10)             /*密碼                                   */
);

alter table lmw_file add constraint lmw_pk primary key  (lmw01) deferrable initially deferred;
grant select on lmw_file to tiptopgp;
grant update on lmw_file to tiptopgp;
grant delete on lmw_file to tiptopgp;
grant insert on lmw_file to tiptopgp;
grant references on lmw_file to tiptopgp;
grant references on lmw_file to ods;
grant select on lmw_file to ods;
