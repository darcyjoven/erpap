/*
================================================================================
檔案代號:oep_file
檔案名稱:訂單變更單單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oep_file
(
oep01       nvarchar(20) NOT NULL,   /*訂單單號                               */
oep02       smallint NOT NULL,       /*變更序號                               */
                                     /*變更序號  99/07/23 modify              */
oep04       datetime,                /*變更日期                               */
oep05       nvarchar(1),             /*No Use                                 */
oep06       nvarchar(10),            /*送貨地址                               */
                                     /*送貨地址         #no.7214 alter        */
oep06b      nvarchar(10),            /*變更送貨地址                           */
                                     /*變更送貨地址     #no.7214 alter        */
oep07       nvarchar(6),             /*原收款條件                             */
oep07b      nvarchar(6),             /*變更收款條件                           */
oep08       nvarchar(4),             /*原幣別                                 */
oep08b      nvarchar(4),             /*變更幣別                               */
oep09       nvarchar(1),             /*狀況碼                                 */
                                     /*狀況碼:0.送簽中  1.已核淮    2.發出    */
                                     /*#6686  S.送簽    R.送簽退回  W.抽單    */
oep10       nvarchar(6),             /*價格條件                               */
oep10b      nvarchar(6),             /*變更價格條件                           */
oep11       nvarchar(20),            /*交運方式                               */
oep11b      nvarchar(20),            /*變更交運方式                           */
oep12       nvarchar(10),            /*變更人員                               */
oep13       nvarchar(10),            /*變更理由碼                             */
oep14       nvarchar(4),             /*變更前稅別                             */
oep14b      nvarchar(4),             /*變更後稅別                             */
oep15       nvarchar(30),            /*變更前客戶訂單編號                     */
oep15b      nvarchar(30),            /*變更後客戶訂單編號                     */
oep161      smallint,                /*原訂金比率                             */
oep161b     smallint,                /*變更訂金比率                           */
oep162      smallint,                /*原出貨比率                             */
oep162b     smallint,                /*變更出貨比率                           */
oep163      smallint,                /*原尾款比率                             */
oep163b     smallint,                /*變更尾款比率                           */
oep261      decimal(18),             /*原訂金金額                             */
oep261b     decimal(18),             /*變更訂金金額                           */
oep262      decimal(18),             /*原出貨金額                             */
oep262b     decimal(18),             /*變更出貨金額                           */
oep263      decimal(18),             /*原尾款金額                             */
oep263b     decimal(18),             /*變更尾款金額                           */
oepacti     nvarchar(1),             /*資料有效碼                             */
oepconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否(Y/N/X)                          */
oepdate     datetime,                /*最近修改日                             */
oepdays     smallint,                /*簽核完成天數                           */
oepgrup     nvarchar(10),            /*資料所有部門                           */
oeplegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
oepmksg     nvarchar(1),             /*是否簽核                               */
                                     /*本欄位可控制此張訂購變更單是否需簽核， */
                                     /*如需簽核為自動賦與簽核等級或自行設定簽核*/
                                     /*等級可在單據性質檔中控制，因此簽核的控制*/
                                     /*亦可利用單據性質檔來控制               */
oepmodu     nvarchar(10),            /*資料修改者                             */
oeporig     nvarchar(10),            /*資料建立部門                           */
oeporiu     nvarchar(10),            /*資料建立者                             */
oepplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
oepprit     smallint,                /*簽核優先等級                           */
oepsign     nvarchar(4),             /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepsmax     smallint,                /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購變更單應簽的人數               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepsseq     smallint,                /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購變更單已簽的人數               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepud01     nvarchar(255),           /*自訂欄位-Textedit                      */
oepud02     nvarchar(40),            /*自訂欄位-文字                          */
oepud03     nvarchar(40),            /*自訂欄位-文字                          */
oepud04     nvarchar(40),            /*自訂欄位-文字                          */
oepud05     nvarchar(40),            /*自訂欄位-文字                          */
oepud06     nvarchar(40),            /*自訂欄位-文字                          */
oepud07     decimal(18),             /*自訂欄位-數值                          */
oepud08     decimal(18),             /*自訂欄位-數值                          */
oepud09     decimal(18),             /*自訂欄位-數值                          */
oepud10     integer,                 /*自訂欄位-整數                          */
oepud11     integer,                 /*自訂欄位-整數                          */
oepud12     integer,                 /*自訂欄位-整數                          */
oepud13     datetime,                /*自訂欄位-日期                          */
oepud14     datetime,                /*自訂欄位-日期                          */
oepud15     datetime,                /*自訂欄位-日期                          */
oepuser     nvarchar(10)             /*資料所有者                             */
);

create        index oepplant_idx on oep_file (oepplant);
alter table oep_file add constraint oep_pk primary key  (oep01,oep02);
grant select on oep_file to tiptopgp;
grant update on oep_file to tiptopgp;
grant delete on oep_file to tiptopgp;
grant insert on oep_file to tiptopgp;
grant references on oep_file to tiptopgp;
grant references on oep_file to ods;
grant select on oep_file to ods;
