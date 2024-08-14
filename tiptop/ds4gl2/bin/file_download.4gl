# Program name...: file_download.4gl
# Descriptions...: Download file and execute client program
# Input parameter: ps_source 檔案名稱 
#                  ps_opt 輸出選項(b=excel,f=word process console,x=PXRbar)
# Return code....: none
# Usage .........: $FGLRUN file_download ps_source ps_opt
# Date & Author..: 2005 By CoCo 
# Modify.........: 2005/07/19 No:BUG-4A0082 By coco add word process console
# Modify.........: 2005/07/22 No:BUG-550203 By coco add PXRbar
# Modify.........: 2005/09/02 No:MOD-590017 by Brendan

DEFINE gs_client   STRING,
       gs_rcp      STRING,
       g_fe_ver    DECIMAL(3,2),
       g_dvm_ver   DECIMAL(3,2)

MAIN
  DEFINE ps_source           STRING,
         ps_target,ps_opt    STRING
  DEFINE ls_command          STRING
  DEFINE li_status           INTEGER
  DEFINE tmp_file            STRING,
         s,l_cmd             STRING,
         l_channel           base.Channel,
         l_channel1          base.Channel

   WHENEVER ERROR CONTINUE

   LET ps_source=ARG_VAL(1)
   LET ps_opt=ARG_VAL(2)          ### BUG-4A0082
#  LET ps_source="$TEMPDIR/",p_name CLIPPED
  DISPLAY ps_source
   LET ps_target = "C:\\tiptop"

  IF cl_null(ps_source) OR cl_null(ps_target) THEN
     RETURN FALSE
  END IF
 
  IF (ps_opt = "b") or (ps_opt = "x") THEN  ###BUG-4A0082 BUG-550203 
     LET tmp_file = ps_source CLIPPED,".tmp"
     ##加跳行符號
     LET l_channel = base.Channel.create()
     LET l_channel1 = base.Channel.create()
     CALL l_channel.openFile(tmp_file,"a" )
     CALL l_channel1.openFile(ps_source,"r" )
     CALL l_channel.setDelimiter("")
     CALL l_channel1.setDelimiter("")

     LET s=l_channel1.readLine()
     WHILE s IS NOT NULL 
        LET s = s CLIPPED,ascii(13)
        CALL l_channel.write(s)
        display s 
        LET s=l_channel1.readLine()
     END WHILE
     CALL l_channel.close()
     CALL l_channel1.close()
     LET l_cmd="rm ",ps_source CLIPPED
     RUN l_cmd
     LET l_cmd="cp ",tmp_file CLIPPED," ",ps_source CLIPPED
     RUN l_cmd
     LET l_cmd="rm ",tmp_file CLIPPED
     RUN l_cmd
  END IF
  CALL cl_transferPrepare()

  #-- MOD-590017
  IF g_dvm_ver >= 1.32 AND g_fe_ver >= 1.32 THEN
     CALL FGL_PUTFILE(ps_source, ps_target || "\\" || ps_source)
     LET li_status = STATUS
  ELSE
     IF NOT cl_startRcpDaemon() THEN
        RETURN FALSE
     ELSE  
        LET li_status = 0
        LET ls_command = gs_rcp, " ", ps_source, " ", gs_client, ":\"", ps_target, "\" >/dev/null 2>&1"
        RUN ls_command RETURNING li_status
        display ls_command
        CALL cl_stopRcpDaemon()
     END IF
  END IF
  IF li_status != 0 THEN
     display li_status, ": file download failed(is source file existing?)."
     RETURN FALSE
  END IF
  #-- MOD-590017 end

  CASE ps_opt 
     WHEN "b"   ###BUG-4A0082 
        LET ls_command = "excel", " ", ps_target,"\\", ps_source
     WHEN "f"   ###BUG-4A0082 
        LET ls_command = "C:\\tiptop\\wpc.exe","  ", ps_target,"\\", ps_source,
                                               "  ", ps_target,"\\axrr330.doc", 
                                               "  ", ps_target,"\\Waxrr330.doc" 
     WHEN "x"   ###BUG-550203 
        LET ls_command = "C:\\tiptop\\PXRbar.exe","  ", ps_target,"\\", ps_source
  END CASE
  display ls_command    
  CALL ui.Interface.frontCall("standard",
                              "shellexec",
                              [ls_command],
                              [li_status])
  IF li_status > 0 THEN
     RETURN FALSE
  ELSE
     RETURN TRUE
  END IF
END MAIN

