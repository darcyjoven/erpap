
   SCHEMA ds
   MAIN 
      DEFINE g_zz DYNAMIC ARRAY OF RECORD LIKE zz_file.* 
      DEFINE li_cnt INTEGER 
      DEFINE li_pos INTEGER 
      DEFINE ls_tmp STRING 
      WHENEVER ERROR CONTINUE 
      DATABASE top30_ds
      LET li_cnt = 1 
      DECLARE catch_data_cr CURSOR FOR SELECT * FROM zz_file   
      FOREACH catch_data_cr INTO g_zz[li_cnt].* 
         IF li_cnt MOD 5 = 0 THEN 
            DISPLAY 'Row:',li_cnt,' ok!' 
         END IF 
         LET li_cnt = li_cnt + 1 
      END FOREACH 
      CALL g_zz.deleteElement(li_cnt) 
      LET li_cnt = li_cnt - 1 
      CLOSE DATABASE 
      DATABASE ds
      DELETE FROM zz_file 
      FOR li_cnt = 1 TO g_zz.getLength() 
         LET ls_tmp = g_zz[li_cnt].zz08
         IF ls_tmp.getIndexOf('p_report',1) THEN 
            LET ls_tmp = '%FGLRUN% %',UPSHIFT(g_zz[li_cnt].zz011 CLIPPED),'i%/',g_zz[li_cnt].zz01 CLIPPED 
            LET g_zz[li_cnt].zz08 = ls_tmp 
         END IF 
         IF ls_tmp.getIndexOf('$FGLRUN $',1) THEN 
            LET ls_tmp = '%FGLRUN% %',ls_tmp.subString(10,ls_tmp.getLength()) 
            LET li_pos = ls_tmp.getIndexOf('i',1) 
            LET ls_tmp = ls_tmp.subString(1,li_pos),'%', 
                         ls_tmp.subString(li_pos+1,ls_tmp.getLength()) 
            WHILE TRUE 
                IF ls_tmp.getIndexOf("'",8) THEN 
                   LET ls_tmp = ls_tmp.subString(1,ls_tmp.getIndexOf("'",8)-1),'"', 
                                ls_tmp.subString(ls_tmp.getIndexOf("'",8)+1,ls_tmp.getLength()) 
                ELSE 
                   EXIT WHILE 
                END IF 
            END WHILE 
            LET g_zz[li_cnt].zz08 = ls_tmp 
         END IF 
         INSERT INTO zz_file VALUES g_zz[li_cnt].* 
         IF STATUS THEN 
            DISPLAY li_cnt, STATUS 
         ELSE 
            DISPLAY li_cnt, 'Record ok!' 
         END IF 
      END FOR 
   END MAIN 
