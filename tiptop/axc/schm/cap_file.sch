/*
================================================================================
檔案代號:cap_file
檔案名稱:暫估差异明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cap_file
(
cap01       smallint DEFAULT 0 NOT NULL, /*年度*/
cap02       smallint DEFAULT 0 NOT NULL, /*月份*/
cap03       nvarchar(40) DEFAULT ' ' NOT NULL, /*產品編號*/
cap04       nvarchar(20) DEFAULT ' ' NOT NULL, /*應付賬款單號*/
cap05       smallint DEFAULT 0 NOT NULL, /*應付賬款項次*/
cap06       nvarchar(20),            /*暫估單                                 */
cap07       smallint,                /*暫估項次                               */
cap08       nvarchar(20),            /*入庫單                                 */
cap09       smallint,                /*入庫項次                               */
cap10       decimal(20,6),           /*原幣應付本幣                           */
cap11       decimal(20,6),           /*原幣暫估本幣                           */
cap12       decimal(20,10),          /*當月匯率                               */
cap13       decimal(15,3),           /*入庫數量                               */
cap14       decimal(20,10),          /*重估匯率                               */
cap15       nvarchar(1),             /*處理狀態                               */
cap16       nvarchar(10),            /*處理人員                               */
cap17       datetime,                /*處理日期                               */
cap18       decimal(20,6) DEFAULT '0' NOT NULL, /*發票單價*/
cap19       decimal(20,6) DEFAULT '0' NOT NULL /*暫估單價*/
);

alter table cap_file add constraint cap_pk primary key  (cap01,cap02,cap03,cap04,cap05);
grant select on cap_file to tiptopgp;
grant update on cap_file to tiptopgp;
grant delete on cap_file to tiptopgp;
grant insert on cap_file to tiptopgp;
grant references on cap_file to tiptopgp;
grant references on cap_file to ods;
grant select on cap_file to ods;
