/*
================================================================================
檔案代號:wpd_file
檔案名稱:电子采购报价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpd_file
(
wpd01       nvarchar(15) DEFAULT ' ' NOT NULL, /*電子採購序號*/
wpd02       datetime,                /*報價日期                               */
wpd03       nvarchar(10) DEFAULT ' ' NOT NULL, /*廠商編號*/
wpd04       datetime,                /*需求日期                               */
wpd05       nvarchar(40),            /*料件編號                               */
wpd06       nvarchar(120),           /*品名規格                               */
wpd07       nvarchar(4),             /*需求單位                               */
wpd08       decimal(18) DEFAULT '0' NOT NULL, /*需求數量*/
wpd09       decimal(18) DEFAULT '0' NOT NULL, /*報價單價*/
wpd10       nvarchar(1) DEFAULT ' ', /*已拋轉單據                             */
wpd11       nvarchar(1) DEFAULT 'N' NOT NULL, /*比價結束*/
wpd12       datetime,                /*報價有效日                             */
wpd13       nvarchar(1) DEFAULT 'N' NOT NULL, /*分量計價*/
wpd14       nvarchar(10)             /*來源工廠                               */
);

alter table wpd_file add constraint wpd_pk primary key  (wpd01,wpd03) deferrable initially deferred;
grant select on wpd_file to tiptopgp;
grant update on wpd_file to tiptopgp;
grant delete on wpd_file to tiptopgp;
grant insert on wpd_file to tiptopgp;
grant references on wpd_file to tiptopgp;
grant references on wpd_file to ods;
grant select on wpd_file to ods;
