# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt540.4gl
# Descriptions...: 採購單單頭資料維護作業(簡易輸入)
# Date & Author..: 92/11/17 By Apple
#               (輸入採購單身時,必須將請購單單頭狀態pmk25 改為 '2')
#                  (刪除時,當請購單上已轉採購量為0時,update請購狀況碼為'1')
#                  (更改單頭之單據性質,但單身之性質未update)
#                  (採購單位未找到換算率,加show error massage)
#                  (增加請購單開窗,料件^T開窗,單身加送貨地址pmn23,急料否pmn63)
#                  (特別說明改call apmt402)(單身增加保稅否及會計科目)
#                  (立即列印改先default單據性質smyprint,採購部門由採購人員def)
#                  (增加PO對PR轉換率,替代功能修改,增加採購單價check功能,簡化menu
# Modify.........: No:7857 03/08/20 By Mandy 呼叫自動取單號時應在 Transction中
# Modify.........: No.7920 03/08/26 Kammy 1.add pmm99 多角序號,主畫面add pmm905
#                                         2.多角流程代碼抓取方式
# Modify.........: No.8841 03/12/04 Kitty pmn122不可為null否則轉ap會有問題
# Modify.........: No.9034 04/01/12 Kammy 針對委外型態，若為一對多工單，
#                                         不應判斷工單已確認不允許發出還原
# Modify.........: No.9595 04/05/25 Carol 單身交貨日在確認時應再次檢查是否
#                                         有空白,有的話不可確認
# Modify.........: No.8618 03/11/27 Apple 改公式g_pmn[l_ac].pmn31*g_pmm.pmm42> l_ima53* (1+g_sma.sma84/100)
# Modify.........: No.8752 03/11/27 Apple 在 g_sma.sma109='R' 時也應顯示錯誤訊息。
# Modify.........: No.9811 04/07/31 Wiky 在輸入廠商時,會自動帶出稅別,但不會自動代出稅率!
# Modify.........: No.MOD-480178 04/08/05 ECHO 取消CALL t540_ef的註解
# Modify.........: No.9842 04/08/10 Wiky NO.9842修改(smallint 不可用' ' ) 先給NULL 因為No.3545 中let pmn69 = ' ',ORACLE會產生錯誤-1349
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-490248 04/09/15 By Smapmin以彈跳視窗顯示警告訊息
# Modify.........: No.MOD-490282 04/09/15 By 多角貿易拋轉否 default 'N'
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4A0061 04/10/08 By Smapmin查詢時新增採購單號開窗功能
# Modify.........: No.MOD-4A0138 04/10/11 By Mandy 單身料件編號是MISC的情況時,品名規格應抓apmt420的品名,不應抓料件主檔的規格
# Modify.........: No.MOD-4A0134 04/10/11 By Mandy 單身維護時,跳最後一筆,按[放棄]後要再 重清畫面一次;不然會殘留異常!
# Modify.........: No.MOD-4A0334 04/10/29 By Carrier
# Modify.........: No.MOD-4A0356 04/11/02 By Nicola p_ze有C開頭的錯誤碼
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0104 04/11/12 By Mandy 到單身後選一筆,按右側的 "其他資料維護" ,去維護輸入會計科目,確認後,再查出來,資料沒有update 乃是空白
# Modify.........: No.MOD-4B0119 04/11/12 By Mandy 到單身後選一筆,按右側的 "其他資料維護" ,1.按倉庫欄位開窗後,程式當出
#                                                                                          2.原替代料號的值為A,按替代料號開窗選B後,則畫面show的值還是A
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0276 04/11/26 By Mandy LET g_qryparam.where = " AND ........."
#                                                                           ^^^最一開始這�不能有AND 否則組SQL會錯
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmi600/apmq210/apmq220時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.MOD-4B0058 04/12/06 By Echo  aoos010設定不使用 EasyFlow 但單據設定需簽核(使用tiptop簡易簽核)
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0049 04/12/13 By Mandy 頁尾之筆數顯示在新增狀況時其/後之數字會顯示小數二位,如/3.00
# Modify.........: No.FUN-4C0074 04/12/14 By pengu 匯率幣別欄位修改，與aoos010的azi17做判斷，
#                                                   如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-4C0072 04/12/15 By Carol  error message 顯示錯誤 add ze: tri-022
# Modify.........: No.MOD-4B0143 04/12/16 By Nicola 單身未輸入，無法移回上一筆
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.MOD-530163 05/03/24 By Mandy 用單身做查詢條件，SQL語法中必須加UNIQUE，要不然如果同一個單頭有多筆身資料符合條件的話，用上下筆翻就會有問題。
# Modify.........: No.MOD-530449 05/03/26 By Yuna 急料否預設值為null ，請購單轉入後，補完供應商資料及數量後，無法直接存檔,要預設為'N'
# Modify.........: No.MOD-530715 05/03/28 By Mandy 若已有採購變更單，則不允許進行發出還原。
# Modify.........: No.MOD-530719 05/03/28 By Mandy pmn36, pmn37 應該預設與 pmn33, pmn34 一致
# Modify.........: No.MOD-530331 05/03/28 By Mandy 單身新增 button 可以再補入預算資料
# Modify         : No.MOD-530885 05/03/31 by alexlin VAR CHAR->CHAR
# Modify         : No.MOD-540007 05/04/01 by Echo  送簽中按發出,沒有error message 提示
# Modify.........: No.MOD-530881 05/04/04 by wujie  修改進單身后產生死循環
# Modify.........: No.MOD-540057 05/04/26 By kim 請購與採購的勾稽
# Modify         : No.MOD-540162 05/05/06 By Mandy AFTER FIELD pmn41 筆誤寫 AND sfb87! = 'X' ,不可以寫! = ,有空格要改成!=
# Modify         : No.FUN-550038 05/05/11 by Echo 複製功能，無判斷單別是否簽核，
#                                                 將確認與簽核流程拆開獨立。
# Modify.........: No.FUN-550019 05/05/17 By Danny 採購含稅單價
#                                                  BUG處理,若pmn31有值,則不CALL s_defprice
# Modify.........: No.FUN-540027 05/05/20 By Elva  新增雙單位內容
# Modify.........: No.FUN-540027 05/05/31 By jackie 單據編號加大
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560020 05/06/07 By Elva  雙單位內容修改
# Modify.........: No.MOD-550066 05/05/09 By Mandy 在AFTER INSERT 時若pmn121的值為NULL,帶default pmn121=1
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-560197 05/06/23 By saki  多單位內容顯示
# Modify.........: No.MOD-560002 05/07/04 By Yiting 查詢不開委外單號
# Modify.........: No.MOD-550148 05/07/11 By Yiting 輸入請購單號項次號 , 料號還>
# Modify.........: NO.MOD-570073 05/07/12 By Yiting 若參數 設定走料件供應商,則進
# Modify.........: NO.MOD-570246 05/07/20 By Yiting 輸入 原始交貨日 直接按確定 >
# Modify.........: No.FUN-580027 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-570406 05/08/10 By Nicola 單據性質為"SUB"時，請購單號不一定要輸入
# Modify.........: No.MOD-580002 05/08/12 By Nicola 已預付，不可取消確認
# Modify.........: No.FUN-590020 05/09/09 By Nicola 料件為"MISC"時，保稅預設為"N"
# Modify.........: No.FUN-590029 05/09/09 By Nicola 單身第二筆預設"請購單號"移至項次再移回來，會不見！
# Modify.........: No.MOD-580037 05/09/12 By Nicola 出貨日期為非工作日，只警告
# Modify.........: No.MOD-580207 05/09/23 By Nicola 請購轉採購,採購單維護時,抓取pmh_file資料時,應將pmh07帶至pmn123...(廠牌)
# Modify.........: No.MOD-590003 05/09/05 By day  查詢時單位的controlp返回值有問題
# Modify.........: No.FUN-580113 05/09/13 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.MOD-590282 05/09/15 By Nicola 加入日期控管，採購日期=<交貨日期+<到廠日期
# Modify.........: No.MOD-590084 05/09/20 By Nicola 取消確認時，更新序號不可加1
# Modify.........: No.MOD-590346 05/09/16 By Carrier mark du_default()
# Modify.........: No.TQC-590007 05/09/29 By Rosayu 複製時請加判斷若請購與採購互相勾稽,則不能作複製的動作並show"請購與採購互相勾稽,所以不能複製."
# Modify.........: No.TQC-5A0015 05/10/07 By Mandy 程式中單身 請購單號,Blanker PO單號 不需設定依照系統參數(aoos010)設定單據編號欄位格式,
#                                                  因為加了此設定會清不掉請購單號,Blanker PO單號,一定會有值'-',則會影響程式正確的判斷
# Modify.........: No.MOD-590033 05/10/19 By Nicola 單據性質為"SUB"，單身無資料時，查詢不到
# Modify.........: No.MOD-590182 05/09/15 By Nicola tri-022未考慮若出貨工廠出通單作廢的情形!
# Modify.........: No.FUN-5A0101 05/10/24 By Sarah 將pmn904的controlp部分換成call q_poz1
# Modify.........: NO.TQC-5A0096 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.MOD-5A0451 05/11/08 By Nicola 急料與保稅給預設值
# Modify.........: No.MOD-5A0415 05/11/08 By Nicola 到廠日期不可小於等於交貨日期
# Modify.........: No.MOD-5B0002 05/11/08 By Nicola 新增第二筆以上之單身時，不預設到廠日期
# Modify.........: No.TQC-5B0060 05/11/09 By Mandy #pmn35(原始到庫日期) = pmn34(原始到廠日期) + ima491(入庫前置期)
# Modify.........: No.TQC-5B0058 05/11/09 By Mandy 在輸入單身時,若原始交貨日期輸入空白,然後按Enter後就hold住了.(GP 2.0)才有此問題
# Modify.........: NO.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.MOD-5C0024 05/12/05 By Nicola COPY時，pmm99為null
# Modify.........: No.TQC-5C0014 05/12/05 By Carrier set_required時去除單位換算率
# Modify.........: No.MOD-5C0113 05/12/21 By Nicola _pmn25()中,將pml35預設給g_pmn2.pmn35
# Modify.........: No.FUN-5B0059 06/01/03 By Sarah t540_out()中,第四個參數g_bgjob請改傳N
# Modify.........: No.FUN-610018 06/01/06 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610028 06/01/19 By Sarah t540_out()中,傳g_lang的地方改成傳pmc911
# Modify.........: NO.FUN-5A0193 06/01/20 BY yiting 單據性質為SUB時 ，供應商應與工單供應商資料相同
# Modify.........: No.FUN-610076 06/01/23 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-610019 06/02/21 By Nicola 單身新增寫入失敗
# Modify.........: No.FUN-620063 06/02/27 By saki 自訂欄位功能
# Modify.........: No.FUN-630006 06/03/06 By Nicola 新增欄位pmm909(資料來源)
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.MOD-630039 06/03/14 By Claire 1)委外採購單採購還原不可將已結單的一併還原
#                                                   2)委外採購單採購發出不可將已結單的一併發出
#                                                   3)委外採購單確認時, 不可將已結案的單身也做確認
#                                                   4)委外採購單取消確認時, 不可將已結案的單身也做取消確認
#                                                   5)委外採購單更正時, 不可將已結案的單身也做同步更正
# Modify.........: No.FUN-630040 06/03/23 By Nicola 若請購單項次為統購料,則不可敲採購單
# Modify.........: No.MOD-610151 06/03/23 By Claire 僅提供輸入MISC料號時才能更改品名(pmn041)
# Modify.........: No.MOD-610037 06/04/03 By pengu 若不用計價單位時，不會自動計算pmn88,pmn88t的金額
# Modify.........: No.TQC-620023 06/04/03 By pengu FUNCTION t540_set_origin_field()計算pmn88,pmn88t的
#                                                  值用cl_digcut()取值,否則會有尾差
# Modify.........: No.TQC-620024 06/04/03 By pengu FUNCTION t540_update()計算pmm40,pmm40t的值改用pmn88,pmm88t
# Modify.........: No.MOD-620073 06/04/03 By pengu q_pmh的條件為pmhacti='Y' AND pmh01 = ima01 AND pmh02 = 'arg1'
#                                               但在第3120行中，並沒有給它引數
# Modify.........: No.MOD-620088 06/04/03 By pengu FUNCTION t564()中畫面可去輸入pmn14,pmn15,pmn35,pmn36,pmn37
#                                                  但輸入完後並沒有update其值到資料庫內
# Modify.........: No.TQC-640011 06/03/01 By Echo 單據性質為SUB時，傳入採購單號參數時應能帶出資料
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640074 06/04/09 By Mandy 委外採購單須和採購單一樣需配合系統參數作 料件/供應商控管
# Modify.........: No.MOD-640233 06/04/11 By Sarah 當委外採購單之委外工單發料單已過帳,則不可做發出還原
# Modify.........: No.MOD-640436 06/04/12 By Sarah 輸入沖銷無交期採購單的採購單時，如果沒輸入沖銷項次，要卡住不能往下走
# Modify.........: No.MOD-640491 06/04/17 By Claire pmn24()未執行無法取得 g_ima49值,造成後來的計算式值得null
# Modify.........: No.MOD-640492 06/04/17 By Claire 加強訊息顯示
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.FUN-640263 06/04/28 By Sarah INSERT INTO pmn_file前,LET pmn65='1'
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650055 06/05/16 By Pengu 當系統參數設使用多單但aimi100中料號單位管制方式為1.單一單位
#                                                  若手動輸入單身資料時，會跳至母/參考單位及母/參考數量維護
# Modify.........: No.TQC-650108 06/05/22 BY Tracy 增加料件多屬性內容
# Modify.........: No.TQC-660020 06/06/07 BY Joe 修正委外工單轉採購單後,採購單單身欄位顯示異常問題
# Modify.........: No.TQC-650119 06/06/16 By Pengu 新增'資料來源'的查詢
# Modify.........: No.TQC-660074 06/06/16 By Pengu 執行'新增'or'修改'功能, 按放棄時, 會提示兩次放棄輸入的訊息(9001)
# Modify.........: No.FUN-660129 06/06/20 By wujie  cl_err --> cl_err3
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.FUN-660051 06/06/22 By Nicola 多角計價方式為反推時，最終廠商一定要輸入
# Modify.........: No.MOD-660090 06/06/22 By Rayven 料件多屬性補充修改，check_料號()內應再加傳p_cmd的參數
# Modify.........: No.TQC-660124 06/06/27 By Pengu asms290設定不使用計價單位，一旦按了進入單身,此時計價數量卻跑了出來
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670100 06/07/24 By Mandy 標準單價pmn30不正確
# Modify.........: No.MOD-670110 06/07/28 By Claire 料號做替代後單價應重新抓取
# Modify.........: No.FUN-680029 06/08/23 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: NO.FUN-670007 06/09/18 BY yiting 採購發出時依據pod05執行拋轉的動作，還原時亦然
# Modify.........: NO.TQC-680111 06/09/20 BY yiting 單價逆推加上日期條件
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.FUN-690047 06/09/28 By Sarah 畫面單身增加顯示pmn38,單身的pmn38(可用/不可用)預設跟單頭的pmm45一樣,
#                                                  當pmm45='Y'時,單身的pmn38可進入更改,當pmm45='N'時,單身的pmn38不可更改
# Modify.........: No.FUN-660067 06/10/11 By rainy 採購發出時，如廠商資料設定採購發出Mail給廠商時，將採購單查出當附件Mail給廠給的連絡人
# Modify.........: No.CHI-690043 06/10/17 By Sarah 採購單單身新增'取出單價'(pmn90)欄位,keep住最初default的採購單價
#                                                  超限率(sma84)也改以此取出單價(pmn90)與採購單價(pmn31)相比
# Modify.........: No.MOD-6A0142 06/10/31 By Ray 更改了采購數量之后計價數量雖然會隨之改變，但是update數據庫的時候update的是舊值
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/11/01 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-650191 06/11/06 By rainy pmw03改抓 pmx12
# Modify.........: No.FUN-6A0036 06/11/13 By rainy 判斷停產(ima140)時要一併判斷ima1401(生效日)
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0122 06/11/21 By rainy 輸入單身時，工單號碼改判斷應為"已確認"
# Modify.........: No.TQC-680028 06/11/24 By Claire 料號做替代後單價應重新抓取,該筆料號也應重計
# Modify.........: No.MOD-680097 06/11/24 By Claire 串apmt901直接deflaut印出特別說明及備註
# Modify.........: No.TQC-690086 06/12/08 By pengu  委外重工採購單，應不受單價不允許為0之限制
# Modify.........: No.MOD-6A0068 06/12/13 By pengu 委外採購單若單身未輸入工單號碼時，會出現ERR MESS (abm-731)
# Modify.........: No.MOD-6B0032 06/12/13 By pengu 若採購單作廢時,未update 無交期採購單的狀態及已轉數量
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.MOD-6B0155 06/12/14 By pengu 在請購單中可以登打"MISC-Eden"的料件,但到採購單時單身輸入請購單號後
#                                                  會出現"mfg0002"錯誤訊時
# Modify.........: No.MOD-6C0116 06/12/21 By Sarah 在t540_pmn25()裡,增加取單價的功能
# Modify.........: No.FUN-6C0040 06/12/29 By Jack Lai 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-6C0094 07/01/08 By kim 單身若有輸入請購單,則抓取請購單的成本中心,且不能修改
# Modify.........: No.MOD-6C0129 07/01/09 By pengu 單身'請購單單號"未檢查是否為已存在的單號
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.MOD-710071 07/01/22 By claire 修改單身料號時品名規格不會跟著改變
# Modify.........: No.MOD-710144 07/01/25 By Smapmin pmm44的選項有1~4
# Modify.........: No.FUN-6C0050 07/01/29 By rainy 單身顯示訂單單號及序號(可QBE)
# Modify.........: No.MOD-710141 07/01/31 By claire 當不使用計價單位及雙單位時,單身修改時若已存在單位一(pmn80)則單位一數量(pmn82)會不隱藏
# Modify.........: No.CHI-6B0006 07/02/26 By rainy 稅別更改時，訊問是否更新單價並重算，幣別匯率更改時，提示使用者要更改單身資料
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730012 07/03/21 By kim 將確認段移到sapmt540_sub.4gl
# Modify.........: No.FUN-720043 07/03/23 By Mandy APS相關調整
# Modify.........: No.FUN-730033 07/03/27 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.TQC-6C0205 07/04/04 By claire pmn30判斷有誤
# Modify.........: No.TQC-740044 07/04/10 By kim 多角貿易否會Display NULL
# Modify.........: No.FUN-740029 07/04/10 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-6C0131 06/04/11 By pengu 未考慮計價數量的沖銷的情形
# Modify.........: No.FUN-740033 07/03/27 By Carrier 會計科目加帳套-afa_file要傳帳套
# Modify.........: No.FUN-740046 07/04/12 By rainy 訂單號號/序號存到 pmn24/25,pmn94/95改為 no use
# Modify.........: No.TQC-730022 07/04/13 By rainy 由訂單輸入單身應可更改單價金額
# Modify.........: No.CHI-740014 07/04/16 By kim (採購單) 單身 pmm42(替代碼 ),pmm16(狀況碼)應不可輸入
# Modify.........: No.CHI-740014 07/04/16 By kim "agree"段的確認後的show的位置錯誤
# Modify.........: No.TQC-740164 07/04/22 By Nicola 抓供應商時，加入pmh21,pmh22條件
# Modify.........: No.TQC-740250 07/04/22 By Nicola t540sub_pmh()多一個參數
# Modify.........: No.MOD-740169 07/04/23 By Pengu 點選 [單價]按鈕不會顯示採購最近單價與採購市價資料
# Modify.........: No.MOD-740332 07/04/23 By Pengu 採購單已確認/發出後,按取消確認應SHOW錯誤訊息為"採購單已發出"
# Modify.........: No.MOD-740298 07/04/23 By claire 序號不可修改
# Modify.........: No.TQC-740281 07/04/24 By Echo 若由TIPTOP走簽核流程,APS Action要隱藏
# Modify.........: No.MOD-740282 07/04/25 By rainy 訂單轉入的資料開放單頭可供修改
# Modify.........: No.TQC-750013 07/05/04 By Mandy 1.參數設不串APS時,Action "APS相關資料"不要出現
#                                                  2.一進入程式,不查詢直接按APS相關資料,當出
# Modify.........: No.CHI-750005 07/05/08 By kim 取替代在單身輸入負數後，按確定鈕，程序退出更新沒有成功
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.MOD-750082 07/05/17 By claire 此段transation需用begin work包住
# Modify.........: No.MOD-750081 07/05/17 By claire 委外採購單輸入工單後要帶出 pmn122專案代號
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.TQC-750115 07/05/25 by yiting apmt540(採購單)單別未設定 ""預算管理"" (smy59='N') 預算號碼(pmm06)應不可輸入"
# Modify.........: No.MOD-750130 07/05/28 By claire (1) 單位二換算率於修改單身母單位時應重新給值
#                                                   (2) 單位一也未回寫
# Modify.........: No.TQC-760064 07/06/08 By wujie  請購轉采購后，采購單作廢時請購單狀態會變為1審核，但是采購單取消作廢后，請購單狀態并未更新為2
# Modify.........: No.TQC-750236 07/06/10 By claire MOD-530719調整新增時不給值,及發出還原時給空白
# Modify.........: No.MOD-760025 07/06/10 By claire 修改單頭稅別時,要先確定有單身資料再show訊息axm-191
# Modify.........: No.TQC-760152 07/06/18 By Rayven 采購發出無法還原，多角貿易流程代碼不用和當前比較
# Modify.........: No.TQC-770042 07/07/09 By Rayven 若請購與采購勾稽時,參數中差異百分比若沒維護,則判斷不出已勾稽.改為若差異百分比沒維護時,默認為0
# Modify.........: No.FUN-710060 07/08/08 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.TQC-710080 07/08/11 By pengu  當不使用計價單位時,若去修改請購單位時隱藏的計價單位不會跟著變動
# Modify.........: No.MOD-780108 07/08/17 By claire 發出還原時 要加上 pmm18='Y'及g_errno=' '才做apmp811
# Modify.........: No.MOD-780139 07/08/22 By claire 單身新增時為請購單的項次自動帶出料號後,應將料號設為noentry避免誤改料號
# Modify.........: No.MOD-780171 07/08/22 By Carol  單頭更改稅別,單身[pmn88]及[pmn88t]重計應用計價數量(pmn87)*單價
# Modify.........: No.TQC-770103 07/08/29 By claire 替代功能計算數量時,數量定義型態不可為整數
# Modify.........: No.FUN-760042 07/08/29 By claire 單身的其它說明維護需放在單頭段
# Modify.........: No.MOD-780283 07/08/31 By claire 委外採購的pmn09轉換率不可直接給1應取原值再寫回
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理
# Modify.........: No.MOD-730044 07/09/19 By claire 交易單位(pmn86)與採購單位(ima44)或計價單位(ima908)的轉換
# Modify.........: No.MOD-790079 07/09/19 By claire (1) 不使用計價單位時及多單位時, 修改單位, 數量及單價沒有連動
#                                                   (2) 請購單帶入採購單身時,取價的計價單位沒有給值
#                                                   (3) 請購單帶入採購單身後,料號要存給舊值,才不會造成採購單位重新取值
# Modify.........: No.MOD-7A0005 07/10/04 By Carol 委採單還原不update 工單狀態
# Modify.........: No.MOD-7A0126 07/10/23 By claire 單據性質(g_argv3)若為空白時,應給pmm02的值
# Modify.........: No.TQC-7A0025 07/10/22 By xufeng 新增或修改后的料件編號如果和請購單對應的料件不同時,彈出警告信息
# Modify.........: No.TQC-7A0093 07/10/24 By Judy 多單位，單身錄入時，料件為參考單位無法自動帶出采購單位
# Modify.........: No.TQC-7B0009 07/11/01 By wujie 彈出的警告信息內容不正確。描述：錄入采購單時，在“代理商”一欄輸入“廠商性質為2:付款廠商”的廠商編號，系統彈出警告信息（mfg3227)
# Modify.........: No.TQC-7B0015 07/11/02 By wujie 單身未輸入資料時，不彈出是否打印的詢問窗體
# Modify.........: NO.MOD-7B0085 07/11/12 BY yiting call t540sub_pmh( )傳入參加增加
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 自定義欄位功能修正
# Modify.........: No.MOD-7B0265 07/10/30 By claire 當單頭幣別值改變時,重取azi04的值
# Modify.........: No.TQC-7C0018 07/12/07 By heather 點擊"多角貿易"按鈕后彈出的prompt界面異常
# Modify.........: No.MOD-7C0050 07/12/07 By claire MISC料件無效時不可使用
# Modify.........: No.TQC-7C0072 07/12/07 By Unicorn 增加apm-590報錯信息
# Modify.........: No.MOD-7C0057 07/12/07 By claire 調整TQC-760152,否則待採來源單據不會檢核廠商要同於流程代碼所設第一站
# Modify.........: No.MOD-7C0058 07/12/07 By claire pmn09*pmn20需取位
# Modify.........: No.TQC-7C0060 07/11/08 By Rayven 多角貿易單據點擊“發出還原”、“取消審核”功能鈕，多角拋轉還原失敗程式無控管，并且允許發出還原及取消審核
# Modify.........: No.TQC-7C0109 07/12/08 By LILID  欄位過數量時，如果已經初始化了pmn31和pmn90,不可重新更改pmn90
# Modify.........: No.TQC-7C0112 07/12/08 By heather使彈出的prompt的界面點擊關閉按鈕可以離開
# Modify.........: No.TQC-7C0089 07/12/08 By heather點擊"替代"按鈕時出現的替代料號會重復
# Modify.........: No.TQC-7C0116 07/12/08 By LILID 單位換算錯誤
# Modify.........: No.TQC-7C0119 07/12/08 By LILID show錯誤信息以采購單位show
# Modify.........: No.TQC-7C0121 07/12/08 By LILID 如果去不到單價，取出價格初始化為最近采購單價
# Modify.........: No.TQC-7C0124 07/12/08 By Davidzv 進入單身"料件基本資料"action改為調用aimi100
# Modify.........: No.TQC-7C0108 07/12/10 By wujie 通過請購單帶出的單身資料,不可修改料件子屬性
# Modify.........: No.FUN-7C0004 07/12/10 By rainy 新增內部交易功能
# Modify.........: No.TQC-7C0131 07/12/12 By judy 通過請購單帶出的單身資料,不可修改料件子屬性加入到set_entry_b()中
# Modify.........: No.TQC-7C0033 07/12/12 By Rayven 拋轉還原前增加警告判斷
# Modify.........: No.TQC-7C0164 07/12/25 By rainy 判斷 l_smy53值時，考慮原客戶是NULL值的處理
# Modify.........: No.FUN-7C0017 07/12/27 By bnlent 增加行業別規範化修改
# Modify.........: No.FUN-810038 08/01/16 By kim GP5.1 ICD
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/30 By ve007 單身增加制單號字段，對Blanket PO增加替代功能
# Modify.........: No.FUN-810045 08/02/19 By rainy 項目管理，單頭專案代號pmm05顯示於畫面維護
#                                                  子劃面apmt541取消,單身pmn122(專案代號)後，加WBS編碼(pmn96)、活動代號(pmn97)、部門代號(pmn67)、 費用原因(pmn98)、會計科目(pmn40,pmn401)、預算編號(pmn66)
# Modify.........: No.FUN-7B0018 08/02/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: NO.FUN-7C0002 08/03/06 BY Yiting apsi214->apsi317.4gl
# Modify.........: No.MOD-810025 08/03/17 By claire 一般委外做 apm-038 check 製程委外不做 apm-038 check
# Modify.........: No.MOD-820091 08/03/17 By claire 委外採購手輸入時要 default pmn43,pmn431
# Modify.........: No.FUN-830018 08/03/17 By claire pmn11凍結碼畫碼顯示
# Modify.........: No.CHI-820014 08/03/17 By claire 調整TQC-7C0121條件錯誤
# Modify.........: No.MOD-830084 08/03/11 By claire 由單頭串其它資料時,資料要確保顯示正確
# Modify.........: No.FUN-7C0036 08/03/21 By jamie 報表列印時，不需參考慣用語言別的設定。
# Modify.........: No.CHI-830025 08/03/24 By kim 一班採購單不秀icd的採購單
# Modify.........: No.TQC-830053 08/03/26 By Dido 利用新舊值判斷跳過新增時檢核 apm-038
# Modify.........: No.CHI-830032 08/03/26 By kim GP5.1整合測試修改
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830161 08/04/01 By Carrier 去掉預算編號pmn66,pmm06
# Modify.........: No.FUN-840178 08/04/07 By ve007 debug 810016
# Modify.........: No.MOD-840054 08/04/07 By Dido 調整條件
# Modify.........: No.FUN-840042 08/04/15 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-840137 08/04/17 By Dido 修改計算 pmn88 邏輯 
# Modify.........: No.CHI-840015 08/04/18 By claire 使用參考單位時,修改單位一(銷售)單位時,應更新單位一的轉換率,以oeb05不以ima31
# Modify.........: No.CHI-830033 08/04/18 By claire 未(含)稅金額=未(含)稅單價*計價數量的方式調整為:
#                                                   (1)單價含稅時,以含稅金額/(1+稅率)/100 = 未稅金額 
#                                                   (1)單價未稅時,以未稅金額*(1+稅率)/100 = 含稅金額 
# Modify.........: No.MOD-840233 08/04/20 By kim GP5.1-ICD顧問測試修改
# Modify.........: No.MOD-840215 08/04/21 By kim GP5.1-ICD顧問測試修改
# Modify.........: No.MOD-850011 08/05/04 By chenl  對采購取消作廢時，轉采購數量進行判斷。
# Modify.........: No.MOD-840639 08/05/06 By claire 輸入完項次直接按確定,pmn08未帶值
# Modify.........: No.MOD-840665 08/05/06 By claire pmm40 define調整 
# Modify.........: No.MOD-850109 08/05/12 By Smapmin 單據性質為SUB時，供應商應與工單供應商資料相同，但必須過濾工單供應商為空者
# Modify.........: No.MOD-850127 08/05/20 By Smapmin 預設採購所屬會計年度/期別
# Modify.........: No.FUN-850027 08/05/30 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-850027 08/06/17 By douzh 計算并檢核預算耗用時考慮是以部門還是以營運中心傳入計算耗用
# Modify.........: No.MOD-870085 08/07/08 By claire 代採流程有最終供應商時,建議應以最後一站的供應商資料做開窗及判別資料的合理性
# Modify.........: No.MOD-870113 08/07/11 By claire 委外採購單於單身進入時會先做取價(稅別為含稅時),此時輸入含稅單價後不應再重計含稅金額應以原default值或輸入值為主
# Modify.........: No.MOD-870161 08/07/14 By zhaijie 其他資料頁簽中的"運送方式"欄位應開窗選擇
# Modify.........: No.MOD-870268 08/07/23 By Smapmin 更改完計價單位後,單價並未更新
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.TQC-870047 08/07/30 By chenyu 修改單頭稅別時，單身和單頭的金額沒有考慮單價含稅這個欄位
# Modify.........: No.FUN-870117 08/08/21 by ve007  服飾版自動帶出制單號
# Modify.........: No.MOD-880090 08/08/12 By claire 單頭未稅,單身取不到單價時, 以人工輸入未稅單價, 含稅單價不會重推
# Modify.........: No.MOD-890023 08/09/04 By chenyu ICD功能修改
# Modify.........: No.FUN-870124 08/09/17 By jan 服飾版修改
# Modify.........: No.MOD-890159 08/09/17 By chenyu ICD功能修改
# Modify.........: No.MOD-890109 08/09/19 By Smapmin 當單價為0重新default單價時,開窗詢問是否重新default
# Modify.........: No.MOD-890239 08/09/24 By chenyu 修改MOD-890159，在update之前加一個判斷
# Modify.........: No.MOD-890229 08/09/25 By Smapmin pmm03 noentry的控管移至畫面檔
# Modify.........: No.CHI-890026 08/10/06 By Smapmin 依照稅別含稅否重新計算含稅/未稅金額
# Modify.........: No.MOD-8A0048 08/10/06 By chenl   單身更新后應對單身資料進行重新抓取，以保証單身資料顯示正確。
# Modify.........: No.CHI-8A0022 08/10/20 By Smapmin 取單價時,考慮是否走製程/委外
# Modify.........: No.MOD-8A0098 08/10/21 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.MOD-8A0239 08/10/28 By chenyu 工單發料后，委外采購應該還是可以錄入
# Modify.........: No.MOD-8A0279 08/11/13 By chenyu 新增采購單時，單價直接帶出
# Modify.........: No.CHI-8B0018 08/11/13 By xiaofeizhu 判斷pmx_file時，要先判斷pmx10,pmx11值
# Modify.........: No.MOD-8B0188 08/11/24 By chenyu s_chkoga()里面，不可以直接拿pmm01當作訂單號
# Modify.........: No.MOD-8B0273 08/12/01 By chenyu 采購單頭單價含稅時，未稅單價=未稅金額/計價數量
# Modify.........: No.MOD-8C0140 08/12/15 By Smapmin 作廢/取消作廢時針對請購單的處理,要限制資料來源為1.自行輸入或2.請購單轉入.
# Modify.........: No.MOD-8C0159 08/12/16 By chenyu 其他資料維護，點退出時，不走update那一段
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-8C0298 08/12/31 By chenyu 單身"含稅單價"不能為空
# Modify.........: No.TQC-910003 09/01/03 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.FUN-910005 09/01/05 BY DUKE ADD 串接 apsi317時,新增 vmz_file.vmz25 = 0
# Modify.........: No.MOD-910096 09/01/09 By Smapmin 查詢與維護料件廠商基本資料時,要區分是否委外
# Modify.........: No.MOD-910097 09/01/09 By Smapmin 委外採購單新增時,單頭pmm45預設為N
# Modify.........: No.MOD-910188 09/01/16 By Smapmin 收貨部門開窗後,部門中文說明放錯欄位
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-920037 09/02/09 By jan 修改pmniicd12欄位開窗 
# Modify.........: No.FUN-920073 09/02/10 By jan aict040 若所輸入的 pmn68+pmn69 存在於收貨單 之單號+項次  則不可輸入
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程 
# Modify.........: No.CHI-8C0047 09/02/12 by ve007 單頭匯率異動時，開窗詢問是否更新本幣單價，如是則自動更新
# Modify.........: No.MOD-920290 09/02/23 By chenyu 訂單轉入的采購單，在ON ROW CHANGE中不需要檢查pmn07和pmn20
# Modify.........: No.FUN-920175 09/02/24 By kim 取消確認/作廢段程式拆解到_sub.4gl中，以便後續程序呼叫
# Modify.........: No.FUN-920190 09/02/26 By kim 將單頭刪除段移到_sub.4gl中，以便後續程序呼叫
# Modify.........: No.MOD-930045 09/03/05 By shiwuying t540_pmm21()增加傳一參數
# Modify.........: No.CHI-930003 09/03/06 By jan 動態隱部分ICD欄位
# Modify.........: No.FUN-930145 09/03/18 By destiny pmn98增加管控
# Modify.........: No.FUN-920183 09/03/24 By shiwuying MRP功能改善
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-930113 09/03/30 By mike 將oah-->pnz
# Modify.........: No.TQC-940006 09/04/01 By chenyu 使用參考單位并使用blanked po的時候，單價取不到,將t_pmn31,t_pmn31t定義成全局變量
# Modify.........: No.MOD-940064 09/04/14 By Smapmin 到庫日不可小於到廠日/交貨日
# Modify.........: No.MOD-940278 09/04/21 By Smapmin mfg3390的錯誤訊息應只針對一對一的委外工單做判斷
# Modify.........: No.TQC-940132 09/04/22 By Smapmin 採購單稅別為含稅,於輸入含稅單價時,若單價超過最近採購單價時,訊(apm-240)息會一直卡住且無法離開.
# Modify.........: No.TQC-950002 09/05/04 By chenyu b_ima918應該為b_ima921
# Modify.........: No.FUN-940083 09/05/06 By zhaijie新增VIM管理否欄位判斷 
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.MOD-950116 09/05/14 By Smapmin 刪除採購單單身時,回寫請購單單身已轉採購量時會出錯
# Modify.........: No.TQC-950010 09/05/07 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.MOD-950102 09/05/14 By Dido 若有設定最終供應商需檢核流程設定是否有 99 站別
# Modify.........: No.FUN-950026 09/05/15 by ve007 add pmniicd13
# Modify.........: No.MOD-950172 09/05/27 By Smapmin 輸入單位一之前重新抓取正確的採購單位(ima44)
# Modify.........: No.MOD-950284 09/06/03 By Smapmin 使用利潤中心功能又做預算控管時,會一直卡在會計科目的欄位
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.TQC-910033 09/06/08 By chenmoyan t540sub_pmh中增加一個參數
# Modify.........: No.TQC-960196 09/06/29 By lilingyu "運送方式"欄位更改為開窗欄位,可從aooi160中自行挑選資料
# Modify.........: No.MOD-960190 09/06/30 By mike 訂單單身的ima021欄位是不允許下查詢的,故將采購單改的跟訂單一致,不允許采購單單身針對
# Modify.........: No.MOD-970018 09/07/02 By lilingyu 當apmt540從請購單轉采購單的時候,修改了pmn34之后不會重新推算pmn35，導致pmn35的值出錯
# Modify.........: No.MOD-960186 09/07/08 By Smapmin 使用多單位且料件為單一單位時,單位一的轉換率有錯誤
# Modify.........: No.FUN-950088 09/06/29 By hongmei 單身增加pmn123,mse02欄位
# Modify.........: No.TQC-950054 09/07/10 By jan updat行業別檔時，KEY值一并update
# Modify.........: No.FUN-940138 09/07/10 By jan mark掉FUN-920073的內容
# Modify.........: No.FUN-960130 09/07/21 By sunyanchun 增加流通零售功能
# Modify.........: No.MOD-970202 09/07/22 By mike 將g_no的地方改由g_pmn[l_ac].pmn04[1,4]取代. 
# Modify.........: No.FUN-950056 09/07/27 By chenmoyan 去掉ima920
# Modify.........: No.TQC-980091 09/08/12 By sherry 單身凍結碼default 'N'    
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.TQC-980279 09/08/28 By sherry 請購的料號若為統購的，不可以拋采購單      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980038 09/09/10 By chenmoyan pmm02的值由smy72代出
# Modify.........: No.MOD-990178 09/09/21 By Dido 增加跨營運中心函數 
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960033 09/08/03 By chenmoyan 加pmh22為條件者，再加pm23
# Modify.........: No.TQC-990097 09/10/14 By lilingyu FUNCTION t540_chk_pv()函數段選擇azp03,出現語法錯誤
# Modify.........: No.MOD-9A0041 09/10/15 By Smapmin MISC輸入單位時,也要判斷單位是否存在
# Modify.........: No.           09/10/20 By lilingyu 部分sql改成標準寫法
# Modify.........: No.FUN-9A0068 09/10/28 By douzh VMI测试结果反馈及相关调整
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No:MOD-9B0042 09/11/06 By Smapmin 作廢/取消作廢還要重算pmm44/pmm44t
# Modify.........: No:MOD-9B0116 09/11/18 By Dido 以核價檔取價,且使用分量計價的方式,修改數量後單價要重取
# Modify.........: No:TQC-9B0104 09/11/19 By Carrier CONSTRUCT时加入oriu/orig
# Modify.........: No:FUN-9B0116 09/11/20 By cockroach ADD pmn72~pmn77
# Modify.........: No:FUN-9B0127 09/11/24 By cockroach 查詢不能查單身
# Modify.........: No:MOD-9B0154 09/11/24 By Smapmin 單頭登打廠商時,若單身有blanket po,則要檢核廠商是否相同
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:MOD-9C0016 09/12/03 By mike 原有的零售管控非成本仓拿掉
# Modify.........: No:TQC-9B0191 09/12/03 By jan 修改aict040 異動單號開窗
# Modify.........: No:FUN-9C0046 09/12/09 By chenls (1)單頭資料來源添加item：8 電子採購
#                                                   (2)添加單身時判斷電子採購是否已拋轉
#                                                   (3)刪除單身前判斷是否為電子採購單
#                                                   (4)刪除資料時判斷是否有電子採購單
# Modify.........: No:TQC-9C0075 09/12/11 by sherry 做跨資料庫處理時，傳入的dbs參數改為傳plant
# Modify.........: No:CHI-9C0002 09/12/15 By Smapmin special_description加入權限控管
# Modify.........: No:FUN-9C0083 09/12/17 By mike 还原MOD-9B0116
# Modify.........: No:FUN-9C0075 09/12/17 By cockroach pmn73默認值改為4
# Modify.........: No:TQC-9C0108 09/12/17 By lilingyu 點擊發出還原按鈕,無任何提示
# Modify.........: No:MOD-9C0207 09/12/19 By Carrier 若与采购勾稽时,若采购料件与请购不符,则不过
# Modify.........: No:MOD-9C0285 09/12/21 By Cockroach 檢查價格以決定欄位是否可以錄入
# Modify.........: No:CHI-9C0025 09/12/25 By jan 單身新增pmn52/pmn54/pmn56
# Modify.........: No:MOD-9C0401 09/12/25 By sabrina 在_a()給完pmm04後，就先CALL s_get_bookno() 
# Modify.........: No.TQC-970328 09/12/29 By baofei s_chkoga() oga99 -->oea99 
# Modify.........: No:MOD-9C0159 10/01/08 By Smapmin 取出單價不應被update
# Modify.........: No.FUN-A10034 10/01/09 By chenmoyan 改電子采購BUG
# Modify.........: No:FUN-A10001 10/01/09 by dxfwo  VMI bug 重查後還是為"Y"
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No:CHI-9A0018 10/01/28 By shiwuying 單頭來源為"5.工單轉入"時，單身"請購單號"欄位的title需變成"工單單號"
# Modify.........: No:CHI-9C0023 10/02/05 By Smapmin 單身增加到庫日欄位,日期的檢核移到推算完相關日期之後
# Modify.........: No:TQC-A30047 10/03/10 By Carrier 单身无资料时,不需要弹出报表打印的选项
# Modify.........: No:TQC-A30054 10/03/10 By lilingyu "采購單性質"選擇"2.TRI:多角貿易"時,增加一個提示訊息
# Modify.........: No:MOD-A30089 10/03/15 By Smapmin 修改單身單價取位
# Modify.........: No:FUN-A30030 10/03/22 By Cockroach 添加pos相關管控
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:CHI-A50014 10/05/18 By Summer 替代量輸入負值,數量需加回原替代的料號 
# Modify.........: No.FUN-A50054 FUN-A60035 10/05/31 By chenmoyan 增加服饰版二维功能 
# Modify.........: No:CHI-A40021 10/06/04 By Summer 用agli102科目是否有做專案控管的參數,
#                                                   做為抓取預算資料時是否要以專案為條件
# Modify.........: No:FUN-A60011 10/06/07 By Carrier 平行工艺,单身增加pmn012 工艺序
# Modify.........: No:FUN-A60027 10/06/12 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:TQC-A60113 10/06/24 by yinhy 單身新增時的存檔前判斷，判斷 IF cl_null(pmn012) THEN pmn012=一個空格
# Modify.........: No.FUN-A60076 10/06/30 By vealxu 製造功能優化-平行制程
# Modify.........: No.FUN-A60035 10/07/06 By chenls 服飾狀態下單身顯示問題
# Modify.........: No.FUN-A60035 10/07/08 By chenmoyan 服飾版母料號才需走款式明細流程
# Modify.........: No.FUN-A50102 10/07/23 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A70114 10/07/23 By houlia 更改會計科目賦值g_pmn[l_ac].pmn40/g_pmn[l_ac].pmn401
# Modify.........: No:MOD-A70148 10/07/23 By Smapmin 修改交貨/到廠/到庫日期合理性判斷後停留的位置
# Modify.........: No.FUN-A60035 10/07/27 By chenls 服飾版二維功能mark
# Modify.........: No:MOD-A60003 10/07/30 By Smapmin 單身其他資料Action中的會計科目要能立即顯示最新資料
# Modify.........: No:MOD-A50210 10/07/30 By Smapmin 將t540_upd_oeb28()移到sub裡去寫
# Modify.........: No.FUN-A80001 10/08/02 By destiny 增加截止日期判断逻辑
# Modify.........: No.TQC-A80009 10/08/02 By houlia 有默認pmn930時死循環，增加控管
# Modify.........: No:MOD-A80075 10/08/13 By Smapmin 還原MOD-740282的修改
# Modify.........: No:MOD-A80011 10/08/13 By Smapmin 只要料號有修改過,一律重取單價
# Modify.........: No:TQC-A80070 10/08/20 By yinhy 採購單中的單身請購單項次更改時，請購單中的採購量未更新 
# Modify.........: No.FUN-A80121 10/08/24 By shenyang  單身選擇料件可以多選，多選后自動生成多筆單身資料
# Modify.........: No.FUN-A80087 10/08/31 By Lilan EF簽核時指定g_action_choice="efconfirm"
# Modify.........: No.FUN-A90009 10/09/07 By destiny b2b 
# Modify.........: No.FUN-A80150 10/09/08 By sabrina 單身新增"號機批號"(pmn919)欄位
# Modify.........: No:MOD-A10174 10/09/29 By sabrina N p540_pmn40()將SUM(pmn20*pmn31)/(pmn20*pmn31t)改為SUM(pmn88)/(pmn88t)
# Modify.........: No.FUN-A80121 10/10/20 By chenying add t540_chk_multi_ima01()
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu 全系統增加料件管控 
# Modify.........: No.TQC-AB0044 10/11/16 By houlia 拿掉帶出默認倉庫判斷 
# Modify.........: No:CHI-AA0025 10/11/23 By Summer 1.若是由訂單轉入,pmn20仍需開放可以修改
#                                                   2.利用t540_upd_oeb28()回寫已轉採購量
#                                                   3.採購量不可大於原訂單單身的數量
# Modify.........: No:MOD-AB0207 10/11/23 By Smapmin 若有打請購單時,MISC料的品名應由請購單帶出
# Modify.........: No:TQC-AB0081 10/11/28 By lixh1 修改CONSTRUCT欄位順序和欄位開窗
# Modify.........: No:MOD-AB0258 10/12/01 By Smapmin 單身登打請購單預設多單位的數量時,未扣除已拋轉的請購單數量
# Modify.........: No:TQC-AC0257 10/12/17 By shiwuying Mark s_defprice_A6段取價邏輯
# Modify.........: No:TQC-AC0283 10/12/18 By lixh1   修改查詢時無法QBE單身BUG  
# Modify.........: No.TQC-AC0297 10/12/18 By vealxu 當不走平行工藝時，製程段和製程段說明沒隱藏
# Modify.........: No:MOD-AC0145 10/12/21 By Smapmin 手動新增單身時,pmn123的值沒有帶出
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-A50190 10/12/24 By Summer 修正MOD-890023
# Modify.........: No:TQC-AC0374 10/12/28 By jan 重撈製程料號
# Modify.........: No:TQC-AC0371 10/12/30 By huangrh 採購營運中心沒資料,但對應的名稱有顯示,如果沒有採購策略，默認為'1'經銷
# Modify.........: No:MOD-AC0425 11/01/04 By lixh1   AFTER FIELD pmn07時,判斷資料來源為"請購單轉入",才抓取請購單資料及做相關判斷 
# Modify.........: No:CHI-AB0006 11/01/06 By Smapmin MISC料件開窗輸入會科時,default料件基本檔的會科
# Modify.........: No:MOD-B10043 11/01/07 By Summer s_defprice()這個FUNCTON跑完後,有錯誤就會顯示錯誤訊息後要停留的不能寫死pmn86
# Modify.........: No:MOD-B10138 11/01/20 By Summer 調整取位方式
# Modify.........: No:FUN-B10052 11/01/26 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B10056 11/02/12 By vealxu 修改制程段號的管控
# Modify.........: No:FUN-A60055 11/03/01 By Lilan EF(EasyFlow)簽核時不可執行的功能
# Modify.........: No:TQC-B30020 11/03/08 By destiny 修改完modu的值没有及时显示         
# Modify.........: No.TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No.MOD-B30191 11/03/12 By wuxj 采购单单身采购数量变动时回写请购单
# Modify.........: No:MOD-B30280 11/03/12 By Summer 只要重新取價會變更到pmn31,pmn31t的地方,都要同步更新pmn44 
# Modify.........: No.MOD-B30347 11/03/14 By lixia 修改採購日期時增加失效日期判斷
# Modify.........: No:MOD-B30413 11/03/16 By Summer 追CHI-A40019單,更改單頭幣別/稅別時,重新預設採購單價
# Modify.........: No:MOD-B30618 11/03/21 By Summer 修改列印時外部參數傳遞  
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B30717 11/04/06 By Summer 發出還原時重新抓取多角貿易拋轉pmm905
# Modify.........: No:MOD-B40022 11/04/06 By Summer CALL t540_upd_oeb28(),應加上判斷是否為訂單轉入
# Modify.........: No:MOD-B40122 11/04/14 By lilingyu 當不使用請購單參數時(sma31='N'),錄入採購單單身時報錯:更新到請購單失敗
# Modify.........: No:MOD-B40127 11/04/18 By Summer 委外入庫時才會做發料套數的控管,故採購單發出還原不需做此控卡,將MOD-640233還原
# Modify.........: No:TQC-B40178 11/04/21 By lilingyu 直接新增採購單資料,輸入完單身資料後,系統報錯"更新到請購單單身失敗"
# Modify.........: No:TQC-B10162 11/04/22 By lilingyu 採購參數sma45='N',由請購單拋磚至採購單,然後仍然可以更改單身
# Modify.........: No:TQC-B40210 11/04/25 By lilingyu EF簽核相關問題修改 
# Modify.........: No:FUN-B40098 11/04/28 By shiwuying 扣率代銷時，倉庫只能選非成本倉
# Modify.........: No:TQC-B40226 11/05/03 By lilingyu 單身未稅、含稅單價欄位輸入控管
# Modify.........: No:TQC-B50018 11/05/05 By lilingyu 未稅、含稅單價欄位不需區分Pnz04
# Modify.........: No:MOD-B50145 11/05/17 By lilingyu PR、PO預算管控
# Modify.........: No:TQC-B50094 11/05/18 By wujie    通过预算项目带出预设科目改为从aglt600抓科目
# Modify.........: No:FUN-B50046 11/05/24 By abby APS GP5.25追版問題調整
# Modify.........: No:MOD-B50194 11/05/30 By Summer 委外採購單在輸入完工單後，預計完工日要default給到庫日,到廠與交貨日用推算的
# Modify.........: No:CHI-AC0016 11/05/30 By Smapmin 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60029 11/06/08 By lixia 修改採購數量時重新獲取單價
# Modify.........: No:MOD-B50254 11/06/10 By Summer 採購取替代,Insert/Update未考量計價數量的部份
# Modify.........: No:MOD-B60114 11/06/14 By zm 修正TQC-B50018 BUG
# Modify.........: No:MOD-B60119 11/06/14 By JoHung 刪除單身時一併刪除對應項次的特別說明
#                                                   修改單身項次時一併修改對應的特別說明項次
# Modify.........: No.FUN-B60074 11/06/15 By xianghui 去掉加工列印封裝，並將點擊委外加工單功能時直接印出數據不需跳出窗口
# Modify.........: No.FUN-B50150 11/06/20 By guoch 採購單取到了單價是否可以修改
# Modify.........: No.TQC-B60235 11/06/21 By guoch 對部門編號不能修改的BUG進行處理
# Modify.........: No.TQC-B60212 11/06/21 BY xjll 修改程式中兩次出現'apm-339' 提示
# Modify.........: No.TQC-B60300 11/06/23 By guoch mark FUN-B50150
# Modify.........: No.FUN-B60150 11/07/06 By baogc 成本代銷中若sma146=1入成本倉，若sma146=2入非成本倉
# Modify.........: No.CHI-B70015 11/07/11 By jason 因為WAFER採購單的Blanket PO並非來自無交期採購單(pon_file)，WAFER採購單不應該做這項檢查
# Modify.........: No.CHI-B70017 11/07/12 By jason t540_pmn04_chk 這道檢查，當ICD行業時不要做
# Modify.........: No.CHI-B70016 11/07/13 By xianghui 程式處理單身新增多筆資料時，一並處理行業別table
# Modify.........: No:MOD-B60102 11/07/20 By JoHung 判斷單頭的資料來源如果是人工輸入/請購單轉入才去做請採勾稽
# Modify.........: No:MOD-B70246 11/07/29 By JoHung pmn07判斷新舊值增加判斷舊值為NULL
# Modify.........: No:TQC-B80051 11/08/04 By lixia 修改成本中心管控時機
# Modify.........: No:TQC-B80060 11/08/04 By lixia 委外採購單時根據參數管控pmn43,pmn431是否顯示
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:MOD-B80112 11/08/18 By Vampire 選取Code release類採購單，單身選取要銷的BankPO的時候，會出現錯誤訊息無法繼續輸入
# Modify.........: No:MOD-B80332 11/09/03 By johung apmi110設定未取到價格人工輸入
#                                                   修正單身維護單價後，重新進入單身時無法再維護欄位問題
# Modify.........: No:TQC-B90049 11/09/06 By lilingyu 委外工單審核後生成的委外採購單:進入單身，光標移至製程段號欄位，系統出現報錯提示無法退出，但是委外工單是不走工藝的
# Modify.........: No:CHI-B80082 11/09/08 By johung 將apm-281控卡改為判斷是否存在pmh_file，存在才允許修改
# Modify.........: No:MOD-B90089 11/09/13 By suncx 請購轉採購，更改採購單身請購單項次後，原請購項次的請購單身的狀況碼未更新回已核准
# Modify.........: No:MOD-B90117 11/09/15 By suncx 到廠日期和入庫日期計算錯誤
# Modify.........: No:TQC-B90163 11/09/22 By suncx MOD-B90117BUG修正
# Modify.........: No:MOD-B90126 11/09/26 By Vampire 當沒做預算控管時，AFTER FIELD專案代號時，會進NEXT FIELD部門代號，造成無窮迴圈。
# Modify.........: No.FUN-B80093 11/10/06 By pauline 控管VIM相關欄位	
# Modify.........: No:MOD-BA0028 11/10/11 By Smapmin 已有預付帳款不可發出還原
# Modify.........: No:FUN-B90103 11/10/18 By xjll    增加服飾二維 
# Modify.........: No:TQC-C10021 12/01/05 By suncx 修正CHI-B80082的卡控時機
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0086 12/01/30 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-B90109 12/02/01 By Vampire 加上本製程編號的條件(AND pmn43=g_pmn[l_ac].pmn43) 否則同工單不同製程序的數量會累家在一起
# Modify.........: No:MOD-BA0143 12/02/01 By Vampire 加上料件不為MISC的控卡 
# Modify.........: No:TQC-BC0121 11/12/31 By destiny 取替代后保税资料没有更新
# Modify.........: No:FUN-C20006 12/02/03 By xjll    服飾行業區分業態(g_azw.azw04='2')
# Modify.........: No:FUN-C20026 12/02/08 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-BC0168 12/02/08 By Summer 調整回寫請購單狀況碼問題 
# Modify.........: No:MOD-BC0303 12/02/09 By Vampire 控卡非VMI廠商不可勾選VMI採購
# Modify.........: No:TQC-B90215 12/02/13 By destiny 变更采购单日期后应提示是否需要变更汇率
# Modify.........: No:TQC-BB0165 12/02/13 By destiny 廠牌欄位修改為空後，未將廠牌名稱欄位清空
# Modify.........: No:TQC-BB0171 12/02/13 By destiny 通过供应商按钮更改厂商资料后要重新刷新一遍
# Modify.........: No:TQC-BC0212 12/02/13 By Carrier 取替代判断错误
# Modify.........: No:FUN-C10002 12/02/14 By bart 作業編號pmn78帶預設值
# Modify.........: No:MOD-BC0046 12/02/15 By suncx 當修改單身料號時pmn09需要重新賦值
# Modify.........: No:TQC-C10067 12/02/15 By suncx 單身取價錯誤
# Modify.........: No:TQC-C10061 12/02/15 By suncx pmm02='SUB'時，更改供應商也需要做控卡
# Modify.........: No:TQC-C10068 12/02/15 By suncx apmt590單身錄入工單後，帶出資料BUG處理
# Modify.........: No:TQC-C10071 12/02/15 By suncx 委外採購時，料件開窗根據工單開窗
# Modify.........: No:MOD-BA0002 12/02/15 By Summer 料號舊值為空或是料號有做修改時才要重帶品名規格 
# Modify.........: No:MOD-BA0025 12/02/15 By Summer 變更供應商,再變更稅別回原供應商稅別時,稅率沒有變 
# Modify.........: No:MOD-BA0026 12/02/15 By Summer 新增採購單時，輸入請購單項次後，一併帶出廠牌及名稱 
# Modify.........: No:MOD-BA0075 12/02/15 By Summer 採購單的倉儲批不應該控卡,請取消pmn52/pmn56必填的控卡 
# Modify.........: No:TQC-C10119 12/02/16 By suncx 複製時一併複製單身工單
# Modify.........: No:TQC-C10116 12/02/16 By suncx 單身做數量檢查時，排除pmn16='8'的
# Modify.........: No:TQC-C10102 12/02/16 By SunLM 當為重工委外時候,單價可以為零
# Modify.........: No:TQC-BB0166 12/02/16 By SunLM 自動帶出廠牌資料,modify MOD-BA0026
# Modify.........: No:TQC-BC0027 12/02/16 By SunLM 當採購單由工單轉來時,會判斷是否存在此工單
# Modify.........: No:TQC-C20013 12/02/16/By suncx 修改供應商時需做供應商的管控，修改完供應商需要重新取價
# Modify.........: No:TQC-C20232 12/02/16 By xjll    非多屬性料件修改倉儲批時沒有更新到pmn_file
# Modify.........: No:TQC-C20348 12/02/22 By lixiang  服飾流通業商品策略，採購策略的修改
# Modify.........: No:TQC-C20411 12/02/23 By lixiang 服飾中詳細資料即使顯示	
# Modify.........: No:TQC-C20455 12/02/24 By lixiang FUN-C10002增加了欄位，服飾中進行同步增加
# Modify.........: No:TQC-C20500 12/02/27 By xjll    請購轉採購舊值備份
# Modify.........: No:TQC-C20417 12/02/28 By SunLM 一般工藝工單,但是其中的某道工藝進行委外,過工單欄位報錯
# Modify.........: No:MOD-BC0275 12/02/28 By Elise 取消pmn52控卡
# Modify.........: No:MOD-C10015 12/02/29 By Elise 拿掉 驗收單列印(pmm30) 欄位
# Modify.........: No:TQC-C30114 12/03/07 By huangrh 服飾流通的採購策略中配置子料件資料
# Modify.........: No:TQC-C30109 12/03/07 By bart 1.apm-815要判斷非aict040.4gl才卡
#                                                 2.排除輸入單位時就會卡數量 
# Modify.........: No:MOD-C10092 12/03/09 By jt_chen 調整apmt590,單頭來源為5:工單轉入時,單身會有兩個工單單號的問題
# Modify.........: No:MOD-C30187 12/03/10 By lixiang 修改服飾零售業態下畫面檔欄位的控管
# Modify.........: No:MOD-C30217 12/03/10 By xjll    服飾業bug 修改
# Modify.........: No:FUN-C30087 12/03/14 By bart 當g_prog不為apmt590_icd時,不需進入MENU,直接給l_prog的值就好
# Modify.........: No:MOD-C30578 12/03/15 By dongsz 單身要抓取vmi管理相關資料時，先判斷sma93='Y'才抓取
# Modify.........: No:FUN-C30140 12/03/16 By Mandy 送簽中,應不可執行以下ACTION"供應商資料"
# Modify.........: No:MOD-C30366 12/03/16 By yuhuabao 如果替代碼為's'替代的時候，採購量的控管應先進行轉換
# Modify.........: No:MOD-C30445 12/03/16 By yuhuabao 計價單位會變成計價數量
# Modify.........: No:FUN-C30211 12/03/20 By bart 請購單在bank po時,wafer star / code release不用再開請購,串沖bank po
# Modify.........: No:TQC-C30164 12/03/23 By SunLM 修正複製採購單據時候,匯率不能取到最新值
# Modify.........: No:FUN-C30289 12/04/03 By bart 所有程式的Multi Die隱藏
# Modify.........: No:TQC-C30225 12/04/06 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No:TQC-C40032 12/04/06 By zhuhao 錯誤信息修改
# Modify.........: No:FUN-C30130 12/04/12 By lixiang 服飾母單身增加pmnslk68,pmnslk69
# Modify.........: No:FUN-C30300 12/04/19 By bart 倉儲批開窗需顯示參考單位數量
# Modify.........: No:TQC-C40149 12/04/19 By lixiang 服飾母單身單價欄位的控管
# Modify.........: No:TQC-C40248 12/04/28 By lixiang 服飾母單身請購單號和項次的檢查
# Modify.........: No:TQC-C30063 12/05/09 By Vampire t540_b_fill接參數用p_wc2,但where條件還是用g_wc2
# Modify.........: No:TQC-C40237 12/05/10 By SunLM 新增單身時候替代碼賦初值錯誤問題
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:MOD-C50063 12/05/14 By Elise pmn08不在array內,不會有值,後續多角拋轉時會因無法做單位換算出錯
# Modify.........: No:FUN-C50051 12/05/14 By lixiang 母單身料件和供應廠商關系依照料件來控管，判斷ima915
# Modify.........: No:MOD-C40110 12/05/15 By Elise 修改價格條件pmm41時詢問是否重新取價
# Modify.........: No:MOD-C40129 12/04/18 By Elise 程式中列印output功能沒有權限控管應該加上
# Modify.........: No:FUN-C50074 12/05/18 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3525->axm-627
# Modify.........: No:MOD-C50144 12/05/21 By SunLM 當採購單是工單轉入時,單身不能修改的問題
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C50087 12/05/28 By Vampire 發出還原時判斷是否已存在預購申請作業(aapt710),若有則不允許發出還原
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:MOD-BB0264 12/06/06 By Vampire 回寫Blanket已轉數量未轉換單位
# Modify.........: No:MOD-C30797 12/06/11 By Vampire (1) CALL q_pom2,增加傳參數判斷稅別
#                                                    (2) AFTER FIELD pmn68 ,增加控卡幣別、稅別
# Modify.........: No:MOD-C30823 12/06/11 By Vampire 透過單身去補上請購單號項次的,採購單不會回寫請購單狀況碼、轉採購量,但採購變更單會回寫轉採購量
# Modify.........: No:MOD-C30865 12/06/11 By Vampire 先SELECT * INTO g_pmn2.*後,再SELECT 個別欄位 INTO 對應的欄位
# Modify.........: No:TQC-C60164 12/06/19 By zhuhao 修改TQC-BC0027錯誤
# Modify.........: No:TQC-C60182 12/06/26 By bart Blanket PO單號項次錯誤時跳回Blanket PO單號
# Modify.........: No:FUN-C60088 12/06/26 By qiaozy 如果請購中的到庫交貨等日期小於採購日期則賦值為採購日期
# Modify.........: No:FUN-C60100 12/06/26 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No.MOD-C50245 12/07/03 By Vampire CALL s_defprice重新取價時,取出單價(pmn90)也要一併重帶
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No:MOD-C70081 12/07/06 By Elise 檢查工單生產數量，應排除作廢及結案狀態(6,7,8)
# Modify.........: No:TQC-C70068 12/07/11 By zhuhao 增加判斷t540_sign()進入條件
# Modify.........: No.MOD-C60035 12/07/16 By SunLM 判斷若g_pmn2.pmn08為空,對其賦初值
# Modify.........: No:MOD-C60179 12/07/17 By SunLM 單價action，本幣單價和標準單價欄位關閉不可修改
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C70256 12/08/15 By Vampire (1) 使用參考單位時無CALL s_umfchk換算數量
#                                                    (2) 修正MOD-AC0425，增加人工輸入時，也需要重新計算
# Modify.........: No:MOD-C80061 12/08/15 By Vampire (1) 確認時afa-978的控卡請排除替代碼為【2:主料, 有副料可替代】
#                                                    (2) AFTER FIELD pmn20 替代碼為【2:主料, 有副料可替代】不控卡 mfg3331
# Modify.........: No:TQC-C80166 12/08/28 By dongsz 單別只做預設，不要關閉採購單性質欄位且不要清空
# Modify.........: No:MOD-C80239 12/09/26 By Elise 新增修改時確認人no entry
# Modify.........: No:MOD-C80237 12/09/26 By Elise update時，重新給予替代料號資料
# Modify.........: No:MOD-C90211 12/09/28 By Vampire 當單頭輸入專案號碼後，進入單身時，無法用單身陣列判斷，改透過全域變數傳入料號判斷
# Modify.........: No:MOD-CA0024 12/10/15 By Vampire 單頭有輸入專案號碼,進單身可選人工輸入或依專案產生單身,選專案產生單身時判斷pmn88,pmn88t為null時重新計算
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No.CHI-CB0008 12/11/05 By Lori 1.單頭的稅「率」改變，不詢問直接自動更新單身。
#                                                 2.單頭的「稅率」不變，但「是否含稅」改變，才需要顯示詢問視窗。
#                                                 3.單身若進入單價後，單價無任何異動時，亦不能更新後面的金額。
# Modify.........: No:FUN-CB0014 12/11/14 By lixh1 增加資料清單
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-C30125 12/12/24 By Lori 詢價單號增加開窗功能
# Modify.........: No:MOD-CC0129 13/01/22 By Carrier 1.点多角贸易的按钮报6372的错误 2.INSERT poz_file报-391的错误
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.FUN-C30075 13/01/29 By Sakura 料號為特性主料(ima928='Y')時需判斷存在替代料資料(apmi303)
# Modify.........: No.FUN-D10112 13/01/31 By SunLM 單身show出pmn88和pmn88t
# Modify.........: No:MOD-CB0186 13/02/01 By jt_chen 取不到價,單價不應為舊值
# Modify.........: No.MOD-D10202 13/02/01 By jt_chen 調整pmn43,pmn431,pmn012的預設值給值不須包在pmn65='1'的判斷裡
# Modify.........: No:MOD-CA0165 13/02/01 By jt_chen 調整新舊值判斷,原本重算計價數量是用_t改用_o判斷
# Modify.........: No:MOD-CC0023 13/02/04 By jt_chen 續MOD-CB0186,取不到價,單價不為舊值
# Modify.........: No:MOD-D10041 13/02/04 By Elise 若為委外採購，縱使sma45設為n，仍允許新增委外採購單
# Modify.........: No:MOD-D10091 13/02/04 By Elise 在 t561() 抓完值後，也要給 g_pmn[l_ac].pmn40 預設值
# Modify.........: No.FUN-D10118 13/02/21 By SunLM 採購單別smy81='N',则可以请购单号/项次可以为空
# Modify.........: No.FUN-D20025 13/02/21 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D10214 13/02/26 By Elise 調整錯誤訊息
# Modify.........: No.FUN-D10128 13/02/26 By SunLM 若為農業發票(gec05='A')時,未稅單價邏輯調整
# Modify.........: No:MOD-CA0164 13/03/04 By Elise 調整複製時pmn24,pmn25給null
# Modify.........: No.TQC-D20066 13/03/04 By SunLM 因規划有變，暫時還原FUN-D10118的所以調整。
# Modify.........: No.MOD-D20145 13/03/08 By Elise pmn36,pmn37給值處如果為pmn33,pmn34,調整為給null
# Modify.........: No:MOD-D10103 13/03/12 By jt_chen (1) 調整跳出訊提的處理,不能一直彈出訊息無法離開
#                                                    (2) 訊息提示:採購單價格條件設定不能人工輸入,且採購參數設定採購單價不可為零,請調整價格條件或核定取價
#                                                    (3) 採購參數採購單價不可為零的控卡不分一般採購、委外採購,皆須依參數設定
# Modify.........: No.MOD-D20098 13/03/12 By jt_chen ecm52 = 'N'(外包)也可以轉委外工單
# Modify.........: No:FUN-D30030 13/03/20 By Nina 修正參數aoos010的是否與M-Barcode整合設定為'N'時有顯示'條碼相關'的功能
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-CA0007、DEV-CB0016、DEV-CB0022、DEV-CC0001、DEV-D10004、DEV-D20002、DEV-CB0002以上為GP5.25 的單號
# Modify.........: No.MOD-D30183 13/03/20 By Vampire 委外工單及重工委外工單沒有製成段號，TQC-B90049增加此控卡，應該將條件改為 AND
# Modify.........: No:CHI-C10037 13/03/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
# Modify.........: No:CHI-CC0033 13/03/27 By jt_chen 兩角修改
# Modify.........: No:FUN-D30087 13/03/27 By Elise 廠牌開窗判斷有做需要料件承認(ima926)的撈abmi310，若沒有的則撈amri504
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 1.調整確認自動產生barcode
#                                                    2.調整取消確認自動作廢barcode
# Modify.........: No.CHI-D30005 13/04/09 By Elise 串查apmi600第一個參數g_argv1為廠商代號,第二個g_argv2為執行功能
# Modify.........: No.FUN-D40042 13/04/12 By fengrui 採購單添加備註欄位pmn100
# Modify.........: No.DEV-D40015 13/04/17 By Nina  若有勾選M-barcode整合時且供應商有代印條碼，則需控卡單身料件的條碼產生時機點
#                                                  g_prog = 'apmt540'為'F；g_prog = 'apmt590'為'G'
# Modify.........: No:TQC-D40025 13/04/21 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40154 13/04/22 By Vampire  p540() 判斷執行的程式類型再賦予g_type預設值
# Modify.........: No:MOD-D50257 13/05/29 By SunLM 對g_action_flag賦初值。完善MOD-D10103 after field pmn31
# Modify.........: No:MOD-D60176 13/06/20 By SunLM 当g_smy.smy57[4,4]='Y',根據BLANKET PO单号项次帶出料號單位等基本資料
# Modify.........: No.FUN-D40103 13/05/08 By fengrui 抓ime_file資料添加imeacti='Y'條件
# Modify.........: No:TQC-D50071 13/07/15 By qirl 沒有使用電子採購系統的情況下，單身【電子採購序號】欄位不可見
# Modify.........: No:TQC-D50078 13/07/16 By lujh 有供應商管控時，直接帶出apmi254中的【幣種】
# Modify.........: NO.MOD-D90027 13/09/06 By SunLM 單價不含稅,在錄入單身的時候,幣別單價位數azi03為2,含稅金額顯示有誤
# Modify.........: NO.MOD-D90139 13/09/26 By SunLM 增加qbe條件查詢存儲按鈕
# Modify.........: NO.MOD-DA0177 13/10/28 By SunLM 不按順序輸入料號,請購單項次,單號,造成無法檢驗採購單和請購單數量勾稽判斷

DATABASE ds 
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt540.global"
GLOBALS "../../axm/4gl/s_slk.global"   #FUN-B90103--add
DEFINE  g_chr1         LIKE type_file.chr1     #TQC-9B0191
DEFINE  g_multi_ima01  STRING
DEFINE  g_wc3          STRING
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#DEFINE  g_index_pmn02 DYNAMIC ARRAY OF RECORD 
#        pmn02         LIKE pmn_file.pmn02
#        END RECORD
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
#FUN-B90103--start
#FUN-B90103--end 
#No.FUN-BB0086--add--begin--
DEFINE g_pmn07_t      LIKE pmn_file.pmn07 
DEFINE g_pmn80_t      LIKE pmn_file.pmn80   
DEFINE g_pmn83_t      LIKE pmn_file.pmn83   
DEFINE g_pmn86_t      LIKE pmn_file.pmn86   
#No.FUN-BB0086--add--end--
DEFINE g_pnz08  LIKE pnz_file.pnz08    #FUN-C50074
DEFINE g_pmn04  LIKE pmn_file.pmn04    #MOD-C90211 add TQC-D20066
DEFINE g_cmd    STRING                 #No:DEV-D30026--add

#FUN-CB0014 ------------Begin------------
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   g_action_flag  STRING
DEFINE   g_rec_b1       LIKE type_file.num10
DEFINE   l_ac1          LIKE type_file.num10
DEFINE   g_pmm_1        DYNAMIC ARRAY OF RECORD 
                           pmm01_1     LIKE pmm_file.pmm01,
                           pmm909_11   LIKE pmm_file.pmm09,
                           pmm04_1     LIKE pmm_file.pmm04,
                           pmm02_1     LIKE pmm_file.pmm02,
                           pmm09_1     LIKE pmm_file.pmm09,
                           pmc03_1     LIKE pmc_file.pmc03,
                           pmm18_1     LIKE pmm_file.pmm18,
                           pmm25_11    LIKE pmm_file.pmm25,
                           pmm20_1     LIKE pmm_file.pmm20,
                           pma02_1     LIKE pma_file.pma02,
                           pmm41_1     LIKE pmm_file.pmm41,
                           pnz02_1     LIKE pnz_file.pnz02,
                           pmm12_1     LIKE pmm_file.pmm12,
                           gen02_1     LIKE gen_file.gen02,
                           pmm13_1     LIKE pmm_file.pmm13,
                           gem02_1     LIKE gem_file.gem02,
                           pmmmksg_1   LIKE pmm_file.pmmmksg,
                           pmm905_1    LIKE pmm_file.pmm905 
                                       END RECORD 
#FUN-CB0014 ------------End--------------
DEFINE g_chkprice_flag LIKE type_file.chr1 #MOD-D10103 add
DEFINE   g_b_flag       LIKE type_file.chr1    #TQC-D40025

FUNCTION t540(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7,
              p_argv8,p_argv9,p_argv10,p_argv12)   #No.FUN-630010
   DEFINE p_argv1    LIKE pmm_file.pmm01,     #採購單號
          p_argv2    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1) #狀況碼
          p_argv3    LIKE pmm_file.pmm02,     #性質
          p_argv4    LIKE sfb_file.sfb01,     #工單單號
          p_argv5    LIKE sfb_file.sfb05,     #Parts no    #NO.FUN-9B0016
          p_argv6    LIKE sfb_file.sfb15,     #Finish date
          p_argv7    LIKE sfb_file.sfb08,     # qty
          p_argv8    LIKE type_file.num5,     #No.FUN-680136 SMALLINT #本次作業序號
          p_argv9    LIKE type_file.num5,     #No.FUN-680136 SMALLINT #下次作業序號
          p_argv10   LIKE sfb_file.sfb08,     #生產數量
          p_argv12   STRING                   #No.FUN-630010
 
   WHENEVER ERROR CONTINUE
   LET g_argv1 =p_argv1      #單號
   LET g_argv2 =p_argv2      #狀況
   LET g_argv3 =p_argv3      #性質
   LET g_argv4 =p_argv4      #W/O No
   IF cl_null(g_argv2) THEN LET g_argv2=0 END IF
   IF cl_null(g_argv4) THEN LET g_flag2 = 'Y' ELSE LET g_flag2 = 'N' END IF
   LET g_argv5 = p_argv5
   LET g_argv6 = p_argv6
   LET g_argv7 = p_argv7
   LET g_argv8 = p_argv8
   LET g_argv9 = p_argv9
   LET g_argv10= p_argv10
   LET g_argv12= p_argv12    #No.FUN-630010
   LET g_ydate = NULL
 
   CASE
      WHEN g_argv3 ='SUB' AND g_argv2='0'
         LET g_argv11 = 'apmt590'
         LET g_type = "2"  #No.FUN-670099
      WHEN g_argv3 !='SUB' AND g_argv2='0'
         LET g_argv11 = 'apmt540'
         LET g_type = "1"  #No.FUN-670099
   END CASE
 
 
   LET g_wc2=" 1=1 "
#FUN-B90103------add-----------
#FUN-B90103-------end----------
   INITIALIZE g_pmm.* TO NULL
   INITIALIZE g_pmm_t.* TO NULL
   INITIALIZE g_pmm_o.* TO NULL
 
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
 
   IF cl_null(g_pod.pod05) THEN
      SELECT pod05 INTO g_pod.pod05
        FROM pod_file
       WHERE pod00 = '0'
   END IF
 
   LET g_forupd_sql = "SELECT * FROM pmm_file WHERE pmm01 = ? FOR UPDATE" #g_pmm.pmm01
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t540_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET p_row = 2 LET p_col = 2
 
      IF g_argv3='SUB' THEN
#FUN-B90103---add-----------begin------------
#FUN-B90103-end----------------
            OPEN WINDOW t540_w AT p_row,p_col WITH FORM "apm/42f/apmt590"
              ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#FUN-C10002---begin
#FUN-C10002---end
#FUN-B90103--add--#&endif
            LET g_type = "2"  #No.FUN-670099
            CALL cl_ui_init()  #No.FUN-A60011
          # CALL cl_set_comp_visible("pmn012,ecu014",g_sma.sma54='Y')    #No.FUN-A60011  #TQC-AC0297
            CALL cl_set_comp_visible("pmn012,ecu014",g_sma.sma541 = 'Y')  #TQC-AC0297  
            CALL cl_set_comp_visible("pmn43,pmn431",g_sma.sma541 = 'Y')   #TQC-B80060
#FUN-B90103--------add---------
#FUN-B90103--------end---------
      ELSE
         IF g_argv2='2' THEN
            OPEN WINDOW t540_w AT p_row,p_col WITH FORM "apm/42f/apmt570"
              ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
            LET g_type = "1"  #No.FUN-670099
            CALL cl_ui_init()  #No.FUN-A60011
            CALL cl_set_comp_visible("pmn012,ecu014",FALSE)    #No.FUN-A60011
         ELSE
            CASE g_prog
              WHEN "apmt540"
                  OPEN WINDOW t540_w AT p_row,p_col WITH FORM "apm/42f/apmt540"
                    ATTRIBUTE (STYLE = g_win_style CLIPPED)
                  CALL cl_ui_init()  #No.FUN-A60011
#No:TQC-D50071----add--star---
                  IF g_aza.aza95 = 'N' THEN
                     CALL cl_set_comp_visible("pmn99",FALSE)
                  END IF
#No:TQC-D50071----add--end---
                  CALL cl_set_comp_visible("pmn012,ecu014",FALSE)    #No.FUN-A60011
            END CASE
            LET g_type = "1"
         END IF
      END IF

#     CALL cl_ui_init()  #No.FUN-A60011
   END IF
  #SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-9C0025 #MOD-BA0075 mark
 
   #初始化界面的樣式(沒有任何默認屬性組)
   LET lg_smy62 = ''
   LET lg_group = ''
   CALL t540_refresh_detail()
 
   CALL t540_def_form()
  #MOD-BA0075 mark --start--
  #CALL t540_set_no_required_pmn52()  #CHI-9C0025
  #CALL t540_set_required_pmn52()     #CHI-9C0025
  #MOD-BA0075 mark --end--
 
   #建立簽核模式時的 toolbar icon
   CALL aws_efapp_toolbar()
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN
      CALL aws_gpmcli_toolbar()
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
   IF g_azw.azw04 <> '2' OR cl_null(g_azw.azw04) THEN
      CALL cl_set_comp_visible("pmm52,pmm52_desc,pmm53,pmm53_desc,pmmconu",FALSE)
      CALL cl_set_comp_visible("pmmconu_desc,pmmcond,pmmplant,pmmplant_desc",FALSE)
      CALL cl_set_comp_visible("pmmcont,pmm51",FALSE)
      CALL cl_set_comp_visible("pmn72,pmn73,pmn74,pmn75,pmn76,pmn77",FALSE)
      CALL cl_set_comp_entry("pmm52",FALSE)
   END IF
  #TQC-B30004 ------mark begin---------------
  ##FUN-A30030 ADD BEGIN----------------------------
  # IF g_aza.aza88 ='N' THEN
  #    CALL cl_set_comp_visible("pmmpos",FALSE)
  # END IF
  ##FUN-A30030 ADD END-----------------------------
  #TQC-B30004 ------mark--end----------------
  CALL cl_set_comp_visible("pmmpos",FALSE)   #TQC-B30004 add
  CALL cl_set_comp_visible("pmniicd08",FALSE)  #FUN-C30289

   CALL cl_set_comp_visible("pmn919",g_sma.sma1421='Y')     #FUN-A80150 add
   CALL cl_set_comp_visible("pmm53,pmm53_desc",FALSE)  #bnl
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv12
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t540_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t540_a()
            END IF
         WHEN "efconfirm"
            LET g_action_choice = "efconfirm"    #FUN-A80087 add
            CALL t540_q()
            CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL t540sub_y_upd(g_pmm.pmm01,g_action_choice)       #CALL 原確認的 update 段
               #這裡不能CALL _show(),否則會錯
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
 
         OTHERWISE
            CALL t540_q()
      END CASE
   END IF
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,confirm,                                undo_confirm, easyflow_approval, triangletrade, undo_release, release_po,                                modify_status, special_description, sub, vender, aps_related_data, b_more,                                b_more2, m_item_supplierr, purchase_price, icd_maintain_product                              ,memo,barcode_gen            #TQC-B40210  add memo  #FUN-D30030 add barcode_gen                               ")  #TQC-740281 #FUN-A60055 add:b_more, b_more2, m_item_supplierr, purchase_price #FUN-D20025 add undo_void
        RETURNING g_laststage
   IF g_azw.azw04 <> '2' THEN
      CALL cl_set_comp_visible('pmmcont',FALSE)
   END IF
# FUN-B80093 add START											
   IF g_sma.sma93="Y" THEN											
      CALL cl_set_comp_visible("pmn89", TRUE)											
   ELSE											
      CALL cl_set_comp_visible("pmn89", FALSE)											
   END IF											
# FUN-B80093 add END											

  #FUN-D30030 add str-----------
   SELECT aza131 INTO g_aza.aza131 FROM aza_file
   IF g_aza.aza131  = 'N' THEN
      CALL cl_set_act_visible("barcode_gen,barcode_output,barcode_query",FALSE)
   END IF
  #FUN-D30030 add end-----------

   CALL t540_menu()
   CLOSE WINDOW t540_w
 
END FUNCTION
 
FUNCTION t540_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_ima926        LIKE    ima_file.ima926   #FUN-D30087 add
 
   CLEAR FORM
   CALL g_pmn.clear()
   IF NOT cl_null(g_argv1) THEN
        LET g_wc = " pmm01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INITIALIZE g_pmm.* TO NULL    #No.FUN-750051
#FUN-B90103---------------------begin----------------------
       DIALOG ATTRIBUTES(UNBUFFERED)
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                  pmm01,pmm03,pmm909,pmm04,pmm02,pmm09,pmm05,pmm18,pmm25,
                  pmmuser,pmmgrup,pmmoriu,pmmorig,pmmmodu,pmmdate,pmmacti,pmmcrat,
                  pmm20,pmm41,pmm10,pmm11,pmm12,pmm13,pmm21,pmm22,pmm42,pmm45,pmmmksg,
                  pmm905,pmm99,pmm51,pmm52,pmm53,pmmcond,pmmcont,pmmconu,pmmplant,pmmpos,
                 #pmm14,pmm15,pmm16,pmm17,pmm30,pmm44,     #MOD-C10015 mark pmm30
                  pmm14,pmm15,pmm16,pmm17,pmm44,           #MOD-C10015 mark pmm30
                  pmmud01,pmmud02,pmmud03,pmmud04,pmmud05,
                  pmmud06,pmmud07,pmmud08,pmmud09,pmmud10,
                  pmmud11,pmmud12,pmmud13,pmmud14,pmmud15,
                  pmm40,pmm40t

       BEFORE CONSTRUCT
                  CALL cl_qbe_init()
       END CONSTRUCT
       CONSTRUCT g_wc2 ON
            pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,
            pmn04,
            pmn72,                           #NO.FUN-960130
            pmn041,
            pmn07,pmn73,pmn74,pmn75,pmn76,pmn77,               #NO.FUN-960130
            pmn20,pmn83,pmn84,pmn85,pmn80,pmn81,               #NO.FUN-960130
            pmn82,pmn86,pmn87,
            pmn68,pmn69,pmn31,pmn31t,pmn89,pmn64,  #No.FUN-940083
            pmn63,pmn33,pmn34,pmn35,pmn919,pmn012,pmn43,pmn78,pmn100,pmn431,pmn122,   #CHI-9C0023 add pmn35  #No.FUN-A60011 #FUN-A80150 add pmn919  #No:FUN-C10002 add pmn78  #FUN-D40042 pmn100
            pmn96,pmn97,pmn67,pmn98,pmn40,pmn401,          #FUN-810045  #No.FUN-830161
            pmn930, #MOD-960190
            pmn90,pmn123, #FUN-950088 add pmn123                                                               #FUN-740046
            pmn52,pmn54,pmn56   #CHI-9C0025
           ,pmnud01,pmnud02,pmnud03,pmnud04,pmnud05,
           pmnud06,pmnud07,pmnud08,pmnud09,pmnud10,
           pmnud11,pmnud12,pmnud13,pmnud14,pmnud15
           ,pmn99  #No.FUN-A90009 add pmn99 

       FROM s_pmn[1].pmn02,s_pmn[1].pmn24,s_pmn[1].pmn25,s_pmn[1].pmn65,
            s_pmn[1].pmn41,s_pmn[1].pmn42,s_pmn[1].pmn16, # FUN-9B0127 mark s_pmn[1].pmn72,  #NO.FUN-960130-add--add pmn72
            s_pmn[1].pmn04,s_pmn[1].pmn72,s_pmn[1].pmn041, #FUN-9B0127 ADD s_pmn[1].pmn72,
            s_pmn[1].pmn07,s_pmn[1].pmn73,s_pmn[1].pmn74,s_pmn[1].pmn75,   #FUN-960130
            s_pmn[1].pmn76,s_pmn[1].pmn77,s_pmn[1].pmn20,                   #FUN-960130
            s_pmn[1].pmn83,s_pmn[1].pmn84,s_pmn[1].pmn85,s_pmn[1].pmn80,
            s_pmn[1].pmn81,s_pmn[1].pmn82,s_pmn[1].pmn86,s_pmn[1].pmn87,
            s_pmn[1].pmn68,s_pmn[1].pmn69,s_pmn[1].pmn31,s_pmn[1].pmn31t,   #No.FUN-550019
            s_pmn[1].pmn89,                                                 #No.FUN-940083
            s_pmn[1].pmn64,s_pmn[1].pmn63,s_pmn[1].pmn33,s_pmn[1].pmn34,s_pmn[1].pmn35,   #CHI-9C0023 add pmn35
            s_pmn[1].pmn919,                                                #FUN-A80150 pmn919
            s_pmn[1].pmn012,                                                #No.FUN-A60011
            s_pmn[1].pmn43,s_pmn[1].pmn78,s_pmn[1].pmn100,s_pmn[1].pmn431,s_pmn[1].pmn122,  #No:FUN-C10002 add pmn78  #FUN-D40042 pmn100
            s_pmn[1].pmn96,s_pmn[1].pmn97,s_pmn[1].pmn67,s_pmn[1].pmn98,  #FUN-810045
            s_pmn[1].pmn40,s_pmn[1].pmn401,                               #FUN-810045  #No.FUN-830161
            s_pmn[1].pmn930, #MOD-960190
            s_pmn[1].pmn90,s_pmn[1].pmn123,   #FUN-950088 add pmn123                                                                 
            s_pmn[1].pmn52,s_pmn[1].pmn54,s_pmn[1].pmn56   #CHI-9C0025  
           ,s_pmn[1].pmnud01,s_pmn[1].pmnud02,s_pmn[1].pmnud03,s_pmn[1].pmnud04,s_pmn[1].pmnud05,
           s_pmn[1].pmnud06,s_pmn[1].pmnud07,s_pmn[1].pmnud08,s_pmn[1].pmnud09,s_pmn[1].pmnud10,
           s_pmn[1].pmnud11,s_pmn[1].pmnud12,s_pmn[1].pmnud13,s_pmn[1].pmnud14,s_pmn[1].pmnud15
          #,s_pmn[1].pmnd99 #No.FUN-A90009 add pmn99       #TQC-AC0283
           ,s_pmn[1].pmn99      #TQC-AC0283  

      BEFORE CONSTRUCT
      CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT 
 ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm01) #單據編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    IF g_argv3 = 'SUB' THEN
                        LET g_qryparam.form = "q_pmm9"
                    ELSE
                        LET g_qryparam.form = "q_pmm12"
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm01
                    NEXT FIELD pmm01
               WHEN INFIELD(pmm05) #專案代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form ="q_pja2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm05
                    NEXT FIELD pmm05
               WHEN INFIELD(pmm09) #查詢廠商檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm09
                    NEXT FIELD pmm09
               WHEN INFIELD(pmm10) #查詢地址資料檔 (0:表送貨地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm10
                    NEXT FIELD pmm10
                WHEN INFIELD(pmm11) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm11
                    NEXT FIELD pmm11
               WHEN INFIELD(pmm12) #採購員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm12
                    CALL t540_peo('a','1',g_pmm.pmm12)
                    NEXT FIELD pmm12
               WHEN INFIELD(pmm13) #請購DEPT
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm13
                    NEXT FIELD pmm13
#TQC-AB0081 ----------Begin----------
             WHEN INFIELD(pmm14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmm_1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm14
                    NEXT FIELD pmm14
               WHEN INFIELD(pmm15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmm_2"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm15
                    NEXT FIELD pmm15
               WHEN INFIELD(pmm17)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmm_3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm17
                    NEXT FIELD pmm17
#TQC-AB0081 ----------End------------
                WHEN INFIELD(pmm16)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmm16"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm16
                    NEXT FIELD pmm16
               WHEN INFIELD(pmm20) #查詢付款條件資料檔(pma_file)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pma"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm20
                    NEXT FIELD pmm20
               WHEN INFIELD(pmm21) #查詢稅別資料檔(gec_file)i
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gec"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm21
                    NEXT FIELD pmm21
               WHEN INFIELD(pmm22) #查詢幣別資料檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm22
                    NEXT FIELD pmm22   
                   WHEN INFIELD(pmm41) #價格條件
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pnz01" #FUN-930113
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm41
               WHEN INFIELD(pmmud02)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmud02
                  NEXT FIELD pmmud02
               WHEN INFIELD(pmmud03)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmud03
                  NEXT FIELD pmmud03
               WHEN INFIELD(pmmud04)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmud04
                  NEXT FIELD pmmud04
               WHEN INFIELD(pmmud05)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmud05
                  NEXT FIELD pmmud05
               WHEN INFIELD(pmmud06)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmud06
                  NEXT FIELD pmmud06
               WHEN INFIELD(pmm52)  #采購機構
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_pmm52"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm52
                  NEXT FIELD pmm52
               WHEN INFIELD(pmm53)   #配送中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_pmm53"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm53
                  NEXT FIELD pmm53
               WHEN INFIELD(pmmconu)  #審核人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_pmmconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmmconu
                  NEXT FIELD pmmconu 
             
               WHEN INFIELD(pmnslk24) #請購單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmnslk24"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmnslk24
                    NEXT FIELD pmnslk24  

               WHEN INFIELD(pmnslk04) #料件編號
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmnslk04
                 NEXT FIELD pmnslk04       
               
               WHEN INFIELD(pmnslk07) #採購單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmnslk07 
                 NEXT FIELD pmnslk07

             #FUN-C30130--add--begin--
               WHEN INFIELD(pmnslk68) #Blanket P/O
                  #CALL q_pom2(TRUE,TRUE,g_pmnslk[1].pmnslk68,g_pmnslk[1].pmnslk69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret            #MOD-C30797 mark
                  CALL q_pom2(TRUE,TRUE,g_pmnslk[1].pmnslk68,g_pmnslk[1].pmnslk69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_qryparam.multiret #MOD-C30797 add
                  DISPLAY g_qryparam.multiret TO pmnslk68
                  NEXT FIELD pmnslk68

              WHEN INFIELD(pmnslk69) #Blanket P/O
                  #CALL q_pom2(TRUE,TRUE,g_pmnslk[1].pmnslk68,g_pmnslk[1].pmnslk69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret            #MOD-C30797 mark
                  CALL q_pom2(TRUE,TRUE,g_pmnslk[1].pmnslk68,g_pmnslk[1].pmnslk69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_qryparam.multiret #MOD-C30797 add
                  DISPLAY g_qryparam.multiret TO pmnslk69
                  NEXT FIELD pmnslk69
             #FUN-C30130--add--end--

               WHEN INFIELD(pmnslk52)
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmnslk52
                 NEXT FIELD pmnslk52 

                WHEN INFIELD(pmn24) #請購單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pml3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn24
                    NEXT FIELD pmn24
               WHEN INFIELD(pmn04) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                    DISPLAY g_qryparam.multiret TO pmn04
                    NEXT FIELD pmn04
               WHEN INFIELD(pmn07) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn07  #No.MOD-590003
                    NEXT FIELD pmn07
               WHEN INFIELD(pmn83)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn83
                    NEXT FIELD pmn83

               WHEN INFIELD(pmn80)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmn80
                    NEXT FIELD pmn80

               WHEN INFIELD(pmn86)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmn86
                   NEXT FIELD pmn86
               WHEN INFIELD(pmn41) #工單編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb7"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn41
                    NEXT FIELD pmn41

               WHEN INFIELD(pmn68) #Blanket P/O
                     #CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret            #MOD-C30797 mark
                     CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_qryparam.multiret #MOD-C30797 add
                  DISPLAY g_qryparam.multiret TO pmn68
                  NEXT FIELD pmn68

              WHEN INFIELD(pmn69) #Blanket P/O
                     #CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret            #MOD-C30797 mark
                     CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_qryparam.multiret #MOD-C30797 add
                  DISPLAY g_qryparam.multiret TO pmn69
                  NEXT FIELD pmn69

             #FUN-810045 begin
               WHEN INFIELD(pmn122)   #專案代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn122
                  NEXT FIELD pmn122
               WHEN INFIELD(pmn96)    #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn96
                  NEXT FIELD pmn96
               WHEN INFIELD(pmn97)    #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn97
                  NEXT FIELD pmn97
               WHEN INFIELD(pmn67)    #部門代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn67
                    NEXT FIELD pmn67
               WHEN INFIELD(pmn98)    #費用原因
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"                    #No.FUN-930145
                  LET g_qryparam.state = "c"   #多選
                  LET g_qryparam.arg1 = '7'                          #No.FUN-930145
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn98
                  NEXT FIELD pmn98
               WHEN INFIELD(pmn40)    #科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"   #多選
                  LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn40
                  NEXT FIELD pmn40
               WHEN INFIELD(pmn401)   #科目二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"   #多選
                  LET g_qryparam.arg1 = g_bookno2   #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn40
                  NEXT FIELD pmn40
               WHEN INFIELD(pmn930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn930
                  NEXT FIELD pmn930

              WHEN INFIELD(pmn123)
                  LET l_ima926 = 'N'                #FUN-D30087 add
                  SELECT ima926 INTO l_ima926 FROM ima_file  #FUN-D30087 add
                   WHERE ima01 = g_pmn[l_ac].pmn04           #FUN-D30087 add
                   CALL cl_init_qry_var()
                  IF l_ima926 = 'Y' THEN            #FUN-D30087 add
                     LET g_qryparam.form = "q_bmj3" #FUN-D30087 add
                  ELSE                              #FUN-D30087 add
                     LET g_qryparam.form = "q_mse"
                  END IF                            #FUN-D30087 add
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_pmn[l_ac].pmn04    #FUN-D30087 add
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn123
                  NEXT FIELD pmn123
                WHEN INFIELD(pmn52) #查詢 img資料檔
                 #No.FUN-AA0049--begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_imd"
                 #LET g_qryparam.state    = "c"
                 #LET g_qryparam.arg1     = 'SW'        #倉庫類別
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                 #No.FUN-AA0049--end
                 DISPLAY g_qryparam.multiret TO pmn52
                 NEXT FIELD pmn52
              #No.FUN-A60011  --Begin
              WHEN INFIELD(pmn012)  #工艺段号
                 CALL cl_init_qry_var()
               # LET g_qryparam.form     = "q_ecu012_1"     #FUN-B10056 mark
                 LET g_qryparam.form     = "q_ecb012_1"     #FUN-B10056
                 LET g_qryparam.state    = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmn012
                 NEXT FIELD pmn012
              #No.FUN-A60011  --End
              #No.FUN-C10002  --Begin 
              WHEN INFIELD(pmn78)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_pmn78"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn78
                  NEXT FIELD pmn78
              #No.FUN-C10002  --End   
               OTHERWISE EXIT CASE
            END CASE    

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #MOD-D90139 add --start-- sunlm
         ON ACTION qbe_save
            CALL cl_qbe_save() 
         #MOD-D90139 add --end--
        
         ON ACTION accept
            EXIT DIALOG
            
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG 
                 
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG
      END DIALOG
#FUN-B90103---------------------end------------------------


#FUN-B90103------------------mark-------------------------start--

#TQC-AB0081 -----------------------------Begin-----------------------------------
#      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#                  pmm01,pmm03,pmm909,pmm04,pmm02,pmm09,pmm05,pmm18,pmmcont,  #No.TQC-650119 modify  #FUN-810045 add pmm05  #No.FUN-830161  #NO.FUN-960130---add pmmcont
#                  pmm20,pmm41,pmm10,pmm11,
#                  pmm12,pmm13,pmm21,pmm43,pmm22,pmm42,pmm40,pmm40t,  #No.FUN-610018
#                  pmm45,pmm905,pmm99,pmmmksg,pmm25,pmmpos,    #NO.FUN-960130---add pos
#                  pmm14,pmm15,pmm16,pmm17,pmm30,pmm44,
#                  pmm51,pmm52,pmm53,pmmcond,pmmconu,pmmplant,  #NO.FUN-960130--add--
#                  pmmud01,pmmud02,pmmud03,pmmud04,pmmud05,
#                  pmmud06,pmmud07,pmmud08,pmmud09,pmmud10,
#                  pmmud11,pmmud12,pmmud13,pmmud14,pmmud15,
#                  pmmuser,pmmgrup,pmmmodu,pmmdate,pmmacti,
#                  pmmcrat,pmmoriu,pmmorig                    #NO.FUN-960130  #No.TQC-9B0104
#TQC-AB0081 -----------------------------End--------------------------------------
#TQC-AB0081 -----------------------------------Begin----------------------------------
#     CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#                 pmm01,pmm03,pmm909,pmm04,pmm02,pmm09,pmm05,pmm18,pmm25,
#                 pmmuser,pmmgrup,pmmoriu,pmmorig,pmmmodu,pmmdate,pmmacti,pmmcrat,
#                 pmm20,pmm41,pmm10,pmm11,pmm12,pmm13,pmm21,pmm22,pmm42,pmm45,pmmmksg,
#                 pmm905,pmm99,pmm51,pmm52,pmm53,pmmcond,pmmcont,pmmconu,pmmplant,pmmpos,
#                 pmm14,pmm15,pmm16,pmm17,pmm30,pmm44,
#                 pmmud01,pmmud02,pmmud03,pmmud04,pmmud05,
#                 pmmud06,pmmud07,pmmud08,pmmud09,pmmud10,
#                 pmmud11,pmmud12,pmmud13,pmmud14,pmmud15,
#                 pmm40,pmm40t
#TQC-AB0081 -----------------------------------End------------------------------------
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(pmm01) #單據編號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state= "c"
#                   IF g_argv3 = 'SUB' THEN
#                       LET g_qryparam.form = "q_pmm9"
#                   ELSE
#                       LET g_qryparam.form = "q_pmm12"
#                   END IF
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm01
#                   NEXT FIELD pmm01
#              WHEN INFIELD(pmm05) #專案代號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state= "c"
#                   LET g_qryparam.form ="q_pja2"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm05
#                   NEXT FIELD pmm05
#              WHEN INFIELD(pmm09) #查詢廠商檔
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pmc1"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm09
#                   NEXT FIELD pmm09
#              WHEN INFIELD(pmm10) #查詢地址資料檔 (0:表送貨地址)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pme"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm10
#                   NEXT FIELD pmm10
#              WHEN INFIELD(pmm11) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pme"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm11
#                   NEXT FIELD pmm11
#              WHEN INFIELD(pmm12) #採購員
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gen"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm12
#                   CALL t540_peo('a','1',g_pmm.pmm12)
#                   NEXT FIELD pmm12
#              WHEN INFIELD(pmm13) #請購DEPT
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gem"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm13
#                   NEXT FIELD pmm13
#TQC-AB0081 ----------Begin----------
#              WHEN INFIELD(pmm14)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pmm_1"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm14
#                   NEXT FIELD pmm14
#              WHEN INFIELD(pmm15)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pmm_2"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm15
#                   NEXT FIELD pmm15
#              WHEN INFIELD(pmm17)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pmm_3"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm17
#                   NEXT FIELD pmm17
#TQC-AB0081 ----------End------------
#               WHEN INFIELD(pmm16)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pmm16"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm16
#                   NEXT FIELD pmm16
#              WHEN INFIELD(pmm20) #查詢付款條件資料檔(pma_file)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pma"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm20
#                   NEXT FIELD pmm20
#              WHEN INFIELD(pmm21) #查詢稅別資料檔(gec_file)i
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gec"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm21
#                   NEXT FIELD pmm21
#              WHEN INFIELD(pmm22) #查詢幣別資料檔
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_azi"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmm22
#                   NEXT FIELD pmm22
#             WHEN INFIELD(pmm41) #價格條件
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_pnz01" #FUN-930113
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmm41
#              WHEN INFIELD(pmmud02)
#                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmud02
#                 NEXT FIELD pmmud02
#              WHEN INFIELD(pmmud03)
#                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmud03
#                 NEXT FIELD pmmud03
#              WHEN INFIELD(pmmud04)
#                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmud04
#                 NEXT FIELD pmmud04
#              WHEN INFIELD(pmmud05)
#                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmud05
#                 NEXT FIELD pmmud05
#              WHEN INFIELD(pmmud06)
#                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmud06
#                 NEXT FIELD pmmud06
#              WHEN INFIELD(pmm52)  #采購機構
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form ="q_pmm52"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmm52
#                 NEXT FIELD pmm52
#              WHEN INFIELD(pmm53)   #配送中心
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form ="q_pmm53"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmm53
#                 NEXT FIELD pmm53
#              WHEN INFIELD(pmmconu)  #審核人員
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form ="q_pmmconu"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmmconu
#                 NEXT FIELD pmmconu
#              OTHERWISE EXIT CASE
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#                ON ACTION qbe_select
#      CALL cl_qbe_list() RETURNING lc_qbe_sn
#      CALL cl_qbe_display_condition(lc_qbe_sn)
#     END CONSTRUCT
#
#     IF INT_FLAG THEN
#        RETURN
#     END IF
#
#     CONSTRUCT g_wc2 ON
#            pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,
#&ifdef SLK
#            pmnislk01,                                   #No.FUN-810016 add pmnislk
#&endif
#            pmn04,
#            pmn72,                           #NO.FUN-960130
#            pmn041,
#&ifdef ICD
#            pmniicd14,pmniicd15,    #No.FUN-7C0017
#&endif
#            pmn07,pmn73,pmn74,pmn75,pmn76,pmn77,               #NO.FUN-960130
#            pmn20,pmn83,pmn84,pmn85,pmn80,pmn81,               #NO.FUN-960130
#            pmn82,pmn86,pmn87,
#&ifdef ICD            
#            pmniicd13,                                       #No.FUN-950026
#&endif              
#            pmn68,pmn69,pmn31,pmn31t,pmn89,pmn64,  #No.FUN-940083
#           pmn63,pmn33,pmn34,pmn35,pmn919,pmn012,pmn43,pmn431,pmn122,   #CHI-9C0023 add pmn35  #No.FUN-A60011 #FUN-A80150 add pmn919
#           pmn96,pmn97,pmn67,pmn98,pmn40,pmn401,          #FUN-810045  #No.FUN-830161
#           pmn930, #MOD-960190
#           pmn90,pmn123, #FUN-950088 add pmn123                                                               #FUN-740046
#           pmn52,pmn54,pmn56   #CHI-9C0025
#&ifdef ICD
#           ,pmniicd06,pmniicd09,pmniicd18,pmniicd12,   #No.FUN-7C0017
#            pmniicd08,pmniicd03,pmniicd11,pmniicd16    #No.FUN-7C0017  #No.MOD-890023 add
#&endif
#           ,pmnud01,pmnud02,pmnud03,pmnud04,pmnud05,
#           pmnud06,pmnud07,pmnud08,pmnud09,pmnud10,
#           pmnud11,pmnud12,pmnud13,pmnud14,pmnud15
#           ,pmn99  #No.FUN-A90009 add pmn99 
# 
#       FROM s_pmn[1].pmn02,s_pmn[1].pmn24,s_pmn[1].pmn25,s_pmn[1].pmn65,
#            s_pmn[1].pmn41,s_pmn[1].pmn42,s_pmn[1].pmn16, # FUN-9B0127 mark s_pmn[1].pmn72,  #NO.FUN-960130-add--add pmn72
#&ifdef SLK
#            s_pmn[1].pmnislk01, #No.FUN-810016
#&endif
#            s_pmn[1].pmn04,s_pmn[1].pmn72,s_pmn[1].pmn041, #FUN-9B0127 ADD s_pmn[1].pmn72,
#&ifdef ICD
#            s_pmn[1].pmniicd14,s_pmn[1].pmniicd15,    #No.FUN-7C0017
#&endif
#            s_pmn[1].pmn07,s_pmn[1].pmn73,s_pmn[1].pmn74,s_pmn[1].pmn75,   #FUN-960130
#           s_pmn[1].pmn76,s_pmn[1].pmn77,s_pmn[1].pmn20,                   #FUN-960130
#           s_pmn[1].pmn83,s_pmn[1].pmn84,s_pmn[1].pmn85,s_pmn[1].pmn80,
#           s_pmn[1].pmn81,s_pmn[1].pmn82,s_pmn[1].pmn86,s_pmn[1].pmn87,
#&ifdef ICD
#            s_pmn[1].pmniicd13,              #No.FUN-950026
#&endif            
#            s_pmn[1].pmn68,s_pmn[1].pmn69,s_pmn[1].pmn31,s_pmn[1].pmn31t,   #No.FUN-550019
#            s_pmn[1].pmn89,                                                 #No.FUN-940083
#            s_pmn[1].pmn64,s_pmn[1].pmn63,s_pmn[1].pmn33,s_pmn[1].pmn34,s_pmn[1].pmn35,   #CHI-9C0023 add pmn35
#           s_pmn[1].pmn919,                                                #FUN-A80150 pmn919
#           s_pmn[1].pmn012,                                                #No.FUN-A60011
#           s_pmn[1].pmn43,s_pmn[1].pmn431,s_pmn[1].pmn122,
#           s_pmn[1].pmn96,s_pmn[1].pmn97,s_pmn[1].pmn67,s_pmn[1].pmn98,  #FUN-810045
#           s_pmn[1].pmn40,s_pmn[1].pmn401,                               #FUN-810045  #No.FUN-830161
#           s_pmn[1].pmn930, #MOD-960190
#           s_pmn[1].pmn90,s_pmn[1].pmn123,   #FUN-950088 add pmn123                                                                             #FUN-740046
#           s_pmn[1].pmn52,s_pmn[1].pmn54,s_pmn[1].pmn56   #CHI-9C0025
#&ifdef ICD
#           ,s_pmn[1].pmniicd06,s_pmn[1].pmniicd09,s_pmn[1].pmniicd18,s_pmn[1].pmniicd12,  #No.FUN-7C0017
#          #s_pmn[1].pmniicd08,s_pmn[1].pmniicd03,s_pmn[1].pmniicd11,s_pmn[1].pmniicd05   #No.FUN-7C0017  #No:MOD-890023 mark   #MOD-A50190 mark
#           s_pmn[1].pmniicd08,s_pmn[1].pmniicd03,s_pmn[1].pmniicd11,s_pmn[1].pmniicd16   #MOD-A50190
#&endif
#          ,s_pmn[1].pmnud01,s_pmn[1].pmnud02,s_pmn[1].pmnud03,s_pmn[1].pmnud04,s_pmn[1].pmnud05,
#          s_pmn[1].pmnud06,s_pmn[1].pmnud07,s_pmn[1].pmnud08,s_pmn[1].pmnud09,s_pmn[1].pmnud10,
#          s_pmn[1].pmnud11,s_pmn[1].pmnud12,s_pmn[1].pmnud13,s_pmn[1].pmnud14,s_pmn[1].pmnud15
#         #,s_pmn[1].pmnd99 #No.FUN-A90009 add pmn99       #TQC-AC0283 
#          ,s_pmn[1].pmn99      #TQC-AC0283
#   BEFORE CONSTRUCT
#      CALL cl_qbe_display_condition(lc_qbe_sn)
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(pmn24) #請購單號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_pml3"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmn24
#                   NEXT FIELD pmn24
#              WHEN INFIELD(pmn04) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#&ifdef ICD
#                      IF g_prog='aict040' THEN
#                          LET g_qryparam.form = "q_imaicd"
#                          LET g_qryparam.where = " imaicd IN ('0','1','2')"
#                          CALL q_sel_ima(TRUE, "q_imaicd"," imaicd IN ('0','1','2')","","","","","","",'')  
#                             RETURNING  g_qryparam.multiret
#                      END IF
#&endif
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

#                   DISPLAY g_qryparam.multiret TO pmn04
#                   NEXT FIELD pmn04
#              WHEN INFIELD(pmn07) #採購單位
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_gfe"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmn07  #No.MOD-590003
#                   NEXT FIELD pmn07
#              WHEN INFIELD(pmn83)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO pmn83
#                      NEXT FIELD pmn83
#              WHEN INFIELD(pmn80)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_gfe"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmn80
#                   NEXT FIELD pmn80
#                  WHEN INFIELD(pmn86)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_gfe"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmn86
#                  NEXT FIELD pmn86
#              WHEN INFIELD(pmn41) #工單編號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_sfb7"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO pmn41
#                   NEXT FIELD pmn41
#
#              WHEN INFIELD(pmn68) #Blanket P/O
#&ifdef ICD
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_pmm"
#                     LET g_qryparam.state = 'c'
#                     LET g_qryparam.where = " pmm02='WB1' OR pmm02='WB3'"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#&else
#                     CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret
#&endif
#                  DISPLAY g_qryparam.multiret TO pmn68
#                  NEXT FIELD pmn68
# 
#               WHEN INFIELD(pmn69) #Blanket P/O
#&ifdef ICD
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_pmn"
#                     LET g_qryparam.state = 'c'
#                     LET g_qryparam.arg1 = g_pmn[1].pmn68
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#&else
#                     CALL q_pom2(TRUE,TRUE,g_pmn[1].pmn68,g_pmn[1].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_qryparam.multiret
#&endif
#                 DISPLAY g_qryparam.multiret TO pmn69
#                 NEXT FIELD pmn69
#            #FUN-810045 begin
#              WHEN INFIELD(pmn122)   #專案代號
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_pja2"
#                 LET g_qryparam.state = "c"   #多選
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn122
#                 NEXT FIELD pmn122
#              WHEN INFIELD(pmn96)    #WBS
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_pjb4"
#                 LET g_qryparam.state = "c"   #多選
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn96
#                 NEXT FIELD pmn96
#              WHEN INFIELD(pmn97)    #活動
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_pjk3"
#                 LET g_qryparam.state = "c"   #多選
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn97
#                 NEXT FIELD pmn97
#              WHEN INFIELD(pmn67)    #部門代號
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_gem"
#                 LET g_qryparam.state = "c"   #多選
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn67
#                 NEXT FIELD pmn67
#              WHEN INFIELD(pmn98)    #費用原因
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_azf01a"                    #No.FUN-930145 
#                 LET g_qryparam.state = "c"   #多選
#                 LET g_qryparam.arg1 = '7'                          #No.FUN-930145
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn98
#                 NEXT FIELD pmn98
#              WHEN INFIELD(pmn40)    #科目
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_aag"
#                 LET g_qryparam.state = "c"   #多選
#                 LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn40
#                 NEXT FIELD pmn40
#              WHEN INFIELD(pmn401)   #科目二
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_aag"
#                 LET g_qryparam.state = "c"   #多選
#                 LET g_qryparam.arg1 = g_bookno2   #No.FUN-730033
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn40
#                 NEXT FIELD pmn40
#              WHEN INFIELD(pmn930)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form  = "q_gem4"
#                 LET g_qryparam.state = "c"   #多選
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn930
#                 NEXT FIELD pmn930
#              
#             WHEN INFIELD(pmn123)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_mse"
#                 LET g_qryparam.state = 'c'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO pmn123
#                 NEXT FIELD pmn123
#             WHEN INFIELD(pmn52) #查詢 img資料檔
#                #No.FUN-AA0049--begin
#                #CALL cl_init_qry_var()
#                #LET g_qryparam.form     = "q_imd"
#                #LET g_qryparam.state    = "c"
#                #LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                #CALL cl_create_qry() RETURNING g_qryparam.multiret
#                CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
#                #No.FUN-AA0049--end
#                DISPLAY g_qryparam.multiret TO pmn52
#                NEXT FIELD pmn52
#             #No.FUN-A60011  --Begin
#             WHEN INFIELD(pmn012)  #工艺段号
#                CALL cl_init_qry_var()
#              # LET g_qryparam.form     = "q_ecu012_1"     #FUN-B10056 mark
#                LET g_qryparam.form     = "q_ecb012_1"     #FUN-B10056
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO pmn012
#                NEXT FIELD pmn012
#             #No.FUN-A60011  --End  
#&ifdef ICD
#             WHEN INFIELD(pmniicd14) #內編母體
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imaicd1"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmniicd14
#                  NEXT FIELD pmniicd14
#             WHEN INFIELD(pmniicd15) #最終產品料號
#FUN-AA0059---------mod------------str-----------------
#             
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_imaicd"
#                   LET g_qryparam.state = 'c'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   CALL q_sel_ima(TRUE, "q_imaicd","","","","","","","",'')  
#                    RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
#                  DISPLAY g_qryparam.multiret TO pmniicd15
#                  NEXT FIELD pmniicd15          
#             WHEN INFIELD(pmniicd18) #下階廠商
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_pmc2"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmniicd18
#                  NEXT FIELD pmniicd18
#             WHEN INFIELD(pmniicd12) #Wafer廠商
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_icq02_icd_1"  #CHI-920037
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmniicd12
#                  NEXT FIELD pmniicd12
#             WHEN INFIELD(pmniicd03) #作業編號
#                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO pmniicd03
#                  NEXT FIELD pmniicd03
#&endif
#              OTHERWISE EXIT CASE
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#     END CONSTRUCT
#FUN-B90103--mark----------------------end--------------   
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
   IF g_argv2 = '0' THEN      #已開立
      LET g_wc = g_wc clipped," AND pmm25 IN ('X','0','1','2','6','9','S','R','W') "
   END IF
 
   IF g_argv2 = '1' THEN      #已核淮
      LET g_wc = g_wc clipped," AND pmm25 IN ('1') "
   END IF
 
   IF g_argv2 = '2' THEN      #已發出
      LET g_wc = g_wc clipped," AND pmm25 IN ('2') "
   END IF
 
   IF g_argv3 = 'SUB' THEN
      LET g_wc = g_wc clipped," AND pmm02 = 'SUB' "
   ELSE
      LET g_wc = g_wc clipped," AND pmm02 not IN ('SUB') "
   END IF

#FUN-B90103--add##&ifndef SLK
   IF g_wc2=' 1=1 ' THEN
      IF g_argv3='SUB' THEN  #NO:6961
         IF NOT cl_null(g_argv4)  THEN   #NO:6961
            LET g_sql="SELECT UNIQUE pmm01 ",#MOD-530163
                      "  FROM pmm_file,pmn_file ", #組合出SQL指令
                      " WHERE pmm01=pmn01 AND ", g_wc CLIPPED,
                      " AND pmn41='",g_argv4,"' ",
                      " ORDER BY pmm01 "
         ELSE
            LET g_sql="SELECT UNIQUE pmm01 ",#MOD-530163
                      "  FROM pmm_file ", #組合出SQL指令
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY pmm01 "
         END IF
      ELSE
         LET g_sql="SELECT UNIQUE pmm01 FROM pmm_file ", #組合出SQL指令 #MOD-530163 加UNIQUE
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY pmm01"
      END IF
   ELSE
      LET g_sql="SELECT UNIQUE pmm01 FROM pmm_file,pmn_file ", #MOD-530163 加UNIQUE
                " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                "   AND pmm01 = pmn01",
                " ORDER BY pmm01"
   END IF
#FUN-B90103--&endif

#FUN-B90103--start-----
#FUN-B90103--end-------   

   PREPARE t540_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE t540_cs                         # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t540_prepare
   DECLARE t540_fill_cs CURSOR WITH HOLD FOR t540_prepare      #FUN-CB0014

#FUN-B90103--add#ifndef SLK 
   IF g_argv3='SUB' THEN
      IF g_wc2=' 1=1 ' THEN
         IF NOT cl_null(g_argv4)  THEN   #NO:6961
            LET g_sql= "SELECT COUNT(DISTINCT pmm01) ",
                       "  FROM pmm_file,pmn_file ",
                       " WHERE pmm02='SUB' AND pmn01=pmm01 ",
                       "   AND ",g_wc CLIPPED,
                       " AND pmn41='",g_argv4,"' "
         ELSE
            LET g_sql= "SELECT COUNT(DISTINCT pmm01) ",
                       "  FROM pmm_file ",
                       " WHERE pmm02='SUB' ",
                       "   AND ",g_wc CLIPPED
         END IF
      ELSE
         LET g_sql= "SELECT COUNT(DISTINCT pmm01) ",
                    "  FROM pmm_file,pmn_file",
                    " WHERE pmm01 = pmn01 AND pmm02='SUB' ",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2
      END IF
   ELSE
      IF g_wc2=' 1=1 ' THEN
         LET g_sql= "SELECT COUNT(*) FROM pmm_file",
                       " WHERE pmm02 != 'SUB' AND ",g_wc CLIPPED
      ELSE
         LET g_sql= "SELECT COUNT(DISTINCT pmm01) FROM pmm_file,pmn_file",
                    " WHERE pmm01 = pmn01",
                    "  AND pmm02 != 'SUB' AND ",g_wc CLIPPED," AND ",
                    g_wc2
      END IF
   END IF
#FUN-B90103--&endif
#FUN-B90103--add--start--
#FUN-B90103--end--------- 

   PREPARE t540_precount FROM g_sql
   DECLARE t540_count CURSOR FOR t540_precount
 
END FUNCTION
 
FUNCTION t540_menu()
   DEFINE l_creator   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) #「不准」時是否退回填表人 #FUN-580113
   DEFINE l_flowuser  LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # 是否有指定加簽人員      #FUN-580113
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_sql       STRING                 #DEV-D30026
 
   LET l_flowuser = "N"   #FUN-580113
 
   WHILE TRUE
   #  CALL t540_bp("G")         #FUN-CB0014
   #FUN-CB0014 --------Begin----------
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t540_bp("G")
         WHEN (g_action_flag = "info_list")
            CALL t540_list_fill()
            CALL t540_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT pmm_file.* INTO g_pmm.* FROM pmm_file
                WHERE pmm01=g_pmm_1[l_ac1].pmm01_1
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET mi_no_ask = TRUE
               IF g_rec_b1 >0 THEN
                   CALL t540_fetch('/')
               END IF
               CALL cl_set_comp_visible("page3", FALSE)
               CALL cl_set_comp_visible("page4", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page3", TRUE)
               CALL cl_set_comp_visible("page4", TRUE)
             END IF
      END CASE
   #FUN-CB0014 --------End----------
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t540_a()
            END IF
         WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t540_q()
              END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                 CALL t540_r() #FUN-920190
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                 CALL t540_u()
            END IF
         WHEN "reproduce"
              IF cl_chk_act_auth() THEN
                 CALL t540_copy()
              END IF
         WHEN "detail"
              IF cl_chk_act_auth() THEN       #No.7286
                 CALL t540_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
              
         WHEN "output"
           IF cl_chk_act_auth() THEN  #MOD-C40129 add
              CALL t540_out() 
           END IF                     #MOD-C40129 add
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "供應商資料"
         WHEN "vender"
            #FUN-C30017 add---end---
            IF cl_null(g_pmm.pmm01) THEN
               CALL cl_err('','-400',1)  #MOD-640492 0->1
            ELSE
               IF g_pmm.pmm25 NOT MATCHES '[Ss]' THEN  #FUN-C30140 add if判斷
                   LET g_pmm_t.* = g_pmm.*     #TQC-C20013 add
                   CALL t542(g_argv2,g_pmm.pmm01)
                   SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01=g_pmm.pmm01 #TQC-BB0171
                   #TQC-C20013 add --start--
                   IF g_pmm.pmm09 != g_pmm_t.pmm09 OR g_pmm.pmm22 != g_pmm_t.pmm22 OR
                      g_pmm.pmm04 != g_pmm_t.pmm04 OR g_pmm.pmm21 != g_pmm_t.pmm21 OR
                      g_pmm.pmm43 != g_pmm_t.pmm43 THEN
                      CALL t540_get_price()
                   END IF
                   #TQC-C20013 add --end--
                   CALL t540_show() #TQC-BB0171
               #FUN-C30140 add---str---
               ELSE
                   CALL cl_err('','mfg3557',0) #本單據目前已送簽或已核准
               END IF
               #FUN-C30140 add---end---
            END IF
       #@WHEN "單價查詢"
         WHEN "qry_unit_price"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_pmm.pmm01) THEN
                  CALL cl_err('','-400',1)  #MOD-640492 0->1
               ELSE
                  CALL t540_6()
               END IF
            END IF
       #@WHEN "三角貿易"
         WHEN "triangletrade"
            IF cl_chk_act_auth() THEN
               CALL t540_v()
            END IF
       #@WHEN "簽核狀況"
         WHEN "approval_status"               # MOD-4C0041
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN                #FUN-550038
                    CALL aws_efstat2()     #MOD-560007
               END IF
            END IF
 
         WHEN "easyflow_approval"     #FUN-550038
            IF cl_chk_act_auth() THEN
              #FUN-C20026 add str---
               SELECT * INTO g_pmm.* FROM pmm_file
                WHERE pmm01 = g_pmm.pmm01
               CALL t540_show()
               CALL t540_b_fill(' 1=1',' 1=1')
              #FUN-C20026 add end---
               CALL t540_ef()
               CALL t540_show()  #FUN-C20026 add
            END IF
 
       #@WHEN "備註"
         WHEN "memo"
#TQC-B40210 --begin--
          IF g_pmm.pmm25 MATCHES '[Ss]' THEN 
             CALL cl_err('','apm-030',0)
          ELSE             
#TQC-B40210 --end--         
            IF g_pmm.pmm01 IS NOT NULL AND g_pmm.pmm01 != ' '
               AND g_pmm.pmm02 IS NOT NULL AND g_pmm.pmm02 != ' ' THEN
               LET g_cmd = 'apmt503 ','1 ',"'",
                           g_pmm.pmm01 clipped,"'"
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            ELSE
               CALL cl_err('','-400',1)  #MOD-640492 0->1
            END IF
          END IF          #TQC-B40210
            
       #@WHEN "特別說明"
         WHEN "special_description"
            IF cl_chk_act_auth() THEN   #CHI-9C0002
               IF g_pmm.pmm01 IS NOT NULL AND g_pmm.pmm01 != ' ' THEN
                  LET g_cmd = "apmt402 ",'1 ',"'",
                      g_pmm.pmm01,"'",' ','0' CLIPPED
                      CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
               ELSE
                  CALL cl_err('','-400',1)   #MOD-640492 0->1
               END IF
            END IF   #CHI-9C0002
       #@WHEN "特別說明"
         WHEN "b_more"
            IF (g_pmm.pmm01 IS NOT NULL AND g_pmm.pmm01 != ' ') AND l_ac>0 THEN
               #FUN-A60055 add str ---------------
               IF g_pmm.pmm25 matches '[Ss]' THEN
                  CALL cl_err('','apm-030',1)
               ELSE
               #FUN-A60055 add end ---------------
                  SELECT * INTO g_pmn2.* FROM pmn_file                 
                   WHERE pmn01=g_pmm.pmm01 AND pmn02=g_pmn[l_ac].pmn02 
                  BEGIN WORK                                            
                  CALL t540_b_more('u')                             
                  COMMIT WORK   
               END IF                             #FUN-A60055 add                                       
            ELSE
               CALL cl_err('','-400',1)   
            END IF
       #@WHEN "替代"
         WHEN "sub"
            IF cl_chk_act_auth() THEN
               #FUN-A60055 add str ---------------
               IF g_pmm.pmm25 matches '[Ss]' THEN
                  CALL cl_err('','apm-030',1)
               ELSE
               #FUN-A60055 add end ---------------
                  IF cl_null(g_pmm.pmm01) THEN
                     CALL cl_err('','-400',1)   #MOD-640492 0->1
                  ELSE
                     CALL t540_s()
                  END IF
               END IF                           #FUN-A60055 add
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t540sub_x(g_pmm.pmm01,g_action_choice,TRUE)   #FUN-920175 #FUN-D20025 mark
               CALL t540sub_x(g_pmm.pmm01,g_action_choice,TRUE,1)  #FUN-D20025 add
               CALL  t540_update()    #MOD-9B0042
               CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-920175
               CALL t540_show() #FUN-920175
            END IF
       #FUN-D20025 add
       #@WHEN "取消作廢"
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t540sub_x(g_pmm.pmm01,g_action_choice,TRUE,2)  
               CALL  t540_update()    
               CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.*
               CALL t540_show()
            END IF
       #FUN-D20025 add     
       #@WHEN "發出還原"
         WHEN "undo_release"
            IF cl_chk_act_auth() THEN
                IF g_pmm.pmm02<> 'ICT' THEN  #NO.MOD-4A0334  --begin
                 #若為三角貿易單據，但非來源單據則不可發出還原
                  IF g_pmm.pmm901 = 'Y' THEN
                     IF g_pmm.pmm906 = 'Y' THEN
                        IF s_chkoga() THEN
                           #MOD-B30717 add --start--
                           SELECT pmm905,pmm99 INTO g_pmm.pmm905,g_pmm.pmm99 FROM pmm_file
                            WHERE pmm01=g_pmm.pmm01
                           #MOD-B30717 add --end--
                           IF g_pmm.pmm905 = 'Y' THEN        #No.TQC-7C0033
                              IF cl_confirm('apm-979') THEN  #No.TQC-7C0033
                                 IF g_pmm.pmm25 = '2' AND g_pmm.pmm906 = 'Y'  #No.TQC-7C0060
                                    AND g_pod.pod05 = 'Y'     #FUN-670007
                                    AND g_pmm.pmm18 = 'Y'     #MOD-780108 add # 走簽核時會有pmm25='1' pmm18='N' 的狀況
                                    AND g_errno = ' ' THEN    #MOD-780108 add # reverse()會有錯誤訊息時不再往下執行
                                    LET g_cmd = "apmp811 '",g_pmm.pmm01,"'"
                                   CALL cl_cmdrun_wait(g_cmd)
                                 END IF
                                 SELECT * INTO g_pmm.* FROM pmm_file
                                  WHERE pmm01=g_pmm.pmm01
                                CALL t540_show()                      # 重新顯示
                              END IF #No.TQC-7C0033
                           END IF    #No.TQC-7C0033
                           IF cl_null(g_pmm.pmm99) THEN
                              CALL t540_reverse()
                           ELSE
                              CALL cl_err('','tri-013',1)
                           END IF
                        END IF
                   ELSE
                      CALL cl_err('','apm-095',1)
                     END IF
                  ELSE
                     CALL t540_reverse()
                  END IF
                END IF --NO.MOD-4A0334  --end
            END IF
         #darcy:2024/09/02 add s---
         when "change_pmn35"
            if cl_chk_act_auth() then
               call sapmt540_change_pmn35(g_pmm.pmm01,g_pmn[l_ac].pmn02)
            end if
         #darcy:2024/09/02 add e---
       #@WHEN "採購發出"
         WHEN "release_po"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_pmm.pmm01) THEN
                  CALL cl_err('','-400',1)  #MOD-640492 0->1
               ELSE
                  CALL t540sub_issue(g_pmm.pmm01,TRUE)
                  CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-730012
                  CALL t540_show()  #FUN-730012
               END IF
            END IF
       #@WHEN "變更狀況"
         WHEN "modify_status"
            IF cl_null(g_pmm.pmm01) THEN
               CALL cl_err('','-400',1)  #MOD-640492 0->1
            ELSE
               LET g_cmd = "apmt910 '",g_pmm.pmm01,"'"
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF
       #@WHEN "驗收狀況"
         WHEN "receiving_status"
            IF cl_null(g_pmm.pmm01) THEN
               CALL cl_err('','-400',1)   #MOD-640492 0->1
            ELSE
               LET g_cmd = "apmq520 "," '",g_pmm.pmm01,"'"," ' ' "
               CALL cl_cmdrun(g_cmd CLIPPED)
            END IF
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t540sub_y_upd(g_pmm.pmm01,g_action_choice)       #CALL 原確認的 update 段 #FUN-740034
                  CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-730012
                  CALL t540_show() #FUN-730012
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t540sub_z(g_pmm.pmm01,g_action_choice,TRUE)   #FUN-920175
               CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-920175
               CALL t540_show() #FUN-920175
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
            # CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')    #FUN-CB0014
             #FUN-CB0014 -------Begin--------
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF cl_null(g_action_flag) THEN LET g_action_flag = 'main' END IF #MOD-D50257 ADD
               CASE g_action_flag
                  WHEN 'main'
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmn),'','')
                  WHEN 'info_list'
                     LET page = f.FindNode("Page","page4")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmm_1),'','')
               END CASE
               LET g_action_choice = NULL
             #FUN-CB0014 -------End---------
            END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL t540sub_y_upd(g_pmm.pmm01,g_action_choice)      #CALL 原確認的 update 段
                 CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-730012   #CHI-740014
                 CALL t540_show() #FUN-730012   #CHI-740014
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN
                    IF aws_efapp_getnextforminfo() THEN
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                       IF NOT cl_null(g_argv1) THEN
                          CALL t540_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,                              confirm, undo_confirm, easyflow_approval, triangletrade, undo_release, release_po,                              modify_status, special_description, sub, vender, aps_related_data, b_more, b_more2,                               m_item_supplierr, purchase_price, icd_maintain_product                             ,memo            #TQC-B40210 add memo                              ")  #TQC-740281 #FUN-A60055 add:b_more, b_more2, m_item_supplierr, purchase_price #FUN-D20025 add undo_void
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_pmm.pmm25 = 'R'
                      DISPLAY BY NAME g_pmm.pmm25
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                         IF NOT cl_null(g_argv1) THEN
                            CALL t540_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,                               confirm, undo_confirm, easyflow_approval, triangletrade, undo_release,                                release_po, modify_status, special_description, sub, vender, aps_related_data,                                b_more, b_more2, m_item_supplierr, purchase_price, icd_maintain_product                              ,memo            #TQC-B40210 add memo                                                             ")  #TQC-740281 #FUN-A60055 add:b_more, b_more2, m_item_supplierr, purchase_price #FUN-D20025 add undo_void
                                 RETURNING g_laststage
                         ELSE
                            EXIT WHILE
                         END IF
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
        #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmm.pmm01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmm01"
                 LET g_doc.value1 = g_pmm.pmm01
                 CALL cl_doc()
               END IF
         END IF
         #@WHEN GPM規範顯示
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmn[l_ac].pmn04 END IF
              LET l_supplierid = g_pmm.pmm09
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmn[l_ac].pmn04 END IF
              LET l_supplierid = g_pmm.pmm09
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #APS相關資料
         WHEN "aps_related_data"
               IF cl_chk_act_auth() THEN
                  CALL t540_aps()
               END IF

        #DEV-D30026-----add----begin------------
         WHEN "barcode_gen"     #條碼產生
               IF cl_chk_act_auth() THEN
                  #CALL t540_barcode_gen()                   #DEV-D30045--mark
                  CALL t540sub_barcode_gen(g_pmm.pmm01,'Y')  #DEV-D30045--mod
               END IF

         WHEN "barcode_query"   #條碼查詢
               IF cl_chk_act_auth() THEN
                  LET l_sql = "abaq100 '",g_pmm.pmm01,"' "
                  CALL cl_cmdrun_wait(l_sql)
               END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                #DEV-D30045--mark--begin
                #IF g_pmm.pmm01 IS NULL THEN
                #   CALL cl_err('',-400,0)
                #ELSE
                #   CASE
                #      WHEN g_prog[1,7] = "apmt540"
                #         LET g_msg=' ibb03="',g_pmm.pmm01 CLIPPED,'"'
                #         LET g_cmd = "abar100",
                #             " '",g_today CLIPPED,"' ''",
                #             " '",g_lang CLIPPED,"' 'Y' '' '1'",
                #             " '' '' '' '' ",
                #             " '",g_msg CLIPPED,"' ",
                #             " 'A' 'F' '1'"
                #      WHEN g_prog[1,7] = "apmt590"
                #         LET g_msg=' ibb03="',g_pmm.pmm01 CLIPPED,'"'
                #         LET g_cmd = "abar100",
                #             " '",g_today CLIPPED,"' ''",
                #             " '",g_lang CLIPPED,"' 'Y' '' '1'",
                #             " '' '' '' '' ",
                #             " '",g_msg CLIPPED,"' ",
                #             " 'A' 'G' '1'"            
                #   END CASE
                #   CALL cl_cmdrun_wait(g_cmd)
                #END IF
                #DEV-D30045--mark--end
                CALL t540_barcode_out() #DEV-D30045--add
             END IF
        #DEV-D30026--add--end-------------------
 
#FUN-A60035 ---MARK BEGIN
#&ifdef SLK
##FUN-A50054 --Begin
#         WHEN "style_detail"
#            IF l_ac>0 THEN
#               CALL s_detail(g_prog,g_pmm.pmm01,g_pmn[l_ac].pmn02,g_pmn[l_ac].pmn04,'Y')
#               RETURNING g_pmn[l_ac].pmn20
#            END IF
##FUN-A50054 --End
#&endif
#FUN-A60035 ---MARK END
      END CASE
   END WHILE
   CLOSE t540_cs
 
END FUNCTION
 
FUNCTION t540_a()
   DEFINE l_chr             LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE li_result         LIKE type_file.num5    #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE l_pmmplant_desc   LIKE azp_file.azp02    #NO.FUN-960130
 
   IF s_shut(0) THEN RETURN END IF
  #IF g_sma.sma45 matches'[Nn]' THEN           #採購單不可直接輸入 #MOD-D10041 mark           
   IF g_sma.sma45 matches'[Nn]' AND (g_argv3 != 'SUB' OR cl_null(g_argv3)) THEN  #採購單不可直接輸入 #MOD-D10041 add
      CALL cl_err(g_sma.sma45,'mfg0034',1)
      RETURN
   END IF
   MESSAGE ""
   CLEAR FORM                                  # 清螢幕欄位內容
     CALL g_pmn.clear()
   INITIALIZE g_pmm.* LIKE pmm_file.*
   INITIALIZE g_pmm_o.* LIKE pmm_file.*
   INITIALIZE g_pmm_t.* LIKE pmm_file.* #NO:7442
   IF g_ydate IS NULL THEN
        LET g_pmm.pmm01 = NULL
        LET g_pmm.pmm04 = g_today               #採購日期
   ELSE                                         #使用上筆資料值
        LET g_pmm.pmm01 = g_sheet               #單別
        LET g_pmm.pmm04 = g_ydate               #收貨日期
   END IF
   CALL s_get_bookno(YEAR(g_pmm.pmm04))             #MOD-9C0401 add
        RETURNING g_flag,g_bookno1,g_bookno2        #MOD-9C0401 add
   SELECT azn02 INTO g_pmm.pmm31
     FROM azn_file WHERE azn01 = g_pmm.pmm04
   LET g_pmm01_t = NULL
   IF cl_null(g_argv3) THEN LET g_argv3 = 'REG'  END IF
   LET g_pmm.pmm02 = g_argv3     #單號性質
   LET g_pmm.pmm03 = 0
   LET g_pmm.pmm12 = g_user
   LET g_pmm.pmm13 = g_grup     #No.B420
   CALL t540_peo('d','1',g_pmm.pmm12)
   IF NOT cl_null(g_errno) THEN
      LET g_pmm.pmm12 = ''
   END IF
 
   CALL t540_dep('d','1',g_pmm.pmm13)
   IF NOT cl_null(g_errno) THEN
      LET g_pmm.pmm13 = ''
   END IF
   LET g_pmm.pmm22 = g_aza.aza17 #No.B420
   LET g_pmm.pmm18 = 'N'
   LET g_pmm.pmm25 = '0'         #開立
   LET g_pmm.pmm27 = g_today
  #LET g_pmm.pmm30 = 'N'         #MOD-C10015 mark pmm30
   LET g_pmm.pmm40 = 0           #未稅總金額
   LET g_pmm.pmm40t = 0          #含稅總金額
   LET g_pmm.pmm401= 0           #代買總金額
   LET g_pmm.pmm42 = 1           #匯率
   LET g_pmm.pmm43 = 0           #稅率
   LET g_pmm.pmm44 = '1'         #扣抵區分   bugno:5389
   IF g_argv3 = 'SUB' THEN 
      LET g_pmm.pmm45 = 'N'       
   ELSE
      LET g_pmm.pmm45 = 'Y'       
   END IF
   LET g_pmm.pmm46 = 0           #預付比率
   LET g_pmm.pmm47 = 0           #預付金額
   LET g_pmm.pmm48 = 0           #已結帳金額
   LET g_pmm.pmm905= 'N'         #No.MOD-490282
   LET g_pmm.pmmdays = 0         #列印次數
   LET g_pmm.pmmprno = 0         #列印次數
   LET g_pmm.pmmsmax = 0         #己簽順序
   LET g_pmm.pmmsseq = 0         #應簽順序
   LET g_pmm.pmmprsw = 'Y'
   LET l_tmp.prt   = 'N'
   LET  g_pmm.pmmmksg = 'N'
   LET  g_pmm.pmmpos = 'N'   #FUN-960130
   LET  g_pmm.pmmcont = ''   #FUN-960130
   CALL s_pmmsta('pmm',g_pmm.pmm25,g_pmm.pmm18,g_pmm.pmmmksg)
          RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc3
   LET g_pmm.pmmplant=g_plant
   LET g_pmm.pmmlegal=g_legal
   LET g_pmm.pmm51 = '1'           
   LET g_pmm.pmm52 = g_pmm.pmmplant
   SELECT azp02 INTO l_pmmplant_desc FROM azp_file WHERE azp01 = g_pmm.pmmplant
   DISPLAY g_plant,l_pmmplant_desc,l_pmmplant_desc
        TO pmmplant,pmmplant_desc,pmm52_desc
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_pmm.pmmacti ='Y'                   #有效的資料
       LET g_pmm.pmmuser = g_user
       LET g_pmm.pmmoriu = g_user #FUN-980030
       LET g_pmm.pmmorig = g_grup #FUN-980030
       LET g_data_plant = g_plant #FUN-980030
       LET g_pmm.pmmgrup = g_grup               #使用者所屬群
       LET g_pmm.pmmdate = g_today
       LET g_pmm.pmmcrat = g_today              #NO.FUN-960130
       LET g_pmm.pmm909 = "1"         #No.FUN-630006
       CALL t540_i("a")                      # 各欄位輸入
       IF INT_FLAG THEN                         # 若按了DEL鍵
          INITIALIZE g_pmm.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,1)   #MOD-640492 0->1
          CLEAR FORM
          CALL g_pmn.clear()
          EXIT WHILE
       END IF
       IF cl_null(g_pmm.pmm01) THEN           # KEY 不可空白
             CONTINUE WHILE
       END IF
       IF g_pmm.pmm02 = 'TAP' THEN
          LET g_pmm.pmm901= 'Y'         #多角貿易採購單
          LET g_pmm.pmm902= 'N'         #最終採購單否
          LET g_pmm.pmm905= 'N'         #多角貿易拋轉否
          LET g_pmm.pmm906= 'Y'         #多角貿易來源採購單否
       ELSE
          LET g_pmm.pmm901= 'N'         #多角貿易採購單
          LET g_pmm.pmm902= ' '         #最終採購單否
          LET g_pmm.pmm905= 'N'         #多角貿易拋轉否  #BUG
          LET g_pmm.pmm906= ' '         #多角貿易來源採購單否
       END IF
       DISPLAY BY NAME g_pmm.pmm905     #No.7920
       BEGIN WORK #No:7857
        IF g_prog='aict040' THEN LET g_chr1='A' ELSE LET g_chr1='2' END IF   #TQC-9B0191
        CALL s_auto_assign_no("apm",g_pmm.pmm01,g_pmm.pmm04,g_chr1,"pmm_file","pmm01","","","") #TQC-9B0191
             RETURNING li_result,g_pmm.pmm01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_pmm.pmm01
          INSERT INTO pmm_file VALUES(g_pmm.*)       # DISK WRITE
          LET g_ydate = g_pmm.pmm04           #備份上一筆交貨日期
          LET g_sheet = s_get_doc_no(g_pmm.pmm01)       #No.FUN-540027
          IF SQLCA.sqlcode THEN
#            ROLLBACK WORK #No:7857   #MOD-B70246 mark
             CALL cl_err3("ins","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
             ROLLBACK WORK            #MOD-B70246 
             CONTINUE WHILE
          ELSE
             COMMIT WORK #No:7857
             CALL cl_flow_notify(g_pmm.pmm01,'I')
             SELECT pmm01 INTO g_pmm.pmm01 FROM pmm_file
                      WHERE pmm01 = g_pmm.pmm01
             ###### 新增多角貿易功能
             IF g_pmm.pmm901='Y' THEN    #多角貿易
                CALL t540_v()
             END IF
 
             LET g_rec_b = 0   #FUN-810045
             CALL g_pmn.clear()
             IF NOT cl_null(g_pmm.pmm05) THEN #BY 專案管理
                CALL t540_pml_process()   #add by Carol:00/02/15
             END IF
 
             #單據別有做預管控管時，才顯示預算相關欄位 預算/部門/科目一
             CALL cl_set_comp_visible("pmn67,pmn40",g_smy.smy59='Y')        #No.FUN-830161
             #單據別有做預算控管且有使用多套帳時才顯示科目二
             CALL cl_set_comp_visible("pmn401",g_smy.smy59='Y' AND g_aza.aza63='Y')
 
             CALL t540_b()
             LET g_pmm_t.* = g_pmm.*                # 保存上筆資料
             LET g_pmm_o.* = g_pmm.*                # 保存上筆資料
             IF NOT cl_null(g_pmm.pmm01) THEN       #TQC-C70068
                CALL t540_sign('a') 
             END IF                                 #TQC-C70068
          END IF
 
          IF NOT cl_null(g_pmm.pmm01)
             AND g_smy.smydmy4='Y'
             AND g_smy.smyapr <> 'Y'                #確認  #FUN-640184
          THEN
             LET g_action_choice = "insert"      #FUN-640184
 
             CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                CALL t540sub_y_upd(g_pmm.pmm01,g_action_choice)       #CALL 原確認的 update 段
                CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* #FUN-730012
                CALL t540_show() #FUN-730012
             END IF
          END IF
          IF NOT cl_null(g_pmm.pmm01)  THEN
               CALL t540_prt()
          END IF
          EXIT WHILE
      END WHILE
#FUN-B90103--------------start--------------
#FUN-B90103----------------end--------------
END FUNCTION
 
FUNCTION t540_i(p_cmd)
      DEFINE
           p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
           l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(60)
           l_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
           l_buf           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(20)
           l_n             LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
DEFINE l_sfb82     LIKE sfb_file.sfb82  #NO.FUN-5A0193
DEFINE l_sfb100    LIKE sfb_file.sfb100 #NO.FUN-5A0193
DEFINE l_t         LIKE smy_file.smyslip,  #FUN-7C0004
       l_smy53     LIKE smy_file.smy53
DEFINE l_count     LIKE type_file.num5        #TQC-960196 
DEFINE l_ged02     LIKE ged_file.ged02        #TQC-960196
DEFINE l_slip      LIKE smy_file.smyslip      #No.FUN-980038 
DEFINE l_pmm02     LIKE pmm_file.pmm02        #No.FUN-980038
DEFINE l_cnt       LIKE type_file.num5   #MOD-9B0154
DEFINE l_pmn68     LIKE pmn_file.pmn68   #MOD-9B0154
DEFINE l_pom09     LIKE pom_file.pom09   #MOD-9B0154
#MOD-B30413 add --start--
DEFINE l_pmn01     LIKE pmn_file.pmn01
DEFINE l_pmn02     LIKE pmn_file.pmn02
DEFINE l_pmn65     LIKE pmn_file.pmn65
DEFINE l_pmn04     LIKE pmn_file.pmn04
DEFINE l_pmn87     LIKE pmn_file.pmn87
DEFINE l_pmn86     LIKE pmn_file.pmn86
DEFINE l_pmn31     LIKE pmn_file.pmn31
DEFINE l_pmn31t    LIKE pmn_file.pmn31t
DEFINE l_pmn41     LIKE pmn_file.pmn41
DEFINE l_pmn43     LIKE pmn_file.pmn43
DEFINE l_pmn88     LIKE pmn_file.pmn88
DEFINE l_pmn88t    LIKE pmn_file.pmn88t
DEFINE l_pmn44     LIKE pmn_file.pmn44 
DEFINE l_ecm04     LIKE ecm_file.ecm04
DEFINE l_pmn90     LIKE pmn_file.pmn90 
DEFINE l_pmn73     LIKE pmn_file.pmn73
DEFINE l_pmn74     LIKE pmn_file.pmn74
#MOD-B30413 add --end--
#CHI-B80082 -- begin --
DEFINE l_pmn012    LIKE pmn_file.pmn012
DEFINE l_pmn18     LIKE pmn_file.pmn18
DEFINE l_ima915    LIKE ima_file.ima915
#CHI-B80082 -- end --
DEFINE l_pmc914    LIKE pmc_file.pmc914   #MOD-BC0303 add
DEFINE l_pmm42     LIKE pmm_file.pmm42    #TQC-C30164 
DEFINE l_pom21     LIKE pom_file.pom21    #MOD-C30797 add        
DEFINE l_pom22     LIKE pom_file.pom22    #MOD-C30797 add
DEFINE l_gec07     LIKE gec_file.gec07    #CHI-CB0008 add
DEFINE l_conu      LIKE type_file.chr1    #CHI-CB0008 add

        CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
        INPUT BY NAME   g_pmm.pmmoriu,g_pmm.pmmorig,#87/04/21 modify g_pmm.pmm03不可輸入
            g_pmm.pmm01,g_pmm.pmm03,g_pmm.pmm04,g_pmm.pmm02,g_pmm.pmm09,
            g_pmm.pmm05,g_pmm.pmm18,g_pmm.pmm909,                 #No.FUN-630006    #FUN-810045 add pmm05  #No.FUN-830161
            g_pmm.pmm20,g_pmm.pmm41,g_pmm.pmm10,g_pmm.pmm11,
            g_pmm.pmm12,g_pmm.pmm13,g_pmm.pmm21,g_pmm.pmm43,
            g_pmm.pmm22,g_pmm.pmm42,g_pmm.pmm40,g_pmm.pmm40t,  #No.FUN-610018
            g_pmm.pmm45,g_pmm.pmm905,g_pmm.pmm99,g_pmm.pmmmksg,g_pmm.pmm25,
           #g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,g_pmm.pmm30,   #MOD-C10015 mark g_pmm.pmm30
            g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,               #MOD-C10015 mark g_pmm.pmm30
            g_pmm.pmm44,
            g_pmm.pmm51,g_pmm.pmm52,g_pmm.pmm53,              #NO.FUN-960130
            g_pmm.pmmud01,g_pmm.pmmud02,g_pmm.pmmud03,g_pmm.pmmud04,g_pmm.pmmud05,
            g_pmm.pmmud06,g_pmm.pmmud07,g_pmm.pmmud08,g_pmm.pmmud09,g_pmm.pmmud10,
            g_pmm.pmmud11,g_pmm.pmmud12,g_pmm.pmmud13,g_pmm.pmmud14,g_pmm.pmmud15,
            g_pmm.pmmuser,g_pmm.pmmgrup,g_pmm.pmmmodu,g_pmm.pmmdate,
            g_pmm.pmmacti,g_pmm.pmmcrat  #NO.FUN-960130-add pmmcrat
            WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t540_set_entry(p_cmd)
            CALL t540_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("pmm01")
 
         BEFORE FIELD pmm01
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
               NEXT FIELD pmm04
            END IF
 
         AFTER FIELD pmm01
            IF NOT cl_null(g_pmm.pmm01) OR (g_pmm.pmm01!=g_pmm_t.pmm01) THEN #FUN-550038
               LET g_t1=s_get_doc_no(g_pmm.pmm01)
               #得到該單別對應的屬性群組
               IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
                  #讀取smy_file中指定作業對應的默認屬性群組
                  SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
                  #刷新界面顯示
                  CALL t540_refresh_detail()
               ELSE
                  LET lg_smy62 = ''
               END IF
            IF g_prog='aict040' THEN LET g_chr1='A' ELSE LET g_chr1='2' END IF   #TQC-9B0191
            CALL s_check_no("apm",g_pmm.pmm01,g_pmm01_t,g_chr1,"pmm_file","pmm01","") #TQC-9B0191
              RETURNING li_result,g_pmm.pmm01
            DISPLAY BY NAME g_pmm.pmm01
            IF (NOT li_result) THEN
              NEXT FIELD pmm01
            END IF
            IF cl_null(g_pmm01_t) THEN
               CALL s_get_doc_no(g_pmm.pmm01) RETURNING l_slip          
               SELECT smy72 INTO l_pmm02 FROM smy_file                                                                      
                WHERE smyslip = l_slip                                                                                          
               IF NOT cl_null(l_pmm02) 
                  AND l_pmm02 = 'REG' OR l_pmm02 = 'EXP' OR l_pmm02 = 'CAP'   #TQC-C80166 add
                   OR l_pmm02 = 'TRI' OR l_pmm02 = 'TAP' THEN                 #TQC-C80166 add
                  LET g_pmm.pmm02 = l_pmm02
                  DISPLAY BY NAME g_pmm.pmm02
               END IF
            END IF
                IF cl_null(g_pmm_t.pmm01) OR (g_pmm.pmm01 != g_pmm_t.pmm01 ) THEN
                   LET  g_pmm.pmmmksg = g_smy.smyapr
                   LET  g_pmm.pmmsign = g_smy.smysign
                   LET  g_pmm.pmmprsw = 'Y' #g_smy.smyprint  #96-06-18 #簽核否
                   DISPLAY BY NAME g_pmm.pmmmksg
                   display g_pmm.pmmmksg
                END IF
           ELSE
               IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                  LET lg_smy62 = ''
                  CALL t540_refresh_detail()
               END IF
           END IF
           CALL t540_set_no_entry(p_cmd)    #NO.TQC-750115
 
         AFTER FIELD pmm02  #單據性質
           IF (NOT cl_null(g_pmm.pmm02)) THEN
               IF g_pmm.pmm02 != 'REG' AND g_pmm.pmm02 != 'EXP' AND
                  g_pmm.pmm02 != 'CAP' AND g_pmm.pmm02 != 'SUB' AND
                  g_pmm.pmm02 != 'TAP'
                  THEN
                   CALL cl_err('','apm-096',1)       #TQC-A30054
                  LET g_pmm.pmm02 = g_pmm_o.pmm02
                  DISPLAY BY NAME g_pmm.pmm02
                  NEXT FIELD pmm02
               END IF
               LET g_pmm_o.pmm02 = g_pmm.pmm02
 
                            IF g_pmm.pmm02 = 'TAP' THEN
                             LET g_pmm.pmm901= 'Y'         #多角貿易採購單
                               LET g_pmm.pmm902= 'N'         #最終採購單否
                               LET g_pmm.pmm905= 'N'         #多角貿易拋轉否
                               LET g_pmm.pmm906= 'Y'         #多角貿易來源採購單否
                            ELSE
                             LET g_pmm.pmm901= 'N'         #多角貿易採購單
                               LET g_pmm.pmm902= ' '         #最終採購單否
                               LET g_pmm.pmm905= 'N'         #多角貿易拋轉否 #TQC-740044
                               LET g_pmm.pmm906= ' '         #多角貿易來源採購單否
                            END IF
                            DISPLAY BY NAME g_pmm.pmm905     #No.7920
           END IF
 
         AFTER FIELD pmm909
            IF g_pmm.pmm909 = '8' THEN
               CALL cl_getmsg('apm1027',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
               CALL cl_getmsg('apm1028',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
            END IF
 
         AFTER FIELD pmm04       #採購日期(預設會計年度/期間)
           IF NOT cl_null(g_pmm.pmm04) THEN
              IF cl_null(g_pmm_o.pmm04) OR (g_pmm_o.pmm04 != g_pmm.pmm04) THEN
                  SELECT azn02,azn04 INTO g_pmm.pmm31,g_pmm.pmm32
                    FROM azn_file WHERE azn01 = g_pmm.pmm04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","azn_file",g_pmm.pmm04,"","mfg0027","","",1)  #No.FUN-660129
                     LET g_pmm.pmm04 = g_pmm_o.pmm04
                     DISPLAY BY NAME g_pmm.pmm04
                     NEXT FIELD pmm04
                   END IF
               END IF
               CALL s_get_bookno(YEAR(g_pmm.pmm04))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_pmm.pmm04,'aoo-081',1)
                  NEXT FIELD pmm04
               END IF
               #MOD-B30347---add--str--
               CALL t540_chk_pon19(g_pmm.pmm01,g_pmm.pmm04) RETURNING l_flag
               IF NOT l_flag THEN 
                  CALL cl_err('','apm-815',1)
                  LET g_pmm.pmm04 = g_pmm_o.pmm04
                  DISPLAY BY NAME g_pmm.pmm04
                  NEXT FIELD pmm04
               END IF
               #MOD-B30347---add--end--
               #TQC-B90215--begin
               IF g_aza.aza17 != g_pmm.pmm22 THEN
                  IF NOT cl_null(g_pmm_o.pmm04) AND g_pmm_o.pmm04 != g_pmm.pmm04 THEN
                     IF cl_confirm('apm-701') THEN
                        CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904)
                              RETURNING g_pmm.pmm42
                        DISPLAY BY NAME g_pmm.pmm42
                     END IF
                  END IF
               END IF
               #TQC-B90215--end         
           END IF
           LET g_pmm_o.pmm04 = g_pmm.pmm04
 
            AFTER FIELD pmm05
              IF NOT cl_null(g_pmm.pmm05) THEN
                 SELECT COUNT(*) INTO g_cnt FROM pja_file
                  WHERE pja01 = g_pmm.pmm05
                    AND pjaacti = 'Y'
                    AND pjaclose='N'             #FUN-960038 
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_pmm.pmm05,'asf-984',0)
                    NEXT FIELD pmm05
                 END IF
              END IF
 
            AFTER FIELD pmm09     #供應商
               IF NOT cl_null(g_pmm.pmm09) THEN                               
                  IF NOT cl_null(g_pmm_t.pmm09) AND (g_pmm.pmm09!=g_pmm_t.pmm09) THEN  #TQC-830053
                     IF g_pmm.pmm02 = 'SUB' THEN
                        SELECT sfb82,sfb100 INTO l_sfb82,l_sfb100
                          FROM sfb_file,pmn_file
                         WHERE pmn01 = g_pmm.pmm01
                           AND sfb01 = pmn41
                           AND sfb87 != 'X'
                           AND (pmn43 IS NULL OR pmn43= 0) #MOD-840054 add
                        IF l_sfb100 <> '2' AND NOT cl_null(l_sfb82)   #MOD-850109
                        THEN
                            IF g_pmm.pmm09 <> l_sfb82 THEN
                                CALL cl_err('','apm-038',1)  #MOD-640492 0->1
                                LET g_pmm.pmm09 = g_pmm_o.pmm09
                                DISPLAY BY NAME g_pmm.pmm09
                                NEXT FIELD pmm09
                            END IF
                        END IF
                     END IF
                  END IF  #TQC-830053
                  IF cl_null(g_pmm_o.pmm09) OR (g_pmm_o.pmm09 != g_pmm.pmm09)
                  THEN CALL t540_supplier('a','1',g_pmm.pmm09)     #show 簡稱
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pmm.pmm09,g_errno,1)  #MOD-640492 0->1
                          LET g_pmm.pmm09 = g_pmm_o.pmm09
                          CALL t540_supplier('a','1',g_pmm.pmm09)     #TQC-D50078  add
                          DISPLAY BY NAME g_pmm.pmm09
                          NEXT FIELD pmm09
                       END IF
                       IF p_cmd='u' AND g_pmm.pmm02<>'SUB' THEN
#CHI-B80082 -- mark begin --
                      #SELECT COUNT(*) INTO l_n FROM pmm_file,pmn_file
                      # WHERE pmm01=g_pmm.pmm01
                      #   AND pmn01=pmm01
                      #   AND pmn04 IN (SELECT ima01 FROM ima_file
                      #                  WHERE ima915 IN ('2','3'))
                      #IF l_n > 0 THEN
                      #      CALL cl_err('','apm-281',1)  #MOD-640492 0->1
                      #      LET g_pmm.pmm09 = g_pmm_o.pmm09
                      #      DISPLAY BY NAME g_pmm.pmm09
                      #      CALL t540_supplier('a','1',g_pmm.pmm09)
                      #      NEXT FIELD pmm09
                      #   END IF
#CHI-B80082 -- mark end --
#CHI-B80082 -- begin --

                          #MOD-BC0303 ----- modify start -----
                          LET l_n = 0
                          SELECT COUNT(*) INTO l_n FROM pmn_file
                           WHERE pmn01 = g_pmm.pmm01 AND pmn89 = 'Y'
                          IF l_n > 0 THEN
                             SELECT pmc914 INTO l_pmc914 FROM pmc_file
                               WHERE pmc01 = g_pmm.pmm09
                             IF l_pmc914 = 'N' THEN
                                CALL cl_err(g_pmm.pmm09,'apm1070',1)
                                NEXT FIELD pmm09
                             END IF
                          END IF
                          #MOD-BC0303 ----- modify end -----

                          DECLARE pmn_cur1 CURSOR FOR
                             SELECT pmn012,pmn04,pmn18,pmn41,pmn43 FROM pmn_file
                                WHERE pmn01 = g_pmm.pmm01
                          FOREACH pmn_cur1 INTO l_pmn012,l_pmn04,l_pmn18,l_pmn41,l_pmn43
                             SELECT ima915 INTO l_ima915 FROM ima_file
                                WHERE ima01 = l_pmn04
                             IF l_ima915='2' OR l_ima915='3' THEN
                                CALL t540sub_pmh(l_pmn04,l_pmn41,
                                                 l_pmn43,l_pmn18,l_pmn012,g_pmm.*,g_type)
                                IF NOT cl_null(g_errno) THEN
                                   CALL cl_err(l_pmn04,g_errno,1)
                                   LET g_pmm.pmm09 = g_pmm_o.pmm09
                                   DISPLAY BY NAME g_pmm.pmm09
                                   CALL t540_supplier('a','1',g_pmm.pmm09)
                                   NEXT FIELD pmm09
                                   EXIT FOREACH
                                END IF
                             END IF
                          END FOREACH
#CHI-B80082 -- end --
                        END IF
                        CALL t540_supplier_cd()     #show 出預設值
                        IF g_aza.aza17 = g_pmm.pmm22 THEN   #本幣
                           LET g_pmm.pmm42 = 1
                        ELSE
                           CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) #FUN-640016
                           RETURNING g_pmm.pmm42
                        END IF
                        DISPLAY BY NAME g_pmm.pmm42
                        IF NOT cl_null(g_chr) THEN
                           LET g_pmm.pmm09 = g_pmm_o.pmm09
                           DISPLAY BY NAME g_pmm.pmm09
                           NEXT FIELD pmm09
                        END IF
 
                      #check 單據別如是內部交易，則供應商一定要設定pov，且對應營運中心的客戶也要設定pov
                       LET l_t = s_get_doc_no(g_pmm.pmm01)
                       SELECT smy53 INTO l_smy53 FROM smy_file
                        WHERE smyslip = l_t
                       IF l_smy53 = 'Y' AND NOT cl_null(l_smy53) THEN  #內部交易單據   #TQC-7C0164 add NOT cl_null(smy53)
                         IF NOT t540_chk_pv() THEN
                           LET g_pmm.pmm09 = g_pmm_o.pmm09
                           DISPLAY BY NAME g_pmm.pmm09
                           NEXT FIELD pmm09
                         END IF
                       END IF
                  END IF
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM pmn_file 
                    WHERE pmn01 = g_pmm.pmm01
                  IF l_cnt > 0 THEN
                     DECLARE pmn_cur CURSOR FOR 
                       SELECT pmn68 FROM pmn_file WHERE pmn01=g_pmm.pmm01
                     FOREACH pmn_cur INTO l_pmn68
                       IF NOT cl_null(l_pmn68) THEN
                          LET l_pom09 = ''
                          SELECT pom09 INTO l_pom09 FROM pom_file 
                            WHERE pom01=l_pmn68
                          IF l_pom09 <> g_pmm.pmm09 THEN
                             CALL cl_err(l_pom09,'apm-903',1)   
                             NEXT FIELD pmm09
                          END IF
                       END IF
                     END FOREACH
                  END IF 
               END IF
               LET g_pmm_o.pmm09 = g_pmm.pmm09
               #TQC-BB0165--begin
               IF cl_null(g_pmm.pmm09) THEN
                  DISPLAY ' ' TO pmc03
               END IF
               #TQC-BB0165--begin
 
         AFTER FIELD pmm12       #採購員
              IF NOT cl_null(g_pmm.pmm12) THEN
                  IF cl_null(g_pmm_o.pmm12) OR (g_pmm.pmm12!=g_pmm_o.pmm12 ) THEN
                     CALL t540_peo('a','1',g_pmm.pmm12)
                     IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_pmm.pmm12,g_errno,1)  #MOD-640492 0->1
                         LET g_pmm.pmm12 = g_pmm_o.pmm12
                         DISPLAY BY NAME g_pmm.pmm12
                         NEXT FIELD pmm12
                     END IF
                  END IF
              END IF
              LET g_pmm_o.pmm12 = g_pmm.pmm12
 
              AFTER FIELD pmm13       #採購員
                IF NOT cl_null(g_pmm.pmm13) THEN
                    IF cl_null(g_pmm_o.pmm13) OR (g_pmm.pmm13!=g_pmm_o.pmm13 )
                       THEN CALL t540_dep('a','1',g_pmm.pmm13)
                            IF NOT cl_null(g_errno) THEN
                               CALL cl_err(g_pmm.pmm13,g_errno,1)  #MOD-640492 0->1
                               LET g_pmm.pmm13 = g_pmm_o.pmm13
                               DISPLAY BY NAME g_pmm.pmm13
                               NEXT FIELD pmm13
                            END IF
                    END IF
                END IF
                LET g_pmm_o.pmm13 = g_pmm.pmm13
 
      AFTER FIELD pmm16
         IF NOT cl_null(g_pmm.pmm16) THEN 
            SELECT COUNT(*) INTO l_count FROM ged_file
             WHERE ged01 = g_pmm.pmm16
            IF l_count < 1 THEN 
               CALL cl_err('','axm-309',0)
               NEXT FIELD pmm16
            ELSE
            	 SELECT ged02 INTO l_ged02 FROM ged_file
            	  WHERE ged01 = g_pmm.pmm16
            	 DISPLAY l_ged02 TO FORMONLY.ged02     
            END IF  
         ELSE
         	  DISPLAY ''  TO FORMONLY.ged02    
         END IF 
         LET g_pmm_o.pmm16 = g_pmm.pmm16 
 
          AFTER FIELD pmm41                       #價格條件
              IF NOT cl_null(g_pmm.pmm41) THEN
                 SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmm.pmm41 #FUN-930113
                 IF STATUS THEN
                    CALL cl_err3("sel","pnz_file",g_pmm.pmm41,"",STATUS,"","sel pnz:",1)  #No.FUN-660129 #FUN-930113
                    NEXT FIELD pmm41
                 END IF
                 DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113
              END IF
 
          AFTER FIELD pmm20                       #付款條件
                IF NOT cl_null(g_pmm.pmm20) THEN
                    CALL t540_pmm20('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmm.pmm20,g_errno,1) #MOD-640492 0->1
                       LET g_pmm.pmm20 = g_pmm_o.pmm20
                       DISPLAY BY NAME g_pmm.pmm20
                       NEXT FIELD pmm20
                    END IF
                END IF
                LET g_pmm_o.pmm20 = g_pmm.pmm20
 
         AFTER FIELD pmm21                       #稅別條件
                IF NOT cl_null(g_pmm.pmm21) THEN
                    IF (g_pmm_o.pmm21 IS NULL) OR (g_pmm.pmm21 != g_pmm_o.pmm21)
                     THEN CALL t540_pmm21('a')      #No.MOD-930045
                          IF NOT cl_null(g_errno) THEN
                             CALL cl_err(g_pmm.pmm21,g_errno,1)  #MOD-640492 0->1
                             LET g_pmm.pmm21 = g_pmm_o.pmm21
                             DISPLAY BY NAME g_pmm.pmm21
                             NEXT FIELD pmm21
                          END IF
                     END IF
                     #MOD-C30797 ----- add start -----
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM pmn_file WHERE pmn01 = g_pmm.pmm01
                     IF l_cnt > 0 THEN
                        DECLARE pmn_cur3 CURSOR FOR SELECT pmn68 FROM pmn_file WHERE pmn01=g_pmm.pmm01
                        FOREACH pmn_cur3 INTO l_pmn68
                          IF NOT cl_null(l_pmn68) THEN
                             LET l_pom21 = ''
                             SELECT pom21 INTO l_pom21 FROM pom_file WHERE pom01=l_pmn68
                             IF l_pom21 <> g_pmm.pmm21 THEN
                                CALL cl_err(l_pom21,'apm1074',1)
                                NEXT FIELD pmm21
                             END IF
                          END IF
                        END FOREACH
                     END IF
                     #MOD-C30797 ----- add end -----
                END IF
                LET g_pmm_o.pmm21 = g_pmm.pmm21
 
          AFTER FIELD pmm10                      #送貨地址
                IF NOT cl_null(g_pmm.pmm10) THEN
                   IF cl_null(g_pmm_o.pmm10) OR (g_pmm_o.pmm10 != g_pmm.pmm10)
                   THEN CALL t540_pmm10(g_pmm.pmm10)
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pmm.pmm10,g_errno,1)  #MOD-640492 0->1
                           LET g_pmm.pmm10 = g_pmm_o.pmm10
                           DISPLAY BY NAME g_pmm_o.pmm10
                           NEXT FIELD pmm10
                        END IF
                   END IF
                END IF
                LET  g_pmm_o.pmm10 = g_pmm.pmm10
 
          AFTER FIELD pmm11                      #發票地址
                IF NOT cl_null(g_pmm.pmm11) THEN
                   IF cl_null(g_pmm_o.pmm11) OR
                      (g_pmm_o.pmm11 != g_pmm.pmm11) THEN
                      CALL t540_pmm10(g_pmm.pmm11)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_pmm.pmm11,g_errno,1)  #MOD-640492 0->1
                         LET g_pmm.pmm11 = g_pmm_o.pmm11
                         DISPLAY BY NAME g_pmm_o.pmm11
                         NEXT FIELD pmm11
                      END IF
                   END IF
                END IF
                LET  g_pmm_o.pmm11 = g_pmm.pmm11
 
         AFTER FIELD pmm22                      #幣別
               IF NOT cl_null(g_pmm.pmm22) THEN
                 IF cl_null(g_pmm_o.pmm22) OR (g_pmm_o.pmm22 != g_pmm.pmm22)
                 THEN CALL t540_pmm22()
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm22,g_errno,1)  #MOD-640492 0->1
                        LET g_pmm.pmm22 = g_pmm_o.pmm22
                        DISPLAY BY NAME g_pmm.pmm22
                        NEXT FIELD pmm22
                      END IF
                      #TQC-D50078--add--str--
                      DECLARE pmn_cur1_1 CURSOR FOR
                       SELECT pmn012,pmn04,pmn18,pmn41,pmn43 FROM pmn_file      
                        WHERE pmn01 = g_pmm.pmm01
                      FOREACH pmn_cur1_1 INTO l_pmn012,l_pmn04,l_pmn18,l_pmn41,l_pmn43       
                         SELECT ima915 INTO l_ima915 FROM ima_file
                          WHERE ima01 = l_pmn04
                         IF l_ima915='2' OR l_ima915='3' THEN
                            CALL t540sub_pmh(l_pmn04,l_pmn41,
                            l_pmn43,l_pmn18,l_pmn012,g_pmm.*,g_type)           
                            IF NOT cl_null(g_errno) THEN
                                CALL cl_err(l_pmn04,g_errno,1)
                                LET g_pmm.pmm22 = g_pmm_o.pmm22
                                DISPLAY BY NAME g_pmm.pmm22
                                NEXT FIELD pmm22
                                EXIT FOREACH
                             END IF
                        END IF
                      END FOREACH
                      #TQC-D50078--add--end--
                      IF g_aza.aza17 = g_pmm.pmm22 THEN   #本幣
                         LET g_pmm.pmm42 = 1
                      ELSE
                         CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) #FUN-640016
                              RETURNING g_pmm.pmm42
                      END IF
                      DISPLAY BY NAME g_pmm.pmm42
                 END IF
                 #MOD-C30797 ----- add start -----
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM pmn_file WHERE pmn01 = g_pmm.pmm01
                 IF l_cnt > 0 THEN
                    DECLARE pmn_cur4 CURSOR FOR SELECT pmn68 FROM pmn_file WHERE pmn01=g_pmm.pmm01
                    FOREACH pmn_cur4 INTO l_pmn68
                      IF NOT cl_null(l_pmn68) THEN
                         LET l_pom22 = ''
                         SELECT pom22 INTO l_pom22 FROM pom_file WHERE pom01=l_pmn68
                         IF l_pom22 <> g_pmm.pmm22 THEN
                            CALL cl_err(l_pom22,'apm1075',1)
                            NEXT FIELD pmm22
                         END IF
                      END IF
                    END FOREACH
                 END IF
                 #MOD-C30797 ----- add end -----
              END IF
              LET g_pmm_o.pmm22 = g_pmm.pmm22
 
         AFTER FIELD pmm42                      #匯率
              IF NOT cl_null(g_pmm.pmm42) THEN
                 IF g_pmm.pmm42 <= 0 THEN
                     CALL cl_err(g_pmm.pmm42,'mfg0013',1)  #MOD-640492 0->1
                     LET g_pmm.pmm42 = g_pmm_o.pmm42
                     DISPLAY BY NAME g_pmm.pmm42
                     NEXT FIELD pmm42
                 END IF
 
                 IF g_pmm.pmm22 =g_aza.aza17 THEN
                    LET g_pmm.pmm42 =1
                    DISPLAY g_pmm.pmm42  TO pmm42
                    END IF
#TQC-C30164 add begin               
                  IF g_aza.aza17 != g_pmm.pmm22 THEN
                     CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904)
                        RETURNING l_pmm42
                     IF l_pmm42 <>  g_pmm.pmm42 THEN 
                         IF cl_confirm('apm-702') THEN
                            LET  g_pmm.pmm42 = l_pmm42
                            DISPLAY BY NAME g_pmm.pmm42
                         END IF 
                     END IF 
                  END IF
#TQC-C30164 add end  
              END IF
              LET g_pmm_o.pmm42 = g_pmm.pmm42
 
         AFTER FIELD pmm43          #稅率
              IF cl_null(g_pmm.pmm43) THEN
                  LET g_pmm.pmm43 = 0
                  DISPLAY BY NAME g_pmm.pmm43
              END IF
              IF NOT cl_null(g_pmm.pmm43) AND g_pmm.pmm43 < 0 THEN
                 CALL cl_err(g_pmm.pmm43,'mfg0013',1)  #MOD-640492 0->1
                 LET g_pmm.pmm43 = g_pmm_o.pmm43
                 DISPLAY BY NAME g_pmm.pmm43
                 NEXT FIELD pmm43
              END IF
              LET g_pmm_o.pmm43 = g_pmm.pmm43
 
        AFTER FIELD pmm45                      #可用否
            IF NOT cl_null(g_pmm.pmm45) THEN
                IF g_pmm.pmm45 NOT MATCHES'[YyNn]' THEN
                    CALL cl_err(g_pmm.pmm45,'mfg1002',1)  #MOD-640492 0->1
                    LET g_pmm.pmm45 = g_pmm_o.pmm45
                    DISPLAY BY NAME g_pmm.pmm45
                    NEXT FIELD pmm45
                END IF
            END IF
            LET g_pmm_o.pmm45= g_pmm.pmm45
 
        AFTER FIELD pmmmksg    #簽核否
           IF NOT cl_null(g_pmm.pmmmksg) THEN
               IF g_pmm.pmmmksg NOT MATCHES '[yYnN]' THEN NEXT FIELD pmmmksg END IF
               IF g_pmm.pmmmksg  MATCHES'[Nn]' THEN
                  LET g_pmm.pmmsmax = 0
                  LET g_pmm.pmmsseq = 0
               END IF
               IF g_pmm.pmmmksg MATCHES '[Yy]' THEN
                  LET g_pmm.pmm25 = "0"
                  DISPLAY BY NAME g_pmm.pmm25
                  CALL s_pmmsta('pmm',g_pmm.pmm25,g_pmm.pmm18,g_pmm.pmmmksg)
                                RETURNING g_sta
               END IF
               IF g_pmm.pmmmksg MATCHES '[Nn]' AND g_argv2 !='2' THEN
                  LET g_pmm.pmm25 = "1"
                  DISPLAY BY NAME g_pmm.pmm25
                  CALL s_pmmsta('pmm',g_pmm.pmm25,g_pmm.pmm18,g_pmm.pmmmksg)
                                RETURNING g_sta
                END IF
           END IF
 
##-------------- Genero 其他畫面副程式(sapmt523)加入主程式 ---------------##
       AFTER FIELD pmm14
            IF cl_null(g_pmm.pmm14) THEN    #收貨部門
               DISPLAY ' ' TO FORMONLY.gem02_2
            ELSE
               IF g_pmm_o.pmm14 IS NULL OR
                  (g_pmm.pmm14 != g_pmm_o.pmm14 ) THEN
                   CALL t540_dep('a','2',g_pmm.pmm14)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm14,g_errno,1)  #MOD-640492 0->1
                        LET g_pmm.pmm14 = g_pmm_o.pmm14
                        DISPLAY BY NAME g_pmm_o.pmm14
                        NEXT FIELD pmm14
                    END IF
               END IF
            END IF
            LET g_pmm_o.pmm14 = g_pmm.pmm14
 
       AFTER FIELD pmm15
            IF cl_null(g_pmm.pmm15) THEN    #確認人
               DISPLAY ' ' TO FORMONLY.gen02_2
            ELSE
               IF (g_pmm_o.pmm15 IS NULL) OR
                  (g_pmm.pmm15 != g_pmm_o.pmm15 ) THEN
                   CALL t540_peo('a','2',g_pmm.pmm15)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm15,g_errno,1)  #MOD-640492 0->1
                        LET g_pmm.pmm15 = g_pmm_o.pmm15
                        DISPLAY BY NAME g_pmm_o.pmm15
                        NEXT FIELD pmm15
                    END IF
               END IF
            END IF
            LET g_pmm_o.pmm15 = g_pmm.pmm15
 
       AFTER FIELD pmm17                      #代理商
           IF cl_null(g_pmm.pmm17) THEN
               DISPLAY ' ' TO FORMONLY.pmc03_2
            ELSE IF (g_pmm_o.pmm17 IS NULL) OR
                    (g_pmm.pmm17 != g_pmm_o.pmm17 ) THEN
                    CALL t540_supplier('a','2',g_pmm.pmm17)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmm.pmm17,g_errno,1)  #MOD-640492 0->1
                       LET g_pmm.pmm17 = g_pmm_o.pmm17
                       DISPLAY BY NAME g_pmm_o.pmm17
                       NEXT FIELD pmm17
                    END IF
                 END IF
            END IF
 
      #MOD-C10015 ---mark---str---
      #AFTER FIELD pmm30       #印驗收單
      #    IF cl_null(g_pmm.pmm30 ) OR g_pmm.pmm30 NOT MATCHES'[YyNn]' THEN
      #       CALL cl_err(g_pmm.pmm30,'mfg1002',1)  #MOD-640492 0->1
      #       LET g_pmm.pmm30 = g_pmm_o.pmm30
      #       DISPLAY BY NAME g_pmm.pmm30
      #       NEXT FIELD pmm30
      #    END IF
      #    LET g_pmm_o.pmm30= g_pmm.pmm30
      #MOD-C10015 ---mark---end---
 
        BEFORE FIELD pmm44  #扣抵區分
            IF cl_null(g_pmm.pmm44) THEN
               LET g_pmm.pmm44 = '1'
               DISPLAY BY NAME g_pmm.pmm44
            END IF
 
        AFTER FIELD pmm44   #扣抵區分
            IF NOT cl_null(g_pmm.pmm44)
               AND g_pmm.pmm44 NOT MATCHES '[1234]' THEN #bugno:5389,6374   #MOD-710144
               LET g_pmm.pmm44 = g_pmm_o.pmm44
               DISPLAY BY NAME g_pmm.pmm44
               NEXT FIELD pmm44
            END IF
            LET g_pmm_o.pmm44 = g_pmm.pmm44
        
        AFTER FIELD pmm51
           IF NOT cl_null(g_pmm.pmm51) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_pmm.pmm51<>g_pmm_t.pmm51) THEN
                 IF NOT cl_null(g_pmm.pmm04) AND NOT cl_null(g_pmm.pmm09) THEN
                    CALL t540_upd_pmm21()
                    IF cl_null(g_errno) THEN
                       CALL t540_pmm21('a')
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD pmm51
                    END IF
                 END IF
              END IF
           END IF
        AFTER FIELD pmm53
           IF NOT cl_null(g_pmm.pmm53) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_pmm.pmm53<>g_pmm_t.pmm53) THEN
                 CALL t540_pmm53('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmm.pmm53,g_errno,0)
                    LET g_pmm.pmm53=g_pmm_t.pmm53
                    DISPLAY BY NAME g_pmm.pmm53
                    NEXT FIELD pmm53
                 END IF
              END IF
           END IF
##-------------- Genero 其他畫面副程式(sapmt523)加入主程式 (end)----------##
 
        AFTER FIELD pmmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
            IF INT_FLAG THEN                         # 若按了DEL鍵
 
               EXIT INPUT
            END IF
            IF cl_null(g_pmm.pmm31) THEN 
               SELECT azn02 INTO g_pmm.pmm31 FROM azn_file
                WHERE azn01 = g_pmm.pmm04
            END IF
            IF cl_null(g_pmm.pmm32) THEN 
               SELECT azn04 INTO g_pmm.pmm32 FROM azn_file
                WHERE azn01 = g_pmm.pmm04
            END IF
#TQC-C30164 add begin
            IF p_cmd='u' THEN
               IF g_aza.aza17 != g_pmm.pmm22 THEN
                  CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904)
                     RETURNING l_pmm42
                  IF l_pmm42 <>  g_pmm.pmm42 THEN 
                      IF cl_confirm('apm-702') THEN
                         LET  g_pmm.pmm42 = l_pmm42
                         DISPLAY BY NAME g_pmm.pmm42
                      END IF 
                  END IF 
               END IF           
            END IF 
#TQC-C30164 add end
            #TQC-C10021 add begin------------------------------
            #IF p_cmd='u' AND g_pmm.pmm02<>'SUB' THEN
            IF p_cmd='u' THEN    #TQC-C10061
               DECLARE pmn_cur2 CURSOR FOR
                  SELECT pmn012,pmn04,pmn18,pmn41,pmn43 FROM pmn_file
                     WHERE pmn01 = g_pmm.pmm01
               FOREACH pmn_cur2 INTO l_pmn012,l_pmn04,l_pmn18,l_pmn41,l_pmn43
                  SELECT ima915 INTO l_ima915 FROM ima_file
                     WHERE ima01 = l_pmn04
                  IF l_ima915='2' OR l_ima915='3' THEN
                     CALL t540sub_pmh(l_pmn04,l_pmn41,
                                      l_pmn43,l_pmn18,l_pmn012,g_pmm.*,g_type)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(l_pmn04,g_errno,1)
                        LET g_pmm.pmm09 = g_pmm_o.pmm09
                        DISPLAY BY NAME g_pmm.pmm09
                        CALL t540_supplier('a','1',g_pmm.pmm09)
                        NEXT FIELD pmm09
                        EXIT FOREACH
                     END IF
                  END IF
               END FOREACH
            END IF
            #TQC-C10021 add end---------------------------------

            #MOD-B30413 add --start--
            #CHI-CB0008 mark begin---
            #IF g_pmm.pmm09 != g_pmm_t.pmm09 OR g_pmm.pmm22 != g_pmm_t.pmm22 OR g_pmm.pmm04 != g_pmm_t.pmm04 OR g_pmm.pmm21 != g_pmm_t.pmm21 OR g_pmm.pmm43 != g_pmm_t.pmm43
            #   OR g_pmm.pmm41 != g_pmm_t.pmm41 THEN  #MOD-C40110 add
            #CHI-CB0008 mark end-----

            #CHI-CB0008 add begin---
            LET l_conu = NULL
            SELECT gec07 INTO l_gec07
                FROM gec_file
               WHERE gec01 = g_pmm_t.pmm21
                 AND gec011='1'  #進項
            IF g_pmm.pmm09 != g_pmm_t.pmm09 OR g_pmm.pmm22 != g_pmm_t.pmm22 OR g_pmm.pmm04 != g_pmm_t.pmm04 OR g_pmm.pmm43 != g_pmm_t.pmm43
               OR g_pmm.pmm41 != g_pmm_t.pmm41 OR cl_null(g_pmm_t.pmm43) THEN
               LET l_conu = 'Y'
            END IF
            SELECT COUNT(*) INTO g_cnt FROM pmn_file
             WHERE pmn01=g_pmm.pmm01
            IF (g_pmm.pmm43 = g_pmm_t.pmm43 AND g_gec07 != l_gec07) OR cl_null( l_gec07) THEN
               IF g_cnt > 0 THEN  #CHI-CB0024
                  IF cl_confirm('apm-543') THEN
                     LET l_conu = 'Y'
                  END IF
               ELSE
                  LET l_conu = 'N'
               END IF
            END IF
            #CHI-CB0008 add end-----
            IF l_conu = 'Y' THEN                                   #CHI-CB0008 add
              #SELECT COUNT(*) INTO g_cnt FROM pmn_file            #CHI-CB0008 mark
              # WHERE pmn01=g_pmm.pmm01                            #CHI-CB0008 mark
               IF g_cnt > 0 THEN
                  #IF cl_confirm('apm-543') THEN  #是否重新取價    #CHI-CB0008 mark
                     DECLARE upd_pmn_cs CURSOR FOR
                       SELECT pmn01,pmn02,pmn65,pmn04,pmn87,pmn86,pmn31,pmn31t,pmn43,pmn41,pmn88,pmn88t 
                         FROM pmn_file
                        WHERE pmn01=g_pmm.pmm01
                    FOREACH upd_pmn_cs INTO l_pmn01,l_pmn02,l_pmn65,l_pmn04,l_pmn87,l_pmn86,l_pmn31,l_pmn31t,l_pmn43,l_pmn41
                                           ,l_pmn88,l_pmn88t
                       LET l_ecm04=' '
                       IF NOT cl_null(l_pmn43) AND l_pmn43 != 0 THEN
                          SELECT ecm04 INTO l_ecm04 FROM ecm_file
                           WHERE ecm01 = l_pmn41 AND ecm03 = l_pmn43
                       END IF

                       #TQC-C10067 mark ---------------
                       #LET g_type = ''
                       #IF g_pmm.pmm02='SUB' AND l_pmn65='1' THEN
                       #   LET g_type = '2'
                       #ELSE
                       #   LET g_type = '1'
                       #END IF
                       #TQC-C10067 mark end----------------
                       #LET g_type = '2'   #TQC-C10067 #MOD-D40154 mark
                       LET g_errno=''
                       CALL s_defprice_new(l_pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                                           l_pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                           l_pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                              RETURNING l_pmn31,l_pmn31t,
                                        l_pmn73,l_pmn74 
                       CALL t540_price_check(l_pmn31,l_pmn31t) 
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,1)
                          EXIT FOREACH
                       END IF
                       
                       LET l_pmn44 = cl_digcut( l_pmn31*g_pmm.pmm42, g_azi03 ) 
                       LET l_pmn90 = l_pmn31 

                       #重新取價後金額重算
                       LET l_pmn88 = l_pmn31 * l_pmn87 
                       LET l_pmn88t= l_pmn31t* l_pmn87
                       SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'
                       CALL cl_digcut(l_pmn88,t_azi04) RETURNING  l_pmn88  
                       CALL cl_digcut(l_pmn88t,t_azi04) RETURNING l_pmn88t
                       IF g_gec07 = 'N' THEN
                          LET l_pmn88t = l_pmn88 * ( 1 + g_pmm.pmm43/100)
                          LET l_pmn88t = cl_digcut(l_pmn88t,t_azi04) 
                       ELSE
                          #-----CHI-AC0016---------
                          #LET l_pmn88 = l_pmn88t/ ( 1 + g_pmm.pmm43/100)
                          #LET l_pmn88 = cl_digcut(l_pmn88,t_azi04) 
                          #IF g_gec05 = 'T' THEN
                          IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                             #TQC-C30225 add begin
                             LET l_pmn31  = l_pmn31t* ( 1 - g_pmm.pmm43/100)
                             LET l_pmn31  = cl_digcut(l_pmn31,t_azi03)                             
                             #TQC-C30225 add end
                             LET l_pmn88  = l_pmn88t* ( 1 - g_pmm.pmm43/100)
                             LET l_pmn88  = cl_digcut(l_pmn88,t_azi04)   
                          ELSE
                             LET l_pmn88  = l_pmn88t/ ( 1 + g_pmm.pmm43/100)
                             LET l_pmn88  = cl_digcut(l_pmn88,t_azi04)   
                          END IF
                          #-----END CHI-AC0016-----
                       END IF

                       UPDATE pmn_file SET pmn31 = l_pmn31,
                                           pmn31t= l_pmn31t,
                                           pmn88 = l_pmn88,
                                           pmn88t= l_pmn88t,
                                           pmn44 = l_pmn44, 
                                           pmn90 = l_pmn90 
                        WHERE pmn01 = l_pmn01 AND pmn02 = l_pmn02
                       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err3("upd","pmn_file",l_pmn01,l_pmn02,STATUS,"","upd pmn:",1)
                          EXIT FOREACH
                       END IF

                    END FOREACH
                    CALL t540_b_fill(' 1=1',' 1=1')    #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
                    CALL t540_update()
                  #END IF     #CHI-CB0008 mark
               END IF 
            END IF
            #MOD-B30413 add --end--

        ON KEY(F1) NEXT FIELD pmm01
        ON KEY(F2) NEXT FIELD pmm02
 
        ON ACTION supplier_data
           #LET g_cmd = "apmi600  '' ",g_pmm.pmm09 CLIPPED  #MOD-4B0255 #參數傳錯 #CHI-D30005 mark
            LET g_cmd = "apmi600 '",g_pmm.pmm09,"' '' "     #CHI-D30005
           CALL cl_cmdrun(g_cmd)
 
        ON ACTION item_supplier
            LET g_cmd = "apmq210 '' ",g_pmm.pmm09 CLIPPED     #MOD-4B0255
            CALL cl_cmdrun(g_cmd)                             #MOD-4B0255
 
         ON ACTION last_po_price
            LET g_cmd = "apmq220 ",g_pmm.pmm09 CLIPPED        #MOD-4B0255
            CALL cl_cmdrun(g_cmd)                             #MOD-4B0255
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pmm01) #單據編號
                     LET g_t1 = s_get_doc_no(g_pmm.pmm01)       #No.FUN-540027
                     IF g_prog='aict040' THEN LET g_chr1='A' ELSE LET g_chr1='2' END IF   #TQC-9B0191
                     CALL q_smy(FALSE,FALSE,g_t1,'APM',g_chr1) RETURNING g_t1    #TQC-670008 #TQC-9B0191
                     LET g_pmm.pmm01=g_t1             #No.FUN-540027
                     DISPLAY BY NAME g_pmm.pmm01
                     NEXT FIELD pmm01
 
                WHEN INFIELD(pmm05) #專案代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pja2"
                    LET g_qryparam.default1 = g_pmm.pmm05
                    CALL cl_create_qry() RETURNING g_pmm.pmm05
                    DISPLAY BY NAME g_pmm.pmm05
                    NEXT FIELD pmm05
 
                WHEN INFIELD(pmm09) #查詢廠商檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_pmm.pmm09
                     CALL cl_create_qry() RETURNING g_pmm.pmm09
                     DISPLAY BY NAME g_pmm.pmm09
                     CALL t540_supplier('a','1',g_pmm.pmm09)
                     NEXT FIELD pmm09
               WHEN INFIELD(pmm16)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ged1"
                     LET g_qryparam.default1 = g_pmm.pmm16
                     CALL cl_create_qry() RETURNING g_pmm.pmm16
                     DISPLAY BY NAME g_pmm.pmm16
                     NEXT FIELD pmm16
                WHEN INFIELD(pmm17) #查詢代理人
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_pmm.pmm17
                     CALL cl_create_qry() RETURNING g_pmm.pmm17
                     DISPLAY BY NAME g_pmm.pmm17
                     CALL t540_supplier('a','1',g_pmm.pmm17)
                     NEXT FIELD pmm17
                WHEN INFIELD(pmm10) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pmm.pmm10
                     CALL cl_create_qry() RETURNING g_pmm.pmm10
                     DISPLAY BY NAME g_pmm.pmm10
                     NEXT FIELD pmm10
                WHEN INFIELD(pmm11) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pmm.pmm11
                     CALL cl_create_qry() RETURNING g_pmm.pmm11
                     DISPLAY BY NAME g_pmm.pmm11
                     NEXT FIELD pmm11
                WHEN INFIELD(pmm12) #採購員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_pmm.pmm12
                     CALL cl_create_qry() RETURNING g_pmm.pmm12
                     DISPLAY BY NAME g_pmm.pmm12
                     CALL t540_peo('a','1',g_pmm.pmm12)
                     NEXT FIELD pmm12
                WHEN INFIELD(pmm15) #確認員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_pmm.pmm15
                     CALL cl_create_qry() RETURNING g_pmm.pmm15
                     DISPLAY BY NAME g_pmm.pmm15
                     CALL t540_peo('a','2',g_pmm.pmm15)
                     NEXT FIELD pmm15
                WHEN INFIELD(pmm16) #運送方式
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ged"
                     LET g_qryparam.default1 = g_pmm.pmm16
                     CALL cl_create_qry() RETURNING g_pmm.pmm16
                     DISPLAY BY NAME g_pmm.pmm16
                     NEXT FIELD pmm16
                WHEN INFIELD(pmm13) #請購DEPT
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_pmm.pmm13
                     CALL cl_create_qry() RETURNING g_pmm.pmm13
                     DISPLAY BY NAME g_pmm.pmm13
                     CALL t540_dep('a','1',g_pmm.pmm13)
                     NEXT FIELD pmm13
                WHEN INFIELD(pmm14) #請購DEPT
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_pmm.pmm14
                     CALL cl_create_qry() RETURNING g_pmm.pmm14
                     DISPLAY BY NAME g_pmm.pmm14
                     CALL t540_dep('a','2',g_pmm.pmm14)   #MOD-910188
                     NEXT FIELD pmm14
                WHEN INFIELD(pmm20) #查詢付款條件資料檔(pma_file)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pma"
                     LET g_qryparam.default1 = g_pmm.pmm20
                     CALL cl_create_qry() RETURNING g_pmm.pmm20
                     DISPLAY BY NAME g_pmm.pmm20
                     NEXT FIELD pmm20
                WHEN INFIELD(pmm21) #查詢稅別資料檔(gec_file)i
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gec"
                     LET g_qryparam.default1 = g_pmm.pmm21
                     LET g_qryparam.arg1     = '1'
                     CALL cl_create_qry() RETURNING g_pmm.pmm21
                     DISPLAY BY NAME g_pmm.pmm21
                     NEXT FIELD pmm21
                WHEN INFIELD(pmm22) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = g_pmm.pmm22
                     CALL cl_create_qry() RETURNING g_pmm.pmm22
                     DISPLAY BY NAME g_pmm.pmm22
                     NEXT FIELD pmm22
                WHEN INFIELD(pmm42)
                   CALL s_rate(g_pmm.pmm22,g_pmm.pmm42) RETURNING g_pmm.pmm42
                   DISPLAY BY NAME g_pmm.pmm42
                   NEXT FIELD pmm42
               WHEN INFIELD(pmm41) #價格條件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pnz01" #FUN-930113
                    LET g_qryparam.default1 = g_pmm.pmm41
                    CALL cl_create_qry() RETURNING g_pmm.pmm41
                    DISPLAY BY NAME g_pmm.pmm41
                    SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmm.pmm41 #FUN-930113
                    DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113
               WHEN INFIELD(pmm53)      #配送中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.default1 = g_pmm.pmm53
                  CALL cl_create_qry() RETURNING g_pmm.pmm53
                  DISPLAY BY NAME g_pmm.pmm53
                  CALL t540_pmm53('d')
                  NEXT FIELD pmm53
               WHEN INFIELD(pmmud02)
                  CALL cl_dynamic_qry() RETURNING g_pmm.pmmud02
                  DISPLAY BY NAME g_pmm.pmmud02
                  NEXT FIELD pmmud02
               WHEN INFIELD(pmmud03)
                  CALL cl_dynamic_qry() RETURNING g_pmm.pmmud03
                  DISPLAY BY NAME g_pmm.pmmud03
                  NEXT FIELD pmmud03
               WHEN INFIELD(pmmud04)
                  CALL cl_dynamic_qry() RETURNING g_pmm.pmmud04
                  DISPLAY BY NAME g_pmm.pmmud04
                  NEXT FIELD pmmud04
               WHEN INFIELD(pmmud05)
                  CALL cl_dynamic_qry() RETURNING g_pmm.pmmud05
                  DISPLAY BY NAME g_pmm.pmmud05
                  NEXT FIELD pmmud05
               WHEN INFIELD(pmmud06)
                  CALL cl_dynamic_qry() RETURNING g_pmm.pmmud06
                  DISPLAY BY NAME g_pmm.pmmud06
                  NEXT FIELD pmmud06
                OTHERWISE EXIT CASE
             END CASE
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
END FUNCTION
FUNCTION t540_upd_pmm21()
DEFINE l_pmm21 LIKE pmm_file.pmm21
DEFINE l_rto01 LIKE rto_file.rto01
DEFINE l_rto03 LIKE rto_file.rto03
    
    LET g_errno = ''
    SELECT rto01,rto03 
      INTO l_rto01,l_rto03
      FROM rto_file
     WHERE rto05 = g_pmm.pmm09
       AND rto06 = g_pmm.pmm51 AND rtoplant = g_pmm.pmmplant
       AND rto02 = (SELECT MAX(rto02) FROM rto_file
                     WHERE rto05 = g_pmm.pmm09 AND rto06 = g_pmm.pmm51 
                       AND rtoplant = g_pmm.pmmplant)
       AND rto08 <= g_pmm.pmm04 AND rto09 >= g_pmm.pmm04
       AND rtoacti = 'Y' AND rtoconf = 'Y'
    IF SQLCA.sqlcode=0 THEN
       SELECT rts06
         INTO l_pmm21
         FROM rts_file
        WHERE rts02 = l_rto03 AND rts04 = l_rto01 AND rtsplant = g_pmm.pmmplant
          AND rts03 = (SELECT MAX(rts03) FROM rts_file
                        WHERE rts02 = l_rto03 AND rts04 = l_rto01 AND rtsplant = g_pmm.pmmplant)
          AND rtsacti = 'Y' AND rtsconf = 'Y'
    END IF
    IF SQLCA.sqlcode = 0 THEN
       LET g_pmm.pmm21 = l_pmm21
    ELSE
        CALL cl_err('','art-428',0)
    END IF
END FUNCTION
 
FUNCTION t540_supplier(p_cmd,p_code,p_key)  #供應廠商
        DEFINE l_pmc03   LIKE pmc_file.pmc03,
               l_pmc30   LIKE pmc_file.pmc30,
               l_pmcacti LIKE pmc_file.pmcacti,
               p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
               p_code    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
               p_key     LIKE pmc_file.pmc01
 
      LET g_errno = ' '
      SELECT pmc03,pmc30,pmcacti INTO l_pmc03,l_pmc30,l_pmcacti
        FROM pmc_file
       WHERE pmc01 = p_key
 
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                                       LET l_pmc03 = NULL
             WHEN l_pmcacti='N' LET g_errno = '9028'
             WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
             WHEN l_pmc30  ='2' LET g_errno = 'apm-964'      #付款商    #No.TQC-7B0009
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
           IF p_code = '1' THEN
              DISPLAY l_pmc03 TO FORMONLY.pmc03
           ELSE
              DISPLAY l_pmc03 TO FORMONLY.pmc03_2
           END IF
      END IF
END FUNCTION
 
FUNCTION t540_supplier_cd()  #供應廠商check ,default
      DEFINE l_pmc05   LIKE pmc_file.pmc05,   #廠商目前狀況
               l_pmcacti LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
               l_buf     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(20)
               l_chr     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
         LET g_chr = " "
         #FOB/送貨地址/帳單地址/付款方式/付款幣別/列印抑制
         SELECT pmc05,pmc15,pmc16,pmc17,pmc22,pmc47,pmc49,pmcacti
             INTO l_pmc05,g_pmm.pmm10,g_pmm.pmm11,g_pmm.pmm20,
                    g_pmm.pmm22,g_pmm.pmm21,g_pmm.pmm41,l_pmcacti
             FROM pmc_file
            WHERE pmc01 = g_pmm.pmm09 AND pmc30 IN ('1','3')
            CASE
               WHEN l_pmc05 = '0'   #尚侍核准
                      CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg
                      WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YyNn]'
                            LET INT_FLAG = 0  ######add for prompt bug
                            PROMPT g_msg CLIPPED FOR CHAR l_chr
                               ON IDLE g_idle_seconds
                                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                            END PROMPT
                            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
                            IF l_chr MATCHES '[Nn]' THEN LET g_chr = 'e'  END IF
                       END WHILE
               WHEN l_pmc05 = '2'  CALL cl_err(g_pmm.pmm09,'mfg3042',1) #FUN-690025
                        LET g_chr = 's'
               OTHERWISE EXIT CASE
            END CASE
 
#genero add
                IF NOT cl_null(g_pmm.pmm10) THEN
                   CALL t540_pmm10(g_pmm.pmm10)
                   IF NOT cl_null(g_errno) THEN
                      LET g_pmm.pmm10 = ''
                   END IF
                END IF
 
                IF NOT cl_null(g_pmm.pmm11) THEN
                   CALL t540_pmm10(g_pmm.pmm11)
                   IF NOT cl_null(g_errno) THEN
                      LET g_pmm.pmm11 = ''
                   END IF
                END IF
 
                IF NOT cl_null(g_pmm.pmm22) THEN
                   CALL t540_pmm22()
                   IF NOT cl_null(g_errno) THEN
                      LET g_pmm.pmm22 = ''
                   END IF
                END IF
 
                IF NOT cl_null(g_pmm.pmm41) THEN
                   SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmm.pmm41 #FUN-930113
                   IF STATUS THEN
                      LET g_pmm.pmm41 = ''
                      LET l_buf = ''
                   END IF
                   DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113
                END IF
 
                IF NOT cl_null(g_pmm.pmm20) THEN
                   CALL t540_pmm20('d')
                   IF NOT cl_null(g_errno) THEN
                      LET g_pmm.pmm20 = ''
                   END IF
                END IF
                IF g_azw.azw04 = '2' THEN
                   IF NOT cl_null(g_pmm.pmm51) AND NOT cl_null(g_pmm.pmm04) THEN
                      CALL t540_upd_pmm21()
                   END IF
                END IF
                IF NOT cl_null(g_pmm.pmm21) THEN
                   CALL t540_pmm21('a')     #No.MOD-930045
                   IF NOT cl_null(g_errno) THEN
                      LET g_pmm.pmm21 = ''
                   END IF
                END IF
            LET g_pmm_o.* = g_pmm.*  #MOD-BA0025 add
            DISPLAY BY NAME g_pmm.pmm10    #送貨地 No.B420
            DISPLAY BY NAME g_pmm.pmm11    #No.B420
            DISPLAY BY NAME g_pmm.pmm20    #付款條件
            DISPLAY BY NAME g_pmm.pmm22    #幣別
            DISPLAY BY NAME g_pmm.pmm21    #稅別
            DISPLAY BY NAME g_pmm.pmm41    #PRICE TERM
END FUNCTION
 
FUNCTION t540_peo(p_cmd,p_code,p_key)    #人員
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                p_code      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
                p_key       LIKE gen_file.gen01,
                l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti
 
        LET g_errno = ' '
        SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
            FROM gen_file WHERE gen01 = p_key
 
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
          IF p_code = '1' THEN
             DISPLAY l_gen02 TO FORMONLY.gen02
              IF p_cmd='a' THEN    #No.MOD-480601
                LET g_pmm.pmm13=l_gen03
                DISPLAY BY NAME g_pmm.pmm13
              END IF               #No.MOD-480601
          ELSE
             DISPLAY l_gen02 TO FORMONLY.gen02_2
          END IF
END FUNCTION
 
FUNCTION t540_dep(p_cmd,p_code,p_key)    #部門
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                p_code      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
                p_key       LIKE gem_file.gem01,
                l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti
 
        LET g_errno = ' '
        SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = p_key
 
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
          IF p_code = '1' THEN
             DISPLAY l_gem02 TO FORMONLY.gem02
          ELSE
             DISPLAY l_gem02 TO FORMONLY.gem02_2
          END IF
END FUNCTION
 
FUNCTION t540_pmm20(p_cmd)  #付款條件
       DEFINE    p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                   l_pma02    like pma_file.pma02,
                   l_pma06    like pma_file.pma06,
                   l_pmaacti  like pma_file.pmaacti
 
       LET g_errno = " "
         SELECT pma02,pma06,pmaacti INTO l_pma02,l_pma06,l_pmaacti
              FROM pma_file WHERE pma01 = g_pmm.pmm20
 
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                          LET l_pma06   = NULL
                                          LET l_pma02   = NULL
                                          LET l_pmaacti = NULL
             WHEN l_pmaacti='N' LET g_errno = '9028'
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         IF p_cmd = 'a' THEN LET g_pmm.pmm46 = l_pma06 END IF
         DISPLAY l_pma02 TO pma02
END FUNCTION
 
FUNCTION t540_pmm21(p_cmd)#稅別        #No.MOD-930045
 DEFINE p_cmd     LIKE type_file.chr1  #No.MOD-930045
        DEFINE  l_gec04   LIKE gec_file.gec04,
                  l_gecacti LIKE gec_file.gecacti
 
        LET g_errno = " "
        SELECT gec04,gecacti,gec07,gec05 INTO l_gec04,l_gecacti,g_gec07,g_gec05   #No:FUN-550019   #CHI-AC0016 add gec05
            FROM gec_file
           WHERE gec01 = g_pmm.pmm21
             AND gec011='1'  #進項
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                         LET l_gec04 = 0
               WHEN l_gecacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF NOT cl_null(l_gec04) AND p_cmd = 'a' THEN  #No.MOD-930045
           LET g_pmm.pmm43 = l_gec04
           DISPLAY BY NAME g_pmm.pmm43
        END IF
          DISPLAY g_gec07 TO gec07
END FUNCTION
 
FUNCTION t540_pmm10(p_code)    #check 地址
        DEFINE  p_cmd   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                    p_code  LIKE pme_file.pme01,
                    l_pme02 LIKE pme_file.pme02,
                    l_pmeacti LIKE pme_file.pmeacti
 
        LET g_errno = " "
        SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
          WHERE pme01 = p_code
 
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012'
                                         LET l_pmeacti=NULL
               WHEN l_pmeacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
END FUNCTION
 
FUNCTION t540_pmm22()  #幣別
        DEFINE l_aziacti LIKE azi_file.aziacti
 
        LET g_errno = " "
        SELECT azi03,azi04,aziacti INTO t_azi03,t_azi04,l_aziacti FROM azi_file  #No.MOD-8B0273 add
                              WHERE azi01 = g_pmm.pmm22
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                         LET l_aziacti = 0
               WHEN l_aziacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
 
END FUNCTION
FUNCTION t540_pmm53(p_cmd)   #配送中心
DEFINE    l_gemacti  LIKE gem_file.gemacti, 
          l_gem02    LIKE gem_file.gem02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
     WHERE gem01 = g_pmm.pmm53
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-188' 
                                 LET l_gem02=NULL 
        WHEN l_gemacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.pmm53_desc
  END IF
 
END FUNCTION
 
FUNCTION t540_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
       INITIALIZE g_pmm.* TO NULL
 
    CALL cl_msg("")                              #FUN-640184
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    IF g_sma.sma120 = 'Y'  THEN
       LET lg_smy62 = ''
       LET lg_group = ''
       CALL t540_refresh_detail()
    END IF
 
    CALL t540_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_pmn.clear()
       INITIALIZE g_pmm.* TO NULL
       RETURN
    END IF
 
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640184
 
    OPEN t540_count
    FETCH t540_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t540_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)  #MOD-640492 0->1
       INITIALIZE g_pmm.* TO NULL
    ELSE
       CALL t540_fetch('F')                  # 讀出TEMP第一筆並顯示
       CALL t540_list_fill()                 #FUN-CB0014  add
    END IF
    CALL cl_msg("")                              #FUN-640184
END FUNCTION
 
FUNCTION t540_fetch(p_flpmm)
DEFINE p_flpmm         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE l_slip          LIKE smy_file.smyslip  #No.FUN-680136 VARCHAR(10)               #No.TQC-650108
 
        CASE p_flpmm
             WHEN 'N' FETCH NEXT     t540_cs INTO g_pmm.pmm01
             WHEN 'P' FETCH PREVIOUS t540_cs INTO g_pmm.pmm01
             WHEN 'F' FETCH FIRST    t540_cs INTO g_pmm.pmm01
             WHEN 'L' FETCH LAST     t540_cs INTO g_pmm.pmm01
             WHEN '/'
                  IF (NOT mi_no_ask) THEN
                      CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                      LET INT_FLAG = 0  ######add for prompt bug
                      PROMPT g_msg CLIPPED,': ' FOR g_jump
                         ON IDLE g_idle_seconds
                            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                      END PROMPT
                      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
                  END IF
                  FETCH ABSOLUTE g_jump t540_cs INTO g_pmm.pmm01
                  LET mi_no_ask = FALSE
        END CASE
 
      IF SQLCA.sqlcode THEN
           CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)  #MOD-640492 0->1
           INITIALIZE g_pmm.* TO NULL  #TQC-6B0105
           LET g_pmm.pmm01 = NULL      #TQC-6B0105
           RETURN
        ELSE
           CASE p_flpmm
              WHEN 'F' LET g_curs_index = 1
              WHEN 'P' LET g_curs_index = g_curs_index - 1
              WHEN 'N' LET g_curs_index = g_curs_index + 1
              WHEN 'L' LET g_curs_index = g_row_count
              WHEN '/' LET g_curs_index = g_jump
           END CASE
 
           CALL cl_navigator_setting( g_curs_index, g_row_count )
        END IF
 
      SELECT * INTO g_pmm.* FROM pmm_file       # 重讀DB,因TEMP有不被更新特性
         WHERE pmm01 = g_pmm.pmm01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("sel","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ELSE
           LET g_t1 = s_get_doc_no(g_pmm.pmm01)       #No.FUN-540027
           SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_t1
           LET g_data_owner = g_pmm.pmmuser      #FUN-4C0056 add
           LET g_data_group = g_pmm.pmmgrup      #FUN-4C0056 add
           LET g_data_plant = g_pmm.pmmplant #FUN-980030
          #在使用Q查詢的情況下得到當前對應的屬性組smy62
          IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
             LET l_slip = g_pmm.pmm01[1,g_doc_len]
             SELECT smy62 INTO lg_smy62 FROM smy_file
              WHERE smyslip = l_slip
          END IF
          CALL s_get_bookno(YEAR(g_pmm.pmm04)) RETURNING g_flag,g_bookno1,g_bookno2
          IF g_flag =  '1' THEN  #抓不到帳別
             CALL cl_err(g_pmm.pmm04,'aoo-081',1)
          END IF
          CALL t540_show()                      # 重新顯示
        END IF
END FUNCTION
 
FUNCTION t540_show()
   DEFINE l_buf   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(20)
   DEFINE l_ged02   LIKE ged_file.ged02     #TQC-960196 
   DEFINE l_pmmconu_desc   LIKE gen_file.gen02  #NO.FUN-960130
   DEFINE l_pmmplant_desc  LIKE azp_file.azp02  #NO.FUN-960130
   LET g_pmm_t.* = g_pmm.*
   LET g_pmm_o.* = g_pmm.*
 
   DISPLAY BY NAME g_pmm.pmmoriu,g_pmm.pmmorig,
         g_pmm.pmm01,g_pmm.pmm03,g_pmm.pmm04,g_pmm.pmm02,g_pmm.pmm09,
         g_pmm.pmm05,g_pmm.pmm18,               #FUN-810045 add pmm05  #No.FUN-830161
         g_pmm.pmm20,g_pmm.pmm41,g_pmm.pmm10,g_pmm.pmm11,
         g_pmm.pmm12,g_pmm.pmm13,g_pmm.pmm21,g_pmm.pmm43,
         g_pmm.pmm22,g_pmm.pmm42,g_pmm.pmm40,g_pmm.pmm40t,  #No.FUN-610018
         g_pmm.pmm45,g_pmm.pmm905,g_pmm.pmm99,g_pmm.pmmmksg,g_pmm.pmm25,
        #g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,g_pmm.pmm30,     #MOD-C10015 mark g_pmm.pmm30
         g_pmm.pmm14,g_pmm.pmm15,g_pmm.pmm16,g_pmm.pmm17,                 #MOD-C10015 mark g_pmm.pmm30
         g_pmm.pmm44,g_pmm.pmm909,    #No.FUN-630006
         g_pmm.pmm51,g_pmm.pmm52,g_pmm.pmm53,g_pmm.pmmcond,g_pmm.pmmconu,g_pmm.pmmplant, #NO.FUN-960130
         g_pmm.pmmuser,g_pmm.pmmgrup,g_pmm.pmmmodu,g_pmm.pmmdate,
         g_pmm.pmmacti,g_pmm.pmmcrat, #NO.FUN-960130-add-pmmcrat-
         g_pmm.pmmpos,g_pmm.pmmcont,  #NO.FUN-960130---add---
         g_pmm.pmmud01,g_pmm.pmmud02,g_pmm.pmmud03,g_pmm.pmmud04,g_pmm.pmmud05,
         g_pmm.pmmud06,g_pmm.pmmud07,g_pmm.pmmud08,g_pmm.pmmud09,g_pmm.pmmud10,
         g_pmm.pmmud11,g_pmm.pmmud12,g_pmm.pmmud13,g_pmm.pmmud14,g_pmm.pmmud15
 
   CALL t540_pic() #FUN-730012
 
   CALL s_pmmsta('pmm',g_pmm.pmm25,g_pmm.pmm18,g_pmm.pmmmksg)
                      RETURNING g_sta
   CALL t540_peo('d','1',g_pmm.pmm12)
   CALL t540_peo('d','2',g_pmm.pmm15)
   CALL t540_dep('d','1',g_pmm.pmm13)
   CALL t540_dep('d','2',g_pmm.pmm14)
   CALL t540_supplier('d','1',g_pmm.pmm09)
   CALL t540_supplier('d','2',g_pmm.pmm17)
   CALL t540_pmm20('d')
   CALL t540_pmm53('d')
   IF NOT cl_null(g_pmm.pmmconu) THEN
      SELECT gen02 INTO l_pmmconu_desc FROM gen_file
        WHERE gen01=g_pmm.pmmconu AND genacti='Y'
      DISPLAY l_pmmconu_desc TO pmmconu_desc
   ELSE
      CLEAR pmmconu,pmmcond,pmmconu_desc
   END IF
   SELECT azp02 INTO l_pmmplant_desc FROM azp_file
         WHERE azp01=g_pmm.pmmplant
   DISPLAY l_pmmplant_desc TO pmmplant_desc
   LET l_pmmplant_desc=''                                         #TQC-AC0371
   SELECT azp02 INTO l_pmmplant_desc FROM azp_file
         WHERE azp01=g_pmm.pmm52
   DISPLAY l_pmmplant_desc TO pmm52_desc
   CALL t540_pmm21('q')                            #No.MOD-930045
   CALL t540_pmm22()                #No.FUN-550019
   SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmm.pmm41 #FUN-930113
   DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113
 
   DISPLAY '' TO FORMONLY.ged02 
   SELECT ged02 INTO l_ged02 FROM ged_file
    WHERE ged01 = g_pmm.pmm16
   DISPLAY l_ged02 TO FORMONLY.ged02  

    CASE g_pmm.pmm909
     WHEN "3"
        CALL cl_getmsg('axr-500',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
        CALL cl_getmsg('apm-040',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
    #No.CHI-9A0018 -BEGIN-----
     WHEN "5"  
        IF cl_null(g_argv3) OR g_argv3<>'SUB' THEN                           
           CALL cl_getmsg('sub-098',g_lang) RETURNING g_msg
           CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
        END IF   #MOD-C10092 add
    #No.CHI-9A0018 -END-------
     WHEN "8"
        CALL cl_getmsg('apm1027',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
        CALL cl_getmsg('apm1028',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
     OTHERWISE
        CALL cl_getmsg('apm-041',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
        CALL cl_getmsg('apm-042',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
     END CASE   

   #單據別有做預管控管時，才顯示預算相關欄位 預算/部門/科目一
   CALL cl_set_comp_visible("pmn67,pmn40",g_smy.smy59='Y')        #No.FUN-830161
   #單據別有做預算控管且有使用多套帳時才顯示科目二
   CALL cl_set_comp_visible("pmn401",g_smy.smy59='Y' AND g_aza.aza63='Y')
 
   CALL t540_b_fill(g_wc2,g_wc3) #單身    #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
   CALL t540_list_fill()                 #FUN-CB0014  add
   CALL cl_show_fld_cont()               #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t540_b_fill(p_wc2,p_wc3)          #FUN-B90103--add p_wc3 用於服飾行業母單身和子單身顯示的關聯
   DEFINE p_wc2    STRING, #No.FUN-680136 VARCHAR(200) #FUN-730068
          p_wc3    STRING, #FUN-B90103--add  
          l_sql    STRING, #No.FUN-680136 VARCHAR(1000) #FUN-730068
          l_name   LIKE gfe_file.gfe01     #No.FUN-680136 VARCHAR(04)
   DEFINE l_sfb06  LIKE sfb_file.sfb06     #No.FUN-A60011
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  DEFINE l_pmn02  DYNAMIC ARRAY OF RECORD
#         pmn02    LIKE pmn_file.pmn02
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE l_go     LIKE type_file.chr1
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
   DEFINE l_flag   LIKE type_file.num5   #TQC-AC0374
   DEFINE l_sfb05  LIKE sfb_file.sfb05   #TQC-AC0374
 
   LET l_sql ="SELECT pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,'',pmn72,pmn04,",       #NO.FUN-960130
              "       '','','','','','','','','','','','','','','','','','','','','',",#No.TQC-650108
              "       pmn041,ima021,'','',pmn07,pmn73,pmn74,pmn75,pmn76,pmn77,pmn20,pmn83,pmn84,pmn85,", #NO.FUN-960130
              "       pmn80,pmn81,pmn82,pmn86,pmn87,'',pmn68,pmn69,pmn31,",            #NO.FUN-950026 add ''
              "       pmn31t,pmn88,pmn88t,pmn89,pmn64,pmn63,pmn33,pmn34,pmn35,pmn919,pmn122,",   #No.FUN-940083   #CHI-9C0023 add pmn35 #FUN-A80150 pmn919#FUN-D10112add pmn88 pmn88t
              "       pmn96,pmn97,pmn67,pmn98,pmn40,pmn401,      ",   #FUN-810045 add  #No.FUN-830161
              "       pmn930,'',pmn012,'',pmn43,pmn78,pmn431,pmn91 ",          #No.FUN-810016  #No.FUN-A60011  #FUN-C10002 add pmn78
              "      ,pmn100,pmn38 ",   #FUN-690047 add  #FUN-D40042 add pmn100
              "      ,pmn90 ",   #CHI-690043 add
              "      ,pmn11,pmn123,'' ",   #FUN-830018 add #FUN-950088 add pmn123,''
              "      ,pmn52,pmn54,pmn56 ", #CHI-9C0025
        "      ,'','','','',",  #No.FUN-7C0017
              "       '','','','' ",  #No.FUN-7C0017
              "       ,pmnud01,pmnud02,pmnud03,pmnud04,pmnud05,",
              "       pmnud06,pmnud07,pmnud08,pmnud09,pmnud10,",
             # "       pmnud11,pmnud12,pmnud13,pmnud14,pmnud15",      #No.FUN-A90009
              "       pmnud11,pmnud12,pmnud13,pmnud14,pmnud15,pmn99", #No.FUN-A90009 add pmn99 
              " FROM pmn_file LEFT OUTER JOIN ima_file ON pmn04=ima01 ",  #091020
              #" WHERE pmn01= '",g_pmm.pmm01,"' AND ",g_wc2 CLIPPED, #TQC-C30063 mark
              " WHERE pmn01= '",g_pmm.pmm01,"' AND ",p_wc2 CLIPPED,  #TQC-C30063 add
              " ORDER BY pmn02"
#FUN-B90103------------add-----------------------------
#FUN-B90103-------end----------------------------------------
   PREPARE t540_pp FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE t540_cs2 CURSOR FOR t540_pp
   CALL g_pmn.clear()
   LET g_cnt=1
   FOREACH t540_cs2 INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      #No.FUN-A60011  --Begin
      IF NOT cl_null(g_pmn[g_cnt].pmn41) THEN
        #FUN-B10056 ----------mod start----------  
        #SELECT sfb06 INTO l_sfb06 FROM sfb_file
        # WHERE sfb01 = g_pmn[g_cnt].pmn41
        #CALL s_schdat_sel_ima571(g_pmn[g_cnt].pmn41) RETURNING l_flag,l_sfb05 #TQC-AC0374
        #SELECT ecu014 INTO g_pmn[g_cnt].ecu014 FROM ecu_file
        ##WHERE ecu01 = g_pmn[g_cnt].pmn04 #TQC-AC0374
        # WHERE ecu01 = l_sfb05            #TQC-AC0374
        #   AND ecu02 = l_sfb06
        #   AND ecu012= g_pmn[g_cnt].pmn012
         CALL s_schdat_ecm014(g_pmn[g_cnt].pmn41,g_pmn[g_cnt].pmn012) RETURNING g_pmn[g_cnt].ecu014
      END IF
      #No.FUN-A60011  --End  

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#     #FUN-A60035 ---mark begin
#     SELECT ata02 INTO g_pmn[g_cnt].pmn25 FROM ata_file
#      WHERE ata00 = 'apmt420_slk'
#        AND ata01 = g_pmn[g_cnt].pmn24
#        AND ata03 = g_pmn[g_cnt].pmn02
#     #FUN-A60035 ---mark end
#     SELECT ata02,ata05 INTO g_pmn[g_cnt].pmn02,g_pmn[g_cnt].pmn04
#       FROM ata_file
#      WHERE ata00 = g_prog
#        AND ata01 = g_pmm.pmm01
#        AND ata03 = g_pmn[g_cnt].pmn02
#     LET l_pmn02[l_pmn02.getLength() + 1] = g_pmn[g_cnt].pmn02   #FUN-A60035 add
#     IF g_cnt > 1 THEN
#        #FUN-A60035 ---mark begin
#        #IF g_pmn[g_cnt].pmn02 = g_pmn[g_cnt-1].pmn02 THEN
#        #   CONTINUE FOREACH
#        #END IF
#        #FUN-A60035 ---mark end
#        #FUN-A60035 ---add begin
#         LET l_go = 'N'
#         FOR l_i = 1 TO l_pmn02.getLength()-1
#            IF g_pmn[g_cnt].pmn02 = l_pmn02[l_i].pmn02 THEN
#               LET l_go = 'Y'
#               EXIT FOR
#            END IF
#         END FOR
#         IF l_go = 'Y' THEN
#            CONTINUE FOREACH
#         END IF
#         #FUN-A60035 ---add end
#     END IF
#     SELECT SUM(ata08) INTO g_pmn[g_cnt].pmn20 from ata_file
#      WHERE ata00 = g_prog
#        AND ata01 = g_pmm.pmm01
#        AND ata02 = g_pmn[g_cnt].pmn02
#&else
##FUN-A50054 --End      
#FUN-A60035 ---MARK END
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_pmn[g_cnt].att00,g_pmn[g_cnt].att01,g_pmn[g_cnt].att02,
                g_pmn[g_cnt].att03,g_pmn[g_cnt].att04,g_pmn[g_cnt].att05,
                g_pmn[g_cnt].att06,g_pmn[g_cnt].att07,g_pmn[g_cnt].att08,
                g_pmn[g_cnt].att09,g_pmn[g_cnt].att10
           FROM imx_file WHERE imx000 = g_pmn[g_cnt].pmn04
 
           LET g_pmn[g_cnt].att01_c = g_pmn[g_cnt].att01
           LET g_pmn[g_cnt].att02_c = g_pmn[g_cnt].att02
           LET g_pmn[g_cnt].att03_c = g_pmn[g_cnt].att03
           LET g_pmn[g_cnt].att04_c = g_pmn[g_cnt].att04
           LET g_pmn[g_cnt].att05_c = g_pmn[g_cnt].att05
           LET g_pmn[g_cnt].att06_c = g_pmn[g_cnt].att06
           LET g_pmn[g_cnt].att07_c = g_pmn[g_cnt].att07
           LET g_pmn[g_cnt].att08_c = g_pmn[g_cnt].att08
           LET g_pmn[g_cnt].att09_c = g_pmn[g_cnt].att09
           LET g_pmn[g_cnt].att10_c = g_pmn[g_cnt].att10
      END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054--Begin add      
#&endif
##FUn-A50054---end      
#FUN-A60035 ---MARK END
      CALL t540_set_pmn930(g_pmn[g_cnt].pmn930) RETURNING g_pmn[g_cnt].gem02a #FUN-670051
       SELECT mse02 INTO g_pmn[g_cnt].mse02
         FROM mse_file WHERE mse01=g_pmn[g_cnt].pmn123
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 1 ) #MOD-640492 0->1
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmn.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t540_refresh_detail()  #No.TQC-650108   刷新單身的欄位顯示
END FUNCTION

#FUN-B90103--add--start--
#FUN-B90103--add--end
 
FUNCTION t540_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
#FUN-B90103--add--begin--
#FUN-B90103--add--end-- 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_chr='@'
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B90103--add--begin---
IF g_azw.azw04='2' AND (g_prog="apmt540_slk" OR g_prog="apmt590_slk") THEN    #FUN-C20006--add
#FUN-C20006---------------begin-------------------------
ELSE
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_sma.sma901 != 'Y' THEN
             CALL cl_set_act_visible("aps_related_data",FALSE)
         END IF
         IF g_argv2='2' THEN
             CALL cl_set_act_visible("insert,undo_release",FALSE)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION info_list                 #FUN-CB0014
         LET g_action_flag="info_list"    #FUN-CB0014
         EXIT DISPLAY                     #FUN-CB0014

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t540_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t540_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t540_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t540_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t540_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 供應商資料
      ON ACTION vender
         LET g_action_choice="vender"
         EXIT DISPLAY
    #@ON ACTION 單價查詢
      ON ACTION qry_unit_price
         LET g_action_choice="qry_unit_price"
         EXIT DISPLAY
    #@ON ACTION 三角貿易
      ON ACTION triangletrade
         LET g_action_choice="triangletrade"
         EXIT DISPLAY
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY
    #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
    #@ON ACTION 特別說明
      ON ACTION special_description
         LET g_action_choice="special_description"
         EXIT DISPLAY
    #@ON ACTION 替代
      ON ACTION sub
         LET g_action_choice="sub"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025 add
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY 
#FUN-D20025 add          
    #@ON ACTION 發出還原
      ON ACTION undo_release
         LET g_action_choice="undo_release"
         EXIT DISPLAY
    #@ON ACTION 採購發出
      ON ACTION release_po
         LET g_action_choice="release_po"
         EXIT DISPLAY
    #@ON ACTION 變更狀況
      ON ACTION modify_status
         LET g_action_choice="modify_status"
         EXIT DISPLAY
    #@ON ACTION 驗收狀況
      ON ACTION receiving_status
         LET g_action_choice="receiving_status"
         EXIT DISPLAY
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval         #FUN-550038
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244      mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t540_def_form()     #FUN-610067
         CALL t540_pic() #FUN-730012
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
     #DEV-D30026--add--begin-----------
      ON ACTION barcode_gen
         LET g_action_choice = 'barcode_gen'
         EXIT DISPLAY

      ON ACTION barcode_query
         LET g_action_choice = 'barcode_query'
         EXIT DISPLAY

      ON ACTION barcode_output #條碼列印
         LET g_action_choice = 'barcode_output'
         EXIT DISPLAY
     #DEV-D30026--add--end-------------

      AFTER DISPLAY
         CONTINUE DISPLAY
#start FUN-580113
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      ON ACTION b_more
         LET g_action_choice="b_more"
         EXIT DISPLAY
 
      ON ACTION aps_related_data
         LET g_action_choice = 'aps_related_data'
         EXIT DISPLAY
      
 #FUN-A60035 ---MARK BEGIN
 ##FUN-A50054 --Begin
 #&ifdef SLK
 #      ON ACTION style_detail
 #         LET g_action_choice = 'style_detail'
 #         EXIT DISPLAY
 #&endif         
 #FUN-A50054---end 
 #FUN-A60035 ---MARK END
       &include "qry_string.4gl"
   END DISPLAY
END IF       
#FUN-C20006------------------end-------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-CB0014 -------------Begin-------------
FUNCTION t540_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   

 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_chr='@'
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_pmm_1 TO s_pmm_1.*                                      
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_curs_index)

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET g_curs_index = l_ac1
         CALL cl_show_fld_cont()  
      END DISPLAY 

      ON ACTION main 
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t540_fetch('/')
         END IF 
         CALL cl_set_comp_visible("page3", FALSE)
         CALL cl_set_comp_visible("page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         CALL cl_set_comp_visible("page4", TRUE)
         EXIT DIALOG
         
      ON ACTION accept
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         CALL t540_fetch('/')
         CALL cl_set_comp_visible("page4", FALSE)
         CALL cl_set_comp_visible("page4", TRUE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         EXIT DIALOG

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL t540_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
         ACCEPT DIALOG                  

      ON ACTION previous
         CALL t540_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 !=0 THEN
            CALL fgl_set_arr_curr(g_curs_index)   
         END IF
         ACCEPT DIALOG                    

      ON ACTION jump
         CALL t540_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)   
         END IF
         ACCEPT DIALOG                    

      ON ACTION next
         CALL t540_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)   
         END IF
         ACCEPT DIALOG                    

      ON ACTION last
         CALL t540_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)   
         END IF
         ACCEPT DIALOG                    

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG 
         
#TQC-D10084--mark--str--
#&ifdef SLK
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac2 = 1
#         EXIT DIALOG
#&endif
#
#&ifndef SLK
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DIALOG
#&endif
#TQC-D10084--mark--end--         
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 供應商資料
      ON ACTION vender
         LET g_action_choice="vender"
         EXIT DIALOG
    #@ON ACTION 單價查詢
      ON ACTION qry_unit_price
         LET g_action_choice="qry_unit_price"
         EXIT DIALOG
    #@ON ACTION 三角貿易
      ON ACTION triangletrade
         LET g_action_choice="triangletrade"
         EXIT DIALOG   
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG
    #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DIALOG
    #@ON ACTION 特別說明
      ON ACTION special_description
         LET g_action_choice="special_description"
         EXIT DIALOG
    #@ON ACTION 替代
      ON ACTION sub
         LET g_action_choice="sub"
         EXIT DIALOG   
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#FUN-D20025 add
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#FUN-D20025 add         
    #@ON ACTION 發出還原
      ON ACTION undo_release
         LET g_action_choice="undo_release"
         EXIT DIALOG
    #@ON ACTION 採購發出
      ON ACTION release_po
         LET g_action_choice="release_po"
         EXIT DIALOG
    #@ON ACTION 變更狀況
      ON ACTION modify_status
         LET g_action_choice="modify_status"
         EXIT DIALOG
    #@ON ACTION 驗收狀況
      ON ACTION receiving_status
         LET g_action_choice="receiving_status"
         EXIT DIALOG
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval         
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG

    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG


 

      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  
         END IF
         CALL cl_show_fld_cont()                   
         CALL t540_def_form()     
         CALL t540_pic()
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about        
         CALL cl_about()      

      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

     #DEV-D30026--add--begin-----------
      ON ACTION barcode_gen
         LET g_action_choice = 'barcode_gen'
         EXIT DIALOG

      ON ACTION barcode_query
         LET g_action_choice = 'barcode_query'
         EXIT DIALOG

      ON ACTION barcode_output #條碼列印
         LET g_action_choice = 'barcode_output'
         EXIT DIALOG
     #DEV-D30026--add--end-------------
      AFTER DIALOG  
         CONTINUE DIALOG

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG
 
      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO") 

      ON ACTION related_document    
         LET g_action_choice="related_document"
         EXIT DIALOG 

      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DIALOG
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DIALOG

      ON ACTION b_more
         LET g_action_choice="b_more"
         EXIT DIALOG

      ON ACTION aps_related_data
         LET g_action_choice = 'aps_related_data'
         EXIT DIALOG
     END DIALOG
     CALL cl_set_act_visible("accept,cancel", TRUE)   
END FUNCTION   

FUNCTION t540_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_pmm01        LIKE pmm_file.pmm01

   CALL g_pmm_1.clear()
   LET l_cnt = 1 
   FOREACH t540_fill_cs INTO l_pmm01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      SELECT pmm01,pmm909,pmm04,pmm02,pmm09,pmc03,pmm18,pmm25,pmm20,pma02,pmm41,pnz02,pmm12,gen02,
             pmm13,gem02,pmmmksg,pmm905
        INTO g_pmm_1[l_cnt].*
        FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm09 = pmc01
                      LEFT OUTER JOIN pma_file ON pmm20 = pma01
                      LEFT OUTER JOIN pnz_file ON pmm41 = pnz01
                      LEFT OUTER JOIN gen_file ON pmm12 = gen01
                      LEFT OUTER JOIN gem_file ON pmm13 = gem01
       WHERE pmm01 = l_pmm01
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_cnt - 1

    DISPLAY ARRAY g_pmm_1 TO s_pmm_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
#FUN-CB0014 -------------End---------------

FUNCTION t540_u()
   DEFINE   l_pmn02     LIKE pmn_file.pmn02
   DEFINE   l_pmn31     LIKE pmn_file.pmn31
   DEFINE   l_pmn31t    LIKE pmn_file.pmn31t
   DEFINE   l_pmn44     LIKE pmn_file.pmn44
   DEFINE   l_pmn20     LIKE pmn_file.pmn20  #CHI-6B0006
   DEFINE   l_pmn88t    LIKE pmn_file.pmn88t #CHI-6B0006
   DEFINE   l_pmn88     LIKE pmn_file.pmn88  #TQC-870047
   DEFINE   l_pmn87     LIKE pmn_file.pmn87  #CHI-B70039 add
   DEFINE   l_sw_pmm42  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)             # pmm42 匯率是否變更 sw
   DEFINE   l_sw_pmm43  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)             # pmm43 稅率是否變更 sw 7259
#FUN-B90103--------------add----
#FUN-B90103-------------end----
   DEFINE   l_gec07     LIKE gec_file.gec07  #CHI-CB0008 add

   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pmm.pmm01) THEN CALL cl_err('','-400',1) RETURN END IF  #MOD-640492 0->1
 
   SELECT * INTO g_pmm.* FROM pmm_file
    WHERE pmm01=g_pmm.pmm01
 
   IF g_pmm.pmmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmm.pmm01,9027,1)  #MOD-640492 0->1
      RETURN
   END IF
 
   IF g_pmm.pmm18='X' THEN
      CALL cl_err('','9024',1)  #MOD-640492 0->1
      RETURN
   END IF
 
   IF g_pmm.pmm18='Y' THEN   #7263
      CALL cl_err('','9023',1)   #MOD-640492 0->1
      RETURN
   END IF
 
   IF g_pmm.pmm25 matches '[Ss]' THEN
      CALL cl_err('','apm-030',1)  #MOD-640492 0->1
      RETURN
   END IF
 
   IF g_argv2 = '0' AND g_pmm.pmm18 = 'Y' AND g_pmm.pmm25 = "1" AND g_pmm.pmmmksg = "Y"  THEN
      CALL cl_err('','mfg3168',1) RETURN  #MOD-640492 0->1
   END IF
 
   IF g_argv2 = '0' AND g_pmm.pmm18 = 'Y' AND g_pmm.pmm25 = "1" AND g_pmm.pmmmksg = "N" THEN
      CALL cl_err('','9023',1) RETURN    #MOD-640492 0->1
   END IF
 
   IF g_argv2 MATCHES '[01]' AND g_pmm.pmm25 MATCHES'[269]' THEN
      CALL cl_err('','mfg9136',1) RETURN   #MOD-640492 0->1
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmm01_t = g_pmm.pmm01
   BEGIN WORK
 
   OPEN t540_cl USING g_pmm.pmm01
   IF STATUS THEN
      CALL cl_err("OPEN t540_cl:", STATUS, 1)
      CLOSE t540_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t540_cl INTO g_pmm.*               # 對DB鎖定
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)  #MOD-640492 0->1
      CLOSE t540_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_pmm.pmmmodu=g_user               # 修改者
   LET g_pmm.pmmdate = g_today            # 修改日期
   IF g_aza.aza88='Y' THEN    #FUN-A30030 ADD
      LET g_pmm.pmmpos='N'                   #NO.FUN-960130
   END IF
   CALL t540_show()                       # 顯示最新資料
 
   WHILE TRUE
      LET g_pmm_o.* = g_pmm.*
 
      CALL t540_i("u")                     # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmm.*  = g_pmm_t.*
         CALL t540_show()
         CALL cl_err('',9001,1)      #MOD-640492 0->1
         EXIT WHILE
      END IF
 
      LET l_sw_pmm42 = 'N'
      IF (NOT cl_null(g_pmm_t.pmm42)) AND (NOT cl_null(g_pmm.pmm42)) THEN
         IF g_pmm_t.pmm42 != g_pmm.pmm42 THEN
           IF l_sw_pmm42 = 'N' THEN           #No.CHI-8C0047
            IF cl_confirm('apm-358')   THEN   #No.CHI-8C0047
              LET l_sw_pmm42 = 'Y'
            END IF                           #NO.CHI-8C0047
           END IF                           #NO.CHI-8C0047 
         END IF
      END IF
      IF (NOT cl_null(g_pmm_t.pmm22)) AND (NOT cl_null(g_pmm.pmm22)) THEN
        IF g_pmm_t.pmm22 != g_pmm.pmm22 AND l_sw_pmm42 = 'Y' THEN
           LET l_sw_pmm42 = 'Y'  
        END IF
      END IF
      IF l_sw_pmm42 = 'Y' THEN
        CALL cl_err('','axm-190',1)
      END IF
 
      IF g_pmm_t.pmm40<>0  OR g_pmm_t.pmm40t<>0 THEN   #MOD-760025 add
      LET l_sw_pmm43 = 'N'                       # BugNo.7259
      #CHI-CB0008 mark begin---
      #IF (NOT cl_null(g_pmm_t.pmm43)) AND (NOT cl_null(g_pmm.pmm43)) THEN
      #   IF g_pmm_t.pmm43 != g_pmm.pmm43 THEN
      #     IF cl_confirm('axm-191') THEN   #CHI-6B0009 add
      #      LET l_sw_pmm43 = 'Y'
      #     END IF                          #CHI-6B0009 add
      #   END IF
      #END IF                                     # BugNo.7259 END
      #CHI-CB0008 mark end------

      #CHI-CB0008 add begin---
      IF g_pmm_t.pmm43 != g_pmm.pmm43 OR cl_null(g_pmm_t.pmm43) THEN
         LET l_sw_pmm43 = 'Y'
      END IF

      SELECT gec07 INTO l_gec07
          FROM gec_file
         WHERE gec01 = g_pmm_t.pmm21
           AND gec011='1'  #進項

      IF (g_pmm_t.pmm43 = g_pmm.pmm43 AND g_gec07 <> l_gec07) OR cl_null(l_gec07) THEN
         IF cl_confirm('axm-191') THEN
            LET l_sw_pmm43 = 'Y'
         END IF
      END IF
      #CHI-CB0008 add end-----
      END IF    #MOD-760025 add
 
      IF g_pmm.pmmmksg  MATCHES'[Yy]'  THEN
         IF g_argv2='1' THEN                     # 為巳核准
            IF g_sma.sma77 = '2' THEN            # 不可重簽
               CALL cl_err('','mfg6144',1)  #MOD-640492 0->1
               CALL s_signm(6,34,g_lang,'2',g_pmm.pmm01,3,g_pmm.pmmsign,
                            g_pmm.pmmdays,g_pmm.pmmprit,g_pmm.pmmsmax,
                            g_pmm.pmmsseq)
            ELSE                                 # 可重簽
               CALL s_signm(6,34,g_lang,'1',g_pmm.pmm01,3,g_pmm.pmmsign,
                            g_pmm.pmmdays,g_pmm.pmmprit,g_pmm.pmmsmax,
                            g_pmm.pmmsseq)
                  RETURNING g_pmm.pmmsign,      # 等級
                            g_pmm.pmmdays,
                            g_pmm.pmmprit,
                            g_pmm.pmmsmax,      # 應簽
                            g_pmm.pmmsseq,      # 已簽
                            g_statu
 
              #重簽的處理1:將巳簽歸零2:過程檔delete 3:狀況碼為0.開立
              LET g_pmm.pmmsseq = 0
              LET g_pmm.pmm25   = '0'
 
              DELETE FROM azd_file
               WHERE azd01=g_pmm.pmm01 AND azd02 = 3
           END IF
         END IF
      END IF
 
      IF cl_null(g_pmm.pmm03) THEN LET g_pmm.pmm03=0 END IF
 
      #-modi 採購多角貿易  kammy
      IF g_pmm.pmm02 = 'TAP' THEN
         LET g_pmm.pmm901= 'Y'         #多角貿易採購單
         LET g_pmm.pmm902= 'N'         #最終採購單否
         LET g_pmm.pmm905= 'N'         #多角貿易拋轉否
         LET g_pmm.pmm906= 'Y'         #多角貿易來源採購單否
      ELSE
         LET g_pmm.pmm901= 'N'
         LET g_pmm.pmm902= ' '         #最終採購單否
         LET g_pmm.pmm905= 'N'         #多角貿易拋轉否 #TQC-740044
         LET g_pmm.pmm906= ' '         #多角貿易來源採購單否
      END IF
      LET g_pmm.pmm25 = '0'              #FUN-550038

      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file   #MOD-A30089
        WHERE azi01=g_pmm.pmm22   #MOD-A30089
 
      IF l_sw_pmm43 = 'Y' THEN
         IF g_gec07 = 'N' THEN
            LET g_pmm.pmm40t = g_pmm.pmm40*(1.00+g_pmm.pmm43/100.0)
            LET g_pmm.pmm40t = cl_digcut(g_pmm.pmm40t,g_azi04)
         ELSE
            LET g_pmm.pmm40 = g_pmm.pmm40t/(1.00+g_pmm.pmm43/100.0)
            LET g_pmm.pmm40 = cl_digcut(g_pmm.pmm40,g_azi04)
         END IF
      END IF
 
      UPDATE pmm_file SET pmm_file.* = g_pmm.*    # 更新DB
       WHERE pmm01 = g_pmm01_t                 # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      IF g_pmm.pmm01 != g_pmm_t.pmm01 THEN
         UPDATE pmn_file SET pmn01=g_pmm.pmm01 WHERE pmn01=g_pmm_t.pmm01
         IF STATUS THEN
            CALL cl_err3("upd","pmn_file",g_pmm_t.pmm01,"",SQLCA.sqlcode,"","upd pmn01",1)  #No.FUN-660129
            ROLLBACK WORK
            RETURN
         END IF
         UPDATE pmz_file SET pmz01=g_pmm.pmm01 WHERE pmz01=g_pmm_t.pmm01
         UPDATE pmo_file SET pmo01=g_pmm.pmm01 WHERE pmo01=g_pmm_t.pmm01
         UPDATE pmp_file SET pmp01=g_pmm.pmm01 WHERE pmp01=g_pmm_t.pmm01
      END IF
 
     #當單頭的pmm45改成N時,要將單身所有的pmn38全部改成N
      IF g_pmm.pmm45 != g_pmm_t.pmm45 AND g_pmm.pmm45='N' THEN
         UPDATE pmn_file SET pmn38 = 'N'
                       WHERE pmn01=g_pmm.pmm01
                      #當pmn24,pmn25不是空白的時候,
                      #表示單身的pmn38是由請購單的pml38帶過來的,不能修改
                         AND pmn24 IS NULL AND pmn25 IS NULL
         IF STATUS THEN
            CALL cl_err('upd pmn38',STATUS,1) ROLLBACK WORK RETURN
         END IF
      END IF
 
      #如單頭性質更改,單身也須更改96-09-13
      IF g_pmm.pmm02 != g_pmm_t.pmm02 THEN
 
         UPDATE pmn_file SET pmn011=g_pmm.pmm02 WHERE pmn01=g_pmm.pmm01
         IF STATUS THEN
            CALL cl_err3("upd","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","upd pmn011",1)  #No.FUN-660129
            ROLLBACK WORK RETURN
         END IF
 
      END IF
 
      #更改單身狀況
#FUN-B90103--------------add----
#FUN-B90103-------------end---- 
      DECLARE t540_stat CURSOR FOR
       SELECT pmn02,pmn31,pmn31t,pmn44,pmn87,pmn88t,pmn88 FROM pmn_file  #MOD-780171 pmn20 改為 pmn87計價數量金額才不會算錯   #TQC-870047 add pmn88
        WHERE pmn01 = g_pmm.pmm01
 
      IF NOT SQLCA.sqlcode THEN
 
         # 異動匯率,更改本幣單價                   #950228 Add By Jackson
#        FOREACH t540_stat INTO l_pmn02,l_pmn31,l_pmn31t,l_pmn44,l_pmn20,l_pmn88t,l_pmn88  #CHI-6B0006 add pmn20/pmn88t  #TQC-870047 add pmn88   #CHI-B70039 mark
         FOREACH t540_stat INTO l_pmn02,l_pmn31,l_pmn31t,l_pmn44,l_pmn87,l_pmn88t,l_pmn88  #CHI-B70039
 
         #-----MOD-A30089---------
         IF l_sw_pmm42 = 'Y' OR l_sw_pmm43 = 'Y' THEN 
            LET l_pmn31 = cl_digcut(l_pmn31,t_azi03)    
            LET l_pmn31t= cl_digcut(l_pmn31t,t_azi03)   
#           LET l_pmn88 = cl_digcut(l_pmn31*l_pmn20,t_azi04)    #CHI-B70039 mark
#           LET l_pmn88t= cl_digcut(l_pmn31t*l_pmn20,t_azi04)   #CHI-B70039 mark
            LET l_pmn88 = cl_digcut(l_pmn87*l_pmn31,t_azi04)    #CHI-B70039
            LET l_pmn88t= cl_digcut(l_pmn87*l_pmn31t,t_azi04)   #CHI-B70039
         END IF
         #-----END MOD-A30089-----

         #幣別/匯率更改時，不異動單身資料僅做訊息提示 
         IF l_sw_pmm42 = 'Y' THEN
            LET l_pmn44 = cl_digcut( l_pmn31*g_pmm.pmm42, t_azi03 )  #No.CHI-6A0004
         END IF   
         
         IF l_sw_pmm43 = 'Y' THEN
            IF g_gec07 = 'N' THEN
               LET l_pmn31t = l_pmn31 * (1.00+g_pmm.pmm43 / 100.0)
               LET l_pmn31t = cl_digcut(l_pmn31t,t_azi03)  #No.MOD-8B0273 add
               LET l_pmn88t = l_pmn88 * (1.00+g_pmm.pmm43 / 100.0)
               LET l_pmn88t = cl_digcut(l_pmn88t,t_azi04)  #No.MOD-8B0273 add
            ELSE
               LET l_pmn31 = l_pmn31t/(1.00+g_pmm.pmm43/100.0)                                                                      
               LET l_pmn31 = cl_digcut(l_pmn31,t_azi03)
               #-----CHI-AC0016---------
               #LET l_pmn88 = l_pmn88t/(1.00+g_pmm.pmm43/100.0)
               #LET l_pmn88 = cl_digcut(l_pmn88,t_azi04)    #No.MOD-8B0273 add
               #IF g_gec05 = 'T' THEN
               IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                  #TQC-C30225 add begin
                  LET l_pmn31 = l_pmn31t*(1.00-g_pmm.pmm43/100.0)
                  LET l_pmn31 = cl_digcut(l_pmn31,t_azi03)                  
                  #TQC-C30225 add end
                  LET l_pmn88 = l_pmn88t*(1.00-g_pmm.pmm43/100.0)
                  LET l_pmn88 = cl_digcut(l_pmn88,t_azi04)   
               ELSE
                  LET l_pmn88 = l_pmn88t/(1.00+g_pmm.pmm43/100.0)
                  LET l_pmn88 = cl_digcut(l_pmn88,t_azi04)   
               END IF
               #-----END CHI-AC0016----- 
            END IF
         END IF
 
          #MOD-630039 此段發生若委外採購狀況為0開立時,當多筆不同工單的單身
          #           其中一筆為狀況8已結案,當做單頭更正時,所有單身會全部被
          #           更新同單頭0
         UPDATE pmn_file
            SET pmn16=g_pmm.pmm25,pmn31t=l_pmn31t,pmn44=l_pmn44
               ,pmn88t = l_pmn88t      #CHI-6B0006 add
               ,pmn88 = l_pmn88,pmn31=l_pmn31     #TQC-870047 add
          WHERE pmn01 = g_pmm.pmm01
            AND pmn02 = l_pmn02
            AND pmn16 NOT MATCHES'[678]'
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         
         END IF
         CALL t540_update()   #MOD-A30089
 
         END FOREACH
#FUN-B90103----------------add
#FUN-B90103----------------end-----------------
      END IF
      EXIT WHILE
   END WHILE
       CALL t540_b_fill(' 1=1',' 1=1') #MOD-630039   #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
   IF l_sw_pmm43 = 'Y' THEN
      CALL t540_show()                      # 重新顯示
   END IF
 
   DISPLAY BY NAME g_pmm.pmm25
 
   CALL t540_pic() #FUN-730012
 
   CLOSE t540_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmm.pmm01,'U')
 
END FUNCTION
 
FUNCTION t540_sign(p_cmd)
        DEFINE     p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                   l_slip   LIKE oay_file.oayslip,  #No.FUN-680136 VARCHAR(05) #No.FUN-540027
                   l_pmmsign   LIKE pmm_file.pmmsign
 
      #IF cl_null(g_pmm.pmm01) THEN CALL cl_err('','-400',1) RETURN END IF  #MOD-640492 0->1   #TQC-C70068 mark  會顯示多餘錯誤信息
       IF g_pmm.pmmmksg MATCHES'[nN]' OR g_pmm.pmm25 matches'[269]' THEN
          RETURN
       END IF
         LET g_pmm.pmmdays=g_smy.smydays #1999/04/21 add by Carol
       IF p_cmd = 'a' OR g_argv2 matches'[0X]' THEN
            LET g_pmm.pmmdays=g_smy.smydays
            LET l_pmmsign = ' '
            IF p_cmd = 'b' THEN
               LET g_smy.smyatsg=' '
              LET l_slip = s_get_doc_no(g_pmm.pmm01)       #No.FUN-540027
              SELECT smyatsg INTO g_smy.smyatsg FROM smy_file
                WHERE smyslip = l_slip
               SELECT pmmsign INTO l_pmmsign FROM pmm_file
                WHERE pmm01 = g_pmm.pmm01
            END IF
            IF g_smy.smyatsg matches'[Yy]' THEN   #自動賦予簽核等級
               CALL s_sign(g_pmm.pmm01,3,'pmm01','pmm_file')
                RETURNING g_pmm.pmmsign
            END IF
            CALL signm_count(g_pmm.pmmsign) RETURNING g_pmm.pmmsmax
            IF l_pmmsign != g_pmm.pmmsign THEN
               UPDATE pmm_file SET pmmsign = g_pmm.pmmsign,
                                   pmmsmax = g_pmm.pmmsmax,
                                   pmmdays = g_pmm.pmmdays,
                                   pmmprit = g_pmm.pmmprit,
                                   pmmsseq = 0
               WHERE pmm01 = g_pmm.pmm01
               DELETE FROM azd_file WHERE azd01 = g_pmm.pmm01 AND azd02 = 3
            END IF
       ELSE
            IF g_argv2 = '1' THEN  #已核准P/R
               #重簽的處理1:將巳簽歸零2:過程檔delete 3:狀況碼為開立
               #如為自動符予簽核等級則要重新來過
               IF g_sma.sma77 = '1' THEN  #需重簽
                  LET g_smy.smyatsg = ' '
                  LET l_slip = s_get_doc_no(g_pmm.pmm01)       #No.FUN-540027
                  SELECT smyatsg INTO g_smy.smyatsg FROM smy_file
                   WHERE smyslip = l_slip
                  IF g_smy.smyatsg matches'[Yy]' THEN
                     CALL s_sign(g_pmm.pmm01,3,'pmm01','pmm_file')
                      RETURNING l_pmmsign
                  ELSE
                     CALL s_signm(6,34,g_lang,'1',g_pmm.pmm01,3,g_pmm.pmmsign,
                                  g_pmm.pmmdays,g_pmm.pmmprit,g_pmm.pmmsmax,
                                  g_pmm.pmmsseq)
                     RETURNING l_pmmsign,       #等級
                               g_pmm.pmmdays,
                               g_pmm.pmmprit,
                               g_pmm.pmmsmax,       #應簽
                               g_pmm.pmmsseq,       #已簽
                               g_statu
                  END IF
                  IF l_pmmsign != g_pmm.pmmsign THEN
                     CALL signm_count(l_pmmsign) RETURNING g_pmm.pmmsmax
                     UPDATE pmm_file SET pmmsseq = 0,
                                         pmm25 = '0',
                                         pmmsmax = g_pmm.pmmsmax,
                                         pmmsign = l_pmmsign,
                                         pmmdays = g_pmm.pmmdays,
                                         pmmprit = g_pmm.pmmprit
                     WHERE pmm01 = g_pmm.pmm01
                     DELETE FROM azd_file
                      WHERE azd01 = g_pmm.pmm01 AND azd02 = 3 END IF
              ELSE
                     CALL s_signm(6,34,g_lang,'1',g_pmm.pmm01,3,g_pmm.pmmsign,
                       g_pmm.pmmdays,g_pmm.pmmprit,g_pmm.pmmsmax,g_pmm.pmmsseq)
                     RETURNING l_pmmsign,       #等級
                               g_pmm.pmmdays,
                               g_pmm.pmmprit,
                               g_pmm.pmmsmax,       #應簽
                               g_pmm.pmmsseq,       #已簽
                               g_statu
                     IF l_pmmsign != g_pmm.pmmsign THEN
                        CALL signm_count(l_pmmsign) RETURNING g_pmm.pmmsmax
                        UPDATE pmm_file SET pmmsseq = 0,
                                            pmm25 = '0',
                                            pmmsmax = g_pmm.pmmsmax,
                                            pmmsign = l_pmmsign,
                                            pmmdays = g_pmm.pmmdays,
                                            pmmprit = g_pmm.pmmprit
                         WHERE pmm01 = g_pmm.pmm01
                         DELETE FROM azd_file
                          WHERE azd01 = g_pmm.pmm01 AND azd02 = 3
                     END IF
               END IF
            END IF
       END IF
END FUNCTION
 
FUNCTION t540_r()
   LET g_success='Y'  #FUN-920190
   CALL t540sub_r(g_pmm.pmm01,g_action_choice,TRUE)   #FUN-920190

   IF g_success='Y' THEN
      CLEAR FORM
      CALL g_pmn.clear()
      INITIALIZE g_pmm.* TO NULL
      CALL cl_msg("")
      OPEN t540_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t540_cs
         CLOSE t540_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t540_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t540_cs
         CLOSE t540_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t540_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t540_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t540_fetch('/')
      END IF
   END IF
END FUNCTION
 
FUNCTION t540_copy()
   DEFINE
      l_newno         LIKE pmm_file.pmm01,
      l_newdate       LIKE pmm_file.pmm04,
      l_pmm31         LIKE pmm_file.pmm31,
      l_pmm32         LIKE pmm_file.pmm32,
      p_stat          LIKE type_file.chr1,       #No.FUN-680136  VARCHAR(01)
      l_oldno         LIKE pmm_file.pmm01
   DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
 
            IF s_shut(0) THEN RETURN END IF
            IF cl_null(g_pmm.pmm01) THEN
                  CALL cl_err('',-400,1)  #MOD-640492 0->1
                  RETURN
            END IF
            IF g_argv2 MATCHES '[Yy]' THEN
               CALL cl_err('','mfg0055',1) #MOD-640492 0->1
                  RETURN
            END IF
               IF g_sma.sma32 MATCHES '[Yy]' THEN
                   CALL cl_err('','apm-013',1)
                   RETURN
               END IF
 
                LET g_before_input_done = FALSE   #FUN-580027
                CALL t540_set_entry('a')          #FUN-580027
                LET g_before_input_done = TRUE    #FUN-580027
                LET l_newdate=NULL
            CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
            INPUT l_newno,l_newdate WITHOUT DEFAULTS FROM pmm01,pmm04
                BEFORE INPUT
                  CALL cl_set_docno_format("pmm01")
 
                 AFTER FIELD pmm01
                        IF l_newno[1,g_doc_len] IS NULL THEN
                           NEXT FIELD pmm01
                        END IF
                IF g_prog='aict040' THEN LET g_chr1='A' ELSE LET g_chr1='2' END IF   #TQC-9B0191
                CALL s_check_no("apm",l_newno,"",g_chr1,"pmm_file","pmm01","")  #TQC-9B0191
                   RETURNING li_result,l_newno
                DISPLAY l_newno TO pmm01
                IF (NOT li_result) THEN
                     NEXT FIELD pmm01
                   END IF
 
                     AFTER FIELD pmm04       #採購日期(預設會計年度/期間)
                       IF cl_null(l_newdate) THEN
                          NEXT FIELD pmm04
                       ELSE
                         SELECT azn02,azn04 INTO l_pmm31,l_pmm32 FROM azn_file
                          WHERE azn01 = l_newdate
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("sel","azn_file",l_newdate,"","mfg0027","","",1)  #No.FUN-660129
                            LET l_newdate = g_pmm.pmm04
                            DISPLAY l_newdate TO pmm04
                            NEXT FIELD pmm04
                         END IF
                         CALL s_get_bookno(YEAR(l_newdate))
                              RETURNING g_flag,g_bookno1,g_bookno2
                         IF g_flag =  '1' THEN  #抓不到帳別
                            CALL cl_err(l_newdate,'aoo-081',1)
                            NEXT FIELD pmm04
                         END IF
                       END IF
                       BEGIN WORK #No:7857
     CALL s_auto_assign_no("apm",l_newno,l_newdate,"","pmm_file","pmm01","","","")
     RETURNING li_result,l_newno
     IF (NOT li_result) THEN
       NEXT FIELD pmm01
     END IF
     DISPLAY l_newno TO pmm01
 
                    ON ACTION CONTROLP
                       CASE
                           WHEN INFIELD(pmm01) #單據編號
                                LET g_t1 = s_get_doc_no(l_newno)       #No.FUN-540027
                                IF g_prog='aict040' THEN LET g_chr1='A' ELSE LET g_chr1='2' END IF   #TQC-9B0191
                                CALL q_smy(FALSE,FALSE,g_t1,'APM',g_chr1) RETURNING g_t1  #TQC-670008
                                LET l_newno=g_t1    #No.FUN-540027
                                DISPLAY l_newno TO pmm01
                                NEXT FIELD pmm01
                       END CASE
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
      ROLLBACK WORK
                  DISPLAY BY NAME g_pmm.pmm01
               RETURN
            END IF
            DROP TABLE y
            IF g_pmm.pmmmksg = 'N' THEN
               LET p_stat = '1' ELSE  LET p_stat = '0'
            END IF
            SELECT * FROM pmm_file         #單頭複製
             WHERE pmm01=g_pmm.pmm01
              INTO TEMP y
            UPDATE y
                  SET pmm01=l_newno,    #新的鍵值
                            pmm03= 0     ,    #更動序號
                            pmm04= l_newdate, #單據日期
                            pmm18= 'N',
                            pmm25= '0'   ,    #狀況碼
                            pmm27= g_today,   #狀況日期
                            pmm31= l_pmm31,   #年度     #No.B451
                            pmm32= l_pmm32,   #月份     #No.B451
                            pmm905='N',       #No.7920
                            pmm99=NULL,       #No.MOD-5C0024
                            pmmsseq=0,        #已簽人數
                            pmmprdt= NULL,    #列印日期
                            pmmprno= 0,       #列印次數
                            pmmmksg=g_smy.smyapr,#是否簽核 BugNo:6418
                            pmmuser=g_user,   #資料所有者
                            pmmgrup=g_grup,   #資料所有者所屬群
                            pmmmodu=NULL,     #資料修改日期
                            pmmdate=g_today,  #資料建立日期
                            pmmcrat = g_today,                 #NO.FUN-960130
                            pmmcond = NULL,                    #NO.FUN-960130
                            pmmconu = NULL,                    #NO.FUN-960130
                            pmmpos = 'N',     #NO.FUN-960130
                            pmmcont = '',      #NO.FUN-960130
                            pmmacti='Y'       #有效資料
                INSERT INTO pmm_file
                 SELECT * FROM y
                 IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   RETURN
                 ELSE
                   COMMIT WORK
                 END IF
#FUN-B90103--add-------------
#FUN-B90103--end-------------
            DROP TABLE x
            SELECT * FROM pmn_file         #單身複製
                  WHERE pmn01=g_pmm.pmm01
                  INTO TEMP x
            IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                  RETURN
            END IF
            UPDATE x
                  SET pmn01=l_newno,
                      pmn05= ' ',
                     #pmn24= ' ',    #NO.3545 #MOD-CA0164 mark
                     #pmn25= 0,               #MOD-CA0164 mark
                      pmn24= NULL,            #MOD-CA0164 add
                      pmn25= NULL,            #MOD-CA0164 add
                      pmn16= '0',
                      pmn65='1',
                     #pmn41= ' ',    #TQC-C10119
                      pmn50= 0,
                      pmn51= 0,
                      pmn53= 0,
                      pmn55= 0,
                      pmn57= 0,
                      pmn58= 0,
                      pmn59= ' ',pmn60 = 0,   #NO.3641
                      pmn68= ' ',pmn69=NULL   #No.9842 pmn69(smallint 不可用' ' ) #NO.3545 pmn69 = ' '
            UPDATE x SET pmn012=' ' WHERE pmn01=g_pmm01 AND pmn012 IS NULL #No.TQC-A60113
            INSERT INTO pmn_file
                  SELECT * FROM x
            IF SQLCA.sqlcode THEN
#              ROLLBACK WORK #No:7857   #MOD-B70246 mark
               CALL cl_err3("ins","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               ROLLBACK WORK            #MOD-B70246
               RETURN
            ELSE
               COMMIT WORK #No:7857
            END IF
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
             LET l_oldno = g_pmm.pmm01
             SELECT pmm_file.* INTO g_pmm.* FROM pmm_file
                  WHERE pmm01 = l_newno
             CALL t540_u()
             #SELECT pmm_file.* INTO g_pmm.* FROM pmm_file  #FUN-C80046
             #     WHERE pmm01 = l_oldno                    #FUN-C80046
             #CALL t540_show()                              #FUN-C80046
            DISPLAY BY NAME g_pmm.pmm01
END FUNCTION
 
FUNCTION t540_prt()
   IF cl_null(g_pmn.getlength()) OR g_pmn.getlength() =0 THEN RETURN END IF    #No.TQC-7B0015
   #No.TQC-A30047  --Begin
   IF g_rec_b <= 0 THEN RETURN END IF
   #No.TQC-A30047  --End  
   IF cl_confirm('mfg3242') THEN CALL t540_out() END IF
END FUNCTION
 
FUNCTION t540_out()
   DEFINE l_cmd         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_prog        LIKE zz_file.zz01,      #No.FUN-680136 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_lang        LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) #No:6715可選擇列印(0.中文/1.英文/2.簡體)
   DEFINE l_pmc911      LIKE pmc_file.pmc911   #FUN-610028
   DEFINE l_conp        LIKE type_file.chr1     #FUN-B60074
 
   IF cl_null(g_pmm.pmm01) THEN
      CALL cl_err('','-400',1)  #MOD-640492 0->1
      RETURN
   END IF
   
      MENU ""
         ON ACTION prt_po_80
           # LET l_prog='apmr900' #FUN-C30085 mark
            LET l_prog='apmg900' #FUN-C30085 add
            EXIT MENU
 
         ON ACTION prt_po_132
           # LET l_prog='apmr901' #FUN-C30085 mark
            LET l_prog='apmg901' #FUN-C30085 add
            EXIT MENU
 
         ON ACTION exit
            EXIT MENU
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
 
          -- for Windows close event trapped
          COMMAND KEY(INTERRUPT)
                LET INT_FLAG=FALSE             #MOD-570244      mars
              LET g_action_choice = "exit"
              EXIT MENU
 
      END MENU

   SELECT pmmprsw INTO g_pmm.pmmprsw FROM pmm_file
    WHERE pmm01 = g_pmm.pmm01
   IF NOT cl_null(l_prog) THEN #BugNo:5548
      LET l_wc='pmm01="',g_pmm.pmm01,'"'
#MOD-B30618 mark --start--
#      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
#       WHERE zz01 = l_prog
#      IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc2 = ' ' THEN
#          LET l_wc2 ='Y Y Y'
#      END IF
#&ifdef ICD
#        LET l_cmd = l_prog CLIPPED,
#                  " '",g_today CLIPPED,"' ''",
#                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",   #FUN-7C0036 mod   #FUN-5B0059   #FUN-610028
#                  " '",l_wc CLIPPED,"' ",l_wc2
#&else
#        LET l_cmd = l_prog CLIPPED,
#                    " '",g_today CLIPPED,"' ''",
#                    " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",   #FUN-7C0036 mod   #FUN-5B0059   #FUN-610028
#                    " '",l_wc CLIPPED,"' '",l_wc2 CLIPPED,"' " #MOD-680097  add l_wc2  #,l_wc2
#&endif
#MOD-B30618 mark --end--
#FUN-B60074-mark-str--
#     #MOD-B30618 add --start--
#      LET l_cmd = l_prog CLIPPED,
#                  " '",g_today CLIPPED,"' ''",
#                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'", 
#                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
#     #MOD-B30618 add --end--
#FUN-B60074-mark-end--
#FUN-B60074-add-str--
      LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
#FUN-B60074-add-end--
      CALL cl_cmdrun(l_cmd)
   END IF
 
END FUNCTION
 
 
FUNCTION t540_reverse()          #發出還原
     DEFINE    l_pmn50  LIKE pmn_file.pmn50,
               l_pmn02  LIKE pmn_file.pmn02,
               l_pmn04  LIKE pmn_file.pmn04,
               l_pmn20  LIKE pmn_file.pmn20,
               l_pon20  LIKE pon_file.pon20,
               l_pmn41  LIKE pmn_file.pmn41,
               l_sfb100 LIKE sfb_file.sfb100,
               l_sfb87  LIKE sfb_file.sfb87,
               l_sfb04  LIKE sfb_file.sfb04,
               l_azn02  LIKE azn_file.azn02,
               l_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
               l_azn03  LIKE azn_file.azn03,
               l_azn04  LIKE azn_file.azn04,
               l_azn05  LIKE azn_file.azn05,
               l_sql    STRING, #No.FUN-680136 VARCHAR(100) #FUN-730068
               l_cnt    LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    LET g_errno = ' ' #MOD-780108 add
    IF g_pmm.pmm01 IS NULL THEN
       CALL cl_err('',-400,1)
       LET g_errno='-400'  #MOD-780108 add
       RETURN
    END IF
    IF  g_pmm.pmm25 NOT MATCHES'[2]' THEN
        CALL cl_err('','mfg3410',1)
       LET g_errno='mfg3410'  #MOD-780108 add
        RETURN
    END IF
 
    SELECT SUM(pmn50) INTO l_pmn50 FROM pmn_file WHERE pmn01 = g_pmm.pmm01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","sum(pmn50) fail :",1)  #No.FUN-660129
    END IF
    IF l_pmn50 > 0 THEN
       CALL cl_err('','mfg3411',1)
       LET g_errno='mfg3411'  #MOD-780108 add
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM rvb_file,rva_file  #No7326
     WHERE rva01 = rvb01  AND rvaconf !='X'            #No7326
       AND rvb04=g_pmm.pmm01
    IF g_cnt > 0 THEN
       CALL cl_err('','apm-401',1)
       LET g_errno='apm-401'  #MOD-780108 add
       RETURN                 #MOD-780108 modify
    END IF
    SELECT COUNT(*) INTO g_cnt FROM pna_file
     WHERE pna01=g_pmm.pmm01
    IF g_cnt > 0 THEN
       #已有採購變更單，不允許進行發出還原。
       CALL cl_err('','apm-541',1)
       LET g_errno='apm-541'  #MOD-780108 add
       RETURN                 #MOD-780108 modify
    END IF

   #MOD-C50087 add start -----
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ala_file,alb_file
    WHERE ala01 = alb01 AND alafirm <> 'X'
      AND alb04 = g_pmm.pmm01
   IF g_cnt > 0 THEN
      #已有預購申請單,不可發出還原
      CALL cl_err('','apm1077',1)
      LET g_errno='apm1031'
      RETURN
   END IF
   #MOD-C50087 add end   -----

    #-----MOD-BA0028---------
    LET g_cnt = 0 
    SELECT COUNT(*) INTO g_cnt FROM apa_file,apb_file
     WHERE apa01 = apb01
       AND apa42 <> 'Y'
       AND apb06 = g_pmm.pmm01 
    IF g_cnt > 0 THEN
       #已有預付帳款,不可發出還原
       CALL cl_err('','apm1063',1)
       LET g_errno='apm1031'
       RETURN
    END IF
    #-----END MOD-BA0028-----
 
   #MOD-B40127 mark --start--
   ##判斷若為委外採購單,其工單已發料過帳,則不可做發出還原的動作
   #IF g_argv2='0' AND g_argv3='SUB' THEN   #委外採購單
   #   LET g_cnt = 0
   #   SELECT COUNT(*) INTO g_cnt FROM sfp_file
   #    WHERE sfp01 IN (SELECT DISTINCT sfq01 FROM sfq_file
   #                     WHERE sfq02=g_pmm.pmm01)
   #      AND sfp04 = 'Y'
   #   IF g_cnt > 0 THEN
   #      #此工單之委外成套發料單已過帳，不允許進行發出還原。
   #      CALL cl_err('','apm-850',1)
   #      LET g_errno='apm-850'  #MOD-780108 add
   #      RETURN                 #MOD-780108 modify
   #   END IF
   #END IF
   #MOD-B40127 mark --end--
 
 
    IF s_yorn(0,0,'2') THEN  #MOD-750082 add
    LET g_success = 'Y'
    BEGIN WORK            #MOD-750082 add
    DECLARE t540_reverse CURSOR FOR
         SELECT pmn41 FROM pmn_file WHERE pmn01 = g_pmm.pmm01
    FOREACH t540_reverse INTO l_pmn41
         IF cl_null(l_pmn41) THEN CONTINUE FOREACH END IF
         SELECT sfb87,sfb04 INTO l_sfb87,l_sfb04 FROM sfb_file
          WHERE sfb01=l_pmn41
         IF l_sfb100 != '2' THEN #No.9034
            IF l_sfb87 = 'Y' THEN LET g_success = 'N' EXIT FOREACH END IF
         END IF                  #No.9034
    END FOREACH
    IF g_success = 'N' THEN
       CALL cl_err('','apm-279',1)
       ROLLBACK WORK  #MOD-750082 add
       LET g_errno='apm-279'  #MOD-780108 add
       RETURN
    END IF
       OPEN t540_cl USING g_pmm.pmm01
       IF STATUS THEN
          CALL cl_err("OPEN t540_cl:", STATUS,1)
          LET g_errno=STATUS  #MOD-780108 add
          CLOSE t540_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t540_cl INTO g_pmm.*               # 對DB鎖定
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)   #MOD-640492 0->1
          LET g_errno=SQLCA.sqlcode  #MOD-780108 add
          ROLLBACK WORK
          RETURN
       END IF
       UPDATE pmm_file SET pmm25 = '1' WHERE pmm01 = g_pmm.pmm01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","Update pmm25 fail:",1)  #No.FUN-660129
          LET g_success = 'N'
       END IF
       UPDATE pmn_file SET pmn16 = '1' ,pmn36=null
        WHERE pmn01 = g_pmm.pmm01
          AND pmn16 = '2'   #MOD-630039
                                         AND pmn16 = '2'   #MOD-630039
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","pmn_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","Update pmn16 fail:",1)  #No.FUN-660129
          LET g_success = 'N'
       END IF
 
       IF g_success = 'Y' THEN
          CALL cl_cmmsg(1) COMMIT WORK
       ELSE
          CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
 
    END IF
    SELECT * INTO g_pmm.* FROM pmm_file
     WHERE pmm01=g_pmm.pmm01
    CALL t540_show()                      # 重新顯示
END FUNCTION
 
FUNCTION t540_s()       #替代
   DEFINE old_part                      LIKE pmn_file.pmn04 #No.MOD-490217
   DEFINE old_seq,i,j,l_i,l_n           LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE old_qty,left_qty              LIKE pmn_file.pmn20    #TQC-770103 modify INTEGER
   DEFINE l_pmn  RECORD LIKE pmn_file.*
   DEFINE l_bmd05,l_bmd06               LIKE type_file.dat     #No.FUN-680136 DATE
#   DEFINE l_tot                         LIKE ima_file.ima26    #No.FUN-680136 DECIMAL(13,3) #FUN-A20044
   DEFINE l_tot                         LIKE type_file.num15_3    #No.FUN-680136 DECIMAL(13,3) #FUN-A20044
   DEFINE l_pmn31     LIKE pmn_file.pmn31     #TQC-680028 add
   DEFINE l_pmn31t    LIKE pmn_file.pmn31t    #TQC-680028 add
   DEFINE new DYNAMIC ARRAY OF RECORD
          new_part                 LIKE ima_file.ima01,   #No.MOD-490217
          new_rate                  LIKE pmn_file.pmn62,   #No.FUN-680136 DECIMAL(6,3)
          new_yes                   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
          new_qty                   LIKE pmn_file.pmn20, #TQC-770103 modify INTEGER,
          new_qty3                  LIKE pmn_file.pmn20  #TQC-770103 modify INTEGER
          END RECORD,
          l_allow_insert  LIKE type_file.num5,       #可新增否  #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5        #可刪除否  #No.FUN-680136 SMALLINT
   DEFINE l_ima915        LIKE ima_file.ima915       #FUN-710060 add
   DEFINE l_ecm04         LIKE ecm_file.ecm04,       #CHI-8A0022
          l_pmh21         LIKE pmh_file.pmh21,       #No.CHI-8C0017
          l_pmh22         LIKE pmh_file.pmh22        #No.CHI-8C0017   
   DEFINE l_pmh24         LIKE pmh_file.pmh24        #FUN-940083
   DEFINE l_pmc914        LIKE pmc_file.pmc914       #FUN-940083
   DEFINE l_cnt           LIKE type_file.num5        #CHI-A50014 add
 
   LET p_row = 2 LET p_col = 30
   OPEN WINDOW i5403_w AT p_row,p_col
        WITH FORM "apm/42f/apmt5403"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt5403")
 
   WHILE TRUE
      INPUT BY NAME old_seq WITHOUT DEFAULTS
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help() 
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i5403_w EXIT WHILE END IF
      SELECT * INTO l_pmn.* FROM pmn_file
             WHERE pmn01 = g_pmm.pmm01 AND pmn02 = old_seq
      IF STATUS THEN
         CALL cl_err3("sel","pmn_file",g_pmm.pmm01,"",STATUS,"","sel pmn",1) #No.FUN-660129
         CONTINUE WHILE END IF  #MOD-640492 0->1
      IF l_pmn.pmn16 NOT MATCHES "[01]" THEN
         CALL cl_err('','mfg3208',1) CONTINUE WHILE  #MOD-640492 0->1
      END IF
      LET l_pmn31 = l_pmn.pmn31   #TQC-680028 add
      LET l_pmn31t= l_pmn.pmn31t  #TQC-680028 add
      LET l_pmn.pmn61 = l_pmn.pmn04
      LET left_qty = l_pmn.pmn20
      LET old_part = l_pmn.pmn04
      LET old_qty = l_pmn.pmn20 - l_pmn.pmn50 + l_pmn.pmn55  #No.+032
      DISPLAY BY NAME old_part,old_qty,l_pmn.pmn07
     #IF old_qty <=0 THEN CALL cl_err('','mfg3374',1) CONTINUE WHILE END IF  #MOD-640492 0->1   #CHI-A50014 mark
      IF old_qty <=0 AND l_pmn.pmn20 >0 THEN CALL cl_err('','mfg3374',1) CONTINUE WHILE END IF  #CHI-A50014
 
      DECLARE i400_sc CURSOR FOR
              SELECT DISTINCT bmd04,bmd07,'N',0,0,bmd03,bmd05,bmd06 FROM bmd_file
                 WHERE bmd01 = old_part AND bmd02='2'
                   AND bmdacti = 'Y'                                           #CHI-910021
                 ORDER BY bmd03
      CALL new.clear()
      LET l_n = 1
      LET l_i = 0
      FOREACH i400_sc INTO new[l_n].*,j,l_bmd05,l_bmd06
        IF STATUS THEN CALL cl_err('foreach',STATUS,1) CONTINUE WHILE END IF #MOD-640492 0->1
        IF new[l_n].new_rate = 0 THEN LET new[l_n].new_rate = 1 END IF
        IF g_pmm.pmm04<l_bmd05 THEN CONTINUE FOREACH END IF      #判斷生效日
        IF g_pmm.pmm04>l_bmd06 AND NOT cl_null(l_bmd06) THEN     #判斷失效日
           CONTINUE FOREACH
        END IF
        LET l_n = l_n + 1
      END FOREACH
 
      CALL new.deleteElement(l_n)
      LET l_i = l_n - 1
 
      IF l_i = 0 THEN CALL cl_err('','mfg6201',1) CONTINUE WHILE END IF  #MOD-640492 0->1
 
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
 
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
            ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(i)
            END IF
 
         BEFORE ROW
            LET i = ARR_CURR()
 
         BEFORE FIELD new_part
            IF NOT cl_null(new[i].new_part) THEN
               NEXT FIELD new_yes
            END IF
 
         AFTER FIELD new_part
            IF NOT cl_null(new[i].new_part) THEN
               SELECT {ima02,ima44,}1
                       INTO {new[i].ima02,new[i].unit,}new[i].new_rate
                       FROM ima_file
                      WHERE ima01=new[i].new_part
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",new[i].new_part,"",STATUS,"","sel ima:",1)  #No.FUN-660129
                  NEXT FIELD new_part
               END IF
            END IF
 
         BEFORE FIELD new_qty
            IF new[i].new_yes='Y' THEN
               SELECT ima915 INTO l_ima915 FROM ima_file
                WHERE ima01=new[i].new_part
               IF l_ima915='2' OR l_ima915='3' THEN
                  CALL t540sub_pmh(new[i].new_part,g_pmn[l_ac].pmn41,   #No.TQC-910033 ADD
                                   g_pmn[l_ac].pmn43,l_pmn.pmn18,g_pmn[l_ac].pmn012,g_pmm.*,g_type)    #No.TQC-910033  #No.FUN-A60011
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(new[i].new_part,g_errno,1)  #MOD-640492 0->1
                     NEXT FIELD new_yes
                  END IF
               END IF
            ELSE
               LET new[i].new_qty = 0
               DISPLAY new[i].new_qty TO s_new[j].new_qty
            END IF
 
         AFTER FIELD new_qty
            LET new[i].new_qty3 = new[i].new_qty / new[i].new_rate
            DISPLAY new[i].new_qty3 TO s_new[j].new_qty3
            LET l_tot = 0
            FOR i = 1 TO 10
               IF NOT cl_null(new[i].new_part) AND
                 #new[i].new_yes = "Y" AND new[i].new_qty > 0 THEN #CHI-A50014 mark
                  new[i].new_yes = "Y"  THEN                       #CHI-A50014
                  LET l_tot = l_tot + new[i].new_qty3
               END IF
            END FOR
            DISPLAY BY NAME l_tot
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET g_success = 'Y'
 
            BEGIN WORK
            LET l_tot = 0
            FOR i = 1 TO new.getLength()
               IF NOT cl_null(new[i].new_part) AND
                 #new[i].new_yes = "Y" AND new[i].new_qty > 0 THEN  #CHI-A50014 mark
                  new[i].new_yes = "Y"  THEN                        #CHI-A50014
                  LET l_tot = l_tot + new[i].new_qty3
                  #CHI-A50014 mark --start--
                  #SELECT MAX(pmn02)+1 INTO l_pmn.pmn02 FROM pmn_file
                  #       WHERE pmn01 = g_pmm.pmm01
                  #CHI-A50014 mark --end--
                  #CHI-A50014 add --start--
                  LET l_pmn.pmn20 = 0
                  SELECT COUNT(*) INTO l_cnt FROM pmn_file
                     WHERE pmn01 = g_pmm.pmm01
                       AND pmn04 = new[i].new_part
                       AND pmn42 = 'S'
                  IF l_cnt > 0 THEN
                     SELECT pmn02,pmn20 INTO l_pmn.pmn02,l_pmn.pmn20 FROM pmn_file
                        WHERE pmn01 = g_pmm.pmm01
                          AND pmn04 = new[i].new_part
                          AND pmn42 = 'S'
                  ELSE
                     SELECT MAX(pmn02)+1 INTO l_pmn.pmn02 FROM pmn_file
                        WHERE pmn01 = g_pmm.pmm01
                  END IF
                  IF l_pmn.pmn20 + new[i].new_qty < 0 THEN
                    #CALL cl_err('','mfg6202',1) #CHI-A50014 mark
                     CALL cl_err('','apm-544',1) #CHI-A50014
                     LET g_success = 'N'
                     EXIT FOR
                  END IF
                  #CHI-A50014 add --end--
                  LET l_pmn.pmn04 = new[i].new_part
                  LET l_pmn.pmn041 = NULL
                  SELECT ima02 INTO l_pmn.pmn041 FROM ima_file
                         WHERE ima01 = l_pmn.pmn04
                  LET l_pmn.pmn06 = NULL
                  #TQC-BC0121--begin
                  SELECT ima15 INTO l_pmn.pmn64 FROM ima_file
                   WHERE ima01 = l_pmn.pmn04
                  #TQC-BC0121--end
                  IF g_pmm.pmm02='SUB' THEN
                     LET l_pmh22='2'
                     IF NOT cl_null(l_pmn.pmn18) THEN
                        SELECT sgm04 INTO l_pmh21 FROM sgm_file
                         WHERE sgm01=l_pmn.pmn18
                           AND sgm02=l_pmn.pmn41
                           AND sgm03=l_pmn.pmn43
                           AND sgm012 = l_pmn.pmn012  #No.FUN-A60076
                     ELSE
                        SELECT ecm04 INTO l_pmh21 FROM ecm_file 
                         WHERE ecm01=l_pmn.pmn41
                           AND ecm03=l_pmn.pmn43
                           AND ecm012=l_pmn.pmn012    #No.FUN-A60011
                     END IF
                  ELSE
                     LET l_pmh22='1'
                     LET l_pmh21=' '
                  END IF
                  SELECT pmh04 INTO l_pmn.pmn06 FROM pmh_file
                         WHERE pmh01 = l_pmn.pmn04 AND pmh02 = g_pmm.pmm09
                           AND pmh13 = g_pmm.pmm22
                           AND pmh21 = l_pmh21 AND pmh22 = l_pmh22                       #CHI-8C0017
                           AND pmh23 = ' '                      #No.CHI-960033
                           AND pmhacti = 'Y'                                             #CHI-910021                           
                 #LET l_pmn.pmn20 = new[i].new_qty  #CHI-A50014 mark
                  LET l_pmn.pmn20 = l_pmn.pmn20 + new[i].new_qty  #CHI-A50014
                  LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)   #No.FUN-BB0086
                  #MOD-B50254 add --start--
                  LET g_factor = 1
                  CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86)
                       RETURNING g_cnt,g_factor
                  IF g_cnt = 1 THEN
                     LET g_factor = 1
                  END IF
                  LET l_pmn.pmn87 = l_pmn.pmn20 * g_factor
                  LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)   #No.FUN-BB0086
                  #MOD-B50254 add --end--
                  LET l_pmn.pmn50 = 0
                  LET l_pmn.pmn51 = 0
                  LET l_pmn.pmn53 = 0
                  LET l_pmn.pmn55 = 0
                  LET l_pmn.pmn57 = 0
                  LET l_pmn.pmn42 = 'S'
                  LET l_pmn.pmn62 = new[i].new_rate
                  #取替代後重新取價
                  LET l_ecm04=' '
                  IF NOT cl_null(l_pmn.pmn43) AND l_pmn.pmn43 != 0 THEN
                     SELECT ecm04 INTO l_ecm04 FROM ecm_file
                      WHERE ecm01 = l_pmn.pmn41 AND ecm03 = l_pmn.pmn43
                        AND ecm012= l_pmn.pmn012    #No.FUN-A60011
                  END IF
                  CALL s_defprice_new(l_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                                      l_pmn.pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                      l_pmn.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                         RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                                   l_pmn.pmn73,l_pmn.pmn74   #TQC-AC0257 add
                  IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73='4' END IF  #TQC-AC0257
                  CALL t540_price_check(l_pmn.pmn31,l_pmn.pmn31t)      #MOD-9C0285 ADD--
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                          #NEXT FIELD pmn86   #MOD-B10043 mark
                           LET g_success ='N' #MOD-B10043 add
                           EXIT FOR           #MOD-B10043 add
                        END IF
                  SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file     #No.CHI-6A0004
                   WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  #原幣
                  LET l_pmn.pmn44 = cl_digcut( l_pmn.pmn31*g_pmm.pmm42, g_azi03)      #No.CHI-6A0004
                  LET l_pmn.pmn88 = l_pmn.pmn31  * l_pmn.pmn87
                  LET l_pmn.pmn88t= l_pmn.pmn31t * l_pmn.pmn87
                  #MOD-B10138 add --start--
                  LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn88,t_azi04)
                  LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn88t,t_azi04)
                  #MOD-B10138 add --end--
                  IF g_gec07 = 'N' THEN
                     LET l_pmn.pmn88t = l_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
                     LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn88t,t_azi04) #MOD-B10138 add
                  ELSE
                     #-----CHI-AC0016---------
                     #LET l_pmn.pmn88  = l_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
                     #LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn88,t_azi04) #MOD-B10138 add
                     #IF g_gec05 = 'T' THEN
                     IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                        #TQC-C30225 add begin
                        LET l_pmn.pmn31  = l_pmn.pmn31t * ( 1 - g_pmm.pmm43/100)
                        LET l_pmn.pmn31 = cl_digcut(l_pmn.pmn31,t_azi03)                        
                        #TQC-C30225 add end
                        LET l_pmn.pmn88  = l_pmn.pmn88t * ( 1 - g_pmm.pmm43/100)
                        LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn88,t_azi04) 
                     ELSE
                        LET l_pmn.pmn88  = l_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
                        LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn88,t_azi04) 
                     END IF
                     #-----END CHI-AC0016-----
                  END IF
                 #MOD-B10138 mark --start-- 
                 #LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn88,t_azi04)
                 #LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn88t,t_azi04)
                 #MOD-B10138 mark --end--
                  LET l_pmn.pmn90=l_pmn.pmn31 #CHI-750005
                  SELECT pmh24 INTO l_pmh24 FROM pmh_file
                     WHERE pmh01 = l_pmn.pmn04
                       AND pmh02 = g_pmm.pmm09
                       AND pmh13 = g_pmm.pmm22
                       AND pmh21 = " "
                       AND pmh22 = '1'
                       AND pmh23 = ' '                      #No.CHI-960033
                       AND pmhacti = 'Y'
                  IF NOT cl_null(l_pmh24) THEN
                     LET l_pmn.pmn89=l_pmh24
                  ELSE
                     IF g_sma.sma93="Y" THEN                          #MOD-C30578  add 
                        SELECT pmc914 INTO l_pmc914 FROM pmc_file 
                         WHERE pmc01 = g_pmm.pmm09 
                        IF l_pmc914 = 'Y' THEN
                           LET l_pmn.pmn89 = 'Y'
                        ELSE
                           LET l_pmn.pmn89 = 'N'
                        END IF
                     END IF                                           #MOD-C30578  add
                  END IF
                  IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
                  IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
                  IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF   #TQC-9B0203
                  IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012=' ' END IF  #No.TQC-A60113
                  LET l_pmn.pmnplant = g_plant  #FUN-980006 add
                  LET l_pmn.pmnlegal = g_legal  #FUN-980006 add
                  #CHI-A50014 add --start--
                  IF l_pmn.pmn20 = 0 THEN
#MOD-B60119 -- begin --
                     DELETE FROM pmo_file
                        WHERE pmo01 = l_pmn.pmn01 
                        AND pmo03 = l_pmn.pmn02 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","pmo_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","",1)
                        LET g_success = 'N'
                        EXIT FOR
                     END IF
#MOD-B60119 -- end --
                     DELETE FROM pmn_file
                     WHERE pmn01 = l_pmn.pmn01
                       AND pmn02 = l_pmn.pmn02
                     IF STATUS THEN
                        CALL cl_err3("del","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","del pmn",1)
                        LET g_success ='N'
                        EXIT FOR
                     END IF
                  ELSE
                     IF l_cnt > 0 THEN
                        UPDATE pmn_file SET pmn_file.* = l_pmn.*   # 更新DB
                        WHERE pmn01 = l_pmn.pmn01
                          AND pmn02 = l_pmn.pmn02
                        IF STATUS THEN
                           CALL cl_err3("upd","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","upd pmn",1)
                           LET g_success ='N'
                           EXIT FOR
                        END IF
                     ELSE
                  #CHI-A50014 add --end--
                        CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                                        l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
                        INSERT INTO pmn_file VALUES (l_pmn.*)
                        IF STATUS THEN
#                          CALL cl_err('ins pmn',STATUS,1)   #No.FUN-660129
                           CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","ins pmn",1)  #No.FUN-660129
                           LET g_success ='N'
                           EXIT FOR
                        END IF
                     END IF
                  END IF  #CHI-A50014 add
               END IF
            END FOR
            DISPLAY BY NAME l_tot
            IF g_success = 'Y' THEN
               IF l_tot > old_qty THEN
                 #CALL cl_err('','mfg6202',1) LET g_success = 'N' #CHI-A50014 mark
                  CALL cl_err('','apm-544',1) LET g_success = 'N' #CHI-A50014
               ELSE
                  #MOD-B50254 add --start--
                  SELECT * INTO l_pmn.* FROM pmn_file
                   WHERE pmn01 = g_pmm.pmm01 AND pmn02 = old_seq
                  #MOD-B50254 add --end--
                  LET left_qty = left_qty - l_tot
                  LET left_qty = s_digqty(left_qty,l_pmn.pmn07)    #FUN-910088--add--
                  #MOD-B50254 add --start--
                  LET g_factor = 1
                  CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86)
                       RETURNING g_cnt,g_factor
                  IF g_cnt = 1 THEN
                     LET g_factor = 1
                  END IF
                  LET l_pmn.pmn87 = left_qty * g_factor
                  LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)   #No.FUN-BB0086
                  #MOD-B50254 add --end--
                 #MOD-B50254 mod --start--
                 #LET l_pmn.pmn88 = l_pmn31  * left_qty
                 #LET l_pmn.pmn88t= l_pmn31t * left_qty
                  LET l_pmn.pmn88 = l_pmn31  * l_pmn.pmn87 
                  LET l_pmn.pmn88t= l_pmn31t * l_pmn.pmn87 
                 #MOD-B50254 mod --end--
                  #MOD-B10138 add --start--
                  LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn88 , t_azi04)  
                  LET l_pmn.pmn88t = cl_digcut( l_pmn.pmn88t , t_azi04)  
                  #MOD-B10138 add --end--
                  IF g_gec07='Y' THEN
                     #-----CHI-AC0016---------
                     #LET l_pmn.pmn88 = l_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
                     #LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn88 , t_azi04)  
                     #IF g_gec05 = 'T' THEN
                     IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                        LET l_pmn.pmn88 = l_pmn.pmn88t * ( 1 - g_pmm.pmm43/100)
                        LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn88 , t_azi04)  
                     ELSE
                        LET l_pmn.pmn88 = l_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
                        LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn88 , t_azi04)  
                     END IF
                     #-----END CHI-AC0016-----
                    #LET l_pmn.pmn88t = cl_digcut( l_pmn.pmn88t , t_azi04)     #CHI-890026 #MOD-B10138 mark
                  ELSE
                     LET l_pmn.pmn88t = l_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
                     LET l_pmn.pmn88t = cl_digcut( l_pmn.pmn88t , t_azi04)  
                    #LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn88 , t_azi04)     #CHI-890026 #MOD-B10138 mark
                  END IF
                  
                  UPDATE pmn_file SET pmn20=left_qty,
                                      pmn87=l_pmn.pmn87,     #MOD-B50254 add
                                      pmn88=l_pmn.pmn88,     #TQC-680028 add
                                      pmn88t=l_pmn.pmn88t,   #TQC-680028 add
                                      pmn42='2'
                   WHERE pmn01 = g_pmm.pmm01 AND pmn02 = old_seq
                  IF STATUS THEN
                     CALL cl_err3("upd","pmn_file",g_pmm.pmm01,old_seq,STATUS,"","upd pmn",1)  #No.FUN-660129
                     LET g_success ='N'
                  END IF
               END IF
            END IF
            IF g_success = 'Y' THEN
               CALL  t540_update()    #MOD-670110 add
               COMMIT WORK
            ELSE
               ROLLBACK WORK
               NEXT FIELD new_yes
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG  THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i5403_w
      ELSE
         CLOSE WINDOW i5403_w
         ERROR ''
         CALL t540_pmm40_show()    #MOD-670110 add
         CALL t540_b_fill(' 1=1',' 1=1') #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t540_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n,l_n1        LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_date          LIKE type_file.dat,    #No.FUN-680136 DATE
    l_over          LIKE pmn_file.pmn20,
    p_qty           LIKE pmn_file.pmn20,   #MOD-7C0058
    l_ima07         LIKE ima_file.ima07,
    l_ima55         LIKE ima_file.ima55,
    l_pmn18         LIKE pmn_file.pmn18,
    l_pmn09         LIKE pmn_file.pmn09,
    l_pmm09         LIKE pmm_file.pmm09,     #No.MOD-620073 add
    l_pml07         LIKE pml_file.pml07,
    l_pmn50         LIKE pmn_file.pmn50,
    l_pmk25         LIKE pmk_file.pmk25,
    l_pml20,l_pmn20 LIKE pml_file.pml20,
    l_pon20         LIKE pon_file.pon20,
    l_sfb01         LIKE sfb_file.sfb01,
    l_sfb100        LIKE sfb_file.sfb100,
    l_sfa065        LIKE sfa_file.sfa065,
    l_sfa05         LIKE sfa_file.sfa05,
    l_qty,l_diff    LIKE pmn_file.pmn20,
    l_pml           RECORD LIKE pml_file.*,
    l_qty1          LIKE pmn_file.pmn20,
    l_sub_qty       LIKE pmn_file.pmn20,    #MOD-C30366 add
    l_ima53         LIKE ima_file.ima53,   #最近採購單價
    l_flag1         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE pmn_file.pmn07,    #No.FUN-680136 VARCHAR(04)
    l_feature       LIKE type_file.dat,     #No.FUN-680136 VARCHAR(05)    #No.TQC-5A0096
    l_pmmmksg       LIKE pmm_file.pmmmksg,
    l_sql           STRING, #No.FUN-680136 VARCHAR(100) #FUN-730068
    l_ecm04         LIKE ecm_file.ecm04,    #NO:7178
    l_fac           LIKE ima_file.ima31_fac, #No.FUN-680136 dec(16,8)
    l_allow_insert  LIKE type_file.num5,                 #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否  #No.FUN-680136 SMALLINT
    l_pmm25         LIKE pmm_file.pmm25,
    l_ima928        LIKE ima_file.ima928     #FUN-C30075 add
    DEFINE   l_success    LIKE type_file.chr1    #No.FUN-810016
    DEFINE   li_i         LIKE type_file.num5    #No.FUN-680136 SMALLINT
    DEFINE   l_count      LIKE type_file.num5    #No.FUN-680136 SMALLINT
    DEFINE   l_temp       LIKE ima_file.ima01
    DEFINE   l_check_res  LIKE type_file.num5    #No.FUN-680136 SMALLINT
    DEFINE   l_tqn        RECORD  LIKE tqn_file.*
    DEFINE   li_result    LIKE type_file.num5    #No.CHI-690066 add SMALLINT
    DEFINE  l_chr4      LIKE type_file.chr4
    DEFINE  l_ima915    LIKE ima_file.ima915     #FUN-710060 add
    DEFINE  l_m         LIKE type_file.num5      #No.TQC-7A0025 add
    DEFINE  l_pjb25     LIKE pjb_file.pjb25,
            l_pmn67     LIKE pmn_file.pmn67,
            l_pmn40     LIKE pmn_file.pmn40,
            l_pmn401    LIKE pmn_file.pmn401
    DEFINE  l_vmz01     LIKE vmz_file.vmz01   #NO.FUN-7C0002 
    DEFINE  l_pjb09     LIKE pjb_file.pjb09   #No.FUN-850027 
    DEFINE  l_pjb11     LIKE pjb_file.pjb11   #No.FUN-850027
    DEFINE  l_azf09     LIKE azf_file.azf09   #No.FUN-930145
    DEFINE  l_pmh24     LIKE pmh_file.pmh24   #FUN-940083
    DEFINE  l_pmc914    LIKE pmc_file.pmc914  #FUN-940083
    DEFINE  l_ima491    LIKE ima_file.ima491   #MOD-970018
    DEFINE  l_pml92     LIKE pml_file.pml92   #No.FUN-9C0046
    DEFINE  l_ima01     LIKE ima_file.ima01   #FUN-B10056
    DEFINE  l_flag2     LIKE type_file.num5   #FUN-B10056    
    DEFINE  l_sfb02     LIKE sfb_file.sfb02   #TQC-C10102
    DEFINE  l_cnt2      LIKE type_file.num5   #TQC-C20417 add
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#&ifdef SLK
#   DEFINE  l_ima25     LIKE ima_file.ima25   #FUN-A50054
#   DEFINE  l_ata02     LIKE ata_file.ata02
#   DEFINE  l_ata04     LIKE ata_file.ata04
#   DEFINE  l_ata05     LIKE ata_file.ata05   #FUN-A60035 add
#   DEFINE  l_ps        LIKE type_file.chr1
#   DEFINE  l_ata03_t   LIKE ata_file.ata03
#   DEFINE  l_ata04_t   LIKE ata_file.ata04 
#   DEFINE  l_ata08     LIKE ata_file.ata08
#   DEFINE  l_str       STRING
#   DEFINE  l_str1      STRING
#   DEFINE  l_ima151    LIKE ima_file.ima151  #FUN-A60035
#   DEFINE  l_pmn25_t   LIKE pmn_file.pmn25   #FUN-A60035
#&endif
##FUN-A50054---End          
#FUN-A60035 ---MARK END
#   DEFINE  l_index     LIKE type_file.num5   #FUN-A60035    #FUN-A60035 ---MARK
    DEFINE  l_rtz08     LIKE rtz_file.rtz08   #FUN-B40098
    DEFINE  l_rtz07     LIKE rtz_file.rtz07   #FUN-B60150 ADD
    DEFINE  l_smy59     LIKE smy_file.smy59   #MOD-B50145
    DEFINE  l_smyslip   LIKE smy_file.smyslip #MOD-B50145
    DEFINE  l_pnz07     LIKE pnz_file.pnz07   #FUN-B50150  # TQC-B60300 mark
    DEFINE  l_pmm41     LIKE pmm_file.pmm41   #FUN-B50150  # TQC-B60300 mark
#FUN-B90103-------------add
#FUN-B90103--------------end
   DEFINE l_tf   LIKE type_file.chr1   #No.FUN-BB0086
   DEFINE l_case STRING                #No.FUN-BB0086
   DEFINE l_pon07  LIKE pon_file.pon07     #FUN-910088--add--
   DEFINE l_pmn07  LIKE pmn_file.pmn07     #FUN-910088--add--
   DEFINE  l_pml16     LIKE pml_file.pml16   #MOD-BC0168 add
   DEFINE  l_wc        STRING                #TQC-C10071 add
   DEFINE  l_pmn20po   LIKE pmn_file.pmn20   #MOD-BB0264 add
   DEFINE  l_pondiff   LIKE pmn_file.pmn20   #MOD-BB0264 add
   DEFINE  l_pmn24_t   LIKE pmn_file.pmn24   #MOD-C30823 add
   DEFINE  l_pmn24_g   LIKE pmn_file.pmn24   #MOD-C30823 add
   DEFINE  l_pml80     LIKE pml_file.pml80   #MOD-C70256 add
   DEFINE  l_pml83     LIKE pml_file.pml83   #MOD-C70256 add
   DEFINE  l_pml86     LIKE pml_file.pml86   #MOD-C70256 add
   DEFINE  l_ima926    LIKE ima_file.ima926  #FUN-D30087 add
  #DEV-D40015 add str------
   DEFINE  l_ima932    LIKE ima_file.ima932
   DEFINE  l_pmc61     LIKE pmc_file.pmc61
  #DEV-D40015 add end------

    LET g_action_choice = ""
 
    LET g_errno = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_pmm.pmm01) THEN CALL cl_err('','-400',1)
       RETURN
    END IF

#TQC-B10162 --begin--
  #IF g_sma.sma45 matches'[Nn]' AND g_pmm.pmm909 != '5' THEN  #MOD-C50144 add  g_pmm.pmm909 != '5'        #MOD-D10041 mark
   IF g_sma.sma45 matches'[Nn]' AND g_pmm.pmm909 != '5' AND (g_argv3 != 'SUB' OR cl_null(g_argv3)) THEN  #採購單不可直接輸入 #MOD-D10041 add
      CALL cl_err(g_sma.sma45,'mfg0034',1)
      RETURN
   END IF
#TQC-B10162 --end--
 
    SELECT * INTO g_pmm.* FROM pmm_file
     WHERE pmm01=g_pmm.pmm01
 
    IF cl_null(g_argv3) THEN LET g_argv3=g_pmm.pmm02 END IF   #MOD-7A0126
 
    IF g_pmm.pmmacti ='N' THEN
       CALL cl_err(g_pmm.pmm01,'aom-000',1)
       RETURN
    END IF
 
    LET l_pmm25 = g_pmm.pmm25          #FUN-550038
 
    IF g_pmm.pmm18='X' THEN CALL cl_err('','9024',1) RETURN END IF  #MOD-640492 0->1
 
    IF g_pmm.pmm18='Y' THEN CALL cl_err('','9023',1) RETURN END IF #7263  #MOD-640492 0->1
 
    IF g_pmm.pmm25 matches '[Ss]' THEN
       CALL cl_err('','apm-030',1)  #MOD-640492 0->1
       RETURN
    END IF
 
    IF g_argv2 = '0' AND g_pmm.pmm18 ="Y" AND g_pmm.pmm25 = "1" AND g_pmm.pmmmksg = "Y"  THEN
       CALL cl_err('','mfg3168',1) RETURN   #MOD-640492 0->1
    END IF
 
    IF g_argv2 = '0' AND g_pmm.pmm18 = "Y" AND g_pmm.pmm25 = "1" AND g_pmm.pmmmksg = "N"
       AND g_argv3 !='SUB' THEN
       CALL cl_err('','9023',1)  #MOD-640492 0->1
       RETURN
    END IF
 
    IF g_argv2 MATCHES '[01]' AND g_pmm.pmm25 MATCHES'[269]' THEN
       CALL cl_err('','mfg9136',1) RETURN  #MOD-640492 0->1
    END IF
     
    LET g_success = 'Y'
    CALL cl_chg_comp_att("pmn31t","NOT NULL|REQUIRED|SCROLL","1|1|1")  #No.MOD-8C0298
 
    IF NOT cl_null(g_argv4) AND g_rec_b=0 THEN
       CALL t540_g_b()            # 若有工單號碼自動產生單身資料
       CALL t540_b_fill(' 1=1',' 1=1') #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
    END IF
 
    CALL cl_opmsg('b')
 
    CALL s_get_bookno(YEAR(g_pmm.pmm04))
         RETURNING g_flag,g_bookno1,g_bookno2
 
    LET g_forupd_sql =
     " SELECT * ",
     "    FROM pmn_file ",
     "    WHERE pmn01 = ? ",
     "     AND pmn02 = ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t540_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#FUN-B90103--add--begin--
#FUN-B90103--add--end--
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_pmn.clear() END IF
#FUN-B90103--add--begin----
#FUN-B90103--add--end------
     IF g_pmm.pmm909 = '3' THEN
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
     END IF
#FUN-B90103--add--str--
   IF g_azw.azw04='2' AND (g_prog="apmt540_slk" OR g_prog="apmt590_slk") THEN    #FUN-C20006--add 
#FUN-C20006-----end-------------------------
#FUN-B90103--end--------------------                                                       
ELSE      #FUN-C20006--add
     INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            #genero
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET g_value = NULL
            LET g_pmn04 = NULL
 
            BEGIN WORK
 
            OPEN t540_cl USING g_pmm.pmm01
            IF STATUS THEN
               CALL cl_err("OPEN t540_cl:", STATUS, 1)
               CLOSE t540_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t540_cl INTO g_pmm.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)  #MOD-640492 0->1
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
               #No.FUN-BB0086--add--begin--
               LET g_pmn07_t = g_pmn[l_ac].pmn07
               LET g_pmn80_t = g_pmn[l_ac].pmn80
               LET g_pmn83_t = g_pmn[l_ac].pmn83
               LET g_pmn86_t = g_pmn[l_ac].pmn86
               #No.FUN-BB0086--add--end--
               LET g_pmn_o.pmn07=g_pmn_t.pmn07
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#              DECLARE t540_ata1 SCROLL CURSOR FOR
#               SELECT ata02,ata03,ata04,ata05 FROM ata_file #FUN-A60035 add ata05
#                WHERE ata00=g_prog
#                  AND ata01=g_pmm.pmm01
#                  AND ata02=g_pmn_t.pmn02
#              FOREACH t540_ata1 INTO l_ata02,g_pmn_t.pmn02,l_ata04,l_ata05 #FUN-A60035 add ata05
#&endif
##FUN-A50054 --End 
#FUN-A60035 ---MARK END
                  OPEN t540_bcl USING g_pmm.pmm01,g_pmn_t.pmn02
                  IF STATUS THEN
                     CALL cl_err("OPEN t540_bcl:", STATUS, 1)
                  ELSE
                     FETCH t540_bcl INTO g_pmn2.* #FUN-730068
                     IF SQLCA.sqlcode THEN
                         CALL cl_err(g_pmn_t.pmn02,SQLCA.sqlcode,1)
                         LET l_lock_sw = "Y"
                     ELSE
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#&ifndef SLK
##FUN-A50054---End                        
#FUN-A60035 ---MARK END
                        CALL t540_b_move_to() #FUN-730068
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#&endif
##FUN-A50054---End                      
#FUN-A60035 ---MARK END
                        IF NOT cl_null(g_pmn[l_ac].pmn41)
                           AND g_pmm.pmm02 = 'SUB' THEN #NO:6961
                           SELECT * INTO g_sfb.* FROM sfb_file
                            WHERE sfb01 = g_pmn[l_ac].pmn41 AND sfb87!='X'
                           IF SQLCA.sqlcode THEN
                              INITIALIZE g_sfb.* TO NULL
                           END IF
                        END IF
                        LET g_pmn_o.*=g_pmn2.*
                        SELECT ima021 INTO g_pmn[l_ac].ima021 FROM ima_file
                         WHERE ima01=g_pmn[l_ac].pmn04
                        CALL t540_set_pmn930(g_pmn[l_ac].pmn930) RETURNING g_pmn[l_ac].gem02a #FUN-670051
                        #----如工單號碼不為空白,則單身資料自動產生,且只可維護單價資料
                        IF (NOT cl_null(g_argv4) OR g_pmm.pmm02 = 'SUB')  THEN #No:6232
                           CALL t540_b_move_back()
                           LET g_before_input_done = FALSE
                           CALL t540_set_entry_b(p_cmd)
                           CALL t540_set_no_entry_b(p_cmd)
                           LET g_before_input_done = TRUE
                           NEXT FIELD pmn31
                        END IF
                        IF g_argv3 = 'SUB' AND g_pmm.pmm18 = 'Y' THEN
                           CALL t540_b_move_back()
                        END IF
                     END IF
                  END IF 
                  IF g_sma.sma115 = 'Y' THEN
                     IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                        SELECT ima44,ima31 INTO g_ima44,g_ima31
                          FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
 
                        CALL s_chk_va_setting(g_pmn[l_ac].pmn04)
                             RETURNING g_flag,g_ima906,g_ima907
 
                        CALL s_chk_va_setting1(g_pmn[l_ac].pmn04)
                             RETURNING g_flag,g_ima908
                     END IF
                  END IF
 
                  LET g_before_input_done = FALSE
                  CALL t540_set_required()  #MOD-540057
                  CALL t540_set_entry_b(p_cmd)
                  CALL t540_set_no_entry_b(p_cmd)
                #TQC-B60235  --begin
                  CALL cl_set_comp_entry("pmn67",TRUE) 
                #TQC-B60235  --end   
                  
               #FUN-B50150  --begin
                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)  # TQC-B60300 mark
   #               IF cl_null(g_pmm.pmm41) THEN
   #	                 SELECT pmc49 INTO l_pmm41 FROM pmc_file
   #	                  WHERE pmc01 = g_pmm.pmm09
   #                  IF SQLCA.sqlcode THEN 
   #   	                CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
   #   	                LET l_pnz07 = 'N'
   #                  END IF	  
   #               ELSE 
   #	                 LET l_pmm41 = g_pmm.pmm41	   
   #               END IF

   #               IF NOT cl_null(l_pmm41) THEN
   #	                 SELECT pnz07 INTO l_pnz07 FROM pnz_file
   #	                  WHERE pnz01 = l_pmm41
   #                  IF SQLCA.sqlcode THEN 
   #   	                CALL cl_err( 'sel pnz07' , SQLCA.sqlcode,0)
   #   	                LET l_pnz07 = 'N'
   #                  END IF	   	   
   #               END IF 
                  
   #               IF l_pnz07 = 'N'  THEN 
   #                  IF g_pmn[l_ac].pmn31 > 0 OR g_pmn[l_ac].pmn31t > 0 THEN
   #                     CALL cl_set_comp_entry("pmn31",FALSE)
   #                     CALL cl_set_comp_entry("pmn31t",FALSE)
   #                  END IF
   #               END IF
             #FUN-B50150  --end
                  
                  LET g_before_input_done = TRUE
                  CALL cl_show_fld_cont()     #FUN-550037(smin)
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#              END FOREACH
#              LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
#              LET g_pmn2.pmn02 = l_ata02
#              LET g_pmn2.pmn04 = l_ata05
#              LET g_pmn_t.pmn02 = g_pmn2.pmn02
#              LET g_pmn_t.pmn04 = g_pmn2.pmn04
#&endif
##FUN-A50054 --End                         
#FUN-A60035 ---MARK END
            END IF
            #如工單號碼不為空白,則單身資料自動產生,且只可維護單價/交期資料
 
        BEFORE INSERT
            IF g_sma.sma45 matches'[Nn]' THEN      #採購單不可直接輸入
               CALL cl_err(g_sma.sma45,'mfg0033',1)
               RETURN
            END IF
            LET l_n = ARR_COUNT()
            BEGIN WORK
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL t540_set_entry_b(p_cmd)
            CALL t540_set_no_entry_b(p_cmd)
          #TQC-B60235  --begin
            CALL cl_set_comp_entry("pmn67",TRUE) 
          #TQC-B60235  --end   
            LET g_before_input_done = TRUE
            INITIALIZE g_pmn[l_ac].* TO NULL      #900423
            INITIALIZE g_pmn_o.* TO NULL
            INITIALIZE g_pmn_t.* TO NULL
            INITIALIZE g_pmn2.* TO NULL
            INITIALIZE arr_detail[l_ac].* TO NULL   #No.TQC-650108
            #No.FUN-BB0086--add--begin--
            LET g_pmn07_t = NULL 
            LET g_pmn80_t = NULL 
            LET g_pmn83_t = NULL 
            LET g_pmn86_t = NULL 
            #No.FUN-BB0086--add--end--
            LET g_pmn[l_ac].pmn20 = 0
            LET g_pmn[l_ac].pmn31 = 0
            LET g_pmn[l_ac].pmn31t= 0             #No.FUN-550019
            LET g_pmn[l_ac].pmn16 = g_pmm.pmm25
            LET g_pmn[l_ac].pmn63 = "N"    #No.MOD-5A0451
            LET g_pmn[l_ac].pmn89 = "N"    #No.FUN-940083
            LET g_pmn[l_ac].pmn64 = "N"    #No.MOD-5A0451
            LET g_pmn[l_ac].pmn65 = '1'    #FUN-640263 add
            LET g_pmn[l_ac].pmn38 = g_pmm.pmm45        #MPS/MRP 可用/不可用   #FUN-690047 add
            LET g_pmn[l_ac].pmn90 = 0      #CHI-690043 add   #取出單價
            LET g_pmn[l_ac].pmn73 = '4'    #NO.FUN-9C0075 add
            LET g_pmn[l_ac].pmn11 ='N'      #凍結碼   #TQC-980091 add 
            LET g_pmn2.pmn01      = g_pmm.pmm01
            LET g_pmn2.pmn011     = g_pmm.pmm02
            LET g_pmn2.pmn16      = g_pmm.pmm25
            LET g_pmn2.pmn09      = 1            #轉換率
            LET g_pmn2.pmn11      ='N'           #凍結碼
            LET g_pmn2.pmn14 =g_sma.sma886[1,1]  #部份交貨
            LET g_pmn2.pmn15 =g_sma.sma886[2,2]  #提前交貨
            LET g_pmn2.pmn20      = 0            #訂購量
            LET g_pmn2.pmn30      = 0            #標準價格
            LET g_pmn2.pmn31      = 0            #單價
            LET g_pmn2.pmn31t     = 0            #含稅單價  No.FUN-550019
            LET g_pmn2.pmn38      = g_pmm.pmm45  #MPS/MRP 可用/不可用   #FUN-690047
            LET g_pmn2.pmn44      = 0            #本幣單價
            LET g_pmn2.pmn50      = 0
            LET g_pmn2.pmn51      = 0
            LET g_pmn2.pmn53      = 0
            LET g_pmn2.pmn55      = 0
            LET g_pmn2.pmn57      = 0
            LET g_pmn2.pmn58      = 0
            LET g_pmn2.pmn63      = 'N'
            LET g_pmn2.pmn89      = 'N'           #FUN-940083 VMI管理否
            LET g_pmn2.pmn64      = 'N'
            LET g_pmn[l_ac].pmn122 = g_pmm.pmm05
            LET g_pmn2.pmn122 = g_pmn[l_ac].pmn122
            LET g_pmn[l_ac].pmn930=s_costcenter(g_pmm.pmm13)
            LET g_pmn2.pmn930=g_pmn[l_ac].pmn930
            CALL t540_set_pmn930(g_pmn[l_ac].pmn930) RETURNING g_pmn[l_ac].gem02a
            IF g_smy.smy59='Y' THEN
               LET g_pmn[l_ac].pmn67 = g_pmm.pmm13
               LET g_pmn2.pmn67 = g_pmn[l_ac].pmn67
               IF l_ac>1 THEN
                  SELECT pmn67,pmn40,pmn401        #No.FUN-680029 add pmn401  #No.FUN-830161
                    INTO g_pmn[l_ac].pmn67,g_pmn[l_ac].pmn40,g_pmn[l_ac].pmn401                    #No.FUN-830161
                    FROM pmn_file
                   WHERE pmn01=g_pmm.pmm01 AND pmn02=g_pmn[l_ac-1].pmn02
                  LET g_pmn2.pmn40  = g_pmn[l_ac].pmn40
                  LET g_pmn2.pmn401 = g_pmn[l_ac].pmn401
               END IF
               LET g_pmn2.pmn67 = g_pmn[l_ac].pmn67
            END IF
            LET g_pmn2.pmn90      = 0            #取出單價   #CHI-690043 add
            LET g_pmn_t.*         = g_pmn[l_ac].*      #新輸入資料
 
            CALL cl_show_fld_cont()                   #No.FUN-560197
            NEXT FIELD pmn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,1)  #MOD-640492 0->1
               LET INT_FLAG = 0
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            #將t540_set_origin_field()搬到判斷式IF smd115='Y'外面
            #這樣當不使用多單位時才會計算pmn88與pmn88t的金額
            CALL t540_set_origin_field()  #No.MOD-610037 add
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                  SELECT ima44,ima31 INTO g_ima44,g_ima31
                    FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
               END IF
 
               CALL s_chk_va_setting(g_pmn[l_ac].pmn04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD pmn04
               END IF
 
               CALL s_chk_va_setting1(g_pmn[l_ac].pmn04)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD pmn02  #MOD-590536
               END IF
 
               CALL t540_du_data_to_correct()
 
               CALL t540_set_origin_field()
               #計算pmn20,pmn07的值,檢查數量的合理性
               CALL t540_check_inventory_qty(p_cmd)
                   RETURNING g_flag
               IF g_flag = '1' THEN
                  IF g_ima906 = '3' OR g_ima906 = '2' THEN  #No.FUN-560020
                     NEXT FIELD pmn85
                  ELSE
                     NEXT FIELD pmn82
                  END IF
               END IF
            END IF
 
 
            LET g_pmn2.pmn31 = g_pmn[l_ac].pmn31
            LET g_pmn2.pmn31t= g_pmn[l_ac].pmn31t
            LET g_pmn2.pmn33 = g_pmn[l_ac].pmn33
            LET g_pmn2.pmn34 = g_pmn[l_ac].pmn34
            LET g_pmn2.pmn35 = g_pmn[l_ac].pmn35   #CHI-9C0023
            LET g_pmn2.pmn919 = g_pmn[l_ac].pmn919   #FUN-A80150 add
            LET g_pmn2.pmn36 = ''
            LET g_pmn2.pmn37 = ''
            LET g_pmn2.pmn41 = g_pmn[l_ac].pmn41
            LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
            CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
            LET g_pmn2.pmn63 = g_pmn[l_ac].pmn63
	    LET g_pmn2.pmn89 = g_pmn[l_ac].pmn89                          #No.FUN-940083
            LET g_pmn2.pmn64 = g_pmn[l_ac].pmn64
            LET g_pmn2.pmn65 = g_pmn[l_ac].pmn65
            LET g_pmn2.pmn68 = g_pmn[l_ac].pmn68
            LET g_pmn2.pmn69 = g_pmn[l_ac].pmn69
            LET g_pmn2.pmn80 = g_pmn[l_ac].pmn80
            LET g_pmn2.pmn81 = g_pmn[l_ac].pmn81
            LET g_pmn2.pmn82 = g_pmn[l_ac].pmn82
            LET g_pmn2.pmn83 = g_pmn[l_ac].pmn83
            LET g_pmn2.pmn84 = g_pmn[l_ac].pmn84
            LET g_pmn2.pmn85 = g_pmn[l_ac].pmn85
            LET g_pmn2.pmn86 = g_pmn[l_ac].pmn86
            LET g_pmn2.pmn87 = g_pmn[l_ac].pmn87
            LET g_pmn2.pmn72 = g_pmn[l_ac].pmn72
            LET g_pmn2.pmn73 = g_pmn[l_ac].pmn73
            LET g_pmn2.pmn74 = g_pmn[l_ac].pmn74
            LET g_pmn2.pmn75 = g_pmn[l_ac].pmn75
            LET g_pmn2.pmn76 = g_pmn[l_ac].pmn76
            LET g_pmn2.pmn77 = g_pmn[l_ac].pmn77
            LET g_pmn2.pmn90 = g_pmn[l_ac].pmn90   #CHI-690043 add   #取出單價
            LET g_pmn2.pmn930= g_pmn[l_ac].pmn930 #FUN-670051
            LET g_pmn2.pmn52 = g_pmn[l_ac].pmn52  #CHI-9C0025
            LET g_pmn2.pmn54 = g_pmn[l_ac].pmn54  #CHI-9C0025
            LET g_pmn2.pmn56 = g_pmn[l_ac].pmn56  #CHI-9C0025
            LET g_pmn2.pmn100= g_pmn[l_ac].pmn100 #FUN-D40042
            CALL t540_b_move_back_2() #FUN-730068
            IF cl_null(g_pmn2.pmn011) THEN #採購單據性質
               IF NOT cl_null(g_pmm.pmm02) THEN
                  LET g_pmn2.pmn011 = g_pmm.pmm02
               ELSE
                  CALL cl_err('','mfg9346',1)
                  ROLLBACK WORK
                  CANCEL INSERT
                  INITIALIZE g_pmn[l_ac].* TO NULL
               END IF
            END IF
            IF cl_null(g_pmn2.pmn61) THEN #替代料
               LET g_pmn2.pmn61=g_pmn2.pmn04
               LET g_pmn2.pmn62=1
            END IF
            IF cl_null(g_pmn2.pmn33) AND
               NOT cl_null(g_pmn2.pmn04) THEN #預計交貨日
               CALL cl_err('','mfg3226',1)
            END IF
            IF cl_null(g_pmn2.pmn34) THEN
               LET g_pmn2.pmn34=g_pmn2.pmn33
               DISPLAY g_pmn2.pmn34 TO pmn34
            END IF
              IF cl_null(g_pmn2.pmn65) THEN #代買
               LET g_pmn2.pmn65='1'
            END IF
            IF g_pmn2.pmn20 <> g_pmn[l_ac].pmn20 THEN
               DISPLAY g_pmn2.pmn20 TO pmn20
            END IF
            IF cl_null(g_pmn2.pmn122) THEN #專案代號
               LET g_pmn2.pmn122=' '
            END IF
            IF cl_null(g_pmn2.pmn96) THEN #wbs
               LET g_pmn2.pmn96=' '
            END IF
            IF cl_null(g_pmn2.pmn97) THEN #活動
               LET g_pmn2.pmn97=' '
            END IF
            IF cl_null(g_pmn2.pmn98) THEN #費用原因
               LET g_pmn2.pmn98=' '
            END IF
 
            IF g_pmn[l_ac].pmn02 > 0 AND g_pmn[l_ac].pmn02 IS NOT NULL THEN
               IF g_pmn_t.pmn02 IS NULL THEN                  
                  IF cl_null(g_pmn2.pmn42) THEN  #TQC-C40237 add  
                     LET g_pmn2.pmn42='0'
                  END IF 
                  LET g_pmn[l_ac].pmn42 = g_pmn2.pmn42  #NO.FUN-960130
                  LET g_pmn2.pmn61=g_pmn2.pmn04
                  LET g_pmn2.pmn62=1
                   IF ( cl_null(g_pmn2.pmn30) OR g_pmn2.pmn30 = 0 )  #TQC-6C0205 modify
                      AND NOT cl_null(g_pmn2.pmn04) THEN
                     SELECT imb118 INTO g_pmn2.pmn30 FROM imb_file
                      WHERE imb01 = g_pmn2.pmn04
                      IF cl_null(g_pmn2.pmn30) THEN LET g_pmn2.pmn30 = 0 END IF
                  END IF
                  IF cl_null(g_pmn2.pmn34) THEN LET g_pmn2.pmn34=g_pmn2.pmn33 END IF
                 #pmn35(原始到庫日期) = pmn34(原始到廠日期) + ima491(入庫前置期)
                  IF cl_null(g_pmn2.pmn35) THEN
                      IF NOT cl_null(g_ima491) THEN
                          IF NOT cl_null(g_pmn2.pmn34) THEN
                              LET g_pmn2.pmn35 = g_pmn2.pmn34 + g_ima491
                          END IF
                      END IF
                  END IF
               END IF
            END IF
            IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
               IF cl_null(g_pmn[l_ac].pmn68) THEN
                  CALL cl_err('','apm-907',1)   #No.MOD-4A0356
                  ROLLBACK WORK
                  CANCEL INSERT
               END IF
               IF cl_null(g_pmn[l_ac].pmn69) THEN
                  CALL cl_err('','apm-907',1)   #No.MOD-4A0356
                  ROLLBACK WORK
                  CANCEL INSERT
               END IF
            END IF
            IF cl_null(g_pmn2.pmn121) THEN
                LET g_pmn2.pmn121 = 1
            END IF
            SELECT pmh24 INTO l_pmh24 FROM pmh_file
                WHERE pmh01 = g_pmn2.pmn04
                  AND pmh02 = g_pmm.pmm09
                  AND pmh13 = g_pmm.pmm22
                  AND pmh21 = " "
                  AND pmh22 = '1'
                  AND pmh23 = ' '                      #No.CHI-960033
                  AND pmhacti = 'Y'
            IF cl_null(g_pmn2.pmn01) THEN LET g_pmn2.pmn01 = ' ' END IF
            IF cl_null(g_pmn2.pmn02) THEN LET g_pmn2.pmn02 = 0 END IF
            IF cl_null(g_pmn2.pmn58) THEN LET g_pmn2.pmn58 = 0 END IF   #TQC-9B0203
            IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF  #No.TQC-A60113
            IF g_gec07='Y' THEN
               #-----CHI-AC0016---------
               #LET g_pmn2.pmn88 = g_pmn2.pmn88t / ( 1 + g_pmm.pmm43/100)
               #LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
               #IF g_gec05 = 'T' THEN
               IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                  #TQC-C30225 add begin
                  LET g_pmn2.pmn31 = g_pmn2.pmn31t * ( 1 - g_pmm.pmm43/100)
                  LET g_pmn2.pmn31 = cl_digcut( g_pmn2.pmn31 , t_azi03)
                  #TQC-C30225 add end
                  LET g_pmn2.pmn88 = g_pmn2.pmn88t * ( 1 - g_pmm.pmm43/100)
                  LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
               ELSE
                  LET g_pmn2.pmn88 = g_pmn2.pmn88t / ( 1 + g_pmm.pmm43/100)
                  LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
               END IF
               #-----END CHI-AC0016-----
            ELSE
               LET g_pmn2.pmn88t = g_pmn2.pmn88 * ( 1 + g_pmm.pmm43/100)
               LET g_pmn2.pmn88t = cl_digcut( g_pmn2.pmn88t , t_azi04)  
            END IF
            LET g_pmn2.pmnplant = g_pmm.pmmplant #NO.FUN-960130
            LET g_pmn2.pmnlegal = g_pmm.pmmlegal #NO.FUN-960130
            IF cl_null(g_pmn2.pmn52) THEN LET g_pmn2.pmn52 = ' ' END IF  #CHI-9C0025
            IF cl_null(g_pmn2.pmn54) THEN LET g_pmn2.pmn54 = ' ' END IF  #CHI-9C0025
            IF cl_null(g_pmn2.pmn56) THEN LET g_pmn2.pmn56 = ' ' END IF  #CHI-9C0025
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#   LET l_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#               "  WHERE ata00 = '",g_prog,"'",
#               "    AND ata01 = '",g_pmm.pmm01,"'",
#               "    AND ata02 = '",g_pmn[l_ac].pmn02,"'"
#   DECLARE t540_ata_curs SCROLL CURSOR FROM l_sql
#   FOREACH t540_ata_curs INTO g_pmn2.pmn02,g_pmn2.pmn04,g_pmn2.pmn20
#      #FUN-A60035 ---add begin
#      LET l_pmn25_t = g_pmn2.pmn25
#      LET g_pmn2.pmn25 = g_pmn2.pmn02
#      LET g_pmn[l_ac].pmn25 = g_pmn2.pmn02
#      #FUN-A60035 ---add end
#&endif
##FUN-A50054 --End            
#FUN-A60035 ---MARK END
            LET g_pmn2.pmn88 = g_pmn2.pmn88 * g_pmn2.pmn20 / g_pmn[l_ac].pmn20
            LET g_pmn2.pmn88t= g_pmn2.pmn88t* g_pmn2.pmn20 / g_pmn[l_ac].pmn20
            LET g_pmn2.pmn87 = g_pmn2.pmn87* g_pmn2.pmn20 / g_pmn[l_ac].pmn20
            LET g_pmn2.pmn87 = s_digqty(g_pmn2.pmn87,g_pmn2.pmn86)   #No.FUN-BB0086
            CALL cl_digcut(g_pmn2.pmn88,t_azi04)  RETURNING g_pmn2.pmn88     #No.FUN-A60011
            CALL cl_digcut(g_pmn2.pmn88t,t_azi04) RETURNING g_pmn2.pmn88t    #No.FUN-A60011
            IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF  #No.TQC-A60113
            CALL s_schdat_pmn78(g_pmn2.pmn41,g_pmn2.pmn012,g_pmn2.pmn43,g_pmn2.pmn18,   #FUN-C10002
                                            g_pmn2.pmn32) RETURNING g_pmn2.pmn78      #FUN-C10002
            INSERT INTO pmn_file VALUES(g_pmn2.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pmn_file",g_pmn2.pmn01,g_pmn2.pmn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_success = 'N'
               ROLLBACK WORK
               CANCEL INSERT
            END IF
#           IF g_pmm.pmm909 <> '3' THEN   #TQC-730022    #MOD-B60102 mark
            IF g_pmm.pmm909 MATCHES '[128]' THEN         #MOD-B60102
               IF NOT cl_null(g_pmn[l_ac].pmn24) THEN           ##新增
                  SELECT SUM(pmn20/pmn62*pmn121) INTO l_pmn20 FROM pmn_file
                   WHERE pmn24 = g_pmn[l_ac].pmn24 AND pmn25 = g_pmn[l_ac].pmn25
                     AND pmn16<>'9'       #取消(Cancel)
                  IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
               #FUN-910088--add--start--
                  SELECT pml07 INTO l_pml07 FROM pml_file
                   WHERE pml01 = g_pmn[l_ac].pmn24
                     AND pml02 = g_pmn[l_ac].pmn25
                  LET l_pmn20 = s_digqty(l_pmn20,l_pmn07)
               #FUN-910088--add--end-- 
                  IF g_pmm.pmm909 <> '8' THEN    #FUN-A10034
                     UPDATE pml_file SET pml21 = l_pmn20,pml16='2'
                      WHERE pml01 = g_pmn[l_ac].pmn24 
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#                        AND pml02 = g_pmn2.pmn02
#&else
#FUN-A60035 ---MARK END
                        AND pml02 = g_pmn[l_ac].pmn25
#FUN-A60035 ---MARK BEGIN
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","pml_file",g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25,SQLCA.sqlcode,"","pmn24 update pml21",1)  #No.FUN-660129
                        LET g_success = 'N'
                        ROLLBACK WORK
                        CANCEL INSERT
                     ELSE
                        UPDATE pmk_file SET pmk25 = '2'
                         WHERE pmk01 = g_pmn[l_ac].pmn24
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行

                        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                           CALL cl_err3("upd","pmk_file",g_pmn[l_ac].pmn24,"",SQLCA.sqlcode,"","pmn24 update pmk25",1)  #No.FUN-660129
                           LET g_success = 'N'
                           ROLLBACK WORK
                           CANCEL INSERT
                        END IF
                     END IF
                  END IF                         #FUN-A10034
               END IF
            END IF   #TQC-730022
 
            #------------  沖銷 Blanket P/O  -----------------------
            IF NOT cl_null(g_pmn[l_ac].pmn68)  THEN      ##新增
               SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file
                 WHERE pmn68 = g_pmn[l_ac].pmn68 AND pmn69 = g_pmn[l_ac].pmn69
                   AND pmn16<>'9'       #取消(Cancel)
               IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
            #FUN-910088--add--start--
               SELECT pon07 INTO l_pon07 FROM pon_file
                WHERE pon01 = g_pmn[l_ac].pmn68 AND pon02 = g_pmn[l_ac].pmn69 
               LET l_pmn20 = s_digqty(l_pmn20,l_pon07)      
            #FUN-910088--add--
                  UPDATE pon_file SET pon21 = l_pmn20,pon16='2'
                   WHERE pon01 = g_pmn[l_ac].pmn68 AND pon02 = g_pmn[l_ac].pmn69
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","pon_file",g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,SQLCA.sqlcode,"","pmn68 update pon21",1)  #No.FUN-660129
                     LET g_success = 'N'
                     ROLLBACK WORK
                     CANCEL INSERT
                  ELSE
                     UPDATE pom_file SET pom25 = '2'
                      WHERE pom01 = g_pmn[l_ac].pmn68
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行

                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","pom_file",g_pmn[l_ac].pmn68,"",SQLCA.sqlcode,"","pmn68 update pom25",1)  #No.FUN-660129
                        LET g_success = 'N'
                        ROLLBACK WORK
                        CANCEL INSERT
                     END IF
                  END IF
            END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#&ifdef SLK
#  END FOREACH
#  #FUN-A60035 ---add begin
#  LET g_pmn2.pmn25 = l_pmn25_t
#  LET g_pmn[l_ac].pmn25 = l_pmn25_t 
#  #FUN-A60035 ---add end
#&endif
##FUN-A50054---End
#FUN-A60035 ---MARK END
 
            IF g_success = 'Y' THEN
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL  t540_update()
               LET l_pmm25 = '0'          #FUN-550038
               COMMIT WORK
 
            ELSE
               ROLLBACK WORK
            END IF

        BEFORE FIELD pmn02                        #default 序號
            IF g_pmn[l_ac].pmn02 IS NULL OR
               g_pmn[l_ac].pmn02 = 0 THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#               SELECT MAX(ata02)+1 INTO g_pmn[l_ac].pmn02
#                 FROM ata_file WHERE ata00 = g_prog
#                  AND ata01 = g_pmm.pmm01
#&else
##FUN-A50054---End	
#FUN-A60035 ---MARK END
               SELECT max(pmn02)+1
                   INTO g_pmn[l_ac].pmn02
                   FROM pmn_file
                   WHERE pmn01 = g_pmm.pmm01
#&endif                   #FUN-A60035 ---MARK
               IF g_pmn[l_ac].pmn02 IS NULL THEN
                  LET g_pmn[l_ac].pmn02 = 1
               END IF
              #IF g_sma.sma45 matches'[Nn]' THEN      #採購單不可直接輸入 #MOD-D10041 mark
               IF g_sma.sma45 matches'[Nn]' AND (g_argv3 != 'SUB' OR cl_null(g_argv3)) THEN  #採購單不可直接輸入 #MOD-D10041 add
                  CALL cl_err(g_sma.sma45,'apm-590',1)#TQC-7C0072
                  LET g_pmn[l_ac].pmn02='' #TQC-7C0072
                  RETURN
               END IF
            END IF
            IF l_ac > 1 AND p_cmd = 'a' THEN
               LET g_pmn[l_ac].pmn24=g_pmn[l_ac-1].pmn24
               LET g_pmn[l_ac].pmn33=g_pmn[l_ac-1].pmn33
            END IF
 
        AFTER FIELD pmn02                        #check 序號是否重複
            IF g_pmn[l_ac].pmn02 IS NULL THEN
               LET g_pmn[l_ac].pmn02 = g_pmn_t.pmn02
            END IF
            IF NOT cl_null(g_pmn[l_ac].pmn02) THEN
                IF g_pmn[l_ac].pmn02 != g_pmn_t.pmn02 OR
                   g_pmn_t.pmn02 IS NULL THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#                  SELECT COUNT(*) INTO l_n FROM ata_file
#                   WHERE ata00 = g_prog
#                     AND ata01 = g_pmm.pmm01
#                     AND ata02 = g_pmn[l_ac].pmn02
#&else
##FUN-A50054 --End                   
#FUN-A60035 ---MARK END
                    SELECT count(*)
                        INTO l_n
                        FROM pmn_file
                        WHERE pmn01 = g_pmm.pmm01 AND
                              pmn02 = g_pmn[l_ac].pmn02
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&endif
##FUN-A50054 --End        
#FUN-A60035 ---MARK END           
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,1)  #MOD-640492 0->1
                        LET g_pmn[l_ac].pmn02 = g_pmn_t.pmn02
                        NEXT FIELD pmn02
#MOD-B60119 -- begin --
                    ELSE
                        UPDATE pmo_file SET pmo03 = g_pmn[l_ac].pmn02
                           WHERE pmo01 = g_pmm.pmm01
                           AND pmo03 = g_pmn_o.pmn02
#MOD-B60119 -- end --
                    END IF
                END IF
                LET g_pmn2.pmn02 = g_pmn[l_ac].pmn02
                LET g_pmn_o.pmn02 = g_pmn[l_ac].pmn02
            END IF
 
        BEFORE FIELD pmn24   #No.FUN-590029
           CALL t540_set_entry_b(p_cmd)
           CALL t540_set_entry_b('s')
 
        AFTER FIELD pmn24
           IF NOT cl_null(g_pmn[l_ac].pmn24) THEN
              IF NOT cl_null(g_pmn[l_ac].pmn25) THEN
                 SELECT pml92 INTO l_pml92 FROM pml_file WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                 IF l_pml92 = 'Y' THEN
                    CALL cl_err("","apm1029",1)
                    NEXT FIELD pmn24
                 END IF
              END IF
#TQC-BC0027  begin #分單別對是否存在此單號進行判斷
              IF g_pmm.pmm909 = '5' THEN
              	 SELECT COUNT(*) INTO l_cnt FROM sfb_file
                     WHERE sfb01 = g_pmn[l_ac].pmn24
                    IF l_cnt <= 0 OR SQLCA.SQLCODE = 100 THEN
                       CALL cl_err('','afa-908',1)
                       NEXT FIELD pmn24
                    END IF                                   
              ELSE  
                 IF g_pmm.pmm909 <> '3' THEN           #No.TQC-C60164 add
                    SELECT COUNT(*) INTO l_cnt FROM pmk_file
                     WHERE pmk01 = g_pmn[l_ac].pmn24
                    IF l_cnt <= 0 OR SQLCA.SQLCODE = 100 THEN
                       CALL cl_err('','mfg3137',1)
                       NEXT FIELD pmn24
                    END IF
                 END IF                                #NO.TQC-C60164 add
              END IF
#TQC-BC0027 end
              IF g_azw.azw04 = '2' THEN
                 CALL t540_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD pmn24
                 END IF
              END IF
              #MOD-DA0177 add beg--------
              IF NOT cl_null(g_pmn[l_ac].pmn24)  AND NOT cl_null(g_pmn[l_ac].pmn25) THEN  
                 CALL t540_pmn25(p_cmd)
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD pmn24
                 END IF  
              END IF 
              #MOD-DA0177 add end--------
           END IF
           LET g_pmn2.pmn24 = g_pmn[l_ac].pmn24
           IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND
              NOT cl_null(g_pmn[l_ac].pmn24) AND
              (cl_null(g_pmn_t.pmn24) OR g_pmn[l_ac].pmn24 != g_pmn_t.pmn24) THEN
              LET g_t1 = g_pmn[l_ac].pmn24[1,g_doc_len]
              SELECT COUNT(*) INTO l_n FROM smy_file
               WHERE smyslip = g_t1 AND smy62 = lg_smy62
              IF l_n = 0 THEN
                 CALL cl_err_msg('','apm1004',lg_smy62,0)
                 NEXT FIELD pmn24
              END IF
           END IF
                 
        #MOD-B90126 --- start ---
        BEFORE FIELD pmn122
           CALL t540_set_entry_b(p_cmd)
        #MOD-B90126 ---  end  ---
 
        AFTER FIELD pmn122    #專案代號
          IF NOT cl_null(g_pmn[l_ac].pmn122) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_pmn[l_ac].pmn122
                AND pjaacti = 'Y'
                AND pjaclose='N'             #FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_pmn[l_ac].pmn122,'asf-984',0)
                NEXT FIELD pmn122
             END IF
             CALL t540_bud(p_cmd,'3')
             IF NOT cl_null(g_errno) THEN
                NEXT FIELD pmn122
             END IF
          ELSE
          #MOD-B90126 --- start ---
          #  NEXT FIELD pmn67    #IF 專案沒輸入資料，直接跳到部門,WBS/活動不可輸入
             CALL t540_set_no_entry_b(p_cmd)
          #MOD-B90126 ---  end  ---
          END IF
 
        BEFORE FIELD pmn96
          IF cl_null(g_pmn[l_ac].pmn122) THEN
             NEXT FIELD pmn122
          END IF
          CALL t540_set_entry_b(p_cmd)   #MOD-B90126 add
 
        AFTER FIELD pmn96     #WBS
          IF NOT cl_null(g_pmn[l_ac].pmn96) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_pmn[l_ac].pmn122
                AND pjb02 = g_pmn[l_ac].pmn96
                AND pjbacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_pmn[l_ac].pmn96,'apj-051',0)
                LET g_pmn[l_ac].pmn96 = g_pmn_t.pmn96
                NEXT FIELD pmn96
             ELSE
                SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                 FROM pjb_file WHERE pjb01 = g_pmn[l_ac].pmn122
                  AND pjb02 = g_pmn[l_ac].pmn96 
                  AND pjbacti = 'Y'            
                IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                   CALL cl_err(g_pmn[l_ac].pmn96,'apj-090',0)
                   LET g_pmn[l_ac].pmn96 = g_pmn_t.pmn96
                   NEXT FIELD pmn96
                END IF
             END IF
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_pmn[l_ac].pmn96
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD pmn97
             ELSE
                LET g_pmn[l_ac].pmn97 = ' '
                DISPLAY BY NAME g_pmn[l_ac].pmn97
             #MOD-B90126 --- start ---
             #  NEXT FIELD pmn67
                CALL t540_set_no_entry_b(p_cmd)
             #MOD-B90126 ---  end  ---
             END IF
             CALL t540_bud(p_cmd,'3')
             IF NOT cl_null(g_errno) THEN
                NEXT FIELD pmn96 
             END IF
          END IF
 
        BEFORE FIELD pmn97
          IF cl_null(g_pmn[l_ac].pmn96) THEN
             NEXT FIELD pmn96
          ELSE
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_pmn[l_ac].pmn96
             IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
                LET g_pmn[l_ac].pmn97 = ' '
                DISPLAY BY NAME g_pmn[l_ac].pmn97
                #NEXT FIELD pmn67    #MOD-B90126 mark
             END IF
          END IF
 
        AFTER FIELD pmn97     #活動
          IF NOT cl_null(g_pmn[l_ac].pmn97) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_pmn[l_ac].pmn97
                AND pjk11 = g_pmn[l_ac].pmn96
                AND pjkacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_pmn[l_ac].pmn97,'apj-049',0)
                NEXT FIELD pmn97
             END IF
          END IF
 
#MOD-B50145 --begin--
        BEFORE FIELD pmn67 
            LET l_smy59 = NULL 
            IF g_smy.smy59 = 'Y' THEN 
              IF NOT cl_null(g_pmn[l_ac].pmn24) THEN 
                 CALL s_get_doc_no(g_pmn[l_ac].pmn24) 
                     RETURNING l_smyslip 
                 SELECT smy59 INTO l_smy59 FROM smy_file
                  WHERE smyslip = l_smyslip
                  IF l_smy59 = 'Y' THEN 
                     CALL cl_set_comp_entry("pmn67",FALSE)         
                  END IF         
               END IF 
            END IF               
#MOD-B50145 --end-- 

        AFTER FIELD pmn67     #部門
          IF NOT cl_null(g_pmn[l_ac].pmn67) THEN
            SELECT COUNT(*) INTO g_cnt FROM gem_file
             WHERE gem01=g_pmn[l_ac].pmn67
               AND gemacti='Y'
            IF g_cnt = 0 THEN
               CALL cl_err(g_pmn[l_ac].pmn67,'apm-003',0)
               NEXT FIELD pmn67
            END IF
            IF g_pmm.pmm909 MATCHES '[128]' THEN #MOD-B60102 add
               IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                  SELECT pml67 INTO l_pmn67 FROM pml_file
                    WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                  IF l_pmn67!=g_pmn[l_ac].pmn67 THEN
                     LET g_pmn[l_ac].pmn67=g_pmn_t.pmn67
                     CALL cl_err(g_pmn[l_ac].pmn67,'apm-311',1)
                     DISPLAY BY NAME g_pmn[l_ac].pmn67
                     NEXT FIELD pmn67
                  END IF
               END IF
            END IF #MOD-B60102 add
            CALL t540_bud(p_cmd,'3')
            IF NOT cl_null(g_errno) THEN
#MOD-B50145 --begin-- 
               CALL cl_err('',g_errno,0)       
               IF g_smy.smy59 ='Y' AND l_smy59='Y' THEN 
                  NEXT FIELD pmn24
#MOD-B50145 --end-- 
               ELSE   
                  NEXT FIELD pmn67 
               END IF                         #MOD-B50145   
            END IF
          END IF
 
 
        AFTER FIELD pmn98     #費用原因
          IF NOT cl_null(g_pmn[l_ac].pmn98) THEN
             SELECT COUNT(*) INTO g_cnt FROM azf_file
               WHERE azf01=g_pmn[l_ac].pmn98 AND azf02='2' AND azfacti='Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_pmn[l_ac].pmn98,'asf-453',0)
                NEXT FIELD pmn98
             END IF
             SELECT azf09 INTO l_azf09 FROM azf_file
               WHERE azf01=g_pmn[l_ac].pmn98 AND azf02='2' AND azfacti='Y'
             IF l_azf09 !='7' THEN
                CALL cl_err(g_pmn[l_ac].pmn98,'aoo-406',0)
                NEXT FIELD pmn98
             END IF 
             CALL t540_bud(p_cmd,'3')
             IF NOT cl_null(g_errno) THEN
                LET g_pmn[l_ac].pmn40 = g_pmn_t.pmn40
                LET g_pmn[l_ac].pmn401= g_pmn_t.pmn401
                DISPLAY BY NAME g_pmn[l_ac].pmn40,g_pmn[l_ac].pmn401
                NEXT FIELD pmn98 
             END IF
             IF cl_null(g_pmn[l_ac].pmn40) THEN
#No.TQC-B50094 --begin
                IF g_pmn[l_ac].pmn122 IS NULL THEN LET g_pmn[l_ac].pmn122 = ' ' END IF
                IF g_pmn[l_ac].pmn96  IS NULL THEN LET g_pmn[l_ac].pmn96  = ' ' END IF
                IF g_pmn[l_ac].pmn67  IS NULL THEN LET g_pmn[l_ac].pmn67  = ' ' END IF
                SELECT afb02 INTO g_pmn[l_ac].pmn40
                  FROM afb_file
                 WHERE afb00 = g_bookno1 
                   AND afb01 = g_pmn[l_ac].pmn98 
                   AND afb03 = YEAR(g_pmm.pmm04)
                   AND afb04 = g_pmn[l_ac].pmn96
                   AND afb041= g_pmn[l_ac].pmn67 
                   AND afb042= g_pmn[l_ac].pmn122

#               SELECT azf14 INTO g_pmn[l_ac].pmn40
#                 FROM azf_file
#               WHERE azf01=g_pmn[l_ac].pmn98 AND azf02='2' AND azfacti='Y'
#No.TQC-B50094 --end
             END IF
 
             IF g_aza.aza63='Y' AND cl_null(g_pmn[l_ac].pmn401) THEN
               LET g_pmn[l_ac].pmn401 = g_pmn[l_ac].pmn40
             END IF
             DISPLAY BY NAME g_pmn[l_ac].pmn40,g_pmn[l_ac].pmn401
 
          ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
            IF g_smy.smy59 = 'Y' THEN
              CALL cl_err('','apj-201',0)
              NEXT FIELD pmn98
            END IF
          END IF
 
        AFTER FIELD pmn40     #科目一
          IF NOT cl_null(g_pmn[l_ac].pmn40) THEN
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=g_pmn[l_ac].pmn40
               AND aag00=g_bookno1
            IF g_cnt = 0 THEN
#FUN-B10052 --begin--    
#               LET g_pmn[l_ac].pmn40=g_pmn_t.pmn40
#               CALL cl_err(g_pmn[l_ac].pmn40,"aap-021",1)
                CALL cl_err(g_pmn[l_ac].pmn40,"aap-021",0)
 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn40
                  LET g_qryparam.arg1 = g_bookno1
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' AND aag01 LIKE '",g_pmn[l_ac].pmn40 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn40                
#FUN-B10052  --end--
               DISPLAY BY NAME g_pmn[l_ac].pmn40
               NEXT FIELD pmn40
            END IF
            IF g_pmm.pmm909 MATCHES '[128]' THEN #MOD-B60102 add
               IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                  SELECT pml40 INTO l_pmn40 FROM pml_file
                    WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                  IF l_pmn40!=g_pmn2.pmn40 THEN
                     LET g_pmn[l_ac].pmn40=g_pmn_t.pmn40
                     CALL cl_err(g_pmn[l_ac].pmn40,'apm-311',1)
                     DISPLAY BY NAME g_pmn[l_ac].pmn40
                     NEXT FIELD pmn40
                  END IF
               END IF
            END IF #MOD-B60102 add
            CALL t540_bud(p_cmd,'1')
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD pmn40 
            END IF
          ELSE
            IF g_smy.smy59 = 'Y' THEN
              CALL cl_err('','apj-202',0)
              NEXT FIELD pmn40
            END IF
          END IF

        AFTER FIELD pmn401    #科目二
          IF NOT cl_null(g_pmn[l_ac].pmn401) THEN
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=g_pmn[l_ac].pmn401
               AND aag00=g_bookno2
            IF g_cnt = 0 THEN
#FUN-B10052 --begin--
#              LET g_pmn[l_ac].pmn401=g_pmn_t.pmn401
#              CALL cl_err(g_pmn[l_ac].pmn401,"aap-021",1)
               CALL cl_err(g_pmn[l_ac].pmn401,"aap-021",0)
               
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn401
                  LET g_qryparam.arg1 = g_bookno2
                  LET g_qryparam.construct = 'N'                  
                  LET g_qryparam.where = " aag03 IN ('2','4') AND aag01 LIKE '",g_pmn[l_ac].pmn401 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn401               
#FUN-B10052 --end--
               DISPLAY BY NAME g_pmn[l_ac].pmn401
               NEXT FIELD pmn401
            END IF
            IF g_pmm.pmm909 MATCHES '[128]' THEN #MOD-B60102 add
               IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                  SELECT pml401 INTO l_pmn401 FROM pml_file
                    WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                  IF l_pmn401!=g_pmn2.pmn401 THEN
                     LET g_pmn[l_ac].pmn401=g_pmn_t.pmn401
                     CALL cl_err(g_pmn[l_ac].pmn401,'apm-311',1)
                     DISPLAY BY NAME g_pmn[l_ac].pmn401
                     NEXT FIELD pmn401
                  END IF
               END IF
            END IF #MOD-B60102 add
            CALL t540_bud(p_cmd,'2')
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD pmn401
            END IF
          ELSE
            IF g_aza.aza63 = 'Y' AND g_smy.smy59 = 'Y' THEN
              CALL cl_err('','apj-203',0)
              NEXT FIELD pmn401
            END IF
          END IF
        AFTER FIELD pmn25   #請購單項次
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#          IF p_cmd='a' OR 
#              (g_cmd='u' AND (g_pmn[l_ac].pmn24<>g_pmn_o.pmn24 OR g_pmn[l_ac].pmn25<>g_pmn_o.pmn25)) THEN
#             SELECT * FROM ata_file 
#              WHERE ata00='apmt420_slk'
#                AND ata01=g_pmn[l_ac].pmn24
#                AND ata02=g_pmn[l_ac].pmn25
#             INTO TEMP x
#             UPDATE x SET ata00=g_prog,
#                          ata01=g_pmm.pmm01,
#                          ata02=g_pmn[l_ac].pmn02
#             INSERT INTO ata_file 
#                  SELECT * FROM x
#             SELECT SUM(pml86),SUM(pml87),SUM(pml31t),SUM(pml31) 
#               INTO g_pmn[l_ac].pmn86,g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
#               FROM pml_file 
#              WHERE pml01=g_pmm.pmm01 AND pml02=g_pmn[l_ac].pmn02
#              DISPLAY BY NAME g_pmn[l_ac].pmn86,g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
#         END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

           IF NOT cl_null(g_pmn[l_ac].pmn25) THEN
              IF NOT cl_null(g_pmn[l_ac].pmn24) THEN
                 SELECT pml92 INTO l_pml92 
                   FROM pml_file 
                  WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                 IF l_pml92 = 'Y' THEN
                    CALL cl_err("","apm1029",1)
                    NEXT FIELD pmn25
                 END IF
              END IF
              IF g_azw.azw04 = '2' THEN
                 CALL t540_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD pmn25
                 END IF
              END IF
           END IF
         IF g_sma.sma32 matches'[Yy]' THEN #請購與採購互相勾稽
               IF g_pmm.pmm02 = 'SUB' THEN       #No.MOD-570406
              ELSE
                 IF cl_null(g_pmn[l_ac].pmn24) OR
                    cl_null(g_pmn[l_ac].pmn25) THEN
                     #請購與採購互相勾稽,請購單號-項次不可空白,
                     #且要存在請購單維護作業(apmt420)
                    IF g_pmm.pmm02 <> 'WB1' AND g_pmm.pmm02 <> 'WB2' THEN #FUN-C30211
                          CALL cl_err('','apm-540 ',1)  #MOD-640492 0->1
                          NEXT FIELD pmn24
                    END IF   #FUN-C30211
                 END IF
              END IF
         END IF
 
           IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) AND  #No.FUN-590029
              (cl_null(g_pmn_t.pmn24) OR g_pmn_t.pmn24 != g_pmn[l_ac].pmn24
                                OR g_pmn_t.pmn25 != g_pmn[l_ac].pmn25) THEN
              CALL t540_pmn25(p_cmd)   #MOD-640491 add p_cmd
              CALL t540_set_no_entry_b('s')
              CALL t540_set_pmn87()  #No.TQC-6C0131 add
               IF NOT cl_null(g_errno)
                  AND (g_pmn[l_ac].pmn04[1,4] != 'MISC'
                       OR cl_null(g_pmn[l_ac].pmn04)) THEN
                 CALL cl_err('',g_errno,1)  #MOD-640492 0->1
                 LET g_pmn[l_ac].pmn24 = g_pmn_o.pmn24
                 LET g_pmn[l_ac].pmn25 = g_pmn_o.pmn25
                 LET g_pmn[l_ac].pmn122= g_pmn_o.pmn122
                 LET g_pmn[l_ac].pmn96= g_pmn_o.pmn96
                 LET g_pmn[l_ac].pmn97= g_pmn_o.pmn97
                 LET g_pmn[l_ac].pmn98= g_pmn_o.pmn98
                 DISPLAY g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25,
                         g_pmn[l_ac].pmn122
                      TO pmn24,pmn25,pmn122
                 DISPLAY BY NAME g_pmn[l_ac].pmn96
                 DISPLAY BY NAME g_pmn[l_ac].pmn97
                 DISPLAY BY NAME g_pmn[l_ac].pmn98
 
                 NEXT FIELD pmn24
              END IF
              CALL t540_bud(p_cmd,'3')
              IF NOT cl_null(g_errno) THEN
                 IF g_gec07 = 'N' THEN          #No.FUN-560102
                    NEXT FIELD pmn31
                 ELSE
                    NEXT FIELD pmn31t
                 END IF
              END IF
              CALL t540_def()                    #MOD-840639 add
              CALL t540_set_no_entry_b(p_cmd)    #MOD-780139 add
           END IF
           LET g_pmn2.pmn25 = g_pmn[l_ac].pmn25

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#          IF p_cmd='a' OR
#              (g_cmd='u' AND (g_pmn[l_ac].pmn24<>g_pmn_o.pmn24 OR g_pmn[l_ac].pmn25<>g_pmn_o.pmn25)) THEN
#             DROP TABLE x
#             SELECT * FROM ata_file
#              WHERE ata00='apmt420_slk'
#                AND ata01=g_pmn[l_ac].pmn24
#                AND ata02=g_pmn[l_ac].pmn25
#             INTO TEMP x
#             UPDATE x SET ata00=g_prog,
#                          ata01=g_pmm.pmm01,
#                          ata02=g_pmn[l_ac].pmn02
#             INSERT INTO ata_file
#                  SELECT * FROM x
#             SELECT SUM(pml86),SUM(pml87),SUM(pml31t),SUM(pml31)
#               INTO g_pmn[l_ac].pmn86,g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
#               FROM pml_file
#              WHERE pml01=g_pmm.pmm01 AND pml02=g_pmn[l_ac].pmn02
#              DISPLAY BY NAME g_pmn[l_ac].pmn86,g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
#         END IF
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#          SELECT DISTINCT(ata05) INTO g_pmn[l_ac].pmn04
#            FROM ata_file 
#           WHERE ata00=g_prog
#             AND ata01=g_pmm.pmm01
#             AND ata02=g_pmn[l_ac].pmn02
#          SELECT COUNT(*) INTO g_pmn[l_ac].pmn20
#            FROM ata_file 
#           WHERE ata00=g_prog
#             AND ata01=g_pmm.pmm01
#             AND ata02=g_pmn[l_ac].pmn02
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
 
        BEFORE FIELD pmn04
           CALL t540_set_entry_b(p_cmd)
           CALL t540_set_no_required()
           IF g_argv2 = '2' THEN
              LET l_pmn50 = 0
              SELECT pmn50 INTO l_pmn50 FROM pmn_file
                     WHERE pmn01 = g_pmm.pmm01 AND pmn02 = g_pmn_t.pmn02
              IF l_pmn50 > 0 THEN
                  CALL cl_err('','mfg3374',1)  #MOD-640492 0->1
           #genero
              END IF
           END IF
 
        AFTER FIELD pmn04        # check 料件編號
           IF NOT s_chkima08(g_pmn[l_ac].pmn04) THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
              IF g_pmn[l_ac].pmn04[1,4] != 'MISC' THEN   #MOD-BA0143 add
#FUN-AA0059 ---------------------start----------------------------
                 IF NOT s_chk_item_no(g_pmn[l_ac].pmn04,"") THEN
                    CALL cl_err('',g_errno,1)
                    LET g_pmn[l_ac].pmn04= g_pmn_t.pmn04
                    NEXT FIELD pmn04
                 END IF
#FUN-AA0059 ---------------------end-------------------------------
              END IF                                     #MOD-BA0143 add
            #FUN-C30075---add---START
              SELECT ima928 INTO l_ima928 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04 
              IF l_ima928 = 'Y' THEN
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM pnc_file WHERE pnc01 = g_pmn[l_ac].pmn04 
                IF l_cnt <= 0 THEN
                   CALL cl_err('','apm1092',0)
                   NEXT FIELD pmn04
                END IF
              END IF
            #FUN-C30075---add-----END
              IF cl_null(g_pmn2.pmn08) THEN 
                 SELECT ima25 INTO g_pmn2.pmn08 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04 #MOD-C60035 add
              END IF
              IF p_cmd='a' OR (p_cmd='u' AND g_pmn[l_ac].pmn04<>g_pmn_t.pmn04) THEN
                 IF g_azw.azw04='2' THEN
                    CALL t540_chkpmn04()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_errmsg,g_errno,0)
                       NEXT FIELD pmn04                   
                    END IF             
                 END IF
              END IF
             #DEV-D40015 add str--------
             #若有勾選M-barcode整合時且供應商有代印條碼，則需控卡單身料件的條碼產生時機點
             #g_prog = 'apmt540'為'F；g_prog = 'apmt590'為'G'
              IF g_aza.aza131 = 'Y' THEN   #與條碼管理系統整合
                 LET l_pmc61 = ''
                 SELECT pmc61 INTO l_pmc61 #是否代印條碼
                   FROM pmc_file
                  WHERE pmc01 = g_pmm.pmm09
                 IF l_pmc61 <> 'N' THEN   
                    LET l_ima932 = ''
                    SELECT ima932 INTO l_ima932   #條碼產生時機點
                      FROM ima_file
                     WHERE ima01 = g_pmn[l_ac].pmn04
                    IF (g_prog = 'apmt540' AND l_ima932 <> 'F') OR 
                       (g_prog = 'apmt590' AND l_ima932 <> 'G') THEN
                       CALL cl_err('','aba-181',1)
                       NEXT FIELD pmn04
                    END IF
                 END IF
              END IF
             #DEV-D40015 add end--------
           END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
##FUN-A60035 --Begin             
#            LET l_ima151=''
#            SELECT ima151 INTO l_ima151 
#              FROM ima_file
#             WHERE ima01=g_pmn[l_ac].pmn04
##FUN-A60035 --End
#            CALL t540_check_pmn04('pmn04',l_ac,p_cmd) RETURNING
#                l_check_res  
#            IF g_sma.sma120='Y' AND l_ima151='Y' THEN #FUN-A60035 add l_ima151
#                CALL cl_set_comp_entry("pmn20",FALSE)
#                CALL s_detail(g_prog,g_pmm.pmm01,g_pmn[l_ac].pmn02,g_pmn[l_ac].pmn04,'N') #FUN-A50054
#                       RETURNING g_pmn[l_ac].pmn20
#            ELSE
#                CALL cl_set_comp_entry("pmn20",TRUE)
#            END IF
#            SELECT ima25 INTO l_ima25 
#              FROM ima_file 
#             WHERE ima01 = g_pmn[l_ac].pmn04
#&else
##FUN-A50054---end	        
#FUN-A60035 ---MARK END
#           CALL cl_set_comp_entry("pmn20",TRUE)   #FUN-A50054 add      #FUN-A60035 ---MARK
           #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
           CALL t540_check_pmn04('pmn04',l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 Begin add                 
#&endif               
##FUN-A50054 end 
#FUN-A60035 ---MARK END 
           IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
              IF cl_null(g_pmn[l_ac].pmn52) AND cl_null(g_pmn[l_ac].pmn54) 
                 AND cl_null(g_pmn[l_ac].pmn56) THEN
                 LET g_pmn[l_ac].pmn52 = g_ima35
                 LET g_pmn[l_ac].pmn54 = g_ima36
                 LET g_pmn[l_ac].pmn56 = " "
              END IF
           END IF
         #FUN-B60150 ADD&MARK BEGIN ----------------------------
         ##FUN-B40098 Begin---
         # IF g_azw.azw04 = '2' AND g_pmm.pmm51 = '3' THEN
         #    SELECT rtz08 INTO l_rtz08 FROM rtz_file 
         #     WHERE rtz01 = g_pmm.pmmplant
         #    IF NOT cl_null(l_rtz08) THEN
         #       LET g_pmn[l_ac].pmn52 = l_rtz08
         #       LET g_pmn[l_ac].pmn54 = ' '
         #       LET g_pmn[l_ac].pmn56 = ' '
         #    END IF
         # END IF
         ##FUN-B40098 End-----
           IF g_azw.azw04 = '2' THEN
              #FUN-C90049 mark begin---
              #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
              # WHERE rtz01 = g_pmm.pmmplant
              #FUN-C90049 mark end-----
              CALL s_get_defstore(g_pmm.pmmplant,g_pmn[l_ac].pmn04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
              IF g_pmm.pmm51 = '3' OR (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2') THEN
                 IF NOT cl_null(l_rtz08) THEN
                    LET g_pmn[l_ac].pmn52 = l_rtz08
                    LET g_pmn[l_ac].pmn54 = ' '
                    LET g_pmn[l_ac].pmn56 = ' '
                 END IF
              END IF
              IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
                 IF NOT cl_null(l_rtz07) THEN
                    LET g_pmn[l_ac].pmn52 = l_rtz07
                    LET g_pmn[l_ac].pmn54 = ' '
                    LET g_pmn[l_ac].pmn56 = ' '
                 END IF
              END IF
           END IF
         #FUN-B60150 ADD&MARK  END  -----------------------------
            LET g_pmn_o.pmn86 = g_pmn[l_ac].pmn86   #MOD-730044  add
           IF NOT l_check_res THEN NEXT FIELD pmn04 END IF
 
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifndef SLK
#FUN-A60035 ---MARK END
           LET l_m=0
           IF g_pmm.pmm909 MATCHES '[12]' THEN
              IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25)
                 AND NOT cl_null(g_pmn[l_ac].pmn04) THEN
                 SELECT COUNT(*) INTO l_m
                   FROM pmk_file,pml_file
                  WHERE pmk01=pml01
                    AND pml01=g_pmn[l_ac].pmn24
                    AND pml02=g_pmn[l_ac].pmn25
                    AND pml04=g_pmn[l_ac].pmn04
                 IF l_m =0 THEN
                    CALL cl_err('','apm1013',1)
                    IF g_sma.sma32 = 'Y' THEN
                       NEXT FIELD pmn04
                    END IF
                 END IF
              END IF
           END IF
           IF g_pmm.pmm909 MATCHES '[3]' THEN
              IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25)
                 AND NOT cl_null(g_pmn[l_ac].pmn04) THEN
                 SELECT COUNT(*) INTO l_m
                   FROM oea_file,oeb_file
                  WHERE oea01=oeb01
                    AND oeb01=g_pmn[l_ac].pmn24
                    AND oeb03=g_pmn[l_ac].pmn25
                    AND oeb04=g_pmn[l_ac].pmn04
                 IF l_m =0 THEN
                    CALL cl_err('','apm1013',1)
                 END IF
              END IF
           END IF
#FUN-A60035 ---MARK BEGIN
#&endif
##FUN-A50054 --Begin
#FUN-A60035 ---MARK END
        #當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
        #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
        #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
        #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
        #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
        #其他分支就不需要這么麻煩了
           CALL t540_qry_ima01() #TQC-C30109
        BEFORE FIELD att00
              #根據子料件找到母料件及各個屬性
              SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                     imx06,imx07,imx08,imx09,imx10
              INTO g_pmn[l_ac].att00, g_pmn[l_ac].att01, g_pmn[l_ac].att02,
                   g_pmn[l_ac].att03, g_pmn[l_ac].att04, g_pmn[l_ac].att05,
                   g_pmn[l_ac].att06, g_pmn[l_ac].att07, g_pmn[l_ac].att08,
                   g_pmn[l_ac].att09, g_pmn[l_ac].att10
              FROM imx_file
              WHERE imx000 = g_pmn[l_ac].pmn04
 
              LET g_pmn04 = g_pmn[l_ac].att00
 
              #賦值所有屬性
              LET g_pmn[l_ac].att01_c = g_pmn[l_ac].att01
              LET g_pmn[l_ac].att02_c = g_pmn[l_ac].att02
              LET g_pmn[l_ac].att03_c = g_pmn[l_ac].att03
              LET g_pmn[l_ac].att04_c = g_pmn[l_ac].att04
              LET g_pmn[l_ac].att05_c = g_pmn[l_ac].att05
              LET g_pmn[l_ac].att06_c = g_pmn[l_ac].att06
              LET g_pmn[l_ac].att07_c = g_pmn[l_ac].att07
              LET g_pmn[l_ac].att08_c = g_pmn[l_ac].att08
              LET g_pmn[l_ac].att09_c = g_pmn[l_ac].att09
              LET g_pmn[l_ac].att10_c = g_pmn[l_ac].att10
              #顯示所有屬性
              DISPLAY BY NAME g_pmn[l_ac].att00
              DISPLAY BY NAME
                g_pmn[l_ac].att01, g_pmn[l_ac].att01_c,
                g_pmn[l_ac].att02, g_pmn[l_ac].att02_c,
                g_pmn[l_ac].att03, g_pmn[l_ac].att03_c,
                g_pmn[l_ac].att04, g_pmn[l_ac].att04_c,
                g_pmn[l_ac].att05, g_pmn[l_ac].att05_c,
                g_pmn[l_ac].att06, g_pmn[l_ac].att06_c,
                g_pmn[l_ac].att07, g_pmn[l_ac].att07_c,
                g_pmn[l_ac].att08, g_pmn[l_ac].att08_c,
                g_pmn[l_ac].att09, g_pmn[l_ac].att09_c,
                g_pmn[l_ac].att10, g_pmn[l_ac].att10_c
              CALL t540_set_no_entry_b(p_cmd)    #No.TQC-650108
 
        #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att00
            #FUN-AB0025 ------------add start-----------
            IF NOT cl_null(g_pmn[l_ac].att00) THEN
               IF NOT s_chk_item_no(g_pmn[l_ac].att00,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD att00
               END IF
            END IF
            #FUN-AB0025 -----------add end----------- 
            #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
            SELECT COUNT(ima01) INTO l_count FROM ima_file
              WHERE ima01 = g_pmn[l_ac].att00 AND imaag = lg_smy62
            IF l_count = 0 THEN
               CALL cl_err_msg('','aim-909',lg_smy62,0)
               NEXT FIELD att00
            END IF
 
            LET g_pmn04 = g_pmn[l_ac].att00
 
            #如果設置為不允許新增
            IF g_sma.sma908 <> 'Y' THEN
               CALL t540_check_pmn04('imx00',l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
               IF NOT l_check_res THEN NEXT FIELD att00 END IF
            END IF
 
        AFTER FIELD att01
            CALL t540_check_att0x(g_pmn[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01 END IF
        AFTER FIELD att02
            CALL t540_check_att0x(g_pmn[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02 END IF
        AFTER FIELD att03
            CALL t540_check_att0x(g_pmn[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
        AFTER FIELD att04
            CALL t540_check_att0x(g_pmn[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04 END IF
        AFTER FIELD att05
            CALL t540_check_att0x(g_pmn[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05 END IF
        AFTER FIELD att06
            CALL t540_check_att0x(g_pmn[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06 END IF
        AFTER FIELD att07
            CALL t540_check_att0x(g_pmn[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07 END IF
        AFTER FIELD att08
            CALL t540_check_att0x(g_pmn[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08 END IF
        AFTER FIELD att09
            CALL t540_check_att0x(g_pmn[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09 END IF
        AFTER FIELD att10
            CALL t540_check_att0x(g_pmn[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10 END IF
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att01_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att01_c,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01_c END IF
        AFTER FIELD att02_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02_c END IF
        AFTER FIELD att03_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att03_c,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03_c END IF
        AFTER FIELD att04_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att04_c,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04_c END IF
        AFTER FIELD att05_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att05_c,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05_c END IF
        AFTER FIELD att06_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att06_c,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06_c END IF
        AFTER FIELD att07_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att07_c,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07_c END IF
        AFTER FIELD att08_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att08_c,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08_c END IF
        AFTER FIELD att09_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att09_c,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09_c END IF
        AFTER FIELD att10_c
            CALL t540_check_att0x_c(g_pmn[l_ac].att10_c,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
        AFTER FIELD pmn041
            LET g_pmn2.pmn041 = g_pmn[l_ac].pmn041
            CALL t540_set_no_entry_b(p_cmd)         #MOD-610151
 
        BEFORE FIELD pmn80,pmn07    #No.FUN-540027
           IF g_argv2 = '2' THEN
              LET l_pmn50 = 0
              SELECT pmn50 INTO l_pmn50 FROM pmn_file
                     WHERE pmn01 = g_pmm.pmm01 AND pmn02 = g_pmn_t.pmn02
              IF l_pmn50 > 0 THEN
                  CALL cl_err('','mfg3374',1)  #MOD-640492 0->1
              END IF
           END IF
           IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25)
              AND g_pmn[l_ac].pmn04[1,4] != 'MISC' THEN
               #採購料件/供應商控制
                SELECT ima915 INTO l_ima915 FROM ima_file
                 WHERE ima01=g_pmn[l_ac].pmn04
                IF l_ima915='2' OR l_ima915='3' THEN
                    CALL t540sub_pmh(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn41,#No.TQC-910033 
                                     g_pmn[l_ac].pmn43,g_pmn2.pmn18,g_pmn[l_ac].pmn012,g_pmm.*,g_type)      #No.TQC-910033 #No.FUN-A60011
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1)  #MOD-640492 0->1
                      LET g_pmn[l_ac].pmn04 = g_pmn_o.pmn04
                      DISPLAY g_pmn[l_ac].pmn04 TO pmn04
 
                      IF NOT cl_null(g_pmn[l_ac].pmn24) THEN
                         NEXT FIELD pmn02
                      ELSE
                         NEXT FIELD pmn04
                      END IF
                   END IF
                END IF
                #料件主檔檢查/預設值的讀取
                IF g_pmn[l_ac].pmn04<>g_pmn_t.pmn04 OR
                   cl_null(g_pmn_t.pmn04) THEN
                   CALL t540_def()
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1)  #MOD-640492 0->1
                   LET g_pmn[l_ac].pmn04 = g_pmn_o.pmn04
                   DISPLAY g_pmn[l_ac].pmn04 TO pmn04
 
                   NEXT FIELD pmn04
                END IF
                IF g_sma.sma886[5,5]='Y' AND
                  (g_pmm.pmm02='EXP' OR g_pmm.pmm02='CAP'
                   OR g_pmn[l_ac].pmn04[1,4] = 'MISC') THEN #MOD-970202   
                   CALL t561()       #若MISC須輸入會計科目
                END IF
          END IF
#MOD-B70246 -- begin --
           IF INFIELD(pmn07) THEN
              LET g_pmn_o.pmn07 = g_pmn[l_ac].pmn07
           END IF
#MOD-B70246 -- end --
          IF INFIELD(pmn80) THEN
             IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                SELECT ima44,ima31 INTO g_ima44,g_ima31
                  FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
             END IF
          END IF
 
        AFTER FIELD pmn07    #採購單位
            IF NOT cl_null(g_pmn[l_ac].pmn07) THEN
               CALL t540_unit(g_pmn[l_ac].pmn07)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmn[l_ac].pmn07,g_errno,1)  
                  LET g_pmn[l_ac].pmn07 = g_pmn_o.pmn07
                  DISPLAY g_pmn[l_ac].pmn07 TO pmn07
                  NEXT FIELD pmn07
               END IF
                IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN #MOD-970202   
                   LET g_pmn2.pmn121=1
                   LET g_pmn2.pmn09=1
                 ELSE
                    IF cl_null(g_pmn2.pmn08) THEN 
                       SELECT ima25 INTO g_pmn2.pmn08 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04 #MOD-C60035 add
                    END IF                       
                      #取採購對庫存換算率
                      CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,
                                            g_pmn2.pmn08)
                             RETURNING g_sw,g_pmn2.pmn09
                       IF g_sw THEN       #85-09-23 by kitty
                         CALL cl_err(g_pmn[l_ac].pmn07,'mfg7002',1) #MOD-640492 0->1
                          LET g_pmn2.pmn09=1
                          NEXT FIELD pmn07
                       END IF
 
                      #取採購對請購換算率96-07-12
                      IF g_pmn[l_ac].pmn24 !=' ' AND g_pmn[l_ac].pmn25!=' '
                         AND NOT cl_null(g_pmn[l_ac].pmn24)
                         AND NOT cl_null(g_pmn[l_ac].pmn25)
                         THEN
                         #IF g_pmm.pmm909 = '2' THEN     #MOD-AC0425 #MOD-C70256 mark 
                         IF g_pmm.pmm909 = '2' OR g_pmm.pmm909 = '1' THEN #MOD-C70256 add
                            IF g_pmn[l_ac].pmn07<>g_pmn_o.pmn07 THEN
                               CALL s_umfchk(g_pmn[l_ac].pmn04,
                                             g_pmn[l_ac].pmn07, g_pmn_o.pmn07) RETURNING g_sw,g_pmn2.pmn121 
                               IF g_sw THEN 
                               ### --單位換算率抓不到 ---# 
                                  CALL cl_err(g_pmn[l_ac].pmn04,'abm-731',1) 
                                  NEXT FIELD pmn07 
                               END IF
                               LET g_pmn[l_ac].pmn20=
                                   g_pmn[l_ac].pmn20/g_pmn2.pmn121
                               LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                               DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
                            END IF
                            SELECT pml07 INTO l_pml07 FROM pml_file
                             WHERE pml01=g_pmn[l_ac].pmn24 AND
                                   pml02=g_pmn[l_ac].pmn25
                              CALL s_umfchk(g_pmn[l_ac].pmn04,
                                          g_pmn[l_ac].pmn07,
                                               l_pml07)
                                 RETURNING g_sw,g_pmn2.pmn121
                            IF g_sw THEN
                             ###--單位換算率抓不到 ---#
                                CALL cl_err('pmn07/pml07: ','abm-731',1)
                                NEXT FIELD pmn07
                            END IF
                            IF cl_null(g_pmn_o.pmn07)
                               THEN
                               LET g_pmn[l_ac].pmn20=
                                   g_pmn[l_ac].pmn20/g_pmn2.pmn121
                               LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                               DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
                            END IF
                         END IF	      #MOD-AC0425	
                      END IF       
                END IF
                #MOD-BB0264 ----- modify start -----
                IF g_smy.smy57[4,4]='Y' AND NOT cl_null(g_pmn[l_ac].pmn07) AND NOT cl_null(g_pon.pon07) THEN
                   CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07, g_pon.pon07) RETURNING g_sw,g_pmn2.pmn70
                   IF g_sw THEN
                      CALL cl_err('','abm-731',1)
                      IF g_sma.sma115 ='N' THEN
                         NEXT FIELD pmn07
                      ELSE
                         IF g_ima906 = '2' OR g_ima906 = '3' THEN
                            NEXT FIELD pmn83
                         ELSE
                            NEXT FIELD pmn80
                         END IF
                      END IF
                   END IF
                END IF
                #MOD-BB0264 ----- modify end -----
                IF g_pmn[l_ac].pmn87 = 0 OR
                      (g_pmn_t.pmn07 <> g_pmn[l_ac].pmn07 OR
                       g_pmn_t.pmn86 <> g_pmn[l_ac].pmn86) THEN
 
                   IF g_sma.sma116 MATCHES '[02]' THEN
                      LET g_pmn[l_ac].pmn86 = g_pmn[l_ac].pmn07
                   END IF
 
                   CALL t540_set_pmn87()
                END IF
#               IF g_pmn[l_ac].pmn07 <> g_pmn_o.pmn07 THEN                             #MOD-B70246
                IF g_pmn[l_ac].pmn07 <> g_pmn_o.pmn07 OR cl_null(g_pmn_o.pmn07) THEN   #MOD-B70246
                   CALL t540_set_pmn87()     #MOD-790079
                  #TQC-AC0257 Begin---
                  #IF g_azw.azw04 = '2' THEN
                  #   CALL s_defprice_A6(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm04,g_pmm.pmm22,
                  #                      g_pmm.pmm21,g_pmm.pmm43,g_pmn[l_ac].pmn07,g_pmm.pmmplant)
                  #      RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74
                  #END IF
                  #TQC-AC0257 End-----
                   IF g_pmn[l_ac].pmn31 IS NULL THEN LET g_pmn[l_ac].pmn31 = 0 END IF
                LET l_ecm04=' '
                IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
                   SELECT ecm04 INTO l_ecm04 FROM ecm_file
                    WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
                      AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                END IF
                CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                     g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                     g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                               g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF  #FUN-9C0075 ADD
                LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)  #MOD-9C0285 ADD    
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD pmn07
                END IF
                #MOD-B30280 add --start--
                LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                #MOD-B30280 add --end--
                  IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
                   LET g_factor = 1
                   CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn_o.pmn07,g_pmn[l_ac].pmn07)
                         RETURNING g_cnt,g_factor
                   IF g_cnt = 1 THEN
                      LET g_factor = 1
                   END IF
                   LET g_pmn[l_ac].pmn20 = g_pmn[l_ac].pmn20 * g_factor
                   LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                   DISPLAY g_pmn[l_ac].pmn20 TO pmn20
                  END IF
                   DISPLAY g_pmn[l_ac].pmn31 TO pmn31
                   DISPLAY g_pmn[l_ac].pmn31t TO pmn31t
                END IF
                CALL t540_bud(p_cmd,'3')
                IF NOT cl_null(g_errno) THEN
                   NEXT FIELD pmn07 
                END IF
                #No.FUN-BB0086--add--begin--
                IF NOT cl_null(g_pmn[l_ac].pmn20) AND NOT cl_null(g_pmn[l_ac].pmn07) THEN
                   IF cl_null(g_pmn_t.pmn20) OR cl_null(g_pmn07_t) OR g_pmn_t.pmn20 != g_pmn[l_ac].pmn20 OR g_pmn07_t != g_pmn[l_ac].pmn07 THEN
                      LET g_pmn[l_ac].pmn20=s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)
                      DISPLAY BY NAME g_pmn[l_ac].pmn20
                   END IF
                END IF
                LET g_pmn07_t = g_pmn[l_ac].pmn07
                #No.FUN-BB0086--add--end--
            END IF
            LET g_pmn2.pmn07  = g_pmn[l_ac].pmn07
            LET g_pmn_o.pmn07 = g_pmn[l_ac].pmn07
 
    #FUN-B60150 ADD&MARK BEGIN ---------------------------------------
    ##FUN-B40098 Begin---
    # BEFORE FIELD pmn52
    #    IF g_azw.azw04 = '2' AND cl_null(g_pmn[l_ac].pmn52) AND g_pmm.pmm51 = '3' THEN
    #       SELECT rtz08 INTO l_rtz08 FROM rtz_file
    #        WHERE rtz01 = g_pmm.pmmplant
    #       IF NOT cl_null(l_rtz08) THEN
    #          LET g_pmn[l_ac].pmn52 = l_rtz08
    #          LET g_pmn[l_ac].pmn54 = ' '
    #          LET g_pmn[l_ac].pmn56 = ' '
    #       END IF
    #    END IF
    ##FUN-B40098 End-----
      BEFORE FIELD pmn52
         IF g_azw.azw04 = '2' AND cl_null(g_pmn[l_ac].pmn52) THEN
            #FUN-C90049 mark begin---
            #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
            # WHERE rtz01 = g_pmm.pmmplant
            #FUN-C90049 mark end-----
            CALL s_get_defstore(g_pmm.pmmplant,g_pmn[l_ac].pmn04) RETURNING  l_rtz07,l_rtz08    #FUN-C90049 add
            IF g_pmm.pmm51 = '3' AND (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2') THEN
               IF NOT cl_null(l_rtz08) THEN
                  LET g_pmn[l_ac].pmn52 = l_rtz08
                  LET g_pmn[l_ac].pmn54 = ' '
                  LET g_pmn[l_ac].pmn56 = ' '
               END IF
            END IF
            IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
               IF NOT cl_null(l_rtz07) THEN
                  LET g_pmn[l_ac].pmn52 = l_rtz07
                  LET g_pmn[l_ac].pmn54 = ' '
                  LET g_pmn[l_ac].pmn56 = ' '
               END IF
            END IF
         END IF
    #FUN-B60150 ADD&MARK  END  ---------------------------------------

      AFTER FIELD pmn52
      IF g_azw.azw04='2' THEN
         IF NOT cl_null(g_pmn[l_ac].pmn52) THEN
            CALL t540_pmn52()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmn[l_ac].pmn52,g_errno,0)
               NEXT FIELD pmn52
            END IF
         END IF   
      END IF
      #No.FUN-AA0049--begin
      IF NOT s_chk_ware(g_pmn[l_ac].pmn52) THEN
         NEXT FIELD pmn52
      END IF 
      #No.FUN-AA0049--end
      
      IF NOT cl_null(g_pmn[l_ac].pmn52) THEN
         LET l_n1=0
         SELECT count(*) INTO l_n1 FROM imd_file
          WHERE imd01 = g_pmn[l_ac].pmn52
            AND imdacti = 'Y'
         IF l_n1 = 0 THEN
            CALL cl_err('',100,0)
            NEXT FIELD pmn52
         END IF
  #FUN-D40103--mark--str--
       # #IF g_pmn[l_ac].pmn54 IS NOT NULL THEN   #MOD-BC0275 mark
       #  IF NOT cl_null(g_pmn[l_ac].pmn54)  THEN #MOD-BC0275
       #     IF NOT t540_chk_pmn54() THEN
       #        CALL cl_err3("sel","ime_file",g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54,100,"","",0)
       #        NEXT FIELD pmn52
       #     END IF
       #  END IF
       #FUN-D40103--mark--str--
      END IF
      LET g_pmn2.pmn52 = g_pmn[l_ac].pmn52
      LET g_pmn_o.pmn52 = g_pmn[l_ac].pmn52
       IF NOT s_imechk(g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54) THEN NEXT FIELD pmn54 END IF  #FUN-D40103 add 

   AFTER FIELD pmn54
 #FUN-D40103--mark--str--
 #    #IF g_pmn[l_ac].pmn54 IS NOT NULL AND  #MOD-BC0275 mark
 #     IF NOT cl_null(g_pmn[l_ac].pmn54) AND #MOD-BC0275
 #        NOT cl_null(g_pmn[l_ac].pmn52) THEN
 #        IF NOT t540_chk_pmn54() THEN
 #           CALL cl_err3("sel","ime_file",g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54,100,"","",0)
 #           NEXT FIELD pmn54
 #        END IF
 #     END IF
#FUN-D40103--mark--end--
      IF cl_null(g_pmn[l_ac].pmn54) THEN LET g_pmn[l_ac].pmn54 = ' ' END IF              #FUN-D40103 add
      IF NOT s_imechk(g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54) THEN NEXT FIELD pmn54 END IF  #FUN-D40103 add
      LET g_pmn2.pmn54 = g_pmn[l_ac].pmn54
      LET g_pmn_o.pmn54 = g_pmn[l_ac].pmn54
 
   AFTER FIELD pmn56
      LET g_pmn2.pmn56 = g_pmn[l_ac].pmn56
      LET g_pmn_o.pmn56 = g_pmn[l_ac].pmn56

       AFTER FIELD pmn20   #採購數量
          #No.FUN-BB0086--add--begin--
          IF NOT cl_null(g_pmn[l_ac].pmn20) AND NOT cl_null(g_pmn[l_ac].pmn07) THEN
             IF cl_null(g_pmn_t.pmn20) OR cl_null(g_pmn07_t) OR g_pmn_t.pmn20 != g_pmn[l_ac].pmn20 OR g_pmn07_t != g_pmn[l_ac].pmn07 THEN
                LET g_pmn[l_ac].pmn20=s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)
                DISPLAY BY NAME g_pmn[l_ac].pmn20
             END IF
          END IF
          #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_pmn[l_ac].pmn20) THEN
               #IF g_pmn[l_ac].pmn20 <= 0 THEN                             #MOD-C80061 mark
               IF g_pmn[l_ac].pmn20 <= 0 AND g_pmn[l_ac].pmn42 != '2' THEN #MOD-C80061 add
                   CALL cl_err(g_pmn[l_ac].pmn20,'mfg3334',1)  #MOD-640492 0->1   #TQC-C40032 modify mfg3331->mfg3334
                   LET g_pmn[l_ac].pmn20 = g_pmn_o.pmn20
                   DISPLAY g_pmn[l_ac].pmn20 TO pmn20              
 
                   NEXT FIELD pmn20
               END IF
               IF (g_pmn_o.pmn20 IS NULL OR g_pmn[l_ac].pmn20 != g_pmn_o.pmn20 )
                        AND (g_pmn[l_ac].pmn04[1,4] != 'MISC') THEN #MOD-970202   
                 #CALL s_sizechk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn20,g_lang) #CHI-C10037 mark
                  CALL s_sizechk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn20,g_lang,g_pmn[l_ac].pmn07) #CHI-C10037 add
                          RETURNING g_pmn[l_ac].pmn20
                  DISPLAY g_pmn[l_ac].pmn20 TO pmn20                
 
               END IF
               IF (p_cmd='a' OR g_pmn_o.pmn20 IS NULL) OR
                       (p_cmd='u'OR g_pmn_o.pmn20 != g_pmn[l_ac].pmn20) THEN
                  #add or 修改時,採購量不可小於已交量
                  IF g_pmn[l_ac].pmn20 < g_pmn_o.pmn50 THEN
                     CALL cl_err(g_pmn_o.pmn50,'mfg3424',1)
                     NEXT FIELD pmn20
                  END IF
                  IF g_pmm.pmm02='SUB' THEN
                     IF cl_null(g_pmn_t.pmn20) THEN LET g_pmn_t.pmn20 = 0 END IF
                     SELECT SUM(pmn20) INTO l_qty FROM pmn_file,pmm_file
                      WHERE pmn41=g_pmn[l_ac].pmn41 AND pmn65='1'
                        AND pmm01=pmn01 AND pmn43=g_pmn[l_ac].pmn43   #MOD-B90109 add 
                       #AND pmn16 <> '8'     #TQC-C10116    #MOD-C70081 mark
                        AND pmn16 NOT IN ('6','7','8','9')  #MOD-C70081
                        AND pmm18 <> 'X'                    #MOD-C70081
                        #AND pmm01=pmn01                              #MOD-B90109 mark
                     IF cl_null(l_qty) THEN LET l_qty = 0 END IF #no.6261
                     IF g_pmn[l_ac].pmn65='1' THEN     #NO:6961一般採購COUNT
                         IF NOT cl_null(g_sfb.sfb05) THEN
                            SELECT ima55 INTO l_ima55 FROM ima_file
                             WHERE ima01=g_sfb.sfb05
                         ELSE
                            SELECT ima55 INTO l_ima55 FROM ima_file
                             WHERE ima01=g_pmn[l_ac].pmn04
                         ENd IF
                         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima55)
                            RETURNING g_sw,l_pmn09
                         IF g_sw THEN
                             CALL cl_err('pmn20/sfb08 ','abm-731',1)
                             NEXT FIELD pmn20
                         END IF
                         IF cl_null(l_pmn09) THEN LET l_pmn09=0 END IF
                         LET l_qty1=(l_qty-g_pmn_t.pmn20+g_pmn[l_ac].pmn20)*l_pmn09
                         IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
                         IF l_qty1 > g_sfb.sfb08  THEN
                            CALL cl_err('','apm-302',1) NEXT FIELD pmn20  #MOD-640492 0->1
                         END IF
                     END IF
                     IF g_pmn[l_ac].pmn65='2' THEN  #NO:6961代買採購COUNT
                        IF cl_null(g_pmn_t.pmn20) THEN LET g_pmn_t.pmn20 = 0 END IF
                        #抓工單代買數
                        SELECT SUM(sfa065) INTO l_sfa065 FROM sfa_file
                          WHERE sfa01=g_sfb.sfb01
                            AND sfa03=g_pmn[l_ac].pmn04
                         IF cl_null(l_sfa065) THEN LET l_sfa065 = 0 END IF
                        #檢查不同單位
                        SELECT ima25 INTO l_ima55 FROM ima_file
                          WHERE ima01=g_pmn[l_ac].pmn04
                         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima55)
                            RETURNING g_sw,l_pmn09      #單位轉換
                         IF g_sw THEN
                            CALL cl_err('pmn20/sfb08 ','abm-731',1)
                            NEXT FIELD pmn20
                         END IF
                         SELECT SUM(pmn20) INTO l_qty FROM pmn_file
                          WHERE pmn41=g_pmn[l_ac].pmn41 AND pmn65='2'
                            AND pmn04=g_pmn[l_ac].pmn04
                         IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                         IF cl_null(l_pmn09) THEN LET l_pmn09=0 END IF
                         LET l_qty1=(l_qty-g_pmn_t.pmn20+g_pmn[l_ac].pmn20)*l_pmn09
                         IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
                         IF l_qty1 > l_sfa065 AND
                            (p_cmd='a' OR (g_pmn[l_ac].pmn20!=g_pmn_t.pmn20 )) THEN
                            CALL cl_err('','apm-302',1) NEXT FIELD pmn20  #MOD-640492 0->1
                         END IF
                     END IF
                  END IF
                  IF NOT cl_null(g_pmn[l_ac].pmn24) AND   #請購單
                     g_sma.sma32='Y'  THEN   
                        #請購與採購是否要互相勾稽
                        #若sma32 'Y':如有請購單,採購量不可大於請購量
 
                     SELECT * INTO l_pml.* FROM pml_file
                     WHERE pml01= g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","pml_file",g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25,"apm-202","","",1)  #No.FUN-660129
                        NEXT FIELD pmn20
                     END IF
 
                     LET l_pml20 = l_pml.pml20*l_pml.pml09  #請購量
                     LET l_pml20 = s_digqty(l_pml20,l_pml.pml07)    #FUN-910088--add--
                     LET l_pmn20 = 0
                     SELECT SUM(pmn20/pmn62*pmn09) INTO l_pmn20 #TQC-7C0116 071208 統一換算成庫存單位
                       FROM pmn_file #採購量
                      WHERE (pmn24=g_pmn[l_ac].pmn24 AND pmn25=g_pmn[l_ac].pmn25
                        AND  pmn01 = g_pmm.pmm01 AND pmn02!= g_pmn_o.pmn02
                        AND pmn16<>'9')       #取消(Cancel)
                         OR (pmn24=g_pmn[l_ac].pmn24 AND pmn25=g_pmn[l_ac].pmn25
                        AND  pmn01!= g_pmm.pmm01
                        AND pmn16<>'9')       #取消(Cancel)
                     IF STATUS OR cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
                     #----------------與請購互相勾稽 -------------------------------------
                     SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
                      WHERE ima01=g_pmn[l_ac].pmn04
                     IF cl_null(g_sma.sma341) THEN LET g_sma.sma341 = 0 END IF
                     IF cl_null(g_sma.sma342) THEN LET g_sma.sma342 = 0 END IF
                     IF cl_null(g_sma.sma343) THEN LET g_sma.sma343 = 0 END IF
                     CASE
                     WHEN l_ima07='A'  #計算可容許的數量
                          LET l_over=l_pml.pml20 * (g_sma.sma341/100)
                     WHEN l_ima07='B'
                          LET l_over=l_pml.pml20 * (g_sma.sma342/100)
                     WHEN l_ima07='C'
                          LET l_over=l_pml.pml20 * (g_sma.sma343/100)
                     OTHERWISE
                          LET l_over=0
                     END CASE
                     #需做取位
                      LET p_qty = g_pmn[l_ac].pmn20*g_pmn2.pmn09
                      LET l_over= l_over*l_pml.pml09#TQC-7C0116 add
                     IF p_qty+l_pmn20>    #採購量
                        (l_pml20+l_over) THEN   #請購量+容許量
                         CALL cl_err(g_pmn[l_ac].pmn20,'mfg3425',1)#TQC-7C0119以采購單位show信息
                        IF g_sma.sma33='R'    #reject
                           THEN
                           NEXT FIELD pmn20
                        END IF
                     END IF
                  END IF
               END IF
               LET g_pmn2.pmn20 = g_pmn[l_ac].pmn20
              #LET g_pmn_o.pmn20 = g_pmn[l_ac].pmn20             #MOD-CA0165 mark
               IF g_pmn[l_ac].pmn87 = 0 OR
                     (g_pmn_o.pmn20 <> g_pmn[l_ac].pmn20 OR       #MOD-CA0165 g_pmn_t.pmn20 -> g_pmn_o.pmn20
                      g_pmn_o.pmn86 <> g_pmn[l_ac].pmn86) THEN    #MOD-CA0165 g_pmn_t.pmn86 -> g_pmn_o.pmn86
                  CALL t540_set_pmn87() 
               END IF
               LET g_pmn_o.pmn20 = g_pmn[l_ac].pmn20              #MOD-CA0165 add
               #MOD-BB0264 ----- add start -----
               SELECT * INTO g_pon.* FROM pon_file WHERE pon01 = g_pmn[l_ac].pmn68 AND pon02 = g_pmn[l_ac].pmn69
               IF g_smy.smy57[4,4]='Y' AND NOT cl_null(g_pmn[l_ac].pmn07) AND NOT cl_null(g_pon.pon07) THEN
                  #Blanket P/O 之單位轉換因子
                  CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,g_pon.pon07) RETURNING g_sw,g_pmn2.pmn70
                  IF g_sw THEN
                     CALL cl_err('','abm-731',1)
                     IF g_sma.sma115 ='N' THEN
                        NEXT FIELD pmn07
                     ELSE
                        IF g_ima906 = '2' OR g_ima906 = '3' THEN
                           NEXT FIELD pmn83
                        ELSE
                           NEXT FIELD pmn80
                        END IF
                     END IF
                  END IF

                  IF cl_null(g_pmn2.pmn62) THEN LET g_pmn2.pmn62 = 1 END IF
                  LET l_pmn20po = g_pmn[l_ac].pmn20/g_pmn2.pmn62*g_pmn2.pmn70

                  SELECT SUM(pmn20/pmn62*pmn70) INTO l_pondiff FROM pmn_file
                   WHERE pmn68 = g_pmn[l_ac].pmn68 AND pmn69 = g_pmn[l_ac].pmn69
                     AND pmn16 <> '9' AND pmn01 <> g_pmm.pmm01
                  IF STATUS OR l_pondiff IS NULL THEN LET l_pondiff = 0 END IF

                  #輸入之數量不可大於Blanket P/O 之
                  #申請數量-已轉數量(pon20-pon21)
                  IF l_pmn20po > g_pon.pon20 - l_pondiff THEN
                     CALL cl_err('','apm-905',1)
                     NEXT FIELD pmn20
                  END IF
               END IF
               #MOD-BB0264 ----- modify end -----
               #單價預設值的設定
               IF NOT cl_null(g_pmn[l_ac].pmn20) AND g_pmn[l_ac].pmn20 != 0 THEN
                  #IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31 = 0 THEN                                                                                     #MOD-9B0116 mark #FUN-9C0083取消mark
                  IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31 = 0 
                    #OR (g_pmn[l_ac].pmn20 <> g_pmn_t.pmn20) THEN  #TQC-B60029
                     OR (g_pmn[l_ac].pmn20 <> g_pmn_t.pmn20)   #TQC-B60029  #MOD-BC0046
                     OR (g_pmn[l_ac].pmn04 <> g_pmn_t.pmn04) THEN  #MOD-BC0046
                        #FUN-C50074---begin
                        SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                        IF cl_null(g_pnz08) THEN 
                           LET g_pnz08 = 'Y'
                        END IF 
                        IF g_pnz08 = 'Y' THEN
                        #IF g_sma.sma112 = 'Y' THEN
                        #FUN-C50074---end  
                           IF p_cmd = 'a' THEN   #No.MOD-8A0279 add
                              LET l_flag1 = '1'  #No.MOD-8A0279 add
                           ELSE                  #No.MOD-8A0279 add
                              IF cl_confirm('apm-339') THEN
                                 LET l_flag1 = '1'
                              ELSE
                                 LET l_flag1 = '0'
                              END IF
                           END IF                #No.MOD-8A0279 add
                        ELSE
                           LET l_flag1 = '1'
                        END IF
                        IF l_flag1 = '1' THEN
                           LET l_ecm04=' '
                           IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
                              SELECT ecm04 INTO l_ecm04 FROM ecm_file
                               WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
                                 AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                           END IF
                           CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                               g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                               g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                          g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                           IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                           LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                           CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t) #MOD-9C0285 ADD--
                           IF NOT cl_null(g_errno) THEN
                              CALL cl_err('',g_errno,1)
                             #NEXT FIELD pmn86 #MOD-B10043 mark
                              NEXT FIELD pmn20 #MOD-B10043
                           END IF
                        #FUN-B50150  --Begin
                        ELSE    # TQC-B60300 mark
                           CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)   # TQC-B60300 mark
                        #FUN-B50150  --End
                        END IF   #MOD-890109
                 #TQC-AC0257 Begin---
                 #IF g_azw.azw04 = '2' THEN
                 #    CALL s_defprice_A6(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm04,g_pmm.pmm22,
                 #                       g_pmm.pmm21,g_pmm.pmm43,g_pmn[l_ac].pmn07,g_pmm.pmmplant)
                 #      RETURNING li_i,li_i,g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74 
                 #   DISPLAY BY NAME g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74
                 #END IF
                 #TQC-AC0257 End-----
                  IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #FUN-9C0075 ADD
                 #IF p_cmd!='u' THEN
                  IF p_cmd!='u' OR (p_cmd = 'u' AND g_pmn[l_ac].pmn04 <> g_pmn_t.pmn04) THEN  #MOD-BC0046
                     LET g_pmn[l_ac].pmn90=g_pmn[l_ac].pmn31  #取出單價
                     DISPLAY g_pmn[l_ac].pmn90 TO pmn90
                  END IF
                  END IF
                  LET t_pmn31 = g_pmn[l_ac].pmn31                  #no.7231
                  LET t_pmn31t= g_pmn[l_ac].pmn31t                 #no.7231
                 #MOD-CC0023 -- mark start --
                 #IF g_pmn[l_ac].pmn31=0 THEN
                 #   LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                 #   LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t          #No.FUN-610018
                 #END IF
                 #MOD-CC0023 -- mark end --
 
                  IF NOT cl_null(g_pmn[l_ac].pmn68)
                     AND NOT cl_null(g_pmn[l_ac].pmn69) THEN
                     SELECT * INTO g_pon.* FROM pon_file
                      WHERE pon01 = g_pmn[l_ac].pmn68
                        AND pon02 = g_pmn[l_ac].pmn69
                     CALL s_bkprice(t_pmn31,t_pmn31t,g_pon.pon31,g_pon.pon31t)
                          RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
                     IF g_pmn[l_ac].pmn31=0 THEN
                        LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                        LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t          #No.FUN-610018
                     END IF
                  END IF
                  #MOD-B30280 add --start--
                  LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                  CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                  #MOD-B30280 add --end--
                  DISPLAY g_pmn[l_ac].pmn31 TO pmn31
                  DISPLAY g_pmn[l_ac].pmn31t TO pmn31t     #No.FUN-610018
              END IF
              CALL t540_bud(p_cmd,'3')
              IF NOT cl_null(g_errno) THEN
                 NEXT FIELD pmn20 
              END IF
           END IF
 
        BEFORE FIELD pmn83
           IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
           END IF
           CALL t540_set_no_required()
 
        AFTER FIELD pmn83  #第二單位
           IF cl_null(g_pmn[l_ac].pmn04) THEN NEXT FIELD pmn04 END IF
           IF NOT cl_null(g_pmn[l_ac].pmn83) THEN
              #MOD-C70256 add start -----
              IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN
                 LET g_pmn2.pmn121=1
                 LET g_pmn2.pmn09=1
              ELSE
                 IF cl_null(g_pmn2.pmn08) THEN
                    SELECT ima25 INTO g_pmn2.pmn08 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04
                 END IF
                 #取採購對庫存換算率
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn83,g_pmn2.pmn08)
                               RETURNING g_sw,g_pmn2.pmn09
                 IF g_sw THEN
                    CALL cl_err(g_pmn[l_ac].pmn83,'mfg7002',1)
                    LET g_pmn2.pmn09=1
                    NEXT FIELD pmn80
                 END IF

                 #取採購對請購換算率
                 IF g_pmn[l_ac].pmn24 !=' ' AND g_pmn[l_ac].pmn25!=' '
                    AND NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                    IF g_pmm.pmm909 = '2' OR g_pmm.pmm909 = '1' THEN
                       IF g_pmn[l_ac].pmn83<>g_pmn_o.pmn83 THEN
                          CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn83, g_pmn_o.pmn83)
                                        RETURNING g_sw,g_pmn2.pmn121
                          IF g_sw THEN
                             CALL cl_err(g_pmn[l_ac].pmn04,'abm-731',1)
                             NEXT FIELD pmn07
                          END IF
                          LET g_pmn[l_ac].pmn85= g_pmn[l_ac].pmn85/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn85 TO pmn85
                       END IF
                       SELECT pml83 INTO l_pml83 FROM pml_file
                        WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn83,l_pml83)
                                      RETURNING g_sw,g_pmn2.pmn121
                       IF g_sw THEN
                           CALL cl_err('pmn83/pml83: ','abm-731',1)
                           NEXT FIELD pmn07
                       END IF
                       IF cl_null(g_pmn_o.pmn83) THEN
                          LET g_pmn[l_ac].pmn85=g_pmn[l_ac].pmn85/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn85 TO pmn85
                       END IF
                    END IF
                 END IF
              END IF
              IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
                 LET g_factor = 1
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn_o.pmn83,g_pmn[l_ac].pmn83)
                       RETURNING g_cnt,g_factor
                 IF g_cnt = 1 THEN
                    LET g_factor = 1
                 END IF
                 LET g_pmn[l_ac].pmn85 = g_pmn[l_ac].pmn85 * g_factor
                 DISPLAY g_pmn[l_ac].pmn85 TO pmn85
              END IF
              #MOD-C70256 add end   -----
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pmn[l_ac].pmn83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pmn[l_ac].pmn83,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pmn83
              END IF
              CALL s_du_umfchk(g_pmn[l_ac].pmn04,'','','',
                               g_ima44,g_pmn[l_ac].pmn83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pmn[l_ac].pmn83,g_errno,1)  #MOD-640492 0->1
                 NEXT FIELD pmn83
              END IF
              IF cl_null(g_pmn_t.pmn83) OR g_pmn_t.pmn83 <> g_pmn[l_ac].pmn83 THEN
                 LET g_pmn[l_ac].pmn84 = g_factor
              END IF
              LET g_pmn2.pmn83  = g_pmn[l_ac].pmn83
              LET g_pmn_o.pmn83 = g_pmn[l_ac].pmn83
              #No.FUN-BB0086--add--begin--
              IF NOT t540_pmn85_check(p_cmd) THEN 
                 LET g_pmn83_t = g_pmn[l_ac].pmn83
                 NEXT FIELD pmn83
              END IF 
              LET g_pmn83_t = g_pmn[l_ac].pmn83
              #No.FUN-BB0086--add--end--
           END IF
           CALL t540_du_data_to_correct()
           CALL t540_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        AFTER FIELD pmn84  #第二轉換率
           IF NOT cl_null(g_pmn[l_ac].pmn84) THEN
              IF g_pmn[l_ac].pmn84=0 THEN
                 NEXT FIELD pmn84
              END IF
              LET g_pmn2.pmn84  = g_pmn[l_ac].pmn84
              LET g_pmn_o.pmn84 = g_pmn[l_ac].pmn84
           END IF
 
        AFTER FIELD pmn85  #第二數量
           IF NOT t540_pmn85_check(p_cmd) THEN NEXT FIELD pmn85 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_pmn[l_ac].pmn85) THEN
           #   IF g_pmn[l_ac].pmn85 < 0 THEN
           #      CALL cl_err('','aim-391',1)  # #MOD-640492 0->1
           #      NEXT FIELD pmn85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_pmn_t.pmn85 <> g_pmn[l_ac].pmn85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_pmn[l_ac].pmn85*g_pmn[l_ac].pmn84
           #         IF cl_null(g_pmn[l_ac].pmn82) OR g_pmn[l_ac].pmn82=0 THEN #CHI-960022
           #            LET g_pmn[l_ac].pmn82=g_tot*g_pmn[l_ac].pmn81
           #            LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
           #            LET g_pmn_o.pmn82 = g_pmn[l_ac].pmn82
           #            DISPLAY BY NAME g_pmn[l_ac].pmn82                          
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #   LET g_pmn2.pmn85  = g_pmn[l_ac].pmn85
           #  #LET g_pmn_o.pmn85 = g_pmn[l_ac].pmn85                           #MOD-CA0165 mark
           #END IF
           #IF cl_null(g_pmn[l_ac].pmn86) THEN
           #   LET g_pmn[l_ac].pmn87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      (g_pmn_o.pmn81 <> g_pmn[l_ac].pmn81 OR                   #MOD-CA0165   g_pmn_t.pmn81 -> g_pmn_o.pmn81
           #      g_pmn_o.pmn82 <> g_pmn[l_ac].pmn82 OR                    #MOD-CA0165   g_pmn_t.pmn82 -> g_pmn_o.pmn82
           #      g_pmn_o.pmn84 <> g_pmn[l_ac].pmn84 OR                    #MOD-CA0165   g_pmn_t.pmn84 -> g_pmn_o.pmn84
           #      g_pmn_o.pmn85 <> g_pmn[l_ac].pmn85 OR                    #MOD-CA0165   g_pmn_t.pmn85 -> g_pmn_o.pmn85
           #      g_pmn_o.pmn86 <> g_pmn[l_ac].pmn86) THEN                 #MOD-CA0165   g_pmn_t.pmn86 -> g_pmn_o.pmn86
           #      CALL t540_set_pmn87()
           #   END IF
           #END IF
           #LET g_pmn_o.pmn85 = g_pmn[l_ac].pmn85                          #MOD-CA0165   add
           #CALL t540_bud(p_cmd,'3')
           #IF NOT cl_null(g_errno) THEN
           #   NEXT FIELD pmn85
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
        AFTER FIELD pmn80  #第一單位
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           #No.FUN-BB0086--add--end--
           IF cl_null(g_pmn[l_ac].pmn04) THEN NEXT FIELD pmn04 END IF
           IF NOT cl_null(g_pmn[l_ac].pmn80) THEN
              #MOD-C70256 add start -----
              IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN
                 LET g_pmn2.pmn121=1
                 LET g_pmn2.pmn09=1
              ELSE
                 IF cl_null(g_pmn2.pmn08) THEN
                    SELECT ima25 INTO g_pmn2.pmn08 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04
                 END IF
                 #取採購對庫存換算率
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn80,g_pmn2.pmn08)
                               RETURNING g_sw,g_pmn2.pmn09
                 IF g_sw THEN
                    CALL cl_err(g_pmn[l_ac].pmn80,'mfg7002',1)
                    LET g_pmn2.pmn09=1
                    NEXT FIELD pmn80
                 END IF

                 #取採購對請購換算率
                 IF g_pmn[l_ac].pmn24 !=' ' AND g_pmn[l_ac].pmn25!=' '
                    AND NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                    IF g_pmm.pmm909 = '2' OR g_pmm.pmm909 = '1' THEN
                       IF g_pmn[l_ac].pmn80<>g_pmn_o.pmn80 THEN
                          CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn80, g_pmn_o.pmn80)
                                        RETURNING g_sw,g_pmn2.pmn121
                          IF g_sw THEN
                             CALL cl_err(g_pmn[l_ac].pmn04,'abm-731',1)
                             NEXT FIELD pmn07
                          END IF
                          LET g_pmn[l_ac].pmn82= g_pmn[l_ac].pmn82/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn82 TO pmn82
                       END IF
                       SELECT pml80 INTO l_pml80 FROM pml_file
                        WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn80,l_pml80)
                                      RETURNING g_sw,g_pmn2.pmn121
                       IF g_sw THEN
                           CALL cl_err('pmn80/pml80: ','abm-731',1)
                           NEXT FIELD pmn07
                       END IF
                       IF cl_null(g_pmn_o.pmn80) THEN
                          LET g_pmn[l_ac].pmn82=g_pmn[l_ac].pmn82/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn82 TO pmn82
                       END IF
                    END IF
                 END IF
              END IF
              IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
                 LET g_factor = 1
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn_o.pmn80,g_pmn[l_ac].pmn80)
                       RETURNING g_cnt,g_factor
                 IF g_cnt = 1 THEN
                    LET g_factor = 1
                 END IF
                 LET g_pmn[l_ac].pmn82 = g_pmn[l_ac].pmn82 * g_factor
                 DISPLAY g_pmn[l_ac].pmn82 TO pmn82
              END IF
              #MOD-C70256 add end   -----
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pmn[l_ac].pmn80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pmn[l_ac].pmn80,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pmn80
              END IF
              CALL t540_set_origin_field()
              CALL s_du_umfchk(g_pmn[l_ac].pmn04,'','','',
                               g_pmn[l_ac].pmn07,g_pmn[l_ac].pmn80,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pmn[l_ac].pmn80,g_errno,1)  #MOD-640492 0->1
                 NEXT FIELD pmn80
              END IF
              IF cl_null(g_pmn_t.pmn80) OR g_pmn_t.pmn80 <> g_pmn[l_ac].pmn80 THEN
                 LET g_pmn[l_ac].pmn81 = g_factor
              END IF
              LET g_pmn2.pmn80  = g_pmn[l_ac].pmn80
              LET g_pmn_o.pmn80 = g_pmn[l_ac].pmn80
              #No.FUN-BB0086--add--begin--
              #CALL t540_pmn82_check(p_cmd) RETURNING l_tf,l_case    TQC-C30109 mark
              LET g_pmn80_t = g_pmn[l_ac].pmn80
              IF NOT l_tf THEN 
                 CASE l_case
                    WHEN "pmn82" NEXT FIELD pmn82
                    WHEN "pmn85" NEXT FIELD pmn85
                    OTHERWISE EXIT CASE 
                 END CASE 
              END IF 
              #No.FUN-BB0086--add--end--
           END IF
           CALL t540_du_data_to_correct()
           CALL t540_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        AFTER FIELD pmn81  #第一轉換率
           IF NOT cl_null(g_pmn[l_ac].pmn81) THEN
              IF g_pmn[l_ac].pmn81=0 THEN
                 NEXT FIELD pmn81
              END IF
              LET g_pmn2.pmn81  = g_pmn[l_ac].pmn81
              LET g_pmn_o.pmn81 = g_pmn[l_ac].pmn81
           END IF
 
        AFTER FIELD pmn82  #第一數量
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           CALL t540_pmn82_check(p_cmd) RETURNING l_tf,l_case 
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "pmn82" NEXT FIELD pmn82
                 WHEN "pmn85" NEXT FIELD pmn85
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
           IF NOT cl_null(g_pmn[l_ac].pmn82) THEN
              IF g_pmn[l_ac].pmn82 < 0 THEN
                 CALL cl_err('','aim-391',1)  #   #MOD-640492 0->1
                 NEXT FIELD pmn82
              END IF
              LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
             #LET g_pmn_o.pmn82 = g_pmn[l_ac].pmn82   #MOD-CA0165 mark
           END IF
           #計算pmn20,pmn07的值,檢查數量的合理性
            CALL t540_set_origin_field()
            CALL t540_check_inventory_qty(p_cmd)
                RETURNING g_flag
            IF g_flag = '1' THEN
               IF g_ima906 = '3' OR g_ima906 = '2' THEN  #No.FUN-560020
                  NEXT FIELD pmn85
               ELSE
                  NEXT FIELD pmn82
               END IF
            END IF
 
            IF cl_null(g_pmn[l_ac].pmn86) THEN
               LET g_pmn[l_ac].pmn87 = 0
            ELSE
               IF p_cmd = 'a' OR  p_cmd = 'u' AND
                     (g_pmn_o.pmn81 <> g_pmn[l_ac].pmn81 OR          #MOD-CA0165   g_pmn_t.pmn81 -> g_pmn_o.pmn81
                      g_pmn_o.pmn82 <> g_pmn[l_ac].pmn82 OR          #MOD-CA0165   g_pmn_t.pmn82 -> g_pmn_o.pmn82
                      g_pmn_o.pmn84 <> g_pmn[l_ac].pmn84 OR          #MOD-CA0165   g_pmn_t.pmn84 -> g_pmn_o.pmn84
                      g_pmn_o.pmn85 <> g_pmn[l_ac].pmn85 OR          #MOD-CA0165   g_pmn_t.pmn85 -> g_pmn_o.pmn85
                      g_pmn_o.pmn86 <> g_pmn[l_ac].pmn86) THEN       #MOD-CA0165   g_pmn_t.pmn86 -> g_pmn_o.pmn86
                  CALL t540_set_pmn87()
               END IF
            END IF
            LET g_pmn_o.pmn82 = g_pmn[l_ac].pmn82                    #MOD-CA0165   add
            CALL t540_bud(p_cmd,'3')
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD pmn82
            END IF
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        BEFORE FIELD pmn86
           IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
           END IF
           CALL t540_set_no_required()
 
        AFTER FIELD pmn86
           IF cl_null(g_pmn[l_ac].pmn04) THEN NEXT FIELD pmn04 END IF
           IF NOT cl_null(g_pmn[l_ac].pmn86) THEN
              #MOD-C70256 add start -----
              IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN
                 LET g_pmn2.pmn121=1
                 LET g_pmn2.pmn09=1
              ELSE
                 IF cl_null(g_pmn2.pmn08) THEN
                    SELECT ima25 INTO g_pmn2.pmn08 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04
                 END IF
                 #取採購對庫存換算率
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn86,g_pmn2.pmn08)
                               RETURNING g_sw,g_pmn2.pmn09
                 IF g_sw THEN
                    CALL cl_err(g_pmn[l_ac].pmn86,'mfg7002',1)
                    LET g_pmn2.pmn09=1
                    NEXT FIELD pmn80
                 END IF

                 #取採購對請購換算率
                 IF g_pmn[l_ac].pmn24 !=' ' AND g_pmn[l_ac].pmn25!=' '
                    AND NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
                    IF g_pmm.pmm909 = '2' OR g_pmm.pmm909 = '1' THEN
                       IF g_pmn[l_ac].pmn86<>g_pmn_o.pmn86 THEN
                          CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn86, g_pmn_o.pmn86)
                                        RETURNING g_sw,g_pmn2.pmn121
                          IF g_sw THEN
                             CALL cl_err(g_pmn[l_ac].pmn04,'abm-731',1)
                             NEXT FIELD pmn07
                          END IF
                          LET g_pmn[l_ac].pmn87= g_pmn[l_ac].pmn87/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn87 TO pmn87
                       END IF
                       SELECT pml86 INTO l_pml86 FROM pml_file
                        WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn86,l_pml86)
                                      RETURNING g_sw,g_pmn2.pmn121
                       IF g_sw THEN
                           CALL cl_err('pmn86/pml86: ','abm-731',1)
                           NEXT FIELD pmn07
                       END IF
                       IF cl_null(g_pmn_o.pmn86) THEN
                          LET g_pmn[l_ac].pmn87=g_pmn[l_ac].pmn87/g_pmn2.pmn121
                          DISPLAY g_pmn[l_ac].pmn87 TO pmn87
                       END IF
                    END IF
                 END IF
              END IF
              IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
                 LET g_factor = 1
                 CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn_o.pmn86,g_pmn[l_ac].pmn86)
                       RETURNING g_cnt,g_factor
                 IF g_cnt = 1 THEN
                    LET g_factor = 1
                 END IF
                 LET g_pmn[l_ac].pmn87 = g_pmn[l_ac].pmn87 * g_factor
                 DISPLAY g_pmn[l_ac].pmn87 TO pmn87
              END IF
              #MOD-C70256 add end   -----
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pmn[l_ac].pmn86
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pmn[l_ac].pmn86,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pmn86
              END IF
              CALL s_du_umfchk(g_pmn[l_ac].pmn04,'','','',
                               g_ima44,g_pmn[l_ac].pmn86,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pmn[l_ac].pmn86,g_errno,1)   #MOD-640492 0->1
                 NEXT FIELD pmn86
              END IF
                IF g_pmn[l_ac].pmn86 <> g_pmn_o.pmn86 THEN
                   CALL t540_set_pmn87()
                   LET l_ecm04=' '
                   IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
                      SELECT ecm04 INTO l_ecm04 FROM ecm_file
                       WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
                         AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                   END IF
                 CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                     g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                     g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                               g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                 IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                 LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t) #MOD-9C0285 ADD 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD pmn86
                END IF
                 #MOD-B30280 add --start--
                 LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                 CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                 #MOD-B30280 add --end--
                END IF
              CALL t540_bud(p_cmd,'3')
              IF NOT cl_null(g_errno) THEN
                 NEXT FIELD pmn86
              END IF
              LET g_pmn2.pmn86  = g_pmn[l_ac].pmn86
              LET g_pmn_o.pmn86 = g_pmn[l_ac].pmn86
              #No.FUN-BB0086--add--begin---
              IF NOT t540_pmn87_check(p_cmd,l_ecm04) THEN 
                 LET g_pmn86_t = g_pmn[l_ac].pmn86
                 NEXT FIELD pmn86
              END IF 
              LET g_pmn86_t = g_pmn[l_ac].pmn86
              #No.FUN-BB0086--add--end---
           END IF
           CALL t540_set_required()
 
        BEFORE FIELD pmn87
           IF g_sma.sma115 = 'Y' THEN
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 (g_pmn_o.pmn81 <> g_pmn[l_ac].pmn81 OR      #MOD-CA0165 g_pmn_t.pmn81 -> g_pmn_o.pmn81
                  g_pmn_o.pmn82 <> g_pmn[l_ac].pmn82 OR      #MOD-CA0165 g_pmn_t.pmn82 -> g_pmn_o.pmn82
                  g_pmn_o.pmn84 <> g_pmn[l_ac].pmn84 OR      #MOD-CA0165 g_pmn_t.pmn84 -> g_pmn_o.pmn84
                  g_pmn_o.pmn85 <> g_pmn[l_ac].pmn85 OR      #MOD-CA0165 g_pmn_t.pmn85 -> g_pmn_o.pmn85
                  g_pmn_o.pmn86 <> g_pmn[l_ac].pmn86) THEN   #MOD-CA0165 g_pmn_t.pmn86 -> g_pmn_o.pmn86
                 CALL t540_set_pmn87()
              END IF
           ELSE
              IF g_pmn[l_ac].pmn87 = 0 OR
                    (g_pmn_t.pmn20 <> g_pmn[l_ac].pmn20 OR
                     g_pmn_t.pmn86 <> g_pmn[l_ac].pmn86) THEN
                 CALL t540_set_pmn87()
              END IF
           END IF
           CALL t540_bud(p_cmd,'3')
           IF NOT cl_null(g_errno) THEN
              NEXT FIELD pmn82
           END IF
 
        AFTER FIELD pmn87
           IF NOT t540_pmn87_check(p_cmd,l_ecm04) THEN NEXT FIELD pmn87 END IF   #No.FUN-BB0086
           IF NOT cl_null(g_pmn[l_ac].pmn87) THEN
              IF g_pmn[l_ac].pmn87 < 0 THEN
                 CALL cl_err('','aim-391',1)  #  #MOD-640492 0->1
                 NEXT FIELD pmn87
              END IF
              CALL t540_bud(p_cmd,'3')
              IF NOT cl_null(g_errno) THEN
                 NEXT FIELD pmn87
              END IF
              IF g_pmn[l_ac].pmn87 <> g_pmn_o.pmn87 THEN
                 CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                     g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                     g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                        RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                  g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                 IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                 LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)  #MOD-9C0285 ADD--
                 #MOD-B30280 add --start--
                 LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                 CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                 #MOD-B30280 add --end--
              END IF        
              LET g_pmn2.pmn87  = g_pmn[l_ac].pmn87
              LET g_pmn_o.pmn87 = g_pmn[l_ac].pmn87
           END IF
 
        AFTER FIELD pmn68   #Blanket P/O
            IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
               IF cl_null(g_pmn[l_ac].pmn68) THEN
                  CALL cl_err('','apm-907',1)   #No.MOD-4A0356
                  NEXT FIELD pmn68
               END IF
            END IF
            IF NOT cl_null(g_pmn[l_ac].pmn68) THEN
#CHI-B70017               
               IF p_cmd = 'a' OR(p_cmd ='u' AND g_pmn_t.pmn68!= g_pmn[l_ac].pmn68 AND g_pmn_t.pmn69!= g_pmn[l_ac].pmn69) THEN                 
                  IF NOT cl_null (g_pmn[l_ac].pmn69) THEN
                     CALL t540_pmn04_chk(g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmn[l_ac].pmn04) RETURNING  l_success
                     IF l_success ='N' THEN
                        LET g_pmn[l_ac].pmn69 = NULL  #TQC-C60182
                        NEXT FIELD pmn68
                     END IF
                  END IF
               END  IF
#CHI-B70017               

                  CALL t540_pmn68()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pmn[l_ac].pmn68,g_errno,1)  #MOD-640492 0->1
                     NEXT FIELD pmn68
                  END IF
               IF g_pmm.pmm09 != g_pom.pom09 THEN    #廠商編號不合
                   CALL cl_err(g_pmm.pmm09,'apm-903',1)   #No.MOD-4A0356  #MOD-640492 0->1
                  NEXT FIELD pmn68
               END IF

               #MOD-C30797 ----- add start -----
               IF g_pmm.pmm21 != g_pom.pom21 THEN
                  CALL cl_err(g_pmm.pmm09,'apm1074',1)
                  NEXT FIELD pmn68
               END IF
               IF g_pmm.pmm22 != g_pom.pom22 THEN
                  CALL cl_err(g_pmm.pmm09,'apm1075',1)
                  NEXT FIELD pmn68
               END IF
               #MOD-C30797 ----- add end -----
            END IF
            LET g_pmn2.pmn68 = g_pmn[l_ac].pmn68
 
          # 將專案代號 pom05代入pmn122
            LET g_pmn[l_ac].pmn122 = g_pom.pom05
            LET g_pmn2.pmn122 = g_pmn[l_ac].pmn122
 
 
        AFTER FIELD pmn69   #Blanket 項次
            IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
               IF cl_null(g_pmn[l_ac].pmn69) THEN
                  CALL cl_err('','apm-907',1)   #No.MOD-4A0356
                  IF cl_null(g_pmn[l_ac].pmn68) THEN #TQC-C60182
                     NEXT FIELD pmn68                #TQC-C60182
                  ELSE                               #TQC-C60182
                     NEXT FIELD pmn69
                  END IF  #TQC-C60182
               END IF
            END IF
               CALL t540_set_origin_field()    #No.FUN-540027
            IF NOT cl_null(g_pmn[l_ac].pmn69) THEN
               IF ((g_pmn[l_ac].pmn69 != g_pmn_o.pmn69 OR g_pmn_o.pmn69 IS NULL)
               OR (g_pmn[l_ac].pmn68 != g_pmn_o.pmn68 OR g_pmn_o.pmn68 IS NULL))
                 THEN
#CHI-B70017                                           
                   IF NOT cl_null (g_pmn[l_ac].pmn68) THEN
                      CALL t540_pmn04_chk(g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmn[l_ac].pmn04) RETURNING  l_success
                      IF l_success ='N' THEN
                         #NEXT FIELD pmn69 #TQC-C60182
                         LET g_pmn[l_ac].pmn69 = NULL  #TQC-C60182
                         NEXT FIELD pmn68  #TQC-C60182
                      END IF
                   END IF
#CHI-B70017                   

                     SELECT * INTO g_pon.* FROM pon_file
                      WHERE pon01 = g_pmn[l_ac].pmn68
                        AND pon02 = g_pmn[l_ac].pmn69
                     IF STATUS THEN
                         CALL cl_err3("sel","pon_file",g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,"apm-902","","",1)  #No.FUN-660129
                        NEXT FIELD pmn68
                     END IF
                  #NO.FUN-A80001--begin

#MOD-D60176 add begin------------
#根據BLANKET PO单号项次帶出料號單位等基本資料
                     IF cl_null(g_pmn[l_ac].pmn04) THEN 
                        LET g_pmn[l_ac].pmn04 = g_pon.pon04
                        SELECT ima02,ima021 INTO g_pmn[l_ac].pmn041,g_pmn[l_ac].ima021 FROM ima_file
                         WHERE ima01=g_pmn[l_ac].pmn04
                     END IF 
                     IF cl_null(g_pmn[l_ac].pmn07) THEN 
                        LET g_pmn[l_ac].pmn07 = g_pon.pon07
                     END IF  
                     IF g_sma.sma115 = 'Y' THEN 
                        LET g_pmn[l_ac].pmn80 = g_pon.pon80 #单位一
                        LET g_pmn[l_ac].pmn81 = g_pon.pon81 #单位一换算率(与采购单位)
                        LET g_pmn[l_ac].pmn82 = g_pon.pon82 #单位一数量
                        LET g_pmn[l_ac].pmn83 = g_pon.pon83 #单位二
                        LET g_pmn[l_ac].pmn84 = g_pon.pon84 #单位二换算率(与采购单位)                      
                        LET g_pmn[l_ac].pmn85 = g_pon.pon85 #单位二数量
                        LET g_pmn[l_ac].pmn86 = g_pon.pon86 #计价单位
                     END IF    
#MOD-D60176 add end--------------                    

#TQC-C30109---begin
#TQC-C30109---end
                     IF g_pmm.pmm04>g_pon.pon19 THEN
                        CALL cl_err('','apm-815',1)
                        NEXT FIELD pmn69
                     END IF
#TQC-C30109---begin                     
#TQC-C30109---end
                  #NO.FUN-A80001--end
                  #Blanket P/O 之單位轉換因子
                  CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,
                                g_pon.pon07)
                            RETURNING g_sw,g_pmn2.pmn70
                  IF g_sw THEN
                     CALL cl_err('','abm-731',1)
                     IF g_sma.sma115 ='N' THEN
                        NEXT FIELD pmn07
                     ELSE
                        IF g_ima906 = '2' OR g_ima906 = '3' THEN
                           NEXT FIELD pmn83
                        ELSE
                           NEXT FIELD pmn80   #No.FUN-540027
                        END IF
                     END IF
                  END IF
                  #MOD-BB0264 ----- add start -----
                  IF cl_null(g_pmn2.pmn62) THEN LET g_pmn2.pmn62 = 1 END IF
                  LET l_pmn20po = g_pmn[l_ac].pmn20/g_pmn2.pmn62*g_pmn2.pmn70

                  SELECT SUM(pmn20/pmn62*pmn70) INTO l_pondiff FROM pmn_file
                   WHERE pmn68 = g_pmn[l_ac].pmn68 AND pmn69 = g_pmn[l_ac].pmn69
                     AND pmn16 <> '9' AND pmn01 <> g_pmm.pmm01
                  IF STATUS OR l_pondiff IS NULL THEN LET l_pondiff = 0 END IF
                  #MOD-BB0264 ----- add end -----
                  #輸入之數量不可大於Blanket P/O 之
                  #申請數量-已轉數量(pon20-pon21)
                  #IF g_pmn[l_ac].pmn20 > g_pon.pon20 - g_pon.pon21 THEN         #MOD-BB0264 mark
                  IF l_pmn20po > g_pon.pon20 - l_pondiff THEN                    #MOD-BB0264 add
                      CALL cl_err('','apm-905',1)   #No.MOD-4A0356  #MOD-640492 0->1
                     IF g_sma.sma115 ='N' THEN
                        NEXT FIELD pmn20
                     ELSE
                        IF g_ima906 = '2' OR g_ima906 = '3' THEN
                           NEXT FIELD pmn85  #No.FUN-540027
                        ELSE
                           NEXT FIELD pmn82
                        END IF
                     END IF
                  END IF
                    # 若走Blanket PO 流程，單價認定依參數設定
                    IF NOT cl_null(g_pmn[l_ac].pmn68) THEN
                       CALL s_bkprice(t_pmn31,t_pmn31t,g_pon.pon31,g_pon.pon31t)
                          RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
                    END IF
                 IF g_pmn[l_ac].pmn31=0 THEN   #若單價零，預設請購單單價
                    LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                    LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t          #No.FUN-610018
                 DISPLAY BY NAME g_pmn[l_ac].pmn31
                 DISPLAY BY NAME g_pmn[l_ac].pmn31t
                 END IF
                 #MOD-B30280 add --start--
                 LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                 CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                 #MOD-B30280 add --end--
               END IF
             END IF
            LET g_pmn2.pmn69 = g_pmn[l_ac].pmn69
            IF p_cmd!='u' THEN
               LET g_pmn[l_ac].pmn90=g_pmn[l_ac].pmn31  #取出單價
               DISPLAY g_pmn[l_ac].pmn90 TO pmn90
            END IF
            CALL t540_set_no_entry_b(p_cmd)  #FUN-810045
 
 
        BEFORE FIELD pmn31,pmn31t   #單價     #No.FUN-550019
             IF cl_null(g_pmn_o.pmn31) THEN LET g_pmn_o.pmn31=0 END IF
             IF cl_null(g_pmn_o.pmn31t) THEN LET g_pmn_o.pmn31t=0 END IF
            IF g_pmm.pmm02 = 'SUB' THEN   #委外採購單可修改單價及交期
               IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                  #單價預設值的設定
                  IF NOT cl_null(g_pmn[l_ac].pmn20) AND g_pmn[l_ac].pmn20 != 0 THEN
                     IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31 = 0 THEN
                        #FUN-C50074---begin
                        SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                        IF cl_null(g_pnz08) THEN 
                           LET g_pnz08 = 'Y'
                        END IF 
                        IF g_pnz08 = 'Y' THEN
                        #IF g_sma.sma112 = 'Y' THEN
                        #FUN-C50074---end 
                           IF p_cmd = 'a' THEN   #No.MOD-8A0279 add
                              LET l_flag1 = '1'  #No.MOD-8A0279 add
                           ELSE                  #No.MOD-8A0279 add
                              IF cl_confirm('apm-339') THEN
                                 LET l_flag1 = '1'
                              ELSE
                                 LET l_flag1 = '0'
                              END IF
                           END IF                #No.MOD-8A0279 add
                        ELSE
                           LET l_flag1 = '1'
                        END IF
                           IF NOT cl_null(g_pmn[l_ac].pmn43) AND
                              g_pmn[l_ac].pmn43 != 0 THEN
                              SELECT ecm04 INTO l_ecm04
                                FROM ecm_file
                               WHERE ecm01 = g_pmn[l_ac].pmn41 #工號
                                 AND ecm03 = g_pmn[l_ac].pmn43 #製程序
                                 AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                              IF l_flag1 = '1' THEN   #MOD-890109
                                 CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                                     g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,
                                                     g_pmm.pmm21,g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,
                                                     g_pmn[l_ac].pmn91,g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                      RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                                g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                                 IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                                 LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)   #MOD-9C0285 ADD
                           #FUN-B50150  --Begin
                              ELSE          # TQC-B60300 mark
                                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)           # TQC-B60300 mark
                           #FUN-B50150  --End
                              END IF   #MOD-890109
                           ELSE
                              IF l_flag1 = '1' THEN   #MOD-890109
                                 CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                                     g_pmm.pmm04,g_pmn[l_ac].pmn87,'',
                                                     g_pmm.pmm21,g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,
                                                     '',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                         RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                                   g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                                 IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                                 LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t) #MOD-9C0285 ADD  
                           #FUN-B50150  --Begin
                              ELSE             # TQC-B60300 mark
                                 CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)             # TQC-B60300 mark
                           #FUN-B50150  --End
                              END IF   #MOD-890109
                           END IF   
                           IF l_flag1 = '1' THEN   #MOD-890109
                              IF NOT cl_null(g_errno) THEN
                                 CALL cl_err('',g_errno,1)
                                #NEXT FIELD pmn86 #MOD-B10043 mark
                                 NEXT FIELD pmn31 #MOD-B10043
                              END IF
                           END IF   #MOD-890109
                     END IF
                     LET t_pmn31 = g_pmn[l_ac].pmn31
                     LET t_pmn31t= g_pmn[l_ac].pmn31t          #No.FUN-610018
                     IF g_pmn[l_ac].pmn31=0 THEN
                        LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                        LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t   #No.FUN-610018
                     END IF
                     #MOD-B30280 add --start--
                     LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                     CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                     #MOD-B30280 add --end--
                  END IF
               END IF
            END IF
 
               IF NOT cl_null(g_pmn[l_ac].pmn68) THEN
                  CALL s_bkprice(t_pmn31,t_pmn31t,g_pon.pon31,g_pon.pon31t)
                     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
                  IF g_pmn[l_ac].pmn31=0 THEN   #若單價零，預設請購單單價
                     LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                     LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t          #No.FUN-610018
                  END IF
                  IF p_cmd!='u' THEN
                     LET g_pmn[l_ac].pmn90=g_pmn[l_ac].pmn31  #取出單價
                     DISPLAY g_pmn[l_ac].pmn90 TO pmn90
                  END IF
               END IF
            LET g_pmn_o.pmn31 = g_pmn[l_ac].pmn31    #MOD-870113 add
            LET g_pmn_o.pmn31t= g_pmn[l_ac].pmn31t   #MOD-870113 add
            #MOD-B30280 add --start--
            LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
            CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
            #MOD-B30280 add --end--
            DISPLAY g_pmn[l_ac].pmn31 TO pmn31
            DISPLAY g_pmn[l_ac].pmn31t TO pmn31t     #No.FUN-610018
            DISPLAY g_pmn[l_ac].pmn90 TO pmn90     #MOD-C50245 add
 
        AFTER FIELD pmn31   #單價
            IF NOT cl_null(g_pmn[l_ac].pmn31) THEN
                SELECT sfb01 INTO l_sfb01 from sfb_file   #工單2.產生(一對一)
                 WHERE sfb01=g_pmm.pmm01                  #數量不可修改
                IF NOT cl_null(g_argv4) THEN
                   IF FGL_LASTKEY()=2002 THEN
                      IF g_sma.sma115 = 'N' THEN
                         NEXT FIELD pmn07
                      ELSE
                         IF g_ima906 = '3' OR g_ima906 = '2' THEN
                            NEXT FIELD pmn83
                         ELSE
                            NEXT FIELD pmn80
                         END IF
                      END IF
                   END IF
                END IF
                # 參數設定單價不可為零
                #TQC-C10102 add
                IF NOT cl_null(g_pmn[l_ac].pmn41) AND g_pmm.pmm02='SUB' THEN
                   SELECT sfb02 INTO l_sfb02 FROM sfb_file 
                    WHERE sfb01 =g_pmn[l_ac].pmn41                
                END IF 
                #TQC-C10102 add end
                #IF g_sma.sma112= 'N' AND g_argv3 != 'SUB' THEN      #No.TQC-690086 modify #TQC-C10102 mark
                #FUN-C50074---begin
                SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                IF cl_null(g_pnz08) THEN 
                   LET g_pnz08 = 'Y'
                END IF 
                IF g_pnz08 = 'N' AND l_sfb02 != '8' THEN
                #IF g_sma.sma112= 'N'  AND l_sfb02 != '8' THEN         #TQC-C10102 add l_sfb02
                #FUN-C50074---end 
                   IF g_pmn[l_ac].pmn31 <=0 THEN
                      #MOD-D10103 add start -----
                      IF g_chkprice_flag = 'Y' THEN
                         CALL cl_err('','apm1091',1) NEXT FIELD pmn02
                      ELSE
                      #MOD-D10103 add end    -----
                        # CALL cl_err('','axm-627',1) NEXT FIELD pmn31  #FUN-C50076
                         #MOD-D50257 add begin-------
                         IF g_gec07 = 'Y' THEN 
                            CALL cl_err('','axm-627',1) NEXT FIELD pmn31t
                         ELSE 
                            CALL cl_err('','axm-627',1) NEXT FIELD pmn31 
                         END IF        
                         #MOD-D50257 add end--------- 
                      END IF   #MOD-D10103 add
                   END IF
                END IF
                IF g_pmn[l_ac].pmn31 < 0 THEN
                   CALL cl_err(g_pmn[l_ac].pmn31,'mfg1322',1)  #MOD-640492 0->1
                   LET g_pmn[l_ac].pmn31 = g_pmn_o.pmn31
                   DISPLAY g_pmn[l_ac].pmn31 TO pmn31
                   NEXT FIELD pmn31
                END IF
                #----- check採購單價超過最近採購單價% 96-06-25
                IF g_sma.sma84 != 99.99 AND g_pmn[l_ac].pmn04[1,4] <>'MISC' THEN
                  #超限率(sma84)改以取出單價(pmn90)與採購單價(pmn31)相比
                   IF g_pmn[l_ac].pmn90 != 0 THEN
                      IF g_pmn[l_ac].pmn31 > g_pmn[l_ac].pmn90*(1+g_sma.sma84/100) #MOD-740298 #不需在*匯率,因為CHI-690043已將取出的pmn90換算為採購幣別的價格
                      THEN
                         IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                             CALL cl_err(g_pmn[l_ac].pmn04,'apm-240',1) #No:8752  #MOD-640492 0->1
                             NEXT FIELD pmn31
                         ELSE
                             CALL cl_err('','apm-240',1)  #MOD-640492 0->1
                         END IF
                      END IF
                   ELSE
                      SELECT ima53 INTO l_ima53 FROM ima_file
                       WHERE ima01=g_pmn[l_ac].pmn04
                      IF l_ima53 != 0 THEN                #CHI-820014 
                         IF g_pmn[l_ac].pmn31*g_pmm.pmm42 > l_ima53*(1+g_sma.sma84/100)
                           THEN
                            IF g_sma.sma109 = 'R' THEN
                               CALL cl_err(g_pmn[l_ac].pmn04,'apm-240',1)
                               NEXT FIELD pmn31
                            ELSE
                               CALL cl_err('','apm-240',1)
                            END IF
                         END IF
                      END IF
                   END IF
                END IF
                LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03) #No.CHI-6A0004
                IF g_pmn_o.pmn31 <> g_pmn[l_ac].pmn31  THEN #MOD-880090
                LET g_pmn[l_ac].pmn31t =
                    g_pmn[l_ac].pmn31 * ( 1 + g_pmm.pmm43/100)
                END IF #MOD-870113 add
                LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03) #No.CHI-6A0004
                LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                LET g_pmn_o.pmn31 = g_pmn[l_ac].pmn31
                LET g_pmn_o.pmn31t= g_pmn[l_ac].pmn31t       #No.FUN-550019
                LET g_pmn2.pmn31 = g_pmn[l_ac].pmn31
                LET g_pmn2.pmn31t= g_pmn[l_ac].pmn31t        #No.FUN-550019
                LET g_pmn[l_ac].pmn88 = g_pmn[l_ac].pmn31 * g_pmn[l_ac].pmn87   #FUN-D10112
                #LET g_pmn[l_ac].pmn88t= g_pmn[l_ac].pmn31t* g_pmn[l_ac].pmn87   #FUN-D10112                
                LET g_pmn[l_ac].pmn88t= g_pmn[l_ac].pmn31 * ( 1 + g_pmm.pmm43/100)* g_pmn[l_ac].pmn87 #MOD-D90027
                LET g_pmn[l_ac].pmn88t= cl_digcut(g_pmn[l_ac].pmn88t,t_azi04)  #MOD-D90027 add                
            END IF
 
        AFTER FIELD pmn31t   #單價
            IF NOT cl_null(g_pmn[l_ac].pmn31t) THEN
                LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004
                LET g_pmn[l_ac].pmn31 =                                                                                             
                    g_pmn[l_ac].pmn31t / ( 1 + g_pmm.pmm43 / 100)                                                                   
                LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)
----------------##TQC-C30225 add begin
                #IF g_gec07='Y' AND g_gec05 = 'T' THEN
                IF g_gec07='Y' AND g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                   LET g_pmn[l_ac].pmn31 = g_pmn[l_ac].pmn31t * ( 1 - g_pmm.pmm43/100)
                   LET g_pmn[l_ac].pmn31 = cl_digcut( g_pmn[l_ac].pmn31 , t_azi03)
                END IF       
----------------##TQC-C30225 add end
                SELECT sfb01 INTO l_sfb01 from sfb_file   #工單2.產生(一對一)
                 WHERE sfb01=g_pmm.pmm01                  #數量不可修改
                IF NOT cl_null(g_argv4) THEN
                   IF FGL_LASTKEY()=2002 THEN
                      IF g_sma.sma115 = 'N' THEN
                         NEXT FIELD pmn07
                      ELSE
                         IF g_ima906 = '3' OR g_ima906 = '2' THEN
                            NEXT FIELD pmn83
                         ELSE
                            NEXT FIELD pmn80
                         END IF
                      END IF
                   END IF  #No.FUN-540027
                END IF
                # 參數設定單價不可為零
                #TQC-C10102 add
                IF NOT cl_null(g_pmn[l_ac].pmn41) AND g_pmm.pmm02='SUB' THEN
                   SELECT sfb02 INTO l_sfb02 FROM sfb_file 
                    WHERE sfb01 =g_pmn[l_ac].pmn41                
                END IF 
                #TQC-C10102 add end
                #IF g_sma.sma112= 'N' AND g_argv3 != 'SUB' THEN      #No.TQC-690086 modify #TQC-C10102 mark
                #FUN-C50074---begin
                SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                IF cl_null(g_pnz08) THEN 
                   LET g_pnz08 = 'Y'
                END IF 
                IF g_pnz08 = 'N' AND l_sfb02 != '8' THEN
                #IF g_sma.sma112= 'N'  AND l_sfb02 != '8' THEN         #TQC-C10102 add l_sfb02
                #FUN-C50074---end 
                   IF g_pmn[l_ac].pmn31t <=0 THEN
                      #MOD-D10103 add start -----
                      IF g_chkprice_flag = 'Y' THEN
                         CALL cl_err('','apm1091',1) NEXT FIELD pmn02
                      ELSE
                     #MOD-D10103 add end    -----                
                        # CALL cl_err('','axm-627',1) NEXT FIELD pmn31t  #FUN-C50076
                         #MOD-D50257 add begin-------
                         IF g_gec07 = 'Y' THEN 
                            CALL cl_err('','axm-627',1) NEXT FIELD pmn31t
                         ELSE 
                            CALL cl_err('','axm-627',1) NEXT FIELD pmn31 
                         END IF        
                         #MOD-D50257 add end--------- 
                      END IF   #MOD-D10103 add
                   END IF
                END IF
                IF g_pmn[l_ac].pmn31t < 0 THEN
                   CALL cl_err(g_pmn[l_ac].pmn31t,'mfg1322',1)  #MOD-640492 0->1
                   LET g_pmn[l_ac].pmn31t = g_pmn_o.pmn31t
                   NEXT FIELD pmn31t
                END IF
                #----- check採購單價超過最近採購單價% 96-06-25
                IF g_sma.sma84 != 99.99 AND g_pmn[l_ac].pmn04[1,4] <>'MISC' THEN
                  #超限率(sma84)改以取出單價(pmn90)與採購單價(pmn31)相比
                   IF g_pmn[l_ac].pmn90 != 0 THEN
                      IF g_pmn[l_ac].pmn31 > g_pmn[l_ac].pmn90*(1+g_sma.sma84/100) #MOD-740298 #不需在*匯率,因為CHI-690043已將取出的pmn90換算為採購幣別的價格
                      THEN
                         IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                             CALL cl_err(g_pmn[l_ac].pmn04,'apm-240',1) #No:8752  #MOD-640492 0->1
                             NEXT FIELD pmn31t
                         ELSE
                             CALL cl_err('','apm-240',1)  #MOD-640492 0->1
                         END IF
                      END IF
                   ELSE
                      SELECT ima53 INTO l_ima53 FROM ima_file
                       WHERE ima01=g_pmn[l_ac].pmn04
                      IF l_ima53 != 0 THEN                #CHI-820014 
                         IF g_pmn[l_ac].pmn31*g_pmm.pmm42 > l_ima53*(1+g_sma.sma84/100)
                           THEN
                            IF g_sma.sma109 = 'R' THEN
                               CALL cl_err(g_pmn[l_ac].pmn04,'apm-240',1)
                               NEXT FIELD pmn31t    #TQC-940132 pmn31-->pmn31t
                            ELSE
                               CALL cl_err('','apm-240',1)
                            END IF
                         END IF
                      END IF
                   END IF
                END IF
                LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                LET g_pmn_o.pmn31 = g_pmn[l_ac].pmn31
                LET g_pmn_o.pmn31t= g_pmn[l_ac].pmn31t
                LET g_pmn2.pmn31 = g_pmn[l_ac].pmn31
                LET g_pmn2.pmn31t= g_pmn[l_ac].pmn31t
                LET g_pmn[l_ac].pmn88 = g_pmn[l_ac].pmn31 * g_pmn[l_ac].pmn87   #FUN-D10112
                LET g_pmn[l_ac].pmn88t= g_pmn[l_ac].pmn31t* g_pmn[l_ac].pmn87   #FUN-D10112
            END IF
 
        BEFORE FIELD pmn65    #代買否
           IF cl_null(g_pmn[l_ac].pmn65) THEN
              LET g_pmn[l_ac].pmn65='1'
              DISPLAY g_pmn[l_ac].pmn65 TO pmn65
           END IF
 
        AFTER FIELD pmn65    #代買否
           IF NOT cl_null(g_pmn[l_ac].pmn65) THEN
              IF g_pmn[l_ac].pmn65 NOT MATCHES '[12]' THEN
                  NEXT FIELD pmn65
              END IF
           END IF
           LET g_pmn_o.pmn65 = g_pmn[l_ac].pmn65
           LET g_pmn2.pmn65 = g_pmn[l_ac].pmn65
 
        BEFORE FIELD pmn41
          CALL t540_set_entry_b(p_cmd)
 
        AFTER FIELD pmn41    #工單編號
            IF NOT cl_null(g_pmn[l_ac].pmn41) AND g_pmm.pmm02='SUB' THEN
               DECLARE t540_cll CURSOR FOR
                   SELECT * FROM sfb_file
                    WHERE sfb01  = g_pmn[l_ac].pmn41
                       AND sfb87 != 'X'            #No.FUN-550019 #MOD-540162
 
               OPEN t540_cll
               IF STATUS THEN
                  CALL cl_err("OPEN t540_cl:", STATUS, 1)   #No.FUN-660129
                  CLOSE t540_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t540_cll INTO g_sfb.*               # 對DB鎖定
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行

               IF SQLCA.sqlcode THEN
                   CALL cl_err('sel sfb',SQLCA.sqlcode,1)  #MOD-640492 0->1
                   NEXT FIELD pmn41
               END IF
               IF NOT cl_null(g_sfb.sfb82) THEN
                      IF g_pmm.pmm09 != g_sfb.sfb82 AND g_sfb.sfb93 ='N' THEN
                         CALL cl_err('','mfg9360',1)  NEXT FIELD pmn41  #MOD-640492 0->1
                      END IF
               END IF
               IF g_sfb.sfb87 !='Y' THEN
                  IF g_sfb.sfb100='2' THEN
                      CALL cl_err('','asf-933',1)
                  ELSE
                      CALL cl_err('','apm-280',1)
                  END IF
                  NEXT FIELD pmn41
               END IF
               LET g_pmn[l_ac].pmn122 = g_sfb.sfb27 #專案代號　　#MOD-750081 add
               LET g_pmn[l_ac].pmn96 = g_sfb.sfb271 #WBS
               LET g_pmn[l_ac].pmn97 = g_sfb.sfb50  #活動
               LET g_pmn[l_ac].pmn98 = g_sfb.sfb51  #費用原因
               IF g_pmn[l_ac].pmn65='1' THEN
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                   WHERE sfb01 = g_pmn[l_ac].pmn41
                     AND (sfb02=7 OR sfb02=8) AND sfb04 IN ('2','3','4')   #No.MOD-8A0239 add
                  SELECT sfb100 INTO l_sfb100 FROM sfb_file
                    WHERE sfb01 = g_pmn[l_ac].pmn41
                  IF l_cnt = 0 AND l_sfb100 = '1' THEN 
#                     CALL cl_err('','mfg3390',1)  #MOD-640492 0->1 #TQC-C20417 mark
#                     NEXT FIELD pmn41                              #TQC-C20417 mark
#TQC-C20417 add begin 一般工藝工單,但是其中的某道工藝進行委外,過工單欄位報錯
                     SELECT COUNT(*) INTO l_cnt2 FROM ecm_file 
                      WHERE ecm01 = g_pmn[l_ac].pmn41
                       #AND ecm52 = 'Y'   #MOD-D20098 mark
                     IF l_cnt2 = 0 THEN
                        CALL cl_err('','mfg3390',1) 
                        NEXT FIELD pmn41
                     END IF  
#TQC-C20417 add end
                  END IF
               ELSE
                  SELECT COUNT(*) INTO l_cnt FROM sfa_file
                  WHERE sfa01 = g_pmn[l_ac].pmn41 AND sfa065>0
                  IF l_cnt = 0 THEN
                     CALL cl_err(g_pmn[l_ac].pmn41,'apm-591',1)  #TQC-7C0072
                     NEXT FIELD pmn41
                  END IF
               END IF
               IF g_pmn[l_ac].pmn65='1' THEN
                   SELECT SUM(pmn20) INTO l_qty FROM pmn_file,pmm_file  #NO:6961
                    WHERE pmn41=g_pmn[l_ac].pmn41 AND pmn65='1'
                     AND pmm01=pmn01
                     AND pmn04=g_sfb.sfb05   #add
                    #AND pmn16 <> '8'     #TQC-C10116    #MOD-C70081 mark
                     AND pmn16 NOT IN ('6','7','8','9')  #MOD-C70081
                     AND pmm18 <> 'X'                    #MOD-C70081
                   IF cl_null(l_qty) THEN LET l_qty=0 END IF
                   IF cl_null(g_pmn[l_ac].pmn07) THEN
                       #應用採購單位
                       SELECT ima44 INTO g_pmn[l_ac].pmn07 FROM ima_file
                        WHERE ima01=g_sfb.sfb05
                     END IF
                     SELECT ima55 INTO l_ima55 FROM ima_file
                      WHERE ima01 = g_sfb.sfb05
                     CALL s_umfchk(g_sfb.sfb05,g_pmn[l_ac].pmn07,l_ima55)
                          RETURNING g_i,l_fac
                    IF g_i THEN
                        CALL cl_err('','mfg3075',1)  #MOD-640492 0->1
                        NEXT FIELD pmn41
                    END IF
                    LET l_qty = l_qty * l_fac
 
                    IF l_qty > g_sfb.sfb08 AND
                      (p_cmd='a' OR (g_pmn[l_ac].pmn41!=g_pmn_t.pmn41
                       AND g_pmn[l_ac].pmn41 IS NOT NULL)) THEN
                      CALL cl_err('','apm-302',1) NEXT FIELD pmn41  #MOD-640492 0->1
                   END IF
               END IF
 
              #IF p_cmd='a' AND g_pmn[l_ac].pmn65='1' THEN   #NO:6961
               IF (p_cmd='a' OR (g_pmn[l_ac].pmn41!=g_pmn_t.pmn41 AND g_pmn[l_ac].pmn41 IS NOT NULL)) #TQC-C10068
                  AND g_pmn[l_ac].pmn65='1' THEN  #TQC-C10068
                  IF g_sfb.sfb02= 8 THEN                     #若資料為8重工委外
                     SELECT sfa05 INTO l_sfa05               #不帶零件退庫備料<0
                       FROM sfa_file,sfb_file                #出來
                      WHERE sfb01=sfa01
                        AND sfb01=g_pmn[l_ac].pmn41
                        AND sfa03=g_sfb.sfb05
                     IF l_sfa05<0 THEN
                        NEXT FIELD pmn04
                     END IF
                  END IF
                  LET g_pmn[l_ac].pmn04 = g_sfb.sfb05
                  CALL t540_pmn04('a',g_no)                                                                              
                  ######  無效料件或Phase Out者不可以請購
                  IF g_errno <> ' ' THEN
                     CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1) #MOD-640492 0->1
                     NEXT FIELD pmn41
                  END IF
                  LET g_pmn[l_ac].pmn20 = g_sfb.sfb08 - l_qty
                  IF cl_null(g_pmn[l_ac].pmn07) THEN
                     SELECT ima44 INTO g_pmn[l_ac].pmn07 FROM ima_file
                      WHERE ima01=g_pmn[l_ac].pmn04
                  END IF
                  SELECT ima55 INTO l_ima55 FROM ima_file
                   WHERE ima01 = g_pmn[l_ac].pmn04
                  #                              生產單位,採購單位
                  CALL s_umfchk(g_pmn[l_ac].pmn04,l_ima55,g_pmn[l_ac].pmn07)
                       RETURNING g_i,l_fac
                  IF g_i THEN
                      CALL cl_err('','mfg3075',1)  #MOD-640492 0->1
                      NEXT FIELD pmn41
                  END IF
                  LET g_pmn[l_ac].pmn20 = g_pmn[l_ac].pmn20 * l_fac
                  LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                  IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31=0 THEN
                     IF NOT cl_null(g_pmn[l_ac].pmn20) AND g_pmn[l_ac].pmn20 != 0 THEN
                           #FUN-C50074---begin
                           SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                           IF cl_null(g_pnz08) THEN 
                              LET g_pnz08 = 'Y'
                           END IF 
                           IF g_pnz08 = 'Y' THEN
                           #IF g_sma.sma112 = 'Y' THEN
                           #FUN-C50074---end 
                              IF p_cmd = 'a' THEN   #No.MOD-8A0279 add
                                 LET l_flag1 = '1'  #No.MOD-8A0279 add
                              ELSE                  #No.MOD-8A0279 add
                                 IF cl_confirm('apm-339') THEN
                                    LET l_flag1 = '1'
                                 ELSE
                                    LET l_flag1 = '0'
                                 END IF
                              END IF                #No.MOD-8A0279 add
                           ELSE
                              LET l_flag1 = '1'
                           END IF
                           IF NOT cl_null(g_pmn[l_ac].pmn43) AND
                              g_pmn[l_ac].pmn43 != 0 THEN
                               SELECT ecm04 INTO l_ecm04
                                 FROM ecm_file
                                WHERE ecm01 = g_pmn[l_ac].pmn41 #工號
                                  AND ecm03 = g_pmn[l_ac].pmn43 #製程序
                                  AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                               IF l_flag1 = '1' THEN   #MOD-890109
                                  CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn[l_ac].pmn87,
                                                      l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                       RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                                 g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                                  IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                                  LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t) #MOD-9C0285 ADD
                        #FUN-B50150  --Begin
                               ELSE          # TQC-B60300 mark
                                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)         # TQC-B60300 mark
                        #FUN-B50150  --End
                               END IF   #MOD-890109
                           ELSE
                               IF l_flag1 = '1' THEN   #MOD-890109
                                  CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn[l_ac].pmn87,'',
                                                      g_pmm.pmm21,g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                         RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                                   g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                                  IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
                                  LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31 #MOD-C50245 add
                                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)  #MOD-9C0285 ADD  
                        #FUN-B50150  --Begin
                               ELSE       # TQC-B60300 mark
                                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)        # TQC-B60300 mark
                        #FUN-B50150  --End
                               END IF   #MOD-890109
                           END IF
                           IF l_flag1 = '1' THEN   #MOD-890109
                               IF NOT cl_null(g_errno) THEN
                                  CALL cl_err('',g_errno,1)
                                 #NEXT FIELD pmn86 #MOD-B10043 mark
                                  NEXT FIELD pmn41 #MOD-B10043
                               END IF
                           END IF   #MOD-890109
 
                        IF cl_null(g_pmn[l_ac].pmn31) THEN
                           LET g_pmn[l_ac].pmn31=0
                           LET g_pmn[l_ac].pmn31t=0
                        END IF
                        #MOD-B30280 add --start--
                        LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                        CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
                        #MOD-B30280 add --end--
                     END IF
                  END IF
                 #MOD-B50194 mark --start--
                 #IF cl_null(g_pmn[l_ac].pmn33) THEN
                 #   LET g_pmn[l_ac].pmn33=g_sfb.sfb15
                 #END IF
                 #IF cl_null(g_pmn[l_ac].pmn34) THEN
                 #   LET g_pmn[l_ac].pmn34=g_sfb.sfb15
                 #END IF
                 #MOD-B50194 mark --end--
                  #-----CHI-9C0023---------
                  IF cl_null(g_pmn[l_ac].pmn35) THEN
                     LET g_pmn[l_ac].pmn35=g_sfb.sfb15
                  END IF
                  #-----END CHI-9C0023-----
                  #MOD-B50194 add --start--
                  IF cl_null(g_pmn[l_ac].pmn34) THEN
                     LET g_pmn[l_ac].pmn34 = g_pmn[l_ac].pmn35 - g_ima491
                  END IF
                  IF cl_null(g_pmn[l_ac].pmn33) THEN
                     LET g_pmn[l_ac].pmn33 = g_pmn[l_ac].pmn34 - g_ima49 
                  END IF
                  #MOD-B50194 add --end--
                  #FUN-D40042--add--str--
                  LET g_pmn[l_ac].pmn100 = '' 
                  SELECT sfb96 INTO g_pmn[l_ac].pmn100 FROM sfb_file 
                   WHERE sfb01=g_pmn[l_ac].pmn41
                  #FUN-D40042--add--end--
                  DISPLAY g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn20,
                          g_pmn[l_ac].pmn07,g_pmn[l_ac].pmn31,
                          g_pmn[l_ac].pmn31t,
                          g_pmn[l_ac].pmn33,g_pmn[l_ac].pmn34,
                          g_pmn[l_ac].pmn35,g_pmn[l_ac].pmn100  #CHI-9C0023 #FUN-D40042 add pmn100
                       TO pmn04,pmn20,pmn07,pmn31,pmn31t,pmn33,pmn34,pmn35,pmn100  #No.FUN-610018  #CHI-9C0023 add pmn35 #FUN-D40042 add pmn100
                  LET g_pmn2.pmn04 = g_pmn[l_ac].pmn04
                  LET g_pmn2.pmn07 = g_pmn[l_ac].pmn07
                  LET g_pmn2.pmn20 = g_pmn[l_ac].pmn20
                  LET g_pmn2.pmn31 = g_pmn[l_ac].pmn31
                  LET g_pmn2.pmn33 = g_pmn[l_ac].pmn33
                  LET g_pmn2.pmn34 = g_pmn[l_ac].pmn34
                  LET g_pmn2.pmn35 = g_pmn[l_ac].pmn35   #CHI-9C0023
                  LET g_pmn2.pmn100= g_pmn[l_ac].pmn100  #FUN-D40042 add
               END IF
               IF g_pmn[l_ac].pmn65='1' THEN
                  IF g_pmn[l_ac].pmn04!=g_sfb.sfb05 THEN
                     CALL cl_err(g_sfb.sfb05,'apm-247',1)  #MOD-640492 0->1
                     LET g_pmn[l_ac].pmn41=null
                     DISPLAY g_pmn[l_ac].pmn41 TO pmn41
                     NEXT FIELD pmn41
                  END IF
                 #LET g_pmn[l_ac].pmn43 = 0                         #MOD-D10202 mark 
                 #LET g_pmn[l_ac].pmn431 = 0                        #MOD-D10202 mark
                 #LET g_pmn[l_ac].pmn012 = ' '    #No.FUN-A60011    #MOD-D10202 mark
                  DISPLAY g_pmn[l_ac].pmn43,g_pmn[l_ac].pmn431
               END IF
               LET g_pmn[l_ac].pmn43 = 0                            #MOD-D10202 add
               LET g_pmn[l_ac].pmn431 = 0                           #MOD-D10202 add
               LET g_pmn[l_ac].pmn012 = ' '                         #MOD-D10202 add
               CALL t540_set_entry_b(p_cmd)  #FUN-810045 add
            END IF


        #No.FUN-A60011  --Begin
        AFTER FIELD pmn012
            IF g_pmn[l_ac].pmn012 IS NOT NULL THEN
               IF NOT cl_null(g_pmn[l_ac].pmn41) THEN
                  CALL t540_pmn012(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pmn[l_ac].pmn012,g_errno,0)
                     NEXT FIELD pmn012
                  END IF
               END IF
            ELSE
               LET g_pmn[l_ac].pmn012 = ' '
            END IF
        #No.FUN-A60011  --End  
 
        AFTER FIELD pmn89    #保稅否
            IF g_pmn[l_ac].pmn89 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD pmn89
            END IF
            LET g_pmn2.pmn89 = g_pmn[l_ac].pmn89
 
        AFTER FIELD pmn64    #保稅否
            IF g_pmn[l_ac].pmn64 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD pmn64
            END IF
            LET g_pmn2.pmn64 = g_pmn[l_ac].pmn64
 
        BEFORE FIELD pmn63    #急料否
            IF cl_null(g_pmn[l_ac].pmn63) THEN
               LET g_pmn[l_ac].pmn63 = 'N'
            END IF
 
        AFTER FIELD pmn63    #急料否
            LET g_pmn2.pmn63 = g_pmn[l_ac].pmn63
 
        AFTER FIELD pmn33    #交貨日期
             IF NOT cl_null(g_pmn[l_ac].pmn33) THEN
                IF g_pmm.pmm04 > g_pmn[l_ac].pmn33 THEN
                   CALL cl_err("","apm-029",1)           #MOD-640491 0->1
                   NEXT FIELD pmn33
                END IF
                LET li_result = 0
                CALL s_daywk(g_pmn[l_ac].pmn33) RETURNING li_result
  
                IF li_result = 0 THEN      #0:非工作日
                   CALL cl_err(g_pmn[l_ac].pmn33,'mfg3152',1)
                END IF
                IF li_result = 2 THEN      #2:未設定
                   CALL cl_err(g_pmn[l_ac].pmn33,'mfg3153',1)
                END IF
  
                IF NOT cl_null(g_pmn[l_ac].pmn34) THEN
                   IF g_pmn[l_ac].pmn33 > g_pmn[l_ac].pmn34 THEN
                      CALL cl_err('','mfg3225',1)  #MOD-640492 0->1
                      #NEXT FIELD pmn33   #MOD-A70148
                      NEXT FIELD pmn34   #MOD-A70148
                   END IF
                END IF
                #IF NOT cl_null(g_pmn2.pmn35) THEN   #CHI-9C0023
                IF NOT cl_null(g_pmn[l_ac].pmn35) THEN   #CHI-9C0023
                   #IF g_pmn[l_ac].pmn33 > g_pmn2.pmn35 THEN   #CHI-9C0023
                   IF g_pmn[l_ac].pmn33 > g_pmn[l_ac].pmn35 THEN   #CHI-9C0023
                      CALL cl_err('','mfg3224',1)
                      #NEXT FIELD pmn33   #MOD-A70148
                      NEXT FIELD pmn35   #MOD-A70148
                   END IF
                END IF
             END IF
             LET g_pmn2.pmn33 = g_pmn[l_ac].pmn33
 
 
        BEFORE FIELD pmn34     #到廠日期
            IF cl_null(g_pmn[l_ac].pmn34) AND NOT cl_null(g_pmn[l_ac].pmn33) THEN #TQC-5B0058 ADD
               IF cl_null(g_ima49) THEN LET g_ima49 = 0 END IF    #TQC-730022 =null的話在BEFORE FIELD pmn34會繞不出來
              #MOD-B90117 ---mod ----begin---------------
              #LET g_pmn[l_ac].pmn34 = g_pmn[l_ac].pmn33 + g_ima49
              #CALL s_wkday(g_pmn[l_ac].pmn34) RETURNING l_flag,l_date
               CALL t540_get_date(g_pmn[l_ac].pmn33,g_ima49) RETURNING l_date
              #MOD-B90117 ---mod -----end----------------
               IF l_date IS NULL OR l_date = ' ' THEN
                   NEXT FIELD pmn34
               ELSE
                   LET g_pmn[l_ac].pmn34 = l_date
                   DISPLAY g_pmn[l_ac].pmn34 TO pmn34
               END IF
            END IF
 
        AFTER FIELD pmn34     #輸入海關手冊編
            IF NOT cl_null(g_pmn[l_ac].pmn34) AND NOT cl_null(g_pmn[l_ac].pmn33) THEN
               IF g_pmn[l_ac].pmn33 > g_pmn[l_ac].pmn34 THEN
                  CALL cl_err('','mfg3225',1)  #MOD-640492 0->1
                  NEXT FIELD pmn34
               END IF
            END IF

            #-----CHI-9C0023---------
            #往下移
            #IF NOT cl_null(g_pmn[l_ac].pmn34) AND NOT cl_null(g_pmn2.pmn35) THEN
            #   IF g_pmn2.pmn35 < g_pmn[l_ac].pmn34 THEN
            #      CALL cl_err('','mfg3195',1) 
            #      NEXT FIELD pmn34
            #   END IF
            #END IF
            #LET g_pmn2.pmn34 = g_pmn[l_ac].pmn34
            #-----END CHI-9C0023-----

            IF g_pmn_t.pmn34 IS NULL OR g_pmn_t.pmn34 != g_pmn[l_ac].pmn34 THEN 
               SELECT ima491 INTO l_ima491 FROM ima_file
                WHERE ima01 = g_pmn[l_ac].pmn04
              #MOD-B90117 mod begin--------------------
              #IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
              ##LET g_pmn2.pmn35 = g_pmn[l_ac].pmn34 + l_ima491    #CHI-9C0023
              #LET g_pmn[l_ac].pmn35 = g_pmn[l_ac].pmn34 + l_ima491    #CHI-9C0023
               CALL t540_get_date(g_pmn[l_ac].pmn34,l_ima491) RETURNING g_pmn[l_ac].pmn35
              #MOD-B90117 mod end----------------------
            END IF  

            #-----CHI-9C0023---------
            IF NOT cl_null(g_pmn[l_ac].pmn34) AND NOT cl_null(g_pmn[l_ac].pmn35) THEN
               IF g_pmn[l_ac].pmn35 < g_pmn[l_ac].pmn34 THEN
                  CALL cl_err('','mfg3195',1) 
                  #NEXT FIELD pmn34   #MOD-A70148
                  NEXT FIELD pmn35   #MOD-A70148
               END IF
            END IF
            LET g_pmn2.pmn34 = g_pmn[l_ac].pmn34
            #-----END CHI-9C0023-----

            IF g_aza.aza27 = 'Y' AND g_smy.smy57[5,5] = 'Y' THEN
               CALL t540_b_more2(p_cmd)
            END IF

        #-----CHI-9C0023---------
        AFTER FIELD pmn35
            IF NOT cl_null(g_pmn[l_ac].pmn35) THEN
               CALL s_wkday(g_pmn[l_ac].pmn35) RETURNING l_flag,l_date
               IF cl_null(l_date) THEN
                  NEXT FIELD pmn35
               ELSE
                  LET g_pmn[l_ac].pmn35 = l_date
                  DISPLAY BY NAME g_pmn[l_ac].pmn35
               END IF
               IF g_pmn[l_ac].pmn35 < g_pmn[l_ac].pmn34 OR
                  g_pmn[l_ac].pmn35 < g_pmn[l_ac].pmn33 THEN
                  CALL cl_err(g_pmn[l_ac].pmn35,'mfg3195',1)
                  NEXT FIELD pmn35
               END IF
            ELSE
               SELECT ima491 INTO l_ima491 FROM ima_file
                WHERE ima01 = g_pmn[l_ac].pmn04
              #MOD-B90117 mod begin--------
              #IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
              #LET g_pmn[l_ac].pmn35 = g_pmn[l_ac].pmn34 + l_ima491
               CALL t540_get_date(g_pmn[l_ac].pmn34,l_ima491) RETURNING g_pmn[l_ac].pmn35
              #MOD-B90117 mod end----------
               DISPLAY BY NAME g_pmn[l_ac].pmn35
            END IF
            LET g_pmn2.pmn35 = g_pmn[l_ac].pmn35
        #-----END CHI-9C0023-----
        
       #FUN-A80150---add---start--
        BEFORE FIELD pmn919
           IF cl_null(g_pmn[l_ac].pmn35) THEN
              NEXT FIELD pmn35
           END IF
       #FUN-A80150---add---end---
 
        BEFORE FIELD pmn930   
            IF g_aaz.aaz90='Y' THEN
                IF NOT cl_null(g_pmn[l_ac].pmn25) THEN
                    CALL cl_set_comp_entry("pmn930",FALSE)
                END IF
            END IF

         AFTER FIELD pmn930   #TQC-B80051 
            IF NOT cl_null(g_pmn[l_ac].pmn930) THEN
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                                          WHERE gem01=g_pmn[l_ac].pmn930
                                            AND gem09 IN ('1','2')
                                            AND gemacti='Y'
                IF l_cnt=0 THEN
                   CALL cl_err3("sel","gem_file",g_pmn[l_ac].pmn930,"",100,"","",1)
                   LET g_pmn[l_ac].pmn930=g_pmn_t.pmn930
                   LET g_pmn[l_ac].gem02a=g_pmn_t.gem02a
                   DISPLAY BY NAME g_pmn[l_ac].pmn930,g_pmn[l_ac].gem02a
#TQC-A80009 ---add
                   LET g_pmn[l_ac].pmn930 = NULL
#TQC-A80009 --end
                   NEXT FIELD pmn930
                END IF
                CALL t540_bud(p_cmd,'3')
                IF NOT cl_null(g_errno) THEN
                   NEXT FIELD pmn930
                END IF
                CALL t540_set_pmn930(g_pmn[l_ac].pmn930) RETURNING g_pmn[l_ac].gem02a
                DISPLAY BY NAME g_pmn[l_ac].gem02a
            ELSE
                LET g_pmn[l_ac].gem02a=NULL
                DISPLAY BY NAME g_pmn[l_ac].gem02a
            END IF
            LET g_pmn2.pmn930  = g_pmn[l_ac].pmn930
            LET g_pmn_o.pmn930 = g_pmn[l_ac].pmn930
 
        AFTER FIELD pmn123
              IF NOT cl_null(g_pmn[l_ac].pmn123) THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM mse_file
                  WHERE mse01 = g_pmn[l_ac].pmn123
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_pmn[l_ac].pmn123,'mfg2603',0)
                    NEXT FIELD pmn123
                 ELSE 
                   SELECT mse02 INTO g_pmn[l_ac].mse02
                     FROM mse_file WHERE mse01=g_pmn[l_ac].pmn123
                   DISPLAY g_pmn[l_ac].mse02 TO FORMONLY.mse02
                 END IF
              #TQC-BB0165--begin
              ELSE
                 LET g_pmn[l_ac].mse02=' '
                 DISPLAY g_pmn[l_ac].mse02 TO FORMONLY.mse02
              #TQC-BB0165--end
              END IF
 
 
 
        AFTER FIELD pmn38
            LET g_pmn2.pmn38 = g_pmn[l_ac].pmn38
        #NO.FUN-960130--start----商品條碼
        AFTER FIELD pmn72
           IF NOT cl_null(g_pmn[l_ac].pmn72) THEN
#FUN-AB0025 --------mark start-----------
#           #FUN-AA0059 ---------------------start----------------------------
#           IF NOT s_chk_item_no(g_pmn[l_ac].pmn72,"") THEN
#            CALL cl_err('',g_errno,1)
#            LET g_pmn[l_ac].pmn72= g_pmn_t.pmn72
#            NEXT FIELD pmn72
#           END IF
#           #FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 --------mark end--------
              IF p_cmd='a' OR (p_cmd='u' AND g_pmn[l_ac].pmn72<>g_pmn_t.pmn72) THEN
              CALL t540_pmn72('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD pmn72
              ELSE
                 CALL t540_chkpmn04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_errmsg,g_errno,0)
                    NEXT FIELD pmn72
                 ELSE
                    CALL t540_check_pmn04('pmn04',l_ac,p_cmd) RETURNING l_check_res
                    IF NOT l_check_res THEN NEXT FIELD pmn72 END IF
                    CALL cl_set_comp_entry("pmn04,pmn041,pmn07",FALSE)
                 END IF
              END IF
           END IF
        ELSE
           CALL cl_set_comp_entry("pmn04,pmn07",TRUE)
        END IF
 
        AFTER FIELD pmnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pmnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_argv2 = '2' THEN
              SELECT pmn50 INTO l_pmn50 FROM pmn_file
               WHERE pmn01 = g_pmm.pmm01 AND pmn02 = g_pmn[l_ac].pmn02
              IF l_pmn50 > 0 THEN
                 CALL cl_err('','mfg3374',1)  #MOD-640492 0->1
                    LET l_ac_t = l_ac
                   EXIT INPUT 
              END IF
           END IF
           IF g_pmm.pmm02 ='SUB' THEN   #NO:6961委外型態='1'一對一時跟工單單號相同不可刪
              SELECT COUNT(*) INTO l_n FROM sfb_file,pmm_file,pmn_file
               WHERE sfb01 = g_pmm.pmm01
                 AND pmn01 = pmm01
                 AND sfb100 = '1'
              IF l_n>0 THEN
                 CALL cl_err('','apm-592',1)  #TQC-7C0072
                 LET l_ac_t = l_ac
                 EXIT INPUT   
              END IF
           END IF
           #請購分配單不可刪除
           IF g_pmm.pmm909='6' THEN 
              CALL cl_err('','art-246',0)
              CANCEL DELETE
           END IF
            IF g_pmn_t.pmn02 > 0 AND
               g_pmn_t.pmn02 IS NOT NULL THEN

                IF g_pmm.pmm909='8' AND g_pmn_t.pmn24 IS NOT NULL THEN
                   IF NOT cl_confirm('apm1025') OR (g_argv2 !=2 AND g_pmm.pmm25 MATCHES'[26789]') THEN
                      CANCEL DELETE
                   END IF
                ELSE
                   IF NOT cl_delb(0,0) OR (g_argv2 !=2 AND g_pmm.pmm25 MATCHES'[26789]') THEN
                      CANCEL DELETE
                   END IF
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                IF g_sma.sma901 = 'Y' THEN
                    LET l_chr4 = g_pmn_t.pmn02 USING '&&&&'
                    LET l_vmz01 = g_pmm.pmm01 CLIPPED,'-',l_chr4   #NO.FUN-7C0002 add
                    DELETE FROM vmz_file             #NO.FUN-7C0002 add
                     WHERE vmz01 = l_vmz01           #NO.FUN-7C0002 add
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","vmz_file",l_vmz01,'',SQLCA.sqlcode,"","",1)  #NO.FUN-7C0002 add
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
                END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#&ifdef SLK               
#               #FUN-A60035 ---add begin
#               #刪除前將序號記錄下來
#               CALL g_index_pmn02.clear()
#               DECLARE t540_index_pmn02 CURSOR FOR
#                 SELECT ata03 FROM ata_file
#                  WHERE ata00 = g_prog
#                    AND ata02 = g_pmn_t.pmn02
#                    AND ata01 = g_pmm.pmm01
#               LET l_index = 1
#               FOREACH t540_index_pmn02 INTO g_index_pmn02[l_index].pmn02
#                  IF STATUS THEN
#                     CALL cl_err('',STATUS,1)
#                  END IF
#                  LET l_index = l_index + 1
#               END FOREACH 
#               CALL g_index_pmn02.deleteElement(l_index)
#               #FUN-A60035 ---add end 
#               DELETE FROM pmn_file 
#                      WHERE pmn01 = g_pmm.pmm01 
#                        AND pmn02 IN
#                    (SELECT ata03 FROM ata_file 
#                      WHERE ata00 = g_prog
#                        AND ata02 = g_pmn_t.pmn02
#                        AND ata01 = g_pmm.pmm01)
#                     IF SQLCA.sqlcode THEN
#                        CALL cl_err3("del","pmn_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)
#                        ROLLBACK WORK
#                        CANCEL DELETE
#                     ELSE
#                        DELETE FROM pmni_file 
#                         WHERE pmni01 = g_pmm.pmm01 
#                           AND pmni02 IN
#                       (SELECT ata03 FROM ata_file 
#                         WHERE ata00 = g_prog
#                           AND ata02 = g_pmn_t.pmn02
#                           AND ata01 = g_pmm.pmm01)
#                        IF SQLCA.sqlcode THEN
#                           CALL cl_err3("del","pmni_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)
#                           ROLLBACK WORK
#                           CANCEL DELETE 
#                        ELSE
#                           DELETE FROM ata_file 
#                            WHERE ata00 = g_prog
#                              AND ata02 = g_pmn_t.pmn02
#                              AND ata01 = g_pmm.pmm01
#                           IF SQLCA.sqlcode THEN
#                              CALL cl_err3("del","ata_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)
#                              ROLLBACK WORK
#                              CANCEL DELETE
#                           ELSE
#                           	 IF g_aza.aza88='Y' THEN
#                                 LET g_pmm.pmmpos='N'
#                                 DISPLAY BY NAME g_pmm.pmmpos
#                                 UPDATE pmm_file SET pmmpos=g_pmm.pmmpos
#                                  WHERE pmm01 =g_pmm.pmm01
#                               END IF
#                           END IF      
#                        END IF
#&else                                     
#FUN-A60035 ---MARK END
#MOD-B60119 -- begin --
                DELETE FROM pmo_file
                   WHERE pmo01 = g_pmm.pmm01
                   AND pmo03 = g_pmn_t.pmn02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pmo_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
#MOD-B60119 -- end --
                DELETE FROM pmn_file
                    WHERE pmn01 = g_pmm.pmm01 AND
                          pmn02 = g_pmn_t.pmn02
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行
 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pmn_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
               #FUN-A30030 ADD--------------------------------------
                IF g_aza.aza88='Y' THEN
                   LET g_pmm.pmmpos='N'
                   DISPLAY BY NAME g_pmm.pmmpos
                   UPDATE pmm_file SET pmmpos=g_pmm.pmmpos
                    WHERE pmm01 =g_pmm.pmm01
                END IF
               #FUN-A30030 END--------------------------------------
#&endif               #FUN-A60035 ---MARK

#      IF g_pmm.pmm909 <> '3'            #MOD-B60102 mark
       IF g_pmm.pmm909 MATCHES '[128]'   #MOD-B60102
           THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#          FOR l_index = 1 TO g_index_pmn02.getLength()
#             LET g_pmn_o.pmn25 = g_index_pmn02[l_index].pmn02
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
                    IF NOT cl_null(g_pmn_o.pmn24) THEN
                       #MOD-BC0168 add --start--
                       SELECT pml16 INTO l_pml16 
                         FROM pml_file
                        WHERE pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                       #MOD-BC0168 add --end--
                       SELECT SUM(pmn20/pmn62*pmn121) INTO l_pmn20 FROM pmn_file
                        WHERE pmn24 = g_pmn_o.pmn24 AND pmn25 = g_pmn_o.pmn25
                          AND pmn16<>'9'       #取消(Cancel)
                       IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
 
                 #FUN-910088--add--start--
                     SELECT pml07 INTO l_pml07 FROM pml_file
                       WHERE  pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                     LET l_pmn20 = s_digqty(l_pmn20,l_pml07)
                 #FUN-910088--add--end--
                    IF g_pmm.pmm909<>'8' THEN        #FUN-A10034
                       #MOD-BC0168 add --start--
                       IF l_pml16 NOT MATCHES '[678]' THEN 
                          IF l_pmn20=0 THEN
                             LET l_pml16 ='1'
                          END IF
                       END IF
                       #MOD-BC0168 add --end--
                      #IF l_pmn20=0 THEN #MOD-BC0168 mark
                         #UPDATE pml_file SET pml21 = l_pmn20,pml16='1'   #MOD-950116 #MOD-BC0168 mark
                          UPDATE pml_file SET pml21 = l_pmn20,pml16=l_pml16           #MOD-BC0168
                           WHERE pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","pml_file",g_pmn_o.pmn24,g_pmn_o.pmn25,SQLCA.sqlcode,"","update pml21 fail:",1)  #No.FUN-660129
                             ROLLBACK WORK
                             CANCEL DELETE
                          END IF
                      #MOD-BC0168 mark --start--
                      #ELSE
                      #   UPDATE pml_file SET pml21 = l_pmn20   #MOD-950116
                      #      WHERE pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行

                      #    IF SQLCA.sqlcode THEN
                      #       CALL cl_err3("upd","pml_file",g_pmn_o.pmn24,g_pmn_o.pmn25,SQLCA.sqlcode,"","update pml21 fail:",1)  #No.FUN-660129
                      #       ROLLBACK WORK
                      #       CANCEL DELETE
                      #    END IF
                      #END IF
                      #MOD-BC0168 mark --end--
 
                       #No.3401-- 當單身狀況碼皆為1時,update單頭狀況碼010821
                       UPDATE pmk_file SET pmk25='1'
                         WHERE pmk01=g_pmn_o.pmn24 AND pmk01 NOT IN
                         (SELECT pml01 FROM pml_file WHERE pml01=g_pmn_o.pmn24
                                       AND pml16 NOT IN ('1'))
                          AND pmk25 != '6' #MOD-BC0168 add
 
                       LET l_sql = "pml01='",g_pmn_o.pmn24,"' AND pml02=",
                                   g_pmn_o.pmn25
                       CALL s_qtychk('pml_file','pml21',l_sql)
                    END IF   #TQC-730022
                  END IF     #FUN-A10034
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#&ifdef SLK
#         END FOR
#&endif
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
                   END IF    #No.FUN-7C0017
                    #--------- 沖銷 Blanket P/O量 -----------------
                    IF NOT cl_null(g_pmn_o.pmn68) THEN
                       SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file
                        WHERE pmn68 = g_pmn_o.pmn68 AND pmn69 = g_pmn_o.pmn69
                          AND pmn16 <> '9'
                       IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                     #FUN-910088--add--start--
                      SELECT pon07 INTO l_pon07 FROM pon_file
                        WHERE pon01 = g_pmn_o.pmn68 AND pon02 = g_pmn_o.pmn69
                       LET l_pmn20 = s_digqty(l_pmn20,l_pon07)
                     #FUN-910088--add--
 
                       IF l_pmn20 = 0 THEN
                             UPDATE pon_file SET pon21 = l_pmn20 ,pon16 = '1'
                              WHERE pon01 = g_pmn_o.pmn68 AND pon02 = g_pmn_o.pmn69
                       ELSE
                             UPDATE pon_file SET pon21 = l_pmn20
                              WHERE pon01 = g_pmn_o.pmn68 AND pon02 = g_pmn_o.pmn69
                       END IF
 
                       IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","pon_file",g_pmn_o.pmn68,g_pmn_o.pmn69,SQLCA.sqlcode,"","update pon21 fail:",1) #No.FUN-660129
                          ROLLBACK WORK
                          CANCEL DELETE
                       END IF
                       #----- 當單身狀況碼皆為1時,update單頭狀況碼
                          UPDATE pom_file SET pom25='1'
                           WHERE pom01=g_pmn_o.pmn68 AND pom01 NOT IN
                             (SELECT pon01 FROM pon_file WHERE pon01=g_pmn_o.pmn68
                                AND pon16 NOT IN ('1'))
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","pom_file",g_pmn_o.pmn68,"",SQLCA.sqlcode,"","update pon21 fail:",1)  #No.FUN-660129
                             ROLLBACK WORK
                             CANCEL DELETE
                          END IF
                    END IF
                END IF
              IF g_pmm.pmm909='8' AND g_pmn_t.pmn24 THEN
                 UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=g_pmn_t.pmn24
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 UPDATE wpc_file SET wpc09='N' WHERE wpc01=g_pmn_t.pmn24
#MOD-B70246 因檢核ROLLBACK WORK後不可有SQLCA.sqlcode，讓此段的SQLCA.sqlcode與上段的ROLLBACK WORK相距五行


                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF

                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET g_no = g_pmn2.pmn04[1,4]                                                                             
                LET l_diff = (g_pmn[l_ac].pmn20 * g_pmn2.pmn09) * -1
                LET l_pmm25 = '0'          #FUN-550038
            END IF
 
        AFTER DELETE
          CALL  t540_update()
 
        ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,1)  #MOD-640492 0->1
               LET INT_FLAG = 0
               LET g_pmn[l_ac].* = g_pmn_t.*
               CLOSE t540_bcl
               ROLLBACK WORK
               EXIT INPUT    
            END IF
           #FUN-A30030 ADD----------------------------
            IF g_aza.aza88='Y' THEN
               LET g_pmm.pmmpos='N'
               DISPLAY BY NAME g_pmm.pmmpos
               UPDATE pmm_file SET pmmpos=g_pmm.pmmpos
                WHERE pmm01 =g_pmm.pmm01
            END IF
           #FUN-A30030 END--------------------------------------
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_pmn[l_ac].pmn02,-263,1)
                LET g_pmn[l_ac].* = g_pmn_t.*
            ELSE
               #將t540_set_origin_field()搬到判斷式IF smd115='Y'外面
               #這樣當不使用多單位時才會計算pmn88與pmn88t的金額
               CALL t540_set_origin_field()  #No.MOD-610037 add
 
 
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                     SELECT ima44,ima31 INTO g_ima44,g_ima31
                       FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
                  END IF
 
                  CALL s_chk_va_setting(g_pmn[l_ac].pmn04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD pmn04
                  END IF
                  CALL s_chk_va_setting1(g_pmn[l_ac].pmn04)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD pmn02   #MOD-590536
                  END IF
 
                  CALL t540_du_data_to_correct()
 
                  CALL t540_set_origin_field()
#                 IF g_pmm.pmm909 != '3' THEN      #No.MOD-920290 add    #MOD-B60102 mark
                  IF g_pmm.pmm909 MATCHES '[128]' THEN                   #MOD-B60102
                     #計算pmn20,pmn07的值,檢查數量的合理性
                     CALL t540_check_inventory_qty(p_cmd)
                         RETURNING g_flag
                     IF g_flag = '1' THEN
                        IF g_ima906 = '3' OR g_ima906 = '2' THEN  #No.FUN-560020
                           NEXT FIELD pmn85
                        ELSE
                           NEXT FIELD pmn82
                        END IF
                     END IF
                  END IF    #No.MOD-920290 add
               END IF
                 #CHI-AA0025 add --start--
                 #檢核採購數量是否超過訂單數量
                 IF g_pmm.pmm909 = '3' AND
                    NOT cl_null(g_pmn[l_ac].pmn24) AND  
                    NOT cl_null(g_pmn[l_ac].pmn25) THEN
                    LET l_qty = 0 
                    SELECT oeb12 * oeb05_fac INTO l_qty FROM oeb_file
                     WHERE oeb01 = g_pmn[l_ac].pmn24
                       AND oeb03 = g_pmn[l_ac].pmn25
#MOD-C30366 ------------ add -------------  begin #如果為替代情況則，換算后進行控管
                    IF g_pmn[l_ac].pmn42 = 'S' THEN
                       LET l_sub_qty = g_pmn[l_ac].pmn20/g_pmn2.pmn62*g_pmn2.pmn09
                    ELSE
                       LET l_sub_qty = g_pmn[l_ac].pmn20 * g_pmn2.pmn09
                    END IF
                    IF l_sub_qty > l_qty THEN
#MOD-C30366 ------------ add -------------  end
#                   IF g_pmn[l_ac].pmn20 * g_pmn2.pmn09 > l_qty THEN   #MOD-C30366 mark
                       CALL cl_err(g_pmn[l_ac].pmn20,'apm1022',1)
                       IF g_sma.sma115 = 'Y' THEN
                          IF g_ima906 MATCHES '[23]' THEN
                             NEXT FIELD pmn85
                          ELSE
                             NEXT FIELD pmn82
                          END IF
                       ELSE
                          NEXT FIELD pmn20
                       END IF
                    END IF
                 END IF 
                 #CHI-AA0025 add --end--
                 CALL t540_b_move_back_2()  #TQC-950054 
                 LET g_pmn2.pmn52 = g_pmn[l_ac].pmn52   #CHI-9C0025
                 LET g_pmn2.pmn54 = g_pmn[l_ac].pmn54   #CHI-9C0025
                 LET g_pmn2.pmn56 = g_pmn[l_ac].pmn56   #CHI-9C0025
                 LET g_pmn2.pmn31 = g_pmn[l_ac].pmn31   #MOD-870268
                 LET g_pmn2.pmn31t = g_pmn[l_ac].pmn31t   #MOD-870268
                #LET g_pmn2.pmn36 = g_pmn[l_ac].pmn33 #MOD-530719  #MOD-D20145 mark  
                #LET g_pmn2.pmn37 = g_pmn[l_ac].pmn34 #MOD-530719  #MOD-D20145 mark  
                 LET g_pmn2.pmn36 = NULL #MOD-D20145 add
                 LET g_pmn2.pmn37 = NULL #MOD-D20145 add
                 LET g_pmn2.pmn87 = g_pmn[l_ac].pmn87 #MOD-6A0142
                 LET g_pmn2.pmn86 = g_pmn[l_ac].pmn86 #No.TQC-710080 add
                 LET g_pmn2.pmn84 = g_pmn[l_ac].pmn84 #MOD-750130 add
                 LET g_pmn2.pmn81 = g_pmn[l_ac].pmn81 #MOD-750130 add
                  LET g_pmn2.pmn122  = g_pmn[l_ac].pmn122
                  LET g_pmn2.pmn96   = g_pmn[l_ac].pmn96
                  LET g_pmn2.pmn97   = g_pmn[l_ac].pmn97
                  LET g_pmn2.pmn67   = g_pmn[l_ac].pmn67
                  LET g_pmn2.pmn98   = g_pmn[l_ac].pmn98
                  LET g_pmn2.pmn40   = g_pmn[l_ac].pmn40
                  LET g_pmn2.pmn401  = g_pmn[l_ac].pmn401
                  LET g_pmn2.pmn100  = g_pmn[l_ac].pmn100  #FUN-D40042 add
                  LET g_pmn2.pmnud01  = g_pmn[l_ac].pmnud01
                  LET g_pmn2.pmnud02  = g_pmn[l_ac].pmnud02
                  LET g_pmn2.pmnud03  = g_pmn[l_ac].pmnud03
                  LET g_pmn2.pmnud04  = g_pmn[l_ac].pmnud04
                  LET g_pmn2.pmnud05  = g_pmn[l_ac].pmnud05
                  LET g_pmn2.pmnud06  = g_pmn[l_ac].pmnud06
                  LET g_pmn2.pmnud07  = g_pmn[l_ac].pmnud07
                  LET g_pmn2.pmnud08  = g_pmn[l_ac].pmnud08
                  LET g_pmn2.pmnud09  = g_pmn[l_ac].pmnud09
                  LET g_pmn2.pmnud10  = g_pmn[l_ac].pmnud10
                  LET g_pmn2.pmnud11  = g_pmn[l_ac].pmnud11
                  LET g_pmn2.pmnud12  = g_pmn[l_ac].pmnud12
                  LET g_pmn2.pmnud13  = g_pmn[l_ac].pmnud13
                  LET g_pmn2.pmnud14  = g_pmn[l_ac].pmnud14
                  LET g_pmn2.pmnud15  = g_pmn[l_ac].pmnud15
 
                 LET g_pmni2.pmnislk01 = g_pmn[l_ac].pmnislk01   #No.FUN-810016
                  IF g_gec07='Y' THEN
                     #-----CHI-AC0016---------
                     #LET g_pmn2.pmn88 = g_pmn2.pmn88t / ( 1 + g_pmm.pmm43/100)
                     #LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
                     #IF g_gec05 = 'T' THEN 
                     IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                        #TQC-C30225 add begin
                        LET g_pmn2.pmn31 = g_pmn2.pmn31t * ( 1 - g_pmm.pmm43/100)
                        LET g_pmn2.pmn31 = cl_digcut( g_pmn2.pmn31 , t_azi03)                        
                        #TQC-C30225 add end
                        LET g_pmn2.pmn88 = g_pmn2.pmn88t * ( 1 - g_pmm.pmm43/100)
                        LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
                     ELSE
                        LET g_pmn2.pmn88 = g_pmn2.pmn88t / ( 1 + g_pmm.pmm43/100)
                        LET g_pmn2.pmn88 = cl_digcut( g_pmn2.pmn88 , t_azi04)  
                     END IF
                     #-----END CHI-AC0016-----
                  ELSE
                     LET g_pmn2.pmn88t = g_pmn2.pmn88 * ( 1 + g_pmm.pmm43/100)
                     LET g_pmn2.pmn88t = cl_digcut( g_pmn2.pmn88t , t_azi04)  
                  END IF
                  IF cl_null(g_pmn2.pmn52) THEN LET g_pmn2.pmn52 = ' ' END IF  #CHI-9C0025
                  IF cl_null(g_pmn2.pmn54) THEN LET g_pmn2.pmn54 = ' ' END IF  #CHI-9C0025
                  IF cl_null(g_pmn2.pmn56) THEN LET g_pmn2.pmn56 = ' ' END IF  #CHI-9C0025
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
##FUN-A50054 --Begin
#                  DELETE FROM pmn_file WHERE pmn01=g_pmm.pmm01
#                     AND pmn02 NOT IN
#                  (SELECT ata03 FROM ata_file
#                    WHERE ata00=g_prog
#                      AND ata01=g_pmm.pmm01)
#                  DELETE FROM pmn_file WHERE pmn01=g_pmm.pmm01 
#                     AND pmn02 IN
#                  ( SELECT ata03 FROM ata_file 
#                    WHERE ata00=g_prog
#                      AND ata01=g_pmm.pmm01
#                      AND ata02=g_pmn[l_ac].pmn02)
#                  DELETE FROM pmni_file WHERE pmni01=g_pmm.pmm01 
#                     AND pmni02 IN
#                  ( SELECT ata03 FROM ata_file 
#                    WHERE ata00=g_prog
#                      AND ata01=g_pmm.pmm01
#                      AND ata02=g_pmn[l_ac].pmn02)
#                  LET l_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#                              "  WHERE ata00 = '",g_prog,"'",
#                              "    AND ata01 = '",g_pmm.pmm01,"'",
#                              "    AND ata02 = '",g_pmn_t.pmn02,"'"
#                  DECLARE t540_ata_curs1 SCROLL CURSOR FROM l_sql
#                  FOREACH t540_ata_curs1 INTO l_ata03_t,l_ata04_t,l_ata08
#                     LET g_pmn2.pmn02 = l_ata03_t
#                     LET g_pmn2.pmn04 = l_ata04_t
#                     LET g_pmn2.pmn20 = l_ata08
#                       #UPDATE pmn_file SET * = g_pmn2.*
#                       # WHERE pmn01=g_pmm.pmm01 AND pmn02=l_ata03_t
#                       #IF SQLCA.sqlcode THEN
#                       #   CALL cl_err3("upd","pmn_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","upd pmn",1)  #No.FUN-650108
#                       #   LET g_pmn[l_ac].* = g_pmn_t.*
#                       #ELSE
#                       #   LET g_pmni2.pmni02 = l_ata03_t
#                       #   LET g_pmni2.pmnislk01 = g_pmn[l_ac].pmnislk01
#                       #   UPDATE pmni_file SET pmni_file.*=g_pmni2.*
#                       #    WHERE pmni01=g_pmm.pmm01
#                       #      AND pmni02=l_ata03_t
#                       #   IF SQLCA.sqlcode THEN
#                       #      CALL cl_err3("upd","pmni_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","upd pmni",1)  
#                       #   END IF
#                       #END IF
#                       
#                        IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF  #No.TQC-A60113
#                        INSERT INTO pmn_file VALUES(g_pmn2.*)
#                        IF SQLCA.sqlcode THEN
#                           CALL cl_err3("ins","pmn_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","upd pmn",1)  #No.FUN-650108
#                           RETURN FALSE
#                        ELSE
#                           LET g_pmni2.pmni01 = g_pmn2.pmn01
#                           LET g_pmni2.pmni02 = g_pmn2.pmn02
#                           IF NOT s_ins_pmni(g_pmni2.*,g_pmm.pmmplant) THEN #FUN-A50054
#                              RETURN FALSE
#                           END IF
#                        END IF
#                      #E#D IF
#                       #UPDATE ata_file SET ata02 = g_pmn[l_ac].pmn02,
#                       #              WHERE ata00 = g_prog
#                       #                AND ata01 = g_pmm.pmm01
#                       #                AND ata03 = l_ata03_t
#                       #IF SQLCA.sqlcode THEN
#                       #   CALL cl_err3("upd","ata_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","upd ata",1)  #No.FUN-650108
#                       #   LET g_pmn[l_ac].* = g_pmn_t.*
#                       #   RETURN FALSE
#                       #END IF
#                  END FOREACH
#&else
##FUN-A50054 --End                
#FUN-A60035 ---MARK END
                IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF #TQC-A60113
                UPDATE pmn_file SET pmn_file.* = g_pmn2.*   # 更新DB
                    WHERE pmn01=g_pmm.pmm01
                      AND pmn02=g_pmn_t.pmn02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","pmn_file",g_pmm.pmm01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_pmn[l_ac].* = g_pmn_t.*
                   LET g_success = 'N'
                END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin add
#&endif
##FUN-A50054---end        
#FUN-A60035 ---MARK end        
#     IF g_pmm.pmm909 <> '3'            #MOD-B60102 mark
      IF g_pmm.pmm909 MATCHES '[128]'   #MOD-B60102
          THEN
               #MOD-C30823 add start
               IF cl_null(g_pmn_t.pmn24) THEN
                  LET l_pmn24_t = ' '
               ELSE
                  LET l_pmn24_t = g_pmn_t.pmn24
               END IF
               IF cl_null(g_pmn[l_ac].pmn24) THEN
                  LET l_pmn24_g = ' '
               ELSE
                  LET l_pmn24_g = g_pmn[l_ac].pmn24
               END IF
               #MOD-C30823 add end
               IF g_sma.sma31 = 'Y' THEN               #MOD-B40122 
                   #IF g_pmn[l_ac].pmn24!=g_pmn_t.pmn24    #請購單 #MOD-C30823 mark
                   IF l_pmn24_g!=l_pmn24_t                         #MOD-C30823 add
                      OR g_pmn[l_ac].pmn25!=g_pmn_t.pmn25 OR g_pmn[l_ac].pmn20 !=g_pmn_t.pmn20 THEN   ##修改 #No.MOD-B30191
#TQC-B40178 --begin--                     
                    LET l_count = 0 
                    SELECT COUNT(*) INTO l_count FROM pml_file
                     WHERE pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                    IF l_count > 0 THEN  
#TQC-B40178 --end--
                     SELECT SUM(pmn20/pmn62*pmn121) INTO l_pmn20 FROM pmn_file
                      WHERE pmn24 = g_pmn_o.pmn24 AND pmn25 = g_pmn_o.pmn25
                        AND pmn16<>'9'       #取消(Cancel)
                     IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                 #FUN-910088--add--start--
                     SELECT pml07 INTO l_pml07 FROM pml_file
                       WHERE  pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                     LET l_pmn20 = s_digqty(l_pmn20,l_pml07)
                 #FUN-910088--add--end--
                     #IF g_pmm.pmm909 = '8' THEN    #FUN-9A0034  #TQC-A80070 mark
                     IF g_pmm.pmm909 <> '8' THEN    #TQC-A80070 add 
                       #UPDATE pml_file SET pml21 = l_pmn20,pml16='2'   #MOD-B90089 mark
                        UPDATE pml_file SET pml21 = l_pmn20,pml16='1'   #MOD-B90089 add
                         WHERE pml01 = g_pmn_o.pmn24 AND pml02 = g_pmn_o.pmn25
                        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                           CALL cl_err3("upd","pml_file",g_pmn_o.pmn24,g_pmn_o.pmn25,SQLCA.sqlcode,"","pmn24 update pml21_2",1)  #No.FUN-660129
                           LET g_success = 'N'
                        ELSE
                           UPDATE pmk_file SET pmk25 = '2'
                            WHERE pmk01 = g_pmn_o.pmn24 AND
                                  pmk01 NOT IN (SELECT pml01 FROM pml_file
                                                 WHERE pml01=g_pmn_o.pmn24
                                                   AND pml16 IN ('0','1'))
                           IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","pmk_file",g_pmn_o.pmn24,"",SQLCA.sqlcode,"","pmn24 update pmk25_2",1)  #No.FUN-660129
                              LET g_success = 'N'
                           END IF
                        END IF
                     END IF             #FUN-A10034
                    END IF        #TQC-B40178 
                    
                     IF NOT cl_null(g_pmn[l_ac].pmn24) THEN           ##新增
                        SELECT SUM(pmn20/pmn62*pmn121) INTO l_pmn20 FROM pmn_file
                         WHERE pmn24 = g_pmn[l_ac].pmn24 AND pmn25 = g_pmn[l_ac].pmn25
                           AND pmn16<>'9'       #取消(Cancel)
                       IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                  #FUN-910088--add--start--
                       SELECT pml07 INTO l_pml07 FROM pml_file
                        WHERE pml01 = g_pmn[l_ac].pmn24 AND pml02 = g_pmn[l_ac].pmn25
                       LET l_pmn20 = s_digqty(l_pmn20,l_pml07)
                  #FUN-910088--add--end--
                       UPDATE pml_file SET pml21 = l_pmn20,pml16='2'
                        WHERE pml01 = g_pmn[l_ac].pmn24 AND pml02 = g_pmn[l_ac].pmn25
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("upd","pml_file",g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25,SQLCA.sqlcode,"","pmn24 update pml21",1)  #No.FUN-660129
                          LET g_success = 'N'
                       ELSE
                          UPDATE pmk_file SET pmk25 = '2'
                           WHERE pmk01 = g_pmn[l_ac].pmn24
                          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                             CALL cl_err3("upd","pmk_file",g_pmn[l_ac].pmn24,"",SQLCA.sqlcode,"","pmn24 update pmk25",1)  #No.FUN-660129
                             LET g_success = 'N'
                          END IF
                       END IF
                    END IF               #FUN-A10034
                 END IF    #TQC-730022
               END IF                 #MOD-B40122 
                END IF  #FUN-810038
                   #------------  沖銷 Blanket P/O  -----------------------
                   IF NOT cl_null(g_pmn_t.pmn68) THEN
                      IF g_pmn[l_ac].pmn68 IS NULL OR g_pmn[l_ac].pmn68 != g_pmn_t.pmn68
                         OR g_pmn[l_ac].pmn69 IS NULL OR g_pmn[l_ac].pmn69!=g_pmn_t.pmn69
                      THEN  ##修改
                         SELECT SUM(pmn20/pmn62*pmn70) INTO l_pon20 FROM pmn_file
                          WHERE pmn68 = g_pmn_t.pmn68 AND pmn69 = g_pmn_t.pmn69
                            AND pmn16<>'9'       #取消(Cancel)
                         IF STATUS OR l_pon20 IS NULL THEN LET l_pon20 = 0 END IF
                     #FUN-910088--add--start--
                         SELECT pon07 INTO l_pon07 FROM pon_file 
                          WHERE pon01 = g_pmn_o.pmn68 AND pon02 = g_pmn_o.pmn69
                         LET l_pon20 = s_digqty(l_pon20,l_pon07)
                     #FUN-910088--add--end--
                         IF l_pon20 = 0 THEN
                               UPDATE pon_file SET pon21 = l_pon20 ,pon16 = '1'
                                WHERE pon01 = g_pmn_o.pmn68 AND pon02 = g_pmn_o.pmn69
                         ELSE
                               UPDATE pon_file SET pon21 = l_pon20,pon16 = '2'
                                WHERE pon01 = g_pmn_t.pmn68 AND pon02 = g_pmn_t.pmn69
                         END IF
                         IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","pon_file",g_pmn_t.pmn68,g_pmn_t.pmn69,SQLCA.sqlcode,"","update pon21 fail:",1) #No.FUN-660129
                            LET g_success = 'N'
                         ELSE
                               #----- 當單身狀況碼皆為1時,update單頭狀況碼
                               UPDATE pom_file SET pom25='1'
                                WHERE pom01=g_pmn_o.pmn68 AND pom01 NOT IN
                                  (SELECT pon01 FROM pon_file WHERE pon01=g_pmn_o.pmn68
                                     AND pon16 NOT IN ('1'))
                         END IF
                      END IF
                   END IF
                   #------------  沖銷 Blanket P/O  -----------------------
                   IF NOT cl_null(g_pmn[l_ac].pmn68)  THEN      ##新增
                      SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file
                        WHERE pmn68 = g_pmn[l_ac].pmn68 AND pmn69 = g_pmn[l_ac].pmn69
                          AND pmn16<>'9'       #取消(Cancel)
                      IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                    #FUN-910088--add--start--
                      SELECT pon07 INTO l_pon07 FROM pon_file
                       WHERE pon01 = g_pmn[l_ac].pmn68 AND pon02 = g_pmn[l_ac].pmn69 
                      LET l_pmn20 = s_digqty(l_pmn20,l_pon07) 
                    #FUN-910088--add--end--
                         UPDATE pon_file SET pon21 = l_pmn20,pon16='2'
                          WHERE pon01 = g_pmn[l_ac].pmn68 AND pon02 = g_pmn[l_ac].pmn69
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            CALL cl_err3("upd","pon_file",g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,SQLCA.sqlcode,"","pmn68 update pon21",1)  #No.FUN-660129
                         LET g_success = 'N'
                      ELSE
                            UPDATE pom_file SET pom25 = '2'
                             WHERE pom01 = g_pmn[l_ac].pmn68
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            CALL cl_err3("upd","pom_file",g_pmn[l_ac].pmn68,"",SQLCA.sqlcode,"","pmn68 update pom25",1)  #No.FUN-660129
                            LET g_success = 'N'
                         END IF
                      END IF
                   END IF
                   IF g_success = "Y" THEN
                      MESSAGE 'UPDATE O.K'
                      LET l_pmm25 = '0'          #FUN-550038
                      IF g_pmm.pmm909 = '3' THEN #MOD-B40022 add
                         CALL t540_upd_oeb28('b',g_pmn_t.pmn02,g_pmm.pmm01)   #CHI-AA0025 add
                      END IF #MOD-B40022 add
                      #將舊值和轉換因子的值與新值和轉換因子的值相減
                      CALL t540_update()
                      COMMIT WORK
                      CALL t540_b_fill(' 1=1',' 1=1')  #No.MOD-8A0048  #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
                   ELSE
                      ROLLBACK WORK
                   END IF
                END IF
 
        AFTER ROW
            DISPLAY "AFTER ROW=",g_pmn.getLength()," l_ac=",l_ac
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac      #TQC-D40025
            IF INT_FLAG THEN
               CALL cl_err('',9001,1) #MOD-640492 0->1
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmn[l_ac].* = g_pmn_t.*
               ELSE
           #        INITIALIZE g_pmn[l_ac].* TO NULL #MOD-4A0134   #TQC-D40025
           #TQC-D40025--add--str--
                  CALL g_pmn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
           #TQC-D40025--add--end--
               END IF
display 'leave =',g_pmn.getLength()," l_ac=",l_ac
               CLOSE t540_bcl
               ROLLBACK WORK
               EXIT INPUT              #mark by FUN-B90103 
          END IF                   
          LET l_ac_t = l_ac      #TQC-D40025
            CLOSE t540_bcl
            COMMIT WORK
 
        ON ACTION item_master
            IF g_sma.sma38 MATCHES'[Yy]' THEN
               IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                  LET g_cmd = "aimi100 '", g_pmn[l_ac].pmn04 CLIPPED,"'"
               ELSE
                  LET g_cmd = "aimi100 "
               END IF
               CALL cl_cmdrun(g_cmd)
            ELSE
               CALL cl_err(g_sma.sma38,'mfg0035',1)
            END IF
        ON ACTION unit_data
            LET g_cmd = 'aooi101 '
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION unit_conversion #料件廠商資料
            LET g_cmd = 'aooi102 '
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION item_unit_conversion
            LET g_cmd = 'aooi103 '
            CALL cl_cmdrun(g_cmd)
 
       ON ACTION q_pmh #料件廠商資料
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_pmh4"   #MOD-910096 q_pmh-->q_pmh4
           LET g_qryparam.default1 = g_pmm.pmm09
           LET g_qryparam.arg1 = g_pmm.pmm09  #No.MOD-620073 add
           IF g_argv3 = 'SUB' THEN 
              LET g_qryparam.arg2 = '2'
           ELSE
              LET g_qryparam.arg2 = '1'
           END IF   
           CALL cl_create_qry() RETURNING l_pmm09
 
       ON ACTION m_item_supplier #料件供應商
           IF g_argv3 = 'SUB' THEN 
              CALL cl_cmdrun('apmi264')
           ELSE
              CALL cl_cmdrun('apmi254')
           END IF   
       ON ACTION purchase_unit
            CALL t562()
       ON ACTION purchase_price #單價
            CALL t563()
       ON ACTION delivery_date #原始交貨日
            CALL t564(p_cmd)     #No.MOD-620088 modify
 
       ON ACTION b_more2 #輸入海關手冊編
           #FUN-A60055 add str ---------------
            IF g_pmm.pmm25 matches '[Ss]' THEN
               CALL cl_err('','apm-030',1)
            ELSE
           #FUN-A60055 add end ---------------
               IF g_aza.aza27 = 'Y' AND g_smy.smy57[5,5] = 'Y' THEN
                  CALL t540_b_more2(p_cmd)
               END IF
            END IF                       #FUN-A60055 add
 
       ON ACTION description
            LET g_cmd = "apmt402 1 '",g_pmm.pmm01,"' ",g_pmn[l_ac].pmn02
            CALL cl_cmdrun_wait(g_cmd) #FUN-660216 add
 
       ON ACTION b_more
             CALL t540_b_more(p_cmd) #MOD-4B0104
 
        ON ACTION CONTROLP
            CASE
              #新增的母料件開窗
              #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
              #BEFORE FIELD att00來做開窗了
              #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
               WHEN INFIELD(att00)
                    #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------                    
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ima_p"
#                    LET g_qryparam.arg1 = lg_group
#                    CALL cl_create_qry() RETURNING g_pmn[l_ac].att00
                     CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                       RETURNING  g_pmn[l_ac].att00
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_pmn[l_ac].att00
                    LET g_pmn[l_ac].pmn04 =g_pmn[l_ac].att00                    
                    LET g_pmn[l_ac].att01 =null                                 
                    LET g_pmn[l_ac].att01_c =null                               
                    LET g_pmn[l_ac].att02 =null                                 
                    LET g_pmn[l_ac].att02_c =null                               
                    LET g_pmn[l_ac].att03 =null                                 
                    LET g_pmn[l_ac].att03_c =null                               
                    LET g_pmn[l_ac].att04 =null                                 
                    LET g_pmn[l_ac].att04_c =null                               
                    LET g_pmn[l_ac].att05 =null                                 
                    LET g_pmn[l_ac].att05_c =null                               
                    LET g_pmn[l_ac].att06 =null                                 
                    LET g_pmn[l_ac].att06_c =null                               
                    LET g_pmn[l_ac].att07 =null                                 
                    LET g_pmn[l_ac].att07_c =null                               
                    LET g_pmn[l_ac].att08 =null                                 
                    LET g_pmn[l_ac].att08_c =null                               
                    LET g_pmn[l_ac].att09 =null                                 
                    LET g_pmn[l_ac].att09_c =null                               
                    LET g_pmn[l_ac].att10 =null                                 
                    LET g_pmn[l_ac].att10_c =null                               
                    NEXT FIELD att00
               WHEN INFIELD(pmn24) #請購單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pml3"
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25
                    DISPLAY g_pmn[l_ac].pmn24 TO pmn24
                    DISPLAY g_pmn[l_ac].pmn25 TO pmn25
                    NEXT FIELD pmn24
               WHEN INFIELD(pmn04) #料件編號
               # No.FUN-A80121 ...begin
               IF p_cmd = 'a' AND g_pmm.pmm909='1' AND cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN  
                  #TQC-C10071 add begin---------------------------
                  IF g_prog = 'apmt590' AND NOT cl_null(g_pmn[l_ac].pmn41) THEN
                     CALL t540_get_pmn04() RETURNING l_wc
                     CALL q_sel_ima(FALSE, "q_ima",l_wc,g_pmn[l_ac].pmn04,"","","","","",'' )
                       RETURNING  g_pmn[l_ac].pmn04
                  ELSE
                  #TQC-C10071 add  end----------------------------
                     CALL q_ima(1,1,g_plant) RETURNING g_multi_ima01  
                     IF NOT cl_null(g_multi_ima01)  THEN
                        CALL t540_multi_ima01()
                        CALL t540_b_fill(' 1=1',' 1=1')    #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
                        LET g_flag = TRUE
                        EXIT INPUT     #mark by FUN-B90103
                     END IF 
                  END IF  #TQC-C10071 add
               ELSE 
              # No.FUN-A80121  ..end
#FUN-AA0059---------mod------------str-----------------                  
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#&endif 
#TQC-C30109---end
#                    LET g_qryparam.default1 = g_pmn[l_ac].pmn04
#                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn04
                     CALL q_sel_ima(FALSE, "q_ima","",g_pmn[l_ac].pmn04,"","","","","",'' ) 
                     RETURNING  g_pmn[l_ac].pmn04
#TQC-C30109---begin
#TQC-C30109---end

#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_pmn[l_ac].pmn04 TO pmn04 

                    NEXT FIELD pmn04
                END IF      # No.FUN-A80121   
               WHEN INFIELD(pmn07) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_pmn[l_ac].pmn07
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn07
                    DISPLAY g_pmn[l_ac].pmn07 TO pmn07
                    NEXT FIELD pmn07
               WHEN INFIELD(pmn80) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pmn[l_ac].pmn80
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn80
                    DISPLAY BY NAME g_pmn[l_ac].pmn80
                    NEXT FIELD pmn80
 
               WHEN INFIELD(pmn83) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pmn[l_ac].pmn83
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn83
                    DISPLAY BY NAME g_pmn[l_ac].pmn83
                    NEXT FIELD pmn83
 
               WHEN INFIELD(pmn86) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pmn[l_ac].pmn86
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn86
                    DISPLAY BY NAME g_pmn[l_ac].pmn86
                    NEXT FIELD pmn86
               WHEN INFIELD(pmn41) #工單編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb7"
                    LET g_qryparam.where= " sfb04 IN ('1','2','3','4','5') "
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn41
                    DISPLAY g_pmn[l_ac].pmn41 TO pmn41
                    NEXT FIELD pmn41
               WHEN INFIELD(pmn52) #查詢 img資料檔
                    #FUN-C30300---begin
                    LET g_ima906 = NULL
                    SELECT ima906 INTO g_ima906 FROM ima_file
                     WHERE ima01 = g_pmn[l_ac].pmn04
                    #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                    IF s_industry("icd") THEN  #TQC-C60028
                       CALL q_idc(FALSE,TRUE,g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54,g_pmn[l_ac].pmn56)
                       RETURNING g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54,g_pmn[l_ac].pmn56
                    ELSE
                    #FUN-C30300---end
                       CALL q_img4(FALSE,TRUE,g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54, 
                                   g_pmn[l_ac].pmn56,'A')
                       RETURNING g_pmn[l_ac].pmn52,g_pmn[l_ac].pmn54,g_pmn[l_ac].pmn56
                    END IF  #No.FUN-870007
                    DISPLAY BY NAME g_pmn[l_ac].pmn52
                    DISPLAY BY NAME g_pmn[l_ac].pmn54
                    DISPLAY BY NAME g_pmn[l_ac].pmn56
 
               WHEN INFIELD(pmn68) #Blanket P/O
                       #CALL q_pom2(FALSE,TRUE,g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69            #MOD-C30797 mark
                       CALL q_pom2(FALSE,TRUE,g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69 #MOD-C30797 add
                    DISPLAY g_pmn[l_ac].pmn68 TO pmn68          #No.MOD-490371
                    DISPLAY g_pmn[l_ac].pmn69 TO pmn69          #No.MOD-490371
                    NEXT FIELD pmn68
 
               WHEN INFIELD(pmn69) #Blanket P/O
                       #CALL q_pom2(FALSE,TRUE,g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmm.pmm09,g_pmm.pmm22) RETURNING g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69            #MOD-C30797 mark
                       CALL q_pom2(FALSE,TRUE,g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm21) RETURNING g_pmn[l_ac].pmn68,g_pmn[l_ac].pmn69 #MOD-C30797 add
                    DISPLAY g_pmn[l_ac].pmn68 TO pmn68          #No.MOD-490371
                    DISPLAY g_pmn[l_ac].pmn69 TO pmn69          #No.MOD-490371
                    NEXT FIELD pmn69
 
               WHEN INFIELD(pmn122) #專案代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn122
                  DISPLAY BY NAME g_pmn[l_ac].pmn122
                  NEXT FIELD pmn122
               WHEN INFIELD(pmn96)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_pmn[l_ac].pmn122
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn96
                  DISPLAY BY NAME g_pmn[l_ac].pmn96
                  NEXT FIELD pmn96
               WHEN INFIELD(pmn97)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.arg1 = g_pmn[l_ac].pmn96
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn97
                  DISPLAY BY NAME g_pmn[l_ac].pmn97
                  NEXT FIELD pmn97
               WHEN INFIELD(pmn67)  #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn67
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn67
                  DISPLAY BY NAME g_pmn[l_ac].pmn67
                  NEXT FIELD pmn67
               WHEN INFIELD(pmn98)  #費用原因
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"                  #No.FUN-930145
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn98
                  LET g_qryparam.arg1 = '7'                        #No.FUN-930145  
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn98
                  DISPLAY BY NAME g_pmn[l_ac].pmn98
                  NEXT FIELD pmn98
               WHEN INFIELD(pmn40)  #科目一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn40
                  LET g_qryparam.arg1 = g_bookno1
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' "
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn40
                  DISPLAY BY NAME g_pmn[l_ac].pmn40
                  NEXT FIELD pmn40
               WHEN INFIELD(pmn401) #科目二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn401
                  LET g_qryparam.arg1 = g_bookno2
                  LET g_qryparam.where = " aag03 IN ('2','4') "
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn401
                  DISPLAY BY NAME g_pmn[l_ac].pmn401
                  NEXT FIELD pmn401
               #No.FUN-A60011  --Begin
               WHEN INFIELD(pmn012) #工艺段号
                  CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_ecm012"    #FUN-B10056 mark
                  LET g_qryparam.form = "q_ecb012_1"  #FUN-B10056
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn012
                  LET g_qryparam.arg1 = g_pmn[l_ac].pmn41
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn012
                  DISPLAY BY NAME g_pmn[l_ac].pmn012
                  NEXT FIELD pmn012
               #No.FUN-A60011  --End  
 
               WHEN INFIELD(pmn930)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem4"
                    CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn930
                    DISPLAY BY NAME g_pmn[l_ac].pmn930
                    NEXT FIELD pmn930
               WHEN INFIELD(pmn123) 
                  LET l_ima926 = 'N'                #FUN-D30087 add
                  SELECT ima926 INTO l_ima926 FROM ima_file  #FUN-D30087 add
                   WHERE ima01 = g_pmn[l_ac].pmn04           #FUN-D30087 add
                  CALL cl_init_qry_var()
                  IF l_ima926 = 'Y' THEN            #FUN-D30087 add
                     LET g_qryparam.form = "q_bmj3" #FUN-D30087 add
                  ELSE                              #FUN-D30087 add
                     LET g_qryparam.form = "q_mse"
                  END IF                            #FUN-D30087 add
                  LET g_qryparam.arg1 = g_pmn[l_ac].pmn04    #FUN-D30087 add
                  LET g_qryparam.default1 = g_pmn[l_ac].pmn123
                  CALL cl_create_qry() RETURNING g_pmn[l_ac].pmn123
                  DISPLAY BY NAME g_pmn[l_ac].pmn123
                  NEXT FIELD pmn123  
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmn02) AND l_ac > 1 THEN
                LET g_pmn[l_ac].* = g_pmn[l_ac-1].*
                SELECT max(pmn02)+1                 #MOD-C30366 add
                  INTO g_pmn[l_ac].pmn02            #MOD-C30366 add
                  FROM pmn_file                     #MOD-C30366 add
                 WHERE pmn01 = g_pmm.pmm01          #MOD-C30366 add
                NEXT FIELD pmn02
            END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT    
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
        END INPUT
END IF   #FUN-C20006
       LET g_pmm.pmmmodu=g_user  #TQC-B30020
       LET g_pmm.pmmdate=g_today #TQC-B30020
       
       UPDATE pmm_file SET pmmmodu=g_user,pmmdate=g_today,pmm25=l_pmm25
          WHERE pmm01=g_pmm.pmm01
       LET g_pmm.pmm25 = l_pmm25
       DISPLAY BY NAME g_pmm.pmm25
       DISPLAY BY NAME g_pmm.pmmmodu   #TQC-B30020
       DISPLAY BY NAME g_pmm.pmmdate   #TQC-B30020
       CALL t540_pic() #FUN-730012
       CALL t540_b_fill(' 1=1',' 1=1') #TQC-C20411 add 
   # No.FUN-A80121  ..begin
    IF g_flag THEN
       LET g_flag = FALSE
       CALL t540_b()
    END IF
    # No.FUN-A80121  ..end
    CLOSE t540_bcl
#FUN-B90103------------begin
#FUN-B90103------------end
    IF g_success = 'N' THEN
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    CALL t540_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t540_delHeader()
DEFINE l_n LIKE type_file.num5
DEFINE l_action_choice    STRING               #CHI-C80041
DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
DEFINE l_num              LIKE type_file.num5  #CHI-C80041
DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
DEFINE l_sql              STRING               #CHI-C80041
DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041

   SELECT COUNT(*) INTO l_n FROM pmn_file WHERE pmn01 = g_pmm.pmm01
   IF l_n = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_pmm.pmm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM pmm_file ",
                  "  WHERE pmm01 LIKE '",l_slip,"%' ",
                  "    AND pmm01 > '",g_pmm.pmm01,"'"
      PREPARE t540_pb1 FROM l_sql 
      EXECUTE t540_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t540sub_x(g_pmm.pmm01,g_action_choice,TRUE)   #FUN-D20025 mark
         CALL t540sub_x(g_pmm.pmm01,g_action_choice,TRUE,1)  #FUN-D20025 add
         CALL t540_update() 
         CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* 
         CALL t540_show()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM pmz_file WHERE pmz01 = g_pmm.pmm01
         DELETE FROM pmo_file WHERE pmo01 = g_pmm.pmm01
         DELETE FROM pmp_file WHERE pmp01 = g_pmm.pmm01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pmm_file WHERE pmm01 = g_pmm.pmm01
         INITIALIZE g_pmm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t540_g_b()       #工單自動產生單身
   DEFINE  l_flag     LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE  l_ima49    LIKE ima_file.ima49
   DEFINE  l_ima491   LIKE ima_file.ima491
   DEFINE  l_ima021   LIKE ima_file.ima021
   DEFINE  l_ima55    LIKE ima_file.ima55
   DEFINE  l_sfa12    LIKE sfa_file.sfa12
   DEFINE  l_sfa05    LIKE sfa_file.sfa05
   DEFINE  l_sfb02    LIKE sfb_file.sfb02
   DEFINE  l_fac      LIKE ima_file.ima31_fac  #No.FUN-680136 DEC(16,8)
   DEFINE  l_date     LIKE type_file.dat     #No.FUN-680136 DATE
   DEFINE  l_ecm04    LIKE ecm_file.ecm04 #NO:7178
   DEFINE  l_pmh24    LIKE pmh_file.pmh24        #FUN-940083
   DEFINE  l_pmc914   LIKE pmc_file.pmc914       #FUN-940083
   IF g_pmm.pmm01 IS NULL THEN RETURN END IF
 
   #------------------#
   #   產生工單資料   #
   #------------------#
 
   SELECT '','',0,'',sfb05,ima02,'',' ',ima44,ima25,1,'',
           1,'','',0,'','','','0','',sfb08,'','','',0,
           0,0,0,'','',sfb13,
          '','','Y','',sfb01,'0',sfb17,0,0,0,0,
           0,0,0,0,0,0,0,0,0,'',
           0,sfb05,1,'N','N','1','','','','','','',
          '',1,0,'',1,0,'',0 ,0 ,0,
          '', '' ,0, '',0, '','','','',sfb96,    #FUN-D40042 add sfb96
          ima55,ima49,ima491,ima021
    #INTO g_pmn2.*,l_ima55,l_ima49,l_ima491,l_ima021 #MOD-C30865 mark
    #MOD-C30865 add start -----
     INTO g_pmn2.pmn01, g_pmn2.pmn011,g_pmn2.pmn02, g_pmn2.pmn03, g_pmn2.pmn04
         ,g_pmn2.pmn041,g_pmn2.pmn05, g_pmn2.pmn06, g_pmn2.pmn07, g_pmn2.pmn08
         ,g_pmn2.pmn09, g_pmn2.pmn10, g_pmn2.pmn11, g_pmn2.pmn121,g_pmn2.pmn122
         ,g_pmn2.pmn123,g_pmn2.pmn13, g_pmn2.pmn14, g_pmn2.pmn15, g_pmn2.pmn16
         ,g_pmn2.pmn18, g_pmn2.pmn20, g_pmn2.pmn23, g_pmn2.pmn24, g_pmn2.pmn25
         ,g_pmn2.pmn30, g_pmn2.pmn31, g_pmn2.pmn31t,g_pmn2.pmn32, g_pmn2.pmn33
         ,g_pmn2.pmn34, g_pmn2.pmn35, g_pmn2.pmn36, g_pmn2.pmn37, g_pmn2.pmn38
         ,g_pmn2.pmn40, g_pmn2.pmn41, g_pmn2.pmn42, g_pmn2.pmn43, g_pmn2.pmn431
         ,g_pmn2.pmn44, g_pmn2.pmn45, g_pmn2.pmn46, g_pmn2.pmn50, g_pmn2.pmn51
         ,g_pmn2.pmn52, g_pmn2.pmn53, g_pmn2.pmn54, g_pmn2.pmn55, g_pmn2.pmn56
         ,g_pmn2.pmn57, g_pmn2.pmn58, g_pmn2.pmn59, g_pmn2.pmn60, g_pmn2.pmn61
         ,g_pmn2.pmn62, g_pmn2.pmn63, g_pmn2.pmn64, g_pmn2.pmn65, g_pmn2.pmn66
         ,g_pmn2.pmn67, g_pmn2.pmn68, g_pmn2.pmn69, g_pmn2.pmn70, g_pmn2.pmn71
         ,g_pmn2.pmn80, g_pmn2.pmn81, g_pmn2.pmn82, g_pmn2.pmn83, g_pmn2.pmn84
         ,g_pmn2.pmn85, g_pmn2.pmn86, g_pmn2.pmn87, g_pmn2.pmn88, g_pmn2.pmn88t
         ,g_pmn2.pmn930,g_pmn2.pmn401,g_pmn2.pmn90, g_pmn2.pmn94, g_pmn2.pmn95
         ,g_pmn2.pmn96, g_pmn2.pmn97, g_pmn2.pmn98, g_pmn2.pmn91   , g_pmn2.pmn100  #FUN-D40042 add pmn100
         ,l_ima55     , l_ima49,      l_ima491,     l_ima021   
    #MOD-C30865 add end   -----
     FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05 = ima01  #091020 
    WHERE sfb01=g_argv4
      AND (sfb02=7 OR sfb02=8)
      AND sfb04='1'
 
   IF STATUS THEN
      CALL cl_err3("sel","sfb_file,ima_file","","",STATUS,"","auto sfb err:",1) #No.FUN-660129
      RETURN END IF #MOD-640492 0->1
   #--------------------------------#
   #   處理產生出來之採購單身資料   #
   #--------------------------------#
 
   #重工委外負數不可產生在採購單
   SELECT sfb02 INTO l_sfb02 FROM sfb_file
    WHERE sfb01 =g_argv4
   IF l_sfb02=8 THEN
      SELECT SUM(sfa05) INTO l_sfa05 FROM sfa_file  #FUN-A60027 sfa05 -> SUM(sfa05)
       WHERE sfa01=g_argv4
         AND sfa27=g_pmn2.pmn04
      IF l_sfa05<0 THEN
         INITIALIZE g_pmn2.* TO NULL
      END IF
   ELSE
      LET g_success = 'Y'
      BEGIN WORK
 
      SELECT max(pmn02)+1 INTO g_pmn2.pmn02
        FROM pmn_file
       WHERE pmn01 = g_pmm.pmm01
 
      IF g_pmn2.pmn02 IS NULL THEN
          LET g_pmn2.pmn02 = 1
      END IF
 
      LET g_pmn2.pmn01=g_pmm.pmm01
      LET g_pmn2.pmn011='SUB'
 
      CALL s_umfchk(g_pmn2.pmn04,g_pmn2.pmn07,g_pmn2.pmn08)
      RETURNING l_flag,g_pmn2.pmn09
 
      IF l_flag THEN
         CALL cl_err('pmn07/pmn08: ','abm-731',1) # Modify:單位換算率抓不到
         LET g_success = 'N'                      # 98/11/15
      END IF
 
      CALL s_overate(g_pmn2.pmn04) RETURNING g_pmn2.pmn13
 
      LET g_pmn2.pmn14 = g_sma.sma886[1,1]             # 部份交貨
      LET g_pmn2.pmn15 = g_sma.sma886[2,2]             # 提前交貨
 
      CALL s_umfchk(g_pmn2.pmn04,l_ima55,g_pmn2.pmn07) # 取生產單位
           RETURNING l_flag,l_fac                      # 與採購單位換算率
 
      IF l_flag THEN
         CALL cl_err('ima55/pmn07: ','abm-731',1)      # Modify:單位換算率抓不到
         LET g_success ='N'                            # 98/11/15
         LET l_fac=1
      END IF
 
      LET g_pmn2.pmn20 = g_pmn2.pmn20*l_fac
      LET g_pmn2.pmn20 = s_digqty(g_pmn2.pmn20,g_pmn2.pmn07)    #FUN-910088--add--
 
      SELECT imb118 INTO g_pmn2.pmn30
        FROM imb_file
       WHERE imb01 = g_pmn2.pmn04
 
      IF cl_null(g_pmn2.pmn30) THEN LET g_pmn2.pmn30=0 END IF
 
         IF NOT cl_null(g_pmn2.pmn43) AND g_pmn2.pmn43 != 0 THEN
             SELECT ecm04 INTO l_ecm04
               FROM ecm_file
              WHERE ecm01 = g_pmn2.pmn41                  #工號
                AND ecm03 = g_pmn2.pmn43                  #製程序
                AND ecm012= g_pmn2.pmn012                 #No.FUN-A60011
             CALL s_defprice_new(g_pmn2.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                                 g_pmn2.pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,
                                  g_type,g_pmn2.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                  RETURNING g_pmn2.pmn31,g_pmn2.pmn31t,
                            g_pmn2.pmn73,g_pmn2.pmn74   #TQC-AC0257 add
             CALL t540_price_check(g_pmn2.pmn31,g_pmn2.pmn31t)   #MOD-9C0285 ADD 
             LET g_pmn2.pmn90 = g_pmn2.pmn31           #MOD-C50245 add
         ELSE
             CALL s_defprice_new(g_pmn2.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                                 g_pmn2.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,
                                 g_type,g_pmn2.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                   RETURNING g_pmn2.pmn31,g_pmn2.pmn31t,
                             g_pmn2.pmn73,g_pmn2.pmn74   #TQC-AC0257 add
             CALL t540_price_check(g_pmn2.pmn31,g_pmn2.pmn31t)    #MOD-9C0285 ADD
         END IF
         IF cl_null(g_pmn2.pmn73) THEN LET g_pmn2.pmn73='4' END IF #TQC-AC0257
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
          END IF
      IF cl_null(g_pmn2.pmn31) THEN
         LET g_pmn2.pmn31=0
         LET g_pmn2.pmn31t = 0
      END IF
      LET g_pmn2.pmn90=g_pmn2.pmn31   #CHI-690043 add
 
      LET l_flag = ' '
      LET l_date = ' '
 
      LET g_pmn2.pmn34 = g_pmn2.pmn35-l_ima491         #到廠日
      CALL s_wkday(g_pmn2.pmn34) RETURNING l_flag,l_date
 
      IF l_date IS NULL OR l_date = ' ' THEN
          LET g_pmn2.pmn34=l_date
      END IF
 
      LET l_flag=' '
      LET l_date=' '
 
      LET g_pmn2.pmn33 = g_pmn2.pmn34-l_ima49          #交貨日
      CALL s_wkday(g_pmn2.pmn33) RETURNING l_flag,l_date
 
      IF l_date IS NULL OR l_date = ' ' THEN
          LET g_pmn2.pmn33=l_date
      END IF
 
      LET g_pmn2.pmn44 = g_pmn2.pmn31 * g_pmm.pmm42   #bugno:5225
      CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
 
      SELECT sfb27,sfb271,sfb50,sfb51
        INTO g_pmn2.pmn122,g_pmn2.pmn96,g_pmn2.pmn97,g_pmn2.pmn98
        FROM sfb_file
       WHERE sfb01 = g_pmn2.pmn41
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","sfa_file",g_pmn2.pmn41,"","asf-523","","",0)
         LET g_pmn2.pmn122 = ''
         LET g_pmn2.pmn96  = ''
         LET g_pmn2.pmn97  = ''
         LET g_pmn2.pmn98  = ''
      END IF
 
      #------------------#
      #   寫入採購單身   #
      #------------------#
 
      SELECT pmh24 INTO l_pmh24 FROM pmh_file
         WHERE pmh01 = g_pmn2.pmn04
           AND pmh02 = g_pmm.pmm09
           AND pmh13 = g_pmm.pmm22
           AND pmh21 = " "
           AND pmh22 = '1'
           AND pmh23 = ' '                      #No.CHI-960033
           AND pmhacti = 'Y'
      IF NOT cl_null(l_pmh24) THEN
         LET g_pmn2.pmn89=l_pmh24
      ELSE
         IF g_sma.sma93="Y" THEN                        #MOD-C30578 add
            SELECT pmc914 INTO l_pmc914 FROM pmc_file 
             WHERE pmc01 = g_pmm.pmm09 
            IF l_pmc914 = 'Y' THEN
               LET g_pmn2.pmn89 = 'Y'
            ELSE
               LET g_pmn2.pmn89 = 'N'
            END IF
         END IF                                         #MOD-C30578 add
      END IF
      IF g_sma.sma115 = 'Y' THEN
         CALL t540_set_du_by_origin('b')
      END IF
       IF cl_null(g_pmn2.pmn01) THEN LET g_pmn2.pmn01 = ' ' END IF
       IF cl_null(g_pmn2.pmn02) THEN LET g_pmn2.pmn02 = 0 END IF
       IF cl_null(g_pmn2.pmn58) THEN LET g_pmn2.pmn58 = 0 END IF   #TQC-9B0203
       IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF  #No.TQC-A60113
       CALL s_schdat_pmn78(g_pmn2.pmn41,g_pmn2.pmn012,g_pmn2.pmn43,g_pmn2.pmn18,   #FUN-C10002
                                         g_pmn2.pmn32) RETURNING g_pmn2.pmn78      #FUN-C10002
      INSERT INTO pmn_file VALUES(g_pmn2.*)
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pmn_file",g_pmn2.pmn01,g_pmn2.pmn02,SQLCA.sqlcode,"","sfb ins pmn:",1)  #No.FUN-660129
         ROLLBACK WORK
      END IF
      IF g_success='Y'
          THEN COMMIT WORK
          ELSE ROLLBACK WORK
      END IF
   END IF
   #------------------#
   #   產生代買資料   #
   #------------------#
 
   LET g_sql = "SELECT ' ','',0,' ',sfa03,ima02,' ',' ',",
               "       ima44,ima25,1,' ',' ',1, sfb27, '', 0, ' ',' ',",
               "       '0',' ',sfa065,' ',' ',0,' ',0,0,  ' ',' ',sfb13,",
               "       ' ',' ',' ','Y',' ',sfa01,sfa26,sfa08,0,  0,0, 0, 0,",
               "       0,'', 0,'',0, '', 0, 0,'',0, ' ',1,'N','N','2',",
               "       '','','',0, 1, '', '',0, 0, '',0 ,0 ,'',0, 0, 0,",
               "       '', '' ,0, '',0, sfb271,sfb50,sfb51,'',",
               "       sfa12,",  #No.FUN-540027
               "       ima55,ima49,ima491 ",
               "  FROM sfb_file,sfa_file LEFT OUTER JOIN ima_file ON sfa03=ima01 ", #091020
               " WHERE sfa01 = '",g_argv4 CLIPPED,"'",
               "   AND sfa065 > 0    AND sfb87 != 'X'"
 
   PREPARE t540_g_b_p1 FROM g_sql
   DECLARE t540_g_b_c1 CURSOR WITH HOLD FOR t540_g_b_p1
   #FOREACH t540_g_b_c1 INTO g_pmn2.*,l_sfa12,l_ima55,l_ima49,l_ima491 #MOD-C30865 mark
   #MOD-C30865 add start -----
   FOREACH t540_g_b_c1 INTO g_pmn2.pmn01, g_pmn2.pmn011, g_pmn2.pmn02, g_pmn2.pmn03, g_pmn2.pmn04
                           ,g_pmn2.pmn041,g_pmn2.pmn05,  g_pmn2.pmn06, g_pmn2.pmn07, g_pmn2.pmn08
                           ,g_pmn2.pmn09, g_pmn2.pmn10,  g_pmn2.pmn11, g_pmn2.pmn121,g_pmn2.pmn122
                           ,g_pmn2.pmn123,g_pmn2.pmn13,  g_pmn2.pmn14, g_pmn2.pmn15, g_pmn2.pmn16
                           ,g_pmn2.pmn18, g_pmn2.pmn20,  g_pmn2.pmn23, g_pmn2.pmn24, g_pmn2.pmn25
                           ,g_pmn2.pmn30, g_pmn2.pmn31,  g_pmn2.pmn31t,g_pmn2.pmn32, g_pmn2.pmn33
                           ,g_pmn2.pmn34, g_pmn2.pmn35,  g_pmn2.pmn36, g_pmn2.pmn37, g_pmn2.pmn38
                           ,g_pmn2.pmn40, g_pmn2.pmn41,  g_pmn2.pmn42, g_pmn2.pmn43, g_pmn2.pmn431
                           ,g_pmn2.pmn44, g_pmn2.pmn45,  g_pmn2.pmn46, g_pmn2.pmn50, g_pmn2.pmn51
                           ,g_pmn2.pmn52, g_pmn2.pmn53,  g_pmn2.pmn54, g_pmn2.pmn55, g_pmn2.pmn56
                           ,g_pmn2.pmn57, g_pmn2.pmn58,  g_pmn2.pmn59, g_pmn2.pmn60, g_pmn2.pmn61
                           ,g_pmn2.pmn62, g_pmn2.pmn63,  g_pmn2.pmn64, g_pmn2.pmn65, g_pmn2.pmn66
                           ,g_pmn2.pmn67, g_pmn2.pmn68,  g_pmn2.pmn69, g_pmn2.pmn70, g_pmn2.pmn71
                           ,g_pmn2.pmn80, g_pmn2.pmn81,  g_pmn2.pmn82, g_pmn2.pmn83, g_pmn2.pmn84
                           ,g_pmn2.pmn85, g_pmn2.pmn86,  g_pmn2.pmn87, g_pmn2.pmn88, g_pmn2.pmn88t
                           ,g_pmn2.pmn930,g_pmn2.pmn401, g_pmn2.pmn90, g_pmn2.pmn94, g_pmn2.pmn95
                           ,g_pmn2.pmn96, g_pmn2.pmn97,  g_pmn2.pmn98, g_pmn2.pmn91, l_sfa12
                           ,l_ima55,      l_ima49,       l_ima491
   #MOD-C30865 add end   -----
      IF STATUS THEN CALL cl_err('for sfa',STATUS,1) EXIT FOREACH END IF
 
   #--------------------------------#
   #   處理產生出來之採購單身資料   #
   #--------------------------------#
 
      SELECT max(pmn02)+1 INTO g_pmn2.pmn02
        FROM pmn_file
       WHERE pmn01 = g_pmm.pmm01
 
      IF g_pmn2.pmn02 IS NULL THEN LET g_pmn2.pmn02 = 1 END IF
 
      LET g_pmn2.pmn01 = g_pmm.pmm01               #單號
      LET g_pmn2.pmn011= 'SUB'
 
      CALL s_umfchk(g_pmn2.pmn04,g_pmn2.pmn07,g_pmn2.pmn08)
           RETURNING l_flag,g_pmn2.pmn09
 
      IF l_flag THEN
          CALL cl_err('pmn07/pmn08: ','abm-731',1) #Modify:單位換算率抓不到
          EXIT FOREACH
      END IF
 
      CALL s_overate(g_pmn2.pmn04) RETURNING g_pmn2.pmn13
 
      LET g_pmn2.pmn14 =g_sma.sma886[1,1]         #部份交貨
      LET g_pmn2.pmn15 =g_sma.sma886[2,2]         #提前交貨
 
      CALL s_umfchk(g_pmn2.pmn04,l_sfa12,g_pmn2.pmn07) #取發料單位
           RETURNING l_flag,l_fac                      #與採購單位換算率
 
      IF l_flag THEN
          CALL cl_err('sfa12/pmn07: ','asf-032',1) #Modify:單位換算率抓不到
          EXIT FOREACH
      END IF
 
      LET g_pmn2.pmn20 = g_pmn2.pmn20 * l_fac
      LET g_pmn2.pmn20 = s_digqty(g_pmn2.pmn20,g_pmn2.pmn07)   #FUN-910088--add--
 
      SELECT imb118 INTO g_pmn2.pmn30
        FROM imb_file
       WHERE imb01 = g_pmn2.pmn04
 
      IF cl_null(g_pmn2.pmn30) THEN LET g_pmn2.pmn30=0 END IF
 
      IF NOT cl_null(g_pmn2.pmn43) AND g_pmn2.pmn43 != 0 THEN
 
          SELECT ecm04 INTO l_ecm04
            FROM ecm_file
           WHERE ecm01 = g_pmn2.pmn41 #工號
             AND ecm03 = g_pmn2.pmn43 #製程序
             AND ecm012= g_pmn2.pmn012                 #No.FUN-A60011
 
          CALL s_defprice_new(g_pmn2.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                              g_pmn2.pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,
                              g_type,g_pmn2.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
               RETURNING g_pmn2.pmn31,g_pmn2.pmn31t,
                         g_pmn2.pmn73,g_pmn2.pmn74   #TQC-AC0257 add
          CALL t540_price_check(g_pmn2.pmn31,g_pmn2.pmn31t)   #MOD-9C0285
      ELSE
          CALL s_defprice_new(g_pmn2.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                               g_pmn2.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,
                              g_type,g_pmn2.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                RETURNING g_pmn2.pmn31,g_pmn2.pmn31t,
                          g_pmn2.pmn73,g_pmn2.pmn74   #TQC-AC0257 add
          CALL t540_price_check(g_pmn2.pmn31,g_pmn2.pmn31t)   #MOD-9C0285  ADD
      END IF
      IF cl_null(g_pmn2.pmn73) THEN LET g_pmn2.pmn73='4' END IF #TQC-AC0257
       IF NOT cl_null(g_errno) THEN
          CALL cl_err('',g_errno,1)
       END IF
 
      IF cl_null(g_pmn2.pmn31) THEN
         LET g_pmn2.pmn31=0
         LET g_pmn2.pmn31t=0
      END IF
 
      LET g_pmn2.pmn90=g_pmn2.pmn31   #CHI-690043 add
 
      LET l_flag = ' '
      LET l_date = ' '
 
      LET g_pmn2.pmn34 = g_pmn2.pmn35-l_ima491         #到廠日
      CALL s_wkday(g_pmn2.pmn34) RETURNING l_flag,l_date
 
      IF l_date IS NULL OR l_date = ' ' THEN LET g_pmn2.pmn34=l_date END IF
 
      LET l_flag=' '
      LET l_date=' '
 
      LET g_pmn2.pmn33 = g_pmn2.pmn34-l_ima49          #交貨日
      CALL s_wkday(g_pmn2.pmn33) RETURNING l_flag,l_date
 
      IF l_date IS NULL OR l_date =' ' THEN LET g_pmn2.pmn33=l_date END IF
 
      LET g_pmn2.pmn44 = g_pmn2.pmn31 * g_pmm.pmm42  #bugno:5225
      CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44  #No.CHI-6A0004
 
      LET g_success = 'Y'
      BEGIN WORK
 
        IF g_sma.sma115 = 'Y' THEN
           CALL t540_set_du_by_origin('b')
        END IF
        SELECT pmh24 INTO l_pmh24 FROM pmh_file
           WHERE pmh01 = g_pmn2.pmn04
             AND pmh02 = g_pmm.pmm09
             AND pmh13 = g_pmm.pmm22
             AND pmh21 = " "
             AND pmh22 = '1'
             AND pmh23 = ' '                      #No.CHI-960033
             AND pmhacti = 'Y'
        IF NOT cl_null(l_pmh24) THEN
           LET g_pmn2.pmn89=l_pmh24
        ELSE
           IF g_sma.sma93="Y" THEN                        #MOD-C30578 add
              SELECT pmc914 INTO l_pmc914 FROM pmc_file 
               WHERE pmc01 = g_pmm.pmm09 
              IF l_pmc914 = 'Y' THEN
                 LET g_pmn2.pmn89 = 'Y'
              ELSE
                 LET g_pmn2.pmn89 = 'N'
              END IF
           END IF                                         #MOD-C30578 add
        END IF                                        
         IF cl_null(g_pmn2.pmn01) THEN LET g_pmn2.pmn01 = ' ' END IF
         IF cl_null(g_pmn2.pmn02) THEN LET g_pmn2.pmn02 = 0 END IF
         IF cl_null(g_pmn2.pmn58) THEN LET g_pmn2.pmn58 = 0 END IF   #TQC-9B0203
         IF cl_null(g_pmn2.pmn012) THEN LET g_pmn2.pmn012=' ' END IF  #No.TQC-A60113
         CALL s_schdat_pmn78(g_pmn2.pmn41,g_pmn2.pmn012,g_pmn2.pmn43,g_pmn2.pmn18,   #FUN-C10002
                                           g_pmn2.pmn32) RETURNING g_pmn2.pmn78      #FUN-C10002
        INSERT INTO pmn_file VALUES(g_pmn2.*)
 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmn_file",g_pmn2.pmn01,g_pmn2.pmn02,SQLCA.sqlcode,"","sfa ins pmn:",1)  #No.FUN-660129
            ROLLBACK WORK
            CONTINUE FOREACH
        END IF
        IF g_success='Y'
            THEN COMMIT WORK
            ELSE ROLLBACK WORK
        END IF
 
     END FOREACH
 
   CALL t540_b_fill(' 1=1',' 1=1')  #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
 
END FUNCTION
FUNCTION t540_pmn52()
DEFINE l_imd11     LIKE imd_file.imd11
DEFINE l_imd20     LIKE imd_file.imd20
DEFINE l_imdacti   LIKE imd_file.imdacti
DEFINE l_n         LIKE type_file.num5
DEFINE l_rtz08     LIKE rtz_file.rtz08   #FUN-B40098
DEFINE l_rtz07     LIKE rtz_file.rtz07   #FUN-B60150 ADD

   LET g_errno = ''
   SELECT imd11,imd20,imdacti
     INTO l_imd11,l_imd20,l_imdacti
     FROM imd_file
    WHERE imd01 = g_pmn[l_ac].pmn52  #CHI-9C0025
   CASE
     WHEN SQLCA.sqlcode = 100 LET g_errno = 'aic-034'
     WHEN l_imd11 = 'N'       LET g_errno = 'mfg6080'
     #WHEN l_imd20 = 'N'       LET g_errno = 'art-426'  #No.FUN-AA0049
     WHEN l_imdacti = 'N'     LET g_errno = 'art-303'
   END CASE

  #FUN-B40098 Begin---
  #IF cl_null(g_errno) AND g_azw.azw04='2' AND g_pmm.pmm51 = '3' THEN  #FUN-B60150 MARK
   IF cl_null(g_errno) AND g_azw.azw04='2' THEN
      IF (g_pmm.pmm51 = '3' OR (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2')) THEN #FUN-B60150 ADD
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM imd_file
          WHERE imd01 = g_pmn[l_ac].pmn52
            AND imd01 IN (SELECT jce02 FROM jce_file)
         IF g_cnt = 0 THEN  #FUN-B60150 ADD
            IF g_pmm.pmm51 = '3' THEN
               LET g_errno = 'apm-147'
            #FUN-B60150 ADD - BEGIN ----------
            ELSE
               LET g_errno = 'apm-153'
            END IF
            #FUN-B60150 ADD - END ------------
         END IF
      END IF #FUN-B60150 ADD
      #FUN-B60150 ADD - BEGIN ----------------------------------
      IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN 
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM imd_file
          WHERE imd01 = g_pmn[l_ac].pmn52
            AND imd01 NOT IN (SELECT jce02 FROM jce_file)
         IF g_cnt = 0 THEN
            LET g_errno = 'apm-154'
         END IF
      END IF
      #FUN-B60150 ADD - END ------------------------------------
   END IF
  #FUN-B40098 End-----
END FUNCTION
 
FUNCTION t540_b_more(p_cmd)
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE  p_cmd    LIKE type_file.chr1   #MOD-4B0104  #No.FUN-680136 VARCHAR(1)
  DEFINE  l_cnt    LIKE type_file.num5   #FUN-650191
  DEFINE  l_pmx10  LIKE pmx_file.pmx10   #CHI-8B0018
  DEFINE  l_pmx11  LIKE pmx_file.pmx11   #CHI-8B0018
  DEFINE  l_bz     LIKE type_file.chr1   #No.MOD-8C0159 add
 
    LET l_bz = 'Y'     #No;MOD-8C0159 add
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t5405_w AT p_row,p_col WITH FORM "apm/42f/apmt5405"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt5405")
 
      IF g_aza.aza63 = 'N' THEN
         CALL cl_set_comp_visible("pmn401",FALSE)
      END IF
 
      IF cl_null(g_pmn2.pmn13) AND NOT cl_null(g_pmn2.pmn04) THEN
         CALL s_overate(g_pmn2.pmn04) RETURNING g_pmn2.pmn13
      END IF
      IF cl_null(g_pmn2.pmn15) THEN
         LET g_pmn2.pmn15 = g_sma.sma886[2,2]         #提前交貨
      END IF
      IF cl_null(g_pmn2.pmn14) THEN
         LET g_pmn2.pmn14 = g_sma.sma886[1,1]         #部份交貨
      END IF
      IF cl_null(g_pmn2.pmn30) AND NOT cl_null(g_pmn2.pmn04) THEN
         SELECT imb118 INTO g_pmn2.pmn30 FROM imb_file
          WHERE imb01 = g_pmn2.pmn04
          IF cl_null(g_pmn2.pmn30) THEN LET g_pmn2.pmn30 = 0 END IF
      END IF
      IF cl_null(g_pmn2.pmn43)  THEN LET g_pmn2.pmn43 = 0  END IF
      IF cl_null(g_pmn2.pmn431) THEN LET g_pmn2.pmn431 = 0 END IF
      IF g_pmn2.pmn012 IS NULL THEN LET g_pmn2.pmn012 = ' ' END IF   #No.FUN-A60011
      IF NOT cl_null(g_argv9) THEN
         LET g_pmn2.pmn43 = g_argv9
      END IF
      IF NOT cl_null(g_argv10) THEN
         LET g_pmn2.pmn431= g_argv10
      END IF
      IF cl_null(g_pmn2.pmn61) THEN
         LET g_pmn2.pmn61 = g_pmn2.pmn04
      END IF
      IF cl_null(g_pmn2.pmn62) THEN
         LET g_pmn2.pmn62 = 1
      END IF
      DISPLAY g_pmn2.pmn61 TO pmn61
      DISPLAY g_pmn2.pmn431 TO pmn431
      DISPLAY g_pmn2.pmn43 TO pmn43
      DISPLAY g_pmn2.pmn30 TO pmn30
      DISPLAY g_pmn2.pmn13 TO pmn13
      DISPLAY g_pmn2.pmn14 TO pmn14
      DISPLAY g_pmn2.pmn15 TO pmn15
      DISPLAY g_pmn2.pmn05 TO pmn05 #no.4650
 
    INPUT BY NAME g_pmn2.pmn40,g_pmn2.pmn401,g_pmn2.pmn23,g_pmn2.pmn03,g_pmn2.pmn06,  #No.FUN-680029 add g_pmn2.pmn401
                  g_pmn2.pmn13,g_pmn2.pmn14,g_pmn2.pmn15,
                  g_pmn2.pmn30,g_pmn2.pmn43,
                  g_pmn2.pmn431,g_pmn2.pmn61,g_pmn2.pmn62,
                  g_pmn2.pmn05
                  WITHOUT DEFAULTS

    AFTER FIELD pmn40                      #會計科目
       IF NOT cl_null(g_pmn2.pmn40) THEN
          IF g_sma.sma03='Y' THEN
             IF NOT s_actchk3(g_pmn2.pmn40,g_bookno1) THEN  #No.FUN-730033
#FUN-B10052 --begin--
#               CALL cl_err(g_pmn2.pmn40,'mfg0018',1)  #MOD-640492 0->1
#               LET g_pmn2.pmn40 = g_pmn_o.pmn40
                CALL cl_err(g_pmn2.pmn40,'mfg0018',0) 

               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_pmn2.pmn40
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_bookno1   
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' AND aag01 LIKE '",g_pmn2.pmn40 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_pmn2.pmn40
               DISPLAY g_pmn2.pmn40 TO pmn40                
#FUN-B10052 --end--
                NEXT FIELD pmn40
             END IF
          END IF
       END IF
       LET l_pmn40=g_pmn2.pmn40
       LET g_pmn_o.pmn40 = g_pmn2.pmn40
 
    AFTER FIELD pmn401
       IF NOT cl_null(g_pmn2.pmn401) THEN
          IF g_sma.sma03='Y' THEN
             IF NOT s_actchk3(g_pmn2.pmn401,g_bookno2) THEN  #No.FUN-730033
#FUN-B10052 --begin--
#                CALL cl_err(g_pmn2.pmn401,'mfg0018',1)
#                LET g_pmn2.pmn401 = g_pmn_o.pmn401
               CALL cl_err(g_pmn2.pmn401,'mfg0018',0)                  
               
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_pmn2.pmn401
               LET g_qryparam.arg1 = g_bookno2  
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' AND aag01 LIKE '",g_pmn2.pmn401 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_pmn2.pmn401
               DISPLAY g_pmn2.pmn401 TO pmn401
#FUN-B10052 --end--
                NEXT FIELD pmn401
             END IF
          END IF
       END IF
       LET l_pmn401=g_pmn2.pmn401
       LET g_pmn_o.pmn401 = g_pmn2.pmn401
 
    AFTER FIELD pmn23                      #送貨地址
      IF NOT cl_null(g_pmn2.pmn23) THEN
         CALL t540_pmn23(g_pmn2.pmn23)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pmn2.pmn23,g_errno,1)  #MOD-640492 0->1
            LET g_pmn2.pmn23 = g_pmn_o.pmn23
            DISPLAY BY NAME g_pmn_o.pmn23
            NEXT FIELD pmn23
         END IF
      END IF
      LET l_pmn23=g_pmn2.pmn23
      LET g_pmn_o.pmn23 = g_pmn2.pmn23
 
    AFTER FIELD pmn03                      #詢價單號
      IF NOT cl_null(g_pmn2.pmn03) THEN
         CALL t540_pmn03()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pmn2.pmn03,g_errno,1) #MOD-640492 0->1
            LET g_pmn2.pmn03 = g_pmn_o.pmn03
            DISPLAY BY NAME g_pmn2.pmn03
            NEXT FIELD pmn03
         END IF
        IF g_pmm.pmm02='SUB' THEN
           LET l_pmx11='2'
           IF g_pmn2.pmn43 = 0 OR cl_null(g_pmn2.pmn43) THEN  
              LET l_pmx10 =' '
           ELSE
             IF NOT cl_null(g_pmn2.pmn18) THEN
              SELECT sgm04 INTO l_pmx10 FROM sgm_file
               WHERE sgm01=g_pmn2.pmn18
                 AND sgm02=g_pmn2.pmn41
                 AND sgm03=g_pmn2.pmn43
                 AND sgm012 = g_pmn2.pmn012 #No.FUN-A60076
             ELSE
              SELECT ecm04 INTO l_pmx10 FROM ecm_file 
               WHERE ecm01=g_pmn2.pmn41
                 AND ecm03=g_pmn2.pmn43
                 AND ecm012=g_pmn2.pmn012   #No.FUN-A60011
             END IF
           END IF          #No.TQC-910033  
        ELSE
           LET l_pmx11='1'
           LET l_pmx10=' '
        END IF
                           
         SELECT COUNT(*) INTO l_cnt FROM pmx_file
          WHERE pmx01 = g_pmn2.pmn03
            AND pmx12 = g_pmm.pmm09
            AND pmx10 = l_pmx10                                    #CHI-8B0018                                                
            AND pmx11 = l_pmx11                                    #CHI-8B0018
          IF l_cnt = 0 THEN
            CALL cl_err(g_pmn2.pmn03,'mfg0028',1) #MOD-640492 0->1
            LET g_pmn2.pmn03 = g_pmn_o.pmn03
            DISPLAY BY NAME g_pmn2.pmn03
            NEXT FIELD pmn03
         END IF
      END IF
      LET l_pmn03 = g_pmn2.pmn03
      LET g_pmn_o.pmn03 = g_pmn2.pmn03
 
    AFTER FIELD pmn06                      #廠商料號
      LET l_pmn06 = g_pmn2.pmn06
      LET g_pmn_o.pmn06 = g_pmn2.pmn06
 
    AFTER FIELD pmn13
      LET l_pmn13 = g_pmn2.pmn13
      LET g_pmn_o.pmn13 = g_pmn2.pmn13
 
    AFTER FIELD pmn14
      LET l_pmn14 = g_pmn2.pmn14
      LET g_pmn_o.pmn14 = g_pmn2.pmn14
 
    AFTER FIELD pmn15
      LET l_pmn15 = g_pmn2.pmn15
      LET g_pmn_o.pmn15 = g_pmn2.pmn15
 
    AFTER FIELD pmn30
      LET l_pmn30 = g_pmn2.pmn30
      LET g_pmn_o.pmn30 = g_pmn2.pmn30
 
   AFTER FIELD pmn43
      LET l_pmn43 = g_pmn2.pmn43
      LET g_pmn_o.pmn43 = g_pmn2.pmn43
 
   AFTER FIELD pmn431
      LET l_pmn431 = g_pmn2.pmn431
      LET g_pmn_o.pmn431 = g_pmn2.pmn431
 
   BEFORE FIELD pmn61
       IF cl_null(g_pmn2.pmn61) THEN     #MOD-4B0119
         LET g_pmn2.pmn61 = g_pmn2.pmn04
      END IF
 
   AFTER FIELD pmn61
      LET l_pmn61 = g_pmn2.pmn61
      LET g_pmn_o.pmn61 = g_pmn2.pmn61
      IF cl_null(g_pmn2.pmn62) THEN
         LET g_pmn2.pmn62 = 1
      END IF
 
   AFTER FIELD pmn62
      LET l_pmn62 = g_pmn2.pmn62
      LET g_pmn_o.pmn62 = g_pmn2.pmn62
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(pmn40) #會計科目
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_pmn2.pmn40
               LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' "
               CALL cl_create_qry() RETURNING g_pmn2.pmn40
               DISPLAY g_pmn2.pmn40 TO pmn40
               NEXT FIELD pmn40
          WHEN INFIELD(pmn401)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_pmn2.pmn401
               LET g_qryparam.arg1 = g_bookno2   #No.FUN-730033
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 = '2' "
               CALL cl_create_qry() RETURNING g_pmn2.pmn401
               DISPLAY g_pmn2.pmn401 TO pmn401
               NEXT FIELD pmn401
          WHEN INFIELD(pmn23) #查詢地址資料檔 (0:表送貨地址)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pme"
               LET g_qryparam.default1 = g_pmn2.pmn23
               CALL cl_create_qry() RETURNING g_pmn2.pmn23
               DISPLAY g_pmn2.pmn23 TO pmn23
               NEXT FIELD pmn23
          WHEN INFIELD(pmn61) #料件編號
#FUN-AA0059---------mod------------str-----------------          
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.default1 = g_pmn2.pmn61
#               CALL cl_create_qry() RETURNING g_pmn2.pmn61
                CALL q_sel_ima(FALSE, "q_ima","",g_pmn2.pmn61,"","","","","",'' ) 
                RETURNING  g_pmn2.pmn61
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_pmn2.pmn61 TO pmn61
               NEXT FIELD pmn61
          #FUN-C30125 add begin---
          WHEN INFIELD(pmn03) #詢價單單號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmx01"
               LET g_qryparam.default1 = g_pmn2.pmn03
               LET g_qryparam.arg1 = g_pmn2.pmn04 
               LET g_qryparam.arg2 = g_plant
               CALL cl_create_qry() RETURNING g_pmn2.pmn03
               DISPLAY g_pmn2.pmn03 TO pmn03
               NEXT FIELD pmn03
          #FUN-C30125 add end-----
          OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    AFTER INPUT
       IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          LET l_bz = 'N'      #No.MOD-8C0159 add
          EXIT INPUT
       END IF
       LET l_flag = 'N'
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
 END INPUT
    IF p_cmd='u' AND l_bz = 'Y' THEN  #No.MOD-8C0159 add
       UPDATE pmn_file SET pmn40=g_pmn2.pmn40,
                           pmn23=g_pmn2.pmn23,
                           pmn03=g_pmn2.pmn03,
                           pmn06=g_pmn2.pmn06,
                           pmn13=g_pmn2.pmn13,
                           pmn14=g_pmn2.pmn14,
                           pmn15=g_pmn2.pmn15,
                           pmn30=g_pmn2.pmn30,
                           pmn43=g_pmn2.pmn43,
                           pmn431=g_pmn2.pmn431,
                           pmn61=g_pmn2.pmn61,
                           pmn62=g_pmn2.pmn62,
                           pmn05=g_pmn2.pmn05
        WHERE pmn01=g_pmm.pmm01
          AND pmn02=g_pmn[l_ac].pmn02
       IF g_aza.aza63 = 'Y' THEN
          UPDATE pmn_file SET pmn401 = g_pmn2.pmn401
           WHERE pmn01=g_pmm.pmm01
             AND pmn02=g_pmn[l_ac].pmn02
       END IF
    END IF
    CLOSE WINDOW t5405_w                 #結束畫面
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
END FUNCTION
 
FUNCTION t540_b_more2(p_cmd)
    DEFINE l_no     LIKE coc_file.coc01
     DEFINE l_coc10  LIKE coc_file.coc10        #No.MOD-4B0275
     DEFINE l_coc04  LIKE coc_file.coc04        #No.MOD-4B0275
    DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680136 SMALLINT
    DEFINE p_cmd    LIKE type_file.chr1   #a:新增 u:修改  #No.FUN-680136 VARCHAR(1)
 
    IF g_smy.smy57[5,5] != 'Y' THEN RETURN END IF
 
    LET p_row = 8 LET p_col = 24
    OPEN WINDOW t540_m_w AT p_row,p_col WITH FORM "apm/42f/apmt540_m"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt540_m")
 
 
    SELECT pmn71 INTO g_pmn2.pmn71 FROM pmn_file
     WHERE pmn01 = g_pmm.pmm01 AND pmn02 = g_pmn[l_ac].pmn02
 
    INPUT BY NAME g_pmn2.pmn71 WITHOUT DEFAULTS
       AFTER FIELD pmn71
          IF NOT cl_null(g_pmn2.pmn71) THEN
             SELECT coc10 INTO l_coc10 FROM coc_file WHERE coc03=g_pmn2.pmn71
             IF STATUS THEN
                CALL cl_err3("sel","coc_file",g_pmn2.pmn71,"","aco-062","","",1)  #No.FUN-660129
                NEXT FIELD pmn71
             END IF
             SELECT COUNT(*) INTO l_cnt FROM coc_file,coe_file,coa_file
              WHERE coc01 = coe01 AND coe03 = coa03
                AND coa05 = l_coc10
                AND coa01 = g_pmn[l_ac].pmn04
                AND coc03 = g_pmn2.pmn71
             IF l_cnt = 0 THEN
                CALL cl_err(g_pmn2.pmn71,'aco-073',1) NEXT FIELD pmn71  #MOD-640492 0->1
             END IF
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(pmn71)
              CALL q_coc2(FALSE,FALSE,g_pmn2.pmn71,'',g_pmm.pmm04,'1',
                          '',g_pmn[l_ac].pmn04)
              RETURNING g_pmn2.pmn71,l_coc04
              DISPLAY BY NAME g_pmn2.pmn71
              NEXT FIELD pmn71
             OTHERWISE EXIT CASE
          END CASE
 
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0 CLOSE WINDOW t540_m_w RETURN
    END IF
 IF p_cmd = 'u' THEN
    UPDATE pmn_file SET pmn71=g_pmn2.pmn71
     WHERE pmn01=g_pmm.pmm01 AND pmn02=g_pmn[l_ac].pmn02
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","pmn_file",g_pmm.pmm01,g_pmn[l_ac].pmn02,STATUS,"","upd pmn71",1)  #No.FUN-660129
    END IF
 END IF
    CLOSE WINDOW t540_m_w                 #結束畫面
END FUNCTION
 
FUNCTION t540_pmn03()  #詢價單號
 DEFINE  l_pmwacti   LIKE pmw_file.pmwacti
 
  LET g_errno = " "
  SELECT pmwacti INTO l_pmwacti
    FROM pmw_file
   WHERE pmw01 = g_pmn2.pmn03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3051'
                            LET l_pmwacti = NULL
         WHEN l_pmwacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t540_pmn23(p_code)    #check 地址
  DEFINE  p_cmd   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          p_code  LIKE pme_file.pme01,
          l_pme02 LIKE pme_file.pme02,
          l_pmeacti LIKE pme_file.pmeacti
 
  LET g_errno = " "
  SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
   WHERE pme01 = p_code
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012' LET l_pmeacti=NULL
         WHEN l_pmeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t540_pmn25(p_cmd)
   DEFINE l_pml04  LIKE pml_file.pml04,
          l_pml041 LIKE pml_file.pml041,
          l_pml06  LIKE pml_file.pml06,   #FUN-D40042 add
          l_pml07  LIKE pml_file.pml07,
          l_pml16  LIKE pml_file.pml16,
          l_pml12  LIKE pml_file.pml12,
          l_pml20  LIKE pml_file.pml20,
          l_pml33  LIKE pml_file.pml33,
          l_pml34  LIKE pml_file.pml34,
          l_pml38  LIKE pml_file.pml38,   #FUN-690047 add
          l_pml41  LIKE pml_file.pml41,
          l_pml40  LIKE pml_file.pml40,
          l_pml401 LIKE pml_file.pml401,  #FUN-810045 add
          l_pml42  LIKE pml_file.pml42,
          l_pml31  LIKE pml_file.pml31,
          l_pml31t LIKE pml_file.pml31t,  #No.FUN-610018
          l_pml44  LIKE pml_file.pml44,
          l_pml67  LIKE pml_file.pml67,
          l_pml35  LIKE pml_file.pml35,   #No.MOD-5C0113
          l_pmk18  LIKE pmk_file.pmk18,
          l_pmk25  LIKE pmk_file.pmk25,
          l_pmk05  LIKE pmk_file.pmk05,
          l_pmkacti  LIKE pmk_file.pmkacti,
          l_pml80  LIKE pml_file.pml80,
          l_pml81  LIKE pml_file.pml81,
          l_pml82  LIKE pml_file.pml82,
          l_pml83  LIKE pml_file.pml83,
          l_pml84  LIKE pml_file.pml84,
          l_pml85  LIKE pml_file.pml85,
          l_pml86  LIKE pml_file.pml86,
          l_pml87  LIKE pml_file.pml87,
          l_pml88  LIKE pml_file.pml88,
          l_pml88t LIKE pml_file.pml88t,
          l_pml930 LIKE pml_file.pml930  #FUN-670051
   DEFINE l_pml121 LIKE pml_file.pml121, #WBS
          l_pml122 LIKE pml_file.pml122, #活動
          l_pml90  LIKE pml_file.pml90  #費用原因
   DEFINE l_pml192 LIKE pml_file.pml192   #No.FUN-630040
   DEFINE p_cmd    LIKE type_file.chr1                  #MOD-640491  #No.FUN-680136 VARCHAR(1)
   DEFINE l_ecm04  LIKE ecm_file.ecm04        #CHI-8A0022
   DEFINE l_pml190 LIKE pml_file.pml190   #TQC-980279    
   DEFINE l_pml919 LIKE pml_file.pml919   #FUN-A80150 add
#FUN-A60035 ---MARK BEGIN
#   DEFINE l_sql    STRING                 #FUN-A60035 add 
#   DEFINE l_pmn25_t  LIKE pmn_file.pmn25  #FUN-A60035 add
#FUN-A60035 ---MARK END
   DEFINE l_pmn    RECORD LIKE pmn_file.*     #MOD-AB0258 
   DEFINE l_pml123 LIKE pml_file.pml123  #廠牌 #MOD-BA0026 add

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 --- add begin
#&ifdef SLK
#   LET l_pmn25_t = g_pmn[l_ac].pmn25
#   LET l_sql = " SELECT ata03 FROM ata_file ",
#             #  "  WHERE ata00 = '",g_prog,"'",
#             #  "    AND ata01 = '",g_pmm.pmm01,"'",
#             #  "    AND ata02 = '",g_pmn[l_ac].pmn02,"'"
#                "  WHERE ata00 = 'apmt420_slk'",
#                "    AND ata01 = '",g_pmn[l_ac].pmn24,"'",
#                "    AND ata02 = '",g_pmn[l_ac].pmn25,"'"
#   DECLARE t540_ata_curs_c SCROLL CURSOR FROM l_sql
#   FOREACH t540_ata_curs_c INTO g_pmn[l_ac].pmn25
#&endif
##FUN-A60035 --- add end
#FUN-A60035 ---MARK END
 
   LET g_errno = " "
   SELECT pml04,pml041,pml06,pml07,pml16,pml20-pml21,pml33,pml34,pml40,pml401,pml41,pml42,   #FUN-810045 add pml401  #FUN-D40042 add pml06
          pmk18,pmk25,pmkacti,pml31,pml31t,pml44,pml67,pml12,                  #No.FUN-610018   #No.FUN-830161
          pml80,pml81,pml82,pml83,pml84,pml85,pml86,pml87,pml88,pml88t,pml35,  #No.MOD-5C0113
          pml192,pml930,pml38,   #FUN-670051   #FUN-690047 add pml38
          pml121,pml122,pml123,pml90     #FUN-810045 add #MOD-BA0026 add pml123
          ,pml190,pml919                 #TQC-980279 add pml190    #FUN-A80150 add pml919  
     INTO l_pml04,l_pml041,l_pml06,l_pml07,l_pml16,l_pml20,l_pml33,l_pml34,  #FUN-D40042 add pml06
          l_pml40,l_pml401,l_pml41,l_pml42,l_pmk18,l_pmk25,l_pmkacti,    #FUN-810045 add pml401
          l_pml31,l_pml31t,l_pml44,l_pml67,l_pml12,                            #No.FUN-610018   #No.FUN-830161
          l_pml80,l_pml81,l_pml82,l_pml83,l_pml84,l_pml85,l_pml86,l_pml87,
          l_pml88,l_pml88t,l_pml35,l_pml192,   #No.FUN-630040   #No.MOD-5C0113
          l_pml930   #FUN-670051
         ,l_pml38    #FUN-690047 add
         ,l_pml121,l_pml122,l_pml123,l_pml90    #FUN-810045 add #MOD-BA0026 add pml123
         ,l_pml190,l_pml919  #TQC-980279 add pml190     #FUN-A80150 add pml919 
     FROM pml_file,pmk_file
    WHERE pml01 = g_pmn[l_ac].pmn24
      AND pml02 = g_pmn[l_ac].pmn25
      AND pmk01 = pml01
 
   CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'mfg3055'
        WHEN l_pml16 matches'[678]'  LET g_errno = 'mfg3258'
        WHEN l_pml16 = '0'           LET g_errno = 'apm-295' #已開立未確認
        WHEN l_pml16 = '9'           LET g_errno = 'mfg3259' #取消
        WHEN l_pml20 <= 0            LET g_errno = 'apm-201'
        WHEN l_pmk18  ='N'           LET g_errno = 'apm-292' #
        WHEN l_pml190 ='Y'           LET g_errno = 'apm-044'  #TQC-980279 add
        WHEN l_pmk25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
        WHEN l_pmkacti='N'           LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
   LET g_pmn[l_ac].pmn04 = l_pml04
   LET g_pmn2.pmn04 = l_pml04
   CALL t540_pmn04(p_cmd,' ')  #MOD-640491
 
   SELECT ima021 INTO g_pmn[l_ac].ima021
    FROM ima_file
    WHERE ima01=g_pmn[l_ac].pmn04
 
   LET g_pmn[l_ac].pmn041= l_pml041 LET g_pmn2.pmn041= l_pml041
   LET g_pmn[l_ac].pmn07 = l_pml07  LET g_pmn2.pmn07 = l_pml07
   LET g_pmn[l_ac].pmn20 = l_pml20  LET g_pmn2.pmn20 = l_pml20
   LET g_pmn[l_ac].pmn33 = l_pml33  LET g_pmn2.pmn33 = l_pml33
   LET g_pmn[l_ac].pmn34 = l_pml34  LET g_pmn2.pmn34 = l_pml34
   LET g_pmn[l_ac].pmn35 = l_pml35  LET g_pmn2.pmn35 = l_pml35   #CHI-9C0023
   LET g_pmn[l_ac].pmn38 = l_pml38  LET g_pmn2.pmn38 = l_pml38   #FUN-690047 add
   LET g_pmn[l_ac].pmn41 = l_pml41  LET g_pmn2.pmn41 = l_pml41
   LET g_pmn[l_ac].pmn42 = l_pml42  LET g_pmn2.pmn42 = l_pml42
   LET g_pmn[l_ac].pmn100= l_pml06  LET g_pmn2.pmn100= l_pml06   #FUN-D40042 add
   #-----MOD-AB0258---------
   DECLARE t540_x CURSOR FOR 
     SELECT * FROM pmn_file 
      WHERE pmn24 = g_pmn[l_ac].pmn24
        AND pmn25 = g_pmn[l_ac].pmn25
        AND (pmn01 <> g_pmm.pmm01 OR 
             (pmn01 = g_pmm.pmm01 AND pmn02 <> g_pmn[l_ac].pmn02)) 
   FOREACH t540_x INTO l_pmn.*
      CALL s_umfchk(g_pmn[l_ac].pmn04,l_pmn.pmn80,l_pml80)
       RETURNING g_cnt,g_factor
      LET l_pml82 = l_pml82 - l_pmn.pmn82 * g_factor
      LET l_pml82 = s_digqty(l_pml82,l_pml80)        #FUN-910088--add--
      CALL s_umfchk(g_pmn[l_ac].pmn04,l_pmn.pmn83,l_pml83)
       RETURNING g_cnt,g_factor
      LET l_pml85 = l_pml85 - l_pmn.pmn85 * g_factor
      LET l_pml85 = s_digqty(l_pml85,l_pml83)        #FUN-910088--add--
      CALL s_umfchk(g_pmn[l_ac].pmn04,l_pmn.pmn86,l_pml86)
       RETURNING g_cnt,g_factor
      LET l_pml87 = l_pml87 - l_pmn.pmn87 * g_factor
      LET l_pml87 = s_digqty(l_pml87,l_pml86)        #FUN-910088--add--
   END FOREACH
   #-----END MOD-AB0258-----
   LET g_pmn_o.pmn07 = l_pml07
   LET g_pmn_t.pmn07 = l_pml07
   LET g_pmn[l_ac].pmn86 = l_pml86 LET g_pmn2.pmn86 = l_pml86
   LET g_pmn[l_ac].pmn87 = l_pml87 LET g_pmn2.pmn87 = l_pml87
   LET g_pmn[l_ac].pmn919 = l_pml919       #FUN-A80150 add
  #TQC-AC0257 Begin---
  #IF g_azw.azw04 = '2' THEN
  #    CALL s_defprice_A6(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm04,g_pmm.pmm22,
  #                       g_pmm.pmm21,g_pmm.pmm43,g_pmn[l_ac].pmn07,g_pmm.pmmplant)
  #      RETURNING l_pml31,l_pml31t,g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74
  #END IF
  #TQC-AC0257 End-----
 
   LET l_ecm04=' '
   IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
         AND ecm012 =g_pmn[l_ac].pmn012    #No.FUN-A60011
   END IF
   CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                       g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,
                       g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
            RETURNING l_pml31,l_pml31t,
                      g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74  #TQC-AC0257 add
   CALL t540_price_check(l_pml31,l_pml31t)     #MOD-9C0285 ADD
   IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF  #FUN-9C0075 ADD

       IF NOT cl_null(g_errno) THEN
          CALL cl_err('',g_errno,1)
       END IF
   IF cl_null(l_pml31)  THEN LET l_pml31 = 0 END IF
   IF cl_null(l_pml31t) THEN LET l_pml31t= 0 END IF
   LET g_pmn[l_ac].pmn31 = l_pml31  LET g_pmn2.pmn31 = l_pml31
   LET g_pmn[l_ac].pmn31t= l_pml31t    #No.FUN-610018
   LET g_pmn2.pmn31t = l_pml31t         #No.FUN-610018
   LET g_pmn[l_ac].pmn80 = l_pml80 LET g_pmn2.pmn80 = l_pml80
   LET g_pmn[l_ac].pmn81 = l_pml81 LET g_pmn2.pmn81 = l_pml81
   LET g_pmn[l_ac].pmn82 = l_pml82 LET g_pmn2.pmn82 = l_pml82
   LET g_pmn[l_ac].pmn83 = l_pml83 LET g_pmn2.pmn83 = l_pml83
   LET g_pmn[l_ac].pmn84 = l_pml84 LET g_pmn2.pmn84 = l_pml84
   LET g_pmn[l_ac].pmn85 = l_pml85 LET g_pmn2.pmn85 = l_pml85
   #LET g_pmn2.pmn35 = l_pml35   #No.MOD-5C0113   #CHI-9C0023
   LET g_pmn[l_ac].pmn930=l_pml930 #FUN-670051
   IF p_cmd != 'u' THEN
      LET g_pmn[l_ac].pmn90 = l_pml31  LET g_pmn2.pmn90 = l_pml31
   END IF
 
   IF cl_null(l_pml12) THEN LET l_pml12=' ' END IF       #No:8841
 
   LET g_pmn[l_ac].pmn122= l_pml12
   LET g_pmn2.pmn122= l_pml12
   LET g_pmn[l_ac].pmn96  = l_pml121  LET g_pmn2.pmn96  = l_pml121
   LET g_pmn[l_ac].pmn97  = l_pml122  LET g_pmn2.pmn97  = l_pml122
   #MOD-BA0026 add --start--
   #TQC-BB0166 add begin
   IF cl_null(l_pml123) THEN 
      SELECT pmh07 INTO l_pml123 FROM pmh_file
       WHERE pmh01 = g_pmn[l_ac].pmn04 
         AND pmh02 = g_pmm.pmm09
         AND pmh13 = g_pmm.pmm22
         AND pmh21 = " "
         AND pmh22 = '1'
         AND pmh23 = ' '                      
         AND pmhacti = 'Y'
   END IF 
   #TQC-BB0166 add end
   LET g_pmn[l_ac].pmn123  = l_pml123   LET g_pmn2.pmn123  = l_pml123
   SELECT mse02 INTO g_pmn[l_ac].mse02
     FROM mse_file WHERE mse01=l_pml123
   #MOD-BA0026 add --end--
   LET g_pmn[l_ac].pmn98  = l_pml90   LET g_pmn2.pmn98  = l_pml90
   LET g_pmn[l_ac].pmn40 = l_pml40
   LET g_pmn[l_ac].pmn401 = l_pml401  LET g_pmn2.pmn401 = l_pml401
 
   LET g_pmn2.pmn40 = l_pml40
   LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
   CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44
   LET g_pmn[l_ac].pmn67 = l_pml67  #TQC-B60235
   LET g_pmn2.pmn67 = l_pml67
   LET g_pmn2.pmn88 = l_pml88
   LET g_pmn2.pmn88t= l_pml88t
   LET g_pmn2.pmn930= l_pml930 #FUN-670051
   CALL t540_set_pmn930(g_pmn[l_ac].pmn930) RETURNING g_pmn[l_ac].gem02a #FUN-670051
 
   DISPLAY g_pmn[l_ac].pmn04  TO pmn04
   DISPLAY g_pmn[l_ac].pmn041 TO pmn041
   DISPLAY g_pmn[l_ac].ima021 TO ima021
   DISPLAY g_pmn[l_ac].pmn07  TO pmn07
   DISPLAY g_pmn[l_ac].pmn20  TO pmn20
   DISPLAY g_pmn[l_ac].pmn33  TO pmn33
   DISPLAY g_pmn[l_ac].pmn34  TO pmn34
   DISPLAY g_pmn[l_ac].pmn35  TO pmn35   #CHI-9C0023
   DISPLAY g_pmn[l_ac].pmn38  TO pmn38   #FUN-690047 add
   DISPLAY g_pmn[l_ac].pmn41  TO pmn41
   DISPLAY g_pmn[l_ac].pmn42  TO pmn42
   DISPLAY g_pmn[l_ac].pmn31  TO pmn31
   DISPLAY g_pmn[l_ac].pmn122 TO pmn122
   DISPLAY g_pmn[l_ac].pmn80  TO pmn80
   DISPLAY g_pmn[l_ac].pmn81  TO pmn81
   DISPLAY g_pmn[l_ac].pmn82  TO pmn82
   DISPLAY g_pmn[l_ac].pmn83  TO pmn83
   DISPLAY g_pmn[l_ac].pmn84  TO pmn84
   DISPLAY g_pmn[l_ac].pmn85  TO pmn85
   DISPLAY g_pmn[l_ac].pmn86  TO pmn86
   DISPLAY g_pmn[l_ac].pmn87  TO pmn87
   DISPLAY g_pmn[l_ac].pmn930 TO pmn930  #FUN-670051
   DISPLAY g_pmn[l_ac].pmn90  TO pmn90   #CHI-690043 add
   DISPLAY BY NAME g_pmn[l_ac].pmn122,g_pmn[l_ac].pmn96,
                   g_pmn[l_ac].pmn97 ,g_pmn[l_ac].pmn98
   DISPLAY g_pmn[l_ac].pmn100 TO pmn100  #FUN-D40042 add
   #MOD-BA0026 add --start--
   DISPLAY g_pmn[l_ac].mse02 TO FORMONLY.mse02
   DISPLAY BY NAME g_pmn[l_ac].pmn123  
   #MOD-BA0026 add --end--
   
   DROP TABLE x
 
   SELECT * FROM pmo_file    #特殊說明檔
    WHERE pmo01 = g_pmn[l_ac].pmn24
      AND pmo03 = g_pmn[l_ac].pmn25
     INTO TEMP x
 
   UPDATE x SET pmo01 = g_pmm.pmm01,
                pmo02 = '1',
                pmo03 = g_pmn[l_ac].pmn02
 
   INSERT INTO pmo_file SELECT * FROM x

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 --- add begin
#&ifdef SLK
#   END FOREACH
#   LET g_pmn[l_ac].pmn25 = l_pmn25_t
#&endif
##FUN-A60035 --- add end
#FUN-A60035 ---MARK END
 
END FUNCTION
 
FUNCTION t540_pmn68()
  SELECT * INTO g_pom.* FROM pom_file
   WHERE pom01 = g_pmn[l_ac].pmn68
  CASE WHEN STATUS = 100                    LET g_errno = 'apm-902'   #No.MOD-4A0356
       WHEN g_pom.pom25 MATCHES '[678]'     LET g_errno = 'mfg3258'
       WHEN g_pom.pom25 = '9'               LET g_errno = 'mfg3259'
       WHEN g_pom.pom25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
       WHEN g_pom.pom18 = 'N'               LET g_errno = 'apm-292'
       OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION


#No.FUN-A60011  --Begin
FUNCTION t540_pmn012(p_cmd)         
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_sfb06         LIKE sfb_file.sfb06
DEFINE l_ecuacti       LIKE ecu_file.ecuacti
DEFINE l_ecu10         LIKE ecu_file.ecu10
DEFINE l_ecu014        LIKE ecu_file.ecu014
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_flag          LIKE type_file.num5   #TQC-AC0374
DEFINE l_sfb05         LIKE sfb_file.sfb05   #TQC-AC0374
DEFINE l_sfb02         LIKE sfb_file.sfb02   #TQC-B90049

   LET g_errno = ' '
  #FUN-B10056------------mark start-------- 
  #SELECT sfb06 INTO l_sfb06 FROM sfb_file
  # WHERE sfb01 = g_pmn[l_ac].pmn41
  #IF SQLCA.sqlcode THEN
  #   LET g_errno = SQLCA.SQLCODE USING '-------'
  #   RETURN
  #END IF
  #FUN-B10056 -----------mark end----------
   
   CALL s_schdat_sel_ima571(g_pmn[l_ac].pmn41) RETURNING l_flag,l_sfb05  #TQC-AC0374
  #FUN-B10056 ------------mark start------
  #SELECT ecu014,ecu10,ecuacti INTO l_ecu014,l_ecu10,l_ecuacti
  #  FROM ecu_file
  # WHERE ecu01 = l_sfb05    #TQC-AC0374
  #   AND ecu02 = l_sfb06
  #   AND ecu012= g_pmn[l_ac].pmn012
  #
  #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
  #                               LET l_ecu014 = NULL
  #     WHEN l_ecuacti='N'        LET g_errno = '9028'
  #     WHEN l_ecu10 <> 'Y'       LET g_errno = '9029'
  #     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  #END CASE
  #
  #IF NOT cl_null(g_errno) THEN RETURN END IF
  #
  #SELECT COUNT(*) INTO l_cnt FROM ecm_file
  # WHERE ecm01 = g_pmn[l_ac].pmn41
  #   AND ecm012= g_pmn[l_ac].pmn012
  #IF l_cnt = 0 THEN
  #   LET g_errno = 'aec-311'
  #   RETURN
  #ELSE
  #   IF SQLCA.sqlcode <> 0 THEN
  #      LET g_errno = SQLCA.SQLCODE USING '-------'
  #   END IF
  #END IF
  #FUN-B10056 ----------mark end-------------------------
   
#TQC-B90049 --begin--
   LET l_sfb02 = NULL 
   SELECT sfb02 INTO l_sfb02 FROM sfb_file
    WHERE sfb01 = g_pmn[l_ac].pmn41
  #IF l_sfb02 <> '7' OR l_sfb02 <>'8' THEN #MOD-D30183 mark 
   IF l_sfb02 <> 7 AND l_sfb02 <> 8 THEN   #MOD-D30183 add 
#TQC-B90049 --end--  
      IF NOT s_schdat_ecm012(g_pmn[l_ac].pmn41,g_pmn[l_ac].pmn012) THEN      #FUN-B10056
         LET g_errno = 'aec-311'                                             #FUN-B10056
         RETURN                                                              #FUN-B10056 
      END IF                                                                 #FUN-B10056 
      CALL s_schdat_ecm014(g_pmn[l_ac].pmn41,g_pmn[l_ac].pmn012) RETURNING l_ecu014    #FUN-B10056 
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_pmn[l_ac].ecu014 = l_ecu014
      END IF
   END IF   #TQC-B90049 

END FUNCTION
#No.FUN-A60011  --End  

FUNCTION t540_pmn72(p_cmd)         
DEFINE    l_rtaacti  LIKE rta_file.rtaacti, 
          l_rta01    LIKE rta_file.rta01, 
          l_rta03    LIKE rta_file.rta03,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT rta01,rta03,rtaacti INTO l_rta01,l_rta03,l_rtaacti FROM rta_file
     WHERE rta05=g_pmn[l_ac].pmn72
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-189' 
                                 LET l_rta01=NULL 
                                 LET l_rta03=NULL
        WHEN l_rtaacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_pmn[l_ac].pmn04 = l_rta01
     LET g_pmn[l_ac].pmn07 = l_rta03
     DISPLAY BY NAME g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07
  END IF
 
END FUNCTION
 
FUNCTION t540_pmn04(p_cmd,p_no)  #料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima39   LIKE ima_file.ima39,
           l_ima391  LIKE ima_file.ima391,  #No.FUN-680029
           l_ima140  LIKE ima_file.ima140,
           l_ima1401 LIKE ima_file.ima1401, #FUN-6A0036
           l_imaacti LIKE ima_file.imaacti,
           p_no      LIKE gsb_file.gsb05,   #No.FUN-680136 VARCHAR(04)
           p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    DEFINE l_ima08   LIKE ima_file.ima08  #FUN-810038
    DEFINE l_pmh24   LIKE pmh_file.pmh24  #FUN-940083
    DEFINE l_pmc914  LIKE pmc_file.pmc914 #FUN-940083
 
 
  LET g_errno = " "
  SELECT ima02,ima021,ima39,ima391,ima49,ima491,ima140,ima1401,imaacti  #No:7225 #No.FUN-680029 add ima391  #FUN-6A0036(ima1401)
         INTO l_ima02,l_ima021,l_ima39,l_ima391,g_ima49,g_ima491,l_ima140,l_ima1401,l_imaacti #No.FUN-680029 add l_ima391  #FUN-6A0036(ima1401)
    FROM ima_file
         WHERE ima01 = g_pmn[l_ac].pmn04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
                                 LET l_ima021=NULL
       WHEN l_imaacti='N'        LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       WHEN l_ima140 = 'Y'  AND l_ima1401 <= g_pmm.pmm04   #FUN-6A0036
        LET g_errno = 'apm-006' #No:7225
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
 
  #MISC料無效時不可用於請/採購
  IF g_pmn[l_ac].pmn04[1,4]='MISC' AND g_errno<>'9028' THEN
     LET g_errno=''
  END IF
  #IF g_pmn[l_ac].pmn04[1,4] = 'MISC' AND NOT cl_null(g_pmn[l_ac].pmn041) THEN   #MOD-AB0207
  IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN   #MOD-AB0207
      IF NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25) THEN
          SELECT pml041 INTO l_ima02 FROM pml_file
           WHERE pml01 = g_pmn[l_ac].pmn24
             AND pml02 = g_pmn[l_ac].pmn25
      END IF
  END IF
  IF cl_null(g_pmn_o.pmn04) OR g_pmn[l_ac].pmn04 <> g_pmn_o.pmn04 THEN #MOD-BA0002 add
     LET g_pmn[l_ac].pmn041= l_ima02     #NO:6808 IF拿掉
     LET g_pmn2.pmn041     = l_ima02
     DISPLAY g_pmn[l_ac].pmn041 TO pmn041
 
     LET g_pmn[l_ac].ima021= l_ima021
     DISPLAY g_pmn[l_ac].ima021 TO ima021
 
     #-----MOD-A60003---------
     #IF g_pmn[l_ac].pmn04[1,4] <> 'MISC' AND cl_null(g_pmn2.pmn40) THEN  #MOD-640491   
     IF g_pmn[l_ac].pmn04[1,4] <> 'MISC' AND 
        (cl_null(g_pmn2.pmn40) OR g_pmn[l_ac].pmn04 <> g_pmn_o.pmn04) THEN     
     #-----END MOD-A60003-----
#TQC-A70114 --modify
        LET g_pmn2.pmn40 = l_ima39   #MOD-A60003  取消mark
        LET g_pmn[l_ac].pmn40 = l_ima39
#TQC-A70114  --end
     END IF
     IF g_aza.aza63 = 'Y' THEN
        #-----MOD-A60003---------
        #IF g_pmn[l_ac].pmn04[1,4] <> 'MISC' AND cl_null(g_pmn2.pmn401) THEN  #MOD-640491   
        IF g_pmn[l_ac].pmn04[1,4] <> 'MISC' AND 
           (cl_null(g_pmn2.pmn401) OR g_pmn[l_ac].pmn04 <> g_pmn_o.pmn04) THEN     
        #-----END MOD-A60003-----
#TQC-A70114 --modify
           LET g_pmn2.pmn401 = l_ima391   #MOD-A60003  取消mark
           LET g_pmn[l_ac].pmn401 = l_ima391
#TQC-A70114 --end
        END IF
     END IF
  END IF  #MOD-BA0002 add
  IF cl_null(g_ima49) THEN LET g_ima49 = 0 END IF
  IF cl_null(g_ima491) THEN LET g_ima491 = 0 END IF
 
  IF cl_null(g_errno) THEN
     SELECT pmh24 INTO l_pmh24 
       FROM pmh_file  
      WHERE pmh01 = g_pmn[l_ac].pmn04 
        AND pmh02 = g_pmm.pmm09
        AND pmh13 = g_pmm.pmm22
        AND pmh21 = " "
        AND pmh22 = '1'
        AND pmh23 = ' '                      #No.CHI-960033
        AND pmhacti = 'Y'
       IF NOT cl_null(l_pmh24) THEN
          LET g_pmn[l_ac].pmn89=l_pmh24
       ELSE
          IF g_sma.sma93="Y" THEN                        #MOD-C30578 add 
             SELECT pmc914 INTO l_pmc914 FROM pmc_file 
              WHERE pmc01 = g_pmm.pmm09 
             IF l_pmc914 = 'Y' THEN
                LET g_pmn[l_ac].pmn89 = 'Y'
             ELSE
                LET g_pmn[l_ac].pmn89 = 'N'
             END IF
          END IF                                         #MOD-C30578 add
       END IF
       DISPLAY g_pmn[l_ac].pmn89 TO pmn89
  END IF
 
END FUNCTION
 
FUNCTION t540_update()
    DEFINE l_tot_pmm40   LIKE pmm_file.pmm40,
           l_tot_pmm40t  LIKE pmm_file.pmm40t      #No.FUN-610018
    SELECT SUM(pmn88),SUM(pmn88t)                  #No.TQC-620024 add
      INTO l_tot_pmm40,l_tot_pmm40t                #No.FUN-610018
      FROM pmn_file
     WHERE pmn01 = g_pmm.pmm01
    IF SQLCA.sqlcode OR l_tot_pmm40 IS NULL THEN
       LET l_tot_pmm40 = 0
       LET l_tot_pmm40t= 0   #No.FUN-610018
    END IF
    SELECT azi04 INTO t_azi04 FROM azi_file  #No.CHI-6A0004
     WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'
    CALL cl_digcut(l_tot_pmm40,t_azi04) RETURNING l_tot_pmm40  #No.CHI-6A0004
    CALL cl_digcut(l_tot_pmm40t,t_azi04) RETURNING l_tot_pmm40t  #No.FUN-610018  #No.CHI-6A0004
 
    UPDATE pmm_file SET pmm40 = l_tot_pmm40,  #未稅總金額
                        pmm40t= l_tot_pmm40t  #FUN-610018 含稅總金額
     WHERE pmm01 = g_pmm.pmm01
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","update pmm40 fail :",1)  #No.FUN-660129
       LET g_success = 'N'
    END IF
    DISPLAY l_tot_pmm40 TO pmm40
    DISPLAY l_tot_pmm40t TO pmm40t   #No.FUN-610018
    LET g_pmm.pmm40 = l_tot_pmm40    #MOD-B30413 add
    LET g_pmm.pmm40t = l_tot_pmm40t  #MOD-B30413 add
#FUN-B90103--add--------begin------------
#FUN-B90103------------end-------------- 
END FUNCTION
 
FUNCTION t540_pmm40_show()
    DEFINE l_tot_pmm40   LIKE pmm_file.pmm40,
           l_tot_pmm40t  LIKE pmm_file.pmm40t
 
    SELECT pmm40,pmm40t
      INTO l_tot_pmm40,l_tot_pmm40t
      FROM pmm_file
     WHERE pmm01 = g_pmm.pmm01
    DISPLAY l_tot_pmm40 TO pmm40
    DISPLAY l_tot_pmm40t TO pmm40t
END FUNCTION
 
#料件輸入完後
FUNCTION t540_def()
  DEFINE  l_imaacti  LIKE ima_file.imaacti,
          l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima44    LIKE ima_file.ima44,
          l_pmh21    LIKE pmh_file.pmh21,   #No.CHI-8C0017
          l_pmh22    LIKE pmh_file.pmh22    #No.CHI-8C0017          
 
  LET g_errno = " "
#來源料件主檔的預設值 (版本/採購單位/庫存單位/OPC/再補貨量)
  SELECT ima05,ima44,ima25,ima37,ima99,imaacti,ima02,ima15,ima021,ima44, #NO:5074
         ima35,ima36  #CHI-9C0025
    INTO g_pmn2.pmn05,g_pmn2.pmn07,g_pmn2.pmn08,g_ima37,g_ima99,l_imaacti,l_ima02,g_pmn2.pmn64,l_ima021,l_ima44
         ,g_ima35,g_ima36   #CHI-9C0025
    FROM ima_file
   WHERE ima01=g_pmn[l_ac].pmn04
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
#TQC-AB0044  --mark
#  #No.FUN-AA0049--begin
#  IF NOT s_chk_ware(g_ima35) THEN
#     LET g_ima35=' '
#     LET g_ima36=' '
#  END IF 
#  #No.FUN-AA0049--end
#TQC-AB0044  --end        
   IF NOT cl_null(g_errno) THEN RETURN END IF
   IF g_pmm.pmm02='SUB' THEN
       LET g_pmn2.pmn07 = l_ima44 #自行輸入委外採購單,應用採購單位
   END IF
   IF cl_null(g_pmn[l_ac].pmn24) AND  cl_null(g_pmn[l_ac].pmn25) THEN #MOD-790079 add
     LET g_pmn[l_ac].pmn07 = g_pmn2.pmn07
   END IF   #MOD-790079
   DISPLAY g_pmn[l_ac].pmn07 TO pmn07
    LET g_pmn[l_ac].pmn63 = g_pmn2.pmn63  #MOD-530449
    DISPLAY g_pmn[l_ac].pmn63 TO pmn63    #MOD-530449
   LET g_pmn[l_ac].pmn64 = g_pmn2.pmn64
   DISPLAY g_pmn[l_ac].pmn64 TO pmn64
 
#來源料件/供廠商對應檔的預設值(廠商料件)
   IF g_pmm.pmm02='SUB' THEN
      LET l_pmh22='2'
      IF g_pmn2.pmn43 = 0 OR cl_null(g_pmn2.pmn43) THEN  
         LET l_pmh21 =' '
      ELSE
        IF NOT cl_null(g_pmn2.pmn18) THEN
         SELECT sgm04 INTO l_pmh21 FROM sgm_file
          WHERE sgm01=g_pmn2.pmn18
            AND sgm02=g_pmn2.pmn41
            AND sgm03=g_pmn2.pmn43
            AND sgm012 = g_pmn2.pmn012  #No.FUN-A60076
        ELSE
         SELECT ecm04 INTO l_pmh21 FROM ecm_file 
          WHERE ecm01=g_pmn2.pmn41
            AND ecm03=g_pmn2.pmn43
            AND ecm012=g_pmn2.pmn012    #No.FUN-A60011
        END IF     
      END IF                #NO.TQC-910033     
   ELSE
      LET l_pmh22='1'
      LET l_pmh21=' '
   END IF
   SELECT pmh04,pmh07 INTO g_pmn2.pmn06,g_pmn2.pmn123 FROM pmh_file   #No.MOD-580207
    WHERE pmh01 = g_pmn[l_ac].pmn04 AND pmh02 = g_pmm.pmm09
      AND pmh13 = g_pmm.pmm22
      AND pmh21 = l_pmh21 AND pmh22 = l_pmh22                         #CHI-8C0017
      AND pmh23 = ' '                                                 #No.CHI-960
      AND pmhacti = 'Y'                                               #CHI-910021      
   IF cl_null(g_pmn[l_ac].pmn24) AND  cl_null(g_pmn[l_ac].pmn25) THEN #MOD-BA0026 add
      #-----MOD-AC0145---------
      LET g_pmn[l_ac].pmn123 = g_pmn2.pmn123   
      SELECT mse02 INTO g_pmn[l_ac].mse02
        FROM mse_file WHERE mse01=g_pmn[l_ac].pmn123
      DISPLAY g_pmn[l_ac].mse02 TO FORMONLY.mse02
      DISPLAY BY NAME g_pmn[l_ac].pmn123  
      #-----END MOD-AC0145-----
   END IF #MOD-BA0026 add
 
#來源料件/供廠商對應檔的預設值(超短交限率)
   CALL s_overate(g_pmn[l_ac].pmn04) RETURNING g_pmn2.pmn13
 
#來源料件/供廠商對應檔的預設值(標準價格)
   SELECT imb118 INTO g_pmn2.pmn30 FROM imb_file
                WHERE imb01 = g_pmn[l_ac].pmn04
END FUNCTION
 
FUNCTION t540_unit(p_unit)  #單位
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION  t561()
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 LET p_row = 3 LET p_col = 44
 OPEN WINDOW t561_w AT p_row,p_col
             WITH FORM "apm/42f/apmt561"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt561")

 #-----CHI-AB0006---------
 IF cl_null(g_pmn2.pmn40) THEN
    SELECT ima39 INTO g_pmn2.pmn40 FROM ima_file
      WHERE ima01 = g_pmn[l_ac].pmn04
 END IF
 #-----END CHI-AB0006-----
 
 
 INPUT BY NAME g_pmn2.pmn40
        WITHOUT DEFAULTS
    AFTER FIELD pmn40                      #會計科目
       IF NOT cl_null(g_pmn2.pmn40) THEN
          IF g_sma.sma03='Y' THEN
             IF NOT s_actchk3(g_pmn2.pmn40,g_bookno1) THEN  #No.FUN-730033
#FUN-B10052 --begin--            
#                CALL cl_err(g_pmn2.pmn40,'mfg0018',1)  #MOD-640492 0->1
#                LET g_pmn2.pmn40 = g_pmn_o.pmn40
                 CALL cl_err(g_pmn2.pmn40,'mfg0018',0)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.default1 = g_pmn2.pmn40
                    LET g_qryparam.arg1 = g_bookno1   
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2' AND aag01 LIKE '",g_pmn2.pmn40 CLIPPED,"%'"
                    CALL cl_create_qry() RETURNING g_pmn2.pmn40
                    DISPLAY BY NAME g_pmn2.pmn40
#FUN-B10052 --end--                
                NEXT FIELD pmn40
             END IF
          END IF
       END IF
       LET g_pmn_o.pmn40 = g_pmn2.pmn40
       LET g_pmn[l_ac].pmn40 = g_pmn2.pmn40 #MOD-D10091 add
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(pmn40) #會計科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.default1 = g_pmn2.pmn40
                    LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 = '2' "
                    CALL cl_create_qry() RETURNING g_pmn2.pmn40
 
             DISPLAY BY NAME g_pmn2.pmn40
             NEXT FIELD pmn40
             OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    AFTER INPUT
       IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          EXIT INPUT
       END IF
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
 END INPUT
 CLOSE WINDOW t561_w
END FUNCTION
 
FUNCTION  t562()
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE  p_cmd    LIKE type_file.chr1    #No.FUN-540027  #No.FUN-680136 VARCHAR(1)
  DEFINE  l_pml07  LIKE pml_file.pml07
 
 
 LET p_row = 3 LET p_col = 40
 OPEN WINDOW t562_w AT p_row,p_col
     WITH FORM "apm/42f/apmt562"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt562")
 
 
    SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_pmn2.pmn04
    CALL t562_def_form()
 
  INPUT BY NAME g_pmn2.pmn07,g_pmn2.pmn83,g_pmn2.pmn80,
                g_pmn2.pmn08,g_pmn2.pmn09
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            CALL t540_set_entry_b(p_cmd)
            CALL t540_set_no_entry_b(p_cmd)
            CALL t540_set_no_required()
            CALL t540_set_required()
 
        AFTER FIELD pmn83  #第二單位
            IF NOT cl_null(g_pmn2.pmn83) THEN
                IF (g_pmn_o.pmn83 IS NULL ) OR
                   (g_pmn2.pmn83 != g_pmn_o.pmn83) THEN
                    CALL t540_unit(g_pmn2.pmn83)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmn2.pmn83,g_errno,1)  #MOD-640492 0->1
                        LET g_pmn2.pmn83 = g_pmn_o.pmn83
                        DISPLAY BY NAME g_pmn2.pmn83
                        NEXT FIELD pmn83
                    END IF
                END IF
                LET g_pmn_o.pmn83  = g_pmn2.pmn83
             END IF
 
        AFTER FIELD pmn80  #第一單位
            IF NOT cl_null(g_pmn2.pmn80) THEN
                IF (g_pmn_o.pmn80 IS NULL ) OR
                   (g_pmn2.pmn80 != g_pmn_o.pmn80) THEN
                    CALL t540_unit(g_pmn2.pmn80)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmn2.pmn80,g_errno,1) #MOD-640492 0->1
                        LET g_pmn2.pmn80 = g_pmn_o.pmn80
                        DISPLAY BY NAME g_pmn2.pmn80
                        NEXT FIELD pmn80
                    END IF
                END IF
                LET g_pmn_o.pmn80  = g_pmn2.pmn80
             END IF
 
        AFTER FIELD pmn07  #採購單位,須存在
            IF NOT cl_null(g_pmn2.pmn07) THEN
               IF (g_pmn_o.pmn07 IS NULL )
                   OR (g_pmn2.pmn07 != g_pmn_o.pmn07) THEN
                  CALL t540_unit(g_pmn2.pmn07)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pmn2.pmn07,g_errno,1)  #MOD-640492 0->1
                     LET g_pmn2.pmn07 = g_pmn_o.pmn07
                     DISPLAY BY NAME g_pmn2.pmn07
                     NEXT FIELD pmn07
                  END IF
               END IF
               IF NOT cl_null(g_pmn[l_ac].pmn25) THEN        #增加請購單位判斷
                  SELECT pml07 INTO l_pml07 FROM pml_file
                   WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
                  CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn2.pmn07,l_pml07)
                  RETURNING l_flag,g_pmn2.pmn121
                  IF l_flag THEN
                     ### -------單位換算率抓不到 ----###
                     CALL cl_err('pmn07/pml07: ','abm-731',1)
                     NEXT FIELD pmn07
                     LET g_pmn2.pmn121=1
                  END IF
                  LET g_pmn[l_ac].pmn20=g_pmn[l_ac].pmn20*g_pmn2.pmn121
                  LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #FUN-910088--add--
               END IF
               IF (g_pmn2.pmn07 != g_pmn_o.pmn07 AND
                  g_pmn2.pmn08 IS NOT NULL ) THEN
                  CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn2.pmn07,g_pmn2.pmn08)
                  RETURNING l_flag,g_pmn2.pmn09
                  IF l_flag THEN
                     CALL cl_err(g_pmn2.pmn07,'mfg1206',1) #MOD-640492 0->1
                     LET g_pmn2.pmn07 = g_pmn_o.pmn07
                     DISPLAY BY NAME g_pmn2.pmn07
                     LET g_pmn2.pmn09 = g_pmn_o.pmn09
                     DISPLAY BY NAME g_pmn2.pmn09
                     NEXT FIELD pmn07
                  END IF
                  DISPLAY BY NAME g_pmn2.pmn09
               END IF
            END IF
            LET g_pmn_o.pmn07 = g_pmn2.pmn07
 
        BEFORE FIELD pmn09         #採購對庫存轉換率
           IF g_sma.sma115 = 'Y' THEN
             IF cl_null(g_pmn2.pmn80) AND cl_null(g_pmn2.pmn83) THEN
                NEXT FIELD pmn80
             END IF
             CALL t540_set_pmn07() RETURNING l_flag
             IF l_flag THEN
               CALL cl_err(g_pmn2.pmn07,'mfg1206',1)  #MOD-640492 0->1
               LET g_pmn2.pmn07 = g_pmn_o.pmn07
               LET g_pmn2.pmn83 = g_pmn_o.pmn83
               LET g_pmn2.pmn80 = g_pmn_o.pmn80
               DISPLAY BY NAME g_pmn2.pmn07
               DISPLAY BY NAME g_pmn2.pmn83
               DISPLAY BY NAME g_pmn2.pmn80
               LET g_pmn2.pmn09 = g_pmn_o.pmn09
               DISPLAY BY NAME g_pmn2.pmn09
               NEXT FIELD pmn80
             ELSE
                LET g_pmn_o.pmn07  = g_pmn2.pmn07
             END IF
           END IF
 
       AFTER FIELD pmn09         #採購對庫存轉換率
            IF NOT cl_null(g_pmn2.pmn09) THEN
                IF g_pmn2.pmn09 <= 0 THEN
                    CALL cl_err(g_pmn2.pmn09,'mfg0013',1)  #MOD-640492 0->1
                    LET g_pmn2.pmn09 = g_pmn_o.pmn09
                    DISPLAY g_pmn2.pmn09 TO pmn09
                    NEXT FIELD pmn09
                END IF
            END IF
            LET g_pmn_o.pmn09  = g_pmn2.pmn09
 
       ON ACTION unit_data
                 LET g_cmd = 'aooi101 '
                 CALL cl_cmdrun(g_cmd)
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmn07) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_pmn2.pmn07
                    CALL cl_create_qry() RETURNING g_pmn2.pmn07
 
                  DISPLAY BY NAME g_pmn2.pmn07
                  NEXT FIELD pmn07
               WHEN INFIELD(pmn83) #第二單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pmn2.pmn83
                  CALL cl_create_qry() RETURNING g_pmn2.pmn83
                  DISPLAY BY NAME g_pmn2.pmn83
                  NEXT FIELD pmn83
               WHEN INFIELD(pmn80) #第一單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pmn2.pmn80
                  CALL cl_create_qry() RETURNING g_pmn2.pmn80
                  DISPLAY BY NAME g_pmn2.pmn80
                  NEXT FIELD pmn80
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION item_unit_conversion
                 LET g_cmd = 'aooi103 '
                 CALL cl_cmdrun(g_cmd)
 
       ON ACTION unit_conversion
           CASE
              WHEN INFIELD(pmn07) #單位換算資料
                 LET g_cmd = 'aooi102 '
                 CALL cl_cmdrun(g_cmd)
              OTHERWISE EXIT CASE
           END CASE
 
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
            CALL cl_cmdask()
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
        LET l_flag = 'N'
        IF cl_null(g_pmn2.pmn07) THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pmn2.pmn07
        END IF
        IF g_sma.sma115 = 'Y' THEN
           IF cl_null(g_pmn2.pmn83) AND cl_null(g_pmn2.pmn80) THEN
              LET l_flag = 'Y'
              DISPLAY BY NAME g_pmn2.pmn80
              DISPLAY BY NAME g_pmn2.pmn83
           END IF
        END IF
        IF cl_null(g_pmn2.pmn09) OR g_pmn2.pmn09 <= 0 THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pmn2.pmn09
        END IF
        IF l_flag = 'Y' THEN CALL cl_err('','9033',1)  #MOD-640492 0->1
           IF g_sma.sma115 = 'N' THEN
              NEXT FIELD pmn07
           ELSE
              NEXT FIELD pmn80
           END IF
        END IF
        LET g_pmn[l_ac].pmn07 = g_pmn2.pmn07
        LET g_pmn[l_ac].pmn80 = g_pmn2.pmn80
        LET g_pmn[l_ac].pmn83 = g_pmn2.pmn83
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
 END INPUT
 CLOSE WINDOW t562_w
END FUNCTION
 
FUNCTION  t563()
  DEFINE  l_ima53   LIKE ima_file.ima53,
          l_ima531  LIKE ima_file.ima531,
          l_flag    LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 LET p_row = 3 LET p_col = 55
 OPEN WINDOW t563_w AT p_row,p_col
      WITH FORM "apm/42f/apmt563"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt563")
 
 
 SELECT ima49,ima491,ima53,ima531
           INTO g_ima49,g_ima491,l_ima53,l_ima531
                FROM ima_file
           WHERE ima01 =  g_pmn[l_ac].pmn04
 IF cl_null(l_ima53) THEN LET l_ima53 = 0 END IF
 IF cl_null(l_ima531) THEN LET l_ima531 = 0 END IF
 DISPLAY l_ima53 TO FORMONYL.ima53
 DISPLAY l_ima531 TO FORMONYL.ima531

#MOD-C60179 mark beg---- 
# INPUT BY NAME g_pmn2.pmn44,g_pmn2.pmn30
#        WITHOUT DEFAULTS
# 
#    BEFORE INPUT
#       DISPLAY l_ima53 TO ima53
#       DISPLAY l_ima531 TO ima531
#MOD-C60179 mark end----
 #MOD-C60179 add begin----------
 MENU ""
    BEFORE MENU
       DISPLAY BY NAME g_pmn2.pmn44,g_pmn2.pmn30
       DISPLAY l_ima53 TO ima53
       DISPLAY l_ima531 TO ima531
 #MOD-C60179 add end------------  
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      #CONTINUE INPUT #MOD-C60179
       CONTINUE MENU   #MOD-C60179
 
    ON ACTION about         
       CALL cl_about()     
 
    ON ACTION help          
       CALL cl_show_help() 
 
    ON ACTION controlg      
       CALL cl_cmdask()     
#MOD-C60179 add begin----------
    ON ACTION exit
       EXIT MENU

    ON ACTION close
       EXIT MENU
#MOD-C60179 add end------------ 
# END INPUT  MOD-C60179
 END MENU #MOD-C60179 
 CLOSE WINDOW t563_w
END FUNCTION
 
FUNCTION  t564(p_cmd)       #No.MOD-620088 modify
 DEFINE  l_qty     LIKE pmn_file.pmn20,
         l_flag1   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         g_flag,l_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         g_pmn14_t   LIKE pmn_file.pmn14,
         g_pmn15_t   LIKE pmn_file.pmn15,
         g_pmn33_t   LIKE pmn_file.pmn33,
         g_pmn34_t   LIKE pmn_file.pmn34,
         g_pmn35_t   LIKE pmn_file.pmn35,
         g_pmn36_t   LIKE pmn_file.pmn36,
         g_pmn37_t   LIKE pmn_file.pmn37,
         p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
 
         g_date    LIKE type_file.dat     #No.FUN-680136 DATE
DEFINE   li_result   LIKE type_file.num5  #NO.CHI-690066 add SMALLINT
 
  CALL t540_pmn04('a',g_no)  #MOD-570246                                                                                 
 LET p_row = 3 LET p_col = 55
 OPEN WINDOW t564_w AT p_row,p_col
      WITH FORM "apm/42f/apmt564"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt564")
     LET g_pmn14_t = g_pmn2.pmn14
     LET g_pmn15_t = g_pmn2.pmn15
     LET g_pmn33_t = g_pmn2.pmn33
     LET g_pmn34_t = g_pmn2.pmn34
     LET g_pmn35_t = g_pmn2.pmn35
     LET g_pmn36_t = g_pmn2.pmn36
     LET g_pmn37_t = g_pmn2.pmn37
 
 
 INPUT BY NAME   g_pmn2.pmn14,g_pmn2.pmn15,
                 g_pmn2.pmn33,g_pmn2.pmn34,g_pmn2.pmn35,
                 g_pmn2.pmn36,g_pmn2.pmn37
                 WITHOUT DEFAULTS
 
        AFTER FIELD pmn33    #交貨日期
            IF cl_null(g_pmn2.pmn33) THEN
               IF NOT cl_null(g_pmn2.pmn34) THEN #依到廠日推出交貨日
                  LET g_pmn2.pmn33 = g_pmn2.pmn34 - g_ima49
                  DISPLAY BY NAME g_pmn2.pmn33
               ELSE
                  IF NOT cl_null(g_pmn2.pmn35) THEN
                     LET g_pmn2.pmn34 = g_pmn2.pmn35 - g_ima491
                     LET g_pmn2.pmn33 = g_pmn2.pmn34 - g_ima49
                     DISPLAY BY NAME g_pmn2.pmn33,g_pmn2.pmn34
 
                  END IF
               END IF
            END IF
            LET li_result = 0
            CALL s_daywk(g_pmn[l_ac].pmn33) RETURNING li_result
            IF li_result = 0 THEN      #0:非工作日
               CALL cl_err(g_pmn[l_ac].pmn33,'mfg3152',1)
            END IF
            IF li_result = 2 THEN      #2:未設定
               CALL cl_err(g_pmn[l_ac].pmn33,'mfg3153',1)
            END IF
 
            IF g_pmn_o.pmn33 IS NULL OR g_pmn_o.pmn33 != g_pmn2.pmn33 THEN
               LET g_pmn2.pmn34 = g_pmn2.pmn33 + g_ima49
               LET g_pmn2.pmn35 = g_pmn2.pmn34 + g_ima491
               DISPLAY BY NAME g_pmn2.pmn34,g_pmn2.pmn35
 
            END IF
            LET g_pmn_o.pmn33 = g_pmn2.pmn33
 
        AFTER FIELD pmn34     #到廠日期
            IF NOT cl_null(g_pmn2.pmn34) THEN
               CALL s_wkday(g_pmn2.pmn34) RETURNING g_flag,g_date
               IF cl_null(g_date) THEN
                  NEXT FIELD pmn34
               ELSE
                  LET g_pmn2.pmn34 = g_date
                  DISPLAY BY NAME g_pmn2.pmn34
               END IF
               IF g_pmn2.pmn34 < g_pmn2.pmn33 THEN #到庫日不可小於到廠日
                  LET g_pmn2.pmn34 = g_pmn_o.pmn34
                  DISPLAY BY NAME g_pmn2.pmn34
                  CALL cl_err(g_pmn2.pmn34,'mfg3225',1)  #MOD-640492 0->1
                  NEXT FIELD pmn34
               END IF
            ELSE
               LET g_pmn2.pmn34 = g_pmn2.pmn33 + g_ima49
               DISPLAY BY NAME g_pmn2.pmn34
            END IF
            IF g_pmn_o.pmn34 IS NULL OR g_pmn_o.pmn34 != g_pmn2.pmn34 THEN
               LET g_pmn2.pmn35 = g_pmn2.pmn34 + g_ima491
               DISPLAY BY NAME g_pmn2.pmn35
            END IF
            LET g_pmn_o.pmn34 = g_pmn2.pmn34
 
        AFTER FIELD pmn35    #入庫日期
            IF NOT cl_null(g_pmn2.pmn35) THEN
               CALL s_wkday(g_pmn2.pmn35) RETURNING g_flag,g_date
               IF cl_null(g_date) THEN
                  NEXT FIELD pmn35
               ELSE
                  LET g_pmn2.pmn35 = g_date
                  DISPLAY BY NAME g_pmn2.pmn35
               END IF
               IF g_pmn2.pmn35 < g_pmn2.pmn34 OR
                  g_pmn2.pmn35 < g_pmn2.pmn33 THEN
                  CALL cl_err(g_pmn2.pmn35,'mfg3195',1)  #MOD-640492 0->1
                  LET g_pmn2.pmn35 = g_pmn_o.pmn35
                  DISPLAY BY NAME g_pmn2.pmn35
                  NEXT FIELD pmn35
               END IF
            ELSE
               LET g_pmn2.pmn35 = g_pmn2.pmn34 + g_ima491
               DISPLAY BY NAME g_pmn2.pmn35
            END IF
            LET g_pmn_o.pmn35 = g_pmn2.pmn35
 
       AFTER INPUT
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT INPUT END IF
        LET l_flag = 'N'
        IF cl_null(g_pmn2.pmn33) THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pmn2.pmn33
        END IF
        IF cl_null(g_pmn2.pmn34) THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pmn2.pmn34
        END IF
        IF cl_null(g_pmn2.pmn35) THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pmn2.pmn35
        END IF
        IF l_flag = 'Y' THEN CALL cl_err('','9033',1) NEXT FIELD pmn33 END IF  #MOD-640492 0->1
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
 END INPUT
 IF INT_FLAG THEN
 LET INT_FLAG=0
     LET g_pmn2.pmn14 = g_pmn14_t
     LET g_pmn2.pmn15 = g_pmn15_t
     LET g_pmn2.pmn33 = g_pmn33_t
     LET g_pmn2.pmn34 = g_pmn34_t
     LET g_pmn2.pmn35 = g_pmn35_t
     LET g_pmn2.pmn36 = g_pmn36_t
     LET g_pmn2.pmn37 = g_pmn37_t
     CLOSE WINDOW t564_w
     RETURN
  END IF
IF p_cmd='u' THEN
    UPDATE pmn_file SET pmn14=g_pmn2.pmn14,
                        pmn15=g_pmn2.pmn15,
                        pmn33=g_pmn2.pmn33,
                        pmn34=g_pmn2.pmn34,
                        pmn35=g_pmn2.pmn35,
                        pmn36=g_pmn2.pmn36,
                        pmn37=g_pmn2.pmn37
     WHERE pmn01=g_pmm.pmm01 AND pmn02=g_pmn[l_ac].pmn02
 END IF
 
 CLOSE WINDOW t564_w
 LET g_pmn[l_ac].pmn33=g_pmn2.pmn33
 LET g_pmn[l_ac].pmn34=g_pmn2.pmn34
 LET g_pmn[l_ac].pmn35=g_pmn2.pmn35    #CHI-9C0023
 DISPLAY BY NAME g_pmn2.pmn33,g_pmn2.pmn34,g_pmn2.pmn35   #CHI-9C0023 add pmn35
END FUNCTION
 
FUNCTION t540_b_move_back()
 
      LET g_pmn2.pmn01  = g_pmm.pmm01
      LET g_pmn2.pmn011 = g_pmm.pmm02
      LET g_pmn2.pmn02  = g_pmn[l_ac].pmn02
      LET g_pmn2.pmn04  = g_pmn[l_ac].pmn04
      LET g_pmn2.pmn041 = g_pmn[l_ac].pmn041
      LET g_pmn2.pmn07  = g_pmn[l_ac].pmn07
      LET g_pmn2.pmn11  ='N'                       #凍結碼
      LET g_pmn2.pmn14  = g_sma.sma886[1,1]        #部份交貨
      LET g_pmn2.pmn15  = g_sma.sma886[2,2]        #提前交貨
      LET g_pmn2.pmn16  = g_pmm.pmm25
      LET g_pmn2.pmn20  = g_pmn[l_ac].pmn20
      LET g_pmn2.pmn24  = g_pmn[l_ac].pmn24
      LET g_pmn2.pmn25  = g_pmn[l_ac].pmn25
      LET g_pmn2.pmn30  = 0                        #標準價格
      LET g_pmn2.pmn31  = g_pmn[l_ac].pmn31
      LET g_pmn2.pmn31t = g_pmn[l_ac].pmn31t       #No.FUN-550019
      LET g_pmn2.pmn33  = g_pmn[l_ac].pmn33
      LET g_pmn2.pmn34  = g_pmn[l_ac].pmn34
      LET g_pmn2.pmn35  = g_pmn[l_ac].pmn35        #CHI-9C0023
      LET g_pmn2.pmn38  = g_pmn[l_ac].pmn38        #MPS/MRP 可用/不可用   #FUN-690047
      LET g_pmn2.pmn41  = g_pmn[l_ac].pmn41
      LET g_pmn2.pmn42  = g_pmn[l_ac].pmn42
      LET g_pmn2.pmn50  = 0
      LET g_pmn2.pmn51  = 0
      LET g_pmn2.pmn53  = 0
      LET g_pmn2.pmn55  = 0
      LET g_pmn2.pmn57  = 0
      LET g_pmn2.pmn58  = 0
      LET g_pmn2.pmn61  = g_pmn[l_ac].pmn04
      LET g_pmn2.pmn62  = 1
      LET g_pmn2.pmn63  = g_pmn[l_ac].pmn63
      LET g_pmn2.pmn89  = g_pmn[l_ac].pmn89                 #FUN-940083
      LET g_pmn2.pmn64  = g_pmn[l_ac].pmn64
      LET g_pmn2.pmn65  = g_pmn[l_ac].pmn65
      LET g_pmn2.pmn68  = g_pmn[l_ac].pmn68
      LET g_pmn2.pmn69  = g_pmn[l_ac].pmn69
      LET g_pmn2.pmn80= g_pmn[l_ac].pmn80
      LET g_pmn2.pmn81  = g_pmn[l_ac].pmn81
      LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
      LET g_pmn2.pmn83  = g_pmn[l_ac].pmn83
      LET g_pmn2.pmn84  = g_pmn[l_ac].pmn84
      LET g_pmn2.pmn85  = g_pmn[l_ac].pmn85
      LET g_pmn2.pmn86  = g_pmn[l_ac].pmn86
      LET g_pmn2.pmn87  = g_pmn[l_ac].pmn87
      LET g_pmn2.pmn90  = g_pmn[l_ac].pmn31   #CHI-690043 add  #將單價keep在pmn90
      LET g_pmn2.pmn122  = g_pmn[l_ac].pmn122
      LET g_pmn2.pmn96   = g_pmn[l_ac].pmn96
      LET g_pmn2.pmn97   = g_pmn[l_ac].pmn97
      LET g_pmn2.pmn67   = g_pmn[l_ac].pmn67
      LET g_pmn2.pmn98   = g_pmn[l_ac].pmn98
      LET g_pmn2.pmn40   = g_pmn[l_ac].pmn40
      LET g_pmn2.pmn401  = g_pmn[l_ac].pmn401
      LET g_pmn2.pmn123  = g_pmn[l_ac].pmn123   #FUN-950088 add
      LET g_pmn2.pmn52   = g_pmn[l_ac].pmn52    #CHI-9C0025
      LET g_pmn2.pmn56   = g_pmn[l_ac].pmn56    #CHI-9C0025
      LET g_pmn2.pmn54   = g_pmn[l_ac].pmn54    #CHI-9C0025
      LET g_pmn2.pmn919  = g_pmn[l_ac].pmn919   #FUN-A80150 add
      LET g_pmn2.pmn100  = g_pmn[l_ac].pmn100   #FUN-D40042
     LET g_pmn2.pmnud01 = g_pmn[l_ac].pmnud01
     LET g_pmn2.pmnud02 = g_pmn[l_ac].pmnud02
     LET g_pmn2.pmnud03 = g_pmn[l_ac].pmnud03
     LET g_pmn2.pmnud04 = g_pmn[l_ac].pmnud04
     LET g_pmn2.pmnud05 = g_pmn[l_ac].pmnud05
     LET g_pmn2.pmnud06 = g_pmn[l_ac].pmnud06
     LET g_pmn2.pmnud07 = g_pmn[l_ac].pmnud07
     LET g_pmn2.pmnud08 = g_pmn[l_ac].pmnud08
     LET g_pmn2.pmnud09 = g_pmn[l_ac].pmnud09
     LET g_pmn2.pmnud10 = g_pmn[l_ac].pmnud10
     LET g_pmn2.pmnud11 = g_pmn[l_ac].pmnud11
     LET g_pmn2.pmnud12 = g_pmn[l_ac].pmnud12
     LET g_pmn2.pmnud13 = g_pmn[l_ac].pmnud13
     LET g_pmn2.pmnud14 = g_pmn[l_ac].pmnud14
     LET g_pmn2.pmnud15 = g_pmn[l_ac].pmnud15
END FUNCTION
 
FUNCTION t540_6()    #price (IQ)
   DEFINE l_pmn02 LIKE pmn_file.pmn02
   DEFINE l_pmn04 LIKE pmn_file.pmn04
   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pmm.pmm01
   IF g_pmm.pmm01 IS NULL THEN CALL cl_err('',-400,1) RETURN END IF  #MOD-640492 0->1
   LET p_row = 4 LET p_col = 27
   OPEN WINDOW t540_6 AT p_row,p_col          #條件畫面
        WITH FORM "apm/42f/apmt540_6"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt540_6")
 
   WHILE TRUE
      INPUT l_pmn02 WITHOUT DEFAULTS FROM pmn02
 
      AFTER FIELD pmn02
         IF NOT cl_null(l_pmn02) THEN
             SELECT COUNT(*) INTO l_cnt FROM pmn_file
              WHERE pmn01=g_pmm.pmm01 AND pmn02=l_pmn02
             IF l_cnt=0 THEN
                CALL cl_err(l_pmn02,'apm-219',1)  #MOD-640492 0->1
                NEXT FIELD pmn02
             END IF
         END IF
       
 
      AFTER INPUT
 
        IF INT_FLAG THEN EXIT INPUT END IF
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     END INPUT
     CLOSE WINDOW t540_6                 #結束畫面
     EXIT WHILE
   END WHILE
   SELECT pmn04 INTO l_pmn04 FROM pmn_file
    WHERE pmn01=g_pmm.pmm01 AND pmn02=l_pmn02
 
   LET g_cmd = 'apmq221 ',"'", l_pmn04,"'"
   CALL cl_cmdrun(g_cmd)
END FUNCTION
 
FUNCTION t540_pml_process()
    DEFINE l_pml01    LIKE pml_file.pml01
    DEFINE l_pml02    LIKE pml_file.pml02
    DEFINE l_pmn122   LIKE pmn_file.pmn122
    DEFINE l_qty      LIKE pml_file.pml20
    DEFINE l_n        LIKE type_file.num5    #No.FUN-680136 SMALLINT
    DEFINE l_chr      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    LET p_row = 20 LET p_col = 4
    OPEN WINDOW t540_f1 AT p_row,p_col WITH 3 ROWS,70 COLUMNS
    LET l_pmn122 = g_pmm.pmm05  #FUN-810045 add
    WHILE TRUE
          CALL cl_getmsg('apm-163',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED FOR CHAR l_chr
          IF l_chr NOT MATCHES '[12]' OR cl_null(l_chr)  THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
          IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
          IF cl_null(l_pmn122) THEN EXIT WHILE
          ELSE
             SELECT COUNT(*) INTO l_n FROM pml_file WHERE pml12=l_pmn122
             IF l_n = 0 THEN CALL cl_err('','apm-164',1) CONTINUE WHILE END IF  #MOD-640484
          END IF
          IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END WHILE
    CLOSE WINDOW t540_f1
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF l_chr='2' THEN
#FUN-B90103--------------add-----------
#FUN-C20006--end--------------------------------
       DECLARE t540_pmk_pro CURSOR WITH HOLD FOR
          SELECT pml01,pml02,pml20-pml21 FROM pml_file,pmk_file
          WHERE pml12=l_pmn122 AND pmk25 IN ('1','2') AND
                pmkacti='Y' AND pmk01=pml01
       #----- insert 採購單身檔
       LET l_n=0
       BEGIN WORK
       LET g_success='Y'
       FOREACH t540_pmk_pro INTO l_pml01,l_pml02,l_qty
        IF STATUS THEN EXIT FOREACH END IF
        IF l_qty>0 THEN
           #產生單身資料
           LET l_n=l_n+1
           CALL t540_pmn(l_pml01,l_pml02,l_n)
           IF g_success = 'N' THEN
              EXIT FOREACH
              ROLLBACK WORK
           END IF
           IF g_success='Y' THEN
              CALL t540_pmo(l_pml01,l_pml02,l_n) END IF #特殊說明檔
           IF g_success='Y' THEN
              CALL t540_pml(l_pml01,l_pml02) END IF     #請購單身狀況及已轉數量
           IF g_success = 'Y'THEN
              CALL t540_pmm40() END IF                  #採購單總金額

           #update 請購單頭狀況碼及狀況異動日期
           IF g_success = 'Y' AND g_pmm.pmm909<>'8' THEN  #FUN-9A0034
              UPDATE pmk_file SET pmk25='2',pmk27=TODAY
               WHERE pmk01=l_pml01 AND pmk01 NOT IN
              (SELECT pml01 FROM pml_file WHERE pml01=l_pml01
                                 AND pml16 IN ('0','1'))
              IF SQLCA.sqlcode THEN
                 LET g_success='N'
                 CALL cl_err3("upd","pmk_file",l_pml01,"",SQLCA.sqlcode,"","upd pmk25",1)  #No.FUN-660129
              END IF
           END IF
           IF g_success = 'N' THEN
              EXIT FOREACH
              ROLLBACK WORK
           END IF
        END IF

       END FOREACH
       IF g_success = 'N' THEN
          ROLLBACK WORK
       ELSE
          COMMIT WORK
          CALL t540_b_fill(' 1=1',' 1=1') #單身 #FUN-B90103--add  新增參數用於服飾行業母單身和子單身的切換
#FUN-B90103------------add-------
#FUN-B90103------------end------
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t540_pmn(p_pml01,p_pml02,p_n)      #產生單身資料
  DEFINE p_pml01    LIKE pml_file.pml01
  DEFINE p_pml02    LIKE pml_file.pml02
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE p_n        LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_pml      RECORD LIKE pml_file.*
  DEFINE l_pmn      RECORD LIKE pmn_file.*
  DEFINE l_ecm04    LIKE ecm_file.ecm04        #CHI-8A0022
  DEFINE l_pmh24    LIKE pmh_file.pmh24        #FUN-940083
  DEFINE l_pmc914   LIKE pmc_file.pmc914       #FUN-940083
#FUN-A60035 ---MARK BEGIN
#&ifdef SLK
#  DEFINE l_sql      STRING  #FUN-A50054
#&endif    
#FUN-A60035 ---MARK END
  DEFINE l_rtz08    LIKE rtz_file.rtz08   #FUN-B40098
  DEFINE l_rtz07    LIKE rtz_file.rtz07   #FUN-B60150 ADD
 
  #---取出請購單身資料
   SELECT * INTO l_pml.* FROM pml_file
    WHERE pml01=p_pml01 AND pml02=p_pml02
 
  #---產生採購單身資料
   LET  l_pmn.pmn63=l_pml.pml91          #急料否    #No.FUN-920183 add
   LET  l_pmn.pmn01=g_pmm.pmm01          #採購單號
   LET  l_pmn.pmn011=g_pmm.pmm02         #採購性質
   LET  l_pmn.pmn02=p_n                  #序號
   LET  l_pmn.pmn03=l_pml.pml03          #詢價單號
   LET  l_pmn.pmn04=l_pml.pml04          #料號
   LET  g_pmn04 = l_pmn.pmn04            #MOD-C90211 add
   LET  l_pmn.pmn041=l_pml.pml041        #品名
   LET  l_pmn.pmn05=l_pml.pml05          #APS單據編號
   LET  l_pmn.pmn06=l_pml.pml06          #廠商料號
   LET  l_pmn.pmn08=l_pml.pml08          #庫存單位
   LET  l_pmn.pmn83=l_pml.pml83
   LET  l_pmn.pmn84=l_pml.pml84
   LET  l_pmn.pmn85=l_pml.pml85
   LET  l_pmn.pmn80=l_pml.pml80
   LET  l_pmn.pmn81=l_pml.pml81
   LET  l_pmn.pmn82=l_pml.pml82
   LET  l_pmn.pmn86=l_pml.pml86
   LET  l_pmn.pmn87=l_pml.pml87
   LET  l_pmn.pmn88=l_pml.pml88
   LET  l_pmn.pmn88t=l_pml.pml88t
 
   IF l_pml.pml04[1,4] <> 'MISC' THEN
      SELECT ima44 INTO l_pmn.pmn07 FROM ima_file  #採購單位
       WHERE ima01=l_pmn.pmn04
      CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08)
           RETURNING l_flag,l_pmn.pmn09            #取換算率(採購對庫存)
      IF l_flag=1 THEN                             #單位換算率抓不到
         CALL cl_err('pmn07/pmn08: ','abm-731',1)
         RETURN
      END IF
   END IF
   LET  l_pmn.pmn11=l_pml.pml11         #凍結碼
   LET  l_pmn.pmn121=1                  #採購對請購之轉換率
   LET  l_pmn.pmn122=l_pml.pml12        #No use->專案代號 00/04/18
   IF cl_null(l_pmn.pmn122) THEN LET l_pmn.pmn122=' ' END IF   #No:8841
   LET l_pmn.pmn96 = l_pml.pml121    #WBS
   IF cl_null(l_pmn.pmn96) THEN LET l_pmn.pmn96 = ' ' END IF
   LET l_pmn.pmn97 = l_pml.pml122    #活動
   IF cl_null(l_pmn.pmn97) THEN LET l_pmn.pmn97 = ' ' END IF
   LET l_pmn.pmn98 = l_pml.pml90    #費用原因
   IF cl_null(l_pmn.pmn98) THEN LET l_pmn.pmn98 = ' ' END IF
   LET  l_pmn.pmn123=l_pml.pml123       #No use
   LET  l_pmn.pmn13=l_pml.pml13          #超短交限率
   LET  l_pmn.pmn14=l_pml.pml14          #部份交貨否
   LET  l_pmn.pmn15=l_pml.pml15          #提前交貨否
   LET  l_pmn.pmn16='0'
   LET  l_pmn.pmn20=l_pml.pml20-l_pml.pml21 #採購量
   LET  l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)    #FUN-910088--add--
   LET  l_pmn.pmn23=' '                  #送貨地址
   LET  l_pmn.pmn24=p_pml01              #請購單號
   LET  l_pmn.pmn25=p_pml02              #序號
   LET  l_pmn.pmn30=l_pml.pml30          #標準價格
   LET l_ecm04=' '
   IF NOT cl_null(l_pmn.pmn43) AND l_pmn.pmn43 != 0 THEN
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm01 = l_pmn.pmn41 AND ecm03 = l_pmn.pmn43
         AND ecm012= l_pmn.pmn012    #No.FUN-A60011
   END IF
   CALL s_defprice_new(l_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,
                       g_pmm.pmm04,l_pmn.pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,
                       g_type,l_pmn.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
        RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                  l_pmn.pmn73,l_pmn.pmn74     #TQC-AC0257 add
   IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73='4' END IF #TQC-AC0257
   CALL t540_price_check(l_pmn.pmn31,l_pmn.pmn31t)  #MOD-9C0285 ADD
   LET  g_pmn04 = ''            #MOD-C90211 add
       IF NOT cl_null(g_errno) THEN
          CALL cl_err('',g_errno,1)
       END IF

   #MOD-CA0024 add start -----
   #l_pmn.pmn88 l_pmn.pmn88t 若為NULL重新金額重算
   IF cl_null(l_pmn.pmn88) OR cl_null(l_pmn.pmn88t) THEN
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'

      LET l_pmn.pmn88 = l_pmn.pmn31 * l_pmn.pmn87
      CALL cl_digcut(l_pmn.pmn88,t_azi04) RETURNING  l_pmn.pmn88
      LET l_pmn.pmn88t= l_pmn.pmn31t* l_pmn.pmn87
      CALL cl_digcut(l_pmn.pmn88t,t_azi04) RETURNING l_pmn.pmn88t

      IF g_gec07 = 'N' THEN
         LET l_pmn.pmn88t = l_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
         LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn88t,t_azi04)
      ELSE
         #IF g_gec05 = 'T' THEN
         IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
            LET l_pmn.pmn31  = l_pmn.pmn31t* ( 1 - g_pmm.pmm43/100)
            LET l_pmn.pmn31  = cl_digcut(l_pmn.pmn31,t_azi03)
            LET l_pmn.pmn88  = l_pmn.pmn88t* ( 1 - g_pmm.pmm43/100)
            LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
         ELSE
            LET l_pmn.pmn88  = l_pmn.pmn88t/ ( 1 + g_pmm.pmm43/100)
            LET l_pmn.pmn88  = cl_digcut(l_pmn.pmn88,t_azi04)
         END IF
      END IF
   END IF
   #MOD-CA0024 add end   -----

   LET  l_pmn.pmn34=l_pml.pml34          #原始到廠日期
   LET  l_pmn.pmn33=l_pmn.pmn34          #原始交貨日
   LET  l_pmn.pmn35=l_pmn.pmn34          #到庫日
   LET  l_pmn.pmn36=NULL                 #最近確認交貨日期
   LET  l_pmn.pmn37=NULL                 #最後一次到廠日期
   LET  l_pmn.pmn38=l_pml.pml38          #可用/不可用
   LET  l_pmn.pmn40=l_pml.pml40          #會計科目
   LET  l_pmn.pmn401=l_pml.pml401          #會計科目二  #FUN-810045 add
   LET  l_pmn.pmn41=l_pml.pml41          #工單號碼
   LET  l_pmn.pmn42=l_pml.pml42          #替代碼
   LET  l_pmn.pmn43=l_pml.pml43          #作業序號
   LET  l_pmn.pmn431=l_pml.pml431        #下一站作業序號
   LET  l_pmn.pmn012 = ' '               #No.FUN-A60011
   LET  l_pmn.pmn44 =l_pmn.pmn31*g_pmm.pmm42  #本幣單價
   CALL cl_digcut(l_pmn.pmn44,g_azi03) RETURNING l_pmn.pmn44   #MOD-B30280 add
   LET  l_pmn.pmn45=NULL                 #NO:7190
   LET  l_pmn.pmn50=0                    #交貨量
   LET  l_pmn.pmn51=0                    #在驗量
   LET  l_pmn.pmn53=0                    #入庫量
   SELECT ima35,ima36 INTO l_pmn.pmn52,l_pmn.pmn54 FROM ima_file
    WHERE ima01=l_pmn.pmn04
 #FUN-B60150 ADD&MARK BEGIN ---------------------------------------
 ##FUN-B40098 Begin---
 # SELECT rtz08 INTO l_rtz08 FROM rtz_file
 #  WHERE rtz01 = g_pmm.pmmplant
 # IF NOT cl_null(l_rtz08) THEN
 #    LET l_pmn.pmn52 = l_rtz08
 #    LET l_pmn.pmn54 = ' '
 #    LET l_pmn.pmn56 = ' '
 # END IF
 ##FUN-B40098 End-----
   IF g_azw.azw04 = '2' THEN
      #FUN-C90049 mark begin---
      #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
      # WHERE rtz01 = g_pmm.pmmplant
      #FUN-C90049 mark end-----
      CALL s_get_defstore(g_pmm.pmmplant,l_pmn.pmn04) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add
      IF g_pmm.pmm51 = '3' AND (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2') THEN
         IF NOT cl_null(l_rtz08) THEN
            LET l_pmn.pmn52 = l_rtz08
            LET l_pmn.pmn54 = ' '
            LET l_pmn.pmn56 = ' '
         END IF
      END IF
      IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
         IF NOT cl_null(l_rtz07) THEN
            LET l_pmn.pmn52 = l_rtz07
            LET l_pmn.pmn54 = ' '
            LET l_pmn.pmn56 = ' '
         END IF
      END IF
   END IF
 #FUN-B60150 ADD&MARK  END  ---------------------------------------
#TQC-AB0044  --mark    
#   #No.FUN-AA0049--begin
#   IF NOT s_chk_ware(l_pmn.pmn52) THEN
#      LET l_pmn.pmn52=' '
#      LET l_pmn.pmn54=' '
#   END IF 
#   #No.FUN-AA0049--end
#TQC-AB0044  --end        
   LET  l_pmn.pmn55=0                     #驗退量
   LET  l_pmn.pmn56=' '                   #批號
   LET  l_pmn.pmn57=0                     #超短交量
   LET  l_pmn.pmn58=0                     #無交期性採購單已轉量
   LET  l_pmn.pmn59=' '                   #退貨單號
   LET  l_pmn.pmn60=0                     #項次
   LET  l_pmn.pmn61=l_pmn.pmn04           #被替代料號
   LET  l_pmn.pmn62=1                     #替代率
   LET  l_pmn.pmn63='N'                   #急料否
   LET  l_pmn.pmn67=l_pml.pml67
   SELECT ima15 INTO l_pmn.pmn64 FROM ima_file
    WHERE ima01=l_pml.pml04
   IF cl_null(l_pmn.pmn64) OR l_pmn.pmn64 NOT MATCHES '[YN]' THEN
      LET  l_pmn.pmn64='N'
   END IF
   LET  l_pmn.pmn65='1'                   #一般/代買
   LET  l_pmn.pmn90=l_pmn.pmn31           #取出單價   #CHI-690043 add
 
   # check 請購量+容許量
   IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽        
         IF t540_available_qty(l_pmn.pmn09*l_pmn.pmn20,l_pmn.pmn24,l_pmn.pmn25,l_pmn.pmn04) THEN 
            RETURN 
         END IF
   END IF
   IF g_success = 'Y' THEN
       SELECT pmh24 INTO l_pmh24 FROM pmh_file
           WHERE pmh01 = l_pmn.pmn04
             AND pmh02 = g_pmm.pmm09
             AND pmh13 = g_pmm.pmm22
             AND pmh21 = " "
             AND pmh22 = '1'
             AND pmh23 = ' '                      #No.CHI-960033
             AND pmhacti = 'Y'
       IF NOT cl_null(l_pmh24) THEN
          LET l_pmn.pmn89=l_pmh24
       ELSE
          IF g_sma.sma93="Y" THEN                        #MOD-C30578 add 
             SELECT pmc914 INTO l_pmc914 FROM pmc_file 
              WHERE pmc01 = g_pmm.pmm09 
             IF l_pmc914 = 'Y' THEN
                 LET l_pmn.pmn89 = 'Y'
             ELSE
                LET l_pmn.pmn89 = 'N'
             END IF
          END IF                                         #MOD-C30578 add
       END IF
       IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
       IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
      LET l_pmn.pmnplant = g_plant #FUN-980006 add
      LET l_pmn.pmnlegal = g_legal #FUN-980006 add
      IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF   #TQC-9B0203
      IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012=' ' END IF  #No.TQC-A60113
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifdef SLK
#     LET l_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#                 "  WHERE ata00 = '",g_prog,"'",
#                 "    AND ata01 = '",g_pmm.pmm01,"'",
#                 "    AND ata02 = '",g_pmn[l_ac].pmn02,"'"
#     DECLARE t5400_ata_curs SCROLL CURSOR FROM l_sql
#     FOREACH t5400_ata_curs INTO l_pmn.pmn02,l_pmn.pmn04,l_pmn.pmn20
#&endif
##FUN-A50054---End            
#FUN-A60035 ---MARK END
      CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                      l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
      INSERT INTO pmn_file VALUES (l_pmn.*)   #BugNo.7259
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","ins pmn",1)  #No.FUN-660129
         RETURN
      END IF
#FUN-A60035 ---MARK BEGIN
#&ifdef SLK
#   END FOREACH  #FUN-A50054 add
#&endif 
#FUN-A60035 ---MARK END
   END IF 
   
   
END FUNCTION
 
FUNCTION  t540_pmo(p_pml01,p_pml02,p_n)      #請購單號
   DEFINE   p_pml01    LIKE pml_file.pml01
   DEFINE   p_pml02    LIKE pml_file.pml02
   DEFINE   l_pmo      RECORD LIKE pmo_file.*
   DEFINE   p_n        LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE   l_sql      STRING #No.FUN-680136 VARCHAR(300) #FUN-730068
 
   LET l_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal ", #FUN-980006 add pmoplant,pmolegal
               " FROM pmo_file ",
               " WHERE pmo01 ='",p_pml01,"' ",
               "   AND pmo02='0' AND pmo03=",p_pml02,
               " ORDER BY 1"
   PREPARE t540_pmo2 FROM l_sql
   DECLARE pmo2_cs CURSOR FOR t540_pmo2  #CURSOR
   FOREACH pmo2_cs INTO l_pmo.*          #單身 ARRAY 填充
     LET l_pmo.pmo01=g_pmm.pmm01
     LET l_pmo.pmo02='1'
     LET l_pmo.pmo03=p_n
     INSERT INTO pmo_file VALUES (l_pmo.*)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pmo_file",l_pmo.pmo01,l_pmo.pmo03,SQLCA.sqlcode,"","ins pmo2",1)  #No.FUN-660129
        RETURN
     END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION t540_pmm40()     #update 採購單頭的總金額
   DEFINE l_pmm40  LIKE pmm_file.pmm40,   #MOD-840665 modify
          l_pmm40t LIKE pmm_file.pmm40t
  #SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)  #No:TQC-980183 Add  #MOD-A10174 mark
   SELECT SUM(pmn88),SUM(pmn88t)                                  #MOD-A10174 add
     INTO l_pmm40,l_pmm40t
     FROM pmn_file
    WHERE pmn01 = g_pmm.pmm01
   LET l_pmm40 = cl_digcut(l_pmm40,t_azi04)  #No.CHI-6A0004
   LET l_pmm40t= cl_digcut(l_pmm40t,t_azi04)  #No.CHI-6A0004
 
   UPDATE pmm_file SET pmm40 = l_pmm40,
                       pmm40t= l_pmm40t
    WHERE pmm01 = g_pmm.pmm01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","upd pmm40",1)  #No.FUN-660129
      RETURN
   END IF
END FUNCTION
 
FUNCTION  t540_pml(p_pml01,p_pml02)  #update 請購單身之已轉採購數量及狀況碼
  DEFINE p_pml01   LIKE pml_file.pml01
  DEFINE p_pml02   LIKE pml_file.pml02
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pml07   LIKE pml_file.pml07    #FUN-910088--add--
 
  LET l_sum=0
 #數量/替代率*對請購換算率
  SELECT SUM(pmn20/pmn62*pmn121) INTO l_sum FROM pmn_file
   WHERE pmn24=p_pml01 AND pmn25=p_pml02 AND pmn16<>'9'
#FUN-910088--add-start--
  SELECT pml07 INTO l_pml07 FROM pml_file
   WHERE pml01=p_pml01 AND pml02=p_pml02
  LET l_sum = s_digqty(l_sum,l_pml07)
#FUN-910088--add--end--
  UPDATE pml_file SET pml16='2',pml21=l_sum
   WHERE pml01=p_pml01 AND pml02=p_pml02
  IF SQLCA.sqlcode THEN
     LET g_success='N'
     CALL cl_err3("upd","pml_file",p_pml01,p_pml02,SQLCA.sqlcode,"","upd pml",1)  #No.FUN-660129
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION t540_available_qty(p_qty,p_pmn24,p_pmn25,p_item)
DEFINE   p_pmn24  LIKE  pmn_file.pmn24
DEFINE   p_pmn25  LIKE  pmn_file.pmn25
DEFINE   p_item   LIKE  pmn_file.pmn04
DEFINE   p_qty    LIKE  pmn_file.pmn20,
         l_pmn20  LIKE  pmn_file.pmn20,
#         l_over   LIKE  ima_file.ima26,   #No.FUN-680136 DECIMAL(13,3), #FUN-A20044
         l_over   LIKE  type_file.num15_3,   #No.FUN-680136 DECIMAL(13,3), #FUN-A20044
         l_ima07  LIKE  ima_file.ima07,
         l_ima25  LIKE  ima_file.ima25,#TQC-7C0119 add
         l_pml20  LIKE  pml_file.pml20
 
   LET l_pmn20 = 0
   SELECT SUM(pmn20/pmn62*pmn09) INTO l_pmn20 FROM pmn_file #採購量#TQC-7C0116 add
    WHERE pmn24=p_pmn24     #請購單
      AND pmn25=p_pmn25     #請購序號
      AND pmn16<>'9'        #取消(Cancel)
   IF STATUS OR cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
 #----------------與請購互相勾稽 -------------------------------------
   SELECT ima07,ima25 INTO l_ima07,l_ima25 FROM ima_file  #select ABC code#TQC-7C0119 add
    WHERE ima01=p_item
 
   SELECT pml20*pml09 INTO l_pml20 FROM pml_file
    WHERE pml01=p_pmn24
      AND pml02=p_pmn25
 
   LET l_pmn20 = s_digqty(l_pmn20,l_ima25)   #FUN-910088--add--
   LET l_pml20 = s_digqty(l_pml20,l_ima25)   #FUN-910088--add--
   IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF
   IF cl_null(g_sma.sma341) THEN LET g_sma.sma341 = 0 END IF
   IF cl_null(g_sma.sma342) THEN LET g_sma.sma342 = 0 END IF
   IF cl_null(g_sma.sma343) THEN LET g_sma.sma343 = 0 END IF
   CASE
   WHEN l_ima07='A'  #計算可容許的數量
        LET l_over=l_pml20 * (g_sma.sma341/100)
   WHEN l_ima07='B'
        LET l_over=l_pml20 * (g_sma.sma342/100)
   WHEN l_ima07='C'
        LET l_over=l_pml20 * (g_sma.sma343/100)
   OTHERWISE
        LET l_over=0
   END CASE
   IF p_qty+l_pmn20>    #本筆採購量+已轉採購量
      (l_pml20+l_over) THEN   #請購量+容許量
      CALL cl_err(p_qty||' '||l_ima25,'mfg3425',1)  #TQC-7C0119 mod
      IF g_sma.sma33='R'    #reject
         THEN
         RETURN -1
      END IF
   END IF
   RETURN 0
END FUNCTION
 
FUNCTION t540_g()
   DEFINE l_cmd            LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_prog          LIKE zz_file.zz01,      #No.FUN-680136  VARCHAR(10)
          l_wc,l_wc2      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway       LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
   DEFINE l_sw           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_n           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_buf         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(6)
          l_name        LIKE type_file.chr20   #No.FUN-680136 VARCHAR(20)
   DEFINE l_easycmd     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(4096),
          l_updsql_0    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500),
          l_updsql_1    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500),
          l_updsql_2    LIKE type_file.chr1000, #No.FUN-680136  VARCHAR(500),
          l_upload      LIKE type_file.chr1000  #No.FUN-680136  VARCHAR(1000)
 
 
   IF g_aza.aza23 matches '[ Nn]'
     THEN
     CALL cl_err('aza23','mfg3551',1)  #MOD-640484
     RETURN
   END IF
   IF cl_null(g_pmm.pmm01) THEN CALL cl_err('','-400',1)  RETURN END IF  #MOD-640484
   IF g_pmm.pmmmksg IS NULL OR g_pmm.pmmmksg matches '[Nn]'
     THEN
     CALL cl_err('','mfg3549',1)  #MOD-640484
     RETURN
   END IF
 
   IF g_pmm.pmm18 matches '[NnX]'
     THEN
     CALL cl_err('','mfg3550',1)  #MOD-640484
     RETURN
   END IF
 
   IF g_pmm.pmm25 matches '[Ss1]'
     THEN
     CALL cl_err('','mfg3557',1)   #本單據目前已送簽或已核准   #MOD-640484
     RETURN
   END IF
 
#--- 產生本張單據之報表檔
 #  LET l_prog='apmr900' #FUN-C30085 mark
   LET l_prog='apmr900' #FUN-C30085 add
 
   LET l_wc='pmm01="',g_pmm.pmm01,'"'
 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = l_prog
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN LET l_wc2 = " '3' " END IF
 
#---- 抓報表檔名  l_name
   CALL cl_outnam(l_prog) RETURNING l_name
   LET l_cmd = l_prog CLIPPED,
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '0' '1'",
               " '",l_wc CLIPPED,"' '"
    CALL cl_cmdrun(l_cmd)
 
   LET l_updsql_0="UPDATE pmm_file SET pmm25='S' WHERE pmm01='",g_pmm.pmm01,"';"
   LET l_updsql_1="UPDATE pmm_file SET pmm25='1' WHERE pmm01='",g_pmm.pmm01,"';",
                  "UPDATE pmn_file SET pmn16='1' WHERE pmn01='",g_pmm.pmm01,"';"
   LET l_updsql_2="UPDATE pmm_file SET pmm25='R' WHERE pmm01='",g_pmm.pmm01,"';"
   LET l_easycmd='ef ',
                 '"','TIPTOP_PO','" ',                  #E-Form單別
                 '"','apmt540','" ',                    #程式代號
                 '"',g_pmm.pmm01 CLIPPED,'" ',          #單號
                 '"',g_dbs CLIPPED,'" ',                #資料庫(連線字串)
                 '"',l_updsql_0 CLIPPED,'" ',           #更新狀況碼-送簽中
                 '"',l_updsql_1 CLIPPED,'" ',           #簽核同意
                 '"',l_updsql_2 CLIPPED,'" ',           #簽核不同意
                 '"','1','" ',                          #附件總數
                 '"',l_name CLIPPED,'" ',               #報表檔徑名
                 '"','2','" ',                          #條件欄位總數
                 '"C',g_pmm.pmmsign CLIPPED,'" ',        #條件1: 簽核等級
                 '"N','5000','" '                       #條件2: 總金額
  RUN l_easycmd
  CALL t540_pic() #FUN-730012
END FUNCTION
 
FUNCTION t540_pv()
  DEFINE
         l_cnt     LIKE  type_file.num5,
         l_poz     RECORD LIKE poz_file.*,
         l_poy     RECORD LIKE poy_file.*,
         l_pov_pmc RECORD LIKE pov_file.*,
         l_pov_occ RECORD LIKE pov_file.*,
         l_occ     RECORD LIKE occ_file.*,
         l_azp03   LIKE     azp_file.azp03,
         l_azp02,l_azp02_1  LIKE azp_file.azp02,
         l_sql     STRING,
         l_txt     STRING
 
  #供應商的內部交易設定
   SELECT * INTO l_pov_pmc.* FROM pov_file
    WHERE pov01 = '0'
      AND pov02 = g_pmm.pmm09
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_pmm.pmm09,SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
   END IF
   #CHI-CC0033 -- add start --
   IF l_pov_pmc.pov27[1,4] ='MISC' THEN
      LET l_pov_pmc.pov27=g_plant
   END IF 
   #CHI-CC0033 -- add end --
 
  SELECT COUNT(*) INTO l_cnt FROM poz_file
   WHERE poz12 = 'Y'
     AND poz13 = g_plant
     AND poz14 = l_pov_pmc.pov03
  IF l_cnt = 0 THEN   #產生流程
 
     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
     SELECT azp03,azp02 INTO l_azp03,l_azp02_1 FROM azp_file
      WHERE azp01 = l_pov_pmc.pov03
     IF SQLCA.sqlcode THEN
       CALL cl_err(l_pov_pmc.pov03,SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
     END IF
     LET l_azp03 = s_dbstring(l_azp03)    #TQC-950010 ADD     
   # LET l_sql = "SELECT * FROM ",l_azp03 ,"pov_file",                             #FUN-A50102 mark
     LET l_sql = "SELECT * FROM ",cl_get_target_table(l_pov_pmc.pov03,'pov_file'), #FUN-A50102  
                 " WHERE pov01 = '1'",
                 "   AND pov02 = '",l_pov_pmc.pov27 CLIPPED,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql	          	#MOD-990178
     CALL cl_parse_qry_sql(l_sql,l_pov_pmc.pov03) RETURNING l_sql       #FUN-A50102
     PREPARE pov_occ_pre FROM l_sql
     EXECUTE pov_occ_pre INTO l_pov_occ.*
     IF SQLCA.sqlcode THEN
       CALL cl_err(l_pov_pmc.pov27,'apm-966',1)
       LET g_success = 'N'
       RETURN
     END IF
 
    #依對應營運中心 pov03 及 客戶編號pov27到對應營運中心抓客戶資料
    #LET l_sql = "SELECl_pov_pmc.pov03T * FROM ",l_azp03 ,"occ_file",                             #FUN-A50102 mark
     #No.MOD-CC0129  --Begin
     #LET l_sql = "SELECl_pov_pmc.pov03T * FROM ",cl_get_target_table(l_pov_pmc.pov03,'occ_file'), #FUN-A50102
     LET l_sql = "SELECT * FROM ",cl_get_target_table(l_pov_pmc.pov03,'occ_file'), #FUN-A50102
     #No.MOD-CC0129  --End
                 " WHERE occ01 = '", l_pov_pmc.pov27 CLIPPED,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql	      	   #MOD-990178
     CALL cl_parse_qry_sql(l_sql,l_pov_pmc.pov03) RETURNING l_sql  #FUN-A50102
     PREPARE occ_pre2 FROM l_sql
     EXECUTE occ_pre2 INTO l_occ.*
     IF SQLCA.sqlcode THEN
       CALL cl_err(l_pov_pmc.pov27,SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
     END IF
 
     INITIALIZE l_poz.* TO NULL
     INITIALIZE l_poy.* TO NULL
 
     CALL cl_getmsg('apm-969',g_lang) RETURNING l_txt
     LET l_poz.poz00 = '2'  #代採
    #LET l_poz.poz01 = g_plant CLIPPED,l_pov_pmc.pov03                 #CHI-CC0033 mark
     LET l_poz.poz01 = g_plant[2,5] CLIPPED , l_pov_pmc.pov03[2,5]     #CHI-CC0033 add
     LET l_poz.poz011= '1'  #正拋
     LET l_poz.poz02 = l_azp02 CLIPPED," > ",l_azp02_1 CLIPPED," ",l_txt CLIPPED
     LET l_poz.poz03 = l_pov_occ.pov10   #pov27+對應營運中心的 pov10
     LET l_poz.poz04 = ' '
     LET l_poz.poz05 = ' '
     LET l_poz.poz06 = ' '
     LET l_poz.poz07 = ' '
     LET l_poz.poz08 = ' '
     LET l_poz.poz09 = 'N'
     LET l_poz.poz10 = 'N'
     LET l_poz.poz11 = '2'
     LET l_poz.poz12 = 'Y'
     LET l_poz.poz13 = g_plant
     LET l_poz.poz14 = l_pov_pmc.pov03
     LET l_poz.pozacti = 'Y'
     LET l_poz.pozuser = g_user
     LET l_poz.pozgrup = g_grup
     LET l_poz.pozmodu = ' '
     LET l_poz.pozdate = g_today
     LET l_poz.poz17 = 'Y'
     LET l_poz.poz18 = ' '
     LET l_poz.poz19 = 'N'
     #CHI-CC0033 -- add start --
     LET l_poz.poz20='N'
     LET l_poz.poz21=''
     #CHI-CC0033 -- add end --
 
     LET l_poz.pozoriu = g_user      #No.FUN-980030 10/01/04
     LET l_poz.pozorig = g_grup      #No.FUN-980030 10/01/04
     LET l_poz.poz20   = 'N'         #No.MOD-CC0129
     INSERT INTO poz_file VALUES (l_poz.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poz_file",l_poz.poz01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
 
    #INSRET 第0站
     LET l_poy.poy01 = l_poz.poz01
     LET l_poy.poy02 = 0
     LET l_poy.poy03 = l_pov_pmc.pov27
     LET l_poy.poy04 = g_plant
     LET l_poy.poy05 = g_pmm.pmm22
     LET l_poy.poy06 = g_pmm.pmm20
     LET l_poy.poy07 = ' '
     LET l_poy.poy08 = ' '
     LET l_poy.poy09 = g_pmm.pmm21
     LET l_poy.poy10 = ' '
    #LET l_poy.poy11 = l_pov_pmc.pov04   #CHI-CC0033 mark
     LET l_poy.poy11 = l_pov_occ.pov04   #CHI-CC0033 add
     LET l_poy.poy12 = ' '
     LET l_poy.poy13 = l_pov_pmc.pov07
     LET l_poy.poy14 = ' '
     LET l_poy.poy15 = l_poy.poy05
     LET l_poy.poy16 = ' '
     LET l_poy.poy17 = l_pov_pmc.pov07
     LET l_poy.poy18 = ' '
     LET l_poy.poy19 = g_pmm.pmm13
     LET l_poy.poy20 = ' '
     LET l_poy.poy26 = ' '
     LET l_poy.poy27 = ' '
     LET l_poy.poy28 = ' '
     LET l_poy.poy29 = ' '
     SELECT pmc1913 INTO l_poy.poy30  FROM pmc_file
      WHERE pmc01 = g_pmm.pmm09
     LET l_poy.poy31 = ' '
     LET l_poy.poy32 = ' '
     LET l_poy.poy33 = ' '
     LET l_poy.poy34 = ' '
     LET l_poy.poy35 = l_pov_pmc.pov14
     LET l_poy.poy36 = ' '
     LET l_poy.poy37 = l_pov_pmc.pov16
     LET l_poy.poy38 = l_pov_pmc.pov17
     LET l_poy.poy39 = ' '
     LET l_poy.poy40 = l_pov_pmc.pov19
     LET l_poy.poy41 = ' '
     LET l_poy.poy42 = l_pov_pmc.pov21
     LET l_poy.poy43 = ' '
     LET l_poy.poy44 = l_pov_pmc.pov23
     LET l_poy.poy45 = ' '
     LET l_poy.poy46 = l_pov_pmc.pov25
     LET l_poy.poy47 = ' '
     INSERT INTO poy_file VALUES (l_poy.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
 
 
    #INSRET 第1站
     LET l_poy.poy01 = l_poz.poz01
     LET l_poy.poy02 = 1
     LET l_poy.poy03 = g_pmm.pmm09
     LET l_poy.poy04 = l_pov_pmc.pov03
     LET l_poy.poy05 = g_pmm.pmm22
    #LET l_poy.poy06 = ' '               #CHI-CC0033 mark,預設'0'站,付款條件
     LET l_poy.poy07 = l_occ.occ45
     LET l_poy.poy08 = l_occ.occ41
    #LET l_poy.poy09 = ' '               #CHI-CC0033 mark,預設'0'站,PO稅別
     LET l_poy.poy10 = l_occ.occ43
    #LET l_poy.poy11 = l_pov_occ.pov04   #CHI-CC0033 mark 
     LET l_poy.poy11 = l_pov_pmc.pov04   #CHI-CC0033 add,庫別錯置
     LET l_poy.poy12 = l_occ.occ08
    #LET l_poy.poy13 = ' '               #CHI-CC0033 mark,預設'0'站,AP類別
    #LET l_poy.poy14 = ' '               #CHI-CC0033 mark,預設'0'站,營運中心編號
     LET l_poy.poy15 = l_poy.poy05
     LET l_poy.poy16 = l_pov_occ.pov06
    #LET l_poy.poy17 = ' '               #CHI-CC0033 mark,預設'0'站,AP科目類別
     LET l_poy.poy18 = l_pov_occ.pov09
    #LET l_poy.poy19 = ' '               #CHI-CC0033 mark,預設'0'站,AP部門編號
     LET l_poy.poy20 = l_pov_occ.pov10
     LET l_poy.poy26 = l_pov_occ.pov11
     LET l_poy.poy27 = l_occ.occ1024
     LET l_poy.poy28 = l_occ.occ1706
     LET l_poy.poy29 = l_occ.occ66
    #LET l_poy.poy30 = ' '               #CHI-CC0033 mark,預設'0'站,倉退理由碼
     LET l_poy.poy31 = l_occ.occ1705
     LET l_poy.poy32 = l_pov_occ.pov12
    #LET l_sql = "SELECT tqk02 FROM ",l_azp03 ,"tqk_file",                               #FUN-A50102 mark
     LET l_sql = "SELECT tqk02 FROM ",cl_get_target_table(l_pov_pmc.pov03,'tqk_file'),   #FUN-A50102
                 " WHERE tqk01 = ?"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql		      #MOD-990178
     CALL cl_parse_qry_sql(l_sql,l_pov_pmc.pov03) RETURNING l_sql     #FUN-A50102 
     PREPARE tqk_pre  FROM l_sql
     EXECUTE tqk_pre INTO l_poy.poy33 USING l_occ.occ01
     LET l_poy.poy34 = l_pov_occ.pov13
    #LET l_poy.poy35 = ' '               #CHI-CC0033 mark,預設'0'站,採購單單別
     LET l_poy.poy36 = l_pov_occ.pov15
    #LET l_poy.poy37 = ' '               #CHI-CC0033 mark,預設'0'站,收貨單別
    #LET l_poy.poy38 = ' '               #CHI-CC0033 mark,預設'0'站,入庫單別
     LET l_poy.poy39 = l_pov_occ.pov18
    #LET l_poy.poy40 = ' '               #CHI-CC0033 mark,預設'0'站,AP單別
     LET l_poy.poy41 = l_pov_occ.pov20
    #LET l_poy.poy42 = ' '               #CHI-CC0033 mark,預設'0'站,倉退單別
     LET l_poy.poy43 = l_pov_occ.pov22
    #LET l_poy.poy44 = ' '               #CHI-CC0033 mark,預設'0'站,AP折讓單別
     LET l_poy.poy45 = l_pov_occ.pov25
    #LET l_poy.poy46 = ' '               #CHI-CC0033 mark,預設'0'站,採購成本中心
     LET l_poy.poy47 = l_pov_occ.pov26
     INSERT INTO poy_file VALUES (l_poy.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
 
     LET g_pmm.pmm904 = l_poz.poz01
 
  ELSE
    SELECT poz01 INTO g_pmm.pmm904 FROM poz_file
     WHERE poz12 = 'Y'
       AND poz13 = g_plant
       AND poz14 = l_pov_pmc.pov03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","poz_file",g_plant,l_pov_pmc.pov03,STATUS,"","sel pov:",0)
       LET g_success = 'N'
    END IF
  END IF
END FUNCTION
 
 
FUNCTION t540_chk_pv()
  DEFINE l_pov03  LIKE pov_file.pov03,
         l_pov27  LIKE pov_file.pov27,
         l_cnt    LIKE type_file.num5,
         l_azp03  LIKE azp_file.azp03,
         l_pmc903 LIKE pmc_file.pmc903,
         l_sql    STRING
 
  #內部交易單據，供應商應為關係人
   SELECT pmc903 INTO l_pmc903 FROM pmc_file
    WHERE pmc01 = g_pmm.pmm09
   IF l_pmc903 <> 'Y' THEN
     CALL cl_err(g_pmm.pmm09,'apm-967',1)
     RETURN 0
   END IF
  #check pmm01 的 pov_file是否有設定，並抓出 pov03及 pov27
   SELECT COUNT(*) INTO l_cnt FROM pov_file
    WHERE pov01 = '0'
      AND pov02 = g_pmm.pmm09
   IF l_cnt = 0 THEN
     CALL cl_err(g_pmm.pmm09,'apm-965',1)
     RETURN 0
   END IF
   SELECT pov03,pov27 INTO l_pov03,l_pov27
     FROM pov_file
    WHERE pov01 = '0'
      AND pov02 = g_pmm.pmm09
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_pmm.pmm09,SQLCA.sqlcode,1)
     RETURN 0
   END IF
   SELECT azp03 INTO l_azp03 FROM azp_file    #TQC-990097
    WHERE azp01 = l_pov03
   IF SQLCA.sqlcode THEN
     CALL cl_err(l_pov03,SQLCA.sqlcode,1)
     RETURN 0
   END IF
   LET l_azp03 = s_dbstring(l_azp03)  #TQC-950010 ADD    
  #LET l_sql = "SELECT COUNT(*) FROM ",l_azp03,"pov_file",                         #FUN-A50102 mark
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_pov03,'pov_file'),    #FUN-A50102
               " WHERE pov01 = '1'",  #客戶
               #"   AND pov02 = '", l_pov27 CLIPPED,"'",    #CHI-CC0033 mark
               "   AND pov03 = '", g_plant CLIPPED,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#MOD-990178
   CALL cl_parse_qry_sql(l_sql,l_pov03) RETURNING l_sql #FUN-A50102
   PREPARE pov_pre FROM l_sql
   EXECUTE pov_pre INTO l_cnt
   IF l_cnt = 0 THEN
     CALL cl_err(l_pov27,'apm-966',1)
     RETURN 0
   END IF
 
   RETURN 1
END FUNCTION
 
#多角貿易資料維護============= No.7920 流程代碼抓法修改
FUNCTION t540_v()
   DEFINE l_poz02  LIKE poz_file.poz02,
          l_poy03  LIKE poy_file.poy03,
          t_azp03  STRING,                 #TQC-9C0075
          l_pmc01  LIKE pmc_file.pmc01,   #MOD-870085 add        
          l_sql    STRING,                #MOD-870085 add        
          l_msg    STRING,                #MOD-870085 add
          l_poy31  LIKE poy_file.poy03,
          l_poy32  LIKE poy_file.poy03,
          l_poy33  LIKE poy_file.poy03,
          l_poy34  LIKE poy_file.poy03,
          l_poy35  LIKE poy_file.poy03,
          l_poy36  LIKE poy_file.poy03
   DEFINE l_ans     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE i        LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE l_pox03  LIKE pox_file.pox03     #No.FUN-660051
   DEFINE l_poy04_s LIKE poy_file.poy04    #FUN-670007
   DEFINE l_t      LIKE smy_file.smyslip,
          l_smy53  LIKE smy_file.smy53,
          l_poz13  LIKE poz_file.poz13,
          l_poz14  LIKE poz_file.poz14
   DEFINE l_cnt    LIKE type_file.num5     #MOD-950102
   DEFINE t_plant  LIKE azp_file.azp01     #TQC-9C0075
   DEFINE l_azp03  LIKE azp_file.azp03     #TQC-9C0075
   DEFINE l_len    LIKE type_file.num5     #TQC-9C0075
   DEFINE l_last LIKE type_file.num5       #FUN-A50102 add
   DEFINE l_last_plant LIKE azp_file.azp01 #FUN-A50102
    IF cl_null(g_pmm.pmm01) THEN CALL cl_err('','-400',1) RETURN END IF  #MOD-640484
    IF cl_null(g_pmm.pmm901) OR g_pmm.pmm901 != 'Y' THEN RETURN END IF
 
 
    #重新讀取資料
    SELECT * INTO g_pmm.*
      FROM pmm_file
      WHERE pmm01=g_pmm.pmm01
 
   #check 單據別如是內部交易，則供應商一定要設定pov，且對應營運中心的客戶也要設定pov
    LET l_t = s_get_doc_no(g_pmm.pmm01)
    SELECT smy53 INTO l_smy53 FROM smy_file
     WHERE smyslip = l_t
    IF l_smy53 = 'Y' AND NOT cl_null(l_smy53) THEN  #內部交易單據  #TQC-7C0164 add not cl_null(smy53)
      IF t540_chk_pv() THEN
        LET g_success = 'Y'
        CALL t540_pv()
        IF g_success = 'N' THEN
          CALL cl_err('','apm-968',1)
          RETURN
        END IF
      ELSE
        RETURN
      END IF
    END IF
 
    LET p_row = 06 LET p_col = 11
    OPEN WINDOW t540_vw AT p_row,p_col WITH FORM "apm/42f/apmt540_v"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt540_v")
 
 
    #讀取流程代碼相關資料
    LET l_poz02=null
    LET l_poy31=null  LET l_poy32=null
    LET l_poy33=null  LET l_poy34=null
    LET l_poy35=null  LET l_poy36=null
    IF g_pmm.pmm904 IS NOT NULL THEN
       SELECT poz02,poz13,poz14 INTO l_poz02,l_poz13,l_poz14 FROM poz_file WHERE poz01 = g_pmm.pmm904    #FUN-7C0014 add poz13,14
       FOR i = 1 TO 6
           SELECT poy03 INTO l_poy03 FROM poy_file
            WHERE poy01 = g_pmm.pmm904 AND poy02 = i
           IF STATUS THEN LET l_poy03 = '' END IF
           CASE i
              WHEN 1 LET l_poy31 = l_poy03
              WHEN 2 LET l_poy32 = l_poy03
              WHEN 3 LET l_poy33 = l_poy03
              WHEN 4 LET l_poy34 = l_poy03
              WHEN 5 LET l_poy35 = l_poy03
              WHEN 6 LET l_poy36 = l_poy03
           END CASE
       END FOR
    END IF
    DISPLAY l_poz02 TO FORMONLY.poz02
    DISPLAY l_poy31 TO FORMONLY.poy31
    DISPLAY l_poy32 TO FORMONLY.poy32
    DISPLAY l_poy33 TO FORMONLY.poy33
    DISPLAY l_poy34 TO FORMONLY.poy34
    DISPLAY l_poy35 TO FORMONLY.poy35
    DISPLAY l_poy36 TO FORMONLY.poy36
    #若已拋轉則不可更改資料
    IF g_pmm.pmm905='Y'  THEN
       DISPLAY BY NAME g_pmm.pmm901,g_pmm.pmm902,g_pmm.pmm904,
                  g_pmm.pmm911,g_pmm.pmm912,g_pmm.pmm913,g_pmm.pmm914,
                  g_pmm.pmm915,g_pmm.pmm916,g_pmm.pmm50,g_pmm.pmm903,
                  g_pmm.pmm905
 
       LET INT_FLAG = 0  ######add for prompt bug
 
      CALL t540_menu1()    #TQC-7C0018  add
       CLOSE WINDOW t540_vw
       RETURN
    END IF
 
    INPUT BY NAME g_pmm.pmm901,g_pmm.pmm902,g_pmm.pmm904,
                  g_pmm.pmm911,g_pmm.pmm912,g_pmm.pmm913,g_pmm.pmm914,
                  g_pmm.pmm915,g_pmm.pmm916,g_pmm.pmm50,g_pmm.pmm903,
              g_pmm.pmm905
          WITHOUT DEFAULTS
 
      #如是內部交易，不可輸入最終供應商
       BEFORE INPUT
         CALL t540_set_entry_v(l_smy53)
         CALL t540_set_no_entry_v(l_smy53)
 
       AFTER FIELD pmm904
          IF NOT cl_null(g_pmm.pmm904) THEN
              #檢查第一站與主畫面輸入的資料是否穩合
              SELECT * INTO g_poz.* FROM poz_file
               WHERE poz01 = g_pmm.pmm904 AND pozacti = 'Y'
              IF STATUS THEN
                 CALL cl_err3("sel","poz_file",g_pmm.pmm904,"","tri-006","","",1)  #No.FUN-660129
                 NEXT FIELD pmm904
              END IF
              IF g_poz.poz00 != '2' THEN
                 CALL cl_err('','tri-008',1) NEXT FIELD pmm904
              END IF
             #目前己無poz05起始站
              SELECT poy04 INTO l_poy04_s FROM poy_file
               WHERE poy01 = g_pmm.pmm904
                 AND poy02 = 0
              IF l_poy04_s <> g_plant THEN
                 CALL cl_err('','apm-012',1)
                 NEXT FIELD pmm904
              END IF
             SELECT * INTO g_poy.* FROM poy_file
             WHERE poy01 = g_pmm.pmm904 AND poy02 = 1
             IF g_poy.poy03 <> g_pmm.pmm09 THEN
                CALL cl_err('','apm-007',1)  #MOD-640484
                NEXT FIELD pmm904
             END IF
             # 若不指定幣別，則不用對應流程代碼的幣別
             IF g_poz.poz09 = 'Y' THEN
                IF g_poy.poy05 <> g_pmm.pmm22 THEN
                   CALL cl_err('','apm-008',1)  #MOD-640484
                   NEXT FIELD pmm904
                END IF
             END IF
 
 
 
           IF NOT (l_smy53 = 'Y' AND NOT cl_null(l_smy53) ) THEN  #一般多角貿易 #FUN-7C0004 兩角內部交易不判斷第1站付款條件及PO稅別 #TQC-7C0164
             IF g_poy.poy06 <> g_pmm.pmm20 THEN
                CALL cl_err('','apm-009',1)   #MOD-640484
                NEXT FIELD pmm904
             END IF
             IF g_poy.poy09 <> g_pmm.pmm21 THEN
                CALL cl_err('','apm-010',1)  #MOD-640484
                NEXT FIELD pmm904
             END IF
           END IF  #FUN-7C0004
              LET g_sql = "SELECT pox03 FROM pox_file ",
                          " WHERE pox01 = '",g_pmm.pmm904,"'",
                          "   AND pox02 <= '",g_today,"'",
                          " ORDER BY pox02 "
              PREPARE pox_pre1 FROM g_sql
              IF SQLCA.sqlcode THEN
                  CALL cl_err('pox pre1:',SQLCA.sqlcode,1)
              END IF
              DECLARE pox_curs SCROLL CURSOR FOR pox_pre1
              OPEN pox_curs
              FETCH LAST pox_curs INTO l_pox03
              IF l_pox03 = "3" OR l_pox03 = "4" THEN
                 CALL cl_set_comp_required("pmm50",TRUE)
              ELSE
                 CALL cl_set_comp_required("pmm50",FALSE)
              END IF
              LET l_poz02=g_poz.poz02
              IF g_pmm_t.pmm904 IS NULL OR g_pmm.pmm904<>g_pmm_t.pmm904 THEN
                 FOR i = 1 TO 6
                     SELECT poy03 INTO l_poy03 FROM poy_file
                      WHERE poy01 = g_pmm.pmm904 AND poy02 = i
                     IF STATUS THEN LET l_poy03 = '' END IF
                     CASE i
                       WHEN 1 LET l_poy31 = l_poy03
                       WHEN 2 LET l_poy32 = l_poy03
                       WHEN 3 LET l_poy33 = l_poy03
                       WHEN 4 LET l_poy34 = l_poy03
                       WHEN 5 LET l_poy35 = l_poy03
                       WHEN 6 LET l_poy36 = l_poy03
                    END CASE
                 END FOR
                 DISPLAY l_poz02 TO FORMONLY.poz02
                 DISPLAY l_poy31 TO FORMONLY.poy31
                 DISPLAY l_poy32 TO FORMONLY.poy32
                 DISPLAY l_poy33 TO FORMONLY.poy33
                 DISPLAY l_poy34 TO FORMONLY.poy34
                 DISPLAY l_poy35 TO FORMONLY.poy35
                 DISPLAY l_poy36 TO FORMONLY.poy36
                 LET g_pmm.pmm903=g_poz.poz03
                 DISPLAY BY NAME g_pmm.pmm903
                 LET g_pmm.pmm911 = l_poy31
                 LET g_pmm.pmm912 = l_poy32
                 LET g_pmm.pmm913 = l_poy33
                 LET g_pmm.pmm914 = l_poy34
                 LET g_pmm.pmm915 = l_poy35
                 LET g_pmm.pmm916 = l_poy36
                 DISPLAY BY NAME g_pmm.pmm911,g_pmm.pmm912,g_pmm.pmm913,
                                 g_pmm.pmm914,g_pmm.pmm915,g_pmm.pmm916
              END IF
          END IF
          LET g_pmm_t.pmm904= g_pmm.pmm904
 
       AFTER FIELD pmm50
          IF NOT cl_null(g_pmm.pmm50) THEN
             SELECT count(*) INTO l_cnt FROM poy_file
              WHERE poy01 = g_pmm.pmm904
                AND poy02 = 99  
             IF l_cnt = 0 THEN
                CALL cl_err(g_pmm.pmm50,'apm-069',1)  
                NEXT FIELD pmm50
             END IF
               CALL t540_azp() RETURNING t_azp03
               CALL s_mtrade_last_plant(g_pmm.pmm904)  RETURNING l_last,l_last_plant          #FUN-A50102 
              #LET l_sql = " SELECT pmc01 FROM ",t_azp03 CLIPPED,"pmc_file" ,                 #FUN-A50102  mark
               LET l_sql = " SELECT pmc01 FROM ",cl_get_target_table(l_last_plant,'pmc_file'),#FUN-A50102  
                           "  WHERE pmc01 = '",g_pmm.pmm50,"'"
	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#MOD-990178
               CALL cl_parse_qry_sql(l_sql,l_last_plant) RETURNING l_sql#FUN-A50102
               PREPARE pmc_pre FROM l_sql
               DECLARE pmc_cs CURSOR FOR pmc_pre
               OPEN pmc_cs
               FETCH pmc_cs INTO l_pmc01
             IF STATUS THEN
                LET l_msg = 'select ',t_azp03 CLIPPED,' pmc'   #MOD-870085 add
                CALL cl_err3("sel","pmc_file",g_pmm.pmm50,"",SQLCA.sqlcode,"",l_msg,1)  #No.FUN-660129  #MOD-870085 modify select pmc->l_msg
                NEXT FIELD pmm50
             END IF
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF g_pmm.pmm901='Y' AND cl_null(g_pmm.pmm904) THEN
             NEXT FIELD pmm904
          END IF
        ON ACTION CONTROLP
           CASE
            WHEN INFIELD(pmm904)
                 CALL cl_init_qry_var()
 
                 IF l_smy53 = 'Y' AND NOT cl_null(l_smy53) THEN #兩角內部交易
                   LET g_qryparam.form = "q_poz4"
                 ELSE                                           #一般多角貿易
                   LET g_qryparam.form = "q_poz1"   #FUN-5A0101
                 END IF
                 LET g_qryparam.default1 = g_pmm.pmm904
                 LET g_qryparam.arg1     = '2'
                 IF l_smy53 = 'Y' AND NOT cl_null(l_smy53) THEN   #TQC-7C0164 add not cl_null(smy53)
                   LET g_qryparam.arg2 = l_poz13
                   LET g_qryparam.arg3 = l_poz14
                 END IF
                 CALL cl_create_qry() RETURNING g_pmm.pmm904
                 DISPLAY BY NAME g_pmm.pmm904
                 NEXT FIELD pmm904
              WHEN INFIELD(pmm911)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmm.pmm911
                 CALL cl_create_qry() RETURNING g_pmm.pmm911
                 DISPLAY BY NAME g_pmm.pmm911
                 NEXT FIELD pmm911
              WHEN INFIELD(pmm912)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmm.pmm912
                 CALL cl_create_qry() RETURNING g_pmm.pmm912
                 DISPLAY BY NAME g_pmm.pmm912
                 NEXT FIELD pmm912
              WHEN INFIELD(pmm913)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmm.pmm913
                 CALL cl_create_qry() RETURNING g_pmm.pmm913
                 DISPLAY BY NAME g_pmm.pmm913
                 NEXT FIELD pmm913
              WHEN INFIELD(pmm914)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmm.pmm914
                 CALL cl_create_qry() RETURNING g_pmm.pmm914
                 DISPLAY BY NAME g_pmm.pmm914
                 NEXT FIELD pmm914
              WHEN INFIELD(pmm915)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmm.pmm915
                 CALL cl_create_qry() RETURNING g_pmm.pmm915
                 DISPLAY BY NAME g_pmm.pmm915
                 NEXT FIELD pmm915
              WHEN INFIELD(pmm50)
                 CALL t540_azp() RETURNING t_azp03
                 LET l_len=t_azp03.getIndexOf('.',1)
                 LET l_azp03=t_azp03.subString(1,l_len-1)  
                 SELECT azp01 INTO t_plant FROM azp_file
                  WHERE azp03 = l_azp03
                 CALL q_m_pmc3(FALSE,TRUE,g_pmm.pmm50,t_plant)  
                 RETURNING g_pmm.pmm50
                 DISPLAY BY NAME g_pmm.pmm50
                 NEXT FIELD pmm50
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    CLOSE WINDOW t540_vw
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    UPDATE pmm_file SET * = g_pmm.* WHERE pmm01 = g_pmm.pmm01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","update pmm",1)  #No.FUN-660129
    END IF
    CALL t540_pmm21('a')   #No.MOD-930045
    CALL t540_pmm20('a')
    DISPLAY BY NAME g_pmm.pmm20 ,g_pmm.pmm21 ,g_pmm.pmm22,
                    g_pmm.pmm41 ,g_pmm.pmm10 ,g_pmm.pmm11,
                    g_pmm.pmm42,g_pmm.pmm43
END FUNCTION
 
FUNCTION t540_menu1()
MENU ""
     ON ACTION locale
  CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION exit
        LET g_action_choice = "exit"
           EXIT MENU
 
     COMMAND KEY(INTERRUPT)
          EXIT MENU
 
     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       EXIT MENU
 
     ON ACTION about         
        CALL cl_about()     
 
     ON ACTION help          
        CALL cl_show_help() 
 
     ON ACTION controlg      
        CALL cl_cmdask()     
 
 
END MENU
END FUNCTION
 
FUNCTION s_chkoga()  #檢查是否有已製出貨單但未扣帳,以免資料不壹致 No.7920
 DEFINE l_sql      STRING #No.FUN-680136 VARCHAR(600) #FUN-730068
 DEFINE l_azp      RECORD LIKE azp_file.*
 DEFINE l_cnt      LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_dbs      LIKE azp_file.azp01    #No.FUN-680136 VARCHAR(10)
 DEFINE l_dbs_new  LIKE type_file.chr21   #No.FUN-680136 VARCHAR(21)
 DEFINE i,j        LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_last     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_oea01    LIKE oea_file.oea01    #No.MOD-8B0188 add
 DEFINE p_dbs_tra  LIKE azw_file.azw05    #FUN-980093 add
 DEFINE p_plant_new LIKE azp_file.azp01    #FUN-980093 add
 
   SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_pmm.pmm904
   IF STATUS THEN
      RETURN 0
   END IF
   CALL t540_last() RETURNING l_last
   FOR j = 1 TO l_last
      SELECT poy04 INTO l_dbs FROM poy_file
       WHERE poy01 = g_pmm.pmm904 AND poy02 = j
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = l_dbs
      LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010    
 
      LET g_plant_new = l_dbs
      LET p_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET p_dbs_tra = g_dbs_tra
 
    # LET l_sql = " SELECT oea01 FROM ",p_dbs_tra CLIPPED,"oea_file ",  #FUN-980093 add      #FUN-A50102 mark
      LET l_sql = " SELECT oea01 FROM ",cl_get_target_table(p_plant_new,'oea_file'),               #FUN-A50102
                  "  WHERE oea99 = '",g_pmm.pmm99,"'"   #TQC-970328
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-920032  #FUN-950007 add
       CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql #FUN-980093
      PREPARE oea01_prepare FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('oea01_prepare:',SQLCA.sqlcode,1)   #No.FUN-660129
         RETURN 0
      END IF
      DECLARE oea01_curs CURSOR FOR oea01_prepare
      OPEN oea01_curs
      FETCH oea01_curs INTO l_oea01
      IF cl_null(l_oea01) THEN LET l_oea01 = g_pmm.pmm01 END IF
      CLOSE oea01_curs
      LET l_sql = " SELECT COUNT(*) ",
            # "   FROM ",p_dbs_tra CLIPPED,"oga_file ",  #FUN-980093 add      #FUN-A50102 mark
              "   FROM ",cl_get_target_table(p_plant_new,'oga_file'),               #FUN-A50102
              "  WHERE oga16 = '",l_oea01,"'",      #No.MOD-8B0188 mark
              "    AND (oga09 = '4' OR oga09 = '5' OR oga09 = '6')",
                  "    AND ogaconf <> 'X'"   #No.MOD-590182
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-950007 add
       CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql #FUN-980093
      PREPARE chkoga_prepare1 FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)   #No.FUN-660129
         RETURN 0
      END IF
      DECLARE chkoga_curs1 CURSOR FOR chkoga_prepare1
      OPEN chkoga_curs1
      FETCH chkoga_curs1 INTO l_cnt
      IF SQLCA.sqlcode THEN LET L_cnt = 0 END IF
      IF l_cnt > 0 THEN
         CALL cl_err(l_dbs,'tri-022',1)    #MOD-4C0072
         RETURN 0
      END IF
      CLOSE chkoga_curs1
   END FOR
   RETURN 1
END FUNCTION
 
FUNCTION t540_last()  #取得最終站資料庫 No.7920
 DEFINE l_last   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
  SELECT MAX(poy02) INTO l_last FROM poy_file
   WHERE poy01 = g_pmm.pmm904
  IF STATUS THEN
     CALL cl_err3("sel","poy_file","","","axm-318","","",1)  #No.FUN-660129
     RETURN ''
  END IF
  IF cl_null(l_last) THEN LET l_last = 1 END IF
  RETURN l_last
END FUNCTION
 
FUNCTION t540_ef()
 
     CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
     IF g_success = "N" THEN
         RETURN
     END IF
 
     CALL aws_condition()#判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
      IF aws_efcli2(base.TypeInfo.create(g_pmm),base.TypeInfo.create(g_pmn),'','','','')
      THEN
         LET g_success = 'Y'
         LET g_pmm.pmm25 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
         DISPLAY BY NAME g_pmm.pmm25
         CALL t540_show()                      # 重新顯示    #FUN-550038
      ELSE
         LET g_success = 'N'
      END IF
END FUNCTION
 
 
FUNCTION t540_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN #OR INFIELD(pmm01) THEN
       #CALL cl_set_comp_entry("pmm01,pmm02,pmm09,pmm45",TRUE)         #FUN-690047 add pmm45   #MOD-740282 add pmm09  #No.FUN-830161   #MOD-A80075
       CALL cl_set_comp_entry("pmm01,pmm02,pmm45",TRUE)         #FUN-690047 add pmm45   #MOD-740282 add pmm09  #No.FUN-830161   #MOD-A80075
   END IF
 
   CALL cl_set_comp_entry("pmm15",TRUE)   #MOD-C80239 add
END FUNCTION
 
FUNCTION t540_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   #請購與採購需要互相勾稽時,pmm45不可修改
   IF p_cmd = 'u' AND g_sma.sma32='Y' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmm45",FALSE)
   END IF
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
       CALL cl_set_comp_entry("pmm01",FALSE)   #MOD-740298 add pmm02   #MOD-890229拿掉pmm03
   END IF
   IF g_argv3 = 'SUB' OR g_pmm.pmm02 = 'SUB' THEN
       CALL cl_set_comp_entry("pmm02",FALSE)
   END IF
   #-----MOD-A80075---------
   #IF g_pmm.pmm909 = '3' THEN
   #    CALL cl_set_comp_entry("pmm09",FALSE)
   #END IF
   #-----END MOD-A80075-----

  #MOD-C80239---S---
   IF p_cmd='u' OR p_cmd='a' THEN
      CALL cl_set_comp_entry("pmm15",FALSE)
   END IF
  #MOD-C80239---E---

END FUNCTION
 
FUNCTION t540_set_entry_v(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1
  CALL cl_set_comp_entry("pmm50",TRUE)
END FUNCTION
FUNCTION t540_set_no_entry_v(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1
 
  IF p_cmd = 'Y' THEN
    CALL cl_set_comp_entry("pmm50",FALSE)
  END IF
END FUNCTION
 
FUNCTION t540_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   l_pmc914  LIKE pmc_file.pmc914   #MOD-BC0303 add
 
   CALL cl_set_comp_entry("pmn96,pmn97",TRUE)                     #MOD-B90126 add

   IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("pmn24,pmn68,pmn69,pmn65,pmn31,pmn31t",TRUE)  #No.FUN-550019
   END IF
 
   IF g_pmm.pmm45='Y' AND (NOT g_before_input_done) AND
      g_pmn[l_ac].pmn24 IS NULL AND g_pmn[l_ac].pmn25 IS NULL THEN
      CALL cl_set_comp_entry("pmn38",TRUE)
   END IF
 
   IF INFIELD(pmn24) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmn04",TRUE)
   END IF
 
   IF INFIELD(pmn04) OR (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("pmn041",TRUE)
   END IF
 
   IF INFIELD(pmn25) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmn122,pmn96,pmn97",TRUE)
   END IF
 
   CALL cl_set_comp_entry("pmn81,pmn83,pmn84,pmn85,pmn86,pmn87",TRUE)
   IF p_cmd = 's' AND g_sma.sma120 ="Y" THEN
      CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",TRUE)
   END IF
 
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_entry("pmn930",TRUE)
   END IF
      #CHI-AA0025 拿掉pmn20
      CALL cl_set_comp_entry("pmn02,pmn24,pmn25,pmn65,pmn41,                              pmn04,pmn07,pmn83,pmn84,pmn85,pmn80,                              pmn81,pmn82,pmn86,pmn87",TRUE)
   #MOD-BC0303 ----- modify start -----
   SELECT pmc914 INTO l_pmc914 FROM pmc_file
     WHERE pmc01 = g_pmm.pmm09
   IF l_pmc914 = 'Y' THEN
      CALL cl_set_comp_entry("pmn89",TRUE)
   END IF
   #MOD-BC0303 ----- modify end -----
END FUNCTION
 
FUNCTION t540_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         l_pjb25   LIKE pjb_file.pjb25     #MOD-B90126
DEFINE   l_pmc914  LIKE pmc_file.pmc914   #MOD-BC0303 add
 
   IF (g_pmm.pmm45='N' AND (NOT g_before_input_done)) OR
      (NOT cl_null(g_pmn[l_ac].pmn24) OR NOT cl_null(g_pmn[l_ac].pmn25)) THEN
      CALL cl_set_comp_entry("pmn38",FALSE)
   END IF
 
   IF (NOT cl_null(g_pmn[l_ac].pmn24) AND NOT cl_null(g_pmn[l_ac].pmn25)) OR NOT cl_null(g_pmn[l_ac].pmn41) THEN
      CALL cl_set_comp_entry("pmn122,pmn96,pmn97",FALSE)
   END IF
   IF (NOT cl_null(g_pmn[l_ac].pmn68) AND NOT cl_null(g_pmn[l_ac].pmn69)) THEN
      CALL cl_set_comp_entry("pmn122",FALSE)
   END IF
 
   IF NOT cl_null(g_pmn[l_ac].pmn24) THEN
      CALL cl_set_comp_entry("pmn04",FALSE)
      IF  g_before_input_done THEN
          IF g_pmn[l_ac].pmn04[1,4] != 'MISC' THEN
              CALL cl_set_comp_entry("pmn041",FALSE)
          END IF
      END IF
 
      IF NOT cl_null(g_sma.sma120) AND g_sma.sma907 = 'Y' THEN
         CALL cl_set_comp_entry("att00,att01,att01_c,att02,att02_c,att03,att03_c,                              att04,att04_c,att05,att05_c,att06,att06_c,att07,                              att07_c,att08,att08_c,att09,att09_c,att10,                              att10_c ",FALSE)
      END IF
   END IF
 
   IF INFIELD(pmn04) OR (NOT g_before_input_done) THEN
       IF g_pmn[l_ac].pmn04[1,4] != 'MISC' THEN
           CALL cl_set_comp_entry("pmn041",FALSE)
       END IF
   END IF
 
   IF NOT g_before_input_done THEN
       IF p_cmd='u' AND
          NOT cl_null(g_pmn[l_ac].pmn24) AND
          NOT cl_null(g_pmn[l_ac].pmn25) AND
          g_pmn[l_ac].pmn24=g_pmn_t.pmn24 AND
          g_pmn[l_ac].pmn25=g_pmn_t.pmn25 THEN
           CALL cl_set_comp_entry("pmn24",FALSE)
       END IF
 
       IF NOT cl_null(g_pmn[l_ac].pmn24) THEN
           CALL cl_set_comp_entry("pmn04",FALSE)
           CALL cl_set_comp_entry("pmn041",FALSE)   #MOD-610151
       END IF
       IF g_smy.smy57[4,4] = 'N' THEN
           CALL cl_set_comp_entry("pmn68,pmn69",FALSE)
       END IF
 
       IF g_pmm.pmm02 != 'SUB' THEN
           CALL cl_set_comp_entry("pmn65",FALSE)
       END IF
 
       IF g_gec07 = 'N' THEN          #No.FUN-560102
          CALL cl_set_comp_entry("pmn31t",FALSE)
       ELSE
          CALL cl_set_comp_entry("pmn31",FALSE)
       END IF
   END IF
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("pmn83,pmn84,pmn85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("pmn83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("pmn84,pmn81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("pmn86,pmn87",FALSE)
   END IF
    IF p_cmd ='s' AND g_sma.sma120 ="Y" AND NOT cl_null(g_pmn[l_ac].pmn25)
       AND NOT cl_null(g_pmn[l_ac].pmn24) THEN
       CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",FALSE)
    END IF
 
   IF g_pmm.pmm909 = '3' THEN  #CHI-740014 拿掉 pmn42,pmn16,
      #CHI-AA0025 拿掉pmn20
      CALL cl_set_comp_entry("pmn02,pmn24,pmn25,pmn65,pmn41,                              pmn04,pmn07,pmn83,pmn84,pmn85,pmn80,                              pmn81,pmn82,pmn86,pmn87",FALSE)
   END IF
 
   IF NOT cl_null(g_pmn[l_ac].pmn72) THEN
      CALL cl_set_comp_entry("pmn04,pmn07",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmn04,pmn07",TRUE)
   END IF

   #MOD-B90126 --- start ---
   IF cl_null(g_pmn[l_ac].pmn122) THEN
      CALL cl_set_comp_entry("pmn96,pmn97",FALSE)
   END IF

   SELECT pjb25 INTO l_pjb25 FROM pjb_file
    WHERE pjb02 = g_pmn[l_ac].pmn96
   IF l_pjb25 = 'N' THEN
      CALL cl_set_comp_entry("pmn97",FALSE)
   END IF
   #MOD-B90126 ---  end  ---

   #MOD-BC0303 ----- modify start -----
   SELECT pmc914 INTO l_pmc914 FROM pmc_file
     WHERE pmc01 = g_pmm.pmm09
   IF l_pmc914 = 'N' THEN
      CALL cl_set_comp_entry("pmn89",FALSE)
   END IF
   #MOD-BC0303 ----- modify end -----
END FUNCTION
 
FUNCTION t540_set_required()
               
   IF g_pmm.pmm02 = 'SUB' THEN
      CALL cl_set_comp_required("pmn24,pmn25",FALSE)
   ELSE
      #FUN-C30211---begin
      IF (g_pmm.pmm02 = 'WB1' OR g_pmm.pmm02 = 'WB2') AND g_sma.sma32 matches'[Yy]' THEN
         CALL cl_set_comp_required("pmn24,pmn25",FALSE)
      ELSE 
      #FUN-C30211---end
         CALL cl_set_comp_required("pmn24,pmn25",g_sma.sma32 matches'[Yy]')                      
      END IF    #FUN-C30211
   END IF
 
   #輸入沖銷無交期採購單的採購單時，Blanket PO單號、Blanket PO項次為必要輸入欄位
   IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
      CALL cl_set_comp_required("pmn68,pmn69",TRUE)
   END IF
 
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_required("pmn83,pmn85,pmn80,pmn82",TRUE)
   END IF
   IF g_sma.sma115='Y' THEN  #MOD-710141  add
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_pmn[l_ac].pmn80) THEN
      CALL cl_set_comp_required("pmn82",TRUE)
   END IF
   IF NOT cl_null(g_pmn[l_ac].pmn83) THEN
      CALL cl_set_comp_required("pmn85",TRUE)
   END IF
   END IF                    #MOD-710141 add
   IF g_sma.sma116 NOT MATCHES '[02]' THEN
     IF NOT cl_null(g_pmn[l_ac].pmn86) THEN
        CALL cl_set_comp_required("pmn87",TRUE)
     END IF
   END IF

END FUNCTION
 
FUNCTION t540_set_no_required()
 
  CALL cl_set_comp_required("pmn83,pmn84,pmn85,pmn80,pmn81,pmn82,pmn86,pmn87",FALSE)
 
  CALL cl_set_comp_required("pmn68,pmn69",FALSE)
END FUNCTION

#MOD-BA0075 mark --start--
#FUNCTION t540_set_no_required_pmn52()
#  CALL cl_set_comp_required("pmn52,pmn56",FALSE)  #CHI-9C0025
#END FUNCTION
#
#FUNCTION t540_set_required_pmn52()
#   IF g_ccz.ccz28 = '3' THEN
#      CALL cl_set_comp_required("pmn56",TRUE)
#   END IF
#   IF g_ccz.ccz28 = '5' THEN
#      CALL cl_set_comp_required("pmn52",TRUE)
#   END IF
#END FUNCTION
#MOD-BA0075 mark --end--

#FUN-D40103--mark--str--
#FUNCTION t540_chk_pmn54()
#DEFINE l_n  LIKE type_file.num5
#
#   LET l_n = 0
#   SELECT count(*) INTO l_n FROM ime_file
#    WHERE ime01 = g_pmn[l_ac].pmn52
#      AND ime02 = g_pmn[l_ac].pmn54
#   IF l_n = 0 THEN
#      RETURN 0
#   ELSE
#      RETURN 1
#   END IF
#END FUNCTION
#FUN-D40103--mark--end--

#用于default 雙單位/轉換率/數量
FUNCTION t540_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima31  LIKE ima_file.ima31,
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_pmn[l_ac].pmn04
 
    SELECT ima44,ima31,ima906,ima907,ima908
      INTO l_ima44,l_ima31,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF g_sma.sma115 = 'Y' THEN             #No.TQC-6C0131 add
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET l_unit2 = NULL
          LET l_fac2  = NULL
          LET l_qty2  = NULL
       ELSE
          LET l_unit2 = l_ima907
          CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET l_fac2 = l_factor
          LET l_qty2  = 0
       END IF
 
       LET l_unit1 = l_ima44
       LET l_fac1  = 1
       LET l_qty1  = 0
    END IF                #No.TQC-6C0131 add
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_pmn[l_ac].pmn83=l_unit2
       LET g_pmn[l_ac].pmn84=l_fac2
       LET g_pmn[l_ac].pmn85=l_qty2
       LET g_pmn[l_ac].pmn80=l_unit1
       LET g_pmn[l_ac].pmn81=l_fac1
       LET g_pmn[l_ac].pmn82=l_qty1
       LET g_pmn[l_ac].pmn86=l_unit3
       LET g_pmn[l_ac].pmn87=l_qty3
       LET g_pmn[l_ac].pmn87 = s_digqty(g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn86)   #No.FUN-BB0086
       LET g_pmn2.pmn83 = g_pmn[l_ac].pmn83
       LET g_pmn2.pmn84 = g_pmn[l_ac].pmn84
       LET g_pmn2.pmn85 = g_pmn[l_ac].pmn85
       LET g_pmn2.pmn80 = g_pmn[l_ac].pmn80
       LET g_pmn2.pmn81 = g_pmn[l_ac].pmn81
       LET g_pmn2.pmn82 = g_pmn[l_ac].pmn82
       LET g_pmn2.pmn86 = g_pmn[l_ac].pmn86
       LET g_pmn2.pmn87 = g_pmn[l_ac].pmn87
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t540_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor LIKE ima_file.ima31_fac,  #No.FUN-680136 DECIMAL(16,8)
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
    IF SQLCA.sqlcode = 100 THEN
       IF g_pmn[l_ac].pmn04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_pmn[l_ac].pmn84
    LET l_qty2=g_pmn[l_ac].pmn85
    LET l_fac1=g_pmn[l_ac].pmn81
    LET l_qty1=g_pmn[l_ac].pmn82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_pmn[l_ac].pmn07=g_pmn[l_ac].pmn80
                   LET g_pmn[l_ac].pmn20=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_pmn[l_ac].pmn07=l_ima44
                   LET g_pmn[l_ac].pmn20=l_tot
          WHEN '3' LET g_pmn[l_ac].pmn07=g_pmn[l_ac].pmn80
                   LET g_pmn[l_ac].pmn20=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_pmn[l_ac].pmn84=l_qty1/l_qty2
                   ELSE
                      LET g_pmn[l_ac].pmn84=0
                   END IF
       END CASE
       LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #FUN-910088--add--
    END IF
 
    LET g_pmn2.pmn07=g_pmn[l_ac].pmn07
   #MOD-C50063---S---
    IF cl_null(g_pmn2.pmn08) THEN 
       LET g_pmn2.pmn08=l_ima25
    END IF
    CALL s_overate(g_pmn2.pmn04) RETURNING g_pmn2.pmn13
   #MOD-C50063---E---
    LET g_pmn2.pmn20=g_pmn[l_ac].pmn20
 
    LET g_factor = 1
    CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET g_pmn2.pmn09 = g_factor
 
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
       LET g_pmn[l_ac].pmn86 = g_pmn[l_ac].pmn07
       LET g_pmn[l_ac].pmn87 = g_pmn[l_ac].pmn20
    END IF
    LET g_pmn2.pmn88 = g_pmn[l_ac].pmn31 * g_pmn[l_ac].pmn87   #MOD-840137
    LET g_pmn2.pmn88t= g_pmn[l_ac].pmn31t* g_pmn[l_ac].pmn87   #MOD-840137
    SELECT azi04 INTO t_azi04 FROM azi_file     #MOD-7B0265
     WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'   #MOD-7B0265
    #MOD-B10138 add --start--
    CALL cl_digcut(g_pmn2.pmn88,t_azi04) RETURNING  g_pmn2.pmn88  
    CALL cl_digcut(g_pmn2.pmn88t,t_azi04) RETURNING g_pmn2.pmn88t 
    #MOD-B10138 add --end--
    IF g_gec07 = 'N' THEN
       LET g_pmn2.pmn88t = g_pmn2.pmn88 * ( 1 + g_pmm.pmm43/100)
       CALL cl_digcut(g_pmn2.pmn88t,t_azi04) RETURNING g_pmn2.pmn88t #MOD-B10138 add 
    ELSE
       #-----CHI-AC0016---------
       #LET g_pmn2.pmn88  = g_pmn2.pmn88t/ ( 1 + g_pmm.pmm43/100)
       #CALL cl_digcut(g_pmn2.pmn88,t_azi04) RETURNING  g_pmn2.pmn88 #MOD-B10138 add
       #IF g_gec05 = 'T' THEN 
       IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
          #TQC-C30225 add begin
          LET g_pmn2.pmn31  = g_pmn2.pmn31t* ( 1 - g_pmm.pmm43/100)
          CALL cl_digcut(g_pmn2.pmn31,t_azi03) RETURNING  g_pmn2.pmn31
          #TQC-C30225 add end
          LET g_pmn2.pmn88  = g_pmn2.pmn88t* ( 1 - g_pmm.pmm43/100)
          CALL cl_digcut(g_pmn2.pmn88,t_azi04) RETURNING  g_pmn2.pmn88 
       ELSE
          LET g_pmn2.pmn88  = g_pmn2.pmn88t/ ( 1 + g_pmm.pmm43/100)
          CALL cl_digcut(g_pmn2.pmn88,t_azi04) RETURNING  g_pmn2.pmn88
       END IF
       #-----END CHI-AC0016----- 
    END IF
   #MOD-B10138 mark --start--
   #CALL cl_digcut(g_pmn2.pmn88,t_azi04) RETURNING  g_pmn2.pmn88  #No.CHI-6A0004
   #CALL cl_digcut(g_pmn2.pmn88t,t_azi04) RETURNING g_pmn2.pmn88t #No.CHI-6A0004
   #MOD-B10138 mark --end--
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t540_du_data_to_correct()
 
   IF cl_null(g_pmn[l_ac].pmn80) THEN
      LET g_pmn[l_ac].pmn81 = NULL
      LET g_pmn[l_ac].pmn82 = NULL
      LET g_pmn2.pmn80 = NULL
      LET g_pmn2.pmn81 = NULL
      LET g_pmn2.pmn82 = NULL
   END IF
 
   IF cl_null(g_pmn[l_ac].pmn83) THEN
      LET g_pmn[l_ac].pmn84 = NULL
      LET g_pmn[l_ac].pmn85 = NULL
      LET g_pmn2.pmn83 = NULL
      LET g_pmn2.pmn84 = NULL
      LET g_pmn2.pmn85 = NULL
   END IF
 
   IF cl_null(g_pmn[l_ac].pmn86) THEN
      LET g_pmn[l_ac].pmn87 = NULL
      LET g_pmn2.pmn86 = NULL
      LET g_pmn2.pmn87 = NULL
   END IF
 
   DISPLAY BY NAME g_pmn[l_ac].pmn81
   DISPLAY BY NAME g_pmn[l_ac].pmn82
   DISPLAY BY NAME g_pmn[l_ac].pmn84
   DISPLAY BY NAME g_pmn[l_ac].pmn85
   DISPLAY BY NAME g_pmn[l_ac].pmn86
   DISPLAY BY NAME g_pmn[l_ac].pmn87
 
END FUNCTION
 
FUNCTION t540_set_pmn87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor  LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
  DEFINE    l_ecm04   LIKE ecm_file.ecm04    #NO.FUN-930148            
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
 
    IF SQLCA.sqlcode =100 THEN
       IF g_pmn[l_ac].pmn04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pmn[l_ac].pmn84
       LET l_qty2=g_pmn[l_ac].pmn85
       LET l_fac1=g_pmn[l_ac].pmn81
       LET l_qty1=g_pmn[l_ac].pmn82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pmn[l_ac].pmn20
       CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    IF g_sma.sma115 = 'Y' THEN
       CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,g_pmn[l_ac].pmn86)
             RETURNING g_cnt,l_factor
    ELSE
       CALL s_umfchk(g_pmn[l_ac].pmn04,l_ima44,g_pmn[l_ac].pmn86)
             RETURNING g_cnt,l_factor
    END IF
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_pmn[l_ac].pmn87 = l_tot
    LET g_pmn[l_ac].pmn87 = s_digqty(g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn86)   #No.FUN-BB0086
    IF g_pmn[l_ac].pmn87 != g_pmn_t.pmn87 THEN 
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
         AND ecm012= g_pmn[l_ac].pmn012                        #No.FUN-A60011
      CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                          g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,
                          g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
             RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                       g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
       IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF
      CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)   #MOD-9C0285 ADD
      #MOD-B30280 add --start--
      LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
      CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44
      #MOD-B30280 add --end--
    END IF                  
END FUNCTION
 
FUNCTION t540_set_du_by_origin(p_code)
  DEFINE l_ima44    LIKE ima_file.ima44,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_pmn04    LIKE pmn_file.pmn04,
         l_factor   LIKE ima_file.ima31_fac,  #No.FUN-680136  DECIMAL(16,8),
         p_code     LIKE type_file.chr1       #No.FUN-680136  VARCHAR(01)
    IF p_code ='b' THEN
       LET l_pmn04 = g_pmn2.pmn04
    ELSE
       LET l_pmn04 = g_pmn[l_ac].pmn04
    END IF
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_pmn04
 
    IF p_code = 'b' THEN
       IF cl_null(g_pmn2.pmn80) THEN
          LET g_pmn2.pmn80 = g_pmn2.pmn07
          LET g_pmn2.pmn81 = g_pmn2.pmn09
          LET g_pmn2.pmn82 = g_pmn2.pmn20
       END IF
 
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET g_pmn2.pmn83 = NULL
          LET g_pmn2.pmn84 = NULL
          LET g_pmn2.pmn85 = NULL
       ELSE
          IF cl_null(g_pmn2.pmn83) THEN
             LET g_pmn2.pmn83 = l_ima907
             CALL s_du_umfchk(l_pmn04,'','','',g_pmn2.pmn07,l_ima907,l_ima906)
                  RETURNING g_errno,l_factor
             LET g_pmn2.pmn84 = l_factor
             LET g_pmn2.pmn85 = 0
          END IF
       END IF
       IF cl_null(g_pmn2.pmn86) THEN
          LET g_pmn2.pmn86 = g_pmn2.pmn07
          LET g_pmn2.pmn87 = g_pmn2.pmn20
       END IF
    ELSE
       IF cl_null(g_pmn[l_ac].pmn80) THEN
          LET g_pmn[l_ac].pmn80 = g_pmn[l_ac].pmn07
          LET g_pmn[l_ac].pmn81 = g_pmn2.pmn09
          LET g_pmn[l_ac].pmn82 = g_pmn[l_ac].pmn20
       END IF
 
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET g_pmn[l_ac].pmn83 = NULL
          LET g_pmn[l_ac].pmn84 = NULL
          LET g_pmn[l_ac].pmn85 = NULL
       ELSE
          IF cl_null(g_pmn[l_ac].pmn83) THEN
             LET g_pmn[l_ac].pmn83 = l_ima907
             CALL s_du_umfchk(l_pmn04,'','','',g_pmn[l_ac].pmn07,l_ima907,l_ima906)
                  RETURNING g_errno,l_factor
             LET g_pmn[l_ac].pmn84 = l_factor
             LET g_pmn[l_ac].pmn85 = 0
          END IF
       END IF
 
       IF cl_null(g_pmn[l_ac].pmn86) THEN
          LET g_pmn[l_ac].pmn86 = g_pmn[l_ac].pmn07
          LET g_pmn[l_ac].pmn87 = g_pmn[l_ac].pmn20
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t540_set_pmn07()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor  LIKE ima_file.ima31_fac,  #No.FUN-680136 DECIMAL(16,8),
            l_ima44  LIKE ima_file.ima44,
            l_pml07  LIKE pml_file.pml07,
            l_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            p_code   LIKE type_file.chr1     #No.FUN-680136  VARCHAR(01)
 
   SELECT ima44,ima906 INTO l_ima44,l_ima906 FROM ima_file
    WHERE ima01=g_pmn[l_ac].pmn04
   LET l_fac2=g_pmn2.pmn84
   LET l_qty2=g_pmn2.pmn85
   LET l_fac1=g_pmn2.pmn81
   LET l_qty1=g_pmn2.pmn82
 
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET g_pmn2.pmn07=g_pmn2.pmn80
                  LET g_pmn2.pmn20=l_qty1
         WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                  LET g_pmn2.pmn07=l_ima44
                  LET g_pmn2.pmn20=l_tot
                  LET g_pmn2.pmn20 = s_digqty(g_pmn2.pmn20,g_pmn2.pmn07)   #No.FUN-BB0086
         WHEN '3' LET g_pmn2.pmn07=g_pmn2.pmn80
                  LET g_pmn2.pmn20=l_qty1
      END CASE
   ELSE
      LET g_pmn2.pmn07=g_pmn2.pmn80
      LET g_pmn2.pmn20=l_qty1
   END IF
 
   LET g_factor = 1
   CALL s_umfchk(g_pmn2.pmn04,g_pmn2.pmn07,l_ima44)
         RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
      RETURN 1
   END IF
   LET g_pmn2.pmn09 = g_factor
 
   IF NOT cl_null(g_pmn2.pmn07) THEN
      IF (g_pmn_o.pmn07 IS NULL )
          OR (g_pmn2.pmn07 != g_pmn_o.pmn07) THEN
         CALL t540_unit(g_pmn2.pmn07)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pmn2.pmn07,g_errno,1)  #MOD-640484
            LET g_pmn2.pmn07 = g_pmn_o.pmn07
            DISPLAY BY NAME g_pmn2.pmn07
            RETURN 1
         END IF
      END IF
      IF NOT cl_null(g_pmn[l_ac].pmn25) THEN        #增加請購單位判斷
         SELECT pml07 INTO l_pml07 FROM pml_file
          WHERE pml01=g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn2.pmn07,l_pml07)
         RETURNING l_flag,g_pmn2.pmn121
         IF l_flag THEN
            #### -------單位換算率抓不到 ----###
            CALL cl_err('pmn07/pml07: ','abm-731',1)
            RETURN 1
            LET g_pmn2.pmn121=1
         END IF
         LET g_pmn[l_ac].pmn20=g_pmn[l_ac].pmn20*g_pmn2.pmn121
         LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,l_pml07)   #No.FUN-BB0086
      END IF
      IF (g_pmn2.pmn07 != g_pmn_o.pmn07 AND
         g_pmn2.pmn08 IS NOT NULL ) THEN
         CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn2.pmn07,g_pmn2.pmn08)
         RETURNING l_flag,g_pmn2.pmn09
         IF l_flag THEN
            CALL cl_err(g_pmn2.pmn07,'mfg1206',1)  #MOD-640484
            LET g_pmn2.pmn07 = g_pmn_o.pmn07
            DISPLAY BY NAME g_pmn2.pmn07
            LET g_pmn2.pmn09 = g_pmn_o.pmn09
            DISPLAY BY NAME g_pmn2.pmn09
            RETURN 1
         END IF
         DISPLAY BY NAME g_pmn2.pmn09
      END IF
   END IF
   LET g_pmn_o.pmn07 = g_pmn2.pmn07
 
   IF cl_null(g_pmn2.pmn86) THEN
      LET g_pmn2.pmn86 = g_pmn2.pmn07
      LET g_pmn2.pmn87 = g_pmn2.pmn09
   END IF
   RETURN 0
 
END FUNCTION
 
FUNCTION t540_check_inventory_qty(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_qty      LIKE pmn_file.pmn20
  DEFINE l_qty1     LIKE pmn_file.pmn20
  DEFINE l_pml      RECORD LIKE pml_file.*
  DEFINE l_pml07    LIKE pml_file.pml07
  DEFINE l_pml20    LIKE pml_file.pml20
  DEFINE l_pmn09    LIKE pmn_file.pmn09
  DEFINE l_ima55    LIKE ima_file.ima55
  DEFINE l_ima07    LIKE ima_file.ima07
  DEFINE l_over     LIKE pml_file.pml20
  DEFINE l_sfa065   LIKE sfa_file.sfa065
  DEFINE l_pmn20    LIKE pmn_file.pmn20,
         p_qty      LIKE pmn_file.pmn20   #MOD-7C0058
  DEFINE l_flag1    LIKE type_file.chr1    #MOD-890109
  DEFINE l_ecm04    LIKE ecm_file.ecm04        #CHI-8A0022
 
   #對原單位的控制移至此段
   IF NOT cl_null(g_pmn[l_ac].pmn07) THEN
       IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN #MOD-970202   
          LET g_pmn2.pmn121=1
          LET g_pmn2.pmn09=1
       ELSE
          #取採購對庫存換算率
          CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,
                                g_pmn2.pmn08)
                 RETURNING g_sw,g_pmn2.pmn09
           IF g_sw THEN       #85-09-23 by kitty
             CALL cl_err(g_pmn[l_ac].pmn07,'mfg7002',1)  #MOD-640484
              LET g_pmn2.pmn09=1
              RETURN 1
           END IF
 
          #取採購對請購換算率
          IF g_pmm.pmm909 MATCHES '[128]' THEN #MOD-B60102 add
             IF g_pmn[l_ac].pmn24 !=' ' AND g_pmn[l_ac].pmn25!=' '
                AND NOT cl_null(g_pmn[l_ac].pmn24)
                AND NOT cl_null(g_pmn[l_ac].pmn25)
                THEN
                IF g_pmn[l_ac].pmn07<>g_pmn_o.pmn07 THEN
                   CALL s_umfchk(g_pmn[l_ac].pmn04,
                                 g_pmn[l_ac].pmn07,
                                      g_pmn_o.pmn07)
                       RETURNING g_sw,g_pmn2.pmn121
                   IF g_sw THEN
                       ###Modify: --單位換算率抓不到 ---#
                       CALL cl_err(g_pmn[l_ac].pmn04,'abm-731',1)
                       RETURN 1
                   END IF
                   LET g_pmn[l_ac].pmn20=
                       g_pmn[l_ac].pmn20/g_pmn2.pmn121
                   LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                   DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
                END IF
                SELECT pml07 INTO l_pml07 FROM pml_file
                 WHERE pml01=g_pmn[l_ac].pmn24 AND
                       pml02=g_pmn[l_ac].pmn25
                CALL s_umfchk(g_pmn[l_ac].pmn04,
                              g_pmn[l_ac].pmn07,
                                   l_pml07)
                    RETURNING g_sw,g_pmn2.pmn121
                IF g_sw THEN
                    ###Modify:--單位換算率抓不到 ---#
                    CALL cl_err('pmn07/pml07: ','abm-731',1)
                    RETURN 1
                END IF
                IF cl_null(g_pmn_o.pmn07)
                   THEN
                   LET g_pmn[l_ac].pmn20=
                       g_pmn[l_ac].pmn20/g_pmn2.pmn121
                       LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,g_pmn[l_ac].pmn07)   #No.FUN-BB0086
                   DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
                END IF
             END IF
          END IF   #MOD-B60102 add
       END IF
   END IF
   LET g_pmn2.pmn07  = g_pmn[l_ac].pmn07
   LET g_pmn_o.pmn07 = g_pmn[l_ac].pmn07
   #對原數量的控制移至此段
   IF NOT cl_null(g_pmn[l_ac].pmn20) THEN
      IF g_pmn[l_ac].pmn20 <= 0 THEN
          CALL cl_err(g_pmn[l_ac].pmn20,'mfg3334',1)  #MOD-640484   #TQC-C40032 modify mfg3331->mfg3334
          LET g_pmn[l_ac].pmn20 = g_pmn_o.pmn20
          DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
          RETURN 1
      END IF
      IF (g_pmn_o.pmn20 IS NULL OR g_pmn[l_ac].pmn20 != g_pmn_o.pmn20 )
               AND (g_pmn[l_ac].pmn04[1,4] != 'MISC') THEN #MOD-970202  
        #CALL s_sizechk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn20,g_lang) #CHI-C10037 mark
         CALL s_sizechk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn20,g_lang,g_pmn[l_ac].pmn07) #CHI-C10037 add
                 RETURNING g_pmn[l_ac].pmn20
         DISPLAY g_pmn[l_ac].pmn20 TO pmn20
 
      END IF
      IF (p_cmd='a' OR g_pmn_o.pmn20 IS NULL) OR
              (p_cmd='u'OR g_pmn_o.pmn20 != g_pmn[l_ac].pmn20) THEN
         #add or 修改時,採購量不可小於已交量
         IF g_pmn[l_ac].pmn20 < g_pmn_o.pmn50 THEN
            CALL cl_err(g_pmn_o.pmn50,'mfg3424',1)
            RETURN 1
         END IF
         IF g_pmm.pmm02='SUB' THEN
            IF cl_null(g_pmn_t.pmn20) THEN LET g_pmn_t.pmn20 = 0 END IF
            SELECT SUM(pmn20) INTO l_qty FROM pmn_file,pmm_file
             WHERE pmn41=g_pmn[l_ac].pmn41 AND pmn65='1'
               AND pmm01=pmn01
              #AND pmn16 <> '8'     #TQC-C10116    #MOD-C70081 mark
               AND pmn16 NOT IN ('6','7','8','9')  #MOD-C70081
               AND pmm18 <> 'X'                    #MOD-C70081
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF #no.6261
            IF g_pmn[l_ac].pmn65='1' THEN     #NO:6961一般採購COUNT
                SELECT ima55 INTO l_ima55 FROM ima_file
                 WHERE ima01=g_sfb.sfb05
                CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima55)
                   RETURNING g_sw,l_pmn09
                IF g_sw THEN
                    CALL cl_err('pmn20/sfb08 ','abm-731',1)
                    RETURN 1
                END IF
                IF cl_null(l_pmn09) THEN LET l_pmn09=0 END IF
                LET l_qty1=(l_qty-g_pmn_t.pmn20+g_pmn[l_ac].pmn20)*l_pmn09
                IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
                IF l_qty1 > g_sfb.sfb08  THEN
                   CALL cl_err('','apm-302',1) #MOD-640484
                   RETURN 1
                END IF
            END IF
            IF g_pmn[l_ac].pmn65='2' THEN  #NO:6961代買採購COUNT
               IF cl_null(g_pmn_t.pmn20) THEN LET g_pmn_t.pmn20 = 0 END IF
               #抓工單代買數
               SELECT SUM(sfa065) INTO l_sfa065 FROM sfa_file
                 WHERE sfa01=g_sfb.sfb01
                   AND sfa03=g_pmn[l_ac].pmn04
                IF cl_null(l_sfa065) THEN LET l_sfa065 = 0 END IF
               #檢查不同單位
               SELECT ima25 INTO l_ima55 FROM ima_file
                 WHERE ima01=g_pmn[l_ac].pmn04
                CALL s_umfchk(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn07,l_ima55)
                   RETURNING g_sw,l_pmn09      #單位轉換
                IF g_sw THEN
                   CALL cl_err('pmn20/sfb08 ','abm-731',1)
                   RETURN 1
                END IF
                SELECT SUM(pmn20) INTO l_qty FROM pmn_file
                 WHERE pmn41=g_pmn[l_ac].pmn41 AND pmn65='2'
                   AND pmn04=g_pmn[l_ac].pmn04
                IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                IF cl_null(l_pmn09) THEN LET l_pmn09=0 END IF
                LET l_qty1=(l_qty-g_pmn_t.pmn20+g_pmn[l_ac].pmn20)*l_pmn09
                IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
                IF l_qty1 > l_sfa065 AND
                   (p_cmd='a' OR (g_pmn[l_ac].pmn20!=g_pmn_t.pmn20 )) THEN
                   CALL cl_err('','apm-302',1) #NEXT FIELD pmn20  #MOD-640484
                   RETURN 1
                END IF
            END IF
         END IF
                 
         IF g_pmm.pmm909 MATCHES '[128]' THEN    #MOD-B60102 add
            IF NOT cl_null(g_pmn[l_ac].pmn24)  AND   #請購單
               g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
                                      #若'Y':如有請購單,採購量不可大於請購量
               SELECT * INTO l_pml.* FROM pml_file
               WHERE pml01= g_pmn[l_ac].pmn24 AND pml02=g_pmn[l_ac].pmn25
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","pml_file",g_pmn[l_ac].pmn24,g_pmn[l_ac].pmn25,"apm-202","","",1)  #No.FUN-660129
                  RETURN 1
               END IF
 
               LET l_pml20 = l_pml.pml20*l_pml.pml09  #請購量
               LET l_pml20 = s_digqty(l_pml20,l_pml.pml07)    #FUN-910088--add--
               LET l_pmn20 = 0
               SELECT SUM(pmn20/pmn62*pmn09) INTO l_pmn20#TQC-7C0116 add
                 FROM pmn_file #採購量
                WHERE (pmn24=g_pmn[l_ac].pmn24 AND pmn25=g_pmn[l_ac].pmn25
                  AND  pmn01 = g_pmm.pmm01 AND pmn02!= g_pmn_o.pmn02
                  AND pmn16<>'9')       #取消(Cancel)
                   OR (pmn24=g_pmn[l_ac].pmn24 AND pmn25=g_pmn[l_ac].pmn25
                  AND  pmn01!= g_pmm.pmm01
                  AND pmn16<>'9')       #取消(Cancel)
               IF STATUS OR cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
               #----------------與請購互相勾稽 -------------------------------------
               SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
                WHERE ima01=g_pmn[l_ac].pmn04
               IF cl_null(g_sma.sma341) THEN LET g_sma.sma341 = 0 END IF
               IF cl_null(g_sma.sma342) THEN LET g_sma.sma342 = 0 END IF
               IF cl_null(g_sma.sma343) THEN LET g_sma.sma343 = 0 END IF
               CASE
               WHEN l_ima07='A'  #計算可容許的數量
                    LET l_over=l_pml.pml20 * (g_sma.sma341/100)
               WHEN l_ima07='B'
                    LET l_over=l_pml.pml20 * (g_sma.sma342/100)
               WHEN l_ima07='C'
                    LET l_over=l_pml.pml20 * (g_sma.sma343/100)
               OTHERWISE
                    LET l_over=0
               END CASE
               #需做取位
                LET p_qty = g_pmn[l_ac].pmn20*g_pmn2.pmn09
                LET l_over= l_over*l_pml.pml09#TQC-7C0116 add
               IF p_qty+l_pmn20>    #採購量
                  (l_pml20+l_over) THEN   #請購量+容許量
                   CALL cl_err(g_pmn[l_ac].pmn20,'mfg3425',1)#TQC-7C0119 mod
                  IF g_sma.sma33='R'    #reject
                     THEN
                     RETURN 1
                  END IF
               END IF
            END IF
         END IF    #MOD-B60102 add
      END IF
      LET g_pmn2.pmn20 = g_pmn[l_ac].pmn20
      LET g_pmn_o.pmn20 = g_pmn[l_ac].pmn20
      #單價預設值的設定
      IF NOT cl_null(g_pmn[l_ac].pmn20) AND g_pmn[l_ac].pmn20 != 0 THEN
         IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31 = 0 THEN                                                                                     #MOD-9B0116 mark #FUN-9C0083 取消mark
            #FUN-C50074---begin
            SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
            IF cl_null(g_pnz08) THEN 
               LET g_pnz08 = 'Y'
            END IF 
            IF g_pnz08 = 'Y' THEN
            #IF g_sma.sma112 = 'Y' THEN
            #FUN-C50074---end 
               IF p_cmd = 'a' THEN   #No.MOD-8A0279 add
                  LET l_flag1 = '1'  #No.MOD-8A0279 add
               ELSE                  #No.MOD-8A0279 add
                  IF cl_confirm('apm-339') THEN
                     LET l_flag1 = '1'
                  ELSE
                     LET l_flag1 = '0'
                  END IF
               END IF                #No.MOD-8A0279 add
            ELSE
               LET l_flag1 = '1'
            END IF
               IF l_flag1 = '1' THEN    #MOD-890109
                  LET l_ecm04=' '
                  IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
                     SELECT ecm04 INTO l_ecm04 FROM ecm_file
                      WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
                        AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                  END IF
                  CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                      g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,
                                      g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                         RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                   g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                  IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF
                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)        #MOD-9C0285 ADD
                  LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31          #MOD-C50245 add
             #FUN-B50150  --Begin
               ELSE             # TQC-B60300 mark
                  CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)           # TQC-B60300 mark
             #FUN-B50150  --End
               END IF   #MOD-890109
         END IF
         LET t_pmn31 = g_pmn[l_ac].pmn31                  #no.7231
         LET t_pmn31t= g_pmn[l_ac].pmn31t                 #no.7231
        #MOD-CC0023 -- mark start --
        #IF g_pmn[l_ac].pmn31=0 THEN
        #   LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
        #   LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t          #No.FUN-610018
        #END IF
        #MOD-CC0023 -- mark end -- 
          # 若走Blanket PO 流程，單價認定依參數設定
          IF NOT cl_null(g_pmn[l_ac].pmn68)
             AND NOT cl_null(g_pmn[l_ac].pmn69) THEN
             SELECT * INTO g_pon.* FROM pon_file
              WHERE pon01 = g_pmn[l_ac].pmn68
                AND pon02 = g_pmn[l_ac].pmn69
             CALL s_bkprice(t_pmn31,t_pmn31t,g_pon.pon31,g_pon.pon31t)
                RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
             IF g_pmn[l_ac].pmn31=0 THEN
                LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t    #No.FUN-610018
             END IF
          END IF
          #MOD-B30280 add --start--
          LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
          CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44
          #MOD-B30280 add --end--
          DISPLAY g_pmn[l_ac].pmn31 TO pmn31
          DISPLAY g_pmn[l_ac].pmn31t TO pmn31t          #No.FUN-610018
          IF p_cmd!='u' THEN
             LET g_pmn[l_ac].pmn90=g_pmn[l_ac].pmn31
             DISPLAY g_pmn[l_ac].pmn90 TO pmn90
          END IF
      END IF
  END IF
  RETURN 0
END FUNCTION
 
FUNCTION t540_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn83,pmn85,pmn80,pmn82",FALSE)
      CALL cl_set_comp_visible("pmn07,pmn20",TRUE)
   ELSE
      CALL cl_set_comp_visible("pmn83,pmn84,pmn85,pmn80,pmn81,pmn82",TRUE)
      CALL cl_set_comp_visible("pmn07,pmn20",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("pmn86,pmn87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("pmn84,pmn81",FALSE)
 
   #aza08 = 'Y' 要做專案管理時，畫面才顯示專案相關欄位(專案代號/WBS/活動)
   CALL cl_set_comp_visible("pmm05,pmn122,pmn96,pmn97",g_aza.aza08='Y')
   #單據別有做預管控管時，才顯示預算相關欄位 預算/部門/科目一
   CALL cl_set_comp_visible("pmn67,pmn40",g_smy.smy59='Y')        #No.FUN-830161
   #單據別有做預算控管且有使用多套帳時才顯示科目二
   CALL cl_set_comp_visible("pmn401",g_smy.smy59='Y' AND g_aza.aza63='Y')
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("pmn930,gem02a",g_aaz.aaz90='Y')
END FUNCTION
 
FUNCTION t562_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("pmn83,pmn80",FALSE)
       CALL cl_set_comp_att_text("pmn83",' ')
       CALL cl_set_comp_att_text("pmn80",' ')
       CALL cl_set_comp_visible("pmn07,pmn09",TRUE)
    ELSE
       CALL cl_set_comp_visible("pmn07",FALSE)
       CALL cl_set_comp_visible("pmn09",FALSE)
       CALL cl_set_comp_att_text("pmn07",' ')
       CALL cl_set_comp_att_text("pmn09",' ')
       IF g_ima906 ='1' THEN
          CALL cl_set_comp_visible("pmn80",TRUE)
          CALL cl_set_comp_visible("pmn83",FALSE)
          CALL cl_set_comp_att_text("pmn83",' ')
       ELSE
          CALL cl_set_comp_visible("pmn83",TRUE)
          CALL cl_set_comp_visible("pmn80",TRUE)
       END IF
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
    END IF
END FUNCTION
 
FUNCTION t540_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
 
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(lg_smy62 IS NOT NULL) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_pmn.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_pmn.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_pmn[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pmn[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN
            LET lg_group = l_compare
         #以后是比較
         ELSE
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
       END FOR
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替pmn04子料件編號來顯示
     #得到當前語言別下pmn04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = 'apmt540' AND gae02 = 'pmn04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
 
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'pmn04,pmn041'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'pmn04,pmn041'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
 
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,".",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,".",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR
 
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'pmn04'
  END IF
 
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的pmn04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把pmn04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_pmn[l_ac]都被改成g_pmn[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t540_check_pmn04(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t540_check_pmn04(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,    #No.FUN-680136 SMALLINT,  #g_pmn數組中的當前記錄下標
 
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-680136 SMALLINT,
  ls_value                    STRING,
  lv_value                    LIKE ima_file.ima01,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE gfe_file.gfe01,    #No.FUN-680136 VARCHAR(04)
  l_n                         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,   #No.FUN-680136 INTEGER,
  p_cmd                       LIKE type_file.chr1,    #MOD-660090  #No.FUN-680136 VARCHAR(1)
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_fac                       LIKE oeb_file.oeb05_fac,
  l_sfa065                    LIKE sfa_file.sfa065,
  l_sfa05                     LIKE sfa_file.sfa05,
  l_feature                   LIKE oay_file.oayslip,    #No.FUN-680136 VARCHAR(05)   #No.TQC-5A0096
  l_ima140                    LIKE ima_file.ima140,
  l_imaag                     LIKE ima_file.imaag,      #No.FUN-640056
  l_check_r                   LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(01)
  l_max                       LIKE tqw_file.tqw07,
  l_ima915                    LIKE ima_file.ima915,     #FUN-710060 add
  l_ima44                     LIKE ima_file.ima44,      #TQC-7A0093
  l_flag                      LIKE type_file.chr1       #No.FUN-7B0018
   DEFINE b_azp03       LIKE type_file.chr21 #No.FUN-850100
   DEFINE e_azp03       LIKE type_file.chr21 #No.FUN-850100
   DEFINE l_poz011      LIKE poz_file.poz011 #No.FUN-850100
   DEFINE b_ima918      LIKE ima_file.ima918 #No.FUN-850100
   DEFINE b_ima921      LIKE ima_file.ima921 #No.FUN-850100
   DEFINE e_ima918      LIKE ima_file.ima918 #No.FUN-850100
   DEFINE e_ima921      LIKE ima_file.ima921 #No.FUN-850100
   DEFINE l_sql         STRING  #No.FUN-850100
   DEFINE  l_flag1      LIKE type_file.chr1    #MOD-890109
   DEFINE l_ecm04       LIKE ecm_file.ecm04   #CHI-8A0022
   DEFINE b_azp01       LIKE azp_file.azp01   #FUN-A50102
   DEFINE e_azp01       LIKE azp_file.azp01   #FUN-A50102 

 
     #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
     #新的子料件編號并把值填入到已經隱藏起來的pmn04中（如果imxXX能夠顯示，pmn04一定是隱藏的）
     #下面就可以直接沿用pmn04的檢核邏輯了
     #如果不是，則看看是不是pmn04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
 
     IF NOT cl_null(g_pmn[l_ac].pmn04) AND g_sma.sma120 = 'N' THEN
           SELECT imaag INTO l_imaag FROM ima_file
            WHERE ima01 =g_pmn[l_ac].pmn04
           IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
              CALL cl_err(g_pmn[l_ac].pmn04,'aim1004',0)
              RETURN FALSE
           END IF
     END IF
 
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifndef SLK
#FUN-A60035 ---MARK END
     IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
        ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
        ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
        ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN
 
        #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
        #全部被輸入完成了才進行后續的操作
        LET ls_pid = g_pmn[p_ac].att00   # ls_pid 父料件編號
        LET ls_value = g_pmn[p_ac].att00   # ls_value 子料件編號
        IF cl_null(ls_pid) THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t540_set_no_entry_b(p_cmd)
           CALL t540_set_required()
 
           RETURN TRUE
        END IF  #注意這里沒有錯，所以返回TRUE
 
        #取出當前母料件包含的明細屬性的個數
        SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
           (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
        IF l_cnt = 0 THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t540_set_no_entry_b(p_cmd)
           CALL t540_set_required()
 
            RETURN TRUE
        END IF
 
        FOR li_i = 1 TO l_cnt
            #如果有任何一個明細屬性應該輸而沒有輸的則退出
            IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
               #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
               #注釋掉
               CALL t540_set_no_entry_b(p_cmd)
               CALL t540_set_required()
 
               RETURN TRUE
            END IF
        END FOR
 
        #得到系統定義的標准分隔符sma46
        SELECT sma46 INTO l_ps FROM sma_file
 
        #合成子料件的名稱
        SELECT ima01 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
          WHERE ima01 = ls_pid
        LET ls_spec = ls_pname  # ls_spec 子料件名稱
        #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
        #替換初始名稱，如果找不到則就用原來的名稱
        FOR li_i = 1 TO l_cnt
            LET lc_agd03 = ""
            LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
            SELECT agd03 INTO lc_agd03 FROM agd_file
             WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
            IF cl_null(lc_agd03) THEN
               LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
            ELSE
               LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
            END IF
        END FOR
 
        #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
        LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
        LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
        LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                     "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                     "ORDER BY agb02"
        DECLARE param_curs CURSOR FROM ls_sql
        FOREACH param_curs INTO lc_agb03
          #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
          IF cl_null(l_param_list) THEN
             LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
          ELSE
             LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
          END IF
        END FOREACH
 
        LET g_value = ls_value
 
        LET lv_value = ls_value
        IF g_sma.sma908 <> 'Y' THEN
           SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = lv_value
           IF l_cnt = 0 THEN
              CALL cl_err(g_value,'ams-003',1)
              RETURN FALSE
           END IF
        END IF
 
        #調用cl_copy_ima將新生成的子料件插入到數據庫中
        IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
           #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
           LET ls_value_fld = ls_value
 
           INSERT INTO imx_file VALUES(ls_value_fld,arr_detail[p_ac].imx[1],
             arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
             arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
             arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10],
             ls_pid)
           #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
           #記錄的完全同步
 
           IF SQLCA.sqlcode THEN
 
              CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)  #No.FUN-660129
              DELETE FROM ima_file WHERE ima01 = ls_value_fld
#&ifndef STD  #將imaicd_file操作變成icd專用    #No.FUN-830132           
              RETURN FALSE
           END IF
        END IF
 
        #把生成的子料件賦給pmn04，否則下面的檢查就沒有意義了
        LET g_pmn[p_ac].pmn04 = ls_value
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
        IF l_n=0 THEN
           CALL cl_err('pmn04','ams-003',1)
           RETURN FALSE
        END IF
     ELSE
       IF ( p_field <> 'pmn04' )AND( p_field <> 'imx00' ) THEN
          RETURN FALSE
       END IF
     END IF
#FUN-A60035 ---MARK BEGIN
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END
 
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照pmn04進行判斷了
 
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD pmn04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
 

  IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#&ifndef SLK
#FUN-A60035 ---MARK END
     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("pmn04",g_pmn[l_ac].pmn04,"","1","b")
               RETURNING l_check_r,g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn041
          IF l_check_r = '0' THEN
             RETURN FALSE
          END IF
          DISPLAY g_pmn[l_ac].pmn04 TO pmn04
          DISPLAY g_pmn[l_ac].pmn041 TO pmn041
          LET g_value = g_pmn[l_ac].pmn04
          SELECT imx00 INTO g_pmn04
            FROM imx_file
           WHERE imx000 = g_pmn[l_ac].pmn04
       END IF
     END IF
#FUN-A60035 ---MARK BEGIN
#&endif
##FUN-A50054 --End
#FUN-A60035 ---MARK END 
            IF NOT cl_null(g_pmn[l_ac].pmn04) THEN
                LET l_misc=g_pmn[l_ac].pmn04[1,4]
                IF g_pmn[l_ac].pmn04[1,4]='MISC' THEN  #NO:6808
                   LET g_pmn[l_ac].pmn64="N"   #No.FUN-590020
                     SELECT COUNT(*) INTO l_n FROM ima_file
                      WHERE ima01=l_misc
                        AND ima01='MISC'
                     IF l_n=0 THEN
                        CALL cl_err('','aim-806',1)  #MOD-640492 0->1
                        RETURN FALSE
                     END IF
                END IF
                LET g_pmn2.pmn04 = g_pmn[l_ac].pmn04
                LET g_no = g_pmn2.pmn04[1,4]                                                                             
                LET l_feature = s_get_doc_no(g_pmn2.pmn011)  #No.TQC-5A0096
                    CALL t540_pmn04(p_cmd,g_no)                                                                          
                    ###### 無效料件或Phase Out者不可以請購
                    IF g_errno <> ' '  THEN  #NO:6808  #MOD-7C0050
                       CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1)  #MOD-640492 0->1
                       RETURN FALSE
                    END IF
                IF g_pmn[l_ac].pmn65='2' THEN
                   SELECT COUNT(*) INTO l_n FROM sfa_file
                    WHERE sfa01=g_pmn[l_ac].pmn41
                      AND sfa03=g_pmn[l_ac].pmn04
                   IF l_n=0 THEN
                       CALL cl_err(g_pmn[l_ac].pmn04,'asf-949',1)  #MOD-640492 0->1
                       LET g_pmn[l_ac].pmn04 = g_pmn_o.pmn04
                       LET g_pmn[l_ac].pmn041= NULL
                       LET g_pmn[l_ac].ima021= NULL
                       DISPLAY g_pmn[l_ac].pmn04  TO pmn04
                       DISPLAY g_pmn[l_ac].pmn041 TO pmn041
                       DISPLAY g_pmn[l_ac].ima021 TO ima021
                       RETURN FALSE
                   END IF
                   #輸入的委外代買料號,在備料中的委外代買要>0
                   SELECT SUM(sfa05),SUM(sfa065) INTO l_sfa05,l_sfa065 FROM sfa_file #FUN-A60027 sfa05,sfa065->sum(sfa05),sum(sfa065)
                    WHERE sfa01=g_pmn[l_ac].pmn41
                      AND sfa03=g_pmn[l_ac].pmn04
                   IF cl_null(l_sfa065) OR l_sfa065<=0 THEN
                      CALL cl_err(g_pmn[l_ac].pmn04,'asf-948',1)  #MOD-640492 0->1
                      RETURN FALSE
                   END IF
                   IF g_sfb.sfb02=8 THEN        #NO:6961 若資料為8重工委外
                      IF l_sfa05<0 THEN         #零件退庫備料不可輸入
                          CALL cl_err(g_pmn[l_ac].pmn04,'asf-953',1)  #MOD-640492 0->1
                          RETURN FALSE
                      END IF
                   END IF
                END IF
                IF (cl_null(g_pmn_t.pmn04) OR g_pmn[l_ac].pmn04 != g_pmn_t.pmn04)
                    AND (g_pmn[l_ac].pmn04[1,4] != 'MISC') THEN #MOD-970202    
                    #採購料件/供應商控制
                    SELECT ima915 INTO l_ima915 FROM ima_file
                     WHERE ima01=g_pmn[l_ac].pmn04
                    IF l_ima915='2' OR l_ima915='3' THEN
                       CALL t540sub_pmh(g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn41,#No.TQC-910033 
                                        g_pmn[l_ac].pmn43,g_pmn2.pmn18,g_pmn[l_ac].pmn012,g_pmm.*,g_type)         #No.TQC-910033 #No.FUN-A60011
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1)  #MOD-640492 0->1
                          LET g_pmn[l_ac].pmn04 = g_pmn_o.pmn04
                          DISPLAY g_pmn[l_ac].pmn04 TO pmn04
 
                          RETURN FALSE
                       END IF
                    END IF
                    ##委外採購單料料要為工單單頭料號
                    IF g_pmm.pmm02='SUB' AND g_pmn[l_ac].pmn65='1' AND
                       NOT cl_null(g_pmn[l_ac].pmn41) THEN
                       SELECT COUNT(*) INTO l_n
                         FROM sfb_file
                        WHERE sfb05=g_pmn[l_ac].pmn04
                          AND sfb01=g_pmn[l_ac].pmn41
                       IF l_n=0 THEN
                          CALL cl_err(g_pmn[l_ac].pmn04,'apm-333',1)  #MOD-640492 0->1
                          RETURN FALSE
                       END IF
                       IF g_sfb.sfb02=8 THEN             #NO:6961#若資料為8重工委外
                           SELECT sfa05 INTO l_sfa05     #不帶零件退庫備料<0出來
                             FROM sfa_file,sfb_file
                            WHERE sfb01=sfa01
                              AND sfb01=g_pmn[l_ac].pmn41
                              AND sfa03=g_pmn[l_ac].pmn04
                           IF l_sfa05<0 THEN
                               CALL cl_err(g_pmn[l_ac].pmn04,'asf-953',1)
                               RETURN FALSE
                           END IF
                       END IF
                    END IF
 
                    #料件主檔檢查/預設值的讀取
                    IF g_pmn[l_ac].pmn04<>g_pmn_t.pmn04 OR
                       cl_null(g_pmn_t.pmn04) THEN
                       CALL t540_def()
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pmn[l_ac].pmn04,g_errno,1)  #MOD-640492 0->1
                       LET g_pmn[l_ac].pmn04 = g_pmn_o.pmn04
                       DISPLAY g_pmn[l_ac].pmn04 TO pmn04
 
                       RETURN FALSE
                    END IF
                    #單價預設值的設定NO:7178
                    IF NOT cl_null(g_pmn[l_ac].pmn20) AND g_pmn[l_ac].pmn20 != 0 THEN
                       IF cl_null(g_pmn[l_ac].pmn31) OR g_pmn[l_ac].pmn31 = 0 OR 
                          (g_pmn[l_ac].pmn04 <> g_pmn_o.pmn04 OR g_pmn_o.pmn04 IS NULL) THEN   #MOD-A80011
                          #FUN-C50074---begin
                          SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_pmm.pmm41
                          IF cl_null(g_pnz08) THEN 
                             LET g_pnz08 = 'Y'
                          END IF 
                          IF g_pnz08 = 'Y' THEN
                          #IF g_sma.sma112 = 'Y' THEN
                          #FUN-C50074---end 
                             IF p_cmd = 'a' THEN   #No.MOD-8A0279 add
                                LET l_flag1 = '1'  #No.MOD-8A0279 add
                             ELSE                  #No.MOD-8A0279 add
                          #      IF cl_confirm('apm-339') THEN     # MOD By NO.TQC-B60212
                          #         LET l_flag1 = '1'              # MOD By NO.TQC-B60212 
                          #      ELSE                             # MOD By NO.TQC-B60212
                          #         LET l_flag1 = '0'             # MOD By NO.TQC-B60212
                          #      END IF
                             END IF                #No.MOD-8A0279 add
                          ELSE
                             LET l_flag1 = '1'
                          END IF
                             IF l_flag1 = '1' THEN   #MOD-890109
                                LET l_ecm04=' '
                                IF NOT cl_null(g_pmn[l_ac].pmn43) AND g_pmn[l_ac].pmn43 != 0 THEN
                                   SELECT ecm04 INTO l_ecm04 FROM ecm_file
                                    WHERE ecm01 = g_pmn[l_ac].pmn41 AND ecm03 = g_pmn[l_ac].pmn43
                                      AND ecm012= g_pmn[l_ac].pmn012    #No.FUN-A60011
                                END IF
                                CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                                    g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,
                                                    g_pmm.pmm43,g_type,g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                                      RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                                                g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
                                IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF
                                CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)    #MOD-9C0285 ADD
                                LET g_pmn[l_ac].pmn90 = g_pmn[l_ac].pmn31          #MOD-C50245 add
                        #FUN-B50150  --Begin
                             ELSE          # TQC-B60300 mark
                                CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)      # TQC-B60300 mark
                        #FUN-B50150  --End
                             END IF   #MOD-890109
                       END IF
                      #MOD-CB0186 -- mark start --
                      #IF g_pmn[l_ac].pmn31=0 THEN
                      #   LET g_pmn[l_ac].pmn31=g_pmn2.pmn31
                      #   LET g_pmn[l_ac].pmn31t=g_pmn2.pmn31t  #No.FUN-610018
                      #END IF
                      #MOD-CB0186 -- mark end --
                       #MOD-B30280 add --start--
                       LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
                       CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44
                       #MOD-B30280 add --end--
                       DISPLAY g_pmn[l_ac].pmn31 TO pmn31
                       DISPLAY g_pmn[l_ac].pmn31t TO pmn31t     #No.FUN-610018
                       IF p_cmd!='u' THEN
                          LET g_pmn[l_ac].pmn90=g_pmn[l_ac].pmn31
                          DISPLAY g_pmn[l_ac].pmn90 TO pmn90
                       END IF
                    END IF
                END IF
                IF g_sma.sma886[5,5]='Y' AND
                  (g_pmm.pmm02='EXP' OR g_pmm.pmm02='CAP'
                   OR g_pmn[l_ac].pmn04[1,4] = 'MISC') THEN #MOD-970202     
                   CALL t561()       #若MISC須輸入會計科目
                END IF
                IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_pmn[l_ac].pmn04)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      RETURN FALSE
                   END IF
                   CALL s_chk_va_setting1(g_pmn[l_ac].pmn04)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      RETURN FALSE
                   END IF
                   IF g_ima906 = '3' THEN
                      LET g_pmn[l_ac].pmn83=g_ima907
                      LET g_pmn[l_ac].pmn85 = s_digqty(g_pmn[l_ac].pmn85,g_pmn[l_ac].pmn83)    #FUN-910088--add--
                      SELECT ima44 INTO l_ima44 FROM ima_file
                       WHERE ima01=g_pmn[l_ac].pmn04
                      LET g_pmn[l_ac].pmn80=l_ima44
                      LET g_pmn[l_ac].pmn82 = s_digqty(g_pmn[l_ac].pmn82,g_pmn[l_ac].pmn80)    #FUN-910088--add--
                      DISPLAY g_pmn[l_ac].pmn80 TO pmn80
                      DISPLAY g_pmn[l_ac].pmn83 TO pmn83
                   END IF
                #計價單位與數量應不受多單位參數影響
                END IF
                SELECT ima44,ima31,ima908 INTO g_ima44,g_ima31,g_ima908  #MOD-730044 modify
                  FROM ima_file WHERE ima01=g_pmn[l_ac].pmn04
                IF cl_null(g_pmn[l_ac].pmn80) AND  #No.FUN-560020
                   cl_null(g_pmn[l_ac].pmn83) THEN
                   CALL t540_du_default(p_cmd)
                END IF
               IF p_cmd='u' AND  (g_pmn[l_ac].pmn04 <> g_pmn_o.pmn04) THEN
                IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
                   LET g_pmn[l_ac].pmn86=g_ima908
#                  LET g_pmn[l_ac].pmn86 = s_digqty(g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn86)    #FUN-910088--add--  #MOD-C30445 mark
                   LET g_pmn[l_ac].pmn87 = s_digqty(g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn86)    #MOD-C30445 add
                END IF
               END IF
                CALL t540_set_pmn87()    #No.TQC-6C0131 add
            END IF
            IF cl_null(g_pmn[l_ac].pmn04) THEN
               RETURN FALSE
            END IF
            LET g_pmn2.pmn04 = g_pmn[l_ac].pmn04
            LET g_pmn_o.pmn04 = g_pmn[l_ac].pmn04
            CALL t540_set_no_entry_b(p_cmd)
            CALL t540_set_required()
 
     IF g_pmm.pmm901="Y" THEN
        SELECT poz011 INTO l_poz011 FROM poz_file
         WHERE poz01 = g_pmm.pmm904
  
        IF l_poz011 = "1" THEN
           SELECT azp03,azp01 INTO b_azp03,b_azp01          #FUN-A50102 add azp01
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
  
           SELECT azp03,azp01 INTO e_azp03,e_azp01          #FUN-A50102 add azp01
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
        ELSE
           SELECT azp03,azp01 INTO e_azp03,e_azp01          #FUN-A50102 add azp01 
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
  
           SELECT azp03,azp01 INTO b_azp03,b_azp01          #FUN-A50102  add azp01 
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
        END IF
  
        LET b_azp03 = s_dbstring(b_azp03)   #TQC-950010 ADD                                                                         
                                                                                                                                    
        LET e_azp03 = s_dbstring(e_azp03)   #TQC-950010 ADD    
  
      # LET l_sql = " SELECT ima918,ima921 FROM ",b_azp03 CLIPPED,"ima_file ",              #FUN-A50102 mark
        LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(b_azp01,'ima_file'),  #FUN-A50102
                    "  WHERE ima01 ='",g_pmn[l_ac].pmn04,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,b_azp01) RETURNING l_sql      #FUN-A50102 
        PREPARE b_ima_pre FROM l_sql
  
        DECLARE b_ima_cs CURSOR FOR b_ima_pre
  
        OPEN b_ima_cs
  
        FETCH b_ima_cs INTO b_ima918,b_ima921
        IF SQLCA.SQLCODE THEN
          #CALL cl_err(b_azp03,'b_ima_cs',0) #MOD-D10214 mark                                                                              
           CALL cl_err(b_azp03,'axm-297',0)  #MOD-D10214
        END IF
  
        IF cl_null(b_ima918) THEN
           LET b_ima918 = "N"
        END IF
  
        IF cl_null(b_ima921) THEN
           LET b_ima921 = "N"
        END IF
  
       #LET l_sql = " SELECT ima918,ima921 FROM ",e_azp03 CLIPPED,"ima_file ",             #FUN-A50102 mark
        LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(e_azp01,'ima_file'), #FUN-A50102
                    "  WHERE ima01 ='",g_pmn[l_ac].pmn04,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,e_azp01) RETURNING l_sql          #FUN-A50102
        PREPARE e_ima_pre FROM l_sql
  
        DECLARE e_ima_cs CURSOR FOR e_ima_pre
  
        OPEN e_ima_cs
  
        FETCH e_ima_cs INTO e_ima918,e_ima921
        IF SQLCA.SQLCODE THEN
          #CALL cl_err(e_azp03,'e_ima_cs',0) #MOD-D10214 mark                                                                             
           CALL cl_err(e_azp03,'axm-297',0)  #MOD-D10214
        END IF
  
        IF cl_null(e_ima918) THEN
           LET e_ima918 = "N"
        END IF
  
        IF cl_null(e_ima921) THEN
           LET e_ima921 = "N"
        END IF
  
        IF e_ima918 = "Y" OR e_ima921 = "Y" THEN
           IF b_ima918 <> "Y" AND b_ima921 <> "Y" THEN    #No.TQC-950002 add
              CALL cl_err(g_pmn[l_ac].pmn04,'axm-087',1)                                                                              
              RETURN FALSE
           END IF
        END IF
     END IF
 
     RETURN TRUE
  ELSE
     #如果是由pmn04來觸發的,說明當前用的是舊的流程,那么pmn04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF ( p_field = 'pmn04' )OR( p_field = 'imx00' ) THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t540_set_no_entry_b(p_cmd)
        CALL t540_set_required()
 
        RETURN TRUE
     ELSE
        #如果不是pmn,則是由attxx來觸發的,則非輸不可
        RETURN FALSE
     END IF #如果為空則不允許新增
  END IF
 
END FUNCTION
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t540_check_pmn04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t540_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        LIKE type_file.chr1,   #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
  l_check_res  LIKE type_file.num5,    #No.FUN-680136 SMALLINT,
  l_b2         LIKE pmh_file.pmh04,   #No.FUN-680136 VARCHAR(30),
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成pmn04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t540_refresh_detail()函數在較早的時候填充
 
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t540_check_pmn04('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res
    RETURN l_check_res
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t540_check_pmn04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t540_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-680136 SMALLINT,
  p_row    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_index  STRING,
  p_cmd    LIKE type_file.chr1,   #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
  l_check_res     LIKE type_file.num5,    #No.FUN-680136 SMALLINT,
  l_b2            LIKE pmh_file.pmh04,  #No.FUN-680136 VARCHAR(30),
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成pmn04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t540_check_pmn04('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res
  RETURN l_check_res
END FUNCTION
 
FUNCTION t540_set_pmn930(p_pmn930)
DEFINE p_pmn930 LIKE pmn_file.pmn930
DEFINE l_gem02  LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=p_pmn930
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION
 
FUNCTION t540_pic()
   IF g_pmm.pmm18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_pmm.pmm25='1' OR g_pmm.pmm25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_pmm.pmm25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
   CALL cl_set_field_pic(g_pmm.pmm18,g_chr2,""  ,g_chr3,g_chr,""  )
END FUNCTION
 
FUNCTION t540_aps()
   DEFINE  l_chr4      LIKE type_file.chr4
   DEFINE  l_vmz       RECORD LIKE vmz_file.*    #FUN-7C0002
   DEFINE  l_vmz01     LIKE vmz_file.vmz01       #FUN-7C0002
 
         IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
         IF cl_null(g_pmm.pmm01) THEN
            CALL cl_err('',-400,1)
            RETURN
         END IF
         IF cl_null(g_pmn[l_ac].pmn02) THEN
            CALL cl_err('','arm-034',1)
            RETURN
         END IF
         LET l_chr4 = g_pmn[l_ac].pmn02 USING '&&&&'
 
         LET l_vmz01 = g_pmm.pmm01 CLIPPED,'-',l_chr4
         SELECT vmz01 FROM vmz_file
          WHERE vmz01 = l_vmz01
         IF SQLCA.SQLCODE=100 THEN
            LET l_vmz.vmz01 = l_vmz01
            LET l_vmz.vmz12 = 0
            LET l_vmz.vmz16 = NULL
            LET l_vmz.vmz25 = 0  #FUN-910005  ADD
            LET l_vmz.vmzplant = g_plant #FUN-B50046 add
            LET l_vmz.vmzlegal = g_legal #FUN-B50046 add
            INSERT INTO vmz_file VALUES(l_vmz.*)
               IF STATUS THEN
                  CALL cl_err3("ins","vmz_file",l_vmz.vmz01,"",SQLCA.sqlcode,
                               "","",1)
               END IF
         END IF
         LET g_cmd = "apsi317 '",l_vmz01,"'"
         CALL cl_cmdrun(g_cmd)
END FUNCTION
 
FUNCTION t540_b_move_to()
   LET g_pmn[l_ac].pmn02   =  g_pmn2.pmn02
   LET g_pmn[l_ac].pmn24   =  g_pmn2.pmn24
   LET g_pmn[l_ac].pmn25   =  g_pmn2.pmn25
   LET g_pmn[l_ac].pmn65   =  g_pmn2.pmn65
   LET g_pmn[l_ac].pmn41   =  g_pmn2.pmn41
   LET g_pmn[l_ac].pmn42   =  g_pmn2.pmn42
   LET g_pmn[l_ac].pmn16   =  g_pmn2.pmn16
   LET g_pmn[l_ac].pmn04   =  g_pmn2.pmn04
   LET g_pmn[l_ac].pmn07   =  g_pmn2.pmn07
   LET g_pmn[l_ac].pmn20   =  g_pmn2.pmn20
   LET g_pmn[l_ac].pmn83   =  g_pmn2.pmn83
   LET g_pmn[l_ac].pmn84   =  g_pmn2.pmn84
   LET g_pmn[l_ac].pmn85   =  g_pmn2.pmn85
   LET g_pmn[l_ac].pmn80   =  g_pmn2.pmn80
   LET g_pmn[l_ac].pmn81   =  g_pmn2.pmn81
   LET g_pmn[l_ac].pmn82   =  g_pmn2.pmn82
   LET g_pmn[l_ac].pmn86   =  g_pmn2.pmn86
   LET g_pmn[l_ac].pmn87   =  g_pmn2.pmn87
   LET g_pmn[l_ac].pmn68   =  g_pmn2.pmn68
   LET g_pmn[l_ac].pmn69   =  g_pmn2.pmn69
   LET g_pmn[l_ac].pmn31   =  g_pmn2.pmn31
   LET g_pmn[l_ac].pmn31t  =  g_pmn2.pmn31t
   LET g_pmn[l_ac].pmn89   =  g_pmn2.pmn89                 #FUN-940083
   LET g_pmn[l_ac].pmn64   =  g_pmn2.pmn64
   LET g_pmn[l_ac].pmn63   =  g_pmn2.pmn63
   LET g_pmn[l_ac].pmn33   =  g_pmn2.pmn33
   LET g_pmn[l_ac].pmn34   =  g_pmn2.pmn34
   LET g_pmn[l_ac].pmn35   =  g_pmn2.pmn35   #CHI-9C0023
   LET g_pmn[l_ac].pmn122  =  g_pmn2.pmn122
   LET g_pmn[l_ac].pmn96  =  g_pmn2.pmn96
   LET g_pmn[l_ac].pmn97  =  g_pmn2.pmn97
   LET g_pmn[l_ac].pmn67  =  g_pmn2.pmn67
   LET g_pmn[l_ac].pmn98  =  g_pmn2.pmn98
   LET g_pmn[l_ac].pmn40  =  g_pmn2.pmn40
   LET g_pmn[l_ac].pmn401 =  g_pmn2.pmn401
   LET g_pmn[l_ac].pmn930  =  g_pmn2.pmn930
   LET g_pmn[l_ac].pmn52   =  g_pmn2.pmn52   #CHI-9C0025
   LET g_pmn[l_ac].pmn54   =  g_pmn2.pmn54   #CHI-9C0025
   LET g_pmn[l_ac].pmn56   =  g_pmn2.pmn56   #CHI-9C0025
   LET g_pmn[l_ac].pmn43   =  g_pmn2.pmn43
   LET g_pmn[l_ac].pmn431  =  g_pmn2.pmn431
   LET g_pmn[l_ac].pmn012  =  g_pmn2.pmn012   #No.FUN-A60011
   LET g_pmn[l_ac].pmn91   =  g_pmn2.pmn91    #No.FUN-810016
   LET g_pmn[l_ac].pmn38   =  g_pmn2.pmn38
   LET g_pmn[l_ac].pmn90   =  g_pmn2.pmn90
   LET g_pmn[l_ac].pmn123  =  g_pmn2.pmn123   #FUN-950088 add
   LET g_pmn[l_ac].pmn919  =  g_pmn2.pmn919   #FUN-A80150 add
   LET g_pmn[l_ac].pmnud01 = g_pmn2.pmnud01
   LET g_pmn[l_ac].pmnud02 = g_pmn2.pmnud02
   LET g_pmn[l_ac].pmnud03 = g_pmn2.pmnud03
   LET g_pmn[l_ac].pmnud04 = g_pmn2.pmnud04
   LET g_pmn[l_ac].pmnud05 = g_pmn2.pmnud05
   LET g_pmn[l_ac].pmnud06 = g_pmn2.pmnud06
   LET g_pmn[l_ac].pmnud07 = g_pmn2.pmnud07
   LET g_pmn[l_ac].pmnud08 = g_pmn2.pmnud08
   LET g_pmn[l_ac].pmnud09 = g_pmn2.pmnud09
   LET g_pmn[l_ac].pmnud10 = g_pmn2.pmnud10
   LET g_pmn[l_ac].pmnud11 = g_pmn2.pmnud11
   LET g_pmn[l_ac].pmnud12 = g_pmn2.pmnud12
   LET g_pmn[l_ac].pmnud13 = g_pmn2.pmnud13
   LET g_pmn[l_ac].pmnud14 = g_pmn2.pmnud14
   LET g_pmn[l_ac].pmnud15 = g_pmn2.pmnud15
END FUNCTION
 
FUNCTION t540_b_move_back_2()
   LET g_pmn2.pmn02  = g_pmn[l_ac].pmn02
   LET g_pmn2.pmn24  = g_pmn[l_ac].pmn24
   LET g_pmn2.pmn25  = g_pmn[l_ac].pmn25
   LET g_pmn2.pmn65  = g_pmn[l_ac].pmn65
   LET g_pmn2.pmn41  = g_pmn[l_ac].pmn41
   LET g_pmn2.pmn42  = g_pmn[l_ac].pmn42
   LET g_pmn2.pmn16  = g_pmn[l_ac].pmn16
   LET g_pmn2.pmn04  = g_pmn[l_ac].pmn04
   LET g_pmn2.pmn07  = g_pmn[l_ac].pmn07
   LET g_pmn2.pmn20  = g_pmn[l_ac].pmn20
   LET g_pmn2.pmn83  = g_pmn[l_ac].pmn83
   LET g_pmn2.pmn84  = g_pmn[l_ac].pmn84
   LET g_pmn2.pmn85  = g_pmn[l_ac].pmn85
   LET g_pmn2.pmn80  = g_pmn[l_ac].pmn80
   LET g_pmn2.pmn81  = g_pmn[l_ac].pmn81
   LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
   LET g_pmn2.pmn86  = g_pmn[l_ac].pmn86
   LET g_pmn2.pmn87  = g_pmn[l_ac].pmn87
   LET g_pmn2.pmn68  = g_pmn[l_ac].pmn68
   LET g_pmn2.pmn69  = g_pmn[l_ac].pmn69
   LET g_pmn2.pmn31  = g_pmn[l_ac].pmn31
   LET g_pmn2.pmn31t = g_pmn[l_ac].pmn31t
   LET g_pmn2.pmn89  = g_pmn[l_ac].pmn89      #FUN-940083
   LET g_pmn2.pmn64  = g_pmn[l_ac].pmn64
   LET g_pmn2.pmn63  = g_pmn[l_ac].pmn63
   LET g_pmn2.pmn33  = g_pmn[l_ac].pmn33
   LET g_pmn2.pmn34  = g_pmn[l_ac].pmn34
   LET g_pmn2.pmn35  = g_pmn[l_ac].pmn35      #CHI-9C0023
   LET g_pmn2.pmn122 = g_pmn[l_ac].pmn122
   LET g_pmn2.pmn96  = g_pmn[l_ac].pmn96
   LET g_pmn2.pmn97  = g_pmn[l_ac].pmn97
   LET g_pmn2.pmn67  = g_pmn[l_ac].pmn67
   LET g_pmn2.pmn98  = g_pmn[l_ac].pmn98
   LET g_pmn2.pmn40  = g_pmn[l_ac].pmn40
   LET g_pmn2.pmn401 = g_pmn[l_ac].pmn401
   LET g_pmn2.pmn930 = g_pmn[l_ac].pmn930
   LET g_pmn2.pmn43  = g_pmn[l_ac].pmn43
   LET g_pmn2.pmn431 = g_pmn[l_ac].pmn431
   LET g_pmn2.pmn012 = g_pmn[l_ac].pmn012   #No.FUN-A60011
   LET g_pmn2.pmn91  = g_pmn[l_ac].pmn91    #No.FUN-810016
   LET g_pmn2.pmn38  = g_pmn[l_ac].pmn38
   LET g_pmn2.pmn90  = g_pmn[l_ac].pmn90
   LET g_pmn2.pmn123 = g_pmn[l_ac].pmn123   #FUN-950088 add
   LET g_pmn2.pmn52  = g_pmn[l_ac].pmn52     #CHI-9C0025
   LET g_pmn2.pmn54  = g_pmn[l_ac].pmn54     #CHI-9C0025
   LET g_pmn2.pmn56  = g_pmn[l_ac].pmn56     #CHI-9C0025
   LET g_pmn2.pmn919 = g_pmn[l_ac].pmn919    #FUN-A80150 add
   LET g_pmn2.pmnud01 = g_pmn[l_ac].pmnud01
   LET g_pmn2.pmnud02 = g_pmn[l_ac].pmnud02
   LET g_pmn2.pmnud03 = g_pmn[l_ac].pmnud03
   LET g_pmn2.pmnud04 = g_pmn[l_ac].pmnud04
   LET g_pmn2.pmnud05 = g_pmn[l_ac].pmnud05
   LET g_pmn2.pmnud06 = g_pmn[l_ac].pmnud06
   LET g_pmn2.pmnud07 = g_pmn[l_ac].pmnud07
   LET g_pmn2.pmnud08 = g_pmn[l_ac].pmnud08
   LET g_pmn2.pmnud09 = g_pmn[l_ac].pmnud09
   LET g_pmn2.pmnud10 = g_pmn[l_ac].pmnud10
   LET g_pmn2.pmnud11 = g_pmn[l_ac].pmnud11
   LET g_pmn2.pmnud12 = g_pmn[l_ac].pmnud12
   LET g_pmn2.pmnud13 = g_pmn[l_ac].pmnud13
   LET g_pmn2.pmnud14 = g_pmn[l_ac].pmnud14
   LET g_pmn2.pmnud15 = g_pmn[l_ac].pmnud15
   LET g_pmn2.pmn61  = g_pmn[l_ac].pmn04     #MOD-C80237 add
END FUNCTION
 
 
FUNCTION t540_pmn04_chk(p_pmn68,p_pmn69,p_pmn04)
DEFINE l_pon04      LIKE pon_file.pon04,
       l_success    LIKE type_file.chr1,
       l_ima152     LIKE ima_file.ima152,
       l_ima151     LIKE ima_file.ima151,
       l_pmu        RECORD LIKE pmu_file.*,
       l_pmn04_cut  LIKE pmu_file.pmu06,
       l_tpmu00     LIKE type_file.num5,
       l_n,l_n1     LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_agb03a     LIKE agb_file.agb03,
       l_agb03b     LIKE agb_file.agb03,
       l_agb03c     LIKE agb_file.agb03,
       l_imx01      LIKE imx_file.imx01,
       l_imx02      LIKE imx_file.imx02,
       l_imx03      LIKE imx_file.imx03,
       l_imx00      LIKE imx_file.imx00,
       l_imx01a     LIKE imx_file.imx01,
       l_imx02a     LIKE imx_file.imx02,
       l_imx03a     LIKE imx_file.imx03,
       l_imx01b     LIKE imx_file.imx01,
       l_imx02b     LIKE imx_file.imx02,
       l_imx03b     LIKE imx_file.imx03,
       l_pmu03      LIKE pmu_file.pmu03,
       l_tpmu03     LIKE pmu_file.pmu03,
       l_tpmu04     LIKE pmu_file.pmu04,
       p_pmn04      LIKE pmn_file.pmn04,
       p_pmn68      LIKE pmn_file.pmn68,
       p_pmn69      LIKE pmn_file.pmn69
 
  LET l_success ='Y'
 
  SELECT pon04 INTO l_pon04
              FROM pon_file
              WHERE pon01= p_pmn68
              AND  pon02 = p_pmn69
            SELECT ima152,ima151 INTO l_ima152,l_ima151
              FROM ima_file
              WHERE ima_file.ima01=l_pon04
            IF g_pmn[l_ac].pmn04!=l_pon04 THEN
              IF l_ima152='0' THEN     #No.FUN-840178
                CALL cl_err('','apm-340',0)
                LET l_success ='N'
                RETURN l_success
              ELSE
                IF l_ima151='Y' THEN       #采購料號為母料號
                  IF l_ima152='1' THEN     #依替代原則         #No.FUN-840178
                     SELECT * FROM ima_file WHERE ima_file.ima01=g_pmn[l_ac].pmn04
                       AND ima_file.ima01 IN(
                     SELECT imx000 FROM imx_file
                       WHERE imx_file.imx00=l_pon04)
                         AND ima_file.imaacti='Y'   #必須是相同母料號的明細料號
                     IF SQLCA.sqlcode=0 THEN
                        SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                          AND pmv_file.pmv06='Y'
                          AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                        IF l_n=0 THEN
                           SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='1'
                           SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='2'
                           SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='3'
                           SELECT imx01,imx02,imx03 INTO l_imx01,l_imx02,l_imx03
                             FROM imx_file WHERE imx000=g_pmn[l_ac].pmn04
                           SELECT COUNT(*) INTO l_n
                             FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                              AND pmv_file.pmv09<=g_pmm.pmm04
                              AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                          IF l_n=0 THEN
                             CALL cl_err('','apm-345',1)
                             LET l_success ='N'
                             RETURN l_success
                          ELSE
                            IF l_agb03a IS NOT NULL AND l_agb03a!=' ' THEN
                               SELECT COUNT(*) INTO l_n
                                 FROM pmv_file
                                WHERE pmv_file.pmv01=l_pon04
                                  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                                  AND pmv_file.pmv09<=g_pmm.pmm04
                                  AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10=' ')
                                  AND pmv_file.pmv03=l_agb03a AND pmv_file.pmv04='*'    #No.FUn-870117
                                  AND (pmv_file.pmv05=l_imx01 OR pmv_file.pmv05='*')
                               IF l_n=0 THEN
                                  CALL cl_err('','apm-341',1)
                                  LET l_success ='N'
                                  RETURN l_success
                               ELSE
                                 IF l_agb03b IS NOT NULL AND l_agb03b!=' '  THEN
                                    SELECT COUNT(*) INTO l_n
                                    FROM pmv_file
                                    WHERE pmv_file.pmv01=l_pon04
                                    AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                                    AND pmv_file.pmv09<=g_pmm.pmm04
                                    AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                    AND pmv_file.pmv03=l_agb03b AND pmv_file.pmv04='*'    #No.FUn-870117
                                    AND (pmv_file.pmv05=l_imx02 OR pmv_file.pmv05='*')
                                    IF l_n=0 THEN
                                       CALL cl_err('','apm-343',1)
                                       LET l_success ='N'
                                       RETURN l_success
                                    ELSE
                                      IF l_agb03c IS NOT NULL AND l_agb03c!=' ' THEN
                                         SELECT COUNT(*) INTO l_n
                                           FROM pmv_file
                                          WHERE pmv_file.pmv01=l_pon04
                                            AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                                            AND pmv_file.pmv09<=g_pmm.pmm04
                                            AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                            AND pmv_file.pmv03=l_agb03c AND pmv_file.pmv04='*'    #No.FUn-870117
                                            AND (pmv_file.pmv05=l_imx03 OR pmv_file.pmv05='*')
                                        IF l_n=0 THEN
                                           CALL cl_err('','apm-344',1)
                                           LET l_success ='N'
                                           RETURN l_success
                                         END IF
                                      END IF
                                  END IF
                               END IF
                            END IF
                          END IF
                        END IF
                      END IF
                     ELSE
                       CALL cl_err('','apm-346',1)
                       LET l_success ='N'
                       RETURN l_success
                     END IF
                   ELSE
                     IF l_ima152='2' THEN   #依替代群組          #No.FUN-840178
                        SELECT COUNT(*) INTO l_n FROM pnc_file
                        WHERE pnc_file.pnc01=l_pon04
                          AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pmm.pmm09)
                          AND pnc_file.pnc03=g_pmn[l_ac].pmn04
                          AND pnc_file.pnc04<=g_pmm.pmm04 AND (pnc_file.pnc05>g_pmm.pmm04
                           OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                       IF l_n=0 THEN
                          CALL cl_err('','apm-347',1)
                          LET l_success ='N'
                          RETURN l_success
                       END IF
                    END IF
                  END IF
             ELSE
          #表示是多屬性明細料號
                IF l_n>0  THEN
                  IF l_ima152='1' THEN
                    SELECT * FROM imx_file,ima_file
                     WHERE ima_file.ima01=g_pmn[l_ac].pmn04
                     AND imx_file.imx000=ima_file.ima01
                     AND imx_file.imx00 IN(
                     SELECT imx00 FROM imx_file WHERE imx_file.imx000=l_pon04)
                     AND ima_file.imaacti='Y'
                    IF SQLCA.sqlcode=0 THEN
                      SELECT a.imx00 INTO l_imx00
                        FROM imx_file a, imx_file b
                       WHERE a.imx000=g_pmn[l_ac].pmn04
                         AND b.imx000=l_pon04
                         AND a.imx00=b.imx00
                      SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                         AND pmv_file.pmv06='Y'
                         AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                      IF l_n=0 THEN
                        SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='1'
                        SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='2'
                        SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='3'
                        SELECT imx01,imx02,imx03 INTO l_imx01a,l_imx02a,l_imx03a
                          FROM imx_file WHERE imx000=l_pon04
                        SELECT imx01,imx02,imx03 INTO l_imx01b,l_imx02b,l_imx03b
                          FROM imx_file WHERE imx000=g_pmn[l_ac].pmn04
                        SELECT COUNT(*) INTO l_n
                          FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                           AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                           AND pmv_file.pmv09<=g_pmm.pmm04
                           AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                        IF l_n=0 THEN
                           CALL cl_err('','apm-345',1)
                           LET l_success ='N'
                           RETURN l_success
                        ELSE
                          IF l_agb03a IS NOT NULL  THEN
                            IF l_imx01a != l_imx01b THEN 
                               LET l_n =1 
                            ELSE    
                            SELECT COUNT(*) INTO l_n
                             FROM pmv_file
                            WHERE pmv_file.pmv01=l_imx00
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                              AND pmv_file.pmv09<=g_pmm.pmm04
                              AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                              AND pmv_file.pmv03=l_agb03a AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx01a)
                              AND (pmv_file.pmv05=l_imx01b OR pmv_file.pmv05='*')
                           END IF 
                           IF l_n=0 THEN
                              CALL cl_err('','apm-341',1)
                              LET l_success ='N'
                              RETURN l_success
                           ELSE
                             IF l_agb03b IS NOT NULL  THEN
                                IF l_imx02a != l_imx02b THEN 
                               LET l_n =1 
                            ELSE
                                SELECT COUNT(*) INTO l_n
                                FROM pmv_file
                                WHERE pmv_file.pmv01=l_imx00
                                AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                                AND pmv_file.pmv09<=g_pmm.pmm04
                                AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                AND pmv_file.pmv03=l_agb03b AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx02a)
                                AND (pmv_file.pmv05=l_imx02b OR pmv_file.pmv05='*')
                            END IF     
                                IF l_n=0 THEN
                                  CALL cl_err('','apm-343',1)
                                  LET l_success ='N'
                                  RETURN l_success
                                ELSE
                                  IF l_agb03c IS NOT NULL  THEN
                                  IF l_imx01a != l_imx02b THEN 
                                     LET l_n =1 
                                  ELSE
                                     SELECT COUNT(*) INTO l_n
                                     FROM pmv_file
                                     WHERE pmv_file.pmv01=l_imx00
                                       AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pmm.pmm09)
                                       AND pmv_file.pmv09<=g_pmm.pmm04
                                       AND (pmv_file.pmv10>g_pmm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                       AND pmv_file.pmv03=l_agb03c AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx03a)
                                       AND (pmv_file.pmv05=l_imx03b OR pmv_file.pmv05='*')
                                   END IF     
                                    IF l_n=0 THEN
                                       CALL cl_err('','apm-344',1)
                                       LET l_success ='N'
                                       RETURN l_success
                                    END IF
                                  END IF
                                END IF
                             END IF
                           END IF
                         END IF
                      END IF
                    END IF
                 ELSE
                    CALL cl_err('','apm-346',1)
                    LET g_pmn[l_ac].pmn04=l_pon04
                    LET l_success ='N'
                    RETURN l_success
                END IF
              ELSE
                IF l_ima152='2' THEN
                  SELECT COUNT(*) INTO l_n FROM pnc_file
                  WHERE pnc_file.pnc01=l_pon04
                  AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pmm.pmm09)
                  AND pnc_file.pnc03=g_pmn[l_ac].pmn04
                  AND pnc_file.pnc04<=g_pmm.pmm04 AND (pnc_file.pnc05>g_pmm.pmm04
                  OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                  IF l_n=0 THEN
                   CALL cl_err('','apm-347',1)
                   LET l_success ='N'
                   RETURN l_success
                  END IF
                END IF
              END IF
            ELSE  #為其他一般料號
                IF l_ima152='1' THEN
                  DROP TABLE tpmu_file
                  CREATE TEMP TABLE tpmu_file(
                  tpmu00      DECIMAL(5,0)   NOT NULL,   #替代序號
                  tpmu01      VARCHAR(40)       NOT NULL,   #料號
                  tpmu02      VARCHAR(10)       NOT NULL,   #供應商，*號代表不區分供應商
                  tpmu03      DECIMAL(5,0)   NOT NULL,   #起始碼
                  tpmu04      DECIMAL(5,0)   NOT NULL,   #截至碼
                  tpmu05      VARCHAR(20)       NOT NULL,   #原值
                  tpmu06      VARCHAR(20)       NOT NULL    #替代值
                  );
                  DECLARE t110_pmu_cl CURSOR WITH HOLD FOR
                     SELECT * FROM pmu_file
                      WHERE pmu_file.pmu01=l_pon04
                      AND (pmu_file.pmu02='*' OR pmu_file.pmu02=g_pmm.pmm09)
                      AND pmu_file.pmu07<=g_pmm.pmm04
                      AND (pmu_file.pmu08>g_pmm.pmm04 OR pmu_file.pmu08 IS NULL OR pmu_file.pmu08='')
                      ORDER BY pmu03
                     LET l_tpmu00=0
                     FOREACH t110_pmu_cl INTO l_pmu.*
                      IF l_pmu.pmu03!=l_pmu03 OR l_pmu03 IS NULL THEN
                        LET l_tpmu00=l_tpmu00+1
                      END IF
                      INSERT INTO tpmu_file VALUES (
                      l_tpmu00,l_pmu.pmu01,l_pmu.pmu02,l_pmu.pmu03,
                      l_pmu.pmu04,l_pmu.pmu05,l_pmu.pmu06)
                     END FOREACH
                  FOR l_i=1 TO l_tpmu00
                    SELECT unique tpmu03,tpmu04 INTO l_tpmu03,l_tpmu04
                    FROM tpmu_file
                    WHERE tpmu00=l_i
                    LET l_pmn04_cut=g_pmn[l_ac].pmn04[l_tpmu03,l_tpmu04]
                    SELECT COUNT(*) INTO l_n
                    FROM tpmu_file
                    WHERE tpmu_file.tpmu00=l_i
                    AND tpmu_file.tpmu06=l_pmn04_cut
                    #No.TQC-BC0212  --Begin
                    IF l_n > 0 THEN
                       EXIT FOR
                    END IF
                    #No.TQC-BC0212  --End
                  END FOR
                    IF l_n=0 THEN
                     CALL cl_err('','apm-348',1)
                     LET l_success ='N'
                     RETURN l_success
                    END IF
                ELSE
                   IF l_ima152='2' THEN
                      SELECT COUNT(*) INTO l_n FROM pnc_file
                       WHERE pnc_file.pnc01=l_pon04
                       AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pmm.pmm09)
                       AND pnc_file.pnc03=g_pmn[l_ac].pmn04
                       AND pnc_file.pnc04<=g_pmm.pmm04 AND (pnc_file.pnc05>g_pmm.pmm04
                       OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                   IF l_n=0 THEN
                    CALL cl_err('','apm-347',1)
                    LET l_success ='N'
                    RETURN l_success
                   END IF
                  END IF
                END IF
               END IF
              END IF
            END IF
          END IF
          RETURN l_success
END FUNCTION
 
FUNCTION t540_bud(p_cmd,p_flag)
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_flag      LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_flag      LIKE type_file.num5
  DEFINE l_msg       LIKE ze_file.ze03
  DEFINE l_over      LIKE afc_file.afc07
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_cmd       LIKE type_file.chr1
  DEFINE bamt1       LIKE afc_file.afc07
  DEFINE bamt2       LIKE afc_file.afc07
  DEFINE bamt3       LIKE afc_file.afc07
  DEFINE bamt4       LIKE afc_file.afc07
  DEFINE bamt5       LIKE afc_file.afc07
  DEFINE bamt6       LIKE afc_file.afc07
  DEFINE l_aag23     LIKE aag_file.aag23  #CHI-A40021 add
  DEFINE l_pmn96     LIKE pmn_file.pmn96  #CHI-A40021 add
  DEFINE l_pmn122    LIKE pmn_file.pmn122 #CHI-A40021 add
 
  LET g_errno = ''
  IF g_smy.smy59 <> 'Y' THEN RETURN END IF
 
  IF g_aza.aza08 = 'N' THEN
     LET g_pmn[l_ac].pmn96 = ' '
     LET g_pmn[l_ac].pmn122= ' '
  END IF
  IF g_bookno1 IS NULL OR g_pmn[l_ac].pmn98 IS NULL OR
     g_pmn[l_ac].pmn40 IS NULL OR g_pmm.pmm31 IS NULL OR 
     g_pmn[l_ac].pmn96 IS NULL OR g_pmn[l_ac].pmn67 IS NULL OR 
     g_pmn[l_ac].pmn122 IS NULL OR g_pmm.pmm32 IS NULL THEN
     RETURN
  END IF
 
  IF g_aaz.aaz90 = 'Y' THEN
     IF g_pmn[l_ac].pmn930 IS NULL THEN
        RETURN
     END IF
  END IF
  IF g_aza.aza63 = 'Y' THEN
     IF g_bookno2 IS NULL OR g_pmn[l_ac].pmn401 IS NULL THEN
        RETURN
     END IF
  END IF
 
  IF g_pmn[l_ac].pmn98 <> g_pmn_t.pmn98  OR
     g_pmn[l_ac].pmn40 <> g_pmn_t.pmn40  OR
     g_pmn[l_ac].pmn96 <> g_pmn_t.pmn96  OR
     g_pmn[l_ac].pmn67 <> g_pmn_t.pmn67  OR
     g_pmn[l_ac].pmn122<> g_pmn_t.pmn122 THEN
     LET l_cmd = 'a' 
  END IF
 
  IF g_aaz.aaz90 = 'Y' THEN
     IF g_pmn[l_ac].pmn930 <> g_pmn_t.pmn930 THEN
        LET l_cmd = 'a'
     END IF
  END IF
  IF g_aza.aza63 = 'Y' THEN
     IF g_pmn[l_ac].pmn401 <> g_pmn_t.pmn401 THEN
        LET l_cmd = 'a'
     END IF
  END IF
 
  #無PR,直接用新值與可用比較
  #有PR,新增或是不同預算,則用新值 - pml剩余量 與 可用量比較
  #     修改,則用新值-舊值 與 可用量比較
  IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
     LET p_sum1 = 0
     LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42
  ELSE
      IF p_cmd = 'a' OR l_cmd = 'a' THEN
         IF g_aaz.aaz90 = 'Y' THEN
             CALL s_budamt1(g_bookno1,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn40,
                            g_pmm.pmm31,g_pmn[l_ac].pmn96,
                            g_pmn[l_ac].pmn930,g_pmn[l_ac].pmn122,
                            g_pmm.pmm32,'0')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         ELSE
             CALL s_budamt1(g_bookno1,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn40,
                            g_pmm.pmm31,g_pmn[l_ac].pmn96,
                            g_pmn[l_ac].pmn67,g_pmn[l_ac].pmn122,
                            g_pmm.pmm32,'0')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         END IF
         IF cl_null(bamt1) THEN LET bamt1 = 0 END IF
         LET p_sum1 = 0
         LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42 - bamt1
      ELSE
         LET p_sum1 = g_pmn_t.pmn87 * g_pmn_t.pmn31 * g_pmm.pmm42
         LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42
      END IF
  END IF
  IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
  IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
 
  #CHI-A40021 add --start--
  SELECT aag23 INTO l_aag23 FROM  aag_file
   WHERE aag00=g_bookno1
     AND aag01=g_pmn[l_ac].pmn40
  IF l_aag23='Y' THEN
     LET l_pmn96 = g_pmn[l_ac].pmn96
     LET l_pmn122 = g_pmn[l_ac].pmn122
  ELSE
     LET l_pmn96 = ' '
     LET l_pmn122 = ' '
  END IF
  #CHI-A40021 add --end--
  IF p_flag = '1' OR p_flag = '3' THEN
     IF g_aaz.aaz90 = 'Y' THEN
        CALL s_budchk1(g_bookno1,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn40,
                       g_pmm.pmm31,l_pmn96,  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn930,l_pmn122,  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'0',p_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn40,'/',
                       g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn930,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'/',l_over
           CALL cl_err(l_msg,g_errno,1)
           RETURN
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
              LET l_msg = g_bookno1,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn40,'/',
                          g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                          g_pmn[l_ac].pmn930,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                          g_pmm.pmm32,'/',l_over
              CALL cl_err(l_msg,g_errno,1)
              LET g_errno = ' '
              RETURN
           END IF
        END IF
     ELSE
        CALL s_budchk1(g_bookno1,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn40,
                       g_pmm.pmm31,l_pmn96,  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn67,l_pmn122,  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'0',p_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn40,'/',
                       g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn67,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'/',l_over
           CALL cl_err(l_msg,g_errno,1)
           RETURN
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
              LET l_msg = g_bookno1,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn40,'/',
                          g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                          g_pmn[l_ac].pmn67,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                          g_pmm.pmm32,'/',l_over
              CALL cl_err(l_msg,g_errno,1)
              LET g_errno = ' '
              RETURN
           END IF
        END IF
     END IF
  END IF
 
  IF g_aza.aza63 = 'N' THEN RETURN END IF
  #無PR,直接用新值與可用比較
  #有PR,新增或是不同預算,則用新值 - pml剩余量 與 可用量比較
  #     修改,則用新值-舊值 與 可用量比較
  IF cl_null(g_pmn[l_ac].pmn24) AND cl_null(g_pmn[l_ac].pmn25) THEN
     LET p_sum1 = 0
     LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42
  ELSE
      IF p_cmd = 'a' OR l_cmd = 'a' THEN
         IF g_aaz.aaz90 = 'Y' THEN
             CALL s_budamt1(g_bookno2,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn401,
                            g_pmm.pmm31,g_pmn[l_ac].pmn96,
                            g_pmn[l_ac].pmn930,g_pmn[l_ac].pmn122,
                            g_pmm.pmm32,'1')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         ELSE
             CALL s_budamt1(g_bookno2,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn401,
                            g_pmm.pmm31,g_pmn[l_ac].pmn96,
                            g_pmn[l_ac].pmn67,g_pmn[l_ac].pmn122,
                            g_pmm.pmm32,'1')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         END IF
         IF cl_null(bamt1) THEN LET bamt1 = 0 END IF
         LET p_sum1 = 0
         LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42 - bamt1
      ELSE
         LET p_sum1 = g_pmn_t.pmn87 * g_pmn_t.pmn31 * g_pmm.pmm42
         LET p_sum2 = g_pmn[l_ac].pmn87 * g_pmn[l_ac].pmn31 * g_pmm.pmm42
      END IF
  END IF
  IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
  IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
  IF p_flag = '2' OR p_flag = '3' THEN
     IF g_aaz.aaz90 = 'Y' THEN
        #CHI-A40021 add --start--
        SELECT aag23 INTO l_aag23 FROM  aag_file
         WHERE aag00=g_bookno2
           AND aag01=g_pmn[l_ac].pmn401
        IF l_aag23='Y' THEN
           LET l_pmn96 = g_pmn[l_ac].pmn96
           LET l_pmn122 = g_pmn[l_ac].pmn122
        ELSE
           LET l_pmn96 = ' '
           LET l_pmn122 = ' '
        END IF
        #CHI-A40021 add --end--
        IF g_bookno2 IS NULL OR g_pmn[l_ac].pmn98 IS NULL OR
           g_pmn[l_ac].pmn401 IS NULL OR g_pmm.pmm31 IS NULL OR 
           g_pmn[l_ac].pmn96 IS NULL OR g_pmn[l_ac].pmn930 IS NULL OR 
           g_pmn[l_ac].pmn122 IS NULL OR g_pmm.pmm32 IS NULL THEN
           RETURN
        END IF
        CALL s_budchk1(g_bookno2,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn401,
                       g_pmm.pmm31,l_pmn96,  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn930,l_pmn122,  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'1',p_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno2,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn401,'/',
                       g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn930,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'/',l_over
           CALL cl_err(l_msg,g_errno,1)
           RETURN
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
              LET l_msg = g_bookno2,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn401,'/',
                          g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                          g_pmn[l_ac].pmn930,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                          g_pmm.pmm32,'/',l_over
              CALL cl_err(l_msg,g_errno,1)
              LET g_errno = ' '
              RETURN
           END IF 
        END IF
     ELSE
        IF g_bookno2 IS NULL OR g_pmn[l_ac].pmn98 IS NULL OR
           g_pmn[l_ac].pmn401 IS NULL OR g_pmm.pmm31 IS NULL OR 
           g_pmn[l_ac].pmn96 IS NULL OR g_pmn[l_ac].pmn67 IS NULL OR 
           g_pmn[l_ac].pmn122 IS NULL OR g_pmm.pmm32 IS NULL THEN
           RETURN
        END IF
        CALL s_budchk1(g_bookno2,g_pmn[l_ac].pmn98,g_pmn[l_ac].pmn401,
                       g_pmm.pmm31,l_pmn96,  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn67,l_pmn122,  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'1',p_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno2,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn401,'/',
                       g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                       g_pmn[l_ac].pmn67,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                       g_pmm.pmm32,'/',l_over
           CALL cl_err(l_msg,g_errno,1)
           RETURN
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
              LET l_msg = g_bookno2,'/',g_pmn[l_ac].pmn98,'/',g_pmn[l_ac].pmn401,'/',
                          g_pmm.pmm31,'/',l_pmn96,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn96->l_pmn96
                          g_pmn[l_ac].pmn67,'/',l_pmn122,'/',  #CHI-A40021 mod g_pmn[l_ac].pmn122->l_pmn122
                          g_pmm.pmm32,'/',l_over
              CALL cl_err(l_msg,g_errno,1)
              LET g_errno = ' '
              RETURN
           END IF 
        END IF
     END IF
  END IF
  RETURN
 
END FUNCTION
 
FUNCTION t540_chkpmn04()
DEFINE  l_rty03     LIKE rty_file.rty03,    #采購類型
        l_rty06     LIKE rty_file.rty06,    #經營方式
        l_rtz04     LIKE rtz_file.rtz04,    #商品策略
        l_n         LIKE type_file.num5
DEFINE  l_rte04     LIKE rte_file.rte04,    #可采
        l_rte07     LIKE rte_file.rte07,
        l_rtdconf   LIKE rtd_file.rtdconf,
        l_azw07     LIKE azw_file.azw07    #FUN-A80121
 
   LET g_errno = ''
   LET g_errmsg = ''
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
   IF SQLCA.sqlcode = 0 THEN
      SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_plant AND azwacti = 'Y'  #FUN-A80121
      IF NOT cl_null(l_azw07) THEN     #FUN-A80121
         SELECT rte04,rte07,rtdconf 
            INTO l_rte04,l_rte07,l_rtdconf
            FROM rtd_file,rte_file
           WHERE rte03 = g_pmn[l_ac].pmn04
             AND rtd03 = l_azw07    #FUN-A80121
             AND rtd01 = rte01
             AND rtd01 = l_rtz04
         LET g_errmsg = "arti120:"
         IF l_rtdconf='N' THEN
            LET g_errno='9029'
         ELSE
            IF l_rte04='N' THEN
               LET g_errno='art-230'
            ELSE
               IF l_rte07='N' THEN
                  LET g_errno='9028'
               END IF
            END IF
         END IF
      END IF
   ELSE
      LET g_errno = SQLCA.sqlcode
   END IF   
   IF cl_null(g_errno) THEN
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file
          WHERE rty01=g_plant AND rty02=g_pmn[l_ac].pmn04
            AND rtyacti='Y'
      LET g_errmsg = "arti110:" 
      IF cl_null(l_rty06) THEN LET l_rty06='1' END IF   #TQC-AC0371 如果沒有採購策略，默認為'1'經銷
      IF l_rty06<>g_pmm.pmm51 THEN
         LET g_errno='art-190'
      ELSE
         IF g_pmm.pmm52 = g_plant THEN   
            IF l_rty03<>'1' THEN             
               LET g_errno='art-234'
            END IF                
         ELSE
        #   SELECT azw06 INTO l_azw06 FROM azw_file       #FUN-A80121
        #       WHERE azw01=g_pmm.pmm52 AND azwacti = 'Y' #FUN-A80121
        #   IF l_azw06=g_plant THEN                       #FUN-A80121  
            SELECT azw07 INTO l_azw07 FROM azw_file       #FUN-A80121   
                WHERE azw01=g_pmm.pmm52 AND azwacti = 'Y' #FUN-A80121
            IF l_azw07=g_plant THEN                       #FUN-A80121 
               IF l_rty03<>'2' THEN             
                  LET g_errno='art-235'
               END IF   
            END IF
         END IF
      END IF
   END IF   
END FUNCTION
FUNCTION t540_transfer()
DEFINE l_pmn20 LIKE pmn_file.pmn20
DEFINE l_pmn24 LIKE pmn_file.pmn24
DEFINE l_pmn25 LIKE pmn_file.pmn25
DEFINE l_n     LIKE type_file.num5
 
    IF g_azw.azw04 <> '2' THEN
       RETURN
    END IF
 
    DROP TABLE pmn_temp
    SELECT pmn24,pmn25,pmn20 
      FROM pmn_file
     WHERE pmn01 = g_pmm.pmm01
      INTO TEMP pmn_temp
    DECLARE pmn_sel CURSOR FOR SELECT * FROM pmn_temp
    FOREACH pmn_sel INTO l_pmn24,l_pmn25,l_pmn20 
       SELECT COUNT(*) FROM pml_file
        WHERE pml01 = l_pmn24
          AND pml02 = l_pmn25
          AND pml20 <= l_pmn20
       IF l_n = 0 THEN
          UPDATE pml_file SET pml11 = 'Y'
             WHERE pml01 = l_pmn24
               AND pml02 = l_pmn25
       END IF 
       UPDATE pml_file SET pml21 = l_pmn20
          WHERE pml01 = l_pmn24
            AND pml02 = l_pmn25
    END FOREACH
END FUNCTION
#檢查由請購單帶出的商品是否為自定貨商品
FUNCTION t540_check()
DEFINE l_rty03   LIKE rty_file.rty03
DEFINE l_pml04   LIKE pml_file.pml04
 
   LET g_errno = ""
 
   IF g_pmn[l_ac].pmn24 IS NULL OR g_pmn[l_ac].pmn25 IS NULL THEN   
      RETURN
   END IF
 
   SELECT pml04 INTO l_pml04 FROM pml_file WHERE pml01 = g_pmn[l_ac].pmn24
      AND pml02 = g_pmn[l_ac].pmn25
   IF STATUS THEN
      LET g_errno = STATUS
      RETURN
   END IF

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 --- add begin
#&ifdef SLK
#  SELECT DISTINCT(ata05) INTO l_pml04 
#    FROM ata_file
#   WHERE ata00='apmt420_slk'
#     AND ata01=g_pmn[l_ac].pmn24
#     AND ata02=g_pmn[l_ac].pmn25
#  IF STATUS THEN
#     LET g_errno = STATUS
#     RETURN
#  END IF
#&endif
##FUN-A60035 -- add end
#FUN-A60035 ---MARK END
 
   SELECT rty03 INTO l_rty03 FROM rty_file WHERE rty01 = g_pmm.pmmplant
      AND rty02 = l_pml04
   IF STATUS THEN
      LET g_errno = STATUS
      RETURN
   END IF
 
   IF l_rty03 != '1' THEN
      LET g_errno = 'art-234'
   END IF
END FUNCTION

FUNCTION t540_price_check(p_pmn31,p_pmn31t)
   DEFINE p_pmn31    LIKE   pmn_file.pmn31
   DEFINE p_pmn31t   LIKE   pmn_file.pmn31t
   DEFINE l_pmm41    LIKE   pmm_file.pmm41
   DEFINE l_pnz04    LIKE   pnz_file.pnz04
   DEFINE l_pnz07    LIKE   pnz_file.pnz07    #FUN-B50150      # TQC-B60300 mark
   DEFINE l_pmn04    LIKE   pmn_file.pmn04    #MOD-C90211 add

   LET g_chkprice_flag = 'N' #MOD-D10103 add
   IF cl_null(g_pmm.pmm41) THEN
   	  SELECT pmc49 INTO l_pmm41 FROM pmc_file
   	   WHERE pmc01 = g_pmm.pmm09
      IF SQLCA.sqlcode THEN 
      	 CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
         LET g_chkprice_flag = 'Y' #MOD-D10103 add
      	 RETURN
      END IF	  
   ELSE 
   	  LET l_pmm41 = g_pmm.pmm41	   
   END IF

   IF NOT cl_null(l_pmm41) THEN
   	  SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file    #FUN-B50150 add pnz07   # TQC-B60300 mark
   	   WHERE pnz01 = l_pmm41
      IF SQLCA.sqlcode THEN 
      	 CALL cl_err( 'sel pnz04,pnz07' , SQLCA.sqlcode,0)      #FUN-B50150  add pnz07
         LET g_chkprice_flag = 'Y' #MOD-D10103 add
      	 RETURN
      END IF	   	   
   END IF 
#MOD-B80332 -- mark begin --
#  IF l_pnz04 = 'Y'  THEN 
#TQC-B40226 --begin--  
#  	 IF g_azw.azw04 = '1' THEN 
#  	   IF g_gec07 = 'Y' THEN 
#  	     CALL cl_set_comp_entry("pmn31",FALSE)
#  	     CALL cl_set_comp_entry("pmn31t",TRUE)
#  	   ELSE 
#  	     CALL cl_set_comp_entry("pmn31t",FALSE)
#  	     CALL cl_set_comp_entry("pmn31",TRUE)   	   	    
#  	   END IF 
#  	 ELSE 
#TQC-B40226 --end--   	 	
#  	   IF g_gec07 = 'Y' THEN
#  	   	  CALL cl_set_comp_entry("pmn31",FALSE)  
#  	   	  IF p_pmn31t = 0 OR cl_null(p_pmn31t) THEN 
#            CALL cl_set_comp_entry("pmn31t",TRUE) 
#         ELSE 
#         	 CALL cl_set_comp_entry("pmn31t",FALSE)  	 
#         END IF
#      ELSE
#      	  CALL cl_set_comp_entry("pmn31t",FALSE)  
#  	   	  IF p_pmn31 = 0 OR cl_null(p_pmn31) THEN 
#            CALL cl_set_comp_entry("pmn31",TRUE)
#         ELSE 
#         	 CALL cl_set_comp_entry("pmn31",FALSE)     
#         END IF       	     	   	  		  
#      END IF
#    END IF         #TQC-B40226   
#  ELSE
#MOD-B80332 -- mark end --

#MOD-B60114 --begin--
#TQC-B50018 --begin--  
#   	 IF g_azw.azw04 = '1' THEN 
#   	   IF g_gec07 = 'Y' THEN 
#   	     CALL cl_set_comp_entry("pmn31",FALSE)
#   	     CALL cl_set_comp_entry("pmn31t",TRUE)
#   	   ELSE 
#   	     CALL cl_set_comp_entry("pmn31t",FALSE)
#   	     CALL cl_set_comp_entry("pmn31",TRUE)   	   	    
#   	   END IF 
#   	 ELSE 
##TQC-B50018 --end--    	
#MOD-B60114 --end--
#MOD-B80332 -- mark begin --
#  	     CALL cl_set_comp_entry("pmn31",FALSE)  
#  	     CALL cl_set_comp_entry("pmn31t",FALSE) 
#MOD-B80332 -- mark end --
#   	 END IF    #TQC-B50018    #MOD-B60114
#  END IF   #MOD-B80332 mark
   
#MOD-B80332 -- mark begin --
# TQC-B60300 mark  -Begin
 #FUN-B50150  --begin
#  IF l_pnz07 = 'Y' THEN
#     IF g_gec07 = 'Y' THEN
#        CALL cl_set_comp_entry("pmn31",FALSE)
#        IF p_pmn31t > 0 THEN
#           CALL cl_set_comp_entry("pmn31t",TRUE)
#        END IF
#     ELSE
#        CALL cl_set_comp_entry("pmn31t",FALSE)
#        IF p_pmn31 > 0 THEN
#           CALL cl_set_comp_entry("pmn31",TRUE)
#        END IF
#     END IF
#  ELSE
#     IF p_pmn31 >0 OR p_pmn31t > 0 THEN
#        CALL cl_set_comp_entry("pmn31",FALSE)
#        CALL cl_set_comp_entry("pmn31t",FALSE)
#     END IF
#  END IF
 #FUN-B50150  --end
# TQC-B60300 mark  --end
#MOD-B80332 -- mark end --

   #MOD-C90211 add start ------
   IF NOT cl_null(g_pmn04) THEN
      LET l_pmn04 = g_pmn04
   ELSE
      LET l_pmn04 = g_pmn[l_ac].pmn04
   END IF
   #MOD-C90211 add end   ------

   #FUN-BC0088 ----- add start -----
   #IF g_pmn[l_ac].pmn04[1,4] = 'MISC' THEN #MOD-C90211 mark
   IF l_pmn04[1,4] = 'MISC' THEN            #MOD-C90211 add
      IF g_gec07 = 'Y' THEN   #含稅
         CALL cl_set_comp_entry("pmn31",FALSE)
         CALL cl_set_comp_entry("pmn31t",TRUE)
      ELSE
         CALL cl_set_comp_entry("pmn31",TRUE)
         CALL cl_set_comp_entry("pmn31t",FALSE)
      END IF
      RETURN
   END IF
   #FUN-BC0088 ----- add end -----

#MOD-B80332 -- begin --
   IF g_gec07 = 'Y' THEN   #含稅
      IF p_pmn31t = 0 OR cl_null(p_pmn31t) THEN
         #未取到含稅單價
         IF l_pnz04 = 'Y' THEN #未取到單價可人工輸入
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
            LET g_chkprice_flag = 'Y' #MOD-D10103 add
         END IF
      ELSE
         #有取到含稅單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
            LET g_chkprice_flag = 'Y' #MOD-D10103 add
         END IF
      END IF
   ELSE                    #不含稅
      IF p_pmn31 = 0 OR cl_null(p_pmn31) THEN
         #未取到稅前單價
         IF l_pnz04 = 'Y' THEN   #未取到單價可人工輸入
            CALL cl_set_comp_entry("pmn31",TRUE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
            LET g_chkprice_flag = 'Y' #MOD-D10103 add
         END IF
      ELSE
         #有取到稅前單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pmn31",TRUE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
            LET g_chkprice_flag = 'Y' #MOD-D10103 add
         END IF
      END IF
   END IF
#MOD-B80332 -- end --
END FUNCTION  

FUNCTION t540_azp()
  DEFINE l_azp01  LIKE azp_file.azp01,
         l_azp03  LIKE azp_file.azp03,
         l_azp053 LIKE azp_file.azp03
  DEFINE l_dbs    LIKE type_file.chr21  
  DEFINE p_last LIKE type_file.num5        
  DEFINE p_last_plant LIKE azp_file.azp01    
 
 
    CALL s_mtrade_last_plant(g_pmm.pmm904)
         RETURNING p_last,p_last_plant
    LET g_errno=' '
    SELECT azp03,azp053 INTO l_azp03,l_azp053 FROM azp_file
      WHERE azp01=p_last_plant
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
          WHEN l_azp053 ='N' LET g_errno = 'mfg8000'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    LET l_dbs = s_dbstring(l_azp03)       #add                                                                                      
    RETURN l_dbs
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#MOD-A50210

# No.FUN-A80121  ..begin
FUNCTION t540_multi_ima01()        
DEFINE   tok          base.StringTokenizer
DEFINE   l_sql        STRING
DEFINE   l_n          LIKE type_file.num5
DEFINE   g_cnt        LIKE type_file.num5
DEFINE   l_plant      LIKE azw_file.azw01
DEFINE   l_no         LIKE rtu_file.rtu01
DEFINE   l_pmn        RECORD LIKE pmn_file.* 
DEFINE   l_ecm04      LIKE ecm_file.ecm04 
DEFINE   l_flag1      LIKE type_file.chr1, 
         l_misc       LIKE gfe_file.gfe01, 
         l_b2         LIKE ima_file.ima31,
         l_ima25      LIKE ima_file.ima25,
         l_ima31      LIKE ima_file.ima31,
         l_ima906     LIKE ima_file.ima906,
         l_ima907     LIKE ima_file.ima907,
         l_ima908     LIKE ima_file.ima907,
         l_imaacti    LIKE ima_file.imaacti,
         l_factor     LIKE ima_file.ima31_fac,
         l_qty        LIKE type_file.num10,  
         p_cmd        LIKE type_file.chr1,    
         l_ima135     LIKE ima_file.ima135,
         l_ima1002    LIKE ima_file.ima1002,
         l_ima35      LIKE ima_file.ima35,
         l_ima36      LIKE ima_file.ima36,
         l_occ1028    LIKE occ_file.occ1028,
         l_ima1010    LIKE ima_file.ima1010,
         l_fac        LIKE oeb_file.oeb05_fac,
         l_sfa065     LIKE sfa_file.sfa065,
         l_sfa05      LIKE sfa_file.sfa05,
         l_feature    LIKE oay_file.oayslip,   
         l_ima140     LIKE ima_file.ima140,
         l_imaag      LIKE ima_file.imaag,     
         l_check_r    LIKE type_file.chr1,     
         l_max        LIKE tqw_file.tqw07,
         l_ima915     LIKE ima_file.ima915,     
         l_ima49      LIKE ima_file.ima49, 
         l_ima491     LIKE ima_file.ima491, 
         l_ima44      LIKE ima_file.ima44,      
         l_flag       LIKE type_file.chr1
DEFINE l_ima02        LIKE ima_file.ima02,
       l_ima021       LIKE ima_file.ima021,
       l_ima39        LIKE ima_file.ima39,
       l_ima391       LIKE ima_file.ima391   
DEFINE l_ima08        LIKE ima_file.ima08  
DEFINE l_pmh24        LIKE pmh_file.pmh24 
DEFINE l_pmc914       LIKE pmc_file.pmc914          
DEFINE l_rtz08        LIKE rtz_file.rtz08   #FUN-B40098
DEFINE l_rtz07        LIKE rtz_file.rtz07   #FUN-B60150 ADD

    CALL s_showmsg_init()
    LET l_plant = g_plant
    LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
        WHILE tok.hasMoreTokens()
           LET l_pmn.pmn04 = tok.nextToken()
           IF NOT s_chk_item_no(l_pmn.pmn04,"") THEN
             CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file',g_errno,1) 
             CONTINUE WHILE
            END IF
#FUN-A80121---add------------10/10/20
           IF NOT s_chkima08(l_pmn.pmn04) THEN
              CONTINUE WHILE    
           END IF
           IF g_azw.azw04='2' THEN
               IF NOT t540_chk_multi_ima01(l_pmn.pmn04) THEN
                   CONTINUE WHILE 
               END IF
           END IF    
#FUN-A80121---add------------10/10/20        
           LET l_pmn.pmn01 = g_pmm.pmm01
           LET l_pmn.pmn011 = g_pmm.pmm02
           LET l_pmn.pmn012 = g_pmm.pmm05
           LET l_pmn.pmn33 = g_pmm.pmm04
           IF cl_null(l_pmn.pmn122) THEN
               LET  l_pmn.pmn122 = ''
           END IF
           LET  l_pmn.pmn65 = '1'
           LET  l_pmn.pmn41=  ''
           LET  l_pmn.pmn43 = NULL
           LET  l_pmn.pmn20 = '0'
           LET l_sql="SELECT max(pmn02)+1 FROM ",cl_get_target_table(l_plant,'pmn_file'),
                     " WHERE pmn01 = '",g_pmm.pmm01,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_pmn_pre FROM l_sql
           EXECUTE sel_pmn_pre INTO l_pmn.pmn02
           IF cl_null(l_pmn.pmn02) THEN
              LET  l_pmn.pmn02 = '1'
           END IF
           LET l_sql="SELECT ima44,ima25,ima15,ima35,ima36,ima44,ima31,ima49,ima491,ima906,ima907,ima908 FROM ",cl_get_target_table(l_plant,'ima_file'),
                     " WHERE ima01 = '",l_pmn.pmn04,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_ima_pre FROM l_sql
           EXECUTE sel_ima_pre INTO  l_pmn.pmn07,l_pmn.pmn08,l_pmn.pmn64,l_pmn.pmn52,l_pmn.pmn54,l_ima44,l_ima31,l_ima49,l_ima491,l_ima906,l_ima907,l_ima908
           IF g_sma.sma115 = 'Y' THEN            
              IF l_ima906 = '1' THEN  #不使用雙單位
                  LET l_pmn.pmn83 = NULL
                  LET l_pmn.pmn84  = NULL
                  LET l_pmn.pmn85  = NULL
              ELSE
                  LET l_pmn.pmn83 = l_ima907
                  CALL s_du_umfchk(l_pmn.pmn04,'','','',l_ima44,l_ima907,l_ima906)
                  RETURNING g_errno,l_factor
                  LET l_pmn.pmn84 = l_factor
                  LET l_pmn.pmn85  = 0
              END IF
              LET l_pmn.pmn80 = l_ima44
              LET l_pmn.pmn81  = 1
              LET l_pmn.pmn82  = 0
           END IF
           IF g_sma.sma116 MATCHES '[02]' THEN   
                LET l_pmn.pmn86 = NULL
                LET l_pmn.pmn87 = NULL
           ELSE
                LET l_pmn.pmn86 = l_ima908
                LET l_pmn.pmn87 = 0
           END IF
           LET l_misc=l_pmn.pmn04[1,4]
           IF l_pmn.pmn04[1,4]='MISC' THEN  
               LET l_pmn.pmn64="N"   
               SELECT COUNT(*) INTO l_n FROM ima_file
               WHERE ima01=l_misc
               AND ima01='MISC'
               IF l_n=0 THEN
                  CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','aim-806',1) 
                  CONTINUE WHILE
               END IF
           END IF
           LET l_feature = s_get_doc_no(g_pmn2.pmn011) 
           SELECT ima02,ima021,ima39,ima391 INTO l_ima02,l_ima021,l_ima39,l_ima391
           FROM ima_file
           WHERE ima01 = l_pmn.pmn04
  #MISC料無效時不可用於請/採購
           LET l_pmn.pmn041= l_ima02
           IF l_pmn.pmn04[1,4] <> 'MISC' THEN
              LET l_pmn.pmn40 = l_ima39
           END IF
           IF g_aza.aza63 = 'Y' THEN
              IF l_pmn.pmn04[1,4] <> 'MISC' THEN   
                 LET l_pmn.pmn401 = l_ima391
              END IF
           END IF
           SELECT pmh24 INTO l_pmh24 
           FROM pmh_file  
           WHERE pmh01 = l_pmn.pmn04 AND pmh02 = g_pmm.pmm09 AND pmh13 = g_pmm.pmm22
           AND pmh21 = " " AND pmh22 = '1' AND pmh23 = ' ' AND pmhacti = 'Y'
           IF NOT cl_null(l_pmh24) THEN
              LET l_pmn.pmn89=l_pmh24
           ELSE
              IF g_sma.sma93="Y" THEN                        #MOD-C30578 add 
                 SELECT pmc914 INTO l_pmc914 FROM pmc_file 
                 WHERE pmc01 = g_pmm.pmm09 
                 IF l_pmc914 = 'Y' THEN
                    LET l_pmn.pmn89 = 'Y'
                 ELSE
                    LET l_pmn.pmn89 = 'N'
                 END IF
              END IF                                         #MOD-C30578 add
           END IF
###### 無效料件或Phase Out者不可以請購
           IF l_pmn.pmn65='2' THEN
              SELECT COUNT(*) INTO l_n FROM sfa_file
              WHERE sfa01=l_pmn.pmn41
              AND sfa03=l_pmn.pmn04
              IF l_n=0 THEN
                 CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','asf-949',1) 
                 CONTINUE WHILE
              END IF
#輸入的委外代買料號,在備料中的委外代買要>0
              SELECT SUM(sfa05),SUM(sfa065) INTO l_sfa05,l_sfa065 FROM sfa_file 
              WHERE sfa01=l_pmn.pmn41
              AND sfa03=l_pmn.pmn04
              IF cl_null(l_sfa065) OR l_sfa065<=0 THEN
                 CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','asf-948',1) 
                 CONTINUE WHILE
              END IF
              IF g_sfb.sfb02=8 THEN        #NO:6961 若資料為8重工委外
                  IF l_sfa05<0 THEN         #零件退庫備料不可輸入
                     CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','asf-953',1) 
                     CONTINUE WHILE
                  END IF
              END IF
           END IF
           IF (l_pmn.pmn04[1,4] != 'MISC') THEN   
#採購料件/供應商控制
           SELECT ima915 INTO l_ima915 FROM ima_file
           WHERE ima01=l_pmn.pmn04
              IF l_ima915='2' OR l_ima915='3' THEN
                  CALL t540sub_pmh(l_pmn.pmn04,l_pmn.pmn41,
                                   l_pmn.pmn43,g_pmn2.pmn18,l_pmn.pmn012,g_pmm.*,g_type)       
                  IF NOT cl_null(g_errno) THEN
                     CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file',g_errno,1) 
                     CONTINUE WHILE
                  END IF
              END IF
##委外採購單料料要為工單單頭料號
              IF g_pmm.pmm02='SUB' AND l_pmn.pmn65='1' AND
                 NOT cl_null(l_pmn.pmn41) THEN
                 SELECT COUNT(*) INTO l_n
                 FROM sfb_file
                 WHERE sfb05=l_pmn.pmn04
                 AND sfb01=l_pmn.pmn41
                 IF l_n=0 THEN
                    CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','apm-333',1) 
                    CONTINUE WHILE
                 END IF
                 IF g_sfb.sfb02=8 THEN             #NO:6961#若資料為8重工委外
                    SELECT sfa05 INTO l_sfa05     #不帶零件退庫備料<0出來
                    FROM sfa_file,sfb_file
                    WHERE sfb01=sfa01
                    AND sfb01=l_pmn.pmn41
                    AND sfa03=l_pmn.pmn04
                    IF l_sfa05<0 THEN
                       CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file','asf-953',1) 
                       CONTINUE WHILE
                    END IF
                 END IF
             END IF
           END IF  
          #TQC-AC0257 Begin---
          #IF g_azw.azw04 = '2' THEN
          #    CALL s_defprice_A6(l_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm04,g_pmm.pmm22,
          #                       g_pmm.pmm21,g_pmm.pmm43,l_pmn.pmn07,g_pmm.pmmplant)
          #    RETURNING l_pmn.pmn31,l_pmn.pmn31t,l_pmn.pmn73,l_pmn.pmn74
          #END IF
          #TQC-AC0257 End-----
           CALL s_defprice_new(l_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,
                                        g_pmm.pmm04,l_pmn.pmn87,l_ecm04,g_pmm.pmm21,
                                        g_pmm.pmm43,g_type,l_pmn.pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
           RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                     l_pmn.pmn73,l_pmn.pmn74   #TQC-AC0257 add 
           IF l_pmn.pmn73 IS NULL THEN LET l_pmn.pmn73 = '4' END IF
#料件主檔檢查/預設值的讀取
            IF g_sma.sma115 = 'Y' THEN
                CALL s_chk_va_setting(l_pmn.pmn04)
                RETURNING g_flag,g_ima906,g_ima907
                IF g_flag=1 THEN
                   CONTINUE WHILE
                END IF
                CALL s_chk_va_setting1(l_pmn.pmn04)
                   RETURNING g_flag,g_ima908
                IF g_flag=1 THEN
                   CONTINUE WHILE
                END IF
                IF g_ima906 = '3' THEN
                   LET l_pmn.pmn83=g_ima907
                   LET l_pmn.pmn85 = s_digqty(l_pmn.pmn85,l_pmn.pmn83)   #FUN-910088--add--
                   SELECT ima44 INTO l_ima44 FROM ima_file
                   WHERE ima01=l_pmn.pmn04
                   LET l_pmn.pmn80=l_ima44
                   LET l_pmn.pmn82 = s_digqty(l_pmn.pmn82,l_pmn.pmn80)    #FUN-910088--add--
                END IF
#計價單位與數量應不受多單位參數影響
           END IF 
           IF NOT t540_multi_ima01_1(l_pmn.pmn04) THEN
               CONTINUE WHILE 
           END IF
           LET l_sql="SELECT pmh04,pmh07 FROM ",cl_get_target_table(l_plant,'pmh_file'),
                     " WHERE pmh01 = '",l_pmn.pmn04,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_pmh_pre FROM l_sql
           EXECUTE sel_pmh_pre INTO  l_pmn.pmn06,l_pmn.pmn123

           LET l_sql="SELECT gen03 FROM ",cl_get_target_table(l_plant,'gen_file'),
                     " WHERE gen01 = '",g_pmm.pmm12,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_gen03_pre FROM l_sql
           EXECUTE sel_gen03_pre INTO  l_pmn.pmn67

           LET l_sql="SELECT imb118 FROM ",cl_get_target_table(l_plant,'imb_file'),
                   " WHERE imb01 = '",l_pmn.pmn04,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_imb_pre FROM l_sql
           EXECUTE sel_imb_pre INTO  l_pmn.pmn30
           IF cl_null(l_pmn.pmn30)  THEN
              LET  l_pmn.pmn30 = '0'
           END IF 
           LET  l_pmn.pmn03 = NULL
           LET  l_pmn.pmn05 = NULL
           IF NOT cl_null(l_pmn.pmn04) THEN 
           CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,
                         l_pmn.pmn08)
                RETURNING g_sw,l_pmn.pmn09
           END IF 
           LET  l_pmn.pmn10 = NULL
           LET  l_pmn.pmn11 = 'N'
           IF NOT cl_null(l_pmn.pmn04) THEN
              CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13
           END IF
           LET  l_pmn.pmn121 = '1'
           LET  l_pmn.pmn14 = g_sma.sma886[1,1] 
           LET  l_pmn.pmn15 = g_sma.sma886[2,2]      
           LET  l_pmn.pmn16 = '0'
           LET  l_pmn.pmn18 = NULL
           LET  l_pmn.pmn23 = NULL
           LET  l_pmn.pmn24 = NULL
           LET  l_pmn.pmn25 = NULL
           LET  l_pmn.pmn32 = NULL
          #MOD-B90117 mod begin-----------------
          #LET  l_pmn.pmn34 = l_pmn.pmn33 + l_ima49
          #LET  l_pmn.pmn35 = l_pmn.pmn34 + l_ima491
           CALL t540_get_date(l_pmn.pmn33,l_ima49) RETURNING l_pmn.pmn34
           CALL t540_get_date(l_pmn.pmn34,l_ima491) RETURNING l_pmn.pmn35
          #MOD-B90117 mod end-------------------
           LET  l_pmn.pmn36 = NULL
           LET  l_pmn.pmn37 = NULL
           LET  l_pmn.pmn38 = g_pmm.pmm45
           LET  l_pmn.pmn42 = '0'
           LET  l_pmn.pmn431 = NULL
           LET  l_pmn.pmn44 = cl_digcut( l_pmn.pmn31*g_pmm.pmm42, g_azi03)
           LET  l_pmn.pmn45 = NULL
           LET  l_pmn.pmn46 = NULL
           LET  l_pmn.pmn50 = '0'
           LET  l_pmn.pmn51 = '0'
           LET  l_pmn.pmn53 = '0'
           LET  l_pmn.pmn55 = '0'
           LET  l_pmn.pmn56 = ''
           LET  l_pmn.pmn57 = '0'
           LET  l_pmn.pmn58 = '0'
           LET  l_pmn.pmn59 = NULL
           LET  l_pmn.pmn60 = NULL
           LET  l_pmn.pmn61 = l_pmn.pmn04
           LET  l_pmn.pmn90 = g_pmn2.pmn31
           LET  l_pmn.pmn62 = '1'
           LET  l_pmn.pmn63 = 'N'
           LET  l_pmn.pmn66 = NULL
           LET  l_pmn.pmn71 = NULL
           LET  l_pmn.pmn88 = l_pmn.pmn31 * l_pmn.pmn87 
           LET  l_pmn.pmn88t= l_pmn.pmn31t* l_pmn.pmn87   
           LET  l_pmn.pmn94 = NULL
           LET  l_pmn.pmn95 = NULL
           LET  l_pmn.pmn96 = NULL
           LET  l_pmn.pmn97 = NULL
           LET  l_pmn.pmn98 = NULL
           LET  l_pmn.pmn91 = NULL
           LET  l_pmn.pmnplant = g_plant
           LET  l_pmn.pmnlegal = g_legal
           LET  l_pmn.pmn72 = NULL
           LET  l_pmn.pmn75 = NULL
           LET  l_pmn.pmn76 = NULL
           LET  l_pmn.pmn77 = NULL
           LET  l_pmn.pmn012 = ''
           IF g_azw.azw04 = '2' THEN
              LET l_pmn.pmn52=' '
              LET l_pmn.pmn54=' '
            #FUN-B60150 ADD&MARK BEGIN ---------------------------------------
            ##FUN-B40098 Begin---
            # IF g_pmm.pmm51 = '3' THEN
            #    SELECT rtz08 INTO l_rtz08 FROM rtz_file
            #     WHERE rtz01 = g_pmm.pmmplant
            #    IF NOT cl_null(l_rtz08) THEN
            #       LET l_pmn.pmn52 = l_rtz08
            #       LET l_pmn.pmn54 = ' '
            #       LET l_pmn.pmn56 = ' '
            #    END IF
            # END IF
            ##FUN-B40098 End-----
              #FUN-C90049 mark begin---
              #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
              # WHERE rtz01 = g_pmm.pmmplant
              #FUN-C90049 mark end-----
              CALL s_get_defstore(g_pmm.pmmplant,l_pmn.pmn04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
              IF g_pmm.pmm51 = '3' AND (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2') THEN
                 IF NOT cl_null(l_rtz08) THEN
                    LET l_pmn.pmn52 = l_rtz08
                    LET l_pmn.pmn54 = ' '
                    LET l_pmn.pmn56 = ' '
                 END IF
              END IF
              IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
                 IF NOT cl_null(l_rtz07) THEN
                    LET g_pmn[l_ac].pmn52 = l_rtz07
                    LET l_pmn.pmn54 = ' '
                    LET l_pmn.pmn56 = ' '
                 END IF
              END IF
            #FUN-B60150 ADD&MARK  END  ---------------------------------------
           END　 IF   
        #TQC-AB0044  --mark
        ##No.FUN-AA0049--begin
        #  IF NOT s_chk_ware1(l_pmn.pmn52,l_plant) THEN
        #     LET l_pmn.pmn52=' '
        #     LET l_pmn.pmn54=' '
        #  END IF 
        ##No.FUN-AA0049--end     
        #TQC-AB0044 --end
           LET l_sql="SELECT gem10 FROM ",cl_get_target_table(l_plant,'gem_file'),
                     " WHERE gem01 = '",l_pmn.pmn67,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_gem10_pre FROM l_sql
           EXECUTE sel_gem10_pre INTO  l_pmn.pmn930
           CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                           l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
           INSERT INTO pmn_file VALUES (l_pmn.*)
           IF SQLCA.sqlcode THEN
                CALL s_errmsg('pmn01',l_pmn.pmn04,'INS pmn_file',SQLCA.sqlcode,1) 
                CONTINUE WHILE
#CHI-B70016-add-str--
#CHI-B70016-add-end--
           END IF
        END WHILE
    CALL s_showmsg()
END FUNCTION
#參考FUNCTION t540_check_pmn04(p_field,p_ac,p_cmd)中 多角貿易的邏輯 
FUNCTION  t540_multi_ima01_1(l_pmn04)
   DEFINE b_azp03       LIKE type_file.chr21 
   DEFINE e_azp03       LIKE type_file.chr21 
   DEFINE l_poz011      LIKE poz_file.poz011 
   DEFINE b_ima918      LIKE ima_file.ima918 
   DEFINE b_ima921      LIKE ima_file.ima921 
   DEFINE e_ima918      LIKE ima_file.ima918 
   DEFINE e_ima921      LIKE ima_file.ima921 
   DEFINE l_sql         STRING  
   DEFINE l_ecm04       LIKE ecm_file.ecm04   
   DEFINE b_azp01       LIKE azp_file.azp01   
   DEFINE e_azp01       LIKE azp_file.azp01
   DEFINE l_pmn04       LIKE pmn_file.pmn04
   DEFINE l_pmn         RECORD LIKE pmn_file.* 
      IF g_pmm.pmm901="Y" THEN
        SELECT poz011 INTO l_poz011 FROM poz_file
         WHERE poz01 = g_pmm.pmm904
  
        IF l_poz011 = "1" THEN
           SELECT azp03,azp01 INTO b_azp03,b_azp01         
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
  
           SELECT azp03,azp01 INTO e_azp03,e_azp01         
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
        ELSE
           SELECT azp03,azp01 INTO e_azp03,e_azp01          
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MIN(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
  
           SELECT azp03,azp01 INTO b_azp03,b_azp01          
             FROM poy_file,azp_file
            WHERE poy01 = g_pmm.pmm904
              AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                             WHERE poy01= g_pmm.pmm904)
              AND poy04 = azp01
        END IF
  
        LET b_azp03 = s_dbstring(b_azp03)                                                                        
                                                                                                                                    
        LET e_azp03 = s_dbstring(e_azp03)     
  
      # LET l_sql = " SELECT ima918,ima921 FROM ",b_azp03 CLIPPED,"ima_file ",              
        LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(b_azp01,'ima_file'), 
                    "  WHERE ima01 ='",l_pmn04,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
        CALL cl_parse_qry_sql(l_sql,b_azp01) RETURNING l_sql    
        PREPARE b_ima01_pre FROM l_sql
  
        DECLARE b_ima01_cs CURSOR FOR b_ima01_pre
  
        OPEN b_ima01_cs
  
        FETCH b_ima01_cs INTO b_ima918,b_ima921
        IF SQLCA.SQLCODE THEN
          #CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','b_ima_cs',1)  #MOD-D10214 mark
           CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','axm-297',1)   #MOD-D10214
           RETURN FALSE           
        END IF
  
        IF cl_null(b_ima918) THEN
           LET b_ima918 = "N"
        END IF
  
        IF cl_null(b_ima921) THEN
           LET b_ima921 = "N"
        END IF
  
       #LET l_sql = " SELECT ima918,ima921 FROM ",e_azp03 CLIPPED,"ima_file ",             
        LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(e_azp01,'ima_file'), 
                    "  WHERE ima01 ='",l_pmn04,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 
        CALL cl_parse_qry_sql(l_sql,e_azp01) RETURNING l_sql          
        PREPARE e_ima02_pre FROM l_sql
  
        DECLARE e_ima02_cs CURSOR FOR e_ima02_pre
  
        OPEN e_ima02_cs
  
        FETCH e_ima02_cs INTO e_ima918,e_ima921
        IF SQLCA.SQLCODE THEN
          #CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','e_ima_cs',1) #MOD-D10214 mark
           CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','axm-297',1)  #MOD-D10214
           RETURN FALSE            
        END IF
  
        IF cl_null(e_ima918) THEN
           LET e_ima918 = "N"
        END IF
  
        IF cl_null(e_ima921) THEN
           LET e_ima921 = "N"
        END IF
  
        IF e_ima918 = "Y" OR e_ima921 = "Y" THEN
           IF b_ima918 <> "Y" AND b_ima921 <> "Y" THEN                                                                             
              CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','axm-087',1)
              RETURN FALSE  
           END IF
        END IF
     END IF
     RETURN TRUE
END FUNCTION     
# No.FUN-A80121  ..end

#No.FUN-A80121---add---10/10/20
FUNCTION t540_chk_multi_ima01(l_pmn04) 
DEFINE  l_rty03     LIKE rty_file.rty03,    #采購類型
        l_rty06     LIKE rty_file.rty06,    #經營方式
        l_rtz04     LIKE rtz_file.rtz04,    #商品策略
        l_n         LIKE type_file.num5
DEFINE  l_rte04     LIKE rte_file.rte04,    #可采
        l_rte07     LIKE rte_file.rte07,
        l_rtdconf   LIKE rtd_file.rtdconf,
        l_azw07     LIKE azw_file.azw07
DEFINE  l_pmn04     LIKE pmn_file.pmn04
DEFINE   l_pmn      RECORD LIKE pmn_file.* 
      LET g_errno = ''       
      IF g_azw.azw04='2' THEN
         LET g_errno = ''
         SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
         IF cl_null(g_errno) THEN
            SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file
            WHERE rty01=g_plant AND rty02=l_pmn04
                  AND rtyacti='Y'
            IF cl_null(l_rty06) THEN LET l_rty06='1' END IF   #TQC-AC0371 如果沒有採購策略，默認為'1'經銷
            IF l_rty06<>g_pmm.pmm51 THEN
               CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','art-190',1)
               RETURN FALSE  
            ELSE
               IF g_pmm.pmm52 = g_plant THEN   
                  IF l_rty03<>'1' THEN 
                     CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','art-234',1)
                     RETURN FALSE  
                  END IF                
               ELSE
                 SELECT azw07 INTO l_azw07 FROM azw_file
                 WHERE azw01=g_pmm.pmm52 AND azwacti = 'Y'
                 IF l_azw07=g_plant THEN
                    IF l_rty03<>'2' THEN
                       CALL s_errmsg('pmn01',l_pmn04,'INS pmn_file','art-235',1)
                       RETURN FALSE  
                    END IF   
                 END IF
               END IF
            END IF
         END IF
      END IF   
      RETURN TRUE    
END FUNCTION
#No.FUN-A80121---add---10/10/20
#MOD-B30347---add--str--
#當BLANK PO不為空時，變動採購日期檢查是否失效
FUNCTION t540_chk_pon19(p_pmm01,p_pmm04)
   DEFINE p_pmm01     LIKE pmm_file.pmm01
   DEFINE p_pmm04     LIKE pmm_file.pmm04
   DEFINE l_pmn68     LIKE pmn_file.pmn68
   DEFINE l_pmn69     LIKE pmn_file.pmn69
   DEFINE l_pon19     LIKE pon_file.pon19
   

   DECLARE cur_pon19 CURSOR FOR SELECT pmn68,pmn69 FROM pmn_file
                                 WHERE pmn01 = p_pmm01
                                   AND pmn68 IS NOT NULL
   FOREACH cur_pon19 INTO l_pmn68,l_pmn69
      IF NOT cl_null(l_pmn68) THEN
         SELECT pon19 INTO l_pon19 
           FROM pon_file
          WHERE pon01 = l_pmn68
            AND pon02 = l_pmn69
         IF p_pmm04 > l_pon19 THEN            
            RETURN FALSE
         END IF
      END IF
   END FOREACH
   RETURN TRUE
END FUNCTION
#MOD-B30347---add--end--

#MOD-B90117 add--------begin----------
#根據日期和前置天數計算到廠和入庫日期
FUNCTION t540_get_date(p_date,p_day)
DEFINE p_date LIKE type_file.dat
DEFINE p_day  LIKE type_file.num5
DEFINE l_date LIKE type_file.dat
DEFINE l_i    LIKE type_file.num5
DEFINE l_flag LIKE type_file.chr1,
       l_dat  LIKE type_file.dat

   LET l_date = NULL

   FOR l_i=1 TO p_day
      IF cl_null(l_date) THEN
         LET l_date = p_date + 1
      ELSE
         LET l_date = l_date + 1
      END IF
      CALL s_wkday(l_date) RETURNING l_flag,l_dat
      IF l_flag = 1 THEN
         LET l_date = l_dat
      END IF
   END FOR

   IF p_day = 0 THEN RETURN p_date END IF #TQC-B90163

   RETURN l_date
END FUNCTION
#FUN-B90103--add---------begin-----------
#FUN-B90103----end--------------
#MOD-B90117 add---------end---------

#No.FUN-BB0086---add---begin---
FUNCTION t540_pmn82_check(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_pmn[l_ac].pmn82) AND NOT cl_null(g_pmn[l_ac].pmn80) THEN
      IF cl_null(g_pmn_t.pmn82) OR cl_null(g_pmn80_t) OR g_pmn_t.pmn82 != g_pmn[l_ac].pmn82 OR g_pmn80_t != g_pmn[l_ac].pmn80 THEN
         LET g_pmn[l_ac].pmn82=s_digqty(g_pmn[l_ac].pmn82,g_pmn[l_ac].pmn80)
         DISPLAY BY NAME g_pmn[l_ac].pmn82
      END IF
   END IF

   IF NOT cl_null(g_pmn[l_ac].pmn82) THEN
      IF g_pmn[l_ac].pmn82 < 0 THEN
         CALL cl_err('','aim-391',1)  #   #MOD-640492 0->1
         RETURN FALSE,'pmn82'
      END IF
      LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
      LET g_pmn_o.pmn82 = g_pmn[l_ac].pmn82
   END IF
   #計算pmn20,pmn07的值,檢查數量的合理性
    CALL t540_set_origin_field()
    CALL t540_check_inventory_qty(p_cmd)
        RETURNING g_flag
    IF g_flag = '1' THEN
       IF g_ima906 = '3' OR g_ima906 = '2' THEN  #No.FUN-560020
          RETURN FALSE,'pmn85'
       ELSE
          RETURN FALSE,'pmn82'
       END IF
    END IF

    IF cl_null(g_pmn[l_ac].pmn86) THEN
       LET g_pmn[l_ac].pmn87 = 0
    ELSE
       IF p_cmd = 'a' OR  p_cmd = 'u' AND
             (g_pmn_t.pmn81 <> g_pmn[l_ac].pmn81 OR
              g_pmn_t.pmn82 <> g_pmn[l_ac].pmn82 OR
              g_pmn_t.pmn84 <> g_pmn[l_ac].pmn84 OR
              g_pmn_t.pmn85 <> g_pmn[l_ac].pmn85 OR
              g_pmn_t.pmn86 <> g_pmn[l_ac].pmn86) THEN
          CALL t540_set_pmn87()
       END IF
    END IF
    CALL t540_bud(p_cmd,'3')
    IF NOT cl_null(g_errno) THEN
       RETURN FALSE,'pmn82'
    END IF
   CALL cl_show_fld_cont()                  
   RETURN TRUE,''
END FUNCTION

FUNCTION t540_pmn85_check(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_pmn[l_ac].pmn85) AND NOT cl_null(g_pmn[l_ac].pmn83) THEN
      IF cl_null(g_pmn_t.pmn85) OR cl_null(g_pmn83_t) OR g_pmn_t.pmn85 != g_pmn[l_ac].pmn85 OR g_pmn83_t != g_pmn[l_ac].pmn83 THEN
         LET g_pmn[l_ac].pmn85=s_digqty(g_pmn[l_ac].pmn85,g_pmn[l_ac].pmn83)
         DISPLAY BY NAME g_pmn[l_ac].pmn85
      END IF
   END IF
   IF NOT cl_null(g_pmn[l_ac].pmn85) THEN
      IF g_pmn[l_ac].pmn85 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_pmn_t.pmn85 <> g_pmn[l_ac].pmn85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_pmn[l_ac].pmn85*g_pmn[l_ac].pmn84
            LET g_pmn[l_ac].pmn85 = s_digqty(g_pmn[l_ac].pmn85,g_pmn[l_ac].pmn83)    #FUN-910088--add--
            IF cl_null(g_pmn[l_ac].pmn82) OR g_pmn[l_ac].pmn82=0 THEN 
               LET g_pmn[l_ac].pmn82=g_tot*g_pmn[l_ac].pmn81
               LET g_pmn[l_ac].pmn82 = s_digqty(g_pmn[l_ac].pmn82,g_pmn[l_ac].pmn80)    #FUN-910088--add--
               LET g_pmn2.pmn82  = g_pmn[l_ac].pmn82
               LET g_pmn_o.pmn82 = g_pmn[l_ac].pmn82
               DISPLAY BY NAME g_pmn[l_ac].pmn82                          
            END IF                                                    
         END IF
      END IF
      LET g_pmn2.pmn85  = g_pmn[l_ac].pmn85
      LET g_pmn_o.pmn85 = g_pmn[l_ac].pmn85
   END IF
   IF cl_null(g_pmn[l_ac].pmn86) THEN
      LET g_pmn[l_ac].pmn87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_pmn_t.pmn81 <> g_pmn[l_ac].pmn81 OR
             g_pmn_t.pmn82 <> g_pmn[l_ac].pmn82 OR
             g_pmn_t.pmn84 <> g_pmn[l_ac].pmn84 OR
             g_pmn_t.pmn85 <> g_pmn[l_ac].pmn85 OR
             g_pmn_t.pmn86 <> g_pmn[l_ac].pmn86) THEN
         CALL t540_set_pmn87()
      END IF
   END IF
   CALL t540_bud(p_cmd,'3')
   IF NOT cl_null(g_errno) THEN
      RETURN FALSE 
   END IF
   CALL cl_show_fld_cont()                  
   RETURN TRUE
END FUNCTION

FUNCTION t540_pmn87_check(p_cmd,l_ecm04)
   DEFINE p_cmd   LIKE type_file.chr1
   DEFINE l_ecm04 LIKE ecm_file.ecm04
   IF NOT cl_null(g_pmn[l_ac].pmn87) AND NOT cl_null(g_pmn[l_ac].pmn86) THEN
      IF cl_null(g_pmn_t.pmn87) OR cl_null(g_pmn86_t) OR g_pmn_t.pmn87 != g_pmn[l_ac].pmn87 OR g_pmn86_t != g_pmn[l_ac].pmn86 THEN
         LET g_pmn[l_ac].pmn87=s_digqty(g_pmn[l_ac].pmn87,g_pmn[l_ac].pmn86)
         DISPLAY BY NAME g_pmn[l_ac].pmn87
      END IF
   END IF
   IF NOT cl_null(g_pmn[l_ac].pmn87) THEN
      IF g_pmn[l_ac].pmn87 < 0 THEN
         CALL cl_err('','aim-391',1)  #  #MOD-640492 0->1
         RETURN FALSE 
      END IF
      CALL t540_bud(p_cmd,'3')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE 
      END IF
      IF g_pmn[l_ac].pmn87 <> g_pmn_o.pmn87 THEN
         CALL s_defprice_new(g_pmn[l_ac].pmn04,g_pmm.pmm09,g_pmm.pmm22,
                             g_pmm.pmm04,g_pmn[l_ac].pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                             g_pmn[l_ac].pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
                          g_pmn[l_ac].pmn73,g_pmn[l_ac].pmn74   #TQC-AC0257 add
         IF g_pmn[l_ac].pmn73 IS NULL THEN LET g_pmn[l_ac].pmn73 = '4' END IF #TQC-AC0257
         CALL t540_price_check(g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t)  #MOD-9C0285 ADD--
         #MOD-B30280 add --start--
         LET g_pmn2.pmn44 = g_pmn[l_ac].pmn31 * g_pmm.pmm42 #本幣單價
         CALL cl_digcut(g_pmn2.pmn44,g_azi03) RETURNING g_pmn2.pmn44   #No.CHI-6A0004
         #MOD-B30280 add --end--
      END IF        
      LET g_pmn2.pmn87  = g_pmn[l_ac].pmn87
      LET g_pmn_o.pmn87 = g_pmn[l_ac].pmn87
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end--- 

#TQC-C20013 add begin-----------------------------
FUNCTION t540_get_price()
DEFINE l_pmn01     LIKE pmn_file.pmn01
DEFINE l_pmn02     LIKE pmn_file.pmn02
DEFINE l_pmn65     LIKE pmn_file.pmn65
DEFINE l_pmn04     LIKE pmn_file.pmn04
DEFINE l_pmn87     LIKE pmn_file.pmn87
DEFINE l_pmn86     LIKE pmn_file.pmn86
DEFINE l_pmn31     LIKE pmn_file.pmn31
DEFINE l_pmn31t    LIKE pmn_file.pmn31t
DEFINE l_pmn41     LIKE pmn_file.pmn41
DEFINE l_pmn88     LIKE pmn_file.pmn88
DEFINE l_pmn88t    LIKE pmn_file.pmn88t
DEFINE l_ecm04     LIKE ecm_file.ecm04
DEFINE l_pmn90     LIKE pmn_file.pmn90
DEFINE l_pmn73     LIKE pmn_file.pmn73
DEFINE l_pmn74     LIKE pmn_file.pmn74
DEFINE l_pmn44     LIKE pmn_file.pmn44

   SELECT COUNT(*) INTO g_cnt FROM pmn_file
    WHERE pmn01=g_pmm.pmm01
   IF g_cnt > 0 THEN
      IF cl_confirm('apm-543') THEN  #是否重新取價
         DECLARE upd_pmn_cs1 CURSOR FOR
          SELECT pmn01,pmn02,pmn65,pmn04,pmn87,pmn86,pmn31,pmn31t,pmn43,pmn41,pmn88,pmn88t
            FROM pmn_file
           WHERE pmn01=g_pmm.pmm01
         FOREACH upd_pmn_cs1 INTO l_pmn01,l_pmn02,l_pmn65,l_pmn04,l_pmn87,l_pmn86,l_pmn31,l_pmn31t,l_pmn43,l_pmn41
                                ,l_pmn88,l_pmn88t
            LET l_ecm04=' '
            IF NOT cl_null(l_pmn43) AND l_pmn43 != 0 THEN
               SELECT ecm04 INTO l_ecm04 FROM ecm_file
                WHERE ecm01 = l_pmn41 AND ecm03 = l_pmn43
            END IF

            LET g_type = '2'
            LET g_errno=''
            CALL s_defprice_new(l_pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,
                                l_pmn87,l_ecm04,g_pmm.pmm21,g_pmm.pmm43,g_type,
                                l_pmn86,'',g_pmm.pmm41,g_pmm.pmm20,g_pmm.pmmplant)
                      RETURNING l_pmn31,l_pmn31t,
                                l_pmn73,l_pmn74
            CALL t540_price_check(l_pmn31,l_pmn31t)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               EXIT FOREACH
            END IF

            LET l_pmn44 = cl_digcut( l_pmn31*g_pmm.pmm42, g_azi03 )
            LET l_pmn90 = l_pmn31
            #重新取價後金額重算
            LET l_pmn88 = l_pmn31 * l_pmn87
            LET l_pmn88t= l_pmn31t* l_pmn87
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01=g_pmm.pmm22 AND aziacti ='Y'
            CALL cl_digcut(l_pmn88,t_azi04) RETURNING  l_pmn88
            CALL cl_digcut(l_pmn88t,t_azi04) RETURNING l_pmn88t
            IF g_gec07 = 'N' THEN
               LET l_pmn88t = l_pmn88 * ( 1 + g_pmm.pmm43/100)
               LET l_pmn88t = cl_digcut(l_pmn88t,t_azi04)
            ELSE
               #IF g_gec05 = 'T' THEN
               IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                  LET l_pmn88  = l_pmn88t* ( 1 - g_pmm.pmm43/100)
                  LET l_pmn88  = cl_digcut(l_pmn88,t_azi04)
               ELSE
                  LET l_pmn88  = l_pmn88t/ ( 1 + g_pmm.pmm43/100)
                  LET l_pmn88  = cl_digcut(l_pmn88,t_azi04)
               END IF
            END IF

            UPDATE pmn_file SET pmn31 = l_pmn31,
                                pmn31t= l_pmn31t,
                                pmn88 = l_pmn88,
                                pmn88t= l_pmn88t,
                                pmn44 = l_pmn44,
                                pmn90 = l_pmn90
             WHERE pmn01 = l_pmn01 AND pmn02 = l_pmn02
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","pmn_file",l_pmn01,l_pmn02,STATUS,"","upd pmn:",1)
               EXIT FOREACH
            END IF

         END FOREACH
         CALL t540_b_fill(' 1=1',' 1=1')
         CALL t540_update()
      END IF
   END IF
END FUNCTION
#TQC-C20013 add end-------------------------------

#TQC-C10071 add begin-----------------------------
#根據工單編號抓取對應的料件編號
FUNCTION t540_get_pmn04()
DEFINE l_pmn04_s STRING
DEFINE l_pmn04   LIKE pmn_file.pmn04

   LET l_pmn04_s = " ima01 IN("
   SELECT sfb05 INTO l_pmn04 FROM sfb_file
    WHERE sfb01  = g_pmn[l_ac].pmn41
      AND sfb87 != 'X'
   LET l_pmn04_s = l_pmn04_s,"'",l_pmn04,"'"

   DECLARE t540_sel_sfa03 CURSOR FOR
         SELECT sfa03 FROM sfa_file
          WHERE sfa01=g_pmn[l_ac].pmn41
             AND sfa065>0 AND sfa05 > 0
   FOREACH t540_sel_sfa03 INTO l_pmn04
      LET l_pmn04_s = l_pmn04_s,",'",l_pmn04,"'"
   END FOREACH
   LET l_pmn04_s = l_pmn04_s,")"

   RETURN l_pmn04_s
END FUNCTION
#TQC-C10071 add end-------------------------------
#TQC-C30109---begin
FUNCTION t540_qry_ima01()
DEFINE l_pmn80     LIKE pmn_file.pmn80,
       l_pmn81     LIKE pmn_file.pmn81,
       l_pmn82     LIKE pmn_file.pmn82,
       l_pmn83     LIKE pmn_file.pmn83,
       l_pmn84     LIKE pmn_file.pmn84,
       l_pmn85     LIKE pmn_file.pmn85,
       l_pmn86     LIKE pmn_file.pmn86,
       l_pmn87     LIKE pmn_file.pmn87,
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       l_ima908    LIKE ima_file.ima908,
       l_ima44     LIKE ima_file.ima44,
       l_factor    LIKE ima_file.ima31_fac 
       
DEFINE l_sql       STRING
   LET l_sql="SELECT ima44,ima906,ima907,ima908 FROM ",cl_get_target_table(g_plant,'ima_file'),
             " WHERE ima01 = '",g_pmn[l_ac].pmn04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
   PREPARE sel_ima_pre1 FROM l_sql
   EXECUTE sel_ima_pre1 INTO  l_ima44,l_ima906,l_ima907,l_ima908
   IF g_sma.sma115 = 'Y' THEN            
      IF l_ima906 = '1' THEN  #不使用雙單位
         LET l_pmn83 = NULL
         LET l_pmn84  = NULL
         LET l_pmn85  = NULL
      ELSE
         LET l_pmn83 = l_ima907
         CALL s_du_umfchk(g_pmn[l_ac].pmn04,'','','',l_ima44,l_ima907,l_ima906)
         RETURNING g_errno,l_factor
         LET l_pmn84 = l_factor
         LET l_pmn85  = 0
      END IF
         LET l_pmn80 = l_ima44
         LET l_pmn81  = 1
         LET l_pmn82  = 0
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN   
      LET l_pmn86 = NULL
      LET l_pmn87 = NULL
   ELSE
      LET l_pmn86 = l_ima908
      LET l_pmn87 = 0
   END IF
   
   LET g_pmn[l_ac].pmn80 = l_pmn80
   LET g_pmn[l_ac].pmn81 = l_pmn81
   #LET g_pmn[l_ac].pmn82 = l_pmn82
   LET g_pmn[l_ac].pmn83 = l_pmn83
   LET g_pmn[l_ac].pmn84 = l_pmn84
   #LET g_pmn[l_ac].pmn85 = l_pmn85
   LET g_pmn[l_ac].pmn86 = l_pmn86
   #LET g_pmn[l_ac].pmn87 = l_pmn87
   
END FUNCTION 
#TQC-C30109---end    

#DEV-D30045--mark--begin
##條碼產生函式
##DEV-D30026---add--begin-------------
#FUNCTION t540_barcode_gen()
#   DEFINE l_count   LIKE type_file.num5
#   DEFINE l_pmn02   LIKE pmn_file.pmn02
#   DEFINE l_pmn04   LIKE pmn_file.pmn04
#   DEFINE l_pmn20   LIKE pmn_file.pmn20
#   DEFINE l_ima931  LIKE ima_file.ima931
#   DEFINE l_ima933  LIKE ima_file.ima933
#   DEFINE l_ima918  LIKE ima_file.ima918
#   DEFINE l_ima919  LIKE ima_file.ima919
#   DEFINE l_ima920  LIKE ima_file.ima920
#   DEFINE l_ima921  LIKE ima_file.ima921
#   DEFINE l_ima922  LIKE ima_file.ima922
#   DEFINE l_ima923  LIKE ima_file.ima923
#   DEFINE l_sql     STRING
#   DEFINE l_n       LIKE type_file.num5
#   DEFINE l_cnt     LIKE type_file.num5 
#   DEFINE l_ima930  LIKE ima_file.ima930  
#
#   LET l_n = 0
#
#   IF cl_null(g_pmm.pmm01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#   SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pmm.pmm01
#
#   IF g_pmm.pmm18 = 'N' THEN
#      CALL cl_err('','sfb-999',0)
#      RETURN
#   END IF
#
#   IF g_pmm.pmm18 = 'X' THEN
#      CALL cl_err('','sfb-998',0)
#      RETURN
#   END IF
#
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt
#     FROM tlfb_file
#    WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file
#                      WHERE ibb03 = g_pmm.pmm01)
#   IF l_cnt >=1 THEN
#      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
#      CALL cl_err(g_pmm.pmm01,'aba-127',1)
#      RETURN
#   END IF
#
#   LET g_success = 'Y'
#   BEGIN WORK
#   CALL s_showmsg_init()
#
#   OPEN t540_cl USING g_pmm.pmm01
#   IF STATUS THEN
#      CALL cl_err("OPEN t540_cl:", STATUS, 1)
#      CLOSE t540_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH t540_cl INTO g_pmm.*               # 對DB鎖定
#
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,1)  #MOD-640492 0->1
#      CLOSE t540_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#  IF g_prog[1,7] = "apmt540" THEN
#     SELECT count(*) INTO l_count FROM ibb_file WHERE ibb02 = 'F' AND ibb03 = g_pmm.pmm01
#     IF l_count > 0 THEN
#        IF NOT cl_confirm('sfb-995') THEN
#           ROLLBACK WORK 
#           RETURN
#        END IF
#        DELETE FROM iba_file WHERE iba01 IN (SELECT ibb01 FROM ibb_file
#                                           WHERE ibb02 = 'F'
#                                             AND ibb03 = g_pmm.pmm01)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","iba_file",g_pmm.pmm01,'',SQLCA.sqlcode,"","",1)
#           LET g_success = 'N' 
#           ROLLBACK WORK      
#           RETURN
#        END IF
#        DELETE FROM ibb_file WHERE ibb02 = 'F' AND ibb03 = g_pmm.pmm01
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","ibb_file",g_pmm.pmm01,'',SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#           ROLLBACK WORK     
#           RETURN
#        END IF
#     END IF
#  END IF
#
#  IF g_prog[1,7] = "apmt590" THEN
#     SELECT count(*) INTO l_count FROM ibb_file WHERE ibb02 = 'G' AND ibb03 = g_pmm.pmm01
#     IF l_count > 0 THEN
#        IF NOT cl_confirm('sfb-995') THEN
#           ROLLBACK WORK
#           RETURN
#        END IF
#        DELETE FROM iba_file WHERE iba01 IN (SELECT ibb01 FROM ibb_file
#                                           WHERE ibb02 = 'G'
#                                             AND ibb03 = g_pmm.pmm01)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","iba_file",g_pmm.pmm01,'',SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#           ROLLBACK WORK     
#           RETURN
#        END IF
#        DELETE FROM ibb_file WHERE ibb02 = 'G' AND ibb03 = g_pmm.pmm01
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","ibb_file",g_pmm.pmm01,'',SQLCA.sqlcode,"","",1)
#           LET g_success = 'N' 
#           ROLLBACK WORK       
#           RETURN
#        END IF
#     END IF
#  END IF
#
#  IF g_prog[1,7] = "apmt540" THEN
#     LET l_sql = "SELECT pmn02,pmn04,pmn20,ima931,ima933,ima918,ima919,ima920,ima921,ima922,ima923",
#                 "  FROM pmn_file,ima_file WHERE pmn01 = '",g_pmm.pmm01,"' ",
#                 "   AND pmn04 = ima01 ",
#                 "   AND ima930 = 'Y' ",
#                 "   AND ima932 = 'F' ",
#                 " ORDER BY pmn02 "
#  END IF
#  IF g_prog[1,7] = "apmt590" THEN
#     LET l_sql = "SELECT pmn02,pmn04,pmn20,ima931,ima933,ima918,ima919,ima920,ima921,ima922,ima923",
#                 "  FROM pmn_file,ima_file WHERE pmn01 = '",g_pmm.pmm01,"' ",
#                 "   AND pmn04 = ima01 ",
#                 "   AND ima930 = 'Y' ",
#                 "   AND ima932 = 'G' ",
#                 " ORDER BY pmn02 "
#  END IF
#   PREPARE pmn_prep FROM l_sql
#   DECLARE pmn_cs CURSOR FOR pmn_prep
#
#   FOREACH pmn_cs INTO l_pmn02,l_pmn04,l_pmn20,l_ima931,l_ima933,l_ima918,l_ima919,l_ima920,l_ima921,l_ima922,l_ima923
#      IF STATUS THEN
#         CALL cl_err('FOREACH:',STATUS,0) EXIT FOREACH
#      END IF
#
#      IF cl_null(l_pmn20) THEN
#         LET l_pmn20 = 0
#      END IF
#
#     #DEV-D30026 mark---str---
#     #第一階段因不支援批/序號管理,
#     #產生料件批號條碼規則固定,固定為'A'+料號
#     #不CALL產生條碼的共用副程式
#     #IF l_ima918 = 'Y' AND l_ima919 = 'Y' THEN
#     #   LET l_n = l_n + 1
#     #   IF g_prog[1,7] = "apmt540" THEN
#     #      CALL s_gen_barcode('1','F',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #   IF g_prog[1,7] = "apmt590" THEN
#     #      CALL s_gen_barcode('1','G',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #END IF
#
#     #IF l_ima921 = 'Y' AND l_ima922 = 'Y' THEN
#     #   LET l_n = l_n + 1
#     #   IF g_prog[1,7] = "apmt540" THEN
#     #      CALL s_gen_barcode('2','F',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #   IF g_prog[1,7] = "apmt590" THEN
#     #      CALL s_gen_barcode('2','G',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #END IF
#
#     #IF l_ima931 = 'Y' THEN
#     #   LET l_n = l_n + 1
#     #   IF g_prog[1,7] = "apmt540" THEN
#     #      CALL s_gen_barcode('3','F',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #   IF g_prog[1,7] = "apmt590" THEN
#     #      CALL s_gen_barcode('3','G',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#     #   END IF
#     #END IF
#     #DEV-D30026 mark---end---
#      LET l_n = l_n + 1
#      SELECT ima930 INTO l_ima930 FROM ima_file WHERE ima01 = l_pmn04
#      IF l_ima930 = 'Y' THEN
#         IF g_prog[1,7] = "apmt540" THEN
#            CALL t540_ins_barcode('F',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#         END IF
#         IF g_prog[1,7] = "apmt590" THEN
#            CALL t540_ins_barcode('G',g_pmm.pmm01,l_pmn02,l_pmn04,l_pmn20)
#         END IF
#      END IF
#      IF g_success = 'N' THEN
#          EXIT FOREACH
#      END IF
#   END FOREACH
#   IF l_n = 0 THEN
#      CALL cl_err('','mfg-100',1) 
#      LET g_success = 'N' 
#   END IF
#
#   CALL s_showmsg()
#   IF g_success='Y' THEN
#      CALL cl_msgany(0,0,'aba-001')
#      COMMIT WORK
#   ELSE
#      CALL cl_msgany(0,0,'aba-002')
#      COMMIT WORK
#      ROLLBACK WORK
#   END IF
#END FUNCTION   
#
#FUNCTION t540_ins_barcode(l_p1,l_p2,l_p3,l_p4,l_p5)
#  #                 p1:F:採購單(apmt540)
#  #                    G:委外採購單(apmt590)
#  #                 p2:來源單號
#  #                 p3:來源項次
#  #                 p4:料號
#  #                 p5:數量
#   DEFINE l_iba      RECORD LIKE iba_file.*
#   DEFINE l_ibb      RECORD LIKE ibb_file.*
#   DEFINE l_p1       LIKE type_file.chr1  #條碼產生時機點:F:採購單(apmt540)/G:委外採購單(apmt590)
#   DEFINE l_p2       LIKE ibb_file.ibb03  #來源單號
#   DEFINE l_p3       LIKE ibb_file.ibb04  #來源項次
#   DEFINE l_p4       LIKE ima_file.ima01  #料號
#   DEFINE l_p5       LIKE ibb_file.ibb07  #數量
#   DEFINE l_cnt      LIKE type_file.num5  
#
#       LET l_iba.iba01 = 'A',l_p4  #條碼編號:A+料號
#       LET l_iba.iba02 = 'A'       #條碼類型:A:條碼批號-料號
#       LET l_iba.iba03 = l_p4      #條碼組成2:料號
#
#       LET l_cnt = 0
#       SELECT COUNT(*) INTO l_cnt
#         FROM iba_file
#        WHERE iba01 = l_iba.iba01
#       IF NOT(l_cnt > 0 AND l_iba.iba02 MATCHES '[5ABC]') THEN
#          INSERT INTO iba_file VALUES(l_iba.*)
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
#              LET g_success='N'
#              RETURN
#          END IF
#       END IF 
#
#       LET l_ibb.ibb01 = l_iba.iba01 #條碼編號
#       LET l_ibb.ibb02 = l_p1        #
#       LET l_ibb.ibb03 = l_p2        #來源單號
#       LET l_ibb.ibb04 = l_p3        #來源項次
#       LET l_ibb.ibb05 = 0           #包號
#       LET l_ibb.ibb06 = l_p4        #料號
#       LET l_ibb.ibb07 = l_p5        #數量
#       LET l_ibb.ibb08 = NULL
#       LET l_ibb.ibb09 = NULL
#       LET l_ibb.ibb10 = 0           #總包數
#       LET l_ibb.ibb11 = 'Y'             
#       LET l_ibb.ibb12 = 0               
#       LET l_ibb.ibbacti = 'Y'             
#       INSERT INTO ibb_file VALUES(l_ibb.*)
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#       END IF
#END FUNCTION
##DEV-D30026---add--end--
#DEV-D30045--mark--end


#DEV-D30045--add--begin
FUNCTION t540_barcode_out()
   DEFINE l_cmd       STRING

   IF g_pmm.pmm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_cmd = ''

   CASE
      WHEN g_prog[1,7] = "apmt540"
         LET g_msg=' ibb03="',g_pmm.pmm01 CLIPPED,'"'
         LET l_cmd = "abar100",
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '' '1'",
             " '' '' '' '' ",
             " '",g_msg CLIPPED,"' ",
             " ' ' 'F' '",s_gen_barcode_ibd07(),"'"
      WHEN g_prog[1,7] = "apmt590"
         LET g_msg=' ibb03="',g_pmm.pmm01 CLIPPED,'"'
         LET l_cmd = "abar100",
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '' '1'",
             " '' '' '' '' ",
             " '",g_msg CLIPPED,"' ",
             " ' ' 'G' '",s_gen_barcode_ibd07(),"'"
   END CASE

   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
#DEV-D30045--add--end

#darcy:2024/09/02 add s---
function sapmt540_change_pmn35(p_pmm01,p_pmn02)
   define p_pmm01 like pmm_file.pmm01
   define p_pmn02 like pmn_file.pmn02
   define l_pmn35 like pmn_file.pmn35

   if cl_null(p_pmm01) then
      return
   end if
   if cl_null(p_pmn02) then
      return
   end if
   select pmn16 into l_pmn16 from pmn_file where pmn01 = p_pmm01 and pmn02 = p_pmn02
   if sqlca.sqlcode or cl_null(l_pmn16) then
      call cl_err("单身无此笔资料","!",1)
      return
   end if 
   if l_pmn16 matches '[678S]' then
      call cl_err("此笔资料已结案，不允许修改","!",1)
      return
   end if

   while true
      prompt "请输入新的到库日期" for l_pmn35

      if int_flag then
         display "取消修改"
         exit while
      else
         if cl_null(l_pmn35) then
            call cl_err('日期不可为空',"!",1)
            continue while
         else
            update pmn_file set pmn35 = l_pmn35
             where pmn01 = p_pmm01 and pmn02 = p_pmn02
            if sqlca.sqlcode then
               call cl_err("upd pmn_file",sqlca.sqlcode,1)
               return
            end if
         end if
      end if
   end while
   
end function
#darcy:2024/09/02 add e---
