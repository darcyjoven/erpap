/*
================================================================================
檔案代號:occa_file
檔案名稱:客戶申請主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table occa_file
(
occa00      nvarchar(1),             /*申請類別(I:新增 U:修改)                */
occa01      nvarchar(10),            /*客戶編號                               */
occa011     nvarchar(10),            /*申請客戶編號                           */
occa02      nvarchar(40),            /*客戶簡稱                               */
occa03      nvarchar(10),            /*客戶分類                               */
occa04      nvarchar(10),            /*負責業務員編號                         */
occa05      nvarchar(1),             /*1.永久性 2.暫時性                      */
occa06      nvarchar(1),             /*性質(1.買受人 2.送貨客戶 3.收          */
occa07      nvarchar(10),            /*收款客戶編號                           */
occa08      nvarchar(5),             /*慣用發票別                             */
occa09      nvarchar(10),            /*送貨客戶編號                           */
occa10      nvarchar(1),             /*是否簽核                               */
occa1001    datetime,                /*營業職照有效開始日期                   */
occa1002    datetime,                /*營業職照失效開始日期                   */
occa1003    nvarchar(10),            /*所屬業態                               */
occa1004    nvarchar(1),             /*狀態碼                                 */
occa1005    nvarchar(10),            /*所屬機構                               */
occa1006    nvarchar(10),            /*所屬通路                               */
occa1007    nvarchar(10),            /*系統碼                                 */
occa1008    nvarchar(10),            /*系統區域碼                             */
occa1009    nvarchar(10),            /*省份/特區                              */
occa1010    nvarchar(10),            /*地市級/區                              */
occa1011    nvarchar(10),            /*區/縣/市                               */
occa1012    nvarchar(255),           /*實際公司地址                           */
occa1013    nvarchar(10),            /*賣場面積                               */
occa1014    nvarchar(10),            /*連鎖店數                               */
occa1015    datetime,                /*門店開業日                             */
occa1016    nvarchar(10),            /*慣用出貨倉庫                           */
occa1017    nvarchar(20),            /*稅務登記証號                           */
occa1018    datetime,                /*稅務登記証有效開始期                   */
occa1019    datetime,                /*稅務登記証有效截止期                   */
occa1020    nvarchar(10),            /*納稅人識別號                           */
occa1021    nvarchar(80),            /*發票全稱                               */
occa1022    nvarchar(10),            /*發票客戶編號                           */
occa1023    nvarchar(10),            /*收款客戶編號                           */
occa1024    nvarchar(10),            /*業績歸屬機構                           */
occa1025    nvarchar(10),            /*費用歸屬機構                           */
occa1026    smallint,                /*對帳日                                 */
occa1027    nvarchar(1),             /*是否更改訂單單價                       */
occa1028    decimal(18),             /*慣用訂價折扣率                         */
occa1029    nvarchar(10),            /*代送商                                 */
occa11      nvarchar(20),            /*統一發票                               */
occa12      datetime,                /*創業日                                 */
occa13      decimal(18),             /*資本額                                 */
occa14      decimal(18),             /*年營業額                               */
occa15      decimal(18),             /*員工人數                               */
occa16      datetime,                /*No Use                                 */
occa171     datetime,                /*No Use                                 */
occa172     datetime,                /*No Use                                 */
occa173     datetime,                /*No Use                                 */
occa174     datetime,                /*No Use                                 */
occa175     datetime,                /*信用額度有效日期                       */
occa18      nvarchar(80),            /*公司全名(1)                            */
occa19      nvarchar(80),            /*公司全名(2)                            */
occa20      nvarchar(10),            /*區域編號                               */
occa21      nvarchar(10),            /*國別編號                               */
occa22      nvarchar(10),            /*地區別                                 */
occa231     nvarchar(255),           /*發票地址-1                             */
occa232     nvarchar(255),           /*發票地址-2                             */
occa233     nvarchar(255),           /*發票地址-3                             */
occa241     nvarchar(255),           /*送貨地址-1                             */
occa242     nvarchar(255),           /*送貨地址-2                             */
occa243     nvarchar(255),           /*送貨地址-3                             */
occa261     nvarchar(40),            /*tel no-1                               */
occa262     nvarchar(40),            /*tel no-2                               */
occa263     nvarchar(40),            /*tel no-3                               */
occa271     nvarchar(40),            /*fax no-1                               */
occa272     nvarchar(40),            /*fax no-2                               */
occa273     nvarchar(40),            /*fax no-2                               */
occa28      nvarchar(40),            /*公司負責人                             */
occa29      nvarchar(40),            /*業務聯絡人                             */
occa292     nvarchar(5),             /*業務聯絡人分機號碼                     */
occa30      nvarchar(40),            /*財務聯絡人                             */
occa302     nvarchar(5),             /*財務聯絡人分機號碼                     */
occa31      nvarchar(1),             /*客戶銷售庫存管理否                     */
occa32      decimal(18),             /*最大折扣率                             */
occa33      nvarchar(10),            /*額度客戶                               */
occa34      nvarchar(10),            /*集團碼                                 */
occa35      nvarchar(10),            /*郵遞區號                               */
occa36      smallint,                /*寬限天數                               */
occa37      nvarchar(1),             /*是否為關係人(y/n)                      */
occa38      nvarchar(2),             /*客戶月結日                             */
occa39      nvarchar(2),             /*客戶付款日                             */
occa39a     nvarchar(2),             /*客戶付款日二                           */
occa40      nvarchar(1),             /*月底重評價                             */
                                     /*視為本幣AR否(Y/N)                      */
                                     /*  對於美金報價本幣付款的客戶,雖然以原幣*/
                                     /*  立帳, 但視為本幣AR, 月底不必作匯差調整*/
