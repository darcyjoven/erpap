/*
================================================================================
檔案代號:cxh_file
檔案名稱:每月製程元件在製成本檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxh_file
(
cxh01       nvarchar(20) NOT NULL,   /*工單編號                               */
cxh011      nvarchar(10) NOT NULL,   /*成本中心編號                           */
cxh012      nvarchar(6) NOT NULL,    /*作業編號                               */
cxh013      nvarchar(10) DEFAULT ' ' NOT NULL, /*製程段號*/
cxh014      smallint DEFAULT 0 NOT NULL, /*製程序*/
cxh02       smallint NOT NULL,       /*年度                                   */
cxh03       smallint NOT NULL,       /*月份                                   */
cxh04       nvarchar(40) NOT NULL,   /*元件料號                               */
cxh05       nvarchar(1) NOT NULL,    /*元件料號類別                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
cxh06       nvarchar(1) DEFAULT ' ' NOT NULL, /*成本計算類別*/
cxh07       nvarchar(40) DEFAULT ' ' NOT NULL, /*類別代號(批次號/專案號/利潤 */
cxh11       decimal(18) NOT NULL,    /*上月結存數量                           */
                                     /*上月結存數量(製程轉出單位之結存量)     */
cxh12       decimal(18) NOT NULL,    /*上月結存金額(a+b+c+d+e)                */
cxh12a      decimal(18) NOT NULL,    /*上月結存金額-材料   (a)                */
cxh12b      decimal(18) NOT NULL,    /*上月結存金額-人工   (b)                */
cxh12c      decimal(18) NOT NULL,    /*上月結存金額-製費   (c)                */
cxh12d      decimal(18) NOT NULL,    /*上月結存金額-加工   (d)                */
cxh12e      decimal(18) NOT NULL,    /*上月結存金額-其他   (e)                */
cxh12f      decimal(18) DEFAULT '0', /*上月結存金額-製費三 (f)                */
cxh12g      decimal(18) DEFAULT '0', /*上月結存金額-製費四 (g)                */
cxh12h      decimal(18) DEFAULT '0', /*上月結存金額-製費五 (h)                */
cxh21       decimal(18) NOT NULL,    /*本月本站投入數量                       */
                                     /*本月本站投入數量(製程轉入單位之投入量) */
cxh22       decimal(18) NOT NULL,    /*本月本站投入金額(a+b+c+d+e)            */
cxh22a      decimal(18) NOT NULL,    /*本月本站投入金額-材料   (a)            */
cxh22b      decimal(18) NOT NULL,    /*本月本站投入金額-人工   (b)            */
cxh22c      decimal(18) NOT NULL,    /*本月本站投入金額-製費   (c)            */
cxh22d      decimal(18) NOT NULL,    /*本月本站投入金額-加工   (d)            */
cxh22e      decimal(18) NOT NULL,    /*本月本站投入金額-其他   (e)            */
cxh22f      decimal(18) DEFAULT '0', /*本月本站投入金額-製費三 (f)            */
cxh22g      decimal(18) DEFAULT '0', /*本月本站投入金額-製費四 (g)            */
cxh22h      decimal(18) DEFAULT '0', /*本月本站投入金額-製費五 (h)            */
cxh24       decimal(18) NOT NULL,    /*本月前製程入                           */
                                     /*本月前製程入(製程轉入單位之轉入量)     */
