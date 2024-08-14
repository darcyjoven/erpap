/*
================================================================================
檔案代號:sgyi_file
檔案名稱:工單製程單元變更檔
檔案目的:工單工藝單元變更單身檔
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgyi_file
(
sgyi01      nvarchar(20) DEFAULT ' ' NOT NULL, /*工單編號*/
sgyi012     nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
sgyi02      smallint DEFAULT 0 NOT NULL, /*工藝序*/
sgyi03      smallint DEFAULT 0 NOT NULL, /*變更序號*/
sgyi05      nvarchar(10) DEFAULT ' ' NOT NULL, /*單元編號*/
sgyilegal   nvarchar(10) NOT NULL,   /*所屬法人                               */
sgyiplant   nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sgyislk01   integer,                 /*原單元順序                             */
sgyislk03   decimal(18),             /*原現實工時                             */
sgyislk04   decimal(18),             /*原標準工價                             */
sgyislk05   decimal(18),             /*原現實工價                             */
sgyislk06   integer,                 /*新單元順序                             */
sgyislk08   decimal(18),             /*新現實工時                             */
sgyislk09   decimal(18),             /*新標準工價                             */
sgyislk10   decimal(18)              /*新現實工價                             */
);

alter table sgyi_file add constraint sgyi_pk primary key  (sgyi01,sgyi02,sgyi03,sgyi05,sgyi012);
grant select on sgyi_file to tiptopgp;
grant update on sgyi_file to tiptopgp;
grant delete on sgyi_file to tiptopgp;
grant insert on sgyi_file to tiptopgp;
grant references on sgyi_file to tiptopgp;
grant references on sgyi_file to ods;
grant select on sgyi_file to ods;
