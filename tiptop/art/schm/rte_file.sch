/*
================================================================================
檔案代號:rte_file
檔案名稱:商品策略單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rte_file
(
rte01       nvarchar(10) DEFAULT ' ' NOT NULL, /*商品策略代碼*/
rte02       smallint DEFAULT 0 NOT NULL, /*項次*/
rte03       nvarchar(40),            /*產品編號                               */
rte04       nvarchar(1),             /*是否可採                               */
rte05       nvarchar(1),             /*是否可售                               */
rte06       nvarchar(1),             /*是否可退                               */
rte07       nvarchar(1),             /*是否有效                               */
rte08       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
rte09       nvarchar(1) DEFAULT '2' NOT NULL, /*進/銷項*/
rtepos      nvarchar(1)              /*已傳POS否                              */
);

create        index rte_02 on rte_file (rte01,rte03);
alter table rte_file add constraint rte_pk primary key  (rte01,rte02);
grant select on rte_file to tiptopgp;
grant update on rte_file to tiptopgp;
grant delete on rte_file to tiptopgp;
grant insert on rte_file to tiptopgp;
grant references on rte_file to tiptopgp;
grant references on rte_file to ods;
grant select on rte_file to ods;
