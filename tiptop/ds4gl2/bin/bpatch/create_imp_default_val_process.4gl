# 自動產生預設值匯入作業 2007 by saki
# 產生import_default_value_版號.4gl 版更時帶入各資料庫執行
# 若未指定log檔, 則於$TEMPDIR底下patch_data_fill.log記錄

# Parameter 1 : Old Version or "p_alt"
# Parameter 2 : New Version or field_name
# Parameter 3 : Create file path
# Parameter 4 : Convert Tool

IMPORT os

DATABASE ds

DEFINE g_db_type LIKE type_file.chr3
MAIN
   DEFINE ls_ver_old      STRING
   DEFINE ls_ver_new      STRING
   DEFINE ls_create_path  STRING
   DEFINE ls_convert      STRING
   DEFINE ls_ver          STRING
   DEFINE lc_zs06         LIKE zs_file.zs06
   DEFINE lr_zs           DYNAMIC ARRAY OF RECORD
             tablename    STRING,
             fieldname    STRING
                          END RECORD
   DEFINE ls_tablename    STRING
   DEFINE ls_fieldname    STRING
   DEFINE lr_zte          DYNAMIC ARRAY OF RECORD LIKE zte_file.*
   DEFINE li_cnt          SMALLINT
   DEFINE lc_channel      base.Channel
   DEFINE ls_sql          STRING
   DEFINE ls_str          STRING
   DEFINE ls_cmd          STRING
   DEFINE ls_impfun_path  STRING
   DEFINE ls_fun_name     STRING
   DEFINE lr_fun_name     DYNAMIC ARRAY OF STRING
   DEFINE li_i            SMALLINT
   DEFINE li_k            SMALLINT
   DEFINE li_result       SMALLINT
   DEFINE ls_fun_path     STRING
   DEFINE ls_fgldir       STRING
   DEFINE ls_fglprofile   STRING
   DEFINE lc_channel2     base.Channel
   DEFINE ls_report_name  STRING
   DEFINE lc_zte01        LIKE zte_file.zte01
   DEFINE lc_zte03        LIKE zte_file.zte03

   LET ls_ver_old = ARG_VAL(1)      #帶入大版版號(old)
   LET ls_ver_new = ARG_VAL(2)      #帶入大版版號(new)
   LET ls_create_path = ARG_VAL(3)  #檔案產生位置
   LET ls_convert = ARG_VAL(4)      #資料convert工具 big5_to_gb2312.lux,b5tou8 (null表示不轉檔)
   IF ls_ver_old IS NULL OR ls_ver_new IS NULL THEN
      RETURN
   END IF

   IF ls_ver_new.getIndexOf(".",1) THEN
      LET ls_ver = ls_ver_new.subString(1,ls_ver_new.getIndexOf(".",1)-1),ls_ver_new.subString(ls_ver_new.getIndexOf(".",1)+1,ls_ver_new.getLength())
   ELSE
      LET ls_ver = ls_ver_new
   END IF
   LET ls_impfun_path = "/u6/topzl/impdefvalue/"
   IF ls_create_path IS NULL THEN
      LET ls_create_path = FGL_GETENV("TEMPDIR"),"/"
   END IF
      
   LET ls_fgldir = FGL_GETENV("FGLDIR")
   LET g_db_type = DB_GET_DATABASE_TYPE()

   IF NOT os.Path.exists(ls_create_path) THEN
      IF os.Path.mkdir(ls_create_path) THEN
         DISPLAY 'mkdir OK'
      END IF
   END IF

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ls_create_path||"import_default_value_"||ls_ver||".4gl","w")
   CALL lc_channel.setDelimiter("")
   LET ls_str = "# ",ls_ver_new," Operation of update default value : Auto Create : ",TODAY," ",TIME
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("")
   CALL lc_channel.write("IMPORT os")
   CALL lc_channel.write("")
   CALL lc_channel.write("DATABASE ds")
   CALL lc_channel.write("")
   CALL lc_channel.write("DEFINE gc_channel base.Channel")
   CALL lc_channel.write("DEFINE g_str STRING")
   CALL lc_channel.write("")
   CALL lc_channel.write("MAIN")
   CALL lc_channel.write("DEFINE ls_dbs CHAR(21)")
   CALL lc_channel.write("DEFINE ls_logpath STRING")
   CALL lc_channel.write("")
   CALL lc_channel.write("WHENEVER ERROR CONTINUE")
   CALL lc_channel.write("")
   CALL lc_channel.write("LET ls_dbs = ARG_VAL(1)")
   CALL lc_channel.write("LET ls_logpath = ARG_VAL(2)")
   CALL lc_channel.write("IF ls_logpath IS NULL THEN")
   CALL lc_channel.write("   LET ls_logpath = FGL_GETENV(\"TEMPDIR\"),os.Path.separator(),\"import_default_value_"||ls_ver_new||".log\"")
   CALL lc_channel.write("END IF")
   CALL lc_channel.write("")
   CALL lc_channel.write("LET gc_channel = base.Channel.create()")
   CALL lc_channel.write("CALL gc_channel.openFile(ls_logpath,\"a\")")
   CALL lc_channel.write("CALL gc_channel.setDelimiter(\"\")")
   LET ls_str = "CALL gc_channel.write(\"===============Message of Data Fill (\"||ls_dbs CLIPPED||\") (\"||DATE||\" \"||TIME(CURRENT)||\")===============\")"
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("CALL gc_channel.write(\"\")")
   CALL lc_channel.write("")
   CALL lc_channel.write("CLOSE DATABASE")
   CALL lc_channel.write("DATABASE ls_dbs")
   CALL lc_channel.write("IF SQLCA.sqlcode THEN")
   LET ls_str = "   DISPLAY \"Connect database '\",ls_dbs CLIPPED,\"' error\""
   CALL lc_channel.write(ls_str)
   LET ls_str = "   LET g_str = \"Connect database '\",ls_dbs CLIPPED,\"' error\""
   CALL lc_channel.write(ls_str)
   CALL lc_channel.write("   CALL gc_channel.write(g_str)")
   CALL lc_channel.write("   RETURN")
   CALL lc_channel.write("END IF")
   CALL lc_channel.write("")
   CALL lc_channel.write("LET g_str = \"DATABASE : \",ls_dbs CLIPPED")
   CALL lc_channel.write("OPEN WINDOW imp_val_w WITH FORM \"import_default_value.42f\"")
   CALL lc_channel.write("ATTRIBUTE(STYLE=\"reportViewer\", TEXT=g_str)")
   CALL lc_channel.write("CALL ui.Interface.loadStyles(\"bpatch.4st\")")
   CALL lc_channel.write("CLOSE WINDOW screen")
   CALL lc_channel.write("CALL ui.Interface.refresh()")
   CALL lc_channel.write("INPUT g_str FROM formonly.dummy01 ATTRIBUTE(ACCEPT=FALSE,CANCEL=FALSE)")
   CALL lc_channel.write("BEFORE INPUT")

   # 搜尋期間內的zs資料,zs資料出來時,若有alter column的部份,
   # 串回zta找尋預設值設定
   IF ls_ver_old = "p_alt" THEN
      LET ls_sql = "SELECT zte01,zte03 FROM zte_file WHERE zte03='",ls_ver_new,"'"
      PREPARE zte_pre FROM ls_sql
      DECLARE zte_curs CURSOR FOR zte_pre
      LET li_i = 1
      FOREACH zte_curs INTO lc_zte01,lc_zte03
         LET lr_zs[li_i].tablename = lc_zte01
         LET lr_zs[li_i].fieldname = lc_zte03
         LET li_i = li_i + 1
      END FOREACH
   ELSE
      IF g_db_type = "ORA" THEN
         LET ls_sql = "SELECT UNIQUE zs06 FROM zs_file ",
                      " WHERE zs02='ds' AND zs12 >= '",ls_ver_old,"'",
                      "   AND zs06 like 'alter%'"
      ELSE
         LET ls_sql = "SELECT UNIQUE zs06 FROM zs_file ",
                      " WHERE zs02='ds' AND zs12 >= '",ls_ver_old,"'",
                      "   AND zs06 matches 'alter*'"
      END IF
      PREPARE zs_pre FROM ls_sql
      DECLARE zs_curs CURSOR FOR zs_pre
      LET li_i = 1
      FOREACH zs_curs INTO lc_zs06
         LET ls_str = lc_zs06
         IF ls_str.getIndexOf("alter table ",1) THEN
            LET ls_str = ls_str.subString(13,ls_str.getLength())
            LET ls_tablename = ls_str.subString(1,ls_str.getIndexOf(" ",1)-1)
            LET ls_str = ls_str.subString(ls_str.getIndexOf(ls_tablename,1)+ls_tablename.getLength()+1,ls_str.getLength())
            CASE
               WHEN ls_str.getIndexOf("add(",1)
                  LET ls_fieldname = ls_str.subString(ls_str.getIndexOf("add(",1)+4,ls_str.getIndexOf(" ",1)-1)
               WHEN ls_str.getIndexOf("modify(",1)
                  LET ls_fieldname = ls_str.subString(ls_str.getIndexOf("modify(",1)+7,ls_str.getIndexOf(" ",1)-1)
               OTHERWISE
                  CONTINUE FOREACH
            END CASE
            IF ls_tablename IS NULL OR ls_fieldname IS NULL THEN
               CONTINUE FOREACH
            END IF
            LET li_result = FALSE
            FOR li_cnt = 1 TO lr_zs.getLength()
                IF ls_tablename = lr_zs[li_cnt].tablename AND ls_fieldname = lr_zs[li_cnt].fieldname THEN
                   LET li_result = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_result THEN
               LET lr_zs[li_i].tablename = ls_tablename
               LET lr_zs[li_i].fieldname = ls_fieldname
               LET li_i = li_i + 1
            END IF
         END IF
      END FOREACH
   END IF

   #利用這些tablename跟fieldname來搜尋有沒有預設值
   LET li_k = 1
   FOR li_i = 1 TO lr_zs.getLength()
       LET lr_zte[li_k].zte01 = lr_zs[li_i].tablename
       LET lr_zte[li_k].zte03 = lr_zs[li_i].fieldname
       SELECT COUNT(*) INTO li_cnt FROM zte_file WHERE zte01=lr_zte[li_k].zte01 AND zte02='ds' AND zte03=lr_zte[li_k].zte03 AND zte05!="1"
       IF li_cnt <= 0 THEN
          CALL lr_zte.deleteElement(li_k)
          CONTINUE FOR
       END IF
       SELECT * INTO lr_zte[li_k].* FROM zte_file WHERE zte01=lr_zte[li_k].zte01 AND zte02='ds' AND zte03=lr_zte[li_k].zte03 AND zte05!="1"
       CASE lr_zte[li_k].zte05
          WHEN "2"
             # 固定預設值
             LET ls_sql = "LET g_str = \"Update fixed value ---\\nTable : ",lr_zte[li_k].zte01 CLIPPED,"\\nSET : ",lr_zte[li_k].zte03 CLIPPED,"='",lr_zte[li_k].zte06 CLIPPED,"'\""
             CALL lc_channel.write(ls_sql)
             LET ls_sql = "DISPLAY g_str TO formonly.dummy01"
             CALL lc_channel.write(ls_sql)
             LET ls_sql = "CALL ui.Interface.refresh()"
             CALL lc_channel.write(ls_sql)
             LET ls_sql = "UPDATE ",lr_zte[li_k].zte01 CLIPPED," SET ",lr_zte[li_k].zte03 CLIPPED,"='",lr_zte[li_k].zte06 CLIPPED,"'"
             CALL lc_channel.write(ls_sql)
             LET ls_str = "IF SQLCA.sqlcode THEN"
             CALL lc_channel.write(ls_str)
             LET ls_str = "   DISPLAY \"ERROR\",SQLCA.sqlcode,\" \",\"",ls_sql,"\""
             CALL lc_channel.write(ls_str)
             LET ls_str = "   LET g_str = \"ERROR\",SQLCA.sqlcode,\" \",\"",ls_sql,"\""
             CALL lc_channel.write(ls_str)
             CALL lc_channel.write("   CALL gc_channel.write(g_str)")
             LET ls_str = "END IF"
             CALL lc_channel.write(ls_str)
          WHEN "3"
             # 程式匯入預設值 
             LET ls_sql = "LET g_str = \"Update by function ---\\nFunction : ",lr_zte[li_k].zte06 CLIPPED,"()\""
             CALL lc_channel.write(ls_sql)
             LET ls_sql = "DISPLAY g_str TO formonly.dummy01"
             CALL lc_channel.write(ls_sql)
             LET ls_sql = "CALL ui.Interface.refresh()"
             CALL lc_channel.write(ls_sql)
             LET ls_str = "CALL ",lr_zte[li_k].zte06 CLIPPED,"()"
             CALL lc_channel.write(ls_str)
             LET lr_fun_name[lr_fun_name.getLength()+1] = lr_zte[li_k].zte06 CLIPPED
       END CASE
       LET li_k = li_k + 1
   END FOR

   CALL lc_channel.write("EXIT INPUT")
   CALL lc_channel.write("END INPUT")
   CALL lc_channel.write("CLOSE WINDOW imp_val_w")
   CALL lc_channel.write("END MAIN")

   # 匯入各function, 匯入前先確認compile成功
   FOR li_i = 1 TO lr_fun_name.getLength()
       LET ls_fun_path = ls_impfun_path,lr_fun_name[li_i],".4gl"
       LET ls_cmd = "cd ",ls_impfun_path,";export FGLDIR=",
                    ls_fgldir.subString(1,ls_fgldir.getIndexOf(".",1)),"dev;",
                    "fglcomp ",lr_fun_name[li_i]," >/dev/null 2>&1"
       RUN ls_cmd
       IF os.Path.exists(ls_impfun_path||lr_fun_name[li_i]||".err") THEN
          DISPLAY lr_fun_name[li_i],".4gl compile fail, can't add to import_default_value_",ls_ver,".4gl"
          IF os.Path.delete(ls_impfun_path||lr_fun_name[li_i]||".err") THEN
          END IF
       ELSE
          IF os.Path.delete(ls_impfun_path||lr_fun_name[li_i]||".42m") THEN
          END IF
          # 開始寫入function內容
          CALL lc_channel.write("")
          LET lc_channel2 = base.Channel.create()
          CALL lc_channel2.openFile(ls_fun_path,"r")
          CALL lc_channel2.setDelimiter("")
          WHILE lc_channel2.read(ls_str)
             IF ls_str = "DATABASE ds" THEN
                CONTINUE WHILE
             END IF
             IF ls_str.getIndexOf("FUNCTION ",1) AND ls_str.getIndexOf("()",1) THEN
                IF ls_str.subString(ls_str.getIndexOf("FUNCTION ",1)+9,ls_str.getIndexOf("()",1)-1) != lr_fun_name[li_i] THEN
                   DISPLAY "'",ls_str,"' function name not conform with ",lr_fun_name[li_i],".4gl, can't add to import_default_value_",ls_ver,".4gl"
                   EXIT WHILE
                END IF
             END IF
             CALL lc_channel.write(ls_str)
             LET ls_str = ls_str.trim()
             IF UPSHIFT(ls_str.subString(1,7)) = "DISPLAY " THEN
                LET ls_str = ls_str.subString(9,ls_str.getLength())
                CALL lc_channel.write("         LET g_str = "||ls_str)
                CALL lc_channel.write("         CALL gc_channel.write(g_str)")
             END IF
          END WHILE
          CALL lc_channel2.close()
       END IF
   END FOR

   CALL lc_channel.close()

   # 轉檔
   IF ls_convert IS NOT NULL THEN
      LET ls_cmd = "cd ",ls_create_path,";chmod 777 import_default_value_",ls_ver,".4gl;",
                   "cat import_default_value_",ls_ver,".4gl|",ls_convert," > ",
                   "import_default_value_",ls_ver,".tmp"
      RUN ls_cmd
      IF os.Path.exists(ls_create_path||"import_default_value_"||ls_ver||".tmp") AND
         os.Path.size(ls_create_path||"import_default_value_"||ls_ver||".tmp") THEN
         IF os.Path.copy(ls_create_path||"import_default_value_"||ls_ver||".tmp",
                         ls_create_path||"import_default_value_"||ls_ver||".4gl") THEN
            IF os.Path.delete(ls_create_path||"import_default_value_"||ls_ver||".tmp") THEN
            END IF
         END IF
      END IF
   END IF

   # 檢查產生的程式compile是否正確, 如果轉UNICODE要在UNICODE區compile
   IF ls_convert = "b5tou8" OR ls_convert = "gbtou8" THEN
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile(ls_create_path||"unicode_compile.sh","w")
      CALL lc_channel.setDelimiter("")
      LET ls_str = "/u6/etc/gp.utiptop3"
      CALL lc_channel.write(ls_str)
      LET ls_str = "FGLPROFILE=/u6/etc/fglprofile_2.0/fglprofile.utiptop3;export FGLPROFILE"
      CALL lc_channel.write(ls_str)
      LET ls_str = "LANG=en_US.utf8;export LANG"
      CALL lc_channel.write(ls_str)
      LET ls_str = "cd ",ls_create_path,";export FGLDIR=",
                   ls_fgldir.subString(1,ls_fgldir.getIndexOf(".",1)),"dev;",
                   "fglcomp import_default_value_",ls_ver
      CALL lc_channel.write(ls_str)
      LET ls_cmd = ". ",ls_create_path,"unicode_compile.sh"
      RUN ls_cmd
      IF os.Path.delete(ls_create_path||"unicode_compile_sh") THEN END IF
   ELSE
      DISPLAY ""
      LET ls_cmd = "cd ",ls_create_path,";export FGLDIR=",
                   ls_fgldir.subString(1,ls_fgldir.getIndexOf(".",1)),"dev;",
                   "fglcomp import_default_value_",ls_ver
      RUN ls_cmd
   END IF
   IF os.Path.exists(ls_create_path||"import_default_value"||ls_ver||".err") THEN
      DISPLAY ls_create_path,"import_default_value_"||ls_ver||".4gl compile fail, please check .err file"
   ELSE
      DISPLAY ls_create_path,"import_default_value_"||ls_ver||".4gl compile successfully"
      LET ls_cmd = "cd ",ls_create_path,";fgl2p -o import_default_value_",ls_ver,".42r import_default_value_",ls_ver,".42m"
      RUN ls_cmd
   END IF

   DISPLAY "開始列印Data Fill List報表"
   LET ls_report_name = ls_create_path,"import_default_value_",ls_ver,".txt"
   START REPORT defvalue_report TO ls_report_name
   FOR li_i = 1 TO lr_zte.getLength()
       OUTPUT TO REPORT defvalue_report(lr_zte[li_i].*)
   END FOR
   FINISH REPORT defvalue_report
   DISPLAY "產生Data Fill List報表：",ls_report_name

   # 轉檔
   IF ls_convert IS NOT NULL THEN
      LET ls_cmd = "cd ",ls_create_path,";chmod 777 import_default_value_",ls_ver,".txt;",
                   "cat import_default_value_",ls_ver,".txt|",ls_convert," > ",
                   "import_default_value_",ls_ver,".tmp"
      RUN ls_cmd
      IF os.Path.exists(ls_create_path||"import_default_value_"||ls_ver||".tmp") AND
         os.Path.size(ls_create_path||"import_default_value_"||ls_ver||".tmp") THEN
         IF os.Path.copy(ls_create_path||"import_default_value_"||ls_ver||".tmp",
                         ls_create_path||"import_default_value_"||ls_ver||".txt") THEN
            IF os.Path.delete(ls_create_path||"import_default_value_"||ls_ver||".tmp") THEN
            END IF
         END IF
      END IF
   END IF
END MAIN

REPORT defvalue_report(lr_zte)
   DEFINE lr_zte          RECORD LIKE zte_file.*

   OUTPUT
      TOP MARGIN 1
      LEFT MARGIN 5
      BOTTOM MARGIN 5
      PAGE LENGTH 66

   FORMAT
      PAGE HEADER
         PRINT COLUMN 30,"匯入值設定列表"
         PRINT ""
         PRINT "Table Name",
               COLUMN 22,"Field Name",
               COLUMN 43,"Method",
               COLUMN 54,"Value or Function Name"
         PRINT "==================== ==================== ========== =============================="
      ON EVERY ROW
         PRINT lr_zte.zte01,
               COLUMN 22,lr_zte.zte03,
               COLUMN 43,lr_zte.zte05,
               COLUMN 54,lr_zte.zte06

END REPORT
