/*
================================================================================
檔案代號:poy_file
檔案名稱:多角貿易流程代碼設定單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poy_file
(
poy01       nvarchar(8) NOT NULL,    /*流程代碼                               */
poy02       smallint NOT NULL,       /*站別                                   */
poy03       nvarchar(10),            /*下游廠商編號                           */
poy04       nvarchar(10),            /*營運中心編號                           */
poy05       nvarchar(4),             /*計價幣別                               */
                                     /*計價幣別 -> azi01                      */
poy06       nvarchar(10),            /*付款條件                               */
poy07       nvarchar(6),             /*收款條件                               */
poy08       nvarchar(4),             /*SO稅別                                 */
poy09       nvarchar(4),             /*PO稅別                                 */
poy10       nvarchar(10),            /*銷售分類                               */
poy11       nvarchar(10),            /*倉庫別                                 */
poy12       nvarchar(5),
poy13       nvarchar(1),             /*AP類別                                 */
poy14       nvarchar(10),            /*營運中心編號                           */
poy15       nvarchar(4),             /*計價幣別                               */
                                     /*--------以下為財務預設基本資料----------*/
poy16       nvarchar(10),            /*AR科目類別                             */
poy17       nvarchar(10),            /*AP科目類別                             */
poy18       nvarchar(10),            /*AR部門編號                             */
poy19       nvarchar(10),            /*AP部門編號                             */
poy20       nvarchar(1),             /*營業額申報方式                         */
                                     /*1.全額申報 2.差額申報 3.不申報         */
poy21       nvarchar(1),             /*No Use                                 */
poy22       nvarchar(1),             /*No Use                                 */
poy23       nvarchar(1),             /*No Use                                 */
poy24       nvarchar(1),             /*No Use                                 */
poy25       nvarchar(1),             /*No Use                                 */
poy26       nvarchar(1),             /*是否計算業績                           */
poy27       nvarchar(10),            /*業績歸屬組織                           */
poy28       nvarchar(10),            /*出貨理由碼                             */
poy29       nvarchar(10),            /*代送商編號                             */
poy30       nvarchar(10),            /*倉退理由碼                             */
poy31       nvarchar(10),            /*銷退理由碼                             */
poy32       nvarchar(10),            /*調撥理由碼                             */
poy33       nvarchar(10),            /*債權代碼                               */
poy34       nvarchar(5),             /*訂單單別                               */
poy35       nvarchar(5),             /*採購單單別                             */
poy36       nvarchar(5),             /*出單單別                               */
poy37       nvarchar(5),             /*收貨單單別                             */
poy38       nvarchar(5),             /*入庫單單別                             */
poy39       nvarchar(5),             /*AR單別                                 */
poy40       nvarchar(5),             /*AP單別                                 */
poy41       nvarchar(5),             /*銷退單單別                             */
poy42       nvarchar(5),             /*倉銷退單單別                           */
poy43       nvarchar(5),             /*AR折讓單別                             */
poy44       nvarchar(5),             /*AP折讓單別                             */
poy45       nvarchar(10),            /*訂單成本中心                           */
poy46       nvarchar(10),            /*採購成本中心                           */
poy47       nvarchar(5),             /*出貨通知單別                           */
poy48       nvarchar(5),             /*INVOICE單別                            */
poy49       nvarchar(5),             /*PACKING單別                            */
poyud01     nvarchar(255),           /*自訂欄位-Textedit                      */
poyud02     nvarchar(40),            /*自訂欄位-文字                          */
poyud03     nvarchar(40),            /*自訂欄位-文字                          */
poyud04     nvarchar(40),            /*自訂欄位-文字                          */
poyud05     nvarchar(40),            /*自訂欄位-文字                          */
poyud06     nvarchar(40),            /*自訂欄位-文字                          */
poyud07     decimal(18),             /*自訂欄位-數值                          */
poyud08     decimal(18),             /*自訂欄位-數值                          */
poyud09     decimal(18),             /*自訂欄位-數值                          */
poyud10     integer,                 /*自訂欄位-整數                          */
poyud11     integer,                 /*自訂欄位-整數                          */
poyud12     integer,                 /*自訂欄位-整數                          */
poyud13     datetime,                /*自訂欄位-日期                          */
poyud14     datetime,                /*自訂欄位-日期                          */
poyud15     datetime                 /*自訂欄位-日期                          */
);

alter table poy_file add constraint poy_pk primary key  (poy01,poy02);
grant select on poy_file to tiptopgp;
grant update on poy_file to tiptopgp;
grant delete on poy_file to tiptopgp;
grant insert on poy_file to tiptopgp;
grant references on poy_file to tiptopgp;
grant references on poy_file to ods;
grant select on poy_file to ods;
