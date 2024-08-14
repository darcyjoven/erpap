schema ds 
 
   DEFINE g_channel    base.Channel 
   DEFINE g_str        STRING 
   DEFINE g_tab        CHAR(100)
   DEFINE g_tabname    STRING
   DEFINE g_db         STRING
   DEFINE g_type       STRING
 
MAIN 
   DEFINE tok base.StringTokenizer
   DEFINE ls_prod STRING
   
   LET g_db = ARG_VAL(1)
   LET g_type = ARG_VAL(2)

   CASE
      WHEN g_type = "all"
         DATABASE ds
         DECLARE catch_data_cr CURSOR FOR select name from sysobjects where xtype='U' order by name
         FOREACH catch_data_cr INTO g_tab
            LET g_tabname = g_tab CLIPPED
            IF g_tabname.getIndexOf("_file",2) THEN
               LET g_tabname = g_tabname.subString(1,g_tabname.getIndexOf("_file",2)-1)
                  CALL build_4gl()
            END IF
         END FOREACH
   
      WHEN g_type = "sys"
         LET ls_prod = "gab,gac,gae,gaj,gak,gal,gao,gap,gaq,gat,gau,gav,gaw,gax,gay,gaz,gba,gbb,gbc,gbd,gbf,gbk,gbl,gbm,gbn,gbp,gbs,gbt,gbu,gca,gcb,gcc,gcd,gce,gcf,gcg,gch,gci,gcj,gck,gcm,gcn,gco,gcp,gcq,gcr,gcw,gcx,gcy,gcz,gda,gdb,gdc,gdd,gde,gdf,gdg,gdh,gdi,gdj,gdk,gdm,gee,waa,wad,wah,wca,wcd,wgf,wsd,wsr,zaa,zai,zaw,ze,zm,zy,zz"
         LET tok = base.StringTokenizer.create(ls_prod,",")
         WHILE tok.hasMoreTokens()
           LET g_tabname = tok.nextToken()
           LET g_tab = g_tabname,"_file"
           CALL build_4gl()
         END WHILE

      WHEN g_type IS NULL OR g_type = " " OR g_type.getIndexOf("_file",1)
         DISPLAY " "
         DISPLAY "Usage(s): fglrun cp_data_from_ora database syc_tab1[,syc_tab2] "
         EXIT CASE

      OTHERWISE
         LET tok = base.StringTokenizer.create(g_type,",")
         WHILE tok.hasMoreTokens()
           LET g_tabname = tok.nextToken()
           LET g_tab = g_tabname,"_file"
           CALL build_4gl()
         END WHILE
   END CASE 

END MAIN 

FUNCTION build_4gl()
   LET g_channel = base.Channel.create() 
   CALL g_channel.openFile( "temp1.4gl", "w" )
   CALL g_channel.setDelimiter("") 
   CALL generate_prog()
   CALL g_channel.close()

   RUN "rcs temp1"
   RUN "fglrun temp1"
END FUNCTION

