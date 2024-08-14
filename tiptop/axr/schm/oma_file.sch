/*
================================================================================
檔案代號:oma_file
檔案名稱:應收/待抵帳款單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oma_file
(
oma00       nvarchar(2),             /*帳款類別                               */
                                     /*帳款類別 (1*:應收帳款 2*:待抵帳款 3.其他*/
                                     /* 11.訂金應收       21.退貨折讓待抵     */
                                     /* 12.出貨應收       22.雜項待抵         */
                                     /* 13.尾款應收       23.預收(訂金)       */
                                     /* 14.雜項應收       24.暫收(溢收)       */
                                     /*                   25.折扣             */
                                     /* 31.其他應收(不列入應收帳款)           */
oma01       nvarchar(20) NOT NULL,   /*帳款編號                               */
                                     /* 11.訂金號碼       21.待抵單號         */
                                     /* 12.INVOICE#       22.待抵單號         */
                                     /* 13.INVOICE#2      23.待抵單號         */
                                     /* 14.應收單號       24.待抵單號         */
oma02       datetime,                /*帳款日期                               */
oma03       nvarchar(10),            /*帳款客戶編號                           */
                                     /*帳款客戶編號  occ01                    */
                                     /*  MISC: 雜項客戶, 可輸入簡稱           */
oma032      nvarchar(40),            /*帳款客戶簡稱                           */
oma04       nvarchar(10),            /*發票客戶編號                           */
                                     /*發票客戶編號(9605 No use,請由發票檔維護)*/
oma042      nvarchar(20),            /*發票客戶統一編號                       */
                                     /*發票客戶統一編號(9605 No use)          */
oma043      nvarchar(80),            /*發票客戶全名                           */
                                     /*發票客戶全名(9605 No use)              */
oma044      nvarchar(255),           /*發票客戶地址                           */
                                     /*發票客戶地址(9605 No use)              */
oma05       nvarchar(5),             /*發票別                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白               */
oma06       nvarchar(10),            /*客戶分類                               */
                                     /*帳款分類 xx                            */
oma07       nvarchar(1),             /*出貨是否計入未開發票的銷貨             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oma08       nvarchar(1),             /*1.內銷 2.外銷  3.視同外銷              */
                                     /*1.內銷 2.外銷  3.視同外銷->no.A047     */
oma09       datetime,                /*發票日期/折讓單日期                    */
oma10       nvarchar(20),            /*發票號碼                               */
                                     /*發票號碼 (於開立發票後更新)ome01       */
oma11       datetime,                /*應收款日/應扣抵日                      */
oma12       datetime,                /*容許票據到期日                         */
                                     /*容許票據到期日/Null                    */
oma13       nvarchar(10),            /*科目分類碼                             */
                                     /*科目分類碼 ool01                       */
oma14       nvarchar(10),            /*人員編號                               */
                                     /*人員編號  gen01                        */
oma15       nvarchar(10),            /*部門編號                               */
                                     /*部門編號  gem01                        */
oma16       nvarchar(20),            /*訂單單號/出貨單號                      */
                                     /*訂單單號/出貨單號oea01/oga01           */
                                     /* 11.訂單單號       21.退貨單號         */
                                     /* 12.出貨單號       22.參考單號         */
                                     /* 13.出貨單號       23.原帳單號         */
                                     /* 14.參考單號       24.沖帳單號         */
oma161      smallint,                /*訂金應收比率                           */
oma162      smallint,                /*出貨應收比率                           */
oma163      smallint,                /*尾款應收比率                           */
oma165      smallint,                /*期別                                   */
oma17       nvarchar(1),             /*扣抵區分                               */
                                     /*扣抵區分 (1/2)     No:6374             */
oma171      nvarchar(2),             /*格式                                   */
                                     /*格式 (31/32/33/34/35/36)               */
oma172      nvarchar(1),             /*課稅別                                 */
                                     /*課稅別 (1/2/3)                         */
oma173      smallint,                /*申報年度                               */
                                     /*申報年度(西元)                         */
