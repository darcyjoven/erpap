/*
================================================================================
檔案代號:shm_file
檔案名稱:Run Card 資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shm_file
(
shm01       nvarchar(19) NOT NULL,   /*Run Card                               */
shm012      nvarchar(20),            /*工單編號                               */
shm05       nvarchar(40),            /*料件編號                               */
shm06       nvarchar(10),            /*使用製程編號                           */
                                     /*使用製程編號  ecu01                    */
shm08       decimal(18) NOT NULL,    /*生產數量                               */
shm09       decimal(18) NOT NULL,    /*完工入庫數量                           */
shm10       decimal(18) NOT NULL,    /*再加工數量                             */
shm11       decimal(18) NOT NULL,    /*F.Q.C 數量                             */
shm111      decimal(18) NOT NULL,    /*MRB   數量                             */
shm12       decimal(18) NOT NULL,    /*報廢數量                               */
shm121      decimal(18) NOT NULL,    /*在製盤盈虧量                           */
                                     /*在製盤盈虧量  add 99/04/27             */
shm122      decimal(18),             /*No Use                                 */
shm13       datetime,                /*預計起始生產日期                       */
shm14       nvarchar(5),             /*預計起始生產時間                       */
                                     /*預計起始生產時間(時:分)                */
shm15       datetime,                /*預計結束生產日期                       */
shm16       nvarchar(5),             /*預計結束生產時間                       */
                                     /*預計結束生產時間(時:分)                */
shm17       smallint,                /*已完工製程序號                         */
shm18       nvarchar(20),            /*號機                                   */
shm28       nvarchar(1),             /*結案否                                 */
shm86       nvarchar(19),            /*Run Card                               */
shm91       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm92       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm93       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm94       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm95       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm96       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm97       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm98       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shm99       nvarchar(1),             /*使用者自訂                             */
                                     /*使用者自訂(USER DEFINE)                */
shmacti     nvarchar(1),             /*資料有效碼                             */
                                     /*系統維護                               */
shmdate     datetime,                /*最近修改日                             */
                                     /*系統維護                               */
shmgrup     nvarchar(10),            /*資料所有群                             */
                                     /*系統維護                               */
shmlegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
shmmodu     nvarchar(10),            /*資料更改者                             */
                                     /*系統維護                               */
shmorig     nvarchar(10),            /*資料建立部門                           */
shmoriu     nvarchar(10),            /*資料建立者                             */
shmplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
shmuser     nvarchar(10)             /*資料所有者                             */
                                     /*系統維護                               */
);

create        index shm_02 on shm_file (shm05);
create        index shmplant_idx on shm_file (shmplant);
alter table shm_file add constraint shm_pk primary key  (shm01);
grant select on shm_file to tiptopgp;
grant update on shm_file to tiptopgp;
grant delete on shm_file to tiptopgp;
grant insert on shm_file to tiptopgp;
grant references on shm_file to tiptopgp;
grant references on shm_file to ods;
grant select on shm_file to ods;
