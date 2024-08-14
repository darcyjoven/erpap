# Prog. Version..: '5.30.03-12.09.18(00008)'     #
#
# Pattern name...: ghrq006.4gl
# Descriptions...: ??????????
# Date & Author..: 13/04/07 By yangjian 

DATABASE ds
  
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1,g_hrat01   LIKE hrat_file.hrat01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott,g_sel_b          LIKE type_file.num5,          
    g_hrat           DYNAMIC ARRAY OF RECORD 
      sel            LIKE hrat_file.hratconf,
      hrat03         LIKE hrat_file.hrat03,
      hrat03_name    LIKE type_file.chr100,
      hrat94         LIKE hrat_file.hrat94,  #zhong xin 
      hrat94_name    LIKE type_file.chr100,
      hrat04         LIKE hrat_file.hrat04,
      hrat04_name    LIKE type_file.chr100,
      hrat87         LIKE hrat_file.hrat87,  #ke
      hrat87_name    LIKE type_file.chr100,
      hrat88         LIKE hrat_file.hrat88,  #zu
      hrat88_name    LIKE type_file.chr100,
      hrat01         LIKE hrat_file.hrat01,
      hrat02         LIKE hrat_file.hrat02,
      hrat95         LIKE hrat_file.hrat95,   #yuan gong hao
      hrat08         LIKE hrat_file.hrat08,
      hrat05         LIKE hrat_file.hrat05,
      hrat05_name    LIKE type_file.chr100,
      hrag07         LIKE hrag_file.hrag07,
      hrar04         LIKE hrar_file.hrar04,
      hrar06         LIKE hrar_file.hrar06,
      hrat17         LIKE hrat_file.hrat17,
      hrat17_name    LIKE type_file.chr100,
      hrat22         LIKE hrat_file.hrat22,
      hrat22_name    LIKE type_file.chr100,
      hrat24         LIKE hrat_file.hrat24,
      hrat24_name    LIKE type_file.chr100,
      hrat10         LIKE hrat_file.hrat10,
      hrat12         LIKE hrat_file.hrat12,
      hrat12_name    LIKE type_file.chr100,
      hrat13         LIKE hrat_file.hrat13,
      hrat15         LIKE hrat_file.hrat15,              
      hrat16         LIKE hrat_file.hrat16,
      hrat25         LIKE hrat_file.hrat25,
      hrat66         LIKE hrat_file.hrat66,
      hrat96         LIKE hrat_file.hrat96,  #yong gong shu xing      
      hrat96_name    LIKE type_file.chr100,
      hrat19         LIKE hrat_file.hrat19,
      hrat19_name    LIKE type_file.chr100,
      hrat20         LIKE hrat_file.hrat20,
      hrat20_name    LIKE type_file.chr100,
      hrat21         LIKE hrat_file.hrat21,
      hrat21_name    LIKE type_file.chr100,
      hrat06         LIKE hrat_file.hrat06,
      hrat06_name    LIKE type_file.chr100,              
      hrat26         LIKE hrat_file.hrat26,
      hrat27         LIKE hrat_file.hrat27,
      hrat77         LIKE hrat_file.hrat77,              
      hrat46         LIKE hrat_file.hrat46,
      hrat76         LIKE hrat_file.hrat76,              
      hrat18         LIKE hrat_file.hrat18,
      hrat45         LIKE hrat_file.hrat45,
      hrat41         LIKE hrat_file.hrat41,
      hrat41_name    LIKE type_file.chr100, 
      hrat40         LIKE hrat_file.hrat40,
      hrat40_name    LIKE type_file.chr100,
      hrat68         LIKE hrat_file.hrat68,
      hrat28         LIKE hrat_file.hrat28,
      hrat28_name    LIKE type_file.chr100,
      hrat29         LIKE hrat_file.hrat29, 
      hrat29_name    LIKE type_file.chr100,
      hrat23         LIKE hrat_file.hrat23,
      hrat42         LIKE hrat_file.hrat42,
      hrat42_name    LIKE type_file.chr100,
      hrat67         LIKE hrat_file.hrat67,
      hrat67_name    LIKE type_file.chr100,
      hraqa02        LIKE hraqa_file.hraqa02,
      hrat64         LIKE hrat_file.hrat64,
      hrat64_name    LIKE type_file.chr100,
      hrat74         LIKE hrat_file.hrat74,
      hrat07         LIKE hrat_file.hrat07,
      hrat09         LIKE hrat_file.hrat09,
      hrat11         LIKE hrat_file.hrat11,
      hrat49         LIKE hrat_file.hrat49, 
      hrat50         LIKE hrat_file.hrat50,
      hrat47         LIKE hrat_file.hrat47,
      hrat48         LIKE hrat_file.hrat48,
      hrat51         LIKE hrat_file.hrat51,
      hrat43         LIKE hrat_file.hrat43,
      hrat43_name    LIKE type_file.chr100,
      hrat44         LIKE hrat_file.hrat44,
      hrat75         LIKE hrat_file.hrat75,
      hrat73         LIKE hrat_file.hrat73,
      hrat36         LIKE hrat_file.hrat36,
      hrat38         LIKE hrat_file.hrat38,
      hrat37         LIKE hrat_file.hrat37,
      hrat34         LIKE hrat_file.hrat34,
      hrat34_name    LIKE type_file.chr100,
      hratconf       LIKE hrat_file.hratconf,
      hrbf08         LIKE hrbf_file.hrbf08,  
      hrbf09         LIKE hrbf_file.hrbf09,
      hrbf08_1       LIKE hrbf_file.hrbf08,  
      hrbf09_1       LIKE hrbf_file.hrbf09                                 
                     END RECORD,
    g_hrat_t         DYNAMIC ARRAY OF RECORD 
      sel            LIKE hrat_file.hratconf,
      hrat03         LIKE hrat_file.hrat03,
      hrat03_name    LIKE type_file.chr100,
      hrat94         LIKE hrat_file.hrat94,  #zhong xin 
      hrat94_name    LIKE type_file.chr100,
      hrat04         LIKE hrat_file.hrat04,
      hrat04_name    LIKE type_file.chr100,
      hrat87         LIKE hrat_file.hrat87,  #ke
      hrat87_name    LIKE type_file.chr100,
      hrat88         LIKE hrat_file.hrat88,  #zu
      hrat88_name    LIKE type_file.chr100,
      hrat01         LIKE hrat_file.hrat01,
      hrat02         LIKE hrat_file.hrat02,
      hrat95         LIKE hrat_file.hrat95,   #yuan gong hao
      hrat08         LIKE hrat_file.hrat08,
      hrat05         LIKE hrat_file.hrat05,
      hrat05_name    LIKE type_file.chr100,
      hrag07         LIKE hrag_file.hrag07,
      hrar04         LIKE hrar_file.hrar04,
      hrar06         LIKE hrar_file.hrar06,
      hrat17         LIKE hrat_file.hrat17,
      hrat17_name    LIKE type_file.chr100,
      hrat22         LIKE hrat_file.hrat22,
      hrat22_name    LIKE type_file.chr100,
      hrat24         LIKE hrat_file.hrat24,
      hrat24_name    LIKE type_file.chr100,
      hrat10         LIKE hrat_file.hrat10,
      hrat12         LIKE hrat_file.hrat12,
      hrat12_name    LIKE type_file.chr100,
      hrat13         LIKE hrat_file.hrat13,
      hrat15         LIKE hrat_file.hrat15,              
      hrat16         LIKE hrat_file.hrat16,
      hrat25         LIKE hrat_file.hrat25,
      hrat66         LIKE hrat_file.hrat66,
      hrat96         LIKE hrat_file.hrat96,  #yong gong shu xing      
      hrat96_name    LIKE type_file.chr100,
      hrat19         LIKE hrat_file.hrat19,
      hrat19_name    LIKE type_file.chr100,
      hrat20         LIKE hrat_file.hrat20,
      hrat20_name    LIKE type_file.chr100,
      hrat21         LIKE hrat_file.hrat21,
      hrat21_name    LIKE type_file.chr100,
      hrat06         LIKE hrat_file.hrat06,
      hrat06_name    LIKE type_file.chr100,              
      hrat26         LIKE hrat_file.hrat26,
      hrat27         LIKE hrat_file.hrat27,
      hrat77         LIKE hrat_file.hrat77,              
      hrat46         LIKE hrat_file.hrat46,
      hrat76         LIKE hrat_file.hrat76,              
      hrat18         LIKE hrat_file.hrat18,
      hrat45         LIKE hrat_file.hrat45,
      hrat41         LIKE hrat_file.hrat41,
      hrat41_name    LIKE type_file.chr100, 
      hrat40         LIKE hrat_file.hrat40,
      hrat40_name    LIKE type_file.chr100,
      hrat68         LIKE hrat_file.hrat68,
      hrat28         LIKE hrat_file.hrat28,
      hrat28_name    LIKE type_file.chr100,
      hrat29         LIKE hrat_file.hrat29, 
      hrat29_name    LIKE type_file.chr100,
      hrat23         LIKE hrat_file.hrat23,
      hrat42         LIKE hrat_file.hrat42,
      hrat42_name    LIKE type_file.chr100,
      hrat67         LIKE hrat_file.hrat67,
      hrat67_name    LIKE type_file.chr100,
      hraqa02        LIKE hraqa_file.hraqa02,
      hrat64         LIKE hrat_file.hrat64,
      hrat64_name    LIKE type_file.chr100,
      hrat74         LIKE hrat_file.hrat74,
      hrat07         LIKE hrat_file.hrat07,
      hrat09         LIKE hrat_file.hrat09,
      hrat11         LIKE hrat_file.hrat11,
      hrat49         LIKE hrat_file.hrat49, 
      hrat50         LIKE hrat_file.hrat50,
      hrat47         LIKE hrat_file.hrat47,
      hrat48         LIKE hrat_file.hrat48,
      hrat51         LIKE hrat_file.hrat51,
      hrat43         LIKE hrat_file.hrat43,
      hrat43_name    LIKE type_file.chr100,
      hrat44         LIKE hrat_file.hrat44,
      hrat75         LIKE hrat_file.hrat75,
      hrat73         LIKE hrat_file.hrat73,
      hrat36         LIKE hrat_file.hrat36,
      hrat38         LIKE hrat_file.hrat38,
      hrat37         LIKE hrat_file.hrat37,
      hrat34         LIKE hrat_file.hrat34,
      hrat34_name    LIKE type_file.chr100,
      hratconf       LIKE hrat_file.hratconf,
      hrbf08         LIKE hrbf_file.hrbf08,  
      hrbf09         LIKE hrbf_file.hrbf09,
      hrbf08_1       LIKE hrbf_file.hrbf08,  
      hrbf09_1       LIKE hrbf_file.hrbf09                            
                     END RECORD,
    g_hrat1          RECORD 
      hrat20a         LIKE hrat_file.hrat20,
      hrat20a_name    LIKE type_file.chr100,
      hrat22a         LIKE hrat_file.hrat22,
      hrat22a_name    LIKE type_file.chr100,
      hrat15a         LIKE hrat_file.hrat15,
      hrat21a         LIKE hrat_file.hrat21,
      hrat21a_name    LIKE type_file.chr100,
      hrat17a         LIKE hrat_file.hrat17,   
      hrat17a_name    LIKE type_file.chr100,           
      hrat25a         LIKE hrat_file.hrat25
                     END RECORD,         
    g_hrag          RECORD LIKE hrag_file.*,                                                                                                      
    g_rec_b         LIKE type_file.num5,  
    g_rec_b1         LIKE type_file.num5,             
    l_ac            LIKE type_file.num5,               
    g_ac            LIKE type_file.num5,
    l_sl,p_row,p_col            LIKE type_file.num5,
    i,j,k           LIKE type_file.num5  

DEFINE g_forupd_sql      STRING                       
DEFINE   g_chr           LIKE type_file.chr1          
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000       
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10         
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   l_tree_ac_t     LIKE type_file.num5
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000, 
          des            LIKE type_file.chr1000,                
          img            LIKE type_file.chr1000,                
          pid            LIKE type_file.num10,
          id             LIKE type_file.num10,
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),       #Group ,Company,Department,Job
          emp            LIKE type_file.num5
          END RECORD
DEFINE    g_id           LIKE type_file.num10
DEFINE    g_level        LIKE type_file.num5
DEFINE g_curr_idx       INTEGER 
DEFINE    g_cnt1         LIKE type_file.num10,
          g_before_input_done   LIKE type_file.num5
DEFINE   g_sum           LIKE type_file.num10
DEFINE   g_jump1         LIKE type_file.num10
DEFINE   g_jump2         LIKE type_file.num10
DEFINE   g_turn          LIKE type_file.num10
DEFINE   g_turn_t        LIKE type_file.num10
DEFINE   g_record        LIKE type_file.num10
DEFINE   g_i    LIKE type_file.num5 
DEFINE   g_j    LIKE type_file.num5 
DEFINE   l_name      STRING
DEFINE   l_items     STRING
DEFINE 
     g_hray         DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,      
        hrat01      LIKE hrat_file.hrat01,    
        hrat02      LIKE hrat_file.hrat02,    
        hraa12      LIKE hraa_file.hraa12,    
        hrao02      LIKE hrao_file.hrao02,    
        hras04      LIKE hras_file.hras04,    
        hrat25      LIKE hrat_file.hrat25,    
        hrat02_1    LIKE hrat_file.hrat02,    
        hrat26      LIKE hrat_file.hrat26,    
        hrat19      LIKE hrad_file.hrad03     
                    END RECORD,
    g_hray_t        DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       
        hrat01      LIKE hrat_file.hrat01,     
        hrat02      LIKE hrat_file.hrat02,     
        hraa12      LIKE hraa_file.hraa12,     
        hrao02      LIKE hrao_file.hrao02,     
        hras04      LIKE hras_file.hras04,     
        hrat25      LIKE hrat_file.hrat25,     
        hrat02_1    LIKE hrat_file.hrat02,     
        hrat26      LIKE hrat_file.hrat26,     
        hrat19      LIKE hrad_file.hrad03      
                    END RECORD,
        b_hray          RECORD LIKE hray_file.*,   
    g_hratid        DYNAMIC ARRAY OF LIKE hrat_file.hratid,   
    g_hratid_t      DYNAMIC ARRAY OF LIKE hrat_file.hratid    


