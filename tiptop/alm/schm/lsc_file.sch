/*
================================================================================
檔案代號:lsc_file
檔案名稱:廣告位合同資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsc_file
(
lsc01       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同號*/
lsc02       nvarchar(20),            /*版本號                                 */
lsc03       nvarchar(10),            /*商戶號                                 */
lsc04       nvarchar(20),            /*廣告位編號                             */
lsc05       datetime,                /*租賃期起始                             */
lsc06       datetime,                /*租賃期截止                             */
lsc07       datetime,                /*簽訂日期                               */
lsc08       decimal(18),             /*定金                                   */
lsc09       decimal(18),             /*合同金額                               */
lsc10       nvarchar(10),            /*終止人                                 */
lsc11       datetime,                /*終止日期                               */
lsc12       nvarchar(1),             /*是否簽核                               */
lsc13       nvarchar(1),             /*簽核狀態                               */
lsc14       nvarchar(1),             /*審核碼                                 */
lsc15       nvarchar(10),            /*審核碼                                 */
lsc16       datetime,                /*審核日期                               */
lsc17       nvarchar(10),            /*no use 原門店編號                      */
lsc18       nvarchar(4),             /*稅種                                   */
lsc19       decimal(18),             /*稅率                                   */
lsc20       nvarchar(1),             /*含稅否                                 */
lsccrat     datetime,                /*資料創建日                             */
lscdate     datetime,                /*最近更改日                             */
lscgrup     nvarchar(10),            /*資料所有群                             */
lsclegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lscmodu     nvarchar(10),            /*資料更改者                             */
lscorig     nvarchar(10),            /*資料建立部門                           */
lscoriu     nvarchar(10),            /*資料建立者                             */
lscstore    nvarchar(10) DEFAULT ' ' NOT NULL, /*門店編號*/
lscuser     nvarchar(10)             /*資料所有者                             */
);

alter table lsc_file add constraint lsc_pk primary key  (lsc01) deferrable initially deferred;
grant select on lsc_file to tiptopgp;
grant update on lsc_file to tiptopgp;
grant delete on lsc_file to tiptopgp;
grant insert on lsc_file to tiptopgp;
grant references on lsc_file to tiptopgp;
grant references on lsc_file to ods;
grant select on lsc_file to ods;
