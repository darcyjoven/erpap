/*
================================================================================
檔案代號:luh_file
檔案名稱:正式商戶狀態信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table luh_file
(
luh00       nvarchar(10),            /*來源門店編號                           */
luh01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
luh02       nvarchar(20) DEFAULT ' ' NOT NULL, /*版本號*/
luh03       nvarchar(10),            /*no use 原門店編號                      */
luh04       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶初始狀態*/
luh05       nvarchar(1) DEFAULT ' ' NOT NULL, /*希望變更狀態*/
luh06       nvarchar(1) DEFAULT ' ' NOT NULL, /*審核結果*/
luh07       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶狀態*/
luhlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
luhplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

create        index luhplant_idx on luh_file (luhplant);
alter table luh_file add constraint luh_pk primary key  (luh01,luh02,luhplant) deferrable initially deferred;
grant select on luh_file to tiptopgp;
grant update on luh_file to tiptopgp;
grant delete on luh_file to tiptopgp;
grant insert on luh_file to tiptopgp;
grant references on luh_file to tiptopgp;
grant references on luh_file to ods;
grant select on luh_file to ods;
