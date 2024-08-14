/*
================================================================================
檔案代號:ogb_file
檔案名稱:出貨單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogb_file
(
ogb01       nvarchar(20) NOT NULL,   /*出貨單號                               */
                                     /*出貨單號 oga01                         */
ogb03       smallint NOT NULL,       /*項次                                   */
ogb04       nvarchar(40),            /*產品編號                               */
                                     /*產品編號 ima01(img01)                  */
ogb05       nvarchar(4),             /*銷售單位                               */
                                     /*銷售單位 (與訂單必須一致)(No-Entry)ima31*/
ogb05_fac   decimal(18) NOT NULL,    /*銷售/庫存彙總單位換算率                */
                                     /*銷售/庫存彙總單位換算率 (To ima25)     */
ogb06       nvarchar(120),           /*品名規格                               */
ogb07       nvarchar(10),            /*額外品名編號                           */
                                     /*額外品名編號  imc02,imc01=ogb04        */
ogb08       nvarchar(10),            /*出貨營運中心編號                       */
                                     /*出貨營運中心編號  azp01                */
ogb09       nvarchar(10),            /*出貨倉庫編號                           */
                                     /*出貨倉庫編號  imd01(img02)             */
ogb091      nvarchar(10),            /*出貨儲位編號                           */
                                     /*出貨儲位編號  ime01(img03)             */
ogb092      nvarchar(24),            /*出貨批號                               */
                                     /*出貨批號            img04   No.+024    */
ogb1001     nvarchar(10),            /*原因碼                                 */
ogb1002     nvarchar(10),            /*訂價代號                               */
ogb1003     datetime,                /*預計出貨日期                           */
ogb1004     nvarchar(20),            /*提案代號                               */
ogb1005     nvarchar(1),             /*作業方式                               */
                                     /*1-出貨,2-折扣                          */
ogb1006     decimal(18),             /*折扣率                                 */
ogb1007     nvarchar(20),            /*現金折扣單號                           */
ogb1008     nvarchar(4),             /*稅別                                   */
ogb1009     decimal(18),             /*稅率                                   */
ogb1010     nvarchar(1),             /*含稅否                                 */
ogb1011     nvarchar(15),            /*非直營KAB                              */
ogb1012     nvarchar(1),             /*搭贈                                   */
ogb1013     decimal(18),             /*已開發票未稅金額                       */
ogb1014     nvarchar(1),             /*保稅已放行否                           */
ogb11       nvarchar(40),            /*客戶產品編號                           */
                                     /*客戶產品編號 obk03,obk01=ogb04,obk02=oga*/
ogb12       decimal(18) NOT NULL,    /*實際出貨數量                           */
                                     /*實際出貨數量 (依銷售單位)              */
ogb13       decimal(18) NOT NULL,    /*原幣單價                               */
ogb14       decimal(18) NOT NULL,    /*原幣未稅金額                           */
ogb14t      decimal(18) NOT NULL,    /*原幣含稅金額                           */
ogb15       nvarchar(4),             /*庫存明細單位由廠/倉/儲/批自            */
                                     /*庫存明細單位(img09)由廠/倉/儲/批自動得出*/
ogb15_fac   decimal(18) NOT NULL,    /*銷售/庫存明細單位換算率                */
                                     /*銷售/庫存明細單位換算率 (To ogb15)     */
ogb16       decimal(18) NOT NULL,    /*數量                                   */
                                     /*數量 (依庫存明細單位)                  */
ogb17       nvarchar(1),             /*多倉儲批出貨否                         */
                                     /*多倉儲批出貨否 (Y/N)                   */
                                     /*  Y:多倉儲批出貨, 需再輸入庫存異動明細 */
                                     /*    (本項次下再掛另一單身 ogc_file)    */
ogb18       decimal(18) NOT NULL,    /*預計出貨數量                           */
                                     /*預計出貨數量 (依銷售單位)              */
ogb19       nvarchar(1),             /*檢驗否                                 */
                                     /*料號是否需要檢驗                       */
ogb20       nvarchar(1),             /*No Use                                 */
ogb21       nvarchar(1),             /*No Use                                 */
ogb22       nvarchar(1),             /*No Use                                 */
ogb31       nvarchar(20),            /*訂單單號                               */
                                     /*訂單單號 oea01(oeb01)                  */
