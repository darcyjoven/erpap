/*
================================================================================
檔案代號:lnh_file
檔案名稱:正式商戶狀態信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnh_file
(
lnh00       nvarchar(10),            /*來源門店編號                           */
lnh01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lnh02       nvarchar(20),            /*版本號                                 */
lnh03       nvarchar(10),            /*no use                                 */
lnh04       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶初始狀態*/
lnh05       nvarchar(1) DEFAULT ' ' NOT NULL, /*希望變更狀態*/
lnh06       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認結果*/
lnh07       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶狀態*/
lnhlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lnhstore    nvarchar(10) DEFAULT ' ' NOT NULL /*門店編號*/
);

alter table lnh_file add constraint lnh_pk primary key  (lnh01,lnhstore) deferrable initially deferred;
grant select on lnh_file to tiptopgp;
grant update on lnh_file to tiptopgp;
grant delete on lnh_file to tiptopgp;
grant insert on lnh_file to tiptopgp;
grant references on lnh_file to tiptopgp;
grant references on lnh_file to ods;
grant select on lnh_file to ods;
