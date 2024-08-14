/*
================================================================================
檔案代號:aaz_file
檔案名稱:總帳會計系統參數檔(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table aaz_file
(
aaz00       nvarchar(1) NOT NULL,    /*KEY, VALUE(0), 隱藏欄位                */
aaz01       nvarchar(1),             /*No Use                                 */
aaz02       nvarchar(1),             /*No Use                                 */
aaz03       nvarchar(1),             /*No Use                                 */
aaz04       nvarchar(1),             /*No Use                                 */
aaz05       nvarchar(1),             /*No Use                                 */
aaz06       nvarchar(1),             /*No Use                                 */
aaz07       nvarchar(1),             /*No Use                                 */
aaz08       nvarchar(1),             /*No Use                                 */
aaz09       nvarchar(1),             /*No Use                                 */
aaz100      nvarchar(24),            /*合併銷貨收入科目      (關係人          */
aaz101      nvarchar(24),            /*合併資產交易損益科目  (關係            */
aaz102      nvarchar(24),            /*合併本期損益科目      (長期投          */
aaz103      nvarchar(24),            /*合併投資收益科目      (長期投          */
aaz104      nvarchar(24),            /*No Use                                 */
aaz105      nvarchar(24),            /*no use                                 */
aaz106      nvarchar(24),            /*no ues                                 */
aaz107      nvarchar(2),             /*科目編號首段碼長                       */
aaz108      nvarchar(2),             /*科目編號其它段碼長                     */
aaz109      nvarchar(24),            /*未實現銷貨利益(關係人交易)             */
aaz110      nvarchar(24),            /*遞延貸項(關係人交易)                   */
aaz111      nvarchar(24),            /*未實現銷貨損失                         */
aaz112      nvarchar(24),            /*遞延貸項                               */
aaz113      nvarchar(24),            /*本期損益(IS)                           */
aaz114      nvarchar(24),            /*本期損益(BS)                           */
aaz115      nvarchar(1) DEFAULT ' ' NOT NULL, /*傳票輸入時自動按缺號產生*/
aaz119      nvarchar(1) DEFAULT 'Y' NOT NULL, /*顯示核算項名稱*/
aaz120      nvarchar(24),            /*再衡量兌換損失科目                     */
aaz121      nvarchar(10),            /*異動碼-5類型代號                       */
aaz1211     nvarchar(1) DEFAULT ' ' NOT NULL, /*異動碼-5輸入控制*/
aaz122      nvarchar(10),            /*異動碼-6類型代號                       */
aaz1221     nvarchar(1) DEFAULT ' ' NOT NULL, /*異動碼-6輸入控制*/
aaz123      nvarchar(10),            /*異動碼-7類型代號                       */
aaz1231     nvarchar(1) DEFAULT ' ' NOT NULL, /*異動碼-7輸入控制*/
aaz124      nvarchar(10),            /*異動碼-8類型代號                       */
aaz1241     nvarchar(1) DEFAULT ' ' NOT NULL, /*異動碼-8輸入控制*/
aaz21       smallint,                /*No Use                                 */
aaz211      nvarchar(4),             /*No Use                                 */
aaz212      nvarchar(8),             /*No Use                                 */
aaz22       smallint,                /*No Use                                 */
aaz221      nvarchar(4),             /*No Use                                 */
aaz222      nvarchar(8),             /*No Use                                 */
aaz23       smallint,                /*No Use                                 */
aaz231      nvarchar(4),             /*No Use                                 */
aaz232      nvarchar(8),             /*No Use                                 */
aaz24       smallint,                /*No Use                                 */
aaz241      nvarchar(4),             /*No Use                                 */
aaz242      nvarchar(8),             /*No Use                                 */
aaz25       smallint,                /*No Use                                 */
aaz251      nvarchar(4),             /*No Use                                 */
aaz252      nvarchar(8),             /*No Use                                 */
aaz26       smallint,                /*No Use                                 */
aaz31       nvarchar(24),            /*損益表本期損益會計科目編號             */
                                     /*損益表本期損益會計科目編號(虛帳戶)     */
                                     /*科目編號中結帳段數後的編號             */
aaz32       nvarchar(24),            /*資產負債表本期損益類會計科             */
                                     /*資產負債表本期損益類會計科目編號(實帳戶)*/
                                     /*科目編號中結帳段數後的編號             */
aaz33       nvarchar(24),            /*資產負債表累計盈虧會計科目             */
                                     /*科目編號中結帳段數後的編號             */
