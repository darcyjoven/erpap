# Prog. Version..: '5.30.01-08.01.04(00000)'     #
#
# Pattern name...: top_chk_dyarr_id.4gl
# Descriptions...: 傳入本作業路徑,判別是否有用到dynamic array的元素做部分遮罩,
#                  有則回傳array id, 無則回傳 null
# Memo...........:
# Modify.........: No:DEV-C50001 12/05/04 By joyce 單檔程式設定遮罩後r.c2會失敗

IMPORT os
DATABASE ds

  DEFINE g_zz01  LIKE zz_file.zz01
  DEFINE g_zz08  LIKE zz_file.zz08
  DEFINE gs_file     STRING
  DEFINE gs_path     STRING

FUNCTION chk_forupd_sql(ls_prog,ls_field)   #No:DEV-C50001

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


FUNCTION chk_table_component(ls_fileread,ls_comp)

  DEFINE ch_read      base.channel
  DEFINE ls_fileread  STRING
  DEFINE ls_source    STRING
  DEFINE ls_tmp       STRING
  DEFINE ls_backup    STRING
  DEFINE li_chk1      INTEGER
  DEFINE ls_prog      STRING
  DEFINE li_status    INTEGER
  DEFINE lc_gdv01     LIKE gdv_file.gdv01
  DEFINE ls_comp      STRING

  LET ch_read = base.Channel.create() 

  CALL ch_read.openFile(ls_fileread, "r") 
  CALL ch_read.setDelimiter("")

  LET li_status = FALSE
  WHILE TRUE    #ch_read.read(ls_source)

      LET ls_source = ch_read.readLine()
      IF ch_read.iseof() THEN EXIT WHILE END IF

      LET ls_tmp = ls_source.trim()

      IF ls_tmp.subString(1,1) = "#" OR ls_tmp.subString(1,1) = "{" OR ls_tmp.subString(1,2) = "--" THEN
         LET ls_tmp = ""
      ELSE
         LET ls_tmp = ls_source.tolowercase()
      END IF
      IF ls_tmp.getIndexOf("#",1) THEN
         LET ls_tmp = ls_tmp.subString(1,ls_tmp.getIndexOf("#",1)-1)
      END IF

      #偵測到 MAIN or FUNCTION則停止
      IF ls_tmp.getIndexOf("main",1) OR ls_tmp.getIndexOf("function ",1) THEN
         EXIT WHILE
      END IF

      #抓取 "dynamic array "
      IF ls_tmp.getIndexOf("dynamic array of record",1) THEN
         LET ls_tmp = ls_tmp.trim()
         LET ls_tmp = ls_tmp.subString(ls_tmp.getIndexOf("_",1)+1,
                                       ls_tmp.getIndexOf("dynamic array",1)-1)
         LET li_chk1 = TRUE
      END IF

      IF ls_tmp.getIndexOf("end record",1) THEN
         LET li_chk1 = FALSE
         EXIT WHILE
      END IF

      IF li_chk1 THEN
         IF ls_tmp.getIndexOf(ls_comp,1) THEN
            LET li_status = TRUE               #此處若只符合前幾碼,也會過
            EXIT WHILE
         END IF
      END IF

      LET ls_backup = ls_source
  END WHILE 

  CALL ch_read.close() 

  RETURN li_status
END FUNCTION