DEFINE g_hraz_h       RECORD
           hraz01     LIKE hraz_file.hraz01,    
           hraz04     LIKE hraz_file.hraz04,
           hraz19     LIKE hraz_file.hraz19,
           hraz05     LIKE hraz_file.hraz05,
           hraz31     LIKE hraz_file.hraz31,
           hraz08     LIKE hraz_file.hraz08,
           hrazud02   LIKE hraz_file.hrazud02,
           hrazud03   LIKE hraz_file.hrazud03,
           hraz10     LIKE hraz_file.hraz10,
           hraz41     LIKE hraz_file.hraz41,
           hraz12     LIKE hraz_file.hraz14,
           hraz14     LIKE hraz_file.hraz14,
           hraz16     LIKE hraz_file.hraz16,
           hraz34     LIKE hraz_file.hraz34,
           hrazud06   LIKE hraz_file.hrazud06,
           hraz39     LIKE hraz_file.hraz39,
           hraz37     LIKE hraz_file.hraz37,
           hraz17     LIKE hraz_file.hraz17,
           hraz18     LIKE hraz_file.hraz18,
           hraz23     LIKE hraz_file.hraz23,
           hraz24     LIKE hraz_file.hraz24,
           hraz27     LIKE hraz_file.hraz27,
           hraz28     LIKE hraz_file.hraz28,
           hraz25     LIKE hraz_file.hraz25,
           hraz26     LIKE hraz_file.hraz26,
           hraz44     LIKE hraz_file.hraz44,
           hrazud01   LIKE hraz_file.hrazud01,
           hrazuser   LIKE hraz_file.hrazuser,
           hrazgrup   LIKE hraz_file.hrazgrup,
           hrazmodu   LIKE hraz_file.hrazmodu,
           hrazdate   LIKE hraz_file.hrazdate,
           hrazoriu   LIKE hraz_file.hrazoriu,
           hrazorig   LIKE hraz_file.hrazorig
           END RECORD, 
           
       g_hraz_h_t     RECORD
           hraz01     LIKE hraz_file.hraz01,    
           hraz04     LIKE hraz_file.hraz04,
           hraz19     LIKE hraz_file.hraz19,
           hraz05     LIKE hraz_file.hraz05,
           hraz31     LIKE hraz_file.hraz31,
           hraz08     LIKE hraz_file.hraz08,
           hrazud02   LIKE hraz_file.hrazud02,
           hrazud03   LIKE hraz_file.hrazud03,
           hraz10     LIKE hraz_file.hraz10,
           hraz41     LIKE hraz_file.hraz41,
           hraz12     LIKE hraz_file.hraz14,
           hraz14     LIKE hraz_file.hraz14,
           hraz16     LIKE hraz_file.hraz16,
           hraz34     LIKE hraz_file.hraz34,
           hrazud06   LIKE hraz_file.hrazud06,
           hraz39     LIKE hraz_file.hraz39,
           hraz37     LIKE hraz_file.hraz37,
           hraz17     LIKE hraz_file.hraz17,
           hraz18     LIKE hraz_file.hraz18,
           hraz23     LIKE hraz_file.hraz23,
           hraz24     LIKE hraz_file.hraz24,
           hraz27     LIKE hraz_file.hraz27,
           hraz28     LIKE hraz_file.hraz28,
           hraz25     LIKE hraz_file.hraz25,
           hraz26     LIKE hraz_file.hraz26,
           hraz44     LIKE hraz_file.hraz44,
           hrazud01   LIKE hraz_file.hrazud01,
           hrazuser   LIKE hraz_file.hrazuser,
           hrazgrup   LIKE hraz_file.hrazgrup,
           hrazmodu   LIKE hraz_file.hrazmodu,
           hrazdate   LIKE hraz_file.hrazdate,
           hrazoriu   LIKE hraz_file.hrazoriu,
           hrazorig   LIKE hraz_file.hrazorig           
                      END RECORD,
       g_hraz         DYNAMIC ARRAY OF RECORD 
           hraz43          LIKE hraz_file.hraz43,    
           hraz32          LIKE hraz_file.hraz32,    
           hrat02          LIKE hrat_file.hrat02,    
           hraz30          LIKE hraz_file.hraz30,    
           hraz30_desc     LIKE hraa_file.hraa12,    
           hraz07          LIKE hraz_file.hraz07,    
           hraz07_desc     LIKE hrao_file.hrao02,
           hrazud04        LIKE hraz_file.hrazud04,
           hrazud04_desc   LIKE hrao_file.hrao02,
           hrazud05        LIKE hraz_file.hrazud05,
           hrazud05_desc   LIKE hrao_file.hrao02, 
           hrazud07        LIKE hraz_file.hrazud07,
           hrazud07_desc   LIKE hrag_file.hrag07,       
           hraz09          LIKE hraz_file.hraz09,    
           hraz09_desc     LIKE hras_file.hras04,    
           hraz40          LIKE hraz_file.hraz40,    
           hraz33          LIKE hraz_file.hraz33,    
           hraz33_desc     LIKE hrat_file.hrat02,    
           hraz13          LIKE hraz_file.hraz13,
           hraz13_desc     LIKE hraf_file.hraf02,
           hraz15          LIKE hraz_file.hraz15,
           hraz11          LIKE hraz_file.hraz11,
           hraz11_desc     LIKE hrai_file.hrai04,
           hraz38          LIKE hraz_file.hraz38    
                      END RECORD,
                      
       g_hraz_t       RECORD
           hraz43          LIKE hraz_file.hraz43,    
           hraz32          LIKE hraz_file.hraz32,    
           hrat02          LIKE hrat_file.hrat02,    
           hraz30          LIKE hraz_file.hraz30,    
           hraz30_desc     LIKE hraa_file.hraa12,    
           hraz07          LIKE hraz_file.hraz07,    
           hraz07_desc     LIKE hrao_file.hrao02,
           hrazud04        LIKE hraz_file.hrazud04,
           hrazud04_desc   LIKE hrao_file.hrao02,
           hrazud05        LIKE hraz_file.hrazud05,
           hrazud05_desc   LIKE hrao_file.hrao02,   
           hrazud07        LIKE hraz_file.hrazud07,
           hrazud07_desc   LIKE hrag_file.hrag07,    
           hraz09          LIKE hraz_file.hraz09,    
           hraz09_desc     LIKE hras_file.hras04,    
           hraz40          LIKE hraz_file.hraz40,    
           hraz33          LIKE hraz_file.hraz33,    
           hraz33_desc     LIKE hrat_file.hrat02,    
           hraz13          LIKE hraz_file.hraz13,
           hraz13_desc     LIKE hraf_file.hraf02,
           hraz15          LIKE hraz_file.hraz15,
           hraz11          LIKE hraz_file.hraz11,
           hraz11_desc     LIKE hrai_file.hrai04,
           hraz38          LIKE hraz_file.hraz38                     
                     END RECORD        
DEFINE  g_hrbh    RECORD      LIKE hrbh_file.*
DEFINE  g_hrbh_t  RECORD      LIKE hrbh_file.*
DEFINE g_hrbj                RECORD LIKE hrbj_file.*
DEFINE g_hrbj_t              RECORD LIKE hrbj_file.*

        
MAIN
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    
    LET p_row = 4 LET p_col = 2  LET g_i = NULL 
    OPEN WINDOW q006_w AT p_row,p_col WITH FORM "ghr/42f/ghrq006"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    
    #add by nihuan 20161228
    CALL cl_set_comp_visible("sel",FALSE)
    CALL cl_set_combo_items("hrat03",NULL,NULL)
    CALL q006_get_items('03') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat03",l_name,l_items)
    
    CALL cl_set_combo_items("hrat17",NULL,NULL)
    CALL q006_get_items('17') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat17",l_name,l_items)
    
    CALL cl_set_combo_items("hrat24",NULL,NULL)
    CALL q006_get_items('24') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat24",l_name,l_items)
    
    CALL cl_set_combo_items("hrat12",NULL,NULL)
    CALL q006_get_items('12') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat12",l_name,l_items)
    
    CALL cl_set_combo_items("hrat19",NULL,NULL)
    CALL q006_get_items('19') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat19",l_name,l_items)
    
    CALL cl_set_combo_items("hrat20",NULL,NULL)
    CALL q006_get_items('20') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrat20",l_name,l_items)
    
    LET g_forupd_sql = "SELECT hratid ", 
                       "  FROM hrat_file WHERE hratid=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q006_zz_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    CALL q006_ui_init()
    CALL  q006_menu()
    CLOSE WINDOW q006_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q006_ui_init()

   #CALL cl_set_comp_visible("name",FALSE)

END FUNCTION 

FUNCTION q006_menu()
	DEFINE n    STRING      
	
   #MOD-C40062 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #MOD-C40062 end add-----

   CALL q006_tree_fill()
   
   WHILE TRUE
   	IF g_i = 1  THEN 
  #    CALL q006_tz()  #add by yeap NO.130707 
      LET g_action_choice = "exit"
    ELSE 
    	CALL q006_bp("G") 
    	 
    END IF 
 
      CASE g_action_choice
         WHEN "detail"
         	  IF cl_chk_act_auth() THEN
              CALL q006_b()
            END IF
         WHEN "q006_dq"
         	  IF cl_chk_act_auth() THEN
              CALL q006_dq()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
              CALL q006_q()
            END IF 
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat),'','')
               #MOD-C40062 str add------
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               LET page = f.FindNode("Page","page1")
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrat),'','')
               #MOD-C40062 end add-----
            END IF                     
         WHEN "ks"
            IF cl_chk_act_auth() THEN 
               CALL q006_ks()
            END IF 
         WHEN "ghri006"
            IF cl_chk_act_auth() THEN 
               CALL q006_ghri006()
            END IF        
         WHEN "nextpage"
            IF cl_chk_act_auth() THEN
            	 CALL q006_b_fill(g_wc2,101)
            END IF 
         WHEN "fi"
            IF cl_chk_act_auth() THEN
            	LET g_jump1 = 1 
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	LET g_cnt = 0           	
             CALL q006_b_fill(g_wc2,g_cnt)
            END IF            	 
         WHEN "pr"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 > 1 THEN 
            	   LET g_jump1 = g_jump1 - 1
            	ELSE 
            	 	 LET g_jump1 = 1
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn           	          	
              CALL q006_b_fill(g_wc2,g_cnt)
            END IF 
         WHEN "ne"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 < g_jump2 THEN 
            	   LET g_jump1 = g_jump1 + 1
            	ELSE
            		 LET g_jump1 = g_jump2
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn            	
              CALL q006_b_fill(g_wc2,g_cnt)
            END IF 
         WHEN "la"
            IF cl_chk_act_auth() THEN
                  DISPLAY g_jump2 TO FORMONLY.jump1
                      LET g_jump1 = g_jump2
                      LET g_cnt = g_turn * (g_jump2-1)             	
              CALL q006_b_fill(g_wc2,g_cnt)
            END IF  
         WHEN "shaixuan"
            IF cl_chk_act_auth() THEN
            	CALL q006_tz()
            END IF 
      END CASE
   END WHILE 
END FUNCTION
	
FUNCTION q006_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
   DEFINE   p_cmd           LIKE type_file.chr1
 	 DEFINE   l_j        LIKE type_file.num10
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
   	
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
   
      DISPLAY ARRAY g_tree TO s_tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
             
         BEFORE ROW
            LET l_tree_ac = ARR_CURR()  
            LET g_curr_idx = ARR_CURR()
            IF l_tree_ac > 0  AND l_tree_ac !=l_tree_ac_t THEN 
            	 CALL q006_tree_b_fill(l_tree_ac)
            END IF 
            LET l_tree_ac_t = l_tree_ac
          # marked  NO.130709 yeap
          #  IF NOT cl_null(g_i) THEN 
          #     CALL q006_tz()
          #  END IF 
            	
            
                     
      END DISPLAY 
         
            
      DISPLAY ARRAY g_hrat TO s_hrat.*  ATTRIBUTE(COUNT=g_sum)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            
            
     
      END DISPLAY 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                        
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   

      ON ACTION fi         #130703
         LET g_action_choice="fi"
         EXIT DIALOG   

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG


      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
         
      ON ACTION q006_dq
         LET g_action_choice="q006_dq"
         EXIT DIALOG 

      ON ACTION pr
         LET g_action_choice="pr"
         EXIT DIALOG   

      ON ACTION ne
         LET g_action_choice="ne"
         EXIT DIALOG   

      ON ACTION la
         LET g_action_choice="la"
         EXIT DIALOG   

      ON ACTION shaixuan   #modified  NO.130709 yeap
         IF g_j = 1 THEN 
            CALL cl_err('',"ghr-126",0)
            LET g_j = 0
         ELSE 
         	  LET g_action_choice="shaixuan"
         END IF 
         EXIT DIALOG
         
      ON ACTION ks
         LET g_action_choice="ks"
         EXIT DIALOG
         
      ON ACTION ghri006
         LET g_action_choice="ghri006"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
     #ON ACTION accept
     #   LET INT_FLAG=FALSE 		
     #   LET g_action_choice="exit"
     #   EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION	

FUNCTION q006_q()

   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )                                                                        
  # CALL cl_set_comp_entry("hrat01,hrat02,hrat03,hrat04",FALSE)                                 
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrat.clear()
   DISPLAY '' TO FORMONLY.cnt1
   CALL q006_b_askkey()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET  g_j = 1 
      RETURN
   ELSE 
   	  LET g_j = 0 
   END IF
  
   CALL cl_replace_str(g_wc2,"hrat20a","hrat20") RETURNING g_wc2
   CALL cl_replace_str(g_wc2,"hrat22a","hrat22") RETURNING g_wc2
   CALL cl_replace_str(g_wc2,"hrat15a","hrat15") RETURNING g_wc2
   CALL cl_replace_str(g_wc2,"hrat21a","hrat21") RETURNING g_wc2
   CALL cl_replace_str(g_wc2,"hrat17a","hrat17") RETURNING g_wc2
   CALL cl_replace_str(g_wc2,"hrat25a","hrat25") RETURNING g_wc2
    LET g_cnt = 1
   CALL q006_b_fill(g_wc2,'')
