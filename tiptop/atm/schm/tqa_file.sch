/*
================================================================================
檔案代號:tqa_file
檔案名稱:基礎代碼檔
檔案目的: 紀錄公司內部所有組織機構的信息,用于業績歸屬和費用歸屬
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqa_file
(
tqa01       nvarchar(10) NOT NULL,   /*營運中心類型                           */
tqa02       nvarchar(80),            /*代碼描述                               */
tqa03       nvarchar(10) NOT NULL,   /*代碼類別                               */
                                     /*1:品類 2:品牌 3:系列 4:型別 5:規格 6:屬性 7:費用支付方式 8:費用支付對象 */
                                     /*9:費用結算方式10系統碼 11:系統區域碼 12:客戶業態 13:合約類別 */
                                     /*14:組織機構類別 15:提案活動類別 16:陳列方式 17:提案檔期類別 */
                                     /*18:提案活動方式 19:通路資料 20:債權資料:*/
tqa04       smallint,                /*層級                                   */
tqa05       decimal(20,6) DEFAULT '0' NOT NULL, /*層級*/
tqa06       decimal(20,6) DEFAULT '0' NOT NULL, /*結束價格*/
tqa07       nvarchar(10),            /*上級品牌編號                           */
tqa08       nvarchar(10),            /*廠家編號                               */
tqaacti     nvarchar(1),             /*資料有效碼                             */
tqadate     datetime,                /*最近修改日                             */
tqagrup     nvarchar(10),            /*資料所有部門                           */
tqamodu     nvarchar(10),            /*資料修改者                             */
tqaorig     nvarchar(10),            /*資料建立部門                           */
tqaoriu     nvarchar(10),            /*資料建立者                             */
tqapos      nvarchar(1) DEFAULT 'N' NOT NULL, /*已傳POS否*/
tqauser     nvarchar(10)             /*資料所有者                             */
);

alter table tqa_file add constraint tqa_pk primary key  (tqa01,tqa03);
grant select on tqa_file to tiptopgp;
grant update on tqa_file to tiptopgp;
grant delete on tqa_file to tiptopgp;
grant insert on tqa_file to tiptopgp;
grant references on tqa_file to tiptopgp;
grant references on tqa_file to ods;
grant select on tqa_file to ods;
