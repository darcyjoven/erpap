/*
================================================================================
檔案代號:cgc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cgc_file
(
cgc01       varchar2(1000),          /*lib名称                                */
cgc02       varchar2(40),            /*版本                                   */
cgc03       number(5),               /*项次                                   */
cgc04       varchar2(2000),          /*函数名称                               */
cgc05       varchar2(2000),          /*返回值                                 */
cgc06       number(5),               /*测试结果                               */
cgc07       varchar2(100),           /*最后修改人                             */
cgc08       varchar2(100),           /*最后修改时间                           */
cgc09       varchar2(100),           /*最后测试人                             */
cgc10       varchar2(100)            /*最后测试时间                           */
);

grant select on cgc_file to tiptopgp;
grant update on cgc_file to tiptopgp;
grant delete on cgc_file to tiptopgp;
grant insert on cgc_file to tiptopgp;
grant index on cgc_file to public;
grant select on cgc_file to ods;
