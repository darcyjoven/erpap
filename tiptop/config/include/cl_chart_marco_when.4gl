FUNCTION cl_udm_chart(p_chart_id, p_argv1, p_argv2, p_wc) 
   DEFINE p_chart_id   STRING #圖表代號 
   DEFINE p_argv1      STRING #條件1 
   DEFINE p_argv2      STRING #條件2 
   DEFINE p_wc         STRING #Web Component 
   IF cl_null(p_chart_id) THEN LET p_chart_id = "" END IF 
   CASE p_chart_id 
      WHEN "" 
      WHEN "s_chart_ap_aging_d"   
         CALL s_chart_ap_aging_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_ar_aging_d"   
         CALL s_chart_ar_aging_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_close_d"   
         CALL s_chart_close_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_cusorder_d"   
         CALL s_chart_cusorder_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_custar_d"   
         CALL s_chart_custar_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_deposit_d"   
         CALL s_chart_deposit_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_empachi_d"   
         CALL s_chart_empachi_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_online_d"   
         CALL s_chart_online_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_purcost_d"   
         CALL s_chart_purcost_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_sal_custclass_d"   
         CALL s_chart_sal_custclass_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_sal_itemclass_d"   
         CALL s_chart_sal_itemclass_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_salecost_d"   
         CALL s_chart_salecost_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_stockABC_d"   
         CALL s_chart_stockABC_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_stock_d"   
         CALL s_chart_stock_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_stocktype_d"   
         CALL s_chart_stocktype_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_unitcost_d"   
         CALL s_chart_unitcost_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_vendap_d"   
         CALL s_chart_vendap_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_verreceipt_d"   
         CALL s_chart_verreceipt_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_wo_qtydiff_d"   
         CALL s_chart_wo_qtydiff_d(p_argv1, p_argv2, p_wc) 
      WHEN "s_chart_wofin_d"   
         CALL s_chart_wofin_d(p_argv1, p_argv2, p_wc) 
   END CASE  
END FUNCTION 
FUNCTION cl_chart_set_combo_items(p_wc, p_chart_id, p_v1, p_v2) 
   DEFINE p_chart_id   STRING #圖表代號 
   DEFINE p_v1         STRING 
   DEFINE p_v2         STRING 
   DEFINE p_wc         STRING #Web Component 
   DEFINE l_comb       STRING #篩選條件的ComboBox名稱 
   DEFINE l_r1, l_r2   STRING #設定ComboBox後的預設值 
   LET l_comb = p_wc, "_combo" 
   IF cl_null(p_chart_id) THEN LET p_chart_id = "" END IF 
   CASE p_chart_id 
      WHEN "" 
      WHEN "s_chart_ap_aging_d"   
         CALL s_chart_ap_aging_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_ar_aging_d"   
         CALL s_chart_ar_aging_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_close_d"   
         CALL s_chart_close_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_cusorder_d"   
         CALL s_chart_cusorder_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_custar_d"   
         CALL s_chart_custar_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_deposit_d"   
         CALL s_chart_deposit_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_empachi_d"   
         CALL s_chart_empachi_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_online_d"   
         CALL s_chart_online_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_purcost_d"   
         CALL s_chart_purcost_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_sal_custclass_d"   
         CALL s_chart_sal_custclass_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_sal_itemclass_d"   
         CALL s_chart_sal_itemclass_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_salecost_d"   
         CALL s_chart_salecost_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_stockABC_d"   
         CALL s_chart_stockABC_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_stock_d"   
         CALL s_chart_stock_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_stocktype_d"   
         CALL s_chart_stocktype_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_unitcost_d"   
         CALL s_chart_unitcost_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_vendap_d"   
         CALL s_chart_vendap_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_verreceipt_d"   
         CALL s_chart_verreceipt_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_wo_qtydiff_d"   
         CALL s_chart_wo_qtydiff_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
      WHEN "s_chart_wofin_d"   
         CALL s_chart_wofin_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2
   END CASE  
   RETURN l_r1, l_r2 
END FUNCTION
