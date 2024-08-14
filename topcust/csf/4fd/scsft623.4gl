# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program code...: cect324.4gl
# Program name...: Run Card完工入庫維護作業
# Modify.........: Modify By Carol:領料單如有輸入單號別則自動產生一張領料單
#                                  無須領料單先建立單頭再由K.領料產生insert單身
# Modify.........: Modify By Carol:1999/04/14 完工入庫數量check最小套數數量
# Modify.........: 99/08/18 By Carol:工單完工時未使用消秏性料件則不可產生領料單
# Modify.........: No:7695 03/07/31 Carol 程式第733行


DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036    #NO.FUN-9B0016
DEFINE l_i       LIKE type_file.num5   #No.FUN-860045
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE l_fac     LIKE img_file.img34   #No.FUN-860045
#
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
#模組變數(Module Variables)
DEFINE
    g_sfu   RECORD LIKE sfu_file.*,
    g_sfb   RECORD LIKE sfb_file.*,
    g_sfu_t RECORD LIKE sfu_file.*,
    g_sfu_o RECORD LIKE sfu_file.*,
    g_yy,g_mm       LIKE type_file.num5,        #No.FUN-680121 SMALLINT,              #
    b_sfv           RECORD LIKE sfv_file.*,
    g_ima           RECORD LIKE ima_file.*,     #-No.MOD-530603
    g_sfv16         LIKE sfv_file.sfv16,        #-No.MOD-530603
    g_ima86         LIKE ima_file.ima86,
    g_img09         LIKE img_file.img09,
    g_img10         LIKE img_file.img10,
    g_ima571        LIKE ima_file.ima571,
    g_min_set       LIKE sfb_file.sfb08,
    g_over_qty      LIKE sfb_file.sfb08,
    g_sfv    DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
             sfv03     LIKE sfv_file.sfv03,
             sfv17     LIKE sfv_file.sfv17,    #FUN-550012
             sfv20     LIKE sfv_file.sfv20,
             sfv11     LIKE sfv_file.sfv11,
             #FUN-BC0104---add---str
             sfv46     LIKE sfv_file.sfv46,
             qcl02     LIKE qcl_file.qcl02,
             sfv47     LIKE sfv_file.sfv47,
             #FUN-BC0104---add---end
             sfv04     LIKE sfv_file.sfv04,
             ima02     LIKE ima_file.ima02,
             ima021    LIKE ima_file.ima021,
             sfv08     LIKE sfv_file.sfv08,
             sfv05     LIKE sfv_file.sfv05,
             sfv06     LIKE sfv_file.sfv06,
             sfv07     LIKE sfv_file.sfv07,
             sfv09     LIKE sfv_file.sfv09,
             sfv33     LIKE sfv_file.sfv33,
             sfv34     LIKE sfv_file.sfv34,
             sfv35     LIKE sfv_file.sfv35,
             sfv30     LIKE sfv_file.sfv30,
             sfv31     LIKE sfv_file.sfv31,
             sfv32     LIKE sfv_file.sfv32,
             sfv41     LIKE sfv_file.sfv41,
             sfv42     LIKE sfv_file.sfv42,
             sfv43     LIKE sfv_file.sfv43,
             sfv44     LIKE sfv_file.sfv44,
             sfv12     LIKE sfv_file.sfv12,
             sfv930    LIKE sfv_file.sfv930, #FUN-670103
             gem02c    LIKE gem_file.gem02,  #FUN-670103
             sfvud07   LIKE sfv_file.sfvud07 #hlf-07751
             ,l_min    LIKE sfv_file.sfv09   #add by guanyao160901
             END RECORD,
    g_sfv_t  RECORD
             sfv03     LIKE sfv_file.sfv03,
             sfv17     LIKE sfv_file.sfv17,    #FUN-550012
             sfv20     LIKE sfv_file.sfv20,
             sfv11     LIKE sfv_file.sfv11,
             #FUN-BC0104---add---str
             sfv46     LIKE sfv_file.sfv46,
             qcl02     LIKE qcl_file.qcl02,
             sfv47     LIKE sfv_file.sfv47,
             #FUN-BC0104---add---end
             sfv04     LIKE sfv_file.sfv04,
             ima02     LIKE ima_file.ima02,
             ima021    LIKE ima_file.ima021,
             sfv08     LIKE sfv_file.sfv08,
             sfv05     LIKE sfv_file.sfv05,
             sfv06     LIKE sfv_file.sfv06,
             sfv07     LIKE sfv_file.sfv07,
             sfv09     LIKE sfv_file.sfv09,
             sfv33     LIKE sfv_file.sfv33,
             sfv34     LIKE sfv_file.sfv34,
             sfv35     LIKE sfv_file.sfv35,
             sfv30     LIKE sfv_file.sfv30,
             sfv31     LIKE sfv_file.sfv31,
             sfv32     LIKE sfv_file.sfv32,
             sfv41     LIKE sfv_file.sfv41,
             sfv42     LIKE sfv_file.sfv42,
             sfv43     LIKE sfv_file.sfv43,
             sfv44     LIKE sfv_file.sfv44,
             sfv12     LIKE sfv_file.sfv12,
             sfv930    LIKE sfv_file.sfv930, #FUN-670103
             gem02c    LIKE gem_file.gem02,  #FUN-670103
             sfvud07   LIKE sfv_file.sfvud07
             ,l_min    LIKE sfv_file.sfv09   #add by guanyao160901
             END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_sfu01         LIKE sfu_file.sfu01,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(200)
    g_t1            LIKE oay_file.oayslip,               #No.FUN-550067  #No.FUN-680121 VARCHAR(5)
    g_buf           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(20)
#   tot1,tot2,tot3  LIKE ima_file.ima26,    #No.FUN-680121 DECIMAL(12,3),
    tot1,tot2,tot3  LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680121 SMALLINT
    g_imd10         LIKE imd_file.imd10,
    un_post_qty     LIKE img_file.img10,  #No.FUN-680121 DEC(15,5),
    tmp_qty         LIKE img_file.img10,  #No.FUN-680121 DEC(15,3),
    tmp_woqty      LIKE img_file.img10,  #No.MOD-880232 add
    g_sgm311        LIKE sgm_file.sgm311,
    g_sgm315        LIKE sgm_file.sgm315,
    g_sgm_out       LIKE sgm_file.sgm311,
    l_program       LIKE ima_file.ima34,  #No.FUN-680121 VARCHAR(10),
    l_za05          LIKE za_file.za05,
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT
DEFINE   g_argv    LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)        #1.完工入庫 2.入庫退回
DEFINE   g_argv1   LIKE sfu_file.sfu01     #No.FUN-630010
DEFINE   g_argv2   STRING                  #No.FUN-630010
DEFINE   u_sign	   LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_post          LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_void          LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_imm01         LIKE imm_file.imm01      #No.FUN-610090
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
 
DEFINE
    g_yes               LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_change            LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
    g_ima25             LIKE ima_file.ima25,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10
DEFINE g_sfv30_t        LIKE sfv_file.sfv30     #No.FUN-BB0086
DEFINE g_sfv35_t        LIKE sfv_file.sfv35     #No.FUN-BB0086
DEFINE g_sfv33_t        LIKE sfv_file.sfv33     #No.FUN-BB0086
DEFINE g_sfv09_t        LIKE sfv_file.sfv09       #FUN-BC0104
DEFINE g_multi_sfv20    STRING                  #add by guanyao160805
#DEFINE l_img_table      STRING                 #FUN-C70087 #FUN-CC0095
#DEFINE l_imgg_table     STRING                 #FUN-C70087 #FUN-CC0095

FUNCTION scect324(p_argv,p_argv1,p_argv2)
 
DEFINE  p_argv   LIKE type_file.chr1,   #No.FUN-680121 VARCHAR(1)  #No.FUN-6A0090
        p_argv1  LIKE sfu_file.sfu01,   #No.FUN-630010
        p_argv2  STRING                 #No.FUN-630010
 
   WHENEVER ERROR CONTINUE
    #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
    CALL t324_mu_ui()
 
    LET g_forupd_sql = "SELECT * FROM sfu_file WHERE sfu01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_cl CURSOR FROM g_forupd_sql
 
    LET g_argv = p_argv
    IF g_argv = '2' THEN
       LET u_sign=-1
    ELSE
       LET u_sign=1
    END IF
    LET g_argv1 = p_argv1       #No.FUN-630010
    LET g_argv2 = p_argv2       #No.FUN-630010
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t324_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t324_a()
             END IF
          OTHERWISE
             CALL t324_q()
       END CASE
    END IF
 
    CALL t324_menu()
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095
END FUNCTION
 
