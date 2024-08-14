# Descriptions...: 效能檢測工具作業
# Date & Author..: No.FUN-E30003 14/03/06 By AndyHuang
# Modify.........: No:FUN-E30040 14/03/21 By AndyHuang fixed Error Msg"An array variable has been referenced outside of its specified dimensions"
# Modify.........: No:FUN-E50050 14/05/16 By AndyHuang optimize program,add excel output
# Modify.........: No:FUN-E90077 14/09/30 By AndyHuang 修正不同檔案同一行時會列同一筆計算

IMPORT os
DATABASE ds

GLOBALS
  DEFINE unix_path	STRING  # FUN-E50050
END GLOBALS

MAIN
  DEFINE g_sql	STRING
  DEFINE l_sql	STRING
  # ---FUN-E50050 start---
  DEFINE l_ln   INTEGER
  DEFINE l_ln1  STRING
  DEFINE l_tm   STRING
  DEFINE l_day  STRING
  DEFINE l_hour STRING
  DEFINE l_min  STRING
  DEFINE l_sec  STRING
  DEFINE l_match STRING
  DEFINE l_time DECIMAL(10,5)
  DEFINE l_prog STRING
  DEFINE l_line integer
  DEFINE str_sql  STRING
  DEFINE str_line STRING
  DEFINE str_time STRING
  DEFINE l_status BOOLEAN
  # ---FUN-E50050 end---
  DEFINE arr DYNAMIC ARRAY OF STRING
  # ---FUN-E50050 start---
  #DEFINE lines DYNAMIC ARRAY OF RECORD
  #    line STRING, 
  #    prog STRING,
  #    sql STRING,
  #    time DECIMAL(10,5)
  #  END RECORD
  # ---FUN-E50050 end---
  DEFINE data DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD	# FUN-E90077
      line INTEGER,
      count INTEGER,
      prog STRING,
      sql STRING,
      time DECIMAL(10,5)
    END RECORD

  DEFINE buff1 STRING
  DEFINE ch_in base.Channel
  DEFINE ch_out base.Channel
  DEFINE buf base.StringBuffer
  DEFINE all_time,avg_time DECIMAL(10,5)
  DEFINE l_arg1	STRING

  DEFINE i INTEGER
  DEFINE j INTEGER
  DEFINE cnt INTEGER
  DEFINE l_u,l_key INTEGER	# FUN-E90077
  DEFINE arr1 ARRAY[2000] OF RECORD
             row INTEGER,               # FUN-E50050
             time DECIMAL(10,5),
             num INTEGER,
             avgtime DECIMAL(10,5),
             line INTEGER,
             prog VARCHAR(50),
             sql VARCHAR(4000)          # FUN-E50050
         END RECORD
  DEFINE att1 DYNAMIC ARRAY OF RECORD
                 row_color STRING,      # FUN-E50050
                 time_color STRING,     # FUN-E50050
                 num_color STRING,      # FUN-E50050
                 avgtime_color STRING,  # FUN-E50050
                 line_color STRING,     # FUN-E50050
                 prog_color STRING,     # FUN-E50050
                 sql_color STRING       # FUN-E50050
         END RECORD

  DEFINE ls_topPath         STRING
  # ---FUN-E50050 start---
  DEFINE aui om.DomNode
  DEFINE tb  om.DomNode
  DEFINE tbi om.DomNode
  DEFINE tbs om.DomNode
  DEFINE window_path    STRING
  DEFINE src_name       STRING
  DEFINE dir_name       STRING
  DEFINE file_name      STRING
  # ---FUN-E50050 end---

  DEFER INTERRUPT
  WHENEVER ERROR CONTINUE

  LET l_arg1 = ARG_VAL(1)
  CALL os.Path.dirname(l_arg1) RETURNING dir_name       # FUN-E50050
  CALL os.Path.basename(l_arg1) RETURNING file_name     # FUN-E50050

  IF l_arg1 IS NULL THEN
    DISPLAY "Usage: fgldebug [FGLSQLDEBUG LOGFILE]"
    EXIT PROGRAM
  END IF
  
  IF os.Path.exists(l_arg1) = FALSE THEN
    DISPLAY "Error: file is not exist"
    EXIT PROGRAM
  END IF

  LET ls_topPath = FGL_GETENV("TOP")

  CLOSE WINDOW screen
  OPEN WINDOW fgldebug WITH FORM ls_topPath||"/ds4gl2/bin/fgldebug" ATTRIBUTES(TEXT="FGLSQL Debug Mode")
  # ---FUN-E50050 start---
  LET aui = ui.Interface.getRootNode()
  LET tb = aui.createChild("ToolBar")
  LET tbi = createToolBarItem(tb,"export","Excel","Export To Excel","export")
  LET tbs = createToolBarSeparator(tb)
  LET tbi = createToolBarItem(tb,"exit","Exit","Quit application","quit")
  # ---FUN-E50050 end---

  CREATE TEMP TABLE tmp_file(
        time    	DECIMAL(10,5),
        num     	VARCHAR(20),
        avgtime    	DECIMAL(10,5),
        line    	VARCHAR(20),
        prog    	VARCHAR(50),
        sql    		VARCHAR(4000)   # FUN-E50050
  )

  RUN "echo \"\";echo -n \"FglDebug Start:\";date +%T.%N"
  # ---FUN-E50050 start---
  #RUN "egrep \"SQL:\ \" "||l_arg1||" > tmp.log"
  #RUN "cat tmp.log | awk '{print \";\",$0}' | cat -n | awk 'begin{}{$1=$1;print}' > sql.log"
  #RUN "egrep \"\ line=\" "||l_arg1||" > tmp.log"
  #RUN "cat -n tmp.log | awk '{print $1,$7,$6}' > line.log"
  #RUN "egrep \"Execution time\" "||l_arg1||" > tmp.log"
  #RUN "cat -n tmp.log | awk '{print $1,substr($7,7,length($7))}' > time.log"
  #RUN "rm -rf tmp.log"
  RUN "egrep \"SQL:\ |\ line=|Execution time\" "||l_arg1||" > tmp.log"

  #LET ch_in = base.Channel.create()
  #CALL ch_in.openFile("sql.log","r")
  #WHILE ch_in.read([buff1])
  #  CALL split(buff1,";") RETURNING arr
  #  LET lines[arr[1]].sql=arr[2]
  #END WHILE
  #CALL ch_in.close()
  #
  #LET ch_in = base.Channel.create()
  #CALL ch_in.openFile("line.log","r")
  #WHILE ch_in.read([buff1])
  #  CALL split(buff1," ") RETURNING arr
  #  LET lines[arr[1]].line=arr[2]
  #  LET lines[arr[1]].prog=arr[3]
  #END WHILE
  #CALL ch_in.close()
  #
  #LET ch_in = base.Channel.create()
  #CALL ch_in.openFile("time.log","r")
  #WHILE ch_in.read([buff1])
  #  CALL split(buff1," ") RETURNING arr
  #  LET lines[arr[1]].time=arr[2]
  #END WHILE
  #CALL ch_in.close()
  #
  #LET i = lines.getLength()
  #FOR j = 1 to i
  #  LET buf = base.StringBuffer.create()
  #  CALL buf.append(lines[j].line)
  #  CALL buf.replace("line=","",1)
  #  CALL buf.trim()
  #  IF buf.toString() <= 0 OR (buf.toString() * 1) IS NULL THEN		#FUN-E30040
  #    CONTINUE FOR
  #  END IF
  #  LET data[buf.toString()].line=buf.toString()
  #  IF data[buf.toString()].count IS NULL THEN
  #    LET data[buf.toString()].count=0
  #  END IF
  #  LET data[buf.toString()].count=data[buf.toString()].count+1
  #  LET data[buf.toString()].prog=lines[j].prog
  #  LET data[buf.toString()].sql=lines[j].sql
  #  IF data[buf.toString()].time IS NULL THEN
  #    LET data[buf.toString()].time=0
  #  END IF
  #  IF lines[j].time IS NULL THEN
  #    LET lines[j].time=0
  #  END IF
  #  LET data[buf.toString()].time=data[buf.toString()].time+lines[j].time
  #  CALL buf.clear()
  #END FOR
  #
  #RUN "cat /dev/null > "||l_arg1||"f"
  #LET all_time=0
  #LET ch_out = base.Channel.create()
  #CALL ch_out.openFile( l_arg1||"f", "w" )
  #
  #BEGIN WORK
  #LET i=data.getLength()
  #FOR j = 1 to i+1
  #  IF data[j].line IS NULL THEN
  #    CONTINUE FOR
  #  END IF
  #  LET all_time=all_time+data[j].time
  #  LET buf = base.StringBuffer.create()
  #  CALL buf.append(data[j].sql)
  #  CALL buf.replace("'","''",0)
  #  LET l_sql = buf.toString()
  #  LET avg_time = data[j].time/data[j].count
  #  CALL ch_out.write(data[j].time||" | "||data[j].count||" | "||avg_time||" | "||data[j].line||" | "||data[j].prog||" | "||data[j].sql)
  #  LET g_sql = "INSERT INTO tmp_file VALUES('",data[j].time,"','",data[j].count,"','",avg_time,"','",data[j].line,"','",data[j].prog,"','",l_sql,"')"
  #  PREPARE insert_prep FROM g_sql
  #  EXECUTE insert_prep
  #  CALL buf.clear()
  #END FOR
  #RUN "echo \"all_time | "||all_time||"\" > "||l_arg1||"fr"
  #RUN "cat "||l_arg1||"f | sort -rn >> "||l_arg1||"fr"
  #RUN "cat "||l_arg1||"f | sort -n > ."||l_arg1||"f ; cp -rfp ."||l_arg1||"f "||l_arg1||"f ; rm -rf ."||l_arg1||"f"
  #CALL ch_out.write("all_time="||all_time)
  #CALL ch_out.close()
  #COMMIT WORK
  #
  #RUN "rm -f line.log"
  #RUN "rm -f time.log"
  #RUN "rm -f sql.log"
  LET all_time=0
  LET ch_in = base.Channel.create()
  CALL ch_in.openFile("tmp.log","r")
  CALL ch_in.setDelimiter("")
  WHILE ch_in.read([buff1])
    LET str_sql = buff1.subString(1,4)
    LET str_line = buff1.subString(4,13)
    LET str_time = buff1.subString(4,17)
    IF str_sql == "SQL:" THEN
      LET l_ln = 2
      LET l_match = "4gl source"
      LET l_sql = buff1
      LET l_key = 1 # FUN-E90077
    END IF
    IF str_line == l_match AND l_ln == 2 THEN
      LET l_ln = 3
      LET l_match = "Execution time"
      LET l_ln1 = buff1.subString(22,buff1.getLength())
      CALL split(l_ln1," ") RETURNING arr
      LET l_prog = arr[1]
      LET buf = base.StringBuffer.create()
      CALL buf.append(arr[2])
      CALL buf.replace("line=","",1)
      CALL buf.trim()
      IF buf.toString() <= 0 OR (buf.toString() * 1) IS NULL THEN		#FUN-E30040
        CONTINUE WHILE
      END IF
      LET l_line = buf.toString()
      CALL buf.clear()
      # ---FUN-E90077 start---
      FOR l_u=1 TO data[l_line].getLength()
        IF data[l_line,l_u].prog == l_prog THEN
          LET l_key = l_u
          EXIT FOR
        ELSE
          LET l_key = l_key + 1  
        END IF  
      END FOR
      # ---FUN-E90077 end---
      LET data[l_line,l_key].line=l_line	# FUN-E90077
      LET buf = base.StringBuffer.create()
      CALL buf.append(l_sql)
      CALL buf.replace("'","''",0)
      LET l_sql = buf.toString()
      CALL buf.clear()
      # ---FUN-E90077 start---
      LET data[l_line,l_key].prog=l_prog
      LET data[l_line,l_key].sql=l_sql
      IF data[l_line,l_key].count IS NULL THEN
        LET data[l_line,l_key].count=0
      END IF
      LET data[l_line,l_key].count=data[l_line,l_key].count+1
      IF data[l_line,l_key].time IS NULL THEN
        LET data[l_line,l_key].time=0
      END IF
      # ---FUN-E90077 end---
    END IF
    IF str_time == l_match AND l_ln == 3 THEN
      LET l_ln = 1
      LET l_match = ""
      LET l_tm = buff1.subString(24,buff1.getLength())
      LET l_day = l_tm.subString(1,1) *24*60*60
      LET l_hour = l_tm.subString(3,4) *60*60
      LET l_min = l_tm.subString(6,7) *60
      LET l_sec = l_tm.subString(9,l_tm.getLength())
      LET l_time = l_day+l_hour+l_min+l_sec
      LET data[l_line,l_key].time=data[l_line,l_key].time+l_time	# FUN-E90077
      LET all_time=all_time+l_time
    END IF
  END WHILE
  CALL ch_in.close()

  RUN "cat /dev/null > "||l_arg1||"f"
  LET ch_out = base.Channel.create()
  CALL ch_out.openFile( l_arg1||"f", "w" )
  CALL ch_out.setDelimiter("")

  BEGIN WORK
  LET i = data.getLength()
  FOR j = 1 to i
    FOR l_key = 1 to data[j].getLength()	# FUN-E90077
      IF data[j,l_key].LINE IS NULL THEN	# FUN-E90077
        CONTINUE FOR
      END IF
      LET avg_time = data[j,l_key].time/data[j,l_key].count	# FUN-E90077
      CALL ch_out.write(data[j,l_key].time||" | "||data[j,l_key].count||" | "||avg_time||" | "||data[j,l_key].line||" | "||data[j,l_key].prog||" | "||data[j,l_key].sql)	# FUN-E90077
      LET g_sql = "INSERT INTO tmp_file VALUES('",data[j,l_key].time,"','",data[j,l_key].count,"','",avg_time,"','",data[j,l_key].line,"','",data[j,l_key].prog,"','",data[j,l_key].sql,"')"	# FUN-E90077
      PREPARE insert_prep FROM g_sql
      EXECUTE insert_prep
    END FOR
  END FOR
  COMMIT WORK
  RUN "echo \"all_time | "||all_time||"\" > "||l_arg1||"fr"
  RUN "cat "||l_arg1||"f | sort -rn >> "||l_arg1||"fr"
  RUN "cat "||l_arg1||"f | sort -n > "||dir_name||"/."||file_name||"f ; cp -rfp "||dir_name||"/."||file_name||"f "||l_arg1||"f ; rm -rf "||dir_name||"/."||file_name||"f"
  CALL ch_out.write("all_time="||all_time)
  CALL ch_out.close()
  RUN "rm -rf tmp.log"
  # ---FUN-E50050 end---
  RUN "echo -n \"FglDebug End:  \";date +%T.%N"

  DISPLAY all_time TO alltime

  DECLARE c1 CURSOR FOR
     SELECT 0,time,num,avgtime,line,prog,sql FROM tmp_file order by time desc # FUN-E50050
  LET cnt = 1
  FOREACH c1 INTO arr1[cnt].*
    LET arr1[cnt].row = cnt # FUN-E50050
    IF cnt MOD 2 = 0 THEN
      LET att1[cnt].row_color = "#EFECCB reverse"     # FUN-E50050
      LET att1[cnt].time_color = "#EFECCB reverse"    # FUN-E50050
      LET att1[cnt].num_color = "#EFECCB reverse"     # FUN-E50050
      LET att1[cnt].avgtime_color = "#EFECCB reverse" # FUN-E50050
      LET att1[cnt].line_color = "#EFECCB reverse"    # FUN-E50050
      LET att1[cnt].prog_color = "#EFECCB reverse"    # FUN-E50050
      LET att1[cnt].sql_color = "#EFECCB reverse"     # FUN-E50050
    END IF
    LET cnt = cnt + 1
  END FOREACH
  LET cnt = cnt - 1
  DISPLAY ARRAY arr1 TO srec.* ATTRIBUTES(COUNT=cnt)
    BEFORE DISPLAY
       CALL DIALOG.setCellAttributes(att1)
    # ---FUN-E50050 start---
       CALL DIALOG.setActionHidden("accept", TRUE)
       CALL DIALOG.setActionHidden("cancel", TRUE)
    ON Action export
       LET src_name = file_name,"fr.xls"
       LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),src_name CLIPPED)
       CALL excel(all_time)
       CALL os.Path.chrwx(unix_path,438) RETURNING l_status
       LET window_path = "c:\\tiptop\\",src_name
       LET STATUS = cl_download_file(unix_path, window_path)
       LET STATUS = cl_open_prog("excel",window_path)
    ON Action EXIT
       EXIT PROGRAM
    # ---FUN-E50050 end---
  END DISPLAY

