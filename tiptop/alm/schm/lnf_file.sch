/*
================================================================================
檔案代號:lnf_file
檔案名稱:正式商戶品牌資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnf_file
(
lnf00       nvarchar(10),            /*來源門店編號                           */
lnf01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lnf02       nvarchar(20),            /*版本號                                 */
lnf03       nvarchar(20) DEFAULT ' ' NOT NULL, /*品牌編號*/
lnf04       nvarchar(10)             /*產地編號                               */
);

alter table lnf_file add constraint lnf_pk primary key  (lnf01,lnf03) deferrable initially deferred;
grant select on lnf_file to tiptopgp;
grant update on lnf_file to tiptopgp;
grant delete on lnf_file to tiptopgp;
grant insert on lnf_file to tiptopgp;
grant references on lnf_file to tiptopgp;
grant references on lnf_file to ods;
grant select on lnf_file to ods;
