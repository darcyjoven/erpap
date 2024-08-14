/*
================================================================================
檔案代號:edb_file
檔案名稱:合拼版資料單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edb_file
(
edb01       nvarchar(20) DEFAULT ' ' NOT NULL, /*課程代號*/
edb02       smallint DEFAULT 0 NOT NULL, /*課程名稱*/
edb03       nvarchar(40) DEFAULT ' ' NOT NULL, /*料件編號*/
edb04       nvarchar(10),            /*製程編號                               */
edb05       integer,                 /*模數                                   */
edb06       integer,                 /*總模數                                 */
edb07       nvarchar(10)             /*被取代製程段號                         */
);

alter table edb_file add constraint edb_pk primary key  (edb01,edb02);
grant select on edb_file to tiptopgp;
grant update on edb_file to tiptopgp;
grant delete on edb_file to tiptopgp;
grant insert on edb_file to tiptopgp;
grant references on edb_file to tiptopgp;
grant references on edb_file to ods;
grant select on edb_file to ods;
