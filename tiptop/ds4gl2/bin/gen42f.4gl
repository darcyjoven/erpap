# Prog. Version..: '5.10.00-07.05.10(00000)'     #
#
# Pattern name...: gen42f.4gl
# Descriptions...: r.f2
# Spec...........: 1.編譯前清除 模組/42f 下.42f及.err檔
#                  2.自動搜尋待編檔案是 .4fd或.per檔, 並以對應compile編輯
#                     (server端務必安裝GeneroStudio,並加入 %GS%/bin 於 %path%)
#                  3.採用4fd,將產生並保留中間檔於per目錄
# Date & Author..: 07/03/29 Create by alex
# Modify.........: No.FUN-830038 08/03/11 By alex 修整為可令 UNIX執行

IMPORT os

DEFINE gi_aw  SMALLINT

MAIN
   DEFINE ls_argval        STRING
   DEFINE ls_pwd4fd        STRING
   DEFINE ls_pwd42f        STRING
   DEFINE ls_target        STRING
   DEFINE ls_module        STRING
   DEFINE lch_pipe         base.Channel
   DEFINE ls_tmp1,ls_tmp2  STRING
   DEFINE tok              base.StringTokenizer
   DEFINE ls_err           STRING
   DEFINE ls_complist      STRING
   DEFINE lc_type          CHAR(3)
   
   #參數1: 要compile的原始碼檔案名稱 (多個時，可用逗號隔開)
   #參數2: 若傳入tiptop，則表示是從GPRebuild來的

   LET ls_argval = ARG_VAL(1)
   IF ARG_VAL(2) = "tiptop" THEN
      LET gi_aw = 1
   ELSE 
      LET gi_aw = 0
   END IF

   #未傳入任何參數處理
   IF ls_argval IS NULL OR ls_argval = " " THEN
      DISPLAY "Usage: r.f2 prog_name(,prog_name) "
      EXIT PROGRAM
   END IF

   LET ls_pwd4fd = os.Path.pwd()

   #若在root directory，則稍等做退上層轉進42f會有問題，先處理
   IF os.Path.isroot(ls_pwd4fd) THEN
      DISPLAY "Error: You Cannot Execute r.f2 in ",ls_pwd4fd," (Root Directory)! "
      EXIT PROGRAM
   ELSE
      LET ls_pwd42f = os.Path.join(os.Path.dirname(ls_pwd4fd),"42f")
      LET ls_module = os.Path.dirname(ls_pwd4fd)
      LET ls_module = os.Path.basename(ls_module)    # ls_module should be module name
   END IF

   #source 驗證處理
   LET tok = base.StringTokenizer.create(ls_argval.trim(),",")
   LET ls_err = ""
   LET ls_complist = ""
   WHILE tok.hasMoreTokens()
      LET ls_target = tok.nextToken()

      CASE
         WHEN os.Path.exists(os.Path.join(ls_pwd4fd.trim(), ls_target.trim()||".4fd"))
            LET ls_target = ls_target.trim(),".4fd"
            LET lc_type = "4fd"
         WHEN os.Path.exists(os.Path.join(ls_pwd4fd.trim(), ls_target.trim()||".per"))
            LET ls_target = ls_target.trim(),".per"
            IF ls_argval.getIndexOf(1,",") THEN
               LET ls_err = ls_err, ls_target.trim(),".per Cannot Support in Multiple Form Build. Please Make it 1 by 1.\n"
               EXIT WHILE
            ELSE
               LET lc_type = "per"
            END IF
         OTHERWISE
            LET ls_err = ls_err, ls_target.trim(),".4fd Not Exist in ",ls_pwd4fd.trim(),", Please Check Again.\n"
            CONTINUE WHILE
      END CASE

      #刪除在 42f下的 4fd (或per檔)
      LET ls_tmp1 = os.Path.join(ls_pwd42f,ls_target)
      IF os.Path.exists(ls_tmp1) THEN
         IF NOT os.Path.delete(ls_tmp1) THEN
            LET ls_err = ls_err, "Error: Fail in Deleting ",ls_tmp1.trim(), " File.\n"
            CONTINUE WHILE
         END IF
      END IF

      #複製 4fd (或per檔) 到 42f目錄
      IF NOT os.Path.copy(os.Path.join(ls_pwd4fd,ls_target), ls_tmp1) THEN
         LET ls_err = ls_err, "Error: Fail in copying ",ls_tmp1.trim()," File.\n"
         CONTINUE WHILE
      END IF

      LET ls_complist = ls_complist," ",ls_target
   END WHILE

   IF ls_err IS NOT NULL THEN
      DISPLAY ls_err
      EXIT PROGRAM
   END IF
   
   #變換目錄到42f下
   IF NOT os.Path.chdir(ls_pwd42f) THEN
      DISPLAY "Error: System Cannot Change DIR to ",ls_pwd42f.trim()," !"
      EXIT PROGRAM
   END IF

   #切換compile license路徑
   LET ls_tmp2 = FGL_GETENV("FGLDIR")
   IF os.Path.exists(os.Path.rootname(ls_tmp2.trim())||".dev") THEN
      CALL FGL_SETENV("FGLDIR",os.Path.rootname(ls_tmp2.trim())||".dev")
   END IF

   #執行編譯
   IF gen42f_compiler(ls_pwd42f,ls_module,ls_complist,lc_type) THEN
      IF NOT gi_aw THEN
         DISPLAY "Info: Compile ", ls_argval.trim()," Process ........................Finish."
      END IF
   ELSE
      DISPLAY "ERROR:......"
   END IF

