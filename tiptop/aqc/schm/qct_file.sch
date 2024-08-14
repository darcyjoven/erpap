/*
================================================================================
檔案代號:qct_file
檔案名稱:品質檢驗單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qct_file
(
qct01       nvarchar(20) NOT NULL,   /*收貨單號                               */
                                     /*收貨單號      (qcs01)                  */
qct02       smallint NOT NULL,       /*收貨項次                               */
                                     /*收貨項次      (qcs02)                  */
qct021      smallint NOT NULL,       /*分批檢驗順序                           */
                                     /*分批檢驗順序  (qcs05)                  */
qct03       smallint NOT NULL,       /*行序                                   */
qct04       nvarchar(10),            /*檢驗項目                               */
qct05       nvarchar(1),             /*缺點等級                               */
qct06       decimal(18),             /*AQL                                    */
qct07       decimal(18),             /*不良數量                               */
qct08       nvarchar(1),             /*判定結果                               */
                                     /*1.合格    2.退貨   3.特採              */
qct09       smallint,                /*接受數量                               */
                                     /*Ac 數量                                */
qct10       smallint,                /*拒絕數量                               */
                                     /*Re 數量                                */
qct11       decimal(18),             /*檢驗量                                 */
qct12       nvarchar(1),             /*檢驗方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qct131      decimal(18),             /*下限                                   */
qct132      decimal(18),             /*上限                                   */
qct14       decimal(8,4),            /*K法標准值                              */
qct15       decimal(8,4),            /*F法標准值                              */
qctlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
qctplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
qctud01     nvarchar(255),           /*自訂欄位-Textedit                      */
qctud02     nvarchar(40),            /*自訂欄位-文字                          */
qctud03     nvarchar(40),            /*自訂欄位-文字                          */
qctud04     nvarchar(40),            /*自訂欄位-文字                          */
qctud05     nvarchar(40),            /*自訂欄位-文字                          */
qctud06     nvarchar(40),            /*自訂欄位-文字                          */
qctud07     decimal(18),             /*自訂欄位-數值                          */
qctud08     decimal(18),             /*自訂欄位-數值                          */
qctud09     decimal(18),             /*自訂欄位-數值                          */
qctud10     integer,                 /*自訂欄位-整數                          */
qctud11     integer,                 /*自訂欄位-整數                          */
qctud12     integer,                 /*自訂欄位-整數                          */
qctud13     datetime,                /*自訂欄位-日期                          */
qctud14     datetime,                /*自訂欄位-日期                          */
qctud15     datetime                 /*自訂欄位-日期                          */
);

create        index qctplant_idx on qct_file (qctplant);
alter table qct_file add constraint qct_pk primary key  (qct01,qct02,qct021,qct03);
grant select on qct_file to tiptopgp;
grant update on qct_file to tiptopgp;
grant delete on qct_file to tiptopgp;
grant insert on qct_file to tiptopgp;
grant references on qct_file to tiptopgp;
grant references on qct_file to ods;
grant select on qct_file to ods;
