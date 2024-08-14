# Prog. Version..: '5.30.05-13.01.08(00010)'     #
#
# Pattern name...: ghri045.4gl
# Descriptions...: 畫面元件顯示多語言設定作業
# Descriptions...: 员工出差信息维护作业
# Date & Author..: 13/06/06 By yeap1

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_hrce                 RECORD LIKE hrce_file.*,
       g_hrce_t               RECORD LIKE hrce_file.*,     #備份舊值
       g_hrcea_t              RECORD LIKE hrcea_file.*,     #備份舊值
       g_hrceb_t              RECORD LIKE hrceb_file.*,     #備份舊值
       g_hrcec_t              RECORD LIKE hrcec_file.*,     #備份舊值
       g_hrce01_t             LIKE        hrce_file.hrce01,         #Key值備份
       g_hrce_lock RECORD LIKE hrce_file.*,      # FOR LOCK CURSOR TOUCH
     g_hrcea   DYNAMIC ARRAY OF RECORD
        hrcea01      LIKE hrcea_file.hrcea01,
        hrcea02      LIKE hrcea_file.hrcea02,
        hrcea03      LIKE hrcea_file.hrcea03,
        hrcea04      LIKE hrcea_file.hrcea04,
        hrcea05      LIKE hrcea_file.hrcea05,
        hrcea06      LIKE hrcea_file.hrcea06,
        hrcea07      LIKE hrcea_file.hrcea07,
        hrcea08      LIKE hrcea_file.hrcea08,
        hrcea09      LIKE hrcea_file.hrcea09,
        hrcea10      LIKE hrcea_file.hrcea10,
        hrcea11      LIKE hrcea_file.hrcea11,
        hrcea12      LIKE hrcea_file.hrcea12,
        hrcea13      LIKE hrcea_file.hrcea13
                    END RECORD,
     g_hrceb  DYNAMIC ARRAY OF RECORD
        hrceb01      LIKE hrceb_file.hrceb01,
        hrceb02      LIKE hrceb_file.hrceb02,
        hrceb03      LIKE hrceb_file.hrceb03,
        hrceb04      LIKE hrceb_file.hrceb04,
        hrceb05      LIKE hrceb_file.hrceb05,
        hrceb06      LIKE hrceb_file.hrceb06
                    END RECORD,
     g_hrcec   DYNAMIC ARRAY OF RECORD
        hrcec01      LIKE hrcec_file.hrcec01,
        hrcec02      LIKE hrcec_file.hrcec02,
        hrcec03      LIKE hrcec_file.hrcec03,
        hrcec04      LIKE hrcec_file.hrcec04,
        hrcec05      LIKE hrcec_file.hrcec05,
        hrcec06      LIKE hrcec_file.hrcec06,
        hrcec07      LIKE hrcec_file.hrcec07,
        hrcec08      LIKE hrcec_file.hrcec08,
        hrcec09      LIKE hrcec_file.hrcec09,
        hrcec10      LIKE hrcec_file.hrcec10,
        hrcec11      LIKE hrcec_file.hrcec11,
        hrcec12      LIKE hrcec_file.hrcec12,
        hrcec13      LIKE hrcec_file.hrcec13,
        hrcec14      LIKE hrcec_file.hrcec14,
        hrcec15      LIKE hrcec_file.hrcec15,
        hrcec16      LIKE hrcec_file.hrcec16
                    END RECORD, 
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,  #No.FUN-580092 HCN
         g_sql                STRING,  #No.FUN-580092 HCN
         g_sql1                STRING,  #No.FUN-580092 HCN
         g_sql2                STRING,  #No.FUN-580092 HCN
         g_sql3                STRING,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b1             LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         g_rec_b2             LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         g_rec_b3             LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac1                  LIKE type_file.num5,     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
         l_ac2                  LIKE type_file.num5,
         l_ac3                  LIKE type_file.num5
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_cnt0                 LIKE type_file.num10 
DEFINE   g_cnt1                 LIKE type_file.num10 
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql         STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE hrce_file.hrce01
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-760049
DEFINE   g_hrbm                RECORD LIKE hrbm_file.*
 
