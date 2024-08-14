/*
================================================================================
檔案代號:axf_file
檔案名稱:會計科目對沖關係檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axf_file
(
axf00       nvarchar(5) NOT NULL,    /*來源帳別                               */
axf01       nvarchar(24) NOT NULL,   /*來源會計科目編號                       */
axf02       nvarchar(24) NOT NULL,   /*對沖會計科目編號                       */
axf03       nvarchar(1),             /*比率否                                 */
                                     /*比率否(Y/N)                            */
                                     /*Y:表依股權比率沖銷                     */
                                     /*N:表全數沖銷                           */
axf04       nvarchar(24),            /*差額對應科目編號                       */
axf05       nvarchar(1),             /*No Use                                 */
axf06       nvarchar(1),             /*No Use                                 */
axf07       nvarchar(1),             /*No Use                                 */
axf08       nvarchar(1),             /*No Use                                 */
axf09       nvarchar(10) NOT NULL,   /*來源公司代碼                           */
axf10       nvarchar(10) NOT NULL,   /*對沖公司代碼                           */
axf12       nvarchar(5) NOT NULL,    /*對沖帳別                               */
axf13       nvarchar(10) DEFAULT ' ' NOT NULL, /*族群代號*/
axf14       nvarchar(1),             /*股本沖銷                               */
axf15       nvarchar(1) DEFAULT '1' NOT NULL, /*對沖來源公司科目餘額來源檔 */
axf16       nvarchar(10) DEFAULT ' ' NOT NULL, /*合併主體*/
axf17       nvarchar(1) DEFAULT '1' NOT NULL, /*對沖目的公司科目餘額來源檔 */
axfacti     nvarchar(1),             /*資料有效碼                             */
axfdate     datetime,                /*最近修改日                             */
axfgrup     nvarchar(10),            /*資料所有部門                           */
axfmodu     nvarchar(10),            /*資料修改者                             */
axforig     nvarchar(10),            /*資料建立部門                           */
axforiu     nvarchar(10),            /*資料建立者                             */
axfuser     nvarchar(10)             /*資料所有者                             */
);

alter table axf_file add constraint axf_pk primary key  (axf01,axf02,axf09,axf10,axf00,axf12,axf13,axf16);
grant select on axf_file to tiptopgp;
grant update on axf_file to tiptopgp;
grant delete on axf_file to tiptopgp;
grant insert on axf_file to tiptopgp;
grant references on axf_file to tiptopgp;
grant references on axf_file to ods;
grant select on axf_file to ods;
