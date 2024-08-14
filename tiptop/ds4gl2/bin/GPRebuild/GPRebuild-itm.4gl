# Prog. Version..: '5.10.00-07.05.10(00000)'     #
#
# Pattern name...: GPRebuild-itm.4gl
# Descriptions...: TIPTOP GP 5.2 圖形化系統重建工具代理作業 
# Date & Author..: 10/05/19 Create by alex
# Modify.........: No.FUN-A50097 10/05/19 By alex 調整簡易平行處理作法
# Modify.........: No.FUN-BA0031 11/10/20 By Hiko 4fd的編譯結果改在GPRebuild.4gl處理
# Modify.........: No.FUN-C60110 12/06/25 By madey 增加拋出log訊息

DATABASE ds

MAIN

   DEFINE ls_cmd       STRING
   DEFINE lch_pipe     base.Channel
   DEFINE ls_tmp1      STRING
   DEFINE g_tmp        STRING
   DEFINE g_cmd        STRING
   DEFINE g_hjr01      LIKE hjr_file.hjr01
   DEFINE g_hjr02      LIKE hjr_file.hjr02
   DEFINE g_hjr03      LIKE hjr_file.hjr03
   DEFINE g_hjr04      LIKE hjr_file.hjr04
   DEFINE g_hjr05      LIKE hjr_file.hjr05
   DEFINE g_hjr06      LIKE hjr_file.hjr06
   DEFINE l_flag       BOOLEAN, #FUN-BA0031:lib,qry,sub執行link失敗的註標.
          l_hjr03_str  STRING

   LET g_hjr01 = ARG_VAL(1)   #建置ID 
   LET g_hjr02 = ARG_VAL(2)   #建置項目 C,L,F 
   LET g_hjr03 = ARG_VAL(3)   #建至模組 
   LET g_hjr04 = ARG_VAL(4)   #建置序號 
   LET g_cmd   = ARG_VAL(5)   #執行指令
   LET g_hjr05 = ""           #錯誤訊息

   IF g_cmd IS NULL OR g_cmd = " " THEN EXIT PROGRAM END IF
   LET lch_pipe = base.Channel.create()
   CALL lch_pipe.openPipe(g_cmd.trim(), "r")

   WHILE lch_pipe.read(ls_tmp1)
      IF ls_tmp1.trim() IS NULL THEN CONTINUE WHILE END IF
      LET g_tmp = g_tmp,"\n",ls_tmp1
   END WHILE
   LET g_tmp = g_tmp.subString(2,g_tmp.getLength())
 
   DISPLAY "g_tmp=",g_cmd,"\n",g_tmp #FUN-C60110  

   IF g_hjr02 = "C" AND g_tmp.getLength() > 0 THEN   #compile時加入 command
      LET g_tmp = g_cmd,"\n",g_tmp 
   END IF
   
   IF g_hjr02 = "L" THEN   #清除link 成功訊息
      CASE
         WHEN g_tmp.getIndexOf(" successfully!",2) 
            LET g_tmp = "" 
         WHEN g_tmp.getIndexOf(" Such Program ID!",2)
            LET g_tmp = g_cmd,"\n",g_tmp 
         WHEN g_tmp.getIndexOf(" Link error.",2)
            LET g_tmp = g_cmd,"\n",g_tmp 
	 OTHERWISE  #FUN-C60110
            LET g_tmp = g_cmd,"flag","\n",g_tmp 
      END CASE
   END IF

   LET l_flag = TRUE #FUN-BA0031:此flag雖然是專門給lib,sub,qry使用,但在此設定預設值並不會對其他程式的執行有任何影響.
   LET l_hjr03_str = g_hjr03 CLIPPED
   #Begin:FUN-BA0031:若是lib,sub,qry的link失敗,則要將l_flag變為FALSE.也就是說,只有這三個模組做link,並且失敗的時候,l_flag才會是FALSE.
   IF g_hjr02 = "X" THEN
      IF g_tmp.getIndexOf(" Link error.",2)>0 THEN
         LET l_flag = FALSE
         LET g_tmp = l_hjr03_str," link error! Please carry out : r.l2 ",l_hjr03_str,", you will receive detailed wrong information."
      END IF
   END IF
   #End:FUN-BA0031

   LET g_hjr05 = g_tmp.trim()
   IF g_hjr05 IS NULL THEN
      LET g_hjr06 = "Y"
   ELSE
      LET g_hjr06 = "N"
      #Begin:FUN-BA0031
      IF g_hjr02 = "X" THEN
         IF l_flag THEN
            LET g_hjr05 = l_hjr03_str,".42x"
            LET g_hjr06 = "Y" #假如是執行lib,sub,qry的link,則只要l_flag IS TRUE,就表示沒有錯誤.
         END IF
      END IF
      #End:FUN-BA0031
   END IF

   #hjr05:錯誤訊息 #hjr06:是否完成處理
   IF g_hjr02 != "F" THEN #FUN-BA0031
      UPDATE hjr_file SET hjr05=g_hjr05, hjr06=g_hjr06
       WHERE hjr01=g_hjr01 AND hjr02=g_hjr02
         AND hjr03=g_hjr03 AND hjr04=g_hjr04
   END IF
END MAIN

