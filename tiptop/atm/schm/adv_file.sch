/*
================================================================================
檔案代號:adv_file
檔案名稱:流通配銷系統參數檔-收貨單
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table adv_file
(
adv01       nvarchar(10) NOT NULL,   /*撥入營運中心                           */
adv02       nvarchar(5),             /*出貨單別                               */
adv03       nvarchar(10),            /*銷售分類                               */
adv04       nvarchar(10),            /*業務員                                 */
adv05       nvarchar(10),            /*出貨部門                               */
adv06       nvarchar(4),             /*稅別                                   */
adv07       decimal(18),             /*稅率                                   */
adv08       nvarchar(1),             /*聯數                                   */
adv09       nvarchar(1),             /*含稅否                                 */
adv10       nvarchar(4),             /*幣別                                   */
adv11       decimal(18),             /*匯率                                   */
adv12       nvarchar(5),             /*發票別                                 */
adv13       nvarchar(10),            /*科目別                                 */
adv14       nvarchar(1),             /*No                                     */
adv15       nvarchar(1),             /*No                                     */
advacti     nvarchar(1),             /*資料有效碼                             */
advdate     datetime,                /*最近修改日                             */
advgrup     nvarchar(10),            /*資料所有部門                           */
advmodu     nvarchar(10),            /*資料修改者                             */
advorig     nvarchar(10),            /*資料建立部門                           */
advoriu     nvarchar(10),            /*資料建立者                             */
advuser     nvarchar(10)             /*資料所有者                             */
);

alter table adv_file add constraint adv_pk primary key  (adv01);
grant select on adv_file to tiptopgp;
grant update on adv_file to tiptopgp;
grant delete on adv_file to tiptopgp;
grant insert on adv_file to tiptopgp;
grant references on adv_file to tiptopgp;
grant references on adv_file to ods;
grant select on adv_file to ods;