END FUNCTION   
   	
   	
FUNCTION q006_b_askkey()
 DEFINE l_wc            STRING  #160818 add by zhangtn

    CLEAR FORM      
    CALL g_hrat.clear()

    #add by zhangbo130902---begin
    DISPLAY ARRAY g_tree TO s_tree.*
    BEFORE DISPLAY
      EXIT DISPLAY
    END DISPLAY
    #add by zhangbo130902---end 
    CONSTRUCT g_wc2 ON hrat20a,hrat22a,hrat15a,hrat21a,hrat17a,hrat25a,
                       hrat01,hrat02,hrat03,hrat04,
                       hrat08,hrat05,hrag07,hrar04,
                       hrar06,hrat17,hrat22,hrat24,
                       hrat10,hrat12,hrat13,hrat15,
                       hrat16,hrat25,hrat66,hrat19,
                       hrat20,hrat21,hrat06,hrat26,
                       hrat27,hrat46,hrat76,hrat18,
                       hrat45,hrat41,hrat40,hrat68,
                       hrat28,hrat29,hrat23,hrat42,
                       hrat67,hrat64,hrat74,hrat07,
                       hrat09,hrat11,hrat49,hrat50,
                       hrat47,hrat48,hrat51,hrat43,
                       hrat44,hrat75,hrat73,hrat36,
                       hrat38,hrat37,hrat34,hratconf #,hrbf08,hrbf09,hrbf08_1
         FROM hrat20a,hrat22a,hrat15a,hrat21a,hrat17a,hrat25a,
                       s_hrat[1].hrat01,s_hrat[1].hrat02,s_hrat[1].hrat03,s_hrat[1].hrat04,
                       s_hrat[1].hrat08,s_hrat[1].hrat05,s_hrat[1].hrag07,s_hrat[1].hrar04,
                       s_hrat[1].hrar06,s_hrat[1].hrat17,s_hrat[1].hrat22,s_hrat[1].hrat24,
                       s_hrat[1].hrat10,s_hrat[1].hrat12,s_hrat[1].hrat13,s_hrat[1].hrat15,
                       s_hrat[1].hrat16,s_hrat[1].hrat25,s_hrat[1].hrat66,s_hrat[1].hrat19,
                       s_hrat[1].hrat20,s_hrat[1].hrat21,s_hrat[1].hrat06,s_hrat[1].hrat26,
                       s_hrat[1].hrat27,s_hrat[1].hrat46,s_hrat[1].hrat76,s_hrat[1].hrat18,
                       s_hrat[1].hrat45,s_hrat[1].hrat41,s_hrat[1].hrat40,s_hrat[1].hrat68,
                       s_hrat[1].hrat28,s_hrat[1].hrat29,s_hrat[1].hrat23,s_hrat[1].hrat42,
                       s_hrat[1].hrat67,s_hrat[1].hrat64,s_hrat[1].hrat74,s_hrat[1].hrat07,
                       s_hrat[1].hrat09,s_hrat[1].hrat11,s_hrat[1].hrat49,s_hrat[1].hrat50,
                       s_hrat[1].hrat47,s_hrat[1].hrat48,s_hrat[1].hrat51,s_hrat[1].hrat43,
                       s_hrat[1].hrat44,s_hrat[1].hrat75,s_hrat[1].hrat73,s_hrat[1].hrat36,
                       s_hrat[1].hrat38,s_hrat[1].hrat37,s_hrat[1].hrat34,s_hrat[1].hratconf

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      AFTER FIELD hrat20a
         LET g_hrat1.hrat20a = GET_FLDBUF(hrat20a)
         CALL s_code('313',g_hrat1.hrat20a) RETURNING g_hrag.*
         DISPLAY g_hrag.hrag07 TO hrat20a_name
         
      AFTER FIELD hrat22a
         LET g_hrat1.hrat22a = GET_FLDBUF(hrat22a)
         CALL s_code('317',g_hrat1.hrat22a) RETURNING g_hrag.*
         DISPLAY g_hrag.hrag07 TO hrat22a_name         

      AFTER FIELD hrat21a
         LET g_hrat1.hrat21a = GET_FLDBUF(hrat21a)
         CALL s_code('337',g_hrat1.hrat21a) RETURNING g_hrag.*
         DISPLAY g_hrag.hrag07 TO hrat21a_name
         
      AFTER FIELD hrat17a
         LET g_hrat1.hrat17a = GET_FLDBUF(hrat17a)
         CALL s_code('333',g_hrat1.hrat17a) RETURNING g_hrag.*
         DISPLAY g_hrag.hrag07 TO hrat17a_name          
               
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrat17a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.construct = "N"        #add by zhangbo130902
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17a
                 NEXT FIELD hrat17a
              WHEN INFIELD(hrat20a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.construct = "N"        #add by zhangbo130902
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20a
                 NEXT FIELD hrat20a
              WHEN INFIELD(hrat21a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '337'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.construct = "N"        #add by zhangbo130902
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat21a
                 NEXT FIELD hrat21a
#               WHEN INFIELD(hrat19a)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_hrad02"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat19a
#                 NEXT FIELD hrat19
              WHEN INFIELD(hrat22a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.construct = "N"        #add by zhangbo130902
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat22a
                 NEXT FIELD hrat22a
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
                 
#
#              WHEN INFIELD(hrat87)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg2 = '2'
#                 LET g_qryparam.form = "cq_hrao01_1_1"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat03
#                 NEXT FIELD hrat87   
#              WHEN INFIELD(hrat88)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg2 = '3'
#                 LET g_qryparam.form = "cq_hrao01_1_1"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat03
#                 NEXT FIELD hrat88  
#                  
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
                 LET g_qryparam.where = "hrat07 = 'Y' "
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
                 LET g_qryparam.form = "q_azp01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat42
                 NEXT FIELD hrat42     
         #     WHEN INFIELD(hrat52)           #marked by yeap 130701
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_hrat01"
         #        LET g_qryparam.state = "c" 
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO hrat52
         #        NEXT FIELD hrat52     
              WHEN INFIELD(hrat64)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrar06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat64
                 NEXT FIELD hrat64                  
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
              WHEN INFIELD(hrat64)#add by yeap 130701
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '204'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat64
                 NEXT FIELD hrat64
              WHEN INFIELD(hrat68)   #added 130702
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat68
                 NEXT FIELD hrat68
              WHEN INFIELD(hrat67)   #added 130702
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraq02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrat67
                  NEXT FIELD hrat67
              OTHERWISE
                 EXIT CASE
           END CASE

      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
    CALL cl_get_hrzxa(g_user) RETURNING l_wc #160818 add by zhangtn
    LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED #160818 add by zhangtn 
    IF INT_FLAG THEN LET g_wc2 = NULL RETURN END IF

END FUNCTION

      
FUNCTION q006_b_fill(p_wc2,p_start)        
DEFINE p_start    LIKE type_file.num5      
DEFINE p_wc2      LIKE type_file.chr1000  
DEFINE l_color    LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1     LIKE type_file.num5

DEFINE l_jump2    LIKE type_file.num10

   DISPLAY 'start: '||TIME
   IF cl_null(p_start) THEN
   	  CALL g_hrat_t.clear()
   	  #LET p_wc2 = cl_replace_str(tm.wc,"1=1","1=0")
   	  
      LET g_sql =  " SELECT 'N',hrat03,'',hrat94,'',hrat04,'',hrat87,'',hrat88,'',hrat01,hrat02,hrat95,hrat08,hrat05,'',",
                   " '','','',hrat17,'',hrat22,'',hrat24,'',hrat10,",
                   " hrat12,'',hrat13,hrat15,hrat16,hrat25,hrat66,hrat96,'',hrat19,'',hrat20,'',",
                   " hrat21,'',hrat06,'',hrat26,hrat27,hrat77,hrat46,hrat76,hrat18,hrat45,",
                   " hrat41,'',hrat40,'',hrat68,hrat28,'',hrat29,'',hrat23,hrat42,'',",
                   " hrat67,'','',hrat64,'',hrat74,hrat07,hrat09,hrat11,hrat49,hrat50,",
                   " hrat47,hrat48,hrat51,hrat43,'',hrat44,hrat75,hrat73,hrat36,hrat38,hrat37,hrat34,'',hratconf",
                   "   FROM hrat_file ",
                   "  WHERE ",p_wc2 CLIPPED,
                   " ORDER BY hrat01 "            
       PREPARE q006_pb FROM g_sql
       DECLARE hrat_curs SCROLL CURSOR WITH HOLD FOR q006_pb
       
       IF g_sum = 0 OR cl_null(p_start) THEN #modified NO.130707
       #LET g_sql = "SELECT count(*) from hrat_file WHERE",p_wc2 CLIPPED   #mark by zhangbo130830
       LET g_sql = "SELECT count(*) from hrat_file WHERE ",p_wc2 CLIPPED   #add by zhangbo130830
        PREPARE q006_precount FROM g_sql
        DECLARE q006_count CURSOR FOR q006_precount
           OPEN q006_count
          FETCH q006_count INTO g_sum
        DISPLAY g_sum TO FORMONLY.cnt
        END IF 
       #mark by shenran start
#        IF g_sum > 1500 THEN 
#        	LET g_sum = 1500
#        END IF 
      #mark by shenran end
       FOREACH hrat_curs  INTO g_hrat_t[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        #he tong
        SELECT MAX(hrbf08),max(hrbf09) INTO g_hrat_t[g_cnt].hrbf08,g_hrat_t[g_cnt].hrbf09 
        FROM hrbf_file 
        left join hrbe_file ON hrbf04=hrbe01
        WHERE hrbf02=(SELECT hratid FROM hrat_file WHERE hrat01=g_hrat_t[g_cnt].hrat01) and hrbe03='001'
        #xie yi
        SELECT MAX(hrbf08),max(hrbf09) INTO g_hrat_t[g_cnt].hrbf08_1,g_hrat_t[g_cnt].hrbf09_1 
        FROM hrbf_file 
        left join hrbe_file ON hrbf04=hrbe01
        WHERE hrbf02=(SELECT hratid FROM hrat_file WHERE hrat01=g_hrat_t[g_cnt].hrat01) and hrbe03='002'

        
        IF g_turn = 0 THEN 
        	LET g_turn = 5000
        END IF 

        LET g_jump1 = 1  
        
        DISPLAY g_jump1 TO FORMONLY.jump1
        
        
        LET g_cnt = g_cnt + 1
#        mark by shenran start
#        IF g_cnt > g_sum THEN
#           CALL cl_err_msg(NULL,"lib-217",g_sum,10)
#           EXIT FOREACH
#        END IF
#        mark by shenran end 
    END FOREACH
    #mark by shenran start
#    IF g_cnt < 1500 THEN 
#    	LET g_sum = g_cnt
#    	DISPLAY g_sum TO cnt
#    END IF  
#    mark by shenran end
    	 LET g_jump2 = g_sum/g_turn
        LET l_jump2 = g_jump2 * g_turn 
        IF l_jump2 < g_sum THEN 
        	LET g_jump2 = g_jump2 + 1 
        END IF 
       DISPLAY g_jump2 TO FORMONLY.jump2
    	
    CALL g_hrat_t.deleteElement(g_cnt)
    CALL q006_set_data(0,g_turn)
    DISPLAY g_rec_b TO cnt1
    DISPLAY g_turn TO cnt1 
    ELSE 
        CALL q006_set_data(p_start,g_turn)
        DISPLAY g_turn TO cnt1 
   END IF 
    	LET g_cnt = 0
    DISPLAY 'end: '||TIME

END FUNCTION	
 

FUNCTION q006_tree_b_fill(p_tree_ac)
 DEFINE p_tree_ac  LIKE type_file.num5
 DEFINE l_sql      STRING
 DEFINE l_job      LIKE type_file.chr100
 DEFINE l_dep      LIKE type_file.chr100
 DEFINE l_company  LIKE type_file.chr100
 DEFINE l_jump2    LIKE type_file.num10
 DEFINE   l_wc   LIKE type_file.chr1000
 
 IF p_tree_ac = 0 THEN RETURN END IF 
 CALL g_hrat.clear()
 #??????????????????????
 IF cl_null(g_wc2) THEN LET g_wc2 = " hrat19='2001'"  END IF    #add by nihuan 20161228 
 
 CALL cl_get_hrzxa(g_user) RETURNING l_wc #160818 add by zhangtn
 LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED #160818 add by zhangtn 
 
 IF g_tree[p_tree_ac].treekey1 = 'J' THEN 
 	  LET l_job = g_tree[p_tree_ac].name
 	  LET l_dep = g_tree[g_tree[p_tree_ac].pid].name
 	  LET l_sql = g_wc2||
                      " AND hrat04 = '",l_dep,"' ",
 	              " AND hrat05 = '",l_job,"' "
 END IF 
 IF g_tree[p_tree_ac].treekey1 = 'D' THEN
 	  LET l_dep = g_tree[p_tree_ac].name
 	  LET l_sql = g_wc2||
             "  AND hrat04 IN( ",
             "  SELECT hrao01 FROM hrao_file ",
             "  CONNECT BY NOCYCLE PRIOR hrao01 = hrao06 ",
             "  START WITH hrao01 = '",l_dep,"') "
 END IF 
 IF g_tree[p_tree_ac].treekey1 MATCHES '[GC]' THEN 
 	  LET l_company = g_tree[p_tree_ac].name
 	  LET l_sql = g_wc2||
             "  AND hrat03 IN( ",
             "  SELECT hraa01 FROM hraa_file ",
             "  CONNECT BY NOCYCLE PRIOR hraa01 = hraa10 ",
             "  START WITH hraa01 = '",l_company,"') "    	
 END IF 
  
  LET g_cnt = 1	
 CALL q006_b_fill(l_sql,'')
END FUNCTION  	
	
FUNCTION q006_tree_fill()
DEFINE p_level,l_n   LIKE   type_file.num5
	 
   CALL g_tree.clear()
   LET g_id=1
   LET g_level=0

 #-----1.????-----
   SELECT DISTINCT hraa01,hraa12 INTO g_tree[g_id].name,g_tree[g_id].des
     FROM hraa_file WHERE hraaacti='Y' AND hraa10 IS NULL 
      IF SQLCA.sqlcode = 100 THEN
         RETURN
      END IF 

      LET g_tree[g_id].expanded=TRUE
      LET g_tree[g_id].id = g_id
      LET g_tree[g_id].pid = NULL
      LET g_tree[g_id].level = g_level
      LET g_tree[g_id].treekey1 = 'G'
      
      SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10=g_tree[g_id].name
   
      IF l_n>0 THEN
         LET g_tree[g_id].has_children = TRUE
      ELSE
         LET g_tree[g_id].has_children = FALSE
      END IF
 #-----3.????----- 
      IF l_n>0 THEN
         CALL q006_tree_fill_1(g_level,g_tree[g_id].id)       #???????
      END IF
   
   LET l_n = g_tree.getLength()
 #-----2.????----- 
   IF l_n>0 THEN
   	  CALL q006_tree_fill_2()
   END IF	   
 #-----3.????-----  
   CALL q006_tree_fill_3()

 #-----4.Tree??-----
   CALL q006_tree_re()
   
END FUNCTION
	
FUNCTION q006_tree_fill_1(p_level,p_id)
DEFINE p_level,l_n     LIKE    type_file.num5
DEFINE p_id   LIKE type_file.num10	
DEFINE l_i      LIKE  type_file.num5
DEFINE l_cnt    LIKE  type_file.num5
DEFINE   l_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000, 
          des            LIKE type_file.chr1000,                
          img            LIKE type_file.chr1000,                
          pid            LIKE type_file.num10,
          id             LIKE type_file.num10,
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),       #Group ,Company,Department,Job
          emp            LIKE type_file.num5
          END RECORD

      LET p_level = p_level + 1
      LET g_sql=" SELECT hraa01,hraa12 FROM hraa_file WHERE hraa10='",g_tree[p_id].name,"' ",
                "    AND hraaacti = 'Y' "
      PREPARE q006_tree_pb FROM g_sql
      DECLARE q006_tree_cs CURSOR FOR q006_tree_pb
      
       LET l_cnt = 1
       FOREACH q006_tree_cs INTO l_tree[l_cnt].name,l_tree[l_cnt].des
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_tree[l_cnt].expanded = 0          #0:??, 1:?  #111
          LET g_id = g_id + 1
          LET l_tree[l_cnt].id = g_id
          LET l_tree[l_cnt].pid = p_id
          LET l_tree[l_cnt].level = p_level
          LET l_tree[l_cnt].treekey1 = 'C'
          CALL g_tree.appendElement()
          LET g_tree[g_tree.getLength()].* = l_tree[l_cnt].*  
          LET l_cnt = l_cnt + 1 
       END FOREACH
       
       CALL l_tree.deleteElement(l_cnt)  #??FOREACH????????
       LET l_cnt = l_cnt - 1 
       
       IF l_cnt > 0 THEN 
          FOR l_i = 1 TO l_cnt
             IF l_tree[l_i].treekey1 != 'C' THEN CONTINUE FOR END IF 
             SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10=l_tree[l_i].name
                AND hraaacti = 'Y'
             IF l_n > 0 THEN 
                LET l_tree[l_i].has_children = TRUE
                LET g_tree[l_tree[l_i].id].has_children = TRUE
                IF l_n > 0 THEN 
                   CALL q006_tree_fill_1(p_level,l_tree[l_i].id) 
                END IF	
             ELSE 
                LET l_tree[l_i].has_children = FALSE  
                LET g_tree[l_tree[l_i].id].has_children = FALSE
             END IF 
          END FOR     
       END IF        
             
END FUNCTION	
	
FUNCTION q006_tree_fill_2()
DEFINE p_level,l_n,l_cnt  LIKE  type_file.num5
DEFINE p_cmd         LIKE  type_file.chr1
DEFINE l_i      LIKE  type_file.num5
                    
       LET g_cnt = g_tree.getLength() 
       LET g_id  = g_cnt       
       FOR l_i = 1 TO g_cnt         
          LET g_sql = "SELECT hrao01,hrao02 FROM hrao_file ",
                      " WHERE hrao05 = 'Y' ",
                      "   AND hraoacti = 'Y' ",
                      "   AND hrao00 = '",g_tree[l_i].name,"' ",
                      " ORDER BY hrao00,hrao01 "           	
          PREPARE q006_tree_pb2 FROM g_sql
          DECLARE q006_tree_cs2 CURSOR FOR q006_tree_pb2
          LET g_id = g_id + 1 
          FOREACH q006_tree_cs2 INTO g_tree[g_id].name,g_tree[g_id].des
             LET g_tree[g_id].id = g_id
             LET g_tree[g_id].pid=l_i                        
             LET g_tree[g_id].expanded=0    #111
             LET g_tree[g_id].level=g_level
             LET g_tree[g_id].treekey1= 'D'
             LET g_id = g_id + 1 
          END FOREACH
          CALL g_tree.deleteelement(g_id)  #??FOREACH????????
          LET g_id = g_id - 1
          LET l_cnt = g_id
       END FOR
       
       
       FOR l_i = 1 TO l_cnt
          IF g_tree[l_i].treekey1 != 'D' THEN CONTINUE FOR END IF 
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao06=g_tree[l_i].name
             AND hraoacti = 'Y'
          IF l_n>0 THEN
             LET g_tree[l_i].has_children = TRUE 
             CALL q006_tree_fill_22(g_tree[l_i].level,g_tree[l_i].id) 
          ELSE 
             LET g_tree[l_i].has_children = FALSE    	
          END IF 
       END FOR       
       
END FUNCTION


FUNCTION q006_tree_fill_22(p_level,p_id)
DEFINE p_level,l_n   LIKE    type_file.num5
DEFINE p_id   LIKE type_file.num10	
DEFINE l_i    LIKE type_file.num5
DEFINE l_cnt    LIKE  type_file.num5
DEFINE   l_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000, 
          des            LIKE type_file.chr1000,                
          img            LIKE type_file.chr1000,                
          pid            LIKE type_file.num10,
          id             LIKE type_file.num10,
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),       #Group ,Company,Department,Job
          emp            LIKE type_file.num5    
          END RECORD

      LET l_cnt = 1 
      LET g_sql=" SELECT hrao01,hrao02 FROM hrao_file ",
                "  WHERE hrao06 = '",g_tree[p_id].name,"' ",
                "    AND hraoacti = 'Y' ",
                "    AND hrao05 = 'N' "
      PREPARE q006_tree_pb3 FROM g_sql
      DECLARE q006_tree_cs3 CURSOR FOR q006_tree_pb3
       FOREACH q006_tree_cs3 INTO l_tree[l_cnt].name,l_tree[l_cnt].des
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET g_id = g_id + 1 
          LET l_tree[l_cnt].id = g_id
          LET l_tree[l_cnt].pid = p_id
          LET l_tree[l_cnt].level = p_level
          LET l_tree[l_cnt].expanded = 0     #111   
          LET l_tree[l_cnt].treekey1 = 'D'
          CALL g_tree.appendElement()
          LET g_tree[g_tree.getLength()].* = l_tree[l_cnt].*  
          LET l_cnt = l_cnt + 1 
       END FOREACH
       
       CALL l_tree.deleteelement(l_cnt)  #??FOREACH????????
       LET l_cnt = l_cnt - 1
       
       FOR l_i = 1 TO l_cnt
          IF l_tree[l_i].treekey1 != 'D' THEN CONTINUE FOR END IF 
          SELECT COUNT(*) INTO l_n FROM hrao_file 
           WHERE hraoacti = 'Y'
             AND hrao06 = l_tree[l_i].name
          IF l_n > 0 THEN 
             LET l_tree[l_i].has_children = TRUE  
             LET g_tree[l_tree[l_i].id].has_children = TRUE  
             CALL q006_tree_fill_22(p_level,l_tree[l_i].id) 
          ELSE 
             LET l_tree[l_i].has_children = FALSE 
             LET g_tree[l_tree[l_i].id].has_children = FALSE
          END IF 
       END FOR     
END FUNCTION
	
	
FUNCTION q006_tree_fill_3()
DEFINE p_level,l_n   LIKE  type_file.num5
DEFINE p_id          STRING
DEFINE l_name    LIKE  hrat_file.hrat02
DEFINE l_i       LIKE  type_file.num5
      
    	 LET g_id = g_tree.getLength()
    	 LET g_cnt = g_id
       FOR l_i = 1 TO g_cnt
          IF g_tree[l_i].treekey1 != 'D' THEN CONTINUE FOR END IF 
          
          LET g_sql = "SELECT hrap05,hrap06 FROM hrap_file",
                      " WHERE hrap01 = '",g_tree[l_i].name,"' ",
                      " ORDER by hrap01,hrap04 "
          PREPARE q006_tree_pb4 FROM g_sql
          DECLARE q006_tree_cs4 CURSOR FOR q006_tree_pb4
          LET g_id = g_id + 1 
          FOREACH q006_tree_cs4 INTO g_tree[g_id].name,g_tree[g_id].des           
             IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             LET g_tree[g_id].expanded = 0   #111
             LET g_tree[g_id].id = g_id
             LET g_tree[g_id].pid = l_i
             LET g_tree[g_id].level = g_level
             LET g_tree[g_id].treekey1 = 'J'
             LET g_tree[g_id].has_children = FALSE
             LET g_id = g_id + 1 
          END FOREACH
          CALL g_tree.deleteelement(g_id)  #??FOREACH????????
          LET g_id = g_id - 1
       END FOR      
END FUNCTION 


FUNCTION q006_tree_re()
 DEFINE i  LIKE type_file.num5
 DEFINE l_n  LIKE type_file.num5

   DROP TABLE q006_tmp
   CREATE TEMP TABLE q006_tmp(
      namea  VARCHAR(1000),
      desa   VARCHAR(1000),
      imga   VARCHAR(1000),
      pida   DECIMAL(10),
      ida    DECIMAL(10),
      has_childrena BOOLEAN,
      expandeda     BOOLEAN, 
      levela        DECIMAL(5),
      treekey1a     VARCHAR(1000),
      emp           DECIMAL(5))

   FOR i = 1 TO g_tree.getLength()
      INSERT INTO q006_tmp VALUES(g_tree[i].*)
   END FOR

   CALL g_tree.clear()

   SELECT * INTO g_tree[1].* FROM q006_tmp WHERE ida = 1

   SELECT COUNT(*) INTO l_n FROM q006_tmp WHERE pida = g_tree[1].id
   CALL q006_icon(g_tree[1].treekey1) RETURNING g_tree[1].img
   IF l_n > 0 THEN 
      CALL q006_tree_re_1(g_tree[1].id,g_tree[1].id)
   END IF 
   CALL q006_emp()

END FUNCTION


FUNCTION q006_tree_re_1(p_ido,p_idn)
DEFINE p_ido LIKE type_file.num5
DEFINE p_idn LIKE type_file.num5
DEFINE i     LIKE type_file.num5
DEFINE l_i   LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5
DEFINE   l_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000, 
          des            LIKE type_file.chr1000,                
          img            LIKE type_file.chr1000,                
          pid            LIKE type_file.num10,
          id             LIKE type_file.num10,
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),       #Group ,Company,Department,Job
          emp            LIKE type_file.num5
          END RECORD
   
   LET g_sql = "SELECT * FROM q006_tmp WHERE pida = ",p_ido
   PREPARE q006_tree_re_prep FROM g_sql
   DECLARE q006_tree_re_cs CURSOR FOR q006_tree_re_prep
   LET l_i = 1
   FOREACH q006_tree_re_cs INTO l_tree[l_i].*
      CALL q006_icon(l_tree[l_i].treekey1) RETURNING l_tree[l_i].img
      LET l_i = l_i + 1
   END FOREACH

   CALL l_tree.deleteElement(l_i)
   LET l_i = l_i - 1

   FOR i = 1 TO l_i
      CALL g_tree.appendElement()
      LET l_tree[i].pid = p_idn
      LET g_tree[g_tree.getLength()].* = l_tree[i].*
      LET g_tree[g_tree.getLength()].id = g_tree.getLength()
      SELECT COUNT(*) INTO l_n FROM q006_tmp WHERE pida = l_tree[i].id
      IF l_n > 0 THEN 
         CALL q006_tree_re_1(l_tree[i].id,g_tree[g_tree.getLength()].id)
      END IF 

   END FOR

END FUNCTION


FUNCTION q006_icon(p_flag)
 DEFINE p_flag  LIKE  type_file.chr1000
    CASE p_flag
         WHEN 'G' RETURN "gongsi.ico" #"group.png" 
         WHEN 'C' RETURN "gongsi.ico" #"lingua.png"
         WHEN 'D' RETURN "bumen.ico"#"notebook.png"
         WHEN 'J' RETURN "zhiwei.ico" #"user.png"
    END CASE
   #CALL ghr_ghri006.i006_hrat52() RETURNING p_flag
END FUNCTION 

FUNCTION q006_emp()
 DEFINE l_i  LIKE type_file.num5
 DEFINE l_job LIKE type_file.chr1000
 DEFINE l_dep LIKE type_file.chr1000
 DEFINE l_cnt LIKE type_file.num5

 FOR l_i = 1 TO g_tree.getLength()
     IF g_tree[l_i].treekey1 != 'J' THEN 
        LET g_tree[l_i].emp = 0 
        CONTINUE FOR 
     END IF 
     LET l_job = g_tree[l_i].name
     LET l_dep = g_tree[g_tree[l_i].pid].name
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM hrat_file
      WHERE hrat04 = l_dep
        AND hrat05 = l_job
     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
     LET g_tree[l_i].emp = l_cnt
     IF l_cnt > 0 THEN 
        CALL q006_emp_1(l_i,l_cnt)
     END IF 
 END FOR

 FOR l_i = 1 TO g_tree.getLength()
     LET g_tree[l_i].des = g_tree[l_i].des||' ('||g_tree[l_i].emp||')'
 END FOR


END FUNCTION

FUNCTION q006_emp_1(l_i,l_cnt)
  DEFINE l_i  LIKE type_file.num5
  DEFINE l_cnt  LIKE type_file.num5

  IF g_tree[l_i].pid IS NOT NULL THEN
     LET g_tree[g_tree[l_i].pid].emp = g_tree[g_tree[l_i].pid].emp + l_cnt
  ELSE 
     RETURN
  END IF 
  CALL q006_emp_1(g_tree[l_i].pid,l_cnt)
  
END FUNCTION


FUNCTION q006_ks()
  DEFINE l_cmd  LIKE  type_file.chr1000
  
    LET l_cmd = "ghrq006_ks 'ghrq006' " 
    CALL cl_cmdrun(l_cmd)

END FUNCTION 

FUNCTION q006_ghri006()
  DEFINE l_cmd  LIKE  type_file.chr1000
  
    LET l_cmd = "ghri006 " 
    CALL cl_cmdrun(l_cmd)
    
END FUNCTION 


FUNCTION q006_set_data(l_cnt,l_turn)
  DEFINE l_cnt, l_turn LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE l_hrat    RECORD LIKE hrat_file.*
  DEFINE l_hraqa04  LIKE hraqa_file.hraqa04 
  CALL g_hrat.clear()
  LET g_rec_b = l_cnt + l_turn  
  #add by zhangbo130830---begin
  IF g_rec_b>g_sum THEN
     LET g_rec_b=g_sum
  END IF
  #add by zhangbo130830---end
  
  FOR li_i = l_cnt+1 TO g_rec_b 
  
      LET g_hrat[li_j+1].* = g_hrat_t[li_i].*
      
      
        #????
        LET l_hrat.hrat03 = g_hrat_t[li_i].hrat03
        CALL i006_hrat03(l_hrat.*) RETURNING g_hrat[li_j+1].hrat03_name
        LET l_hrat.hrat04 = g_hrat_t[li_i].hrat04
        CALL i006_hrat04(l_hrat.*) RETURNING g_hrat[li_j+1].hrat04_name
        LET l_hrat.hrat05 = g_hrat_t[li_i].hrat05
        CALL i006_hrat05(l_hrat.*) RETURNING g_hrat[li_j+1].hrat05_name
        LET l_hrat.hrat06 = g_hrat_t[li_i].hrat06
        CALL i006_hrat06(l_hrat.*) RETURNING g_hrat[li_j+1].hrat06_name
        LET l_hrat.hrat19 = g_hrat_t[li_i].hrat19
        CALL i006_hrat19(l_hrat.*) RETURNING g_hrat[li_j+1].hrat19_name
        LET l_hrat.hrat40 = g_hrat_t[li_i].hrat40
        CALL i006_hrat40(l_hrat.*) RETURNING g_hrat[li_j+1].hrat40_name
        LET l_hrat.hrat42 = g_hrat_t[li_i].hrat42
        CALL i006_hrat42(l_hrat.*) RETURNING g_hrat[li_j+1].hrat42_name
        LET l_hrat.hrat94 = g_hrat_t[li_i].hrat94
        CALL i006_hrat94(l_hrat.*) RETURNING g_hrat[li_j+1].hrat94_name
        LET l_hrat.hrat87 = g_hrat_t[li_i].hrat87
        CALL i006_hrat87_1(l_hrat.*) RETURNING g_hrat[li_j+1].hrat87_name
        LET l_hrat.hrat88 = g_hrat_t[li_i].hrat88
        CALL i006_hrat88_1(l_hrat.*) RETURNING g_hrat[li_j+1].hrat88_name

          
        CALL s_code('314',g_hrat_t[li_i].hrat12) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat12_name = g_hrag.hrag07  
        CALL s_code('333',g_hrat_t[li_i].hrat17) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat17_name = g_hrag.hrag07  
        CALL s_code('313',g_hrat_t[li_i].hrat20) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat20_name = g_hrag.hrag07
        CALL s_code('337',g_hrat_t[li_i].hrat21) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat21_name = g_hrag.hrag07
        CALL s_code('317',g_hrat_t[li_i].hrat22) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat22_name = g_hrag.hrag07
        CALL s_code('334',g_hrat_t[li_i].hrat24) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat24_name = g_hrag.hrag07
        CALL s_code('302',g_hrat_t[li_i].hrat28) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat28_name = g_hrag.hrag07
        CALL s_code('301',g_hrat_t[li_i].hrat29) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat29_name = g_hrag.hrag07

        CALL s_code('320',g_hrat_t[li_i].hrat34) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat34_name = g_hrag.hrag07
        CALL s_code('325',g_hrat_t[li_i].hrat41) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat41_name = g_hrag.hrag07
        CALL s_code('319',g_hrat_t[li_i].hrat43) RETURNING g_hrag.*
        LET g_hrat[li_j+1].hrat43_name = g_hrag.hrag07
        CALL s_code('205',g_hrat_t[li_i].hrat64) RETURNING g_hrag.*#add by yeap 130701
        LET g_hrat[li_j+1].hrat64 = g_hrag.hrag07
        CALL s_code('340',g_hrat_t[li_i].hrat68) RETURNING g_hrag.*#add by yeap 130702
        LET g_hrat[li_j+1].hrat68 = g_hrag.hrag07
        CALL s_code('326',g_hrat_t[li_i].hrat66) RETURNING g_hrag.*#add by yeap 130702
        LET g_hrat[li_j+1].hrat66 = g_hrag.hrag07

         
        SELECT hraqa02,hraqa03,hraqa04  #add by yeap 130701 modified 130702
          INTO g_hrat[li_j+1].hraqa02,g_hrat[li_j+1].hrat67_name,l_hraqa04
          FROM hraqa_file
         WHERE hraqa01 = g_hrat_t[li_i].hrat67
           
       SELECT hrar02,hrar04,hrar06 #add by yeap 130701
         INTO g_hrat[li_j+1].hrag07,g_hrat[li_j+1].hrar04,g_hrat[li_j+1].hrar06
         FROM hrar_file
         left join hras_file ON hras03=hrar03
        WHERE hrar01 = '0000'
          AND hras01 = g_hrat_t[li_i].hrat05
           
           
        CALL s_code('203',g_hrat[li_j+1].hrag07) RETURNING g_hrag.*#add by yeap 130702 modified NO.130707
        LET g_hrat[li_j+1].hrag07 = g_hrag.hrag07
        CALL s_code('204',g_hrat[li_j+1].hrar06) RETURNING g_hrag.*#add by yeap 130702  modified NO.130707
        LET g_hrat[li_j+1].hrar06 = g_hrag.hrag07
     #add by nihuan 20160816---start------
         LET g_hrat[li_j+1].hrat05_name = ''
   IF NOT cl_null(l_hrat.hrat05) THEN
          SELECT hrap06 INTO g_hrat[li_j+1].hrat05_name
          FROM hrap_file
          WHERE hrap05=l_hrat.hrat05
    ELSE
    	LET g_hrat[li_j+1].hrat05_name = ''
   END IF

     #add by nihuan 20160816---end------- 
      LET li_j = li_j + 1
  END FOR
 
END FUNCTION
	
	
FUNCTION q006_tz()  #add by yeap NO.130707
	DEFINE l_jump1    LIKE type_file.num10
	DEFINE l_jump2    LIKE type_file.num10
	DEFINE l_turn   LIKE type_file.num10
	DEFINE l_cnt      LIKE type_file.num10
	DEFINE l_input    LIKE type_file.chr1
	DEFINE l_j        LIKE type_file.num10
        
   #MOD-C40062 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #MOD-C40062 end add-----

	                                  
	                                  
	  INPUT g_jump1,g_turn WITHOUT DEFAULTS FROM jump1,cnt1
	                                  
	  BEFORE INPUT                    
          LET l_input='N'                 
          LET g_before_input_done = FALSE 
              CALL cl_set_comp_entry("jump1,cnt1",TRUE)
          LET g_before_input_done = TRUE  
          LET g_turn_t = g_turn                                      
	  CALL cl_set_comp_visible("accept,cancel",FALSE)
                                          
                                          
     AFTER FIELD cnt1                     
        IF NOT cl_null(g_turn) THEN       
        	LET g_jump2 = g_sum/g_turn
        	LET l_jump2 = g_turn * g_jump2 
        	IF l_jump2 < g_sum THEN   
        		 LET g_jump2 = g_jump2 + 1
        	END IF                    
        	DISPLAY g_jump2 TO FORMONLY.jump2 
        		 IF NOT (g_jump1 > g_jump2) THEN 
        		 	  LET g_jump1 = l_jump1
        	      LET l_cnt = (g_jump1 - 1) * g_turn
      	     ELSE                          
      	    	  LET g_jump1 = g_jump2    
      	    	  LET l_cnt = (g_jump1 - 1) * g_turn
      	     END IF
      	     DISPLAY g_jump1 TO FORMONLY.jump1
        ELSE                              
        	LET g_turn = l_turn       
        	DISPLAY g_turn TO FORMONLY.cnt1
        END IF                            
          
          
     AFTER FIELD jump1
        IF NOT cl_null(g_jump1) THEN
        	IF NOT (g_jump1 > g_jump2) THEN 
        	   LET l_cnt = (g_jump1 - 1) * g_turn
      	  ELSE                          
          	 LET l_jump1 = g_jump1    
      	     LET l_cnt = (l_jump1 - 1) * g_turn
      	  END IF                        
        ELSE                                
      	  NEXT FIELD jump1 
      	END IF 
        	 

     
      ON ACTION query
        CALL q006_q()
        CALL q006_bp_1()
        IF g_j = 1 THEN
        	EXIT INPUT 
        ELSE  
          CONTINUE INPUT 
        END IF                     
 
      ON ACTION HELP
         CALL cl_show_help()    
         CONTINUE INPUT
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
         CONTINUE INPUT
 
      ON ACTION close
         LET g_i = 1
         EXIT INPUT   

      ON ACTION EXIT
         LET g_i = 1
         EXIT INPUT   

      ON ACTION fi         #130703
               LET g_jump1 = GET_FLDBUF(jump1)  
               LET g_turn = GET_FLDBUF(cnt1) 
              CALL q006_relet()
            	LET g_jump1 = 1 
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	LET g_cnt = 0           	
             CALL q006_b_fill(g_wc2,g_cnt)
             CALL q006_bp_1()
         EXIT INPUT
         
      ON ACTION pr
               LET g_jump1 = GET_FLDBUF(jump1)  
               LET g_turn = GET_FLDBUF(cnt1) 
              CALL q006_relet()
            	IF g_jump1 > 1 THEN 
            	   LET g_jump1 = g_jump1 - 1
            	ELSE 
            	 	 LET g_jump1 = 1
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn           	          	
              CALL q006_b_fill(g_wc2,g_cnt)
              CALL q006_bp_1()
         EXIT INPUT

      ON ACTION ne
               LET g_jump1 = GET_FLDBUF(jump1)  
               LET g_turn = GET_FLDBUF(cnt1) 
              CALL q006_relet()
            	IF g_jump1 < g_jump2 THEN 
            	   LET g_jump1 = g_jump1 + 1
            	ELSE
            		 LET g_jump1 = g_jump2
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn            	
              CALL q006_b_fill(g_wc2,g_cnt)
              CALL q006_bp_1()
         EXIT INPUT

      ON ACTION la
               LET g_jump1 = GET_FLDBUF(jump1)  
               LET g_turn = GET_FLDBUF(cnt1) 
                  CALL q006_relet() 
                  DISPLAY g_jump2 TO FORMONLY.jump1
                      LET g_jump1 = g_jump2
                      LET g_cnt = g_turn * (g_jump2-1)             	
              CALL q006_b_fill(g_wc2,g_cnt)
              CALL q006_bp_1()
         EXIT INPUT

      ON ACTION turn
               LET g_jump1 = GET_FLDBUF(jump1)  
               LET g_turn = GET_FLDBUF(cnt1)      
               CALL q006_relet()
              
              IF g_jump1 < 1 THEN 
                 LET g_cnt = 0
              END IF        
              	     	
              CALL q006_b_fill(g_wc2,g_cnt)
              CALL q006_bp_1()
         CONTINUE INPUT
         
      ON ACTION ks
         CALL q006_ks()
         CONTINUE INPUT
         
      ON ACTION ghri006
         CALL q006_ghri006()  
         CONTINUE INPUT

      ON ACTION controlg 
         CALL cl_cmdask()
         CONTINUE INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         #MOD-C40062 str add------
         LET w = ui.Window.getCurrent()
         LET f = w.getForm()
         LET page = f.FindNode("Table","s_hrat")
         CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrat),'','')
         #MOD-C40062 end add-----
         #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat),'','')
         CONTINUE INPUT
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")  
                                                                                                 
   END INPUT
   	CALL cl_set_comp_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION q006_bp_1()
	
	CALL cl_set_comp_visible("accept,cancel",FALSE) 

            
      DISPLAY ARRAY g_hrat TO s_hrat.*  ATTRIBUTE(COUNT=g_sum,UNBUFFERED)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            EXIT DISPLAY            

            
   END DISPLAY 
            
