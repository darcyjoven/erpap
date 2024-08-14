# 由per中的單頭欄位說明,單身欄位說明部份文字敘述load至zq_file中
# 00/11/01 by Raymon

DATABASE ds

DEFINE g_string CHAR(120),
       i,j,k,m  SMALLINT,
       g_count  SMALLINT,
       g_field  CHAR(10)

MAIN

  WHENEVER ERROR CONTINUE
  DROP TABLE per_tmp
  CREATE TEMP TABLE per_tmp(string CHAR(120))
  
  LOAD FROM 'x' INSERT INTO per_tmp
  IF STATUS THEN EXIT PROGRAM END IF

  DECLARE per_cur CURSOR FOR SELECT * FROM per_tmp
                              WHERE string IS NOT NULL
                                AND string <> ' '
  IF STATUS THEN EXIT PROGRAM END IF

  LET g_count=1

  FOREACH per_cur INTO g_string
    IF g_string MATCHES '*○*' OR g_string MATCHES '*●*'
       THEN
       LET g_count=1
       FOR i=1 TO 120
           IF g_string[i,i]='['
              THEN
              IF i<120
                 THEN
                 LET m=i+1
                 IF g_string[m,m] MATCHES '[a-z]'
                    THEN 
                    LET j=i+1
                 END IF
              END IF
           END IF
           IF g_string[i,i]=']'
              THEN
              IF i>1
                 THEN
                 LET m=i-1
                 IF g_string[m,m] MATCHES '[a-z]' OR
                    g_string[m,m] MATCHES '[0-9]'
                    THEN 
                    LET k=i-1 EXIT FOR
                 END IF
              END IF
           END IF
       END FOR
       LET g_field = g_string[j,k]
       DISPLAY g_field,'\ ',g_count USING '&&','\ ',g_string CLIPPED,'\'
    ELSE
       LET g_count = g_count + 1
       DISPLAY g_field,'\ ',g_count USING '&&','\ ',g_string CLIPPED,'\'
    END IF

  END FOREACH

END MAIN