oma174      smallint,                /*申報月份                               */
oma175      integer,                 /*申報流水編號                           */
oma18       nvarchar(24),            /*科目編號                               */
                                     /* 11.應收帳款科目   21.應付銷退款科目   */
                                     /* 12.應收帳款科目   22.待抵科目         */
                                     /* 13.應收帳款科目   23.預收科目         */
                                     /* 14.應收帳款科目   24.溢收科目         */
oma181      nvarchar(24),            /*第二科目編碼                           */
oma19       nvarchar(20),            /*待抵帳款-預收單號                      */
                                     /*  當帳款類別='11'時: 拋轉成的預收單號  */
                                     /*  當帳款類別='12'時: 須沖帳的原預收單號*/
oma20       nvarchar(1),             /*分錄底稿是否可重新產生                 */
                                     /*分錄底稿是否可重新產生(Y/N)            */
                                     /*  設為'N'時表示分錄底稿不必產生,       */
                                     /*         或表示分錄底稿有經過人為修改, */
                                     /*         當執行'分錄產生'時, 不可再產生*/
oma21       nvarchar(4),             /*稅別                                   */
                                     /*稅別        gec01                      */
oma211      decimal(18),             /*稅率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oma212      nvarchar(1),             /*聯數                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oma213      nvarchar(1),             /*含稅否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oma23       nvarchar(4),             /*幣別                                   */
                                     /*幣別   azi01                           */
oma24       decimal(18),             /*匯率                                   */
                                     /*匯率 (更改時將更新單身本幣單價金額)    */
oma25       nvarchar(10),            /*銷售分類一                             */
                                     /*銷售分類一 oab01                       */
oma26       nvarchar(10),            /*銷售分類二                             */
                                     /*銷售分類二 oab01                       */
oma32       nvarchar(6),             /*收款條件編號                           */
                                     /*收款條件編號 oag01                     */
oma33       nvarchar(20),            /*拋轉傳票號                             */
                                     /*拋轉傳票號 npp01                       */
oma34       nvarchar(1),             /*銷退方式                               */
                                     /*No use-> 銷退方式 010416               */
oma35       nvarchar(1),             /*外銷方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7)  01/04/23 add  */
oma36       nvarchar(8),             /*非經海關証明文件名稱                   */
                                     /*非經海關証明文件名稱     01/04/23 add  */
oma37       nvarchar(16),            /*非經海關証明文件號碼                   */
                                     /*非經海關証明文件號碼     01/04/23 add  */
oma38       nvarchar(10),            /*出口報單類別                           */
                                     /*出口報單類別             01/04/23 add  */
oma39       nvarchar(30),            /*出口報單號碼                           */
                                     /*出口報單號碼             01/04/23 add  */
oma40       nvarchar(1),             /*關係人否                               */
oma50       decimal(18) NOT NULL,    /*原幣原訂金或出貨總未稅金額             */
oma50t      decimal(18) NOT NULL,    /*原幣原訂金或出貨總含稅金額             */
oma51       decimal(18),             /*本幣直接沖帳金額                       */
oma51f      decimal(18),             /*原幣直接沖帳金額                       */
oma52       decimal(18) NOT NULL,    /*原幣預收訂金轉銷貨收入金額             */
                                     /*原幣預收訂金轉銷貨收入金額 / 0         */
oma53       decimal(18) NOT NULL,    /*本幣預收訂金轉銷貨收入金額             */
                                     /*本幣預收訂金轉銷貨收入金額 / 0         */
oma54       decimal(18) NOT NULL,    /*原幣應收未稅金額 / 待抵未稅            */
oma54t      decimal(18) NOT NULL,    /*原幣應收含稅金額 / 待抵含稅            */
oma54x      decimal(18) NOT NULL,    /*原幣應收稅額  / 待抵稅額               */
                                     /*原幣應收稅額     / 待抵稅額            */
oma55       decimal(18) NOT NULL,    /*原幣已沖帳金額                         */
oma56       decimal(18) NOT NULL,    /*本幣應收未稅金額 / 待抵未稅            */
oma56t      decimal(18) NOT NULL,    /*本幣應收含稅金額 / 待抵含稅            */
oma56x      decimal(18) NOT NULL,    /*本幣應收稅額  / 待抵稅額               */
                                     /*本幣應收稅額     / 待抵稅額            */
