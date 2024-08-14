/*
================================================================================
檔案代號:pnf_file
檔案名稱:請購變更單身
檔案目的:
上游檔案:pne_file
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnf_file
(
pnf01       nvarchar(20) DEFAULT ' ' NOT NULL, /*請購單號*/
pnf02       smallint DEFAULT 0 NOT NULL, /*變更序號*/
pnf03       smallint DEFAULT 0 NOT NULL, /*請購單項次*/
pnf041a     nvarchar(120),           /*變更後品名規格                         */
pnf041b     nvarchar(120),           /*變更前品名規格                         */
pnf04a      nvarchar(40),            /*變更後料號                             */
pnf04b      nvarchar(40),            /*變更前料號                             */
pnf07a      nvarchar(4),             /*變更後請購單位                         */
pnf07b      nvarchar(4),             /*變更前請購單位                         */
pnf121a     nvarchar(30),            /*變更後WBS編碼                          */
pnf121b     nvarchar(30),            /*變更前WBS編碼                          */
pnf122a     nvarchar(4),             /*變更後活動代號                         */
pnf122b     nvarchar(4),             /*變更前活動代號                         */
pnf12a      nvarchar(10),            /*變更後專案代號                         */
pnf12b      nvarchar(10),            /*變更前專案代號                         */
pnf20a      decimal(15,3),           /*變更後訂購量                           */
pnf20b      decimal(15,3),           /*變更前訂購量                           */
pnf33a      datetime,                /*變更後原始交貨日期                     */
pnf33b      datetime,                /*變更前原始交貨日期                     */
pnf41a      nvarchar(20),            /*變更後PLP-NO.                          */
pnf41b      nvarchar(20),            /*變更前PLP-NO.                          */
pnf50       nvarchar(255),           /*備註                                   */
pnf80a      nvarchar(4),             /*變更後單位一                           */
pnf80b      nvarchar(4),             /*變更前單位一                           */
pnf81a      decimal(20,8),           /*變更后單位一換算率(與採購單            */
pnf81b      decimal(20,8),           /*變更前單位一換算率(與採購單            */
pnf82a      decimal(15,3),           /*變更後單位一數量                       */
pnf82b      decimal(15,3),           /*變更前單位一數量                       */
pnf83a      nvarchar(4),             /*變更後單位二                           */
pnf83b      nvarchar(4),             /*變更前單位二                           */
pnf84a      decimal(20,8),           /*變更后單位二換算率(與採購單            */
pnf84b      decimal(20,8),           /*變更前單位二換算率(與採購單            */
pnf85a      decimal(15,3),           /*變更後單位二數量                       */
pnf85b      decimal(15,3),           /*變更前單位二數量                       */
pnf86a      nvarchar(4),             /*變更後計價單位                         */
pnf86b      nvarchar(4),             /*變更前計價單位                         */
pnf87a      decimal(15,3),           /*變更後計價數量                         */
pnf87b      decimal(15,3),           /*變更前計價數量                         */
pnflegal    nvarchar(10),            /*所屬法人                               */
pnfplant    nvarchar(10),            /*所屬工廠                               */
pnfud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pnfud02     nvarchar(40),            /*自訂欄位-文字                          */
pnfud03     nvarchar(40),            /*自訂欄位-文字                          */
pnfud04     nvarchar(40),            /*自訂欄位-文字                          */
pnfud05     nvarchar(40),            /*自訂欄位-文字                          */
pnfud06     nvarchar(40),            /*自訂欄位-文字                          */
pnfud07     decimal(15,3),           /*自訂欄位-數值                          */
pnfud08     decimal(15,3),           /*自訂欄位-數值                          */
pnfud09     decimal(15,3),           /*自訂欄位-數值                          */
pnfud10     integer,                 /*自訂欄位-整數                          */
pnfud11     integer,                 /*自訂欄位-整數                          */
pnfud12     integer,                 /*自訂欄位-整數                          */
pnfud13     datetime,                /*自訂欄位-日期                          */
pnfud14     datetime,                /*自訂欄位-日期                          */
pnfud15     datetime                 /*自訂欄位-日期                          */
);

alter table pnf_file add constraint pnf_pk primary key  (pnf01,pnf02,pnf03);
grant select on pnf_file to tiptopgp;
grant update on pnf_file to tiptopgp;
grant delete on pnf_file to tiptopgp;
grant insert on pnf_file to tiptopgp;
grant references on pnf_file to tiptopgp;
grant references on pnf_file to ods;
grant select on pnf_file to ods;
