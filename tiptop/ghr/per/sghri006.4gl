# Prog. Version..: '5.30.03-13.04.08(00010)'     #
#
# Pattern name...: ghri006.4gl
# Descriptions...: 人员信息维护作业
# Date & Author..: 13/04/08 By yougs  
# MODIFY.........:by zhuzw 20140627 增加编制内审核处理逻辑
DATABASE ds                                               #建立與資料庫的連線


 
GLOBALS "../../config/top.global"                         #存放的為TIPTOP GP系統整體全域變數定義  
 
DEFINE g_hrat                 RECORD LIKE hrat_file.*
DEFINE g_hrat_t               RECORD LIKE hrat_file.*     #備份舊值
DEFINE g_hrag                 RECORD LIKE hrag_file.*
DEFINE g_hrat01_t             LIKE hrat_file.hrat01       #Key值備份
DEFINE g_wc                   STRING                      #儲存 user 的查詢條件  
DEFINE g_sql                  STRING                      #組 sql 用 
DEFINE g_forupd_sql           STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done    LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                  LIKE hrat_file.hratacti
DEFINE g_cnt                  LIKE type_file.num10       
DEFINE g_i                    LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                  STRING
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10        #總筆數     
DEFINE g_jump                 LIKE type_file.num10        #查詢指定的筆數
DEFINE l_master               LIKE type_file.num5         #部门主管人数 
DEFINE g_no_ask               LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_flag                 LIKE type_file.chr1         #员工自动编号返回的一个值，判断是否可以手工修改
DEFINE g_hrat78               LIKE hraq_file.hraq02       #职称类别
DEFINE g_hrat79               LIKE hrag_file.hrag07       #职称级别
DEFINE g_hraqa04              LIKE hraqa_file.hraqa02     #职称等级代码
DEFINE g_hraqa03              LIKE hraqa_file.hraqa03
DEFINE g_hrat75_name          VARCHAR(20)                 #招聘负责人名字       
DEFINE g_hrar02               LIKE hras_file.hras03       #职务分类编码
DEFINE g_hrat05_name          LIKE hrap_file.hrap06       #主职位名称
DEFINE g_hrat05_name1         LIKE hrag_file.hrag07       #职务类别
DEFINE g_chr2                 LIKE type_file.chr2
DEFINE l_hrag07               LIKE hrag_file.hrag07
DEFINE g_hras06               LIKE hras_file.hras06
DEFINE g_hrbf           RECORD LIKE hrbf_file.*
 
FUNCTION sghri006()
   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   INITIALIZE g_hrat.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hrat_file WHERE hratid = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i006_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET g_action_choice = ""
   CALL i006_menu()                                         #進入選單 Menu
 
END FUNCTION
 

FUNCTION i006_curs()
    CLEAR FORM
    INITIALIZE g_hrat.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrat03,hrat04,hrat72,hrat05,hrat01,hrat02,hrat10,hrat41,hrat40,
        hrat68,hrat06,hrat19,hrat20,hrat21,hrat25,hrat66,hrat26,hrat08,
        hrat58,hrat42,hrat43,hrat12,hrat13,hrat14,hrat15,hrat16,hrat17,
        hrat76,hrat18,hrat46,hrat45,hrat30,hrat24,hrat28,hrat29,hrat22,
        hrat23,hrat34,hrat07,hrat09,hrat11,hratconf,hrat49,hrat50,hrat51,
        hrat47,hrat48,hrat36,hrat69,hrat44,hrat75,hrat73,hrat38,hrat39,
        hrat37,hrat35,hrat70,hrat52,hrat71,hrat67,hrat78,hrat79,hrat74,
        hrat54,hrat53,hrat33,hrat55,hrat57,hrat56,hrat59,hrat60,hrat62,
        hrat61,hrat65,hratuser,hratgrup,hratoriu,hratorig,hratmodu,hratacti,
        hratdate         #modify by hourf 2013/6/27
