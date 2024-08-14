/*
================================================================================
檔案代號:lra_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lra_file
(
lra00       nvarchar(10),            /*No Use                                 */
lra01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lra02       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lra03       decimal(18),             /*No Use                                 */
lra04       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra05       nvarchar(30),            /*No Use                                 */
lra06       nvarchar(20),            /*No Use                                 */
lra07       nvarchar(20),            /*No Use                                 */
lra08       datetime,                /*No Use                                 */
lra09       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra10       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra11       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra12       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra13       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lra14       nvarchar(10),            /*No Use                                 */
lra15       datetime,                /*No Use                                 */
lra16       nvarchar(50),            /*No Use                                 */
lra17       nvarchar(20),            /*No Use                                 */
lra18       nvarchar(1) DEFAULT ' ', /*No Use                                 */
lra19       nvarchar(20),            /*No Use                                 */
lra20       nvarchar(10),            /*商戶號                                 */
lra21       nvarchar(20),            /*No Use                                 */
lra22       nvarchar(10),            /*No Use                                 */
lra23       nvarchar(10),            /*No Use                                 */
lra24       nvarchar(10),            /*No Use                                 */
lra25       nvarchar(10),            /*No Use                                 */
lra26       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lra27       nvarchar(10),            /*No Use                                 */
lra28       nvarchar(10),            /*No Use                                 */
lra29       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lracrat     datetime,                /*No Use                                 */
lradate     datetime,                /*No Use                                 */
lragrup     nvarchar(10),            /*No Use                                 */
lralegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lramodu     nvarchar(10),            /*No Use                                 */
lraorig     nvarchar(10),            /*No Use                                 */
lraoriu     nvarchar(10),            /*No Use                                 */
lraplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lrauser     nvarchar(10)             /*No Use                                 */
);

create        index lraplant_idx on lra_file (lraplant);
alter table lra_file add constraint lra_pk primary key  (lra01) deferrable initially deferred;
grant select on lra_file to tiptopgp;
grant update on lra_file to tiptopgp;
grant delete on lra_file to tiptopgp;
grant insert on lra_file to tiptopgp;
grant references on lra_file to tiptopgp;
grant references on lra_file to ods;
grant select on lra_file to ods;
