/*
================================================================================
檔案代號:apz_file
檔案名稱:應付帳款系統參數檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table apz_file
(
apz00       nvarchar(1) NOT NULL,    /*KEY, VALUE(0), 隱藏欄位                */
apz01       nvarchar(1),             /*目前應付帳款系統是否可放給             */
apz02       nvarchar(1),             /*是否與會計總帳管理系統相連             */
apz02b      nvarchar(5),             /*總帳管理系統使用帳別編號               */
apz02c      nvarchar(5),             /*總帳管理系統使用帳別代號二             */
apz02p      nvarchar(10),            /*總帳管理系統所在營運中心編             */
apz03       nvarchar(1),             /*是否與製造管理系統相連                 */
apz04       nvarchar(1),             /*是否與票據管理系統相連                 */
apz04p      nvarchar(10),            /*票據管理系統所在營運中心編             */
apz05       nvarchar(1),             /*付款沖帳時,可否沖銷傳票未確            */
apz06       nvarchar(1),             /*付款沖帳時,可否沖銷未拋轉傳            */
apz07       nvarchar(1),             /*發票輸入是否檢查字軌                   */
apz08       nvarchar(1),             /*多發票輸入完後更新帳款金額             */
                                     /*1.立即更新  2.詢問                     */
apz11       nvarchar(1),             /*No Use                                 */
apz12       nvarchar(10),            /*發票金額與驗收單金額不符時             */
apz13       nvarchar(1),             /*是否依部門區分預設會計科目             */
                                     /*是否依部門區分預設會計科目(Y/N)        */
apz14       nvarchar(1),             /*是否檢查營利事業統一編號               */
                                     /*是否檢查營利事業統一編號  (Y/N)        */
apz15       nvarchar(1),             /*進貨金額可否大於發票金額               */
                                     /*進貨金額可否大於發票金額  (Y/N)        */
apz16       nvarchar(1),             /*進貨發票請款時可否修改進貨             */
                                     /*進貨發票請款時可否修改進貨單價(Y/N)    */
apz21       smallint,                /*月底重評價年度                         */
apz22       smallint,                /*月底重評價月份                         */
apz23       nvarchar(1),             /*No Use                                 */
apz24       nvarchar(1),             /*No Use                                 */
apz25       nvarchar(1),             /*請款作業輸入營運中心編號否             */
                                     /*請款作業輸入營運中心編號否(Y/N)        */
apz26       nvarchar(1),             /*付款作業輸入營運中心編號否             */
                                     /*付款作業輸入營運中心編號否(Y/N)        */
apz27       nvarchar(1),             /*月底重評價當月認列匯差,次月            */
                                     /*月底重評價當月認列匯差,次月不回轉(Y/N) */
                                     /*for 大陸法規, 每月認列匯差             */
apz31       nvarchar(1),             /*進貨發票輸入時是否自動產生             */
                                     /*進貨發票輸入時是否自動產生分錄(Y/N)    */
apz32       nvarchar(1),             /*雜項發票輸入時是否自動產生             */
                                     /*雜項發票輸入時是否自動產生分錄(Y/N)    */
apz33       nvarchar(1),             /*應付匯率使用類別                       */
                                     /*no use   no.6805                       */
apz34       nvarchar(1),             /*預付發票輸入時是否自動產生             */
                                     /*預付發票輸入時是否自動產生分錄(Y/N)    */
apz35       nvarchar(1),             /*預付C.M.輸入時是否自動產生分           */
                                     /*預付C.M.輸入時是否自動產生分錄(Y/N)    */
apz36       nvarchar(1),             /*No Use                                 */
apz37       nvarchar(1),             /*No Use                                 */
apz38       nvarchar(1),             /*No Use                                 */
apz39       nvarchar(1),             /*No Use                                 */
apz40       nvarchar(1),             /*付款輸入時是否自動產生分錄             */
                                     /*付款輸入時是否自動產生分錄(Y/N)        */
apz42       nvarchar(1),             /*月底重評價分錄底稿產生方式             */
                                     /*                 #no.5630 改為 no use  */
                                     /*月底重評價分錄底稿產生方式       NO.A048*/
                                     /* 1.明細  2.彙總  3.依廠商              */
apz43       nvarchar(1),             /*應付帳款傳票摘要格式                   */
                                     /*  0.空白                               */
                                     /*  1.廠商                               */
                                     /*  2.廠商+發票/帳款編號                 */
apz44       nvarchar(1),             /*付款沖帳傳票摘要格式                   */
                                     /*  0.空白                               */
                                     /*  1.廠商                               */
                                     /*  2.廠商+票據到期日                    */
apz45       smallint,                /*應付帳齡第一段天數                     */
apz46       smallint,                /*應付帳齡第二段天數                     */
apz47       smallint,                /*應付帳齡第三段天數                     */
apz48       smallint,                /*應付帳齡第四段天數                     */
apz49       nvarchar(4),             /*預設稅別                               */
apz50       nvarchar(1),             /*自動產生付款單時是否依營運             */
apz51       nvarchar(1),             /*自動產生付款單時是否依帳款             */
apz52       nvarchar(1),             /*即期支票付款時貸方科目設定             */
                                     /*  1.應付票據                           */
                                     /*  2.銀行存款                           */
apz53       datetime,                /*No Use                                 */
apz54       nvarchar(1),             /*雜項發票請款傳票稅額摘要格             */
                                     /*  0.空白                               */
                                     /*  1.廠商+發票號+日期                   */
apz55       nvarchar(1),             /*請款傳票若為立即付款, 貸方             */
                                     /*  0.空白                               */
                                     /*  1.廠商+票據到期日                    */
apz56       smallint,                /*結帳日                                 */
                                     /*結帳日                    97/05/07 V3.0*/
apz57       datetime,                /*關帳日期                               */
                                     /*關帳日期                  97/05/07 V3.0*/
apz58       nvarchar(2),             /*銀行出帳異動碼                         */
apz59       nvarchar(1),             /*雜項請款單身是否輸入MISC資料           */
apz60       nvarchar(1),             /*進貨發票確認時是否自動產生             */
                                     /*進貨發票確認時是否自動產生折讓單(Y/N)  */
apz61       nvarchar(1),             /*預付金額是否與採購單勾稽               */
apz62       nvarchar(1) DEFAULT 'N', /*預付/暫付不做月底重評價                */
apz63       nvarchar(20) DEFAULT ' ',/*申報統編                               */
apz64       nvarchar(5),             /*默認調帳單別                           */
apz65       nvarchar(1) DEFAULT ' ' NOT NULL, /*轉銷科目類型*/
apz66       nvarchar(10),            /*轉銷帳款類型                           */
apz67       nvarchar(5)              /*默認溢退單別                           */
);

alter table apz_file add constraint apz_pk primary key  (apz00);
grant select on apz_file to tiptopgp;
grant update on apz_file to tiptopgp;
grant delete on apz_file to tiptopgp;
grant insert on apz_file to tiptopgp;
grant references on apz_file to tiptopgp;
grant references on apz_file to ods;
grant select on apz_file to ods;
