/*
================================================================================
檔案代號:qdf_file
檔案名稱:1916檢驗水准計數值樣本代碼資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table qdf_file
(
qdf01       nvarchar(1) DEFAULT '1' NOT NULL, /*級數*/
qdf02       nvarchar(1) DEFAULT '1' NOT NULL, /*樣本字號*/
qdf03       integer DEFAULT 0 NOT NULL, /*起始批量*/
qdf04       integer DEFAULT 0 NOT NULL /*截止批量*/
);

alter table qdf_file add constraint qdf_pk primary key  (qdf01,qdf02);
grant select on qdf_file to tiptopgp;
grant update on qdf_file to tiptopgp;
grant delete on qdf_file to tiptopgp;
grant insert on qdf_file to tiptopgp;
grant references on qdf_file to tiptopgp;
grant references on qdf_file to ods;
grant select on qdf_file to ods;
