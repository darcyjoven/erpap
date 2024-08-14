/*
================================================================================
檔案代號:sfd_file
檔案名稱:料表批號明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfd_file
(
sfd01       nvarchar(20) NOT NULL,   /*料表批號 (PBI number)                  */
                                     /*料表批號  (PBI number)                 */
                                     /*儲存合併料表的批次編號                 */
                                     /*此號碼可作為工單領/發料及料帳扣除時的  */
                                     /*處理依據                               */
sfd02       smallint NOT NULL,       /*項次                                   */
                                     /*儲存該批號歸屬工單順序序號             */
sfd03       nvarchar(20),            /*工單編號                               */
                                     /*儲存該料表批號所屬工單編號             */
sfd04       smallint,                /*合拼序                                 */
sfd05       integer,                 /*模數                                   */
sfd06       integer,                 /*總模數                                 */
sfd07       nvarchar(10),            /*被取代製程段號                         */
sfd08       nvarchar(20),            /*合拼版號                               */
sfd91       nvarchar(1),             /*使用者自訂                             */
sfd92       nvarchar(1),             /*使用者自訂                             */
sfd93       nvarchar(1),             /*使用者自訂                             */
sfd94       nvarchar(1),             /*使用者自訂                             */
sfd95       nvarchar(1),             /*使用者自訂                             */
sfdconf     nvarchar(1) DEFAULT ' ' NOT NULL /*確認否*/
);

create        index sfd_02 on sfd_file (sfd03);
alter table sfd_file add constraint sfd_pk primary key  (sfd01,sfd02);
grant select on sfd_file to tiptopgp;
grant update on sfd_file to tiptopgp;
grant delete on sfd_file to tiptopgp;
grant insert on sfd_file to tiptopgp;
grant references on sfd_file to tiptopgp;
grant references on sfd_file to ods;
grant select on sfd_file to ods;
