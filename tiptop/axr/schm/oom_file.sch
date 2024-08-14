/*
================================================================================
檔案代號:oom_file
檔案名稱:發票簿檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oom_file
(
oom01       smallint NOT NULL,       /*發票年度                               */
oom02       smallint NOT NULL,       /*發票月份-起始                          */
oom021      smallint NOT NULL,       /*發票月份-截止                          */
                                     /*發票月份-截止  add in 99/12/24         */
oom03       nvarchar(5) NOT NULL,    /*發票別                                 */
                                     /*  預設'1',輸入時不可空白               */
oom04       nvarchar(1) NOT NULL,    /*聯數                                   */
                                     /*聯數 (2.二聯式 3.三聯式)               */
oom05       smallint NOT NULL,       /*簿號                                   */
                                     /*簿號 (每月各發票別各聯式均由'1'編起)   */
oom06       nvarchar(1),             /*開立方式                               */
                                     /*開立方式 (1.電腦開立 2.人工開立)       */
oom07       nvarchar(20),            /*起始發票號碼                           */
oom08       nvarchar(20),            /*截止發票號碼                           */
oom09       nvarchar(20),            /*已開發票號碼                           */
oom10       datetime,                /*已開發票日期                           */
oom11       smallint,                /*發票號碼起始流水號位數                 */
oom12       smallint,                /*發票號碼截止流水號位數                 */
oom13       nvarchar(20),            /*申報統編                               */
oom14       nvarchar(10),            /*發放門店                               */
oomdate     datetime,                /*最近修改日                             */
oomgrup     nvarchar(10),            /*資料所有部門                           */
oommodu     nvarchar(10),            /*資料修改者                             */
oomorig     nvarchar(10),            /*資料建立部門                           */
oomoriu     nvarchar(10),            /*資料建立者                             */
oompos      nvarchar(1) DEFAULT 'N' NOT NULL, /*已傳POS否*/
oomuser     nvarchar(10)             /*資料所有者                             */
);

alter table oom_file add constraint oom_pk primary key  (oom01,oom02,oom021,oom03,oom04,oom05);
grant select on oom_file to tiptopgp;
grant update on oom_file to tiptopgp;
grant delete on oom_file to tiptopgp;
grant insert on oom_file to tiptopgp;
grant references on oom_file to tiptopgp;
grant references on oom_file to ods;
grant select on oom_file to ods;
