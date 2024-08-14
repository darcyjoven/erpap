#Generating Primary Key of Tables

DATABASE  ds

MAIN
DEFINE g_dbs            VARCHAR(20) ,
       g_db_type        VARCHAR(3) ,
       l_filename       STRING,
   lv_index_owner       varchar(30),
   lv_index_name        varchar(30),
   lv_table_owner       varchar(30),
   lv_table_name        varchar(30),
   o_table_name        varchar(30),
   lv_uniqueness        varchar(9),
 #  lv_tablespace_name   varchar(30),
 #  lv_ini_trans         smallint,
 #  lv_max_trans         smallint,
 #  lv_initial_extent    smallint,
 #  lv_next_extent       smallint,
 #  lv_min_extents       smallint,
 #  lv_max_extents       smallint,
 #  lv_pct_increase      smallint,
 #  lv_pct_free          smallint,
   #lv_column_name       varchar2(4000),
   lv_column_name       VARCHAR(200),
   lv_columns           VARCHAR(200),
   lv_first_rec         VARCHAR(1),
   lv_first_unique      VARCHAR(1),
   lv_string            VARCHAR(800),
   lv_lineno            smallint
DEFINE   l_sql1         STRING
DEFINE   l_sql2         STRING
DEFINE   l_channel      base.Channel
DEFINE   i_own          VARCHAR(30)
DEFINE   c_ind          VARCHAR(30)
DEFINE   c_tab          VARCHAR(30)
DEFINE   table_buf      STRING
DEFINE   table_buf1      STRING
DEFINE   table_pos      SMALLINT

DEFINE   l_i           SMALLINT
DEFINE   l_part RECORD 
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
          END RECORD
DEFINE    l_part_arr ARRAY[16] of SMALLINT



WHENEVER ERROR CONTINUE  
LET g_dbs      = ARG_VAL(1)
LET l_filename = g_dbs CLIPPED ||'_pri.sql'

 
DISPLAY 'Creating primary key build script...'
DATABASE  g_dbs
LET g_db_type = DB_GET_DATABASE_TYPE()
IF g_db_type="IFX" THEN
       LET l_sql1="select idxname,tabname,idxtype, ",
                  "part1,part2,part3,",
                  " part4,part5,part6,part7,part8,part9,part10,",
                  " part11,part12,part13,part14,part15,part16",
                  " from  sysindexes i ,systables t ",
                  " where i.tabid = t.tabid",
                  " and tabname matches '*_file*' "
  
             DECLARE ifx_cur1 CURSOR FROM l_sql1

       LET l_sql2="SELECT colname FROM systables,syscolumns ",
                  " WHERE tabname= ? ",
                  "   AND systables.tabid=syscolumns.tabid ",
                  " AND colno = ?"
             DECLARE ifx_cur2 CURSOR FROM l_sql2
 


       LET o_table_name = ' '
       LET  l_channel = base.Channel.create()
       CALL l_channel.openFile(l_filename CLIPPED, "w")
       CALL l_channel.setDelimiter("")

       #LET lv_string = 'spool '||g_dbs CLIPPED||'_pri.lst' 
       CALL l_channel.write(lv_string)

       FOREACH ifx_cur1 INTO     lv_index_name,
                                 lv_table_name,
                                 lv_uniqueness,
                                 l_part.*  
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
       LET lv_lineno = 2
       LET lv_first_rec = TRUE


             #LET l_columns=''
       IF (lv_uniqueness = 'U')
          AND (lv_table_name != o_table_name) then 
          LET o_table_name = lv_table_name
          LET table_buf = lv_table_name
          LET table_pos = table_buf.getIndexOf('_file',1)
          LET table_buf = table_buf.SubString(1,table_pos - 1)
          LET table_buf = table_buf.toLowerCase()
         
          LET lv_string = 'DROP INDEX ' || lv_index_name ||';'
          DISPLAY lv_string
          CALL l_channel.write(lv_string)
          LET lv_lineno = lv_lineno + 1
          #LET lv_string = '/'
          LET lv_lineno = lv_lineno + 1

          #FOREACH col_cursor USING lv_index_owner,lv_index_name,lv_table_name INTO lv_column_name
             #DISPLAY lv_column_name
             #DISPLAY lv_first_rec
             IF (lv_first_rec) then
                 LET lv_string = 'ALTER TABLE ' || lv_table_name||' ADD CONSTRAINT PRIMARY KEY('
                 LET lv_first_rec = FALSE
             ELSE 
                 LET lv_string = lv_string || ','
             END IF 
                 LET lv_columns = NULL
             FOR l_i=1 TO 16
                 IF l_part_arr[l_i] IS NULL THEN EXIT FOR END IF
                 FOREACH ifx_cur2 USING lv_table_name,l_part_arr[l_i] INTO lv_column_name
                    IF sqlca.sqlcode THEN
                       DISPLAY sqlca.sqlcode,"foreach sysindexes error"
                       RETURN
                    END IF
                    #DISPLAY lv_column_name 
                    IF lv_columns IS NULL THEN
                       LET lv_columns=lv_column_name CLIPPED
                    ELSE
                       LET lv_columns=lv_columns CLIPPED,",",lv_column_name CLIPPED
                    END IF
                 END FOREACH
             END FOR
                 LET lv_string = lv_string || lv_columns

          #END FOREACH
          LET lv_string = lv_string CLIPPED || ') CONSTRAINT ' || table_buf CLIPPED || '_pk;'
          DISPLAY lv_string
          CALL l_channel.write(lv_string)
          LET lv_lineno = lv_lineno + 1 
          LET lv_string ='                                                  '
          CALL l_channel.write(lv_string)
       END IF 
          LET lv_lineno = lv_lineno + 1
       END FOREACH
          #LET lv_string = 'spool off'
          CALL l_channel.write(lv_string)
          CALL l_channel.close()

      #END IF 


