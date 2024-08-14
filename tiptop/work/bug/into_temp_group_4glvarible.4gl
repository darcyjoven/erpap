# 日期:     90/11/17 (六)
# 狀況:     SELECT INTO TEMP + UNION + GROUP BY + 4GL 變數會出現錯誤
# 錯誤代碼: -6372
# 發生程式: aglr900.4gl (苓嘉)
# 測試人員: Frank Yang

DATABASE ds

DEFINE l_yy   INTEGER
MAIN
   WHENEVER ERROR CONTINUE

LET l_yy=2000

DISPLAY "<< INTO TEMP Test + Group By + 4GL Variable >>"

  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   GROUP BY aba03
 UNION
  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   GROUP BY aba03
 INTO TEMP aa

DISPLAY "Case 0: UNION + GROUP BY -> ",STATUS

  SELECT aba03 t, aba04 d1
    FROM aba_file 
   WHERE aba03=l_yy 
 UNION
  SELECT aba03 t, aba04 d1
    FROM aba_file 
   WHERE aba03=l_yy 
 INTO TEMP bb

DISPLAY "Case 1: UNION + Both WHERE clauses with Variable -> ",STATUS


  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   WHERE aba03=l_yy 
   GROUP BY aba03
 UNION
  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   GROUP BY aba03
 INTO TEMP cc

DISPLAY "Case 2: UNION + GROUP BY + First Where clause with VARIBLE -> ",STATUS


  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   GROUP BY aba03
 UNION
  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   WHERE aba03=l_yy 
   GROUP BY aba03
 INTO TEMP dd 

DISPLAY "Case 3: UNION + GROUP BY + Second Where clause with VARIBLE -> ",STATUS

  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   WHERE aba03=l_yy 
   GROUP BY aba03
 UNION
  SELECT aba03 t, SUM (aba04) d1
    FROM aba_file 
   WHERE aba03=l_yy 
   GROUP BY aba03
 INTO TEMP ee

DISPLAY "Case 4: UNION + GROUP BY + Both SQL with VARIBLE ->",STATUS

END MAIN
