# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri025_2.4gl
# Descriptions...: 
# Date & Author..: 04/20/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrbhb DYNAMIC ARRAY OF RECORD
         hrbhb01   LIKE   hrbhb_file.hrbhb01,
         hrbhb03   LIKE   hrbhb_file.hrbhb03,
         hrat02    LIKE   hrat_file.hrat02,
         hrbhb04   LIKE   hrbhb_file.hrbhb04,
         hrbhb05   LIKE   hrbhb_file.hrbhb05,
         hrbhb06   LIKE   hrbhb_file.hrbhb06,
         hrbhb07   LIKE   hrbhb_file.hrbhb07,
         hrbhb08   LIKE   hrbhb_file.hrbhb07 
               END RECORD
DEFINE g_hrbhb_t RECORD
         hrbhb01   LIKE   hrbhb_file.hrbhb01,
         hrbhb03   LIKE   hrbhb_file.hrbhb03,
         hrat02    LIKE   hrat_file.hrat02,
         hrbhb04   LIKE   hrbhb_file.hrbhb04,
         hrbhb05   LIKE   hrbhb_file.hrbhb05,
         hrbhb06   LIKE   hrbhb_file.hrbhb06,
         hrbhb07   LIKE   hrbhb_file.hrbhb07,
         hrbhb08   LIKE   hrbhb_file.hrbhb07
               END RECORD 
DEFINE g_argv1     LIKE   hrbhb_file.hrbhb02
DEFINE g_wc2           STRING,
       g_sql           STRING,
       g_cmd           LIKE type_file.chr1000, 
       g_rec_b         LIKE type_file.num5,                
       l_ac            LIKE type_file.num5 
DEFINE g_cnt           LIKE type_file.num5 
DEFINE g_forupd_sql STRING     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING                     


MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
       INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("GHR")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   
    LET g_argv1=ARG_VAL(1)
    
    SELECT COUNT(*) INTO g_i FROM hrbh_file WHERE hrbh01=g_argv1	
    IF g_i=0 THEN
    	 CALL  cl_used(g_prog,g_time,2) RETURNING g_time
    	 RETURN
    END IF	
    	 
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i025_2_w AT p_row,p_col WITH FORM "ghr/42f/ghri025_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    LET g_wc2=" hrbhb02='",g_argv1,"'"
    CALL i025_2_b_fill(g_wc2)

    CALL i025_2_menu()
    CLOSE WINDOW i025_2_w                 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i025_2_menu()
 
   WHILE TRUE
      CALL i025_2_bp("G")
      CASE g_action_choice

         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i025_2_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbhb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i025_2_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid    
