# Prog. Version..: '5.00.02-07.06.21(00000)'     #
# Pattern name...: FlmWriteData.4gl
# Descriptions...: Scheduled FLM Data Scanner
# Date & Author..: 07/05/31 by alex
# Modify.........: No:FUN-770085 07/07/24 By hjwang 新增detail記錄供分析參考

IMPORT os
DATABASE ds

    DEFINE g_hjao      RECORD LIKE hja_file.*
    DEFINE g_hjan      RECORD 
            hja01      LIKE hja_file.hja01,
            hja02      DATETIME YEAR TO SECOND,
            hja03      LIKE hja_file.hja03,
            hja04      LIKE hja_file.hja04,
            hja05      LIKE hja_file.hja05,
            hja06      LIKE hja_file.hja06,
            hja07      LIKE hja_file.hja07,
            hja08      LIKE hja_file.hja08,
            hja09      LIKE hja_file.hja09,
            hja10      LIKE hja_file.hja10,
            hja11      LIKE hja_file.hja11,
            hja12      LIKE hja_file.hja12,
            hja13      LIKE hja_file.hja13,
            hja14      LIKE hja_file.hja14,
            hja15      LIKE hja_file.hja15,
            hja16      LIKE hja_file.hja16,
            hja17      LIKE hja_file.hja17,
            hja18      LIKE hja_file.hja18,
            hja19      LIKE hja_file.hja19,
            hja20      LIKE hja_file.hja20,
            hja21      LIKE hja_file.hja21,
            hja22      LIKE hja_file.hja22,
            hja23      LIKE hja_file.hja23
                    END RECORD
    DEFINE g_separator  LIKE type_file.chr1    #CHAR(1) #UNX:/ WNT:\
    DEFINE g_logdir     STRING
    DEFINE g_hjc        DYNAMIC ARRAY OF RECORD LIKE hjc_file.*
    DEFINE g_detail     INTEGER
    DEFINE g_replace    INTEGER                #Using ProcessId count rep hja03

MAIN

    DEFINE li_cnt       INTEGER

    # 07/07/25 傳入 detail 為第一參數時, 程式會記錄當下執行人員及登入IP,port
    #          資料

    IF ARG_VAL(1) = "detail" THEN
       LET g_detail = 1
    ELSE
       LET g_detail = 0
    END IF
    LET g_replace = 0

    # 07/07/25 Genero 2.0始改用 IMPORT os 自動判斷及展開路徑

    LET g_logdir = os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin")
                                                            ,"FLMonitor")
    SELECT count(*) INTO li_cnt FROM hja_file
    IF li_cnt < 1 THEN
       INITIALIZE g_hjao.* TO NULL 
       LET g_hjao.hja01 = 0
       LET g_hjan.hja01 = 1
    ELSE
       SELECT max(hja01) INTO g_hjao.hja01 FROM hja_file
       SELECT * INTO g_hjao.* FROM hja_file WHERE hja01=g_hjao.hja01

       LET g_hjan.hja01 = g_hjao.hja01 + 1
    END IF

    CALL FlmWrite_data()
    CALL FlmWrite_Runtime()
    CALL FlmWrite_Compile()
    CALL FlmWrite_save()

END MAIN


