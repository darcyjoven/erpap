/*
================================================================================
檔案代號:ogh_file
檔案名稱:出貨單實際交易稅別明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogh_file
(
ogh01       nvarchar(20) DEFAULT ' ' NOT NULL, /*出貨單號*/
ogh02       smallint DEFAULT 0 NOT NULL, /*序號*/
ogh03       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
ogh04       decimal(9,4) DEFAULT '0',/*稅率                                   */
ogh05       decimal(20,6) DEFAULT '0', /*固定稅額*/
ogh06       nvarchar(1),             /*含稅否                                 */
ogh07       decimal(20,6) DEFAULT '0', /*未稅金額*/
ogh07t      decimal(20,6) DEFAULT '0', /*含稅金額*/
ogh08       decimal(20,6) DEFAULT '0', /*稅額*/
ogh09       decimal(20,6) DEFAULT '0', /*留抵稅額*/
oghdate     datetime,                /*最近修改日                             */
oghgrup     nvarchar(10),            /*資料所有部門                           */
oghlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oghmodu     nvarchar(10),            /*資料修改者                             */
oghorig     nvarchar(10),            /*資料建立部門                           */
oghoriu     nvarchar(10),            /*資料建立者                             */
oghplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oghuser     nvarchar(10)             /*資料所有者                             */
);

create unique index ogh_01 on ogh_file (ogh01,ogh02);
alter table ogh_file add constraint ogh_pk primary key  (ogh01,ogh02);
grant select on ogh_file to tiptopgp;
grant update on ogh_file to tiptopgp;
grant delete on ogh_file to tiptopgp;
grant insert on ogh_file to tiptopgp;
grant references on ogh_file to tiptopgp;
grant references on ogh_file to ods;
grant select on ogh_file to ods;
