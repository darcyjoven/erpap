/*
================================================================================
檔案代號:oeg_file
檔案名稱:訂單單身稅別明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeg_file
(
oeg01       nvarchar(20) DEFAULT ' ' NOT NULL, /*訂單單號*/
oeg02       smallint DEFAULT 0 NOT NULL, /*項次*/
oeg03       smallint DEFAULT 0 NOT NULL, /*序號*/
oeg04       nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
oeg05       decimal(9,4) DEFAULT '0',/*稅率                                   */
oeg06       decimal(20,6) DEFAULT '0', /*固定稅額*/
oeg07       nvarchar(1),             /*含稅否                                 */
oeg08       decimal(20,6) DEFAULT '0', /*未稅金額*/
oeg08t      decimal(20,6) DEFAULT '0', /*含稅金額*/
oeg09       decimal(20,6) DEFAULT '0', /*稅額*/
oegdate     datetime,                /*最近修改日                             */
oeggrup     nvarchar(10),            /*資料所有部門                           */
oeglegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oegmodu     nvarchar(10),            /*資料修改者                             */
oegorig     nvarchar(10),            /*資料建立部門                           */
oegoriu     nvarchar(10),            /*資料建立者                             */
oegplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oeguser     nvarchar(10)             /*資料所有者                             */
);

create unique index oeg_01 on oeg_file (oeg01,oeg02,oeg03);
alter table oeg_file add constraint oeg_pk primary key  (oeg01,oeg02,oeg03);
grant select on oeg_file to tiptopgp;
grant update on oeg_file to tiptopgp;
grant delete on oeg_file to tiptopgp;
grant insert on oeg_file to tiptopgp;
grant references on oeg_file to tiptopgp;
grant references on oeg_file to ods;
grant select on oeg_file to ods;