FUNCTION t324_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_sfv.clear()
 
    IF cl_null(g_argv1) THEN               #No.FUN-630010
       IF g_argv='1' THEN
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfu.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON
             #sfu01,sfu02,sfu04,sfu08,sfu09,sfu06,sfu05,sfu07,sfuconf, #FUN-660137 #FUN-810045
             sfu01,sfu02,sfu04,sfu08,sfu09,sfu06,sfu07,sfuconf, #FUN-660137        #FUN-810045
             sfupost,sfuuser,sfugrup,sfumodu,sfudate
 
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
 
           ON ACTION controlp
             CASE WHEN INFIELD(sfu01) #查詢單据
            #MOD-4A0252 入庫單號開窗
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form  = "q_sfu" 
                       ##組合拆解的完工入庫單不顯示出來!                                                                                      #TQC-AC0294         
                      #LET g_qryparam.where = " substr(sfu01,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) " #TQC-AC0294                      
                       LET g_qryparam.where = " sfu01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "    #FUN-B40029
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfu01
                       NEXT FIELD sfu01
 
                  WHEN INFIELD(sfu04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfu04
                       NEXT FIELD sfu04
 
                WHEN INFIELD(sfu06) #專案代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2"  #FUN-810045
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfu06
                   NEXT FIELD sfu06
                 WHEN INFIELD(sfu09)   #領料單號 #MOD-4A0252
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form ="q_sfp1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfu09
                   NEXT FIELD sfu09
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT
 
       ELSE
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
          CONSTRUCT BY NAME g_wc ON
             sfu01,sfu02,sfu04,sfu06,sfu07,sfu08,sfu09,sfuconf, #FUN-660137         #FUN-810045
             sfupost,sfuuser,sfugrup,sfumodu,sfudate
 
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
           ON ACTION controlp
             CASE WHEN INFIELD(sfu01) #查詢單据
                       LET g_t1=s_get_doc_no(g_sfu.sfu01)         #No.FUN-550067
                       LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                       CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add 
                       IF g_argv='0' THEN
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008
                       ELSE
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
                       END IF
                       LET g_qryparam.multiret=g_t1
                       DISPLAY g_qryparam.multiret TO sfu01
                       NEXT FIELD sfu01
 
                  WHEN INFIELD(sfu04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfu04
                       NEXT FIELD sfu04
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT
 
       END IF
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " sfu01 = '",g_argv1 CLIPPED,"'"
    END IF
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
 
    IF cl_null(g_argv1) THEN               #No.FUN-630010
       CONSTRUCT g_wc2 ON sfv03,sfv17,sfv20,sfv11, 
                          sfv46,qcl02,sfv47,   #FUN-BC0104 add
                          sfv04,sfv08,sfv05,   #FUN-550012
                          sfv06,sfv07,sfv09,sfv33,sfv35,sfv30,sfv32,
                          sfv41,sfv42,sfv43,sfv44,     #FUN-810045 add
                          sfv12,sfv930,sfvud07 #FUN-670103
                     FROM s_sfv[1].sfv03, s_sfv[1].sfv17,
                          s_sfv[1].sfv20,   #FUN-550012
                          s_sfv[1].sfv11, s_sfv[1].sfv46, s_sfv[1].qcl02, s_sfv[1].sfv47, #FUN-BC0104 add
                          s_sfv[1].sfv04, s_sfv[1].sfv08, s_sfv[1].sfv05,
                          s_sfv[1].sfv06, s_sfv[1].sfv07, s_sfv[1].sfv09,
                          s_sfv[1].sfv33, s_sfv[1].sfv35, s_sfv[1].sfv30,
                          s_sfv[1].sfv32,
                          s_sfv[1].sfv41,s_sfv[1].sfv42,s_sfv[1].sfv43,s_sfv[1].sfv44,  #FUN-810045 add
                          s_sfv[1].sfv12,s_sfv[1].sfv930,s_sfv[1].sfvud07 #FUN-670103
 
                   BEFORE CONSTRUCT
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
           ON ACTION controlp
              CASE WHEN INFIELD(sfv20)    #Run Card
                        CALL q_shm2(TRUE,TRUE,'','')
                             RETURNING g_sfv[1].sfv20
                        DISPLAY BY NAME g_sfv[1].sfv20
                        NEXT FIELD sfv20
                        WHEN INFIELD(sfv17)    #FQC單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.form ="q_qcf4"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfv17
                        NEXT FIELD sfv17
 
                   WHEN INFIELD(sfv11)    #工單單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.construct ="Y"
                        LET g_qryparam.form ="q_sfb01"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfv11
                        NEXT FIELD sfv11
                  WHEN INFIELD(sfv05)
                    #Mod No.FUN-AA0082
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imd"
                    #LET g_qryparam.state    = "c"
                    #LET g_qryparam.arg1     = "A"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AA0082
                     DISPLAY g_qryparam.multiret TO sfv05
                     NEXT FIELD sfv05
                  WHEN INFIELD(sfv06)
                    #Mod No.FUN-AA0082
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_ime"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AA0082
                     DISPLAY g_qryparam.multiret TO sfv06
                     NEXT FIELD sfv06
                  WHEN INFIELD(sfv07)
                     CALL cl_init_qry_var()
                    #Mod No.FUN-AA0082
                    #LET g_qryparam.form     = "q_ime"
                     LET g_qryparam.form     = "q_sfv07"
                    #End Mod No.FUN-AA0082
                     LET g_qryparam.state    = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfv07
                     NEXT FIELD sfv07
                  WHEN INFIELD(sfv33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfv33
                     NEXT FIELD sfv33
                  WHEN INFIELD(sfv30)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfv30
                     NEXT FIELD sfv30
                  WHEN INFIELD(sfv930)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gem4"
                     LET g_qryparam.state = "c"   #多選
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfv930
                     NEXT FIELD sfv930
                 WHEN INFIELD(sfv41) #專案
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2"  
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfv41
                   NEXT FIELD sfv41
                 WHEN INFIELD(sfv42)  #WBS
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfv42
                   NEXT FIELD sfv42
                 WHEN INFIELD(sfv43)  #活動
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjk3"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfv43
                   NEXT FIELD sfv43
                   
                 WHEN INFIELD(sfv44)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"                   #No.FUN-930145
                   LET g_qryparam.state = "c"   #多選
                   LET g_qryparam.arg1 = 'C'                         #No.FUN-930145
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfv44
                   NEXT FIELD sfv44

                 #FUN-BC0104---add---str
                WHEN INFIELD(sfv46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"     
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv46
                  NEXT FIELD sfv46

                WHEN INFIELD(sfv47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"    
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv47
                  NEXT FIELD sfv47
                #FUN-BC0104---add---end
              END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                       ON ACTION qbe_save
                          CALL cl_qbe_save()
 
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE
       LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT sfu01 FROM sfu_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND sfu00 = '",g_argv,"'",
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE sfu_file.sfu01 ",
                   "  FROM sfu_file, sfv_file",
                   " WHERE sfu01 = sfv01",
                   "   AND sfu00 = '",g_argv,"'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t324_prepare FROM g_sql
    DECLARE t324_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t324_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM sfu_file ",
                    " WHERE ",g_wc CLIPPED,
                    "   AND sfu00 = '",g_argv,"'"
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT sfu01) FROM sfu_file,sfv_file WHERE ",
                  "sfu01=sfv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND sfu00 = '",g_argv,"'"
    END IF
 
    PREPARE t324_precount FROM g_sql
    DECLARE t324_count CURSOR FOR t324_precount
 
END FUNCTION
 
FUNCTION t324_menu()
DEFINE l_cmd        LIKE type_file.chr1000   #FUN-BC0104
 
   WHILE TRUE
      CALL t324_bp("G")
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t324_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t324_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t324_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t324_u()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t324_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL t324_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL t324_y_chk()
                 IF g_success = "Y" THEN
                    CALL t324_y_upd()
                 END IF
              END IF
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 CALL t324_z()
              END IF
           WHEN "void"
              IF cl_chk_act_auth() THEN
                #CALL t324_x()    #CHI-D20010
                 CALL t324_x(1)   #CHI-D20010
                 CALL t324_show() #FUN-BC0104
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           #CHI-D20010---begin
           WHEN "undo_void"
              IF cl_chk_act_auth() THEN
                 CALL t324_x(2)
                 CALL t324_show() #FUN-BC0104
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           #CHI-D20010---end
           WHEN "stock_post"
              IF cl_chk_act_auth() THEN
                 CALL t324_s()
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           WHEN "undo_post"
              IF cl_chk_act_auth() THEN
                 CALL t324_w()
                
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           WHEN "gen_mat_wtdw"
              IF cl_chk_act_auth() THEN
                 CALL t324_k()
              END IF
           WHEN "maint_mat_wtdw"
              IF cl_chk_act_auth() THEN
                 IF g_sfu.sfu09 IS NOT NULL THEN
                    LET g_cmd = "asfi510", " '4' " ," '",g_sfu.sfu09,"'"
                    CALL cl_cmdrun(g_cmd CLIPPED)
                 END IF
              END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfv),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sfu.sfu01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfu01"
                 LET g_doc.value1 = g_sfu.sfu01
                 CALL cl_doc()
               END IF
         END IF
         #FUN-BC0104---add---str
          WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN
               LET  l_cmd = "aqcp107 '2' '' '' '' '' '' '' '' '' 'N'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #FUN-BC0104---add---end
         #tianry add 161121
            WHEN "dshz"
               IF cl_chk_act_auth() THEN
                  IF g_sfu.sfu01 IS NOT NULL THEN
                     LET g_msg="cxmq008 '",g_sfu.sfu01,"'"," ''"
                     CALL cl_cmdrun_wait(g_msg) #MOD-580344
                  END IF
               END IF

         #tianry add end 


        WHEN "qry_lot"
           IF l_ac > 0 THEN                                 #MOD-B70224 add
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_sfv[l_ac].sfv04
                 AND imaacti = "Y"
           
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF cl_null(g_sfv[l_ac].sfv06) THEN
                    LET g_sfv[l_ac].sfv06 = ' '
                 END IF
                 IF cl_null(g_sfv[l_ac].sfv07) THEN
                    LET g_sfv[l_ac].sfv07 = ' '
                 END IF
                 SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01=g_sfv[l_ac].sfv04
                    AND img02=g_sfv[l_ac].sfv05
                    AND img03=g_sfv[l_ac].sfv06
                    AND img04=g_sfv[l_ac].sfv07
                 CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                      RETURNING l_i,l_fac
                 IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236--mark---begin
#                CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                             g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                             l_fac,g_sfv[l_ac].sfv09,'','QRY')#CHI-9A0022 add ''
#TQC-B90236--mark---end
#TQC-B90236--add----begin
                 CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                                g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,'','QRY',1)
#TQC-B90236--add----end
                      RETURNING l_r,g_qty 
               END IF
           END IF                                           #MOD-B70224 add 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t324_a()
DEFINE li_result LIKE type_file.num5                 #No.FUN-550067  #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_sfv.clear()
    INITIALIZE g_sfu.* TO NULL
    LET g_sfu_o.* = g_sfu.*
    LET g_sfu_t.* = g_sfu.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sfu.sfu00 = g_argv
        LET g_sfu.sfu02 = g_today
        LET g_sfu.sfupost='N'
        LET g_sfu.sfuconf='N' #FUN-660137
        LET g_sfu.sfuuser=g_user
        LET g_sfu.sfuoriu = g_user #FUN-980030
        LET g_sfu.sfuorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sfu.sfugrup=g_grup
        LET g_sfu.sfudate=g_today
        LET g_sfu.sfu04=g_grup #FUN-670103
        LET g_sfu.sfuplant = g_plant #FUN-980008 add
        LET g_sfu.sfulegal = g_legal #FUN-980008 add
        CALL t324_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_sfu.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_sfu.sfu01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK    #No:7829
        CALL s_auto_assign_no("asf",g_sfu.sfu01,g_sfu.sfu02,"A","sfu_file","sfu01","","","")
          RETURNING li_result,g_sfu.sfu01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_sfu.sfu01
        #FUN-A80128---add---str--
        LET g_sfu.sfu15   = '0'
        LET g_sfu.sfu16   = g_user
        LET g_sfu.sfumksg = 'N' 
        #FUN-A80128---add---end--
        INSERT INTO sfu_file VALUES (g_sfu.*)
        IF STATUS THEN
           CALL cl_err3("ins","sfu_file",g_sfu.sfu01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_sfu.sfu01,'I')
 
        SELECT sfu01 INTO g_sfu.sfu01 FROM sfu_file WHERE sfu01 = g_sfu.sfu01
        LET g_sfu_t.* = g_sfu.*
 
 
        CALL g_sfv.clear()
        LET g_rec_b = 0
        CALL t324_b()                   #輸入單身
 
        SELECT COUNT(*) INTO g_cnt FROM sfv_file WHERE sfv01=g_sfu.sfu01
        IF g_cnt>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t324_out() END IF
           END IF
           IF g_smy.smydmy4='Y' THEN CALL t324_s() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t324_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sfu.sfu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sfu_o.* = g_sfu.*
 
    BEGIN WORK
 
    OPEN t324_cl USING g_sfu.sfu01
    IF STATUS THEN
       CALL cl_err("OPEN t324_cl:", STATUS, 1)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t324_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t324_cl ROLLBACK WORK RETURN
    END IF
    CALL t324_show()
    WHILE TRUE
        LET g_sfu.sfumodu=g_user
        LET g_sfu.sfudate=g_today
        CALL t324_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sfu.*=g_sfu_t.*
            CALL t324_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE sfu_file SET * = g_sfu.* WHERE sfu01 = g_sfu_o.sfu01
        IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
           CALL cl_err3("upd","sfu_file",g_sfu_t.sfu01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        END IF
        IF g_sfu.sfu01 != g_sfu_t.sfu01 THEN CALL t324_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t324_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sfu.sfu01,'U')
 
END FUNCTION
 
FUNCTION t324_chkkey()
    UPDATE sfv_file SET sfv01=g_sfu.sfu01 WHERE sfv01=g_sfu_t.sfu01
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","sfv_file",g_sfu_t.sfu01,"",STATUS,"","upd sfv01",1)  #No.FUN-660128
       LET g_sfu.*=g_sfu_t.* CALL t324_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION t324_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
         g_sfu09         LIKE sfu_file.sfu09
  DEFINE li_result       LIKE type_file.num5                 #No.FUN-550067  #No.FUN-680121 SMALLINT
  DEFINE l_n             LIKE type_file.num5     #TQC-720063
 
    DISPLAY BY NAME
        g_sfu.sfu01,g_sfu.sfu02,g_sfu.sfu04,    #FUN-560195
        g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfuconf, #FUN-660137              #FUN-810045
        g_sfu.sfupost,g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       INPUT BY NAME g_sfu.sfuoriu,g_sfu.sfuorig,
          g_sfu.sfu01,g_sfu.sfu02,g_sfu.sfu04,  #FUN-560195
          g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfuconf, #FUN-660137              #FUN-810045
          g_sfu.sfupost,g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate
             WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t324_set_entry(p_cmd)
          CALL t324_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("sfu01")  #No.FUN-550067
          CALL cl_set_docno_format("sfu09")  #No.FUN-550067
 
 
        BEFORE FIELD sfu01
           CALL t324_set_entry(p_cmd)
 
        AFTER FIELD sfu01
          IF cl_null(g_sfu.sfu01) THEN NEXT FIELD sfu01 END IF
           CALL s_check_no("asf",g_sfu.sfu01,g_sfu_t.sfu01,"A","sfu_file","sfu01","")
             RETURNING li_result,g_sfu.sfu01
           DISPLAY BY NAME g_sfu.sfu01
           IF (NOT li_result) THEN
        	    NEXT FIELD sfu01
           END IF
        #TQC-AC0294-----start------------
           CALL t324_sfu01(p_cmd)
           IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfu.sfu01,g_errno,0)
               NEXT FIELD sfu01
           END IF
        #TQC-AC0294-----end--------------
	        DISPLAY BY NAME g_smy.smydesc
          CALL t324_set_no_entry(p_cmd)    #FUN-550012
 
        AFTER FIELD sfu02
            IF cl_null(g_sfu.sfu02) THEN NEXT FIELD sfu02 END IF
	    IF g_sma.sma53 IS NOT NULL AND g_sfu.sfu02 <= g_sma.sma53 THEN
	        CALL cl_err('','mfg9999',0) NEXT FIELD sfu02
	    END IF
            CALL s_yp(g_sfu.sfu02) RETURNING g_yy,g_mm
            #不可大於現行年月
            IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
               CALL cl_err('','mfg6091',0) NEXT FIELD sfu02
            END IF
 
        AFTER FIELD sfu04
            IF NOT cl_null(g_sfu.sfu04) THEN
               LET g_buf = ''
               SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfu.sfu04
                  AND gemacti='Y'   #NO:6950
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_sfu.sfu04,"",STATUS,"","select gem",1)  #No.FUN-660128
                  NEXT FIELD sfu04   
               END IF
               DISPLAY g_buf TO gem02
            END IF
 
          AFTER FIELD sfu06
             IF NOT cl_null(g_sfu.sfu06) THEN
                SELECT COUNT(*) INTO l_n FROM pja_file
                 WHERE pja01=g_sfu.sfu06
                   AND pjaacti = 'Y'
                   AND pjaclose='N'     #FUN-960038
                IF l_n = 0 THEN
                   CALL cl_err(g_sfu.sfu06,'asf-984',0)
                   NEXT FIELD sfu06
                END IF
                CALL t324_pja02()
             END IF
 
          AFTER FIELD sfu08
             IF NOT cl_null(g_sfu.sfu08) THEN
                SELECT COUNT(*) INTO g_cnt FROM sfd_file
                 WHERE sfd01 = g_sfu.sfu08 AND sfdconf = 'Y'               #FUN-A90035 add sfdconf = 'Y'
                IF g_cnt = 0 THEN
                 # CALL cl_err(g_sfu.sfu08,'asf-401',0)                    #FUN-A90035 mark
                   CALL cl_err(g_sfu.sfu08,'asf-772',0)                    #FUN-A90035
                   NEXT FIELD sfu08
                END IF
             END IF
 
        AFTER FIELD sfu09    #領料單號
           IF g_sfu.sfu09 IS NOT NULL THEN
              SELECT COUNT(*) INTO g_cnt FROM sfp_file
               WHERE sfp01 = g_sfu.sfu09
                 AND sfp06  = '4' AND sfpconf!='X' #FUN-660106
              IF g_cnt = 0 THEN
                 CALL cl_err(g_sfu.sfu09,'asf-525',0)
                 NEXT FIELD sfu09
              END IF
           END IF
 
        ON ACTION controlp
          CASE WHEN INFIELD(sfu01) #查詢單据
                    LET g_t1=s_get_doc_no(g_sfu.sfu01)    #No.FUN-550067
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                    CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add 
	            IF g_argv='0' THEN
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008
                    ELSE
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
	            END IF
                    LET g_sfu.sfu01=g_t1                 #No.FUN-550067
                    DISPLAY BY NAME g_sfu.sfu01
                    NEXT FIELD sfu01
               WHEN INFIELD(sfu04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_sfu.sfu04
                    CALL cl_create_qry() RETURNING g_sfu.sfu04
                    DISPLAY BY NAME g_sfu.sfu04
                    NEXT FIELD sfu04
 
              WHEN INFIELD(sfu06) #專案代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"   #FUN-810045
                 LET g_qryparam.default1 = g_sfu.sfu06
                 CALL cl_create_qry() RETURNING g_sfu.sfu06
                 DISPLAY BY NAME g_sfu.sfu06
                 NEXT FIELD sfu06
               WHEN INFIELD(sfu09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfp1"
                    LET g_qryparam.default1 = g_sfu.sfu09
                    CALL cl_create_qry() RETURNING g_sfu.sfu09
                    DISPLAY BY NAME g_sfu.sfu09
                    NEXT FIELD sfu09
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
FUNCTION t324_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfu01,sfu02,sfu04,sfu06,sfu07,sfu08,sfu09",TRUE) #FUN-560195       #FUN-810045 
    END IF
 
END FUNCTION
 
FUNCTION t324_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfu01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t324_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   CALL cl_set_comp_entry("sfv04",TRUE)
   CALL cl_set_comp_entry("sfv30,sfv32,sfv33,sfv35",TRUE)
 
   CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",TRUE)  #FUN-810045
 
END FUNCTION
 
FUNCTION t324_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("sfv33,sfv35",FALSE)
   END IF
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("sfv33",FALSE)
   END IF
 
   IF l_ac > 0 THEN
     IF NOT cl_null(g_sfv[l_ac].sfv11) THEN
       CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",FALSE)
     END IF
   END IF
 
END FUNCTION
 
FUNCTION t324_set_entry_b1(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    CALL cl_set_comp_entry("sfv04",TRUE)
 
END FUNCTION
 
FUNCTION t324_set_no_entry_b1(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
  DEFINE l_cnt    LIKE type_file.num5    #FUN-BCO104
  DEFINE l_ima903 LIKE ima_file.ima903   #FUN-BC0104
  DEFINE l_ima01  LIKE ima_file.ima01   #FUN-BC0104
 
  #FUN-BC0104--begin-add--
  IF l_ac > 0 THEN
     LET l_cnt=0 LET l_ima903=''
     SELECT ima903,ima01 INTO l_ima903,l_ima01 FROM ima_file
      WHERE ima01 = (SELECT sfb05 FROM sfb_file
                      WHERE sfb01 = g_sfv[l_ac].sfv11)
     IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2'
        AND l_ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
        SELECT COUNT(*) INTO l_cnt FROM bmm_file
         WHERE bmm01 = l_ima01
        IF l_cnt >= 1 THEN
           LET g_sfv16='Y'
        END IF
     END IF
  END IF
  #FUN-BC0104--end--add---
  IF INFIELD(sfv20) AND (cl_null(g_sfv16) OR g_sfv16<>'Y') THEN
     CALL cl_set_comp_entry("sfv04",FALSE)
  END IF
  #FUN-BC0104---add---str---
  IF l_ac >0 THEN
     IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
        CALL cl_set_comp_entry("sfv04",FALSE)
     END IF
  END IF
  #FUN-BC0104---add---end---
END FUNCTION
 
FUNCTION t324_pja02()   #專案名稱
   DEFINE
       l_pja02 LIKE pja_file.pja02 
 
   IF g_sfu.sfu06 IS NULL THEN RETURN END IF
   LET l_pja02=' '
   LET g_errno=' '
   SELECT pja02 INTO l_pja02
     FROM pja_file
     WHERE pja01=g_sfu.sfu06 AND pjaacti='Y'
       AND pjaclose='N'     #FUN-960038
   IF SQLCA.sqlcode THEN
      LET g_errno='apj-005'
      LET l_pja02=''
   END IF
   DISPLAY l_pja02 TO FORMONLY.pja02
 
END FUNCTION
 
 
FUNCTION t324_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfu.* TO NULL               #No.FUN-6A0164
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t324_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sfu.* TO NULL
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t324_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sfu.* TO NULL
    ELSE
        OPEN t324_count
        FETCH t324_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t324_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t324_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t324_cs INTO g_sfu.sfu01
        WHEN 'P' FETCH PREVIOUS t324_cs INTO g_sfu.sfu01
        WHEN 'F' FETCH FIRST    t324_cs INTO g_sfu.sfu01
        WHEN 'L' FETCH LAST     t324_cs INTO g_sfu.sfu01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t324_cs INTO g_sfu.sfu01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)
        INITIALIZE g_sfu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfu_file",g_sfu.sfu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_sfu.* TO NULL
    ELSE
       LET g_data_owner = g_sfu.sfuuser      #FUN-4C0035 add
       LET g_data_group = g_sfu.sfugrup      #FUN-4C0035 add
       LET g_data_plant = g_sfu.sfuplant #FUN-980030
       CALL t324_show()
    END IF
 
END FUNCTION
 
FUNCTION t324_show()
     DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
 
    LET g_sfu_t.* = g_sfu.*                #保存單頭舊值
    SELECT sfuconf INTO g_sfu.sfuconf     #FUN-C40016
      FROM sfu_file                       #FUN-C40016
     WHERE sfu01 = g_sfu.sfu01            #FUN-C40016
    DISPLAY BY NAME g_sfu.sfuoriu,g_sfu.sfuorig,
        g_sfu.sfu01,g_sfu.sfu02,g_sfu.sfu04,   #FUN-560195
        g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,              #FUN-810045
        g_sfu.sfu09,g_sfu.sfuconf, #FUN-660137
        g_sfu.sfupost,
        g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate
    LET g_buf = s_get_doc_no(g_sfu.sfu01)   #No.FUN-550067
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
     DISPLAY l_smydesc TO smydesc LET g_buf = NULL #MOD-4C0010
    CALL t324_show2()
 
    CALL t324_pic() #圖形顯示 #FUN-660137
 
    CALL t324_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t324_show2()
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfu.sfu04
                 DISPLAY g_buf TO gem02 LET g_buf = NULL
    SELECT pja02 INTO g_buf FROM pja_file WHERE pja01 = g_sfu.sfu06 AND pjaacti = 'Y'
    DISPLAY g_buf TO FORMONLY.pja02  
    LET g_buf = NULL        
END FUNCTION
 
FUNCTION t324_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    DEFINE l_i           LIKE type_file.num5   #FUN-810045 add
    DEFINE l_flag        LIKE type_file.chr1    #FUN-B70074 add
    #FUN-BC0104---add---str---
    DEFINE l_sfv17         LIKE sfv_file.sfv17,
           l_sfv47         LIKE sfv_file.sfv47,
           l_cn            LIKE type_file.num5,
           l_c             LIKE type_file.num5
    DEFINE l_sfv_a   DYNAMIC ARRAY OF RECORD
           sfv17           LIKE sfv_file.sfv17,
           sfv47           LIKE sfv_file.sfv47
                     END RECORD
    #FUN-BC0104---add---end---
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sfu.sfu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
 
    BEGIN WORK
 
    OPEN t324_cl USING g_sfu.sfu01
    IF STATUS THEN
       CALL cl_err("OPEN t324_cl:", STATUS, 1)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t324_cl INTO g_sfu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t324_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfu.sfu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete sfu,sfv!"
       DELETE FROM sfu_file WHERE sfu01 = g_sfu.sfu01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","sfu_file",g_sfu.sfu01,"",SQLCA.SQLCODE,"","No ina deleted",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
       #FUN-BC0104---add---str---
        DECLARE sfv03_cur CURSOR FOR SELECT sfv17,sfv47
                                     FROM sfv_file
                                     WHERE sfv01 = g_sfu.sfu01
        LET l_cn = 1
        FOREACH sfv03_cur INTO l_sfv17,l_sfv47
           LET l_sfv_a[l_cn].sfv17 = l_sfv17
           LET l_sfv_a[l_cn].sfv47 = l_sfv47
           LET l_cn = l_cn+1
        END FOREACH
        #FUN-BC0104---add---end---
       DELETE FROM sfv_file WHERE sfv01 = g_sfu.sfu01
       #FUN-BC0104---add---str---
        FOR l_c=1 TO l_cn-1
           IF NOT s_iqctype_upd_qco20(l_sfv_a[l_c].sfv17,0,0,l_sfv_a[l_c].sfv47,'2') THEN
                   ROLLBACK WORK
                   RETURN
                END IF
        END FOR
        #FUN-BC0104---add---end---
#FUN-B70074-add-delete--
       IF NOT s_industry('std') THEN 
          LET l_flag=s_del_sfvi(g_sfu.sfu01,'','')
       END IF
#FUN-B70074-add-end----
      
       IF g_argv='1' THEN
          SELECT COUNT(*) INTO l_i FROM shb_file                                                                                   
               WHERE shb21 = g_sfu.sfu01                                                                                               
                 AND shbconf = 'Y'     #FUN-A70095 
          IF SQLCA.sqlcode THEN LET l_i = 0  END IF                                                                                
          IF l_i>0 THEN                                                                                                            
             UPDATE shb_file SET shb21 = NULL                                                                                      
              WHERE shb21 = g_sfu.sfu01                                                                                            
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                           
                CALL cl_err('upd shb21',SQLCA.sqlcode,1)                                                                           
                ROLLBACK WORK                                                                                                      
                RETURN                                                                                                             
             END IF                                                                                                                
          END IF
       END IF                                                                                                                    
 
       FOR l_i = 1 TO g_rec_b 
          #IF NOT s_del_rvbs("2",g_sfu.sfu01,g_sfv[l_i].sfv03,0)  THEN       #FUN-880129   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_sfu.sfu01,'',0,g_sfv[l_i].sfv04,'DEL') THEN  #TQC-B90236 add
              ROLLBACK WORK
              RETURN
           END IF
       END FOR
 
     
       CLEAR FORM
       CALL g_sfv.clear()
 
       INITIALIZE g_sfu.* TO NULL
       MESSAGE ""
       OPEN t324_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t324_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t324_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t324_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t324_fetch('/')
       END IF
 
    END IF
 
    CLOSE t324_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sfu.sfu01,'D')
 
END FUNCTION
 
 
FUNCTION t324_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_row,l_col      LIKE type_file.num5,   #No.FUN-680121 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt        LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_qcf03          LIKE qcf_file.qcf03,   #No.MOD-530603 add
    l_shm28          LIKE shm_file.shm28,   #No.FUN-630104 add
    l_pjb25          LIKE pjb_file.pjb25,          #FUN-810045
 
    l_ima35          LIKE ima_file.ima35,
    l_ima36          LIKE ima_file.ima36,
    l_ecu04          LIKE ecu_file.ecu04,
    l_ecu05          LIKE ecu_file.ecu05,
    l_sfv09          LIKE sfv_file.sfv09,
    l_sgm_out        LIKE sfv_file.sfv09,
    l_qty1           LIKE sfv_file.sfv09,
    l_qty2           LIKE sfv_file.sfv09,
    l_sgm311         LIKe sgm_file.sgm311,
    l_sgm315         LIKe sgm_file.sgm315,
    l_sfb08          LIKE sfb_file.sfb08,
    l_sfb39          LIKE sfb_file.sfb39,
    l_qcf091         LIKE qcf_file.qcf091,
    l_sum_sfv09      LIKE sfv_file.sfv09,    #FUN-550012
    l_date           LIKE type_file.dat,     #No.FUN-680121 DATE,
    l_allow_insert   LIKE type_file.num5,    #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete   LIKE type_file.num5     #可刪除否  #No.FUN-680121 SMALLINT
DEFINE  l_pjb09      LIKE pjb_file.pjb09     #FUN-850027
DEFINE  l_pjb11      LIKE pjb_file.pjb11     #FUN-850027
DEFINE  l_ima153     LIKE ima_file.ima153    #FUN-910053 
DEFINE  l_azf09      LIKE azf_file.azf09     #No.FUN-930145

DEFINE  l_ecm03      LIKE ecm_file.ecm03     #FUN-A60076
DEFINE  l_ecm012     LIKE ecm_file.ecm012    #FUN-A60076   
DEFINE l_sfvi RECORD LIKE sfvi_file.*        #FUN-B70074
DEFINE l_tf          LIKE type_file.chr1                 #No.FUN-BB0086
DEFINE l_case        STRING                  #No.FUN-BB0086
DEFINE l_sum         LIKE qco_file.qco11       #FUN-BC0104 add
DEFINE l_qcl05       LIKE qcl_file.qcl05       #FUN-BC0104 add
DEFINE l_ac2         LIKE type_file.num5     #CHI-C30118
DEFINE l_n1          LIKE type_file.num5     #TQC-D70056
DEFINE l_shm08       LIKE shm_file.shm08
DEFINE l_sum_sfv09_1 LIKE sfv_file.sfv09
DEFINE l_sfv09_1     LIKE sfv_file.sfv09
#str----add by huanglf160922
DEFINE l_year        LIKE type_file.chr30
DEFINE l_months      LIKE type_file.chr30
DEFINE l_day        LIKE type_file.chr30
#str----end by huanglf160922
#str----add by huanglf161014
DEFINE l_sfb22     LIKE sfb_file.sfb22
DEFINE l_oea31     LIKE oea_file.oea31
DEFINE l_oea23     LIKE oea_file.oea23
DEFINE l_oeb05     LIKE oeb_file.oeb05
DEFINE l_oea21     LIKE oea_file.oea21
DEFINE l_year1     LIKE type_file.chr30
DEFINE l_month1    LIKE type_file.chr30
DEFINE l_number    LIKE type_file.chr30  
DEFINE l_sql       STRING 
#str----end by huanglf161014
    LET g_action_choice = ""
 
    IF g_sfu.sfu01 IS NULL THEN RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
      #是否使用FQC功能                               #入庫
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sfv03,sfv17,sfv20,sfv11,sfv46,'',sfv47,sfv04,'','',sfv08,sfv05,sfv06,",  #FUN-550012 #FUN-BC0104 sfv46,sfv47
                       "       sfv07,sfv09,sfv33,sfv34,sfv35,sfv30,sfv31,sfv32,sfv12,sfv930,'',sfvud07,'' ", #FUN-670103
                       "  FROM sfv_file",
                       " WHERE sfv01= ? AND sfv03= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_sfv.clear() END IF
 
    INPUT ARRAY g_sfv WITHOUT DEFAULTS FROM s_sfv.*
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd='u'
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_sfv16 = 'N'     #FUN-BC0104
 
            BEGIN WORK
 
            OPEN t324_cl USING g_sfu.sfu01
            IF STATUS THEN
               CALL cl_err("OPEN t324_cl:", STATUS, 1)
               CLOSE t324_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t324_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t324_cl ROLLBACK WORK RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sfv_t.* = g_sfv[l_ac].*  #BACKUP
                OPEN t324_bcl USING g_sfu.sfu01,g_sfv_t.sfv03
                IF STATUS THEN
                   CALL cl_err("OPEN t324_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t324_bcl INTO g_sfv_t.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock sfv',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
                   LET g_before_input_done = FALSE
                   CALL t324_set_entry_b('u')
                   CALL t324_set_no_entry_b('u')
                   LET g_before_input_done = TRUE
                 LET g_change='N'  #No.FUN-580029
                END IF
                #FUN-BC0104---add---str---
                CALL t324_set_noentry_sfv46()       
                IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
                   CALL t324_qcl02_desc()
                END IF
                CALL t324_set_entry_b1(p_cmd)
                CALL t324_set_no_entry_b1(p_cmd)
                #FUN-BC0104---add---end---
                CALL cl_show_fld_cont()     #FUN-550037(smin)
              #IF由工單帶入，則不可修改sfv41-43
               IF NOT cl_null(g_sfv[l_ac].sfv11) THEN
                  CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",FALSE)  
               ELSE
                  CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",TRUE)  
               END IF
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP
              INITIALIZE g_sfv[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_sfv[l_ac].* TO s_sfv.*
              CALL g_sfv.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                    RETURNING g_cnt,g_ima906,g_ima907
               IF g_cnt=1 THEN
                  NEXT FIELD sfv04
               END IF
               CALL t324_du_data_to_correct()
            END IF
            CALL t324_set_origin_field()
            CALL t324_b_else()
           
#
#str-----end by huanglf161014
          IF g_success = 'Y' THEN #FUN-810025
#str-----add by huanglf161014
          --LET g_sfv[l_ac].sfvud07 = 0
          --SELECT sfb22 INTO l_sfb22 FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11
--
          --SELECT oea31,oea23,oeb05,oea21 INTO l_oea31,l_oea23,l_oeb05,l_oea21
          --FROM oea_file,oeb_file 
          --WHERE oea01 = oeb01 AND oea01 = l_sfb22
--
          --SELECT oeb13 INTO g_sfv[l_ac].sfvud07 FROM oeb_file 
          --WHERE oeb01= l_sfb22 AND
                --oeb04 = g_sfv[l_ac].sfv04
      #oeb03=(SELECT sfb221 FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11)  #modify by huanglf161014
          --
          --IF g_sfv[l_ac].sfvud07 = 0 OR cl_null(g_sfv[l_ac].sfvud07) THEN 
            --SELECT  xmf07 INTO g_sfv[l_ac].sfvud07 FROM xmf_file 
                --WHERE  xmf01 = l_oea31 AND xmf02 = l_oea23 AND xmf03 = g_sfv[l_ac].sfv04  
                       --AND xmf04 = l_oeb05 AND xmf05 < g_sfu.sfu02 AND ta_xmf02 = l_oea21
--
             --IF g_sfv[l_ac].sfvud07 = 0 OR cl_null(g_sfv[l_ac].sfvud07) THEN
               --LET l_year1 = YEAR(g_today)
               --LET l_month1 = MONTH(g_today)
               --LET l_number = '%',l_year1 CLIPPED,l_month1 CLIPPED,'%'
               --LET l_sql =" SELECT oeb13 FROM oeb_file WHERE oeb01 LIKE '",l_number,"'",
                          --" AND oeb04 = '",g_sfv[l_ac].sfv04,"' ORDER BY oeb01"  
                     --PREPARE oeb_prepare1 FROM l_sql
                     --IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
                        --CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
                        --EXIT PROGRAM 
                     --END IF
                     --DECLARE oeb_curs1 CURSOR FOR oeb_prepare1
                 --
                     --FOREACH oeb_curs1 INTO g_sfv[l_ac].sfvud07
                        --EXIT FOREACH 
                     --END FOREACH
                 --
                 --IF g_sfv[l_ac].sfvud07 = 0 OR cl_null(g_sfv[l_ac].sfvud07) THEN
                    --SELECT DISTINCT oeb13 INTO g_sfv[l_ac].sfvud07 FROM oea_file,oeb_file 
                        --WHERE oea01 = oeb01 AND oeb04 = g_sfv[l_ac].sfv04 
                              --AND oea02 = (SELECT  MAX(oea02) FROM oea_file,oeb_file 
                                           --WHERE oea01 = oeb01 AND oeb04 = g_sfv[l_ac].sfv04)
                   --IF g_sfv[l_ac].sfvud07 = 0 OR cl_null(g_sfv[l_ac].sfvud07) THEN
                       --LET g_sfv[l_ac].sfvud07 = 0
                   --END IF 
                 --END IF 
                  --
             --END IF
         

            INSERT INTO sfv_file (sfv01,sfv03,sfv04,sfv05,sfv06,sfv07,
                                  sfv08,sfv09,sfv11,
                                  sfv46,sfv47,            #FUN-BC0104
                                  sfv41,sfv42,sfv43,sfv44,   #FUN-810045 add
                                  sfv12,sfv17,sfv20,
                                  sfv30,sfv31,sfv32,sfv33,sfv34,sfv35,sfv930,sfvud07,   #FUN-550012 #FUN-670103
                                  sfvplant,sfvlegal) #FUN-980008 add
                           VALUES(g_sfu.sfu01,g_sfv[l_ac].sfv03,
                                  g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                  g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                  g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv09,
                                  g_sfv[l_ac].sfv11,
                                  g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47,  #FUN-BC0104
                                  g_sfv[l_ac].sfv41,g_sfv[l_ac].sfv42,  #FUN-810045
                                  g_sfv[l_ac].sfv43,g_sfv[l_ac].sfv44,  #FUN-810045
                                  g_sfv[l_ac].sfv12,
                                  g_sfv[l_ac].sfv17,g_sfv[l_ac].sfv20,
                                  g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31,
                                  g_sfv[l_ac].sfv32,g_sfv[l_ac].sfv33,
                                  g_sfv[l_ac].sfv34,g_sfv[l_ac].sfv35,g_sfv[l_ac].sfv930,   #FUN-550012 #FUN-670103
                                  g_sfv[l_ac].sfvud07,
                                  g_plant,g_legal) #FUN-980008 add  #hlf-07751
          END IF #FUN-810025
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sfv_file",g_sfu.sfu01,g_sfv[l_ac].sfv03,SQLCA.sqlcode,"","ins sfv",1)  #No.FUN-660128
              #CANCEL INSERT   #MOD-BA0106 mark
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_sfv[l_ac].sfv04
                  AND imaacti = "Y"
              
              
               CANCEL INSERT   #MOD-BA0106
            ELSE
#FUN-B70074--add--insert--
               IF NOT s_industry('std') THEN
                  INITIALIZE l_sfvi.* TO NULL
                  LET l_sfvi.sfvi01 = g_sfu.sfu01
                  LET l_sfvi.sfvi03 = g_sfv[l_ac].sfv03
                  IF NOT s_ins_sfvi(l_sfvi.*,g_plant) THEN
                     CANCEL INSERT
                  END IF
               END IF 
#FUN-B70074--add--insert--
               MESSAGE 'INSERT O.K'
               #FUN-BC0104---add---str
               IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                  CANCEL INSERT 
               END IF
               #FUN-BC0104---add---end
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL t324_set_entry_b('a')
            CALL t324_set_no_entry_b('a')
            LET g_before_input_done = TRUE
            INITIALIZE g_sfv[l_ac].* TO NULL      #900423
            LET g_sfv_t.* = g_sfv[l_ac].*
            LET g_sfv[l_ac].sfv09=0
            LET g_sfv[l_ac].sfv31=1
            LET g_sfv[l_ac].sfv34=1
            LET g_sfv[l_ac].sfv930=s_costcenter(g_sfu.sfu04) #FUN-670103
            LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
            LET g_sfv[l_ac].sfv41 = g_sfu.sfu06    #FUN-810045 add
            LET g_change='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL cl_set_comp_required('sfv46,sfv47',FALSE)       #FUN-BC0104 add
            CALL cl_set_comp_entry('sfv46,sfv47',TRUE)     #FUN-BC0104 add
            NEXT FIELD sfv03
 
        BEFORE FIELD sfv03                            #default 序號
            IF g_sfv[l_ac].sfv03 IS NULL OR g_sfv[l_ac].sfv03 = 0 THEN
                SELECT max(sfv03)+1 INTO g_sfv[l_ac].sfv03
                  FROM sfv_file WHERE sfv01 = g_sfu.sfu01
                IF g_sfv[l_ac].sfv03 IS NULL THEN
                    LET g_sfv[l_ac].sfv03 = 1
                END IF
            END IF
            #FUN-BC0104---add---str---
            IF p_cmd = 'a' THEN
              CALL cl_set_comp_required('sfv46,sfv47',FALSE)
              CALL cl_set_comp_entry('sfv46,sfv47',TRUE)
            END IF
           #FUN-BC0104---add---end---
 
        AFTER FIELD sfv03                        #check 序號是否重複
            IF cl_null(g_sfv[l_ac].sfv03) THEN NEXT FIELD sfv03 END IF
            IF g_sfv[l_ac].sfv03 != g_sfv_t.sfv03 OR
               g_sfv_t.sfv03 IS NULL THEN
                SELECT count(*) INTO l_n FROM sfv_file
                    WHERE sfv01 = g_sfu.sfu01 AND sfv03 = g_sfv[l_ac].sfv03
                IF l_n > 0 THEN
                    LET g_sfv[l_ac].sfv03 = g_sfv_t.sfv03
                    CALL cl_err('',-239,0) NEXT FIELD sfv03
                END IF
            END IF
 
        AFTER FIELD sfv17
          IF NOT cl_null(g_sfv[l_ac].sfv17) THEN
                   CALL t324_sfv17(p_cmd)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,1)
                      NEXT FIELD sfv17
                   END IF
             #FUN-BC0104---add---str---
             IF p_cmd = 'a' THEN
                CALL t324_sfv46_check() 
             END IF
             #FUN-BC0104---add---end---
          END IF

        #FUN-BC0104---add---str---
        BEFORE FIELD sfv20
         CALL t324_set_entry_b1(p_cmd)
        #FUN-BC0104---add---end--- 

        AFTER FIELD sfv20     #Run Card
         IF cl_null(g_sfv[l_ac].sfv20) THEN NEXT FIELD sfv20 END IF
         #TQC-D70056----add---str--
         #LET g_sfv[l_ac].sfv07=g_sfv[l_ac].sfv20   #add by guanyao160901 #modify by huanglf160922
         LET l_year = YEAR (g_today)
         LET l_year = l_year[3,4]
         LET l_months = MONTH(g_today) USING '&&'
         LET l_day = DAY(g_today) USING '&&'
         LET g_sfv[l_ac].sfv07 = g_sfv[l_ac].sfv11,"-",l_year,l_months,l_day #add by huanglf160922
         DISPLAY BY NAME g_sfv[l_ac].sfv07         #add by guanyao160901
         IF NOT cl_null(g_sfv[l_ac].sfv20) THEN
           SELECT COUNT(*) INTO l_n1 FROM shb_file WHERE shb16 = g_sfv[l_ac].sfv20 AND shbconf = 'Y'
              AND shb06 = (SELECT MAX(sgm03) FROM sgm_file,sfb_file,shm_file
                            WHERE sgm02 = sfb01 AND (sfb04 <> '0' OR sfb04 <> '8') AND sgm01 = shm01
                              AND sgm01 = g_sfv[l_ac].sfv20)
           IF l_n1 = 0 THEN
              CALL cl_err("", 100, 0)
              NEXT FIELD sfv20
           END IF
         END IF
         #TQC-D70056----add---end--
         #IF cl_null(g_sfv_t.sfv20) OR g_sfv[l_ac].sfv20 ! = g_sfv_t.sfv20 THEN #FUN-BC0104
           SELECT shm012,shm28 INTO g_sfv[l_ac].sfv11,l_shm28 FROM shm_file
            WHERE shm01 = g_sfv[l_ac].sfv20
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","shm_file",g_sfv[l_ac].sfv20,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
              NEXT FIELD sfv20
           END IF
           LET g_sfv[l_ac].sfv07 = g_sfv[l_ac].sfv11,"-",l_year,l_months,l_day #add by huanglf160922 --dongy 160923加在这里 
           DISPLAY BY NAME g_sfv[l_ac].sfv07         #add by guanyao160901
          #加入RUN CARD 結案碼  
           IF l_shm28='Y' THEN
              CALL cl_err(g_sfv[l_ac].sfv20,'asf-911',0)
              NEXT FIELD sfv20
           END IF
           DISPLAY BY NAME g_sfv[l_ac].sfv11
           CALL t324_set_no_entry_b(p_cmd) #FUN-810045 end
           #檢查工單最小發料日是否小於入庫日
           #TQC-B90222  --begin
          # SELECT MIN(sfp02) INTO l_date FROM sfs_file,sfp_file
          #  WHERE sfs03=g_sfv[l_ac].sfv11 AND sfp01=sfs01
            SELECT MIN(sfp03) INTO l_date FROM sfs_file,sfp_file
            WHERE sfs03=g_sfv[l_ac].sfv11 AND sfp01=sfs01 AND sfp04 = 'Y'
           #TQC-B90222  --end
           IF STATUS OR cl_null(l_date) THEN
          #TQC-B90222  --begin
          #    SELECT MIN(sfp02) INTO l_date FROM sfe_file,sfp_file
          #     WHERE sfe01 = g_sfv[l_ac].sfv11 AND sfe02 = sfp01
              SELECT MIN(sfp03) INTO l_date FROM sfe_file,sfp_file
               WHERE sfe01 = g_sfv[l_ac].sfv11 AND sfe02 = sfp01 AND sfp04 = 'Y'
          #TQC-B90222  --end
           END IF
           SELECT sfb39 INTO g_sfb.sfb39 FROM sfb_file 
              WHERE sfb01 = g_sfv[l_ac].sfv11
          #FUN-D70008-mark---str
          #IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
          #   IF g_sfb.sfb39 != '2' THEN                   #No.MOD-690045 add
          #      CALL cl_err('sel_sfp02','asf-824',1)
          #      NEXT FIELD sfv20
          #   END IF                                       #No.MOD-690045 add
          #END IF
          #FUN-D70008-mark---end
           IF g_argv = '1' THEN
              CALL t324_sfb01(l_ac)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD sfv20
              END IF
              IF cl_null(g_sfb.sfb01) THEN
                 LET g_sfv[l_ac].sfv11=g_sfv_t.sfv11
                 NEXT FIELD sfv11
              END IF
 
              IF g_sfb.sfb94='Y' AND
                 cl_null(g_sfv[l_ac].sfv17)  THEN
                 CALL cl_err(g_sfb.sfb01,'asf-680',0)
                 NEXT FIELD sfv20
              END IF
 
              IF g_sfb.sfb39 != '2' THEN
                 #工單完工方式為'2' pull 不check min_set
                 #最小套=min_set
                 LET g_min_set = 0
                 #CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'')
                 #FUN-A60095--begin--add-------
              
                 IF cl_null(g_sfv[l_ac].sfv20) OR g_min_set = 0 THEN
                 #FUN-A60095--end--add-----------
                 #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','')  #FUN-A60027 #FUN-C70037 mark
                    CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037 
                    RETURNING g_cnt,g_min_set # default 時不考慮超限率
                    IF g_cnt !=0  THEN
                       CALL cl_err('s_minp()','asf-549',0) NEXT FIELD sfv20
                    END IF
                    #str----add by guanyao160901
                    LET g_sfv[l_ac].l_min = g_min_set
                    DISPLAY BY NAME g_sfv[l_ac].l_min
                    #str----add by guanyao160901
                 END IF   #FUN-A60095
                 #-->sma73 工單完工數量是否檢查發料最小套數
                 #-->sma74 工單完工量容許差異百分比
                 CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153  #FUN-910053  
                 IF g_sma.sma73='Y' THEN  #
                    LET g_over_qty=((g_min_set*l_ima153)/100)    #FUN-910053
                 ELSE
                    LET g_over_qty=0
                 END IF
                 IF g_over_qty IS NULL THEN LET g_over_qty=0 END IF  #No.MOD-5A0444 add
                 #-->sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
                 SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                  WHERE sfv20 = g_sfv[l_ac].sfv20
                    AND sfv01 = sfu01
                    AND (sfv01 != g_sfu.sfu01 OR                               #MOD-880066   
                        (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))  #MOD-880066
                    AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                    AND sfuconf <> 'X' 
 
                 IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
 
                 SELECT SUM(sfv09) INTO tmp_woqty FROM sfv_file,sfu_file
                  WHERE sfv11 = g_sfv[l_ac].sfv11
                    AND sfv01 = sfu01
                    AND (sfv01 != g_sfu.sfu01 OR                               
                        (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03)) 
                    AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                    AND sfuconf <> 'X' 
 
                 IF tmp_woqty IS NULL THEN LET tmp_woqty=0 END IF
                 #add by donghy  160826--start
                 IF g_sma.sma73 = 'Y' THEN #str-----add by guanyao160907
                 IF g_min_set - tmp_woqty <= 0 THEN 
                    MESSAGE '入库数量不可大于发量数量'
                    NEXT FIELD sfv20
                 END IF

                 IF g_min_set - tmp_woqty > 0 THEN
                    SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01=g_sfv[l_ac].sfv20
                    IF g_min_set - tmp_woqty > l_shm08 THEN 
                       LET g_sfv[l_ac].sfv09=l_shm08
                    ELSE
                       LET g_sfv[l_ac].sfv09=g_min_set - tmp_woqty 
                    END IF
                 END IF 
                 END IF 
                 #add by donghy  160826--end
                 #LET g_sfv[l_ac].sfv09=g_min_set - tmp_woqty
                 LET g_min_set=g_min_set + g_over_qty
                 DISPLAY BY NAME g_sfv[l_ac].sfv09

                 IF cl_null(g_min_set) THEN LET g_min_set = 0 END IF
                 IF cl_null(tmp_qty) THEN LET tmp_qty = 0 END IF
                 IF cl_null(g_sfv[l_ac].sfv09) THEN LET g_sfv[l_ac].sfv09 = 0 END IF
                 IF cl_null(g_over_qty) THEN LET g_over_qty = 0 END IF
 
                 #-------最小套數-----------------------------------------
                 #LET g_msg= g_x[1] CLIPPED,g_min_set USING '########.#'
                 LET g_msg= '最小发料套数:',g_min_set USING '########.#'
                 CASE WHEN g_sma.sma73='Y' AND l_ima153>0
                           LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'
                      WHEN g_sma.sma73='Y' AND l_ima153<0
                           LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'
                      OTHERWISE EXIT CASE
                 END CASE
 
                 LET g_msg=g_msg CLIPPED,
                    #g_x[2] CLIPPED,tmp_qty USING '####.#',    #已登打入庫量
                   "     已入库量:",tmp_qty USING '########.#',    #已登打入庫量
                    #g_x[3] CLIPPED,(g_sfv[l_ac].sfv09 + g_over_qty)
                    '     剩余可入库量：',(g_sfv[l_ac].sfv09 + g_over_qty)
                                   USING '########.#' #可入庫量
                 ERROR g_msg
                 #-->取最終製程之總轉出量(良品轉出量+Bonus)
                 IF g_sfb.sfb93='Y' THEN  # 製程否
                    CALL s_schdat_max_sgm03(g_sfv[l_ac].sfv20) RETURNING l_ecm012,l_ecm03     #FUN-A60076 
                    SELECT sgm311,sgm315 INTO g_sgm311,g_sgm315 FROM sgm_file
                     WHERE sgm01=g_sfv[l_ac].sfv20
                      #AND sgm03= (SELECT MAX(sgm03) FROM sgm_file       #FUN-A60076 	mark                
                      #             WHERE sgm01=g_sfv[l_ac].sfv20)       #FUN-A60076    mark
                       AND sgm03 = l_ecm03                               #FUN-A60076 
                       AND sgm012 = l_ecm012                             #FUN-A60076 
                    IF STATUS THEN LET g_sgm311=0 LET g_sgm315 = 0 END IF
 
                    LET g_sgm_out=g_sgm311 + g_sgm315
                    IF g_min_set>g_sgm_out THEN
                       LET g_sfv[l_ac].sfv09=g_sgm_out - tmp_qty
                       DISPLAY BY NAME g_sfv[l_ac].sfv09
                    END IF
 
                    LET g_msg= g_x[1] CLIPPED,g_min_set USING '####.#' #最小套數
 
                    CASE WHEN g_sma.sma73='Y' AND l_ima153>0
                              LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'
                         WHEN g_sma.sma73='Y' AND l_ima153<0
                              LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'
                    END CASE
 
                    LET g_msg=g_msg CLIPPED,
                              g_x[4] CLIPPED,g_sgm_out USING '####.#',#終站總轉出量
                              g_x[2] CLIPPED,tmp_qty USING '####.#',  #已登打入庫量
                              g_x[3] CLIPPED,(g_sfv[l_ac].sfv09+g_over_qty)
                                              USING '####.#' #可入庫量
                    ERROR g_msg
 
                 END IF
                 IF g_sfb.sfb94='Y' THEN #是否使用FQC功能
                    #FQC入庫量合計
                    SELECT SUM(sfv09) INTO l_sum_sfv09 FROM sfv_file,sfu_file
                     WHERE sfv17 = g_sfv[l_ac].sfv17
                       AND (( sfv01 != g_sfu.sfu01 ) OR
                            ( sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03 ))
                       AND sfv01 = sfu01
                       AND sfuconf !='X' #FUN-660137
                    IF cl_null(l_sum_sfv09) THEN
                       LET l_sum_sfv09 = 0
                    END IF
                    #FQC單合格量合計
                    SELECT qcf091 INTO l_qcf091 FROM qcf_file   # QC
                     WHERE qcf01 = g_sfv[l_ac].sfv17
                       AND qcf09 <> '2'   #accept   #MOD-940383
                       AND qcf14 = 'Y'
                    IF cl_null(l_qcf091) THEN LET l_qcf091 = 0 END IF
                      #default 未入庫量 = FQC單合格量合計 - FQC入庫量合計
                       LET g_sfv[l_ac].sfv09=l_qcf091 - l_sum_sfv09
                       DISPLAY BY NAME g_sfv[l_ac].sfv09
                    LET g_msg=g_x[1] CLIPPED,g_min_set USING '####.#'  #最小套數
 
                    CASE WHEN g_sma.sma73='Y' AND l_ima153>0
                              LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'
                         WHEN g_sma.sma73='Y' AND l_ima153<0
                              LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'
                    END CASE
                    LET g_msg=g_msg CLIPPED,
                              g_x[5] CLIPPED,l_qcf091 USING '####.#', #FQC量
                              g_x[2] CLIPPED,tmp_qty USING '####.#',  #已登打入庫量
                              g_x[3] CLIPPED,(g_sfv[l_ac].sfv09+g_over_qty)
                                              USING '####.#' #可入庫量
                    ERROR g_msg
 
                 END IF
              END IF
                  SELECT * INTO g_ima.* FROM ima_file
                    WHERE ima01 = (SELECT sfb05 FROM sfb_file
                                    WHERE sfb01 = g_sfv[l_ac].sfv11)
                  IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2'
                    AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
                      SELECT COUNT(*) INTO g_cnt FROM bmm_file
                       WHERE bmm01 = g_ima.ima01
                      IF g_cnt >= 1 THEN
                          LET g_sfv16 = 'Y'
                   #      NEXT FIELD sfv04     #FUN-BC0104 mark
                      ELSE
                          LET g_sfv16 = 'N'    #FUN-BC0104 add
                          CALL t324_set_no_entry_b1('u')
                   #      NEXT FIELD sfv05     #FUN-BC0104 mark
                      END IF
                  ELSE
                      LET g_sfv16 = 'N'        #FUN-BC0104
                      CALL t324_set_no_entry_b1('u')
                   #  NEXT FIELD sfv05         #FUN-BC0104 mark
                  END IF
           ELSE   #退庫
              CALL t324_sfb011(l_ac)
              #-->sum(已存在退庫單退庫數量) by W/O (不管有無過帳)
               SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                WHERE sfv11 = g_sfv[l_ac].sfv11
                  AND sfv01 = sfu01
                  AND sfu00 = '2'   #類別 1.入庫  2.入庫退回
                  AND sfuconf <> 'X' #FUN-660137
                 IF cl_null(tmp_qty) THEN LET tmp_qty=0 END IF
                 LET g_sfv[l_ac].sfv09= g_sfb.sfb09 - tmp_qty
               SELECT * INTO g_ima.* FROM ima_file
                 WHERE ima01 = (SELECT sfb05 FROM sfb_file
                                 WHERE sfb01 = g_sfv[l_ac].sfv11)
               IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2'
                  AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
                   SELECT COUNT(*) INTO g_cnt FROM bmm_file
                    WHERE bmm01 = g_ima.ima01
                   IF g_cnt >= 1 THEN
                       LET g_sfv16 = 'Y'
                #      NEXT FIELD sfv04     #FUN-BC0104 mark
                   ELSE
                       LET g_sfv16 = 'N'        #FUN-BC0104
                       CALL t324_set_no_entry_b1('u')
                #      NEXT FIELD sfv05     #FUN-BC0104 mark
                   END IF
               ELSE
                   LET g_sfv16 = 'N'        #FUN-BC0104
                   CALL t324_set_no_entry_b1('u')
                #  NEXT FIELD sfv05         #FUN-BC0104 mark
               END IF
 
           END IF
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_sfv[l_ac].sfv11,g_errno,0)
              NEXT FIELD sfv20
           END IF
          #FUN-D70008-add---str
          IF g_sma.sma73 = 'Y' THEN #add by guanyao160902
           IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
              IF g_sfb.sfb39 != '2' THEN  
                 CALL cl_err('sel_sfp02','asf-824',1)
                 NEXT FIELD sfv20
              END IF                     
           END IF
          END IF 
          #FUN-D70008-add---end
           SELECT ima571 INTO g_ima571 FROM ima_file WHERE ima01=g_sfb.sfb05
           IF g_ima571 IS NULL THEN LET g_ima571=' ' END IF
           LET l_ecu04=0 LET l_ecu05=0
           IF g_sfb.sfb93 = 'Y' THEN  #製程否
              SELECT ecu04,ecu05 INTO l_ecu04,l_ecu05 FROM ecu_file
               WHERE ecu01=g_ima571 AND ecu02=g_sfb.sfb06
              IF g_argv MATCHES '[0]' AND l_ecu04=l_ecu05 THEN
                 CALL cl_err('','asf-702',0) NEXT FIELD sfv20
              END IF
           END IF
         #END IF #FUN-BC0104
         CALL t324_set_no_entry_b1(p_cmd)  #FUN-BC0104
 
        AFTER FIELD sfv05     #倉庫
           IF g_argv MATCHES '[12]' THEN
              IF cl_null(g_sfv[l_ac].sfv05) THEN NEXT FIELD sfv05 END IF
              SELECT imd02 INTO g_buf FROM imd_file
           #    WHERE imd01=g_sfv[l_ac].sfv05 AND imd10='S'                  #MOD-B50097 mark
                WHERE imd01=g_sfv[l_ac].sfv05 AND (imd10='S' OR imd10='W')   #MOD-B50097 add
                  AND imdacti = 'Y' #MOD-4B0169
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",g_sfv[l_ac].sfv05,"","mfg1100","","imd",1)   #No.FUN-660128
                 NEXT FIELD sfv05
              END IF
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv05) THEN
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_sfv[l_ac].sfv04, g_sfu.sfu01,
                           g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06) THEN
                 NEXT FIELD sfv05
              END IF
              #FUN-D20060----add---end--
              #Add No.FUN-AA0082
              IF NOT s_chk_ware(g_sfv[l_ac].sfv05) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD sfv05
              END IF
              #End Add No.FUN-AA0082
              IF cl_null(g_sfv_t.sfv05) OR
                 g_sfv_t.sfv05 <> g_sfv[l_ac].sfv05 THEN
                 LET g_change='Y'
              END IF
              #FUN-BC0104---add---str---
              IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
                 IF NOT t324_sfv05_check() THEN
                    CALL cl_err('','aqc-524',0)
                    NEXT FIELD sfv05
                 END IF
              END IF
              #FUN-BC0104---add---end---
              
           END IF
 
        AFTER FIELD sfv06    #儲位
           #控管是否為全型空白
           IF g_sfv[l_ac].sfv06 = '　' THEN #全型空白
               LET g_sfv[l_ac].sfv06 = ' '
           END IF
           IF g_argv MATCHES '[12]' THEN
           IF g_sfv[l_ac].sfv06 IS NULL THEN LET g_sfv[l_ac].sfv06 = ' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_sfv[l_ac].sfv05) THEN  #FUN-D20060 add
           IF NOT s_chksmz(g_sfv[l_ac].sfv04, g_sfu.sfu01,
                           g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06) THEN
              NEXT FIELD sfv05
           END IF
           END IF  #FUN-D20060 add
           END IF
           IF g_sfv[l_ac].sfv06 IS NOT NULL THEN
              IF cl_null(g_sfv_t.sfv06) OR
                 g_sfv_t.sfv06 <> g_sfv[l_ac].sfv06 THEN
                 LET g_change='Y'
              END IF
           END IF
 
        AFTER FIELD sfv07    #批號
           #BugNo:5626 控管是否為全型空白
           IF g_sfv[l_ac].sfv07 = '　' THEN #全型空白
               LET g_sfv[l_ac].sfv07 = ' '
           END IF
           IF g_argv MATCHES '[12]' THEN
              IF g_sfv[l_ac].sfv07 IS NULL THEN LET g_sfv[l_ac].sfv07 = ' ' END IF
                 SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                  WHERE img01=g_sfv[l_ac].sfv04 AND img02=g_sfv[l_ac].sfv05
                    AND img03=g_sfv[l_ac].sfv06 AND img04=g_sfv[l_ac].sfv07
              IF STATUS = 100 THEN
                 IF NOT cl_confirm('mfg1401') THEN NEXT FIELD sfv07 END IF
                 CALL s_add_img(g_sfv[l_ac].sfv04, g_sfv[l_ac].sfv05,
                                g_sfv[l_ac].sfv06, g_sfv[l_ac].sfv07,
                                g_sfu.sfu01,       g_sfv[l_ac].sfv03,g_today)
                 IF g_errno='N' THEN NEXT FIELD sfv07 END IF
                 SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                  WHERE img01=g_sfv[l_ac].sfv04 AND img02=g_sfv[l_ac].sfv05
                    AND img03=g_sfv[l_ac].sfv06 AND img04=g_sfv[l_ac].sfv07
              END IF
              IF cl_null(g_sfv[l_ac].sfv08) THEN   #若單位空白
                 LET g_sfv[l_ac].sfv08=g_img09
                 DISPLAY BY NAME g_sfv[l_ac].sfv08
 
              END IF
              IF g_sfv[l_ac].sfv07 IS NOT NULL THEN
                 IF cl_null(g_sfv_t.sfv07) OR
                    g_sfv_t.sfv07 <> g_sfv[l_ac].sfv07 THEN
                    LET g_change='Y'
                 END IF
              END IF
              CALL t324_du_default(p_cmd)
           END IF
 
        BEFORE FIELD sfv09    #入庫量
           ERROR g_msg
 
        AFTER FIELD sfv09    #入庫量
           IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0 THEN
              LET g_sfv[l_ac].sfv09 = 0
              NEXT FIELD sfv09
           END IF
           #No.FUN-BB0086--add--start--
           IF NOT cl_null(g_sfv[l_ac].sfv09) AND NOT cl_null(g_sfv[l_ac].sfv08) THEN
              IF cl_null(g_sfv_t.sfv09) OR g_sfv_t.sfv09 != g_sfv[l_ac].sfv09 THEN
                 LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08)
                 DISPLAY BY NAME g_sfv[l_ac].sfv09
              END IF
           END IF
           #No.FUN-BB0086--add--end--
