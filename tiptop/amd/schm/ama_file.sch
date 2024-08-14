/*
================================================================================
檔案代號:ama_file
檔案名稱:申報稅籍資料維護
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ama_file
(
ama01       nvarchar(10) NOT NULL,   /*申報部門編號                           */
ama02       nvarchar(20),            /*統一編號                               */
ama03       nvarchar(20),            /*稅籍編號                               */
ama04       nvarchar(80),            /*稅捐處全名                             */
ama05       nvarchar(255),           /*營業地址(一)                           */
ama06       nvarchar(255),           /*營業地址(二)                           */
ama07       nvarchar(80),            /*公司對外全名                           */
ama08       smallint,                /*已申報年度                             */
ama09       smallint,                /*已申報月份                             */
ama10       smallint,                /*申報月數                               */
ama11       nvarchar(40),            /*負責人                                 */
                                     /*負責人  #No.B231 010505 add            */
ama12       nvarchar(1),             /*是否可修改前端拋轉的金額資             */
                                     /*是否可修改前端拋轉的金額資料 #No.B231  */
ama13       nvarchar(1),             /*資料別                                 */
ama14       nvarchar(1),             /*縣市別                                 */
ama15       nvarchar(1),             /*總繳代號                               */
ama16       nvarchar(1),             /*自行或委託辦理申報註記                 */
ama17       nvarchar(10),            /*(代理)申報人身分證統一編號             */
ama18       nvarchar(40),            /*(代理)申報人姓名	                        */
ama19       nvarchar(11),            /*(代理)申報人電話                       */
ama20       nvarchar(80),            /*代理申報人證書(登錄)字號               */
ama21       nvarchar(4),             /*(代理)申報人電話區碼                   */
ama22       nvarchar(5),             /*(代理)申報人電話分機號碼               */
ama23       nvarchar(20),            /*總機構統編                             */
ama24       nvarchar(1),             /*進銷資料併總公司合併申報               */
amaacti     nvarchar(1),             /*資料有效碼                             */
amadate     datetime,                /*最近修改日                             */
amagrup     nvarchar(10),            /*資料所有部門                           */
amamodu     nvarchar(10),            /*資料修改者                             */
amaorig     nvarchar(10),            /*資料建立部門                           */
amaoriu     nvarchar(10),            /*資料建立者                             */
amauser     nvarchar(10)             /*資料所有者                             */
);

alter table ama_file add constraint ama_pk primary key  (ama01);
grant select on ama_file to tiptopgp;
grant update on ama_file to tiptopgp;
grant delete on ama_file to tiptopgp;
grant insert on ama_file to tiptopgp;
grant references on ama_file to tiptopgp;
grant references on ama_file to ods;
grant select on ama_file to ods;
