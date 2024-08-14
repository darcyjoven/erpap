/*
================================================================================
檔案代號:sfa_file
檔案名稱:備料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfa_file
(
sfa01       nvarchar(20) NOT NULL,   /*工單編號                               */
                                     /*工單編號 sfb01                         */
sfa012      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
sfa013      smallint DEFAULT 0 NOT NULL, /*製程序*/
sfa02       smallint,                /*工單型態                               */
                                     /*工單型態 (同sfb02)                     */
sfa03       nvarchar(40) NOT NULL,   /*料件編號                               */
                                     /*料件編號 ima01                         */
                                     /*儲存該工單所屬下階料件編號，應為被發放 */
                                     /*投入生產的料件編號                     */
sfa04       decimal(18) NOT NULL,    /*原發數量                               */
                                     /*儲存該工單備料料件，由產品結構產生而來 */
                                     /*之原有數量；在與生產數量對比上使用標準 */
                                     /*用量加上損耗率，延展而來               */
sfa05       decimal(18) NOT NULL,    /*應發數量                               */
                                     /*儲存該工單備料料件，使用者經過修改後， */
                                     /*決定的備料量；開始時，應與原發數量相同 */
sfa06       decimal(18) NOT NULL,    /*已發數量                               */
                                     /*儲存該工單備料料件，已經被發料的數量； */
sfa061      decimal(18) NOT NULL,    /*已領數量                               */
                                     /*儲存該工單備料料件，已經被領料的數量； */
sfa062      decimal(18) NOT NULL,    /*超領數量                               */
                                     /*儲存該工單備料料件，被超領料的數量     */
sfa063      decimal(18) NOT NULL,    /*報廢數量                               */
                                     /*儲存該工單備料料件，被報廢料的數量     */
sfa064      decimal(18) NOT NULL,    /*盤損數量                               */
                                     /*儲存該工單備料料件，盤點時的減少數量   */
sfa065      decimal(18) NOT NULL,    /*委外代買量                             */
                                     /*儲存該工單備料料件，委外代買數量       */
sfa066      decimal(18) NOT NULL,    /*委外代買已交量                         */
                                     /*儲存該工單備料料件，委外代買已交數量   */
sfa07       decimal(18),             /*No Use                                 */
                                     /*No Use (for GP5.2發料改善專案)         */
sfa08       nvarchar(6) NOT NULL,    /*作業編號                               */
                                     /*儲存該工單備料料件，預期投入生產的作業 */
                                     /*所屬作業編號；可由[工單檔]指定的製程編 */
                                     /*號及產品結構而得                       */
sfa09       smallint,                /*前置時間調整                           */
                                     /*前置時間調整(天)                       */
                                     /*表示自工單起始生產日算起,需多少時間備料*/
                                     /*若為正值表示多少天後                   */
                                     /*若為負值表示多少天前                   */
sfa10       nvarchar(5),             /*前置時間調整                           */
                                     /*前置時間調整(時:分)                    */
                                     /*儲存經備料前置調整後，對該日的時間調整 */
                                     /*若為正值表示多少時間後                 */
                                     /*若為負值表示多少時間前                 */
                                     /*量產系統專用                           */
sfa100      decimal(18),             /*發料誤差允許率                         */
                                     /*發料誤差允許率           010515 No.+114*/
sfa11       nvarchar(1),             /*旗標                                   */
                                     /*儲存備料料件的來源特性                 */
                                     /*正確值 E/U/V/R/N                       */
                                     /*E: 消耗性料件                          */
                                     /*U: 大宗自製料件                        */
                                     /*V: 大宗採購料件                        */
                                     /*R: 在製途料件                          */
                                     /*N: 除外一般料件                        */
                                     /*--------單位換算率----------------------*/
sfa12       nvarchar(4) NOT NULL,    /*發料單位                               */
                                     /*儲存該工單備料料件的發料單位，將由產品 */
                                     /*產品結構產生而來                       */
sfa13       decimal(18),             /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sfa14       nvarchar(4),             /*成本單位                               */
                                     /*儲存該工單備料料件的發料單位，將由 [料 */
                                     /*件主檔] 產生而來                       */
sfa15       decimal(18),             /*成本單位/材料成本檔成本單位            */
                                     /*ex.成本單位=g 成本單位=kg              */
                                     /* 1/1000=0.001(換算率)                  */
sfa16       decimal(18),             /*標準單位用量                           */
                                     /*標準單位用量 (Standard QPA)            */
                                     /*儲存該工單備料料件的標準單位用量，由BOM*/
                                     /*產品結構產生而來                       */
                                     /*系統於備料時自動維護,不能修改          */
