/*
================================================================================
檔案代號:zta_file
檔案名稱:檔案名稱檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zta_file
(
zta01       nvarchar(15) NOT NULL,   /*檔案代碼                               */
                                     /*檔案編號, (Table name)                 */
                                     /*Ex:ima_file, zz_file                   */
zta02       nvarchar(20) NOT NULL,   /*檔案名稱                               */
                                     /*no use                                 */
zta03       nvarchar(3),             /*系統別                                 */
zta04       nvarchar(4),             /*使用別                                 */
zta05       datetime,                /*產生日期                               */
zta06       nvarchar(10),            /*產生者                                 */
zta07       nvarchar(1),             /*T/S建議 (Table/Synonym)                */
zta08       nvarchar(1),             /*No Use                                 */
zta09       nvarchar(2),             /*檔案類別                               */
                                     /*檔案類別(P/M/T/S)                      */
                                     /*P:參數檔                               */
                                     /*M:主檔   (M0:單頭 M1:單身)             */
                                     /*T:異動檔 (T0:單頭 T1:單身)             */
                                     /*S:統計檔                               */
zta10       nvarchar(1),             /*資料庫                                 */
zta11       nvarchar(80),            /*檔案名稱                               */
                                     /*上游檔案                               */
zta12       nvarchar(60),            /*檔案目的                               */
                                     /*下游檔案                               */
zta13       nvarchar(1),             /*檔案來源                               */
                                     /*no use                                 */
zta14       nvarchar(1),             /*上游檔案                               */
                                     /*no use                                 */
zta15       nvarchar(1),             /*下游檔案                               */
                                     /*no use                                 */
zta16       nvarchar(1),             /*注意事項                               */
                                     /*no use                                 */
zta17       nvarchar(10),            /*Synonym DB                             */
zta18       nvarchar(1) DEFAULT 'N' NOT NULL /*多語系檔案*/
);

alter table zta_file add constraint zta_pk primary key  (zta01,zta02);
grant select on zta_file to tiptopgp;
grant update on zta_file to tiptopgp;
grant delete on zta_file to tiptopgp;
grant insert on zta_file to tiptopgp;
grant references on zta_file to tiptopgp;
grant references on zta_file to ods;
grant select on zta_file to ods;
