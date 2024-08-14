/*
================================================================================
檔案代號:shb_file
檔案名稱:工單生產日報維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shb_file
(
shb01       nvarchar(20) NOT NULL,   /*移轉單號                               */
shb012      nvarchar(10),            /*製程段號                               */
shb02       datetime,                /*開工日期                               */
shb021      nvarchar(8),             /*開工時間                               */
shb03       datetime,                /*完工日期                               */
shb031      nvarchar(8),             /*完工時間                               */
shb032      decimal(18),             /*投入工時                               */
shb033      decimal(18),             /*投入機時                               */
shb04       nvarchar(10),            /*員工編號                               */
shb05       nvarchar(20),            /*工單編號                               */
shb06       smallint,                /*製程序號                               */
shb07       nvarchar(10),            /*工作中心                               */
shb08       nvarchar(10),            /*線/班別                                */
shb081      nvarchar(6),             /*作業編號                               */
                                     /*作業編號     ecm04                     */
shb082      nvarchar(80),            /*作業名稱                               */
                                     /*作業名稱     ecm45                     */
shb09       nvarchar(10),            /*機台編號                               */
shb10       nvarchar(40),            /*生產料件                               */
shb111      decimal(18),             /*良品轉出數量                           */
shb112      decimal(18),             /*當站報廢數量                           */
shb113      decimal(18),             /*重工轉出數量                           */
shb114      decimal(18),             /*當站下線數量                           */
shb115      decimal(18),             /*Bonus   數量                           */
shb12       smallint,                /*重工轉出下製程序                       */
shb121      nvarchar(10),            /*重工轉出下製程段號                     */
shb13       nvarchar(20),            /*領料單號                               */
shb14       nvarchar(20),            /*入庫單號                               */
shb15       smallint,                /*項次                                   */
shb16       nvarchar(19),            /*Run Card                               */
shb17       decimal(18),             /*工單轉出量                             */
shb18       nvarchar(20),            /*移轉單號                               */
shb19       nvarchar(1),             /*No Use                                 */
shb20       nvarchar(1),             /*No Use                                 */
shb21       nvarchar(20),            /*生產入庫單號                           */
shb22       nvarchar(20),            /*FQC單號                                */
shb23       nvarchar(20),            /*PBI單號                                */
shb24       smallint,                /*PBI報工項次                            */
shb25       nvarchar(20),            /*號機                                   */
shb26       nvarchar(1) DEFAULT ' ' NOT NULL, /*下道工序是否委外*/
shb27       nvarchar(10),            /*委外廠商                               */
shb28       nvarchar(20),            /*委外採購單號                           */
shb29       nvarchar(20),            /*委外收貨單號                           */
shb30       nvarchar(1) DEFAULT ' ' NOT NULL, /*報工方式*/
shb31       nvarchar(1) DEFAULT ' ' NOT NULL, /*本道工序是否委外*/
shbacti     nvarchar(1),             /*資料有效碼                             */
shbdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
shbgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
shbinp      datetime,                /*輸入日期                               */
shblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
shbmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
shborig     nvarchar(10),            /*資料建立部門                           */
shboriu     nvarchar(10),            /*資料建立者                             */
shbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
shbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
shbud02     nvarchar(40),            /*自訂欄位-文字                          */
shbud03     nvarchar(40),            /*自訂欄位-文字                          */
shbud04     nvarchar(40),            /*自訂欄位-文字                          */
shbud05     nvarchar(40),            /*自訂欄位-文字                          */
shbud06     nvarchar(40),            /*自訂欄位-文字                          */
shbud07     decimal(18),             /*自訂欄位-數值                          */
shbud08     decimal(18),             /*自訂欄位-數值                          */
shbud09     decimal(18),             /*自訂欄位-數值                          */
shbud10     integer,                 /*自訂欄位-整數                          */
shbud11     integer,                 /*自訂欄位-整數                          */
shbud12     integer,                 /*自訂欄位-整數                          */
shbud13     datetime,                /*自訂欄位-日期                          */
shbud14     datetime,                /*自訂欄位-日期                          */
shbud15     datetime,                /*自訂欄位-日期                          */
shbuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

create        index shb_02 on shb_file (shb05);
create        index shb_03 on shb_file (shb16);
create        index shbplant_idx on shb_file (shbplant);
alter table shb_file add constraint shb_pk primary key  (shb01);
grant select on shb_file to tiptopgp;
grant update on shb_file to tiptopgp;
grant delete on shb_file to tiptopgp;
grant insert on shb_file to tiptopgp;
grant references on shb_file to tiptopgp;
grant references on shb_file to ods;
grant select on shb_file to ods;