MAIN#gai
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
   INITIALIZE g_hrce.* TO NULL
 
 
   OPEN WINDOW i045_w WITH FORM "ghr/42f/ghri045"
     ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
 #  LET g_db_type=cl_db_get_database_type()   #No.FUN-760049
 
   LET g_forupd_sql =" SELECT * FROM hrce_file ",  
                      "  WHERE hrce01 = ? ",  #No.FUN-710055
                      " FOR UPDATE NOWAIT"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL i045_q()
   END IF
   
   LET g_action_choice = "" 
   CALL i045_menu() 
 
   CLOSE WINDOW i045_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION i045_curs() #gai                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_hrceb.clear()
   CALL g_hrcea.clear()
   CALL g_hrcec.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "hrce01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      INITIALIZE g_hrce.* TO NULL
 
      CONSTRUCT g_wc ON hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,
                        hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti,
                        hrceb02,hrceb03,hrceb04,hrceb05,hrceb06,
                        hrcea02,hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,hrcea08,
                        hrcea09,hrcea10,hrcea11,hrcea12,hrcea13,
                        hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,hrcec07,hrcec08,
                        hrcec09,hrcec10,hrcec15,hrcec16
                   FROM hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,
                        hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti,
                        s_hrceb[1].hrceb02,s_hrceb[1].hrceb03,s_hrceb[1].hrceb04,
                        s_hrceb[1].hrceb05,s_hrceb[1].hrceb06,
                        s_hrcea[1].hrcea02,s_hrcea[1].hrcea03,s_hrcea[1].hrcea04,
                        s_hrcea[1].hrcea05,s_hrcea[1].hrcea06,s_hrcea[1].hrcea07,
                        s_hrcea[1].hrcea08,s_hrcea[1].hrcea09,s_hrcea[1].hrcea10,
                        s_hrcea[1].hrcea11,s_hrcea[1].hrcea12,s_hrcea[1].hrcea13,
                        s_hrcec[1].hrcec02,s_hrcec[1].hrcec03,s_hrcec[1].hrcec04,
                        s_hrcec[1].hrcec05,s_hrcec[1].hrcec06,s_hrcec[1].hrcec07,
                        s_hrcec[1].hrcec08,s_hrcec[1].hrcec09,s_hrcec[1].hrcec10,
                        s_hrcec[1].hrcec15,s_hrcec[1].hrcec16


    BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(hrce02)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrbm03"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_hrce.hrce02
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_hrce.hrce02
                  NEXT FIELD hrce02
                  
           WHEN INFIELD(hrceb03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat03"
            #  LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb03
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb03
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb03
              NEXT FIELD hrceb03
              
           WHEN INFIELD(hrceb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat03"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb04
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb04
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb04
              NEXT FIELD hrceb04

           WHEN INFIELD(hrceb05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb05
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb05
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb05
              NEXT FIELD hrceb05
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql = "SELECT UNIQUE hrce01,hrce02 FROM hrce_file",
               " WHERE ",g_wc CLIPPED," ORDER BY hrce01"
   PREPARE i045_prepare FROM g_sql          # 預備一下
   DECLARE i045_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i045_prepare

   LET g_sql = "SELECT COUNT(*) FROM hrce_file WHERE ",g_wc CLIPPED
   PREPARE i045_precount FROM g_sql
   DECLARE i045_count CURSOR FOR i045_precount
 
END FUNCTION
 
FUNCTION i045_menu()#gai
 
   WHILE TRUE
      CALL i045_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i045_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL i045_u()
            END IF
#         WHEN "reproduce"                       # C.複製
#            IF cl_chk_act_auth() THEN
#               CALL i045_copy()
#            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
            CALL i045_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i045_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i045_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "shenhe"                        
            CALL i045_sh('s')
         WHEN "noshenhe"                       
            CALL i045_sh('n')
         WHEN "removetravel"
            LET g_msg='ghri045a "$FGLRUN $GHRi/ghri045a" '
            CALL cl_cmdrun_wait(g_msg)
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
              IF g_hrce.hrce01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrce01"
                 LET g_doc.value1 = g_hrce.hrce01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrce),'','')
            END IF
         WHEN "generate_link" 
            CALL cl_generate_shortcut()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i045_a()   #gai                         # Add  輸入
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_hrce.* TO NULL
   CALL g_hrcea.clear()
   CALL g_hrceb.clear()
   CALL g_hrcec.clear()
 
   INITIALIZE g_hrce.hrce01 LIKE hrce_file.hrce01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrce.hrce03 = g_today
      LET g_hrce.hrce05 = g_today
      LET g_hrce.hrce09 = NULL 
      LET g_hrce.hrceacti = "Y"
      LET g_hrce.hrceuser = g_user
      LET g_hrce.hrcegrup = g_grup
      CALL i045_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN  
         INITIALIZE g_hrce.* TO NULL      
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
 
 
      IF g_ss='N' THEN
         INITIALIZE g_hrce.* TO NULL
      ELSE
         INSERT INTO hrce_file VALUES(g_hrce.*)
         CALL i045_b_fill('1=1')             # 單身
      END IF

      CALL i045_b()                          # 輸入單身
      LET g_hrce01_t=g_hrce.hrce01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i045_i(p_cmd)#gai                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   l_input      LIKE type_file.chr1
   DEFINE   l_s          VARCHAR(20)
   DEFINE   l_dd         VARCHAR(20)
   DEFINE   l_sql        STRING
   DEFINE   l_time       LIKE hrce_file.hrce07
   DEFINE   l_time1      LIKE type_file.num5
   DEFINE   l_cnt        LIKE type_file.num10
   
 
   LET g_ss = 'Y'

  DISPLAY   g_hrce.hrce02,g_hrce.hrce03,g_hrce.hrce04,g_hrce.hrce05,
            g_hrce.hrce06,g_hrce.hrce07,g_hrce.hrce08,g_hrce.hrce09,
            g_hrce.hrce10,g_hrce.hrce11,g_hrce.hrce12,g_hrce.hrce13,
            g_hrce.hrceacti,g_hrce.hrceuser,g_hrce.hrcegrup,
            g_hrce.hrcemodu,g_hrce.hrcedate,g_hrce.hrceoriu,g_hrce.hrceorig
       TO   hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,hrce09,hrce10,
            hrce11,hrce12,hrce13,hrceacti,hrceuser,hrcegrup,hrcemodu,hrcedate,hrceoriu,
            hrceorig

      CALL cl_set_head_visible("","YES")
 
   INPUT  g_hrce.hrce02,g_hrce.hrce03,g_hrce.hrce04,g_hrce.hrce05,
          g_hrce.hrce06,g_hrce.hrce07,g_hrce.hrce08,g_hrce.hrce09,
          g_hrce.hrce10,g_hrce.hrce11,g_hrce.hrce12,g_hrce.hrce13,
          g_hrce.hrceacti,g_hrce.hrceuser,g_hrce.hrcegrup,
          g_hrce.hrcemodu,g_hrce.hrcedate,g_hrce.hrceoriu,g_hrce.hrceorig
          WITHOUT DEFAULTS 
    FROM  hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,hrce09,hrce10,
          hrce11,hrce12,hrce13,hrceacti,hrceuser,hrcegrup,hrcemodu,hrcedate,hrceoriu,
          hrceorig
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i045_set_entry(p_cmd)
         CALL i045_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD hrce02
         IF g_hrce.hrce02 IS  NULL THEN
            NEXT FIELD hrce02
       ELSE 
            CALL i045_hrce02('a')
        END IF

      AFTER FIELD hrce04
         IF cl_null(g_hrce.hrce04) THEN
            NEXT FIELD hrce04
        END IF

      AFTER FIELD hrce03
         IF g_hrce.hrce03 IS NOT NULL THEN
            LET l_time = g_hrce.hrce03 - g_hrce.hrce05
             IF l_time > 0 THEN
               CALL cl_err('','ghr-102',1) 
               NEXT FIELD hrce05
        #   ELSE  
        #       LET l_time1= g_hrce.hrce04 - g_hrce.hrce06 
        #        IF l_time1 > 0 THEN 
        #           DISPLAY (l_time*24 + l_time1) TO hrce07
        #      ELSE 
        #           DISPLAY ((l_time-1)*24 + l_time1) TO hrce07
        #    END IF 
         END IF 
     END IF 
            
      AFTER FIELD hrce05
         IF g_hrce.hrce05 IS NOT NULL THEN
            LET l_time = g_hrce.hrce03 - g_hrce.hrce05
             IF l_time > 0 THEN
               CALL cl_err('','ghr-102',1) 
               NEXT FIELD hrce03
       #   ELSE  
       #        IF (NOT g_hrce.hrce03) AND (NOT g_hrce.hrce06) THEN
       #            LET l_time1= g_hrce.hrce04 - g_hrce.hrce06 
       #             IF l_time1 > 0 THEN 
       #                DISPLAY (l_time*24 + l_time1) TO hrce07
       #           ELSE 
       #                DISPLAY ((l_time-1)*24 + l_time1) TO hrce07
       #         END IF 
       #    END IF 
        END IF 
     END IF

    #  AFTER FIELD hrce06
    #     IF g_hrce.hrce06 IS NOT NULL THEN  
    #        LET l_time1= g_hrce.hrce04 - g_hrce.hrce06 
    #         IF l_time1 > 0 THEN 
    #            DISPLAY (l_time*24 + l_time1) TO hrce07
    #               NEXT FIELD hrce07
    #       ELSE 
    #            DISPLAY ((l_time-1)*24 + l_time1) TO hrce07
    #               NEXT FIELD hrce07
    #     END IF 
    # END IF 
     
      AFTER INPUT
         IF NOT cl_null(g_hrce.hrce01) THEN
            IF g_hrce.hrce01 != g_hrce01_t OR cl_null(g_hrce01_t) THEN
               SELECT COUNT(UNIQUE hrce01) INTO g_cnt FROM hrce_file
                WHERE hrce01 = g_hrce.hrce01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_hrce.hrce01,-239,0)
                     LET g_hrce.hrce01 = g_hrce01_t
                     NEXT FIELD hrce01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_hrce.hrce01,g_errno,0)
                  NEXT FIELD hrce02
               END IF
            END IF
         END IF
         
    IF p_cmd ='a' THEN 
       BEGIN WORK
       SELECT COUNT(*) INTO l_cnt FROM hrce_file
        WHERE hrce02 = g_hrce.hrce02
          AND hrce03 = g_hrce.hrce03
          AND hrce07 = g_hrce.hrce07
          AND hrce04 = g_hrce.hrce04
          AND hrce09 = g_hrce.hrce09
          AND hrce10 = g_hrce.hrce10
       IF l_cnt > 0 THEN 
          SELECT hrce01 INTO g_hrce.hrce01 FROM hrce_file
           WHERE hrce02 = g_hrce.hrce02
             AND hrce03 = g_hrce.hrce03
             AND hrce07 = g_hrce.hrce07
             AND hrce04 = g_hrce.hrce04
             AND hrce09 = g_hrce.hrce09
             AND hrce10 = g_hrce.hrce10
             CALL cl_err3("ins","hrce_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",1)
             COMMIT WORK 
       ELSE 
          SELECT to_char(max(hrce01)+1,'fm0000000000') INTO g_hrce.hrce01 FROM hrce_file 
       IF cl_null(g_hrce.hrce01) THEN
           	  LET g_hrce.hrce01 =  '0000000001'
       END IF