sfa161      decimal(18),             /*實際單位用量 (Actual QPA)              */
                                     /*系統若使用損耗率, 則本用量會加上損耗率 */
                                     /*系統若不用損耗率, 則本用量不加上損耗率 */
                                     /*系統若不用損耗率, 則本用量等於標準用量.*/
                                     /*系統於備料時自動維護,不能修改          */
sfa25       decimal(18) NOT NULL,    /*未備料量                               */
                                     /*儲存該工單備料料件的應發數量大於 [料件 */
                                     /*主檔] 的可被備料量，而又無其他可替代料 */
                                     /*的數量；亦即未能備料量                 */
sfa26       nvarchar(1),             /*替代碼                                 */
                                     /*儲存該工單備料的料件為原始組合的下階料 */
                                     /*件或採用取／替代料件                   */
                                     /*正確值 0/1/2/3/4/S/U                   */
                                     /*0: 原始料件, 不可被取替代              */
                                     /*1: 新料, 有舊料可取代 (取代後,轉為'3') */
                                     /*2: 主料, 有副料可替代 (替代後,轉為'4') */
                                     /*3: 新料, 已經被取代                    */
                                     /*4: 主料, 已經被替代                    */
                                     /*5: 主料, 可做SET替代(SET替代號,轉為'6')*/
                                     /*                     #Add By 養生2003  */
                                     /*6: 主料, 已做SET替代 #Add By 養生2003  */
                                     /*U: 舊料(取代料件)                      */
                                     /*S: 副料(替代料件)                      */
                                     /*T: SET替代料         #Add BY 養生2003  */
sfa27       nvarchar(40) NOT NULL,   /*被替代料號                             */
                                     /*當 sfa26='012345T'時,欄位儲存料號同sfa03*/
                                     /*當 sfa26='S/U'  時,本欄位儲存被替代料號*/
sfa28       decimal(15,6),           /*替代率                                 */
                                     /*當 sfa26='012345'時,本欄位=1           */
                                     /*當 sfa26='S/U'  時,本欄位儲存替代率    */
                                     /*當 sfa26='T'時,儲存替代料替代量bob07   */
                                     /*               #Add BY 養生2003        */
sfa29       nvarchar(40),            /*上階料號                               */
sfa30       nvarchar(10),            /*指定倉庫                               */
sfa31       nvarchar(10),            /*指定儲位                               */
sfa32       nvarchar(1),             /*代買料否                               */
sfa36       nvarchar(24),            /*廠牌                                   */
sfa91       nvarchar(20),            /*制單號                                 */
sfa92       nvarchar(1),             /*USER DEFINE                            */
sfa93       nvarchar(1),             /*USER DEFINE                            */
sfa94       nvarchar(1),             /*USER DEFINE                            */
sfa95       nvarchar(1),             /*USER DEFINE                            */
sfa96       nvarchar(1),             /*USER DEFINE                            */
sfa97       nvarchar(1),             /*USER DEFINE                            */
sfa98       nvarchar(1),             /*USER DEFINE                            */
sfa99       nvarchar(1),             /*USER DEFINE                            */
sfaacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
sfalegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
sfaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
sfaud01     nvarchar(255),           /*自訂欄位-Textedit                      */
sfaud02     nvarchar(40),            /*自訂欄位-文字                          */
sfaud03     nvarchar(40),            /*自訂欄位-文字                          */
sfaud04     nvarchar(40),            /*自訂欄位-文字                          */
sfaud05     nvarchar(40),            /*自訂欄位-文字                          */
sfaud06     nvarchar(40),            /*自訂欄位-文字                          */
sfaud07     decimal(18),             /*自訂欄位-數值                          */
sfaud08     decimal(18),             /*自訂欄位-數值                          */
sfaud09     decimal(18),             /*自訂欄位-數值                          */
sfaud10     integer,                 /*自訂欄位-整數                          */
sfaud11     integer,                 /*自訂欄位-整數                          */
sfaud12     integer,                 /*自訂欄位-整數                          */
sfaud13     datetime,                /*自訂欄位-日期                          */
sfaud14     datetime,                /*自訂欄位-日期                          */
sfaud15     datetime                 /*自訂欄位-日期                          */
);

create        index sfa_02 on sfa_file (sfa03);
create        index sfaplant_idx on sfa_file (sfaplant);
alter table sfa_file add constraint sfa_pk primary key  (sfa01,sfa03,sfa08,sfa12,sfa27,sfa012,sfa013);
grant select on sfa_file to tiptopgp;
grant update on sfa_file to tiptopgp;
grant delete on sfa_file to tiptopgp;
grant insert on sfa_file to tiptopgp;
grant references on sfa_file to tiptopgp;
grant references on sfa_file to ods;
grant select on sfa_file to ods;
