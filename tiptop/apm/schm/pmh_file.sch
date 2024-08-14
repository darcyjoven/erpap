/*
================================================================================
檔案代號:pmh_file
檔案名稱:供應廠商料件對應資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmh_file
(
pmh01       nvarchar(40) NOT NULL,   /*料件編號                               */
pmh02       nvarchar(10) NOT NULL,   /*供應廠商編號                           */
pmh03       nvarchar(1),             /*是否為主要供應廠商                     */
                                     /*是否為主要供應廠商(Y/N)                */
pmh04       nvarchar(40),            /*廠商料件編號                           */
pmh05       nvarchar(1),             /*核准狀況碼                             */
                                     /*0: 已核准  1.核准中  2.未核准          */
pmh06       datetime,                /*核准日期                               */
pmh07       nvarchar(24),            /*廠牌編號                               */
pmh08       nvarchar(1),             /*檢驗否                                 */
                                     /*N: 免檢  Y:需入庫檢驗                  */
pmh09       nvarchar(1),             /*檢驗程度                               */
                                     /*N.正常檢驗 T.加嚴檢驗 R.減量檢驗       */
pmh10       datetime,                /*免檢核准日期                           */
pmh11       decimal(18),             /*分配比率                               */
                                     /*分配比率(%)                            */
pmh12       decimal(18),             /*最近採購單價                           */
                                     /*最近採購單價(原幣)             (97/07) */
pmh13       nvarchar(4) NOT NULL,    /*採購幣別                               */
pmh14       decimal(18),             /*匯率                                   */
pmh15       nvarchar(1),             /*檢驗水準                               */
                                     /*1.一般    2.特殊                       */
pmh16       nvarchar(1),             /*級數                                   */
pmh17       nvarchar(4),             /*最近採購稅別                           */
pmh18       decimal(18),             /*稅率                                   */
pmh19       decimal(18),             /*最近採購含稅單價                       */
pmh20       nvarchar(1),             /*No Use                                 */
pmh21       nvarchar(6) NOT NULL,    /*作業編號                               */
pmh22       nvarchar(1) NOT NULL,    /*價格型態                               */
                                     /*1.採購  2. 委外                        */
pmh23       nvarchar(10) NOT NULL,   /*製程單元編號,為空代表此筆資            */
pmh24       nvarchar(1) DEFAULT 'N', /*VMI採購                                */
pmh25       nvarchar(1) DEFAULT 'N' NOT NULL, /*電子採購料件*/
pmhacti     nvarchar(1),             /*資料有效碼                             */
pmhdate     datetime,                /*最近修改日                             */
pmhgrup     nvarchar(10),            /*資料所有部門                           */
pmhmodu     nvarchar(10),            /*資料修改者                             */
pmhorig     nvarchar(10),            /*資料建立部門                           */
pmhoriu     nvarchar(10),            /*資料建立者                             */
pmhuser     nvarchar(10)             /*資料所有者                             */
);

alter table pmh_file add constraint pmh_pk primary key  (pmh01,pmh02,pmh13,pmh21,pmh22,pmh23) deferrable initially deferred;
grant select on pmh_file to tiptopgp;
grant update on pmh_file to tiptopgp;
grant delete on pmh_file to tiptopgp;
grant insert on pmh_file to tiptopgp;
grant references on pmh_file to tiptopgp;
grant references on pmh_file to ods;
grant select on pmh_file to ods;