END MAIN



FUNCTION gen42f_compiler(ls_pwd42f,ls_module,ls_target,lc_type)

   DEFINE ls_pwd42f   STRING
   DEFINE ls_module   STRING
   DEFINE ls_target   STRING
   DEFINE ls_perper   STRING
   DEFINE ls_42fper   STRING
   DEFINE ls_tmp1     STRING
   DEFINE lc_type     CHAR(3)
   DEFINE ls_err      STRING
   DEFINE tok         base.StringTokenizer
   
   #判斷叫用的compile tool
   CASE lc_type
      WHEN "per"
         LET ls_tmp1 = "fglform -M ",ls_target.trim()
      WHEN "4fd"
         LET ls_tmp1 = "gsform -i -dbname ds -keep ",ls_target.trim()
   END CASE
   
   #執行指令
   CALL gen42f_execute(ls_tmp1, ls_pwd42f)

   LET tok = base.StringTokenizer.create(ls_target.trim()," ")
   LET ls_err = ""
   WHILE tok.hasMoreTokens()
      LET ls_tmp1 = tok.nextToken()

      #檢查是否有error message
      IF os.Path.exists(os.Path.join(ls_pwd42f, os.Path.rootname(ls_tmp1.trim())||".err")) THEN
         LET ls_err = ls_err, "Error: Forming ",ls_tmp1," Error, Check Environment OR Source Code.\n"
         CONTINUE WHILE
      END IF

      #準備搬移per檔 (檔名準備)
      LET ls_42fper = os.Path.join(ls_pwd42f, os.Path.rootname(ls_tmp1.trim())||".per") 
      LET ls_perper = os.Path.join(os.Path.join(os.Path.dirname(ls_pwd42f.trim()),"per"),
                                   os.Path.rootname(ls_tmp1.trim())||".per")

      #如果42f目錄下有 .per檔的話
      IF os.Path.exists(ls_42fper.trim()) THEN
         IF os.Path.exists(ls_perper.trim()) THEN   
            IF os.Path.delete(ls_perper.trim()) THEN
            END IF
            IF os.Path.copy(ls_42fper.trim(),ls_perper.trim()) THEN
            END IF
            IF os.Path.delete(ls_42fper.trim()) THEN
            END IF
         END IF
      END IF

      #如果42f目錄下有 .4fd檔的話 (下列寫法當tmp1=.per也不會出錯)
      IF os.Path.exists(os.Path.join(ls_pwd42f,ls_tmp1)) THEN   
         IF os.Path.delete(os.Path.join(ls_pwd42f,ls_tmp1)) THEN
         END IF
      END IF
   END WHILE

   IF ls_err IS NOT NULL THEN
      DISPLAY ls_err
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF

END FUNCTION



FUNCTION gen42f_execute(ls_cmd, ls_workdir)

   DEFINE ls_cmd           STRING
   DEFINE ls_workdir       STRING
   DEFINE lch_pipe         base.Channel
   DEFINE ls_tmp1          STRING

   LET lch_pipe = base.Channel.create()
   CALL lch_pipe.openPipe(ls_cmd.trim(), "r")

   WHILE lch_pipe.read(ls_tmp1)
      DISPLAY ls_tmp1
   END WHILE
   RETURN
   
END FUNCTION
