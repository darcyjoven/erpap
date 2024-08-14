/*
================================================================================
檔案代號:occ_file
檔案名稱:客戶主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table occ_file
(
occ01       nvarchar(10) NOT NULL,   /*客戶編號                               */
occ02       nvarchar(40),            /*客戶簡稱                               */
occ03       nvarchar(10),            /*客戶分類                               */
occ04       nvarchar(10),            /*負責業務員編號                         */
occ05       nvarchar(1),             /*1.永久性 2.暫時性                      */
occ06       nvarchar(1),             /*性質                                   */
                                     /*性質 (1.買受人 2.送貨客戶 3.收款客戶 4.開票客戶)*/
occ07       nvarchar(10),            /*收款客戶編號                           */
occ08       nvarchar(5),             /*慣用發票別                             */
occ09       nvarchar(10),            /*送貨客戶編號                           */
occ10       nvarchar(1),             /*No Use                                 */
occ1001     datetime,                /*營業職照有效開始日期                   */
occ1002     datetime,                /*營業職照失效開始日期                   */
occ1003     nvarchar(10),            /*所屬業態                               */
occ1004     nvarchar(1),             /*狀態碼                                 */
occ1005     nvarchar(10),            /*所屬機構                               */
occ1006     nvarchar(10),            /*所屬通路                               */
occ1007     nvarchar(10),            /*系統碼                                 */
occ1008     nvarchar(10),            /*系統區域碼                             */
occ1009     nvarchar(10),            /*省份/特區                              */
occ1010     nvarchar(10),            /*地市級/區                              */
occ1011     nvarchar(10),            /*區/縣/市                               */
occ1012     nvarchar(255),           /*實際公司地址                           */
occ1013     nvarchar(10),            /*賣場面積                               */
occ1014     nvarchar(10),            /*連鎖店數                               */
occ1015     datetime,                /*門店開業日                             */
occ1016     nvarchar(10),            /*慣用出貨倉庫                           */
occ1017     nvarchar(20),            /*稅務登記証號                           */
occ1018     datetime,                /*稅務登記証有效開始期                   */
occ1019     datetime,                /*稅務登記証有效截止期                   */
occ1020     nvarchar(10),            /*納稅人識別號                           */
occ1021     nvarchar(80),            /*發票全稱                               */
occ1022     nvarchar(10),            /*發票客戶編號                           */
occ1023     nvarchar(10),            /*收款客戶編號                           */
occ1024     nvarchar(10),            /*業績歸屬組織                           */
occ1025     nvarchar(10),            /*費用歸屬組織                           */
occ1026     smallint,                /*對帳日                                 */
occ1027     nvarchar(1),             /*是否更改訂單單價                       */
occ1028     decimal(18),             /*慣用訂價折扣率                         */
occ1029     nvarchar(10),            /*代送商                                 */
occ11       nvarchar(20),            /*統一編號                               */
occ12       datetime,                /*創業日                                 */
                                     /*創 業 日                               */
occ13       decimal(18),             /*資 本 額                               */
occ14       decimal(18),             /*年營業額                               */
occ15       decimal(18),             /*員工人數                               */
occ16       datetime,                /*初次交易日                             */
occ1705     nvarchar(10),            /*保稅銷退異動原因代碼                   */
occ1706     nvarchar(10),            /*保稅出貨異動原因代碼                   */
occ1707     nvarchar(10),            /*保稅海關監管編號                       */
occ1708     nvarchar(10),            /*保稅業務人員                           */
occ171      datetime,                /*最近交易日-報價日                      */
                                     /*最近交易日-報價日 (系統自動更新)       */
occ172      datetime,                /*最近交易日-接單日                      */
                                     /*最近交易日-接單日 (系統自動更新)       */
occ173      datetime,                /*最近交易日-出貨日                      */
                                     /*最近交易日-出貨日 (系統自動更新)       */
occ174      datetime,                /*最近交易日-收款日                      */
                                     /*最近交易日-收款日 (系統自動更新)       */
occ175      datetime,                /*信用額度有效日期                       */
                                     /*信用額度有效日期(for tiptop40)         */
