/*
================================================================================
檔案代號:shc_file
檔案名稱:工單生產日報單身缺點碼維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shc_file
(
shc01       nvarchar(20) NOT NULL,   /*移轉單號                               */
shc012      nvarchar(10),            /*責任歸屬製程段                         */
shc03       smallint NOT NULL,       /*行序                                   */
shc04       nvarchar(10),            /*缺點碼                                 */
shc05       decimal(15,3),           /*數量                                   */
shc06       smallint,                /*責任歸屬製程                           */
shc07       nvarchar(1),             /*No Use                                 */
shcacti     nvarchar(1),             /*資料有效碼                             */
shcdate     datetime,                /*最近修改日                             */
shcgrup     nvarchar(10),            /*資料所有部門                           */
shclegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
shcmodu     nvarchar(10),            /*資料修改者                             */
shcorig     nvarchar(10),            /*資料建立部門                           */
shcoriu     nvarchar(10),            /*資料建立者                             */
shcplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
shcuser     nvarchar(10)             /*資料所有者                             */
);

create        index shcplant_idx on shc_file (shcplant);
alter table shc_file add constraint shc_pk primary key  (shc01,shc03);
grant select on shc_file to tiptopgp;
grant update on shc_file to tiptopgp;
grant delete on shc_file to tiptopgp;
grant insert on shc_file to tiptopgp;
grant references on shc_file to tiptopgp;
grant references on shc_file to ods;
grant select on shc_file to ods;
