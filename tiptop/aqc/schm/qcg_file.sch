/*
================================================================================
檔案代號:qcg_file
檔案名稱:FQC 品質檢驗單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcg_file
(
qcg01       nvarchar(20) NOT NULL,   /*收貨單號                               */
qcg03       smallint NOT NULL,       /*行序                                   */
qcg04       nvarchar(10),            /*檢驗項目                               */
qcg05       nvarchar(1),             /*缺點等級                               */
qcg06       decimal(18),             /*AQL                                    */
qcg07       decimal(18),             /*不良數量                               */
qcg08       nvarchar(1),             /*判定結果                               */
                                     /*1.合格    2.重工                       */
qcg09       smallint,                /*接受數量                               */
                                     /*Ac 數量                                */
qcg10       smallint,                /*拒絕數量                               */
                                     /*Re 數量                                */
qcg11       decimal(18),             /*檢驗量                                 */
qcg12       nvarchar(1),             /*檢驗方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcg131      decimal(18),             /*下限                                   */
qcg132      decimal(18),             /*上限                                   */
qcg14       decimal(8,4),            /*K法標准值                              */
qcg15       decimal(8,4),            /*F法標准值                              */
qcglegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
qcgplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
qcgud01     nvarchar(255),           /*自訂欄位-Textedit                      */
qcgud02     nvarchar(40),            /*自訂欄位-文字                          */
qcgud03     nvarchar(40),            /*自訂欄位-文字                          */
qcgud04     nvarchar(40),            /*自訂欄位-文字                          */
qcgud05     nvarchar(40),            /*自訂欄位-文字                          */
qcgud06     nvarchar(40),            /*自訂欄位-文字                          */
qcgud07     decimal(18),             /*自訂欄位-數值                          */
qcgud08     decimal(18),             /*自訂欄位-數值                          */
qcgud09     decimal(18),             /*自訂欄位-數值                          */
qcgud10     integer,                 /*自訂欄位-整數                          */
qcgud11     integer,                 /*自訂欄位-整數                          */
qcgud12     integer,                 /*自訂欄位-整數                          */
qcgud13     datetime,                /*自訂欄位-日期                          */
qcgud14     datetime,                /*自訂欄位-日期                          */
qcgud15     datetime                 /*自訂欄位-日期                          */
);

create        index qcgplant_idx on qcg_file (qcgplant);
alter table qcg_file add constraint qcg_pk primary key  (qcg01,qcg03);
grant select on qcg_file to tiptopgp;
grant update on qcg_file to tiptopgp;
grant delete on qcg_file to tiptopgp;
grant insert on qcg_file to tiptopgp;
grant references on qcg_file to tiptopgp;
grant references on qcg_file to ods;
grant select on qcg_file to ods;
