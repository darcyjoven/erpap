/*
================================================================================
檔案代號:oar_file
檔案名稱:多角貿易營運中心編號發票/稅別設定
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oar_file
(
oar01       nvarchar(2) NOT NULL,    /*流程代碼                               */
oar02       nvarchar(10) NOT NULL,   /*營運中心編號                           */
oar03       nvarchar(5),             /*發票別                                 */
oar04       nvarchar(4)              /*發票稅別                               */
);

alter table oar_file add constraint oar_pk primary key  (oar01,oar02);
grant select on oar_file to tiptopgp;
grant update on oar_file to tiptopgp;
grant delete on oar_file to tiptopgp;
grant insert on oar_file to tiptopgp;
grant references on oar_file to tiptopgp;
grant references on oar_file to ods;
grant select on oar_file to ods;
