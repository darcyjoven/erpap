/*
================================================================================
檔案代號:ltd_file
檔案名稱:促銷金額資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltd_file
(
ltd01       nvarchar(10),            /*no use 原門店編號                      */
ltd02       nvarchar(20) DEFAULT ' ' NOT NULL, /*租憑合同號*/
ltd03       nvarchar(20) DEFAULT ' ' NOT NULL, /*攤位編號*/
ltd04       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
ltd05       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷編號*/
ltd06       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷類型*/
ltd07       nvarchar(10),            /*樓棟編號                               */
ltd08       nvarchar(10),            /*樓層編號                               */
ltd09       nvarchar(10),            /*大類編號                               */
ltd10       nvarchar(10),            /*中類編號                               */
ltd11       nvarchar(10),            /*小類編號                               */
ltd12       decimal(18) DEFAULT '0' NOT NULL, /*折扣返券金額*/
ltd13       decimal(18) DEFAULT '0' NOT NULL, /*折扣返券應返金額*/
ltd14       decimal(18) DEFAULT '0' NOT NULL, /*直接折扣金額*/
ltd15       decimal(18) DEFAULT '0' NOT NULL, /*直接折扣應返金額*/
ltd16       decimal(18) DEFAULT '0' NOT NULL, /*返券返現金額*/
ltd17       decimal(18) DEFAULT '0' NOT NULL, /*返券返現應返金額*/
ltd18       decimal(18) DEFAULT '0' NOT NULL, /*活動贈品金額*/
ltd19       decimal(18) DEFAULT '0' NOT NULL, /*活動贈品應返金額*/
ltdlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ltdstore    nvarchar(10) DEFAULT ' ' NOT NULL /*門店編號*/
);

alter table ltd_file add constraint ltd_pk primary key  (ltd02,ltd03,ltd04,ltd05) deferrable initially deferred;
grant select on ltd_file to tiptopgp;
grant update on ltd_file to tiptopgp;
grant delete on ltd_file to tiptopgp;
grant insert on ltd_file to tiptopgp;
grant references on ltd_file to tiptopgp;
grant references on ltd_file to ods;
grant select on ltd_file to ods;
