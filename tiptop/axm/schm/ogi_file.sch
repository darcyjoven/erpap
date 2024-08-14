/*
================================================================================
檔案代號:ogi_file
檔案名稱:出貨單身稅別明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogi_file
(
ogi01       nvarchar(20) DEFAULT ' ' NOT NULL, /*出貨單號*/
ogi02       smallint DEFAULT 0 NOT NULL, /*項次*/
ogi03       smallint DEFAULT 0 NOT NULL, /*序號*/
ogi04       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
ogi05       decimal(9,4) DEFAULT '0',/*稅率                                   */
ogi06       decimal(20,6) DEFAULT '0', /*固定稅額*/
ogi07       nvarchar(1),             /*含稅否                                 */
ogi08       decimal(20,6) DEFAULT '0', /*未稅金額*/
ogi08t      decimal(20,6) DEFAULT '0', /*含稅金額*/
ogi09       decimal(20,6) DEFAULT '0', /*稅額*/
ogidate     datetime,                /*最近修改日                             */
ogigrup     nvarchar(10),            /*資料所有部門                           */
ogilegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ogimodu     nvarchar(10),            /*資料修改者                             */
ogiorig     nvarchar(10),            /*資料建立部門                           */
ogioriu     nvarchar(10),            /*資料建立者                             */
ogiplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ogiuser     nvarchar(10)             /*資料所有者                             */
);

create unique index ogi_01 on ogi_file (ogi01,ogi02,ogi03);
alter table ogi_file add constraint ogi_pk primary key  (ogi01,ogi02,ogi03);
grant select on ogi_file to tiptopgp;
grant update on ogi_file to tiptopgp;
grant delete on ogi_file to tiptopgp;
grant insert on ogi_file to tiptopgp;
grant references on ogi_file to tiptopgp;
grant references on ogi_file to ods;
grant select on ogi_file to ods;