##------------------------------------------------
           IF g_argv MATCHES '[12]' THEN   #入庫,退回
              SELECT shm08,shm09 INTO l_sfb08,l_sfv09 FROM shm_file
               WHERE shm01 = g_sfv[l_ac].sfv20
              IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
              IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
              IF g_argv = '2' THEN   #退庫時不可大於入庫數量
                 IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
                    CALL cl_err3("sel","shm_file",g_sfv[l_ac].sfv20,"","asf-712","","",1)   #No.FUN-660128
                    NEXT FIELD sfv09
                 END IF
              END IF
           END IF
##----------------------------------------
   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11
           
#str-----add by huanglf160806
         IF g_argv = '1' THEN 
               SELECT  shm08  INTO l_shm08 FROM shm_file WHERE shm01 = g_sfv[l_ac].sfv20
            IF g_sfv[l_ac].sfv09 > l_shm08 THEN 
              LET g_sfv[l_ac].sfv09  = ''
              CALL cl_err(g_sfv[l_ac].sfv09,"csf-067",1)
              NEXT FIELD sfv09
              
            END IF 
              
         END IF 
#end----add by huanglf160806

#str-----add by huanglf160808
         IF g_argv = '1' THEN 
              SELECT SUM(sfv09) INTO l_sum_sfv09_1 FROM sfv_file,sfu_file WHERE sfv01 = sfu01 
              AND sfuconf!='X' AND sfv20 = g_sfv[l_ac].sfv20  AND sfv04 = g_sfv[l_ac].sfv04
              SELECT sfv09 INTO l_sfv09_1 FROM sfv_file,sfu_file WHERE sfv01 = sfu01 AND sfu01 = g_sfu.sfu01
             AND sfv20 = g_sfv[l_ac].sfv20  AND sfv04 = g_sfv[l_ac].sfv04 AND sfuconf!='X'
          IF cl_null(l_sfv09_1) THEN 
             LET l_sfv09_1 = 0
          END IF 
          LET l_sum_sfv09_1 = l_sum_sfv09_1 - l_sfv09_1 + g_sfv[l_ac].sfv09
          IF l_sum_sfv09_1 > l_shm08 THEN  
              LET g_sfv[l_ac].sfv09  = ''
              CALL cl_err(g_sfv[l_ac].sfv09,"csf-070",1)
              NEXT FIELD sfv09
            END IF 
              
         END IF 
