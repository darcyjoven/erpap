/*
================================================================================
檔案代號:lsh_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsh_file
(
lsh00       nvarchar(10),            /*No Use                                 */
lsh01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsh02       nvarchar(20),            /*No Use                                 */
lsh03       nvarchar(10),            /*商戶號                                 */
lsh04       nvarchar(20),            /*No Use                                 */
lsh05       nvarchar(10),            /*No Use                                 */
lsh06       decimal(18),             /*No Use                                 */
lsh07       decimal(18),             /*No Use                                 */
lsh08       decimal(18),             /*No Use                                 */
lsh09       nvarchar(1),             /*No Use                                 */
lsh10       datetime,                /*No Use                                 */
lsh11       nvarchar(1),             /*No Use                                 */
lsh12       nvarchar(10),            /*No Use                                 */
lsh13       datetime,                /*No Use                                 */
lsh14       nvarchar(255),           /*No Use                                 */
lshacti     nvarchar(1),             /*No Use                                 */
lshcrat     datetime,                /*No Use                                 */
lshdate     datetime,                /*No Use                                 */
lshgrup     nvarchar(10),            /*No Use                                 */
lshlegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lshmodu     nvarchar(10),            /*No Use                                 */
lshorig     nvarchar(10),            /*No Use                                 */
lshoriu     nvarchar(10),            /*No Use                                 */
lshplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lshuser     nvarchar(10)             /*No Use                                 */
);

create        index lshplant_idx on lsh_file (lshplant);
alter table lsh_file add constraint lsh_pk primary key  (lsh01) deferrable initially deferred;
grant select on lsh_file to tiptopgp;
grant update on lsh_file to tiptopgp;
grant delete on lsh_file to tiptopgp;
grant insert on lsh_file to tiptopgp;
grant references on lsh_file to tiptopgp;
grant references on lsh_file to ods;
grant select on lsh_file to ods;