END IF 

          
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrce_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_hrce.hrce01,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF
    ELSE  
    END IF 

            IF g_hrce.hrce01 IS NULL THEN
               DISPLAY BY NAME g_hrce.hrce02
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrce02
            END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrce02)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrbm03"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1= g_hrce.hrce02
               CALL cl_create_qry() RETURNING g_hrce.hrce02
               NEXT FIELD hrce02
       OTHERWISE 
               EXIT CASE
     END CASE
 
      ON ACTION controlf                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

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
END FUNCTION
 
FUNCTION i045_hrce02(p_cmd) 

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04
   DEFINE l_hrbm06    LIKE hrbm_file.hrbm06
 
   LET g_errno=''
   SELECT hrbm04,hrbm06 INTO l_hrbm04,l_hrbm06 FROM hrbm_file
    WHERE hrbm03=g_hrce.hrce02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-072'
                                LET l_hrbm04=NULL
                                LET l_hrbm06=NULL 
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='a' OR cl_null(g_errno)THEN
      DISPLAY l_hrbm04 TO hrbm04
      DISPLAY l_hrbm06 TO hrce08
      LET g_hrce.hrce08 = l_hrbm06
   END IF
END FUNCTION

FUNCTION i045_u() #gai
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrce.hrce01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF


   SELECT * INTO g_hrce.* FROM hrce_file
    WHERE hrce01=g_hrce.hrce01        #刷新资料
 
   IF g_hrce.hrceacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrce.hrce01,'mfg1000',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrce01_t = g_hrce.hrce01
 
   BEGIN WORK
   
   OPEN i045_lock_u USING g_hrce.hrce01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i045_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH i045_lock_u INTO g_hrce_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrce01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i045_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   CALL i045_show()
 
   WHILE TRUE
      LET g_hrce01_t = g_hrce.hrce01
      LET g_hrce.hrcemodu=g_user
      LET g_hrce.hrcedate=g_today
      CALL i045_i("u")
      
      IF INT_FLAG THEN
         LET g_hrce.hrce01 = g_hrce01_t
         DISPLAY g_hrce.hrce01 TO hrce01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      
      UPDATE hrce_file SET hrce_file.* = g_hrce.*
       WHERE hrce01 = g_hrce01_t
       
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","hrce_file",g_hrce01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i045_lock_u
   COMMIT WORK
   CALL cl_flow_notify(g_hrce.hrce01,'U')
 
   CALL i045_b_fill("1=1")
END FUNCTION
 
FUNCTION i045_q()   #gai                         #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   INITIALIZE g_hrce.* TO NULL
   DISPLAY '' TO FORMONLY.cnt
   CALL i045_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i045_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_hrce.hrce01 TO NULL
      INITIALIZE g_hrcea[l_ac2].* TO NULL       
      INITIALIZE g_hrceb[l_ac1].* TO NULL
      INITIALIZE g_hrcec[l_ac3].* TO NULL
   ELSE
      OPEN i045_count
      FETCH i045_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i045_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i045_fetch(p_flag)#gai                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         #絕對的筆數   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02   #No.FUN-710055
      WHEN 'P' FETCH PREVIOUS i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02   #No.FUN-710055
      WHEN 'F' FETCH FIRST    i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
      WHEN 'L' FETCH LAST     i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrce.hrce01,SQLCA.sqlcode,0)
      INITIALIZE g_hrce.hrce01 TO NULL  #TQC-6B0105
      RETURN 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   
      SELECT * INTO g_hrce.* FROM hrce_file WHERE hrce01 = g_hrce.hrce01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrce_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_hrce.* TO NULL
      RETURN
   END IF
      CALL i045_show()

END FUNCTION
 
