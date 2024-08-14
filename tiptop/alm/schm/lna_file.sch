/*
================================================================================
檔案代號:lna_file
檔案名稱:商户预登记资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lna_file
(
lna01       nvarchar(20) DEFAULT ' ' NOT NULL, /*預登記單號*/
lna02       nvarchar(10),            /*來源門店編號                           */
lna03       nvarchar(10),            /*預登記商戶號                           */
lna04       nvarchar(20),            /*商戶簡稱                               */
lna05       nvarchar(50),            /*商戶全稱                               */
lna06       nvarchar(1) DEFAULT ' ' NOT NULL, /*企業性質*/
lna07       nvarchar(10),            /*主品牌                                 */
lna08       nvarchar(10),            /*產地                                   */
lna09       nvarchar(60),            /*經營範圍                               */
lna10       nvarchar(10),            /*no use                                 */
lna11       nvarchar(10),            /*總經理                                 */
lna12       nvarchar(20),            /*總經理電話                             */
lna13       nvarchar(10),            /*經營負責人                             */
lna14       nvarchar(20),            /*負責人電話                             */
lna15       nvarchar(10),            /*法人代表                               */
lna16       nvarchar(20),            /*代表電話                               */
lna17       nvarchar(10),            /*經營人                                 */
lna18       nvarchar(20),            /*經營人電話                             */
lna19       nvarchar(30),            /*電子信箱                               */
lna20       nvarchar(30),            /*公司網站                               */
lna21       nvarchar(20),            /*傳真                                   */
lna22       nvarchar(20),            /*代理登記                               */
lna23       decimal(18) DEFAULT '0' NOT NULL, /*擬租面積*/
lna24       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
lna25       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lna26       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lna27       nvarchar(10),            /*確認人                                 */
lna28       datetime,                /*確認日期                               */
lna29       nvarchar(50),            /*備註                                   */
lnacrat     datetime,                /*資料創建日                             */
lnadate     datetime,                /*最近修改日                             */
lnagrup     nvarchar(10),            /*資料所有群                             */
lnamodu     nvarchar(10),            /*資料修改者                             */
lnaorig     nvarchar(10),            /*資料建立部門                           */
lnaoriu     nvarchar(10),            /*資料建立者                             */
lnauser     nvarchar(10)             /*資料所有者                             */
);

alter table lna_file add constraint lna_pk primary key  (lna01) deferrable initially deferred;
grant select on lna_file to tiptopgp;
grant update on lna_file to tiptopgp;
grant delete on lna_file to tiptopgp;
grant insert on lna_file to tiptopgp;
grant references on lna_file to tiptopgp;
grant references on lna_file to ods;
grant select on lna_file to ods;
