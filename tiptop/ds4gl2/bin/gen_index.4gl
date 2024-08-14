# Prog. Version..: '1.00.03-04.10.13'     #
# Pattern name...: gen_index.4gl
# Descriptions...: index schema file產生作業
# Date & Author..: 04/12/14 By qazzaq
# Modify.........: 

DATABASE ds
MAIN
DEFINE
    l_result      CHAR(5),
    p_type        CHAR(1),
    p_zta01       CHAR(15),
    l_db_type     CHAR(3),
    l_db          CHAR(20),
    p_zta17       CHAR(10),
    l_ztc04_t     CHAR(20),
    l_sql         CHAR(1000),
    l_sql1        CHAR(1000),
    l_cmd         CHAR(1000),
    l_cnt         SMALLINT,
    i,j,k         SMALLINT,
    l_unique      CHAR(1),
    l_unique_bak  CHAR(1),
    l_tab_name    CHAR(15),
    l_tab_name_bak CHAR(15),
    l_idx_name    CHAR(20),
    l_idx_name_bak CHAR(20),
    l_column      CHAR(20),
    l_columns     CHAR(400),
    l_length      SMALLINT,
    l_length1     CHAR(10),
    l_scale       SMALLINT,
    l_nullable    CHAR(1),
    l_i           SMALLINT,
    l_part RECORD 
           part1  SMALLINT,
           part2  SMALLINT,
           part3  SMALLINT,
           part4  SMALLINT,
           part5  SMALLINT,
           part6  SMALLINT,
           part7  SMALLINT,
           part8  SMALLINT,
           part9  SMALLINT,
           part10 SMALLINT,
           part11 SMALLINT,
           part12 SMALLINT,
           part13 SMALLINT,
           part14 SMALLINT,
           part15 SMALLINT,
           part16 SMALLINT
           END RECORD,
    l_part_arr ARRAY[16] of SMALLINT

    WHENEVER ERROR CONTINUE
    LET l_db=ARG_VAL(1)
    IF l_db is null THEN 
       DISPLAY "please choose a database!"
       RETURN
    END IF
 
    LET l_db_type=DB_GET_DATABASE_TYPE()
    LET l_cmd="test -e $FGLDBPATH/",l_db CLIPPED,"_idx.sch"
    RUN l_cmd RETURNING l_result
    IF l_result = "0" THEN
       LET l_cmd="rm -f $FGLDBPATH/",l_db CLIPPED,"_idx.sch"
       RUN l_cmd RETURNING l_result
       IF l_result!="0" THEN
          display "write $FGLDBPATH/",l_db CLIPPED,"_idx.sch error!!"
          EXIT PROGRAM
       END IF
    END IF
    IF l_db_type="IFX" THEN
       LET l_sql=" SELECT DISTINCT idxname,idxtype,part1,part2,part3,",
                 "        part4,part5,part6,part7,part8,part9,part10,",
                 "        part11,part12,part13,part14,part15,part16,a.tabname ",
                 "   FROM systables a, sysindexes c ",
                 "  WHERE (a.tabname like '___file'",
                 "     OR a.tabname like '____file'",
                 "     OR a.tabname like '_____file'",
                 "     OR a.tabname like 'aps%' )",
                 "    AND a.tabid=c.tabid"
       LET l_sql1=" SELECT count(*)",
                 "   FROM systables a, sysindexes c ",
                 "  WHERE (a.tabname like '___file'",
                 "     OR a.tabname like '____file'",
                 "     OR a.tabname like '_____file'",
                 "     OR a.tabname like 'aps%' )",
                 "    AND a.tabid=c.tabid"
       DATABASE l_db
       IF sqlca.sqlcode THEN
          DISPLAY "change DB error:",l_db
          RETURN
       END IF
       DECLARE ifx_cur CURSOR FROM l_sql
       IF sqlca.sqlcode THEN
          DISPLAY sqlca.sqlcode,"declare ifx_cur error:",l_db
          RETURN
       END IF
       DECLARE ifx_cnt_cur CURSOR FROM l_sql1
       IF sqlca.sqlcode THEN
          DISPLAY sqlca.sqlcode,"declare ifx_cnt_cur error:",l_db
          RETURN
       END IF
       OPEN ifx_cnt_cur
       IF sqlca.sqlcode THEN
          DISPLAY sqlca.sqlcode,"open cursor ifx_cnt_cur error:",l_db
          RETURN
       END IF
       FETCH ifx_cnt_cur into l_cnt
       IF sqlca.sqlcode THEN
          DISPLAY sqlca.sqlcode,"fetch cursor ifx_cnt_cur error:",l_db
          RETURN
       END IF
       IF l_cnt>=1 THEN
          LET l_cnt=1
          FOREACH ifx_cur INTO l_idx_name,l_unique,l_part.*,l_tab_name
             IF sqlca.sqlcode THEN
                DISPLAY sqlca.sqlcode,"foreach ifx_cur data error!"
                RETURN
             END IF
             LET l_part_arr[1]=l_part.part1
             LET l_part_arr[2]=l_part.part2
             LET l_part_arr[3]=l_part.part3
             LET l_part_arr[4]=l_part.part4
             LET l_part_arr[5]=l_part.part5
             LET l_part_arr[6]=l_part.part6
             LET l_part_arr[7]=l_part.part7
             LET l_part_arr[8]=l_part.part8
             LET l_part_arr[9]=l_part.part9
             LET l_part_arr[10]=l_part.part10
             LET l_part_arr[11]=l_part.part11
             LET l_part_arr[12]=l_part.part12
             LET l_part_arr[13]=l_part.part13
             LET l_part_arr[14]=l_part.part14
             LET l_part_arr[15]=l_part.part15
             LET l_part_arr[16]=l_part.part16
             IF l_unique='D' THEN LET l_unique='N' END IF
             LET l_sql="SELECT colname FROM systables,syscolumns ",
                       " WHERE tabname='",l_tab_name CLIPPED,"'",
                       "   AND systables.tabid=syscolumns.tabid ",
                       " AND colno = ?"
             DECLARE ifx_cur2 CURSOR FROM l_sql
             LET l_columns=''
             FOR l_i=1 TO 16
                 IF l_part_arr[l_i] IS NULL THEN EXIT FOR END IF
                 FOREACH ifx_cur2 USING l_part_arr[l_i] INTO l_column
                    IF sqlca.sqlcode THEN
                       DISPLAY sqlca.sqlcode,"foreach sysindexes error"
                       RETURN
                    END IF
                    IF l_columns IS NULL THEN
                       LET l_columns=l_column CLIPPED
                    ELSE
                       LET l_columns=l_columns CLIPPED,",",l_column CLIPPED
                    END IF
                 END FOREACH
             END FOR
             LET l_cmd='echo "',l_idx_name CLIPPED,"^",
                               l_unique CLIPPED,"^",
                               l_columns CLIPPED,"^",
                               l_tab_name CLIPPED,'^" >>$FGLDBPATH/',l_db CLIPPED,
                               '_idx.sch'
             RUN l_cmd
             LET l_cnt=l_cnt+1
          END FOREACH
       ELSE
          LET l_cmd='echo "" >>$FGLDBPATH/',l_db CLIPPED,'_idx.sch'
          RUN l_cmd
       END IF
       LET l_cmd='chmod 777 $FGLDBPATH/',l_db CLIPPED,'_idx.sch'
       RUN l_cmd
    ELSE
       LET l_sql1="select count(1) ",
                 "  from user_indexes a,user_ind_columns b",
                 " where (lower(a.table_name) like '___file'",
                 "    or lower(a.table_name) like '____file'",
                 "    or lower(a.table_name) like '_____file'",
                 "    or lower(a.table_name) like 'aps%' )",
                 "   and a.index_name=b.index_name"
       LET l_sql="select distinct lower(a.index_name),",
                 "       substr(uniqueness,1,1),",
                 "       lower(column_name) column_name,",
                 "       lower(a.table_name), ",
                 "       b.column_position ",
                 "  from user_indexes a,user_ind_columns b",
                 " where (lower(a.table_name) like '___file'",
                 "    or lower(a.table_name) like '____file'",
                 "    or lower(a.table_name) like '_____file'",
                 "    or lower(a.table_name) like 'aps%' )",
                 "   and a.index_name=b.index_name",
                 " order by 1,5"
       DATABASE l_db
       IF sqlca.sqlcode THEN
          DISPLAY sqlca.sqlcode,"change DB error:",l_db
          RETURN
       END IF
       DECLARE ora_cur CURSOR FROM l_sql
         IF SQLCA.SQLCODE THEN
            DISPLAY sqlca.sqlcode,"declare cursor ora_cur error"
            RETURN
         END IF
       DECLARE ora_cnt_cur CURSOR FROM l_sql1
         IF SQLCA.SQLCODE THEN
            DISPLAY sqlca.sqlcode,"declare cursor ora_cnt_cur error"
            RETURN
         END IF
       OPEN ora_cnt_cur
         IF SQLCA.SQLCODE THEN
            DISPLAY sqlca.sqlcode,"open cursor ora_cnt_cur error"
            RETURN
         END IF
       fetch ora_cnt_cur into l_cnt
         IF SQLCA.SQLCODE THEN
            DISPLAY sqlca.sqlcode,"open cursor ora_cnt_cur error"
            RETURN
         END IF
       IF l_cnt>=1 THEN
          FOREACH ora_cur INTO l_idx_name,l_unique,l_column,l_tab_name
