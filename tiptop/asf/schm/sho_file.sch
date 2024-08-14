/*
================================================================================
檔案代號:sho_file
檔案名稱:製程調整資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sho_file
(
sho01       nvarchar(20) NOT NULL,   /*調整單號                               */
sho012      nvarchar(10),            /*製程段號                               */
sho02       datetime,                /*調整日期                               */
sho03       nvarchar(19),            /*Run Card                               */
sho04       nvarchar(20),            /*工單單號                               */
sho05       nvarchar(1),             /*No Use                                 */
sho06       nvarchar(1),             /*調整項目                               */
                                     /*調整項目(1/2/3)                        */
sho07       smallint,                /*調整製程順序                           */
sho08       nvarchar(6),             /*調整作業編號                           */
sho09       nvarchar(10),            /*插入STAGE/FLOW                         */
                                     /*插入STAGE/FLOW(調整項目2/3時使用)      */
sho10       nvarchar(10),            /*員工代號                               */
sho11       nvarchar(255),           /*備註                                   */
sho12       nvarchar(1),             /*所插入的 Stage/Flow 是 Rework 製       */
sho13       nvarchar(1),             /*No Use                                 */
sho14       nvarchar(1),             /*No Use                                 */
sho15       nvarchar(1),             /*No Use                                 */
sho16       decimal(9,4),            /*損耗率                                 */
sho17       decimal(9,4),            /*實際損耗率                             */
sho52       nvarchar(1),             /*委外否                                 */
sho53       nvarchar(1),             /*PQC 否                                 */
sho54       nvarchar(1),             /*Check in 否                            */
sho62       decimal(16,8),           /*單位用量                               */
sho63       decimal(16,8),           /*底數                                   */
sho64       decimal(9,4),            /*損耗批量                               */
shodate     datetime,                /*最近修改日                             */
shogrup     nvarchar(10),            /*資料所有群                             */
sholegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
shomodu     nvarchar(10),            /*資料更改者                             */
shoorig     nvarchar(10),            /*資料建立部門                           */
shooriu     nvarchar(10),            /*資料建立者                             */
shoplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
shouser     nvarchar(10)             /*資料所有者                             */
);

create        index shoplant_idx on sho_file (shoplant);
alter table sho_file add constraint sho_pk primary key  (sho01);
grant select on sho_file to tiptopgp;
grant update on sho_file to tiptopgp;
grant delete on sho_file to tiptopgp;
grant insert on sho_file to tiptopgp;
grant references on sho_file to tiptopgp;
grant references on sho_file to ods;
grant select on sho_file to ods;
