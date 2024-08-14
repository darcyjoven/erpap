#比對指定patch schema與原有資料庫的schema們差異,並顯示報表 2007 by saki

# Parameter 1 : New Schema File Path
# Parameter 2 : New Index File Path
# Parameter 3 : Result Log Path

IMPORT os

DATABASE ds

TYPE   g_report    DYNAMIC ARRAY OF RECORD
         dbs       LIKE azp_file.azp03,
         action    STRING,
         table     STRING,
         memo      STRING,
         cmd       STRING
                   END RECORD

DEFINE g_sql       STRING
DEFINE g_db_type   CHAR(3)
DEFINE g_cnt       SMALLINT
DEFINE g_cmd       STRING
DEFINE g_sqlcmd    g_report
DEFINE g_illegal   g_report
DEFINE g_idxcmd    g_report
DEFINE g_idxill    g_report
DEFINE g_effect    g_report
DEFINE g_efftmp    DYNAMIC ARRAY OF STRING
DEFINE g_sqlcnt    INTEGER
DEFINE g_illcnt    INTEGER
DEFINE g_idxcnt    INTEGER
DEFINE g_ildcnt    INTEGER
DEFINE g_effcnt    INTEGER
DEFINE g_msg       STRING

MAIN
   DEFINE lr_azp03         DYNAMIC ARRAY OF LIKE azp_file.azp03
   DEFINE ls_new_schpath   STRING
   DEFINE ls_old_schpath   STRING
   DEFINE ls_std_schpath   STRING
   DEFINE ls_new_idxpath   STRING
   DEFINE ls_old_idxpath   STRING
   DEFINE ls_std_idxpath   STRING
   DEFINE ls_log_path      STRING
   DEFINE li_i             INTEGER
   DEFINE ls_result_path   STRING
   DEFINE ls_name          STRING
   DEFINE lc_channel       base.Channel
   DEFINE ls_result        STRING


   LET ls_new_schpath = ARG_VAL(1)
   LET ls_new_idxpath = ARG_VAL(2)
   LET ls_log_path    = ARG_VAL(3)
   IF ls_log_path IS NULL THEN
      LET ls_log_path = FGL_GETENV("TEMPDIR"),os.Path.separator()
   END IF

   IF NOT os.Path.exists(ls_new_schpath) THEN
      DISPLAY ls_new_schpath," 不存在, 不進行原有schema與欲更新schema比對"
      RETURN
   END IF
   IF NOT os.Path.exists(ls_new_idxpath) THEN
      DISPLAY ls_new_idxpath," 不存在, 不進行原有index schema與欲更新index schema比對"
      RETURN
   END IF

   LET g_db_type = DB_GET_DATABASE_TYPE()

   IF g_db_type="IFX" THEN
      LET g_sql="SELECT azp03 FROM azp_file WHERE azp053='Y' ORDER BY azp03"
   ELSE
      LET g_sql="SELECT azp03 FROM azp_file WHERE azp053='Y'",
                " AND UPPER(azp03) in (select username from all_users) ORDER BY azp03"
   END IF
   PREPARE azp03_pre FROM g_sql
   DECLARE azp03_curs CURSOR FOR azp03_pre
   LET g_cnt = 1
   FOREACH azp03_curs INTO lr_azp03[g_cnt]
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL lr_azp03.deleteElement(g_cnt)

   IF g_db_type="IFX" THEN
      CLOSE DATABASE
      DATABASE sysmaster
      FOR li_i = lr_azp03.getLength() TO 1 STEP -1
          SELECT COUNT(*) INTO g_cnt FROM sysdatabases WHERE name = lr_azp03[li_i]
          IF g_cnt <= 0 THEN
             CALL lr_azp03.deleteElement(li_i)
          END IF
      END FOR
      CLOSE DATABASE
      DATABASE ds
   END IF

   LET ls_std_schpath = os.Path.dirname(os.Path.dirname(FGL_GETENV("TOP"))),
                        os.Path.separator(),"topstd",os.Path.separator(),"tiptop",
                        os.Path.separator(),"schema",os.Path.separator(),"ds.sch"
   IF NOT os.Path.exists(ls_std_schpath) THEN
      DISPLAY ls_std_schpath," 不存在, 不進行原出貨資料庫schema檢查"
   END IF
   LET ls_std_idxpath = os.Path.dirname(os.Path.dirname(FGL_GETENV("TOP"))),
                        os.Path.separator(),"topstd",os.Path.separator(),"tiptop",
                        os.Path.separator(),"schema",os.Path.separator(),"ds_idx.sch"
   IF NOT os.Path.exists(ls_std_idxpath) THEN
      DISPLAY ls_std_idxpath," 不存在, 不進行原出貨index schema檢查"
   END IF

   LET g_sqlcnt = 0
   LET g_illcnt = 0
   LET g_idxcnt = 1
   LET g_ildcnt = 1
   LET g_effcnt = 1
   FOR li_i = 1 TO lr_azp03.getLength()
       LET ls_old_schpath = FGL_GETENV("TOP"),os.Path.separator(),"schema",
                            os.Path.separator(),lr_azp03[li_i] CLIPPED,".sch"
       IF NOT os.Path.exists(ls_old_schpath) THEN
          IF g_db_type="IFX" THEN
             LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",lr_azp03[li_i] CLIPPED," -ie"
             RUN g_cmd 
          ELSE
             LET g_cmd = "cd $FGLDBPATH;fgldbsch -db ",lr_azp03[li_i] CLIPPED," -ow ",lr_azp03[li_i] CLIPPED," -ie"
             RUN g_cmd 
          END IF
       END IF

       LET ls_old_idxpath = FGL_GETENV("TOP"),os.Path.separator(),"schema",
                            os.Path.separator(),lr_azp03[li_i] CLIPPED,"_idx.sch"
       IF NOT os.Path.exists(ls_old_idxpath) THEN
          LET g_cmd = "$FGLRUN $DS4GL/bin/gen_index.42r ",lr_azp03[li_i] CLIPPED
          RUN g_cmd
       END IF

       # 比對測試區schema與patch schema
       IF os.Path.exists(ls_old_schpath) AND os.Path.exists(ls_new_schpath) THEN
          DISPLAY "開始",lr_azp03[li_i] CLIPPED,"與patch schema比對"
          LET g_cmd = "diffdb.sh ds_patch ",lr_azp03[li_i] CLIPPED," 5 ",ls_new_schpath," ",ls_old_schpath," Y"
          RUN g_cmd
       END IF

       # 比對測試區index schema與patch index schema
       IF os.Path.exists(ls_old_idxpath) AND os.Path.exists(ls_new_idxpath) THEN
          DISPLAY "開始",lr_azp03[li_i] CLIPPED,"與patch index schema比對"
          LET g_cmd = "diffdb.sh ds_patch ",lr_azp03[li_i] CLIPPED," 6 ",ls_new_idxpath," ",ls_old_idxpath," Y"
          RUN g_cmd
       END IF

       LET ls_result_path = FGL_GETENV("TEMPDIR"),os.Path.separator(),
                            lr_azp03[li_i] CLIPPED,"_command.sql"
       IF os.Path.exists(ls_result_path) THEN
          CALL compare_schema_report(lr_azp03[li_i] CLIPPED,ls_result_path)
          IF os.Path.copy(ls_result_path,ls_log_path||lr_azp03[li_i] CLIPPED||"_command.sql") THEN END IF
       END IF

       LET ls_result_path = FGL_GETENV("TEMPDIR"),os.Path.separator(),
                            lr_azp03[li_i] CLIPPED,"_index.sql"
       IF os.Path.exists(ls_result_path) THEN
          LET lc_channel = base.Channel.create()
          CALL lc_channel.openFile(ls_result_path,"r")
          WHILE lc_channel.read(ls_result)
             LET g_idxcmd[g_idxcnt].dbs = lr_azp03[li_i] CLIPPED
             LET g_idxcmd[g_idxcnt].cmd = ls_result
             LET g_idxcnt = g_idxcnt + 1
          END WHILE
          CALL lc_channel.close()
          IF os.Path.copy(ls_result_path,ls_log_path||lr_azp03[li_i] CLIPPED||"_index.sql") THEN END IF
       END IF

       #比對出貨安裝schema與目前schema差異
       IF os.Path.exists(ls_old_schpath) AND os.Path.exists(ls_std_schpath) THEN
          DISPLAY "開始比對",lr_azp03[li_i] CLIPPED,"是否有自行建立非客製的schema"
          LET g_cmd = "diffdb.sh ",lr_azp03[li_i] CLIPPED," ds 5 ",ls_old_schpath," ",ls_std_schpath," Y"
          RUN g_cmd
       END IF

       #比對出貨安裝index schema與目前index schema差異
       IF os.Path.exists(ls_old_idxpath) AND os.Path.exists(ls_std_idxpath) THEN
          DISPLAY "開始比對",lr_azp03[li_i] CLIPPED,"是否有自行建立非客製的schema"
          LET g_cmd = "diffdb.sh ",lr_azp03[li_i] CLIPPED," ds 6 ",ls_old_idxpath," ",ls_std_idxpath," Y"
          RUN g_cmd
       END IF

       LET ls_result_path = FGL_GETENV("TEMPDIR"),os.Path.separator(),"ds_command.sql"
       IF os.Path.exists(ls_result_path) THEN
          CALL compare_schema_illegal(lr_azp03[li_i] CLIPPED,ls_result_path)
          IF os.Path.copy(ls_result_path,ls_log_path||"ds_command.sql") THEN END IF
       END IF

       LET ls_result_path = FGL_GETENV("TEMPDIR"),os.Path.separator(),"ds_index.sql"
       IF os.Path.exists(ls_result_path) THEN
          LET lc_channel = base.Channel.create()
          CALL lc_channel.openFile(ls_result_path,"r")
          WHILE lc_channel.read(ls_result)
             LET g_idxill[g_ildcnt].dbs = lr_azp03[li_i] CLIPPED
             LET g_idxill[g_ildcnt].cmd = ls_result
             LET g_ildcnt = g_ildcnt + 1
          END WHILE
          CALL lc_channel.close()
          IF os.Path.copy(ls_result_path,ls_log_path||"ds_index.sql") THEN END IF
       END IF

       #將要對ds異動的SQL對客製程式的影響
       LET ls_result_path = FGL_GETENV("TEMPDIR"),os.Path.separator(),"ds_command.sql"
       IF os.Path.exists(ls_result_path) AND lr_azp03[li_i] = "ds" THEN
          DISPLAY "開始偵測ds資料庫更新所影響的客製程式列表"
          CALL compare_schema_alter_effect()
       END IF
   END FOR

   LET ls_name = ls_log_path,"compare_schema.txt"
   START REPORT compare_schema_rep to ls_name
   FOR li_i = 1 TO g_sqlcmd.getLength()
       IF g_sqlcmd[li_i].dbs IS NOT NULL THEN
          OUTPUT TO REPORT compare_schema_rep(g_sqlcmd[li_i].*,"1")
       END IF
   END FOR
   FOR li_i = 1 TO g_illegal.getLength()
       IF g_illegal[li_i].dbs IS NOT NULL THEN
          OUTPUT TO REPORT compare_schema_rep(g_illegal[li_i].*,"2")
       END IF
   END FOR
   FOR li_i = 1 TO g_idxcmd.getLength()
       IF g_idxcmd[li_i].dbs IS NOT NULL THEN
          OUTPUT TO REPORT compare_schema_rep(g_idxcmd[li_i].*,"3")
       END IF
   END FOR
   FOR li_i = 1 TO g_idxill.getLength()
       IF g_idxill[li_i].dbs IS NOT NULL THEN
          OUTPUT TO REPORT compare_schema_rep(g_idxill[li_i].*,"4")
       END IF
   END FOR
   FOR li_i = 1 TO g_effect.getLength()
       IF g_effect[li_i].cmd IS NOT NULL THEN
          OUTPUT TO REPORT compare_schema_rep(g_effect[li_i].*,"5")
       END IF
   END FOR
   FINISH REPORT compare_schema_rep
   LET g_cmd = "$FGLRUN $AZZ/42r/p_view.42r ",ls_name," 66"
   RUN g_cmd
