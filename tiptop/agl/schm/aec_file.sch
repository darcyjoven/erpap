/*
================================================================================
檔案代號:aec_file
檔案名稱:異動別分類帳檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aec_file
(
aec00       nvarchar(5) DEFAULT ' ' NOT NULL, /*帳別*/
aec01       nvarchar(24) DEFAULT ' ' NOT NULL, /*科目編號*/
aec02       datetime DEFAULT '(CONVERT([datet' NOT NULL, /*傳票日期*/
aec03       nvarchar(16) DEFAULT ' ' NOT NULL, /*傳票編號*/
aec04       smallint DEFAULT 0 NOT NULL, /*項次*/
aec05       nvarchar(30) DEFAULT ' ' NOT NULL, /*異動碼*/
aec051      nvarchar(2) DEFAULT ' ' NOT NULL, /*異動碼順序*/
aec052      nvarchar(10) DEFAULT ' ' NOT NULL, /*異動碼類型代號*/
                                     /*#FUN-5C0015                            */
aeclegal    nvarchar(10) NOT NULL    /*所屬法人                               */
);

create        index aec_01 on aec_file (aec01,aec05,aec02);
create        index aec_02 on aec_file (aec05,aec01,aec02);
alter table aec_file add constraint aec_pk primary key  (aec00,aec01,aec02,aec03,aec04,aec05,aec051,aec052,aeclegal) deferrable initially deferred;
grant select on aec_file to tiptopgp;
grant update on aec_file to tiptopgp;
grant delete on aec_file to tiptopgp;
grant insert on aec_file to tiptopgp;
grant references on aec_file to tiptopgp;
grant references on aec_file to ods;
grant select on aec_file to ods;
