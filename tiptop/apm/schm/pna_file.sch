/*
================================================================================
檔案代號:pna_file
檔案名稱:採購變更單單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pna_file
(
pna01       nvarchar(20) NOT NULL,   /*採購單號                               */
pna02       smallint NOT NULL,       /*變更序號                               */
pna04       datetime,                /*變更日期                               */
pna05       nvarchar(1),             /*確認否                                 */
                                     /*確認否(Y/N/X) X.作廢                   */
pna06       nvarchar(1),             /*No Use                                 */
pna07       nvarchar(1),             /*No Use                                 */
pna08       nvarchar(4),             /*變更前幣別                             */
                                     /*變更前幣別 #NO:7203                    */
pna08b      nvarchar(4),             /*變更後幣別                             */
                                     /*變更後幣別 #NO:7203                    */
pna09       nvarchar(6),             /*變更前價格條件                         */
                                     /*變更前價格條件 #NO:7203                */
pna09b      nvarchar(6),             /*變更後價格條件                         */
                                     /*變更後價格條件 #NO:7203                */
pna10       nvarchar(10),            /*變更前付款條件                         */
                                     /*變更前付款條件 #NO:7203                */
pna10b      nvarchar(10),            /*變更後付款條件                         */
                                     /*變更後付款條件 #NO:7203                */
pna11       nvarchar(10),            /*變更前送貨地址                         */
                                     /*變更前送貨地址 #NO:7203                */
pna11b      nvarchar(10),            /*變更後送貨地址                         */
                                     /*變更後送貨地址 #NO:7203                */
pna12       nvarchar(10),            /*變更前發票地址                         */
                                     /*變更前發票地址 #NO:7203                */
pna12b      nvarchar(10),            /*變更後發票地址                         */
                                     /*變更後發票地址 #NO:7203                */
pna13       nvarchar(1),             /*狀況碼                                 */
                                     /*狀況碼          No:6686                */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
pna14       nvarchar(1),             /*簽核否                                 */
                                     /*簽核否          No:6686                */
pna15       nvarchar(10),            /*變更理由碼                             */
pna16       nvarchar(10),            /*變更人員                               */
pna17       nvarchar(15),            /*電子變更序號                           */
pnaacti     nvarchar(1),             /*資料有效碼                             */
pnaconf     nvarchar(1),             /*發出否                                 */
                                     /*發出否(Y/N)                            */
pnadate     datetime,                /*最近修改日                             */
pnagrup     nvarchar(10),            /*資料所有部門                           */
pnalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pnamodu     nvarchar(10),            /*資料修改者                             */
pnaorig     nvarchar(10),            /*資料建立部門                           */
pnaoriu     nvarchar(10),            /*資料建立者                             */
pnaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
pnaud01     nvarchar(255),           /*自訂欄位-Textedit                      */
pnaud02     nvarchar(40),            /*自訂欄位-文字                          */
pnaud03     nvarchar(40),            /*自訂欄位-文字                          */
pnaud04     nvarchar(40),            /*自訂欄位-文字                          */
pnaud05     nvarchar(40),            /*自訂欄位-文字                          */
pnaud06     nvarchar(40),            /*自訂欄位-文字                          */
pnaud07     decimal(18),             /*自訂欄位-數值                          */
pnaud08     decimal(18),             /*自訂欄位-數值                          */
pnaud09     decimal(18),             /*自訂欄位-數值                          */
pnaud10     integer,                 /*自訂欄位-整數                          */
pnaud11     integer,                 /*自訂欄位-整數                          */
pnaud12     integer,                 /*自訂欄位-整數                          */
pnaud13     datetime,                /*自訂欄位-日期                          */
pnaud14     datetime,                /*自訂欄位-日期                          */
pnaud15     datetime,                /*自訂欄位-日期                          */
pnauser     nvarchar(10)             /*資料所有者                             */
);

create        index pnaplant_idx on pna_file (pnaplant);
alter table pna_file add constraint pna_pk primary key  (pna01,pna02) deferrable initially deferred;
grant select on pna_file to tiptopgp;
grant update on pna_file to tiptopgp;
grant delete on pna_file to tiptopgp;
grant insert on pna_file to tiptopgp;
grant references on pna_file to tiptopgp;
grant references on pna_file to ods;
grant select on pna_file to ods;
