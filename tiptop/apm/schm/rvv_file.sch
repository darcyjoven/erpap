/*
================================================================================
檔案代號:rvv_file
檔案名稱:入庫/退扣單異動檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvv_file
(
rvv01       nvarchar(20) NOT NULL,   /*入庫單號/退貨單號                      */
                                     /*入庫單號/退貨單號  rvu01               */
rvv02       smallint NOT NULL,       /*項次                                   */
rvv03       nvarchar(1),             /*異動類別                               */
                                     /*異動類別 (1.入庫  2.驗退 3.倉退) rvu00 */
rvv031      nvarchar(120),           /*品名                                   */
rvv04       nvarchar(20),            /*收貨單號                               */
                                     /*收貨單號 rva01(rvb01)                  */
rvv05       smallint,                /*項次                                   */
                                     /*項次           rvb02                   */
rvv06       nvarchar(10),            /*送貨廠商編號                           */
                                     /*送貨廠商編號   pmc01                   */
rvv09       datetime,                /*異動日期                               */
rvv10       nvarchar(1) DEFAULT ' ' NOT NULL, /*取價類型 1-搭贈,2-促銷協議,3- */
rvv11       nvarchar(20),            /*價格來源                               */
rvv12       nvarchar(20),            /*來源單號                               */
rvv13       smallint,                /*來源項次                               */
rvv17       decimal(18),             /*數量                                   */
rvv18       nvarchar(20),            /*工單編號                               */
                                     /*工單編號       sfb01                   */
rvv23       decimal(18),             /*已請款匹配量                           */
rvv24       nvarchar(1),             /*保稅過帳否                             */
rvv25       nvarchar(1),             /*樣品否                                 */
rvv26       nvarchar(10),            /*退貨理由                               */
                                     /*退貨理由      azf01,azf02='2'          */
rvv31       nvarchar(40),            /*料件編號                               */
                                     /*料件編號      ima01(img01)             */
rvv32       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫          imd01(img02)(imf02)      */
rvv33       nvarchar(10),            /*存放位置                               */
                                     /*存放位置      ime01(img03)(imf03)      */
rvv34       nvarchar(24),            /*批號/專案代號                          */
                                     /*批號/專案代號   img04 / pmn122 No.+024 */
rvv35       nvarchar(4),             /*單位                                   */
                                     /*單位          gfe01                    */
rvv35_fac   decimal(18),             /*轉換率                                 */
                                     /*轉換率                         #No:7704*/
rvv36       nvarchar(20),            /*採購單號                               */
                                     /*採購單號      pmm01(pmn01)             */
rvv37       smallint,                /*採購序號                               */
                                     /*採購序號            pmn02              */
rvv38       decimal(18),             /*單價                                   */
                                     /*單價                           971026Add*/
rvv38t      decimal(18),             /*含稅單價                               */
rvv39       decimal(18),             /*金額                                   */
                                     /*金額                           971026Add*/
rvv39t      decimal(18),             /*含稅金額 (注意:原rvv39定義為           */
rvv40       nvarchar(1),             /*沖暫估否                               */
                                     /*沖暫估否?(Y/N)   02/09/11 alter        */
rvv41       nvarchar(20),            /*手冊編號                               */
                                     /*手冊編號 (A050)                        */
rvv42       smallint,                /*No Use                                 */
rvv43       smallint,                /*No Use                                 */
rvv80       nvarchar(4),             /*單位一                                 */
rvv81       decimal(18),             /*單位一換算率(與採購單位)               */
rvv82       decimal(18),             /*單位一數量                             */
rvv83       nvarchar(4),             /*單位二                                 */
rvv84       decimal(18),             /*單位二換算率(與採購單位)               */
rvv85       decimal(18),             /*單位二數量                             */
rvv86       nvarchar(4),             /*計價單位                               */
rvv87       decimal(18),             /*計價數量                               */
rvv88       decimal(18),             /*暫估數量                               */
rvv89       nvarchar(1) DEFAULT 'N', /*VMI退貨否                              */
rvv919      nvarchar(50),            /*計畫批號                               */
rvv930      nvarchar(10),            /*成本中心                               */
rvvlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
rvvplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
rvvud01     nvarchar(255),           /*自訂欄位-Textedit                      */
rvvud02     nvarchar(40),            /*自訂欄位-文字                          */
rvvud03     nvarchar(40),            /*自訂欄位-文字                          */
rvvud04     nvarchar(40),            /*自訂欄位-文字                          */
rvvud05     nvarchar(40),            /*自訂欄位-文字                          */
rvvud06     nvarchar(40),            /*自訂欄位-文字                          */
rvvud07     decimal(18),             /*自訂欄位-數值                          */
rvvud08     decimal(18),             /*自訂欄位-數值                          */
rvvud09     decimal(18),             /*自訂欄位-數值                          */
rvvud10     integer,                 /*自訂欄位-整數                          */
rvvud11     integer,                 /*自訂欄位-整數                          */
rvvud12     integer,                 /*自訂欄位-整數                          */
rvvud13     datetime,                /*自訂欄位-日期                          */
rvvud14     datetime,                /*自訂欄位-日期                          */
rvvud15     datetime                 /*自訂欄位-日期                          */
);

create        index rvv_02 on rvv_file (rvv04,rvv05);
create        index rvv_03 on rvv_file (rvv36,rvv37);
create        index rvv_04 on rvv_file (rvv09);
create        index rvvplant_idx on rvv_file (rvvplant);
alter table rvv_file add constraint rvv_pk primary key  (rvv01,rvv02);
grant select on rvv_file to tiptopgp;
grant update on rvv_file to tiptopgp;
grant delete on rvv_file to tiptopgp;
grant insert on rvv_file to tiptopgp;
grant references on rvv_file to tiptopgp;
grant references on rvv_file to ods;
grant select on rvv_file to ods;
