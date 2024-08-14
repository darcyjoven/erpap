/*
================================================================================
檔案代號:wpf_file
檔案名稱:採購單預交日異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpf_file
(
wpf01       nvarchar(15) DEFAULT ' ' NOT NULL, /*電子變更序號*/
wpf02       smallint DEFAULT 0 NOT NULL, /*變更項次*/
wpf03       nvarchar(20),            /*採購單號                               */
wpf04       smallint,                /*採購項次                               */
wpf05       datetime,                /*變更後預交日                           */
wpf06       decimal(15,3) DEFAULT '0' NOT NULL, /*變更後預交數量*/
wpf07       nvarchar(1) DEFAULT '1' NOT NULL, /*回覆狀態*/
wpf08       datetime,                /*許可預交日                             */
wpf09       nvarchar(10)             /*來源工廠                               */
);

alter table wpf_file add constraint wpf_pk primary key  (wpf01,wpf02) deferrable initially deferred;
grant select on wpf_file to tiptopgp;
grant update on wpf_file to tiptopgp;
grant delete on wpf_file to tiptopgp;
grant insert on wpf_file to tiptopgp;
grant references on wpf_file to tiptopgp;
grant references on wpf_file to ods;
grant select on wpf_file to ods;
