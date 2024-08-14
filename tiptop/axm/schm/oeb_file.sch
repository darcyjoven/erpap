/*
================================================================================
檔案代號:oeb_file
檔案名稱:訂單單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeb_file
(
oeb01       nvarchar(20) NOT NULL,   /*訂單單號                               */
                                     /*訂單單號 oea01                         */
oeb03       smallint NOT NULL,       /*項次                                   */
oeb04       nvarchar(40),            /*產品編號                               */
                                     /*產品編號 ima01                         */
oeb05       nvarchar(4),             /*銷售單位                               */
                                     /*銷售單位 ima31                         */
oeb05_fac   decimal(18) NOT NULL,    /*銷售/庫存單位換算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
oeb06       nvarchar(120),           /*品名規格                               */
oeb07       nvarchar(10),            /*額外品名編號                           */
                                     /*額外品名編號 imc02,imc01=oeb04         */
oeb08       nvarchar(10),            /*出貨營運中心                           */
                                     /*出貨營運中心 azp01                     */
oeb09       nvarchar(10),            /*出貨倉庫                               */
                                     /*出貨倉庫 imd01(img02)                  */
oeb091      nvarchar(10),            /*出貨儲位                               */
                                     /*出貨儲位 ime01(img03)                  */
oeb092      nvarchar(24),            /*出貨批號                               */
                                     /*出貨批號       img04  No.+024          */
oeb1001     nvarchar(10),            /*原因碼                                 */
oeb1002     nvarchar(10),            /*訂價編號                               */
oeb1003     nvarchar(1),             /*作業方式                               */
oeb1004     nvarchar(20),            /*提案編號                               */
oeb1005     nvarchar(10),            /*訂價群組                               */
oeb1006     decimal(18),             /*折扣率                                 */
oeb1007     nvarchar(20),            /*現金折扣單號                           */
oeb1008     nvarchar(4),             /*稅別                                   */
oeb1009     decimal(18),             /*稅率                                   */
oeb1010     nvarchar(1),             /*含稅否                                 */
oeb1011     nvarchar(15),            /*非直營KAB                              */
oeb1012     nvarchar(1),             /*搭贈                                   */
oeb1013     decimal(18),             /*本次應返金額                           */
oeb11       nvarchar(40),            /*客戶產品編號                           */
                                     /*客戶產品編號 obk03,obk01=oeb04,obk02=oea*/
oeb12       decimal(18) NOT NULL,    /*數量                                   */
oeb13       decimal(18) NOT NULL,    /*單價                                   */
oeb14       decimal(18) NOT NULL,    /*未稅金額                               */
oeb14t      decimal(18) NOT NULL,    /*含稅金額                               */
oeb15       datetime,                /*約定交貨日                             */
oeb16       datetime,                /*排定交貨日                             */
oeb17       decimal(18),             /*取出單價                               */
                                     /*取出單價(紀錄第一次輸入的單價) no.7150 */
oeb18       nvarchar(10),            /*出貨地點                               */
oeb19       nvarchar(1),             /*備置否                                 */
                                     /*備置否(Y/N)                            */
oeb20       nvarchar(10),            /*交運方式                               */
oeb21       nvarchar(6),             /*價格條件                               */
oeb22       nvarchar(10),            /*版本                                   */
oeb23       decimal(18) NOT NULL,    /*待出貨數量                             */
                                     /*待出貨數量 (已出貨通知或出貨未扣帳)    */
oeb24       decimal(18) NOT NULL,    /*已出貨數量                             */
oeb25       decimal(18) NOT NULL,    /*已銷退數量                             */
                                     /*已銷退數量(須再換貨出貨)               */
oeb26       decimal(18) NOT NULL,    /*被結案數量                             */
                                     /* ==>(未交量=訂單量-已出貨+已銷退-被結案)*/
oeb27       nvarchar(20),            /*請購單號                               */
oeb28       decimal(18),             /*已轉請購量                             */
oeb29       decimal(18),             /*償價數量                               */
oeb30       datetime,                /*預計規還日期                           */
oeb31       nvarchar(10),            /*展延原因碼                             */
oeb32       datetime,                /*截止日期                               */
oeb41       nvarchar(10),            /*專案代號                               */
oeb42       nvarchar(30),            /*WBS編號                                */
oeb43       nvarchar(4),             /*活動代號                               */
oeb44       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營方式*/
oeb45       decimal(18),             /*原扣率                                 */
oeb46       decimal(18),             /*新扣率                                 */
oeb47       decimal(18) DEFAULT '0' NOT NULL, /*分攤折價=全部折價字段值的合*/
oeb48       nvarchar(1) DEFAULT '1' NOT NULL, /*出貨方式 1.訂貨 2.現貨*/
oeb49       nvarchar(20),            /*攤位編號                               */
oeb50       nvarchar(10),            /*商戶編號                               */
oeb70       nvarchar(1),             /*結案否                                 */
                                     /*結案否 (Y/N)                           */
