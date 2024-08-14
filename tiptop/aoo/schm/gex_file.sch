/*
================================================================================
檔案代號:gex_file
檔案名稱:資料中心拋轉記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gex_file
(
gex01       nvarchar(10) DEFAULT ' ' NOT NULL, /*資料中心代碼*/
gex02       nvarchar(1) DEFAULT ' ' NOT NULL, /*資料類別*/
gex03       nvarchar(10) DEFAULT ' ' NOT NULL, /*拋轉營運中心*/
gex04       nvarchar(20) DEFAULT ' ' NOT NULL, /*程式代號*/
gex05       nvarchar(80) DEFAULT ' ' NOT NULL, /*拋轉主鍵值*/
gex06       integer,                 /*拋轉筆數                               */
gex07       datetime DEFAULT '(CONVERT([datet' NOT NULL, /*拋轉日期*/
gex08       nvarchar(8) DEFAULT ' ' NOT NULL, /*拋轉時間*/
gex09       nvarchar(10) DEFAULT ' ' NOT NULL /*拋轉人員代號*/
);

alter table gex_file add constraint gex_pk primary key  (gex01,gex02,gex03,gex04,gex05,gex07,gex08,gex09);
grant select on gex_file to tiptopgp;
grant update on gex_file to tiptopgp;
grant delete on gex_file to tiptopgp;
grant insert on gex_file to tiptopgp;
grant references on gex_file to tiptopgp;
grant references on gex_file to ods;
grant select on gex_file to ods;
