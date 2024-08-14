/*
================================================================================
檔案代號:pid_file
檔案名稱:「在製工單」盤點標籤檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pid_file
(
pid01       nvarchar(20) NOT NULL,   /*標籤編號                               */
                                     /*儲存該筆「在製工單」的對應盤點標籤號碼。*/
pid012      nvarchar(10),
pid02       nvarchar(20),            /*工單單號                               */
                                     /*儲存該筆「在製工單」號碼。             */
pid021      smallint,                /*作業序號                               */
                                     /*作業序號 [ecm03]  99.12                */
pid022      nvarchar(6),             /*作業編號                               */
                                     /*作業編號 [ecm04]  99.12                */
pid023      nvarchar(10),            /*製造部門                               */
                                     /*製造部門  gem01   99.12                */
pid03       nvarchar(40),            /*生產料件                               */
                                     /*儲存該筆「在製工單」的生產料件。       */
pid04       decimal(15,3),           /*移轉套數                               */
                                     /*移轉套數 99.12                         */
                                     /*原為:生產量                            */
                                     /*儲存該筆「在製工單」的生產量。         */
pid041      decimal(15,3),           /*初盤點(一) 移轉套數                    */
                                     /*初盤點(一) 移轉套數 99.12              */
pid042      decimal(15,3),           /*初盤點(二) 移轉套數                    */
                                     /*初盤點(二) 移轉套數 99.12              */
pid043      decimal(15,3),           /*複盤點(一) 移轉套數                    */
                                     /*複盤點(一) 移轉套數 99.12              */
pid044      decimal(15,3),           /*複盤點(二) 移轉套數                    */
                                     /*複盤點(二) 移轉套數 99.12              */
pid05       nvarchar(4),             /*生產單位                               */
                                     /*儲存該筆「在製工單」的生產數量單位。   */
pid06       nvarchar(1),             /*空白標籤否                             */
pid07       nvarchar(1),             /*是否已作盤點資料「輸入」               */
                                     /*儲存該筆「在製工單」盤點資料是否已被作 */
                                     /*「輸入」處理。                         */
                                     /*系統維護。                             */
pid08       nvarchar(10),            /*產生人員                               */
                                     /*儲存該筆「在製工單」盤點資料產生者。   */
pid09       datetime,                /*產生日期                               */
                                     /*儲存該筆「在製工單」盤點資料產生日期。 */
pid10       datetime,                /*修正日期                               */
                                     /*儲存該筆「在製工單」盤點資料再修正日期。*/
pid11       datetime,                /*列印日期                               */
                                     /*儲存該筆「在製工單」盤點資料最近一次被 */
                                     /*列印日期。                             */
pid12       smallint,                /*列印次數                               */
                                     /*儲存該筆「在製工單」盤點資料共被列印次 */
                                     /*數。                                   */
pid13       decimal(15,3),           /*完工入庫量                             */
                                     /*儲存該筆「在製工單」的完工入庫量。     */
pid14       decimal(15,3),           /*再加工量                               */
                                     /*儲存該筆「在製工單」的再加工量。       */
pid15       decimal(15,3),           /*完工全檢量                             */
                                     /*完工全檢(FQC)量                        */
                                     /*儲存該筆「在製工單」的完工全檢(FQC)量。*/
pid16       decimal(15,3),           /*No Use                                 */
pid17       decimal(15,3),           /*報廢量                                 */
                                     /*儲存該筆「在製工單」的報廢量。         */
pid18       nvarchar(10),            /*備註製造部門                           */
pid27       nvarchar(40),
pid900      nvarchar(4),             /*保稅盤點位置                           */
pid901      nvarchar(1),             /*使用者自行定義                         */
pidlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pidplant    nvarchar(10) NOT NULL    /*所屬營運中心                           */
);

create        index pid_01 on pid_file (pid01);
create        index pid_02 on pid_file (pid01,pid02,pid022);
create        index pidplant_idx on pid_file (pidplant);
alter table pid_file add constraint pid_pk primary key  (pid01);
grant select on pid_file to tiptopgp;
grant update on pid_file to tiptopgp;
grant delete on pid_file to tiptopgp;
grant insert on pid_file to tiptopgp;
grant references on pid_file to tiptopgp;
grant references on pid_file to ods;
grant select on pid_file to ods;
