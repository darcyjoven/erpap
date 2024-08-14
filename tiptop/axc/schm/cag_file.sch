/*
================================================================================
檔案代號:cag_file
檔案名稱:工單轉入資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cag_file
(
cag01       nvarchar(20) NOT NULL,   /*轉入工單編號                           */
cag012      nvarchar(10) DEFAULT ' ' NOT NULL, /*轉入製程段號*/
cag02       smallint NOT NULL,       /*年度                                   */
cag03       smallint NOT NULL,       /*月份                                   */
cag04       nvarchar(40),            /*料件編號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
cag05       smallint NOT NULL,       /*轉入工單之製程序號                     */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cag06       nvarchar(6),             /*轉入工單之作業編號                     */
                                     /*料件被製作程序過程中的生產活動編號     */
cag11       nvarchar(20),            /*轉出工單編號                           */
cag112      nvarchar(10),            /*轉出製程段號                           */
cag15       smallint,                /*轉出工單之製程序號                     */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cag16       nvarchar(6),             /*轉出工單之作業編號                     */
                                     /*料件被製作程序過程中的生產活動編號     */
cag20       decimal(18),             /*工單轉入量       (+)                   */
cagdate     datetime,                /*首次報工日                             */
caglegal    nvarchar(10) NOT NULL    /*所屬法人                               */
);

alter table cag_file add constraint cag_pk primary key  (cag01,cag02,cag03,cag05,cag012);
grant select on cag_file to tiptopgp;
grant update on cag_file to tiptopgp;
grant delete on cag_file to tiptopgp;
grant insert on cag_file to tiptopgp;
grant references on cag_file to tiptopgp;
grant references on cag_file to ods;
grant select on cag_file to ods;
