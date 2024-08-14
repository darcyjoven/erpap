/*
================================================================================
檔案代號:ogj_file
檔案名稱:銷退單實際交易稅別明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogj_file
(
ogj01       nvarchar(20) DEFAULT ' ' NOT NULL, /*銷退單號*/
ogj02       smallint DEFAULT 0 NOT NULL, /*序號*/
ogj03       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
ogj04       decimal(9,4) DEFAULT '0',/*稅率                                   */
ogj05       decimal(20,6) DEFAULT '0', /*固定稅額*/
ogj06       nvarchar(1),             /*含稅否                                 */
ogj07       decimal(20,6) DEFAULT '0', /*未稅金額*/
ogj07t      decimal(20,6) DEFAULT '0', /*含稅金額*/
ogj08       decimal(20,6) DEFAULT '0', /*稅額*/
ogj09       decimal(20,6) DEFAULT '0', /*留抵稅額*/
ogjdate     datetime,                /*最近修改日                             */
ogjgrup     nvarchar(10),            /*資料所有部門                           */
ogjlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ogjmodu     nvarchar(10),            /*資料修改者                             */
ogjorig     nvarchar(10),            /*資料建立部門                           */
ogjoriu     nvarchar(10),            /*資料建立者                             */
ogjplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ogjuser     nvarchar(10)             /*資料所有者                             */
);

create unique index ogj_01 on ogj_file (ogj01,ogj02);
alter table ogj_file add constraint ogj_pk primary key  (ogj01,ogj02);
grant select on ogj_file to tiptopgp;
grant update on ogj_file to tiptopgp;
grant delete on ogj_file to tiptopgp;
grant insert on ogj_file to tiptopgp;
grant references on ogj_file to tiptopgp;
grant references on ogj_file to ods;
grant select on ogj_file to ods;
