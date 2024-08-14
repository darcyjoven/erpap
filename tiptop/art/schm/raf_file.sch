/*
================================================================================
檔案代號:raf_file
檔案名稱:組合促銷第一單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table raf_file
(
raf01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
raf02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
raf03       smallint DEFAULT 0 NOT NULL, /*組別*/
raf04       nvarchar(1) DEFAULT ' ' NOT NULL, /*參與方式1.必選2.可選*/
raf05       smallint DEFAULT 0,      /*數量                                   */
rafacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
raflegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
rafplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

alter table raf_file add constraint raf_pk primary key  (raf01,raf02,raf03,rafplant);
grant select on raf_file to tiptopgp;
grant update on raf_file to tiptopgp;
grant delete on raf_file to tiptopgp;
grant insert on raf_file to tiptopgp;
grant references on raf_file to tiptopgp;
grant references on raf_file to ods;
grant select on raf_file to ods;
