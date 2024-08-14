/*
================================================================================
檔案代號:lrh_file
檔案名稱:贈品發放記錄單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrh_file
(
lrh00       nvarchar(10),            /*no use                                 */
lrh01       nvarchar(20) DEFAULT ' ' NOT NULL, /*贈品發放單號*/
lrh02       nvarchar(20),            /*攤位編號                               */
lrh03       nvarchar(20),            /*合同編號                               */
lrh04       nvarchar(10),            /*商戶號                                 */
lrh05       nvarchar(10),            /*主品牌                                 */
lrh06       datetime,                /*贈品發放日期                           */
lrh07       nvarchar(20),            /*促銷單編號                             */
lrh08       decimal(18) DEFAULT '0' NOT NULL, /*交款總金額*/
lrh09       nvarchar(20),            /*贈送贈品編號                           */
lrh10       decimal(18) DEFAULT '0' NOT NULL, /*贈品價格*/
lrh11       nvarchar(1) DEFAULT ' ' NOT NULL, /*贈品回收否*/
lrh12       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lrh13       nvarchar(10),            /*確認人                                 */
lrh14       datetime,                /*確認日期                               */
lrh15       nvarchar(50),            /*備注                                   */
lrh16       decimal(18) DEFAULT '0' NOT NULL, /*合同總金額*/
lrh17       nvarchar(10),            /*樓棟編號                               */
lrh18       nvarchar(10),            /*樓層編號                               */
lrh19       nvarchar(10),            /*大類編號                               */
lrh20       nvarchar(10),            /*中類編號                               */
lrh21       nvarchar(10),            /*小類編號                               */
lrhcrat     datetime,                /*資料創建日                             */
lrhdate     datetime,                /*最近更改日                             */
lrhgrup     nvarchar(10),            /*資料所有群                             */
lrhlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lrhmodu     nvarchar(10),            /*資料更改者                             */
lrhorig     nvarchar(10),            /*資料建立部門                           */
lrhoriu     nvarchar(10),            /*資料建立者                             */
lrhplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
lrhuser     nvarchar(10)             /*資料所有者                             */
);

create        index lrhplant_idx on lrh_file (lrhplant);
alter table lrh_file add constraint lrh_pk primary key  (lrh01) deferrable initially deferred;
grant select on lrh_file to tiptopgp;
grant update on lrh_file to tiptopgp;
grant delete on lrh_file to tiptopgp;
grant insert on lrh_file to tiptopgp;
grant references on lrh_file to tiptopgp;
grant references on lrh_file to ods;
grant select on lrh_file to ods;
