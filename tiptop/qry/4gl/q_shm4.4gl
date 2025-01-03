# Prog. Version..: '5.30.06-13.03.12(00001)'     #
 
# Program name  : q_shm4.4gl
# Program ver.  : 7.0
# Description   : Run Card資料查詢(供Run Card發料作業開窗使用)
# Date & Author : 2012/07/13 by suncx (FUN-C70014)
# Memo          : 
# Modify.........: No.FUN-C70014 12/07/13 By suncx

DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         sgm45    LIKE sgm_file.sgm45,
         shm08    LIKE shm_file.shm08,
         shm05    LIKE shm_file.shm05,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         shm09    LIKE shm_file.shm09
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         sgm45    LIKE sgm_file.sgm45,
         shm08    LIKE shm_file.shm08,
         shm05    LIKE shm_file.shm05,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         shm09    LIKE shm_file.shm09
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default2 RECORD
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         shm05    LIKE shm_file.shm05
         END RECORD     
DEFINE   ms_default3      STRING     
DEFINE   ms_ret2 DYNAMIC ARRAY OF RECORD
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         shm05    LIKE shm_file.shm05
         END RECORD,
         ms_ret3          STRING,    #回傳欄位的變數
         ms_key1          LIKE shm_file.shm01

FUNCTION q_shm4(pi_multi_sel,pi_need_cons,p_key1,ps_default2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE shm_file.shm01, #預設回傳值(在取消時會回傳此類預設值).
            ps_default2    RECORD
                           shm01    LIKE shm_file.shm01,
                           shm012   LIKE shm_file.shm012,
                           sgm04    LIKE sgm_file.sgm04,
                           shm05    LIKE shm_file.shm05
                           END RECORD,     #預設回傳值(在取消時會回傳此類預設值).
            p_key1         LIKE shm_file.shm01

   LET ms_default2.* = ps_default2.*
   LET ms_key1     = p_key1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_shm4" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_shm4")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("shm01,shm012,sgm04,shm05", "red")
   END IF
 
   CALL shm4_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret2 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2012/07/16 by suncx
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION shm4_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	
   DEFINE   li_start_index   LIKE type_file.num10, 	
            li_end_index     LIKE type_file.num10 	
   DEFINE   li_curr_page     LIKE type_file.num5  	
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON shm01,shm012,sgm04,sgm45,shm08,shm05,
                                       ima02,ima021,shm09
                       FROM s_shm[1].shm01,s_shm[1].shm012,s_shm[1].sgm04,
                            s_shm[1].sgm45,s_shm[1].shm08,s_shm[1].shm05,
                            s_shm[1].ima02,s_shm[1].ima021,s_shm[1].shm09
                            
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
 
            END CONSTRUCT
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL shm4_qry_prep_result_set() 
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
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
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL shm4_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL shm4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL shm4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION shm4_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,  	
            shm01    LIKE shm_file.shm01,
            shm012   LIKE shm_file.shm012,
            sgm04    LIKE sgm_file.sgm04,
            sgm45    LIKE sgm_file.sgm45,
            shm08    LIKE shm_file.shm08,
            shm05    LIKE shm_file.shm05,
            ima02    LIKE ima_file.ima02,
            ima021   LIKE ima_file.ima021,
            shm09    LIKE shm_file.shm09
            END RECORD
   DEFINE l_count    LIKE type_file.num5       
   DEFINE l_sgm01    LIKE sgm_file.sgm01
   DEFINE l_sgm03    LIKE sgm_file.sgm03
   DEFINE l_shm01    LIKE shm_file.shm01,
          l_shm012   LIKE shm_file.shm012,
          l_shm05    LIKE shm_file.shm05,
          l_shm08    LIKE shm_file.shm08,
          l_shm09    LIKE shm_file.shm09
 
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_shm4', 'sgm_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   LET ls_sql = "SELECT DISTINCT 'N',shm01,shm012,sgm04,sgm45,shm08,shm05,",
                "                ima02,ima021,shm09 ",
                "  FROM sgm_file,sfb_file,shm_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = shm05",     
                " WHERE sgm02 = sfb01",
                "   AND (sfb04 <> '0' OR sfb04 <> '8') ",   #工單不可為開立或結案
                "   AND ",ms_cons_where CLIPPED,
                "   AND sgm01 = shm01 AND shm28='N'"        
 					
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
   LET ls_sql = ls_sql CLIPPED," ORDER BY shm01,shm012,sgm04 " 
 
   DECLARE lcurs_qry CURSOR FROM ls_sql
   CALL ma_qry.clear()
   LET li_i = 1
   FOREACH lcurs_qry INTO lr_qry.*
       IF (SQLCA.SQLCODE) THEN
           CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
           EXIT FOREACH
       END IF
 
       #判斷是否已達選取上限 
       IF li_i-1 >= g_aza.aza38 THEN
           CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
           EXIT FOREACH
       END IF
       LET ma_qry[li_i].* = lr_qry.*
       LET li_i = li_i + 1
    END FOREACH
END FUNCTION

##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION shm4_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION

##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION shm4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  
   DEFINE   li_i             LIKE type_file.num5   
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_shm.* 
         ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL shm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL shm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL shm4_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN      
            CALL GET_FLDBUF(s_shm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL shm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL shm4_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        
            CALL ms_ret2.clear()     
         END IF                      
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret2[1].* = ms_default2.*
         END IF
         LET li_continue = FALSE
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify     	:
##################################################
FUNCTION shm4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_shm.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
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
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
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
         EXIT DISPLAY
         
      ON ACTION accept
         CALL shm4_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret2[1].* = ms_default2.*
         END IF
         LET li_continue = FALSE
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	    : void
# Memo        	:
# Modify     	:
##################################################
FUNCTION shm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION

##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2012/07/18 by suncx
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	    : void
# Memo        	:
# Modify   	    :
##################################################
FUNCTION shm4_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i,l_j        LIKE type_file.num10
 
 
   #GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
   CALL ms_ret2.clear()
   LET l_j = 1
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            LET ms_ret2[l_j].shm01 = ma_qry[li_i].shm01
            LET ms_ret2[l_j].shm012 = ma_qry[li_i].shm012
            LET ms_ret2[l_j].sgm04 = ma_qry[li_i].sgm04
            LET ms_ret2[l_j].shm05 = ma_qry[li_i].shm05
            LET l_j = l_j+1
         END IF    
      END FOR
      #複選狀態只會有一組字串回傳值. 
      CALL ms_ret2.deleteElement(l_j)
   ELSE
      LET ms_ret2[l_j].shm01 = ma_qry[li_i].shm01
      LET ms_ret2[l_j].shm012 = ma_qry[li_i].shm012
      LET ms_ret2[l_j].sgm04 = ma_qry[li_i].sgm04
      LET ms_ret2[l_j].shm05 = ma_qry[li_i].shm05
      #設定多個回傳值.格式為ms_ret+流水號
   END IF
END FUNCTION

##################################################
# Description   : 重設查詢資料.
# Date & Author : 2012/07/18 by suncx
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION shm4_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'Y'
   END FOR
END FUNCTION
#FUN-C70014
