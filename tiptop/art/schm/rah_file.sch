/*
================================================================================
檔案代號:rah_file
檔案名稱:滿額促銷單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rah_file
(
rah01       nvarchar(10) DEFAULT ' ' NOT NULL, /*制定機構*/
rah02       nvarchar(20) DEFAULT ' ' NOT NULL, /*促銷單號*/
rah03       nvarchar(20) DEFAULT ' ' NOT NULL, /*活動代碼*/
rah04       datetime,                /*促銷開始日期                           */
rah05       datetime,                /*促銷結束日期                           */
rah06       nvarchar(8),             /*促銷開始時間                           */
rah07       nvarchar(8),             /*促銷結束時間                           */
rah08       nvarchar(1) DEFAULT ' ' NOT NULL, /*週期否*/
rah09       nvarchar(1) DEFAULT ' ' NOT NULL, /*限定否*/
rah10       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷方式*/
                                     /*2.折扣 3.折讓                          */
rah11       nvarchar(1) DEFAULT ' ' NOT NULL, /*參与方式*/
                                     /*1.整單促銷 2.範圍促銷                  */
rah12       nvarchar(1) DEFAULT ' ' NOT NULL, /*分段計算否*/
rah13       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否會員專享*/
rah14       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與收券*/
rah15       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與積分*/
rah16       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加返券促銷*/
rah17       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加聯盟卡折扣*/
rah18       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參加會員卡折扣*/
rah19       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否參與換贈*/
rah20       nvarchar(1) DEFAULT ' ' NOT NULL, /*促銷實現方式*/
                                     /*1.交易中 2.交易后                      */
rah21       nvarchar(1) DEFAULT ' ' NOT NULL, /*換贈方式*/
                                     /*1. 超量 2.倍量                         */
rah22       nvarchar(1) DEFAULT ' ' NOT NULL, /*換贈類型*/
                                     /*1.單選 2.多選                          */
rah23       smallint,                /*最多可選數量                           */
rah24       nvarchar(255),           /*備註                                   */
rah25       nvarchar(1) DEFAULT '1' NOT NULL, /*條件規則1.滿額2.滿量*/
rah900      nvarchar(1) DEFAULT '0' NOT NULL, /*狀況碼*/
                                     /*0:開立,1:已核准,9:作廢,R:送簽,S:送簽退回,W:抽單*/
rahacti     nvarchar(1) DEFAULT 'Y' NOT NULL, /*資料有效碼*/
rahcond     datetime,                /*確認日期                               */
rahconf     nvarchar(1) DEFAULT 'N' NOT NULL, /*確認碼*/
                                     /*Y.已確認 N.未確認 X.已作废             */
rahcont     nvarchar(8),             /*確認時間                               */
rahconu     nvarchar(10),            /*確認人員                               */
rahcrat     datetime,                /*資料創建日                             */
rahdate     datetime,                /*最近修改日                             */
rahdays     smallint,                /*簽核完成天數                           */
rahgrup     nvarchar(10),            /*資料所有部門                           */
rahlegal    nvarchar(10) DEFAULT ' ' NOT NULL, /*法人別*/
rahmksg     nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
rahmodu     nvarchar(10),            /*資料修改者                             */
rahorig     nvarchar(10),            /*資料建立部門                           */
rahoriu     nvarchar(10),            /*資料建立者                             */
rahplant    nvarchar(10) DEFAULT ' ' NOT NULL, /*所屬營運中心*/
rahpos      nvarchar(1) DEFAULT 'N' NOT NULL, /*已傳POS否*/
rahprit     smallint,                /*簽核優先等級                           */
rahsign     nvarchar(4),             /*簽核等級                               */
rahsmax     smallint,                /*應簽核順序                             */
rahsseq     smallint,                /*已簽核順序                             */
rahuser     nvarchar(10)             /*資料所有者                             */
);

alter table rah_file add constraint rah_pk primary key  (rah01,rah02,rahplant);
grant select on rah_file to tiptopgp;
grant update on rah_file to tiptopgp;
grant delete on rah_file to tiptopgp;
grant insert on rah_file to tiptopgp;
grant references on rah_file to tiptopgp;
grant references on rah_file to ods;
grant select on rah_file to ods;