ogb32       smallint,                /*訂單項次                               */
                                     /*訂單項次       oeb03                   */
ogb41       nvarchar(10),            /*專案代號                               */
ogb42       nvarchar(30),            /*WBS編號                                */
ogb43       nvarchar(4),             /*活動代號                               */
ogb44       nvarchar(1) DEFAULT ' ' NOT NULL, /*經營方式*/
ogb45       decimal(18),             /*原扣率                                 */
ogb46       decimal(18),             /*新扣率                                 */
ogb47       decimal(18) DEFAULT '0' NOT NULL, /*分攤折價=全部折價字段值的和*/
ogb48       nvarchar(20),            /*攤位編號                               */
ogb49       nvarchar(10),            /*商戶編號                               */
ogb50       nvarchar(1) DEFAULT ' ' NOT NULL, /*開票性質*/
ogb60       decimal(18) NOT NULL,    /*已開發票數量                           */
ogb63       decimal(18) NOT NULL,    /*銷退數量                               */
                                     /*銷退數量 (需換貨再出貨)                */
ogb64       decimal(18) NOT NULL,    /*銷退數量                               */
                                     /*銷退數量 (不需換貨出貨)                */
ogb65       nvarchar(10),            /*驗退理由碼                             */
ogb901      nvarchar(1),             /*No Use                                 */
ogb902      nvarchar(1),             /*No Use                                 */
ogb903      nvarchar(1),             /*No Use                                 */
ogb904      nvarchar(1),             /*No Use                                 */
ogb905      nvarchar(1),             /*No Use                                 */
ogb906      nvarchar(1),             /*No Use                                 */
ogb907      nvarchar(1),             /*No Use                                 */
ogb908      nvarchar(20),            /*手冊編號                               */
                                     /*手冊編號 (A050)                        */
ogb909      nvarchar(1),             /*No Use                                 */
ogb910      nvarchar(4),             /*單位一                                 */
ogb911      decimal(18),             /*單位一換算率(與銷售單位)               */
ogb912      decimal(18),             /*單位一數量                             */
ogb913      nvarchar(4),             /*單位二                                 */
ogb914      decimal(18),             /*單位二換算率(與銷售單位)               */
ogb915      decimal(18),             /*單位二數量                             */
ogb916      nvarchar(4),             /*計價單位                               */
ogb917      decimal(18) DEFAULT '0', /*計價數量                               */
ogb930      nvarchar(10),            /*成本中心                               */
ogb931      nvarchar(20),            /*包裝編號                               */
ogb932      decimal(18),             /*包裝數量                               */
ogblegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
ogbplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
ogbud01     nvarchar(255),           /*自訂欄位-Textedit                      */
ogbud02     nvarchar(40),            /*自訂欄位-文字                          */
ogbud03     nvarchar(40),            /*自訂欄位-文字                          */
ogbud04     nvarchar(40),            /*自訂欄位-文字                          */
ogbud05     nvarchar(40),            /*自訂欄位-文字                          */
ogbud06     nvarchar(40),            /*自訂欄位-文字                          */
ogbud07     decimal(18),             /*自訂欄位-數值                          */
ogbud08     decimal(18),             /*自訂欄位-數值                          */
ogbud09     decimal(18),             /*自訂欄位-數值                          */
ogbud10     integer,                 /*自訂欄位-整數                          */
ogbud11     integer,                 /*自訂欄位-整數                          */
ogbud12     integer,                 /*自訂欄位-整數                          */
ogbud13     datetime,                /*自訂欄位-日期                          */
ogbud14     datetime,                /*自訂欄位-日期                          */
ogbud15     datetime                 /*自訂欄位-日期                          */
);

create        index ogb_02 on ogb_file (ogb04);
create        index ogb_03 on ogb_file (ogb31,ogb32);
create        index ogbplant_idx on ogb_file (ogbplant);
alter table ogb_file add constraint ogb_pk primary key  (ogb01,ogb03);
grant select on ogb_file to tiptopgp;
grant update on ogb_file to tiptopgp;
grant delete on ogb_file to tiptopgp;
grant insert on ogb_file to tiptopgp;
grant references on ogb_file to tiptopgp;
grant references on ogb_file to ods;
grant select on ogb_file to ods;
