/*
================================================================================
檔案代號:aps_file
檔案名稱:部門預設會計科目檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aps_file
(
aps01       nvarchar(10) NOT NULL,   /*部門編號                               */
aps11       nvarchar(24),            /*現金科目                               */
aps111      nvarchar(24),            /*現金科目二                             */
aps12       nvarchar(24),            /*預付帳款科目                           */
aps121      nvarchar(24),            /*預付帳款科目二                         */
aps13       nvarchar(24),            /*暫付帳款科目                           */
aps131      nvarchar(24),            /*暫付帳款科目二                         */
aps14       nvarchar(24),            /*開狀預付購料款科目                     */
aps141      nvarchar(24),            /*開狀預付購料款科目二                   */
aps21       nvarchar(24),            /*未開發票應付帳款科目                   */
aps211      nvarchar(24),            /*未開發票應付帳款科目二                 */
aps22       nvarchar(24),            /*應付帳款科目                           */
aps221      nvarchar(24),            /*應付帳款科目二                         */
aps23       nvarchar(24),            /*應付費用科目                           */
aps231      nvarchar(24),            /*預估應付保險費科目                     */
aps232      nvarchar(24),            /*預估應付報關雜費科目                   */
aps233      nvarchar(24),            /*代付費用科目                           */
aps234      nvarchar(24),            /*在途存貨科目                           */
                                     /*在途存貨科目(可設為與 aps14 相同)      */
aps235      nvarchar(24),            /*應付帳款科目二                         */
aps236      nvarchar(24),            /*預估應付保險費科目二                   */
aps237      nvarchar(24),            /*預估應付報關雜費科目二                 */
aps238      nvarchar(24),            /*代付費用科目二                         */
aps239      nvarchar(24),            /*在途存貨科目二                         */
aps24       nvarchar(24),            /*應付票據科目                           */
aps241      nvarchar(24),            /*應付票據科目二                         */
aps25       nvarchar(24),            /*銀行借款科目                           */
aps251      nvarchar(24),            /*銀行借款科目二                         */
aps40       nvarchar(24),            /*購貨退回科目                           */
                                     /*購貨退回科目(未折讓)                   */
aps401      nvarchar(24),            /*購貨退回科目二                         */
aps41       nvarchar(24),            /*進貨折讓科目                           */
aps411      nvarchar(24),            /*進貨折讓科目二                         */
aps42       nvarchar(24),            /*匯差損失科目                           */
aps421      nvarchar(24),            /*匯差損失科目二                         */
aps43       nvarchar(24),            /*匯差收益科目                           */
aps431      nvarchar(24),            /*匯差收益科目二                         */
aps44       nvarchar(24),            /*價格差異科目/採購價差科目              */
aps441      nvarchar(24),            /*價格差異科目二/採購價差科目            */
aps45       nvarchar(24),            /*存貨科目                               */
aps451      nvarchar(24),            /*存貨科目二                             */
aps46       nvarchar(24),            /*手續費科目                             */
aps461      nvarchar(24),            /*手續費科目二                           */
aps47       nvarchar(24),            /*郵資科目                               */
aps471      nvarchar(24),            /*郵資科目二                             */
aps51       nvarchar(24),            /*立帳差異科目                           */
                                     /*立帳差異科目(到單與到貨差異)           */
aps511      nvarchar(24),            /*立帳差異科目二                         */
aps52       nvarchar(24),            /*暫估利息費用                           */
aps521      nvarchar(24),            /*暫估利息費用二                         */
aps53       nvarchar(24),            /*應付暫估利息                           */
aps531      nvarchar(24),            /*應付暫估利息二                         */
aps54       nvarchar(24),            /*利差損失科目                           */
aps541      nvarchar(24),            /*利差損失科目二                         */
aps55       nvarchar(24),            /*利差收益科目                           */
aps551      nvarchar(24),            /*利差收益科目二                         */
aps56       nvarchar(24),            /*代付匯票科目                           */
aps561      nvarchar(24),            /*代付匯票科目二                         */
aps57       nvarchar(24),            /*轉帳手續科目                           */
aps571      nvarchar(24),            /*轉帳手續科目二                         */
aps58       nvarchar(24),            /*應付電匯科目                           */
aps581      nvarchar(24),            /*應付電匯科目二                         */
aps59       nvarchar(24),            /*No Use                                 */
aps60       nvarchar(24),            /*No Use                                 */
aps61       nvarchar(24),            /*溢退科目                               */
aps611      nvarchar(24),            /*溢退科目二                             */
apsacti     nvarchar(1),             /*資料有效碼                             */
apsdate     datetime,                /*最近修改日                             */
apsgrup     nvarchar(6),             /*資料所有群                             */
apsmodu     nvarchar(10),            /*資料更改者                             */
apsorig     nvarchar(10),            /*資料建立部門                           */
apsoriu     nvarchar(10),            /*資料建立者                             */
apsuser     nvarchar(10)             /*資料所有者                             */
);

alter table aps_file add constraint aps_pk primary key  (aps01);
grant select on aps_file to tiptopgp;
grant update on aps_file to tiptopgp;
grant delete on aps_file to tiptopgp;
grant insert on aps_file to tiptopgp;
grant references on aps_file to tiptopgp;
grant references on aps_file to ods;
grant select on aps_file to ods;