display l_idx_name,'',l_unique,'',l_column,'',l_tab_name
            IF SQLCA.SQLCODE THEN
               DISPLAY sqlca.sqlcode,"foreach error"
               RETURN
            END IF
            IF l_idx_name_bak is null THEN
               LET l_idx_name_bak=l_idx_name
               LET l_tab_name_bak=l_tab_name
               LET l_unique_bak=l_unique
               LET l_columns=l_column
            ELSE
               IF l_idx_name_bak != l_idx_name THEN
                  LET l_cmd='echo "',l_idx_name_bak CLIPPED,"^",
                                    l_unique_bak CLIPPED,"^",
                                    l_columns CLIPPED,"^",
                                    l_tab_name_bak CLIPPED,'^" >>$FGLDBPATH/',
                                    l_db CLIPPED,'_idx.sch'
                  RUN l_cmd
                  LET l_idx_name_bak=l_idx_name
                  LET l_tab_name_bak=l_tab_name
                  LET l_unique_bak=l_unique
                  LET l_columns=l_column
               ELSE
                  LET l_columns=l_columns CLIPPED,",",l_column
               END IF
            END IF
          END FOREACH
          LET l_cmd='echo "',l_idx_name CLIPPED,"^",
                            l_unique CLIPPED,"^",
                            l_columns CLIPPED,"^",
                            l_tab_name CLIPPED,'^" >>$FGLDBPATH/',
                            l_db CLIPPED,'_idx.sch'
          RUN l_cmd
       ELSE
          LET l_cmd='echo "">>$FGLDBPATH/',l_db CLIPPED,'_idx.sch'
          RUN l_cmd
       END IF
       LET l_cmd='chmod 777 $FGLDBPATH/',l_db CLIPPED,'_idx.sch'
       RUN l_cmd
    END IF
END MAIN
