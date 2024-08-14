/*
================================================================================
檔案代號:msr_file
檔案名稱:MRP 版本檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msr_file
(
bdate       datetime,                /*起始供需日期                           */
buk_code    nvarchar(10),            /*時距代號                               */
buk_type    nvarchar(1),             /*使用時距方式                           */
                                     /* 1:依時距代號 2.天 3.週 4.旬 5.月      */
edate       datetime,                /*截止供需日期                           */
incl_id     nvarchar(1),             /*是否納入獨立需求檔資料                 */
                                     /*是否納入獨立需求檔資料 (Y/N)           */
incl_mds    nvarchar(1),             /*納入MDS需求                            */
incl_so     nvarchar(1),             /*是否納入實際訂單檔資料                 */
                                     /*是否納入實際訂單檔資料 (Y/N)           */
lot_bm      smallint,                /*BOM 下展階數                           */
lot_no1     nvarchar(50),            /*來源號碼-1                             */
lot_no2     nvarchar(50),            /*來源號碼-2                             */
lot_type    nvarchar(1),             /*模擬料號來源                           */
                                     /*1.生產計劃 2.工單 3.客戶訂單           */
                                     /*4.料號 5.Net Change                    */
msb_expl    nvarchar(1),             /*生產計劃(未轉工單)下階料備             */
msr01       datetime,                /*執行日期                               */
msr02       nvarchar(5),             /*起始時間                               */
msr03       nvarchar(5),             /*結束時間                               */
msr04       integer,                 /*產生筆數                               */
msr05       nvarchar(10),            /*產生人員                               */
msr06       nvarchar(1),             /*是否處理取替代料                       */
msr07       nvarchar(1),             /*是否處理指定廠牌                       */
msr08       nvarchar(10),            /*限定版別編號                           */
                                     /*限定版別編號                    No.7264*/
msr09       nvarchar(1),             /*是否顯示執行過程                       */
msr10       nvarchar(10),            /*APS版本                                */
msr11       nvarchar(10),            /*儲存版本                               */
msr919      nvarchar(50),            /*計畫批號                               */
msr_v       nvarchar(10) NOT NULL,   /*模擬版本                               */
mss_expl    nvarchar(1),             /*建議PLM自製料件是否產生下階            */
oeb_expl    nvarchar(1),             /*No Use                                 */
po_days     integer,                 /*PR/PO 允許交期提前 (Reschedule)        */
sub_days    integer,                 /*處理取替代料天數                       */
sub_flag    nvarchar(1),             /*是否處理取替代料                       */
wo_days     integer                  /*W/O   允許交期提前 (Reschedule)        */
);

alter table msr_file add constraint msr_pk primary key  (msr_v) deferrable initially deferred;
grant select on msr_file to tiptopgp;
grant update on msr_file to tiptopgp;
grant delete on msr_file to tiptopgp;
grant insert on msr_file to tiptopgp;
grant references on msr_file to tiptopgp;
grant references on msr_file to ods;
grant select on msr_file to ods;