FUNCTION i045_show()#gai                         # 將資料顯示在畫面上
   DISPLAY BY NAME
            g_hrce.hrce02,g_hrce.hrce03,g_hrce.hrce04,g_hrce.hrce05,g_hrce.hrce06,
           g_hrce.hrce07,g_hrce.hrce08,g_hrce.hrce09,g_hrce.hrce10,g_hrce.hrce11,
           g_hrce.hrce12,g_hrce.hrce13,g_hrce.hrceconf,g_hrce.hrceacti 
      #  TO hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,
      #     hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti
   CALL i045_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i045_r()#gai        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt           LIKE type_file.num5,
            l_hrceconf      LIKE hrce_file.hrceconf,
            l_hrce          RECORD LIKE hrce_file.*
   DEFINE   l_hrce01        LIKE hrce_file.hrce01
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrce.hrce02) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   SELECT hrceconf,hrce01 INTO l_hrceconf,l_hrce01 FROM hrce_file 
    WHERE hrce02 = g_hrce.hrce02
      AND hrce03 = g_hrce.hrce03
      AND hrce04 = g_hrce.hrce04
      AND hrce07 = g_hrce.hrce07
      AND hrce09 = g_hrce.hrce09
      AND hrce10 = g_hrce.hrce10
   BEGIN WORK
     OPEN i045_lock_u USING l_hrce01
          IF STATUS THEN
             CALL cl_err("OPEN i045_lock_u:", STATUS, 0)
             CLOSE i045_lock_u
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i045_lock_u INTO g_hrce.*
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_hrce01,SQLCA.sqlcode,0)
                RETURN
            END IF
           CALL i045_show()
       IF cl_delh(0,0)THEN                   #確認一下
          LET g_doc.column1 = "hrce01"
          LET g_doc.value1 = g_hrce.hrce01
         CALL cl_del_doc()
         
           IF l_hrceconf = 'N' OR cl_null(l_hrceconf)THEN 
              DELETE FROM hrce_file
              WHERE hrce01 = l_hrce01
      
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrce_file",l_hrce01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
              ELSE
                 DELETE FROM hrceb_file
                  WHERE hrceb01= l_hrce01
                 DELETE FROM hrcea_file
                  WHERE hrcea01= l_hrce01
                 DELETE FROM hrcec_file
                  WHERE hrcec01= l_hrce01
              
                  CLEAR FORM
                   CALL g_hrceb.clear()
                   CALL g_hrcea.clear()
                   CALL g_hrcec.clear()
               
             INITIALIZE g_hrce.* TO NULL
                   OPEN i045_count
                     IF STATUS THEN
                        CLOSE i045_lock_u
                        CLOSE i045_count
                        COMMIT WORK
                        RETURN
                     END IF
                  FETCH i045_count INTO g_row_count
                     IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                        CLOSE i045_lock_u
                        CLOSE i045_count
                        COMMIT WORK
                        RETURN
                     END IF
                DISPLAY g_row_count TO FORMONLY.cnt
                   OPEN i045_b_curs
                     IF g_curs_index = g_row_count + 1 THEN
                        LET g_jump = g_row_count
                        CALL i045_fetch('L')
                     ELSE
                        LET g_jump = g_curs_index
                        LET g_no_ask = TRUE           #No.FUN-6A0080
                        CALL i045_fetch('/')
                     END IF
              END IF
           ELSE 
                CALL cl_err('','ghr-103',1)
                COMMIT WORK 
          END IF 
   END IF
   CLOSE i045_lock_u
   COMMIT WORK
END FUNCTION
 
