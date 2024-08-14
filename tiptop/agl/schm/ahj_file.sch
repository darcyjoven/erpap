/*
================================================================================
檔案代號:ahj_file
檔案名稱:外部銷售利潤分攤檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahj_file
(
ahj01       nvarchar(10) NOT NULL,   /*成本中心                               */
ahj02       smallint NOT NULL,       /*年度                                   */
ahj03       smallint NOT NULL,       /*期別                                   */
ahj04       nvarchar(20) NOT NULL,   /*出貨單號                               */
ahj05       smallint NOT NULL,       /*項次                                   */
ahj06       nvarchar(40),            /*料號                                   */
ahj061      nvarchar(120),           /*品名                                   */
ahj07       decimal(15,3),           /*數量                                   */
ahj08       decimal(20,6),           /*成本單價                               */
ahj09       decimal(20,6),           /*成本金額                               */
ahj10       decimal(20,6),           /*內部單價                               */
ahj11       decimal(20,6),           /*內部金額                               */
ahj12       decimal(20,6),           /*銷售單價                               */
ahj13       decimal(20,6),           /*銷售金額                               */
ahj14       decimal(20,6),           /*內部利潤                               */
ahj15       nvarchar(10),            /*分攤成本中心                           */
ahj16       decimal(15,3),           /*分攤比率                               */
ahj17       decimal(20,6),           /*分攤金額                               */
ahj18       nvarchar(30),            /*分錄單號                               */
ahj19       nvarchar(10)             /*資料來源營運中心                       */
);

alter table ahj_file add constraint ahj_pk primary key  (ahj01,ahj02,ahj03,ahj04,ahj05);
grant select on ahj_file to tiptopgp;
grant update on ahj_file to tiptopgp;
grant delete on ahj_file to tiptopgp;
grant insert on ahj_file to tiptopgp;
grant references on ahj_file to tiptopgp;
grant references on ahj_file to ods;
grant select on ahj_file to ods;
