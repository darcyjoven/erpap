#--------------------------#
# 中英文畫面比對程式       #
# Gunter                   #
# 程式日期:99/05/27        #
#--------------------------#

DATABASE ds

GLOBALS
   DEFINE fname      CHAR(25)           #畫面檔名
   DEFINE chn_fname  CHAR(50)          #中文畫面檔案路徑
   DEFINE eng_fname  CHAR(50)          #英文畫面檔案路徑
END GLOBALS

MAIN
   whenever error continue

   CREATE TEMP TABLE chn_tag_info 
    ( tagname   CHAR(20),
      taglen    SMALLINT,
      times     SMALLINT)    

   CREATE TEMP TABLE eng_tag_info 
    ( tagname   CHAR(20),
      taglen    SMALLINT,
      times     SMALLINT )   
 

   LET chn_fname=arg_val(1) 
   LET eng_fname=arg_val(2)

   CALL tag_info_gen(chn_fname,0)            #產生中文畫面tag資訊

   CALL tag_info_gen(eng_fname,1)            #產生英文畫面tag資訊

   CALL tag_info_compare()                   #比對中英文畫面tag差異
   
   DROP TABLE chn_tag_info 
   DROP TABLE eng_tag_info
END MAIN

FUNCTION tag_info_gen(l_fname,l_flag)
   DEFINE l_fname      CHAR(50)             #畫面檔案路徑
   DEFINE l_flag       SMALLINT              #中英文畫面flag
   DEFINE l_tagname    CHAR(80)              #tag名稱
   DEFINE l_taglen     SMALLINT              #tag欄寬
   DEFINE l_start      SMALLINT
   DEFINE l_str        CHAR(100)
   DEFINE l_chr        CHAR(1)
   DEFINE l_pos        SMALLINT
   DEFINE l_times      SMALLINT
   DEFINE i            SMALLINT
   DEFINE l_length SMALLINT
   DEFINE l_prg    CHAR(1)
   
   DROP TABLE load_per
   CREATE TEMP TABLE load_per (ss CHAR(100))
   LOAD FROM l_fname INSERT INTO load_per

   DECLARE chk_per CURSOR FOR SELECT ss FROM load_per

   IF SQLCA.SQLCODE <> 0 THEN
      IF l_flag = 0 THEN
         DISPLAY "無法取得中文畫面資料",l_fname CLIPPED
      ELSE
         DISPLAY "無法取得英文畫面資料",l_fname CLIPPED
      END IF
   END IF

   LET l_prg = 1
   FOREACH chk_per INTO l_str
      LET l_length=length(l_str clipped)
      IF l_str[1,1]='}' THEN
         LET l_prg = 0
      END IF

      WHILE l_prg = 1
         LET i = 1
         FOR l_pos = i TO l_length                          #開始檢查tag
             LET l_chr=l_str[l_pos,l_pos]
             IF asc2(l_chr) > 127 THEN                   
                LET l_pos = l_pos + 1                       #中文字為兩個Bytes
                CONTINUE FOR
             ELSE
                IF l_chr = '[' THEN
                   LET l_start = l_pos + 1                  #tag啟始位置
                END IF
                IF l_chr = ']' THEN
                   LET l_tagname = l_str[l_start,l_pos-1] CLIPPED
                   LET l_taglen = l_pos - l_start 
                #  DISPLAY l_tagname,':',l_taglen 
                   #-->產生TAG資訊預備資料
                   LET l_times = 0
                   IF l_flag = 0 THEN
                      SELECT times INTO l_times FROM chn_tag_info
                       WHERE tagname = l_tagname
                      IF STATUS = 100 THEN
                         INSERT INTO chn_tag_info VALUES (l_tagname,l_taglen,1)
                      ELSE
                         IF l_times IS NOT NULL THEN
                            LET l_times = l_times + 1
                            UPDATE chn_tag_info
                               SET times = l_times 
                             WHERE tagname = l_tagname
                         END IF
                      END IF
                   ELSE
                      SELECT times INTO l_times FROM eng_tag_info
                       WHERE tagname = l_tagname
                      IF STATUS = 100 THEN
                         INSERT INTO eng_tag_info VALUES (l_tagname,l_taglen,1)
                      ELSE
                         IF l_times IS NOT NULL THEN 
                            LET l_times = l_times + 1
                            UPDATE eng_tag_info
                               SET times = l_times
                             WHERE tagname = l_tagname
                         END IF
                      END IF 
                   END IF
                END IF
                #LET l_pos = l_pos + 1
             END IF
         END FOR  
         EXIT WHILE
      END WHILE
   END FOREACH
