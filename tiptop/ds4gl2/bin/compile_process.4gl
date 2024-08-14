# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: compile_process.4gl
# Descriptions...: Compile處理Data Check、Create Temp Table定義轉換、Validate Function增加
# Memo...........: (1)檢查程式內有無定義固定datatype的情況發生(工作區用)
#                  (2)替換CREATE TEMP TABLE內 LIKE的定義方式(3.5X 工作區用)
#                  (3)create validate function
# Modify.........: No:TQC-750025 07/05/08 By saki 客製區域轉換
# Modify.........: No:FUN-760049 07/06/21 By saki 行業別代碼轉換
# Modify.........: No:TQC-770127 07/07/31 By saki 共用程式且本身不存在zz資料的，若出現在UNIX執行指令內，也要自動增加function
# Modify.........: No:TQC-780036 07/08/08 By saki for sun系統的指令修改
# Modify.........: No:TQC-780051 07/08/15 By alex 功能 (3) API指令修改
# Modify.........: No:FUN-7C0099 08/01/02 By saki 效能改善
# Modify.........: No:FUN-810089 08/02/01 By saki 行業別架構更改
# Modify.........: No:FUN-830038 08/03/15 By alex 調整部份指令for GPRebuild
# Modify.........: No:FUN-820075 08/03/21 By joyce test
# Modify.........: No:FUN-A40070 10/04/28 By alex 調整部份指令for GP5.2
# Modify.........: No.FUN-A90024 10/11/23 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-BB0159 11/11/28 By jrg542 當open window WITH FORM時，遇到/42f/才置換路徑
# Modify.........: No.FUN-BC0056 11/12/19 By jrg542 因應資安議題把相關資料個資隱藏起來
# Modify.........: No:DEV-C50001 12/05/04 By joyce 單檔程式設定遮罩後r.c2會失敗
# Modify.........: No:FUN-CA0016 12/12/28 By joyce 1.安全機制排除個資功能
#                                                  2.取消IMPORT top_chk_dyarr_id的用法，將程式段移到有用到的程式中


IMPORT os        #TQC-780051
#IMPORT FGL top_chk_dyarr_id   # No:FUN-BC0056   # mark by No:FUN-CA0016
DATABASE ds

DEFINE   g_process     STRING                     #處理哪個工作
DEFINE   g_module      STRING                     #模組
DEFINE   g_prog        STRING                     #程式代碼
DEFINE   g_org_path    STRING                     #非42m下要替換的路徑
DEFINE   g_top         STRING                     #$TOP路徑
DEFINE   g_tempdir     STRING                     #$TEMPDIR路徑
DEFINE   g_prog_path   STRING                     #42m底下的原程式路徑
DEFINE   g_temp_path   STRING                     #42m底下處理的程式路徑
DEFINE   g_temp2_path  STRING                     #42m儲存最開始的42m
DEFINE   g_cnt         SMALLINT
DEFINE   g_org         DYNAMIC ARRAY OF STRING    #原始程式碼列表
DEFINE   g_db_type     CHAR(3)
DEFINE   g_cmd         STRING
DEFINE   g_cust        CHAR(1)                    #客製程式
DEFINE   g_funname     DYNAMIC ARRAY OF STRING
DEFINE   g_pack_path   STRING                     #No:FUN-7C0099
DEFINE   g_cust_path   STRING                     #No:FUN-7C0099
DEFINE   g_zz01        LIKE zz_file.zz01          #No:DEV-CA0016
DEFINE   g_zz08        LIKE zz_file.zz08          #No:DEV-CA0016
DEFINE   gs_file       STRING                     #No:DEV-CA0016
DEFINE   gs_path       STRING                     #No:DEV-CA0016


MAIN
   DEFINE l_start        DATETIME HOUR TO FRACTION(5),  #No:FUN-760049
          l_end          DATETIME HOUR TO FRACTION(5)   #No:FUN-760049

   LET g_process = ARG_VAL(1)
   LET g_module = ARG_VAL(2)
   LET g_module = DOWNSHIFT(g_module)
   LET g_prog = ARG_VAL(3)
   LET g_org_path = ARG_VAL(4)

   #No:FUN-7C0099 --start--
   LET g_pack_path = FGL_GETENV("TOP")
   LET g_cust_path = FGL_GETENV("CUST")
   #No:FUN-7C0099 ---end---

   IF g_module.subString(1,1) = "c" THEN
      LET g_top = g_cust_path       #No:FUN-7C0099
   ELSE
      LET g_top = g_pack_path       #No:FUN-7C0099
   END IF
   LET g_tempdir = FGL_GETENV("TEMPDIR")

   IF (g_module IS NULL) OR (g_prog IS NULL) THEN
      DISPLAY "Compile 程式時, 抓不到模組代碼及程式代碼"
      RETURN
   END IF

   LET g_db_type = DB_GET_DATABASE_TYPE()     #No:TQC-770127

   CASE g_process
      WHEN "1"
         #檢查程式內有無定義固定type
         CALL program_check_datatype()
      WHEN "2"
         #CREATE TEMP TABLE 定義轉換
         CALL program_temptable_convert()
      WHEN "3"
         #自定義欄位的Validate Function增加
         LET l_start = CURRENT HOUR TO FRACTION(5)   #No:FUN-760049
         CALL program_create_validate_function()
         LET l_end = CURRENT HOUR TO FRACTION(5)     #No:FUN-760049
#        DISPLAY 'Increase the time of function: ',l_end - l_start      #No:FUN-760049  #FUN-830038 marked
      WHEN "4"
         #轉換 TODAY -> g_today, CURRENT ( a TO b ) -> cl_current_time( a, b)
         CALL program_windows_timezone()
      WHEN "5"
         #轉換 OPEN WINDOW xxxx WITH FORM "xxx/42f/filename" 加上 $TOP 代表的值
         CALL program_openwindow_path()
   END CASE
END MAIN


FUNCTION program_check_datatype()
   DEFINE   li_cnt       INTEGER
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_main      STRING
   DEFINE   li_mark_idx  SMALLINT
   DEFINE   li_result    SMALLINT

   IF g_org_path IS NULL THEN
     #LET g_prog_path = g_top,"/",g_module,"/4gl/",g_prog,".4gl"   #hj
      LET g_prog_path = os.Path.join(os.Path.join(g_top,g_module),"4gl")
      LET g_prog_path = os.Path.join(g_prog_path,g_prog||".4gl")
   ELSE
      LET g_prog_path = g_org_path
   END IF

   IF g_module = "ain" THEN
      RETURN
   END IF

   #檢查欲替換的檔案是否存在
   IF NOT os.Path.exists(g_prog) THEN
      RETURN
   END IF

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_prog_path,"r")
   CALL lc_channel.setDelimiter("")
   LET li_cnt = 1
   WHILE lc_channel.read(ls_result)
      #檢查段
      LET li_mark_idx = ls_result.getIndexOf("#",1)
      IF li_mark_idx = 1 THEN
         LET li_cnt = li_cnt + 1
         CONTINUE WHILE
      END IF

      LET li_result = FALSE
      IF li_mark_idx > 1 THEN
         LET ls_main = ls_result.subString(1,ls_result.getIndexOf("#",1)-1)
      ELSE
         LET ls_main = ls_result
      END IF
      IF ls_main.getIndexOf(" CHAR(",1) OR ls_main.getIndexOf(" char(",1) OR
         ls_main.getIndexOf(" DATE",1) OR ls_main.getIndexOf(" date",1) OR
         ls_main.getIndexOf(" INTEGER",1) OR ls_main.getIndexOf(" integer",1) OR
         ls_main.getIndexOf(" SMALLINT",1) OR ls_main.getIndexOf(" smallint",1) OR
         ls_main.getIndexOf(" DEC(",1) OR ls_main.getIndexOf(" dec(",1) OR 
         ls_main.getIndexOf(" DECIMAL(",1) OR ls_main.getIndexOf(" decimal(",1)
         THEN
         LET li_result = TRUE
      END IF
      IF li_result THEN
         DISPLAY "第",li_cnt,"行: 出現固定DataType字串(CHAR,SMALLINT...),請確認定義方式"
         DISPLAY "         程式段: ",ls_result
      END IF

      LET li_cnt = li_cnt + 1
   END WHILE
   CALL lc_channel.close()
END FUNCTION

