/*
================================================================================
檔案代號:lsn_file
檔案名稱:儲值卡金額異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsn_file
(
lsn01       nvarchar(30) DEFAULT ' ' NOT NULL, /*卡號*/
lsn02       nvarchar(1) DEFAULT ' ' NOT NULL, /*單據類型*/
lsn03       nvarchar(20) DEFAULT ' ' NOT NULL, /*交易單號*/
lsn04       decimal(20,2) DEFAULT '0' NOT NULL, /*本次異動金額*/
lsn05       datetime,                /*異動日期                               */
lsn06       datetime,                /*金額有效期                             */
lsn07       decimal(6,2) DEFAULT '0' NOT NULL, /*折扣率*/
lsn08       nvarchar(10) DEFAULT ' ' NOT NULL /*交易門店*/
);

alter table lsn_file add constraint lsn_pk primary key  (lsn01,lsn02,lsn03);
grant select on lsn_file to tiptopgp;
grant update on lsn_file to tiptopgp;
grant delete on lsn_file to tiptopgp;
grant insert on lsn_file to tiptopgp;
grant references on lsn_file to tiptopgp;
grant references on lsn_file to ods;
grant select on lsn_file to ods;
