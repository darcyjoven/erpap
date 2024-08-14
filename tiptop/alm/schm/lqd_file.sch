/*
================================================================================
檔案代號:lqd_file
檔案名稱:券發放記錄單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqd_file
(
lqd00       nvarchar(10),            /*門店編號                               */
lqd01       nvarchar(20) DEFAULT ' ' NOT NULL, /*券發放單號*/
lqd02       nvarchar(20),            /*攤位編號                               */
lqd03       nvarchar(20),            /*合同編號                               */
lqd04       nvarchar(10),            /*商戶編號                               */
lqd05       nvarchar(10),            /*主品牌                                 */
lqd06       datetime,                /*券發放日期                             */
lqd07       nvarchar(20),            /*促銷單編號                             */
lqd08       decimal(18),             /*可返券交款金額                         */
lqd09       nvarchar(20),            /*返券類型                               */
lqd10       decimal(18),             /*返券金額                               */
lqd11       nvarchar(1),             /*促銷類型                               */
lqd12       nvarchar(1),             /*審核碼                                 */
lqd13       nvarchar(10),            /*審核人                                 */
lqd14       datetime,                /*審核日期                               */
lqd15       nvarchar(80),            /*備注                                   */
lqd16       decimal(18),             /*合同總金額                             */
lqd17       nvarchar(10),            /*樓棟                                   */
lqd18       nvarchar(10),            /*樓層                                   */
lqd19       nvarchar(10),            /*經營大類                               */
lqd20       nvarchar(10),            /*經營中類                               */
lqd21       nvarchar(10),            /*經營小類                               */
lqdcrat     datetime,                /*資料創建日                             */
lqddate     nvarchar(10),            /*最近更改日                             */
lqdgrup     nvarchar(10),            /*資料所有群                             */
lqdlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lqdmodu     nvarchar(10),            /*資料更改者                             */
lqdorig     nvarchar(10),            /*資料建立部門                           */
lqdoriu     nvarchar(10),            /*資料建立者                             */
lqdplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
lqduser     nvarchar(10)             /*資料所有者                             */
);

create        index lqdplant_idx on lqd_file (lqdplant);
alter table lqd_file add constraint lqd_pk primary key  (lqd01) deferrable initially deferred;
grant select on lqd_file to tiptopgp;
grant update on lqd_file to tiptopgp;
grant delete on lqd_file to tiptopgp;
grant insert on lqd_file to tiptopgp;
grant references on lqd_file to tiptopgp;
grant references on lqd_file to ods;
grant select on lqd_file to ods;