END MAIN

FUNCTION split(l_str,l_symbol)
   DEFINE l_str      STRING
   DEFINE la_field       DYNAMIC ARRAY OF STRING
   DEFINE li_idx         INTEGER
   DEFINE ls_token       STRING
   DEFINE lst_token      base.StringTokenizer
   DEFINE l_symbol STRING
   DEFINE buf base.StringBuffer

   LET li_idx = 0
   LET lst_token = base.StringTokenizer.create(l_str, l_symbol)
   WHILE lst_token.hasMoreTokens()
     LET ls_token = lst_token.nextToken()
     LET buf = base.StringBuffer.create()
     CALL buf.append(ls_token)
     CALL buf.trim()
     LET li_idx = li_idx + 1
     LET la_field[li_idx] = buf.toString()
   END WHILE
   RETURN la_field
END FUNCTION

# ---FUN-E50050 start---
FUNCTION createToolBarSeparator(tb)
   DEFINE tb om.DomNode
   DEFINE tbs om.DomNode
   LET tbs = tb.createChild("ToolBarSeparator")
   RETURN tbs
END FUNCTION

FUNCTION createToolBarItem(tb,n,t,c,i)
   DEFINE tb om.DomNode
   DEFINE n,t,c,i VARCHAR(100)
   DEFINE tbi om.DomNode
   LET tbi = tb.createChild("ToolBarItem")
   CALL tbi.setAttribute("name",n)
   CALL tbi.setAttribute("text",t)
   CALL tbi.setAttribute("comment",c)
   CALL tbi.setAttribute("image",i)
   RETURN tbi