#end----add by huanglf160808


          #工單完工方式為'2' pull
           IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
              g_sfb.sfb39 <> '2' THEN
              # check 入庫數量 不可 大於 (生產數量-完工數量)
 
# sma73 工單完工數量是否檢查發料最小套數
# sma74 工單完工量容許差異百分比
              #入庫量不可大於最小套數-以keyin 入庫量
              IF g_sma.sma73='Y'  #
                 AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_woqty) THEN
                    CALL cs_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037 
                       RETURNING g_cnt,g_min_set # default 時不考慮超限率
                    #add by donghy 增加cs_minp 允许有0.01的误差率
 
                    IF (g_sfv[l_ac].sfv09) > (g_min_set-tmp_woqty) THEN
                       #tianry add 161227 放宽比例0.01
                       IF (g_sfv[l_ac].sfv09-(g_min_set-tmp_woqty))/g_sfv[l_ac].sfv09<0.05 THEN
                       ELSE
                          CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)   #TQC-760118 modify 0->1
                          NEXT FIELD sfv09
                       END IF 
                    END IF
              END IF
 
              IF g_sfb.sfb93='Y' AND # 走製程 check 轉出量
                 (g_sfv[l_ac].sfv09) > g_sgm_out - tmp_qty THEN
                 IF NOT t324_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv20,g_sfv[l_ac].sfv09) THEN  #FUN-A90057
                    CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)   #TQC-760118 modify 0->1
                    NEXT FIELD sfv09
                 END IF
              END IF
              IF g_sfb.sfb94='Y' AND #是否使用FQC功能
                 (g_sfv[l_ac].sfv09) > l_qcf091 - tmp_qty
                 THEN
                 CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                 NEXT FIELD sfv09
              END IF
           END IF
           IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
              g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
           THEN
              #----退回量不可大於完工入庫量
              CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
              NEXT FIELD sfv09
           END IF
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfv[l_ac].sfv04
              AND imaacti = "Y"
           
           IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
              (cl_null(g_sfv_t.sfv09) OR (g_sfv[l_ac].sfv09<>g_sfv_t.sfv09 )) THEN
              IF cl_null(g_sfv[l_ac].sfv06) THEN
                 LET g_sfv[l_ac].sfv06 = ' '
              END IF
              IF cl_null(g_sfv[l_ac].sfv07) THEN
                 LET g_sfv[l_ac].sfv07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_sfv[l_ac].sfv04
                 AND img02=g_sfv[l_ac].sfv05
                 AND img03=g_sfv[l_ac].sfv06
                 AND img04=g_sfv[l_ac].sfv07
              CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#No.CHI-9A0022 --Begin
              IF cl_null(g_sfv[l_ac].sfv41) THEN
                 LET l_bno = ''
              ELSE
                 LET l_bno = g_sfv[l_ac].sfv41
              END IF
