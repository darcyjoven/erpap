/*
================================================================================
檔案代號:pne_file
檔案名稱:請購變更單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pne_file
(
pne01       nvarchar(20) DEFAULT ' ' NOT NULL, /*請購單號*/
pne02       smallint DEFAULT 0 NOT NULL, /*變更序號*/
pne03       datetime,                /*變更日期                               */
pne04       nvarchar(10),            /*變更理由碼                             */
pne05       nvarchar(10),            /*變更人員                               */
pne06       nvarchar(1) DEFAULT 'N' NOT NULL, /*确認否*/
pne09       nvarchar(4),             /*變更前幣別                             */
pne09b      nvarchar(4),             /*變更后幣別                             */
pne10       nvarchar(10),            /*變更前付款條件                         */
pne10b      nvarchar(10),            /*變更后付款條件                         */
pne11       nvarchar(6),             /*變更前价格條件                         */
pne11b      nvarchar(6),             /*變更后价格條件                         */
pne12       nvarchar(10),            /*變更前送貨地址                         */
pne12b      nvarchar(10),            /*變更后送貨地址                         */
pne13       nvarchar(10),            /*變更前帳單地址                         */
pne13b      nvarchar(10),            /*變更后帳單地址                         */
pne14       nvarchar(1) DEFAULT '0' NOT NULL, /*狀況碼*/
pneacti     nvarchar(1) DEFAULT 'Y' NOT NULL, /*資料有效碼*/
pnedate     datetime,                /*最近修改日                             */
pnegrup     nvarchar(10),            /*資料所有群                             */
pnelegal    nvarchar(10),            /*所屬法人                               */
pnemksg     nvarchar(1) DEFAULT 'N' NOT NULL, /*簽核否*/
pnemodu     nvarchar(10),            /*資料更改者                             */
pneorig     nvarchar(10),            /*資料建立部門                           */
pneoriu     nvarchar(10),            /*資料建立者                             */
pneplant    nvarchar(10),            /*所屬工廠                               */
pneud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pneud02     nvarchar(40),            /*自訂欄位-文字                          */
pneud03     nvarchar(40),            /*自訂欄位-文字                          */
pneud04     nvarchar(40),            /*自訂欄位-文字                          */
pneud05     nvarchar(40),            /*自訂欄位-文字                          */
pneud06     nvarchar(40),            /*自訂欄位-文字                          */
pneud07     decimal(15,3),           /*自訂欄位-數值                          */
pneud08     decimal(15,3),           /*自訂欄位-數值                          */
pneud09     decimal(15,3),           /*自訂欄位-數值                          */
pneud10     integer,                 /*自訂欄位-整數                          */
pneud11     integer,                 /*自訂欄位-整數                          */
pneud12     integer,                 /*自訂欄位-整數                          */
pneud13     datetime,                /*自訂欄位-日期                          */
pneud14     datetime,                /*自訂欄位-日期                          */
pneud15     datetime,                /*自訂欄位-日期                          */
pneuser     nvarchar(10)             /*資料所有者                             */
);

alter table pne_file add constraint pne_pk primary key  (pne01,pne02);
grant select on pne_file to tiptopgp;
grant update on pne_file to tiptopgp;
grant delete on pne_file to tiptopgp;
grant insert on pne_file to tiptopgp;
grant references on pne_file to tiptopgp;
grant references on pne_file to ods;
grant select on pne_file to ods;
