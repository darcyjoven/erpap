/*
================================================================================
檔案代號:sfl_file
檔案名稱:報廢單單身檔(工單)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfl_file
(
sfl01       nvarchar(20) NOT NULL,   /*報廢單號(SCR)                          */
sfl012      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
sfl02       nvarchar(20) NOT NULL,   /*工單單號                               */
sfl03       nvarchar(40) NOT NULL,   /*料件編號                               */
sfl031      nvarchar(4) NOT NULL,    /*單位                                   */
                                     /*單位(sfa12)                            */
sfl033      decimal(18),             /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sfl04       nvarchar(10) NOT NULL,   /*製程編號                               */
sfl041      smallint DEFAULT 0 NOT NULL, /*製程序號*/
sfl05       decimal(18) NOT NULL,    /*應發數量                               */
                                     /*儲存該工單備料料件，使用者經過修改後， */
                                     /*決定的備料量；開始時，應與原發數量相同 */
sfl06       decimal(18) NOT NULL,    /*已發數量                               */
                                     /*儲存該工單備料料件，已經被發料的數量； */
sfl063      decimal(18) NOT NULL,    /*報廢數量                               */
                                     /*儲存該工單備料料件，被報廢料的數量     */
sfl07       decimal(18) NOT NULL,    /*本次報廢數量                           */
sfl08       nvarchar(10),            /*報廢理由碼                             */
sfl09       nvarchar(24),            /*報廢科目                               */
sfl10       nvarchar(4),             /*單位一                                 */
sfl11       decimal(18),             /*單位一轉換率(與生產單位)               */
sfl12       decimal(18),             /*單位一數量                             */
sfl13       nvarchar(4),             /*單位二                                 */
sfl14       decimal(18),             /*單位二轉換率(與生產單位)               */
sfl15       decimal(18),             /*單位二數量                             */
sfllegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sflplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sflud01     nvarchar(255),           /*自訂欄位-Textedit                      */
sflud02     nvarchar(40),            /*自訂欄位-文字                          */
sflud03     nvarchar(40),            /*自訂欄位-文字                          */
sflud04     nvarchar(40),            /*自訂欄位-文字                          */
sflud05     nvarchar(40),            /*自訂欄位-文字                          */
sflud06     nvarchar(40),            /*自訂欄位-文字                          */
sflud07     decimal(18),             /*自訂欄位-數值                          */
sflud08     decimal(18),             /*自訂欄位-數值                          */
sflud09     decimal(18),             /*自訂欄位-數值                          */
sflud10     integer,                 /*自訂欄位-整數                          */
sflud11     integer,                 /*自訂欄位-整數                          */
sflud12     integer,                 /*自訂欄位-整數                          */
sflud13     datetime,                /*自訂欄位-日期                          */
sflud14     datetime,                /*自訂欄位-日期                          */
sflud15     datetime                 /*自訂欄位-日期                          */
);

alter table sfl_file add constraint sfl_pk primary key  (sfl01,sfl02,sfl03,sfl031,sfl04,sfl041,sfl012);
grant select on sfl_file to tiptopgp;
grant update on sfl_file to tiptopgp;
grant delete on sfl_file to tiptopgp;
grant insert on sfl_file to tiptopgp;
grant references on sfl_file to tiptopgp;
grant references on sfl_file to ods;
grant select on sfl_file to ods;
