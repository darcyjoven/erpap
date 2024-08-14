/*
================================================================================
檔案代號:eda_file
檔案名稱:合拼版資料單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eda_file
(
eda01       nvarchar(20) DEFAULT ' ' NOT NULL, /*職能代號*/
eda02       nvarchar(80),            /*職能說明                               */
eda03       nvarchar(1),             /*永久合拼否                             */
edaacti     nvarchar(1),             /*資料有效碼                             */
edaconf     nvarchar(1),             /*確認碼                                 */
edadate     datetime,                /*最近修改日                             */
edagrup     nvarchar(10),            /*資料所有群                             */
edamodu     nvarchar(10),            /*資料更改者                             */
edaorig     nvarchar(10),            /*資料建立部門                           */
edaoriu     nvarchar(10),            /*資料建立者                             */
edauser     nvarchar(10)             /*資料所有者                             */
);

alter table eda_file add constraint eda_pk primary key  (eda01);
grant select on eda_file to tiptopgp;
grant update on eda_file to tiptopgp;
grant delete on eda_file to tiptopgp;
grant insert on eda_file to tiptopgp;
grant references on eda_file to tiptopgp;
grant references on eda_file to ods;
grant select on eda_file to ods;
