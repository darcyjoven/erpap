/*
================================================================================
檔案代號:rai_file
檔案名稱:滿額促銷單身檔(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rai_file
(
rai01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rai02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rai03       smallint DEFAULT 0 NOT NULL, /*項次*/
rai04       decimal(20,6) DEFAULT '0' NOT NULL, /*滿額金額*/
rai05       decimal(5,2),            /*折扣率                                 */
rai06       decimal(20,6) DEFAULT '0' NOT NULL, /*折讓額*/
rai07       nvarchar(1) DEFAULT 'N' NOT NULL, /*是否按會員等級促銷*/
rai08       decimal(5,2),            /*會員折扣率                             */
rai09       decimal(20,6) DEFAULT '0' NOT NULL, /*會員折讓額*/
raiacti     nvarchar(1) DEFAULT 'Y' NOT NULL, /*有效否*/
railegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
raiplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

alter table rai_file add constraint rai_pk primary key  (rai01,rai02,rai03,raiplant);
grant select on rai_file to tiptopgp;
grant update on rai_file to tiptopgp;
grant delete on rai_file to tiptopgp;
grant insert on rai_file to tiptopgp;
grant references on rai_file to tiptopgp;
grant references on rai_file to ods;
grant select on rai_file to ods;