oma57       decimal(18) NOT NULL,    /*本幣已沖帳金額                         */
oma58       decimal(18),             /*發票匯率                               */
                                     /*發票匯率 (更改時將更新單身發票單價金額)*/
oma59       decimal(18),             /*本幣發票未稅金額                       */
oma59t      decimal(18),             /*本幣發票含稅金額                       */
oma59x      decimal(18),             /*本幣發票稅額                           */
oma60       decimal(18),             /*重估匯率                               */
oma61       decimal(18),             /*本幣未沖金額                           */
oma62       nvarchar(20),            /*覆出單號                               */
                                     /*覆出單號                     養生NO:7257*/
oma63       nvarchar(10),            /*專案編號                               */
                                     /*專案編號                     養生NO:7258*/
oma64       nvarchar(1),             /*狀況碼                                 */
oma65       nvarchar(1),             /*收款處理(1.轉應收帳款 2.直接           */
oma66       nvarchar(10),            /*出貨來源營運中心代碼                   */
oma67       nvarchar(20),            /*Invoice No.                            */
oma68       nvarchar(10),            /*收款客戶                               */
oma69       nvarchar(40),            /*收款客戶簡稱                           */
oma70       nvarchar(1),             /*來源類型                               */
oma71       nvarchar(20),            /*申報統編                               */
oma72       nvarchar(20),            /*開帳來源AR單據號碼                     */
oma930      nvarchar(10),            /*成本中心                               */
oma99       nvarchar(17),            /*多角序號                               */
                                     /*多角序號                         No.8161*/
oma992      nvarchar(20),            /*集團代付單號                           */
                                     /*For 內部帳戶                           */
omaconf     nvarchar(1),             /*確認否                                 */
                                     /*確認否 (Y/N)                           */
omadate     datetime,                /*最近修改日                             */
omagrup     nvarchar(10),            /*資料所有部門                           */
omalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
omamksg     nvarchar(1),             /*簽核否？                               */
omamodu     nvarchar(10),            /*資料修改者                             */
omaorig     nvarchar(10),            /*資料建立部門                           */
omaoriu     nvarchar(10),            /*資料建立者                             */
omaprsw     smallint,                /*列印次數                               */
omaud01     nvarchar(255),           /*自訂欄位-Textedit                      */
omaud02     nvarchar(40),            /*自訂欄位-文字                          */
omaud03     nvarchar(40),            /*自訂欄位-文字                          */
omaud04     nvarchar(40),            /*自訂欄位-文字                          */
omaud05     nvarchar(40),            /*自訂欄位-文字                          */
omaud06     nvarchar(40),            /*自訂欄位-文字                          */
omaud07     decimal(18),             /*自訂欄位-數值                          */
omaud08     decimal(18),             /*自訂欄位-數值                          */
omaud09     decimal(18),             /*自訂欄位-數值                          */
omaud10     integer,                 /*自訂欄位-整數                          */
omaud11     integer,                 /*自訂欄位-整數                          */
omaud12     integer,                 /*自訂欄位-整數                          */
omaud13     datetime,                /*自訂欄位-日期                          */
omaud14     datetime,                /*自訂欄位-日期                          */
omaud15     datetime,                /*自訂欄位-日期                          */
omauser     nvarchar(10),            /*資料所有者                             */
omavoid     nvarchar(1),             /*作廢否                                 */
                                     /*作廢否 (Y/N)                           */
omavoid2    nvarchar(10)             /*作廢理由碼                             */
                                     /*作廢理由碼 oak01,oak03='2'             */
);

create        index oma99 on oma_file (oma99);
create        index oma_02 on oma_file (oma16);
create        index oma_03 on oma_file (oma02);
create        index oma_04 on oma_file (oma10);
create        index oma_06 on oma_file (oma33);
alter table oma_file add constraint oma_pk primary key  (oma01);
grant select on oma_file to tiptopgp;
grant update on oma_file to tiptopgp;
grant delete on oma_file to tiptopgp;
grant insert on oma_file to tiptopgp;
grant references on oma_file to tiptopgp;
grant references on oma_file to ods;
grant select on oma_file to ods;
