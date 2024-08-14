/*
================================================================================
檔案代號:lnw_file
檔案名稱:合同其它費用標準信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnw_file
(
lnw01       nvarchar(16) DEFAULT ' ' NOT NULL, /*合同編號*/
lnw02       nvarchar(20),            /*合同版本號                             */
lnw03       nvarchar(10) DEFAULT ' ' NOT NULL, /*費用明細編號*/
lnw04       nvarchar(24),            /*會計科目                               */
lnw041      nvarchar(24),            /*會計科目二                             */
lnw05       nvarchar(1) DEFAULT ' ', /*No Use                                 */
lnw06       decimal(18),             /*金額                                   */
lnw07       nvarchar(1) DEFAULT ' ' NOT NULL, /*收取方式*/
lnw08       datetime,                /*生效日期                               */
lnw09       datetime,                /*失效日期                               */
lnw10       nvarchar(1),             /*費用歸屬                               */
lnwlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lnwstore    nvarchar(10) DEFAULT ' ' NOT NULL /*門店編號*/
);

alter table lnw_file add constraint lnw_pk primary key  (lnw01,lnw03) deferrable initially deferred;
grant select on lnw_file to tiptopgp;
grant update on lnw_file to tiptopgp;
grant delete on lnw_file to tiptopgp;
grant insert on lnw_file to tiptopgp;
grant references on lnw_file to tiptopgp;
grant references on lnw_file to ods;
grant select on lnw_file to ods;
