/*
================================================================================
檔案代號:sfv_file
檔案名稱:工單完工入庫單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfv_file
(
sfv01       nvarchar(20) NOT NULL,   /*入庫編號                               */
                                     /*入庫編號 sfu01                         */
sfv03       smallint NOT NULL,       /*項次                                   */
sfv04       nvarchar(40),            /*料號                                   */
                                     /*料號     ima01(sfa03)(img01)           */
sfv05       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫     imd01(img02)                  */
sfv06       nvarchar(10),            /*儲位                                   */
                                     /*儲位     ime01(img03)                  */
sfv07       nvarchar(24),            /*批號                                   */
                                     /*批號           img04                   */
sfv08       nvarchar(4),             /*庫存單位                               */
                                     /*庫存單位       ima25                   */
sfv09       decimal(18),             /*入庫量                                 */
sfv11       nvarchar(40),            /*工單單號                               */
                                     /*工單編號       sfb01                   */
                                     /*(ASR此欄是計劃料號)                    */
sfv12       nvarchar(255),           /*備註                                   */
                                     /*備註 (委外工單入庫時輸入發票號碼)      */
sfv13       decimal(18),             /*No Use                                 */
sfv14       smallint,                /*No Use                                 */
sfv15       smallint,                /*No Use                                 */
sfv16       nvarchar(1),             /*當月是否入聯產品否                     */
                                     /*當月是否入聯產品否 #6872               */
                                     /*系統維護                               */
sfv17       nvarchar(20),            /*FQC單號                                */
                                     /*ASR-報工單號 (asrt320)                 */
sfv18       nvarchar(1),             /*No Use                                 */
sfv19       nvarchar(1),             /*No Use                                 */
sfv20       nvarchar(19),            /*Run Card                               */
                                     /*asft620 - 報工單號                     */
sfv30       nvarchar(4),             /*單位一                                 */
sfv31       decimal(18),             /*單位一換算率(與生產單位)               */
sfv32       decimal(18),             /*單位一數量                             */
sfv33       nvarchar(4),             /*單位二                                 */
sfv34       decimal(18),             /*單位二換算率(與生產單位)               */
sfv35       decimal(18),             /*單位二數量                             */
sfv41       nvarchar(10),            /*專案代號                               */
sfv42       nvarchar(30),            /*WBS編碼                                */
sfv43       nvarchar(4),             /*活動代號                               */
sfv44       nvarchar(10),            /*理由碼                                 */
sfv45       nvarchar(20),            /*號機                                   */
sfv930      nvarchar(10),            /*成本中心                               */
sfvlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sfvplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sfvud01     nvarchar(255),           /*自訂欄位-Textedit                      */
sfvud02     nvarchar(40),            /*自訂欄位-文字                          */
sfvud03     nvarchar(40),            /*自訂欄位-文字                          */
sfvud04     nvarchar(40),            /*自訂欄位-文字                          */
sfvud05     nvarchar(40),            /*自訂欄位-文字                          */
sfvud06     nvarchar(40),            /*自訂欄位-文字                          */
sfvud07     decimal(18),             /*自訂欄位-數值                          */
sfvud08     decimal(18),             /*自訂欄位-數值                          */
sfvud09     decimal(18),             /*自訂欄位-數值                          */
sfvud10     integer,                 /*自訂欄位-整數                          */
sfvud11     integer,                 /*自訂欄位-整數                          */
sfvud12     integer,                 /*自訂欄位-整數                          */
sfvud13     datetime,                /*自訂欄位-日期                          */
sfvud14     datetime,                /*自訂欄位-日期                          */
sfvud15     datetime                 /*自訂欄位-日期                          */
);

create        index sfv_02 on sfv_file (sfv11);
create        index sfv_03 on sfv_file (sfv20);
create        index sfvplant_idx on sfv_file (sfvplant);
alter table sfv_file add constraint sfv_pk primary key  (sfv01,sfv03);
grant select on sfv_file to tiptopgp;
grant update on sfv_file to tiptopgp;
grant delete on sfv_file to tiptopgp;
grant insert on sfv_file to tiptopgp;
grant references on sfv_file to tiptopgp;
grant references on sfv_file to ods;
grant select on sfv_file to ods;
