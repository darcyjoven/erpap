/*
================================================================================
檔案代號:smy_file
檔案名稱:製造管理系統 使用單據性質檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smy_file
(
smy51       nvarchar(5),             /*對應驗退單別                           */
                                     /*對應驗退單別            (86/10)        */
smy52       nvarchar(5),             /*對應入庫單別                           */
                                     /*對應入庫單別                     (86/07)*/
smy53       nvarchar(1) DEFAULT ' ', /*兩交內部交易單據否                     */
smy54       nvarchar(24),            /*No Use                                 */
smy55       nvarchar(5),             /*傳票分群碼                             */
                                     /*傳票分群碼(拋轉傳票時的彙總代碼)       */
smy56       nvarchar(1),             /*是否影響呆滯日期                       */
                                     /*是否影響呆滯日期(Y/N)                  */
smy57       nvarchar(10),            /*第一碼:工單製程否                      */
                                     /*第一碼:工單制程否                      */
                                     /*第二碼:工單FQC否                       */
                                     /*第三碼:入庫單流水號是否預設同收貨單流水*/
                                     /*第四碼:是否走Blanket PO 流程           */
                                     /*第五碼:是否輸入手冊編號                */
                                     /*第六碼:委外型態                        */
                                     /*       委外工單對委外採購型態為  1: 一對一*/
                                     /*                                 2: 一對多*/
smy58       nvarchar(1),             /*是否產生Run Card                       */
smy59       nvarchar(1),             /*是否做預算控管                         */
                                     /*是否做預算控管 (For 請採購預算)        */
smy60       nvarchar(10),            /*成本中心                               */
                                     /*成本中心(for 6.00.04 製程成本)         */
smy61       nvarchar(5),             /*對應雜發單別                           */
smy62       nvarchar(10),            /*屬性群組                               */
smy63       nvarchar(5),             /*對應檢驗單別                           */
smy64       nvarchar(1),             /*GPM整合單據控管方式                    */
smy65       nvarchar(1),             /*是否拋轉MES  ( N. 不拋轉, Y. 要        */
smy67       nvarchar(5),             /*報工單對應入庫單別                     */
smy68       nvarchar(5),             /*報工單對應FQC單別                      */
smy69       nvarchar(5),             /*組合拆解關聯工單單別                   */
smy70       nvarchar(5),             /*組合拆解關聯發料單別                   */
smy71       nvarchar(5),             /*組合拆解關聯入庫單別                   */
smy72       nvarchar(10),            /*單據形態                               */
smy73       nvarchar(1),             /*組合拆解單否                           */
smy74       nvarchar(1) DEFAULT 'N' NOT NULL, /*確認時自動轉應付*/
smy75       nvarchar(5),             /*對應PBI單別                            */
smy76       nvarchar(5),             /*報工單對應委外採購單別                 */
smy77       nvarchar(5),             /*報工單對應委外收貨單別                 */
smy78       nvarchar(5),             /*no use                                 */
smyacti     nvarchar(1),             /*資料有效碼                             */
smyapr      nvarchar(1),             /*簽核處理                               */
                                     /*簽核處理(Y/N)                          */
smyatsg     nvarchar(1),             /*是否自動賦予簽核等級                   */
                                     /*是否自動賦予簽核等級(Y/N)              */
smyauno     nvarchar(1),             /*自動編號否                             */
                                     /*自動編號否(Y/N)                        */
smydate     datetime,                /*最近修改日                             */
smydays     smallint,                /*簽核完成天數                           */
smydesc     nvarchar(80),            /*單據名稱                               */
smydmy1     nvarchar(1),             /*計算成本否                             */
                                     /*是否為成會入項(Y/N)                    */
smydmy2     nvarchar(1),             /*成會單據類別                           */
                                     /*成會單據類別 (1/2/3/4/5/X)             */
                                     /*1.入庫(採購,自製,委外)                 */
                                     /*2.銷貨                                 */
                                     /*3.領出(工單,雜發)                      */
                                     /*4.轉撥(同營運中心同料號調撥)           */
                                     /*5.調整(雜發,盤點)                      */
                                     /*X.非庫存異動                           */
