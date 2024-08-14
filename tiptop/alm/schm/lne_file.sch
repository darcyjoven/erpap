/*
================================================================================
檔案代號:lne_file
檔案名稱:正式商戶資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lne_file
(
lne01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lne02       nvarchar(20),            /*版本號                                 */
lne03       nvarchar(10),            /*潛在商戶單號                           */
lne04       nvarchar(10),            /*來源門店編號                           */
lne05       nvarchar(20),            /*商戶簡稱                               */
lne06       nvarchar(50),            /*商戶全稱                               */
lne07       nvarchar(1) DEFAULT ' ' NOT NULL, /*企業性質*/
lne08       nvarchar(10),            /*主品牌                                 */
lne09       nvarchar(10),            /*產地                                   */
lne10       nvarchar(60),            /*經營範圍                               */
lne11       nvarchar(10),            /*no use                                 */
lne12       nvarchar(10),            /*總經理                                 */
lne13       nvarchar(20),            /*總經理電話                             */
lne14       nvarchar(10),            /*營銷負責人                             */
lne15       nvarchar(20),            /*負責人電話                             */
lne16       nvarchar(10),            /*法人代表                               */
lne17       nvarchar(20),            /*代表電話                               */
lne18       nvarchar(10),            /*經營人                                 */
lne19       nvarchar(20),            /*經營人電話                             */
lne20       nvarchar(30),            /*電子信箱                               */
lne21       nvarchar(30),            /*公司網站                               */
lne22       nvarchar(20),            /*傳真                                   */
lne23       nvarchar(20),            /*代理登記                               */
lne24       decimal(18) DEFAULT '0' NOT NULL, /*擬租面積*/
lne25       nvarchar(50),            /*營業執照                               */
lne26       nvarchar(50),            /*稅務登記證                             */
lne27       nvarchar(1) DEFAULT ' ' NOT NULL, /*繳納質保金*/
lne28       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營形態*/
lne29       decimal(18) DEFAULT '0' NOT NULL, /*註冊資金*/
lne30       nvarchar(20),            /*營運中心代碼證                         */
lne31       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否戰盟*/
lne32       decimal(18) DEFAULT '0' NOT NULL, /*當前門店數*/
lne33       decimal(18) DEFAULT '0' NOT NULL, /*當前攤位數*/
lne34       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
lne35       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lne36       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lne37       nvarchar(10),            /*確認人                                 */
lne38       datetime,                /*確認日期                               */
lne39       nvarchar(50),            /*備註                                   */
lne40       nvarchar(4),             /*稅種                                   */
lne41       nvarchar(4),             /*發票種類                               */
lne42       nvarchar(6),             /*收款條件                               */
lne43       nvarchar(10),            /*聯繫人姓名                             */
lne44       nvarchar(20),            /*聯繫人電話                             */
lne45       nvarchar(20),            /*聯繫人郵箱                             */
lne46       nvarchar(20),            /*郵寄編號                               */
lne47       nvarchar(80),            /*郵寄地址                               */
lne48       nvarchar(20),            /*發票郵編                               */
lne49       nvarchar(80),            /*發票地址                               */
lne50       nvarchar(30),            /*銀行編號                               */
lne51       nvarchar(30),            /*銀行名稱                               */
lne52       nvarchar(30),            /*銀行帳號                               */
lne53       nvarchar(30),            /*銀行戶名                               */
lne54       nvarchar(50),            /*備註                                   */
lne55       nvarchar(30),            /*法人身份證                             */
lne56       nvarchar(10),            /*慣用科目類型                           */
lne57       nvarchar(4),             /*慣用幣種                               */
lne58       nvarchar(1),             /*保留小數位                             */
lne59       nvarchar(1),             /*四證審核否                             */
lne61       nvarchar(10),            /*所屬營運中心                           */
lne62       nvarchar(10),            /*商戶客戶類別                           */
lne63       nvarchar(1) DEFAULT '1' NOT NULL, /*商戶客戶性質*/
lne64       nvarchar(10),            /*商戶收款客戶                           */
lne65       nvarchar(10),            /*商戶送貨客戶                           */
lne66       nvarchar(1) DEFAULT ' ' NOT NULL, /*慣用語言*/
lnecrat     datetime,                /*資料創建日                             */
lnedate     datetime,                /*最近更改日                             */
lnegrup     nvarchar(10),            /*資料所有群                             */
lnemodu     nvarchar(10),            /*資料修改者                             */
lneorig     nvarchar(10),            /*資料建立部門                           */
lneoriu     nvarchar(10),            /*資料建立者                             */
lneuser     nvarchar(10)             /*資料所有者                             */
);

alter table lne_file add constraint lne_pk primary key  (lne01) deferrable initially deferred;
grant select on lne_file to tiptopgp;
grant update on lne_file to tiptopgp;
grant delete on lne_file to tiptopgp;
grant insert on lne_file to tiptopgp;
grant references on lne_file to tiptopgp;
grant references on lne_file to ods;
grant select on lne_file to ods;
