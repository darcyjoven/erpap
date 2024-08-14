/*
================================================================================
檔案代號:edf_file
檔案名稱:報工時單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table edf_file
(
edf01       nvarchar(20) DEFAULT ' ' NOT NULL, /*報工時單號*/
edf012      nvarchar(10),            /*製程段號                               */
edf02       smallint DEFAULT 0 NOT NULL, /*項次*/
edf03       nvarchar(20),            /*工單編號                               */
edf04       nvarchar(40),            /*料號                                   */
edf05       decimal(15,3) DEFAULT '0' NOT NULL, /*完工入庫量*/
edf06       nvarchar(6),             /*作業編號                               */
edf07       smallint,                /*製程序                                 */
edf08       decimal(15,3) DEFAULT '0' NOT NULL, /*報工數量*/
edf09       nvarchar(10),            /*員工                                   */
edf10       decimal(15,3),           /*標準單件工時                           */
edf11       decimal(15,3),           /*實際單件工時                           */
edf12       decimal(15,3),           /*工時合計                               */
edflegal    nvarchar(10),            /*所屬法人                               */
edfplant    nvarchar(10)             /*所屬工廠                               */
);

alter table edf_file add constraint edf_pk primary key  (edf01,edf02);
grant select on edf_file to tiptopgp;
grant update on edf_file to tiptopgp;
grant delete on edf_file to tiptopgp;
grant insert on edf_file to tiptopgp;
grant references on edf_file to tiptopgp;
grant references on edf_file to ods;
grant select on edf_file to ods;