ELSE
 
       LET l_sql1="select owner,index_name,table_owner,table_name,uniqueness",
                  " from  all_indexes ",
                  "where owner =UPPER('",g_dbs CLIPPED,"') " ,
                  "order by index_name"
       PREPARE ind_pre FROM l_sql1
       DECLARE ind_cursor CURSOR FOR ind_pre


       LET l_sql2="select lower(column_name) ",
                  "from all_ind_columns ", 
                  "where index_owner = ? ",
                  " and index_name =? ",
                  " and  table_name = ? ",
                  " order  by column_position "

       PREPARE col_pre FROM l_sql2
       DECLARE col_cursor CURSOR FOR col_pre

       LET o_table_name = ' '
       LET  l_channel = base.Channel.create()
       CALL l_channel.openFile(l_filename CLIPPED, "w")
       CALL l_channel.setDelimiter("")

       LET lv_string = 'spool '||g_dbs CLIPPED||'_pri.lst' 
       CALL l_channel.write(lv_string)
 
       FOREACH ind_cursor INTO   lv_index_owner,
                                 lv_index_name,
                                 lv_table_owner,
                                 lv_table_name,
                                 lv_uniqueness

         LET lv_lineno = 2
         LET lv_first_rec = TRUE
         #LET lv_first_unique = TRUE
    
       DISPLAY "o_table_name =  ",o_table_name, "lv_table_name =",lv_table_name
       IF (lv_uniqueness = 'UNIQUE') #AND (lv_first_unique = TRUE) 
          AND (lv_table_name != o_table_name) 
          AND (lv_index_name NOT MATCHES '*_PK') then 
          LET o_table_name = lv_table_name
          LET table_buf = lv_table_name
          LET table_pos = table_buf.getIndexOf('_FILE',1)
          LET table_buf = table_buf.SubString(1,table_pos - 1)
	  
	  IF table_buf IS NULL THEN
	     LET table_buf = lv_index_name
             LET table_pos = table_buf.getIndexOf('_',1)
             LET table_buf = table_buf.SubString(1,table_pos -1)
	  END IF
	  
          LET table_buf = table_buf.toLowerCase()
         
          LET lv_string = 'DROP INDEX ' || lv_index_name
          CALL l_channel.write(lv_string)
          LET lv_lineno = lv_lineno + 1
          LET lv_string = '/'
          CALL l_channel.write(lv_string)
          LET lv_lineno = lv_lineno + 1

          FOREACH col_cursor USING lv_index_owner,lv_index_name,lv_table_name INTO lv_column_name
             DISPLAY lv_column_name
             DISPLAY lv_first_rec
             IF (lv_first_rec) then
                 #LET lv_string = 'ALTER TABLE ' || lv_table_name||' ADD(constraint '||lv_table_name||'_pk'
                 LET lv_string = 'ALTER TABLE ' || lv_table_name||' ADD(constraint '||table_buf||'_pk'
                 LET lv_string = lv_string || ' primary key('
                 LET lv_first_rec = FALSE
             ELSE 
                 LET lv_string = lv_string || ','
             END IF 
                 LET lv_string = lv_string || lv_column_name

          END FOREACH
          LET lv_string = lv_string || '))'
          CALL l_channel.write(lv_string)

          LET lv_lineno = lv_lineno + 1
          LET lv_string = '/'
          CALL l_channel.write(lv_string)
          LET lv_lineno = lv_lineno + 1 
          LET lv_lineno = lv_lineno + 1 
          LET lv_string ='                                                  '
          CALL l_channel.write(lv_string)
       END IF 
          LET lv_lineno = lv_lineno + 1
       END FOREACH
          LET lv_string = 'spool off'
          CALL l_channel.write(lv_string)
          CALL l_channel.close()
END IF

END MAIN