FUNCTION i045_b()#gai                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,               # FUN-7B0081
            l_hrceconf      LIKE hrce_file.hrceconf,
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5                #FUN-680135    SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   li_i            LIKE type_file.num5                # 暫存用數值   # No:FUN-BA0116
   DEFINE   lc_target       LIKE gay_file.gay01                # No:FUN-BA0116
   DEFINE   l_aa            varchar(20)
   DEFINE   l_bb            varchar(20)
   DEFINE   l_cc            varchar(20)
   DEFINE   l_ss            varchar(20)
   DEFINE   l_sql           STRING

 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrce.hrce01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   LET g_forupd_sql= "SELECT hrceb01,hrceb02,hrceb03,hrceb04,hrceb05,hrceb06 ",
                      " FROM hrceb_file ",
                      "  WHERE hrceb01 = ? AND hrceb02 = ?  ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl1 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql =  "SELECT hrcea01,hrcea02,hrcea03,hrcea04,hrcea05,hrcea06,",
                        "hrcea07,hrcea08,hrcea09,hrcea10,hrcea11,hrcea12",
                        " FROM hrcea_file ",
                        "  WHERE hrcea01 = ? AND hrcea02 = ?  ",
                        " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,",
                       "hrcec07,hrcec08,hrcec09,hrcec10,hrcec11,hrcec12",
                       "hrcec13,hrcec14,hrcec15,hrcec16",
                       " FROM hrcec_file ",
                       "  WHERE hrcec01 = ? AND hrcec02 = ?  ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   LET l_ac_t = 0

    DIALOG ATTRIBUTES(UNBUFFERED)
    
        INPUT ARRAY g_hrceb FROM s_hrceb.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac1)
           END IF 
         
        BEFORE ROW
         LET p_cmd=''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
          IF g_rec_b1 >= l_ac1 THEN
             BEGIN WORK 
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
              CALL i045_set_entry(p_cmd)                                       
              CALL i045_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE  
               LET g_hrceb_t.* = g_hrceb[l_ac1].*    #BACKUP
            
          OPEN i045_bcl1 USING g_hrceb_t.hrceb01,g_hrceb_t.hrceb02
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl1:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl1 INTO g_hrceb[l_ac1].hrceb01,g_hrceb[l_ac1].hrceb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrceb_t.hrceb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE
          CALL i045_set_entry(p_cmd)
          CALL i045_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
    INITIALIZE g_hrceb[l_ac1].* TO NULL
           LET g_hrceb_t.* = g_hrceb[l_ac1].*
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD hrceb03

        AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
          CLOSE i045_bcl1
            CANCEL INSERT
         END IF
         BEGIN WORK
               SELECT max(hrceb02) INTO l_ss FROM hrceb_file 
                  LET  l_sql =  " SELECT max(hrceb02) 
                                  FROM hrceb_file
                                  WHERE hrceb02 like '",l_ss,"%'"
              PREPARE l_preb FROM l_sql
              DECLARE l_sql_csb SCROLL CURSOR FOR l_preb 
                 OPEN l_sql_csb 
                FETCH l_sql_csb INTO l_bb
                CLOSE l_sql_csb
 
                   IF l_bb IS NULL THEN        
                      LET l_bb='1'
                   ELSE
                      LET l_bb=l_bb+1
               END IF
                  LET g_hrceb[l_ac1].hrceb01=g_hrce.hrce01
                  LET g_hrceb[l_ac1].hrceb02=l_bb  
         INSERT INTO hrceb_file(hrceb01,hrceb02,hrceb03,hrceb04,hrceb05,hrceb06)
                      VALUES (g_hrce.hrce01,g_hrceb[l_ac1].hrceb02,g_hrceb[l_ac1].hrceb03,
                              g_hrceb[l_ac1].hrceb04,g_hrceb[l_ac1].hrceb05,g_hrceb[l_ac1].hrceb06)

         IF SQLCA.sqlcode THEN
            ROLLBACK WORK
            CALL cl_err3("ins","hrce_file",g_hrce.hrce01,g_hrceb[l_ac1].hrceb02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1 = g_rec_b1 + 1
            DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF

      AFTER FIELD hrceb03
         IF NOT cl_null(g_hrceb[l_ac1].hrceb03) THEN
            SELECT COUNT(*) INTO l_n FROM hrceb_file
             WHERE hrceb03 = g_hrceb[l_ac1].hrceb03
               AND hrceb04 = g_hrceb[l_ac1].hrceb04
               AND hrceb05 = g_hrceb[l_ac1].hrceb05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrceb[l_ac1].hrceb03,-239,0)
                  LET g_hrceb[l_ac1].hrceb03 = g_hrceb_t.hrceb03
                  NEXT FIELD hrceb03
              END IF
        END IF

      AFTER FIELD hrceb04
         IF NOT cl_null(g_hrceb[l_ac1].hrceb04) THEN
            SELECT COUNT(*) INTO l_n FROM hrceb_file
             WHERE hrceb03 = g_hrceb[l_ac1].hrceb03
               AND hrceb04 = g_hrceb[l_ac1].hrceb04
               AND hrceb05 = g_hrceb[l_ac1].hrceb05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrceb[l_ac1].hrceb04,-239,0)
                  LET g_hrceb[l_ac1].hrceb04 = g_hrceb_t.hrceb04
                  NEXT FIELD hrceb04
              END IF
           END IF
 
      AFTER FIELD hrceb05
         IF NOT cl_null(g_hrceb[l_ac1].hrceb05) THEN
            SELECT COUNT(*) INTO l_n FROM hrceb_file
             WHERE hrceb03 = g_hrceb[l_ac1].hrceb03
               AND hrceb04 = g_hrceb[l_ac1].hrceb04
               AND hrceb05 = g_hrceb[l_ac1].hrceb05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrceb[l_ac1].hrceb05,-239,0)
                  LET g_hrceb[l_ac1].hrceb05 = g_hrceb_t.hrceb05
                  NEXT FIELD hrceb05
              END IF
           END IF 

    
     BEFORE DELETE 
         IF NOT cl_null(g_hrceb_t.hrceb02) THEN
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrceb_t.hrceb01
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
                CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                      #No.130614
            LET g_doc.column1 = "hrceb01"                   #No.130614
                LET g_doc.value1 = g_hrceb[l_ac1].hrceb01   #No.130614
                CALL cl_del_doc() 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrceb_file WHERE hrceb01 = g_hrceb_t.hrceb01
                                     AND hrceb02 = g_hrceb_t.hrceb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrceb_file",g_hrceb_t.hrceb01,g_hrceb_t.hrceb02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               CANCEL DELETE
            END IF 
            LET g_rec_b1 = g_rec_b1 - 1
        DISPLAY g_rec_b1 TO FORMONLY.cn2
         COMMIT WORK
     END IF
         MESSAGE 'DELETE O.K'

     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrceb[l_ac1].* = g_hrceb_t.*
          CLOSE i045_bcl1
                ROLLBACK WORK
                EXIT DIALOG
        END IF 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrceb[l_ac1].hrceb02,-263,1)
            LET g_hrceb[l_ac1].* = g_hrceb_t.*
         ELSE 
            UPDATE hrceb_file
               SET hrceb01 = g_hrceb[l_ac1].hrceb01,
                   hrceb02 = g_hrceb[l_ac1].hrceb02,
                   hrceb03 = g_hrceb[l_ac1].hrceb03,
                   hrceb04 = g_hrceb[l_ac1].hrceb04,
                   hrceb05 = g_hrceb[l_ac1].hrceb05,
                   hrceb06 = g_hrceb[l_ac1].hrceb06
             WHERE hrceb01 = g_hrceb_t.hrceb01
               AND hrceb02 = g_hrceb_t.hrceb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrceb_file",g_hrceb[l_ac1].hrceb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrceb[l_ac1].* = g_hrceb_t.*
            ELSE 
               MESSAGE 'UPDATE O.K'
                COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac1 = ARR_CURR()

          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrceb[l_ac1].* = g_hrceb_t.*
               END IF 
             CLOSE i045_bcl1
             ROLLBACK WORK
             EXIT DIALOG
         END IF
         CLOSE i045_bcl1
         COMMIT WORK

      AFTER INPUT 
         IF cl_null(g_hrceb[l_ac1].hrceb01) THEN 
      # CALL cl_err('','cxm-013',1) #NO.130617
            CONTINUE DIALOG
        END IF  

      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac1 > 1 THEN
            LET g_hrceb[l_ac1].* = g_hrceb[l_ac1-1].*
            NEXT FIELD hrceb02
         END IF

      ON ACTION controlp
         CASE
           WHEN INFIELD(hrceb03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat03"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb03
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb03 
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb03
              NEXT FIELD hrceb03
              
           WHEN INFIELD(hrceb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat03"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb04
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb04
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb04
              NEXT FIELD hrceb04

           WHEN INFIELD(hrceb05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb05
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb05
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb05
              NEXT FIELD hrceb05
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                   
         CALL cl_set_head_visible("","AUTO") 
         
   END INPUT
         
   INPUT ARRAY g_hrcea FROM s_hrcea.*
              ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
          CALL fgl_set_arr_curr(l_ac2)
           END IF

        BEFORE ROW
           LET p_cmd=''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'              #DEFAULT
           LET l_n  = ARR_COUNT()
            IF g_rec_b2 >= l_ac2 THEN
            BEGIN WORK 
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                  
           CALL i045_set_entry(p_cmd)                                       
           CALL i045_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE 
            LET g_hrcea_t.* = g_hrcea[l_ac2].*    #BACKUP
            
            OPEN i045_bcl2 USING g_hrcea_t.hrcea01,g_hrcea_t.hrcea02
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl2:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl2 INTO g_hrcea[l_ac2].hrcea01,g_hrcea[l_ac2].hrcea02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcea_t.hrcea01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                  
        CALL i045_set_entry(p_cmd)                                       
        CALL i045_set_no_entry(p_cmd)                                    
         LET g_before_input_done = TRUE 
         INITIALIZE g_hrcea[l_ac2].* TO NULL       #900423
         LET g_hrcea_t.* = g_hrcea[l_ac2].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcea03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         BEGIN WORK
               SELECT max(hrcea02) INTO l_ss FROM hrceb_file 
                  LET  l_sql =  " SELECT max(hrceb02) 
                                  FROM hrceb_file
                                WHERE hrceb02 like '",l_ss,"%'"
              PREPARE l_prea FROM l_sql
              DECLARE l_sql_csa SCROLL CURSOR FOR l_prea 
                 OPEN l_sql_csa 
                FETCH l_sql_csa INTO l_aa
                CLOSE l_sql_csa
 
                   IF l_aa IS NULL THEN        
                      LET l_aa='1'
                   ELSE
                      LET l_aa=l_aa+1
               END IF
                  LET g_hrcea[l_ac2].hrcea01=g_hrce.hrce01
                  LET g_hrcea[l_ac2].hrcea02=l_aa
          INSERT INTO hrcea_file(hrcea01,hrcea02,hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,
                                 hrcea08,hrcea09,hrcea10,hrcea11,hrcea12,hrcea13)
               VALUES (g_hrce.hrce01,g_hrcea[l_ac2].hrcea02,g_hrcea[l_ac2].hrcea03,
                       g_hrcea[l_ac2].hrcea04,g_hrcea[l_ac2].hrcea05,g_hrcea[l_ac2].hrcea06,
                       g_hrcea[l_ac2].hrcea07,g_hrcea[l_ac2].hrcea08,g_hrcea[l_ac2].hrcea09,
                       g_hrcea[l_ac2].hrcea10,g_hrcea[l_ac2].hrcea11,g_hrcea[l_ac2].hrcea12,
                       g_hrcea[l_ac2].hrcea13)
         IF SQLCA.sqlcode THEN
            ROLLBACK WORK
            CALL cl_err3("ins","hrcea_file",g_hrcea[l_ac2].hrcea01,g_hrcea[l_ac2].hrcea02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b2 = g_rec_b2 + 1
        DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF 

      AFTER FIELD hrcea05
         IF NOT cl_null(g_hrcea[l_ac2].hrcea05) THEN
            SELECT COUNT(*) INTO l_n FROM hrcea_file
             WHERE hrcea05 = g_hrcea[l_ac2].hrcea05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrcea[l_ac2].hrcea05,-239,0)
                  LET g_hrcea[l_ac2].hrcea05 = g_hrcea_t.hrcea05
                  NEXT FIELD hrcea05
              END IF
           END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_hrcea_t.hrcea02) THEN
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrcea_t.hrcea01
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL               #No.130614
            LET g_doc.column1 = "hrcea01"               
            LET g_doc.value1 = g_hrcea[l_ac2].hrcea01     
            CALL cl_del_doc()
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrcea_file WHERE hrcea01 = g_hrcea[l_ac2].hrcea01
                                     AND hrcea02 = g_hrcea[l_ac2].hrcea02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcea_file",g_hrcea_t.hrcea01,g_hrcea_t.hrcea02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               CANCEL DELETE
            END IF 
            LET g_rec_b2 = g_rec_b2 - 1
        DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF
         MESSAGE 'DELETE O.K'

      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcea[l_ac2].* = g_hrcea_t.*
            CLOSE i045_bcl2
            ROLLBACK WORK
            EXIT DIALOG
         END IF      
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcea[l_ac2].hrcea02,-263,1)
            LET g_hrcea[l_ac2].* = g_hrcea_t.*
         ELSE 
            UPDATE hrcea_file
               SET hrcea01 = g_hrcea[l_ac2].hrcea01,
                   hrcea02 = g_hrcea[l_ac2].hrcea02,
                   hrcea03 = g_hrcea[l_ac2].hrcea03,
                   hrcea04 = g_hrcea[l_ac2].hrcea04,
                   hrcea05 = g_hrcea[l_ac2].hrcea05,
                   hrcea06 = g_hrcea[l_ac2].hrcea06,
                   hrcea07 = g_hrcea[l_ac2].hrcea07,
                   hrcea08 = g_hrcea[l_ac2].hrcea08,
                   hrcea09 = g_hrcea[l_ac2].hrcea09,
                   hrcea10 = g_hrcea[l_ac2].hrcea10,
                   hrcea11 = g_hrcea[l_ac2].hrcea11,
                   hrcea12 = g_hrcea[l_ac2].hrcea12,
                   hrcea13 = g_hrcea[l_ac2].hrcea13
             WHERE hrcea01 = g_hrcea_t.hrcea01
               AND hrcea02 = g_hrcea_t.hrcea02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcea_file",g_hrcea[l_ac2].hrcea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrcea[l_ac2].* = g_hrcea_t.*
            ELSE 
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         
      AFTER ROW
         LET l_ac2 = ARR_CURR()
  #       LET l_ac_t = l_ac2
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrcea[l_ac2].* = g_hrcea_t.*
               END IF 
               CLOSE i045_bcl2
               ROLLBACK WORK
               EXIT DIALOG
          END IF
          CLOSE i045_bcl2
          COMMIT WORK

      AFTER INPUT 
         IF cl_null(g_hrcea[l_ac2].hrcea01) THEN 
      # CALL cl_err('','cxm-013',1)  #NO.130617
            CONTINUE DIALOG
        END IF 
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac2 > 1 THEN
            LET g_hrcea[l_ac2].* = g_hrcea[l_ac2-1].*
            NEXT FIELD hrcea02
         END IF
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 

END INPUT
    
   INPUT ARRAY g_hrcec FROM s_hrcec.*
              ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT                   
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
      
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b3 >= l_ac3 THEN
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                  
            CALL i045_set_entry(p_cmd)                                       
            CALL i045_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE 
            LET g_hrcec_t.* = g_hrcec[l_ac3].*    #BACKUP
            
            OPEN i045_bcl3 USING g_hrcec_t.hrcec01,g_hrcec_t.hrcec02
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl3:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl3 INTO g_hrcec[l_ac3].hrcec01,g_hrcec[l_ac3].hrcec02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcec_t.hrcec01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE
         CALL i045_set_entry(p_cmd)
         CALL i045_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         INITIALIZE g_hrcec[l_ac3].* TO NULL
         LET g_hrcec_t.* = g_hrcec[l_ac3].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcec03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         BEGIN WORK
          SELECT max(hrcec02) INTO l_ss FROM hrcec_file 
             LET  l_sql =  " SELECT max(hrcec02) 
                             FROM hrcec_file
                             WHERE hrcec02 like '",l_ss,"%'"
         PREPARE l_prec FROM l_sql
         DECLARE l_sql_csc SCROLL CURSOR FOR l_prec 
            OPEN l_sql_csc 
           FETCH l_sql_csc INTO l_cc
           CLOSE l_sql_csc
              IF  l_cc IS NULL THEN        
                  LET l_cc='1'
              ELSE
                  LET l_cc=l_cc+1
              END IF
             LET g_hrcec[l_ac1].hrcec01=g_hrce.hrce01
             LET g_hrcec[l_ac1].hrcec02=l_cc
              
          INSERT INTO hrcec_file(hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,
                                 hrcec07,hrcec08,hrcec09,hrcec10,hrcec11,hrcec12,
                                 hrcec13,hrcec14,hrcec15,hrcec16)
               VALUES (g_hrce.hrce01,g_hrcec[l_ac3].hrcec02,g_hrce02,
                       g_hrceb[l_ac1].hrceb03,g_hrce03,g_hrce04,
                       g_hrce05,g_hrce06,g_hrce07,g_hrce08,
                       g_hrcec[l_ac3].hrcec11,g_hrcec[l_ac3].hrcec12,g_hrcec[l_ac3].hrcec13,
                       g_hrcec[l_ac3].hrcec14,g_hrcec[l_ac3].hrcec15,g_hrcec[l_ac3].hrcec16)
         IF SQLCA.sqlcode THEN
            ROLLBACK WORK
            CALL cl_err3("ins","hrce_file",g_hrcec[l_ac3].hrcec01,g_hrcec[l_ac3].hrcec02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b3 = g_rec_b3 + 1
            DISPLAY g_rec_b3 TO FORMONLY.cn2
         END IF
         
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_hrcec_t.hrcec02) THEN
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrcec_t.hrcec01
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL               #  No.130614
            LET g_doc.column1 = "hrcec01"               
            LET g_doc.value1 = g_hrcec[l_ac3].hrcec01   
            CALL cl_del_doc()
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrcec_file WHERE hrcec01 = g_hrcec[l_ac3].hrcec01
                                     AND hrcec02 = g_hrcec[l_ac3].hrcec02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcec_file",g_hrcec_t.hrcec01,g_hrcec_t.hrcec02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               CANCEL DELETE
            END IF 
            LET g_rec_b3 = g_rec_b3 - 1
        DISPLAY g_rec_b3 TO FORMONLY.cn2
         END IF
         MESSAGE 'DELETE O.K'
         
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcec[l_ac3].* = g_hrcec_t.*
            CLOSE i045_bcl3
            ROLLBACK WORK
            EXIT DIALOG
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcec[l_ac3].hrcec02,-263,1)
            LET g_hrcec[l_ac3].* = g_hrcec_t.*
         ELSE 
            UPDATE hrcec_file
               SET hrcec01 = g_hrcec[l_ac3].hrcec01,
                   hrcec02 = g_hrcec[l_ac3].hrcec02,
                   hrcec03 = g_hrcec[l_ac3].hrcec03,
                   hrcec04 = g_hrcec[l_ac3].hrcec04,
                   hrcec05 = g_hrcec[l_ac3].hrcec05,
                   hrcec06 = g_hrcec[l_ac3].hrcec06,
                   hrcec07 = g_hrcec[l_ac3].hrcec07,
                   hrcec08 = g_hrcec[l_ac3].hrcec08,
                   hrcec09 = g_hrcec[l_ac3].hrcec09,
                   hrcec10 = g_hrcec[l_ac3].hrcec10,
                   hrcec11 = g_hrcec[l_ac3].hrcec11,
                   hrcec12 = g_hrcec[l_ac3].hrcec12,
                   hrcec13 = g_hrcec[l_ac3].hrcec13,
                   hrcec14 = g_hrcec[l_ac3].hrcec14,
                   hrcec15 = g_hrcec[l_ac3].hrcec15,
                   hrcec16 = g_hrcec[l_ac3].hrcec16
             WHERE hrcec01 = g_hrcec_t.hrcec01
               AND hrcec02 = g_hrcec_t.hrcec02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcec_file",g_hrcec_t.hrcec01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrcec[l_ac3].* = g_hrcec_t.*
          ELSE 
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         
      AFTER ROW
         LET l_ac3 = ARR_CURR()
      #   LET l_ac_t = l_ac3
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrcec[l_ac3].* = g_hrcec_t.*
              END IF 
            CLOSE i045_bcl3
            ROLLBACK WORK
            EXIT DIALOG
         END IF
         CLOSE i045_bcl3
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac3 > 1 THEN
            LET g_hrcec[l_ac3].* = g_hrcec[l_ac3-1].*
            NEXT FIELD hrcec02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 
