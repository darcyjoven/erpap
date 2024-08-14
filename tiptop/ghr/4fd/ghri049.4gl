# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri049.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrci    DYNAMIC ARRAY OF RECORD
                  sure      LIKE type_file.chr1,  
                  hrci01 LIKE hrci_file.hrci01, 
                  hrat01 LIKE hrat_file.hrat01, 
                  hrat02 LIKE hrat_file.hrat02, 
                  hrat04 LIKE hrat_file.hrat04, 
                  hrao02 LIKE hrao_file.hrao02, 
                  hrat05 LIKE hrat_file.hrat05, 
                  hras04 LIKE hras_file.hras04, 
                  hrci03 LIKE hrci_file.hrci03, 
                  hrci04 LIKE hrci_file.hrci04, 
                  hrci05 LIKE hrci_file.hrci05, 
                  hrci06 LIKE hrci_file.hrci06, 
                  hrci07 LIKE hrci_file.hrci07, 
                  hrci08 LIKE hrci_file.hrci08, 
                  hrci09 LIKE hrci_file.hrci09, 
                  hrci10 LIKE hrci_file.hrci10, 
                  hrci11 LIKE hrci_file.hrci11, 
                  hrciconf LIKE hrci_file.hrciconf               
               END RECORD,
 
       g_hrci_t RECORD
                  sure      LIKE type_file.chr1,   
                  hrci01 LIKE hrci_file.hrci01, 
                  hrat01 LIKE hrat_file.hrat01, 
                  hrat02 LIKE hrat_file.hrat02, 
                  hrat04 LIKE hrat_file.hrat04, 
                  hrao02 LIKE hrao_file.hrao02, 
                  hrat05 LIKE hrat_file.hrat05, 
                  hras04 LIKE hras_file.hras04, 
                  hrci03 LIKE hrci_file.hrci03, 
                  hrci04 LIKE hrci_file.hrci04, 
                  hrci05 LIKE hrci_file.hrci05, 
                  hrci06 LIKE hrci_file.hrci06, 
                  hrci07 LIKE hrci_file.hrci07, 
                  hrci08 LIKE hrci_file.hrci08, 
                  hrci09 LIKE hrci_file.hrci09, 
                  hrci10 LIKE hrci_file.hrci10, 
                  hrci11 LIKE hrci_file.hrci11, 
                  hrciconf LIKE hrci_file.hrciconf 
               END RECORD,
    g_hrci_ins     RECORD LIKE hrci_file.*,
    g_success      LIKE type_file.chr1,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_flag          LIKE type_file.chr1
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_cnt2        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5 
#DEFINE g_hrci01      LIKE hrci_file.hrci01

MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
  
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i049_w AT p_row,p_col WITH FORM "ghr/42f/ghri049"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init() 
    CALL cl_set_comp_visible("hrci01",FALSE) 
    CALL i049_menu()
    CLOSE WINDOW i049_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i049_menu()
 
   WHILE TRUE
      CALL i049_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i049_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i049_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "confirm"
             IF cl_chk_act_auth() THEN
           	    CALL i049_confirm('Y')
             END IF

         WHEN "unconfirm"
             IF cl_chk_act_auth() THEN
           	    CALL i049_confirm('N')
             END IF
             	         
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
             	CALL i049_sel_all()
             END IF
          
         WHEN "nosel_all"
             IF cl_chk_act_auth() THEN
             	CALL i049_nosel_all()
             END IF             
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i049_q()
   CALL i049_b_askkey()
END FUNCTION	
	
