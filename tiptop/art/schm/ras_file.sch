/*
================================================================================
檔案代號:ras_file
檔案名稱:換贈第二單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ras_file
(
ras01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
ras02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
ras03       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷類型2.組合促銷3.滿額促銷*/
ras04       smallint DEFAULT 0 NOT NULL, /*項次*/
ras05       smallint DEFAULT 0 NOT NULL, /*組別*/
ras06       nvarchar(1) DEFAULT ' ' NOT NULL, /*資料類型1.產品2.產品分類3.類 */
ras07       nvarchar(40),            /*代碼                                   */
ras08       nvarchar(4),             /*單位                                   */
rasacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
raslegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
rasplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

alter table ras_file add constraint ras_pk primary key  (ras01,ras02,ras03,ras04,ras05,ras06,rasplant);
grant select on ras_file to tiptopgp;
grant update on ras_file to tiptopgp;
grant delete on ras_file to tiptopgp;
grant insert on ras_file to tiptopgp;
grant references on ras_file to tiptopgp;
grant references on ras_file to ods;
grant select on ras_file to ods;
