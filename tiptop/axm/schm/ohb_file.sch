/*
================================================================================
檔案代號:ohb_file
檔案名稱:銷退單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohb_file
(
ohb01       nvarchar(20) NOT NULL,   /*銷退單號                               */
                                     /*銷退單號 oha01                         */
ohb03       smallint NOT NULL,       /*項次                                   */
ohb04       nvarchar(40),            /*產品編號                               */
                                     /*產品編號 ima01(img01)                  */
ohb05       nvarchar(4),             /*銷售單位                               */
                                     /*銷售單位 ima25/ogb05                   */
ohb05_fac   decimal(18) NOT NULL,    /*銷售/庫存單位換算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
ohb06       nvarchar(120),           /*品名規格                               */
ohb07       nvarchar(10),            /*額外品名編號                           */
                                     /*額外品名編號 imc02,imc01=ohb04         */
ohb08       nvarchar(10),            /*銷退入庫營運中心編號                   */
                                     /*銷退入庫營運中心編號  azp01            */
ohb09       nvarchar(10),            /*銷退入庫倉庫編號                       */
                                     /*銷退入庫倉庫編號  imd01(img02)         */
ohb091      nvarchar(10),            /*銷退入庫儲位編號                       */
                                     /*銷退入庫儲位編號  imd01(img03)         */
ohb092      nvarchar(24),            /*銷退入庫批號                           */
                                     /*銷退入庫批號            img04  No.+024 */
ohb1001     nvarchar(10),            /*訂價編號                               */
ohb1002     nvarchar(20),            /*提案代號                               */
ohb1003     decimal(18),             /*折扣率                                 */
ohb1004     nvarchar(1),             /*搭增                                   */
ohb1005     nvarchar(1),             /*作業方式                               */
ohb1007     nvarchar(20),            /*現金折扣單號                           */
ohb1008     nvarchar(4),             /*稅別                                   */
ohb1009     decimal(18),             /*稅率                                   */
ohb1010     nvarchar(1),             /*含稅否                                 */
ohb1011     nvarchar(15),            /*非直營KAB                              */
ohb1012     decimal(18),             /*已折讓返利未稅金額                     */
ohb11       nvarchar(40),            /*客戶產品編號                           */
                                     /*客戶產品編號 obk03,obk01=ohb04,obk02=oha*/
ohb12       decimal(18) NOT NULL,    /*數量                                   */
ohb13       decimal(18) NOT NULL,    /*原幣單價                               */
ohb14       decimal(18) NOT NULL,    /*原幣未稅金額                           */
ohb14t      decimal(18) NOT NULL,    /*原幣含稅金額                           */
ohb15       nvarchar(4),             /*庫存明細單位由廠/倉/儲/批自            */
                                     /*庫存明細單位(img09)由廠/倉/儲/批自動得出*/
ohb15_fac   decimal(18) NOT NULL,    /*銷售/庫存明細單位換算率                */
                                     /*銷售/庫存明細單位換算率 (To ogb15)     */
ohb16       decimal(18) NOT NULL,    /*數量                                   */
                                     /*數量 (依庫存明細單位)                  */
ohb30       nvarchar(20),            /*原出貨發票號                           */
                                     /*原出貨發票號 oma10                     */
ohb31       nvarchar(20),            /*出貨單號                               */
                                     /*出貨單號  oga01(ogb01)                 */
                                     /*  若可追索原出貨單, 此處請輸入原出貨單號*/
                                     /*    並可由原出貨單帶出原訂單單號(ohb31)*/
                                     /*  若不追索原出貨單, 此處請輸入空白     */
ohb32       smallint,                /*出貨項次                               */
                                     /*出貨項次     ogb03                     */
ohb33       nvarchar(20),            /*訂單單號                               */
                                     /*訂單單號 oea01(oeb01)                  */
                                     /*  若可追索原訂單號, 此處請輸入原訂單號 */
                                     /*  若不追索原訂單號, 則須新開換貨訂單, 故*/
                                     /*    本欄將於新開換貨訂單時更新為換貨單號*/
ohb34       smallint,                /*訂單項次                               */
                                     /*訂單項次      oeb03                    */
ohb50       nvarchar(10),            /*退貨理由碼                             */
                                     /*退貨理由碼    oak01,oak03='2'          */
ohb51       nvarchar(30),            /*報單號碼                               */
ohb52       nvarchar(20),            /*手冊編號                               */
                                     /*手冊編號                        NO.A093*/
ohb53       nvarchar(1),             /*No Use                                 */
ohb60       decimal(18) NOT NULL,    /*已開折讓數量                           */
ohb61       nvarchar(1),             /*檢驗                                   */
ohb64       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營方式*/
ohb65       decimal(18),             /*原扣率                                 */
ohb66       decimal(18),             /*新扣率                                 */
ohb67       decimal(18) DEFAULT '0' NOT NULL, /*分攤折價=全部折價字段值的合*/
ohb68       nvarchar(1) DEFAULT 'N' NOT NULL, /*有實物否  Y-是,N-否*/
ohb69       nvarchar(20),            /*攤位編號                               */
ohb70       nvarchar(10),            /*商戶編號                               */
ohb71       nvarchar(1) DEFAULT ' ' NOT NULL, /*開票性質*/
ohb910      nvarchar(4),             /*單位一                                 */
ohb911      decimal(18),             /*單位一換算率(與銷售單位)               */
ohb912      decimal(18),             /*單位一數量                             */
ohb913      nvarchar(4),             /*單位二                                 */
ohb914      decimal(18),             /*單位二換算率(與銷售單位)               */
ohb915      decimal(18),             /*單位二數量                             */
ohb916      nvarchar(4),             /*計價單位                               */
ohb917      decimal(18),             /*計價數量                               */
ohb930      nvarchar(10),            /*成本中心                               */
ohblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ohbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ohbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
ohbud02     nvarchar(40),            /*自訂欄位-文字                          */
ohbud03     nvarchar(40),            /*自訂欄位-文字                          */
ohbud04     nvarchar(40),            /*自訂欄位-文字                          */
ohbud05     nvarchar(40),            /*自訂欄位-文字                          */
ohbud06     nvarchar(40),            /*自訂欄位-文字                          */
ohbud07     decimal(18),             /*自訂欄位-數值                          */
ohbud08     decimal(18),             /*自訂欄位-數值                          */
ohbud09     decimal(18),             /*自訂欄位-數值                          */
ohbud10     integer,                 /*自訂欄位-整數                          */
ohbud11     integer,                 /*自訂欄位-整數                          */
ohbud12     integer,                 /*自訂欄位-整數                          */
ohbud13     datetime,                /*自訂欄位-日期                          */
ohbud14     datetime,                /*自訂欄位-日期                          */
ohbud15     datetime                 /*自訂欄位-日期                          */
);

create        index ohb_02 on ohb_file (ohb04);
create        index ohb_03 on ohb_file (ohb30);
create        index ohb_04 on ohb_file (ohb31,ohb32);
create        index ohb_05 on ohb_file (ohb33,ohb34);
create        index ohbplant_idx on ohb_file (ohbplant);
alter table ohb_file add constraint ohb_pk primary key  (ohb01,ohb03);
grant select on ohb_file to tiptopgp;
grant update on ohb_file to tiptopgp;
grant delete on ohb_file to tiptopgp;
grant insert on ohb_file to tiptopgp;
grant references on ohb_file to tiptopgp;
grant references on ohb_file to ods;
grant select on ohb_file to ods;