END FUNCTION

FUNCTION cl_open_prog(ps_prog, ps_arg)
  DEFINE ps_prog   STRING,
         ps_arg    STRING

  IF ps_arg IS NULL THEN
     RETURN FALSE
  END IF

  IF execClientApp(ps_prog, ps_arg) THEN
     RETURN TRUE
  ELSE
     RETURN FALSE
  END IF
END FUNCTION

FUNCTION execClientApp(ps_app, ps_doc)
   DEFINE ps_app       STRING,
          ps_doc       STRING
   DEFINE li_status    DECIMAL(10)
   DEFINE ls_command   STRING
   DEFINE lt_tok       base.StringTokenizer,
          ls_arg       STRING

   IF ps_app IS NULL AND ps_doc IS NULL THEN
      RETURN FALSE
   END IF

   IF ps_app IS NULL THEN
      CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  [ps_doc],
                                  [li_status])
   ELSE
      LET ls_command = ps_app

      IF ps_doc IS NOT NULL THEN
         LET lt_tok = base.StringTokenizer.create(ps_doc, "|")
         WHILE lt_tok.hasMoreTokens()
             LET ls_arg = lt_tok.nextToken()
             LET ls_command = ls_command, " \"", ls_arg, "\""
         END WHILE
      END IF
      CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  [ls_command],
                                  [li_status])
   END IF

   IF ( STATUS ) OR ( NOT li_status ) THEN
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION

