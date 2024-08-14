/*
================================================================================
檔案代號:loa_file
檔案名稱:合同變更數據檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table loa_file
(
loa01       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同編號*/
loa02       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同版本號*/
loa03       datetime,                /*簽訂日期                               */
loa04       nvarchar(10),            /*商戶號                                 */
loa05       nvarchar(1),             /*是否戰盟                               */
loa06       nvarchar(20),            /*攤位號                                 */
loa07       nvarchar(10),            /*no use                                 */
loa08       nvarchar(10),            /*樓棟編號                               */
loa09       nvarchar(10),            /*樓層編號                               */
loa10       decimal(18),             /*經營面積                               */
loa11       decimal(18),             /*建築面積                               */
loa12       nvarchar(10),            /*結算商戶號                             */
loa13       nvarchar(1) DEFAULT ' ' NOT NULL, /*代收銀返款方式*/
loa14       decimal(18),             /*按金額                                 */
loa15       nvarchar(10),            /*租金付款方式                           */
loa16       nvarchar(1) DEFAULT ' ' NOT NULL, /*租賃類型*/
loa17       datetime,                /*租賃期限起日                           */
loa18       datetime,                /*租賃期限止日                           */
loa19       datetime,                /*免租期限起日                           */
loa20       datetime,                /*免租期限止日                           */
loa21       datetime,                /*計租期限起日                           */
loa22       datetime,                /*計租期限起日                           */
loa23       datetime,                /*變更發出日期                           */
loa24       nvarchar(1),             /*是否簽核                               */
loa25       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
loa26       nvarchar(1) DEFAULT ' ' NOT NULL, /*審核狀態*/
loa27       nvarchar(10),            /*初審人                                 */
loa28       datetime,                /*初審日期                               */
loa29       nvarchar(50),            /*備注                                   */
loa30       nvarchar(10),            /*主品牌                                 */
loa31       nvarchar(10),            /*No Use                                 */
loa32       nvarchar(10),            /*No Use                                 */
loa33       nvarchar(10),            /*產品分類                               */
loa34       nvarchar(10),            /*變更發出人                             */
loa35       nvarchar(4),             /*稅種                                   */
loa36       decimal(18),             /*稅率                                   */
loa37       nvarchar(1),             /*含稅否                                 */
loa38       nvarchar(1),             /*展開類型                               */
loa39       smallint,                /*租賃期限                               */
loa40       nvarchar(20),            /*關聯合同號                             */
loa41       nvarchar(20),            /*關聯合同版本號                         */
loa42       decimal(18),             /*增長率                                 */
loa43       nvarchar(1),             /*零頭是否已處理                         */
loa44       nvarchar(1),             /*保底按                                 */
loa45       nvarchar(1),             /*是否整月                               */
loa46       datetime,                /*終審日期                               */
loa47       nvarchar(10),            /*終審人                                 */
loa48       nvarchar(1),             /*狀態                                   */
loa49       nvarchar(10),            /*原因碼                                 */
loa50       nvarchar(1),             /*保底金額基準                           */
loa51       smallint,                /*免租天數                               */
loa52       datetime,                /*末期起始日期                           */
loa53       datetime,                /*末期截止日期                           */
loa54       nvarchar(1) DEFAULT ' ' NOT NULL, /*開票性質*/
loaacti     nvarchar(1),             /*資料有效碼                             */
loacrat     datetime,                /*資料創建日                             */
loadate     datetime,                /*最近修改日                             */
loagrup     nvarchar(10),            /*資料所有群                             */
loalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
loamodu     nvarchar(10),            /*資料修改人                             */
loaorig     nvarchar(10),            /*資料建立部門                           */
loaoriu     nvarchar(10),            /*資料建立者                             */
loaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
loauser     nvarchar(10)             /*資料所有者                             */
);

create        index loaplant_idx on loa_file (loaplant);
alter table loa_file add constraint loa_pk primary key  (loa01,loa02) deferrable initially deferred;
grant select on loa_file to tiptopgp;
grant update on loa_file to tiptopgp;
grant delete on loa_file to tiptopgp;
grant insert on loa_file to tiptopgp;
grant references on loa_file to tiptopgp;
grant references on loa_file to ods;
grant select on loa_file to ods;
