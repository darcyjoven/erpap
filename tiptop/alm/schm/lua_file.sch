/*
================================================================================
檔案代號:lua_file
檔案名稱:費用單單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lua_file
(
lua01       nvarchar(20) DEFAULT ' ' NOT NULL, /*費用單編號*/
lua02       nvarchar(2),             /*費用單類型                             */
lua03       nvarchar(1) DEFAULT ' ', /*費用單來源                             */
lua04       nvarchar(20),            /*合同編號                               */
lua05       nvarchar(1) DEFAULT ' ' NOT NULL, /*商戶來源*/
lua06       nvarchar(20),            /*客戶編號                               */
lua061      nvarchar(20),            /*客戶簡稱                               */
lua07       nvarchar(20),            /*攤位號                                 */
lua08       decimal(18) DEFAULT '0' NOT NULL, /*未稅總金額*/
lua08t      decimal(18) DEFAULT '0' NOT NULL, /*含稅總金額*/
lua09       datetime,                /*單據日期                               */
lua10       nvarchar(1) DEFAULT ' ' NOT NULL, /*系統自動生成*/
lua11       nvarchar(1) DEFAULT ' ', /*來源作業                               */
lua12       nvarchar(20),            /*單據號                                 */
lua13       nvarchar(1) DEFAULT ' ' NOT NULL, /*是否簽核*/
lua14       nvarchar(1) DEFAULT ' ' NOT NULL, /*簽核狀態*/
lua15       nvarchar(1) DEFAULT ' ' NOT NULL, /*確認碼*/
lua16       nvarchar(10),            /*確認人                                 */
lua17       datetime,                /*確認日期                               */
lua18       nvarchar(60),            /*備注                                   */
lua19       nvarchar(10),            /*來源營運中心                           */
lua20       nvarchar(20),            /*合同版本號                             */
lua21       nvarchar(4),             /*稅種                                   */
lua22       decimal(18),             /*稅率                                   */
lua23       nvarchar(1) DEFAULT ' ' NOT NULL, /*含稅否*/
lua24       nvarchar(20),            /*財務單號                               */
lua27       datetime,                /*大月結日期                             */
lua28       datetime,                /*應收報表計租起始日期                   */
lua29       datetime,                /*應收報表計租截止日期                   */
lua30       datetime,                /*費用起始日期                           */
lua31       datetime,                /*費用截止日期                           */
lua32       nvarchar(1) DEFAULT ' ' NOT NULL, /*客戶來源*/
luaacti     nvarchar(1) DEFAULT ' ' NOT NULL, /*資料有效碼*/
luacrat     datetime,                /*資料創建日                             */
luadate     datetime,                /*最近修改日                             */
luagrup     nvarchar(10),            /*資料所有群                             */
lualegal    nvarchar(10) NOT NULL,   /*所屬法人                               */
luamodu     nvarchar(10),            /*資料修改者                             */
luaorig     nvarchar(10),            /*資料建立部門                           */
luaoriu     nvarchar(10),            /*資料建立者                             */
luaplant    nvarchar(10) NOT NULL,   /*所屬營運中心                           */
luauser     nvarchar(10)             /*資料所有者                             */
);

create        index luaplant_idx on lua_file (luaplant);
alter table lua_file add constraint lua_pk primary key  (lua01) deferrable initially deferred;
grant select on lua_file to tiptopgp;
grant update on lua_file to tiptopgp;
grant delete on lua_file to tiptopgp;
grant insert on lua_file to tiptopgp;
grant references on lua_file to tiptopgp;
grant references on lua_file to ods;
grant select on lua_file to ods;
