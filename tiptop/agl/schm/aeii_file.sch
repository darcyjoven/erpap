/*
================================================================================
檔案代號:aeii_file
檔案名稱:合併後科目異動碼(固定)沖帳餘額檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aeii_file
(
aeii00      nvarchar(5) DEFAULT ' ' NOT NULL, /*帳別*/
aeii01      nvarchar(10) DEFAULT ' ' NOT NULL, /*族群編號*/
aeii02      nvarchar(10) DEFAULT ' ' NOT NULL, /*上層公司編號*/
aeii021     nvarchar(5) DEFAULT ' ' NOT NULL, /*上層公司帳別*/
aeii03      nvarchar(10) DEFAULT ' ' NOT NULL, /*下層公司編號*/
aeii031     nvarchar(5) DEFAULT ' ' NOT NULL, /*下層公司帳別*/
aeii04      nvarchar(24) DEFAULT ' ' NOT NULL, /*科目編號*/
aeii05      nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼5值*/
aeii06      nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼6值*/
aeii07      nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼7值*/
aeii08      nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼8值*/
aeii09      smallint DEFAULT 0 NOT NULL, /*會計年度*/
aeii10      smallint DEFAULT 0 NOT NULL, /*期別*/
aeii11      decimal(20,6) DEFAULT '0' NOT NULL, /*借方總金額*/
aeii12      decimal(20,6) DEFAULT '0' NOT NULL, /*貸方總金額*/
aeii13      smallint,                /*借方總筆數                             */
aeii14      smallint,                /*貸方總筆數                             */
aeii15      nvarchar(10),            /*版本                                   */
aeii16      decimal(20,10),          /*再衡量匯率                             */
aeii17      decimal(20,10),          /*換算匯率                               */
aeii18      nvarchar(4) DEFAULT ' ' NOT NULL, /*幣別*/
aeiilegal   nvarchar(10)             /*所屬法人                               */
);

alter table aeii_file add constraint aeii_pk primary key  (aeii00,aeii01,aeii02,aeii021,aeii03,aeii031,aeii04,aeii05,aeii06,aeii07,aeii08,aeii09,aeii10,aeii18);
grant select on aeii_file to tiptopgp;
grant update on aeii_file to tiptopgp;
grant delete on aeii_file to tiptopgp;
grant insert on aeii_file to tiptopgp;
grant references on aeii_file to tiptopgp;
grant references on aeii_file to ods;
grant select on aeii_file to ods;