END MAIN

FUNCTION compare_schema_report(ps_dbs,ps_result_path)
   DEFINE ps_dbs           LIKE azp_file.azp03
   DEFINE ps_result_path   STRING
   DEFINE ps_work          STRING
   DEFINE lc_channel       base.Channel
   DEFINE ls_result        STRING
   DEFINE ls_tmp           STRING
   DEFINE li_i             SMALLINT
   DEFINE li_exist         SMALLINT

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_result_path,"r")
   WHILE lc_channel.read(ls_result)
      IF g_db_type = "IFX" THEN
         IF ls_result IS NULL OR (ls_result.subString(1,2) = "{ " AND ls_result.subString(ls_result.getLength()-1,ls_result.getLength()) = " }") THEN
            LET g_sqlcnt = g_sqlcnt + 1
            IF ls_result IS NOT NULL THEN
               LET g_sqlcmd[g_sqlcnt].memo = ls_result.subString(3,ls_result.getLength()-2)
            END IF
            CONTINUE WHILE
         END IF
      ELSE
         IF ls_result IS NULL OR (ls_result.subString(1,2) = "/*" AND ls_result.subString(ls_result.getLength()-1,ls_result.getLength()) = "*/") THEN
            LET g_sqlcnt = g_sqlcnt + 1
            IF ls_result IS NOT NULL THEN
               LET g_sqlcmd[g_sqlcnt].memo = ls_result.subString(4,ls_result.getLength()-2)
            END IF
            CONTINUE WHILE
         END IF
      END IF

      CASE
         WHEN ls_result.subString(1,12) = "create table"
            LET g_sqlcmd[g_sqlcnt].action = "Create Table"
            LET g_sqlcmd[g_sqlcnt].table = ls_result.subString(14,ls_result.getIndexOf("(",1)-1)
            LET g_sqlcmd[g_sqlcnt].cmd = ls_result
            LET g_sqlcmd[g_sqlcnt].dbs = ps_dbs
         WHEN ls_result.subString(1,11) = "alter table"
            LET ls_tmp = ls_result.subString(13,ls_result.getLength())
            CASE
               WHEN ls_tmp.getIndexOf("modify(",1)
                  LET g_sqlcmd[g_sqlcnt].action = "Modify Column"
                  LET g_sqlcmd[g_sqlcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" modify(",1)-1)
               WHEN ls_tmp.getIndexOf("add(",1)
                  LET g_sqlcmd[g_sqlcnt].action = "Add Column"
                  LET g_sqlcmd[g_sqlcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" add(",1)-1)
               WHEN ls_tmp.getIndexOf("drop(",1)
                  LET g_sqlcmd[g_sqlcnt].action = "Drop Column"
                  LET g_sqlcmd[g_sqlcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" drop(",1)-1)
                  IF g_sqlcmd[g_sqlcnt].memo IS NULL THEN
                     LET g_sqlcmd[g_sqlcnt].memo = "此Column不為客製命名欄位"
                  ELSE
                     LET g_sqlcmd[g_sqlcnt].memo = g_sqlcmd[g_sqlcnt].memo,"\n此Column不為客製命名欄位"
                  END IF
            END CASE
            LET g_sqlcmd[g_sqlcnt].cmd = ls_result
            LET g_sqlcmd[g_sqlcnt].dbs = ps_dbs
         OTHERWISE
            LET g_sqlcnt = g_sqlcnt + 1
            LET g_sqlcmd[g_sqlcnt].cmd = ls_result
            LET g_sqlcmd[g_sqlcnt].dbs = ps_dbs
      END CASE

      #把ds更動的東西倒到g_efftmp
      IF g_sqlcmd[g_sqlcnt].dbs = "ds" THEN
         LET li_exist = FALSE
         IF g_efftmp.getLength() > 0 THEN
            FOR li_i = 1 TO g_efftmp.getLength()
                IF g_sqlcmd[g_sqlcnt].table = g_efftmp[li_i] OR
                   g_sqlcmd[g_sqlcnt].table IS NULL THEN
                   LET li_exist = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_exist THEN
               LET g_efftmp[g_effcnt] = g_sqlcmd[g_sqlcnt].table
               LET g_effcnt = g_effcnt + 1
            END IF
         ELSE
            LET g_efftmp[g_effcnt] = g_sqlcmd[g_sqlcnt].table
            LET g_effcnt = g_effcnt + 1
         END IF
      END IF
   END WHILE
   CALL lc_channel.close()
