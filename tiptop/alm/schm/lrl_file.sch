/*
================================================================================
檔案代號:lrl_file
檔案名稱:積分換物單記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrl_file
(
lrl00       nvarchar(10),            /*no use                                 */
lrl01       nvarchar(20) DEFAULT ' ' NOT NULL, /*積分換物單編號*/
lrl02       nvarchar(30),            /*卡號                                   */
lrl03       nvarchar(16),            /*卡種編號                               */
lrl04       nvarchar(20),            /*會員編號                               */
lrl05       nvarchar(16),            /*方案編號                               */
lrl06       decimal(18) DEFAULT '0' NOT NULL, /*可兌換積分*/
lrl07       decimal(18) DEFAULT '0' NOT NULL, /*兌換積分*/
lrl071      decimal(18) DEFAULT '0' NOT NULL, /*總兌換積分*/
lrl08       nvarchar(20),            /*兌換贈品編號                           */
lrl09       decimal(18) DEFAULT '0' NOT NULL, /*兌換份數*/
lrl10       decimal(18) DEFAULT '0' NOT NULL, /*剩餘積分*/
lrl11       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lrl12       nvarchar(10),            /*確認人                                 */
lrl13       datetime,                /*確認日期                               */
lrlacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
lrlcrat     datetime,                /*資料創建日                             */
lrldate     datetime,                /*最近更改日                             */
lrlgrup     nvarchar(10),            /*資料所有群                             */
lrllegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lrlmodu     nvarchar(10),            /*資料更改者                             */
lrlorig     nvarchar(10),            /*資料建立部門                           */
lrloriu     nvarchar(10),            /*資料建立者                             */
lrlplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
lrluser     nvarchar(10)             /*資料所有者                             */
);

create        index lrlplant_idx on lrl_file (lrlplant);
alter table lrl_file add constraint lrl_pk primary key  (lrl01);
grant select on lrl_file to tiptopgp;
grant update on lrl_file to tiptopgp;
grant delete on lrl_file to tiptopgp;
grant insert on lrl_file to tiptopgp;
grant references on lrl_file to tiptopgp;
grant references on lrl_file to ods;
grant select on lrl_file to ods;
