/*
================================================================================
檔案代號:lrd_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrd_file
(
lrd00       nvarchar(10),            /*No Use                                 */
lrd01       nvarchar(20) DEFAULT ' ' NOT NULL, /*No Use*/
lrd02       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lrd03       nvarchar(20),            /*No Use                                 */
lrd04       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd05       nvarchar(20),            /*No Use                                 */
lrd06       nvarchar(10),            /*商戶號                                 */
lrd07       nvarchar(20),            /*No Use                                 */
lrd08       nvarchar(10),            /*No Use                                 */
lrd09       nvarchar(10),            /*No Use                                 */
lrd10       nvarchar(10),            /*No Use                                 */
lrd11       nvarchar(10),            /*No Use                                 */
lrd12       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd13       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd14       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd15       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd16       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd17       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd18       nvarchar(1) DEFAULT ' ', /*No Use                                 */
lrd19       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd20       decimal(18) DEFAULT '0', /*No Use                                 */
lrd21       decimal(18) DEFAULT '0', /*No Use                                 */
lrd22       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd23       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrd24       datetime,                /*No Use                                 */
lrd241      nvarchar(8),             /*No Use                                 */
lrd25       nvarchar(10),            /*No Use                                 */
lrd26       nvarchar(20),            /*No Use                                 */
lrd27       nvarchar(30),            /*No Use                                 */
lrd28       nvarchar(20),            /*No Use                                 */
lrd29       nvarchar(20),            /*No Use                                 */
lrd30       nvarchar(50),            /*No Use                                 */
lrd31       nvarchar(10),            /*No Use                                 */
lrd32       nvarchar(50),            /*No Use                                 */
lrd33       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lrd34       nvarchar(10),            /*No Use                                 */
lrd35       datetime,                /*No Use                                 */
lrd36       nvarchar(20),            /*No Use                                 */
lrd37       nvarchar(1) DEFAULT ' ', /*No Use                                 */
lrd38       nvarchar(10),            /*No Use                                 */
lrd39       nvarchar(10),            /*No Use                                 */
lrd40       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lrd41       decimal(18) DEFAULT '0' NOT NULL, /*No Use*/
lrdacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lrdcrat     datetime,                /*No Use                                 */
lrddate     datetime,                /*No Use                                 */
lrdgrup     nvarchar(10),            /*No Use                                 */
lrdlegal    nvarchar(10) NOT NULL,   /*No Use                                 */
lrdmodu     nvarchar(10),            /*No Use                                 */
lrdorig     nvarchar(10),            /*No Use                                 */
lrdoriu     nvarchar(10),            /*No Use                                 */
lrdplant    nvarchar(10) NOT NULL,   /*No Use                                 */
lrduser     nvarchar(10)             /*No Use                                 */
);

create        index lrdplant_idx on lrd_file (lrdplant);
alter table lrd_file add constraint lrd_pk primary key  (lrd01) deferrable initially deferred;
grant select on lrd_file to tiptopgp;
grant update on lrd_file to tiptopgp;
grant delete on lrd_file to tiptopgp;
grant insert on lrd_file to tiptopgp;
grant references on lrd_file to tiptopgp;
grant references on lrd_file to ods;
grant select on lrd_file to ods;
