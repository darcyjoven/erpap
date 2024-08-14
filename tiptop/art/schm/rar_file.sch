/*
================================================================================
檔案代號:rar_file
檔案名稱:換贈第一單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rar_file
(
rar01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rar02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rar03       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷類型2.組合促銷3.滿額促銷*/
rar04       smallint DEFAULT 0 NOT NULL, /*項次*/
rar05       smallint DEFAULT 0 NOT NULL, /*組別*/
rar06       decimal(15,3) DEFAULT '0' NOT NULL, /*數量*/
rar07       decimal(20,6) DEFAULT '0' NOT NULL, /*加價金額*/
rar08       decimal(20,6) DEFAULT '0' NOT NULL, /*會員加價金額*/
raracti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
rarlegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
rarplant    nvarchar(10) DEFAULT ' ' NOT NULL /*營運中心*/
);

alter table rar_file add constraint rar_pk primary key  (rar01,rar02,rar03,rar04,rar05,rarplant);
grant select on rar_file to tiptopgp;
grant update on rar_file to tiptopgp;
grant delete on rar_file to tiptopgp;
grant insert on rar_file to tiptopgp;
grant references on rar_file to tiptopgp;
grant references on rar_file to ods;
grant select on rar_file to ods;