DEFINE l_hrbhconf   LIKE hrbh_file.hrbhconf

    SELECT hrbhconf INTO l_hrbhconf FROM hrbh_file WHERE hrbh01=g_argv1
    IF l_hrbhconf != '1' THEN
       CALL cl_err('资料已审核,不可再维护部门面谈信息','!',1)
       LET g_action_choice=""
       RETURN
    END IF      
   
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbhb01,hrbhb03,'',hrbhb04,hrbhb05,hrbhb06,hrbhb07,hrbhb08",
                       "  FROM hrbhb_file WHERE hrbhb01=? AND hrbhb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i025_2_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbhb WITHOUT DEFAULTS FROM s_hrbhb.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_hrbhb_t.* = g_hrbhb[l_ac].*  #BACKUP
           OPEN i025_2_bcl USING g_hrbhb_t.hrbhb01,g_argv1
           IF STATUS THEN
              CALL cl_err("OPEN i025_2_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i025_2_bcl INTO g_hrbhb[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbhb_t.hrbhb01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           
           SELECT hrat01,hrat02 INTO g_hrbhb[l_ac].hrbhb03,g_hrbhb[l_ac].hrat02 
             FROM hrat_file
            WHERE hratid=g_hrbhb[l_ac].hrbhb03
                  
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end  
         INITIALIZE g_hrbhb[l_ac].* TO NULL      #900423
         
         LET g_hrbhb[l_ac].hrbhb04=g_today
         LET g_hrbhb[l_ac].hrbhb06='Y'
         SELECT MAX(hrbhb01)+1 INTO g_hrbhb[l_ac].hrbhb01 FROM hrbhb_file
          WHERE hrbhb02=g_argv1
         IF cl_null(g_hrbhb[l_ac].hrbhb01) THEN 
         	  LET g_hrbhb[l_ac].hrbhb01=1
         END IF
                         
         LET g_hrbhb_t.* = g_hrbhb[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbhb03 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i025_2_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrbhb03存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbhb[l_ac].hrbhb03
        
        INSERT INTO hrbhb_file(hrbhb01,hrbhb02,hrbhb03,hrbhb04,hrbhb05,                          #FUN-A30097
                               hrbhb06,hrbhb07,hrbhb08)  
               VALUES(g_hrbhb[l_ac].hrbhb01,g_argv1,
                      l_hratid,g_hrbhb[l_ac].hrbhb04,                                                              #FUN-A80148--mark--
                      g_hrbhb[l_ac].hrbhb05,g_hrbhb[l_ac].hrbhb06,
                      g_hrbhb[l_ac].hrbhb07,g_hrbhb[l_ac].hrbhb08) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbhb_file",g_hrbhb[l_ac].hrbhb01,g_argv1,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrbhb03
       IF NOT cl_null(g_hrbhb[l_ac].hrbhb03) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrbhb[l_ac].hrbhb03
       	                                            AND hratid=g_argv1
       	                                            AND hratconf='Y'
       	  IF l_n>0 THEN
       	  	 CALL cl_err('面谈人员不能为申请离退人员本人','!',0)
       	  	 NEXT FIELD hrbhb03
       	  END IF
       	  	
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrbhb[l_ac].hrbhb03
       	                                            AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此人员编号','!',0)
       	  	 NEXT FIELD hrbhb03
       	  END IF 
       	  	
       	  SELECT hrat02 INTO g_hrbhb[l_ac].hrat02 FROM hrat_file 
       	   WHERE hrat01=g_hrbhb[l_ac].hrbhb03
       	  DISPLAY BY NAME g_hrbhb[l_ac].hrat02
       	  
       END IF 	   	

       	       	
    BEFORE DELETE                            
       IF g_hrbhb_t.hrbhb01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbhb_file WHERE hrbhb01 = g_hrbhb_t.hrbhb01
                                   AND hrbhb02 = g_argv1
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbhb_file",g_hrbhb_t.hrbhb01,g_hrbhb_t.hrbhb03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrbhb[l_ac].* = g_hrbhb_t.*
         CLOSE i025_2_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbhb[l_ac].hrbhb01,-263,0)
          LET g_hrbhb[l_ac].* = g_hrbhb_t.*
       ELSE
          SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbhb[l_ac].hrbhb03  
          #FUN-A30030 END--------------------
          UPDATE hrbhb_file SET hrbhb03=l_hratid,
                                hrbhb04=g_hrbhb[l_ac].hrbhb04,
                                hrbhb05=g_hrbhb[l_ac].hrbhb05,
                                hrbhb06=g_hrbhb[l_ac].hrbhb06,
                                hrbhb07=g_hrbhb[l_ac].hrbhb07,
                                hrbhb08=g_hrbhb[l_ac].hrbhb08
                WHERE hrbhb01 = g_hrbhb_t.hrbhb01
                  AND hrbhb02 = g_argv1
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbhb_file",g_hrbhb_t.hrbhb01,g_hrbhb_t.hrbhb03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbhb[l_ac].* = g_hrbhb_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbhb[l_ac].* = g_hrbhb_t.*
          END IF
          CLOSE i025_2_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i025_2_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbhb03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat02"
             LET g_qryparam.default1 = g_hrbhb[l_ac].hrbhb03
             CALL cl_create_qry() RETURNING g_hrbhb[l_ac].hrbhb03
             DISPLAY BY NAME g_hrbhb[l_ac].hrbhb03
             NEXT FIELD hrbhb03
             
         OTHERWISE
           EXIT CASE
         END CASE
 
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
 
    END INPUT
 
    CLOSE i025_2_bcl
    COMMIT WORK
END FUNCTION     	     		


FUNCTION i025_2_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbhb01,hrbhb03,'',hrbhb04,hrbhb05,hrbhb06,hrbhb07,hrbhb08",
                   " FROM hrbhb_file",
                   " WHERE ",p_wc2 CLIPPED,
                   " ORDER BY 1" 
 
    PREPARE i025_2_pb FROM g_sql
    DECLARE hrbhb_curs CURSOR FOR i025_2_pb
 
    CALL g_hrbhb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbhb_curs INTO g_hrbhb[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #显示交接人工号姓名
        SELECT hrat01,hrat02 INTO g_hrbhb[g_cnt].hrbhb03,g_hrbhb[g_cnt].hrat02 
          FROM hrat_file 
         WHERE hratid=g_hrbhb[g_cnt].hrbhb03
           AND hratacti='Y'
           AND hratconf='Y'
                              
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbhb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i025_2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbhb TO s_hrbhb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
                             
