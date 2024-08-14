/*
================================================================================
檔案代號:sfs_file
檔案名稱:工單發料底稿單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfs_file
(
sfs01       nvarchar(20) NOT NULL,   /*發料單號                               */
                                     /*發料單號 sfp01                         */
sfs012      nvarchar(10),            /*製程段號                               */
sfs013      smallint,                /*製程序                                 */
sfs02       smallint NOT NULL,       /*項次                                   */
sfs03       nvarchar(40),            /*工單單號                               */
                                     /*工單   sfb01                           */
                                     /*(ASR此欄是料號(asri210,asri220))       */
sfs04       nvarchar(40),            /*料號                                   */
                                     /*料號   ima01(sfa03)                    */
sfs05       decimal(18),             /*發料數量                               */
sfs06       nvarchar(4),             /*發料單位                               */
sfs07       nvarchar(10),            /*倉庫                                   */
                                     /*倉庫   imd01(img02)                    */
sfs08       nvarchar(10),            /*儲位                                   */
                                     /*儲位   ime01(img03)                    */
sfs09       nvarchar(24),            /*批號                                   */
                                     /*批號         img04                     */
sfs10       nvarchar(6),             /*作業編號                               */
sfs21       nvarchar(255),           /*備註                                   */
sfs22       nvarchar(1),             /*No Use                                 */
sfs23       nvarchar(1),             /*No Use                                 */
sfs24       nvarchar(1),             /*No Use                                 */
sfs25       nvarchar(1),             /*No Use                                 */
sfs26       nvarchar(1),             /*替代碼                                 */
                                     /*替代碼 (NULL/U/S)                      */
                                     /*NULL: 非取替代件                       */
                                     /*   U: 取代料件                         */
                                     /*   S: 替代料件                         */
sfs27       nvarchar(40),            /*被替代料號                             */
                                     /*當 sfa26=NULL   時,本欄位=發料料號     */
                                     /*當 sfa26='S/U'  時,本欄位儲存被替代料號*/
sfs28       decimal(15,6),           /*替代率                                 */
                                     /*當 sfa26=NULL   時,本欄位=NULL         */
                                     /*當 sfa26='S/U'  時,本欄位儲存替代率    */
sfs30       nvarchar(4),             /*單位一                                 */
sfs31       decimal(18),             /*單位一換算率(與生產單位)               */
sfs32       decimal(18),             /*單位一數量                             */
sfs33       nvarchar(4),             /*單位二                                 */
sfs34       decimal(18),             /*單位二換算率(與生產單位)               */
sfs35       decimal(18),             /*單位二數量                             */
sfs36       nvarchar(24),            /*廠牌                                   */
sfs930      nvarchar(10),            /*成本中心                               */
sfslegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sfsplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sfsud01     nvarchar(255),           /*自訂欄位-Textedit                      */
sfsud02     nvarchar(40),            /*自訂欄位-文字                          */
sfsud03     nvarchar(40),            /*自訂欄位-文字                          */
sfsud04     nvarchar(40),            /*自訂欄位-文字                          */
sfsud05     nvarchar(40),            /*自訂欄位-文字                          */
sfsud06     nvarchar(40),            /*自訂欄位-文字                          */
sfsud07     decimal(18),             /*自訂欄位-數值                          */
sfsud08     decimal(18),             /*自訂欄位-數值                          */
sfsud09     decimal(18),             /*自訂欄位-數值                          */
sfsud10     integer,                 /*自訂欄位-整數                          */
sfsud11     integer,                 /*自訂欄位-整數                          */
sfsud12     integer,                 /*自訂欄位-整數                          */
sfsud13     datetime,                /*自訂欄位-日期                          */
sfsud14     datetime,                /*自訂欄位-日期                          */
sfsud15     datetime                 /*自訂欄位-日期                          */
);

create        index sfs_02 on sfs_file (sfs03,sfs04);
create        index sfs_03 on sfs_file (sfs04,sfs07,sfs08);
create        index sfsplant_idx on sfs_file (sfsplant);
alter table sfs_file add constraint sfs_pk primary key  (sfs01,sfs02);
grant select on sfs_file to tiptopgp;
grant update on sfs_file to tiptopgp;
grant delete on sfs_file to tiptopgp;
grant insert on sfs_file to tiptopgp;
grant references on sfs_file to tiptopgp;
grant references on sfs_file to ods;
grant select on sfs_file to ods;
