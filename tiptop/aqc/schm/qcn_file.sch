/*
================================================================================
檔案代號:qcn_file
檔案名稱:PQC 品質檢驗單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcn_file
(
qcn01       nvarchar(20) NOT NULL,   /*收貨單號                               */
qcn03       smallint NOT NULL,       /*行序                                   */
qcn04       nvarchar(10),            /*檢驗項目                               */
qcn05       nvarchar(1),             /*缺點等級                               */
qcn06       decimal(18),             /*AQL                                    */
qcn07       decimal(18),             /*不良數量                               */
qcn08       nvarchar(1),             /*判定結果                               */
                                     /*1.合格    2.重工                       */
qcn09       smallint,                /*接受數量                               */
                                     /*Ac 數量                                */
qcn10       smallint,                /*拒絕數量                               */
                                     /*Re 數量                                */
qcn11       decimal(18),             /*檢驗量                                 */
qcn12       nvarchar(1),             /*檢驗方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcn131      decimal(18),             /*下限                                   */
qcn132      decimal(18),             /*上限                                   */
qcn14       decimal(8,4),            /*K法標准值                              */
qcn15       decimal(8,4),            /*F法標准值                              */
qcnlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
qcnplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
qcnud01     nvarchar(255),           /*自訂欄位-Textedit                      */
qcnud02     nvarchar(40),            /*自訂欄位-文字                          */
qcnud03     nvarchar(40),            /*自訂欄位-文字                          */
qcnud04     nvarchar(40),            /*自訂欄位-文字                          */
qcnud05     nvarchar(40),            /*自訂欄位-文字                          */
qcnud06     nvarchar(40),            /*自訂欄位-文字                          */
qcnud07     decimal(18),             /*自訂欄位-數值                          */
qcnud08     decimal(18),             /*自訂欄位-數值                          */
qcnud09     decimal(18),             /*自訂欄位-數值                          */
qcnud10     integer,                 /*自訂欄位-整數                          */
qcnud11     integer,                 /*自訂欄位-整數                          */
qcnud12     integer,                 /*自訂欄位-整數                          */
qcnud13     datetime,                /*自訂欄位-日期                          */
qcnud14     datetime,                /*自訂欄位-日期                          */
qcnud15     datetime                 /*自訂欄位-日期                          */
);

create        index qcnplant_idx on qcn_file (qcnplant);
alter table qcn_file add constraint qcn_pk primary key  (qcn01,qcn03);
grant select on qcn_file to tiptopgp;
grant update on qcn_file to tiptopgp;
grant delete on qcn_file to tiptopgp;
grant insert on qcn_file to tiptopgp;
grant references on qcn_file to tiptopgp;
grant references on qcn_file to ods;
grant select on qcn_file to ods;