smydmy3     nvarchar(1),             /*保稅處理類別                           */
smydmy4     nvarchar(1),             /*是否立即確認                           */
                                     /*是否立即確認                     (8506)*/
smydmy5     nvarchar(1),             /*No Use                                 */
                                     /*編號方式  1.依流水號 2.依年月 3.依tlf905*/
smygrup     nvarchar(10),            /*資料所有部門                           */
smykind     nvarchar(2),             /*單據性質                               */
                                     /*aim: 1: 發料單                         */
                                     /*     2: 收料單                         */
                                     /*     3: 報廢單                         */
                                     /*     4: 調撥單                         */
                                     /*     5: 盤點單                         */
                                     /*     6: 借入單  #BugNo:6817            */
                                     /*     7: 調撥調整單                     */
                                     /*     8: 其他異動單                     */
                                     /*     9: 兩階段調撥單                   */
                                     /*     A: 撥入單                         */
                                     /*     B: 週期調點單                     */
                                     /*     C: 還料單  #BugNo:6817 add        */
                                     /*----------------------------------------*/
                                     /*apm: 1: 請購單                         */
                                     /*     2: 採購單                         */
                                     /*     3: 收貨單                         */
                                     /*     4: 驗退/倉退單                    */
                                     /*     5: 核價單 (97/08 add)             */
                                     /*     6: 詢價單                         */
                                     /*     7: 入庫單                         */
                                     /*     8: 無交期採購單                   */
                                     /*----------------------------------------*/
                                     /*asf: 1: 工單                           */
                                     /*     2: Run Card                       */
                                     /*     3: 工單發料單                     */
                                     /*     4: 工單退料單                     */
                                     /*     7: 製造通知單                     */
                                     /*     8: PBI No.                        */
                                     /*     9: 工單作業移轉單                 */
                                     /*     A: 工單完工入庫/退回單            */
                                     /*     B: FQC(全檢)單                    */
                                     /*     C: 拆件式工單完工入庫             */
                                     /*     D: PQC                            */
                                     /*     E: 品質異常單                     */
                                     /*     F: 報廢單                         */
                                     /*     G: Run Card 製程調整單            */
                                     /*     H: Run Card 製程分割單            */
                                     /*     I: Run Card 製程合併單            */
                                     /*     M: 模具零件需求單                 */
                                     /*     N: 通知單                         */
                                     /*     J: 報工單(非製程)                 */
                                     /*----------------------------------------*/
                                     /*abm: 1: 工程變異單                     */
                                     /*       2: 設計變更單                   */
                                     /*----------------------------------------*/
                                     /*aqc:1:品質異常單                       */
                                     /*      2:檢驗申請單                     */
smymemo1    nvarchar(255),           /*備註                                   */
smymemo2    nvarchar(255),           /*備註                                   */
smymemo3    nvarchar(255),           /*備註                                   */
smymodu     nvarchar(10),            /*資料修改者                             */
smymxno     nvarchar(20),            /*已用單號                               */
smyorig     nvarchar(10),            /*資料建立部門                           */
smyoriu     nvarchar(10),            /*資料建立者                             */
smyprint    nvarchar(1),             /*立即列印                               */
                                     /*單據輸入時是否立即列印                 */
smyprit     smallint,                /*簽核優先等級                           */
smysign     nvarchar(4),             /*簽核等級                               */
smyslip     nvarchar(5) NOT NULL,    /*單    別                               */
smysys      nvarchar(3),             /*系統別                                 */
                                     /*aim: 庫存管理系統                      */
                                     /*apm: 採購管理系統                      */
                                     /*asf: 生產管理系統                      */
                                     /*abm: 產品結構管理系統                  */
                                     /*aqc: 品質管理系統                      */
smyuser     nvarchar(10),            /*資料所有者                             */
smyware     nvarchar(1)              /*倉庫設限方式                           */
);

alter table smy_file add constraint smy_pk primary key  (smyslip);
grant select on smy_file to tiptopgp;
grant update on smy_file to tiptopgp;
grant delete on smy_file to tiptopgp;
grant insert on smy_file to tiptopgp;
grant references on smy_file to tiptopgp;
grant references on smy_file to ods;
grant select on smy_file to ods;