occ18       nvarchar(80),            /*公司全名(1)                            */
occ19       nvarchar(80),            /*公司全名(2)                            */
occ20       nvarchar(10),            /*區域編號                               */
occ21       nvarchar(10),            /*國別編號                               */
occ22       nvarchar(10),            /*地區別                                 */
                                     /*No use                                 */
occ231      nvarchar(255),           /*發票地址-1                             */
occ232      nvarchar(255),           /*發票地址-2                             */
occ233      nvarchar(255),           /*發票地址-3                             */
occ234      nvarchar(255),           /*發票地址-4                             */
occ235      nvarchar(255),           /*發票地址-5                             */
occ241      nvarchar(255),           /*送貨地址-1                             */
occ242      nvarchar(255),           /*送貨地址-2                             */
occ243      nvarchar(255),           /*送貨地址-3                             */
occ244      nvarchar(255),           /*送貨地址-4                             */
occ245      nvarchar(255),           /*送貨地址-5                             */
occ246      nvarchar(10) DEFAULT ' ' NOT NULL, /*資料來源*/
occ247      integer,                 /*客戶資料拋轉次數                       */
occ248      integer,                 /*信用資料拋轉次數                       */
occ261      nvarchar(40),            /*TEL NO-1                               */
occ262      nvarchar(40),            /*TEL NO-2                               */
occ263      nvarchar(40),            /*TEL NO-3                               */
occ271      nvarchar(40),            /*FAX NO-1                               */
occ272      nvarchar(40),            /*FAX NO-2                               */
occ273      nvarchar(40),            /*FAX NO-2                               */
occ28       nvarchar(40),            /*公司負責人                             */
occ29       nvarchar(40),            /*業務聯絡人                             */
occ292      nvarchar(5),             /*業務聯絡人分機號碼                     */
occ30       nvarchar(40),            /*財務聯絡人                             */
occ302      nvarchar(5),             /*財務聯絡人分機號碼                     */
occ31       nvarchar(1),             /*客戶銷售庫存管理否                     */
occ32       decimal(18),             /*最大折扣率                             */
                                     /*折扣率                        #No:A036 */
occ33       nvarchar(10),            /*額度客戶                               */
                                     /*額度客戶                        01/09/25*/
occ34       nvarchar(10),            /*集團碼                                 */
occ35       nvarchar(10),            /*郵遞區號                               */
                                     /*郵遞區號(for top40)             99/04/30*/
occ36       smallint,                /*寬限天數                               */
                                     /*寬限天數(for top40)             99/04/30*/
occ37       nvarchar(1),             /*是否為關係人                           */
                                     /*是否為關係人(Y/N)                      */
occ38       nvarchar(2),             /*客戶月結日                             */
occ39       nvarchar(2),             /*客戶付款日                             */
occ39a      nvarchar(2),             /*客戶付款日二                           */
                                     /*客戶付款日二(for top40)         99/05/12*/
occ40       nvarchar(1),             /*月底重評價                             */
                                     /*視為本幣AR否(Y/N)                      */
                                     /*  對於美金報價本幣付款的客戶,雖然以原幣*/
                                     /*  立帳, 但視為本幣AR, 月底不必作匯差調整*/
occ41       nvarchar(4),             /*慣用稅別                               */
occ42       nvarchar(4),             /*慣用幣別                               */
occ43       nvarchar(10),            /*慣用銷售分類                           */
occ44       nvarchar(6),             /*慣用價格條件                           */
occ45       nvarchar(6),             /*慣用收款條件                           */
occ46       nvarchar(80),            /*慣用其它條件                           */
occ47       nvarchar(10),            /*慣用交運方式                           */
occ48       nvarchar(10),            /*慣用起運港口                           */
occ49       nvarchar(10),            /*慣用到達港口                           */
occ50       nvarchar(10),            /*慣用卸貨港口                           */
                                     /*慣用卸貨港口(for tiptop40)      99/04/30*/
occ51       nvarchar(10),            /*慣用FORWARDER                          */
                                     /*慣用FORWARDER(客戶編號)                */
