/*
================================================================================
檔案代號:lsk_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsk_file
(
lsk01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsk02       nvarchar(20),            /*No Use                                 */
lsk03       nvarchar(10),            /*商戶號                                 */
lsk04       nvarchar(20),            /*No Use                                 */
lsk05       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsk06       decimal(18),             /*No Use                                 */
lsk07       decimal(18),             /*No Use                                 */
lsk08       datetime,                /*No Use                                 */
lsk09       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsk10       nvarchar(10),            /*No Use                                 */
lsk11       datetime,                /*No Use                                 */
lsk12       nvarchar(10),            /*No Use                                 */
lskacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lskcrat     datetime,                /*No Use                                 */
lskdate     datetime,                /*No Use                                 */
lskgrup     nvarchar(10),            /*No Use                                 */
lsklegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lskmodu     nvarchar(10),            /*No Use                                 */
lskorig     nvarchar(10),            /*No Use                                 */
lskoriu     nvarchar(10),            /*No Use                                 */
lskplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lskuser     nvarchar(10)             /*No Use                                 */
);

create        index lskplant_idx on lsk_file (lskplant);
alter table lsk_file add constraint lsk_pk primary key  (lsk01) deferrable initially deferred;
grant select on lsk_file to tiptopgp;
grant update on lsk_file to tiptopgp;
grant delete on lsk_file to tiptopgp;
grant insert on lsk_file to tiptopgp;
grant references on lsk_file to tiptopgp;
grant references on lsk_file to ods;
grant select on lsk_file to ods;
