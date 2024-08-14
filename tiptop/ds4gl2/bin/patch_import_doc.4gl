# 客戶開發記錄作業 - 上傳相關文件 No:FUN-840067 08/04/22 by saki

DATABASE ds

MAIN
   DEFINE ls_file STRING
   DEFINE lr_gcb  RECORD LIKE gcb_file.*

   LET ls_file = ARG_VAL(1)
   LET lr_gcb.gcb01= ARG_VAL(2)
   LET lr_gcb.gcb02= ARG_VAL(3)
   LET lr_gcb.gcb03= ARG_VAL(4)
   LET lr_gcb.gcb04= ARG_VAL(5)
   LOCATE lr_gcb.gcb09 IN MEMORY
   FREE lr_gcb.gcb09
   LOCATE lr_gcb.gcb09 IN FILE ls_file
   UPDATE gcb_file SET gcb09 = lr_gcb.gcb09
    WHERE gcb01 = lr_gcb.gcb01 AND gcb02 = lr_gcb.gcb02
      AND gcb03 = lr_gcb.gcb03 AND gcb04 = lr_gcb.gcb04
   IF SQLCA.sqlcode THEN
      DISPLAY "upload ",ls_file," in document error!"
   END IF
END MAIN