END FUNCTION

FUNCTION tag_info_compare()                       #比對中英文畫面tag差異
   DEFINE  l_buf        CHAR(100)
   DEFINE  l_tagname    CHAR(20)                  #tag名稱
   DEFINE  l_taglen_chn    SMALLINT              #中文tag欄寬
   DEFINE  l_taglen_eng    SMALLINT              #英文tag欄寬
   DEFINE  l_times_chn     SMALLINT              #中文tag出現次數
   DEFINE  l_times_eng     SMALLINT              #英文tag出現次數

##--> 英文畫面沒有出現的TAG 
   DECLARE miss_tag_in_chn CURSOR FOR
      SELECT tagname FROM chn_tag_info 
       WHERE tagname NOT IN ( SELECT tagname FROM eng_tag_info )

   FOREACH miss_tag_in_chn INTO l_tagname
      DISPLAY "<< ",l_tagname CLIPPED,"在英文畫面沒有出現!! >>"
   END FOREACH 

##--> 中文畫面沒有出現的TAG 
   DECLARE miss_tag_in_eng CURSOR FOR
      SELECT tagname FROM eng_tag_info 
       WHERE tagname NOT IN ( SELECT tagname FROM chn_tag_info )

   FOREACH miss_tag_in_eng INTO l_tagname
      DISPLAY "<< ",l_tagname CLIPPED,"在中文畫面沒有出現!! >>"
   END FOREACH 

##->中英文畫面TAG欄寬不相等
   DECLARE tag_len CURSOR FOR
      SELECT chn_tag_info.tagname,chn_tag_info.taglen,eng_tag_info.taglen
        FROM chn_tag_info,eng_tag_info
       WHERE chn_tag_info.tagname = eng_tag_info.tagname         
         AND chn_tag_info.taglen <> eng_tag_info.taglen
   
   FOREACH tag_len INTO l_tagname,l_taglen_chn,l_taglen_eng 
      DISPLAY "<< ",l_tagname CLIPPED,"在中英文畫面檔的欄寬不相等: >>"
      DISPLAY "中文畫面欄寬:",l_taglen_chn
      DISPLAY "英文畫面欄寬:",l_taglen_eng
   END FOREACH

##->中英文畫面TAG出現次數不相等
   DECLARE tag_times CURSOR FOR
      SELECT chn_tag_info.tagname,chn_tag_info.times,eng_tag_info.times
        FROM chn_tag_info,eng_tag_info
       WHERE chn_tag_info.tagname = eng_tag_info.tagname         
         AND chn_tag_info.times <> eng_tag_info.times

   FOREACH tag_times INTO l_tagname,l_times_chn,l_times_eng 
      DISPLAY "<< ",l_tagname CLIPPED,"在中英文畫面檔的出現次數不相等: >> "
      DISPLAY "中文畫面出現次數:",l_times_chn
      DISPLAY "英文畫面出現次數:",l_times_eng
   END FOREACH
END FUNCTION

function asc2(p_str)
  define p_str char(1)
  define l_st char(1)
  define i smallint
  for i=1 to 255
   let l_st=ascii(i)
   if l_st=p_str then
      exit for
   end if
  end for
  return i
end function