aaz41       smallint,                /*No Use                                 */
aaz42       smallint,                /*No Use                                 */
aaz431      nvarchar(1),             /*No Use                                 */
aaz432      nvarchar(1),             /*No Use                                 */
aaz441      nvarchar(1),             /*No Use                                 */
aaz442      nvarchar(1),             /*No Use                                 */
aaz51       nvarchar(1),             /*傳票過帳時是否產生每日餘額             */
                                     /*傳票過帳時是否產生每日餘額檔(Y/N)      */
aaz61       smallint,                /*季預算的第一期分配權數                 */
aaz62       smallint,                /*季預算的第二期分配權數                 */
aaz63       smallint,                /*季預算的第三期分配權數                 */
aaz64       nvarchar(5),             /*預設帳別                               */
aaz641      nvarchar(5),             /*合併報表帳別                           */
aaz65       nvarchar(5),             /*結轉用單別                             */
aaz66       nvarchar(2),             /*No Use                                 */
aaz67       nvarchar(6),             /*No Use                                 */
aaz68       nvarchar(5),             /*應計調整用單別                         */
aaz69       nvarchar(1),             /*是否將帳別顯示於螢幕                   */
                                     /*是否將帳別顯示於螢幕(Y/N)              */
aaz70       nvarchar(5),             /*傳票單別是否做使用者權限控             */
                                     /*傳票單別是否做使用者權限控制(Y/N) no use*/
aaz71       nvarchar(1),             /*傳票輸入時，若借貸方不平衡             */
                                     /*傳票輸入時，若借貸方不平衡(1/2)        */
                                     /*(1)輸入至借貸平衡為止                  */
                                     /*(2)僅予以警言，但仍可接受              */
aaz72       nvarchar(1),             /*科目部門輸入控管方式                   */
                                     /*(1)所設定為拒絕部門方式                */
                                     /*(2)所設定為允許部門方式                */
aaz73       nvarchar(1),             /*No Use                                 */
aaz74       nvarchar(20),            /*No Use                                 */
aaz75       nvarchar(1),             /*No Use                                 */
aaz76       nvarchar(1),             /*No Use                                 */
aaz77       nvarchar(1),             /*報表名稱是否以報表結構名稱             */
                                     /*報表名稱是否以報表結構名稱列印(Y/N)    */
aaz78       nvarchar(1),             /*一般傳票是否可查詢已過帳傳             */
                                     /*一般傳票是否可查詢已過帳傳票(Y/N)      */
aaz79       nvarchar(1),             /*No Use                                 */
aaz80       nvarchar(1),             /*未列印傳票憑證者可否過帳               */
                                     /*未列印傳票憑證者可否過帳(Y/N)          */
aaz81       nvarchar(1),             /*傳票輸入時是否輸入總號                 */
                                     /*傳票輸入時是否輸入總號(Y/N)            */
aaz82       nvarchar(1),             /*傳票列印時是否依借貸排列               */
                                     /*傳票列印時是否依借貸排列(Y/N)          */
aaz83       nvarchar(1),             /*傳票過帳時是否產生外幣餘額             */
                                     /*傳票過帳時是否產生外幣餘額檔(Y/N)      */
aaz84       nvarchar(1),             /*傳票拋轉還原時，還原方式               */
                                     /*傳票拋轉還原時，還原方式:(1/2)         */
                                     /*  (1)刪除                              */
                                     /*  (2)作廢      02/06/11 modi no.4868   */
aaz85       nvarchar(1),             /*各系統拋轉傳票時是否自動確             */
                                     /*各系統拋轉傳票時是否自動確認(Y/N)      */
aaz86       nvarchar(24),            /*再衡量兌換利益科目                     */
aaz87       nvarchar(24),            /*換算調整數科目                         */
aaz88       smallint,                /*科目使用異動碼數(0-10)                 */
                                     /*#FUN-5C0015                            */
aaz89       nvarchar(1),             /*No Use                                 */
aaz90       nvarchar(1),             /*是否使用利潤中心功能(Y/N)              */
aaz91       nvarchar(24),            /*利潤中心內部成本科目                   */
aaz92       nvarchar(24),            /*利潤中心內部收入科目                   */
aaz93       nvarchar(1),             /*No Use                                 */
aaz94       nvarchar(1),             /*No Use                                 */
aaz95       nvarchar(1),             /*No Use                                 */
aaz96       nvarchar(1),             /*No Use                                 */
aaz97       nvarchar(1),             /*No Use                                 */
aaz98       nvarchar(1),             /*No Use                                 */
aaz99       nvarchar(1)              /*No Use                                 */
);

alter table aaz_file add constraint aaz_pk primary key  (aaz00);
grant select on aaz_file to tiptopgp;
grant update on aaz_file to tiptopgp;
grant delete on aaz_file to tiptopgp;
grant insert on aaz_file to tiptopgp;
grant references on aaz_file to tiptopgp;
grant references on aaz_file to ods;
grant select on aaz_file to ods;