END FUNCTION 
	
FUNCTION q006_relet()
		DEFINE l_jump2    LIKE type_file.num10
	  DEFINE l_turn   LIKE type_file.num10
	  DEFINE l_cnt      LIKE type_file.num10
	
              IF cl_null(g_jump1) THEN LET g_jump1 = 1 DISPLAY g_jump1 TO FORMONLY.jump1 END IF 
              	
              	IF NOT cl_null(g_turn) THEN       
        	         LET g_jump2 = g_sum/g_turn
             	     LET l_jump2 = g_turn * g_jump2 
        	          IF l_jump2 < g_sum THEN   
        		           LET g_jump2 = g_jump2 + 1
        	          END IF                    
        	          DISPLAY g_jump2 TO FORMONLY.jump2 
        		        IF NOT (g_jump1 > g_jump2) THEN 
        	             LET g_cnt = (g_jump1 - 1) * g_turn
      	            ELSE                          
      	    	         LET g_jump1 = g_jump2    
      	    	         LET g_cnt = (g_jump1 - 1) * g_turn
      	            END IF
      	            DISPLAY g_jump1 TO FORMONLY.jump1
                ELSE                              
              	    LET g_turn = g_turn_t 
        	          DISPLAY g_turn TO FORMONLY.cnt1
                END IF