#   # Request total counts
FUNCTION FlmWrite_data()

    DEFINE ls_channel    base.Channel
    DEFINE ls_temp       STRING 
    DEFINE ls_cmd        STRING
    DEFINE li_ftype      INTEGER
    DEFINE lc_date       DATETIME YEAR TO FRACTION(3)
    DEFINE li_ret        INTEGER

    LET lc_date = CURRENT YEAR TO FRACTION(3)
    LET g_hjan.hja02 = lc_date

    LET ls_channel = base.Channel.create()
    CALL ls_channel.setDelimiter(" ")
    CALL ls_channel.openFile(g_logdir.trim()||g_separator||"FlmWriteData.log","r")

    LET li_ftype = 0
    WHILE ls_channel.read(ls_temp)

       LET ls_temp = ls_temp.toLowerCase()
       LET ls_temp = ls_temp.trim()
       IF ls_temp.getIndexOf("runtime",1) AND NOT ls_temp.getIndexOf("end",1) THEN
          LET li_ftype = 1 CONTINUE WHILE
       END IF
       IF ls_temp.getIndexOf("compilation",1) THEN
          LET li_ftype = 2 CONTINUE WHILE
       END IF
       IF ls_temp.getIndexOf("extension",1) THEN
          LET li_ftype = 3 CONTINUE WHILE
       END IF
       
       IF li_ftype > 0 THEN
          IF ls_temp.getIndexof("accepted",1) THEN
	     CASE li_ftype
	        WHEN 1 LET g_hjan.hja03 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 2 LET g_hjan.hja06 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 3 LET g_hjan.hja09 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	     END CASE
	     CONTINUE WHILE
	  END IF

          IF ls_temp.getIndexof("rejected",1) THEN
	     CASE li_ftype
	        WHEN 1 LET g_hjan.hja04 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 2 LET g_hjan.hja07 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 3 LET g_hjan.hja10 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	     END CASE
	     CONTINUE WHILE
	  END IF

          IF ls_temp.getIndexof("system problem",1) THEN
	     CASE li_ftype
	        WHEN 1 LET g_hjan.hja05 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 2 LET g_hjan.hja08 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	        WHEN 3 LET g_hjan.hja11 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
	     END CASE
	     LET li_ftype = 0
	     CONTINUE WHILE
	  END IF
       END IF
       
       CASE
          WHEN ls_temp.getIndexOf("end ",1) 
	     LET g_hjan.hja12 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("pid ",1) 
	     LET g_hjan.hja13 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("infor",1) 
	     LET g_hjan.hja14 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("bad ",1) 
	     LET g_hjan.hja15 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("stop",1) 
	     LET g_hjan.hja16 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("delete",1) 
	     LET g_hjan.hja17 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
          WHEN ls_temp.getIndexOf("unknow",1) 
	     LET g_hjan.hja18 = ls_temp.subString(ls_temp.getindexof(":",1)+1,ls_temp.getLength())
       END CASE

       IF ls_temp.getIndexOf("you must specified entry",1) AND
          ls_temp.getIndexOf("in the resource file",1) THEN
          LET g_replace = 1
       END IF

    END WHILE
    CALL ls_channel.close()
END FUNCTION

