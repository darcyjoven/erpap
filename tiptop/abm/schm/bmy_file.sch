/*
================================================================================
檔案代號:bmy_file
檔案名稱:ECN 元件明細資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmy_file
(
bmy01       nvarchar(20) NOT NULL,   /*工程變異單單號                         */
                                     /*儲存工程變異單單號。                   */
bmy011      nvarchar(10),            /*製程編號                               */
bmy012      nvarchar(10),            /*製程段號                               */
bmy013      smallint,                /*製程序                                 */
bmy02       smallint NOT NULL,       /*項次                                   */
                                     /*儲存工程變異單明細項次。               */
bmy03       nvarchar(1),             /*變異別                                 */
                                     /*儲存工程變異單明細對產品結構元件的變異 */
                                     /*狀況別。                               */
                                     /*正確值為「1/2/3/4」。                  */
                                     /*1: 舊元件失效                          */
                                     /*2: 新元件新增生效                      */
                                     /*3: 舊元件修改                          */
                                     /*4: 取代                                */
bmy04       smallint,                /*產品結構項次                           */
                                     /*儲存將被異動的產品結構元件項次。       */
bmy05       nvarchar(40),            /*元件編號                               */
                                     /*儲存將被異動的產品結構元件料件編號。   */
bmy06       decimal(16,8),           /*組成用量                               */
                                     /*儲存欲異動的產品結構中該元件對主件的組 */
                                     /*成用量。                               */
bmy07       decimal(16,8),           /*底數                                   */
                                     /*儲存欲異動的產品結構中該元件對主件的組 */
                                     /*成用量中主件的標準基數。               */
bmy08       decimal(9,4),            /*損耗率                                 */
                                     /*儲存欲異動的在產品組合中，將發生的損耗 */
                                     /*率。                                   */
bmy081      decimal(15,3),           /*固定損耗量                             */
bmy082      decimal(9,4),            /*損耗批量                               */
bmy09       nvarchar(6),             /*作業編號                               */
                                     /*儲存欲異動的產品組合中，元件的投入所屬 */
                                     /*主製程作業序號。                       */
bmy10       nvarchar(4),             /*發料單位                               */
bmy10_fac   decimal(20,8),           /*發料/料件庫存單位換算率                */
                                     /*儲存欲異動的該元件的發料單位對庫存單位 */
                                     /*換算率。                               */
bmy10_fac2  decimal(20,8),           /*發料/料件成本單位換算率                */
                                     /*儲存欲異動的該元件的發料單位對成本單位 */
                                     /*換算率。                               */
bmy11       nvarchar(20),            /*工程圖號                               */
bmy13       nvarchar(10),            /*插件位置                               */
bmy14       nvarchar(40),            /*主件編號                               */
                                     /*儲存將被異動的產品結構主件料件編號。   */
bmy15       nvarchar(1),             /*消耗件否                               */
                                     /*消耗件否 (Y/N)                         */
bmy16       nvarchar(1),             /*替代特性                               */
                                     /*替代特性               #for養生2003    */
                                     /*0.不可取替代 1.取代 2.替代 5.SET替代   */
bmy17       nvarchar(10),            /*主件料號版本                           */
bmy171      nvarchar(10),            /*主件料號目前版本                       */
bmy18       smallint,                /*投料時距                               */
bmy19       nvarchar(10),            /*變異方式                               */
bmy20       smallint,                /*工單開立展開選項                       */
                                     /*No use                                 */
bmy21       nvarchar(1),             /*元件消耗特性                           */
                                     /*元件消耗特性(Y/N)                      */
bmy22       nvarchar(255),           /*備註                                   */
bmy23       decimal(9,4),            /*發料允許誤差%                          */
bmy25       nvarchar(10),            /*倉庫別                                 */
bmy26       nvarchar(10),            /*存放位置                               */
bmy27       nvarchar(40),            /*新料料號                               */
                                     /*新料料號  變異別='4'時使用             */
bmy29       nvarchar(20),            /*特性代碼                               */
bmy30       nvarchar(1),             /*計算方式                               */
bmy33       integer DEFAULT 0 NOT NULL, /*款式BOM對應項次*/
bmy34       nvarchar(1),             /*是否委外代買                           */
bmy35       nvarchar(1),
bmylegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
bmyplant    nvarchar(10) NOT NULL    /*所屬營運中心                           */
);

create        index bmyplant_idx on bmy_file (bmyplant);
alter table bmy_file add constraint bmy_pk primary key  (bmy01,bmy02);
grant select on bmy_file to tiptopgp;
grant update on bmy_file to tiptopgp;
grant delete on bmy_file to tiptopgp;
grant insert on bmy_file to tiptopgp;
grant references on bmy_file to tiptopgp;
grant references on bmy_file to ods;
grant select on bmy_file to ods;