FUNCTION program_temptable_convert()

   DEFINE ls_42mpath  STRING
   DEFINE ls_toplink  STRING

   LET ls_toplink = FGL_GETENV("TOPLINK")
   IF ls_toplink.getIndexOf("Development",1) THEN
      CASE g_db_type 
         WHEN "MSV" LET ls_42mpath = "42mm"   #FUN-A40070
         WHEN "ASE" LET ls_42mpath = "42ma"
         WHEN "IFX" LET ls_42mpath = "42mi"
         WHEN "DB2" LET ls_42mpath = "42md"
         OTHERWISE  LET ls_42mpath = "42m"    #including "ORA"
      END CASE
   ELSE
      LET ls_42mpath = "42m"
   END IF

   IF g_org_path IS NULL THEN
     #LET g_prog_path = g_top,"/",g_module,"/42m/",g_module,"_",g_prog,".4gl"
      LET g_prog_path = os.Path.join(os.Path.join(g_top,g_module),ls_42mpath)          #FUN-A40070
      LET g_prog_path = os.Path.join(g_prog_path,g_module||"_"||g_prog||".4gl")

     #LET g_temp_path = g_top,"/",g_module,"/42m/",g_module,"_",g_prog,"T.4gl"
      LET g_temp_path = os.Path.join(os.Path.join(g_top,g_module),ls_42mpath)          #FUN-A40070
      LET g_temp_path = os.Path.join(g_temp_path,g_module||"_"||g_prog||"T.4gl")
   ELSE
      LET g_prog_path = g_org_path
     #LET g_temp_path = g_tempdir,"/",g_prog,"T.4gl"
      LET g_temp_path = os.Path.join(g_tempdir,g_prog||"T.4gl")
   END IF

   #檢查欲替換的檔案是否存在
   IF NOT os.Path.exists(g_prog_path) THEN
      RETURN
   END IF

   #檢查檔案內是否有關鍵字"CREATE TEMP TABLE"
   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "grep -i 'CREATE TEMP TABLE' ",g_prog_path," > /dev/null 2>&1"
   ELSE
      LET g_cmd = 'findstr "CREATE TEMP TABLE" ', g_prog_path,' >NUL'
   END IF
   RUN g_cmd RETURNING g_cnt

   IF g_cnt THEN
      RETURN
   END IF

   #將舊程式每一行讀進Array (g_org)
   CALL program_in_array(g_prog_path)

   #鎖定檔案
   IF os.Path.separator() = "/" THEN                      #FUN-A40070
      LET g_cmd = "chmod 444 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   #替換CREATE TEMP TABLE內LIKE的定義方式,並將新array內容寫入mod_progT.4gl
   CALL program_patch(g_prog_path)

   #覆蓋mod_progT.4gl->mod_prog.4gl,並將檔案解鎖
   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   LET g_cmd = "mv ",g_temp_path," ",g_prog_path
   RUN g_cmd

   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF
END FUNCTION

#匯入舊程式進array
FUNCTION program_in_array(p_prog_path)
   DEFINE   p_prog_path  STRING
   DEFINE   li_cnt       INTEGER
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(p_prog_path,"r")
   CALL lc_channel.setDelimiter("")
   LET li_cnt = 1
   WHILE lc_channel.read(ls_result)
      LET g_org[li_cnt] = ls_result
      LET li_cnt = li_cnt + 1
   END WHILE
   CALL g_org.deleteElement(li_cnt)
   CALL lc_channel.close()
END FUNCTION

