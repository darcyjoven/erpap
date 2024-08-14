/*
================================================================================
檔案代號:lnd_file
檔案名稱:潜在商户经营信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnd_file
(
lnd00       nvarchar(10),            /*來源門店編號                           */
lnd01       nvarchar(10) DEFAULT ' ' NOT NULL, /*潛在商戶單號*/
lnd02       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件名稱*/
lnd03       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件號碼*/
lnd04       nvarchar(20),            /*經營人                                 */
lnd05       datetime,                /*有效期起日                             */
lnd06       datetime                 /*有效期止日                             */
);

alter table lnd_file add constraint lnd_pk primary key  (lnd01,lnd02,lnd03) deferrable initially deferred;
grant select on lnd_file to tiptopgp;
grant update on lnd_file to tiptopgp;
grant delete on lnd_file to tiptopgp;
grant insert on lnd_file to tiptopgp;
grant references on lnd_file to tiptopgp;
grant references on lnd_file to ods;
grant select on lnd_file to ods;