END FUNCTION

FUNCTION compare_schema_illegal(ps_dbs,ps_result_path)
   DEFINE ps_dbs           LIKE azp_file.azp03
   DEFINE ps_result_path   STRING
   DEFINE ps_work          STRING
   DEFINE lc_channel       base.Channel
   DEFINE ls_result        STRING
   DEFINE ls_tmp           STRING
   DEFINE ls_field         STRING

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_result_path,"r")
   WHILE lc_channel.read(ls_result)
      IF g_db_type = "IFX" THEN
         IF ls_result IS NULL OR (ls_result.subString(1,2) = "{ " AND ls_result.subString(ls_result.getLength()-1,ls_result.getLength()) = " }") THEN
            LET g_illcnt = g_illcnt + 1
            IF ls_result IS NOT NULL THEN
               LET g_illegal[g_illcnt].memo = ls_result.subString(3,ls_result.getLength()-2)
            END IF
            CONTINUE WHILE
         END IF
      ELSE
         IF ls_result IS NULL OR (ls_result.subString(1,2) = "/*" AND ls_result.subString(ls_result.getLength()-1,ls_result.getLength()) = "*/") THEN
            LET g_illcnt = g_illcnt + 1
            IF ls_result IS NOT NULL THEN
               LET g_illegal[g_illcnt].memo = ls_result.subString(4,ls_result.getLength()-2)
            END IF
            CONTINUE WHILE
         END IF
      END IF

      CASE
         WHEN ls_result.subString(1,12) = "create table"
            LET g_illegal[g_illcnt].action = "非客製命名的Table"
            LET g_illegal[g_illcnt].table = ls_result.subString(14,ls_result.getIndexOf("(",1)-1)
            LET g_illegal[g_illcnt].dbs = ps_dbs
         WHEN ls_result.subString(1,11) = "alter table"
            LET ls_tmp = ls_result.subString(13,ls_result.getLength())
            LET g_illegal[g_illcnt].dbs = ps_dbs
            CASE
               WHEN ls_tmp.getIndexOf("modify(",1)
                  LET g_illegal[g_illcnt].action = "修改過Type的欄位"
                  LET g_illegal[g_illcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" modify(",1)-1)
               WHEN ls_tmp.getIndexOf("add(",1)
                  LET g_illegal[g_illcnt].action = "新增非客製命名的欄位"
                  LET g_illegal[g_illcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" add(",1)-1)
                  LET ls_tmp = ls_tmp.subString(ls_tmp.getIndexOf("add(",1)+4,ls_tmp.getLength())
                  IF ls_tmp.subString(1,3) = "ta_" THEN
                     CALL g_illegal.deleteElement(g_illcnt)
                     LET g_illcnt = g_illcnt - 1
                  END IF
               WHEN ls_tmp.getIndexOf("drop(",1)
                  LET g_illegal[g_illcnt].action = "刪除標準欄位"
                  LET g_illegal[g_illcnt].table = ls_tmp.subString(1,ls_tmp.getIndexOf(" drop(",1)-1)
            END CASE
      END CASE
   END WHILE
   CALL lc_channel.close()
