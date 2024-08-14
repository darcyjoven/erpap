/*
================================================================================
檔案代號:lsa_file
檔案名稱:日結作業檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table lsa_file
(
lsa01       datetime DEFAULT '(getdate())' NOT NULL, /*日結日期*/
lsa02       nvarchar(20) DEFAULT ' ' NOT NULL, /*攤位號*/
lsa03       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同號*/
lsa04       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lsa05       nvarchar(10),            /*樓棟編號                               */
lsa06       nvarchar(10),            /*樓層編號                               */
lsa07       nvarchar(10),            /*產品分類                               */
lsa08       nvarchar(10),            /*No Use                                 */
lsa09       nvarchar(10),            /*No Use                                 */
lsa10       nvarchar(2) DEFAULT ' ' NOT NULL, /*No Use*/
lsa11       decimal(18) DEFAULT '0' NOT NULL, /*金額*/
lsa12       nvarchar(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsa13       nvarchar(20),            /*No Use                                 */
lsalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lsaplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

alter table lsa_file add constraint lsa_pk primary key  (lsa01,lsa02,lsa03,lsa04,lsa10,lsa12) deferrable initially deferred;
grant select on lsa_file to tiptopgp;
grant update on lsa_file to tiptopgp;
grant delete on lsa_file to tiptopgp;
grant insert on lsa_file to tiptopgp;
grant references on lsa_file to tiptopgp;
grant references on lsa_file to ods;
grant select on lsa_file to ods;
