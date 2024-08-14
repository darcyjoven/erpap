/*
================================================================================
檔案代號:gec_file
檔案名稱:稅別檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gec_file
(
gec01       nvarchar(4) NOT NULL,    /*稅別碼                                 */
gec011      nvarchar(1) NOT NULL,    /*進/銷項                                */
                                     /*進/銷項 (1.進項 2.銷項)                */
gec02       nvarchar(80),            /*稅別名稱                               */
gec03       nvarchar(24),            /*會計科目編號                           */
gec031      nvarchar(24),            /*會計科目二                             */
gec04       decimal(18),             /*稅率                                   */
gec05       nvarchar(1),             /*發票聯數                               */
                                     /*發票聯數 (0.園區收據 2.二聯 3.三聯 X.不申報)*/
                                     /*進項發票種類:                          */
                                     /*A.農產品收購憑證 G.海關代徵完稅憑證    */
                                     /*N.不可抵扣專用發票 S.可抵扣專用發票    */
                                     /*T.運輸發票 W.廢舊物資收購憑證 Z.其他   */
gec06       nvarchar(1),             /*1.應稅 2.零稅率 3.免稅                 */
gec07       nvarchar(1),             /*單價含稅否                             */
                                     /*單價含稅否 (Y.內含稅 N.不含稅)         */
                                     /*若為二聯式發票則本欄位應為 'Y.內含稅'  */
gec08       nvarchar(2),             /*媒體申報格式                           */
                                     /*不申報 'XX'                            */
                                     /*進項 21/22/23/24/25/26/27/28/29        */
                                     /*銷項 31/32/33/34/35/36                 */
gecacti     nvarchar(1),             /*資料有效碼                             */
gecdate     datetime,                /*最近修改日                             */
gecgrup     nvarchar(10),            /*資料所有部門                           */
gecmodu     nvarchar(10),            /*資料修改者                             */
gecorig     nvarchar(10),            /*資料建立部門                           */
gecoriu     nvarchar(10),            /*資料建立者                             */
gecpos      nvarchar(1),             /*已傳POS否                              */
gecuser     nvarchar(10)             /*資料所有者                             */
);

alter table gec_file add constraint gec_pk primary key  (gec01,gec011);
grant select on gec_file to tiptopgp;
grant update on gec_file to tiptopgp;
grant delete on gec_file to tiptopgp;
grant insert on gec_file to tiptopgp;
grant references on gec_file to tiptopgp;
grant references on gec_file to ods;
grant select on gec_file to ods;
