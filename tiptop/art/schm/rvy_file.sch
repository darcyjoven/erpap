/*
================================================================================
檔案代號:rvy_file
檔案名稱:產品策略稅別明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rvy_file
(
rvy01       nvarchar(10) DEFAULT ' ' NOT NULL, /*產品策略代碼*/
rvy02       smallint DEFAULT 0 NOT NULL, /*項次*/
rvy03       smallint DEFAULT 0 NOT NULL, /*序號*/
rvy04       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
rvy05       nvarchar(1) DEFAULT '2' NOT NULL, /*進/銷項*/
rvy06       decimal(20,6) DEFAULT '0', /*固定稅額*/
rvydate     datetime,                /*最近修改日                             */
rvygrup     nvarchar(10),            /*資料所有部門                           */
rvymodu     nvarchar(10),            /*資料修改者                             */
rvyorig     nvarchar(10),            /*資料建立部門                           */
rvyoriu     nvarchar(10),            /*資料建立者                             */
rvyuser     nvarchar(10)             /*資料所有者                             */
);

create unique index rvy_01 on rvy_file (rvy01,rvy02,rvy03);
alter table rvy_file add constraint rvy_pk primary key  (rvy01,rvy02,rvy03);
grant select on rvy_file to tiptopgp;
grant update on rvy_file to tiptopgp;
grant delete on rvy_file to tiptopgp;
grant insert on rvy_file to tiptopgp;
grant references on rvy_file to tiptopgp;
grant references on rvy_file to ods;
grant select on rvy_file to ods;
