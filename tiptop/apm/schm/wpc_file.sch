/*
================================================================================
檔案代號:wpc_file
檔案名稱:电子采购需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpc_file
(
wpc01       nvarchar(15) DEFAULT ' ' NOT NULL, /*電子採購序號*/
wpc02       nvarchar(1) DEFAULT 'N' NOT NULL, /*需求來源(1.請購單,2.預測需求)*/
wpc03       nvarchar(10) DEFAULT ' ' NOT NULL, /*廠商編號*/
wpc04       datetime,                /*需求日期                               */
wpc05       nvarchar(40),            /*料件編號                               */
wpc06       nvarchar(120),           /*品名規格                               */
wpc07       nvarchar(4),             /*需求單位                               */
wpc08       decimal(18) DEFAULT '0' NOT NULL, /*需求數量*/
wpc09       nvarchar(1) DEFAULT 'N' NOT NULL, /*公告結束否*/
wpc10       datetime,                /*報價截止日                             */
wpc11       nvarchar(10)             /*來源工廠                               */
);

alter table wpc_file add constraint wpc_pk primary key  (wpc01,wpc03) deferrable initially deferred;
grant select on wpc_file to tiptopgp;
grant update on wpc_file to tiptopgp;
grant delete on wpc_file to tiptopgp;
grant insert on wpc_file to tiptopgp;
grant references on wpc_file to tiptopgp;
grant references on wpc_file to ods;
grant select on wpc_file to ods;
