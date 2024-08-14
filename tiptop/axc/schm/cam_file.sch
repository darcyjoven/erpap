/*
================================================================================
檔案代號:cam_file
檔案名稱:每日投入工時單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cam_file
(
cam01       datetime NOT NULL,       /*日期                                   */
cam012      nvarchar(10),
cam02       nvarchar(10) NOT NULL,   /*成本中心                               */
cam03       smallint NOT NULL,       /*序號                                   */
cam04       nvarchar(20),            /*工單編號                               */
cam05       nvarchar(19),            /*RUN CARD                               */
cam06       smallint,                /*製程序                                 */
cam07       decimal(15,3),           /*約當數量                               */
cam08       decimal(15,3),           /*投入工時                               */
cam09       nvarchar(255),           /*備註                                   */
cam10       decimal(15,3),           /*投入標準人工工時                       */
cam11       decimal(15,3),           /*投入標準機器工時                       */
camlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
camud01     nvarchar(255),           /*自訂欄位-Textedit                      */
camud02     nvarchar(40),            /*自訂欄位-文字                          */
camud03     nvarchar(40),            /*自訂欄位-文字                          */
camud04     nvarchar(40),            /*自訂欄位-文字                          */
camud05     nvarchar(40),            /*自訂欄位-文字                          */
camud06     nvarchar(40),            /*自訂欄位-文字                          */
camud07     decimal(15,3),           /*自訂欄位-數值                          */
camud08     decimal(15,3),           /*自訂欄位-數值                          */
camud09     decimal(15,3),           /*自訂欄位-數值                          */
camud10     integer,                 /*自訂欄位-整數                          */
camud11     integer,                 /*自訂欄位-整數                          */
camud12     integer,                 /*自訂欄位-整數                          */
camud13     datetime,                /*自訂欄位-日期                          */
camud14     datetime,                /*自訂欄位-日期                          */
camud15     datetime                 /*自訂欄位-日期                          */
);

create        index cam_02 on cam_file (cam04);
alter table cam_file add constraint cam_pk primary key  (cam01,cam02,cam03);
grant select on cam_file to tiptopgp;
grant update on cam_file to tiptopgp;
grant delete on cam_file to tiptopgp;
grant insert on cam_file to tiptopgp;
grant references on cam_file to tiptopgp;
grant references on cam_file to ods;
grant select on cam_file to ods;