END INPUT 
    
       # BEFORE DIALOG
       # 
       #   OPEN i045_lock_u USING g_hrce.hrce01
       #     IF STATUS THEN 
       #        CALL cl_err("ONPEN i045_lock_u:",STATUS,0)
       #        LET INT_FLAG = 1
       #        EXIT DIALOG
       #    END IF   
       #  FETCH i045_lock_u INTO g_hrce.*
       #     IF SQLCA.sqlcode THEN 
       #        CALL cl_err("fetch i045_lock_u:",SQLCA.sqlcode,0)
       #        LET INT_FLAG = 1
       #        EXIT DIALOG
       #    END IF 
            
        
        
        ON ACTION accept 
           ACCEPT DIALOG
           
        ON ACTION cancel
           LET INT_FLAG = 1
           EXIT DIALOG 
           
        ON ACTION controlg
           CALL cl_cmdask()
        
        ON ACTION about         
         CALL cl_about()
         
        ON ACTION help         
         CALL cl_show_help()
         
END DIALOG
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE i045_lock_u  
       RETURN 
    END IF
    
    CLOSE i045_lock_u 
    
    CLOSE i045_bcl1
    CLOSE i045_bcl2
    CLOSE i045_bcl3
    COMMIT WORK
END FUNCTION
 