occa41      nvarchar(4),             /*慣用稅別                               */
occa42      nvarchar(4),             /*慣用幣別                               */
occa43      nvarchar(10),            /*慣用銷售分類                           */
occa44      nvarchar(6),             /*慣用價格條件                           */
occa45      nvarchar(6),             /*慣用收款條件                           */
occa46      nvarchar(80),            /*慣用其它條件                           */
occa47      nvarchar(10),            /*慣用交運方式                           */
occa48      nvarchar(10),            /*慣用起運港口                           */
occa49      nvarchar(10),            /*慣用到達港口                           */
occa50      nvarchar(10),            /*慣用卸貨港口                           */
occa51      nvarchar(10),            /*慣用forwarder(客戶編號)                */
occa52      nvarchar(10),            /*慣用notify                             */
occa53      smallint,                /*慣用佣金率%                            */
occa55      nvarchar(1),             /*慣用文件列印語言(0.中文 1.英           */
occa56      nvarchar(1),             /*須出貨通知單否                         */
occa57      nvarchar(1),             /*須製作包裝單否                         */
occa61      nvarchar(10),            /*信用評等                               */
occa62      nvarchar(1),             /*信用查核否                             */
occa63      decimal(18),             /*信用額度                               */
occa631     nvarchar(4),             /*額度幣別                               */
occa64      smallint,                /*信用額度容許超出比率                   */
occa65      nvarchar(1),             /*客戶出貨簽收否                         */
occa66      nvarchar(10),            /*代送商代號                             */
occa67      nvarchar(10),            /*慣用科目類別                           */
occa701     nvarchar(255),           /*備註-1                                 */
occa702     nvarchar(255),           /*備註-2                                 */
occa703     nvarchar(255),           /*備註-3                                 */
occa704     nvarchar(255),           /*備註-4                                 */
occaacti    nvarchar(1),             /*資料有效碼                             */
occadate    datetime,                /*最近修改日                             */
occagrup    nvarchar(10),            /*資料所有部門                           */
occamodu    nvarchar(10),            /*資料修改者                             */
occano      nvarchar(80) NOT NULL,   /*申請單號                               */
occaorig    nvarchar(10),            /*資料建立部門                           */
occaoriu    nvarchar(10),            /*資料建立者                             */
occaud01    nvarchar(255),           /*自訂欄位                               */
occaud02    nvarchar(40),            /*自訂欄位                               */
occaud03    nvarchar(40),            /*自訂欄位                               */
occaud04    nvarchar(40),            /*自訂欄位                               */
occaud05    nvarchar(40),            /*自訂欄位                               */
occaud06    nvarchar(40),            /*自訂欄位                               */
occaud07    decimal(18),             /*自訂欄位                               */
occaud08    decimal(18),             /*自訂欄位                               */
occaud09    decimal(18),             /*自訂欄位                               */
occaud10    integer,                 /*自訂欄位                               */
occaud11    integer,                 /*自訂欄位                               */
occaud12    integer,                 /*自訂欄位                               */
occaud13    datetime,                /*自訂欄位                               */
occaud14    datetime,                /*自訂欄位                               */
occaud15    datetime,                /*自訂欄位                               */
occauser    nvarchar(10)             /*資料所有者                             */
);

alter table occa_file add constraint occa_pk primary key  (occano);
grant select on occa_file to tiptopgp;
grant update on occa_file to tiptopgp;
grant delete on occa_file to tiptopgp;
grant insert on occa_file to tiptopgp;
grant references on occa_file to tiptopgp;
grant references on occa_file to ods;
grant select on occa_file to ods;
