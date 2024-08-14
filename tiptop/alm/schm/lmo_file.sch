/*
================================================================================
檔案代號:lmo_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmo_file
(
lmo00       nvarchar(10),            /*No Use                                 */
lmo01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lmo02       nvarchar(20),            /*No Use                                 */
lmo03       nvarchar(10),            /*商戶號                                 */
lmo04       nvarchar(20),            /*No Use                                 */
lmo05       decimal(18),             /*No Use                                 */
lmo06       decimal(18),             /*No Use                                 */
lmo07       decimal(18),             /*No Use                                 */
lmo08       nvarchar(1),             /*No Use                                 */
lmo09       nvarchar(10),            /*No Use                                 */
lmo10       datetime,                /*No Use                                 */
lmoacti     nvarchar(1),             /*No Use                                 */
lmocrat     datetime,                /*No Use                                 */
lmodate     datetime,                /*No Use                                 */
lmogrup     nvarchar(10),            /*No Use                                 */
lmolegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lmomodu     nvarchar(10),            /*No Use                                 */
lmoorig     nvarchar(10),            /*No Use                                 */
lmooriu     nvarchar(10),            /*No Use                                 */
lmostore    nvarchar(10) DEFAULT ' ' NOT NULL, /*No Use*/
lmouser     nvarchar(10)             /*No Use                                 */
);

alter table lmo_file add constraint lmo_pk primary key  (lmo01) deferrable initially deferred;
grant select on lmo_file to tiptopgp;
grant update on lmo_file to tiptopgp;
grant delete on lmo_file to tiptopgp;
grant insert on lmo_file to tiptopgp;
grant references on lmo_file to tiptopgp;
grant references on lmo_file to ods;
grant select on lmo_file to ods;
