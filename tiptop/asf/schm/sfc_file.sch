/*
================================================================================
檔案代號:sfc_file
檔案名稱:料表批號主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfc_file
(
sfc01       nvarchar(20) NOT NULL,   /*料表批號 (PBI number)                  */
                                     /*料表批號  (PBI number)                 */
                                     /*儲存合併料表的批次編號                 */
                                     /*此號碼可作為工單領/發料及料帳扣除時的  */
                                     /*處理依據                               */
sfc02       nvarchar(80),            /*描述                                   */
                                     /*儲存批號需特別加以說明的記錄           */
sfc03       nvarchar(20),            /*合拼版號                               */
sfc04       nvarchar(50),            /*計畫批號                               */
sfc91       nvarchar(1),             /*使用者自訂                             */
sfc92       nvarchar(1),             /*使用者自訂                             */
sfc93       nvarchar(1),             /*使用者自訂                             */
sfc94       nvarchar(1),             /*使用者自訂                             */
sfc95       nvarchar(1),             /*使用者自訂                             */
sfcacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
sfcconf     nvarchar(1) DEFAULT 'N', /*no use                                 */
sfcdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
sfcgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
sfcmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
sfcorig     nvarchar(10),            /*資料建立部門                           */
sfcoriu     nvarchar(10),            /*資料建立者                             */
sfcuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

alter table sfc_file add constraint sfc_pk primary key  (sfc01);
grant select on sfc_file to tiptopgp;
grant update on sfc_file to tiptopgp;
grant delete on sfc_file to tiptopgp;
grant insert on sfc_file to tiptopgp;
grant references on sfc_file to tiptopgp;
grant references on sfc_file to ods;
grant select on sfc_file to ods;