FUNCTION i045_b_fill(p_wc)   #gai   youwenti         #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)
 
     CALL i045_hrceb(g_hrce.hrce01,p_wc)
     CALL i045_hrcea(g_hrce.hrce01,p_wc)
     CALL i045_hrcec(g_hrce.hrce01,p_wc)

END FUNCTION

FUNCTION i045_hrceb(l_hrceb01,p_wc)
    DEFINE  p_wc         STRING
    DEFINE  l_hrceb01    LIKE hrceb_file.hrceb01

    IF cl_null(l_hrceb01) THEN 
       RETURN 
    END IF

    LET g_sql1 = "SELECT hrceb01,hrceb02,hrceb03,hrceb04,hrceb05,hrceb06 ",
                 " FROM hrceb_file ",
                " WHERE hrceb01 = '", l_hrceb01 CLIPPED,"' ",
               #   " AND ",p_wc CLIPPED,   #NO.130617
                " ORDER BY hrceb01,hrceb02"
    PREPARE i045_prepare2 FROM g_sql1           #預備一下
    DECLARE hrceb_curs CURSOR FOR i045_prepare2

    CALL g_hrceb.clear()

    LET g_cnt = 1
    LET g_rec_b1 = 0
    
    FOREACH hrceb_curs INTO g_hrceb[g_cnt].*
        LET g_rec_b1 = g_rec_b1 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
    END FOREACH 
    CALL g_hrceb.deleteElement(g_cnt)
    
   LET g_rec_b1 = g_cnt - 1
   IF INFIELD(hrceb) THEN
      DISPLAY NULL TO FORMONLY.cn2
      DISPLAY g_rec_b1 TO FORMONLY.cn2
   END IF  
   LET g_cnt = 0
   
END FUNCTION 

FUNCTION i045_hrcea(l_hrcea01,p_wc)
    DEFINE  p_wc         STRING
    DEFINE  l_hrcea01    LIKE hrcea_file.hrcea01
    
      CALL g_hrcea.clear()

        IF cl_null(l_hrcea01) THEN 
           RETURN 
        END IF

    LET g_sql2 = "SELECT hrcea01,hrcea02,hrcea03,hrcea04,hrcea05,hrcea06,",
                "hrcea07,hrcea08,hrcea09,hrcea10,hrcea11,hrcea12",
                 " FROM hrcea_file ",
                " WHERE hrcea01 = '",l_hrcea01 CLIPPED,"' ",
               #   " AND ",p_wc CLIPPED,     #NO.130617
                " ORDER BY hrcea01,hrcea02"
 
    PREPARE i045_prepare3 FROM g_sql2           #預備一下
    DECLARE hrcea_curs CURSOR FOR i045_prepare3

        LET g_cnt0 = 1
        LET g_rec_b2 = 0

    FOREACH hrcea_curs INTO g_hrcea[g_cnt0].*       #單身 ARRAY 填充
        LET g_rec_b2 = g_rec_b2 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        LET g_cnt0 = g_cnt0 + 1
         IF g_cnt0 > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
    END FOREACH
    CALL g_hrcea.deleteElement(g_cnt0) 
     LET g_rec_b2 = g_cnt0 - 1

      IF INFIELD(hrcea) THEN
         DISPLAY NULL TO FORMONLY.cn2
         DISPLAY g_rec_b2 TO FORMONLY.cn2
      END IF
     LET g_cnt0 = 0
      