FUNCTION cl_download_file(ps_source, ps_target)
  DEFINE ps_source    STRING,
         ps_target    STRING

  IF ps_source IS NULL OR ps_target IS NULL THEN
     RETURN FALSE
  END IF

  CALL FGL_PUTFILE(ps_source, ps_target)
  IF STATUS THEN
     RETURN FALSE
  ELSE
     RETURN TRUE
  END IF
END FUNCTION

FUNCTION excel(all_time)
  DEFINE mystr  base.StringBuffer
  DEFINE all_time 	DECIMAL(10,5)
  DEFINE ch_xml 	base.Channel
  DEFINE l_xml	 	STRING
  DEFINE l_str,l_alltime STRING
  DEFINE cnt 		INTEGER
  DEFINE l_arr1 ARRAY[2000] OF RECORD
             time DECIMAL(10,5),
             num INTEGER,
             avgtime DECIMAL(10,5),
             line INTEGER,
             prog VARCHAR(50),
             sql VARCHAR(4000)
         END RECORD

  LET  ch_xml = base.Channel.create()
  CALL ch_xml.openFile( unix_path, "w" )
  CALL ch_xml.setDelimiter("")
  let l_alltime = all_time
  let l_alltime = l_alltime.trim()

  LET mystr = base.StringBuffer.create()

  LET l_xml='<?xml version="1.0"?>',ASCII 10,
  '<?mso-application progid=:"Excel.Sheet"?>',ASCII 10,
  '<Workbook xmlns:C="urn:schemas-microsoft-com:office:component:spreadsheet"',ASCII 10,
  'xmlns:html="http://www.w3.org/TR/REC-html40"',ASCII 10,
  'xmlns:o="urn:schemas-microsoft-com:office:office"',ASCII 10,
  'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',ASCII 10,
  'xmlns="urn:schemas-microsoft-com:office:spreadsheet"',ASCII 10,
  'xmlns:x2="http://schemas.microsoft.com/office/excel/2003/xml"',ASCII 10,
  'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"',ASCII 10,
  'xmlns:x="urn:schemas-microsoft-com:office:excel">',ASCII 10,
  '<Styles>',ASCII 10,
  '<Style ss:ID="s66">',ASCII 10,
  '<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',ASCII 10,
  '<NumberFormat ss:Format="0.00000_ "/>',ASCII 10,
  '</Style>',ASCII 10,
  '<Style ss:ID="s65">',ASCII 10,
  '<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',ASCII 10,
  '</Style>',ASCII 10,
  '<Style ss:ID="s64">',ASCII 10,
  '<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>',ASCII 10,
  '</Style>',ASCII 10,
  '<Style ss:ID="s108">',ASCII 10,
  '<Interior ss:Color="#95B3D7" ss:Pattern="Solid"/>',ASCII 10,
  '</Style>',ASCII 10,
  '<Style ss:ID="s110">',ASCII 10,
  '<Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>',ASCII 10,
  '</Style>',ASCII 10,
  '</Styles>',ASCII 10,
  '<Worksheet ss:Name="fgldebug">',ASCII 10,
  '<Table>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="83.25"/>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="69.75"/>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="83.25"/>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="57.75"/>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="177.75"/>',ASCII 10,
  '<Column ss:AutoFitWidth="0" ss:Width="123.75"/>',ASCII 10,
  '<Row>',ASCII 10,
  '<Cell ss:StyleID="s110"><Data ss:Type="String">RUN_ALL_TIME</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s66"><Data ss:Type="Number">',l_alltime,'</Data></Cell>',ASCII 10,
  '</Row>',ASCII 10,
  '<Row>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">RUN_TIME</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">RUN_NUM</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">AVG_TIME</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">RUN_LINE</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">PROG_NAME</Data></Cell>',ASCII 10,
  '<Cell ss:StyleID="s108"><Data ss:Type="String">SQL_STMT</Data></Cell>',ASCII 10,
  '</Row>',ASCII 10
  CALL mystr.append(l_xml)
  DECLARE c2 CURSOR FOR
    SELECT time,num,avgtime,line,prog,sql FROM tmp_file order by time desc
  LET cnt = 1
  FOREACH c2 INTO l_arr1[cnt].*
    LET l_xml = '<Row>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].time
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s66"><Data ss:Type="Number">',l_str,'</Data></Cell>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].num
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s65"><Data ss:Type="Number">',l_str,'</Data></Cell>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].avgtime
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s66"><Data ss:Type="Number">',l_str,'</Data></Cell>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].line
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s65"><Data ss:Type="Number">',l_str,'</Data></Cell>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].prog
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s64"><Data ss:Type="String">',l_str,'</Data></Cell>',ASCII 10
    CALL mystr.append(l_xml)
    LET l_str = l_arr1[cnt].sql
    LET l_str = l_str.trim()
    LET l_xml = '<Cell ss:StyleID="s64"><Data ss:Type="String">',l_str,'</Data></Cell>',ASCII 10,'</Row>',ASCII 10
    CALL mystr.append(l_xml)
    LET cnt = cnt + 1
  END FOREACH
  LET l_xml='</Table>',ASCII 10,'</Worksheet>',ASCII 10,'</Workbook>'
  CALL mystr.append(l_xml)
  CALL ch_xml.write(mystr.toString())
  CALL ch_xml.close()

END FUNCTION
# ---FUN-E50050 end---

