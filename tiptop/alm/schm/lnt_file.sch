/*
================================================================================
檔案代號:lnt_file
檔案名稱:合同資料單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnt_file
(
lnt01       nvarchar(20) DEFAULT ' ' NOT NULL, /*合同編號*/
lnt02       nvarchar(20),            /*合同版本號                             */
lnt03       datetime,                /*簽訂日期                               */
lnt04       nvarchar(10),            /*商戶號                                 */
lnt05       nvarchar(1),             /*是否戰盟                               */
lnt06       nvarchar(20),            /*攤位號                                 */
lnt07       nvarchar(10),            /*no use                                 */
lnt08       nvarchar(10),            /*樓棟編號                               */
lnt09       nvarchar(10),            /*樓層編號                               */
lnt10       decimal(18),             /*經營面積                               */
lnt11       decimal(18),             /*建築面積                               */
lnt12       nvarchar(10),            /*結算商戶號                             */
lnt13       nvarchar(1),             /*代收銀返款方式                         */
lnt14       decimal(18),             /*按金額                                 */
lnt15       nvarchar(10),            /*租金付款方式                           */
lnt16       nvarchar(1) DEFAULT ' ' NOT NULL, /*租賃類型*/
lnt17       datetime,                /*租賃期限起日                           */
lnt18       datetime,                /*租賃期限止日                           */
lnt19       datetime,                /*免租期限起日                           */
lnt20       datetime,                /*免租期限止日                           */
lnt21       datetime,                /*計租期限起日                           */
lnt22       datetime,                /*計租期限起日                           */
lnt23       datetime,                /*合同終止日期                           */
lnt24       nvarchar(1),             /*是否簽核                               */
lnt25       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lnt26       nvarchar(1) DEFAULT ' ' NOT NULL, /*審核狀態*/
lnt27       nvarchar(10),            /*初審人                                 */
lnt28       datetime,                /*初審日期                               */
lnt29       nvarchar(50),            /*備注                                   */
lnt30       nvarchar(10),            /*主品牌                                 */
lnt31       nvarchar(10),            /*No Use                                 */
lnt32       nvarchar(10),            /*No Use                                 */
lnt33       nvarchar(10),            /*產品分類                               */
lnt34       nvarchar(10),            /*合同中止人                             */
lnt35       nvarchar(4),             /*稅種                                   */
lnt36       decimal(18),             /*稅率                                   */
lnt37       nvarchar(1),             /*含稅否                                 */
lnt38       nvarchar(1) DEFAULT ' ' NOT NULL, /*展開類型*/
lnt39       smallint,                /*租賃期限                               */
lnt40       nvarchar(20),            /*關聯合同號                             */
lnt41       nvarchar(20),            /*關聯合同版本號                         */
lnt42       decimal(18),             /*增長率                                 */
lnt43       nvarchar(1),             /*零頭是否已處理                         */
lnt44       nvarchar(1),             /*保底按                                 */
lnt45       nvarchar(1),             /*是否整月                               */
lnt46       datetime,                /*終審日期                               */
lnt47       nvarchar(10),            /*終審人                                 */
lnt48       nvarchar(1),             /*狀態                                   */
lnt49       nvarchar(10),            /*原因碼                                 */
lnt50       nvarchar(1),             /*保底金額基準                           */
lnt51       smallint,                /*免租天數                               */
lnt52       datetime,                /*末期起始日期                           */
lnt53       datetime,                /*末期截止日期                           */
lnt54       nvarchar(1) DEFAULT ' ' NOT NULL, /*開票性質*/
lntacti     nvarchar(1),             /*資料有效碼                             */
lntcrat     datetime,                /*資料創建日                             */
lntdate     datetime,                /*最近修改日                             */
lntgrup     nvarchar(10),            /*資料所有群                             */
lntlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
lntmodu     nvarchar(10),            /*資料修改人                             */
lntorig     nvarchar(10),            /*資料建立部門                           */
lntoriu     nvarchar(10),            /*資料建立者                             */
lntstore    nvarchar(10) DEFAULT ' ' NOT NULL,
lntuser     nvarchar(10)             /*資料所有者                             */
);

alter table lnt_file add constraint lnt_pk primary key  (lnt01) deferrable initially deferred;
grant select on lnt_file to tiptopgp;
grant update on lnt_file to tiptopgp;
grant delete on lnt_file to tiptopgp;
grant insert on lnt_file to tiptopgp;
grant references on lnt_file to tiptopgp;
grant references on lnt_file to ods;
grant select on lnt_file to ods;