#No.CHI-9A0022 --End
#TQC-B90236---mark--begin
#             CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                          g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                          l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark--end
#TQC-B90236---add---begin
              CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                             g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                             g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                             g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236---add---end
                     RETURNING l_r,g_qty 
              IF l_r = "Y" THEN
                 LET g_sfv[l_ac].sfv09 = g_qty
                 LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08) #FUN-BB0086 add
              END IF
           END IF
           
          #工單完工方式為'2' pull(sfb39='2')&走製程(sfb93='Y')
             IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
                g_sfb.sfb39= '2' THEN
               #check 最終製程之總轉出量(良品轉出量+Bonus)
                CALL s_schdat_max_sgm03(g_sfv[l_ac].sfv20) RETURNING l_ecm012,l_ecm03    #FUN-A60076 
                SELECT sgm311,sgm315 INTO l_sgm311,l_sgm315 FROM sgm_file
                 WHERE sgm02=g_sfv[l_ac].sfv11
                   AND sgm01=g_sfv[l_ac].sfv20
                 # AND sgm03= (SELECT MAX(sgm03) FROM sgm_file      #FUN-A60076 mark 
                 #              WHERE sgm02=g_sfv[l_ac].sfv11       #FUN-A60076 mark 
                 #                AND sgm01=g_sfv[l_ac].sfv20)      #FUN-A60076 mark
                   AND sgm03 = l_ecm03         #FUN-A60076
                   AND sgm012 = l_ecm012       #FUN-A60076  
                IF SQLCA.sqlcode THEN
                   LET l_sgm311=0
                   LET l_sgm315=0
                END IF
                LET l_sgm_out=l_sgm311 + l_sgm315
 
 
                LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
                SELECT SUM(sfv09) INTO l_qty1 FROM sfv_file,sfu_file
                 WHERE sfv11 = g_sfv[l_ac].sfv11
                   AND sfv20 = g_sfv[l_ac].sfv20
                   AND sfv01 ! = g_sfu.sfu01  
                   AND sfv01 = sfu01
                   AND sfu00 = '1'           #完工入庫
                   AND sfupost <> 'X'
                IF l_qty1 IS NULL THEN LET l_qty1 =0 END IF
 
                SELECT SUM(sfv09) INTO l_qty2 FROM sfv_file,sfu_file
                 WHERE sfv11 = g_sfv[l_ac].sfv11
                   AND sfv20 = g_sfv[l_ac].sfv20
                   AND sfv01 = g_sfu.sfu01   
                   AND sfv03!= g_sfv[l_ac].sfv03
                   AND sfv01 = sfu01
                   AND sfu00 = '1'           #完工入庫
                   AND sfupost <> 'X'
                IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF
 
                LET l_sfv09 = l_qty1 + l_qty2 + g_sfv[l_ac].sfv09
 
                #入庫量 > 製程最後轉出量
                IF l_sfv09 > l_sgm_out THEN
                   LET g_msg ="(",l_sfv09   USING '######.###','>',
                              l_sgm_out USING '######.###',")"
                   IF NOT t324_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv20,g_sfv[l_ac].sfv09) THEN  #FUN-A90057
                      CALL cl_err(g_msg,'asf-675',1)
                      NEXT FIELD sfv09
                   END IF
                END IF
            END IF
 
           CALL t324_set_no_entry_b('a')
           #FUN-BC0104---add---str
           IF NOT cl_null(g_sfv[l_ac].sfv09) THEN
              CALL t324_qcl05_check() RETURNING l_qcl05
              IF l_qcl05 = '0' OR l_qcl05 = '2' THEN       #TQC-C30013
                 CALL t324_sfv09_check(p_cmd) RETURNING l_sum
                 IF g_sfv[l_ac].sfv09 > l_sum THEN
                    CALL cl_err('','apm-804',1)
                    LET g_sfv[l_ac].sfv09 = l_sum
                    DISPLAY BY NAME g_sfv[l_ac].sfv09
                    NEXT FIELD sfv09
                 END IF
              END IF
            END IF
           #FUN-BC0104---add---end
 
 
        BEFORE FIELD sfv33
           CALL t324_set_no_required()
 
        AFTER FIELD sfv33  #第二單位
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv05
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv33) THEN
              CALL t324_unit(g_sfv[l_ac].sfv33)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD sfv33
              END IF
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_img09,g_sfv[l_ac].sfv33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv33,g_errno,0)
                 NEXT FIELD sfv33
              END IF
              LET g_sfv[l_ac].sfv34 = g_factor
              CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                              g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                              g_sfv[l_ac].sfv33) RETURNING g_cnt
              IF g_cnt = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD sfv33
                    END IF
                 END IF
                 CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                 g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,
                                 g_sfu.sfu01,
                                 g_sfv[l_ac].sfv03,0) RETURNING g_cnt
                 IF g_cnt = 1 THEN
                    NEXT FIELD sfv33
                 END IF
              END IF
              #No.FUN-BB0086--add--start--
         
              LET g_sfv33_t = g_sfv[l_ac].sfv33
              #No.FUN-BB0086--add--end--
           END IF
           CALL t324_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
 
        BEFORE FIELD sfv35
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv07
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv33) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_img09,g_sfv[l_ac].sfv33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv33,g_errno,0)
                 NEXT FIELD sfv05
              END IF
              LET g_sfv[l_ac].sfv34 = g_factor
              CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                              g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                              g_sfv[l_ac].sfv33) RETURNING g_cnt
              IF g_cnt = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD sfv04
                    END IF
                 END IF
                 CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                 g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,
                                 g_sfu.sfu01,
                                 g_sfv[l_ac].sfv03,0) RETURNING g_cnt
                 IF g_cnt = 1 THEN
                    NEXT FIELD sfv04
                 END IF
              END IF
           END IF
         
 
        AFTER FIELD sfv35  #第二數量
           
           #No.FUN-BB0086--mark--start--
           #IF NOT cl_null(g_sfv[l_ac].sfv35) THEN
           #   IF g_sfv[l_ac].sfv35 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD sfv35
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_sfv[l_ac].sfv35*g_sfv[l_ac].sfv34
           #         IF cl_null(g_sfv[l_ac].sfv32) OR g_sfv[l_ac].sfv32=0 THEN #CHI-960022
           #            LET g_sfv[l_ac].sfv32=g_tot*g_sfv[l_ac].sfv31
           #            DISPLAY BY NAME g_sfv[l_ac].sfv32
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           ##copy from AFTER FIELD sfv09
           #SELECT ima918,ima921 INTO g_ima918,g_ima921 
           #  FROM ima_file
           # WHERE ima01 = g_sfv[l_ac].sfv04
           #   AND imaacti = "Y"
           # 
           # IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
           #   (cl_null(g_sfv_t.sfv35) OR (g_sfv[l_ac].sfv35<>g_sfv_t.sfv35 )) THEN
           #   IF cl_null(g_sfv[l_ac].sfv06) THEN
           #      LET g_sfv[l_ac].sfv06 = ' '
           #   END IF
           #   IF cl_null(g_sfv[l_ac].sfv07) THEN
           #      LET g_sfv[l_ac].sfv07 = ' '
           #   END IF
           #   SELECT img09 INTO g_img09 FROM img_file
           #    WHERE img01=g_sfv[l_ac].sfv04
           #      AND img02=g_sfv[l_ac].sfv05
           #      AND img03=g_sfv[l_ac].sfv06
           #      AND img04=g_sfv[l_ac].sfv07
           #   CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
           #       RETURNING l_i,l_fac
           #   IF l_i = 1 THEN LET l_fac = 1 END IF
           ##No.CHI-9A0022 --Begin
           #   IF cl_null(g_sfv[l_ac].sfv41) THEN
           #      LET l_bno = ''
           #   ELSE
           #      LET l_bno = g_sfv[l_ac].sfv41
           #   END IF
           ##No.CHI-9A0022 --End
           #   CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
           #                g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
           #                l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
           #          RETURNING l_r,g_qty 
           #   IF l_r = "Y" THEN
           #      LET g_sfv[l_ac].sfv09 = g_qty
           #   END IF
           #END IF
           # 
           #CALL t324_set_no_entry_b('a')
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--start--
 
        BEFORE FIELD sfv30
           CALL t324_set_no_required()
 
        AFTER FIELD sfv30  #第一單位
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv07
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv30) THEN
              CALL t324_unit(g_sfv[l_ac].sfv30)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD sfv30
              END IF
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv30,g_errno,0)
                 NEXT FIELD sfv30
              END IF
              LET g_sfv[l_ac].sfv31 = g_factor
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                 g_sfv[l_ac].sfv30) RETURNING g_cnt
                 IF g_cnt = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD sfv30
                       END IF
                    END IF
                    CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                    g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                    g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31,
                                    g_sfu.sfu01,
                                    g_sfv[l_ac].sfv03,0) RETURNING g_cnt
                    IF g_cnt = 1 THEN
                       NEXT FIELD sfv30
                    END IF
                 END IF
              END IF
           END IF
           CALL t324_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--add--start---
           LET l_case = ''
           LET l_tf = ''
           IF NOT cl_null(g_sfv[l_ac].sfv32) AND g_sfv[l_ac].sfv32<>0 THEN
              CALL t324_sfv32_check(l_qcf091,l_sfb08,l_sfv09) RETURNING l_tf,l_case
           END IF
           LET g_sfv30_t = g_sfv[l_ac].sfv30
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "sfv32"
                    NEXT FIELD sfv32
                 WHEN "sfv35"
                    NEXT FIELD sfv35
                 WHEN "sfv05"
                    NEXT FIELD sfv05
                 OTHERWISE EXIT CASE 
              END CASE    
           END IF 
           #No.FUN-BB0086--add--start---
 
        AFTER FIELD sfv32  #第一數量
           #No.FUN-BB0086--add--start---
           CALL t324_sfv32_check(l_qcf091,l_sfb08,l_sfv09) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "sfv32"
                    NEXT FIELD sfv32
                 WHEN "sfv35"
                    NEXT FIELD sfv35
                 WHEN "sfv05"
                    NEXT FIELD sfv05
                 OTHERWISE EXIT CASE 
              END CASE    
           END IF 
           #No.FUN-BB0086--add--start---

           #No.FUN-BB0086--mark--start---
           #IF NOT cl_null(g_sfv[l_ac].sfv32) THEN
           #   IF g_sfv[l_ac].sfv32 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD sfv32
           #   END IF
           #END IF
           #CALL t324_du_data_to_correct()
           #CALL t324_set_origin_field()
           #CALL t324_unit(g_sfv[l_ac].sfv08)
           #IF NOT cl_null(g_errno) THEN
           #   CALL cl_err('',g_errno,0)
           #   NEXT FIELD sfv05
           #END IF
           #IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0 THEN
           #   LET g_sfv[l_ac].sfv09 = 0
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD sfv35
           #   ELSE
           #      NEXT FIELD sfv32
           #   END IF
           #END IF
           #IF g_argv MATCHES '[12]' THEN   #入庫,退回
           #   SELECT shm08,shm09 INTO l_sfb08,l_sfv09 FROM shm_file
           #    WHERE shm01 = g_sfv[l_ac].sfv20
           #   IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
           ##   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
           #   IF g_argv = '2' THEN   #退庫時不可大於入庫數量
           #      IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
           #         CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
           #         IF g_ima906 MATCHES '[23]' THEN
           #            NEXT FIELD sfv35
           #         ELSE
           #            NEXT FIELD sfv32
           #         END IF
           #      END IF
           #   END IF
           #END IF
           ##工單完工方式為'2' pull
           #IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
           #   g_sfb.sfb39 <> '2' THEN
           #   # check 入庫數量 不可 大於 (生產數量-完工數量)
 
           ## sma73 工單完工數量是否檢查發料最小套數
           ## sma74 工單完工量容許差異百分比
           #   #入庫量不可大於最小套數-以keyin 入庫量
           #   IF g_sma.sma73='Y'  #
           #      AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_woqty) THEN
           #      CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',0)
           #      IF g_ima906 MATCHES '[23]' THEN
           #         NEXT FIELD sfv35
           #      ELSE
           #         NEXT FIELD sfv32
           #      END IF
           #   END IF
 
           #   IF g_sfb.sfb93='Y' AND # 走製程 check 轉出量
           #      (g_sfv[l_ac].sfv09) > g_sgm_out - tmp_qty THEN
           #      IF NOT t324_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv20,g_sfv[l_ac].sfv09) THEN  #FUN-A90057
           #         CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',0)
           #         IF g_ima906 MATCHES '[23]' THEN
           #            NEXT FIELD sfv35
           #         ELSE
           #            NEXT FIELD sfv32
           #         END IF
           #      END IF
           #   END IF
           #   IF g_sfb.sfb94='Y' AND #是否使用FQC功能
           #      (g_sfv[l_ac].sfv09) > l_qcf091 - tmp_qty
           #      THEN
           #      #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
           #      CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
           #      IF g_ima906 MATCHES '[23]' THEN
           #         NEXT FIELD sfv35
           #      ELSE
           #         NEXT FIELD sfv32
           #      END IF
           #   END IF
           #END IF
           #IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
           #   g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
           #THEN
           #   #----退回量不可大於完工入庫量
           #   CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD sfv35
           #   ELSE
           #      NEXT FIELD sfv32
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end---
 
 
       AFTER FIELD sfv41
          IF NOT cl_null(g_sfv[l_ac].sfv41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_sfv[l_ac].sfv41
                AND pjaacti = 'Y'    
                AND pjaclose='N'     #FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv41,'asf-984',0)
                NEXT FIELD sfv41
             END IF
          ELSE 
             NEXT FIELD sfv12    #IF 專案沒輸入資料，直接跳到理由碼,WBS/活動不可輸入
          END IF
         
       BEFORE FIELD sfv42
         IF cl_null(g_sfv[l_ac].sfv41) THEN
            NEXT FIELD sfv41
         END IF
 
       AFTER FIELD sfv42
          IF NOT cl_null(g_sfv[l_ac].sfv42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_sfv[l_ac].sfv41
                AND pjb02 = g_sfv[l_ac].sfv42
                AND pjbacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv42,'apj-051',0)
                LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                NEXT FIELD sfv42
             END IF
             SELECT pjb09,pjb11
               INTO l_pjb09,l_pjb11 
               FROM pjb_file
              WHERE pjb01 = g_sfv[l_ac].sfv41
                AND pjb02 = g_sfv[l_ac].sfv42
                AND pjb25 = 'N'
                AND pjbacti = 'Y'
             CASE WHEN l_pjb09 !='Y' 
                       CALL cl_err(g_sfv[l_ac].sfv42,'apj-090',0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
                  WHEN l_pjb11 !='Y'
                       CALL cl_err(g_sfv[l_ac].sfv42,'apj-090',0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
                  OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
                       CALL cl_err(g_sfv[l_ac].sfv42,g_errno,0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
             END CASE
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_sfv[l_ac].sfv42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD sfv43
             ELSE
                LET g_sfv[l_ac].sfv43 = ' '
                DISPLAY BY NAME g_sfv[l_ac].sfv43
                NEXT FIELD sfv44
             END IF
          END IF

          #FUN-BC0104---add---str
        BEFORE FIELD sfv46
           CALL t324_set_entry_b1(p_cmd)

        AFTER FIELD sfv46
           IF NOT cl_null(g_sfv[l_ac].sfv46) AND p_cmd = 'a' THEN
             
              #FUN-CC0013 mark begin---
              #LET l_n = 0
              #SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
              #                               qcl_file
              #                         WHERE qco01 = g_sfv[l_ac].sfv17 
              #                         AND   qcf00 = '1' 
              #                         AND   qcf01 = qco01 
              #                         AND   qcf14 = 'Y'
              #                         AND   qco03 = g_sfv[l_ac].sfv46
              #                         AND   qcl01 = qco03
              #                         AND   qcl05 = '3'
              # IF l_n > 0 THEN
              #    CALL cl_err('','apm-806',0)
              #    NEXT FIELD sfv46
              # END IF
              #FUN-CC0013 mark end-----
               CALL t324_set_no_entry_b1(p_cmd)
               CALL t324_set_comp_required(g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47)
               CALL t324_qcl02_desc()
               IF NOT cl_null(g_sfv[l_ac].sfv46) AND NOT cl_null(g_sfv[l_ac].sfv47) THEN
                  CALL t324_qco_show()
               END IF
            END IF 

        AFTER FIELD sfv47
           IF NOT cl_null(g_sfv[l_ac].sfv47) AND p_cmd = 'a' THEN
              
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
                                             qcl_file
                                       WHERE qco01 = g_sfv[l_ac].sfv17 
                                       AND   qcf00 = '1' 
                                       AND   qcf01 = qco01 
                                       AND   qcf14 = 'Y'
                                       AND   qco04 = g_sfv[l_ac].sfv47
                                       AND   qcl01 = qco03
                                      #AND   qcl05 <> '3'    #FUN-CC0013 mark
               IF l_n = 0 THEN
                  CALL cl_err('','apm-807',0)
                  NEXT FIELD sfv47
               END IF
               CALL t324_set_comp_required(g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47)
               IF NOT cl_null(g_sfv[l_ac].sfv46) AND NOT cl_null(g_sfv[l_ac].sfv47) THEN
                  CALL t324_qco_show()
               END IF
            END IF 
        #FUN-BC0104---add---end
 
       BEFORE FIELD sfv43
         IF cl_null(g_sfv[l_ac].sfv42) THEN
            NEXT FIELD sfv42
         ELSE
            SELECT pjb25 INTO l_pjb25 FROM pjb_file
             WHERE pjb02 = g_sfv[l_ac].sfv42
            IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
               LET g_sfv[l_ac].sfv43 = ' '
               DISPLAY BY NAME g_sfv[l_ac].sfv43
               NEXT FIELD sfv44
            END IF
         END IF
 
       AFTER FIELD sfv43
          IF NOT cl_null(g_sfv[l_ac].sfv43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_sfv[l_ac].sfv43
                AND pjk11 = g_sfv[l_ac].sfv42
                AND pjkacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv43,'apj-049',0)
                NEXT FIELD sfv43
             END IF
          END IF
 
       AFTER FIELD sfv44
         IF NOT cl_null(g_sfv[l_ac].sfv44) THEN
            SELECT COUNT(*) INTO g_cnt FROM azf_file
              WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
            IF g_cnt = 0 THEN
               CALL cl_err(g_sfv[l_ac].sfv44,'asf-453',0)
               NEXT FIELD sfv44
            END IF
            SELECT azf09 INTO l_azf09 FROM azf_file 
             WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
            IF l_azf09 !='C' THEN
               CALL cl_err(g_sfv[l_ac].sfv44,'aoo-411',0)                                                                           
               NEXT FIELD sfv44
            END IF  
         ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
           IF g_smy.smy59 = 'Y' THEN
              CALL cl_err('','apj-201',0)
              NEXT FIELD sfv44
           END IF
         END IF
 
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_sfv_t.sfv03 > 0 AND g_sfv_t.sfv03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
              SELECT ima918,ima921 INTO g_ima918,g_ima921
                FROM ima_file
               WHERE ima01 = g_sfv[l_ac].sfv04
                 AND imaacti = "Y"
             
 
 
              
               DELETE FROM sfv_file
                WHERE sfv01 = g_sfu.sfu01 AND sfv03 = g_sfv_t.sfv03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","sfv_file",g_sfu.sfu01,g_sfv_t.sfv03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
#FUN-B70074-add-delete--
              ELSE 
                 IF NOT s_industry('std') THEN 
                    IF NOT s_del_sfvi(g_sfu.sfu01,g_sfv_t.sfv03,'') THEN 
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF 
                 END IF
#FUN-B70074-add-end----
               END IF
               #FUN-BC0104---add---str
                IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                #FUN-BC0104---add---end
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sfv[l_ac].* = g_sfv_t.*
               CLOSE t324_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfv[l_ac].sfv03,-263,1)
               LET g_sfv[l_ac].* = g_sfv_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                       RETURNING g_cnt,g_ima906,g_ima907
                  IF g_cnt =1 THEN
                     NEXT FIELD sfv04
                  END IF
                  CALL t324_du_data_to_correct()
               END IF
               CALL t324_set_origin_field()
 
               CALL t324_b_else()
               
          SELECT oeb13 INTO g_sfv[l_ac].sfvud07 FROM oeb_file 
          WHERE oeb01=(SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11) AND
          oeb03=(SELECT sfb221 FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11)#hlf-07751
               IF g_success = 'Y' THEN
               UPDATE sfv_file SET sfv01=g_sfu.sfu01,
                                   sfv03=g_sfv[l_ac].sfv03,
                                   sfv04=g_sfv[l_ac].sfv04,
                                   sfv05=g_sfv[l_ac].sfv05,
                                   sfv06=g_sfv[l_ac].sfv06,
                                   sfv07=g_sfv[l_ac].sfv07,
                                   sfv08=g_sfv[l_ac].sfv08,
                                   sfv09=g_sfv[l_ac].sfv09,
                                   sfv11=g_sfv[l_ac].sfv11,
                                   sfv41=g_sfv[l_ac].sfv41,  
                                   sfv42=g_sfv[l_ac].sfv42,  
                                   sfv43=g_sfv[l_ac].sfv43,  
                                   sfv44=g_sfv[l_ac].sfv44,  
                                   sfv12=g_sfv[l_ac].sfv12,
                                   sfv20=g_sfv[l_ac].sfv20,
                                   sfv30=g_sfv[l_ac].sfv30,
                                   sfv31=g_sfv[l_ac].sfv31,
                                   sfv32=g_sfv[l_ac].sfv32,
                                   sfv33=g_sfv[l_ac].sfv33,
                                   sfv34=g_sfv[l_ac].sfv34,
                                   sfv35=g_sfv[l_ac].sfv35,
                                   sfv930=g_sfv[l_ac].sfv930,
                                   sfvud07=g_sfv[l_ac].sfvud07               #FUN-670103
                WHERE sfv01=g_sfu.sfu01
                  AND sfv03=g_sfv_t.sfv03
               END IF
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","sfv_file",g_sfu.sfu01,g_sfv_t.sfv03,SQLCA.sqlcode,"","upd sfv",1)  #No.FUN-660128
                  LET g_sfv[l_ac].* = g_sfv_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  #FUN-BC0104---add---str
                  IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                     ROLLBACK WORK 
                  END IF
                  #FUN-BC0104---add---end
	          COMMIT WORK
               END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_sfv.getLength() THEN #CHI-C30118 add
                  SELECT ima918,ima921 INTO g_ima918,g_ima921
                    FROM ima_file
                   WHERE ima01 = g_sfv[l_ac].sfv04
                     AND imaacti = "Y"
                  
                  
               END IF #CHI-C30118 add
               IF p_cmd='u' THEN
                  LET g_sfv[l_ac].* = g_sfv_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sfv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t324_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t324_bcl
            COMMIT WORK
            #CKP
           #CALL g_sfv.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
    #CHI-C30118---add---START 回寫批序料號資料
        AFTER INPUT
            SELECT COUNT(*) INTO g_cnt FROM sfv_file WHERE sfv01=g_sfu.sfu01
            FOR l_ac2 = 1 TO g_cnt
                LET g_ima918 = ' '
                LET g_ima921 = ' '
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_sfv[l_ac2].sfv04
                   AND imaacti = "Y"
                   
                
            END FOR
    #CHI-C30118---add---END
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sfv03) AND l_ac > 1 THEN
                LET g_sfv[l_ac].* = g_sfv[l_ac-1].*
                LET g_sfv[l_ac].sfv03 = NULL
                NEXT FIELD sfv03
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(sfv20)    #Run Card
                    IF p_cmd != 'a' THEN 
                        CALL q_shm2(FALSE,TRUE,'','')   
                           RETURNING g_qryparam.multiret
                      LET g_sfv[l_ac].sfv20 = g_qryparam.multiret
                      DISPLAY BY NAME g_sfv[l_ac].sfv20
                      NEXT FIELD sfv20
                    ELSE 
                      CALL q_shm2(TRUE,TRUE,'','') RETURNING g_multi_sfv20
                      IF NOT cl_null(g_multi_sfv20) THEN 
                        
                         CALL t324_b_fill(" 1=1")
                         CALL t324_b()
                         EXIT INPUT 
                      END IF 
                   END IF 
                      #end----mark by guanyao160805
               WHEN INFIELD(sfv17)
                    CALL q_qcf(FALSE,TRUE,g_sfv[l_ac].sfv17,'2') RETURNING g_sfv[l_ac].sfv17
                    DISPLAY BY NAME g_sfv[l_ac].sfv17
                    NEXT FIELD sfv17
                WHEN INFIELD(sfv11)    #工單單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.construct ="Y"
                     LET g_qryparam.form ="q_sfb01"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv11
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv11
                      DISPLAY BY NAME g_sfv[l_ac].sfv11     #No.MOD-490371
                     NEXT FIELD sfv11
                WHEN INFIELD(sfv05) OR INFIELD(sfv06) OR INFIELD(sfv07)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_sfv[l_ac].sfv04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07)
                      RETURNING g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07
                   ELSE
                   #FUN-C30300---end 
                     CALL q_img4(FALSE,TRUE,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,  ##NO.FUN-660085
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,'A')
                       RETURNING g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,
                                 g_sfv[l_ac].sfv07
                   END IF #FUN-C30300
                     DISPLAY g_sfv[l_ac].sfv05 TO sfv05
                     DISPLAY g_sfv[l_ac].sfv06 TO sfv06
                     DISPLAY g_sfv[l_ac].sfv07 TO sfv07
                     IF INFIELD(sfv05) THEN NEXT FIELD sfv05 END IF
                     IF INFIELD(sfv06) THEN NEXT FIELD sfv06 END IF
                     IF INFIELD(sfv07) THEN NEXT FIELD sfv07 END IF
                WHEN INFIELD(sfv30) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv30
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv30
                     DISPLAY BY NAME g_sfv[l_ac].sfv30
                     NEXT FIELD sfv30
 
                WHEN INFIELD(sfv33) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv33
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv33
                     DISPLAY BY NAME g_sfv[l_ac].sfv33
                     NEXT FIELD sfv33
                WHEN INFIELD(sfv930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem4"
                   CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv930
                   DISPLAY BY NAME g_sfv[l_ac].sfv930
                   NEXT FIELD sfv930
                WHEN INFIELD(sfv41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv41 
                  DISPLAY BY NAME g_sfv[l_ac].sfv41
                  NEXT FIELD sfv41
                WHEN INFIELD(sfv42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv41  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv42 
                  DISPLAY BY NAME g_sfv[l_ac].sfv42
                  NEXT FIELD sfv42
                WHEN INFIELD(sfv43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv42  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv43 
                  DISPLAY BY NAME g_sfv[l_ac].sfv43
                  NEXT FIELD sfv43
                  
                WHEN INFIELD(sfv44)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"                 #No.FUN-930145
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv44
                  LET g_qryparam.arg1 = 'C'                       #No.FUN-930145  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv44
                  DISPLAY BY NAME g_sfv[l_ac].sfv44
                  NEXT FIELD sfv44

                #FUN-BC0104---add---str
                WHEN INFIELD(sfv46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv46
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv17
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  NEXT FIELD sfv46

                WHEN INFIELD(sfv47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv47
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv17
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  NEXT FIELD sfv47
                #FUN-BC0104---add---end
           END CASE
 
        ON ACTION gen_detail
           CALL t324_y_b()
           EXIT INPUT
 
        ON ACTION qry_warehouse
                    #---> Mod No.FUN-AA0082
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = g_sfv[l_ac].sfv05
                    #LET g_qryparam.arg1     = 'SW'          #No.MOD-780207
                    #CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv05
                     CALL q_imd_1(FALSE,TRUE,g_sfv[l_ac].sfv05,"",g_plant,"","")  #只能开当前门店的
                          RETURNING g_sfv[l_ac].sfv05
                    #---> End Mod No.FUN-AA0082
                     NEXT FIELD sfv05
 
        ON ACTION qry_location
                    #---> Mod No.FUN-AA0082
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = g_sfv[l_ac].sfv06
                    #LET g_qryparam.arg1     = g_sfv[l_ac].sfv05 #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                    #CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv06
                     CALL q_ime_1(FALSE,TRUE,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv05,"",g_plant,"","","")
                          RETURNING g_sfv[l_ac].sfv06
                    #---> End Mod No.FUN-AA0082
                     NEXT FIELD sfv06
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfv[l_ac].sfv04
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              IF cl_null(g_sfv[l_ac].sfv06) THEN
                 LET g_sfv[l_ac].sfv06 = ' '
              END IF
              IF cl_null(g_sfv[l_ac].sfv07) THEN
                 LET g_sfv[l_ac].sfv07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_sfv[l_ac].sfv04
                 AND img02=g_sfv[l_ac].sfv05
                 AND img03=g_sfv[l_ac].sfv06
                 AND img04=g_sfv[l_ac].sfv07
              CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#No.CHI-9A0022 --Begin
              IF cl_null(g_sfv[l_ac].sfv41) THEN
                 LET l_bno = ''
              ELSE
                 LET l_bno = g_sfv[l_ac].sfv41
              END IF
#No.CHI-9A0022 --End
#TQC-B90236---mark---begin
#             CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                          g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                          l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark---end
#TQC-B90236---add----begin
              CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                             g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                             g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                             g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236---add----end
                     RETURNING l_r,g_qty 
              IF l_r = "Y" THEN
                 LET g_sfv[l_ac].sfv09 = g_qty
                 LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08) #FUN-BB0086 add

              END IF
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    UPDATE sfu_file SET sfumodu = g_user,sfudate = g_today
     WHERE sfu01 = g_sfu.sfu01
 
    CLOSE t324_bcl
    COMMIT WORK
    IF cl_null(g_sfu.sfu01) THEN RETURN END IF  #add by guanyao160806
    CALL t324_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t324_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sfu.sfu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sfu_file ",
                  "  WHERE sfu01 LIKE '",l_slip,"%' ",
                  "    AND sfu01 > '",g_sfu.sfu01,"'"
      PREPARE t324_pb1 FROM l_sql 
      EXECUTE t324_pb1 INTO l_cnt 
      
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
        #CALL t324_x()  #CHI-D20010
         CALL t324_x(1) #CHI-D20010
         CALL t324_show()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sfu_file WHERE sfu01 = g_sfu.sfu01
         INITIALIZE g_sfu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION  t324_sfv17(p_cmd)
   DEFINE l_qcf02   LIKE qcf_file.qcf02,
          l_qcf03   LIKE qcf_file.qcf03,
          l_qcf021  LIKE qcf_file.qcf021,
          l_qcf14   LIKE qcf_file.qcf14,
          l_qcfacti LIKE qcf_file.qcfacti,
          l_qcf09   LIKE qcf_file.qcf09,
          p_cmd     LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ''
    SELECT qcf02,qcf03,qcf021,qcf14,qcfacti,qcf09
    INTO l_qcf02,l_qcf03,l_qcf021,l_qcf14,l_qcfacti,l_qcf09
    FROM qcf_file
    WHERE qcf01 = g_sfv[l_ac].sfv17
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0044'
        WHEN l_qcfacti='N ' LET g_errno = '9028'
        WHEN l_qcf14='N'    LET g_errno = 'asf-048'
        WHEN l_qcf09='2'    LET g_errno = 'aqc-400'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
      LET g_sfv[l_ac].sfv20 = l_qcf03
      LET g_sfv[l_ac].sfv11 = l_qcf02
      LET g_sfv[l_ac].sfv04 = l_qcf021
      DISPLAY BY NAME g_sfv[l_ac].sfv20
      DISPLAY BY NAME g_sfv[l_ac].sfv11
      DISPLAY BY NAME g_sfv[l_ac].sfv04
    END IF
 
    IF g_sma.sma115='Y' THEN
       CALL t324_sel_ima()
    END IF
 
    IF cl_null(g_sfv_t.sfv11) OR g_sfv[l_ac].sfv11 ! = g_sfv_t.sfv11 THEN
       CALL t324_sfb01(l_ac)
    END IF
 
END FUNCTION
 
 
#--->工單相關資料顯示於劃面
FUNCTION  t324_sfb01(p_ac)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_ima158  LIKE ima_file.ima158,  #FUN-A90057
          l_sfv09   LIKE sfv_file.sfv09,
          l_qcf091  LIKE qcf_file.qcf091,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(15),
          l_d4      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          l_no      LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05),            #No.FUN-550067
          l_status  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          p_ac      LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
   DEFINE l_ecm012  LIKE ecm_file.ecm012    #FUN-A60076
   DEFINE l_ecm03   LIKE ecm_file.ecm03     #FUN-A60076   
   DEFINE l_shm18   LIKE shm_file.shm18     #FUN-A90057

    LET g_errno = ''
    INITIALIZE g_sfb.* TO NULL
 
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima25=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    
 
    SELECT sfb_file.* INTO g_sfb.* FROM sfb_file
     WHERE sfb01=g_sfv[p_ac].sfv11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF

    #str----add by guanyao160907
    IF cl_null(g_sfb.sfbud05) THEN 
       LET g_sfb.sfbud05 = 'N'
    END IF 
    IF g_sfb.sfbud05 = 'Y' THEN 
       LET g_sma.sma73 = 'N'
    ELSE 
       SELECT DISTINCT sma73 INTO g_sma.sma73 FROM sma_file 
    END IF 
    #end----add by guanyao160907
 
# check W/O 是否存在對應之FQC單中 --
   IF NOT cl_null(g_sfv[p_ac].sfv17) AND g_sma.sma896='Y' THEN
      LET l_qcf091 = 0
      SELECT qcf091 INTO l_qcf091 FROM qcf_file
       WHERE qcf01 = g_sfv[p_ac].sfv17
         AND qcf03 = g_sfv[p_ac].sfv20
         AND qcf09 <> '2'                 #NO:6872
         AND qcf14 = 'Y'
      IF SQLCA.sqlcode THEN
         LET g_errno = 'asf-732'
         RETURN
      ELSE
         IF cl_null(l_qcf091) THEN
            LET l_qcf091 = 0
         END IF
      END IF
    END IF
 
    SELECT ima02,ima021,ima35,ima36,ima55,ima158  #FUN-A90057
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55,l_ima158 FROM ima_file  #FUN-A90057
    WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_sfb.sfb05,"",SQLCA.sqlcode,"","sel ima:",1)  #No.FUN-660128
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0082  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0082
    END IF
 
    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       WHEN g_sfb.sfb04 ='8'
            LET g_errno='mfg3430'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
 
    IF g_sfb.sfb02 = 7 THEN    #委外工單
       LET g_errno='mfg9185'
    END IF
 
    IF g_sfb.sfb02 = 11 THEN    #拆件式工單
       LET g_errno='asf-709'
    END IF

   #FUN-D70008---add---str---
    IF cl_null(g_errno) AND g_sma.sma73 = 'Y' THEN   #add g_sma.sma73 by guanyao160902
       IF g_sfb.sfb04 < '4' AND g_sfb.sfb39 !='2' THEN
          LET g_errno='asf-570'
       END IF
    END IF
   #FUN-D70008---add---end---

    LET g_sfv[p_ac].sfv04 = g_sfb.sfb05
 
    IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
       LET g_sfv[p_ac].sfv05 = l_ima35
    ELSE
       LET g_sfv[p_ac].sfv05 = g_sfb.sfb30
    END IF
 
    IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
       LET g_sfv[p_ac].sfv06 = l_ima36
    ELSE
       LET g_sfv[p_ac].sfv06 = g_sfb.sfb31
    END IF
    #FUN-A90057(S)
    IF l_ima158='Y' AND g_sfv[l_ac].sfv20 IS NOT NULL THEN
       IF (g_sfv[l_ac].sfv20 <> g_sfv_t.sfv20) OR (g_sfv_t.sfv20 IS NULL) THEN
          SELECT shm18 INTO l_shm18 FROM shm_file
           WHERE shm01 = g_sfv[l_ac].sfv20
          LET g_sfv[l_ac].sfv07 = l_shm18
          DISPLAY BY NAME g_sfv[l_ac].sfv07
       END IF
    END IF
    #FUN-A90057(E)
    LET g_sfv[l_ac].sfv41 = g_sfb.sfb27
    LET g_sfv[l_ac].sfv42 = g_sfb.sfb271
    LET g_sfv[l_ac].sfv43 = g_sfb.sfb50
    LET g_sfv[l_ac].sfv44 = g_sfb.sfb51
    IF cl_null(g_sfv[l_ac].sfv41) THEN  LET g_sfv[l_ac].sfv41 = ' ' END IF
    IF cl_null(g_sfv[l_ac].sfv42) THEN  LET g_sfv[l_ac].sfv42 = ' ' END IF 
    IF cl_null(g_sfv[l_ac].sfv43) THEN  LET g_sfv[l_ac].sfv43 = ' ' END IF
    IF cl_null(g_sfv[l_ac].sfv44) THEN  LET g_sfv[l_ac].sfv44 = ' ' END IF
    DISPLAY BY NAME g_sfv[l_ac].sfv41,g_sfv[l_ac].sfv42,
                    g_sfv[l_ac].sfv43,g_sfv[l_ac].sfv44  
 
    LET g_sfv[p_ac].ima02 = l_ima02
    LET g_sfv[p_ac].ima021 = l_ima021
 
    CALL s_schdat_max_sgm03(g_sfv[p_ac].sfv20) RETURNING l_ecm012,l_ecm03    #FUN-A60076 
    SELECT sgm58 INTO g_sfv[p_ac].sfv08 FROM sgm_file
     WHERE sgm01=g_sfv[p_ac].sfv20
     #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file       #FUN-A60076  mark
     #            WHERE sgm01=g_sfv[p_ac].sfv20)       #FUN-A60076  mark  
      AND sgm03 = l_ecm03            #FUN-A60076
      AND sgm012 = l_pmn012          #FUN-A60076 
    DISPLAY BY NAME g_sfv[p_ac].sfv04
    DISPLAY BY NAME g_sfv[p_ac].sfv05
    DISPLAY BY NAME g_sfv[p_ac].sfv06
    DISPLAY BY NAME g_sfv[p_ac].ima02
    DISPLAY BY NAME g_sfv[p_ac].ima021
 
    IF g_sma.sma896 = 'Y' AND g_smy.smy57[2,2] = 'Y' THEN
       SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
        WHERE sfv17 = g_sfv[l_ac].sfv17
          AND (( sfv01 != g_sfu.sfu01 ) OR
               ( sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03 ))
          AND sfv01 = sfu01
          AND sfuconf !='X' #FUN-660137
       IF cl_null(l_sfv09) THEN
          LET l_sfv09 = 0
       END IF
       LET g_sfv[p_ac].sfv09= l_qcf091 - l_sfv09
   END IF
 
    IF g_sma.sma115='Y' THEN
       CALL t324_sel_ima()
       CALL t324_set_du_by_origin(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,
                                  g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv05,
                                  g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07)
            RETURNING g_sfv[p_ac].sfv30,g_sfv[p_ac].sfv31,g_sfv[p_ac].sfv32,
                      g_sfv[p_ac].sfv33,g_sfv[p_ac].sfv34,g_sfv[p_ac].sfv35
       DISPLAY BY NAME g_sfv[p_ac].sfv30
       DISPLAY BY NAME g_sfv[p_ac].sfv31
       DISPLAY BY NAME g_sfv[p_ac].sfv32
       DISPLAY BY NAME g_sfv[p_ac].sfv33
       DISPLAY BY NAME g_sfv[p_ac].sfv34
       DISPLAY BY NAME g_sfv[p_ac].sfv35
    END IF
 
    DISPLAY BY NAME g_sfv[p_ac].sfv04
    DISPLAY BY NAME g_sfv[p_ac].ima02
    DISPLAY BY NAME g_sfv[p_ac].ima021
    DISPLAY BY NAME g_sfv[p_ac].sfv05
    DISPLAY BY NAME g_sfv[p_ac].sfv06
    DISPLAY BY NAME g_sfv[p_ac].sfv07
    DISPLAY BY NAME g_sfv[p_ac].sfv08
    DISPLAY BY NAME g_sfv[p_ac].sfv09
  
    LET g_sfv[l_ac].sfv930=g_sfb.sfb98 #FUN-670103
    LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
    DISPLAY BY NAME g_sfv[p_ac].sfv930 #FUN-670103
    DISPLAY BY NAME g_sfv[p_ac].gem02c #FUN-670103
 
END FUNCTION
 
#--->工單相關資料顯示於劃面
FUNCTION  t324_sfb011(p_ac)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_sfv09   LIKE sfv_file.sfv09,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(15),
          l_d4      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          l_no      LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05),             #No.FUN-550067
          l_status  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          p_ac      LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ecm03   LIKE ecm_file.ecm03     #FUN-A60076 
   DEFINE l_ecm012  LIKE ecm_file.ecm012    #FUN-A60076
   
    INITIALIZE g_sfb.* TO NULL
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    LET g_min_set = 0
    LET l_sfv09 = 0
    SELECT sfb_file.* INTO g_sfb.* FROM  sfb_file
     WHERE sfb01=g_sfv[p_ac].sfv11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
 
    SELECT ima02,ima021,ima35,ima36,ima55
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55 FROM ima_file
     WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_sfb.sfb05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0082   #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0082
    END IF
 
    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
 
    LET g_sfv[p_ac].sfv04 = g_sfb.sfb05
 
    IF g_argv='2' THEN
       IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
          LET g_sfv[p_ac].sfv05 = l_ima35
       ELSE
          LET g_sfv[p_ac].sfv05 = g_sfb.sfb30
       END IF
       IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
          LET g_sfv[p_ac].sfv06 = l_ima36
       ELSE
          LET g_sfv[p_ac].sfv06 = g_sfb.sfb31
       END IF
       LET g_sfv[p_ac].sfv09 = g_sfb.sfb09
    END IF
 
    LET g_sfv[p_ac].ima02 = l_ima02
    LET g_sfv[p_ac].ima021= l_ima021
    CALL s_schdat_max_sgm03(g_sfv[p_ac].sfv20) RETURNING l_ecm012,l_ecm03    #FUN-A60076  
    SELECT sgm58 INTO g_sfv[p_ac].sfv08 FROM sgm_file
       WHERE sgm01=g_sfv[p_ac].sfv20
        #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file  #FUN-A60076 
        #            WHERE sgm01=g_sfv[p_ac].sfv20)  #FUN-A60076
         AND sgm012 = l_ecm012  #FUN-A60076	  
         AND sgm03 = l_ecm03    #FUN-A60076
 
    IF g_sma.sma115='Y' THEN
       CALL t324_sel_ima()
       CALL t324_set_du_by_origin(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,
                                  g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv05,
                                  g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07)
            RETURNING g_sfv[p_ac].sfv30,g_sfv[p_ac].sfv31,g_sfv[p_ac].sfv32,
                      g_sfv[p_ac].sfv33,g_sfv[p_ac].sfv34,g_sfv[p_ac].sfv35
       DISPLAY BY NAME g_sfv[p_ac].sfv30
       DISPLAY BY NAME g_sfv[p_ac].sfv31
       DISPLAY BY NAME g_sfv[p_ac].sfv32
       DISPLAY BY NAME g_sfv[p_ac].sfv33
       DISPLAY BY NAME g_sfv[p_ac].sfv34
       DISPLAY BY NAME g_sfv[p_ac].sfv35
    END IF
END FUNCTION
 
FUNCTION t324_b_else()
     IF g_sfv[l_ac].sfv05 IS NULL THEN LET g_sfv[l_ac].sfv05 =' ' END IF
     IF g_sfv[l_ac].sfv06 IS NULL THEN LET g_sfv[l_ac].sfv06 =' ' END IF
     IF g_sfv[l_ac].sfv07 IS NULL THEN LET g_sfv[l_ac].sfv07 =' ' END IF
END FUNCTION
 
FUNCTION t324_delall()
   SELECT COUNT(*) INTO g_cnt FROM sfv_file
    WHERE sfv01 = g_sfu.sfu01
   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM sfu_file WHERE sfu01 = g_sfu.sfu01
   END IF
END FUNCTION
 
FUNCTION t324_y_b()
 
   IF g_sfu.sfu00 != '0' THEN
 
      OPEN WINDOW t324_y_w WITH FORM "asf/42f/cect324y"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("cect324y")
 
      CALL t324_y_b1()
 
      CLOSE WINDOW t324_y_w
 
   END IF
 
   CALL t324_b_fill(' 1=1')
   CALL t324_b()
 
END FUNCTION
 
FUNCTION t324_y_b1()
   DEFINE l_sql,l_wc            LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(500)
   DEFINE i,j,k,l_i             LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE in_qty_t,qty_t        LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_shm DYNAMIC ARRAY OF RECORD
          shm05      LIKE shm_file.shm05,
          shm01      LIKE shm_file.shm01,
          seq        LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
          qty        LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          y          LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
          in_qty     LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          sfb98 LIKE sfb_file.sfb98 #FUN-670103
          END RECORD
   DEFINE l_shm012     LIKE shm_file.shm012
   DEFINE l_sfv RECORD LIKE sfv_file.*
   DEFINE partno	LIKE sfb_file.sfb05  #No.MOD-490217
   DEFINE tot_qty,qty2  LIKE type_file.num10    #No.FUN-680121 INTEGER
   DEFINE seq1		LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
   DEFINE ware             LIKE img_file.img02,
          loc              LIKE img_file.img03,
          lot	           LIKE img_file.img04,
 
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
   DEFINE l_ecm03          LIKE ecm_file.ecm03    #FUN-A60076
   DEFINE l_ecm012         LIKE ecm_file.ecm012   #FUN-A60076
   DEFINE l_sfvi    RECORD LIKE sfvi_file.*       #FUN-B70074
   DEFINE l_flag          LIKE type_file.chr1    #FUN-B70074
 
   LET seq1=0
   INPUT BY NAME partno,tot_qty,seq1,ware,loc,lot WITHOUT DEFAULTS
      AFTER FIELD partno
        IF partno IS NULL THEN NEXT FIELD partno END IF

      #Add No.FUN-AA0082
      AFTER FIELD ware
        IF NOT cl_null(ware) THEN
           IF NOT s_chk_ware(ware) THEN  #检查仓库是否属于当前门店
              NEXT FIELD ware
           END IF
        END IF
      #End Add No.FUN-AA0082

      AFTER FIELD loc
        IF ware IS NOT NULL OR loc IS NOT NULL THEN
           IF NOT s_chksmz('', g_sfu.sfu01,ware,loc) THEN
              NEXT FIELD ware
           END IF
        END IF

      ON ACTION controlp
        CASE WHEN INFIELD(partno)    #
#FUN-AB0025---------mod---------------str----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = partno
#                 CALL cl_create_qry() RETURNING partno
                  CALL q_sel_ima(FALSE, "q_ima","",partno,"","","","","",'' )
                    RETURNING partno
#FUN-AB0025--------mod---------------end----------------
                  DISPLAY BY NAME partno
                  NEXT FIELD partno
        END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 END IF
 
   IF g_sfu.sfu00='1' THEN
      LET l_sql="SELECT shm05,shm01,sgm03,shm08-shm09,'','',sfb98,shm13", #FUN-670103
                "  FROM shm_file,sfb_file,sgm_file",
                " WHERE shm05 MATCHES '",partno CLIPPED,"'",
                "   AND shm012=sfb01",
                "   AND shm01=sgm01",
                "   AND shm08 > shm09 AND sfb04<'8'"
                IF NOT cl_null(seq1) THEN
                   LET l_sql=l_sql CLIPPED, " AND sgm03=",seq1
                END IF
                LET l_sql=l_sql CLIPPED, " ORDER BY shm05,shm01,sgm03"
   END IF
 
   IF g_sfu.sfu00='2' THEN
      LET l_sql="SELECT sfb05,sfb01,0,sfb09,'','',sfb98,sfb25",  #FUN-670103
                "  FROM sfb_file",
                " WHERE sfb09>0 AND sfb04<'8'",
                "   AND sfb05 MATCHES '",partno CLIPPED,"'",
                " ORDER BY sfb05,sfb25 DESC"
   END IF
 
   PREPARE t324_y_b1_p FROM l_sql
   DECLARE t324_y_b1_c CURSOR FOR t324_y_b1_p
   LET i=1
   LET qty2=tot_qty
 
   MESSAGE "Waiting..."
   FOREACH t324_y_b1_c INTO l_shm[i].*,l_shm012
      IF g_sfu.sfu00 = '1' THEN
         IF l_shm[i].qty<=0 THEN CONTINUE FOREACH END IF
      END IF
      IF qty2>0 THEN
         LET l_shm[i].y='Y'
         IF qty2 > l_shm[i].qty THEN
            LET l_shm[i].in_qty=l_shm[i].qty
         ELSE
            LET l_shm[i].in_qty=qty2
         END IF
         LET qty2 = qty2 - l_shm[i].in_qty
      END IF      
      LET i=i+1
 
   END FOREACH
 
   MESSAGE ""
 
   LET l_i = i - 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_shm WITHOUT DEFAULTS FROM s_shm.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
        LET i=ARR_CURR()
 
      BEFORE FIELD y
        LET qty_t=0 LET in_qty_t=0
        FOR k=1 TO l_shm.getLength()
           IF l_shm[k].qty > 0 THEN LET qty_t = qty_t+l_shm[k].qty END IF
           IF l_shm[k].y ='Y' AND l_shm[k].in_qty IS NOT NULL THEN
              LET in_qty_t = in_qty_t+l_shm[k].in_qty
           END IF
        END FOR
        DISPLAY BY NAME qty_t,in_qty_t
 
      BEFORE FIELD in_qty
        IF l_shm[i].y IS NULL OR l_shm[i].y<>'Y'  OR l_shm[i].shm01 IS NULL THEN
           LET l_shm[i].in_qty=NULL
           DISPLAY l_shm[i].in_qty TO s_sfb[j].in_qty
           NEXT FIELD PREVIOUS
        END IF
 
        IF l_shm[i].in_qty IS NULL OR l_shm[i].in_qty = 0 THEN
           LET l_shm[i].in_qty = l_shm[i].qty
           DISPLAY l_shm[i].in_qty TO s_sfb[j].in_qty
        END IF
 
      AFTER FIELD in_qty
        IF l_shm[i].in_qty > l_shm[i].qty THEN
           CALL cl_err('','asf-550',0) NEXT FIELD in_qty
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF NOT cl_sure(0,0) THEN RETURN END IF
 
   INITIALIZE l_sfv.* TO NULL
 
   SELECT MAX(sfv03) INTO l_sfv.sfv03 FROM sfv_file WHERE sfv01=g_sfu.sfu01
   IF l_sfv.sfv03 IS NULL THEN LET l_sfv.sfv03 = 0 END IF
   FOR k=1 TO l_shm.getLength()
      IF l_shm[k].shm01 IS NULL THEN
         CONTINUE FOR
      END IF
      IF l_shm[k].in_qty IS NULL OR l_shm[k].in_qty<=0 THEN
         CONTINUE FOR
      END IF
      LET l_sfv.sfv01=g_sfu.sfu01
      LET l_sfv.sfv03=l_sfv.sfv03+1
      LET l_sfv.sfv04=l_shm[k].shm05
      LET l_sfv.sfv05=ware
      LET l_sfv.sfv06=loc
      LET l_sfv.sfv07=lot
      LET l_sfv.sfvplant = g_plant #FUN-980008 add
      LET l_sfv.sfvlegal = g_legal #FUN-980008 add
      CALL s_schdat_max_sgm03(l_sfv.sfv20) RETURNING l_ecm012,l_ecm03   #FUN-A60076
      SELECT sgm58 INTO l_sfv.sfv08 FROM sgm_file
       WHERE sgm01=l_sfv.sfv20
        #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file   #FUN-A60076   mark
        #            WHERE sgm01=l_sfv.sfv20)         #FUN-A60076   mark
         AND sgm03 = l_ecm03     #FUN-A60076 
         AND sgm012 = l_ecm012   #FUN-A60076      
      LET l_sfv.sfv09=l_shm[k].in_qty
      LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086
      LET l_sfv.sfv11=l_shm012
       #依工單號將工單單頭的專案/WBS/活動/理由碼自動代入到sfv單身
        SELECT sfb27,sfb271,sfb50,sfb51 
          INTO l_sfv.sfv41,l_sfv.sfv42,l_sfv.sfv43,l_sfv.sfv44
          FROM sfb_file
         WHERE sfb01 = l_sfv.sfv11
      IF g_sma.sma115='Y' THEN
         CALL t324_sel_ima()
         CALL t324_set_du_by_origin(l_sfv.sfv04,l_sfv.sfv08,
                                    l_sfv.sfv09,l_sfv.sfv05,
                                    l_sfv.sfv06,l_sfv.sfv07)
              RETURNING l_sfv.sfv30,l_sfv.sfv31,l_sfv.sfv32,
                        l_sfv.sfv33,l_sfv.sfv34,l_sfv.sfv35
      END IF
      LET l_sfv.sfv930=l_shm[k].sfb98 #FUN-670103
      
      IF g_success = 'Y' THEN
         INSERT INTO sfv_file VALUES(l_sfv.*)
#FUN-B70074--add--insert--
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfvi.* TO NULL
            LET l_sfvi.sfvi01 = l_sfv.sfv01
            LET l_sfvi.sfvi03 = l_sfv.sfv03
            LET l_flag = s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant)
         END IF 
#FUN-B70074--add--insert--
      END IF
 
      MESSAGE 'ins sfv:',l_sfv.sfv03,l_sfv.sfv11,STATUS
 
   END FOR
 
END FUNCTION
 
FUNCTION t324_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON sfv03,sfv20,sfv11,sfv04,sfv08,sfv05,sfv06,
                       sfv07,sfv09,sfv41,sfv42,sfv43,sfv44,sfv12  #FUN-810045 add sfv41-44
            FROM s_sfv[1].sfv03,s_sfv[1].sfv20,s_sfv[1].sfv11,
                 s_sfv[1].sfv04,s_sfv[1].sfv08,s_sfv[1].sfv05,
                 s_sfv[1].sfv06,s_sfv[1].sfv07,s_sfv[1].sfv09,
                 s_sfv[1].sfv41,s_sfv[1].sfv42,s_sfv[1].sfv43,s_sfv[1].sfv44,  #FUN-810045
                 s_sfv[1].sfv12
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t324_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t324_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 DEFINE l_sfvud07      LIKE sfv_file.sfvud07
 DEFINE l_x            LIKE type_file.num5   #add by guanyao160901
    LET g_sql = "SELECT sfv03,sfv17,sfv20,sfv11,sfv46,qcl02,sfv47,sfv04,ima02,ima021,",  #FUN-BC0104 add sfv46,qcl02,sfv47
                "sfv08,sfv05,sfv06,sfv07,sfv09,sfv33,sfv34,",
                "sfv35,sfv30,sfv31,sfv32,sfv41,sfv42,sfv43,sfv44,sfv12,sfv930,'',sfvud07,''",  #FUN-670103  #FUN-810045
                " FROM sfv_file LEFT OUTER JOIN ima_file ON sfv04=ima01 ",     #NO.TQC-9A0134 mod
                "               LEFT OUTER JOIN qcl_file ON sfv46=qcl01 ",    #FUN-BC0104
                " WHERE sfv01 ='",g_sfu.sfu01,"' AND ",p_wc2 CLIPPED,  #單頭    #No.TQC-9A0134 mod
                " ORDER BY sfv03"
    PREPARE t324_pb FROM g_sql
    DECLARE sfv_curs CURSOR FOR t324_pb
 
    CALL g_sfv.clear()
 
    LET g_cnt = 1
    FOREACH sfv_curs INTO g_sfv[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          # add by hlf07751
     #  IF g_sfv[g_cnt].sfvud07 IS NULL THEN 
       LET l_sfvud07 =''
       #str-----mark by guanyao160907
       #SELECT oeb13 INTO l_sfvud07 FROM oeb_file 
       #   WHERE oeb01=(SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[g_cnt].sfv11) AND
       #   oeb03=(SELECT sfb221 FROM sfb_file WHERE sfb01=g_sfv[g_cnt].sfv11)
       #end-----mark by guanyao160907
       #str-----add by guanyao160907
       SELECT oeb13 INTO l_sfvud07 FROM oeb_file,sfb_file 
        WHERE oeb01 = sfb22
          AND oeb03 = sfb221
          AND sfb01 = g_sfv[g_cnt].sfv11
       #end-----add by guanyao160907
       LET  g_sfv[g_cnt].sfvud07=l_sfvud07
       IF g_sfv[g_cnt].sfvud07!=l_sfvud07 THEN  
          UPDATE sfv_file SET 
                sfvud07=l_sfvud07       
           WHERE sfv01=g_sfu.sfu01 AND sfv03 =g_sfv[g_cnt].sfv03
          IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
              
          END IF
       END IF 
      # END IF 
       #str----add by guanyao160901
       IF NOT cl_null(g_sfv[g_cnt].sfv11) THEN 
          CALL s_minp(g_sfv[g_cnt].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037 
           RETURNING l_x,g_sfv[g_cnt].l_min # default 時不考慮超限率
          IF l_x !=0  THEN
            LET g_sfv[g_cnt].l_min = 0
          END IF
       END IF 
       #end----add by guanyao160901
       LET g_sfv[g_cnt].gem02c=s_costcenter_desc(g_sfv[g_cnt].sfv930) #FUN-670103
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    
       
    END FOREACH
    CALL g_sfv.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
    #FUN-B30170 add begin-------------------------
    
    LET g_rec_b1 = g_cnt - 1
    #FUN-B30170 add -end--------------------------
END FUNCTION
 
FUNCTION t324_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-B30170 add -----------begin-------------
   DIALOG ATTRIBUTE(UNBUFFERED)
     DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         AFTER DISPLAY
         CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
     
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
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
         CALL t324_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t324_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t324_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t324_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t324_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL t324_mu_ui()   #FUN-610006
         CALL t324_pic() #圖形顯示 #FUN-660137
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end
#@    ON ACTION 領料產生
      ON ACTION gen_mat_wtdw
         LET g_action_choice="gen_mat_wtdw"
         EXIT DIALOG
#@    ON ACTION 領料維護
      ON ACTION maint_mat_wtdw
         LET g_action_choice="maint_mat_wtdw"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"  #MOD-580134
         EXIT DIALOG                #MOD-580134
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG

      #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DIALOG
      #FUN-BC0104---add---end
  
      #tianry add 161121
      ON ACTION dshz
         LET g_action_choice='dshz'
         EXIT DIALOG

      #tianry add end 

      &include "qry_string.4gl"
      
   END DIALOG
   
#   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
#    ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t324_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION previous
#         CALL t324_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t324_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t324_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t324_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL t324_mu_ui()   #FUN-610006
#         CALL t324_pic() #圖形顯示 #FUN-660137
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
##@    ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
##@    ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
##@    ON ACTION 領料產生
#      ON ACTION gen_mat_wtdw
#         LET g_action_choice="gen_mat_wtdw"
#         EXIT DISPLAY
##@    ON ACTION 領料維護
#      ON ACTION maint_mat_wtdw
#         LET g_action_choice="maint_mat_wtdw"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"  #MOD-580134
#         EXIT DISPLAY                #MOD-580134
#  
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
###
# 
#      ON ACTION related_document                #No.FUN-6A0164  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
   #FUN-B30170 add ------------end---------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
 
END FUNCTION
 
 
FUNCTION t324_bp_refresh()
   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
 
FUNCTION t324_out()
     #str----add by guanyao160811
     IF cl_null(g_sfu.sfu01) THEN
        RETURN 
     END IF  
     --IF g_sfu.sfuconf != 'Y' THEN 
        --CALL cl_err('','csf-516',1)
        --RETURN 
     --END IF  
     #end----add by guanyao160811
     CASE WHEN g_argv = '0'  #作業移轉
            LET l_program = 'asfr623' #FUN-C30085 mark
            LET l_program = 'asfg623' #FUN-C30085 add
          WHEN g_argv = '1'  #完工入庫
            --LET l_program = 'asfr621' #FUN-C30085 mark
            --LET l_program = 'asfg621' #FUN-C30085 add
        #str-add by huanglf160804
        IF g_sfu.sfuconf = 'N' THEN 
           CALL cl_err('','csf-516',1)
        ELSE 
           LET g_wc= 'sfu01 = "',g_sfu.sfu01,'"'
           LET g_msg = "csfr623",  #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",g_wc CLIPPED,"' "
                  ," '1' 'N' 'N' 'Y'" 
           CALL cl_cmdrun(g_msg)
        END IF 
        #end—add by huanglf 160804
          WHEN g_argv = '2'  #入庫退回
            LET l_program = 'asfr622' #FUN-C30085 mark
            LET l_program = 'asfg622' #FUN-C30085 add
     END CASE
     
    IF g_argv ! = '1' THEN 
     LET g_wc = 'sfu01 = "',g_sfu.sfu01,'"'
     LET g_cmd = l_program,
                 " '",g_today,"'",
                 " '",g_user,"'",  #TQC-630013
                 " '",g_lang,"'",
                 " 'Y'",
                 " ' '",
                 " '1'",
                 " '",g_wc CLIPPED,"'"
    CALL cl_cmdrun(g_cmd CLIPPED)
    END IF 
     

    
 
END FUNCTION
 
#FUNCTION t324_x()       #CHI-D20010
FUNCTION t324_x(p_type)  #CHI-D20010 
DEFINE l_sfv47   LIKE sfv_file.sfv47,    #FUN-BC0104
       l_sfv17   LIKE sfv_file.sfv17,    #FUN-BC0104
       l_sfv46   LIKE sfv_file.sfv46,    #FUN-BC0104
       l_sfv09   LIKE sfv_file.sfv09     #FUN-BC0104
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01       #MOD-660086 add
   IF cl_null(g_sfu.sfu01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sfu.sfuconf ='X' THEN RETURN END IF
   ELSE
      IF g_sfu.sfuconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t324_cl USING g_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t324_cl INTO g_sfu.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t324_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_sfu.sfu01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF #FUN-660137
   IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660137
   IF g_sfu.sfuconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_sfu.sfuconf)   THEN #FUN-660137  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #FUN-660137  #CHI-D20010
      LET g_chr=g_sfu.sfuconf #FUN-660137
     #IF g_sfu.sfuconf ='N' THEN #FUN-660137  #CHI-D20010
      IF p_type = 1 THEN #FUN-660137          #CHI-D20010
          LET g_sfu.sfuconf='X' #FUN-660137
      ELSE
          LET g_sfu.sfuconf='N' #FUN-660137
      END IF
      UPDATE sfu_file
         SET sfuconf=g_sfu.sfuconf, #FUN-660137
             sfumodu=g_user,
             sfudate=g_today
       WHERE sfu01  =g_sfu.sfu01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","sfu_file",g_sfu.sfu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
          LET g_sfu.sfuconf=g_chr #FUN-660137
      #FUN-C40016----------mark----------str----------
      ##FUN-BC0104---add---str---
      #ELSE
      #   DECLARE sfv03_cur1 CURSOR FOR SELECT sfv09,sfv17,sfv46,sfv47
      #                                   FROM sfv_file
      #                                  WHERE sfv01 = g_sfu.sfu01
      #   FOREACH sfv03_cur1 INTO l_sfv09,l_sfv17,l_sfv46,l_sfv47
      #      IF NOT cl_null(l_sfv46) THEN
      #         UPDATE qco_file SET qco20 = qco20-l_sfv09 WHERE qco01 = l_sfv17
      #                                                     AND qco02 = 0
      #                                                     AND qco04 = l_sfv47
      #                                                     AND qco05 = 0
      #         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #            CALL cl_err3("upd","qco_file",g_sfu.sfu01,"",STATUS,"","upd qco20:",1)
      #            ROLLBACK WORK
      #            RETURN
      #         END IF
      #      END IF
      #   END FOREACH
      #   UPDATE sfv_file SET sfv46 = '',sfv47 = ''
      #       WHERE sfv01 = g_sfu.sfu01
      #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #      CALL cl_err3("upd","sfu_file",g_sfu.sfu01,"",STATUS,"","upd sfv46,sfv47:",1)
      #      ROLLBACK WORK
      #      RETURN
      #   END IF
      ##FUN-BC0104---add---end---
      #FUN-C40016----------mark----------end----------
      #FUN-C40016----add----str----
      ELSE
         DECLARE sfv03_cur1 CURSOR FOR SELECT sfv17,sfv46,sfv47
                                         FROM sfv_file
                                        WHERE sfv01 = g_sfu.sfu01
         FOREACH sfv03_cur1 INTO l_sfv17,l_sfv46,l_sfv47
            IF NOT cl_null(l_sfv46) THEN
               IF NOT s_iqctype_upd_qco20(l_sfv17,0,0,l_sfv47,'2') THEN
                  ROLLBACK WORK
                  RETURN
               END IF 
            END IF
         END FOREACH
      #FUN-C40016----add----end----
      END IF
      DISPLAY BY NAME g_sfu.sfuconf #FUN-660137
   END IF
 
   CLOSE t324_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sfu.sfu01,'V')
 
END FUNCTION
 
FUNCTION t324_s()       #過帳
 DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680121 SMALLINT
 DEFINE l_flag  LIKE type_file.chr1    #FUN-930109
 DEFINE l_sfv05 LIKE sfv_file.sfv05    #FUN-930109
 DEFINE l_sfv06 LIKE sfv_file.sfv06    #FUN-930109
 DEFINE l_sfv03 LIKE sfv_file.sfv03    #FUN-930109
 DEFINE g_flag  LIKE type_file.chr1    #FUN-930109
 DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
 DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
 DEFINE l_sql            STRING                 #FUN-C70087
 DEFINE l_sfv           RECORD LIKE sfv_file.*  #FUN-C70087
 
   IF s_shut(0) THEN RETURN END IF
   #str----add by guanyao160928
   SELECT smaud03 INTO g_sma.smaud03 FROM sma_file WHERE sma00 ='0'
   IF g_sma.smaud03 = 'Y' THEN 
      CALL cl_err('','csf-087',1)
      EXIT PROGRAM
   END IF 
   #end----add by guanyao160928
   IF g_sfu.sfu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
   IF g_sfu.sfupost='Y' THEN RETURN END IF
   IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_sfu.sfuconf = 'N' THEN
      CALL cl_err('','aba-100',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM sfv_file WHERE sfv01 = g_sfu.sfu01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF g_sma.sma53 IS NOT NULL AND g_sfu.sfu02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_sfu.sfu02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(g_yy,'mfg6090',0) RETURN
   END IF
 
#未過帳之FQC單應不可於此作業作過帳
   SELECT COUNT(DISTINCT sfv17) INTO g_cnt FROM sfv_file,sfu_file
    WHERE sfv01 = g_sfu.sfu01
      AND sfv01 = sfu01
      AND sfv17 IN ( SELECT qcf01 FROM qcf_file
                     WHERE qcf09 = '2' OR qcf14 != 'Y' )
   IF g_cnt > 0 THEN
      CALL cl_err('chk_sfv17_qcf','asf-711',0)
      RETURN
   END IF
   BEGIN WORK

   OPEN t324_cl USING g_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_flag = 'Y'
   DECLARE t324_s_cs1 CURSOR FOR SELECT sfv03,sfv05,sfv06 FROM sfv_file                                                                              
                                  WHERE sfv01 = g_sfu.sfu01
   CALL s_showmsg_init() 
 
   FOREACH t324_s_cs1 INTO l_sfv03,l_sfv05,l_sfv06      
      CALL s_incchk(l_sfv05,l_sfv06,g_user) 
      RETURNING l_flag
      IF l_flag = FALSE THEN
         LET g_flag='N'
         LET g_showmsg=l_sfv03,"/",l_sfv05,"/",l_sfv06,"/",g_user                                                                   
         CALL s_errmsg('sfv03,sfv05,sfv06,inc03',g_showmsg,'','asf-888',1)                                                          
      END IF
   END FOREACH   
   CALL s_showmsg()                                                                                                                 
   IF g_flag='N' THEN                                                                                                            
      RETURN                                                                                                                        
   END IF
  #MOD-AC0057---mark---start---    #將此段搬到FETCH後面 
  #IF NOT cl_confirm('mfg0176') THEN 
  #   CLOSE t324_cl
  #   ROLLBACK WORK
  #   RETURN 
  #END IF
  #MOD-AC0057---mark---end---
 
   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t324_s_c2 CURSOR FOR SELECT * FROM sfv_file
     WHERE sfv01 = g_sfu.sfu01 

   FOREACH t324_s_c2 INTO l_sfv.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_sfv.sfv04
         AND img02 = l_sfv.sfv05
         AND img03 = l_sfv.sfv06
         AND img04 = l_sfv.sfv07
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,g_sfu.sfu01,l_sfv.sfv03,g_sfu.sfu02,l_img_table)  #FUN-CC0095
          CALL s_padd_img_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,g_sfu.sfu01,l_sfv.sfv03,g_sfu.sfu02)  #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv30) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv30,g_sfu.sfu01,l_sfv.sfv03,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv30,g_sfu.sfu01,l_sfv.sfv03)  #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                       l_sfv.sfv06,l_sfv.sfv07,
                       l_sfv.sfv33) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv33,g_sfu.sfu01,l_sfv.sfv03,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfv.sfv04,l_sfv.sfv05,l_sfv.sfv06,l_sfv.sfv07,l_sfv.sfv33,g_sfu.sfu01,l_sfv.sfv03)  #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095  
      ELSE
         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
   
   FETCH t324_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324_cl ROLLBACK WORK RETURN
   END IF
 
  #MOD-AC0057---add---start---    #將此段搬到FETCH後面 
   IF NOT cl_confirm('mfg0176') THEN 
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN 
   END IF
  #MOD-AC0057---add---end---
   LET g_success = 'Y'
 
 
   UPDATE sfu_file SET sfupost='Y' WHERE sfu01=g_sfu.sfu01
   IF sqlca.sqlcode THEN LET g_success='N' END IF
 
   CALL t324_s1()
   #CHI-C80010---begin
   IF g_success = 'Y' THEN
      UPDATE sfb_file SET sfb18 = g_sfu.sfu02
       WHERE EXISTS(SELECT 1 FROM sfv_file WHERE sfv11 = sfb01 AND sfv01 = g_sfu.sfu01)
         AND (sfb18 < g_sfu.sfu02 OR sfb18 IS NULL)
   END IF 
   #CHI-C80010---end
   IF g_success = 'Y' THEN
      LET g_sfu.sfupost='Y'
      DISPLAY BY NAME g_sfu.sfupost
      COMMIT WORK
      CALL cl_flow_notify(g_sfu.sfu01,'S')
   ELSE
      LET g_sfu.sfupost='N'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_sfu.sfupost
 