END FUNCTION 

FUNCTION i045_hrcec(l_hrcec01,p_wc)
    DEFINE  p_wc         STRING
    DEFINE  l_hrcec01    LIKE hrcec_file.hrcec01
    
      CALL g_hrcec.clear()

        IF cl_null(l_hrcec01) THEN 
           RETURN 
        END IF

    LET g_sql3 = "SELECT hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,",
                "hrcec07,hrcec08,hrcec09,hrcec10,hrcec15,hrcec16",
                 " FROM hrcec_file ",
                " WHERE hrcec01 = '",l_hrcec01 CLIPPED,"' ",
             #     " AND ",p_wc CLIPPED,        	#NO.130617
                " ORDER BY hrcec01,hrcec02"
 
    PREPARE i045_prepare4 FROM g_sql3           #預備一下
    DECLARE hrcec_curs CURSOR FOR i045_prepare4

        LET g_cnt1 = 1
        LET g_rec_b3 = 0
    
    FOREACH hrcec_curs INTO g_hrcec[g_cnt1].*       #單身 ARRAY 填充
        LET g_rec_b3 = g_rec_b3 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_cnt1 = g_cnt1 + 1
          IF g_cnt1 > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
    END FOREACH
    CALL g_hrcec.deleteElement(g_cnt1) 
     LET g_rec_b3 = g_cnt1 - 1

      IF INFIELD(hrcea) THEN
         DISPLAY NULL TO FORMONLY.cn2
         DISPLAY g_rec_b3 TO FORMONLY.cn2
      END IF
      LET g_cnt1 = 0
    
END FUNCTION 
 
FUNCTION i045_bp(p_ud)#gai
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b1)
   CALL SET_COUNT(g_rec_b2)
   CALL SET_COUNT(g_rec_b3)

   DIALOG ATTRIBUTES(UNBUFFERED)
   
      DISPLAY ARRAY g_hrceb TO s_hrceb.* ATTRIBUTE(COUNT=g_rec_b1)
      
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)

        BEFORE ROW 
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
      END DISPLAY 
              
   DISPLAY ARRAY g_hrcea TO s_hrcea.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        BEFORE ROW 
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
        END DISPLAY 
           
   DISPLAY ARRAY g_hrcec TO s_hrcec.* ATTRIBUTE(COUNT=g_rec_b3)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        BEFORE ROW 
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
        END DISPLAY 

         BEFORE DIALOG
         IF NOT cl_null(g_hrce.hrce01) THEN 
            CALL i045_show()
         END IF 
      
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DIALOG
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DIALOG
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DIALOG
 
 #     ON ACTION reproduce                        # C.複製
 #        LET g_action_choice='reproduce'
 #        EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DIALOG
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         EXIT DIALOG
 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION first                            # 第一筆
         CALL i045_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DIALOG                  #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL i045_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         CONTINUE DIALOG                  #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL i045_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL i045_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL i045_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DIALOG
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DIALOG 
 
      ON ACTION close 
         LET INT_FLAG=FALSE
         LET g_action_choice='exit'
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION related_document
           LET g_action_choice="related_document"
         EXIT DIALOG

      ON ACTION generate_link
           LET g_action_choice="generate_link"
         EXIT DIALOG
         
      ON ACTION shenhe
         LET g_action_choice="shenhe"
         EXIT DIALOG

      ON ACTION noshenhe
         LET g_action_choice="noshenhe"
         EXIT DIALOG

      ON ACTION removetravel
         LET g_action_choice="removetravel"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      AFTER DIALOG
         CONTINUE DIALOG
                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                          
 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i045_sh(p_flhrce)#gai
   DEFINE p_flhrce     LIKE type_file.chr1

    IF g_hrce.hrce01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF


    CASE  p_flhrce
        WHEN's'  LET  p_flhrce = 's'
        WHEN'n'  LET  p_flhrce = 'n'
    END CASE

    CASE  p_flhrce
    WHEN's'

    IF g_hrce.hrceconf = 'Y' THEN
        CALL cl_err('',9023,0)
        RETURN
    END IF

IF  cl_confirm('aap-222') THEN
                           IF g_hrce.hrceconf = 'N' THEN
                          LET  g_hrce.hrceconf = 'Y'
                          END IF
                       UPDATE hrce_file
                          SET hrceconf = 'Y'
                        WHERE hrce01 = g_hrce.hrce01
    END IF

     WHEN'n'

    IF g_hrce.hrceconf = 'N' THEN
        CALL cl_err('',9025,0)
        RETURN
    END IF

IF  cl_confirm('aap-224') THEN
                           IF g_hrce.hrceconf = 'Y' THEN
                          LET g_hrce.hrceconf = 'N'
                          END IF
                       UPDATE hrce_file
                          SET hrceconf = 'N'
                        WHERE hrce01 = g_hrce.hrce01
    END IF
    END CASE



        DISPLAY BY NAME g_hrce.hrceconf

        CALL i045_show()

END FUNCTION

PRIVATE FUNCTION i045_set_entry(p_cmd)#gai
DEFINE   p_cmd     LIKE type_file.chr1
        IF p_cmd = 'u' THEN
        CALL cl_set_comp_entry("hrceb03,hrceb04,hrceb05,hrceb06",TRUE)
        CALL cl_set_comp_entry("hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,hrcea08",TRUE)
        CALL cl_set_comp_entry("hrcea09,hrcea10,hrcea11,hrcea12,hrcea13,hrcec15",TRUE)
        END IF 
        
        IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("hrceb03,hrceb04,hrceb05,hrceb06",TRUE)
        CALL cl_set_comp_entry("hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,hrcea08",TRUE)
        CALL cl_set_comp_entry("hrcea09,hrcea10,hrcea11,hrcea12,hrcea13,hrcec15",TRUE)
        END IF 
        
END FUNCTION

PRIVATE FUNCTION i045_set_no_entry(p_cmd)#gai
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN 
       CALL cl_set_comp_entry("hrceb01,hrceb02,hrcea01,hrcea02,hrcec01,hrcec02",FALSE)
       CALL cl_set_comp_entry("hrcec03,hrcec04,hrcec05,hrcec06,hrcec07,hrcec08",FALSE)
       CALL cl_set_comp_entry("hrcec09,hrcec10,hrcec11,hrcec12,hrcec13,hrcec14,hrcec16",FALSE)
   END IF 
       
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("hrceb01,hrceb02,hrcea01,hrcea02,hrcec01,hrcec02",FALSE)
       CALL cl_set_comp_entry("hrcec03,hrcec04,hrcec05,hrcec06,hrcec07,hrcec08",FALSE)
       CALL cl_set_comp_entry("hrcec09,hrcec10,hrcec11,hrcec12,hrcec13,hrcec14,hrcec16",FALSE)
   END IF 

END FUNCTION

