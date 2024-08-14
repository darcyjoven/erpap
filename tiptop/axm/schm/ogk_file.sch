/*
================================================================================
檔案代號:ogk_file
檔案名稱:銷退單身稅別資料明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogk_file
(
ogk01       nvarchar(20) DEFAULT ' ' NOT NULL, /*銷退單號*/
ogk02       smallint DEFAULT 0 NOT NULL, /*項次*/
ogk03       smallint DEFAULT 0 NOT NULL, /*序號*/
ogk04       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
ogk05       decimal(9,4) DEFAULT '0',/*稅率                                   */
ogk06       decimal(20,6) DEFAULT '0', /*固定稅額*/
ogk07       nvarchar(1),             /*含稅否                                 */
ogk08       decimal(20,6) DEFAULT '0', /*未稅金額*/
ogk08t      decimal(20,6) DEFAULT '0', /*含稅金額*/
ogk09       decimal(20,6) DEFAULT '0', /*稅額*/
ogkdate     datetime,                /*最近修改日                             */
ogkgrup     nvarchar(10),            /*資料所有部門                           */
ogklegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ogkmodu     nvarchar(10),            /*資料修改者                             */
ogkorig     nvarchar(10),            /*資料建立部門                           */
ogkoriu     nvarchar(10),            /*資料建立者                             */
ogkplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ogkuser     nvarchar(10)             /*資料所有者                             */
);

create unique index ogk_01 on ogk_file (ogk01,ogk02,ogk03);
alter table ogk_file add constraint ogk_pk primary key  (ogk01,ogk02,ogk03);
grant select on ogk_file to tiptopgp;
grant update on ogk_file to tiptopgp;
grant delete on ogk_file to tiptopgp;
grant insert on ogk_file to tiptopgp;
grant references on ogk_file to tiptopgp;
grant references on ogk_file to ods;
grant select on ogk_file to ods;
