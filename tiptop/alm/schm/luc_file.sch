/*
================================================================================
檔案代號:luc_file
檔案名稱:費用退款單單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luc_file
(
luc01       nvarchar(20) DEFAULT ' ' NOT NULL, /*費用退款單號*/
luc02       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶來源*/
luc03       nvarchar(10),            /*商戶號                                 */
luc031      nvarchar(20),            /*商戶簡稱                               */
luc04       nvarchar(20),            /*合同編號                               */
luc05       nvarchar(20),            /*攤位編號                               */
luc06       decimal(18) DEFAULT '0' NOT NULL, /*未稅支出總金額*/
luc06t      decimal(18) DEFAULT '0' NOT NULL, /*含稅支出總金額*/
luc07       datetime,                /*單據日期                               */
luc08       nvarchar(60),            /*備注                                   */
luc09       nvarchar(1) DEFAULT ' ' NOT NULL, /*系統自動生成*/
luc10       nvarchar(1) DEFAULT ' ' NOT NULL, /*來源作業*/
luc11       nvarchar(20),            /*單據號                                 */
luc12       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
luc13       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
luc14       nvarchar(1) DEFAULT ' ' NOT NULL, /*審核碼*/
luc15       nvarchar(10),            /*審核人                                 */
luc16       datetime,                /*審核日期                               */
luc17       decimal(18) DEFAULT '0' NOT NULL, /*未稅應付金額*/
luc17t      decimal(18) DEFAULT '0' NOT NULL, /*含稅應付金額*/
luc18       nvarchar(4),             /*稅種                                   */
luc181      decimal(18),             /*稅率                                   */
luc182      nvarchar(1) DEFAULT ' ' NOT NULL, /*含稅*/
luc19       nvarchar(10),            /*no use 原門店編號                      */
luc20       nvarchar(1) DEFAULT ' ' NOT NULL, /*客戶來源*/
lucacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
luccrat     datetime,                /*資料創建日                             */
lucdate     datetime,                /*最近更改日                             */
lucgrup     nvarchar(10),            /*資料所有群                             */
luclegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lucmodu     nvarchar(10),            /*資料修改者                             */
lucorig     nvarchar(10),            /*資料建立部門                           */
lucoriu     nvarchar(10),            /*資料建立者                             */
lucplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
lucuser     nvarchar(10)             /*資料所有者                             */
);

create        index lucplant_idx on luc_file (lucplant);
alter table luc_file add constraint luc_pk primary key  (luc01) deferrable initially deferred;
grant select on luc_file to tiptopgp;
grant update on luc_file to tiptopgp;
grant delete on luc_file to tiptopgp;
grant insert on luc_file to tiptopgp;
grant references on luc_file to tiptopgp;
grant references on luc_file to ods;
grant select on luc_file to ods;
