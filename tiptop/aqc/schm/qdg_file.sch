/*
================================================================================
檔案代號:qdg_file
檔案名稱:1916檢驗水准抽樣計划資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table qdg_file
(
qdg01       nvarchar(1) DEFAULT '1' NOT NULL, /*檢驗水准*/
qdg02       nvarchar(1) DEFAULT '1' NOT NULL, /*級數*/
qdg03       nvarchar(1) DEFAULT '1' NOT NULL, /*樣本字號*/
qdg04       smallint,                /*抽樣數                                 */
qdg05       decimal(8,4),            /*K法標准值                              */
qdg06       decimal(8,4)             /*F法標准值                              */
);

alter table qdg_file add constraint qdg_pk primary key  (qdg01,qdg02,qdg03);
grant select on qdg_file to tiptopgp;
grant update on qdg_file to tiptopgp;
grant delete on qdg_file to tiptopgp;
grant insert on qdg_file to tiptopgp;
grant references on qdg_file to tiptopgp;
grant references on qdg_file to ods;
grant select on qdg_file to ods;
