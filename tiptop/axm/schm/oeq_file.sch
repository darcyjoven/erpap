/*
================================================================================
檔案代號:oeq_file
檔案名稱:訂單變更單單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeq_file
(
oeq01       nvarchar(20) NOT NULL,   /*訂單單號                               */
oeq02       smallint NOT NULL,       /*變更序號                               */
oeq03       smallint NOT NULL,       /*訂單項次                               */
oeq041a     nvarchar(120),           /*變更後品名規格                         */
oeq041b     nvarchar(120),           /*變更前品名規格                         */
oeq04a      nvarchar(40),            /*變更後料號                             */
oeq04b      nvarchar(40),            /*變更前料號                             */
oeq05a      nvarchar(4),             /*變更後訂單單位                         */
oeq05b      nvarchar(4),             /*變更前訂單單位                         */
oeq12a      decimal(18),             /*變更後訂購量                           */
oeq12b      decimal(18),             /*變更前數量                             */
oeq13a      decimal(18),             /*變更後單價                             */
oeq13b      decimal(18),             /*變更前單價                             */
oeq14a      decimal(18),             /*變更後未稅金額                         */
oeq14b      decimal(18),             /*變更前未稅金額                         */
oeq14ta     decimal(18),             /*變更後含稅金額                         */
oeq14tb     decimal(18),             /*變更前含稅金額                         */
oeq15a      datetime,                /*變更後原始交貨日期                     */
oeq15b      datetime,                /*變更前原始交貨日期                     */
oeq20a      nvarchar(4),             /*變更后單位一                           */
oeq20b      nvarchar(4),             /*變更前單位一                           */
oeq21a      decimal(18),             /*變更後單位一轉換率(與銷售單            */
oeq21b      decimal(18),             /*變更前單位一轉換率(與銷售單            */
oeq22a      decimal(18),             /*變更后單位一數量                       */
oeq22b      decimal(18),             /*變更前單位一數量                       */
oeq23a      nvarchar(4),             /*變更后單位二                           */
oeq23b      nvarchar(4),             /*變更前單位二                           */
oeq24a      decimal(18),             /*變更後單位二轉換率(與銷售單            */
oeq24b      decimal(18),             /*變更前單位二轉換率(與銷售單            */
oeq25a      decimal(18),             /*變更后單位二數量                       */
oeq25b      decimal(18),             /*變更前單位二數量                       */
oeq26a      nvarchar(4),             /*變更后計價單位                         */
oeq26b      nvarchar(4),             /*變更前計價單位                         */
oeq27a      decimal(18),             /*變更后計價數量                         */
oeq27b      decimal(18),             /*變更前計價數量                         */
oeq28a      datetime,                /*變更後預計歸還日                       */
oeq28b      datetime,                /*變更前預計歸還日                       */
oeq29a      nvarchar(10),            /*變更後展延原因碼                       */
oeq29b      nvarchar(10),            /*變更前展延原因碼                       */
oeq30a      nvarchar(10),            /*變更後原因碼                           */
oeq30b      nvarchar(10),            /*變更前原因碼                           */
oeq31a      nvarchar(10),            /*變更後專案代號                         */
oeq31b      nvarchar(10),            /*變更前專案代號                         */
oeq32a      nvarchar(30),            /*變更後WBS編碼                          */
oeq32b      nvarchar(30),            /*變更前WBS編碼                          */
oeq33a      nvarchar(4),             /*變更後活動代號                         */
oeq33b      nvarchar(4),             /*變更前活動代號                         */
oeq50       nvarchar(255),           /*備註                                   */
oeqlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oeqplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oequd01     nvarchar(255),           /*自訂欄位-Textedit                      */
oequd02     nvarchar(40),            /*自訂欄位-文字                          */
oequd03     nvarchar(40),            /*自訂欄位-文字                          */
oequd04     nvarchar(40),            /*自訂欄位-文字                          */
oequd05     nvarchar(40),            /*自訂欄位-文字                          */
oequd06     nvarchar(40),            /*自訂欄位-文字                          */
oequd07     decimal(18),             /*自訂欄位-數值                          */
oequd08     decimal(18),             /*自訂欄位-數值                          */
oequd09     decimal(18),             /*自訂欄位-數值                          */
oequd10     integer,                 /*自訂欄位-整數                          */
oequd11     integer,                 /*自訂欄位-整數                          */
oequd12     integer,                 /*自訂欄位-整數                          */
oequd13     datetime,                /*自訂欄位-日期                          */
oequd14     datetime,                /*自訂欄位-日期                          */
oequd15     datetime                 /*自訂欄位-日期                          */
);

create        index oeqplant_idx on oeq_file (oeqplant);
alter table oeq_file add constraint oeq_pk primary key  (oeq01,oeq02,oeq03);
grant select on oeq_file to tiptopgp;
grant update on oeq_file to tiptopgp;
grant delete on oeq_file to tiptopgp;
grant insert on oeq_file to tiptopgp;
grant references on oeq_file to tiptopgp;
grant references on oeq_file to ods;
grant select on oeq_file to ods;