#-- MOD-590017
FUNCTION cl_transferPrepare()
  DEFINE li_idx     INTEGER
  DEFINE lch_ch     base.Channel
  DEFINE ls_str     STRING,
         ls_fe_ver  STRING,
         ls_dvm_ver STRING,
         ls_ver     STRING
  DEFINE lst_tok    base.StringTokenizer
  DEFINE li_cnt     INTEGER

 
  LET ls_fe_ver = ui.Interface.getFrontEndVersion()
  LET lst_tok = base.StringTokenizer.create(ls_fe_ver, ".")
  LET li_cnt = 1
  INITIALIZE ls_ver TO NULL
  WHILE lst_tok.hasMoreTokens()
      IF li_cnt > 2 THEN
         EXIT WHILE
      END IF
      IF li_cnt != 1 THEN
         LET ls_ver = ls_ver CLIPPED, "."
      END IF
      LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
      LET li_cnt = li_cnt + 1
  END WHILE
  LET g_fe_ver = ls_ver

  INITIALIZE ls_ver TO NULL
  LET lch_ch = base.Channel.create()
  CALL lch_ch.openPipe("fpi", "r")
  IF NOT STATUS THEN
     WHILE lch_ch.read(ls_str)
         LET ls_str = ls_str.toUpperCase()
         IF ( li_idx := ls_str.getIndexOf("VERSION", 1) ) THEN
            LET ls_dvm_ver = ls_str.subString(li_idx + 7, ls_str.getLength())
            LET ls_dvm_ver = ls_dvm_ver.trim()
            EXIT WHILE
         END IF
     END WHILE
     CALL lch_ch.close()
     
     LET lst_tok = base.StringTokenizer.create(ls_dvm_ver, ".")
     LET li_cnt = 1
     WHILE lst_tok.hasMoreTokens()
         IF li_cnt > 2 THEN
            EXIT WHILE
         END IF
         IF li_cnt != 1 THEN
            LET ls_ver = ls_ver CLIPPED, "."
         END IF
         LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
         LET li_cnt = li_cnt + 1
     END WHILE
  END IF
  LET g_dvm_ver = ls_ver

  IF g_dvm_ver < 1.32 OR g_fe_ver < 1.32 THEN
     LET gs_client = cl_getClientIP()
  
     LET gs_rcp = "rcp"
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("uname -a", "r")
     IF NOT STATUS THEN
        WHILE lch_ch.read(ls_str)
        END WHILE
        CALL lch_ch.close()
  
        LET ls_str = ls_str.toUpperCase()
        CASE
            WHEN ls_str.getIndexOf("AIX", 1) != 0
                 LET gs_rcp = "rcp.aix"
            WHEN ls_str.getIndexOf("SUNOS", 1) != 0
                 LET gs_rcp = "rcp.sun"
        END CASE
     END IF
  END IF
END FUNCTION
#-- MOD-590017 end

FUNCTION cl_getClientIP()
  DEFINE li_idx      INTEGER
  DEFINE ls_client   STRING
  

  LET ls_client = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") 
  IF cl_null(ls_client) THEN
     LET ls_client = FGL_GETENV("FGLSERVER")
  END IF
  LET li_idx = ls_client.getIndexOf(":", 1)
  IF li_idx != 0 THEN
     LET ls_client = ls_client.subString(1, li_idx - 1)
  END IF
  
  RETURN ls_client
END FUNCTION

FUNCTION cl_startRcpDaemon()
  DEFINE li_status   INTEGER

 
  CALL ui.Interface.frontCall("rcpd", "isStarted", [], [li_status])  
  IF NOT li_status THEN
     CALL ui.Interface.frontCall("rcpd", "start", [], [li_status])
     IF ( STATUS ) OR ( NOT li_status ) THEN
        RETURN FALSE
     END IF
  END IF
 
  RETURN TRUE
END FUNCTION

FUNCTION cl_stopRcpDaemon()
  DEFINE li_status   INTEGER

  CALL ui.Interface.frontCall("rcpd", "stop", [], [li_status])
END FUNCTION

FUNCTION cl_null(ps_source)
   DEFINE   ps_source    STRING
   DEFINE   li_is_null   SMALLINT


   IF (ps_source IS NULL) THEN
      LET li_is_null = TRUE
   ELSE
      LET ps_source = ps_source.trim()
      IF (ps_source.getLength() = 0) THEN
         LET li_is_null = TRUE
      END IF
   END IF

   RETURN li_is_null
END FUNCTION

