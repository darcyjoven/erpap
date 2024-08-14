/*
================================================================================
檔案代號:lmp_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmp_file
(
lmp00       nvarchar(10),            /*No Use                                 */
lmp01       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lmp02       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lmp03       nvarchar(4) DEFAULT ' ' NOT NULL, /*No Use*/
lmp04       nvarchar(2) DEFAULT ' ' NOT NULL, /*No Use*/
lmp05       nvarchar(10),            /*商戶號                                 */
lmp06       nvarchar(20),            /*No Use                                 */
lmp07       nvarchar(10),            /*No Use                                 */
lmp08       decimal(18),             /*No Use                                 */
lmp09       decimal(18),             /*No Use                                 */
lmp10       datetime,                /*No Use                                 */
lmp11       nvarchar(10),            /*No Use                                 */
lmplegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lmpstore    nvarchar(10) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table lmp_file add constraint lmp_pk primary key  (lmp01,lmp02,lmp03,lmp04) deferrable initially deferred;
grant select on lmp_file to tiptopgp;
grant update on lmp_file to tiptopgp;
grant delete on lmp_file to tiptopgp;
grant insert on lmp_file to tiptopgp;
grant references on lmp_file to tiptopgp;
grant references on lmp_file to ods;
grant select on lmp_file to ods;