occ52       nvarchar(10),            /*慣用NOTIFY                             */
                                     /*慣用NOTIFY(for tiptop40)        99/04/30*/
occ53       smallint,                /*慣用佣金率%                            */
occ55       nvarchar(1),             /*慣用文件列印語言                       */
                                     /*慣用文件列印語言 (0.中文 1.英文)       */
occ56       nvarchar(1),             /*須出貨通知單否                         */
                                     /*須出貨通知單否 (Y/N)                   */
occ57       nvarchar(1),             /*須製作包裝單否                         */
                                     /*須製作包裝單否 (Y/N)                   */
occ61       nvarchar(10),            /*信用評等                               */
occ62       nvarchar(1),             /*信用查核否                             */
                                     /*信用查核否 (Y/N)                       */
occ63       decimal(18),             /*信用額度                               */
occ631      nvarchar(4),             /*額度幣別                               */
                                     /*額度幣別(for tiptop40)          99/04/30*/
occ64       smallint,                /*信用額度容許超出比率                   */
                                     /*信用額度容許超出比率%                  */
occ65       nvarchar(1),             /*客戶出貨簽收否                         */
occ66       nvarchar(10),            /*代送商代號                             */
occ67       nvarchar(10),            /*慣用科目類別                           */
occ68       nvarchar(6),             /*慣用訂金收款條件代號                   */
occ69       nvarchar(6),             /*慣用尾款收款條件代號                   */
occ701      nvarchar(255),           /*備註-1                                 */
                                     /*備註-1                          genero */
occ702      nvarchar(255),           /*備註-2                                 */
                                     /*No use                          genero */
occ703      nvarchar(255),           /*備註-3                                 */
                                     /*No use                          genero */
occ704      nvarchar(255),           /*備註-4                                 */
                                     /*No use                          genero */
occ71       nvarchar(1) DEFAULT '1' NOT NULL, /*客戶類型1.現付客戶2.賬期客戶*/
occ72       decimal(18),             /*訂金收取比例%                          */
occ73       nvarchar(1) DEFAULT ' ' NOT NULL, /*按交款金額產生應收*/
occ930      nvarchar(10),            /*對應營運中心                           */
occacti     nvarchar(1),             /*資料有效碼                             */
occdate     datetime,                /*最近修改日                             */
occgrup     nvarchar(10),            /*資料所有部門                           */
occmodu     nvarchar(10),            /*資料修改者                             */
occorig     nvarchar(10),            /*資料建立部門                           */
occoriu     nvarchar(10),            /*資料建立者                             */
occpos      nvarchar(1) DEFAULT 'N' NOT NULL, /*已傳POS否*/
occud01     nvarchar(255),           /*使用者自訂欄位                         */
occud02     nvarchar(40),            /*使用者自訂欄位                         */
occud03     nvarchar(40),            /*使用者自訂欄位                         */
occud04     nvarchar(40),            /*使用者自訂欄位                         */
occud05     nvarchar(40),            /*使用者自訂欄位                         */
occud06     nvarchar(40),            /*使用者自訂欄位                         */
occud07     decimal(18),             /*使用者自訂欄位                         */
occud08     decimal(18),             /*使用者自訂欄位                         */
occud09     decimal(18),             /*使用者自訂欄位                         */
occud10     integer,                 /*使用者自訂欄位                         */
occud11     integer,                 /*使用者自訂欄位                         */
occud12     integer,                 /*使用者自訂欄位                         */
occud13     datetime,                /*使用者自訂欄位                         */
occud14     datetime,                /*使用者自訂欄位                         */
occud15     datetime,                /*使用者自訂欄位                         */
occuser     nvarchar(10)             /*資料所有者                             */
);

create        index occ_02 on occ_file (occ02);
alter table occ_file add constraint occ_pk primary key  (occ01);
grant select on occ_file to tiptopgp;
grant update on occ_file to tiptopgp;
grant delete on occ_file to tiptopgp;
grant insert on occ_file to tiptopgp;
grant references on occ_file to tiptopgp;
grant references on occ_file to ods;
grant select on occ_file to ods;
