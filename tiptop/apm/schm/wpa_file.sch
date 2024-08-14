/*
================================================================================
檔案代號:wpa_file
檔案名稱:厂商电子采购设定资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpa_file
(
wpa01       nvarchar(10) DEFAULT ' ' NOT NULL, /*廠商編號*/
wpa02       nvarchar(1) DEFAULT 'N' NOT NULL, /*是否為電子採購供應商*/
wpa03       nvarchar(10) DEFAULT ' ' NOT NULL, /*WEB使用者賬號*/
wpa05       nvarchar(5),             /*詢價單別                               */
wpa06       nvarchar(5),             /*核價單別                               */
wpa07       nvarchar(5),             /*採購單別                               */
wpa08       nvarchar(5)              /*收貨單別                               */
);

alter table wpa_file add constraint wpa_pk primary key  (wpa01,wpa03) deferrable initially deferred;
grant select on wpa_file to tiptopgp;
grant update on wpa_file to tiptopgp;
grant delete on wpa_file to tiptopgp;
grant insert on wpa_file to tiptopgp;
grant references on wpa_file to tiptopgp;
grant references on wpa_file to ods;
grant select on wpa_file to ods;
