/*
================================================================================
檔案代號:mea_file
檔案名稱:BOM 替代料資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mea_file
(
mea01       smallint NOT NULL,       /*流用代號                               */
mea02       nvarchar(40) NOT NULL,   /*料件編號                               */
mea03       datetime,                /*生效日期範圍                           */
mea04       datetime,                /*失效日期範圍                           */
mea05       nvarchar(30),            /*核准文號範圍                           */
mea06       datetime                 /*核准日期範圍                           */
);

create unique index mea_02 on mea_file (mea02);
alter table mea_file add constraint mea_pk primary key  (mea01,mea02);
grant select on mea_file to tiptopgp;
grant update on mea_file to tiptopgp;
grant delete on mea_file to tiptopgp;
grant insert on mea_file to tiptopgp;
grant references on mea_file to tiptopgp;
grant references on mea_file to ods;
grant select on mea_file to ods;