#   # Rightnow Runtime occupied
FUNCTION FlmWrite_Runtime()

    DEFINE ls_channel    base.Channel
    DEFINE ls_temp       STRING 
    DEFINE ls_host       STRING 
    DEFINE li_cnt        INTEGER
    DEFINE lc_process    LIKE gbq_file.gbq01
    DEFINE lc_gbq02      LIKE gbq_file.gbq02
    DEFINE lc_db         STRING
    DEFINE li_processid  INTEGER

    LET ls_host = "Local"
    LET ls_channel = base.Channel.create()
    CALL ls_channel.setDelimiter(" ")
    CALL ls_channel.openFile(g_logdir.trim()||g_separator||"FlmUsage.log","r")
    CALL g_hjc.clear()
    LET li_cnt = 0
    LET li_processid = 0

    WHILE ls_channel.read(ls_temp)
       LET ls_temp = ls_temp.trim()
       IF ls_temp.getIndexOf("Users",1) AND ls_temp.getIndexOf("/",1) THEN
          LET g_hjan.hja20 = ls_temp.subString(ls_temp.getIndexOf(":",1)+1,
                                               ls_temp.getIndexOf("/",1)-1)
          LET g_hjan.hja21 = ls_temp.subString(ls_temp.getIndexOf("/",1)+1,
                                               ls_temp.getLength() )
       END IF
       IF g_detail THEN
          IF ls_temp.getIndexOf("Host         :",1) THEN
             LET ls_host = ls_temp.subString(ls_temp.getIndexOf(":",1)+1,
                                             ls_temp.getLength() )
          END IF
          IF ls_temp.getIndexOf("GUI Server",1) THEN
             LET li_cnt = li_cnt + 1
             LET g_hjc[li_cnt].hjc01 = g_hjan.hja01
             LET g_hjc[li_cnt].hjc02 = ls_host.trim()
             LET g_hjc[li_cnt].hjc03 = ls_temp.subString(ls_temp.getIndexOf("GUI Server",1)+11,
                                                         ls_temp.getLength() )
             LET g_hjc[li_cnt].hjc04 = "N/A"
             LET g_hjc[li_cnt].hjc05 = 0
             LET li_processid = 1
          END IF
          IF ls_temp.getIndexOf("Process Id",1) AND li_processid THEN
             LET g_hjc[li_cnt].hjc05 = g_hjc[li_cnt].hjc05 + 1
             LET lc_process = ls_temp.subString(ls_temp.getIndexOf("Process Id",1)+11,
                                                         ls_temp.getLength() )

             # 07/07/25 由於 fglWrt 抓出的 IP 與 user 端回傳的 server ip 有時
             #          無法 mapping (127.0.0.1 vs 內部 10.x.x.x) 故以 process
             #          id 作為連結依據, 假設同一台電腦執行人均相同情況下
             #          此處暫不考慮公用電腦情況 (以telnet算同一lic,以web
             #          就算不同 lic

             SELECT gbq03 INTO g_hjc[li_cnt].hjc04 FROM gbq_file
                         WHERE gbq01 = lc_process
          END IF
       END IF

       IF g_replace THEN
          IF ls_temp.getIndexOf("Process Id",1) AND li_processid THEN
             LET g_hjan.hja03 = g_hjan.hja03 + 1
          END IF
       END IF
 
       CONTINUE WHILE
    END WHILE
    CALL ls_channel.close()
END FUNCTION


#   # Rightnow Compiler occupied
FUNCTION FlmWrite_Compile()

    DEFINE ls_channel    base.Channel
    DEFINE ls_temp       STRING 

    LET ls_channel = base.Channel.create()
    CALL ls_channel.setDelimiter(" ")
    CALL ls_channel.openFile(g_logdir.trim()||g_separator||"FlmComp.log","r")

    WHILE ls_channel.read(ls_temp)
       LET ls_temp = ls_temp.trim()
       IF ls_temp.getIndexOf("Users",1) AND ls_temp.getIndexOf("/",1) THEN
          LET g_hjan.hja22 = ls_temp.subString(ls_temp.getIndexOf(":",1)+1,
                                               ls_temp.getIndexOf("/",1)-1)
          LET g_hjan.hja23 = ls_temp.subString(ls_temp.getIndexOf("/",1)+1,
                                               ls_temp.getLength() )
       END IF
       CONTINUE WHILE
    END WHILE
    CALL ls_channel.close()
END FUNCTION


FUNCTION FlmWrite_save()

   DEFINE li_cnt  INTEGER

   INSERT INTO hja_file VALUES(g_hjan.*)

   IF g_detail THEN
      IF g_hjc.getLength() < 1 THEN RETURN END IF
      PREPARE is FROM "INSERT INTO hjc_file VALUES (?,?,?,?,?)"
      DECLARE ic CURSOR FOR is
      BEGIN WORK
      OPEN ic
      FOR li_cnt = 1 TO g_hjc.getLength()
         PUT ic FROM g_hjc[li_cnt].*
         IF li_cnt MOD 50 = 0 THEN
            FLUSH ic
         END IF
      END FOR
      CLOSE ic
      COMMIT WORK
      FREE ic
      FREE is
   END IF

END FUNCTION


