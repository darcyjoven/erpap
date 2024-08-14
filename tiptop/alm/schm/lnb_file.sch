/*
================================================================================
檔案代號:lnb_file
檔案名稱:潛在商戶資料登記檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnb_file
(
lnb01       nvarchar(10) DEFAULT ' ' NOT NULL, /*潛在商戶單號*/
lnb02       nvarchar(20),            /*預登記單號                             */
lnb03       nvarchar(10),            /*來源門店編號                           */
lnb04       nvarchar(10),            /*商戶號                                 */
lnb05       nvarchar(20),            /*商戶簡稱                               */
lnb06       nvarchar(50),            /*商戶全稱                               */
lnb07       nvarchar(1) DEFAULT ' ' NOT NULL, /*企業性質*/
lnb08       nvarchar(10),            /*主品牌                                 */
lnb09       nvarchar(10),            /*產地                                   */
lnb10       nvarchar(60),            /*經營範圍                               */
lnb11       nvarchar(10),            /*no use                                 */
lnb12       nvarchar(10),            /*總經理                                 */
lnb13       nvarchar(20),            /*總經理電話                             */
lnb14       nvarchar(10),            /*營銷負責人                             */
lnb15       nvarchar(20),            /*負責人電話                             */
lnb16       nvarchar(10),            /*法人代表                               */
lnb17       nvarchar(20),            /*代表電話                               */
lnb18       nvarchar(10),            /*經營人                                 */
lnb19       nvarchar(20),            /*經營人電話                             */
lnb20       nvarchar(30),            /*電子信箱                               */
lnb21       nvarchar(30),            /*公司網站                               */
lnb22       nvarchar(20),            /*傳真                                   */
lnb23       nvarchar(20),            /*代理登記                               */
lnb24       decimal(18) DEFAULT '0' NOT NULL, /*擬租面積*/
lnb25       nvarchar(50),            /*營業執照                               */
lnb26       nvarchar(50),            /*稅務登記證                             */
lnb27       nvarchar(1) DEFAULT ' ' NOT NULL, /*繳納質保金*/
lnb28       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營形態*/
lnb29       decimal(18) DEFAULT '0' NOT NULL, /*註冊資金*/
lnb30       nvarchar(20),            /*營運中心代碼證                         */
lnb31       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
lnb32       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lnb33       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lnb34       nvarchar(10),            /*確認人                                 */
lnb35       datetime,                /*審核日期                               */
lnb36       nvarchar(50),            /*備註                                   */
lnb37       nvarchar(4),             /*稅種                                   */
lnb38       nvarchar(4),             /*發票種類                               */
lnb39       nvarchar(6),             /*收款條件                               */
lnb40       nvarchar(10),            /*聯繫人姓名                             */
lnb41       nvarchar(20),            /*聯繫人電話                             */
lnb42       nvarchar(30),            /*聯繫人信箱                             */
lnb43       nvarchar(20),            /*郵寄郵編                               */
lnb44       nvarchar(80),            /*郵寄地址                               */
lnb45       nvarchar(20),            /*發票郵編                               */
lnb46       nvarchar(80),            /*發票地址                               */
lnb47       nvarchar(30),            /*銀行編號                               */
lnb48       nvarchar(30),            /*銀行名稱                               */
lnb49       nvarchar(30),            /*銀行帳號                               */
lnb50       nvarchar(30),            /*銀行戶名                               */
lnb51       nvarchar(50),            /*備註                                   */
lnb52       nvarchar(10),            /*慣用科目類型                           */
lnb53       nvarchar(4),             /*幣種                                   */
lnbcrat     datetime,                /*資料創建日                             */
lnbdate     datetime,                /*最近更改日                             */
lnbgrup     nvarchar(10),            /*資料所有群                             */
lnbmodu     nvarchar(10),            /*資料更改者                             */
lnborig     nvarchar(10),            /*資料建立部門                           */
lnboriu     nvarchar(10),            /*資料建立者                             */
lnbuser     nvarchar(10)             /*資料所有者                             */
);

alter table lnb_file add constraint lnb_pk primary key  (lnb01) deferrable initially deferred;
grant select on lnb_file to tiptopgp;
grant update on lnb_file to tiptopgp;
grant delete on lnb_file to tiptopgp;
grant insert on lnb_file to tiptopgp;
grant references on lnb_file to tiptopgp;
grant references on lnb_file to ods;
grant select on lnb_file to ods;
