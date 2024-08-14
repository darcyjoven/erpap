/*
================================================================================
檔案代號:omee_file
檔案名稱:發票與帳款對照檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omee_file
(
omee01      nvarchar(16) DEFAULT ' ' NOT NULL, /*發票編號*/
omee02      nvarchar(16) DEFAULT ' ' NOT NULL, /*帳款單號*/
omeedate    datetime,                /*資料輸入日                             */
omeegrup    nvarchar(10),            /*資料所有群                             */
omeelegal   nvarchar(10) DEFAULT ' ' NOT NULL, /*所屬法人*/
omeemodu    nvarchar(10),            /*資料更改者                             */
omeeorig    nvarchar(10),            /*資料建立部門                           */
omeeoriu    nvarchar(10),            /*資料建立者                             */
omeeuser    nvarchar(10)             /*資料所有者                             */
);

alter table omee_file add constraint omee_pk primary key  (omee01,omee02);
grant select on omee_file to tiptopgp;
grant update on omee_file to tiptopgp;
grant delete on omee_file to tiptopgp;
grant insert on omee_file to tiptopgp;
grant references on omee_file to tiptopgp;
grant references on omee_file to ods;
grant select on omee_file to ods;
