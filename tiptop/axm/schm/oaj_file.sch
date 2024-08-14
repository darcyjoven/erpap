/*
================================================================================
檔案代號:oaj_file
檔案名稱:費用代碼檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oaj_file
(
oaj01       nvarchar(10) NOT NULL,   /*費用代碼                               */
oaj02       nvarchar(80),            /*費用名稱                               */
oaj03       nvarchar(10),            /*No Use                                 */
oaj031      nvarchar(10),            /*費用總類編號                           */
oaj04       nvarchar(24),            /*會計科目                               */
oaj041      nvarchar(24),            /*會計科目二                             */
oaj05       nvarchar(2),             /*費用類型                               */
oaj06       nvarchar(1) DEFAULT ' ', /*No Use                                 */
oaj07       nvarchar(1) DEFAULT ' ' NOT NULL, /*計提方式*/
oajacti     nvarchar(1),             /*有效碼                                 */
oajpos      nvarchar(1)              /*已傳pos否                              */
);

alter table oaj_file add constraint oaj_pk primary key  (oaj01) deferrable initially deferred;
grant select on oaj_file to tiptopgp;
grant update on oaj_file to tiptopgp;
grant delete on oaj_file to tiptopgp;
grant insert on oaj_file to tiptopgp;
grant references on oaj_file to tiptopgp;
grant references on oaj_file to ods;
grant select on oaj_file to ods;
