/*
================================================================================
檔案代號:rad_file
檔案名稱:一般促銷資料第二單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rad_file
(
rad01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rad02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rad03       smallint DEFAULT 0 NOT NULL, /*組別*/
rad04       nvarchar(1) DEFAULT ' ' NOT NULL, /*資料類型:1.產品,2.產品分類,3. */
rad05       nvarchar(40),            /*代碼                                   */
rad06       nvarchar(4),             /*單位                                   */
radacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
radlegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
radplant    nvarchar(10) DEFAULT ' ' NOT NULL /*所屬營運中心*/
);

create        index radplant_idx on rad_file (radplant);
alter table rad_file add constraint rad_pk primary key  (rad01,rad02,rad03,rad04,radplant);
grant select on rad_file to tiptopgp;
grant update on rad_file to tiptopgp;
grant delete on rad_file to tiptopgp;
grant insert on rad_file to tiptopgp;
grant references on rad_file to tiptopgp;
grant references on rad_file to ods;
grant select on rad_file to ods;
