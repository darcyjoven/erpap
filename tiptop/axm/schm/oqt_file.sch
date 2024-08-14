/*
================================================================================
檔案代號:oqt_file
檔案名稱:報價單單頭資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqt_file
(
oqt01       nvarchar(20) NOT NULL,   /*報價單號                               */
oqt02       datetime,                /*日期                                   */
oqt03       nvarchar(20),            /*客戶單號                               */
oqt04       nvarchar(10),            /*客戶編號                               */
oqt041      nvarchar(80),            /*客戶全名                               */
                                     /*客戶全名     char(40)->char(72) 01/12/27*/
oqt051      nvarchar(255),           /*客戶地址1                              */
oqt052      nvarchar(255),           /*客戶地址2                              */
oqt053      nvarchar(255),           /*客戶地址3                              */
oqt054      nvarchar(255),           /*客戶地址4                              */
oqt055      nvarchar(255),           /*客戶地址-5                             */
oqt06       nvarchar(10),            /*部門                                   */
oqt07       nvarchar(10),            /*業務員編號                             */
oqt08       nvarchar(80),            /*目的地                                 */
oqt09       nvarchar(4),             /*幣別                                   */
oqt091      nvarchar(4),             /*No Use                                 */
oqt10       nvarchar(8),             /*價格條件                               */
oqt11       nvarchar(10),            /*運輸方式                               */
oqt12       nvarchar(1),             /*分量計價                               */
                                     /*分量計價 Y/N                           */
oqt13       nvarchar(80),            /*抬頭                                   */
oqt141      nvarchar(255),           /*文件內容1                              */
oqt142      nvarchar(255),           /*文件內容2                              */
oqt143      nvarchar(255),           /*文件內容3                              */
oqt151      nvarchar(255),           /*收款-1                                 */
oqt152      nvarchar(255),           /*收款-2                                 */
oqt161      nvarchar(255),           /*出貨-1                                 */
oqt162      nvarchar(255),           /*出貨-2                                 */
oqt171      nvarchar(255),           /*包裝-1                                 */
oqt172      nvarchar(255),           /*包裝-2                                 */
oqt173      nvarchar(255),           /*包裝-3                                 */
oqt181      nvarchar(255),           /*保險-1                                 */
oqt182      nvarchar(255),           /*保險-2                                 */
oqt191      nvarchar(255),           /*有效碼-1                               */
oqt192      nvarchar(255),           /*有效碼-2                               */
oqt20       nvarchar(40),            /*簽名人                                 */
oqt21       nvarchar(1),             /*狀況碼                                 */
                                     /*狀況碼:                 #no:6686       */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
oqt22       nvarchar(1),             /*簽核否                                 */
                                     /*簽核否                  #no:6686       */
oqt23       nvarchar(20),            /*估價單號                               */
oqt24       nvarchar(4),             /*稅別                                   */
oqt25       nvarchar(6),             /*收款條件                               */
oqt26       nvarchar(10),            /*起運地                                 */
oqt27       nvarchar(10),            /*到達地                                 */
oqtacti     nvarchar(1),             /*資料有效碼                             */
oqtconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否(Y/N/X)                          */
oqtdate     datetime,                /*最近修改日                             */
oqtgrup     nvarchar(10),            /*資料所有部門                           */
oqtlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oqtmodu     nvarchar(10),            /*資料修改者                             */
oqtorig     nvarchar(10),            /*資料建立部門                           */
oqtoriu     nvarchar(10),            /*資料建立者                             */
oqtplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oqtud01     nvarchar(255),           /*自訂欄位-Textedit                      */
oqtud02     nvarchar(40),            /*自訂欄位-文字                          */
oqtud03     nvarchar(40),            /*自訂欄位-文字                          */
oqtud04     nvarchar(40),            /*自訂欄位-文字                          */
oqtud05     nvarchar(40),            /*自訂欄位-文字                          */
oqtud06     nvarchar(40),            /*自訂欄位-文字                          */
oqtud07     decimal(18),             /*自訂欄位-數值                          */
oqtud08     decimal(18),             /*自訂欄位-數值                          */
oqtud09     decimal(18),             /*自訂欄位-數值                          */
oqtud10     integer,                 /*自訂欄位-整數                          */
oqtud11     integer,                 /*自訂欄位-整數                          */
oqtud12     integer,                 /*自訂欄位-整數                          */
oqtud13     datetime,                /*自訂欄位-日期                          */
oqtud14     datetime,                /*自訂欄位-日期                          */
oqtud15     datetime,                /*自訂欄位-日期                          */
oqtuser     nvarchar(10)             /*資料所有者                             */
);

create        index oqtplant_idx on oqt_file (oqtplant);
alter table oqt_file add constraint oqt_pk primary key  (oqt01);
grant select on oqt_file to tiptopgp;
grant update on oqt_file to tiptopgp;
grant delete on oqt_file to tiptopgp;
grant insert on oqt_file to tiptopgp;
grant references on oqt_file to tiptopgp;
grant references on oqt_file to ods;
grant select on oqt_file to ods;