FUNCTION i049_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_c             LIKE type_file.num5,
    l_hrag07        LIKE hrag_file.hrag07
    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
     
    LET g_sql="SELECT '',hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf",
               "  FROM hrci_file WHERE hrci01=? AND hrci02 = ? AND hrci03 = ? FOR UPDATE"
    LET g_sql = cl_forupdate
    
    PREPARE g_forupd_sql FROM g_sql
    DECLARE i049_bcl CURSOR FOR g_forupd_sql      
 
    INPUT ARRAY g_hrci WITHOUT DEFAULTS FROM s_hrci.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF	
       
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            
        LET l_n  = ARR_COUNT()
        BEGIN WORK
        IF g_rec_b>=l_ac THEN 
           LET p_cmd='u'                                        
           LET g_hrci_t.* = g_hrci[l_ac].*           
           OPEN i049_bcl USING g_hrci_t.hrci01          
           IF STATUS THEN
              CALL cl_err("OPEN i049_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i049_bcl INTO g_hrci[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrci_t.hrci01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF 
              
              IF cl_null(g_hrci[l_ac].sure) THEN LET g_hrci[l_ac].sure = 'Y' END IF
              SELECT hrao02 INTO g_hrci[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrci[l_ac].hrat04        
              SELECT hrap06 INTO g_hrci[l_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrci[l_ac].hrat05 AND hrap01 = g_hrci[l_ac].hrat04
              DISPLAY BY NAME g_hrci[l_ac].hrao02,g_hrci[l_ac].hras04
  
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF  
  
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrci[l_ac].* = g_hrci_t.*
         CLOSE i049_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrci[l_ac].hrci02,-163,0)
          LET g_hrci[l_ac].* = g_hrci_t.*
       ELSE 
           
          UPDATE hrci_file SET hrci01=g_hrci[l_ac].hrci01,
                               hrci02=g_hrci[l_ac].hrci02,
                               hrci03=g_hrci[l_ac].hrci03,
                               hrci04=g_hrci[l_ac].hrci04,
                               hrci05=g_hrci[l_ac].hrci05,
                               hrci06=g_hrci[l_ac].hrci06,
                               hrci07=g_hrci[l_ac].hrci07,
                               hrciacti=g_hrci[l_ac].hrciacti,
                               hrciuser=g_user,      
                               hrcimodu=g_user,
                               hrcidate=g_today,
                               hrcioriu=g_user,
                               hrciorig=g_grup
                WHERE hrci01 = g_hrci_t.hrci01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrci_file",g_hrci_t.hrci01,g_hrci_t.hrci02,SQLCA.sqlcode,"","",1)
             ROLLBACK WORK    #FUN-680010
             LET g_hrci[l_ac].* = g_hrci_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrci[l_ac].* = g_hrci_t.*
          END IF
          CLOSE i049_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i049_bcl                
        COMMIT WORK  
   
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
 
    CLOSE i049_bcl
    COMMIT WORK  
END FUNCTION      	     		
	
FUNCTION i049_b_askkey()
    CLEAR FORM
    CALL g_hrci.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf             
         FROM s_hrci[1].hrci01,s_hrci[1].hrat01,s_hrci[1].hrat02,s_hrci[1].hrat04,s_hrci[1].hrao02,s_hrci[1].hrat05,s_hrci[1].hras04,s_hrci[1].hrci03,s_hrci[1].hrci04,s_hrci[1].hrci05,s_hrci[1].hrci06,s_hrci[1].hrci07,s_hrci[1].hrci08,s_hrci[1].hrci09,s_hrci[1].hrci10,s_hrci[1].hrci11,s_hrci[1].hrciconf
         
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 

              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
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

         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save() 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrciuser', 'hrcigrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF 
 
    CALL i049_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i049_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT '',hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf ",
                   " FROM hrci_file,hrat_file ",
                   " WHERE hrci02 = hratid AND ", p_wc2 CLIPPED, 
                   " ORDER BY hrat01,hrci03" 
 
    PREPARE i049_pb FROM g_sql
    DECLARE hrci_curs CURSOR FOR i049_pb
 
    CALL g_hrci.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrci_curs INTO g_hrci[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
      
        LET g_hrci[g_cnt].sure = 'Y'
        SELECT hrao02 INTO g_hrci[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrci[g_cnt].hrat04        
        SELECT hrap06 INTO g_hrci[g_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrci[g_cnt].hrat05 AND hrap01 = g_hrci[g_cnt].hrat04       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrci.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i049_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrci TO s_hrci.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
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
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY      
         
      ON ACTION sel_all
         LET g_action_choice="sel_all"
         EXIT DISPLAY
      
     ON ACTION cancle_sel_all
         LET g_action_choice="nosel_all"
         EXIT DISPLAY    
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	 
	
FUNCTION i049_sel_all() 
  DEFINE  l_i     LIKE type_file.num5

  FOR l_i = 1 TO g_rec_b
    LET g_hrci[l_i].sure = 'Y'
    DISPLAY BY NAME g_hrci[l_i].sure
  END FOR
 
  CALL g_hrci.deleteElement(l_i)
   
  CALL ui.Interface.refresh()

END FUNCTION	
	
FUNCTION i049_nosel_all() 
  DEFINE  l_i     LIKE type_file.num5

  FOR l_i = 1 TO g_rec_b
    IF g_hrci[l_i].sure = 'Y' THEN
       LET g_hrci[l_i].sure = 'N'
    ELSE
    	 LET g_hrci[l_i].sure = 'Y'
    END IF	   
    DISPLAY BY NAME g_hrci[l_i].sure
  END FOR
 
  CALL g_hrci.deleteElement(l_i)
   
  CALL ui.Interface.refresh()

END FUNCTION	
		 
FUNCTION i049_confirm(p_cmd)	
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5
 
  IF g_rec_b = 0 OR cl_null(g_rec_b) THEN
  	 RETURN
  END IF 	 
  FOR l_i = 1 TO g_rec_b
     IF g_hrci[l_i].sure = 'Y' THEN   
        UPDATE hrci_file SET hrciconf = p_cmd WHERE hrci01 = g_hrci[l_i].hrci01
        DISPLAY BY NAME g_hrci[l_i].hrciconf 
  END FOR
END FUNCTION 