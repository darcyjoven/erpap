/*
================================================================================
檔案代號:lnc_file
檔案名稱:潜在商户品牌资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnc_file
(
lnc00       nvarchar(10),            /*來源門店編號                           */
lnc01       nvarchar(10) DEFAULT ' ' NOT NULL, /*潛在商戶單號*/
lnc02       nvarchar(20) DEFAULT ' ' NOT NULL, /*品牌編號*/
lnc03       nvarchar(10)             /*產地編號                               */
);

alter table lnc_file add constraint lnc_pk primary key  (lnc01,lnc02) deferrable initially deferred;
grant select on lnc_file to tiptopgp;
grant update on lnc_file to tiptopgp;
grant delete on lnc_file to tiptopgp;
grant insert on lnc_file to tiptopgp;
grant references on lnc_file to tiptopgp;
grant references on lnc_file to ods;
grant select on lnc_file to ods;