END FUNCTION 


FUNCTION q006_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       IF p_hrag01='03' THEN  
          LET l_sql="select hraa01,hraa01||':'||hraa02 from hraa_file" 
       ELSE 
          IF p_hrag01='17' THEN 
             LET l_sql=" SELECT hrag06,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='333'",
                 "  ORDER BY hrag06"  
          ELSE 
             IF p_hrag01='24' THEN 
                LET l_sql=" SELECT hrag06,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='334'",
                    "  ORDER BY hrag06"  
             ELSE 
                IF p_hrag01='12' THEN 
                   LET l_sql=" SELECT hrag06,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='314'",
                       "  ORDER BY hrag06"  
                ELSE 
                   IF p_hrag01='19' THEN 
                      LET l_sql=" SELECT hrad02,hrad02||':'||hrad03 FROM hrad_file WHERE hradacti='Y'",
                          "  ORDER BY hrad02"  
                   ELSE 
                      IF p_hrag01='20' THEN 
                         LET l_sql=" SELECT hrag06,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='313'",
                             "  ORDER BY hrag06"
                      END IF 
                   END IF 
                END IF 
             END IF 
          END IF 
       END IF    
            
       PREPARE i213_get_items_pre FROM l_sql
       DECLARE i213_get_items CURSOR FOR i213_get_items_pre
       LET l_name=''
       LET l_items=''
       FOREACH i213_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       RETURN l_name,l_items
END FUNCTION


#add by nihuan 201701---------shen fen zheng dao qi
FUNCTION q006_dq()
DEFINE   l_sql   STRING
DEFINE   l_n     LIKE type_file.num5
DEFINE   l_dq    DYNAMIC ARRAY OF RECORD
              hrat01  LIKE hrat_file.hrat01,
              hrat02  LIKE hrat_file.hrat02,
              hrat04  LIKE hrat_file.hrat04,
              hrao02  LIKE hrao_file.hrao02,
              hrat14  LIKE hrat_file.hrat14
                 END RECORD 
    
    LET l_n=1
    LET l_sql="select hrat01,hrat02,hrat04,hrao02,hrat14 from hrat_file 
               left join hrao_file on hrao01=hrat04
               where hrat14<=add_months(sysdate,3) order by hrat14"
    PREPARE q006_dq FROM l_sql
    DECLARE q006_dq_c CURSOR FOR q006_dq    
    FOREACH q006_dq_c INTO l_dq[l_n].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF  
      LET l_n=l_n+1   
    END FOREACH    
    CALL g_hrat_t.deleteElement(l_n)
    
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q006_dq AT p_row,p_col WITH FORM "ghr/42f/ghrq006_dq"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()  
    
    LET l_n=l_n-1
    
    DISPLAY ARRAY l_dq TO s_dq.* ATTRIBUTE(COUNT=l_n)
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )    
    
      ON ACTION close
#         LET g_action_choice="exit"
         EXIT DISPLAY    

      ON ACTION exit
#         LET g_action_choice="exit"
         EXIT DISPLAY 
         
      ON ACTION exporttoexcel   #No.FUN-4B0020
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_dq),'','')
         
         
      END DISPLAY 
      
    CLOSE WINDOW q006_dq 
END FUNCTION 


FUNCTION q006_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_hratid        LIKE hrat_file.hratid,                 
    l_n,l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    CALL cl_set_comp_visible("sel",TRUE)
    
    CALL g_hratid.clear()
    
 
    INPUT ARRAY g_hrat WITHOUT DEFAULTS FROM s_hrat.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        
        CALL cl_set_comp_entry('sel',TRUE)
        #CALL cl_set_comp_entry("hrat01,hrat02,hrat03,hrat04,hrat08,hrat05,hrat17,hrat22,hrat24,hrat10",FALSE)   
         CALL cl_show_fld_cont()     
        	
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrat[l_ac].* = g_hrat_t[l_ac].*
          END IF              
                 
          EXIT INPUT
        END IF
        
    ON CHANGE sel              
        LET g_sel_b = 0      
        CALL g_hray_t.clear()    
        CALL g_hratid_t.clear()
        FOR l_i = 1 TO g_rec_b 
          IF g_hrat[l_i].sel = 'Y' THEN
            LET g_sel_b = g_sel_b + 1
            SELECT hratid INTO g_hratid[g_sel_b] FROM hrat_file WHERE hrat01=g_hrat[l_i].hrat01
#            LET g_hray[l_i].hrat01=g_hrat[l_i].hrat01
#            LET g_hray[l_i].hrat02=g_hrat[l_i].hrat02
#            LET g_hray[l_i].hrat01=g_hrat[l_i].hrat01
#            
#            
#            LET g_hray_t[g_sel_b].*=g_hray[l_i].*
            LET g_hratid_t[g_sel_b]=g_hratid[g_sel_b]
          END IF 
        END FOR 
        CALL g_hray.deleteElement(l_i)
        DISPLAY g_sel_b TO FORMONLY.cnt2 
                         
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()

     ON ACTION q006_zhuanz
        CALL q006_zhuanz() 
     
     ON ACTION q006_diaod
        CALL q006_diaod()
     
     ON ACTION q006_litui
        CALL q006_litui()
        
     ON ACTION q006_heimd
        CALL q006_heimd()        
 
     ON ACTION sel_all
        FOR l_n = 1 TO g_rec_b
           LET g_hrat[l_n].sel = 'Y'
        END FOR

     ON ACTION sel_none
        FOR l_n = 1 TO g_rec_b
           LET g_hrat[l_n].sel = 'N'
        END FOR
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
    END INPUT
    CALL cl_set_comp_visible("sel",FALSE)
    #CALL q006_b_fill(g_wc2)

END FUNCTION 

FUNCTION q006_zhuanz()
  DEFINE l_hray02    LIKE hray_file.hray02        
  DEFINE l_hrad03,l_hrad03_n    LIKE hrad_file.hrad03         
  DEFINE l_hray24    LIKE hray_file.hray24         
  DEFINE l_hray12    LIKE hray_file.hray12         
  DEFINE l_hray13    LIKE hray_file.hray13         
  DEFINE l_hray14    LIKE hray_file.hray14         
  DEFINE l_i,l_n         LIKE type_file.num5            
  

  IF g_sel_b = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
  END IF 
  
  OPEN WINDOW q006_1_w  WITH FORM "ghr/42f/ghrq006_zz"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale('ghrq006_zz')
  
  #add by zhangbo130905---begin
  DIALOG ATTRIBUTES(UNBUFFERED)
