/*
================================================================================
檔案代號:rae_file
檔案名稱:組合促銷單頭表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rae_file
(
rae01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rae02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rae03       nvarchar(20) DEFAULT ' ' NOT NULL, /*活動代碼*/
rae04       datetime,                /*促銷開始日期                           */
rae05       datetime,                /*促銷結束日期                           */
rae06       nvarchar(8),             /*促銷開始時間                           */
rae07       nvarchar(8),             /*促銷結束時間                           */
rae08       nvarchar(1),             /*週期否                                 */
rae09       nvarchar(1),             /*限定否                                 */
rae10       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷方式1.特價2.折扣3.折讓*/
rae11       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否會員專享*/
rae12       nvarchar(1) DEFAULT ' ' NOT NULL, /*依會員等級促銷否*/
rae13       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與收券*/
rae14       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與積分*/
rae15       decimal(18) DEFAULT '0' NOT NULL, /*特賣價*/
rae16       decimal(18),             /*折扣率%                                */
rae17       decimal(18) DEFAULT '0' NOT NULL, /*折讓額*/
rae18       decimal(18) DEFAULT '0' NOT NULL, /*會員特賣價*/
rae19       decimal(18),             /*會員折扣率%                            */
rae20       decimal(18) DEFAULT '0' NOT NULL, /*會員折讓額*/
rae21       smallint DEFAULT 0,      /*組合總量                               */
rae22       nvarchar(255),           /*備註                                   */
rae23       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加滿額促銷*/
rae24       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加返券促銷*/
rae25       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加聯盟卡折扣*/
rae26       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加會員卡折扣*/
rae27       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與換購*/
rae28       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷實現方式1.交易中2.交易後*/
rae29       nvarchar(1) DEFAULT ' ' NOT NULL, /*換贈方式1.超量2.倍量*/
rae30       nvarchar(1) DEFAULT ' ' NOT NULL, /*換贈類型1.單選2.多選*/
rae31       smallint,                /*最多可選數量                           */
rae900      nvarchar(1) DEFAULT ' ' NOT NULL, /*狀況碼0.開立1.已核准9.作廢R.  */
raeacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
raecond     datetime,                /*確認日期                               */
raeconf     nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
raecont     nvarchar(8),             /*確認時間                               */
raeconu     nvarchar(10),            /*確認人員                               */
raecrat     datetime,                /*資料創建日                             */
raedate     datetime,                /*最近修改日                             */
raedays     smallint,                /*簽核完成天數                           */
raegrup     nvarchar(10),            /*資料所有部門                           */
raelegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
raemksg     nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
raemodu     nvarchar(10),            /*最近修改人                             */
raeorig     nvarchar(10),            /*資料創建部門                           */
raeoriu     nvarchar(10),            /*資料建立者                             */
raeplant    nvarchar(10) DEFAULT ' ' NOT NULL, /*所屬營運中心*/
raepos      nvarchar(1) DEFAULT ' ' NOT NULL, /*已傳POS否*/
raeprit     smallint,                /*簽核優先等級                           */
raesign     nvarchar(4),             /*簽核等級                               */
raesmax     smallint,                /*應簽核順序                             */
raesseq     smallint,                /*已簽核順序                             */
raeuser     nvarchar(10)             /*資料所有者                             */
);

alter table rae_file add constraint rae_pk primary key  (rae01,rae02,raeplant);
grant select on rae_file to tiptopgp;
grant update on rae_file to tiptopgp;
grant delete on rae_file to tiptopgp;
grant insert on rae_file to tiptopgp;
grant references on rae_file to tiptopgp;
grant references on rae_file to ods;
grant select on rae_file to ods;
