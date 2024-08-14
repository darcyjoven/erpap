/*
================================================================================
檔案代號:lug_file
檔案名稱:正式商戶經營信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lug_file
(
lug00       nvarchar(10),            /*來源門店編號                           */
lug01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lug02       nvarchar(20) DEFAULT ' ' NOT NULL, /*版本號*/
lug03       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件名稱*/
lug04       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件號碼*/
lug05       nvarchar(20),            /*經營人                                 */
lug06       datetime,                /*有效期起日                             */
lug07       datetime                 /*有效期止日                             */
);

alter table lug_file add constraint lug_pk primary key  (lug01,lug02,lug03,lug04) deferrable initially deferred;
grant select on lug_file to tiptopgp;
grant update on lug_file to tiptopgp;
grant delete on lug_file to tiptopgp;
grant insert on lug_file to tiptopgp;
grant references on lug_file to tiptopgp;
grant references on lug_file to ods;
grant select on lug_file to ods;