#        hrat03,hrat04,hrat05,hrat06,hrat08,hrat01,hrat02,hrat10,hrat12,
#        hrat13,hrat15,hrat16,hrat17,hrat19,hrat20,hrat22,hrat23,hrat28,
#        hrat29,hratconf,hrat64,hrat26,hrat07,hrat18,hrat66,hrat09,hrat21,
#        hrat25,hrat11,hrat24,hrat14,hrat27,hrat30,hrat34,hrat44,hrat35,
#        hrat37,hrat47,hrat38,hrat40,hrat50,hrat36,hrat43,hrat39,hrat54,
#        hrat46,hrat42,hrat53,hrat49,hrat45,hrat33,hrat52,hrat48,hrat41,
#        hrat51,hrat55,hrat56,hrat57,hrat59,hrat58,hrat60,hrat61,hrat62,
#        hrat63,hrat65,hratuser,hratgrup,hratoriu,hratorig,hratmodu,hratdate,hratacti


        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05     
              WHEN INFIELD(hrat06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
               # LET g_qryparam.where = "hrat07 = 'Y' "
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat06
                 NEXT FIELD hrat06   
              WHEN INFIELD(hrat40)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form = "q_hraf01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat40
                 NEXT FIELD hrat40                  
              WHEN INFIELD(hrat42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrai031"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat42
                 NEXT FIELD hrat42     
              WHEN INFIELD(hrat52)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat52
                 NEXT FIELD hrat52     
#              WHEN INFIELD(hrat64)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_hrar06"
#                 LET g_qryparam.state = "c" 
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat64
#                 NEXT FIELD hrat64                  
              WHEN INFIELD(hrat12)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '314'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat12
                 NEXT FIELD hrat12
              WHEN INFIELD(hrat17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17
                 NEXT FIELD hrat17
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19                 
              WHEN INFIELD(hrat20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20
                 NEXT FIELD hrat20
              WHEN INFIELD(hrat21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '337'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat21
                 NEXT FIELD hrat21
              WHEN INFIELD(hrat73)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '341'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat73
                 NEXT FIELD hrat73
              WHEN INFIELD(hrat78)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraq01"
                  LET g_qryparam.default1 = g_hrat.hrat78
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrat78
                  NEXT FIELD hrat78
              WHEN INFIELD(hrat79)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '206'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.default1 = g_hrat.hrat79
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat79
                 NEXT FIELD hrat79
              WHEN INFIELD(hrat66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '326'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat66
                 NEXT FIELD hrat66
               WHEN INFIELD(hrat68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat68
                 NEXT FIELD hrat68
               WHEN INFIELD(hrat67)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraqa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat67
                 NEXT FIELD hrat67
              WHEN INFIELD(hrat22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat22
                 NEXT FIELD hrat22
              WHEN INFIELD(hrat24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '334'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat24
                 NEXT FIELD hrat24
              WHEN INFIELD(hrat28)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '302'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat28
                 NEXT FIELD hrat28
              WHEN INFIELD(hrat29)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '301'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat29
                 NEXT FIELD hrat29
              WHEN INFIELD(hrat30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '321'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat30
                 NEXT FIELD hrat30
              WHEN INFIELD(hrat34)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '320'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat34
                 NEXT FIELD hrat34
              WHEN INFIELD(hrat75)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat75
                 NEXT FIELD hrat75
              WHEN INFIELD(hrat41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '325'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat41
                 NEXT FIELD hrat41
              WHEN INFIELD(hrat43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '319'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat43
                 NEXT FIELD hrat43 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()   
          
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()
        

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    #LET g_sql = "SELECT hrat01 FROM hrat_file ",                       #組合出 SQL 指令
    #            " WHERE ",g_wc CLIPPED, " ORDER BY hrat01"
    LET g_sql = "SELECT hratid FROM hrat_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hratid"
    PREPARE i006_prepare FROM g_sql
    DECLARE i006_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i006_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrat_file WHERE ",g_wc CLIPPED
    PREPARE i006_precount FROM g_sql
    DECLARE i006_count CURSOR FOR i006_precount
END FUNCTION
 

FUNCTION i006_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i006_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i006_q()
            END IF

        ON ACTION previous
            CALL i006_fetch('P')

        ON ACTION next
            CALL i006_fetch('N')

        ON ACTION jump
            CALL i006_fetch('/')

        ON ACTION first
            CALL i006_fetch('F')

        ON ACTION last
            CALL i006_fetch('L')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i006_u('u')
            END IF 

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i006_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i006_copy()
            END IF

        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i006_confirm('Y')
               CALL i006_show()                   # 重新顯示
            END IF
  
        ON ACTION unconfirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i006_confirm('N')
               CALL i006_show()                   # 重新顯示
            END IF 
            
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i006_x()
            END IF  

        ON ACTION ghri006_a 
            LET g_action_choice="ghri006_a"
            IF cl_chk_act_auth() THEN
               CALL ghri006_a(g_hrat.hratid) #工作简历
            END IF 
        ON ACTION ghri006_b 
            LET g_action_choice="ghri006_b"
            IF cl_chk_act_auth() THEN
               CALL ghri006_b(g_hrat.hratid) #培训经历
            END IF        
        ON ACTION ghri006_c 
            LET g_action_choice="ghri006_c"
            IF cl_chk_act_auth() THEN
               CALL ghri006_c(g_hrat.hratid) #教育背景
            END IF 
        ON ACTION ghri006_d 
            LET g_action_choice="ghri006_d"
            IF cl_chk_act_auth() THEN
               CALL ghri006_d(g_hrat.hratid)  
            END IF  
        ON ACTION ghri006_e 
            LET g_action_choice="ghri006_e"
            IF cl_chk_act_auth() THEN
               CALL ghri006_e(g_hrat.hratid) #语言状况
            END IF 
        ON ACTION ghri006_f 
            LET g_action_choice="ghri006_f"
            IF cl_chk_act_auth() THEN
               CALL ghri006_f(g_hrat.hratid)
            END IF  
        ON ACTION ghri006_g 
            LET g_action_choice="ghri006_g"
            IF cl_chk_act_auth() THEN
               CALL ghri006_g(g_hrat.hratid)
            END IF 
        ON ACTION ghri006_h 
            LET g_action_choice="ghri006_h"
            IF cl_chk_act_auth() THEN
               CALL ghri006_h(g_hrat.hratid)
            END IF 
     #   ON ACTION ghri006_i 
     #       LET g_action_choice="ghri006_i"
     #       IF cl_chk_act_auth() THEN
     #          CALL ghri006_i(g_hrat.hratid)  #兵役状况
     #       END IF                                          
    
   ON ACTION ghri006_j
       CALL i0221_assign()

        ON ACTION ghri006_k 
            LET g_action_choice="ghri006_k"
            IF cl_chk_act_auth() THEN
               CALL i006_read()  #读取身份证
            END IF                                          
    
        ON ACTION ghri006_l 
            LET g_action_choice="ghri006_l"
            IF cl_chk_act_auth() THEN
               CALL i006_write()  #记录身份证
            END IF                                          
    
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about      
           CALL cl_about() 
   
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrat.hrat01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrat01"
                 LET g_doc.value1 = g_hrat.hrat01
                 CALL cl_doc()
              END IF
           END IF
        ON ACTION ghr_import
            LET g_action_choice="import"
            IF cl_chk_act_auth() THEN
                 CALL i006_import()
            END IF
         &include "qry_string.4gl"
    END MENU
    CLOSE i006_cs
END FUNCTION
 
 
FUNCTION i006_a()
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrag07  LIKE hrag_file.hrag07
DEFINE l_hrat08  LIKE type_file.num10  
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrat.* LIKE hrat_file.*
    LET g_hrat01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i006_logic_default('A',g_hrat.*) RETURNING g_hrat.*

        CALL i006_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrat.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrat.hrat01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF  
        CALL i006_logic_default('B',g_hrat.*) RETURNING g_hrat.*
        INSERT INTO hrat_file VALUES(g_hrat.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrat01 INTO g_hrat.hrat01 FROM hrat_file WHERE hrat01 = g_hrat.hrat01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

 
FUNCTION i006_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hraa02      LIKE hraa_file.hraa02
   DEFINE l_hraa03      LIKE hraa_file.hraa03
   DEFINE l_hraa04      LIKE hraa_file.hraa04
   DEFINE l_gem02       LIKE gem_file.gem02 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_hrag07      LIKE hrag_file.hrag07
   DEFINE l_count        LIKE type_file.num5
   DEFINE l_year        LIKE type_file.num5
   DEFINE l_month       LIKE type_file.num5
   DEFINE l_day         LIKE type_file.num5
   DEFINE l_mod         LIKE type_file.num5
   DEFINE l_hrat13_18   LIKE type_file.chr1
   DEFINE l_length      LIKE type_file.num5 
   DEFINE l_hrat16      LIKE type_file.num5
   DEFINE l_hrat13_1    LIKE type_file.num5
   DEFINE l_hrat13_2    LIKE type_file.num5
   DEFINE l_hrat13_3    LIKE type_file.num5
   DEFINE l_hrat13_4    LIKE type_file.num5
   DEFINE l_hrat13_5    LIKE type_file.num5
   DEFINE l_hrat13_6    LIKE type_file.num5
   DEFINE l_hrat13_7    LIKE type_file.num5
   DEFINE l_hrat13_8    LIKE type_file.num5
   DEFINE l_hrat13_9    LIKE type_file.num5
   DEFINE l_hrat13_10   LIKE type_file.num5
   DEFINE l_hrat13_11   LIKE type_file.num5
   DEFINE l_hrat13_12   LIKE type_file.num5
   DEFINE l_hrat13_13   LIKE type_file.num5
   DEFINE l_hrat13_14   LIKE type_file.num5
   DEFINE l_hrat13_15   LIKE type_file.num5
   DEFINE l_hrat13_16   LIKE type_file.num5
   DEFINE l_hrat13_17   LIKE type_file.num5
   DEFINE l_hraa10      LIKE hraa_file.hraa10
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_s           LIKE type_file.num5 
   DEFINE l_hrao02      LIKE hrao_file.hrao02
   DEFINE l_hrat01      LIKE hrat_file.hrat01
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hraw01      LIKE hraw_file.hraw01
   DEFINE l_sr          STRING
   DEFINE l_hran05      LIKE hran_file.hran05
   DEFINE l_hran06      LIKE hran_file.hran06
 
#   DISPLAY BY NAME g_hrat.hrat03,g_hrat.hrat04,g_hrat.hratconf,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat07,
#   g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat09,g_hrat.hrat10,g_hrat.hrat11,g_hrat.hrat12,
#   g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat18,g_hrat.hrat19,
#   g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat24,g_hrat.hrat25,g_hrat.hrat26,
#   g_hrat.hrat27,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat30,g_hrat.hrat64,g_hrat.hrat66,g_hrat.hrat33,g_hrat.hrat53,
#   g_hrat.hrat54,g_hrat.hrat34,g_hrat.hrat35,g_hrat.hrat36,g_hrat.hrat37,g_hrat.hrat38,g_hrat.hrat39,
#   g_hrat.hrat40,g_hrat.hrat41,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat45,g_hrat.hrat46,
#   g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,g_hrat.hrat52,g_hrat.hrat55,
#   g_hrat.hrat56,g_hrat.hrat57,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat61,g_hrat.hrat62,
#   g_hrat.hrat63,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,
#   g_hrat.hratmodu,g_hrat.hratdate,g_hrat.hratacti 
        DISPLAY BY NAME
         g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat72,g_hrat.hrat05,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat41,g_hrat.hrat40,
         g_hrat.hrat68,g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,g_hrat.hrat08,
         g_hrat.hrat58,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,
         g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,
         g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,
         g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat44,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,g_hrat.hrat39,
         g_hrat.hrat37,g_hrat.hrat35,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,
         g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,
         g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,
         g_hrat.hratdate
#        g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat41,g_hrat.hrat40,g_hrat.hrat68,g_hrat.hrat05,
#        g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,
#        g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,
#        g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,
#        g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,
#        g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,
#        g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat51,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat75,
#        g_hrat.hrat73,g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat42,g_hrat.hrat35,
#        g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat72,g_hrat.hrat54,g_hrat.hrat53,
#        g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
#        g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,
#        g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,g_hrat.hratdate                               #modify by hourf 2013/6/27
   
   CALL s_code('302',g_hrat.hrat28) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO g_hrat.hrat28_name
   CALL s_code('301',g_hrat.hrat29) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat29_name
   CALL s_code('340',g_hrat.hrat68) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat68_name
 
#   INPUT BY NAME {g_hrat.hrat03,g_hrat.hrat04,g_hrat.hratconf,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat07,
#   g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat09,g_hrat.hrat10,g_hrat.hrat11,g_hrat.hrat12,
#   g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat18,g_hrat.hrat19,
#   g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat24,g_hrat.hrat25,g_hrat.hrat26,
#   g_hrat.hrat27,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat30,g_hrat.hrat64,g_hrat.hrat33,g_hrat.hrat53,
#   g_hrat.hrat54,g_hrat.hrat34,g_hrat.hrat35,g_hrat.hrat36,g_hrat.hrat37,g_hrat.hrat38,g_hrat.hrat39,
#   g_hrat.hrat40,g_hrat.hrat41,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat45,g_hrat.hrat46,
#   g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,g_hrat.hrat52,g_hrat.hrat55,
#   g_hrat.hrat56,g_hrat.hrat57,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat61,g_hrat.hrat62,
#   g_hrat.hrat63,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,
#   g_hrat.hratmodu,g_hrat.hratdate,g_hrat.hratacti}
#        g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat12,
#        g_hrat.hrat13,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat28,
#        g_hrat.hrat29,g_hrat.hratconf,g_hrat.hrat64,g_hrat.hrat26,g_hrat.hrat07,g_hrat.hrat18,g_hrat.hrat66,g_hrat.hrat09,g_hrat.hrat21,
#        g_hrat.hrat25,g_hrat.hrat11,g_hrat.hrat24,g_hrat.hrat14,g_hrat.hrat27,g_hrat.hrat30,g_hrat.hrat34,g_hrat.hrat44,g_hrat.hrat35,
#        g_hrat.hrat37,g_hrat.hrat47,g_hrat.hrat38,g_hrat.hrat40,g_hrat.hrat50,g_hrat.hrat36,g_hrat.hrat43,g_hrat.hrat39,g_hrat.hrat54,
#        g_hrat.hrat46,g_hrat.hrat42,g_hrat.hrat53,g_hrat.hrat49,g_hrat.hrat45,g_hrat.hrat33,g_hrat.hrat52,g_hrat.hrat48,g_hrat.hrat41,
#        g_hrat.hrat51,g_hrat.hrat55,g_hrat.hrat56,g_hrat.hrat57,g_hrat.hrat59,g_hrat.hrat58,g_hrat.hrat60,g_hrat.hrat61,g_hrat.hrat62,
#        g_hrat.hrat63,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratdate,g_hrat.hratacti  
#      WITHOUT DEFAULTS
      INPUT BY NAME
         g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat72,g_hrat.hrat05,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat41,g_hrat.hrat40,
         g_hrat.hrat68,g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,g_hrat.hrat08,
         g_hrat.hrat58,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,
         g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,
         g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,
         g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat44,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,g_hrat.hrat39,
         g_hrat.hrat37,g_hrat.hrat35,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,
         g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,
         g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,
         g_hrat.hratdate
#        g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat41,g_hrat.hrat40,g_hrat.hrat68,g_hrat.hrat05,
#        g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,
#        g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,
#        g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,
#        g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,
#        g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hrat49,
#        g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat51,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat75,
#        g_hrat.hrat73,g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat42,g_hrat.hrat35,
#        g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat72,g_hrat.hrat54,g_hrat.hrat53,
#        g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
#        g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,
#        g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,g_hrat.hratdate                               #modify by hourf 2013/6/27
      WITHOUT DEFAULTS
   
         
 
      BEFORE INPUT 
          LET g_before_input_done = FALSE
          LET g_hrat.hratconf='N'
          LET g_hrat.hrat07='N'
          LET g_hrat.hrat09='Y'
          LET g_hrat.hrat11='N'
          LET g_hrat.hrat54='N'
          LET g_hrat.hrat53='N'
          LET g_hrat.hrat33='N'
          CALL i006_set_entry(p_cmd)
          CALL i006_set_no_entry(p_cmd)         
          LET g_before_input_done = TRUE 
          CALL cl_set_comp_entry("hrat15,hrat17,hrat18 ",TRUE)
          CALL cl_set_comp_entry("hrat13",FALSE)
          CALL cl_set_comp_required("hrat13,hrat66",FALSE)   
             
      AFTER FIELD hrat03
         IF NOT cl_null(g_hrat.hrat03) THEN 
            CALL i006_logic_chk_hrat03(g_hrat.*) RETURNING g_hrat.*
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_hrat.hrat03,g_errno,0)
               NEXT FIELD hrat03
            ELSE
               #add by yougs130425 begin
               IF NOT cl_null(g_hrat.hrat03) THEN
                  IF g_hrat_t.hrat03 IS NULL THEN
                     LET l_hraa10 = ''
                     SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
                     LET g_flag = 'Y'
                     CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING g_hrat.hrat01,g_flag
                     DISPLAY g_hrat.hrat01 TO hrat01
                     IF g_flag = 'Y' THEN
                        CALL cl_set_comp_entry("hrat01",TRUE)
                     ELSE
                        CALL cl_set_comp_entry("hrat01",FALSE)
                     END IF
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
               IF g_hrat.hrat21='001' THEN 
               SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran05) THEN 
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
                  END IF 
               END IF  
               IF g_hrat.hrat21='002' THEN 
                  SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
                  IF NOT cl_null(l_hran06) THEN 
                     Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
                     DISPLAY BY NAME g_hrat.hrat26
                  END IF 
               END IF
            END IF 
         END IF 
 
     BEFORE FIELD hrat04
         IF cl_null(g_hrat.hrat03) THEN
            CALL cl_err("在录入部门之前请先录入公司编号，谢谢",'!',0)
            NEXT FIELD hrat03
         END IF
         
     AFTER FIELD hrat04
       IF NOT cl_null(g_hrat.hrat04) THEN 
         CALL i006_logic_chk_hrat04(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN 
              CALL cl_err(g_hrat.hrat04,g_errno,1)
              LET g_hrat.hrat04 = ''
              LET g_hrat.hrat05 = ''
              NEXT FIELD hrat04
         END IF 
       END IF 
       
     BEFORE FIELD hrat05
         IF cl_null(g_hrat.hrat04) THEN
            CALL cl_err("在录入职位之前请先录入部门编号，谢谢",'!',0)
            NEXT FIELD hrat04
         END IF
         
     AFTER FIELD hrat05
      IF NOT cl_null(g_hrat.hrat05) THEN 
         SELECT hrap07 INTO g_hrat.hrat07 FROM hrap_file WHERE hrap01=g_hrat.hrat04 AND hrap05=g_hrat.hrat05
         IF g_hrat.hrat07='Y' THEN 
            #校验
            SELECT COUNT(*) INTO l_master FROM hrat_file,hrad_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'
            IF l_master>0 AND g_hrat.hrat05 != g_hrat_t.hrat05  THEN 
               LET g_hrat.hrat07='N'
               LET g_hrat.hrat05=''
               CALL cl_err("部门主管已经存在",'!',1)
            END IF  
         END IF 
         DISPLAY g_hrat.hrat07 TO hrat07
         CALL i006_logic_chk_hrat05(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN 
            CALL cl_err(g_hrat.hrat05,g_errno,1)
                  LET g_hrat.hrat04 = ''
                  LET g_hrat.hrat05 = ''
            NEXT FIELD hrat05
         END IF 
      END IF 
      IF NOT cl_null(g_hrat.hrat05) THEN 
         SELECT hrap06 INTO g_hrat05_name FROM hrap_file WHERE hrap05=g_hrat.hrat05
         SELECT hras03 INTO g_hrar02 FROM hras_file  WHERE hras01=g_hrat.hrat05
         SELECT hrar04 INTO g_hrat05_name1 FROM hrar_file WHERE hrar03=g_hrar02 
         SELECT hras06 INTO g_hras06 FROM hras_file WHERE hras01=g_hrat.hrat05
         SELECT hrag07 INTO g_hrat.hrat64 FROM hrag_file WHERE hrag01='205' AND hrag06=g_hras06
      END IF          
      DISPLAY g_hrat05_name1 TO hrat05_name1
      DISPLAY BY NAME g_hrat.hrat64
      
      AFTER FIELD hrat01
          IF g_hrat.hrat01 IS NOT NULL THEN
             IF p_cmd = "a" OR (p_cmd = "u" AND g_hrat.hrat01 != g_hrat01_t) THEN # 若輸入或更改且改KEY
                 CALL i006_logic_chk_hrat01(g_hrat.*) RETURNING g_hrat.*
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_hrat.hrat01,-239,1)
                   LET g_hrat.hrat01 = g_hrat01_t
                   DISPLAY BY NAME g_hrat.hrat01
                   NEXT FIELD hrat01
                ELSE 
                
                END IF
             END IF   
          END IF                
     AFTER FIELD hrat40
#       IF NOT cl_null(g_hrat.hrat40) THEN 
#          CALL i006_logic_chk_hrat40(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#             CALL cl_err(g_hrat.hrat40,g_errno,1)
#             NEXT FIELD hrat40
#          ELSE 
#          
#          END IF  
#        END IF
     AFTER FIELD hrat68  
#      IF NOT cl_null(g_hrat.hrat68) THEN                                                #add by hourf  2013/06/28
#          CALL i006_logic_chk_hrat68(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#             CALL cl_err(g_hrat.hrat68,g_errno,1)
#             NEXT FIELD hrat68
#          ELSE 
#           
#          END IF 
#      END IF 
     AFTER FIELD hrat06
       IF NOT cl_null(g_hrat.hrat06) THEN 
          IF g_hrat.hrat06 = g_hrat.hrat01 THEN
             CALL cl_err('直接主管不能是自己','!',1)
#          CALL i006_logic_chk_hrat06(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#             CALL cl_err(g_hrat.hrat06,g_errno,1)
             NEXT FIELD hrat06
#          ELSE 
#          
          END IF  
       END IF 
      AFTER FIELD hrat19
#       IF NOT cl_null(g_hrat.hrat19) THEN 
#          CALL i006_logic_chk_hrat19(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#             CALL cl_err(g_hrat.hrat19,g_errno,1)
#             NEXT FIELD hrat19
#          ELSE 
#          
#          END IF  
#       END IF 
     AFTER FIELD hrat20
#        IF NOT cl_null(g_hrat.hrat20) THEN 
#          CALL i006_logic_chk_hrat20(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#             CALL cl_err(g_hrat.hrat20,g_errno,1)
#             NEXT FIELD hrat20
#          ELSE 
#          
#          END IF    
#        END IF   
     AFTER FIELD hrat21
      IF NOT cl_null(g_hrat.hrat21) THEN 
         CALL i006_logic_chk_hrat21(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN 
            CALL cl_err(g_hrat.hrat21,g_errno,1)
            NEXT FIELD hrat21
         ELSE 
         
         END IF  
         IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
            IF g_hrat.hrat21='001' THEN 
               SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran05) THEN 
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
               END IF 
            END IF  
            IF g_hrat.hrat21='002' THEN 
               SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran06) THEN 
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
               END IF 
            END IF
         END IF 
      END IF 
          
#      AFTER FIELD hrat25
#       IF NOT cl_null(g_hrat.hrat25) THEN 
#          CALL i006_logic_chk_hrat25(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN
#            CALL cl_err(g_hrat.hrat25,g_errno,0)
#            NEXT FIELD hrat25
##          ELSE                                          #modify by hourf  2013/07/02 
##             DISPLAY g_hrat.hrat66 TO hrat66
#          END IF 
#        END IF 
      AFTER FIELD hrat25
        IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
            LET g_hrat.hrat36 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat36
            LET g_hrat.hrat38 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat38
            LET g_hrat.hrat69 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat69
         IF g_hrat.hrat21='001' THEN 
            SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
            IF NOT cl_null(l_hran05) THEN 
               Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
               DISPLAY BY NAME g_hrat.hrat26
            END IF 
         END IF  
          IF g_hrat.hrat21='002' THEN 
            SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
            IF NOT cl_null(l_hran06) THEN 
               Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
               DISPLAY BY NAME g_hrat.hrat26
            END IF 
         END IF
        END IF 
         
      ON CHANGE hrat37
          LET g_hrat.hrat37 = cl_digcut(g_hrat.hrat37,1)
              
      ON CHANGE hrat39
          LET g_hrat.hrat39 = cl_digcut(g_hrat.hrat39,1) 
               
      AFTER FIELD hrat08
        IF NOT cl_null(g_hrat.hrat18) THEN 
          CALL i006_logic_chk_hrat08(g_hrat.*,g_hrat_t.hrat01) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat08,g_errno,0)
             NEXT FIELD hrat13
          ELSE 
          
          END IF 
        END IF 
      AFTER FIELD hrat15
        IF NOT cl_null(g_hrat.hrat15) THEN 
          CALL i006_logic_chk_hrat15(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat15,g_errno,0)
             NEXT FIELD hrat15
          ELSE 
             DISPLAY BY NAME g_hrat.hrat16
          END IF 
        END IF 
      AFTER FIELD hrat13
        IF NOT cl_null(g_hrat.hrat13) THEN 
           CALL i006_logic_chk_hrat13(g_hrat.*,g_hrat_t.hrat01) RETURNING g_hrat.*,l_hrag07
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err(g_hrat.hrat13,g_errno,0)
              NEXT FIELD hrat13
           ELSE 
               
             DISPLAY g_hrat.hrat15 TO hrat15             
             DISPLAY g_hrat.hrat16 TO hrat16             
             DISPLAY g_hrat.hrat17 TO hrat17 
             DISPLAY g_hrat.hrat18 TO hrat18          
             DISPLAY l_hrag07 TO hrat17_name 
          END IF 
       END IF 
     AFTER FIELD hrat42
       IF NOT cl_null(g_hrat.hrat42) THEN 
          CALL i006_logic_chk_hrat42(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat42,g_errno,1)
             NEXT FIELD hrat42
          ELSE 
          
          END IF   
       END IF 
     AFTER FIELD hrat52
       IF NOT cl_null(g_hrat.hrat52) THEN 
          CALL i006_logic_chk_hrat52(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat52,g_errno,1)
             NEXT FIELD hrat52
          ELSE 
          
          END IF
       END IF 
#     AFTER FIELD hrat64
#          CALL i006_logic_chk_hrat64(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN 
#            CALL cl_err(g_hrat.hrat64,g_errno,1)
#            NEXT FIELD hrat64
#          ELSE 
#          
#          END IF 
 
     AFTER FIELD hrat12
        IF NOT cl_null(g_hrat.hrat12) THEN 
          CALL i006_logic_chk_hrat12(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat12,g_errno,1)
             NEXT FIELD hrat12
          ELSE 
          CALL cl_set_comp_entry("hrat13",TRUE)
          END IF 
        END IF 
     AFTER FIELD hrat17
        IF NOT cl_null(g_hrat.hrat17) THEN 
          CALL i006_logic_chk_hrat17(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat17,g_errno,1)
             NEXT FIELD hrat17
          ELSE 
          
          END IF  
         END IF 
     AFTER FIELD hrat22
       IF NOT cl_null(g_hrat.hrat22) THEN 
          CALL i006_logic_chk_hrat22(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat22,g_errno,1)
             NEXT FIELD hrat22
          ELSE 
          
          END IF 
       END IF 
     AFTER FIELD hrat24
      IF NOT cl_null(g_hrat.hrat24) THEN 
          CALL i006_logic_chk_hrat24(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat24,g_errno,1)
             NEXT FIELD hrat24
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat28
      IF NOT cl_null(g_hrat.hrat28) THEN 
          CALL i006_logic_chk_hrat28(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat28,g_errno,1)
             NEXT FIELD hrat28
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat29
      IF NOT cl_null(g_hrat.hrat29) THEN 
          CALL i006_logic_chk_hrat29(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat29,g_errno,1)
             NEXT FIELD hrat29
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat30
      IF NOT cl_null(g_hrat.hrat30) THEN 
          CALL i006_logic_chk_hrat30(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat30,g_errno,1)
             NEXT FIELD hrat30
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat66
      IF NOT cl_null(g_hrat.hrat66) THEN 
          CALL i006_logic_chk_hrat66(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat66,g_errno,1)
             NEXT FIELD hrat66
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat67
       IF NOT cl_null(g_hrat.hrat67) THEN
         SELECT hraq01,hraqa02,hraqa04,hrag07,hraqa03 INTO g_hrat.hrat78,g_hrat78,g_hrat.hrat79,g_hrat79,g_hraqa04 FROM hraqa_file 
         LEFT JOIN hraq_file ON hraq01=hraqa02
         LEFT JOIN hrag_file ON hrag01='206' AND hrag06=hraqa04
         WHERE hraqa06=g_hrat.hrat67
         DISPLAY g_hraqa04,g_hrat.hrat78,g_hrat78,g_hrat.hrat79,g_hrat79,g_hraqa04 TO hraqa04,hrat78,hrat78_name,hrat79,hrat79_name,hraqa04
#          SELECT hraqa04 INTO g_hraqa04
#            FROM hraqa_file 
#           WHERE hraqa06=g_hrat.hrat67 
#           SELECT hraqa03 INTO g_hraqa03
#            FROM hraqa_file 
#           WHERE hraqa06=g_hrat.hrat67 
#          SELECT hraqa02 INTO g_hrat78 
#            FROM hraqa_file 
#           WHERE hraqa06=g_hrat.hrat67 
#          SELECT hrag07 INTO g_hrat79 
#            FROM hrag_file
#           WHERE hrag01='206'
#             AND hrag06=g_hraqa04
       END IF 
#       DISPLAY g_hraqa03,g_hrat78,g_hrat79 TO hraqa04,hraqa02,hrag07 
     AFTER FIELD hrat34
      IF NOT cl_null(g_hrat.hrat34) THEN 
          CALL i006_logic_chk_hrat34(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat34,g_errno,1)
             NEXT FIELD hrat34
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat41
       IF NOT cl_null(g_hrat.hrat41) THEN 
          CALL i006_logic_chk_hrat41(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat41,g_errno,1)
             NEXT FIELD hrat41
          ELSE 
          
          END IF 
       END IF 
     AFTER FIELD hrat43
      IF NOT cl_null(g_hrat.hrat43) THEN 
          CALL i006_logic_chk_hrat43(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat43,g_errno,1)
             NEXT FIELD hrat43
          ELSE 
          
          END IF  
      END IF 
     AFTER FIELD hrat73
      IF NOT cl_null(g_hrat.hrat73) THEN 
          CALL i006_logic_chk_hrat73(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN 
             CALL cl_err(g_hrat.hrat73,g_errno,1)
             NEXT FIELD hrat73
          ELSE 
          
          END IF 
      END IF 
     AFTER FIELD hrat75
          IF NOT cl_null(g_hrat.hrat75) THEN
             SELECT hrat02 INTO g_hrat75_name
               FROM hrat_file
              WHERE hrat01=g_hrat.hrat75
          END IF
          DISPLAY g_hrat75_name TO hrat75_name
     AFTER FIELD hrat76
          IF cl_null(g_hrat.hrat45) THEN
             LET g_hrat.hrat45=g_hrat.hrat76     #户口地址
          END IF
          IF cl_null(g_hrat.hrat46) THEN
             LET g_hrat.hrat46=g_hrat.hrat76     #现住地址
          END IF                                                                                                                                                                                                         
      AFTER INPUT
          LET g_hrat.hratuser = s_get_data_owner("hrat_file")  
          LET g_hrat.hratgrup = s_get_data_group("hrat_file")  
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
         LET l_s='0'
         LET l_sr=' '
         IF g_hrat.hrat01 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat01
            LET  l_sr = l_sr,"员工工号不能为空!\n"
#            NEXT FIELD hrat01
         END IF
         IF g_hrat.hrat02 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat02
            LET  l_sr = l_sr,"员工姓名不能为空!\n"
#            NEXT FIELD hrat02
         END IF
         IF g_hrat.hrat03 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat03
            LET  l_sr = l_sr,"所属公司不能为空!\n"
#            NEXT FIELD hrat03
         END IF
         IF g_hrat.hrat04 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat04
            LET  l_sr = l_sr,"所属部门不能为空!\n"
#            NEXT FIELD hrat04
         END IF
         IF g_hrat.hrat05 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat05
            LET  l_sr = l_sr,"担任职位不能为空!\n"
#            NEXT FIELD hrat05
         END IF
         IF g_hrat.hrat06 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat06
            LET  l_sr = l_sr,"直接主管不能为空!\n"
#            NEXT FIELD hrat06
         END IF
         IF g_hrat.hrat17 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat17
            LET  l_sr = l_sr,"性别不能为空!\n"
#            NEXT FIELD hrat17
         END IF
         IF g_hrat.hrat15 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat15
            LET  l_sr = l_sr,"出生日期不能为空!\n"
#            NEXT FIELD hrat15
         END IF
         IF g_hrat.hrat29 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat29
            LET  l_sr = l_sr,"民族不能为空!\n"
#            NEXT FIELD hrat29
         END IF
         IF g_hrat.hrat58 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat58
            LET  l_sr = l_sr,"用工类型不能为空!\n"
#            NEXT FIELD hrat58
         END IF
         IF g_hrat.hrat21 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat21
            LET  l_sr = l_sr,"人员类型不能为空!\n"
#            NEXT FIELD hrat21
         END IF
         IF g_hrat.hrat22 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat22
            LET  l_sr = l_sr,"学历不能为空!\n"
#            NEXT FIELD hrat22
         END IF
         IF g_hrat.hrat23 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat23
            LET  l_sr = l_sr,"主修专业不能为空!\n"
#            NEXT FIELD hrat23
         END IF
         IF g_hrat.hrat25 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat25
            LET  l_sr = l_sr,"入司时间不能为空!\n"
#            NEXT FIELD hrat25
         END IF
         IF g_hrat.hrat13 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat13
            LET  l_sr = l_sr,"证件号码不能为空!\n"
#            NEXT FIELD hrat13
         END IF
         IF g_hrat.hrat14 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat14
            LET  l_sr = l_sr,"证件到期日期不能为空!\n"
#            NEXT FIELD hrat14
         END IF
         IF g_hrat.hrat40 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat40
            LET  l_sr = l_sr,"工作城市不能为空!\n"
#            NEXT FIELD hrat40
         END IF
         IF g_hrat.hrat43 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat43
            LET  l_sr = l_sr,"招聘类型不能为空!\n"
#            NEXT FIELD hrat43
         END IF
         IF g_hrat.hrat34 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat34
            LET  l_sr = l_sr,"政治面貌不能为空!\n"
#            NEXT FIELD hrat34
         END IF
         IF g_hrat.hrat24 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat24
            LET  l_sr = l_sr,"婚姻状况不能为空!\n"
#            NEXT FIELD hrat24
         END IF
         IF g_hrat.hrat18 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat18
            LET  l_sr = l_sr,"籍贯不能为空!\n"
#            NEXT FIELD hrat18
         END IF
         IF g_hrat.hrat30 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat30
            LET  l_sr = l_sr,"户口性质不能为空!\n"
#            NEXT FIELD hrat30
         END IF
         IF g_hrat.hrat45 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat45
            LET  l_sr = l_sr,"户口所在地不能为空!\n"
#            NEXT FIELD hrat45
         END IF
         IF g_hrat.hrat46 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat46
            LET  l_sr = l_sr,"现居住地不能为空!\n"
#            NEXT FIELD hrat46
         END IF
         IF g_hrat.hrat49 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat49
            LET  l_sr = l_sr,"手机号码不能为空!\n"
#            NEXT FIELD hrat49
         END IF
         IF g_hrat.hrat51 IS NULL THEN
            DISPLAY BY NAME g_hrat.hrat51
            LET  l_sr = l_sr,"私人邮箱不能为空!\n"
#            NEXT FIELD hrat51
         END IF
         IF g_hrat.hrat07='Y' THEN 
            SELECT COUNT(*) INTO l_s FROM hraw_file WHERE hraw02=g_hrat.hrat04 AND hraw07='Y' AND hrawacti = 'Y' AND hraw05>today
            IF l_s >'0'THEN 
               SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = g_hrat.hrat04
               SELECT hraw01 INTO l_hraw01 FROM hraw_file WHERE hraw02= g_hrat.hrat04 AND hraw07='Y'
               SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid=l_hraw01
               LET l_sr=l_hrao02,"部门主管已指定为",l_hrat01,l_hrat02
            END IF 
            SELECT COUNT(*) INTO l_s FROM hrat_file,hrad_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'
            IF l_s >'0' AND g_hrat.hrat01 != g_hrat_t.hrat01  THEN
               SELECT hrat01,hrat02,hrat04 INTO l_hrat01,l_hrat02,l_hrat04 FROM hrat_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y'
               LET l_sr=l_sr,l_hrat04,"部门主管已指定为",l_hrat01,l_hrat02
            END IF 
         END IF
         IF NOT cl_null(l_sr) THEN 
            CALL cl_err(l_sr,'!',1)
            NEXT FIELD hrat01
         END IF 
      ON ACTION controlp
        CASE
           WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrat.hrat03
              CALL cl_create_qry() RETURNING g_hrat.hrat03
              DISPLAY BY NAME g_hrat.hrat03
              NEXT FIELD hrat03
           WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              IF NOT cl_null(g_hrat.hrat03) THEN
                 LET g_qryparam.form = "q_hrao01" 
                 LET g_qryparam.arg1 = g_hrat.hrat03
              ELSE
                LET g_qryparam.form = "q_hrao01_1"  
              END IF
              LET g_qryparam.default1 = g_hrat.hrat04
              CALL cl_create_qry() RETURNING g_hrat.hrat04
              DISPLAY BY NAME g_hrat.hrat04
              NEXT FIELD hrat04
               WHEN INFIELD(hrat68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.default1 = g_hrat.hrat68
                 CALL cl_create_qry() RETURNING g_hrat.hrat68
              #   DISPLAY g_qryparam.multiret TO hrat68
              DISPLAY BY NAME g_hrat.hrat68
                 NEXT FIELD hrat68
           WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              IF NOT cl_null(g_hrat.hrat04) THEN
                 LET g_qryparam.form = "q_hrap01" 
                 LET g_qryparam.arg1 = g_hrat.hrat04
              ELSE
                LET g_qryparam.form = "q_hrap01_1"  
              END IF
              LET g_qryparam.default1 = g_hrat.hrat05
              CALL cl_create_qry() RETURNING g_hrat.hrat05
              DISPLAY BY NAME g_hrat.hrat05
              NEXT FIELD hrat05     
           WHEN INFIELD(hrat06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat06" 
              LET g_qryparam.default1 = g_hrat.hrat06
              LET g_qryparam.arg1 = g_hrat.hrat01 
              CALL cl_create_qry() RETURNING g_hrat.hrat06
              DISPLAY BY NAME g_hrat.hrat06
              NEXT FIELD hrat06     
           WHEN INFIELD(hrat42)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrai031" 
              LET g_qryparam.default1 = g_hrat.hrat42
              CALL cl_create_qry() RETURNING g_hrat.hrat42
              DISPLAY BY NAME g_hrat.hrat42
              NEXT FIELD hrat42     
           WHEN INFIELD(hrat52)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat06"
              LET g_qryparam.arg1 = g_hrat.hrat01 
              LET g_qryparam.default1 = g_hrat.hrat52
              CALL cl_create_qry() RETURNING g_hrat.hrat52
              DISPLAY BY NAME g_hrat.hrat52
              NEXT FIELD hrat52     
#           WHEN INFIELD(hrat64)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrar06" 
#              LET g_qryparam.default1 = g_hrat.hrat64
#              CALL cl_create_qry() RETURNING g_hrat.hrat64
#              DISPLAY BY NAME g_hrat.hrat64
#              NEXT FIELD hrat64 
           WHEN INFIELD(hrat12)   
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '314'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat12
              CALL cl_create_qry() RETURNING g_hrat.hrat12
              DISPLAY BY NAME g_hrat.hrat12
              NEXT FIELD hrat12
           WHEN INFIELD(hrat17)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '333'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat17
              CALL cl_create_qry() RETURNING g_hrat.hrat17
              DISPLAY BY NAME g_hrat.hrat17
              NEXT FIELD hrat17
           WHEN INFIELD(hrat19)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrat.hrat19
              CALL cl_create_qry() RETURNING g_hrat.hrat19
              DISPLAY BY NAME g_hrat.hrat19
              NEXT FIELD hrat19              
           WHEN INFIELD(hrat20)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat20
              CALL cl_create_qry() RETURNING g_hrat.hrat20
              DISPLAY BY NAME g_hrat.hrat20
              NEXT FIELD hrat20
           WHEN INFIELD(hrat21)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '337'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat21
              CALL cl_create_qry() RETURNING g_hrat.hrat21
              DISPLAY BY NAME g_hrat.hrat21
              NEXT FIELD hrat21
           WHEN INFIELD(hrat66)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '326'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat66
              CALL cl_create_qry() RETURNING g_hrat.hrat66
              DISPLAY BY NAME g_hrat.hrat66
              NEXT FIELD hrat66
           WHEN INFIELD(hrat73)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '341'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat73
              CALL cl_create_qry() RETURNING g_hrat.hrat73
              DISPLAY BY NAME g_hrat.hrat73
              NEXT FIELD hrat73
           WHEN INFIELD(hrat78)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraq01"
               LET g_qryparam.default1 = g_hrat.hrat78
               CALL cl_create_qry() RETURNING g_hrat.hrat78
               DISPLAY BY NAME g_hrat.hrat78
               SELECT hraq02 INTO g_hrat78 FROM hraq_file WHERE hraq01=g_hrat.hrat78
               DISPLAY g_hrat78 TO hrat78_name
               NEXT FIELD hrat78
           WHEN INFIELD(hrat79)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '206'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat79
              CALL cl_create_qry() RETURNING g_hrat.hrat79
              DISPLAY BY NAME g_hrat.hrat79
              SELECT hrag07 INTO g_hrat79 FROM hrag_file WHERE hrag01='206' AND hrag06=g_hrat.hrat79
              DISPLAY g_hrat79 TO hrat79_name
              NEXT FIELD hrat79
           WHEN INFIELD(hrat22)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '317'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat22
              CALL cl_create_qry() RETURNING g_hrat.hrat22
              DISPLAY BY NAME g_hrat.hrat22
              NEXT FIELD hrat22
           WHEN INFIELD(hrat24)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '334'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat24
              CALL cl_create_qry() RETURNING g_hrat.hrat24
              DISPLAY BY NAME g_hrat.hrat24
              NEXT FIELD hrat24
           WHEN INFIELD(hrat28)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '302'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat28
              CALL cl_create_qry() RETURNING g_hrat.hrat28
              DISPLAY BY NAME g_hrat.hrat28
              NEXT FIELD hrat28
           WHEN INFIELD(hrat29)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '301'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat29
              CALL cl_create_qry() RETURNING g_hrat.hrat29
              DISPLAY BY NAME g_hrat.hrat29
              NEXT FIELD hrat29
           WHEN INFIELD(hrat30)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '321'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat30
              CALL cl_create_qry() RETURNING g_hrat.hrat30
              DISPLAY BY NAME g_hrat.hrat30
              NEXT FIELD hrat30
           WHEN INFIELD(hrat67)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraqa"
              LET g_qryparam.default1 = g_hrat.hrat67
              CALL cl_create_qry() RETURNING g_hrat.hrat67
              DISPLAY BY NAME g_hrat.hrat67
              NEXT FIELD hrat67
           WHEN INFIELD(hrat34)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '320'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat34
              CALL cl_create_qry() RETURNING g_hrat.hrat34
              DISPLAY BY NAME g_hrat.hrat34
              NEXT FIELD hrat34
           WHEN INFIELD(hrat40)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraf01"
              LET g_qryparam.default1 = g_hrat.hrat40
              CALL cl_create_qry() RETURNING g_hrat.hrat40
              DISPLAY BY NAME g_hrat.hrat40
              NEXT FIELD hrat40
           WHEN INFIELD(hrat41)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '325'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat41
              CALL cl_create_qry() RETURNING g_hrat.hrat41
              DISPLAY BY NAME g_hrat.hrat41
              NEXT FIELD hrat41
           WHEN INFIELD(hrat43)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '319'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat43
              CALL cl_create_qry() RETURNING g_hrat.hrat43
              DISPLAY BY NAME g_hrat.hrat43
              NEXT FIELD hrat43               
           WHEN INFIELD(hrat75)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrat.hrat75
              CALL cl_create_qry() RETURNING g_hrat.hrat75
              DISPLAY BY NAME g_hrat.hrat75
              NEXT FIELD hrat75
           OTHERWISE
              EXIT CASE
           END CASE
            
      ON ACTION update
           IF NOT cl_null(g_hrat.hrat01) THEN
              LET g_doc.column1 = "hrat01"
              LET g_doc.value1 = g_hrat.hrat01
              CALL cl_fld_doc("hrat32")
            END IF
                
      ON ACTION ghri006_k
         CALL i006_read()
 
      ON ACTION ghri006_l
         CALL i006_write()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
         
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION

FUNCTION i006_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrat.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i006_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i006_count
    FETCH i006_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i006_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
        INITIALIZE g_hrat.* TO NULL
    ELSE
        CALL i006_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i006_fetch(p_flhrat)
    DEFINE p_flhrat         LIKE type_file.chr1
 
    CASE p_flhrat
        WHEN 'N' FETCH NEXT     i006_cs INTO g_hrat.hratid
        WHEN 'P' FETCH PREVIOUS i006_cs INTO g_hrat.hratid
        WHEN 'F' FETCH FIRST    i006_cs INTO g_hrat.hratid
        WHEN 'L' FETCH LAST     i006_cs INTO g_hrat.hratid
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
   
 
                  ON ACTION help        
                     CALL cl_show_help()
 
                  ON ACTION controlg    
                     CALL cl_cmdask()   
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i006_cs INTO g_hrat.hratid
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
        INITIALIZE g_hrat.* TO NULL  
        LET g_hrat.hrat01 = NULL      
        RETURN
    ELSE
      CASE p_flhrat
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hrat.* FROM hrat_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hratid = g_hrat.hratid
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hrat.hratuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrat.hratgrup
        CALL i006_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i006_show()
DEFINE l_hrag07    LIKE hrag_file.hrag07
DEFINE l_des       LIKE type_file.chr100
   
   LET g_hrat_t.* = g_hrat.*
   DISPLAY BY NAME
      g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat72,g_hrat.hrat05,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat41,g_hrat.hrat40,
      g_hrat.hrat68,g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,g_hrat.hrat08,
      g_hrat.hrat58,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,
      g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,
      g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,
      g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat44,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,g_hrat.hrat39,
      g_hrat.hrat37,g_hrat.hrat35,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,
      g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,
      g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,
      g_hrat.hratdate
#        g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat41,g_hrat.hrat40,g_hrat.hrat68,g_hrat.hrat05,
#        g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,
#        g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,
#        g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,
#        g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,
#        g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,
#        g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat51,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat75,
#        g_hrat.hrat73,g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat42,g_hrat.hrat35,
#        g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat72,g_hrat.hrat54,g_hrat.hrat53,
#        g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
#        g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,
#        g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,g_hrat.hratdate                               #modify by hourf 2013/6/27
#   g_hrat.hrat03,g_hrat.hrat04,g_hrat.hratconf,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat07,
#   g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat09,g_hrat.hrat10,g_hrat.hrat11,g_hrat.hrat12,
#   g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat18,g_hrat.hrat19,
#   g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat24,g_hrat.hrat25,g_hrat.hrat26,
#   g_hrat.hrat27,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat30,g_hrat.hrat64,g_hrat.hrat66,g_hrat.hrat33,g_hrat.hrat53,
#   g_hrat.hrat54,g_hrat.hrat34,g_hrat.hrat35,g_hrat.hrat36,g_hrat.hrat37,g_hrat.hrat38,g_hrat.hrat39,
#   g_hrat.hrat40,g_hrat.hrat41,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat45,g_hrat.hrat46,
#   g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,g_hrat.hrat52,g_hrat.hrat55,
#   g_hrat.hrat56,g_hrat.hrat57,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat61,g_hrat.hrat62,
#   g_hrat.hrat63,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,
#   g_hrat.hratmodu,g_hrat.hratdate,g_hrat.hratacti
   CALL i006_hrat03(g_hrat.*) RETURNING l_des
   CALL i006_hrat04(g_hrat.*) RETURNING l_des
   CALL i006_hrat05(g_hrat.*) RETURNING l_des
   CALL i006_hrat06(g_hrat.*) RETURNING l_des
   CALL i006_hrat19(g_hrat.*) RETURNING l_des
   CALL i006_hrat40(g_hrat.*) RETURNING l_des
   CALL i006_hrat42(g_hrat.*) RETURNING l_des
   CALL i006_hrat52(g_hrat.*) RETURNING l_des
   CALL s_code('314',g_hrat.hrat12) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat12_name
   CALL s_code('333',g_hrat.hrat17) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat17_name
   CALL s_code('313',g_hrat.hrat20) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat20_name
   CALL s_code('340',g_hrat.hrat68) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat68_name
   CALL s_code('337',g_hrat.hrat21) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat21_name
   CALL s_code('326',g_hrat.hrat66) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat66_name
   CALL s_code('317',g_hrat.hrat22) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat22_name
   CALL s_code('334',g_hrat.hrat24) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat24_name
   CALL s_code('302',g_hrat.hrat28) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat28_name
   CALL s_code('301',g_hrat.hrat29) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat29_name
   CALL s_code('321',g_hrat.hrat30) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat30_name
   CALL s_code('320',g_hrat.hrat34) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat34_name
   CALL s_code('325',g_hrat.hrat41) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat41_name
   CALL s_code('319',g_hrat.hrat43) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat43_name
   CALL s_code('341',g_hrat.hrat73) RETURNING g_hrag.*
   DISPLAY g_hrag.hrag07 TO hrat73_name
   LET g_doc.column1 = "hrat01"
   LET g_doc.value1 = g_hrat.hrat01
   CALL cl_get_fld_doc("hrat32") 
   CALL cl_show_fld_cont()
 #  CALL cl_set_comp_comment("i006_w")
   SELECT hraqa03 INTO g_hraqa04 FROM hraqa_file WHERE hraqa06=g_hrat.hrat67
   DISPLAY g_hraqa04 TO hraqa04
   SELECT hraq02 INTO g_hrat78 FROM hraq_file WHERE hraq01=g_hrat.hrat78
   DISPLAY g_hrat78 TO hrat78_name
   SELECT hrag07 INTO g_hrat79 FROM hrag_file WHERE hrag01='206' AND hrag06=g_hrat.hrat79
   DISPLAY g_hrat79 TO hrat79_name

#       LET g_hraqa04=''
#       LET g_hrat78=''
#       LET g_hrat79=''
#       IF NOT cl_null(g_hrat.hrat67) THEN 
#         SELECT hraq01,hraqa02,hraqa04,hrag07,hraqa03,INTO g_hrat.hrat78, FROM hraqa_file
#         left JOIN hraq_file ON hraq02=hraqa02
#         left JOIN hrag_file ON hrag01='205' AND hrag06=hraqa04 AND hraqa06=g_hrat.hrat67
##          SELECT hraqa04 INTO g_hraqa04 
##            FROM hraqa_file 
##           WHERE hraqa06=g_hrat.hrat67 
##            SELECT hraqa03 INTO g_hraqa03 
##            FROM hraqa_file 
##           WHERE hraqa06=g_hrat.hrat67 
##          SELECT hraqa02 INTO g_hrat78 
##            FROM hraqa_file 
##           WHERE hraqa06=g_hrat.hrat67 
##          SELECT hrag07 INTO g_hrat79 
##            FROM hrag_file
##           WHERE hrag06=g_hraqa04 
##             AND hrag01='205'  
##          ELSE 
##             LET g_hraqa03=''
##             LET g_hrat78=''
##             LET g_hrat79=''
#       END IF 
#       DISPLAY g_hraqa03,g_hrat78,g_hrat79 TO hraqa04,hraqa02,hrag07   #职称带出来的相应栏位 

       LET g_hrat05_name1=''
       IF NOT cl_null(g_hrat.hrat05) THEN 
                SELECT hrap06 INTO g_hrat05_name
                FROM hrap_file
                WHERE hrap05=g_hrat.hrat05
                SELECT hras03 INTO g_hrar02
                FROM hras_file
                WHERE hras01=g_hrat.hrat05 
                SELECT hrar04 INTO g_hrat05_name1
                FROM hrar_file
                WHERE hrar03=g_hrar02            
                SELECT hras06 INTO g_hras06 
                FROM hras_file
                WHERE hras01=g_hrat.hrat05
                SELECT hrag07 INTO g_hrat.hrat64
                FROM hrag_file
                WHERE hrag01='205'
                  AND hrag06=g_hras06
          ELSE 
            LET g_hrat05_name1=''
            LET g_hrat.hrat64=''      
       END IF          
       DISPLAY g_hrat05_name TO hrat05_name
       DISPLAY g_hrat05_name1 TO hrat05_name1
       DISPLAY BY NAME g_hrat.hrat64

          LET g_hrat75_name=''
          IF NOT cl_null(g_hrat.hrat75) THEN
             SELECT hrat02 INTO g_hrat75_name
               FROM hrat_file
              WHERE hrat01=g_hrat.hrat75
             ELSE 
             LET  g_hrat75_name=''             
          END IF
          DISPLAY g_hrat75_name TO hrat75_name     #显示招聘负责人姓名
          IF g_hrat.hratconf = 'Y' THEN 
             LET g_chr2='Y' 
          ELSE 
             LET g_chr2='N' 
          END IF
          CALL cl_set_field_pic(g_hrat.hratconf,g_chr2,"","","","")
END FUNCTION


FUNCTION i006_u(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1
    IF g_hrat.hrat01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid=g_hrat.hratid
    IF g_hrat.hratacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'aap-005',0)
       RETURN
    END IF     
    CALL cl_opmsg('u')
    LET g_hrat01_t = g_hrat.hrat01
    BEGIN WORK
 
    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrat.hratmodu=g_user                  #修改者
    LET g_hrat.hratdate = g_today               #修改日期
    CALL i006_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i006_i(p_cmd)                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrat.*=g_hrat_t.*
            CALL i006_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrat_file SET hrat_file.* = g_hrat.*    # 更新DB
            #WHERE hrat01 = g_hrat.hrat01     #MOD-BB0113 mark
            WHERE hratid = g_hrat_t.hratid    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION


FUNCTION i006_confirm(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1 
DEFINE l_str     LIKE ze_file.ze01
DEFINE l_n       LIKE type_file.num5
    IF g_hrat.hrat01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF 
 
    SELECT * INTO g_hrat.* FROM hrat_file
     WHERE hratid = g_hrat.hratid

    IF p_cmd = 'Y' THEN 
       IF g_hrat.hratconf = 'Y' THEN
          CALL cl_err(g_hrat.hrat01,'axm1163',0) 
          RETURN
       END IF
      SELECT COUNT(*) INTO l_n FROM hrath_file WHERE hrath01 = g_hrat.hratid
      IF l_n = 0 THEN
         CALL cl_err('没有紧急联系人不能审核','!',1)
         RETURN 
      END IF 
      SELECT COUNT(*) INTO l_n FROM hratc_file WHERE hratc01 = g_hrat.hratid
      IF l_n = 0 THEN
         CALL cl_err('没有教育背景不能审核','!',1)
         RETURN 
      END IF 
      SELECT COUNT(*) INTO l_n FROM hrbf_file WHERE hrbf02 = g_hrat.hratid
      IF l_n = 0 THEN
         CALL cl_err('没有添加合同信息不能审核','!',1)
         RETURN 
      END IF 
       IF g_hrat.hratacti = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'alm-674',0) 
          RETURN
       END IF
       #add by zhuzw 20140627 start
       IF g_hrat.hrat09 = 'Y' THEN 
          SELECT hrap10 - hrap11 INTO l_n FROM hrap_file
           WHERE hrap01 = g_hrat.hrat04
             AND hrap05 = g_hrat.hrat05
          IF l_n = 0 THEN 
             CALL cl_err('','ghr-261',1)
             RETURN 
          END IF   
       END IF  
       #add by zhuzw 20140627 end 
#       IF cl_null(g_hrat.hrat66) THEN 
#          CALL cl_err('入司时间为空不能审核','!',0) 
#          RETURN
#       END IF 
       IF cl_null(g_hrat.hrat42) THEN 
           CALL cl_err('成本中心为空不能审核','!',0) 
          RETURN
       END IF 
       LET l_str = 'aim-301'  
    ELSE 
       IF g_hrat.hratconf = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'9025',0) 
          RETURN
       END IF
       IF g_hrat.hratacti = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'aec-027',0) 
          RETURN
       END IF  
       LET l_str = 'aim-302'
    END IF
     
    BEGIN WORK

    CALL i006_show() 
    IF  cl_confirm(l_str) THEN
        UPDATE hrat_file
            SET hratconf=p_cmd
            WHERE hratid=g_hrat.hratid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0) 
            ROLLBACK WORK 
        #add by zhuzw 20140627 start
        ELSE
          IF p_cmd = 'Y' THEN
             IF g_hrat.hrat09 = 'Y' THEN 
                UPDATE hrap_file 
                   SET hrap11 = hrap11 +1 ,
                       hrap12 = hrap12 +1 
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05   
                UPDATE hrap_file 
                   SET 
                       hrap14 = hrap14 +1 ,
                       hrap15 = hrap15 +1
                WHERE hrap01 = g_hrat.hrat04
             ELSE 
                UPDATE hrap_file 
                   SET hrap12 = hrap12 +1                       
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05                                
                UPDATE hrap_file 
                   SET 
                       hrap15 = hrap15 +1
                WHERE hrap01 = g_hrat.hrat04
             END IF  
          ELSE 
             IF g_hrat.hrat09 = 'Y' THEN 
                UPDATE hrap_file 
                   SET hrap11 = hrap11 -1 ,
                       hrap12 = hrap12 -1 
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05   
                UPDATE hrap_file 
                   SET 
                       hrap14 = hrap14 -1 ,
                       hrap15 = hrap15 -1
                WHERE hrap01 = g_hrat.hrat04
             ELSE 
                UPDATE hrap_file 
                   SET hrap12 = hrap12 -1                       
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05                                
                UPDATE hrap_file 
                   SET 
                       hrap15 = hrap15 -1
                WHERE hrap01 = g_hrat.hrat04                                
             END IF                   
          END IF 
        #add by zhuzw 20140627 end 
             
        END IF   
    END IF  
    COMMIT WORK 
    SELECT hratconf INTO g_hrat.hratconf FROM hrat_file
     WHERE hratid = g_hrat.hratid
    DISPLAY BY NAME g_hrat.hratconf 
END FUNCTION
 
FUNCTION i006_x()
   
    IF g_hrat.hrat01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid     
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'art-050',0)
       RETURN
    END IF     
    BEGIN WORK
 
    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i006_show()
    IF cl_exp(0,0,g_hrat.hratacti) THEN
        LET g_chr = g_hrat.hratacti
        IF g_hrat.hratacti='Y' THEN
            LET g_hrat.hratacti='N'
        ELSE
            LET g_hrat.hratacti='Y'
        END IF
        UPDATE hrat_file
            SET hratacti=g_hrat.hratacti
            WHERE hratid=g_hrat.hratid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
            LET g_hrat.hratacti = g_chr
        END IF
        DISPLAY BY NAME g_hrat.hratacti
    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i006_r()

    IF g_hrat.hrat01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid  
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'alm-028',0)
       RETURN
    END IF        
    BEGIN WORK
 
    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 0)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i006_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrat01"   
       LET g_doc.value1 = g_hrat.hrat01 

       CALL cl_del_doc()
       DELETE FROM hrat_file WHERE hratid = g_hrat.hratid
       IF SQLCA.SQLCODE THEN
          CALL cl_err("del hrat_file:",SQLCA.SQLCODE,0)
          CLOSE i006_cl
          ROLLBACK WORK  
          RETURN
       END IF
       
       CLEAR FORM
       OPEN i006_count
       IF STATUS THEN
          CLOSE i006_cl
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i006_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i006_cl
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i006_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i006_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i006_fetch('/')
       END IF
    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i006_copy()

    DEFINE l_newno         LIKE hrat_file.hrat01
    DEFINE l_oldno         LIKE hrat_file.hrat01
    DEFINE p_cmd           LIKE type_file.chr1 
    DEFINE l_hratid        LIKE hrat_file.hratid
    DEFINE l_hrat08        LIKE type_file.num10
    DEFINE l_hraa10        LIKE hraa_file.hraa10
    
    IF g_hrat.hrat01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid
  
    LET g_before_input_done = FALSE
    CALL i006_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM hrat01
        BEFORE INPUT
           #add by yougs130425 begin
           IF NOT cl_null(g_hrat.hrat03) THEN
              LET l_hraa10 = ''
              SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
              LET g_flag = 'Y'
              CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING l_newno,g_flag
              DISPLAY l_newno TO hrat01
              IF g_flag = 'Y' THEN
                 CALL cl_set_comp_entry("hrat01",TRUE) 
              ELSE
                 CALL cl_set_comp_entry("hrat01",FALSE)
              END IF
           END IF
           #add by yougs130425 end

 
        AFTER FIELD hrat01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM hrat_file WHERE hrat01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD hrat01
              END IF  
           END IF
   
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

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_hrat.hrat01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrat_file
        WHERE hrat01=g_hrat.hrat01
        INTO TEMP x 
    SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file 
    IF cl_null(l_hratid) THEN
       LET l_hratid = 1
    END IF
    SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL  
    SELECT MAX(to_number(hrat08)+1) INTO l_hrat08 FROM hrat_file 
    IF cl_null(l_hrat08) THEN
       LET l_hrat08 = 1
    END IF  
    SELECT to_char(l_hrat08) INTO l_hrat08 FROM DUAL  
    UPDATE x
        SET hrat01=l_newno,    #資料鍵值
            hratacti='Y',      #資料有效碼
            hratconf = 'N',
            hratoriu = g_user,
            hratorig = g_grup,
            hratuser=g_user,   #資料所有者
            hratgrup=g_grup,   #資料所有者所屬群
            hratmodu=NULL,     #資料修改日期
            hratdate=g_today,  #資料建立日期 
            hratid=l_hratid,
            hrat08=l_hrat08,
            hrat12='',
            hrat13=''

    INSERT INTO hrat_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_hrat.hrat01
        LET g_hrat.hrat01 = l_newno
        SELECT hrat_file.* INTO g_hrat.* FROM hrat_file
               WHERE hrat01 = l_newno
        CALL i006_u('c')
        SELECT hrat_file.* INTO g_hrat.* FROM hrat_file
               WHERE hrat01 = l_oldno
    END IF
    LET g_hrat.hrat01 = l_oldno
    CALL i006_show()
END FUNCTION
  
 
PRIVATE FUNCTION i006_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd <> 'c' THEN
      CALL cl_set_comp_entry("hrat01",TRUE)
   END IF
END FUNCTION

 
PRIVATE FUNCTION i006_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'c' THEN
      CALL cl_set_comp_entry("hrat01",FALSE)
   END IF  
END FUNCTION
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i006_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131022 shenran 
#=================================================================#
FUNCTION i006_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrat08 LIKE hrat_file.hrat08,
       l_hratid LIKE hrat_file.hratid,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrat03  LIKE hrat_file.hrat03,
         hrat04  LIKE hrat_file.hrat04,
         hrat05  LIKE hrat_file.hrat05,
         hrat01  LIKE hrat_file.hrat01,
         hrat02  LIKE hrat_file.hrat02,
         hrat06  LIKE hrat_file.hrat06,
         hrat25  LIKE hrat_file.hrat03,
         hrat66  LIKE hrat_file.hrat66,
         hrat22  LIKE hrat_file.hrat22,
         hrat12  LIKE hrat_file.hrat12,
         hrat13  LIKE hrat_file.hrat13,
         hrat15  LIKE hrat_file.hrat15,
         hrat17  LIKE hrat_file.hrat17,
         hrat19  LIKE hrat_file.hrat19,
         hrat20  LIKE hrat_file.hrat20,
         hrat21  LIKE hrat_file.hrat21,
         hrat49  LIKE hrat_file.hrat49
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow                                                                   
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrat03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrat04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrat05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrat01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrat02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrat06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrat25])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrat66])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[sr.hrat22])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',16).Value'],[sr.hrat12])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',18).Value'],[sr.hrat13])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',19).Value'],[sr.hrat15])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',20).Value'],[sr.hrat17])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',22).Value'],[sr.hrat19])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',24).Value'],[sr.hrat20])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',26).Value'],[sr.hrat21])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',28).Value'],[sr.hrat49])
                 
                IF NOT cl_null(sr.hrat03) AND NOT cl_null(sr.hrat04) AND NOT cl_null(sr.hrat05) AND NOT cl_null(sr.hrat01) AND NOT cl_null(sr.hrat02) AND NOT cl_null(sr.hrat25)
                   AND NOT cl_null(sr.hrat66) AND NOT cl_null(sr.hrat22) AND NOT cl_null(sr.hrat12) AND NOT cl_null(sr.hrat13) AND NOT cl_null(sr.hrat15) AND NOT cl_null(sr.hrat17) 
                   AND NOT cl_null(sr.hrat19) AND NOT cl_null(sr.hrat20) AND NOT cl_null(sr.hrat21)THEN
                   SELECT MAX(to_number(hrat08)+1) INTO l_hrat08 FROM hrat_file 
                   IF cl_null(l_hrat08) THEN
                      LET l_hrat08 = 1
                   END IF  
                   SELECT to_char(l_hrat08) INTO l_hrat08 FROM DUAL  
                   SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file 
                   IF cl_null(l_hratid) THEN
                      LET l_hratid = 1
                   END IF
                   SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL  
                   IF i > 1 THEN
                    INSERT INTO hrat_file(hratid,hrat08,hrat03,hrat04,hrat05,hrat01,hrat02,hrat06,hrat25,hrat66,hrat22,hrat12,hrat13,hrat15,hrat17,hrat19,hrat20,hrat21,hrat49,hratacti,hratuser,hratgrup,hratdate,hratorig,hratoriu)
                      VALUES (l_hratid,l_hrat08,sr.hrat03,sr.hrat04,sr.hrat05,sr.hrat01,sr.hrat02,sr.hrat06,sr.hrat25,sr.hrat66,sr.hrat22,sr.hrat12,sr.hrat13,sr.hrat15,sr.hrat17,sr.hrat19,sr.hrat20,sr.hrat21,sr.hrat49,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrat_file",sr.hrat01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                   END IF 
                END IF 
                   #LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hrat.* FROM hrat_file
       WHERE hratid=l_hratid
       
       CALL i006_show()
   END IF 

END FUNCTION

FUNCTION i0221_assign()
   DEFINE l_hrbf08    LIKE  hrbf_file.hrbf08
   DEFINE l_hrbe02    LIKE hrbe_file.hrbe02
   DEFINE l_hrag07    LIKE hrag_file.hrag07
   IF cl_null(g_hrat.hratid) THEN      
      RETURN
   END IF
   select max(hrbf09) into l_hrbf08 from hrbf_file where hrbf02=g_hrat.hratid
   IF cl_null(l_hrbf08) THEN
      LET g_hrbf.hrbf03 = '1'
      LET g_hrbf.hrbf08 = g_hrat.hrat25
      SELECT trunc(add_months(g_hrat.hrat25,36)) into g_hrbf.hrbf09 FROM dual
      DISPLAY g_hrbf.hrbf08 TO hrbf08  
      DISPLAY g_hrbf.hrbf09 TO hrbf09 
   ELSE
      LET g_hrbf.hrbf03 = '2'
      SELECT l_hrbf08 + 1 into g_hrbf.hrbf08 FROM dual
      SELECT trunc(add_months(g_hrbf.hrbf08,36)) into g_hrbf.hrbf09 FROM dual
      DISPLAY g_hrbf.hrbf08 TO hrbf08  
      DISPLAY g_hrbf.hrbf09 TO hrbf09  
   END IF
   OPEN WINDOW i0221_w1 WITH FORM "ghr/42f/ghri0221"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()
   LET g_hrbf.hrbf02 = g_hrat.hratid
   LET g_hrbf.hrbf05 = 'N'
   LET g_hrbf.hrbf07 = 'N'
   LET g_hrbf.hrbf10 = g_today
   LET g_hrbf.hrbfacti = 'Y'
   LET g_hrbf.hrbfuser = g_user
   LET g_hrbf.hrbfgrup = g_grup
   LET g_hrbf.hrbfmodu = g_user
   LET g_hrbf.hrbfdate = g_today
   LET g_hrbf.hrbforiu = g_user
   LET g_hrbf.hrbforig = g_grup
   WHILE TRUE
      DISPLAY BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12
                    
      INPUT BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12
                    WITHOUT DEFAULTS
         BEFORE INPUT
        call cl_set_comp_entry("hrbf03",true)
            ON ACTION controlp
               CASE
                  WHEN INFIELD(hrbf04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_hrbe01"
                     LET g_qryparam.construct='N'
                     CALL cl_create_qry() RETURNING g_hrbf.hrbf04
                     DISPLAY g_hrbf.hrbf04 TO hrbf04   
                     NEXT FIELD hrbf04  
                  WHEN INFIELD(hrbf11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.arg1 = '339'
                     LET g_qryparam.form ="q_hrag06"
                     LET g_qryparam.construct='N'
                     CALL cl_create_qry() RETURNING g_hrbf.hrbf11
                     DISPLAY g_hrbf.hrbf11 TO hrbf11   
                     NEXT FIELD hrbf11   
               END CASE
            AFTER FIELD hrbf04
               IF NOT cl_null(g_hrbf.hrbf04) THEN
                  SELECT hrbe02 INTO l_hrbe02 FROM hrbe_file
                     WHERE hrbe01=g_hrbf.hrbf04
                  DISPLAY l_hrbe02 TO hrbf04_name
               END IF
            AFTER FIELD hrbf05
               IF g_hrbf.hrbf05 = 'Y' THEN
                  LET g_hrbf.hrbf09 = '9999-12-31'
                  DISPLAY BY NAME g_hrbf.hrbf09
                  CALL cl_set_comp_required("hrbf09",FALSE)
                  CALL cl_set_comp_entry("hrbf09",FALSE)
               ELSE
                  SELECT trunc(add_months(g_hrat.hrat25,36)) into g_hrbf.hrbf09 FROM dual
                  DISPLAY BY NAME g_hrbf.hrbf09
                  CALL cl_set_comp_required("hrbf09",TRUE)
                  CALL cl_set_comp_entry("hrbf09",TRUE)
               END IF
            AFTER FIELD hrbf08
               IF NOT cl_null(g_hrbf.hrbf08) AND cl_null(g_hrbf.hrbf09) THEN
                  SELECT trunc(add_months(g_hrat.hrat25,36)) into g_hrbf.hrbf09 FROM dual
                  DISPLAY BY NAME g_hrbf.hrbf09
               END IF
            AFTER FIELD hrbf11
               IF NOT cl_null(g_hrbf.hrbf11) THEN
                  select hrag07 into l_hrag07 from hrag_file 
                     where hrag01='339' and hrag06=g_hrbf.hrbf11
                  DISPLAY l_hrag07 TO hrbf11_name
               END IF
            
            ON ACTION locale
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               LET g_action_choice = "locale"
               EXIT INPUT
       
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
       
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
       
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
       
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
       
            ON ACTION exit
               LET INT_FLAG = 1
               
            #ON ACTION accept
            #EXIT INPUT 
            IF g_action_choice = "locale" THEN
               LET g_action_choice = ""
               CALL cl_dynamic_locale()
               CONTINUE WHILE    
            END IF 
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               CLOSE WINDOW i0221_w1 
               RETURN
            END IF
         END INPUT  
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW i0221_w1 
            RETURN
         END IF 
      EXIT WHILE
   END WHILE
   IF g_hrbf.hrbf08 > g_hrbf.hrbf09 THEN
      CALL cl_err('',-9913,0)
      LET INT_FLAG = 0
      #CONTINUE WHILE   
   ELSE
      SELECT TO_CHAR(MAX(to_number(hrbf01))+1,'fm0000000000') INTO g_hrbf.hrbf01 FROM hrbf_file
      IF cl_null(g_hrbf.hrbf01) THEN LET g_hrbf.hrbf01 = '0000000001' END IF
      INSERT INTO hrbf_file VALUES(g_hrbf.*)
   END IF
   CLOSE WINDOW i0221_w1
END FUNCTION

FUNCTION i006_read()
        DEFINE ls_str STRING
        DEFINE li_status    SMALLINT
        DEFINE ls_cmd       STRING
        LET ls_cmd="\"D:\\Integration\\IDCard\\CVR100A_U_DSDK.exe\""
        CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
END FUNCTION


FUNCTION i006_write()
   DEFINE gr_gca        RECORD LIKE gca_file.*
   DEFINE gr_gca07      LIKE gca_file.gca07
   DEFINE gr_gcb        RECORD LIKE gcb_file.*
   DEFINE ls_str,ls_str1,ls_str2,ls_str3,ls_str4,ls_str5,ls_str6,ls_str7 LIKE type_file.chr1000
   DEFINE li_status     SMALLINT
   DEFINE ls_location,ls_fname   STRING
   DEFINE ls_sql,gs_mode,ls_time STRING
   IF NOT cl_null(g_hrat.hrat01) THEN  #员工工号不为空时处理
      CALL ui.interface.frontCall('standard','cbget',[],[ls_str]) #获取剪切板中的身份证件信息
      SELECT substr(ls_str,1,INSTR(ls_str,'@',1,1)-1),
               substr(ls_str,INSTR(ls_str,'@',1,1)+1,INSTR(ls_str,'@',1,2)-INSTR(ls_str,'@',1,1)-1),
               substr(ls_str,INSTR(ls_str,'@',1,2)+1,INSTR(ls_str,'@',1,3)-INSTR(ls_str,'@',1,2)-1),
               substr(ls_str,INSTR(ls_str,'@',1,3)+1,INSTR(ls_str,'@',1,4)-INSTR(ls_str,'@',1,3)-1),
               substr(ls_str,INSTR(ls_str,'@',1,4)+1,INSTR(ls_str,'@',1,5)-INSTR(ls_str,'@',1,4)-1),
               substr(ls_str,INSTR(ls_str,'@',1,5)+1,INSTR(ls_str,'@',1,6)-INSTR(ls_str,'@',1,5)-1),
               substr(ls_str,INSTR(ls_str,'@',1,6)+1,INSTR(ls_str,'@',1,7)-INSTR(ls_str,'@',1,6)-1)
         INTO ls_str1,ls_str2,ls_str3,ls_str4,ls_str5,ls_str6,ls_str7
      FROM dual       
      #处理身份证失效日期
      SELECT to_date(substr(ls_str7,12,10),'yyyy.mm.dd') into g_hrat.hrat14 FROM dual
      IF g_hrat.hrat14 < g_today THEN
         CALL cl_err('此身份证件已过期','!',1)
      END IF
      DISPLAY g_hrat.hrat14 TO hrat14
      #处理身份证姓名信息
      LET g_hrat.hrat02=ls_str1
      DISPLAY g_hrat.hrat02 TO hrat02
      #处理身份证性别信息
      SELECT hrag06 into g_hrat.hrat17 FROM hrag_file WHERE  hragacti='Y' and  hrag01 =333 AND hrag07=ls_str2
      DISPLAY g_hrat.hrat17 TO hrat17
      DISPLAY ls_str2 TO hrat17_name
      #处理身份证民族信息
      SELECT hrag06 into g_hrat.hrat29 FROM hrag_file WHERE  hragacti='Y' and  hrag01 =301 AND hrag07=ls_str3||'族'
      DISPLAY g_hrat.hrat29 TO hrat29
      DISPLAY ls_str3||'族' TO hrat29_name
      #处理身份证出生日期信息
      SELECT to_date(ls_str4,'yyyy-mm-dd') into g_hrat.hrat15 FROM dual
      DISPLAY g_hrat.hrat15 TO hrat15
      #处理身份证年龄信息
      SELECT YEAR(SYSDATE)-YEAR(g_hrat.hrat15) into g_hrat.hrat16 FROM dual
      DISPLAY g_hrat.hrat16 TO hrat16
      #处理身份证地址信息
      LET g_hrat.hrat76=ls_str5
      DISPLAY g_hrat.hrat76 TO hrat76
      #处理身份证号码信息
      LET g_hrat.hrat13=ls_str6
      DISPLAY g_hrat.hrat13 TO hrat13
      #处理国家&地区信息
      SELECT hrag07 into g_hrat.hrat28 FROM hrag_file WHERE hrag06='CN' AND  hragacti='Y' AND hrag01='302'
      DISPLAY g_hrat.hrat28 TO hrat28_name
      LET g_hrat.hrat28='CN'
      DISPLAY g_hrat.hrat28 TO hrat28
      #处理证件类型信息
      SELECT hrag07 into g_hrat.hrat12 FROM hrag_file WHERE hrag06='001' AND  hragacti='Y' AND hrag01='314'
      DISPLAY g_hrat.hrat12 TO hrat12_name
      LET g_hrat.hrat12='001'
      DISPLAY g_hrat.hrat12 TO hrat12
      #处理籍贯信息
      SELECT hraj02 into g_hrat.hrat18 FROM hraj_file WHERE hraj01=substr(ls_str6,1,6)
      DISPLAY g_hrat.hrat18 TO hrat18
      #初始化缓存表gca_file
      LET ls_sql = "SELECT gca_file.* FROM gca_file WHERE ",
                     " gca01 = 'hrat01=", g_hrat.hrat01,"'",
                     " AND gca08 = 'FLD'",
                     " AND gca09 = 'hrat32'",
                     " AND gca11 = 'Y'"
      PREPARE fld_doc_pre FROM ls_sql
      EXECUTE fld_doc_pre INTO gr_gca.*
      CASE SQLCA.SQLCODE
         WHEN 0
            LET gs_mode = "modify"
         WHEN NOTFOUND
            LET gs_mode = "insert"
            INITIALIZE gr_gca.* TO NULL
            INITIALIZE gr_gcb.* TO NULL
         OTHERWISE
            CALL cl_err("数据查询异常",'!',0)
      END CASE
      #处理身份证件照片信息
      LET ls_time=TIME
      LET ls_location="D:\\Integration\\IDCard\\zp.bmp"
      IF cl_null(gr_gca.gca07) THEN 
         LET gr_gca07="FLD-",FGL_GETPID() USING "<<<<<<<<<<", "-",TODAY USING "YYYYMMDD", "-",ls_time.subString(1,2), ls_time.subString(4,5), ls_time.subString(7,8)
      ELSE 
         LET gr_gca07=gr_gca.gca07
      END IF 
      LET ls_fname="/u1/out/",gr_gca07
      #上传照片
      IF NOT cl_upload_file(ls_location, ls_fname) THEN
         CALL cl_err("照片上传失败", "!", 1)
         RETURN
      END IF
      #回写数据
      IF gs_mode = "modify" THEN
         LOCATE gr_gcb.gcb09 IN MEMORY
         SELECT gcb_file.* INTO gr_gcb.* FROM gcb_file
         WHERE gcb01 = gr_gca.gca07 AND gcb02 = gr_gca.gca08 AND gcb03 = gr_gca.gca09 AND gcb04 = gr_gca.gca10
         FREE gr_gcb.gcb09
         LOCATE gr_gcb.gcb09 IN FILE ls_fname
         LET gr_gcb.gcb07 = "zp.bmp"
         LET gr_gcb.gcb08 = "D"
         LET gr_gcb.gcb10 = ls_location
         LET gr_gca.gca15 = gr_gcb.gcb16 := g_user CLIPPED
         LET gr_gca.gca16 = gr_gcb.gcb17 := g_grup CLIPPED
         LET gr_gca.gca17 = gr_gcb.gcb18 := g_today CLIPPED
         
         LET ls_sql = "UPDATE gca_file",
                        "   SET gca15 = '", gr_gca.gca15 CLIPPED, "',",
                        "       gca16 = '", gr_gca.gca16 CLIPPED, "',",
                        "       gca17 = '", gr_gca.gca17 CLIPPED, "'",
                        " WHERE gca01='hrat01=", g_hrat.hrat01,"' AND ",
                        "       gca06 = ", gr_gca.gca06
         EXECUTE IMMEDIATE ls_sql
         
         UPDATE gcb_file
            SET gcb07 = gr_gcb.gcb07,
                  gcb08 = gr_gcb.gcb08,
                  gcb09 = gr_gcb.gcb09,
                  gcb10 = gr_gcb.gcb10,
                  gcb16 = gr_gcb.gcb16,
                  gcb17 = gr_gcb.gcb17,
                  gcb18 = gr_gcb.gcb18
         WHERE gcb01 = gr_gcb.gcb01 AND
               gcb02 = gr_gcb.gcb02 AND
               gcb03 = gr_gcb.gcb03 AND
               gcb04 = gr_gcb.gcb04
      ELSE
         LET gr_gca.gca01 = "hrat01=",g_hrat.hrat01
         LET gr_gca.gca02 = ' '
         LET gr_gca.gca03 = ' '
         LET gr_gca.gca04 = ' '
         LET gr_gca.gca05 = ' '
         LET gr_gca.gca06 = -1
         LET gr_gca.gca07 = gr_gcb.gcb01 := gr_gca07
         LET gr_gca.gca08 = gr_gcb.gcb02 := "FLD"
         LET gr_gca.gca09 = gr_gcb.gcb03 := "hrat32"
         LET gr_gca.gca10 = gr_gcb.gcb04 := "001"
         LET gr_gca.gca11 = 'Y'
         LET gr_gca.gca12 = gr_gcb.gcb13 := g_user CLIPPED
         LET gr_gca.gca13 = gr_gcb.gcb14 := g_grup CLIPPED
         LET gr_gca.gca14 = gr_gcb.gcb15 := g_today CLIPPED
         
         LOCATE gr_gcb.gcb09 IN FILE ls_fname
         LET gr_gcb.gcb07 = "zp.bmp"
         LET gr_gcb.gcb08 = "D"
         LET gr_gcb.gcb10 = ls_location
         LET gr_gcb.gcb11 = "O"
         LET gr_gcb.gcb12 = "U"
         
         INSERT INTO gca_file VALUES (gr_gca.*)
         INSERT INTO gcb_file VALUES (gr_gcb.*)
      END IF 
      #照片显示
      LET g_doc.column1 = "hrat01"
      LET g_doc.value1 = g_hrat.hrat01
      CALL cl_get_fld_doc("hrat32") 
      CALL cl_show_fld_cont()
   ELSE
      CALL cl_err('请先录入员工工号信息','!',1)  
   END IF
END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
