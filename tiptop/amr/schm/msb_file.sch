/*
================================================================================
檔案代號:msb_file
檔案名稱:MPS 計劃單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msb_file
(
msb01       nvarchar(20) NOT NULL,   /*MPS 計劃編號                           */
msb02       smallint NOT NULL,       /*項次                                   */
msb03       nvarchar(40),            /*料號                                   */
msb04       datetime,                /*預計生產完工日期                       */
msb05       decimal(18),             /*數量                                   */
msb06       nvarchar(40),            /*主料料號                               */
msb07       datetime,                /*BOM 有效日期                           */
msb08       decimal(18),             /*原始計劃數量                           */
msb919      nvarchar(50),            /*計畫批號                               */
msblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
msbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
msbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
msbud02     nvarchar(40),            /*自訂欄位-文字                          */
msbud03     nvarchar(40),            /*自訂欄位-文字                          */
msbud04     nvarchar(40),            /*自訂欄位-文字                          */
msbud05     nvarchar(40),            /*自訂欄位-文字                          */
msbud06     nvarchar(40),            /*自訂欄位-文字                          */
msbud07     decimal(18),             /*自訂欄位-數值                          */
msbud08     decimal(18),             /*自訂欄位-數值                          */
msbud09     decimal(18),             /*自訂欄位-數值                          */
msbud10     integer,                 /*自訂欄位-整數                          */
msbud11     integer,                 /*自訂欄位-整數                          */
msbud12     integer,                 /*自訂欄位-整數                          */
msbud13     datetime,                /*自訂欄位-日期                          */
msbud14     datetime,                /*自訂欄位-日期                          */
msbud15     datetime                 /*自訂欄位-日期                          */
);

create        index msb_02 on msb_file (msb03);
create        index msbplant_idx on msb_file (msbplant);
alter table msb_file add constraint msb_pk primary key  (msb01,msb02);
grant select on msb_file to tiptopgp;
grant update on msb_file to tiptopgp;
grant delete on msb_file to tiptopgp;
grant insert on msb_file to tiptopgp;
grant references on msb_file to tiptopgp;
grant references on msb_file to ods;
grant select on msb_file to ods;