cxh25       decimal(18) NOT NULL,    /*本月前製程入(a+b+c+d+e)                */
cxh25a      decimal(18) NOT NULL,    /*本月前製程入-材料   (a)                */
cxh25b      decimal(18) NOT NULL,    /*本月前製程入-人工   (b)                */
cxh25c      decimal(18) NOT NULL,    /*本月前製程入-製費   (c)                */
cxh25d      decimal(18) NOT NULL,    /*本月前製程入-加工   (d)                */
cxh25e      decimal(18) NOT NULL,    /*本月前製程入-其他   (e)                */
cxh25f      decimal(18) DEFAULT '0', /*本月前製程投入金額-製費三  (           */
cxh25g      decimal(18) DEFAULT '0', /*本月前製程投入金額-製費四  (           */
cxh25h      decimal(18) DEFAULT '0', /*本月前製程投入金額-製費五  (           */
cxh26       decimal(18) NOT NULL,    /*工單轉入量                             */
cxh27       decimal(18) NOT NULL,    /*工單轉入金額(a+b+c+d+e)                */
cxh27a      decimal(18) NOT NULL,    /*工單轉入金額-材料   (a)                */
cxh27b      decimal(18) NOT NULL,    /*工單轉入金額-人工   (b)                */
cxh27c      decimal(18) NOT NULL,    /*工單轉入金額-製費   (c)                */
cxh27d      decimal(18) NOT NULL,    /*工單轉入金額-加工   (d)                */
cxh27e      decimal(18) NOT NULL,    /*工單轉入金額-其他   (e)                */
cxh27f      decimal(18) DEFAULT '0', /*工單轉入金額-製費三 (f)                */
cxh27g      decimal(18) DEFAULT '0', /*工單轉入金額-製費四 (g)                */
cxh27h      decimal(18) DEFAULT '0', /*工單轉入金額-製費五 (h)                */
cxh28       decimal(18) NOT NULL,    /*重流轉入量                             */
cxh29       decimal(18) NOT NULL,    /*重流轉入金額(a+b+c+d+e)                */
cxh29a      decimal(18) NOT NULL,    /*重流轉入金額-材料   (a)                */
cxh29b      decimal(18) NOT NULL,    /*重流轉入金額-人工   (b)                */
cxh29c      decimal(18) NOT NULL,    /*重流轉入金額-製費   (c)                */
cxh29d      decimal(18) NOT NULL,    /*重流轉入金額-加工   (d)                */
cxh29e      decimal(18) NOT NULL,    /*重流轉入金額-其他   (e)                */
cxh29f      decimal(18) DEFAULT '0', /*重流轉入金額-製費三 (f)                */
cxh29g      decimal(18) DEFAULT '0', /*重流轉入金額-製費四 (g)                */
cxh29h      decimal(18) DEFAULT '0', /*重流轉入金額-製費五 (h)                */
cxh31       decimal(18) NOT NULL,    /*本月轉下製程(良品轉出量+BONUS          */
cxh32       decimal(18) NOT NULL,    /*本月轉下製程(a+b+c+d+e)                */
cxh32a      decimal(18) NOT NULL,    /*本月轉下製程-材料   (a)                */
cxh32b      decimal(18) NOT NULL,    /*本月轉下製程-人工   (b)                */
cxh32c      decimal(18) NOT NULL,    /*本月轉下製程-製費   (c)                */
cxh32d      decimal(18) NOT NULL,    /*本月轉下製程-加工   (d)                */
cxh32e      decimal(18) NOT NULL,    /*本月轉下製程-其他   (e)                */
cxh32f      decimal(18) DEFAULT '0', /*本月轉下製程金額-製費三 (f)            */
cxh32g      decimal(18) DEFAULT '0', /*本月轉下製程金額-製費四 (g)            */
cxh32h      decimal(18) DEFAULT '0', /*本月轉下製程金額-製費五 (h)            */
cxh33       decimal(18) NOT NULL,    /*本月報廢數量                           */
                                     /*本月報廢數量(製程轉出單位之報廢量)     */
cxh34       decimal(18) NOT NULL,    /*本月報廢金額(a+b+c+d+e)                */
cxh34a      decimal(18) NOT NULL,    /*本月報廢金額-材料   (a)                */
cxh34b      decimal(18) NOT NULL,    /*本月報廢金額-人工   (b)                */
cxh34c      decimal(18) NOT NULL,    /*本月報廢金額-製費   (c)                */
cxh34d      decimal(18) NOT NULL,    /*本月報廢金額-加工   (d)                */
cxh34e      decimal(18) NOT NULL,    /*本月報廢金額-其他   (e)                */
cxh34f      decimal(18) DEFAULT '0', /*本月報廢金額-製費三 (f)                */
cxh34g      decimal(18) DEFAULT '0', /*本月報廢金額-製費四 (g)                */
cxh34h      decimal(18) DEFAULT '0', /*本月報廢金額-製費五 (h)                */
cxh35       decimal(18) NOT NULL,    /*工單轉出量                             */
cxh36       decimal(18) NOT NULL,    /*工單轉出金額(a+b+c+d+e)                */
cxh36a      decimal(18) NOT NULL,    /*工單轉出金額-材料   (a)                */
cxh36b      decimal(18) NOT NULL,    /*工單轉出金額-人工   (b)                */
cxh36c      decimal(18) NOT NULL,    /*工單轉出金額-製費   (c)                */
cxh36d      decimal(18) NOT NULL,    /*工單轉出金額-加工   (d)                */
cxh36e      decimal(18) NOT NULL,    /*工單轉出金額-其他   (e)                */
cxh36f      decimal(18) DEFAULT '0', /*工單轉出金額-製費三 (f)                */
cxh36g      decimal(18) DEFAULT '0', /*工單轉出金額-製費四 (g)                */
cxh36h      decimal(18) DEFAULT '0', /*工單轉出金額-製費五 (h)                */
cxh37       decimal(18) NOT NULL,    /*本月當站下線數量                       */
cxh38       decimal(18) NOT NULL,    /*本月當站下線金額(a+b+c+d+e)            */
cxh38a      decimal(18) NOT NULL,    /*本月當站下線金額-材料   (a)            */
cxh38b      decimal(18) NOT NULL,    /*本月當站下線金額-人工   (b)            */
cxh38c      decimal(18) NOT NULL,    /*本月當站下線金額-製費   (c)            */
cxh38d      decimal(18) NOT NULL,    /*本月當站下線金額-加工   (d)            */
cxh38e      decimal(18) NOT NULL,    /*本月當站下線金額-其他   (e)            */
cxh38f      decimal(18) DEFAULT '0', /*本月當站下線金額-製費三 (f)            */
cxh38g      decimal(18) DEFAULT '0', /*本月當站下線金額-製費四 (g)            */
cxh38h      decimal(18) DEFAULT '0', /*本月當站下線金額-製費五 (h)            */
cxh39       decimal(18) NOT NULL,    /*本月重流數量                           */
                                     /*本月重流數量(製程轉出單位之製程重工量) */