#  DISPLAY ARRAY g_hray_t TO s_hray_1.*  ATTRIBUTE(COUNT=g_sel_b)
#     BEFORE DISPLAY
#         IF g_sel_b != 0 THEN
#            CALL fgl_set_arr_curr(l_sel_ac)
#         END IF
#
#     BEFORE ROW
#         LET l_sel_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
#     ON ACTION EXIT
#         LET INT_FLAG=TRUE
#         EXIT DIALOG
#
#     ON ACTION controlg
#        CALL cl_cmdask()
#
#
#    # ON ACTION cancel
#    #     LET INT_FLAG=TRUE              #MOD-570244     mars
#    #     EXIT DIALOG
#
#     ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DIALOG
#
#     ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#  END DISPLAY 
#  #add by zhangbo130905---end 

  INPUT l_hray02,l_hrad03,l_hray24,l_hray12,l_hray13,l_hray14 FROM 
    FORMONLY.zzdate,FORMONLY.zzstat,FORMONLY.hray24,FORMONLY.dirmemo,FORMONLY.depmemo,FORMONLY.genmemo
     
    BEFORE INPUT 
       LET l_hray02=g_today
       DISPLAY l_hray02 TO zzdate  
       NEXT FIELD zzdate
      
      AFTER FIELD zzdate
        IF cl_null(l_hray02) THEN 
           CALL cl_err('','ghr-019',0)
           NEXT FIELD zzdate
        ELSE
        	 NEXT FIELD zzstat   
        END IF 
      #add by zhuzw 20150128 start
      AFTER FIELD zzstat
         IF NOT cl_null(l_hrad03) THEN
            SELECT COUNT(*) INTO l_n FROM hrad_file
             WHERE hrad02= l_hrad03
            IF l_n= 0 THEN 
               CALL cl_err('hrat19,error','!',0)
               NEXT FIELD zzstat
            ELSE 
               SELECT hrad03 INTO l_hrad03_n FROM hrad_file
                WHERE hrad02= l_hrad03   
               DISPLAY  l_hrad03_n TO z_n      	    
            END IF  
         END IF 

      ON ACTION controlp
         CASE
           WHEN INFIELD(zzstat)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = l_hrad03
              CALL cl_create_qry() RETURNING l_hrad03
              DISPLAY BY NAME l_hrad03
              NEXT FIELD zzstat            
           OTHERWISE EXIT CASE
         END CASE
      #add by zhuzw 20150128 end    
      ON ACTION EXIT
         LET INT_FLAG=TRUE
         #EXIT INPUT    #mark by zhangbo130905
         EXIT DIALOG    #add by zhangbo130905
 
      ON ACTION controlg 
        CALL cl_cmdask() 

      ON ACTION accept
         LET INT_FLAG=0
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=TRUE 		#MOD-570244	mars
         #EXIT INPUT        #mark by zhangbo130905
         EXIT DIALOG    #add by zhangbo130905
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE INPUT    #mark by zhangbo130905
         CONTINUE DIALOG    #add by zhangbo130905
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       
   END INPUT 
   
   END DIALOG            #add by zhangbo130905
 
   IF INT_FLAG THEN 
     LET INT_FLAG = FALSE
     CLOSE WINDOW q006_1_w 
     RETURN 
   END IF 

   BEGIN WORK 
   LET g_success ='Y'
   FOR l_i=1 TO g_sel_b
      OPEN  q006_zz_bcl USING g_hratid_t[l_i]       
      IF SQLCA.sqlcode THEN 
         CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOR 
      END IF 
      INITIALIZE b_hray.* TO NULL                     
      CALL q006_def_hray(g_hratid_t[l_i])             
      LET b_hray.hray01=g_hratid_t[l_i]               
      LET b_hray.hray02=l_hray02                      
      LET b_hray.hray02=l_hray02                      
      LET b_hray.hray12=l_hray12                      
      LET b_hray.hray13=l_hray13                      
      LET b_hray.hray14=l_hray14                      
      LET b_hray.hray24=l_hray24                      
      LET b_hray.hray08 = l_hrad03 #add by zhuzw 20150128
      #Step1.hray_file
      INSERT INTO hray_file VALUES(b_hray.*)
      IF SQLCA.sqlcode = '-268'  THEN 
          UPDATE hray_file SET hray_file.*=b_hray.*
          WHERE hray01=b_hray.hray01
          IF SQLCA.sqlcode THEN 
            CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOR 
          END IF 
      ELSE 
      	IF SQLCA.sqlcode THEN   
        	CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
        	LET g_success = 'N'
          EXIT FOR
        END IF   
      END IF 
      #Step2.
      UPDATE hrat_file SET hrat19=b_hray.hray08,hrat26=b_hray.hray02,hrat27=b_hray.hray02
       WHERE hratid=b_hray.hray01
      IF SQLCA.sqlcode THEN 
        CALL cl_err('upd hrat19',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF 
      
      CLOSE q006_zz_bcl                            
   END FOR 
   IF g_success = 'Y' THEN 
     COMMIT WORK 
     CLOSE WINDOW q006_1_w 
     CALL cl_err('','ghr-033',1)                  
     #CALL i010_b_fill("1=1")                      
   ELSE 
   	 ROLLBACK WORK
   	 CLOSE WINDOW q006_1_w 
   	 CALL cl_err('','ghr-034',1)                   
   END IF        
   
   
     
END FUNCTION 

FUNCTION q006_def_hray(p_hray01)
  DEFINE p_hray01     LIKE hray_file.hray01
  LET b_hray.hray02=g_today                
  LET b_hray.hray03=''                     
  LET b_hray.hray04=''                     
  LET b_hray.hray05=g_user                 
  LET b_hray.hray06=g_today                
  LET b_hray.hray07='001'                  
 # LET b_hray.hray08='2001'                
  LET b_hray.hray09='N'                    
  LET b_hray.hray10='003'                  
  LET b_hray.hray11=''                     
  LET b_hray.hray12=''                     
  LET b_hray.hray13=''                     
  LET b_hray.hray14=''                     
  LET b_hray.hray24=0                      
  SELECT hrat04,hrat05 INTO b_hray.hray15,b_hray.hray16 FROM hrat_file   
   WHERE hratid=p_hray01 
  LET b_hray.hray17='N'                           
  LET b_hray.hray18=''                            
  LET b_hray.hray19=''                            
  LET b_hray.hray20=''                            
  LET b_hray.hray21=''                            
  LET b_hray.hray22=''                            
  LET b_hray.hray23=''                            
  LET b_hray.hrayacti='Y'                         
  LET b_hray.hrayuser=g_user                      
  LET b_hray.hraygrup=g_grup                      
  LET b_hray.hraymodu=''                          
  LET b_hray.hraydate=g_today                     
  LET b_hray.hrayoriu=g_user                      
  LET b_hray.hrayorig=g_grup                      
  
END FUNCTION 

FUNCTION q006_diaod()

DEFINE li_result,l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE ls_doc      STRING
DEFINE l_hraz03     LIKE hraz_file.hraz03
DEFINE l_hraz33     LIKE hraz_file.hraz33
DEFINE l_hraz34     LIKE hraz_file.hraz34
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hraz01     LIKE  hraz_file.hraz01  


   DEFER INTERRUPT                     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   	
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW q006_dd WITH FORM "ghr/42f/ghrq006_dd"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hraz04",NULL,NULL)
   CALL cl_set_combo_items("hraz41",NULL,NULL)
   CALL cl_set_combo_items("hraz16",NULL,NULL)
   CALL cl_set_combo_items("hraz39",NULL,NULL)
   CALL cl_set_combo_items("hraz18",NULL,NULL)
   CALL cl_set_combo_items("hraz40",NULL,NULL)
   CALL cl_set_combo_items("hraz15",NULL,NULL)
   CALL cl_set_combo_items("hraz38",NULL,NULL)
#   CALL cl_set_combo_items("hraz16_1",NULL,NULL)
#   CALL cl_set_combo_items("hraz15_1",NULL,NULL)
#   CALL cl_set_combo_items("hraz04_1",NULL,NULL)
#   CALL cl_set_combo_items("hraz38_1",NULL,NULL)
#   CALL cl_set_combo_items("hraz39_1",NULL,NULL)
#   CALL cl_set_combo_items("hraz18_1",NULL,NULL) 
   

   CALL i016_get_items('328') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz04",l_name,l_items)
#   CALL cl_set_combo_items("hraz04_1",l_name,l_items)

   CALL i016_get_items('205') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz40",l_name,l_items)
   CALL cl_set_combo_items("hraz41",l_name,l_items)

   CALL i016_get_items('325') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz15",l_name,l_items)
   CALL cl_set_combo_items("hraz16",l_name,l_items)
#   CALL cl_set_combo_items("hraz15_1",l_name,l_items)
#   CALL cl_set_combo_items("hraz16_1",l_name,l_items)

   CALL i016_get_items('337') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz38",l_name,l_items)
   CALL cl_set_combo_items("hraz39",l_name,l_items) 
#   CALL cl_set_combo_items("hraz38_1",l_name,l_items)
#   CALL cl_set_combo_items("hraz39_1",l_name,l_items)

   CALL i016_get_items('103') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz18",l_name,l_items)
#   CALL cl_set_combo_items("hraz18_1",l_name,l_items)   
      
   CALL cl_ui_init()



   MESSAGE ""
   CLEAR FORM
#   CALL g_hraz.clear()
#   CALL g_hraz_1.clear()

   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_hraz_h.*  TO NULL
   LET g_hraz_h.hraz05=g_today
   LET g_hraz_h.hraz19=g_today
   LET g_hraz_h.hraz18='001'
   LET g_hraz_h.hraz44='N'
         
   WHILE TRUE
      CALL q006_dd_i("a")      
      IF INT_FLAG THEN     
         INITIALIZE g_hraz_h.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      FOR l_i=1 TO g_sel_b
             IF cl_null(g_hraz_h.hraz01) THEN
           	  LET l_year=YEAR(g_today) USING "&&&&"
              LET l_month=MONTH(g_today) USING "&&"
              LET l_day=DAY(g_today) USING "&&"
              LET l_year=l_year.trim()
              LET l_month=l_month.trim()
              LET l_day=l_day.trim()
              LET g_hraz_h.hraz01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
              LET l_hraz01=g_hraz_h.hraz01,"%"
              LET l_sql="SELECT MAX(hraz01) FROM hraz_file",
                        " WHERE hraz01 LIKE '",l_hraz01,"'"
              PREPARE i016_hraz01 FROM l_sql
              EXECUTE i016_hraz01 INTO g_hraz_h.hraz01
              IF cl_null(g_hraz_h.hraz01) THEN 
                 LET g_hraz_h.hraz01=l_hraz01[1,8],'0001'
              ELSE
                 LET l_no=g_hraz_h.hraz01[9,12]
                 LET l_no=l_no+1 USING "&&&&"
                 LET g_hraz_h.hraz01=l_hraz01[1,8],l_no
              END IF
           END IF	         	  
           
           SELECT hrat01,hrat01,hrat02,hrat03,hrat04,hrat05,hrat64,hrat06,hrat40,hrat41,hrat42,hrat21,hrat87,hrat88,hrat20
                INTO g_hraz[l_i].hraz43,g_hraz[l_i].hraz32,g_hraz[l_i].hrat02,g_hraz[l_i].hraz30,g_hraz[l_i].hraz07,g_hraz[l_i].hraz09,
                     g_hraz[l_i].hraz40,g_hraz[l_i].hraz33,g_hraz[l_i].hraz13,g_hraz[l_i].hraz15,
                     g_hraz[l_i].hraz11,g_hraz[l_i].hraz38,g_hraz[l_i].hrazud04,g_hraz[l_i].hrazud05,g_hraz[l_i].hrazud07
               FROM hrat_file
              WHERE hratid=g_hratid[l_i]
           
           SELECT hratid INTO l_hraz03 FROM hrat_file WHERE hrat01=g_hraz[l_ac].hraz43 
           SELECT hratid INTO l_hraz34 FROM hrat_file WHERE hrat01=g_hraz_h.hraz34
           SELECT hratid INTO l_hraz33 FROM hrat_file WHERE hrat01=g_hraz[l_ac].hraz33
 
           INSERT INTO hraz_file(hraz03,hraz01,hraz04,hraz19,hraz05,hraz31,hraz08,hrazud02,hrazud03,hrazud06,hraz10,
                                 hraz41,hraz12,hraz14,hraz16,hraz34,hraz39,hraz37,hraz17,
                                 hraz18,hraz23,hraz24,hraz27,hraz28,hraz25,hraz26,
                                 hraz43,hraz32,hraz30,hraz07,hrazud04,hrazud05,hrazud07,hraz09,hraz40,hraz33,hraz13,
                                 hraz15,hraz11,hraz38,
                                 hrazacti,hrazuser,hrazdate,hrazgrup,hrazoriu,hrazorig,hraz42,hraz44,hrazud01)    #mod by zhangbo130726             
                  VALUES(l_hraz03,g_hraz_h.hraz01,g_hraz_h.hraz04,g_hraz_h.hraz19,g_hraz_h.hraz05,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,g_hraz_h.hrazud06,g_hraz_h.hraz10,
                         g_hraz_h.hraz41,g_hraz_h.hraz12,
                         g_hraz_h.hraz14,g_hraz_h.hraz16,l_hraz34,g_hraz_h.hraz39,g_hraz_h.hraz37,g_hraz_h.hraz17,
                         g_hraz_h.hraz18,g_hraz_h.hraz23,g_hraz_h.hraz24,g_hraz_h.hraz27,
                         g_hraz_h.hraz28,g_hraz_h.hraz25,g_hraz_h.hraz26,
                         g_hraz[l_i].hraz43,g_hraz[l_i].hraz32,g_hraz[l_i].hraz30,g_hraz[l_i].hraz07,g_hraz[l_i].hrazud04,g_hraz[l_i].hrazud05,g_hraz[l_i].hrazud07,                                                              #FUN-A80148--mark--
                         g_hraz[l_i].hraz09,g_hraz[l_i].hraz40,l_hraz33,g_hraz[l_i].hraz13,
                         g_hraz[l_i].hraz15,g_hraz[l_i].hraz11,g_hraz[l_i].hraz38,
                         'Y',g_user,g_today,g_grup,g_user,g_grup,'N',g_hraz_h.hraz44,g_hraz_h.hrazud01)                             #mod by zhangbo130726
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hraz_file",g_hraz_h.hraz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK              #FUN-680010

           ELSE  
#              LET g_rec_b=g_rec_b+1    
#              DISPLAY g_rec_b TO FORMONLY.cn2     
              COMMIT WORK  
           END IF
      END FOR      

      EXIT WHILE
   END WHILE
   
   CLOSE WINDOW q006_dd 
END FUNCTION

FUNCTION i016_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i016_get_items_pre FROM l_sql
       DECLARE i016_get_items CURSOR FOR i016_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i016_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items
END FUNCTION

FUNCTION q006_dd_i(p_cmd)
DEFINE  p_cmd             LIKE type_file.chr1
DEFINE  l_num,l_n         LIKE type_file.num5
DEFINE  l_hraa12          LIKE hraa_file.hraa12
DEFINE  l_hrao02          LIKE hrao_file.hrao02
DEFINE  l_hras04          LIKE hras_file.hras04
DEFINE  l_hrai04          LIKE hrai_file.hrai04
DEFINE  l_hraf02          LIKE hraf_file.hraf02
DEFINE  l_hraz34_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz24_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz26_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz28_desc     LIKE hrat_file.hrat02
DEFINE l_hrap01     LIKE hrap_file.hrap01,
       l_hrap05     LIKE hrap_file.hrap05
         
   IF s_shut(0) THEN
      RETURN
   END IF
   	
   DISPLAY BY NAME g_hraz_h.hraz04,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,
                   g_hraz_h.hraz10,g_hraz_h.hraz12,g_hraz_h.hraz14,
                   g_hraz_h.hraz34,g_hraz_h.hrazud06,g_hraz_h.hraz17,g_hraz_h.hraz19,
                   g_hraz_h.hraz05,g_hraz_h.hraz41,g_hraz_h.hraz16,
                   g_hraz_h.hraz39,g_hraz_h.hraz37,g_hraz_h.hraz18,
                   g_hraz_h.hraz23,g_hraz_h.hraz24,g_hraz_h.hraz27,
                   g_hraz_h.hraz28,g_hraz_h.hraz25,g_hraz_h.hraz26,
                   g_hraz_h.hraz44,g_hraz_h.hrazud01
                           
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hraz_h.hraz04,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,
                 g_hraz_h.hraz10,g_hraz_h.hraz12,g_hraz_h.hraz14,
                 g_hraz_h.hraz34,g_hraz_h.hrazud06,g_hraz_h.hraz19,g_hraz_h.hraz05,
                 g_hraz_h.hraz41,g_hraz_h.hraz16,g_hraz_h.hraz39,
                 g_hraz_h.hraz17,g_hraz_h.hraz44,g_hraz_h.hrazud01
      WITHOUT DEFAULTS 
      
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
         #mark by nihuan 20160902

         IF p_cmd='u' THEN
         	  LET l_n=0

         END IF	  	 	 
         	  	      
      
      AFTER FIELD hraz31
         IF NOT cl_null(g_hraz_h.hraz31) THEN 
            LET l_num = 0        
            SELECT COUNT(*) INTO l_num FROM hraa_file WHERE hraa01 = g_hraz_h.hraz31
                                                        AND hraaacti='Y'

            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01= g_hraz_h.hraz31
                                                         AND hraaacti='Y' 
            DISPLAY l_hraa12 TO hraa12
            CALL cl_set_comp_entry("hraz08,hraz10",TRUE)
         ELSE
             CALL cl_set_comp_entry("hraz08,hraz10",FALSE)
         	  LET g_hraz_h.hraz08=''
         	  DISPLAY BY NAME g_hraz_h.hraz08   
         END IF
      
      #BEFORE FIELD hraz08
      #   IF NOT cl_null(g_hraz_h.hraz31) THEN
      #   	  CALL cl_set_comp_entry("hraz08",TRUE)
      #   ELSE
      #   	  CALL cl_set_comp_entry("hraz08",FALSE)
      #   END IF
         		  	  
      AFTER FIELD hraz08
         IF NOT cl_null(g_hraz_h.hraz08) THEN
            LET l_num = 0
            SELECT COUNT(*) INTO l_num FROM hrao_file WHERE hrao00 = g_hraz_h.hraz31
                                                        AND hrao01 = g_hraz_h.hraz08
                                                        AND hraoacti = 'Y'

            	 	
            SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01= g_hraz_h.hraz08
            DISPLAY l_hrao02 TO hrao02
            CALL cl_set_comp_entry("hraz10",TRUE)
         ELSE
            CALL cl_set_comp_entry("hraz10",FALSE)
         	  LET g_hraz_h.hraz10=''
         	  DISPLAY BY NAME g_hraz_h.hraz10   
         END IF
      
      #BEFORE FIELD hraz10
      #   IF NOT cl_null(g_hraz_h.hraz08) THEN
      #   	  CALL cl_set_comp_entry("hraz10",TRUE)
      #   ELSE
      #   	  CALL cl_set_comp_entry("hraz10",FALSE)
      #   END IF
      

      AFTER FIELD hrazud06
        IF NOT cl_null(g_hraz_h.hrazud06) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='313' AND hrag06=g_hraz_h.hrazud06
          IF l_n = 0 THEN
             CALL cl_err(g_hraz_h.hrazud06,'aap990',1)
             NEXT FIELD hrazud06
          END IF
        END IF


      AFTER FIELD hrazud02
         IF NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02!='-' THEN
            CALL i016_hrazud02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_hraz_h.hrazud02,g_errno,0)
               NEXT FIELD hrazud02
            END IF
         END IF

      AFTER FIELD hrazud03
         IF NOT cl_null(g_hraz_h.hrazud03) AND g_hraz_h.hrazud03!='-'  THEN
            CALL i016_hrazud03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_hraz_h.hrazud03,g_errno,0)
               NEXT FIELD hrazud03
            END IF
         END IF

                  	
      AFTER FIELD hraz10
         IF NOT cl_null(g_hraz_h.hraz10) THEN
         	  LET l_num = 0
         	  IF NOT cl_null(g_hraz_h.hrazud03) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hrazud03
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y'
            ELSE 
            IF NOT cl_null(g_hraz_h.hrazud02) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hrazud02
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y' 
            ELSE 
            IF NOT cl_null(g_hraz_h.hraz08) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hraz08
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y' 
                 END IF 
              END IF                                           
            END IF                                             
            IF l_num = 0 THEN
               CALL cl_err('ZHI WEI ERROR','!',0)
               NEXT FIELD hraz10
            END IF
            	
            SELECT hras04,hras06 INTO l_hras04,g_hraz_h.hraz41 
              FROM hras_file
             WHERE hras01=g_hraz_h.hraz10
            DISPLAY BY NAME g_hraz_h.hraz41
            DISPLAY l_hras04 TO hras04
         END IF
       
      BEFORE FIELD hraz12 
         IF cl_null(g_hraz_h.hraz12) THEN 
            LET g_hraz_h.hraz12='01'
            SELECT hrai04 INTO l_hrai04 FROM hrai_file 
         	   WHERE hrai03=g_hraz_h.hraz12
         	  DISPLAY BY NAME g_hraz_h.hraz12
         	  DISPLAY l_hrai04 TO hrai04
         END IF 
         	
      AFTER FIELD hraz12
         IF NOT cl_null(g_hraz_h.hraz12) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hrai_file 
         	   WHERE hrai03=g_hraz_h.hraz12
         	     AND hraiacti='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("WU CI CHENG BEN ZHONG XIN","!",0)
         	  	 NEXT FIELD hraz12
         	  END IF
         	  	
         	  SELECT hrai04 INTO l_hrai04 FROM hrai_file 
         	   WHERE hrai03=g_hraz_h.hraz12
         	  DISPLAY l_hrai04 TO hrai04
         END IF
         	
      AFTER FIELD hraz14
         IF NOT cl_null(g_hraz_h.hraz14) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hraf_file 
         	   WHERE hraf01=g_hraz_h.hraz14
         	     #AND hrafacti='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("WU CI QU YU ","!",0)
         	  	 NEXT FIELD hraz14
         	  END IF
         	  	
         	  SELECT hraf02 INTO l_hraf02 FROM hraf_file 
         	   WHERE hraf01=g_hraz_h.hraz14
         	  DISPLAY l_hraf02 TO hraf02
         END IF

      BEFORE FIELD hraz34
     #add by nihuan 20161114 for zhijie zhu guan ------------start---------------------
     IF NOT cl_null(g_hraz_h.hraz08) THEN                               #5
     IF NOT cl_null(g_hraz_h.hrazud03) THEN                              #4
           SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat88
           WHERE hrap07='Y'
             AND hrap01 = g_hraz_h.hrazud03
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
              WHERE hrat04=g_hraz_h.hraz08
                AND hrat88=g_hraz_h.hrazud03
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'
           END IF
             IF cl_null(g_hraz_h.hraz34) THEN

                SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw09=g_hraz_h.hrazud03
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'     
             END IF
          IF cl_null(g_hraz_h.hraz34) THEN
             IF NOT cl_null(g_hraz_h.hrazud02) THEN                              
                SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                 FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
                WHERE hrap07='Y'
                  AND hrap01 = g_hraz_h.hrazud02
               IF NOT cl_null(l_hrap01) THEN
                  SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                   WHERE hrat04=g_hraz_h.hraz08
                     AND hrat87=g_hraz_h.hrazud02
                     AND (hrat05=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                END IF
               IF cl_null(g_hraz_h.hraz34) THEN

                  SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                   WHERE hraw09=g_hraz_h.hrazud02
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
               END IF
              END IF      
          END IF  
          IF cl_null(g_hraz_h.hraz34) THEN
         	  IF NOT cl_null(g_hraz_h.hraz08) THEN                    #2
                 SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                   FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat04
                   WHERE hrap07='Y'
                   AND hrap01 = g_hraz_h.hraz08
                  IF NOT cl_null(l_hrap01) THEN                      #1
                    SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                     WHERE hrat04=g_hraz_h.hraz08
                       AND (hrat05=l_hrap05 OR HRAT07='Y')
                       AND HRAT77>=SYSDATE
                       AND hratconf='Y'
                  END IF                                              #1
                 IF cl_null(g_hraz_h.hraz34) THEN                            #1

                   SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                    WHERE hraw09=g_hraz_h.hraz08
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                 END IF                                               #1
              END IF  
          END IF                
     ELSE 
        IF NOT cl_null(g_hraz_h.hrazud02) THEN                              #3
           SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
           WHERE hrap07='Y'
             AND hrap01 = g_hraz_h.hrazud02
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
              WHERE hrat04=g_hraz_h.hraz08
                AND hrat87=g_hraz_h.hrazud02
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'
           END IF
             IF cl_null(g_hraz_h.hraz34) THEN

                SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw09=g_hraz_h.hrazud02
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'
             END IF
           ELSE 
              IF NOT cl_null(g_hraz_h.hraz08) THEN                    #2
                 SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                   FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat04
                   WHERE hrap07='Y'
                   AND hrap01 = g_hraz_h.hraz08
                  IF NOT cl_null(l_hrap01) THEN                      #1
                    SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                     WHERE hrat04=g_hraz_h.hraz08
                       AND (hrat05=l_hrap05 OR HRAT07='Y')
                       AND HRAT77>=SYSDATE
                       AND hratconf='Y'
                  END IF                                              #1
                 IF cl_null(g_hraz_h.hraz34) THEN                            #1

                   SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                    WHERE hraw09=g_hraz_h.hraz08
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                 END IF                                               #1
              END IF                                                  #2           
        END IF                                                        #3
     END IF                                                            #4
     END IF                                                           #5
       IF NOT cl_null(g_hraz_h.hraz34) THEN 
             SELECT hrat02 INTO l_hraz34_desc FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
               AND hratconf='Y'        	     
         	  DISPLAY l_hraz34_desc,g_hraz_h.hraz34 TO hraz34_desc,hraz34
       END IF 
     #add by nihuan 20161114 for zhijie zhu guan ------------end-----------------------         
               	
      AFTER FIELD hraz34
         IF NOT cl_null(g_hraz_h.hraz34) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
         	     AND hratconf='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("WU CI YUAN GONG ","!",0)
         	  	 NEXT FIELD hraz34
         	  END IF
         	  	
         	  SELECT hrat02 INTO l_hraz34_desc FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
               AND hratconf='Y'        	     
         	  DISPLAY l_hraz34_desc TO hraz34_desc
         END IF
         	   	   		      	 	     	    	  		  	     	
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hraz31)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.default1 = g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz31 
               DISPLAY BY NAME g_hraz_h.hraz31 
               NEXT FIELD hraz31
               
            WHEN INFIELD(hrazud06)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hraz_h.hrazud06
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud06
              DISPLAY BY NAME g_hraz_h.hrazud06
              NEXT FIELD hrazud06
              
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
               
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
                        WHEN INFIELD(hrazud02)
            {
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hrazud02
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
               DISPLAY BY NAME g_hraz_h.hrazud02
               NEXT FIELD hrazud02}
             CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hraz31) AND g_hraz_h.hraz31!='-' THEN
                 CASE
                   WHEN NOT cl_null(g_hraz_h.hraz08) AND g_hraz_h.hraz08!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.arg3 = g_hraz_h.hraz08
                    WHEN cl_null(g_hraz_h.hraz08) OR g_hraz_h.hraz08='-'
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '2'
              END IF
              LET g_qryparam.default1 = g_hraz_h.hrazud02
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
              DISPLAY BY NAME g_hraz_h.hrazud02
              NEXT FIELD hrazud02
           { CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hrazud02) THEN
                IF NOT cl_null(g_hraz_h.hraz08) THEN
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.arg3 = g_hraz_h.hraz08
                  LET g_qryparam.form = "cq_hrao01_0"
                ELSE
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.form = "cq_hrao01_0_1"
                END IF
              ELSE
                IF NOT cl_null(g_hraz_h.hraz08) THEN
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.arg3 = g_hraz_h.hraz08
                  LET g_qryparam.form = "cq_hrao01_1"
                ELSE
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.form = "cq_hrao01_1_1"

                 END IF
              END IF

              LET g_qryparam.default1 = g_hraz_h.hrazud02
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
              DISPLAY BY NAME g_hraz_h.hrazud02
              NEXT FIELD hrazud02}

              #############################################3
            WHEN INFIELD(hrazud03)

             CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hraz31) AND g_hraz_h.hraz31!='-' THEN
                 CASE
                   WHEN NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz_h.hrazud02
                   WHEN NOT cl_null(g_hraz_h.hraz08) AND g_hraz_h.hraz08!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz_h.hraz08
                    WHEN cl_null(g_hraz_h.hraz08) OR g_hraz_h.hraz08='-'
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '3'
              END IF
              LET g_qryparam.default1 = g_hraz_h.hrazud03
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud03
              DISPLAY BY NAME g_hraz_h.hrazud03
              NEXT FIELD hrazud03   
