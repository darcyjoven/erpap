/*
================================================================================
檔案代號:lsj_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsj_file
(
lsj01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsj02       nvarchar(20),            /*No Use                                 */
lsj03       nvarchar(10),            /*商戶號                                 */
lsj04       nvarchar(20),            /*No Use                                 */
lsj05       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsj06       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lsj07       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lsj08       datetime,                /*No Use                                 */
lsj09       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsj10       nvarchar(10),            /*No Use                                 */
lsj11       datetime,                /*No Use                                 */
lsj12       nvarchar(10),            /*No Use                                 */
lsjacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsjcrat     datetime,                /*No Use                                 */
lsjdate     datetime,                /*No Use                                 */
lsjgrup     nvarchar(10),            /*No Use                                 */
lsjlegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lsjmodu     nvarchar(10),            /*No Use                                 */
lsjorig     nvarchar(10),            /*No Use                                 */
lsjoriu     nvarchar(10),            /*No Use                                 */
lsjplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lsjuser     nvarchar(10)             /*No Use                                 */
);

create        index lsjplant_idx on lsj_file (lsjplant);
alter table lsj_file add constraint lsj_pk primary key  (lsj01) deferrable initially deferred;
grant select on lsj_file to tiptopgp;
grant update on lsj_file to tiptopgp;
grant delete on lsj_file to tiptopgp;
grant insert on lsj_file to tiptopgp;
grant references on lsj_file to tiptopgp;
grant references on lsj_file to ods;
grant select on lsj_file to ods;
