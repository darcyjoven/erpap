/*
================================================================================
檔案代號:oct_file
檔案名稱:遞延收入檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oct_file
(
oct00       nvarchar(5) DEFAULT ' ' NOT NULL, /*帳別*/
oct01       nvarchar(20) DEFAULT ' ' NOT NULL, /*應收單號*/
oct02       smallint DEFAULT 0 NOT NULL, /*應收單據項次*/
oct03       nvarchar(40),            /*料件編號                               */
oct04       nvarchar(20),            /*出貨單號                               */
oct05       smallint,                /*出貨單項次                             */
oct06       nvarchar(20),            /*銷退單號                               */
oct07       smallint,                /*銷退單項次                             */
oct08       nvarchar(20),            /*傳票編號                               */
oct09       smallint DEFAULT 0 NOT NULL, /*遞延年度*/
oct10       smallint DEFAULT 0 NOT NULL, /*遞延月份*/
oct11       nvarchar(10) DEFAULT ' ' NOT NULL, /*售貨動作代號*/
oct12       decimal(20,6),           /*總遞延收入(本幣)                       */
oct12f      decimal(20,6),           /*總遞廷收入(原幣)                       */
oct13       nvarchar(24),            /*遞延收入科目                           */
oct14       decimal(20,6),           /*每期遞延收入(本幣)                     */
oct14f      decimal(20,6),           /*每期遞廷收入(原幣)                     */
oct15       decimal(20,6),           /*每期折讓金額(本幣)                     */
oct15f      decimal(20,6),           /*每期折讓金額(原幣)                     */
oct16       nvarchar(1) DEFAULT ' ' NOT NULL, /*異動類別*/
oct17       nvarchar(10),            /*營運中心代碼                           */
oct18       nvarchar(4),             /*原幣幣別                               */
oct19       decimal(20,10),          /*匯率                                   */
oct20       nvarchar(24),            /*沖轉每期遞延收入反向科目               */
octlegal    nvarchar(10)             /*所屬法人                               */
);

alter table oct_file add constraint oct_pk primary key  (oct00,oct01,oct02,oct09,oct10,oct11,oct16);
grant select on oct_file to tiptopgp;
grant update on oct_file to tiptopgp;
grant delete on oct_file to tiptopgp;
grant insert on oct_file to tiptopgp;
grant references on oct_file to tiptopgp;
grant references on oct_file to ods;
grant select on oct_file to ods;
