/*
================================================================================
檔案代號:aei_file
檔案名稱:合併前科目異動碼(固定)沖帳餘額檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aei_file
(
aei00       nvarchar(5) DEFAULT ' ' NOT NULL, /*帳別*/
aei01       nvarchar(10) DEFAULT ' ' NOT NULL, /*族群編號*/
aei02       nvarchar(10) DEFAULT ' ' NOT NULL, /*上層公司編號*/
aei021      nvarchar(5) DEFAULT ' ' NOT NULL, /*上層公司帳別*/
aei03       nvarchar(10) DEFAULT ' ' NOT NULL, /*下層公司編號*/
aei031      nvarchar(5) DEFAULT ' ' NOT NULL, /*下層公司帳別*/
aei04       nvarchar(24) DEFAULT ' ' NOT NULL, /*科目編號*/
aei05       nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼5值*/
aei06       nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼6值*/
aei07       nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼7值*/
aei08       nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼8值*/
aei09       smallint DEFAULT 0 NOT NULL, /*會計年度*/
aei10       smallint DEFAULT 0 NOT NULL, /*期別*/
aei11       decimal(20,6),           /*借方總金額                             */
aei12       decimal(20,6),           /*貸方總金額                             */
aei13       smallint,                /*借方總筆數                             */
aei14       smallint,                /*貸方總筆數                             */
aei15       nvarchar(10),            /*版本                                   */
aei16       decimal(20,10),          /*再衡量匯率                             */
aei17       decimal(20,10),          /*換算匯率                               */
aei18       nvarchar(4) DEFAULT ' ' NOT NULL, /*幣別*/
aeilegal    nvarchar(10)             /*所屬法人                               */
);

alter table aei_file add constraint aei_pk primary key  (aei00,aei01,aei02,aei021,aei03,aei031,aei04,aei05,aei06,aei07,aei08,aei09,aei10,aei18);
grant select on aei_file to tiptopgp;
grant update on aei_file to tiptopgp;
grant delete on aei_file to tiptopgp;
grant insert on aei_file to tiptopgp;
grant references on aei_file to tiptopgp;
grant references on aei_file to ods;
grant select on aei_file to ods;
