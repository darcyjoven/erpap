/*
================================================================================
檔案代號:cgb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cgb_file
(
cgb01       varchar2(1000),          /*lib名称                                */
cgb02       varchar2(40),            /*版本                                   */
cgb03       number(5),               /*编译结果                               */
cgb04       varchar2(1000),          /*说明                                   */
cgb05       varchar2(40),            /*来源版本                               */
cgb06       varchar2(2000),          /*编译命令                               */
cgb07       varchar2(100),           /*建立人                                 */
cgb08       varchar2(100),           /*建立时间                               */
cgb09       varchar2(100),           /*最后修改人                             */
cgb10       varchar2(100),           /*最后修改时间                           */
cgb11       varchar2(100),
cgb12       varchar2(100),
cgb13       varchar2(100),
cgb14       varchar2(100),
cgb15       varchar2(100),
cgb16       varchar2(100),
cgb17       varchar2(100),
cgb18       varchar2(100),
cgb19       varchar2(100),
cgb20       varchar2(100),
cgb21       varchar2(100),
cgb22       varchar2(100),
cgb23       varchar2(100),
cgb24       varchar2(100),
cgb25       varchar2(100),
cgb26       varchar2(100)
);

grant select on cgb_file to tiptopgp;
grant update on cgb_file to tiptopgp;
grant delete on cgb_file to tiptopgp;
grant insert on cgb_file to tiptopgp;
grant index on cgb_file to public;
grant select on cgb_file to ods;
