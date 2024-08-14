/*
================================================================================
檔案代號:cah_file
檔案名稱:工單下線資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cah_file
(
cah01       nvarchar(20) NOT NULL,   /*工單編號                               */
cah012      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
cah02       smallint NOT NULL,       /*年度                                   */
cah03       smallint NOT NULL,       /*月份                                   */
cah04       nvarchar(40) NOT NULL,   /*下線料件編號                           */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單下線料件編號                   */
cah05       smallint NOT NULL,       /*下線之製程序號                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cah06       nvarchar(6) NOT NULL,    /*下線之作業編號                         */
                                     /*料件被製作程序過程中的生產活動編號     */
cah07       decimal(18),             /*下線數量         (+)                   */
cah08       decimal(18),             /*下線金額         (+)                   */
cah08a      decimal(18),             /*下線材料成本     (+)                   */
cah08b      decimal(18),             /*下線人工成本     (+)                   */
cah08c      decimal(18),             /*下線製造費用     (+)                   */
cah08d      decimal(18),             /*下線加工費用     (+)                   */
cah08e      decimal(18),             /*下線其它成本     (+)                   */
cah08f      decimal(18) DEFAULT '0', /*下線製造費用三     (+)                 */
cah08g      decimal(18) DEFAULT '0', /*下線製造費用四     (+)                 */
cah08h      decimal(18) DEFAULT '0', /*下線製造費用五     (+)                 */
cahlegal    nvarchar(10) NOT NULL    /*所屬法人                               */
);

alter table cah_file add constraint cah_pk primary key  (cah01,cah02,cah03,cah04,cah05,cah06,cah012);
grant select on cah_file to tiptopgp;
grant update on cah_file to tiptopgp;
grant delete on cah_file to tiptopgp;
grant insert on cah_file to tiptopgp;
grant references on cah_file to tiptopgp;
grant references on cah_file to ods;
grant select on cah_file to ods;
