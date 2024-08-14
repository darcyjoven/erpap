# Prog. Version..: '5.30.06-13.03.15(00005)'     #
# Pattern name..: cq_oga_1.4gl
# Program ver.  : 7.0

 
DATABASE ds   #No.FUN-AA0080
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE oga_qry           DYNAMIC ARRAY OF RECORD
                        oga01  LIKE oga_file.oga01,
                        oga02  LIKE oga_file.oga02,
                        oga04  LIKE oga_file.oga04,
                        occ02  LIKE occ_file.occ02
                        END RECORD
DEFINE oga_qry_tmp       DYNAMIC ARRAY OF RECORD
                        oga01  LIKE oga_file.oga01,
                        oga02  LIKE oga_file.oga02,
                        oga04  LIKE oga_file.oga04,
                        occ02  LIKE occ_file.occ02
                        END RECORD
 
DEFINE ms_cons_where    STRING                   #暫存CONSTRUCT區塊的WHERE條件.
DEFINE mi_multi_sel     LIKE type_file.num5      #是否需要複選資料(TRUE/FALSE).  
DEFINE mi_need_cons     LIKE type_file.num5      #是否需要CONSTRUCT(TRUE/FALSE). 
DEFINE mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.    
DEFINE ms_default1      STRING     
DEFINE ms_ret1          STRING 
DEFINE ms_type          LIKE type_file.chr2  
DEFINE ms_plant         LIKE type_file.chr10 
DEFINE ms_imd01_cons    LIKE type_file.chr1
DEFINE ms_where_sql     STRING
DEFINE l_chr            LIKE type_file.chr1 
 
FUNCTION cq_oga_1()

 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_cqry WITH FORM "cqry/42f/cq_oga_1" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("cq_oga_1")  #No.FUN-AB0029
 
   CALL cq_oga_1_qry_sel()
 
   CLOSE WINDOW w_cqry

   RETURN ms_ret1
END FUNCTION

FUNCTION cq_oga_1_qry_sel()
     DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.      #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.       #No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.      #No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5        #No.FUN-680131 SMALLINT
 
   LET l_chr = 'N'
   #LET mi_page_count = 20   #MOD-D20163
   LET mi_page_count = 100   #MOD-D20163
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
         IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
           CALL cq_oga_1_construct()   
         END IF
         
         CALL cq_oga_1_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = oga_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= oga_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > oga_qry.getLength()) THEN
         LET li_end_index = oga_qry.getLength()
      END IF
     
      CALL cq_oga_1_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || oga_qry.getLength() || "  Page : " || li_curr_page
     

    CALL cq_oga_1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index

     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION cq_oga_1_construct()
  CLEAR FORM
  CALL oga_qry_tmp.clear()

  CONSTRUCT ms_cons_where ON  oga01,oga02,oga04,occ02
       FROM s_oga[1].oga01,s_oga[1].oga02,s_oga[1].oga04,s_oga[1].occ02
    
     ON ACTION about         
        CALL cl_about()        
     
     ON ACTION help          
        CALL cl_show_help()  
     
     ON ACTION controlg      
        CALL cl_cmdask()      
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  END CONSTRUCT
END FUNCTION 


FUNCTION cq_oga_1_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE ls_sql        STRING,
          ls_where      STRING
   DEFINE li_i          LIKE type_file.num10,       
          l_begin_key   LIKE imd_file.imd01
   DEFINE lr_qry        RECORD
                        oga01  LIKE oga_file.oga01,
                        oga02  LIKE oga_file.oga02,
                        oga04  LIKE oga_file.oga04,
                        occ02  LIKE occ_file.occ02
                        END RECORD
   DEFINE lr_qry1       RECORD  
                        oga01  LIKE oga_file.oga01,
                        ogb31  LIKE ogb_file.ogb31,
                        ogb32  LIKE ogb_file.ogb32,
                        ogb04  LIKE ogb_file.ogb04,
                        ogb12  LIKE ogb_file.ogb12
                        END RECORD
   DEFINE l_n           LIKE type_file.num10   
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_ogb12       LIKE ogb_file.ogb12   
   DEFINE l_sql         STRING
   
   LET l_filter_cond = cl_get_extra_cond_for_qry('cq_oga_1','oga_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET ls_sql = "SELECT oga01,oga02,oga04,occ02",                         
                 " FROM oga_file,occ_file,ogb_file",
                 " WHERE ",ms_cons_where,
                 " AND ogaconf = 'Y'  AND oga04 = occ01 AND oga09 = '1' "
       
     PREPARE oga_prepare1 FROM ls_sql
 
     DECLARE lcurs_qry CURSOR WITH HOLD FOR oga_prepare1
 
   FOR li_i = oga_qry.getLength() TO 1 STEP -1
      CALL oga_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
   LET  l_sql  = " SELECT oga01,ogb31,ogb32,ogb04,sum(ogb12)",
                 " FROM oga_file,ogb_file",
                 " WHERE oga01 = ogb01 AND oga011 = '",lr_qry.oga01,"'",
                 " GROUP BY oga01, ogb31, ogb32, ogb04",
                 " ORDER BY oga01,ogb31,ogb32"
    PREPARE oga_prepare2 FROM l_sql
    DECLARE lcurs_qry1 CURSOR WITH HOLD FOR oga_prepare2
    FOREACH lcurs_qry1 INTO lr_qry1.*
    LET l_flag = 'N'
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      SELECT ogb12 INTO l_ogb12 FROM ogb_file,oga_file 
      WHERE oga01 = ogb01 AND oga01 = lr_qry.oga01 
            AND ogb31 = lr_qry1.ogb31 AND ogb32 = lr_qry1.ogb32 AND oga09 = '1'
     IF l_ogb12 > lr_qry1.ogb12 THEN 
        LET l_flag = 'Y'
      END IF 
    END FOREACH 
    IF l_flag = 'Y' THEN 
      LET oga_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
    END IF 
    IF li_i = 1 THEN 
      EXIT FOREACH 
    END IF 
   END FOREACH
END FUNCTION
 

FUNCTION cq_oga_1_qry_set_display_data(pi_start_index,pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10,       #No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10       #No.FUN-680131 INTEGER
 
 
   FOR li_i = oga_qry_tmp.getLength() TO 1 STEP -1
      CALL oga_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET oga_qry_tmp[li_j+1].* = oga_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(oga_qry_tmp.getLength())
END FUNCTION
 

 
FUNCTION cq_oga_1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,        #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5        #No.FUN-680131 SMALLINT
   DEFINE   oga01            LIKE oga_file.oga01
 
   DISPLAY ARRAY oga_qry_tmp TO s_oga.*
      BEFORE DISPLAY
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= oga_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET l_chr = 'Y'
         
         EXIT DISPLAY
      ON ACTION accept
         CALL cq_oga_1_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(oga_qry),'','')
 
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
     
      ON ACTION qry_string
         CALL cl_qry_string("detail")
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
  RETURN ps_hide_act, pi_start_index, pi_end_index
END FUNCTION 



 FUNCTION cq_oga_1_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10        #No.FUN-680131 INTEGER

   IF pi_sel_index = 0 THEN
      RETURN
   END IF
     LET ms_ret1 = oga_qry[pi_sel_index].oga01
   
END FUNCTION


 