/*
================================================================================
檔案代號:pnb_file
檔案名稱:採購變更單身頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnb_file
(
pnb01       nvarchar(20) NOT NULL,   /*採購單號                               */
pnb02       smallint NOT NULL,       /*變更序號                               */
pnb03       smallint NOT NULL,       /*採購單項次                             */
pnb041a     nvarchar(120),           /*變更後品名規格                         */
pnb041b     nvarchar(120),           /*變更前品名規格                         */
pnb04a      nvarchar(40),            /*變更後料號                             */
pnb04b      nvarchar(40),            /*變更前料號                             */
pnb07a      nvarchar(4),             /*變更後採購單位                         */
pnb07b      nvarchar(4),             /*變更前採購單位                         */
pnb20a      decimal(18),             /*變更後訂購量                           */
pnb20b      decimal(18),             /*變更前訂購量                           */
pnb31a      decimal(18),             /*變更後未稅單價                         */
                                     /*變更後單價                             */
pnb31b      decimal(18),             /*變更前未稅單價                         */
                                     /*變更前單價                             */
pnb32a      decimal(18),             /*變更後含稅單價                         */
pnb32b      decimal(18),             /*變更前含稅單價                         */
pnb33a      datetime,                /*變更後原始交貨日期                     */
pnb33b      datetime,                /*變更前原始交貨日期                     */
pnb34a      nvarchar(10),            /*變更后專案代號                         */
pnb34b      nvarchar(10),            /*變更前專案代號                         */
pnb35a      nvarchar(30),            /*變更后WBS編碼                          */
pnb35b      nvarchar(30),            /*變更前WBS編碼                          */
pnb36a      nvarchar(4),             /*變更后活動代號                         */
pnb36b      nvarchar(4),             /*變更前活動代號                         */
pnb50       nvarchar(255),           /*備註                                   */
pnb51       nvarchar(1),             /*No Use                                 */
pnb80a      nvarchar(4),             /*變更后單位一                           */
pnb80b      nvarchar(4),             /*變更前單位一                           */
pnb81a      decimal(18),             /*變更後單位一換算率(與採購單            */
pnb81b      decimal(18),             /*變更前單位一換算率(與採購單            */
pnb82a      decimal(18),             /*變更后單位一數量                       */
pnb82b      decimal(18),             /*變更前單位一數量                       */
pnb83a      nvarchar(4),             /*變更后單位二                           */
pnb83b      nvarchar(4),             /*變更前單位二                           */
pnb84a      decimal(18),             /*變更後單位二換算率(與採購單            */
pnb84b      decimal(18),             /*變更前單位二換算率(與採購單            */
pnb85a      decimal(18),             /*變更后單位二數量                       */
pnb85b      decimal(18),             /*變更前單位二數量                       */
pnb86a      nvarchar(4),             /*變更后計價單位                         */
pnb86b      nvarchar(4),             /*變更前計價單位                         */
pnb87a      decimal(18),             /*變更后計價數量                         */
pnb87b      decimal(18),             /*變更前計價數量                         */
pnb90       nvarchar(20),            /*請購單號                               */
pnb91       smallint,                /*請購單項次                             */
pnblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pnbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
pnbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pnbud02     nvarchar(40),            /*自訂欄位-文字                          */
pnbud03     nvarchar(40),            /*自訂欄位-文字                          */
pnbud04     nvarchar(40),            /*自訂欄位-文字                          */
pnbud05     nvarchar(40),            /*自訂欄位-文字                          */
pnbud06     nvarchar(40),            /*自訂欄位-文字                          */
pnbud07     decimal(18),             /*自訂欄位-數值                          */
pnbud08     decimal(18),             /*自訂欄位-數值                          */
pnbud09     decimal(18),             /*自訂欄位-數值                          */
pnbud10     integer,                 /*自訂欄位-整數                          */
pnbud11     integer,                 /*自訂欄位-整數                          */
pnbud12     integer,                 /*自訂欄位-整數                          */
pnbud13     datetime,                /*自訂欄位-日期                          */
pnbud14     datetime,                /*自訂欄位-日期                          */
pnbud15     datetime                 /*自訂欄位-日期                          */
);

create        index pnbplant_idx on pnb_file (pnbplant);
alter table pnb_file add constraint pnb_pk primary key  (pnb01,pnb02,pnb03);
grant select on pnb_file to tiptopgp;
grant update on pnb_file to tiptopgp;
grant delete on pnb_file to tiptopgp;
grant insert on pnb_file to tiptopgp;
grant references on pnb_file to tiptopgp;
grant references on pnb_file to ods;
grant select on pnb_file to ods;
