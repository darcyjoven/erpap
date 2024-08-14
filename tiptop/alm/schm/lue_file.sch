/*
================================================================================
檔案代號:lue_file
檔案名稱:正式商戶變更資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lue_file
(
lue01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商戶號*/
lue02       nvarchar(20) DEFAULT ' ' NOT NULL, /*版本號*/
lue03       nvarchar(10),            /*潛在商戶單號                           */
lue04       nvarchar(10),            /*來源門店編號                           */
lue05       nvarchar(20),            /*商戶簡稱                               */
lue06       nvarchar(50),            /*商戶全稱                               */
lue07       nvarchar(1) DEFAULT ' ' NOT NULL, /*企業性質*/
lue08       nvarchar(10),            /*主品牌                                 */
lue09       nvarchar(10),            /*產地編號                               */
lue10       nvarchar(60),            /*經營範圍                               */
lue11       nvarchar(10),            /*no use                                 */
lue12       nvarchar(10),            /*總經理                                 */
lue13       nvarchar(20),            /*總經理電話                             */
lue14       nvarchar(10),            /*銷售負責人                             */
lue15       nvarchar(20),            /*負責人電話                             */
lue16       nvarchar(10),            /*法人代表                               */
lue17       nvarchar(20),            /*代表電話                               */
lue18       nvarchar(10),            /*經營人                                 */
lue19       nvarchar(20),            /*經營人電話                             */
lue20       nvarchar(30),            /*電子信箱                               */
lue21       nvarchar(30),            /*公司網站                               */
lue22       nvarchar(20),            /*傳真                                   */
lue23       nvarchar(20),            /*代理登記                               */
lue24       decimal(18) DEFAULT '0' NOT NULL, /*擬租面積*/
lue25       nvarchar(50),            /*營業執照                               */
lue26       nvarchar(50),            /*稅務登記證                             */
lue27       nvarchar(1) DEFAULT ' ' NOT NULL, /*繳納質保金*/
lue28       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營形態*/
lue29       decimal(18) DEFAULT '0' NOT NULL, /*注冊資金*/
lue30       nvarchar(20),            /*營運中心代碼證                         */
lue31       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否戰盟*/
lue32       decimal(18) DEFAULT '0' NOT NULL, /*當前門店數*/
lue33       decimal(18) DEFAULT '0' NOT NULL, /*當前攤位數*/
lue34       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
lue35       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lue36       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lue37       nvarchar(10),            /*確認人                                 */
lue38       datetime,                /*確認日期                               */
lue39       nvarchar(50),            /*備注                                   */
lue40       nvarchar(4),             /*稅種                                   */
lue41       nvarchar(10),            /*發票種類                               */
lue42       nvarchar(6),             /*收款條件                               */
lue43       nvarchar(10),            /*聯系人姓名                             */
lue44       nvarchar(20),            /*聯系人電話                             */
lue45       nvarchar(20),            /*聯系人郵箱                             */
lue46       nvarchar(20),            /*郵寄郵編                               */
lue47       nvarchar(80),            /*郵寄地址                               */
lue48       nvarchar(20),            /*發票郵編                               */
lue49       nvarchar(80),            /*發票地址                               */
lue50       nvarchar(30),            /*銀行編號                               */
lue51       nvarchar(30),            /*銀行名稱                               */
lue52       nvarchar(30),            /*銀行賬號                               */
lue53       nvarchar(30),            /*銀行戶名                               */
lue54       nvarchar(50),            /*備注                                   */
lue55       nvarchar(1) DEFAULT ' ' NOT NULL, /*變更發出*/
lue56       nvarchar(30),            /*法人身份證                             */
lue57       nvarchar(10),            /*慣用科目類型                           */
lue58       nvarchar(4),             /*慣用幣種                               */
lue59       nvarchar(1) DEFAULT ' ' NOT NULL, /*保留小數位*/
lue60       nvarchar(1) DEFAULT ' ' NOT NULL, /*四證審核否*/
lue61       nvarchar(10),            /*所屬營運中心                           */
lue62       nvarchar(10),            /*商戶客戶類別                           */
lue63       nvarchar(1) DEFAULT '1' NOT NULL, /*商戶客戶性質*/
lue64       nvarchar(10),            /*商戶收款客戶                           */
lue65       nvarchar(10),            /*商戶送貨客戶                           */
lue66       nvarchar(1) DEFAULT ' ' NOT NULL, /*慣用語言*/
luecrat     datetime,                /*資料創建日                             */
luedate     datetime,                /*最近修改日                             */
luegrup     nvarchar(10),            /*資料所有群                             */
luemodu     nvarchar(10),            /*資料修改者                             */
lueorig     nvarchar(10),            /*資料建立部門                           */
lueoriu     nvarchar(10),            /*資料建立者                             */
lueuser     nvarchar(10)             /*資料所有者                             */
);

alter table lue_file add constraint lue_pk primary key  (lue01,lue02) deferrable initially deferred;
grant select on lue_file to tiptopgp;
grant update on lue_file to tiptopgp;
grant delete on lue_file to tiptopgp;
grant insert on lue_file to tiptopgp;
grant references on lue_file to tiptopgp;
grant references on lue_file to ods;
grant select on lue_file to ods;
