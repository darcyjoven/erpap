/*
================================================================================
檔案代號:all_file
檔案名稱:預付購料採購單身歷次修改歷史記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table all_file
(
all00       nvarchar(1) NOT NULL,    /*修改次數                               */
                                     /*修改次數 (95/11/10 By Roger)     95/11 */
all01       nvarchar(20) NOT NULL,   /*L/C No                                 */
                                     /*L/C No  95/11                          */
all02       smallint NOT NULL,       /*序號                                   */
all04       nvarchar(20),            /*採購單號                               */
all05       smallint,                /*採購單項次                             */
all06       decimal(20,6),           /*單價                                   */
all07       decimal(15,3),           /*數量                                   */
all08       decimal(20,6),           /*金額                                   */
all11       nvarchar(40),            /*採購料號                               */
all12       decimal(15,3),           /*已到貨數量                             */
                                     /*已到貨數量      99/05/10 modify        */
all13       decimal(20,6),           /*已到貨金額                             */
                                     /*已到貨金額      99/05/10 modify        */
all44       nvarchar(10),            /*資料來源營運中心                       */
all80       nvarchar(4),             /*單位一                                 */
all81       decimal(20,8),           /*單位一換算率(與庫存單位)               */
all82       decimal(15,3),           /*單位一數量                             */
all83       nvarchar(4),             /*單位二                                 */
all84       decimal(20,8),           /*單位二換算率(與庫存單位)               */
all85       decimal(15,3),           /*單位二數量                             */
all86       nvarchar(4),             /*計價單位                               */
all87       decimal(15,3),           /*計價數量                               */
all930      nvarchar(10),            /*成本中心                               */
alllegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
allud01     nvarchar(255),           /*自訂欄位-Textedit                      */
allud02     nvarchar(40),            /*自訂欄位-文字                          */
allud03     nvarchar(40),            /*自訂欄位-文字                          */
allud04     nvarchar(40),            /*自訂欄位-文字                          */
allud05     nvarchar(40),            /*自訂欄位-文字                          */
allud06     nvarchar(40),            /*自訂欄位-文字                          */
allud07     decimal(15,3),           /*自訂欄位-數值                          */
allud08     decimal(15,3),           /*自訂欄位-數值                          */
allud09     decimal(15,3),           /*自訂欄位-數值                          */
allud10     integer,                 /*自訂欄位-整數                          */
allud11     integer,                 /*自訂欄位-整數                          */
allud12     integer,                 /*自訂欄位-整數                          */
allud13     datetime,                /*自訂欄位-日期                          */
allud14     datetime,                /*自訂欄位-日期                          */
allud15     datetime                 /*自訂欄位-日期                          */
);

alter table all_file add constraint all_pk primary key  (all00,all01,all02);
grant select on all_file to tiptopgp;
grant update on all_file to tiptopgp;
grant delete on all_file to tiptopgp;
grant insert on all_file to tiptopgp;
grant references on all_file to tiptopgp;
grant references on all_file to ods;
grant select on all_file to ods;