#替換CREATE TEMP TABLE內LIKE的定義方式,並將新array內容寫入mod_progT.4gl
FUNCTION program_patch(p_prog_path)
   DEFINE   p_prog_path    STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   li_cnt         INTEGER
   DEFINE   li_start       SMALLINT
   DEFINE   ls_old_str     STRING
   DEFINE   ls_new_str     STRING
   DEFINE   ls_table       STRING
   DEFINE   ls_field       STRING
   DEFINE   ls_last        STRING
   DEFINE   lc_type        CHAR(30)
   DEFINE   ls_mark        STRING

   FOR li_cnt = 1 TO g_org.getLength()
       IF g_org[li_cnt].getIndexOf("CREATE TEMP TABLE ",1) THEN
          LET li_start = TRUE
          CONTINUE FOR
       END IF

       LET ls_mark = ""
       IF g_org[li_cnt].getIndexOf("#",1) > 1 AND (li_start) THEN
          LET ls_mark = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("#",1),g_org[li_cnt].getLength())
          LET ls_mark = "     ",ls_mark
          LET g_org[li_cnt] = g_org[li_cnt].subString(1,g_org[li_cnt].getIndexOf("#",1)-1)
       END IF

       IF (g_org[li_cnt].getIndexOf("LIKE ",1)) AND (li_start) THEN
          LET ls_old_str = g_org[li_cnt].subString(1,g_org[li_cnt].getIndexOf("LIKE ",1) - 1)
          #尋找定義的type
          LET ls_table = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("LIKE ",1)+5,g_org[li_cnt].getIndexOf("_file.",1)+4)
          LET ls_table = ls_table.trim()

          IF (g_org[li_cnt].getIndexOf(")",1)) THEN
             CASE
                WHEN (g_org[li_cnt].getIndexOf(" not null",1))
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(" not null",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(" not null",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
                   LET li_start = FALSE
                WHEN (g_org[li_cnt].getIndexOf(" NOT NULL",1))
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(" NOT NULL",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(" NOT NULL",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
                   LET li_start = FALSE
                OTHERWISE
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(")",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(")",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
                   LET li_start = FALSE
             END CASE
          ELSE
             CASE
                WHEN (g_org[li_cnt].getIndexOf(" not null",1))
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(" not null",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(" not null",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
                WHEN (g_org[li_cnt].getIndexOf(" NOT NULL",1))
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(" NOT NULL",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(" NOT NULL",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
                OTHERWISE
                   LET ls_field = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf("_file.",1)+6,g_org[li_cnt].getIndexOf(",",1)-1)
                   LET ls_field = ls_field.trim()
                   LET ls_last = g_org[li_cnt].subString(g_org[li_cnt].getIndexOf(",",1),g_org[li_cnt].getLength())
                   CALL column_type(ls_table,ls_field) RETURNING lc_type
                   LET ls_new_str = ls_old_str," ",lc_type CLIPPED,ls_last,ls_mark
             END CASE
          END IF
          LET g_org[li_cnt] = ls_new_str
       ELSE
          LET li_start = FALSE
          CONTINUE FOR
       END IF
   END FOR

   #寫入檔案
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"w")
   CALL lc_channel.setDelimiter("")
   FOR li_cnt = 1 TO g_org.getLength()
      CALL lc_channel.write(g_org[li_cnt])
   END FOR
   CALL lc_channel.close()

   IF os.Path.separator() = "/" THEN
      LET g_cmd = "chmod 777 ",g_temp_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF
END FUNCTION

FUNCTION column_type(ps_table,ps_field)
   DEFINE   ps_table   STRING
   DEFINE   ps_field   STRING
   DEFINE   ls_sql     STRING
   DEFINE   i          SMALLINT
   DEFINE   lc_type    CHAR(30)
   DEFINE   lc_date    CHAR(30)
   DEFINE   lc_lentgh  CHAR(10)
   DEFINE   li_length  SMALLINT
   DEFINE   l_length1  CHAR(10)
   DEFINE   l_length2  CHAR(10)
   DEFINE   l_scale    SMALLINT
   DEFINE   l_prec     SMALLINT

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #CASE g_db_type
   #   WHEN "IFX" 
   #   LET ls_sql = "SELECT coltype,collength,'','' ",
   #                "  FROM systables a,syscolumns b,outer sysdefaults c",
   #                " WHERE tabname='",ps_table,"'",
   #                "   AND a.tabid=b.tabid",
   #                "   AND b.tabid=c.tabid",
   #                "   AND b.colno=c.colno",
   #                "   AND colname='",ps_field,"'",
   #                " ORDER BY b.colno"
   #   WHEN "ORA" 
   #   LET ls_sql = "SELECT lower(data_type),",
   #                "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),data_scale,'' ",
   #                "  FROM user_tab_columns",
   #                " WHERE lower(table_name)='",ps_table,"'",
   #                "   AND lower(column_name)='",ps_field,"'",
   #                " ORDER BY column_id"
   #   WHEN "MSV" 
   #     LET ls_sql=" SELECT b.system_type_id,b.max_length,b.scale,'' ", 
   #                  " FROM sys.tables a,sys.columns b ",
   #                 " WHERE a.name='",ps_table CLIPPED,"'",
   #                   " AND b.name='",ps_field CLIPPED,"'",
   #                   " AND a.object_id=b.object_id",
   #                 " ORDER BY b.column_id "
   #   WHEN "ASE" 
   #     LET ls_sql=" SELECT b.usertype,b.length,b.scale,b.prec ", 
   #                  " FROM sysobjects a,syscolumns b ",
   #                 " WHERE a.name='",ps_table CLIPPED,"'",
   #                   " AND b.name='",ps_field CLIPPED,"'",
   #                   " AND a.id=b.id",
   #                 " ORDER BY b.colid "
   #   WHEN "DB2" 
   #END CASE
   LET ls_sql=" "
   CALL program_get_column_info(ps_table, ps_field) RETURNING lc_type, l_length1 

   #PREPARE type_curs FROM ls_sql
   #EXECUTE type_curs INTO lc_type,li_length,l_scale,l_prec
   #
   #IF lc_type IS NULL THEN
   #   RETURN ""
   #END IF
   #CASE g_db_type
   #   WHEN "IFX" 
   #   CASE WHEN lc_type = 0 OR lc_type = 256
   #             LET l_length1=li_length CLIPPED
   #             LET lc_type = "char(",l_length1 CLIPPED,")"
   #        WHEN lc_type = 1 OR lc_type = 257
   #             LET lc_type = "smallint"
   #        WHEN lc_type = 2 OR lc_type = 258
   #             LET lc_type = "integer"
   #        WHEN lc_type = 5
   #             LET l_length1=li_length/256
   #             LET li_length=li_length mod 256 CLIPPED
   #             IF l_length1<li_length THEN
   #                FOR i=1 TO 10
   #                    IF l_length1[i,i]="." THEN
   #                       LET lc_type=l_length1[1,i-1] CLIPPED
   #                       EXIT FOR
   #                    END IF
   #                END FOR
   #             ELSE
   #                FOR i=1 TO 10
   #                    IF l_length1[i,i]="." THEN
   #                       LET lc_type=l_length1[1,i-1] CLIPPED,","
   #                       EXIT FOR
   #                    END IF
   #                END FOR
   #                LET l_length1=li_length CLIPPED
   #                LET lc_type = lc_type CLIPPED,l_length1 CLIPPED
   #             END IF
   #             LET lc_type = "decimal(",lc_type CLIPPED,")"
   #        WHEN lc_type = 7
   #             LET lc_type = "date"
   #        WHEN lc_type = 10 OR lc_type = 266
   #             LET lc_type = "datetime"
   #             LET lc_date = li_length mod 514
   #             CASE
   #                WHEN lc_date = 510
   #                     LET lc_date = "year to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"year"
   #                        WHEN l_length1=2
   #                             LET lc_date = lc_date CLIPPED,"month"
   #                        WHEN l_length1=3
   #                             LET lc_date = lc_date CLIPPED,"day"
   #                        WHEN l_length1=4
   #                             LET lc_date = lc_date CLIPPED,"hour"
   #                        WHEN l_length1=5
   #                             LET lc_date = lc_date CLIPPED,"minute"
   #                        WHEN l_length1=6
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #                WHEN lc_date = 32
   #                     LET lc_date = "month to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"month"
   #                        WHEN l_length1=2
   #                             LET lc_date = lc_date CLIPPED,"day"
   #                        WHEN l_length1=3
   #                             LET lc_date = lc_date CLIPPED,"hour"
   #                        WHEN l_length1=4
   #                             LET lc_date = lc_date CLIPPED,"minute"
   #                        WHEN l_length1=5
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #                WHEN lc_date = 66
   #                     LET lc_date = "day to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"day"
   #                        WHEN l_length1=2
   #                             LET lc_date = lc_date CLIPPED,"hour"
   #                        WHEN l_length1=3
   #                             LET lc_date = lc_date CLIPPED,"minute"
   #                        WHEN l_length1=4
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #                WHEN lc_date = 100
   #                     LET lc_date = "hour to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"hour"
   #                        WHEN l_length1=2
   #                             LET lc_date = lc_date CLIPPED,"minute"
   #                        WHEN l_length1=3
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #                WHEN lc_date = 134
   #                     LET lc_date = "minute to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"minute"
   #                        WHEN l_length1=2
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #                WHEN lc_date = 168
   #                     LET lc_date = "second to "
   #                     LET l_length1=li_length/514
   #                     CASE
   #                        WHEN l_length1=1
   #                             LET lc_date = lc_date CLIPPED,"second"
   #                     END CASE
   #             END CASE
   #        WHEN lc_type = 11 OR lc_type = 267
   #             LET lc_type = "byte"
   #        WHEN lc_type = 13 OR lc_type = 269
   #             LET l_length1=li_length CLIPPED
   #             LET lc_type = "varchar(",l_length1 CLIPPED,")"
   #        WHEN lc_type = 261
   #             LET l_length1=li_length/256
   #             FOR i=1 TO 10
   #                 IF l_length1[i,i]="." THEN
   #                    LET lc_type = l_length1[1,i-1] CLIPPED,","
   #                    EXIT FOR
   #                 END IF
   #             END FOR
   #             LET li_length=li_length mod 256 CLIPPED
   #             LET l_length1=li_length CLIPPED
   #             LET lc_type = lc_type CLIPPED,l_length1 CLIPPED
   #             LET lc_type = "decimal(",lc_type CLIPPED,")"
   #        WHEN lc_type = 262  #serial
   #             LET lc_type = "integer"
   #        WHEN lc_type = 263
   #             LET lc_type = "date"
   #   END CASE
   #
   #WHEN "ORA"
   #   CASE WHEN lc_type = 'varchar2'
   #             LET l_length1 = li_length CLIPPED
   #             LET lc_type = "varchar","(",l_length1 CLIPPED,")"
   #        WHEN lc_type = 'char'
   #             LET l_length1 = li_length CLIPPED
   #             LET lc_type = lc_type CLIPPED,"(",l_length1 CLIPPED,")"
   #        WHEN lc_type = 'number'
   #             LET l_length1 = li_length CLIPPED
   #             LET l_length2 = l_scale CLIPPED
   #             IF l_length2<>'0' THEN
   #                LET l_length1 = l_length1 CLIPPED,',',l_length2 CLIPPED
   #             END IF
   #             CASE
   #                WHEN l_length1 = "5" OR l_length1 = "5,0"
   #                   LET lc_type = "smallint"
   #                WHEN l_length1 = "10" OR l_length1 = "10,0"
   #                   LET lc_type = "integer"
   #                OTHERWISE
   #                   LET lc_type = "decimal","(",l_length1 CLIPPED,")"
   #             END CASE
   #   END CASE
   #
   #WHEN "MSV"
   #   CASE
   #        WHEN lc_type = 40 
   #             LET lc_type = "date"
   #        WHEN lc_type = 52
   #             LET lc_type = "smallint"
   #        WHEN lc_type = 56
   #             LET lc_type = "integer"
   #        WHEN lc_type = 106
   #             LET l_length1 = li_length CLIPPED
   #             LET l_length2 = l_scale CLIPPED
   #             IF l_length2<>'0' THEN
   #                LET l_length1 = l_length1 CLIPPED,',',l_length2 CLIPPED
   #             END IF
   #             CASE
   #                WHEN l_length1 = "5" OR l_length1 = "5,0"
   #                   LET lc_type = "smallint"
   #                WHEN l_length1 = "10" OR l_length1 = "10,0"
   #                   LET lc_type = "integer"
   #                OTHERWISE
   #                   LET lc_type = "decimal","(",l_length1 CLIPPED,")"
   #             END CASE
   #        WHEN lc_type = 231 
   #             LET l_length1 = (li_length / 2 ) USING "<<<<<"   #r.s2時NVARCHR已先 x2
   #             LET lc_type = "nvarchar(",l_length1 CLIPPED,")"
   #   END CASE
   #
   #WHEN "ASE"
   #   CASE
   #        WHEN lc_type = 37
   #             LET lc_type = "date"
   #        WHEN lc_type = 6
   #             LET lc_type = "smallint"
   #        WHEN lc_type = 7
   #             LET lc_type = "integer"
   #        WHEN lc_type = 26
   #             LET l_length1 = l_prec CLIPPED
   #             LET l_length2 = l_scale CLIPPED
   #             IF l_length2<>'0' THEN
   #                LET l_length1 = l_length1 CLIPPED,',',l_length2 CLIPPED
   #             END IF
   #             CASE
   #                WHEN l_length1 = "5" OR l_length1 = "5,0"
   #                   LET lc_type = "smallint"
   #                WHEN l_length1 = "10" OR l_length1 = "10,0"
   #                   LET lc_type = "integer"
   #                OTHERWISE
   #                   LET lc_type = "decimal","(",l_length1 CLIPPED,")"
   #             END CASE
   #        WHEN lc_type = 2
   #             LET l_length1 = li_length USING "<<<<<"  
   #             LET lc_type = "varchar(",l_length1 CLIPPED,")"
   #   END CASE
   #WHEN "DB2"
   #
   #END CASE
   IF lc_type IS NULL THEN
      RETURN ""
   END IF

   CASE 
      WHEN lc_type = 'number'
           CASE WHEN l_length1 = "5" OR l_length1 = "5,0"
                     LET lc_type = "smallint"
                WHEN l_length1 = "10" OR l_length1 = "10,0"
                     LET lc_type = "integer"
                OTHERWISE
                     LET lc_type = "decimal","(",l_length1 CLIPPED,")"
           END CASE
           
     WHEN lc_type = 'varchar2'
          LET lc_type = "varchar","(",l_length1 CLIPPED,")"

      WHEN lc_type = 'nvarchar' OR lc_type = 'nvarchar2'
           CASE g_db_type
                WHEN "MSV"
                     LET l_length1 = (l_length1 / 2 ) USING "<<<<<"
                     LET lc_type = "varchar(",l_length1 CLIPPED,")"
                OTHERWISE
                     LET lc_type = "varchar(", l_length1 CLIPPED, ")"
           END CASE
      WHEN lc_type = 'smallint' OR lc_type = 'integer' OR lc_type = 'date'
           LET lc_type = lc_type

      WHEN lc_type = 'binary' OR lc_type = 'byte' OR lc_type = 'image' OR lc_type = 'blob'
           LET lc_type = lc_type
           
      OTHERWISE
           LET lc_type = lc_type, "(", l_length1 CLIPPED, ")"
   END CASE
   #---FUN-A90024---end-------
   
   LET lc_type = UPSHIFT(lc_type)

   RETURN lc_type CLIPPED
END FUNCTION

FUNCTION program_create_validate_function()
   DEFINE   ls_result     STRING
   DEFINE   ls_sql        STRING
   DEFINE   lc_std_id     LIKE smb_file.smb01
   DEFINE   lc_prog       LIKE zz_file.zz01       #No:FUN-7C0099
   DEFINE   lc_gav11      LIKE gav_file.gav11
   DEFINE   li_i          SMALLINT
   DEFINE   lc_industry   LIKE smb_file.smb01     #No:FUN-810089
   DEFINE   li_result     SMALLINT                #No:FUN-810089
   DEFINE   ls_42mpath    STRING

   IF g_module = "lib" OR g_module = "sub" OR g_module = "qry" OR
      g_module = "clib" OR g_module = "csub" OR g_module = "cqry" THEN
      RETURN
   END IF

   IF g_prog.subString(1,3) = "cl_" OR g_prog.subString(1,4) = "ccl_" OR
      g_prog.subString(1,2) = "s_" OR g_prog.subString(1,3) = "cs_" OR
      g_prog.subString(1,2) = "q_" OR g_prog.subString(1,3) = "cq_" THEN
      RETURN
   END IF

   IF FGL_GETENV("TOPLINK")="Development" THEN
      CASE g_db_type                          #FUN-A40070
         WHEN "MSV" LET ls_42mpath = "42mm"
         WHEN "ASE" LET ls_42mpath = "42ma"
         WHEN "DB2" LET ls_42mpath = "42md"
         WHEN "IFX" LET ls_42mpath = "42mi"
         OTHERWISE  LET ls_42mpath = "42m"    #including "ORA"
      END CASE
   ELSE
      LET ls_42mpath = "42m"
   END IF

   IF g_org_path IS NULL THEN
      LET g_prog_path = os.Path.join(os.Path.join(os.Path.join(g_top,g_module),ls_42mpath),g_module||"_"||g_prog||".4gl")
      LET g_temp_path = os.Path.join(os.Path.join(os.Path.join(g_top,g_module),ls_42mpath),g_module||"_"||g_prog||"T.4gl")
      LET g_temp2_path= os.Path.join(os.Path.join(os.Path.join(g_top,g_module),ls_42mpath),g_module||"_"||g_prog||"T2.4gl")
   ELSE
      LET g_prog_path = g_org_path
      LET g_temp_path = os.Path.join(g_tempdir,g_prog||"T.4gl")
      LET g_temp2_path =os.Path.join(g_tempdir,g_prog||"T2.4gl")
   END IF

   #檢查欲替換的檔案是否存在
   IF NOT os.Path.exists(g_prog_path) THEN   #TQC-780051
      RETURN
   END IF

   LET ls_result = os.Path.basename(os.Path.dirname(os.Path.pwd())) #TQC-780051

   IF ls_result.subString(1,1) = "c" THEN
      LET g_cust = "Y"
   ELSE
      LET g_cust = "N"
   END IF

   LET ls_sql = "SELECT COUNT(*) FROM smb_file WHERE smb01=?"
   PREPARE smb01_cnt_pre FROM ls_sql

   CASE g_db_type
      WHEN "ORA" 
      LET ls_sql = "SELECT COUNT(*) FROM zz_file ",
                   " WHERE zz01='",g_prog CLIPPED,"' OR zz08 LIKE '%",g_prog CLIPPED," %'"
      WHEN "IFX"
      LET ls_sql = "SELECT COUNT(*) FROM zz_file ",
                   " WHERE zz01='",g_prog CLIPPED,"' OR zz08 MATCHES '*",g_prog CLIPPED," *'"
      WHEN "MSV" 
      LET ls_sql = "SELECT COUNT(*) FROM zz_file ",
                   " WHERE zz01='",g_prog CLIPPED,"' OR zz08 LIKE '%",g_prog CLIPPED," %'"
      WHEN "ASE"
      LET ls_sql = "SELECT COUNT(*) FROM zz_file ",
                   " WHERE zz01='",g_prog CLIPPED,"' OR zz08 LIKE '%",g_prog CLIPPED," %'"
      WHEN "DB2" 
   END CASE
   PREPARE zz_pre FROM ls_sql

   EXECUTE zz_pre INTO li_i
   IF li_i <= 0 THEN
      RETURN
   END IF

   #鎖定檔案
   IF os.Path.separator() = "/" THEN           #TQC-780051
      LET g_cmd = "chmod 444 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   IF NOT os.Path.copy(g_prog_path,g_temp2_path) THEN
   END IF

   #一般行業代號
   LET lc_std_id = "std"

   LET ls_sql = "SELECT COUNT(UNIQUE gav11) FROM gav_file",
                " WHERE (gav01=? OR gav01 IN ",
                " (SELECT gax02 FROM gax_file WHERE gax01=? AND gax03 = 'Y'))",
                "   AND gav08=? AND gav11=? ",
                "   AND ((gav28 = '3' AND gav21 IS NOT NULL) OR ",
                "        (gav29 = '3' AND gav23 IS NOT NULL) OR ",
                "        (gav30 = '3' AND gav27 IS NOT NULL))"
   PREPARE industry_cnt_pre FROM ls_sql

   #No:FUN-810089 --modify start--
   #以下規則:
   #是行業別程式 saxmt400_icd.4gl
   #    若有找到icd的資料, 則用icd的資料放入$AXM/42m/axm_saxmt400_icd.4gl內
   #    若未找到icd的資料, 則用std的資料放入$AXM/42m/axm_saxmt400_icd.4gl內
   #未跟有行業別代碼的程式 saxmt400.4gl
   #    一定使用std的資料, 放入 $AXM/42m/axm_saxmt400.4gl內

   CALL program_check_industry(g_prog,lc_std_id) RETURNING lc_industry,li_result
   IF li_result AND lc_industry != lc_std_id THEN
      LET lc_prog = g_prog.subString(1,g_prog.getIndexOf(lc_industry CLIPPED,1)-1)
      SELECT COUNT(*) INTO li_i FROM gav_file
       WHERE gav01=lc_prog AND gav08=g_cust
      IF li_i > 0 THEN
         SELECT COUNT(UNIQUE gav11) INTO li_i FROM gav_file
          WHERE gav01=lc_prog AND gav08=g_cust AND gav11=lc_industry
         #有所屬行業別的資料
         IF li_i > 0 THEN
            EXECUTE industry_cnt_pre USING lc_prog,lc_prog,g_cust,lc_industry INTO li_i
            #大於0表示此主程式自訂欄位有自訂function
            IF li_i > 0 THEN
               CALL program_gen_validate_function(lc_std_id CLIPPED,lc_industry CLIPPED)
            ELSE
               CALL program_cat_validate_function()
            END IF
         ELSE
            EXECUTE industry_cnt_pre USING lc_prog,lc_prog,g_cust,lc_std_id INTO li_i
            #大於0表示此主程式自訂欄位有自訂function
            IF li_i > 0 THEN
               CALL program_gen_validate_function(lc_std_id CLIPPED,lc_std_id CLIPPED)
            ELSE
               CALL program_cat_validate_function()
            END IF
         END IF
      ELSE
         CALL program_cat_validate_function()
      END IF
      CALL program_cat_datamask_function()    #No.FUN-BC0056
      CALL program_filename_process(lc_std_id CLIPPED,lc_industry CLIPPED)
   ELSE
      LET lc_prog = g_prog
      SELECT COUNT(*) INTO li_i FROM gav_file
       WHERE gav01=lc_prog AND gav08=g_cust AND gav11=lc_std_id
      IF li_i > 0 THEN
         EXECUTE industry_cnt_pre USING lc_prog,lc_prog,g_cust,lc_std_id INTO li_i
         #大於0表示此主程式自訂欄位有自訂function
         IF li_i > 0 THEN
            CALL program_gen_validate_function(lc_std_id CLIPPED,lc_std_id CLIPPED)
         ELSE
            CALL program_cat_validate_function()
         END IF
      ELSE
         CALL program_cat_validate_function()
      END IF
      CALL program_cat_datamask_function()   #FUN-BC0056
      CALL program_filename_process(lc_std_id CLIPPED,lc_std_id CLIPPED)
   END IF
   #No:FUN-810089 ---modify end---

   IF os.Path.delete(g_temp2_path) THEN END IF

   CALL program_add_datamask_change_func()   #FUN-BC0056
END FUNCTION


FUNCTION program_add_datamask_change_func()  #FUN-BC0056

   DEFINE ls_tmp     STRING
   DEFINE li_status  LIKE type_file.num5
   DEFINE lc_gdv     RECORD LIKE gdv_file.*    #DEV-C50001
   DEFINE lc_path    STRING                    # No:FUN-CA0016
   DEFINE lc_h       LIKE type_file.num5       # No:FUN-CA0016
   DEFINE lc_result  STRING                    # No:FUN-CA0016
   DEFINE lc_file    STRING                    # No:FUN-CA0016


   # No:FUN-CA0016 ---start---
   # 安全機制程式不須加上個資功能
   # 為避免後續有新增安全機制程式，但是卻未排除個資功能，
   # 因此需檢查放置安全機制程式的目錄，確認目前編譯的程式是否為安全機制程式，
   # 若是，則不加上個資功能
   LET lc_path = os.Path.join(os.Path.join(FGL_GETENV("DS4GL"),"bin"),"ora")
   CALL os.Path.dirsort("name", 1)
   LET lc_h = os.Path.diropen(lc_path)
   WHILE lc_h > 0
      LET lc_result = os.Path.dirnext(lc_h)
      IF lc_result IS NULL THEN
         EXIT WHILE
      END IF
      IF lc_result = "." OR lc_result = ".." THEN
         CONTINUE WHILE
      END IF

      LET lc_file = os.Path.rootname(os.Path.basename(lc_result))
      IF lc_file.subString(5,lc_file.getLength()) = g_prog THEN
         RETURN
      END IF
   END WHILE
   CALL os.Path.dirclose(lc_h)
   # No:FUN-CA0016 --- end ---

   #DEV-C50001 -- start--
   LET lc_gdv.gdv01 = g_prog.trim()
   DECLARE cl_set_data_mask_d_cs2 CURSOR FOR
    SELECT gdv02 FROM gdv_file WHERE gdv01=lc_gdv.gdv01 #OR gdv01=others
   
   FOREACH cl_set_data_mask_d_cs2 INTO lc_gdv.gdv02
      IF STATUS THEN EXIT FOREACH END IF

   #  CALL top_chk_dyarr_id.chk_forupd_sql(g_prog,lc_gdv.gdv02) RETURNING li_status,ls_tmp   #No.FUN-BC0056   # No:FUN-CA0016
      CALL program_chk_forupd_sql(g_prog,lc_gdv.gdv02) RETURNING li_status,ls_tmp   #No.FUN-BC0056   # No:FUN-CA0016
      IF li_status THEN 
         EXIT FOREACH       
      END IF
   END FOREACH
   #DEV-C50001 -- end --


   IF NOT li_status THEN
      RETURN
   END IF

   #檢查檔案內是否有關鍵字 'xxx.deleteElement'
   LET ls_tmp = ls_tmp.trim(),".deleteElement"
   IF os.Path.separator() = "/" THEN 
      LET g_cmd = "grep -i '",ls_tmp.trim(),"' ",g_prog_path," > /dev/null 2>&1"
   ELSE
      LET g_cmd = 'findstr "',ls_tmp.trim(),'" ', g_prog_path,' >NUL'
   END IF
   RUN g_cmd RETURNING g_cnt

   IF g_cnt THEN
      RETURN
   END IF

   #將舊程式每一行讀進Array (g_org)
   CALL program_in_array(g_prog_path)

   #鎖定檔案
   IF os.Path.separator() = "/" THEN                      #FUN-A40070
      LET g_cmd = "chmod 444 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   #替換WITH FORM,並將新array內容寫入mod_progT.4gl
   CALL program_deleteelement_patch(g_prog_path,ls_tmp)

   #覆蓋mod_progT.4gl->mod_prog.4gl,並將檔案解鎖
   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   LET g_cmd = "mv ",g_temp_path," ",g_prog_path
   RUN g_cmd

   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

END FUNCTION

#替換WITH FORM,並將新array內容寫入mod_progT.4gl
FUNCTION program_deleteelement_patch(p_prog_path,ls_tmp)
   DEFINE   p_prog_path    STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   li_cnt         INTEGER
   DEFINE   ls_tmp,ls_new  STRING
   DEFINE   li_pos         SMALLINT

   LET ls_tmp = ls_tmp.trim()
   FOR li_cnt = 1 TO g_org.getLength()
       LET ls_new = g_org[li_cnt]
       LET ls_new = ls_new.trim()
       IF ls_new.subString(1,1)="#" OR ls_new.subString(1,2)="--" OR ls_new.subString(1,1)="{" THEN
          CONTINUE FOR
       END IF
       IF NOT g_org[li_cnt].getIndexOf(ls_tmp,1) THEN
          CONTINUE FOR
       END IF
       LET g_org[li_cnt] = g_org[li_cnt],'    CALL cl_set_data_mask_detail("f") #個資遮罩設定'   #DEV-C50001
   END FOR

   #寫入檔案
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"w")
   CALL lc_channel.setDelimiter("")
   FOR li_cnt = 1 TO g_org.getLength()
      CALL lc_channel.write(g_org[li_cnt])
   END FOR
   CALL lc_channel.close()

   IF os.Path.separator() = "/" THEN
      LET g_cmd = "chmod 777 ",g_temp_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF
END FUNCTION


FUNCTION program_check_industry(ps_prog,ps_std_id)
   DEFINE   ps_prog      STRING
   DEFINE   ps_std_id    STRING
   DEFINE   lc_industry  LIKE smb_file.smb01
   DEFINE   li_result    SMALLINT
   DEFINE   li_dash_inx  SMALLINT

   IF ps_prog.getIndexOf("_",1) THEN
      WHILE ps_prog.getIndexOf("_",li_dash_inx+1)
         LET li_dash_inx = ps_prog.getIndexOf("_",li_dash_inx+1)
      END WHILE
      LET lc_industry = ps_prog.subString(li_dash_inx+1,ps_prog.getLength())
      EXECUTE smb01_cnt_pre USING lc_industry INTO g_cnt
      IF g_cnt > 0 THEN
         LET li_result = TRUE
      ELSE
         LET li_result = FALSE
      END IF
   ELSE
      LET lc_industry = ps_std_id
      LET li_result = TRUE
   END IF

   RETURN lc_industry,li_result
END FUNCTION

FUNCTION program_gen_validate_function(pc_std,pc_gav11)
   DEFINE   pc_std        LIKE gav_file.gav11
   DEFINE   pc_gav11      LIKE gav_file.gav11
   DEFINE   ls_sql        STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   lc_gax02      LIKE gax_file.gax02
   DEFINE   lc_gav02      LIKE gav_file.gav02
   DEFINE   lc_gav11      LIKE gav_file.gav11
   DEFINE   lc_gav11_2    LIKE gav_file.gav11
   DEFINE   lc_gav21      LIKE gav_file.gav21
   DEFINE   lc_gav23      LIKE gav_file.gav23
   DEFINE   lc_gav27      LIKE gav_file.gav27
   DEFINE   ls_fun        STRING
   DEFINE   li_fun_num    SMALLINT
   DEFINE   ls_fun_num    STRING
   DEFINE   li_max_num    SMALLINT
   DEFINE   li_i          SMALLINT
   DEFINE   lc_prog       LIKE zz_file.zz01       #No:FUN-7C0099
   DEFINE   li_result     SMALLINT                #No:FUN-7C0099

   LET ls_sql = "SELECT gav02,gav21,gav23,gav27 FROM gav_file",
                " WHERE gav01=? AND gav08=? AND gav11=?",
                "   AND ((gav28 = '3' AND gav21 IS NOT NULL) OR ",
                "        (gav29 = '3' AND gav23 IS NOT NULL) OR ",
                "        (gav30 = '3' AND gav27 IS NOT NULL))"
   PREPARE gav_pre FROM ls_sql
   DECLARE gav_curs CURSOR FOR gav_pre

   LET ls_sql = "SELECT gax02 FROM gax_file",
                " WHERE gax01=? AND gax03='Y'"
   PREPARE gax_pre FROM ls_sql
   DECLARE gax_curs CURSOR FOR gax_pre
   LET lc_prog = g_prog

   LET ls_sql = "SELECT COUNT(UNIQUE gav01) FROM gav_file",
                " WHERE gav01=? AND gav08=? AND gav11=?"
   PREPARE gax_cnt_pre FROM ls_sql

   CALL g_funname.clear()
   LET li_max_num = 0

   IF NOT os.Path.copy(g_temp2_path,g_temp_path) THEN  #TQC-780051
   END IF
   IF os.Path.separator() = "/" THEN                  #TQC-780051
      LET g_cmd = "chmod 777 ",g_temp_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"a")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("")
   CALL lc_channel.write("")
   CALL lc_channel.write("#以下自動產生函式為動態設定於畫面元件設定作業(p_per)內的函式")

   #主程式對應的per檔
   FOREACH gav_curs USING lc_prog,g_cust,pc_gav11 INTO lc_gav02,lc_gav21,lc_gav23,lc_gav27   #No:FUN-7C0099
      IF lc_gav21 IS NOT NULL THEN
         LET ls_fun = lc_gav21 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         CALL funname_check(ls_fun_num) RETURNING li_result
         IF li_result THEN
            CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||pc_gav11 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 基本資料檢查")   #No:FUN-760049
            CALL lc_channel.write(lc_gav21 CLIPPED)
            CALL lc_channel.write("")
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
      END IF
      IF lc_gav23 IS NOT NULL THEN
         LET ls_fun = lc_gav23 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         CALL funname_check(ls_fun_num) RETURNING li_result
         IF li_result THEN
            CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||pc_gav11 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 關聯欄位資料")   #No:FUN-760049
            CALL lc_channel.write(lc_gav23 CLIPPED)
            CALL lc_channel.write("")
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
      END IF
      IF lc_gav27 IS NOT NULL THEN
         LET ls_fun = lc_gav27 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         CALL funname_check(ls_fun_num) RETURNING li_result
         IF li_result THEN
            CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||pc_gav11 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 資料重複檢查")   #No:FUN-760049
            CALL lc_channel.write(lc_gav27 CLIPPED)
            CALL lc_channel.write("")
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
      END IF
      #No:FUN-7C0099 ---modify end---
   END FOREACH

   #其餘副畫面,必須在p_base_per建立才有效
   FOREACH gax_curs USING lc_prog INTO lc_gax02
      IF g_prog.equals(lc_gax02 CLIPPED) THEN
         CONTINUE FOREACH
      END IF
      EXECUTE gax_cnt_pre USING lc_gax02,g_cust,pc_gav11 INTO li_i
      IF li_i > 0 THEN
         LET lc_gav11_2 = pc_gav11 CLIPPED
      ELSE
         LET lc_gav11_2 = pc_std CLIPPED
      END IF
      FOREACH gav_curs USING lc_gax02,g_cust,lc_gav11_2 INTO lc_gav02,lc_gav21,lc_gav23,lc_gav27   #No:FUN-7C0099
         IF lc_gav21 IS NOT NULL THEN
            LET ls_fun = lc_gav21 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            CALL funname_check(ls_fun_num) RETURNING li_result
            IF li_result THEN
               CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||lc_gav11_2 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 基本資料檢查")  #No:FUN-760049
               CALL lc_channel.write(lc_gav21 CLIPPED)
               CALL lc_channel.write("")
               LET li_fun_num = ls_fun_num
               IF li_fun_num > li_max_num THEN
                  LET li_max_num = li_fun_num
               END IF
            END IF
         END IF

         IF lc_gav23 IS NOT NULL THEN
            LET ls_fun = lc_gav23 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            CALL funname_check(ls_fun_num) RETURNING li_result
            IF li_result THEN
               CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||lc_gav11_2 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 關聯欄位資料")  #No:FUN-760049
               CALL lc_channel.write(lc_gav23 CLIPPED)
               CALL lc_channel.write("")
               LET li_fun_num = ls_fun_num
               IF li_fun_num > li_max_num THEN
                  LET li_max_num = li_fun_num
               END IF
            END IF
         END IF

         IF lc_gav27 IS NOT NULL THEN
            LET ls_fun = lc_gav27 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            CALL funname_check(ls_fun_num) RETURNING li_result
            IF li_result THEN
               CALL lc_channel.write("#Form:"||g_prog||",Custom:"||g_cust||",Industry:"||lc_gav11_2 CLIPPED||",Field:"||lc_gav02 CLIPPED||" 資料重複檢查")  #No:FUN-760049
               CALL lc_channel.write(lc_gav27 CLIPPED)
               CALL lc_channel.write("")
               LET li_fun_num = ls_fun_num
               IF li_fun_num > li_max_num THEN
                  LET li_max_num = li_fun_num
               END IF
            END IF
         END IF
      END FOREACH
   END FOREACH

   #補上沒有寫的validate function
   FOR li_i = li_max_num + 1 TO 20
       LET ls_fun_num = li_i USING '&&'
       CALL lc_channel.write("FUNCTION cl_validate_fun"||ls_fun_num||"(ps_value)")
       CALL lc_channel.write("   DEFINE   ps_value   STRING")
       CALL lc_channel.write("   RETURN TRUE")
       CALL lc_channel.write("END FUNCTION")
       CALL lc_channel.write("")
   END FOR
   CALL lc_channel.close()
END FUNCTION

FUNCTION program_cat_validate_function()
   DEFINE   lc_channel   base.Channel
   DEFINE   li_i         SMALLINT
   DEFINE   ls_fun_num   STRING

   IF NOT os.Path.copy(g_temp2_path,g_temp_path) THEN
   END IF

   #補上沒有寫的validate function
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"a")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("")
   CALL lc_channel.write("")
   CALL lc_channel.write("#以下自動產生函式為動態設定於畫面元件設定作業(p_per)內的函式")
   FOR li_i = 1 TO 20
       LET ls_fun_num = li_i USING '&&'
       CALL lc_channel.write("FUNCTION cl_validate_fun"||ls_fun_num||"(ps_value)")
       CALL lc_channel.write("   DEFINE   ps_value   STRING")
       CALL lc_channel.write("   RETURN TRUE")
       CALL lc_channel.write("END FUNCTION")
       CALL lc_channel.write("")
   END FOR
   CALL lc_channel.close()
END FUNCTION

FUNCTION program_filename_process(ps_std_industry,ps_industry)
   DEFINE   ps_std_industry   STRING
   DEFINE   ps_industry       STRING
   DEFINE   ls_tmp        STRING                  #TQC-780051

   LET ps_std_industry = ps_std_industry.trim()
   LET ps_industry = ps_industry.trim()
   #No:FUN-810089 --modify start--  傳進來的檔案都已經分好是否為行業別程式
   IF os.Path.separator() = "/" THEN    #TQC-780051
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF
   IF os.Path.copy(g_temp_path,g_prog_path) THEN
      IF os.Path.delete(g_temp_path) THEN END IF
   END IF
   IF os.Path.separator() = "/" THEN    #TQC-780051
      LET g_cmd = "chmod 777 ",g_prog_path.subString(1,g_prog_path.getIndexOf(".4gl",1)-1),".4gl > /dev/null 2>&1"
      RUN g_cmd
   END IF
END FUNCTION

FUNCTION funname_check(ps_funname)
   DEFINE   ps_funname   STRING
   DEFINE   li_i         SMALLINT
   DEFINE   li_err       SMALLINT

   FOR li_i = 1 TO g_funname.getLength()
       IF g_funname[li_i] = ps_funname THEN
          LET li_err = TRUE
          EXIT FOR
       END IF
   END FOR
   IF li_err THEN
      DISPLAY '此程式所有用到的畫面檔，在p_per所設定的欄位值檢查function name重複'
      RETURN FALSE       #No:FUN-7C0099
   ELSE
      LET g_funname[g_funname.getLength()+1] = ps_funname
      RETURN TRUE        #No:FUN-7C0099
   END IF
END FUNCTION
#No:FUN-7C0099 ---modify end---
# No:FUN-820075 test


#轉換 TODAY -> g_today, CURRENT ( a TO b ) -> cl_current_time( a, b)
FUNCTION program_windows_timezone()

END FUNCTION

#轉換 OPEN WINDOW xxxx WITH FORM "xxx/42f/filename" 加上 $TOP 代表的值
FUNCTION program_openwindow_path()

   DEFINE ls_42mpath  STRING
   DEFINE ls_toplink  STRING

   LET ls_toplink = FGL_GETENV("TOPLINK")
   IF ls_toplink.getIndexOf("Development",1) THEN
      CASE g_db_type 
         WHEN "MSV" LET ls_42mpath = "42mm"   #FUN-A40070
         WHEN "ASE" LET ls_42mpath = "42ma"
         WHEN "IFX" LET ls_42mpath = "42mi"
         WHEN "DB2" LET ls_42mpath = "42md"
         OTHERWISE  LET ls_42mpath = "42m"    #including "ORA"
      END CASE
   ELSE
      LET ls_42mpath = "42m"
   END IF

  #LET g_prog_path = g_top,"/",g_module,"/42m/",g_prog,".4gl"
   LET g_prog_path = os.Path.join(os.Path.join(g_top,g_module),ls_42mpath)
   LET g_prog_path = os.Path.join(g_prog_path,g_prog||".4gl")

  #LET g_temp_path = g_top,"/",g_module,"/42m/",g_module,"_",g_prog,"T3.4gl"
   LET g_temp_path = os.Path.join(os.Path.join(g_top,g_module),ls_42mpath)
   LET g_temp_path = os.Path.join(g_temp_path,g_module||"_"||g_prog||"T3.4gl")

   #檢查檔案內是否有關鍵字 'WITH FORM "'
   IF os.Path.separator() = "/" THEN 
      LET g_cmd = "grep -i 'WITH FORM' ",g_prog_path," > /dev/null 2>&1"
   ELSE
      LET g_cmd = 'findstr "WITH FORM" ', g_prog_path,' >NUL'
   END IF
   RUN g_cmd RETURNING g_cnt

   IF g_cnt THEN
      RETURN
   END IF

   #將舊程式每一行讀進Array (g_org)
   CALL program_in_array(g_prog_path)

   #鎖定檔案
   IF os.Path.separator() = "/" THEN                      #FUN-A40070
      LET g_cmd = "chmod 444 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   #替換WITH FORM,並將新array內容寫入mod_progT.4gl
   CALL program_withform_patch(g_prog_path)

   #覆蓋mod_progT.4gl->mod_prog.4gl,並將檔案解鎖
   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

   LET g_cmd = "mv ",g_temp_path," ",g_prog_path
   RUN g_cmd

   IF os.Path.separator() = "/" THEN                     #FUN-A40070
      LET g_cmd = "chmod 777 ",g_prog_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF

END FUNCTION

#替換WITH FORM,並將新array內容寫入mod_progT.4gl
FUNCTION program_withform_patch(p_prog_path)
   DEFINE   p_prog_path    STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   li_cnt         INTEGER
   DEFINE   ls_tmp,ls_new  STRING
   DEFINE   li_pos         SMALLINT

   FOR li_cnt = 1 TO g_org.getLength()
       IF NOT g_org[li_cnt].getIndexOf("WITH FORM",1) THEN
          CONTINUE FOR
       END IF

       #FUN-BB0159 --start 
       IF NOT g_org[li_cnt].getIndexOf("/42f/",1) THEN
          CONTINUE FOR
       END IF
       #FUN-BB0159 --end

       LET ls_tmp = g_org[li_cnt]
       LET li_pos = g_org[li_cnt].getIndexOf("WITH FORM",1) 
       LET li_pos = g_org[li_cnt].getIndexOf('"',li_pos)
      
       #FUN-BB0159 --start
       IF li_pos = 0 THEN
          LET li_pos = g_org[li_cnt].getIndexOf("WITH FORM",1)
          LET li_pos = g_org[li_cnt].getIndexOf("'",li_pos)
       END IF 
       #FUN-BB0159 --end
      
       IF g_org[li_cnt].subString(li_pos+1, li_pos+1) = "c" THEN
          LET ls_new = g_org[li_cnt].subString(1,li_pos),FGL_GETENV("CUST")
       ELSE
          LET ls_new = g_org[li_cnt].subString(1,li_pos),FGL_GETENV("TOP")
       END IF

       LET ls_new = ls_new,os.Path.separator(),
                    g_org[li_cnt].subString(li_pos + 1, g_org[li_cnt].getLength())
      
       LET g_org[li_cnt] = ls_new
   END FOR

   #寫入檔案
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"w")
   CALL lc_channel.setDelimiter("")
   FOR li_cnt = 1 TO g_org.getLength()
      CALL lc_channel.write(g_org[li_cnt])
   END FOR
   CALL lc_channel.close()

   IF os.Path.separator() = "/" THEN
      LET g_cmd = "chmod 777 ",g_temp_path," > /dev/null 2>&1"
      RUN g_cmd
   END IF
END FUNCTION



FUNCTION program_get_column_info(p_tabname, p_colname) 
   DEFINE p_tabname   LIKE sch_file.sch01
   DEFINE p_colname   LIKE sch_file.sch02
   DEFINE l_sql       STRING
   DEFINE l_sch03     LIKE sch_file.sch03
   DEFINE l_datatype  LIKE type_file.chr14
   DEFINE l_length1   LIKE type_file.num5
   DEFINE l_length2   LIKE type_file.num5 
   DEFINE l_length    STRING
   DEFINE l_tmp       STRING

   LET l_sql=" SELECT sch03, sch04 ",
             "   FROM sch_file ",
             "  WHERE sch01 = '", p_tabname CLIPPED, "'",
             "   AND sch02 = '", p_colname CLIPPED, "'"

   PREPARE program_get_column_info_p FROM l_sql

   IF SQLCA.SQLCODE THEN
      RETURN '',''
   END IF

   EXECUTE program_get_column_info_p INTO l_sch03, l_length1
   LET l_length2 = l_length1 MOD 256  
   LET l_datatype = ""
   CASE
      WHEN l_sch03 = 0 OR l_sch03 = 256
           LET l_length = l_length1
           LET l_datatype = 'char'
      WHEN l_sch03 = 13 OR l_sch03 = 269
           LET l_length = l_length1
           LET l_datatype = "varchar"
      WHEN l_sch03 = 201 OR l_sch03 = 457
           LET l_length = l_length1
           LET l_datatype = "varchar2"
           CASE g_db_type
                WHEN "IFX"
                     LET l_datatype = 'char'
                WHEN "MSV"
                     LET l_datatype = 'nvarchar'
                     LET l_length = l_length1 * 2
                WHEN "ASE"
                     LET l_datatype = 'varchar'
           END CASE
      WHEN l_sch03 = 16 OR l_sch03 = 272
           LET l_length = l_length1
           LET l_datatype = "nvarchar"
      WHEN l_sch03 = 202 OR l_sch03 = 458
           LET l_length = l_length1
           LET l_datatype = "nvarchar2"
      WHEN l_sch03 = 1 OR l_sch03 = 257
           LET l_datatype = 'smallint'
           LET l_length2 = 0
           CASE g_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
                     LET l_length1 = 5
                WHEN "MSV"
                     LET l_length1 = 5
           END CASE
           LET l_tmp=l_length1
           LET l_length=l_tmp CLIPPED,','
           LET l_tmp=l_length2 
           LET l_length=l_length CLIPPED,l_tmp
      WHEN l_sch03 = 2 OR l_sch03 = 258
           LET l_datatype = 'integer'
           LET l_length2 = 0
           CASE g_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
                     LET l_length1 = 10
                WHEN "MSV"
                     LET l_length1 = 10
           END CASE
           LET l_tmp=l_length1
           LET l_length=l_tmp CLIPPED,','
           LET l_tmp=l_length2 
           LET l_length=l_length CLIPPED,l_tmp
      WHEN l_sch03 = 5 OR l_sch03 = 261
           LET l_length1 = l_length1 / 256 USING '&&' CLIPPED
           LET l_length2 = l_length2 CLIPPED
           LET l_tmp=l_length1
           LET l_length=l_tmp CLIPPED,','
           LET l_tmp=l_length2 
           LET l_length=l_length CLIPPED,l_tmp
           LET l_datatype = "decimal"
           CASE g_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
           END CASE
      WHEN l_sch03 = 7 OR l_sch03 = 263
           LET l_datatype = 'date'
           LET l_length = 10
      WHEN l_sch03 = 11 OR l_sch03 = 267
           LET l_datatype = 'binary'
           LET l_length = l_length1
           CASE g_db_type
                WHEN "IFX"
                     LET l_datatype = 'byte'
                WHEN "MSV"
                     LET l_datatype = 'image'
                WHEN "ORA"
                     LET l_datatype = 'blob'
           END CASE
      OTHERWISE
   END CASE   

   RETURN l_datatype, l_length
END FUNCTION
#---FUN-A90024---end-------


FUNCTION program_cat_datamask_function()     #FUN0-BC0056

   DEFINE lc_channel   base.Channel
   DEFINE lc_gdv       RECORD LIKE gdv_file.*
   DEFINE ls_tmp       STRING
   DEFINE ls_tabname   STRING
   DEFINE li_status    SMALLINT
   DEFINE l_tag        SMALLINT                # No:DEV-C50001
   DEFINE lc_path      STRING                  # No:FUN-CA0016
   DEFINE lc_h         LIKE type_file.num5     # No:FUN-CA0016
   DEFINE lc_result    STRING                  # No:FUN-CA0016
   DEFINE lc_file      STRING                  # No:FUN-CA0016


   # No:FUN-CA0016 ---start---
   # 安全機制程式不須加上個資功能
   # 為避免後續有新增安全機制程式，但是卻未排除個資功能，
   # 因此需檢查放置安全機制程式的目錄，確認目前編譯的程式是否為安全機制程式，
   # 若是，則不加上個資功能
   LET lc_path = os.Path.join(os.Path.join(FGL_GETENV("DS4GL"),"bin"),"ora")
   CALL os.Path.dirsort("name", 1)
   LET lc_h = os.Path.diropen(lc_path)
   WHILE lc_h > 0
      LET lc_result = os.Path.dirnext(lc_h)
      IF lc_result IS NULL THEN
         EXIT WHILE
      END IF
      IF lc_result = "." OR lc_result = ".." THEN
         CONTINUE WHILE
      END IF

      LET lc_file = os.Path.rootname(os.Path.basename(lc_result))
      IF lc_file.subString(5,lc_file.getLength()) = g_prog THEN
         RETURN
      END IF
   END WHILE
   CALL os.Path.dirclose(lc_h)
   # No:FUN-CA0016 --- end ---

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_temp_path,"a")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("")

   CALL lc_channel.write("#個資遮罩功能 --- start --")
   CALL lc_channel.write("FUNCTION cl_set_data_mask_detail(pc_type) ")

   CALL lc_channel.write("   DEFINE li_count   LIKE type_file.num5")
   CALL lc_channel.write("   DEFINE ls_lock    STRING")
   CALL lc_channel.write("   DEFINE ls_field   STRING")
   CALL lc_channel.write("   DEFINE pc_type    LIKE type_file.chr1")
   CALL lc_channel.write("   DEFINE li_start   LIKE type_file.num10")
   CALL lc_channel.write("   DEFINE li_end     LIKE type_file.num10")

   #DEV-C50001 -- start--
   #CALL program_chk_forupd_sql(g_prog,g_temp_path) RETURNING li_status,ls_tabname  #No.FUN-BC0056   # No:FUN-CA0016

   #LET ls_tabname = ls_tabname.trim()
   #IF li_status THEN
   LET lc_gdv.gdv01 = g_prog.trim()

   LET l_tag = FALSE

   DECLARE cl_set_data_mask_d_cs CURSOR FOR
    SELECT * FROM gdv_file WHERE gdv01=lc_gdv.gdv01 #OR gdv01=others
   
   FOREACH cl_set_data_mask_d_cs INTO lc_gdv.*
   
      IF STATUS THEN EXIT FOREACH END IF

      #只有第一次時需要產生
      IF l_tag = FALSE  THEN
          LET l_tag = TRUE
          CALL lc_channel.write("   ")
          CALL lc_channel.write("   IF g_azz.azz17 IS NOT NULL AND g_azz.azz17 = \"N\" THEN  #明示為N時不管")
          CALL lc_channel.write("      RETURN")
          CALL lc_channel.write("   END IF")
       
          CALL lc_channel.write("   LET ls_lock  = \"\"")
          CALL lc_channel.write("   LET ls_field = \"\"")
          CALL lc_channel.write("   ")
      END IF

   #  CALL top_chk_dyarr_id.chk_forupd_sql(g_prog,lc_gdv.gdv02) RETURNING li_status,ls_tabname  #No.FUN-BC0056   # No:FUN-CA0016
      CALL program_chk_forupd_sql(g_prog,lc_gdv.gdv02) RETURNING li_status,ls_tabname  #No.FUN-BC0056   # No:FUN-CA0016
      IF li_status THEN
         LET ls_tabname = ls_tabname.trim()
         CALL lc_channel.write("   #Field - "||lc_gdv.gdv02 CLIPPED )
         CALL lc_channel.write("   LET ls_field = ls_field,'"||lc_gdv.gdv02 CLIPPED||",'")


         CALL lc_channel.write("   LET li_start = 1")
         CALL lc_channel.write("   LET li_end = g_"||ls_tabname||".getLength()")

                  LET ls_tmp = "   IF NOT cl_set_data_mask_chk('",lc_gdv.gdv07 CLIPPED,"','",lc_gdv.gdv08 CLIPPED,"') THEN"

         CALL lc_channel.write(ls_tmp)
         CALL lc_channel.write("      FOR li_count = li_start TO li_end")
         CALL lc_channel.write("         LET g_"||ls_tabname||"[li_count]."||lc_gdv.gdv02||" =")
         CALL lc_channel.write("             cl_set_data_mask_method('"||lc_gdv.gdv01||"','"||lc_gdv.gdv02||"',g_"||ls_tabname||"[li_count]."||lc_gdv.gdv02||")")
         CALL lc_channel.write("      END FOR")
         CALL lc_channel.write("      LET ls_lock = ls_lock,'"||lc_gdv.gdv02 CLIPPED||",'")
         CALL lc_channel.write("   END IF")
         CALL lc_channel.write("   ")
      END IF

   END FOREACH

   #只有第一次時需要產生
   IF l_tag = TRUE  THEN
      CALL lc_channel.write("   LET ls_field = ls_field.subString(1,ls_field.getLength()-1)")
      CALL lc_channel.write("   CALL cl_set_comp_entry(ls_field,TRUE)")
      CALL lc_channel.write("   CALL cl_set_comp_entry(ls_lock,FALSE)")
   END IF
   
   #END IF
   #DEV-C50001 -- start--

   CALL lc_channel.write("END FUNCTION")
   CALL lc_channel.write("#個資遮罩功能 --- end --")
   CALL lc_channel.write("")
   CALL lc_channel.close()

END FUNCTION

# No:FUN-CA0016 ---start---
FUNCTION program_chk_forupd_sql(ls_prog,ls_field)   #No:DEV-C50001

  DEFINE ch_read        base.channel
  DEFINE ls_fileread    STRING                
  DEFINE ls_source      STRING
  DEFINE ls_tmp         STRING
  DEFINE ls_backup      STRING
  DEFINE li_chk1        LIKE type_file.num10
  DEFINE ls_prog        STRING
  DEFINE ls_field       STRING               #No:DEV-C50001
  DEFINE li_status      LIKE type_file.num10 
  DEFINE lc_gdv01       LIKE gdv_file.gdv01
  DEFINE ls_return      STRING
  DEFINE l_sql          STRING               #No:DEV-C50001  
  DEFINE l_module       STRING               #No:DEV-C50001  
  DEFINE l_buf          base.StringBuffer    #No:DEV-C50001
  DEFINE l_doc          om.DomDocument       #No:DEV-C50001
  DEFINE l_root         om.DomNode           #No:DEV-C50001
  DEFINE l_record       om.DomNode           #No:DEV-C50001
  DEFINE l_pnode        om.DomNode           #No:DEV-C50001
  DEFINE l_list         om.NodeList          #No:DEV-C50001

  LET lc_gdv01 = ls_prog.trim()
  SELECT count(*) INTO li_chk1 FROM gdv_file WHERE gdv01 = lc_gdv01
  IF li_chk1 > 0 THEN
     LET li_status = TRUE 
  ELSE 
     LET li_status = FALSE 
  END IF
  #No:DEV-C50001 -- start --
  IF li_status = TRUE THEN
     LET l_module = ARG_VAL(2)
     LET ls_fileread = os.Path.join(os.Path.join(FGL_GETENV("TOP"),l_module),"42f")
     LET ls_fileread = os.Path.join(ls_fileread,lc_gdv01||".42f")

     LET l_doc = om.DomDocument.createFromXmlFile(ls_fileread)
     INITIALIZE l_root TO NULL
     IF l_doc IS NOT NULL THEN
        LET l_root = l_doc.getDocumentElement()
        LET l_list = l_root.selectByPath("//TableColumn[@colName=\"" || ls_field.trim() || "\"]")
        IF l_list.getLength() > 0 THEN
           LET l_record = l_list.item(1)
           LET l_pnode = l_record.getParent()
           LET ls_tmp = l_pnode.getAttribute("tabName")
           LET ls_return = ls_tmp.subString(ls_tmp.getIndexOf("_",1)+1,ls_tmp.getLength())
           LET li_status = TRUE 
        ELSE
           LET ls_return = ""
           LET li_status = FALSE
        END IF
     END IF
  END IF

  #mark 拿掉 
  #LET ch_read = base.Channel.create() 

  #CALL ch_read.openFile(ls_fileread, "r") 
  #CALL ch_read.setDelimiter("")

  #WHILE TRUE    #ch_read.read(ls_source)

  #    LET ls_source = ch_read.readLine()
  #    IF ch_read.iseof() THEN EXIT WHILE END IF

  #    LET ls_tmp = ls_source.trim()

  #    IF ls_tmp.subString(1,1) = "#" OR ls_tmp.subString(1,1) = "{" OR ls_tmp.subString(1,2) = "--" THEN
  #       LET ls_tmp = ""
  #    ELSE
  #       LET ls_tmp = ls_source.tolowercase()
  #    END IF
  #    IF ls_tmp.getIndexOf("#",1) THEN
  #       LET ls_tmp = ls_tmp.subString(1,ls_tmp.getIndexOf("#",1)-1)
  #    END IF

  #    #偵測到 MAIN or FUNCTION則停止
  #    IF ls_tmp.getIndexOf("main",1) OR ls_tmp.getIndexOf("function ",1) THEN
  #       EXIT WHILE
  #    END IF

  #    #抓取 "dynamic array "
  #    IF ls_tmp.getIndexOf("dynamic array of record",1) THEN
  #       LET ls_tmp = ls_tmp.trim()
  #       LET ls_return = ls_tmp.subString(ls_tmp.getIndexOf("_",1)+1,
  #                                     ls_tmp.getIndexOf("dynamic array",1)-1)
  #       LET ls_return = ls_return.trim()

  #       #排除系統內有特殊用途的DYNAMIC ARRAY #暫時排除 p_zx 與 axmi221單檔使用 dynamic array問題
  #       IF ls_return.getLength() > 8 OR ls_return.getIndexOf("_",3) THEN 
  #          LET ls_return = ""
  #          CONTINUE WHILE
  #       END IF
  #       EXIT WHILE
  #    END IF

  #    LET ls_backup = ls_source

  #END WHILE 
  #IF ls_return.getLength() < 1 THEN 
  #   LET li_status = FALSE
  #END IF
  #CALL ch_read.close() 
  #No:DEV-C50001 -- end --

  RETURN li_status,ls_return
END FUNCTION
# No:FUN-CA0016 --- end ---
