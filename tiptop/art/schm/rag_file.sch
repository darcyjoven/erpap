/*
================================================================================
檔案代號:rag_file
檔案名稱:組合促銷第二單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rag_file
(
rag01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rag02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rag03       smallint DEFAULT 0 NOT NULL, /*組別*/
rag04       nvarchar(1) DEFAULT ' ' NOT NULL, /*資料類型1.產品2.產品分類3.類 */
rag05       nvarchar(40) DEFAULT ' ' NOT NULL, /*代碼*/
rag06       nvarchar(4) DEFAULT ' ' NOT NULL, /*單位*/
ragacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
raglegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
ragplant    nvarchar(10) DEFAULT ' ' NOT NULL /*營運中心*/
);

alter table rag_file add constraint rag_pk primary key  (rag01,rag02,rag03,rag04,rag05,rag06,ragplant);
grant select on rag_file to tiptopgp;
grant update on rag_file to tiptopgp;
grant delete on rag_file to tiptopgp;
grant insert on rag_file to tiptopgp;
grant references on rag_file to tiptopgp;
grant references on rag_file to ods;
grant select on rag_file to ods;