cxh40       decimal(18) NOT NULL,    /*本月重流金額(a+b+c+d+e)                */
cxh40a      decimal(18) NOT NULL,    /*本月重流金額-材料   (a)                */
cxh40b      decimal(18) NOT NULL,    /*本月重流金額-人工   (b)                */
cxh40c      decimal(18) NOT NULL,    /*本月重流金額-製費   (c)                */
cxh40d      decimal(18) NOT NULL,    /*本月重流金額-加工   (d)                */
cxh40e      decimal(18) NOT NULL,    /*本月重流金額-其他   (e)                */
cxh40f      decimal(18) DEFAULT '0', /*本月重流金額-製費三 (f)                */
cxh40g      decimal(18) DEFAULT '0', /*本月重流金額-製費四 (g)                */
cxh40h      decimal(18) DEFAULT '0', /*本月重流金額-製費五 (h)                */
cxh41       decimal(18) NOT NULL,    /*差異轉出數量                           */
                                     /*差異轉出數量(製程轉出單位之差異量)     */
cxh42       decimal(18) NOT NULL,    /*差異轉出金額(a+b+c+d+e)                */
cxh42a      decimal(18) NOT NULL,    /*差異轉出金額-材料   (a)                */
cxh42b      decimal(18) NOT NULL,    /*差異轉出金額-人工   (b)                */
cxh42c      decimal(18) NOT NULL,    /*差異轉出金額-製費   (c)                */
cxh42d      decimal(18) NOT NULL,    /*差異轉出金額-加工   (d)                */
cxh42e      decimal(18) NOT NULL,    /*差異轉出金額-其他   (e)                */
cxh42f      decimal(18) DEFAULT '0', /*差異轉出金額-製費三 (f)                */
cxh42g      decimal(18) DEFAULT '0', /*差異轉出金額-製費四 (g)                */
cxh42h      decimal(18) DEFAULT '0', /*差異轉出金額-製費五 (h)                */
cxh51       decimal(18) NOT NULL,    /*累計投入數量                           */
                                     /*累計投入數量(製程轉入單位之投入量)     */
cxh52       decimal(18) NOT NULL,    /*累計投入金額(a+b+c+d+e)                */
cxh52a      decimal(18) NOT NULL,    /*累計投入金額-材料   (a)                */
cxh52b      decimal(18) NOT NULL,    /*累計投入金額-人工   (b)                */
cxh52c      decimal(18) NOT NULL,    /*累計投入金額-製費   (c)                */
cxh52d      decimal(18) NOT NULL,    /*累計投入金額-加工   (d)                */
cxh52e      decimal(18) NOT NULL,    /*累計投入金額-其他   (e)                */
cxh52f      decimal(18) DEFAULT '0', /*累計投入金額-製費三                    */
cxh52g      decimal(18) DEFAULT '0', /*累計投入金額-製費四                    */
cxh52h      decimal(18) DEFAULT '0', /*累計投入金額-製費五                    */
cxh53       decimal(18) NOT NULL,    /*累計轉出數量                           */
                                     /*累計轉出數量(製程轉出單位之轉出量)     */
cxh54       decimal(18) NOT NULL,    /*累計轉出金額(a+b+c+d+e)                */
cxh54a      decimal(18) NOT NULL,    /*累計轉出金額-材料   (a)                */
cxh54b      decimal(18) NOT NULL,    /*累計轉出金額-人工   (b)                */
cxh54c      decimal(18) NOT NULL,    /*累計轉出金額-製費   (c)                */
cxh54d      decimal(18) NOT NULL,    /*累計轉出金額-加工   (d)                */
cxh54e      decimal(18) NOT NULL,    /*累計轉出金額-其他   (e)                */
cxh54f      decimal(18) DEFAULT '0', /*累計轉出金額-製費三                    */
cxh54g      decimal(18) DEFAULT '0', /*累計轉出金額-製費四                    */
cxh54h      decimal(18) DEFAULT '0', /*累計轉出金額-製費五                    */
cxh55       decimal(18) NOT NULL,    /*累計超領退數量                         */
                                     /*累計超領退數量(製程轉入單位之超領退量) */
