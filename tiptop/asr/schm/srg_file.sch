/*
================================================================================
檔案代號:srg_file
檔案名稱:報工資料單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srg_file
(
srg01       nvarchar(20) NOT NULL,   /*報工單號                               */
srg02       smallint NOT NULL,       /*項次                                   */
srg03       nvarchar(40),            /*產品編號                               */
srg04       nvarchar(4),             /*生產單位                               */
                                     /*default ima55                          */
srg05       decimal(18),             /*良品數                                 */
srg06       decimal(18),             /*不良品數                               */
srg07       decimal(18),             /*報廢數量                               */
srg08       nvarchar(5),             /*報工時間起                             */
srg09       nvarchar(5),             /*報工時間迄                             */
srg10       decimal(18),             /*工時(分)                               */
srg11       nvarchar(20),            /*入庫單號                               */
srg12       nvarchar(20),            /*fqc單號                                */
srg13       nvarchar(1),             /*主/聯/副/再生產品                      */
                                     /*1:主產品 ; 2:聯產品 ; 3:副產品 ; 4:再生產品*/
srg14       nvarchar(40),            /*入庫產品料號                           */
srg15       nvarchar(1),             /*檢驗否(y/n)                            */
srg16       nvarchar(20),            /*工單編號                               */
srg17       decimal(18),             /*已入庫量                               */
srg18       decimal(18),             /*已FQC量                                */
srg19       decimal(15,3),           /*機時(分)                               */
srg930      nvarchar(10),            /*成本中心                               */
srglegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
srgplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
srgud01     nvarchar(255),           /*自訂欄位-Textedit                      */
srgud02     nvarchar(40),            /*自訂欄位-文字                          */
srgud03     nvarchar(40),            /*自訂欄位-文字                          */
srgud04     nvarchar(40),            /*自訂欄位-文字                          */
srgud05     nvarchar(40),            /*自訂欄位-文字                          */
srgud06     nvarchar(40),            /*自訂欄位-文字                          */
srgud07     decimal(18),             /*自訂欄位-數值                          */
srgud08     decimal(18),             /*自訂欄位-數值                          */
srgud09     decimal(18),             /*自訂欄位-數值                          */
srgud10     integer,                 /*自訂欄位-整數                          */
srgud11     integer,                 /*自訂欄位-整數                          */
srgud12     integer,                 /*自訂欄位-整數                          */
srgud13     datetime,                /*自訂欄位-日期                          */
srgud14     datetime,                /*自訂欄位-日期                          */
srgud15     datetime                 /*自訂欄位-日期                          */
);

create        index srgplant_idx on srg_file (srgplant);
alter table srg_file add constraint srg_pk primary key  (srg01,srg02);
grant select on srg_file to tiptopgp;
grant update on srg_file to tiptopgp;
grant delete on srg_file to tiptopgp;
grant insert on srg_file to tiptopgp;
grant references on srg_file to tiptopgp;
grant references on srg_file to ods;
grant select on srg_file to ods;
