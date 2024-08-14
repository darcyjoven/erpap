/*
================================================================================
檔案代號:raj_file
檔案名稱:滿額促銷單身檔(二)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table raj_file
(
raj01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
raj02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
raj03       smallint DEFAULT 0 NOT NULL, /*項次*/
raj04       nvarchar(1) DEFAULT ' ' NOT NULL, /*資料類型*/
raj05       nvarchar(40),            /*編號                                   */
raj06       nvarchar(4),             /*單位                                   */
rajacti     nvarchar(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rajlegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
rajplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

alter table raj_file add constraint raj_pk primary key  (raj01,raj02,raj03,raj04,rajplant);
grant select on raj_file to tiptopgp;
grant update on raj_file to tiptopgp;
grant delete on raj_file to tiptopgp;
grant insert on raj_file to tiptopgp;
grant references on raj_file to tiptopgp;
grant references on raj_file to ods;
grant select on raj_file to ods;
