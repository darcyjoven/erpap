/*
================================================================================
檔案代號:lsm_file
檔案名稱:積分異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsm_file
(
lsm01       nvarchar(30) DEFAULT ' ' NOT NULL, /*卡號*/
lsm02       nvarchar(1) DEFAULT ' ' NOT NULL, /*單據類型*/
lsm03       nvarchar(20) DEFAULT ' ' NOT NULL, /*交易單號*/
lsm04       decimal(20) DEFAULT '0' NOT NULL, /*本次異動積分*/
lsm05       datetime,                /*異動日期                               */
lsm06       datetime,                /*積分有效期                             */
lsm07       nvarchar(10) DEFAULT ' ' NOT NULL /*交易門店*/
);

alter table lsm_file add constraint lsm_pk primary key  (lsm01,lsm02,lsm03);
grant select on lsm_file to tiptopgp;
grant update on lsm_file to tiptopgp;
grant delete on lsm_file to tiptopgp;
grant insert on lsm_file to tiptopgp;
grant references on lsm_file to tiptopgp;
grant references on lsm_file to ods;
grant select on lsm_file to ods;