#            WHEN INFIELD(hraz10)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_hrap01"
#               LET g_qryparam.default1 = g_hraz_h.hraz10
#               LET g_qryparam.arg1 =g_hraz_h.hraz08
#               CALL cl_create_qry() RETURNING g_hraz_h.hraz10 
#               DISPLAY BY NAME g_hraz_h.hraz10
#               NEXT FIELD hraz10
#               
            WHEN INFIELD(hraz10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrap01"
               LET g_qryparam.default1 = g_hraz_h.hraz10
              IF NOT cl_null(g_hraz_h.hrazud03) AND g_hraz_h.hrazud03 != '-' THEN
                LET g_qryparam.arg1 = g_hraz_h.hrazud03
              ELSE
                IF NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02 != '-' THEN
                  LET g_qryparam.arg1 = g_hraz_h.hrazud02
                ELSE
                  LET g_qryparam.arg1 =g_hraz_h.hraz08
                END IF
              END IF
               CALL cl_create_qry() RETURNING g_hraz_h.hraz10
               DISPLAY BY NAME g_hraz_h.hraz10
               NEXT FIELD hraz10
               
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
               
            WHEN INFIELD(hraz12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrai03"
               LET g_qryparam.default1 = g_hraz_h.hraz12
               CALL cl_create_qry() RETURNING g_hraz_h.hraz12 
               DISPLAY BY NAME g_hraz_h.hraz12
               NEXT FIELD hraz12
               
            WHEN INFIELD(hraz14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraf01"
               LET g_qryparam.default1 = g_hraz_h.hraz14
               CALL cl_create_qry() RETURNING g_hraz_h.hraz14 
               DISPLAY BY NAME g_hraz_h.hraz14
               NEXT FIELD hraz14
               
            WHEN INFIELD(hraz34)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.default1 = g_hraz_h.hraz34
               CALL cl_create_qry() RETURNING g_hraz_h.hraz34 
               DISPLAY BY NAME g_hraz_h.hraz34
               NEXT FIELD hraz34
                     
            OTHERWISE EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about   
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help()
   END INPUT
END FUNCTION

FUNCTION q006_litui()
DEFINE p_row,p_col,l_i,l_n         LIKE type_file.num5
DEFINE l_hrbh   RECORD LIKE hrbh_file.*
DEFINE l_msg    STRING


   OPEN WINDOW q006_lt_w AT p_row,p_col
     WITH FORM "ghr/42f/ghrq006_lt"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()
   CALL cl_set_combo_items("hrbh02",NULL,NULL)
   CALL i025_get_items('311') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrbh02",l_name,l_items)


    CLEAR FORM                                   #
    INITIALIZE g_hrbh.* LIKE hrbh_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbh.hrbh02 = '1'
        LET g_hrbh.hrbh09 = 'N'
        LET g_hrbh.hrbh03 = g_today
        LET g_hrbh.hrbhuser = g_user
        LET g_hrbh.hrbhoriu = g_user
        LET g_hrbh.hrbhorig = g_grup
        LET g_hrbh.hrbhgrup = g_grup               #
        LET g_hrbh.hrbhdate = g_today
        LET g_hrbh.hrbhconf = '1'
        CALL i025_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrbh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        LET l_hrbh.* = g_hrbh.*
        
        FOR l_i=1 TO g_sel_b
        SELECT hratid,hrat01 INTO l_hrbh.hrbh01,g_hrbh.hrbh01 FROM hrat_file
         WHERE hratid=g_hratid[l_i]
           AND hratacti='Y'
           AND hratconf='Y'
        LET l_n=0
        SELECT COUNT(*) INTO l_n FROM hrat_file LEFT JOIN HRAD_FILE ON HRAD02=HRAT19 WHERE hratid=g_hratid[l_i]
                                                      AND hratconf='Y' AND HRAD01 <> '003'
        IF l_n=0 THEN
        	 LET l_msg=g_hrbh.hrbh01,' 此员工不存在或未审核或不在职' 
           CALL cl_err(l_msg,'!',1)
           CONTINUE FOR 
        ELSE 
        
        IF cl_null(l_hrbh.hrbh11) OR cl_null(l_hrbh.hrbh02) OR cl_null(l_hrbh.hrbh03) OR cl_null(l_hrbh.hrbh04) THEN 
           EXIT FOR 
        END IF         

        INSERT INTO hrbh_file VALUES(l_hrbh.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbh_file",g_hrbh.hrbh01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        END IF 
        END FOR 
        EXIT WHILE
    END WHILE
    CLOSE WINDOW q006_lt_w
END FUNCTION

FUNCTION i025_i(p_cmd)

   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_input          LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_hrat02         LIKE hrat_file.hrat02
   DEFINE l_hrat04         LIKE hrat_file.hrat04
   DEFINE l_hrat04_desc    LIKE hrao_file.hrao02
   DEFINE l_hrat05         LIKE hrat_file.hrat05
   DEFINE l_hrat05_desc    LIKE hrap_file.hrap06
   DEFINE l_hrat17         LIKE hrat_file.hrat17
   DEFINE l_hrat17_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat22         LIKE hrat_file.hrat22
   DEFINE l_hrat22_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat06         LIKE hrat_file.hrat06
   DEFINE l_hrat06_desc    LIKE hrat_file.hrat02
   DEFINE l_hrat19         LIKE hrat_file.hrat19
   DEFINE l_hrad03_desc    LIKE hrad_file.hrad03
   DEFINE l_hrat42         LIKE hrat_file.hrat42
   DEFINE l_hrat42_desc    LIKE hrai_file.hrai04
   DEFINE l_hrat25         LIKE hrat_file.hrat25
   DEFINE l_hrbh05_desc    LIKE hrag_file.hrag07
   DEFINE l_hrbh06_desc    LIKE hrad_file.hrad03
   DEFINE l_sql         STRING

   DISPLAY BY NAME
      g_hrbh.hrbh02,g_hrbh.hrbh03,g_hrbh.hrbh04,
      g_hrbh.hrbh05,g_hrbh.hrbh06,g_hrbh.hrbh07,g_hrbh.hrbh08,g_hrbh.hrbh09,
      g_hrbh.hrbh11,g_hrbh.hrbh12,
      g_hrbh.hrbhconf,g_hrbh.hrbhud02
#      ,
#      g_hrbh.hrbhud01,g_hrbh.hrbhud02,g_hrbh.hrbhud03,g_hrbh.hrbhud04,
#      g_hrbh.hrbhud05,g_hrbh.hrbhud06,g_hrbh.hrbhud07,g_hrbh.hrbhud08,
#      g_hrbh.hrbhud09,g_hrbh.hrbhud10,g_hrbh.hrbhud11,g_hrbh.hrbhud12,
#      g_hrbh.hrbhud13,g_hrbh.hrbhud14,g_hrbh.hrbhud15

   INPUT BY NAME
      g_hrbh.hrbh02,g_hrbh.hrbh03,g_hrbh.hrbh04,
      g_hrbh.hrbh05,g_hrbh.hrbh06,g_hrbh.hrbh07,g_hrbh.hrbh08,g_hrbh.hrbh09,
      g_hrbh.hrbh11,g_hrbh.hrbhconf,g_hrbh.hrbhud02
#      ,
#      g_hrbh.hrbhud01,g_hrbh.hrbhud02,g_hrbh.hrbhud03,g_hrbh.hrbhud04,
#      g_hrbh.hrbhud05,g_hrbh.hrbhud06,g_hrbh.hrbhud07,g_hrbh.hrbhud08,
#      g_hrbh.hrbhud09,g_hrbh.hrbhud10,g_hrbh.hrbhud11,g_hrbh.hrbhud12,
#      g_hrbh.hrbhud13,g_hrbh.hrbhud14,g_hrbh.hrbhud15
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i025_set_entry(p_cmd)
          CALL i025_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          LET g_hrbh_t.*=g_hrbh.*   #add by nihuan 20160805

#      AFTER FIELD hrbh01
#         IF NOT cl_null(g_hrbh.hrbh01) THEN
#            LET l_n=0
#            SELECT COUNT(*) INTO l_n FROM hrat_file LEFT JOIN HRAD_FILE ON HRAD02=HRAT19 WHERE hrat01=g_hrbh.hrbh01
#                                                      AND hratconf='Y' AND HRAD01 <> '003'
#            IF l_n=0 THEN
#               CALL cl_err('CI YUAN GONG BU CUN ZAI HUO BU ZAI ZHI HUO WEI SHEN HE','!',1)
#               NEXT FIELD hrbh01
#            END IF
#
#            SELECT a.hrat02,a.hrat04,b.hrao02,a.hrat05,c.hras04,a.hrat06,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,a.hrat42,h.hrai04,a.hrat25
#              INTO l_hrat02,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat06,l_hrat06_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat19,l_hrad03_desc,l_hrat42,l_hrat42_desc,l_hrat25
#            FROM hrat_file a
#            LEFT JOIN hrao_file b ON hrao01=hrat04
#            LEFT JOIN hras_file c ON hras01=hrat05
#            LEFT JOIN hrat_file d ON d.hrat01=a.hrat06
#            LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
#            LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
#            LEFT JOIN hrad_file g ON g.hrad02=a.hrat19
#            LEFT JOIN hrai_file h ON h.hrai03=a.hrat42
#            WHERE a.hrat01=g_hrbh.hrbh01 AND a.hratconf='Y'
#
#            DISPLAY l_hrat02 TO hrat02
#            DISPLAY l_hrat04 TO hrat04
#            DISPLAY l_hrat04_desc TO hrat04_desc
#            DISPLAY l_hrat05 TO hrat05
#            DISPLAY l_hrat05_desc TO hrat05_desc
#            DISPLAY l_hrat06 TO hrat06
#            DISPLAY l_hrat06_desc TO hrat06_desc
#            DISPLAY l_hrat17 TO hrat17
#            DISPLAY l_hrat17_desc TO hrat17_desc
#            DISPLAY l_hrat22 TO hrat22
#            DISPLAY l_hrat22_desc TO hrat22_desc
#            DISPLAY l_hrat19 TO hrbh12
#            DISPLAY l_hrad03_desc TO hrbh12_desc
#            LET g_hrbh.hrbh12=l_hrat19
#            DISPLAY l_hrat42 TO hrat42
#            DISPLAY l_hrat42_desc TO hrat42_desc
#            DISPLAY l_hrat25 TO hrat25
#
#         END IF


      AFTER FIELD hrbh05
         IF g_hrbh.hrbh05 IS NOT NULL THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01 = '310'
                                                      AND hrag06 = g_hrbh.hrbh05
            IF l_n = 0 THEN
               CALL cl_err('WU CI LI TUI YUAN YIN ','!',0)
               LET g_hrbh.hrbh05 = g_hrbh_t.hrbh05
               DISPLAY BY NAME g_hrbh.hrbh05
               NEXT FIELD hrbh05
            END IF

            SELECT hrag07 INTO l_hrbh05_desc FROM hrag_file
             WHERE hrag01='310'
               AND hrag06=g_hrbh.hrbh05
            DISPLAY l_hrbh05_desc TO hrbh05_desc
         END IF

      AFTER FIELD hrbh06
         IF NOT cl_null(g_hrbh.hrbh06) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrad_file
             WHERE hrad01='003'
               AND hrad02=g_hrbh.hrbh06
               AND hradacti='Y'
            IF l_n=0 THEN
               CALL cl_err('WU CI YUAN GONG ZHUANG TAI','!',0)
               NEXT FIELD hrbh06
            END IF
            SELECT hrad03 INTO l_hrbh06_desc FROM hrad_file
             WHERE hrad02=g_hrbh.hrbh06
            DISPLAY l_hrbh06_desc TO hrbh06_desc
         END IF
      AFTER FIELD hrbh11
         IF cl_null(g_hrbh.hrbh11) THEN
            CALL cl_err('ZUI HOU GONG ZUO RI BU KE WEI KONG !','!',0)
            NEXT FIELD hrbh11
         END IF
         IF NOT cl_null(g_hrbh.hrbh11) AND NOT cl_null(g_hrbh.hrbh03) THEN
           IF g_hrbh.hrbh11<g_hrbh.hrbh03 THEN
            CALL cl_err('ZUI HOU GONG ZUO RI BI XU DA YU SHEN QING RI QI','!',0)
            NEXT FIELD hrbh03
          END IF
         END IF
      AFTER FIELD hrbh04
         IF NOT cl_null(g_hrbh.hrbh04) AND NOT cl_null(g_hrbh.hrbh03) THEN
          IF g_hrbh.hrbh04<g_hrbh.hrbh03 THEN
            CALL cl_err('YU JI LI ZHI RI BI XU DA YU SHEN QING RI QI','!',0)
            NEXT FIELD hrbh04
          END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF


      ON ACTION controlp
        CASE
           WHEN INFIELD(hrbh01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat02_002"
              LET g_qryparam.default1 = g_hrbh.hrbh01
              #LET g_qryparam.where =" hrat19 NOT LIKE '3%' "
              CALL cl_create_qry() RETURNING g_hrbh.hrbh01
              DISPLAY BY NAME g_hrbh.hrbh01
              NEXT FIELD hrbh01

           WHEN INFIELD(hrbh05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrbh.hrbh05
              LET g_qryparam.arg1 = '310'
              CALL cl_create_qry() RETURNING g_hrbh.hrbh05
              DISPLAY BY NAME g_hrbh.hrbh05
              NEXT FIELD hrbh05

           WHEN INFIELD(hrbh06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrbh.hrbh06
              LET g_qryparam.where = " hrad01='003' "
              CALL cl_create_qry() RETURNING g_hrbh.hrbh06
              DISPLAY BY NAME g_hrbh.hrbh06
              NEXT FIELD hrbh06

           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                       
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

FUNCTION q006_heimd()
DEFINE l_i   LIKE type_file.num5

   OPEN WINDOW q006_hm_w WITH FORM "ghr/42f/ghrq006_hm"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)             
   CALL cl_ui_init()      

    CLEAR FORM                                   
    INITIALIZE g_hrbj.* LIKE hrbj_file.*
    LET g_hrat01=''
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbj.hrbj17 = g_today       #add by zhangbo130904
        LET g_hrbj.hrbjuser = g_user
        LET g_hrbj.hrbjoriu = g_user 
        LET g_hrbj.hrbjorig = g_grup 
        LET g_hrbj.hrbjgrup = g_grup              
        LET g_hrbj.hrbjdate = g_today
        LET g_hrbj.hrbjacti = 'Y'
        SELECT TO_CHAR(MAX(hrbj01)+1,'fm999999999999') INTO g_hrbj.hrbj01 FROM hrbj_file 
         WHERE substr(hrbj01,1,8) LIKE to_char(sysdate,'yyyyMMdd')
        IF g_hrbj.hrbj01 IS NULL THEN 
        	 LET g_hrbj.hrbj01 = g_today USING "yyyymmdd"||'0001'
        END IF 
        CALL i027_i("a")                        
        IF INT_FLAG THEN                        
            INITIALIZE g_hrbj.* TO NULL
            LET g_hrat01=''
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
      FOR l_i=1 TO g_sel_b
        SELECT hrat01 INTO g_hrat01 FROM hrat_file WHERE hratid=g_hratid[l_i]
        

        CALL i027_hrat01('a')
        IF NOT cl_null(g_errno) THEN
           CALL cl_err('hrbj01:',g_errno,1)
           LET g_hrbj.hrbj02 = NULL
           LET g_hrat01 = NULL
           DISPLAY BY NAME g_hrbj.hrbj02,g_hrat01
           CONTINUE FOR 
        ELSE 
        
        INSERT INTO hrbj_file VALUES(g_hrbj.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbj_file",g_hrbj.hrbj01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660151
            CONTINUE WHILE
        ELSE
            SELECT hrbj01 INTO g_hrbj.hrbj01 FROM hrbj_file WHERE hrbj01 = g_hrbj.hrbj01
        END IF
        END IF
        
      END FOR  
        
        EXIT WHILE
    END WHILE
    CLOSE WINDOW q006_hm_w
END FUNCTION   

FUNCTION i027_hrat01(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrat02   LIKE hrat_file.hrat02
   DEFINE l_hrat03   LIKE hrat_file.hrat04
   DEFINE l_hrat04   LIKE hrat_file.hrat04
   DEFINE l_hrat05   LIKE hrat_file.hrat05
   DEFINE l_hrat03_name   LIKE type_file.chr100
   DEFINE l_hrat04_name   LIKE type_file.chr100
   DEFINE l_hrat05_name   LIKE type_file.chr100
   DEFINE l_hrat42s  LIKE hrat_file.hrat42
   DEFINE l_hrat25   LIKE hrat_file.hrat25
   DEFINE l_hratacti LIKE hrat_file.hratacti
   DEFINE l_hratid   LIKE hrat_file.hratid
 
   LET g_errno=''
   CASE p_cmd 
      WHEN 'd' 
         SELECT hrat03,hrat04,hrat05,hratacti,
                hratid
           INTO l_hrat03,l_hrat04,l_hrat05,l_hratacti,
                g_hrbj.hrbj02
           FROM hrat_file
          WHERE hrat01 = g_hrat01
            AND hratconf = 'Y'
            AND ROWNUM = 1
      WHEN 'a' 
         SELECT hrat03,hrat04,hrat05,hratacti,
                hratid,hrat02,
                hrat17,hrat15,hrat12,hrat13,
                hrat29,hrat24,hrat18,hrat45,
                hrat46,hrat49,hrat51,hrat22,
                hrat23
           INTO l_hrat03,l_hrat04,l_hrat05,l_hratacti,
                g_hrbj.hrbj02,g_hrbj.hrbj03,
                g_hrbj.hrbj07,g_hrbj.hrbj06,g_hrbj.hrbj04,
                g_hrbj.hrbj05,g_hrbj.hrbj08,g_hrbj.hrbj09,
                g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
                g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,
                g_hrbj.hrbj16
           FROM hrat_file
          WHERE hrat01 = g_hrat01
            AND hratconf = 'Y'
            AND ROWNUM = 1
   END CASE
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-031'
                                LET l_hrat02=NULL  LET l_hrat04=NULL  LET l_hrat05=NULL
       WHEN l_hratacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      CALL i027_hrat03(l_hrat03) RETURNING l_hrat03_name
      CALL i027_hrat04(l_hrat04) RETURNING l_hrat04_name
      CALL i027_hrat05(l_hrat04,l_hrat05) RETURNING l_hrat05_name
      DISPLAY BY NAME g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj04,g_hrbj.hrbj05,
                      g_hrbj.hrbj06,g_hrbj.hrbj07,g_hrbj.hrbj08,g_hrbj.hrbj09,
                      g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,g_hrbj.hrbj13,
                      g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16
      DISPLAY l_hrat03 TO FORMONLY.hrat03
      DISPLAY l_hrat04 TO FORMONLY.hrat04
      DISPLAY l_hrat05 TO FORMONLY.hrat05
      DISPLAY l_hrat03_name TO FORMONLY.hrat03_name
      DISPLAY l_hrat04_name TO FORMONLY.hrat04_name
      DISPLAY l_hrat05_name TO FORMONLY.hrat05_name
   END IF
END FUNCTION

FUNCTION i027_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_hrat01,
      g_hrbj.hrbj01,g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj04,g_hrbj.hrbj05,g_hrbj.hrbj06,
      g_hrbj.hrbj07,g_hrbj.hrbj08,g_hrbj.hrbj09,g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
      g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16,
      g_hrbj.hrbj17,g_hrbj.hrbj18,                                            #add by zhangbo130904
      g_hrbj.hrbjuser,g_hrbj.hrbjgrup,g_hrbj.hrbjmodu,g_hrbj.hrbjdate,g_hrbj.hrbjacti,
      g_hrbj.hrbjoriu,g_hrbj.hrbjorig,
      g_hrbj.hrbjud02,g_hrbj.hrbjud03,g_hrbj.hrbjud04,g_hrbj.hrbjud05,g_hrbj.hrbjud06,
      g_hrbj.hrbjud07,g_hrbj.hrbjud08,g_hrbj.hrbjud09,g_hrbj.hrbjud10,g_hrbj.hrbjud11,
      g_hrbj.hrbjud12,g_hrbj.hrbjud13,g_hrbj.hrbjud14,g_hrbj.hrbjud15,g_hrbj.hrbjud01     # add by hourf   13/05/16
 
   INPUT BY NAME
      g_hrbj.hrbj01,g_hrat01,g_hrbj.hrbj02,g_hrbj.hrbj03,g_hrbj.hrbj07,g_hrbj.hrbj06,g_hrbj.hrbj04,
      g_hrbj.hrbj05,g_hrbj.hrbj08,g_hrbj.hrbj09,g_hrbj.hrbj10,g_hrbj.hrbj11,g_hrbj.hrbj12,
      g_hrbj.hrbj13,g_hrbj.hrbj14,g_hrbj.hrbj15,g_hrbj.hrbj16,
      g_hrbj.hrbj17,g_hrbj.hrbj18                                            #add by zhangbo130904

      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE

      AFTER FIELD hrbj17
         IF cl_null(g_hrbj.hrbj17) THEN
            CALL cl_err('RI QI BU NENG WEI KONG','!',1)
            NEXT FIELD hrbj17
         END IF
         

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
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
 
FUNCTION i025_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrbh02 LIKE  hrbh_file.hrbh02
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT SUBSTR(hrag06,LENGTH(hrag06),1) ,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i001_get_items_pre FROM l_sql
       DECLARE i001_get_items CURSOR FOR i001_get_items_pre
       LET l_name=''
       LET l_items=''
       FOREACH i001_get_items INTO l_hrbh02,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name = l_hrbh02
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrbh02 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       RETURN l_name,l_items
END FUNCTION

FUNCTION i027_hrat03(p_hrat03) 
 DEFINE p_hrat03      LIKE hrat_file.hrat03
   DEFINE l_hraa02    LIKE hraa_file.hraa02 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 

   SELECT hraa02,hraaacti INTO l_hraa02,l_hraaacti FROM hraa_file
    WHERE hraa01=p_hrat03
#   CASE
#       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
#                                LET l_hraa02=NULL
#  
#       WHEN l_hraaacti='N'      LET g_errno='9028'
#       OTHERWISE
#            LET g_errno=SQLCA.sqlcode USING '------'
#   END CASE
    RETURN l_hraa02
END FUNCTION

FUNCTION i027_hrat04(p_hrat04)
   DEFINE p_hrat04    LIKE hrat_file.hrat04
   DEFINE l_hrao02    LIKE hrao_file.hrao02
   DEFINE l_hraoacti  LIKE hrao_file.hraoacti

   LET g_errno=''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti FROM hrao_file
    WHERE hrao01=p_hrat04 
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-009'
  #                             LET l_hrao02=NULL

  #    WHEN l_hraoacti='N'       LET g_errno='9028'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_hrao02
END FUNCTION


FUNCTION i027_hrat05(p_hrat04,p_hrat05)
   DEFINE p_hrat04    LIKE hrat_file.hrat04
   DEFINE p_hrat05    LIKE hrat_file.hrat05
   DEFINE l_hrap06    LIKE hrap_file.hrap06
   DEFINE l_hrapacti  LIKE hrap_file.hrapacti

   LET g_errno=''
   SELECT hrap06,hrapacti INTO l_hrap06,l_hrapacti FROM hrap_file
    WHERE hrap05=p_hrat05 AND hrap01 = p_hrat04
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='ghr-010'
  #                             LET l_hrap06=NULL

  #    WHEN l_hrapacti='N'       LET g_errno='9028'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
   RETURN l_hrap06 
END FUNCTION

FUNCTION i016_hrazud02(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz_h.hrazud02
      AND hraoud05='2'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-270'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz_h.hrazud02) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO hrao02_1
   END IF
END FUNCTION


FUNCTION i016_hrazud03(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz_h.hrazud03
      AND hraoud05='3'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-271'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR  cl_null(g_errno) THEN
      IF cl_null(g_hraz_h.hrazud03) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO hrao02_2
   END IF
END FUNCTION


FUNCTION i016_hrazud04(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz[l_ac].hrazud04
      AND hraoud05='2'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-270'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz[l_ac].hrazud04) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO g_hraz[l_ac].hrazud04_desc
   END IF
END FUNCTION


FUNCTION i016_hrazud05(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz[l_ac].hrazud05
      AND hraoud05='3'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-271'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz[l_ac].hrazud05) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO g_hraz[l_ac].hrazud05_desc
   END IF
END FUNCTION

PRIVATE FUNCTION i025_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbh01",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i025_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hrbh01",FALSE)
   END IF
END FUNCTION



