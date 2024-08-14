/*
================================================================================
檔案代號:omj_file
檔案名稱:門市發票日結檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table omj_file
(
omj001      datetime NOT NULL,       /*交易日期                               */
omj002      nvarchar(10) DEFAULT ' ' NOT NULL, /*門店編碼*/
omj003      nvarchar(10) DEFAULT ' ' NOT NULL, /*POS機號*/
omj004      nvarchar(4) DEFAULT ' ' NOT NULL, /*稅別*/
omj005      nvarchar(1) DEFAULT ' ' NOT NULL, /*發票聯數*/
omj006      nvarchar(1) DEFAULT ' ' NOT NULL, /*性質*/
omj007      nvarchar(20) DEFAULT ' ' NOT NULL, /*發票號碼起始流水號位數*/
omj008      nvarchar(20) DEFAULT ' ' NOT NULL, /*發票號碼截止流水號位數*/
omj009      decimal(20,6) DEFAULT '0', /*應稅銷售金額(淨)*/
omj010      decimal(20,6) DEFAULT '0', /*免稅銷售金額(淨)*/
omj011      decimal(20,6) DEFAULT '0', /*銷售稅額*/
omj012      decimal(20,6) DEFAULT '0', /*禮券已開發票金額*/
omj013      decimal(20,6) DEFAULT '0', /*禮券已開發票稅額*/
omj014      decimal(20,6) DEFAULT '0', /*發票總金額*/
omj015      decimal(20,6) DEFAULT '0', /*發票應稅金額*/
omj016      decimal(20,6) DEFAULT '0', /*發票未稅金額*/
omj017      decimal(20,6) DEFAULT '0', /*發票稅額*/
omj018      decimal(20,6) DEFAULT '0', /*已開發票留抵稅額*/
omjdate     datetime,                /*資料輸入日                             */
omjgrup     nvarchar(10),            /*資料所有部門                           */
omjlegal    nvarchar(10),            /*所屬法人                               */
omjmodd     datetime,                /*最近修改日                             */
omjmodu     nvarchar(10),            /*資料修改者                             */
omjorig     nvarchar(10),            /*資料建立部門                           */
omjoriu     nvarchar(10),            /*資料建立者                             */
omjuser     nvarchar(10)             /*資料所有者                             */
);

create unique index omj_01 on omj_file (omj001,omj002,omj003,omj004,omj005,omj007,omj008);
alter table omj_file add constraint omj_pk primary key  (omj001,omj002,omj003,omj004,omj005,omj007,omj008);
grant select on omj_file to tiptopgp;
grant update on omj_file to tiptopgp;
grant delete on omj_file to tiptopgp;
grant insert on omj_file to tiptopgp;
grant references on omj_file to tiptopgp;
grant references on omj_file to ods;
grant select on omj_file to ods;
