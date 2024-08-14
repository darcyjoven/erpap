/*
================================================================================
檔案代號:ome_file
檔案名稱:銷項 GUI 檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ome_file
(
ome00       nvarchar(1) NOT NULL,    /*發票類別                               */
                                     /*發票類別 1.銷項發票                    */
                                     /*         3.非應收發票                  */
ome01       nvarchar(20) NOT NULL,   /*發票號碼                               */
ome02       datetime,                /*發票日期                               */
ome04       nvarchar(10),            /*發票客戶編號                           */
ome042      nvarchar(20),            /*發票客戶統一編號                       */
ome043      nvarchar(80),            /*發票客戶全名                           */
ome044      nvarchar(255),           /*發票客戶地址                           */
                                     /*發票客戶Addr                           */
ome05       nvarchar(5),             /*發票別                                 */
ome08       nvarchar(1),             /*1.內銷 2.外銷                          */
ome16       nvarchar(20),            /*帳單號碼                               */
ome17       nvarchar(1),             /*扣抵區分                               */
                                     /*扣抵區分 (1/2)       No:6374           */
ome171      nvarchar(2),             /*格式                                   */
                                     /*格式 (31/32/33/34/35)                  */
ome172      nvarchar(1),             /*課稅別                                 */
                                     /*課稅別 (1/2/3/D/F)                     */
ome173      smallint,                /*申報年度                               */
                                     /*申報年度(西元)                         */
ome174      smallint,                /*申報月份                               */
ome175      integer,                 /*申報流水編號                           */
ome21       nvarchar(4),             /*稅別                                   */
ome211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)           */
ome212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)           */
ome213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)           */
ome32       datetime,                /*報關日期                               */
ome33       datetime,                /*放行日期                               */
ome34       datetime,                /*出口日期                               */
ome35       nvarchar(1),             /*外銷方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7) -> no use      */
ome38       nvarchar(1),             /*出口文件類別                           */
                                     /*出口文件類別            -> no use      */
                                     /* 1.出口報單                            */
                                     /* 2.快捷郵件 3.攜出證明 4.零稅率證明聯  */
ome39       nvarchar(20),            /*出口文件號碼                           */
                                     /*出口文件號碼            -> no use      */
ome59       decimal(18) NOT NULL,    /*本幣發票未稅金額                       */
ome59t      decimal(18) NOT NULL,    /*本幣發票含稅金額                       */
ome59x      decimal(18) NOT NULL,    /*本幣發票稅額                           */
ome60       nvarchar(20),            /*申報統編                               */
omedate     datetime,                /*資料輸入日                             */
omegrup     nvarchar(10),            /*資料所有部門                           */
omelegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
omemodd     datetime,                /*最近修改日                             */
omemodu     nvarchar(10),            /*資料修改者                             */
omeorig     nvarchar(10),            /*資料建立部門                           */
omeoriu     nvarchar(10),            /*資料建立者                             */
omeprsw     smallint,                /*列印次數                               */
omeud01     nvarchar(255),           /*自訂欄位-Textedit                      */
omeud02     nvarchar(40),            /*自訂欄位-文字                          */
omeud03     nvarchar(40),            /*自訂欄位-文字                          */
omeud04     nvarchar(40),            /*自訂欄位-文字                          */
omeud05     nvarchar(40),            /*自訂欄位-文字                          */
omeud06     nvarchar(40),            /*自訂欄位-文字                          */
omeud07     decimal(18),             /*自訂欄位-數值                          */
omeud08     decimal(18),             /*自訂欄位-數值                          */
omeud09     decimal(18),             /*自訂欄位-數值                          */
omeud10     integer,                 /*自訂欄位-整數                          */
omeud11     integer,                 /*自訂欄位-整數                          */
omeud12     integer,                 /*自訂欄位-整數                          */
omeud13     datetime,                /*自訂欄位-日期                          */
omeud14     datetime,                /*自訂欄位-日期                          */
omeud15     datetime,                /*自訂欄位-日期                          */
omeuser     nvarchar(10),            /*資料所有者                             */
omevoid     nvarchar(1),             /*作廢否                                 */
                                     /*作廢否 (Y/N)                           */
omevoid2    nvarchar(10),            /*作廢理由碼                             */
omevoidd    datetime,                /*作廢日期                               */
omevoidu    nvarchar(10)             /*作廢人員                               */
);

create        index ome_02 on ome_file (ome02);
create        index ome_03 on ome_file (ome16);
alter table ome_file add constraint ome_pk primary key  (ome00,ome01);
grant select on ome_file to tiptopgp;
grant update on ome_file to tiptopgp;
grant delete on ome_file to tiptopgp;
grant insert on ome_file to tiptopgp;
grant references on ome_file to tiptopgp;
grant references on ome_file to ods;
grant select on ome_file to ods;
