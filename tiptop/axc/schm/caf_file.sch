/*
================================================================================
檔案代號:caf_file
檔案名稱:在製月結檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table caf_file
(
caf01       nvarchar(20) NOT NULL,   /*工單編號                               */
caf012      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
caf02       smallint NOT NULL,       /*年度                                   */
caf03       smallint NOT NULL,       /*月份                                   */
caf04       nvarchar(40),            /*料件編號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
caf05       smallint NOT NULL,       /*製程序號                               */
                                     /*料件被製作程序過程中的生產活動順序編號 */
caf06       nvarchar(6) NOT NULL,    /*作業編號                               */
                                     /*料件被製作程序過程中的生產活動編號     */
caf07       nvarchar(10),            /*工作中心編號                           */
                                     /*該生產程序/作業在何一工作站被生產      */
caf10       decimal(18),             /*盤點量                                 */
caf11       decimal(18),             /*重工轉入量       (+)                   */
caf12       decimal(18),             /*工單轉入量       (+)                   */
caf13       decimal(18),             /*良品轉出量       (-)                   */
caf14       decimal(18),             /*Bonus Qty        (-)                   */
caf15       decimal(18),             /*重工轉出         (-)                   */
caf16       decimal(18),             /*當站報廢量       (-)                   */
caf17       decimal(18),             /*當站下線量(入庫) (-)                   */
caf18       decimal(18),             /*工單轉出量       (-)                   */
caf19       decimal(18),             /*委外完工量                             */
cafdate     datetime,                /*製程首次完工日                         */
caflegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
caftime     integer                  /*製程最後報工時間                       */
);

alter table caf_file add constraint caf_pk primary key  (caf01,caf02,caf03,caf05,caf06,caf012);
grant select on caf_file to tiptopgp;
grant update on caf_file to tiptopgp;
grant delete on caf_file to tiptopgp;
grant insert on caf_file to tiptopgp;
grant references on caf_file to tiptopgp;
grant references on caf_file to ods;
grant select on caf_file to ods;
