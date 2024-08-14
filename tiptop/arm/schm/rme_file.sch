/*
================================================================================
檔案代號:rme_file
檔案名稱:RMA 覆出單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rme_file
(
rme01       nvarchar(20) NOT NULL,   /*RMA覆出單號                            */
rme011      nvarchar(20),            /*RMA單號                                */
rme02       datetime,                /*單據日期                               */
rme021      datetime,                /*覆出日期                               */
rme03       nvarchar(10),            /*退貨客戶編號                           */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
rme04       nvarchar(40),            /*退貨客戶簡稱                           */
rme041      nvarchar(20),            /*退貨客戶統一編號                       */
rme071      nvarchar(80),            /*退貨客戶全名                           */
                                     /*退貨客戶全名(同 occ18 公司全名-1)      */
rme072      nvarchar(80),            /*退貨客戶全名                           */
                                     /*退貨客戶全名(同 occ19 公司全名-2)      */
rme073      nvarchar(255),           /*送貨地址                               */
rme074      nvarchar(255),           /*送貨地址                               */
rme075      nvarchar(255),           /*送貨地址                               */
rme076      nvarchar(255),           /*送貨地址-4                             */
rme077      nvarchar(255),           /*送貨地址-5                             */
rme08       nvarchar(20),            /*發票編號/統一發票號碼                  */
rme09       nvarchar(30),            /*報關單號                               */
rme10       nvarchar(20),            /*應收帳款立帳單編號                     */
                                     /*應收帳款立帳單編號(oma_file)           */
rme11       datetime,                /*報關日期                               */
rme12       nvarchar(10),            /*人員編號                               */
rme13       nvarchar(10),            /*部門編號                               */
rme15       nvarchar(4),             /*稅別                                   */
rme151      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)           */
rme152      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)           */
rme153      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)           */
rme16       nvarchar(4),             /*幣別                                   */
rme17       decimal(18),             /*匯率                                   */
rme18       decimal(18),             /*原幣應收未稅金額                       */
rme181      decimal(18),             /*原幣應收稅額                           */
rme182      decimal(18),             /*原幣應收含稅金額                       */
rme19       decimal(18),             /*原幣立帳未稅金額                       */
rme191      decimal(18),             /*原幣立帳稅額                           */
rme192      decimal(18),             /*原幣立帳含稅金額                       */
rme20       nvarchar(1),             /*No Use                                 */
rme21       nvarchar(255),           /*備註                                   */
rme22       nvarchar(5),             /*發票別                                 */
rme28       nvarchar(1),             /*結案碼                                 */
                                     /*結案碼 Y/N                             */
rme29       nvarchar(1),             /*1:內銷 2:外銷                          */
rme30       decimal(18),             /*利潤率                                 */
rme31       nvarchar(1),             /*報關INVOICE確認否                      */
                                     /*報關INVOICE確認否(Y/N)                 */
rme32       nvarchar(1),             /*隨機INVOICE確認否                      */
                                     /*隨機INVOICE確認否(Y/N)                 */
rmeconf     nvarchar(1),             /*確認否                                 */
                                     /*t205確認否 (Y/N)                       */
rmedate     datetime,                /*最近修改日                             */
rmegen      nvarchar(1),             /*確認否                                 */
                                     /*t160確認否 (Y/N)                       */
rmegrup     nvarchar(10),            /*資料所有部門                           */
rmelegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
rmemodu     nvarchar(10),            /*資料修改者                             */
rmeorig     nvarchar(10),            /*資料建立部門                           */
rmeoriu     nvarchar(10),            /*資料建立者                             */
rmepack     nvarchar(1),             /*包裝否                                 */
                                     /*包裝否 (Y/N)                           */
rmeplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
rmepost     nvarchar(1),             /*扣帳否                                 */
                                     /*扣帳否 (Y/N)                           */
rmeprin     nvarchar(1),             /*列印否                                 */
                                     /*列印否 (Y/N)                           */
rmeud01     nvarchar(255),           /*自訂欄位-Textedit                      */
rmeud02     nvarchar(40),            /*自訂欄位-文字                          */
rmeud03     nvarchar(40),            /*自訂欄位-文字                          */
rmeud04     nvarchar(40),            /*自訂欄位-文字                          */
rmeud05     nvarchar(40),            /*自訂欄位-文字                          */
rmeud06     nvarchar(40),            /*自訂欄位-文字                          */
rmeud07     decimal(18),             /*自訂欄位-數值                          */
rmeud08     decimal(18),             /*自訂欄位-數值                          */
rmeud09     decimal(18),             /*自訂欄位-數值                          */
rmeud10     integer,                 /*自訂欄位-整數                          */
rmeud11     integer,                 /*自訂欄位-整數                          */
rmeud12     integer,                 /*自訂欄位-整數                          */
rmeud13     datetime,                /*自訂欄位-日期                          */
rmeud14     datetime,                /*自訂欄位-日期                          */
rmeud15     datetime,                /*自訂欄位-日期                          */
rmeuser     nvarchar(10),            /*資料所有者                             */
rmevoid     nvarchar(1)              /*有效否                                 */
                                     /*有效否 Y:有效 N:作廢                   */
);

alter table rme_file add constraint rme_pk primary key  (rme01);
grant select on rme_file to tiptopgp;
grant update on rme_file to tiptopgp;
grant delete on rme_file to tiptopgp;
grant insert on rme_file to tiptopgp;
grant references on rme_file to tiptopgp;
grant references on rme_file to ods;
grant select on rme_file to ods;