FUNCTION generate_prog()

   LET g_str = ""
   LET g_str = g_str,"\n   SCHEMA ds"
   
   LET g_str = g_str,"\n   MAIN "                                                          
   LET g_str = g_str,"\n      DEFINE g_",g_tabname," DYNAMIC ARRAY OF RECORD LIKE ",g_tabname,"_file.* "       
   LET g_str = g_str,"\n      DEFINE li_cnt INTEGER "
   LET g_str = g_str,"\n      DEFINE li_pos INTEGER "
   LET g_str = g_str,"\n      DEFINE ls_tmp STRING "

   LET g_str = g_str,"\n      WHENEVER ERROR CONTINUE "                                    

   LET g_str = g_str,"\n      DATABASE top30_",g_db                                          

   LET g_str = g_str,"\n      LET li_cnt = 1 "                                             
   LET g_str = g_str,"\n      DECLARE catch_data_cr CURSOR FOR SELECT * FROM ",g_tabname,"_file   "  
   LET g_str = g_str,"\n      FOREACH catch_data_cr INTO g_",g_tabname,"[li_cnt].* "                 
   LET g_str = g_str,"\n         IF li_cnt MOD 5 = 0 THEN "                                
   LET g_str = g_str,"\n            DISPLAY 'Row:',li_cnt,' ok!' "                         
   LET g_str = g_str,"\n         END IF "                                                  
   LET g_str = g_str,"\n         LET li_cnt = li_cnt + 1 "                                 
   LET g_str = g_str,"\n      END FOREACH "                                                

   LET g_str = g_str,"\n      CALL g_",g_tabname,".deleteElement(li_cnt) "                           
   LET g_str = g_str,"\n      LET li_cnt = li_cnt - 1 "                                    

   LET g_str = g_str,"\n      CLOSE DATABASE "                                             
   LET g_str = g_str,"\n      DATABASE ",g_db                                                

   LET g_str = g_str,"\n      DELETE FROM ",g_tabname,"_file "                                       

   LET g_str = g_str,"\n      FOR li_cnt = 1 TO g_",g_tabname,".getLength() "                        
   CASE
      WHEN g_tabname = "zz"
         LET g_str = g_str,"\n         LET ls_tmp = g_zz[li_cnt].zz08"                        
         #Webi回復
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('p_report',1) THEN "                        
         LET g_str = g_str,"\n            LET ls_tmp = '%FGLRUN% %',UPSHIFT(g_zz[li_cnt].zz011 CLIPPED),'i%/',g_zz[li_cnt].zz01 CLIPPED "                        
         LET g_str = g_str,"\n            LET g_zz[li_cnt].zz08 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        
         #代換引號
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('$FGLRUN $',1) THEN "                        
         LET g_str = g_str,"\n            LET ls_tmp = '%FGLRUN% %',ls_tmp.subString(10,ls_tmp.getLength()) "                        
         LET g_str = g_str,"\n            LET li_pos = ls_tmp.getIndexOf('i',1) "                        
         LET g_str = g_str,"\n            LET ls_tmp = ls_tmp.subString(1,li_pos),'%', "
         LET g_str = g_str,"\n                         ls_tmp.subString(li_pos+1,ls_tmp.getLength()) "                        
         LET g_str = g_str,"\n            WHILE TRUE "                        
         LET g_str = g_str,"\n                IF ls_tmp.getIndexOf(\"'\",8) THEN "
         LET g_str = g_str,"\n                   LET ls_tmp = ls_tmp.subString(1,ls_tmp.getIndexOf(\"'\",8)-1),'\"', "
         LET g_str = g_str,"\n                                ls_tmp.subString(ls_tmp.getIndexOf(\"'\",8)+1,ls_tmp.getLength()) "
         LET g_str = g_str,"\n                ELSE "
         LET g_str = g_str,"\n                   EXIT WHILE "
         LET g_str = g_str,"\n                END IF "
         LET g_str = g_str,"\n            END WHILE "
         LET g_str = g_str,"\n            LET g_zz[li_cnt].zz08 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        
      WHEN g_tabname = "gao"
         LET g_str = g_str,"\n         LET ls_tmp = g_",g_tabname,"[li_cnt].gao02"                        
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('$TOP',1) THEN "                        
         LET g_str = g_str,"\n            LET ls_tmp = '%TOP%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01) "                        
         LET g_str = g_str,"\n            LET g_",g_tabname,"[li_cnt].gao02 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('$CUST',1) THEN "                        
         LET g_str = g_str,"\n            LET ls_tmp = '%CUST%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01) "                        
         LET g_str = g_str,"\n            LET g_",g_tabname,"[li_cnt].gao02 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        

         LET g_str = g_str,"\n         LET ls_tmp = g_",g_tabname,"[li_cnt].gao04"
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('$TOP',1) THEN "                        
         LET g_str = g_str,"\n            IF g_gao[li_cnt].gao01 = 'LIB' OR g_gao[li_cnt].gao01 = 'SUB' OR g_gao[li_cnt].gao01 = 'QRY' THEN "                        
         LET g_str = g_str,"\n               LET ls_tmp = '%TOP%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01),'\\\\42m' "
         LET g_str = g_str,"\n            ELSE "                        
         LET g_str = g_str,"\n               LET ls_tmp = '%TOP%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01),'\\\\42r' "                        
         LET g_str = g_str,"\n            END IF "                        
         LET g_str = g_str,"\n            LET g_",g_tabname,"[li_cnt].gao04 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        
         LET g_str = g_str,"\n         IF ls_tmp.getIndexOf('$CUST',1) THEN "                        
         LET g_str = g_str,"\n            IF g_gao[li_cnt].gao01 = 'CLIB' OR g_gao[li_cnt].gao01 = 'CSUB' OR g_gao[li_cnt].gao01 = 'CQRY' THEN "                        
         LET g_str = g_str,"\n               LET ls_tmp = '%CUST%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01),'\\\\42m' "
         LET g_str = g_str,"\n            ELSE "                        
         LET g_str = g_str,"\n               LET ls_tmp = '%CUST%\\\\',DOWNSHIFT(g_gao[li_cnt].gao01),'\\\\42r' "                        
         LET g_str = g_str,"\n            END IF "                        
         LET g_str = g_str,"\n            LET g_",g_tabname,"[li_cnt].gao04 = ls_tmp "                        
         LET g_str = g_str,"\n         END IF "                        
   END CASE
   LET g_str = g_str,"\n         INSERT INTO ",g_tabname,"_file VALUES g_",g_tabname,"[li_cnt].* "             
   LET g_str = g_str,"\n         IF STATUS THEN "                                          
   LET g_str = g_str,"\n            DISPLAY li_cnt, STATUS "                               
   LET g_str = g_str,"\n         ELSE "                                                    
   LET g_str = g_str,"\n            DISPLAY li_cnt, 'Record ok!' "                         
   LET g_str = g_str,"\n         END IF "                                                  
   LET g_str = g_str,"\n      END FOR "                                                    

   LET g_str = g_str,"\n   END MAIN "                                                      
   CALL g_channel.write(g_str)

END FUNCTION
