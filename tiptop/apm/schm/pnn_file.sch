/*
================================================================================
檔案代號:pnn_file
檔案名稱:採購分配底稿檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnn_file
(
pnn01       nvarchar(20) NOT NULL,   /*請購單號                               */
pnn02       smallint NOT NULL,       /*請購項次                               */
pnn03       nvarchar(40) NOT NULL,   /*料件編號                               */
pnn05       nvarchar(10) NOT NULL,   /*廠商編號                               */
pnn06       nvarchar(4) NOT NULL,    /*幣別                                   */
pnn07       decimal(18),             /*分配率                                 */
pnn08       decimal(18),             /*替代量率                               */
                                     /*替代量率(單位替代量)                   */
pnn09       decimal(18),             /*原分配量                               */
pnn10       decimal(18),             /*採購單價                               */
pnn10t      decimal(18),             /*含稅單價                               */
pnn11       datetime,                /*到廠日期                               */
pnn12       nvarchar(4),             /*採購單位                               */
pnn13       nvarchar(1),             /*替代特性                               */
pnn14       nvarchar(40),            /*替代料件                               */
pnn15       nvarchar(10),            /*採購員                                 */
pnn16       nvarchar(1),             /*修正否                                 */
pnn17       decimal(18),             /*轉換率                                 */
pnn18       nvarchar(20),            /*Blanket PO單號                         */
                                     /*Blanket PO單號 add 90/09/05            */
pnn19       smallint,                /*Blanket PO項次                         */
                                     /*Blanket PO項次 add 90/09/05            */
pnn20       decimal(18),             /*轉換因子                               */
                                     /*轉換因子       add 90/09/05            */
                                     /*本欄位為採購單位/Blanket PO單位的轉換率*/
pnn30       nvarchar(4),             /*單位一                                 */
pnn31       decimal(18),             /*單位一換算率(與採購單位)               */
pnn32       decimal(18),             /*單位一數量                             */
pnn33       nvarchar(4),             /*單位二                                 */
pnn34       decimal(18),             /*單位二換算率(與採購單位)               */
pnn35       decimal(18),             /*單位二數量                             */
pnn36       nvarchar(4),             /*計價單位                               */
pnn37       decimal(18),             /*計價數量                               */
pnn38       decimal(18),             /*未稅金額                               */
pnn38t      decimal(18),             /*含稅金額                               */
pnn919      nvarchar(50),            /*計畫批號                               */
pnnlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
pnnplant    nvarchar(10) NOT NULL    /*所屬營運中心                           */
);

create        index pnn_02 on pnn_file (pnn01,pnn02);
create        index pnnplant_idx on pnn_file (pnnplant);
alter table pnn_file add constraint pnn_pk primary key  (pnn01,pnn02,pnn03,pnn05,pnn06);
grant select on pnn_file to tiptopgp;
grant update on pnn_file to tiptopgp;
grant delete on pnn_file to tiptopgp;
grant insert on pnn_file to tiptopgp;
grant references on pnn_file to tiptopgp;
grant references on pnn_file to ods;
grant select on pnn_file to ods;