END FUNCTION
 
FUNCTION t324_s1()
 DEFINE  l_sfv091   LIKE sfv_file.sfv09,
         l_sfv092   LIKE sfv_file.sfv09,
         l_sfv09    LIKE sfv_file.sfv09,
         l_qcf091   LIKE qcf_file.qcf091,
         s_sfv09    LIKE sfv_file.sfv09
  DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
  DEFINE  l_ecm012     LIKE ecm_file.ecm012   #FUN-A60076
  DEFINE  l_ecm03      LIKE ecm_file.ecm03    #FUN-A60076
 
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE t324_s1_c CURSOR FOR
   SELECT * FROM sfv_file WHERE sfv01=g_sfu.sfu01
  FOREACH t324_s1_c INTO b_sfv.*
      IF cl_null(b_sfv.sfv04) THEN LET g_success='N' CONTINUE FOREACH END IF
      CALL s_get_ima153(b_sfv.sfv04) RETURNING l_ima153  #FUN-910053  
 
 
      MESSAGE '_s1() read sfv:',b_sfv.sfv03
      IF b_sfv.sfv09 = 0 THEN
         CALL cl_err(b_sfv.sfv09,'asf-660',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=b_sfv.sfv11
     IF g_sfb.sfb04='8' THEN
        CALL cl_err(g_sfb.sfb01,'mfg3430',1)
        LET g_success='N'
        EXIT FOREACH
     END IF
     #str----add by guanyao160909
     IF cl_null(g_sfb.sfbud05) THEN 
        LET g_sfb.sfbud05 = 'N'
     END IF 
     #end----add by guanyao160909
 
#----入庫量不可大於FQC量
     IF g_argv = '1' THEN   #入庫
        LET l_sfv09=0     #已 key 之入庫量(不分是否已過帳)
        SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
         WHERE sfv11 = b_sfv.sfv11
           AND sfv01 = sfu01
           AND sfu00 = '1'           #完工入庫
           AND sfupost = 'Y'
        IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
 
        LET g_min_set=0
        IF g_sfb.sfb39 != '2' THEN
           #工單完工方式為'2' pull 不check min_set
            #CALL s_minp(b_sfv.sfv11,g_sma.sma73,l_ima153,'')   #FUN-910053
            #FUN-A60095--begin--add-------
            
            IF cl_null(g_sfv[l_ac].sfv20) OR g_min_set = 0 THEN
            #FUN-A60095--end--add-----------
            #  CALL s_minp(b_sfv.sfv11,g_sma.sma73,l_ima153,'','','')   #FUN-A60027 #FUN-C70037 mark
               CALL s_minp(b_sfv.sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02)   #FUN-C70037
                    RETURNING g_cnt,g_min_set
               IF g_cnt !=0  THEN
                  CALL cl_err(b_sfv.sfv09,'asf-549',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF   #FUN-A60095
  
 #W/O 總入庫量大於最小套數 --
            #str----add by guanyao160909
            IF g_sfb.sfbud05 = 'Y' THEN
            ELSE  
            #end----add by guanyao160909
            IF l_sfv09 > g_min_set THEN
              #add by donghy 允许有0.01的误差
              CALL cs_minp(b_sfv.sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02)   #FUN-C70037
                    RETURNING g_cnt,g_min_set
              IF l_sfv09 > g_min_set THEN
                  #str---add by huanglf160824
                #tianry add 161227
                IF (l_sfv09-g_min_set)/l_sfv09<0.05 THEN
                ELSE
                 LET g_showmsg= b_sfv.sfv20                                                                 
                 CALL s_errmsg('sfv20',g_showmsg,'','asf-668',1)
                 LET g_success = 'N'
                 EXIT FOREACH
                END IF 
                 #str---end by huanglf160824
              END IF
             #  CALL cl_err('','asf-668',1)
               
            END IF
            END IF #add by guanyao160909
        END IF
    
        IF g_sfb.sfb93='Y' # 製程否
           #check 最終製程之總轉出量(良品轉出量+Bonus)
           THEN      #
           CALL s_schdat_max_sgm03(b_sfv.sfv20) RETURNING l_ecm012,l_ecm03   #FUN-A60076 
           SELECT sgm311,sgm315 INTO g_sgm311,g_sgm315 FROM sgm_file
            WHERE sgm01=b_sfv.sfv20
             #AND sgm03= (SELECT MAX(sgm03) FROM sgm_file  #FUN-A60076  mark
             #             WHERE sgm01=b_sfv.sfv20)        #FUN-A60076  mark
              AND sgm03 = l_ecm03     #FUN-A60076
              AND sgm012 = l_ecm012   #FUN-A60076 
           IF STATUS THEN LET g_sgm311=0 END IF
           IF STATUS THEN LET g_sgm315=0 END IF
           LET g_sgm_out=g_sgm311 + g_sgm315
 
           LET l_sfv09=0     #已 key 之入庫量(不分是否已過帳)
           SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
            WHERE sfv20 = b_sfv.sfv20
              AND sfv01 = sfu01
              AND sfu00 = '1'           #完工入庫
              AND sfupost = 'Y'
           IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
           IF l_sfv09 > g_sgm_out THEN
              IF g_sma.sma1434 ='Y' THEN
                 #處理自動報工
                 IF NOT t324_gen_shb(b_sfv.*,g_sfu.sfu02,b_sfv.sfv11,l_ecm012,
                                     l_ecm03,l_sfv09-g_sgm_out) THEN  #FUN-A90057
                   #LET g_success="Y"  #TQC-B20107
                    LET g_success="N"  #TQC-B20107
                    EXIT FOREACH
                 END IF  
              ELSE                       
                 #CALL cl_err(b_sfv.sfv03,'asf-675',1) #mark by guanyao160908
                 CALL cl_err(b_sfv.sfv03,'csf-080',1)  #add by guanyao160908
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
         END IF
     END IF
 
#使用FQC功能
     IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' THEN     #FUN-550012
        LET l_sfv09=0     #已 key 之入庫量(不分是否已過帳)
        SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
         WHERE sfv11 = b_sfv.sfv17      #No.TQC-640009 modify
           AND sfv01 = sfu01
           AND sfu00 = '1'           #完工入庫
           AND sfupost = 'Y'
        IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
        SELECT qcf091 INTO l_qcf091 FROM qcf_file   # QC
         WHERE qcf01 = b_sfv.sfv17      #FUN-550012
           AND qcf09 = '1'   #accept
           AND qcf14 = 'Y'
        IF l_qcf091 IS NULL THEN LET l_qcf091 = 0 END IF
 
        IF l_sfv09 > l_qcf091 THEN
           CALL cl_err(b_sfv.sfv03,'asf-660',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END IF
 
      IF g_argv = '1' OR g_argv = '2' THEN   #完工入庫或入庫退回
         #-----更新sfb_file-----------
          LET l_sfv091 = 0    LET l_sfv092 = 0  LET l_sfv09 = 0
          SELECT SUM(sfv09) INTO l_sfv091 FROM sfu_file,sfv_file
           WHERE sfv11 = b_sfv.sfv11
             AND sfu01 = sfv01
             AND sfu00 = '1'           #完工入庫
             AND sfupost = 'Y'
          SELECT SUM(sfv09) INTO l_sfv092 FROM sfu_file,sfv_file
           WHERE sfv11 = b_sfv.sfv11
             AND sfu01 = sfv01
             AND sfu00 = '2'           #入庫退回
             AND sfupost = 'Y'
         LET l_sfv09 = 0
         IF cl_null(l_sfv091) THEN LET l_sfv091 = 0 END IF
         IF cl_null(l_sfv092) THEN LET l_sfv092 = 0 END IF
         LET l_sfv09 = l_sfv091 - l_sfv092
         IF g_argv = '1' THEN
            UPDATE sfb_file SET sfb09 = l_sfv09,
                                sfb04 = '7'
             WHERE sfb01 = b_sfv.sfv11
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","sfb_file",b_sfv.sfv11,"",STATUS,"","upd sfb",1)  #No.FUN-660128
                LET g_success = 'N'
                RETURN
             END IF
         ELSE
            IF l_sfv09<0 THEN
               CALL cl_err(b_sfv.sfv03,'asf-712',0)
               LET g_success='N'
               RETURN
            END IF
            UPDATE sfb_file SET sfb09 = l_sfv09
             WHERE sfb01 = b_sfv.sfv11
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","sfb_file",b_sfv.sfv11,"",STATUS,"","upd sfb",1)  #No.FUN-660128
                LET g_success = 'N'
                RETURN
             END IF
         END IF
      END IF
      IF STATUS THEN
         CALL cl_err('upd sfb',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('upd sfb','mfg0177',1)
         LET g_success = 'N'
         RETURN
      END IF

 {
     IF g_argv = '1' OR g_argv = '2' THEN    #完工入庫或入庫退回
       #------新增工單完工統計資料檔(sfh_file)---
       INSERT INTO sfh_file(sfh01,sfh02,sfh03,sfh04,sfh05,sfh06,sfh07,sfh08,sfh09,
                            sfh10,sfh11,sfh12,sfh13,sfh14,sfh15,sfh16,sfh17,sfh18,
                             sfh91,sfh92,sfhplant,sfhlegal)  #No.MOD-470041 #FUN-980008 add
                           VALUES (b_sfv.sfv11,g_sfu.sfu02,'3',b_sfv.sfv04,
                                   ' ',b_sfv.sfv09,b_sfv.sfv08,b_sfv.sfv05,
                                   b_sfv.sfv06,b_sfv.sfv07,' ',' ',g_sfu.sfu01,
                                   b_sfv.sfv03,0,0,0,' ',' ',' ',
                                  g_plant,g_legal)#FUN-980008 add
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("ins","sfh_file",b_sfv.sfv11,"",STATUS,"","ins sfh",1)  #No.FUN-660128
          LET g_success = 'N' RETURN  
      END IF
    END IF
    
    IF g_argv = '1' OR g_argv = '2' THEN
      CALL t324_update_s(b_sfv.sfv05,b_sfv.sfv06,b_sfv.sfv07,
                       b_sfv.sfv09,b_sfv.sfv08)
      IF g_success='N' THEN 
         LET g_totsuccess='N'
         LET g_success="Y"
         CONTINUE FOREACH    #No.FUN-6C0083
      END IF
      IF g_sma.sma115='Y' THEN
         CALL t324_update_du('s')
      END IF
      IF g_success='N' THEN 
         LET g_totsuccess='N'
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
    END IF
 
    CALL t324_ins_sub_rvv()
    UPDATE shm_file SET shm09=shm09+b_sfv.sfv09 WHERE shm01=b_sfv.sfv20
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","shm_file",b_sfv.sfv20,"",STATUS,"","upd shm",1)  #No.FUN-660128
       LET g_success = 'N' RETURN   
    END IF

    }
  END FOREACH
  IF STATUS THEN CALL cl_err('foreach',STATUS,0) LET g_success='N' END IF
  MESSAGE ''
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 



REPORT t324_rep(sr,p_flag)
  DEFINE p_flag  LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
        sr  RECORD
            sfp01 LIKE sfp_file.sfp01,
            sfp02 LIKE sfp_file.sfp02,
            sfp03 LIKE sfp_file.sfp03,
            sfp04 LIKE sfp_file.sfp04,
            sfp05 LIKE sfp_file.sfp05,
            sfp06 LIKE sfp_file.sfp06,
            sfp07 LIKE sfp_file.sfp07
             END RECORD
 
  ORDER BY sr.sfp01
  FORMAT
    AFTER GROUP OF sr.sfp01
      IF p_flag ='Y' THEN
         UPDATE sfp_file SET sfp02 = sr.sfp02,
                             sfp04 = sr.sfp04,
                             sfp05 = sr.sfp05,
                             sfp06 = sr.sfp06,
                             sfp07 = sr.sfp07
          WHERE sfp01 = sr.sfp01
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
      ELSE
         INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfpconf,  #FUN-660106
                              sfpmksg,sfp15,sfp16,                                #FUN-AB0001 add
                              sfpplant,sfplegal,sfporiu,sfporig) #FUN-980008 add
                       VALUES(sr.sfp01,sr.sfp02,sr.sfp03,sr.sfp04,
                              sr.sfp05,sr.sfp06,sr.sfp07,'N',    #FUN-660106
                              g_smy.smyapr,'0',g_user,           #FUN-AB0001 add
                              g_plant,g_legal, g_user, g_grup)   #FUN-980008 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
 
      END IF
 
END REPORT
 
FUNCTION t324_mu_ui()
    CALL cl_set_comp_visible("sfv31,sfv34",FALSE)
    CALL cl_set_comp_visible("sfv30,sfv33,sfv32,sfv35",g_sma.sma115='Y')
    CALL cl_set_comp_visible("sfv08,sfv09",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv35",g_msg CLIPPED)
       CALL cl_getmsg('asm-310',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv30",g_msg CLIPPED)
       CALL cl_getmsg('asm-311',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv32",g_msg CLIPPED)
    END IF
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("sfu04",TRUE)
   END IF
   CALL cl_set_comp_visible("sfv930,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("sfu06,pja02,sfv41,sfv42,sfv43",g_aza.aza08='Y')
   CALL cl_set_comp_visible("page2",g_sma.sma95='Y')                    #TQC-C80184  add
   CALL cl_set_act_visible("modi_lot,qry_lot",g_sma.sma95='Y')          #TQC-C80184  add
END FUNCTION
 
FUNCTION t324_sel_ima()
   SELECT ima25,ima906,ima907 INTO g_ima25,g_ima906,g_ima907
     FROM ima_file
    WHERE ima01=g_sfv[l_ac].sfv04
END FUNCTION
 
FUNCTION t324_set_du_by_origin(p_sfv04,p_sfv08,p_sfv09,p_sfv05,p_sfv06,p_sfv07)
  DEFINE p_sfv04     LIKE sfv_file.sfv04,
         p_sfv08     LIKE sfv_file.sfv08,
         p_sfv09     LIKE sfv_file.sfv09,
         p_sfv05     LIKE sfv_file.sfv05,
         p_sfv06     LIKE sfv_file.sfv06,
         p_sfv07     LIKE sfv_file.sfv07,
         l_sfv30     LIKE sfv_file.sfv30,
         l_sfv31     LIKE sfv_file.sfv31,
         l_sfv32     LIKE sfv_file.sfv32,
         l_sfv33     LIKE sfv_file.sfv33,
         l_sfv34     LIKE sfv_file.sfv34,
         l_sfv35     LIKE sfv_file.sfv35
 
   IF p_sfv06 IS NULL THEN LET p_sfv06=' ' END IF
   IF p_sfv07 IS NULL THEN LET p_sfv07=' ' END IF
   SELECT img09 INTO g_img09 FROM img_file
    WHERE img01=p_sfv04
      AND img02=p_sfv05
      AND img03=p_sfv06
      AND img04=p_sfv07
   IF cl_null(g_img09) THEN LET g_img09=g_ima25 END IF
 
   LET l_sfv30=p_sfv08
   LET g_factor = 1
   CALL s_umfchk(p_sfv04,l_sfv30,g_img09)
        RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
   END IF
   LET l_sfv31=g_factor
   LET l_sfv32=p_sfv09
   LET l_sfv33=g_ima907
   LET g_factor = 1
   CALL s_umfchk(p_sfv04,l_sfv33,g_img09)
        RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
   END IF
   LET l_sfv34=g_factor
   LET l_sfv35=0
   IF g_ima906 = '3' THEN
      LET g_factor = 1
      CALL s_umfchk(p_sfv04,l_sfv30,l_sfv33)
           RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
      LET l_sfv35=l_sfv32*g_factor
      LET l_sfv35 = s_digqty(l_sfv35,l_sfv33) #FUN-BB0086 add
   END IF
   RETURN l_sfv30,l_sfv31,l_sfv32,l_sfv33,l_sfv34,l_sfv35
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t324_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_sfv[l_ac].sfv04
    LET l_ware = g_sfv[l_ac].sfv05
    LET l_loc  = g_sfv[l_ac].sfv06
    LET l_lot  = g_sfv[l_ac].sfv07
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    SELECT img09 INTO g_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(g_img09) THEN LET g_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = g_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_sfv[l_ac].sfv33 =l_unit2
       LET g_sfv[l_ac].sfv34 =l_fac2
       LET g_sfv[l_ac].sfv35 =l_qty2
       LET g_sfv[l_ac].sfv30 =l_unit1
       LET g_sfv[l_ac].sfv31 =l_fac1
       LET g_sfv[l_ac].sfv32 =l_qty1
    END IF
END FUNCTION
 
FUNCTION t324_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF  #MOD-590120
    LET l_fac2=g_sfv[l_ac].sfv34
    LET l_qty2=g_sfv[l_ac].sfv35
    LET l_fac1=g_sfv[l_ac].sfv31
    LET l_qty1=g_sfv[l_ac].sfv32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_sfv[l_ac].sfv08=g_sfv[l_ac].sfv30
                   LET g_sfv[l_ac].sfv09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_sfv[l_ac].sfv08=g_img09
                   LET g_sfv[l_ac].sfv09=l_tot
                   LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08) #FUN-BB0086 add
          WHEN '3' LET g_sfv[l_ac].sfv08=g_sfv[l_ac].sfv30
                   LET g_sfv[l_ac].sfv09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_sfv[l_ac].sfv34 =l_qty1/l_qty2
                   ELSE
                      LET g_sfv[l_ac].sfv34 =0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION t324_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("sfv33,sfv35,sfv30,sfv32",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_sfv[l_ac].sfv30) THEN
     CALL cl_set_comp_required("sfv32",TRUE)
  END IF
  IF NOT cl_null(g_sfv[l_ac].sfv33) THEN
     CALL cl_set_comp_required("sfv35",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t324_set_no_required()
 
  CALL cl_set_comp_required("sfv33,sfv35,sfv30,sfv32",FALSE)
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t324_du_data_to_correct()
 
   IF cl_null(g_sfv[l_ac].sfv33) THEN
      LET g_sfv[l_ac].sfv34 = NULL
      LET g_sfv[l_ac].sfv35 = NULL
   END IF
 
   IF cl_null(g_sfv[l_ac].sfv30) THEN
      LET g_sfv[l_ac].sfv31 = NULL
      LET g_sfv[l_ac].sfv32 = NULL
   END IF
   DISPLAY BY NAME g_sfv[l_ac].sfv31
   DISPLAY BY NAME g_sfv[l_ac].sfv32
   DISPLAY BY NAME g_sfv[l_ac].sfv34
   DISPLAY BY NAME g_sfv[l_ac].sfv35
 
END FUNCTION
 


#檢查單位是否存在於單位檔中
FUNCTION t324_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#圖形顯示
FUNCTION t324_pic()
   ##圖形顯示
   IF g_sfu.sfuconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_sfu.sfuconf,"",g_sfu.sfupost,"",g_void,"")
END FUNCTION
 
FUNCTION t324_y_chk()
   DEFINE l_cnt      LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_cn       LIKE type_file.num10
   DEFINE l_str      STRING
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06  #No.FUN-860045
   DEFINE l_gem01    LIKE gem_file.gem01    #TQC-C60207
   DEFINE l_shm08    LIKE shm_file.shm08
   DEFINE l_sfv09    LIKE sfv_file.sfv09   #add by huanglf161014
#str----add by huanglf161017
   DEFINE l_sfb09    LIKE sfb_file.sfb09
   DEFINE l_sfbud05  LIKE sfb_file.sfbud05
   DEFINE l_min      LIKE sfv_file.sfv09
   DEFINE l_x        LIKE type_file.num5
#str----end by huanglf1161017
   LET g_success = 'Y'
  #str ly180328 bolck
    LET l_cn=0
     SELECT  COUNT(*) INTO l_cn FROM sfv_file,sfb_file WHERE sfv11=sfb01 AND sfbud06='Y'  AND sfv01=g_sfu.sfu01
   IF l_cn>0 THEN
       CALL   cl_err('','csf-601',1)  
       LET  g_success='N'
       RETURN
   END  IF
#end ly180328 bolck

   IF cl_null(g_sfu.sfu01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
#CHI-C30107 ---------------- add ----------------- begin
   IF g_sfu.sfuconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_sfu.sfuconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   #SELECT COUNT(*) INTO l_cnt FROM sfu_file         #TQC-C90039  mark
   #   WHERE sfu01= g_sfu.sfu01                      #TQC-C90039  mark
   SELECT COUNT(*) INTO l_cnt FROM sfv_file          #TQC-C90039  add
      WHERE sfv01= g_sfu.sfu01                       #TQC-C90039  add
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF    #TQC-C90042 add  LET g_success = 'N'
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
   IF g_sfu.sfuconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_sfu.sfuconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM sfu_file
      WHERE sfu01= g_sfu.sfu01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
#TQC-C60207 ----------------Begin---------------
   IF NOT cl_null(g_sfu.sfu04) THEN
      SELECT gem01 INTO l_gem01 FROM gem_file
       WHERE gem01 = g_sfu.sfu04
         AND gemacti = 'Y'
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err(g_sfu.sfu04,'asf-683',0)
         RETURN
      END IF
   END IF
#TQC-C60207 ----------------End-----------------

#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30118 add #CHI-C30107 mark
   
   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE t324_y_chk_c CURSOR FOR SELECT * FROM sfv_file
                                   WHERE sfv01=g_sfu.sfu01
   FOREACH t324_y_chk_c INTO b_sfv.*   

      #Add No.FUN-AB0054
      IF NOT s_chk_ware(b_sfv.sfv05) THEN  #检查仓库是否属于当前门店
         LET g_success = "N"
         CONTINUE FOREACH
      END IF
      #End Add No.FUN-AB0054
   
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = b_sfv.sfv04
         AND imaacti = "Y"


#str-------add by guanyao160830
      IF g_argv = '1' OR g_argv= '2' THEN 
        SELECT img09 INTO g_img09 FROM img_file
          WHERE img01=b_sfv.sfv04
            AND img02=b_sfv.sfv05
            AND img03=b_sfv.sfv06
            AND img04=b_sfv.sfv07
         IF STATUS THEN
            CALL cl_err3("sel","img_file",b_sfv.sfv04,b_sfv.sfv05,status,"","sel img09",1)  #No.FUN-660128
            LET g_success = 'N' RETURN   
         END IF
      END IF 
#end-------add by guanyao160830
     
         SELECT img09 INTO g_img09 FROM img_file
          WHERE img01=b_sfv.sfv04
            AND img02=b_sfv.sfv05
            AND img03=b_sfv.sfv06
            AND img04=b_sfv.sfv07
 
         CALL s_umfchk(b_sfv.sfv04,b_sfv.sfv08,g_img09) 
             RETURNING l_i,l_fac
 
         IF l_i = 1 THEN LET l_fac = 1 END IF
 
        
      END IF
      IF b_sfv.sfv09 <= 0 THEN 
         MESSAGE '入库数量不可小于等于0！'
         LET g_success = "N"
      END IF

      #str-----add by huanglf160806
         IF g_argv = '1' THEN 
               SELECT  shm08  INTO l_shm08 FROM shm_file WHERE shm01 = b_sfv.sfv20
            IF b_sfv.sfv09 > l_shm08 THEN 
              LET b_sfv.sfv09  = ''
              CALL cl_err(b_sfv.sfv09,"csf-067",1)
              LET g_success = "N"
            END IF 
    #str-----add by huanglf161014
            SELECT  SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file 
            WHERE sfv20 =b_sfv.sfv20 AND sfuconf !='X' AND sfv04 =b_sfv.sfv04 AND sfv01=sfu01
              IF l_sfv09 > l_shm08 THEN 
                 LET b_sfv.sfv09 = ''
                 CALL cl_err(b_sfv.sfv09,'csf-070',1)
                 LET g_success = "N"
              END IF   
         END IF 
    #str-----end by huanglf161014
    #end----add by huanglf160806
    #str----add by huanglf160810
        IF g_argv = '1' THEN 
            IF cl_null(b_sfv.sfv07) THEN 
               LET g_success = "N"
                CALL cl_err(b_sfv.sfv07,"csf-072",1)
            END IF 
        END IF 

    #str----add by huanglf160810

    #str---add by huanglf160913
      IF g_argv = '1' THEN 
            IF cl_null(b_sfv.sfv08) THEN 
               LET g_success = "N"
                CALL cl_err(b_sfv.sfv08,"csf-083",1)
            END IF 
        END IF 
         

    #str---end by huanglf160913

#str-----add by huanglf161017
      IF g_argv = '1' THEN 
          LET l_sfv09 = 0
          SELECT sfbud05 INTO l_sfbud05 FROM sfb_file WHERE sfb01 = b_sfv.sfv11

       IF NOT cl_null(b_sfv.sfv11) THEN 
          #CALL s_minp(b_sfv.sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037
            #RETURNING l_x,l_min # default 時不考慮超限率
          CALL cs_minp(b_sfv.sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037 
                       RETURNING l_x,l_min # default 時不考慮超限率  允许有0.01的误差率           
          IF l_x !=0  THEN
            LET l_min = 0
          END IF
       END IF 
          IF cl_null(l_sfbud05) THEN LET l_sfbud05= 'N' END IF
          IF l_sfbud05 = 'N' THEN 
              SELECT sfb09 INTO l_sfb09 FROM sfb_file WHERE sfb01 = b_sfv.sfv11
              SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file WHERE  sfv11 = b_sfv.sfv11 AND sfv01 = b_sfv.sfv01
              IF l_sfb09 + l_sfv09 > l_min THEN
                #tianry 161227  比例0.05
                IF ((l_sfb09 + l_sfv09)-l_min)/(l_sfb09 + l_sfv09)<0.05 THEN
                ELSE
                 LET g_success = 'N' 
                 CALL cl_err(b_sfv.sfv20,'asf-668',1)
                END IF
              END IF 
          END IF 
      END IF 
#str-----end by huanglf161017

#FUN-C70087---begin mark 
#      LET l_cnt=0
#      SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=b_sfv.sfv04
#                                                 AND img02=b_sfv.sfv05
#                                                 AND img03=b_sfv.sfv06
#                                                 AND img04=b_sfv.sfv07
#      IF l_cnt=0 THEN
#         LET g_success='N'
#         LET l_str="Item ",b_sfv.sfv03,":"
#         CALL cl_err(l_str,'asf-507',1)
#         EXIT FOREACH
#      END IF
#FUN-C70087---end
   END FOREACH
   
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t324_y_upd()
   #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30118 mark 移至y_chk最上方
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t324_cl USING g_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t324_cl
   UPDATE sfu_file SET sfuconf = 'Y' WHERE sfu01 = g_sfu.sfu01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","sfu_file",g_sfu.sfu01,"",STATUS,"","upd sfuconf",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_sfu.sfuconf='Y'
      CALL cl_flow_notify(g_sfu.sfu01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_sfu.sfuconf='N'
   END IF
   DISPLAY BY NAME g_sfu.sfuconf
   CALL t324_pic() #圖形顯示
END FUNCTION
 
FUNCTION t324_z()
   IF cl_null(g_sfu.sfu01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
   IF g_sfu.sfuconf='N' THEN RETURN END IF
   IF g_sfu.sfuconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_sfu.sfupost='Y' THEN
      CALL cl_err('sfupost=Y:','afa-101',0)
      RETURN
   END IF
 
  #IF NOT cl_confirm('axm-109') THEN RETURN END IF   #MOD-AC0057 mark
   BEGIN WORK
 
   OPEN t324_cl USING g_sfu.sfu01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324_cl 
      ROLLBACK WORK 
      RETURN
   END IF
  #MOD-AC0057---modify---start---
  #CLOSE t324_cl
   IF NOT cl_confirm('axm-109') THEN 
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN 
   END IF
  #MOD-AC0057---modify---end---
   LET g_success = 'Y'
   UPDATE sfu_file SET sfuconf = 'N' WHERE sfu01 = g_sfu.sfu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_sfu.sfuconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_sfu.sfuconf
   ELSE
      LET g_sfu.sfuconf='Y'
      ROLLBACK WORK
   END IF
   CLOSE t324_cl         #MOD-AC0057 add
   CALL t324_pic() #圖形顯示
END FUNCTION
 
#FUN-A60095--begin--add--------------
95--end--add-----------------

#FUN-A90057
#若完工入庫量 > 最終站轉出量,且設定自動開立移轉單,且最終站可自動報工,則回傳TRUE,否則回傳FALSE
FUNCTION t324_chk_auto_report(p_sfv11,p_sfv20,p_sfv09)
   DEFINE l_ecm012       LIKE ecm_file.ecm012
   DEFINE l_ecm03        LIKE ecm_file.ecm03
   DEFINE l_min_ecm012   LIKE ecm_file.ecm012
   DEFINE l_min_ecm03    LIKE ecm_file.ecm03
   DEFINE l_min_tran_out LIKE ecm_file.ecm311
   DEFINE p_sfv11        LIKE sfv_file.sfv11
   DEFINE p_sfv20        LIKE sfv_file.sfv20
   DEFINE p_sfv09        LIKE sfv_file.sfv09

   IF g_sma.sma1434 ='Y' THEN      
      #step.1:先檢查最終站是否有足夠的量可自動報工
      CALL s_schdat_max_sgm03(p_sfv20) RETURNING l_ecm012,l_ecm03
      CALL t730sub_check_auto_report(p_sfv11,p_sfv20,l_ecm012,l_ecm03)
         RETURNING l_min_ecm012,l_min_ecm03,l_min_tran_out
      IF l_min_tran_out > = p_sfv09 THEN
         RETURN TRUE
      ELSE
         RETURN FALSE
      END IF
   ELSE
      RETURN FALSE
   END IF 
END FUNCTION

FUNCTION t324_gen_shb(l_sfv,l_sfu02,l_sfv11,l_ecm012,l_ecm03,l_shb111)
   DEFINE l_sfv RECORD LIKE sfv_file.*
   DEFINE l_shb RECORD LIKE shb_file.*
   DEFINE l_sgm RECORD LIKE sgm_file.*
   DEFINE l_sql      STRING
   DEFINE l_t1       LIKE type_file.chr5 
   DEFINE l_sfu02    LIKE sfu_file.sfu02
   DEFINE l_sfv11    LIKE sfv_file.sfv11
   DEFINE l_shb031   LIKE shb_file.shb031
   DEFINE l_ecm012   LIKE ecm_file.ecm012
   DEFINE l_ecm03    LIKE ecm_file.ecm03 
   DEFINE l_shb111   LIKE shb_file.shb111
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_factor    LIKE ecm_file.ecm59
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_i         LIKE type_file.num5

   INITIALIZE l_shb.* TO NULL
   SELECT * INTO l_sgm.* FROM sgm_file
    WHERE sgm01  = l_sfv.sfv20
      AND sgm012 = l_ecm012
      AND sgm03  = l_ecm03

   LET l_t1 = s_get_doc_no(l_sfv.sfv01)

   LET l_sql = "SELECT smyslip FROM smy_file WHERE smy67 = '",l_t1,"'"
   LET l_t1=NULL
   PREPARE t324_s1_p1 FROM l_sql
   DECLARE t324_s1_c1 CURSOR FOR t324_s1_p1
   OPEN t324_s1_c1
   FETCH t324_s1_c1 INTO l_t1
   CLOSE t324_s1_c1
   IF cl_null(l_t1) THEN
      LET g_success='N'
      CALL cl_err(l_sfv.sfv11,'asf-151',1)
      RETURN FALSE
   END IF
   LET l_shb.shb01  = l_t1
   LET l_shb.shb03  = l_sfu02
   LET l_shb.shb05  = l_sfv.sfv11
   LET l_shb.shb06  = l_sgm.sgm03
   LET l_shb.shb16  = l_sgm.sgm01
   LET l_shb.shb012 = l_sgm.sgm012
   LET l_shb.shb10  = l_sgm.sgm03_par   #TQC-C10101 add
   LET l_shb.shb34 = l_sgm.sgm58    #FUN-BB0084
   LET l_shb.shb111 = 0
   LET l_shb.shb113 = 0
   LET l_shb.shb112 = 0
   LET l_shb.shb114 = 0
   LET l_shb.shb115 = 0
   LET l_shb.shb17  = 0
   IF l_sgm.sgm52='Y' THEN   #FUN-A90057
      LET l_shb.shb27  = l_sgm.sgm67
   END IF
   IF l_sgm.sgm62 IS NULL THEN LET l_sgm.sgm62 = 1 END IF
   IF l_sgm.sgm63 IS NULL THEN LET l_sgm.sgm63 = 1 END IF
   LET l_shb.shb02   = g_today
   LET l_shb031 = TIME
   LET l_shb.shb021  = l_shb031[1,5] #TQC-B20107
   LET l_shb.shb031  = l_shb031[1,5]
   LET l_shb.shb032  = 0  #TQC-B20107
   LET l_shb.shb033  = 0  #TQC-B20107
   LET l_shb.shbinp  = g_today
   LET l_shb.shbacti = 'Y'
   LET l_shb.shbuser = g_user
   LET l_shb.shboriu = g_user
   LET l_shb.shborig = g_grup
   LET g_data_plant = g_plant
   LET l_shb.shbgrup = g_grup
   LET l_shb.shbmodu = ''
   LET l_shb.shbdate = ''
   LET l_shb.shbplant = g_plant
   LET l_shb.shblegal = g_legal
   LET l_shb.shb04 = g_user

   LET l_shb.shb111 = l_shb111 * l_sgm.sgm62 / l_sgm.sgm63
   LET l_shb.shb111 = s_digqty(l_shb.shb111,l_shb.shb34)     #FUN-BB0084
   
   CALL s_auto_assign_no("asf",l_shb.shb01,l_shb.shb03,"9","shb_file","shb01","","","")
      RETURNING li_result,l_shb.shb01
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF

   LET l_shb.shb081 = l_sgm.sgm04

   IF l_shb.shb012 IS NULL THEN LET l_shb.shb012=' ' END IF

   #將sgm相關欄位帶入shb
   CALL t730sub_shb081(l_shb.*,l_sgm.*,l_shb.*) 
      RETURNING l_i,l_shb.*,l_sgm.*

   IF l_i = 1 THEN  #有錯誤
      RETURN FALSE
   END IF

   IF g_sma.sma1435='N' THEN
      LET l_shb.shb032 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_sgm.sgm14 / 60
      LET l_shb.shb033 = (l_shb.shb111+l_shb.shb112+l_shb.shb113+l_shb.shb114+l_shb.shb115) * l_sgm.sgm16 / 60
   END IF

   LET l_shb.shb30 = 'Y'
   CALL t730sub_shb26_31(l_shb.shb16,l_shb.shb012,l_shb.shb06) 
      RETURNING l_shb.shb26,l_shb.shb31
   IF cl_null(l_shb.shbconf) THEN LET l_shb.shbconf = 'N' END IF   #FUN-A70095
   INSERT INTO shb_file VALUES (l_shb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb05,SQLCA.sqlcode,1)
      RETURN FALSE
   END IF

   CALL cl_flow_notify(l_shb.shb01,'I')

   IF g_sma.sma1431='Y' THEN
      CALL t730sub_auto_report(l_shb.*,l_sgm.*)
   END IF

   IF g_success='Y' THEN   #TQC-B20107
      CALL t730sub_upd_sgm('a',l_shb.*)    # Update 製程追蹤檔
        RETURNING l_shb.*
   END IF  #TQC-B20107

   IF g_success='N' THEN
      RETURN FALSE
   END IF

   IF l_shb.shb112 > 0 THEN    #表示有報廢數量
      SELECT ima55 INTO l_ima55 FROM ima_file 
       WHERE ima01= l_shb.shb10

      CALL s_umfchk(l_shb.shb10,l_sgm.sgm58,l_ima55)                                                   
               RETURNING l_i,l_factor

      IF l_i = '1' THEN                                                                                             
         LET l_factor = 1
      END IF
      UPDATE sfb_file SET sfb12 = sfb12 + (l_shb.shb112 * l_factor)
       WHERE sfb01 = l_shb.shb05 
      IF SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err(l_shb.shb05,'asf-861',1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-A80102(E)

#TQC-AC0294-------start------------
FUNCTION t324_sfu01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73
 
   LET g_errno = ' '
   IF cl_null(g_sfu.sfu01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_sfu.sfu01)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-876'
   END IF

END FUNCTION
#TQC-AC0294--------end----------------

#No.FUN-BB0086---start---add---
FUNCTION t324_sfv32_check(l_qcf091,l_sfb08,l_sfv09)
   DEFINE l_qcf091         LIKE qcf_file.qcf091
   DEFINE l_sfb08          LIKE sfb_file.sfb08
   DEFINE l_sfv09          LIKE sfv_file.sfv09
   
   IF NOT cl_null(g_sfv[l_ac].sfv32) AND NOT cl_null(g_sfv[l_ac].sfv30) THEN
      IF cl_null(g_sfv_t.sfv32) OR cl_null(g_sfv30_t) OR g_sfv_t.sfv32 != g_sfv[l_ac].sfv32 OR g_sfv30_t != g_sfv[l_ac].sfv30 THEN
         LET g_sfv[l_ac].sfv32=s_digqty(g_sfv[l_ac].sfv32, g_sfv[l_ac].sfv30)
         DISPLAY BY NAME g_sfv[l_ac].sfv32
      END IF
   END IF
   
   IF NOT cl_null(g_sfv[l_ac].sfv32) THEN
      IF g_sfv[l_ac].sfv32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'sfv32'
      END IF
   END IF
   CALL t324_du_data_to_correct()
   CALL t324_set_origin_field()
   CALL t324_unit(g_sfv[l_ac].sfv08)
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN FALSE,'sfv05'
   END IF
   IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0 THEN
      LET g_sfv[l_ac].sfv09 = 0
      IF g_ima906 MATCHES '[23]' THEN
         RETURN FALSE,'sfv35'
      ELSE
         RETURN FALSE,'sfv32'
      END IF
   END IF
   IF g_argv MATCHES '[12]' THEN   #入庫,退回
      SELECT shm08,shm09 INTO l_sfb08,l_sfv09 FROM shm_file
       WHERE shm01 = g_sfv[l_ac].sfv20
      IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
      IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
         IF g_argv = '2' THEN   #退庫時不可大於入庫數量
            IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
               CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN FALSE,'sfv35'
               ELSE
                  RETURN FALSE,'sfv32'
               END IF
            END IF
         END IF
      END IF
      #工單完工方式為'2' pull
      IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
         g_sfb.sfb39 <> '2' THEN
         # check 入庫數量 不可 大於 (生產數量-完工數量)
 
# sma73 工單完工數量是否檢查發料最小套數
# sma74 工單完工量容許差異百分比
         #入庫量不可大於最小套數-以keyin 入庫量
         IF g_sma.sma73='Y'  #
            AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_woqty) THEN
            CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',0)
            IF g_ima906 MATCHES '[23]' THEN
               RETURN FALSE,'sfv35'
            ELSE
               RETURN FALSE,'sfv32'
            END IF
         END IF
 
         IF g_sfb.sfb93='Y' AND # 走製程 check 轉出量
            (g_sfv[l_ac].sfv09) > g_sgm_out - tmp_qty THEN
            IF NOT t324_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv20,g_sfv[l_ac].sfv09) THEN  #FUN-A90057
               CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',0)
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN FALSE,'sfv35'
               ELSE
                  RETURN FALSE,'sfv32'
               END IF
            END IF
         END IF
         IF g_sfb.sfb94='Y' AND #是否使用FQC功能
            (g_sfv[l_ac].sfv09) > l_qcf091 - tmp_qty
            THEN
            #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
            CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
            IF g_ima906 MATCHES '[23]' THEN
               RETURN FALSE,'sfv35'
            ELSE
               RETURN FALSE,'sfv32'
            END IF
         END IF
      END IF
      IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
         g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
         THEN
         #----退回量不可大於完工入庫量
         CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
         IF g_ima906 MATCHES '[23]' THEN
            RETURN FALSE,'sfv35'
         ELSE
            RETURN FALSE,'sfv32'
         END IF
      END IF
      RETURN TRUE,''
END FUNCTION
#No.FUN-BB0086---end---add---

#N

#FUN-BC0104---add---str       

FUNCTION t324_sfv46_check()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_n1    LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_sql1  STRING
   DEFINE l_sql2  STRING

   LET l_n  = 0
   LET l_n1 = 0

   LET l_sql= "SELECT COUNT(*) FROM sfv_file",
              " WHERE  sfv17 = ?"

   LET l_sql1=l_sql CLIPPED," AND sfv46 IS NOT NULL AND sfv46<>' '"
   PREPARE insert_ln FROM l_sql1
   EXECUTE insert_ln INTO l_n USING g_sfv[l_ac].sfv17

   LET l_sql2=l_sql CLIPPED," AND sfv46 IS NULL OR sfv46=' '"
   PREPARE insert_ln1 FROM l_sql2           
   EXECUTE insert_ln1 INTO l_n1 USING g_sfv[l_ac].sfv17

   IF l_n > 0 THEN 
      CALL cl_set_comp_required('sfv46,sfv47',TRUE)
   END IF
   IF l_n1 > 0 THEN
      LET g_sfv[l_ac].sfv46 = ''
      LET g_sfv[l_ac].sfv47 = ''
      DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
      CALL cl_set_comp_entry('sfv46,sfv47',FALSE)
   END IF 
                 
END FUNCTION 

FUNCTION t324_set_noentry_sfv46()
   CALL cl_set_comp_entry('sfv46,sfv47',FALSE)
END FUNCTION

FUNCTION t324_set_comp_required(p_sfv46,p_sfv47)
   DEFINE p_sfv46 LIKE sfv_file.sfv46,
          p_sfv47 LIKE sfv_file.sfv47

   IF NOT cl_null(p_sfv46) OR NOT cl_null(p_sfv47) THEN
      CALL cl_set_comp_required('sfv46,sfv47',TRUE)
   END IF
 
   IF cl_null(p_sfv46) AND cl_null(p_sfv47) THEN
      CALL cl_set_comp_required('sfv46,sfv47',FALSE)
      LET g_sfv[l_ac].qcl02 = ''
   END IF
END FUNCTION

FUNCTION t324_qcl02_desc()

   SELECT qcl02 INTO g_sfv[l_ac].qcl02 FROM qcl_file
             WHERE qcl01 = g_sfv[l_ac].sfv46
      DISPLAY BY NAME g_sfv[l_ac].qcl02
   
END FUNCTION

FUNCTION t324_qcl05_check() 
   DEFINE l_qcl05 LIKE qcl_file.qcl05

   IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
      SELECT qcl05 INTO l_qcl05 FROM qcl_file
                                WHERE qcl01 = g_sfv[l_ac].sfv46
      RETURN l_qcl05
   END IF 
RETURN ''
END FUNCTION

FUNCTION t324_qco_show()
DEFINE l_qcl05 LIKE qcl_file.qcl05
DEFINE l_sum   LIKE qco_file.qco11
DEFINE l_sum1  LIKE qco_file.qco11
   
      SELECT qco06,qco07,qco08,qco09,qco10 INTO g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                                g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                                g_sfv[l_ac].sfv08
                                           FROM qco_file
                                          WHERE qco01 = g_sfv[l_ac].sfv17
                                            AND qco02 = 0
                                            AND qco05 = 0
                                            AND qco04 = g_sfv[l_ac].sfv47
      DISPLAY BY NAME g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                      g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                      g_sfv[l_ac].sfv08
      CALL t324_qcl05_check() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN                     #TQC-C30013
         CALL t324_sfv09_check('') RETURNING g_sfv[l_ac].sfv09
         CALL cl_set_comp_entry('sfv09',TRUE)
         DISPLAY BY NAME g_sfv[l_ac].sfv09
      END IF
END FUNCTION

FUNCTION t324_sfv09_check(p_cmd)
DEFINE l_sum LIKE qco_file.qco11,
       p_cmd LIKE type_file.chr1
   SELECT qco11-qco20 INTO l_sum FROM qco_file
                                      WHERE qco01 = g_sfv[l_ac].sfv17
                                        AND qco02 = 0
                                        AND qco05 = 0
                                        AND qco04 = g_sfv[l_ac].sfv47
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
   IF p_cmd = 'u' THEN
      LET l_sum = l_sum+g_sfv_t.sfv09
   END IF
   RETURN l_sum
    
END FUNCTION 

FUNCTION t324_sfv05_check()
DEFINE l_n     LIKE type_file.num5,
       l_qcl05 LIKE qcl_file.qcl05,
       l_sql   STRING
   LET l_n = 0
   LET l_sql="SELECT COUNT(*) FROM qcl_file,imd_file",
             " WHERE qcl01='",g_sfv[l_ac].sfv46 CLIPPED,
             "' AND imd01 = '",g_sfv[l_ac].sfv05 CLIPPED,
             "' AND qcl03=imd11 AND qcl04=imd12"
   SELECT qcl05 INTO l_qcl05 FROM qcl_file
                  WHERE qcl01 = g_sfv[l_ac].sfv46
   IF l_qcl05 = '0' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
   END IF

  #TQC-C30013---add---str---
   IF l_qcl05 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 IN(SELECT jce02 FROM jce_file)"
   END IF
  #TQC-C30013---add---end---

   PREPARE insert_l_n2 FROM l_sql
   EXECUTE insert_l_n2 INTO l_n

   IF l_n = 0 THEN
      RETURN FALSE
   END IF
RETURN TRUE
END FUNCTION




#str----end by huanglf161017
