/*
================================================================================
檔案代號:lng_file
檔案名稱:正式商戶經營信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lng_file
(
lng00       nvarchar(10),            /*來源門店編號                           */
lng01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lng02       nvarchar(20),            /*版本號                                 */
lng03       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件名稱*/
lng04       nvarchar(20) DEFAULT ' ' NOT NULL, /*證件號碼*/
lng05       nvarchar(20),            /*經營人                                 */
lng06       datetime,                /*有效期起日                             */
lng07       datetime                 /*有效期止日                             */
);

alter table lng_file add constraint lng_pk primary key  (lng01,lng03,lng04) deferrable initially deferred;
grant select on lng_file to tiptopgp;
grant update on lng_file to tiptopgp;
grant delete on lng_file to tiptopgp;
grant insert on lng_file to tiptopgp;
grant references on lng_file to tiptopgp;
grant references on lng_file to ods;
grant select on lng_file to ods;
