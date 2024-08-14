/*
================================================================================
檔案代號:lnz_file
檔案名稱:月收入資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnz_file
(
lnz01       nvarchar(10),            /*no use                                 */
lnz02       nvarchar(20) DEFAULT ' ' NOT NULL, /*攤位編號*/
lnz03       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶編號*/
lnz04       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同編號*/
lnz05       nvarchar(4) DEFAULT ' ' NOT NULL, /*所屬年份*/
lnz06       nvarchar(2) DEFAULT ' ' NOT NULL, /*所屬月份*/
lnz07       decimal(18) DEFAULT '0' NOT NULL, /*金額*/
lnzcrat     datetime,                /*資料創建日                             */
lnzlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lnzstore    nvarchar(10) DEFAULT ' ' NOT NULL /*門店編號*/
);

alter table lnz_file add constraint lnz_pk primary key  (lnz02,lnz03,lnz04,lnz05,lnz06) deferrable initially deferred;
grant select on lnz_file to tiptopgp;
grant update on lnz_file to tiptopgp;
grant delete on lnz_file to tiptopgp;
grant insert on lnz_file to tiptopgp;
grant references on lnz_file to tiptopgp;
grant references on lnz_file to ods;
grant select on lnz_file to ods;