cxh56       decimal(18) NOT NULL,    /*累計超領退金額(a+b+c+d+e)              */
cxh56a      decimal(18) NOT NULL,    /*累計超領退金額-材料   (a)              */
cxh56b      decimal(18) NOT NULL,    /*累計超領退金額-人工   (b)              */
cxh56c      decimal(18) NOT NULL,    /*累計超領退金額-製費   (c)              */
cxh56d      decimal(18) NOT NULL,    /*累計超領退金額-加工   (d)              */
cxh56e      decimal(18) NOT NULL,    /*累計超領退金額-其他   (e)              */
cxh56f      decimal(18) DEFAULT '0', /*累計超領退金額-製費三                  */
cxh56g      decimal(18) DEFAULT '0', /*累計超領退金額-製費四                  */
cxh56h      decimal(18) DEFAULT '0', /*累計超領退金額-製費五                  */
cxh57       decimal(18) NOT NULL,    /*本期超領退數量(製程轉入單位            */
cxh58       decimal(18) NOT NULL,    /*本期超領退金額(a+b+c+d+e)              */
cxh58a      decimal(18) NOT NULL,    /*本期超領退金額-材料   (a)              */
cxh58b      decimal(18) NOT NULL,    /*本期超領退金額-人工   (b)              */
cxh58c      decimal(18) NOT NULL,    /*本期超領退金額-製費   (c)              */
cxh58d      decimal(18) NOT NULL,    /*本期超領退金額-加工   (d)              */
cxh58e      decimal(18) NOT NULL,    /*本期超領退金額-其他   (e)              */
cxh58f      decimal(18) DEFAULT '0', /*本期超領退金額-製費三                  */
cxh58g      decimal(18) DEFAULT '0', /*本期超領退金額-製費四                  */
cxh58h      decimal(18) DEFAULT '0', /*本期超領退金額-製費五                  */
cxh59       decimal(18) NOT NULL,    /*盤差數量                               */
                                     /*盤差數量(製程轉出單位之盤差量)         */
cxh60       decimal(18) NOT NULL,    /*盤差金額(a+b+c+d+e)                    */
cxh60a      decimal(18) NOT NULL,    /*盤差金額-材料   (a)                    */
cxh60b      decimal(18) NOT NULL,    /*盤差金額-人工   (b)                    */
cxh60c      decimal(18) NOT NULL,    /*盤差金額-製費   (c)                    */
cxh60d      decimal(18) NOT NULL,    /*盤差金額-加工   (d)                    */
cxh60e      decimal(18) NOT NULL,    /*盤差金額-其他   (e)                    */
cxh60f      decimal(18) DEFAULT '0', /*盤差金額-製費三                        */
cxh60g      decimal(18) DEFAULT '0', /*盤差金額-製費四                        */
cxh60h      decimal(18) DEFAULT '0', /*盤差金額-製費五                        */
cxh91       decimal(18) NOT NULL,    /*本月結存數量(製程轉出單位之            */
cxh92       decimal(18) NOT NULL,    /*本月結存金額(a+b+c+d+e)                */
cxh92a      decimal(18) NOT NULL,    /*本月結存金額-材料   (a)                */
cxh92b      decimal(18) NOT NULL,    /*本月結存金額-人工   (b)                */
cxh92c      decimal(18) NOT NULL,    /*本月結存金額-製費   (c)                */
cxh92d      decimal(18) NOT NULL,    /*本月結存金額-加工   (d)                */
cxh92e      decimal(18) NOT NULL,    /*本月結存金額-其他   (e)                */
cxh92f      decimal(18) DEFAULT '0', /*本月結存金額-製費三 (f)                */
cxh92g      decimal(18) DEFAULT '0', /*本月結存金額-製費四 (g)                */
cxh92h      decimal(18) DEFAULT '0', /*本月結存金額-製費五 (h)                */
cxhdate     datetime,                /*最近計算日期                           */
cxhlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
cxhorig     nvarchar(10),            /*資料建立部門                           */
cxhoriu     nvarchar(10),            /*資料建立者                             */
cxhtime     nvarchar(5),             /*最近計算時間                           */
cxhuser     nvarchar(10)             /*最近計算人員                           */
);

create        index cxh_02 on cxh_file (cxh04);
alter table cxh_file add constraint cxh_pk primary key  (cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07,cxh013,cxh014);
grant select on cxh_file to tiptopgp;
grant update on cxh_file to tiptopgp;
grant delete on cxh_file to tiptopgp;
grant insert on cxh_file to tiptopgp;
grant references on cxh_file to tiptopgp;
grant references on cxh_file to ods;
grant select on cxh_file to ods;