END FUNCTION

FUNCTION compare_schema_alter_effect()
   DEFINE li_i         SMALLINT
   DEFINE lc_channel   base.Channel
   DEFINE ls_result    STRING

   LET lc_channel = base.Channel.create()
   LET g_effcnt = 1
   FOR li_i = 1 TO g_efftmp.getLength()
       LET g_cmd = "find $CUST/*/4gl/ -name '*.4gl' -exec grep -nil '",g_efftmp[li_i],"' {} \\;"
       CALL lc_channel.openPipe(g_cmd,"r")
       WHILE lc_channel.read(ls_result)
          LET g_effect[g_effcnt].dbs = "ds"
          LET g_effect[g_effcnt].table = g_efftmp[li_i]
          LET g_effect[g_effcnt].cmd = ls_result
          LET g_effcnt = g_effcnt + 1
       END WHILE
   END FOR
   CALL lc_channel.close()
END FUNCTION

REPORT compare_schema_rep(pr_sqlcmd,ps_work)
   DEFINE pr_sqlcmd     RECORD
             dbs        LIKE azp_file.azp03,
             action     STRING,
             table      STRING,
             memo       STRING,
             cmd        STRING
                        END RECORD
   DEFINE ps_work       STRING

   OUTPUT
      TOP MARGIN 1
      LEFT MARGIN 5
      BOTTOM MARGIN 5
      PAGE LENGTH 66

   FORMAT
      PAGE HEADER
         IF ps_work = "1" THEN
            PRINT COLUMN 30,"資料庫 - ",pr_sqlcmd.dbs CLIPPED," 與將更新的Schema比對結果 <將會進行的alter動作>"
            PRINT ""
            PRINT "處理動作",COLUMN 17,"處理table",COLUMN 33,"備註",COLUMN 74,"指令"
            PRINT "=============== =============== ======================================== ============================================================"
         ELSE
            IF ps_work = "2" THEN
               PRINT COLUMN 30,"資料庫 - ",pr_sqlcmd.dbs CLIPPED," 與標準出貨的Schema比對結果 <檢查是否未照客製原則alter>"
               PRINT ""
               PRINT "處理動作",COLUMN 17,"處理table",COLUMN 33,"備註"
               PRINT "=============== =============== ========================================"
            ELSE
               IF ps_work = "3" THEN
                  PRINT COLUMN 30,"資料庫 - ",pr_sqlcmd.dbs CLIPPED," 與將更新的Index Schema比對結果 <將會進行的alter動作>"
                  PRINT ""
                  PRINT "處理指令"
                  PRINT "================================================================================"
               ELSE
                  IF ps_work = "4" THEN
                     PRINT COLUMN 30,"資料庫 - ",pr_sqlcmd.dbs CLIPPED," 與標準出貨的Index Schema比對結果 <檢查是否未照客製原則alter>"
                     PRINT ""
                     PRINT "差異指令"
                     PRINT "================================================================================"
                  ELSE
                     IF ps_work = "5" THEN
                        PRINT COLUMN 30,"資料庫 - ",pr_sqlcmd.dbs CLIPPED," 更動影響的客製程式"
                        PRINT ""
                        PRINT "處理Table",COLUMN 17,"影響程式"
                        PRINT "=============== ================================================="
                     ELSE
                        SKIP 4 LINE
                     END IF
                  END IF
               END IF
            END IF
         END IF

      BEFORE GROUP OF ps_work
         SKIP TO TOP OF PAGE

      BEFORE GROUP OF pr_sqlcmd.dbs
         SKIP TO TOP OF PAGE

      BEFORE GROUP OF pr_sqlcmd.table
         IF ps_work = "5" THEN
            PRINT pr_sqlcmd.table;
         END IF

      ON EVERY ROW
         CASE
            WHEN ps_work = "1"
               PRINT pr_sqlcmd.action,
                     COLUMN 17,pr_sqlcmd.table,
                     COLUMN 33,pr_sqlcmd.memo,
                     COLUMN 74,pr_sqlcmd.cmd
            WHEN ps_work = "2"
               PRINT pr_sqlcmd.action,
                     COLUMN 17,pr_sqlcmd.table,
                     COLUMN 33,pr_sqlcmd.memo
            WHEN ps_work = "3"
               PRINT pr_sqlcmd.cmd
            WHEN ps_work = "4"
               PRINT pr_sqlcmd.cmd
            WHEN ps_work = "5"
               PRINT COLUMN 17,pr_sqlcmd.cmd
         END CASE

      PAGE TRAILER
         IF ps_work = "1" THEN
            PRINT "=============== =============== ======================================== ============================================================"
         ELSE
            IF ps_work = "2" THEN
               PRINT "=============== =============== ========================================"
            ELSE
               IF ps_work = "3" THEN
                  PRINT "================================================================================"
               ELSE
                  IF ps_work = "4" THEN
                     PRINT "================================================================================"
                  ELSE
                     IF ps_work = "5" THEN
                        PRINT "=============== ================================================="
                     ELSE
                        SKIP 1 LINE
                     END IF
                  END IF
               END IF
            END IF
         END IF
END REPORT