oeb70d      datetime,                /*結案日期                               */
oeb71       nvarchar(4),             /*合約項次/估價項次/報價項次             */
                                     /*(當為合約轉入時須輸入)                 */
oeb72       datetime,                /*No Use                                 */
oeb901      decimal(18),             /*已包裝數:出貨時需減出貨量              */
oeb902      datetime,                /*包裝日期                               */
oeb903      decimal(18),             /*累積包裝量                             */
oeb904      decimal(18),             /*議價單價(BI)                           */
oeb905      decimal(18),             /*己備置量                               */
                                     /*己備置量     no.7182 alter             */
oeb906      nvarchar(1),             /*檢驗否                                 */
                                     /*預設單身料號是否需要檢驗               */
oeb907      nvarchar(1),             /*No Use                                 */
oeb908      nvarchar(20),            /*海關手冊編號                           */
oeb909      nvarchar(20),            /*No Use                                 */
oeb910      nvarchar(4),             /*單位一                                 */
oeb911      decimal(18),             /*單位一換算率(與銷售單位)               */
oeb912      decimal(18),             /*單位一數量                             */
oeb913      nvarchar(4),             /*單位二                                 */
oeb914      decimal(18),             /*單位二換算率(與銷售單位)               */
oeb915      decimal(18),             /*單位二數量                             */
oeb916      nvarchar(4),             /*計價單位                               */
oeb917      decimal(18) DEFAULT '0', /*計價數量                               */
oeb918      nvarchar(20),            /*合拼版號                               */
oeb919      nvarchar(50),            /*計畫批號                               */
oeb920      decimal(18),             /*已分配量                               */
oeb930      nvarchar(10),            /*成本中心                               */
oeb931      nvarchar(20),            /*包裝編號                               */
oeb932      decimal(18),             /*包裝數量                               */
oeb933      nvarchar(10),            /*末維屬性組                             */
oeb934      nvarchar(10),            /*屬性群組                               */
oeb935      nvarchar(20),            /*補返來源訂單單號                       */
oeb936      smallint,                /*補返來源訂單項次                       */
oeb937      smallint,                /*物返條件來源合同項次                   */
oeblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oebplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oebud01     nvarchar(255),           /*自訂欄位-Textedit                      */
oebud02     nvarchar(40),            /*自訂欄位-文字                          */
oebud03     nvarchar(40),            /*自訂欄位-文字                          */
oebud04     nvarchar(40),            /*自訂欄位-文字                          */
oebud05     nvarchar(40),            /*自訂欄位-文字                          */
oebud06     nvarchar(40),            /*自訂欄位-數值                          */
oebud07     decimal(18),             /*自訂欄位-數值                          */
oebud08     decimal(18),             /*自訂欄位-數值                          */
oebud09     decimal(18),             /*自訂欄位-數值                          */
oebud10     integer,                 /*自訂欄位-整數                          */
oebud11     integer,                 /*自訂欄位-整數                          */
oebud12     integer,                 /*自訂欄位-整數                          */
oebud13     datetime,                /*自訂欄位-日期                          */
oebud14     datetime,                /*自訂欄位-日期                          */
oebud15     datetime                 /*自訂欄位-日期                          */
);

create        index oeb_02 on oeb_file (oeb04);
create        index oeb_03 on oeb_file (oeb15);
create        index oeb_04 on oeb_file (oeb16);
create        index oebplant_idx on oeb_file (oebplant);
alter table oeb_file add constraint oeb_pk primary key  (oeb01,oeb03);
grant select on oeb_file to tiptopgp;
grant update on oeb_file to tiptopgp;
grant delete on oeb_file to tiptopgp;
grant insert on oeb_file to tiptopgp;
grant references on oeb_file to tiptopgp;
grant references on oeb_file to ods;
grant select on oeb_file to ods;
