/*
================================================================================
檔案代號:lsi_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsi_file
(
lsi01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsi02       decimal(18),             /*No Use                                 */
lsi03       decimal(18),             /*No Use                                 */
lsi04       datetime,                /*No Use                                 */
lsi05       nvarchar(10),            /*商戶號                                 */
lsi06       nvarchar(20),            /*No Use                                 */
lsi07       nvarchar(20),            /*No Use                                 */
lsi08       nvarchar(10),            /*No Use                                 */
lsi09       nvarchar(255),           /*No Use                                 */
lsi10       nvarchar(1),             /*No Use                                 */
lsi11       nvarchar(10),            /*No Use                                 */
lsi12       datetime,                /*No Use                                 */
lsi13       nvarchar(10),            /*No Use                                 */
lsiacti     nvarchar(1),             /*No Use                                 */
lsicrat     datetime,                /*No Use                                 */
lsidate     datetime,                /*No Use                                 */
lsigrup     nvarchar(10),            /*No Use                                 */
lsilegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lsimodu     nvarchar(10),            /*No Use                                 */
lsiorig     nvarchar(10),            /*No Use                                 */
lsioriu     nvarchar(10),            /*No Use                                 */
lsiplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lsiuser     nvarchar(10)             /*No Use                                 */
);

create        index lsiplant_idx on lsi_file (lsiplant);
alter table lsi_file add constraint lsi_pk primary key  (lsi01) deferrable initially deferred;
grant select on lsi_file to tiptopgp;
grant update on lsi_file to tiptopgp;
grant delete on lsi_file to tiptopgp;
grant insert on lsi_file to tiptopgp;
grant references on lsi_file to tiptopgp;
grant references on lsi_file to ods;
grant select on lsi_file to ods;
