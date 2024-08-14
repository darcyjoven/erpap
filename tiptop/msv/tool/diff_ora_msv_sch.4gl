# Prog. Version..: '5.10.07-09.04.23(00000)'     #
#
# Pattern name...: diffsch.4gl
# Descriptions...: topo與topm ds.sch比對 請把 ds.sch 路徑設好

IMPORT os
DATABASE ds
  DEFINE ga_source DYNAMIC ARRAY OF RECORD
            table  VARCHAR(20),
            field  VARCHAR(15),
            type   VARCHAR(20),
            length SMALLINT,
            serial SMALLINT,
            notnul SMALLINT
                 END RECORD
  DEFINE ga_dist DYNAMIC ARRAY OF RECORD
            table  VARCHAR(20),
            field  VARCHAR(15),
            type   VARCHAR(20),
            length SMALLINT,
            serial SMALLINT,
            notnul SMALLINT
                 END RECORD
  DEFINE ga_temp DYNAMIC ARRAY OF RECORD
            table  VARCHAR(20),
            field  VARCHAR(15),
            type   VARCHAR(20),
            length SMALLINT,
            serial SMALLINT,
            notnul SMALLINT
                 END RECORD                 
  DEFINE g_source,g_dist   STRING
  
 

MAIN
   DEFINE l_dbs     STRING  
   DEFINE lc_type   VARCHAR(1)
  
   LET l_dbs = ARG_VAL(1)
   LET lc_type = ARG_VAL(2)  #When "o" Then Check Order Only

   IF lc_type = "r" THEN
      LET g_source = FGL_GETENV("TOP"),"\\schemam\\",l_dbs ,".sch"
      LET g_dist   = FGL_GETENV("TOP"),"\\schema\\",l_dbs ,".sch"
   ELSE
      LET g_source = FGL_GETENV("TOP"),"\\schema\\",l_dbs ,".sch"
      LET g_dist   = FGL_GETENV("TOP"),"\\schemam\\",l_dbs ,".sch"
   END IF

   CALL loadsch_read(g_source)
   CALL loadsch_d2s()
   CALL ga_dist.clear()
   CALL loadsch_read(g_dist)

   CALL loadsch_compare()

END MAIN

FUNCTION build_dynamic_table(p_table)
DEFINE p_table  VARCHAR(20),       
       li_i     INTEGER,
       li_s     INTEGER,
       l_zta01  LIKE zta_file.zta01
   
    
   LET li_s = 1   
   CALL ga_temp.clear()      
   FOR li_i = 1 TO ga_dist.getLength()
       IF p_table = ga_dist[li_i].table THEN       	  
       	  LET ga_temp[li_s].table  = ga_dist[li_i].table 
          LET ga_temp[li_s].field  = ga_dist[li_i].field 
          LET ga_temp[li_s].type   = ga_dist[li_i].type  
          LET ga_temp[li_s].length = ga_dist[li_i].length
          LET ga_temp[li_s].serial = ga_dist[li_i].serial
          LET ga_temp[li_s].notnul = ga_dist[li_i].notnul
          LET li_s = li_s + 1
       END IF
   END FOR
   #CALL g_wsv1.deleteElement(li_i)
   
   IF ga_temp.getLength() > 0 THEN
   	  RETURN "Y" 
   ELSE 
   		RETURN "N" #new table
   END IF
   
   #SELECT count(*) INTO l_cnt FROM  zta_file WHERE zta01=l_zta01 and zta02='ds'
   #IF l_cnt = 0 THEN 
   #   DISPLAY "p_zta not found",l_zta01
   #END IF
   
END FUNCTION
   
FUNCTION loadsch_read(ls_path)

   DEFINE li_cnt  INTEGER
   DEFINE ls_path  STRING
   DEFINE lc_channel    base.Channel
   DEFINE ls_readstr,ls_temp    STRING
   DEFINE li_x1,li_x2,li_x3,li_x4    SMALLINT
  
   LET li_cnt = 1
   display "File=",ls_path
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ls_path.trim(), "r")
   CALL lc_channel.setDelimiter("")
   WHILE lc_channel.read(ls_readstr)
      LET li_x3 = 0
      WHILE TRUE
         LET li_x3 = li_x3 + 1
         LET li_x4 = FALSE
         IF ls_readstr.getIndexOf("^",1) THEN
            LET li_x1 = ls_readstr.getIndexOf("^",1)
            LET ls_temp = ls_readstr.subString(1,li_x1 - 1)
            LET ls_readstr = ls_readstr.subString(li_x1+1,ls_readstr.getLength())
         ELSE
            LET ls_temp = ls_readstr.trim()
            LET li_x4 = TRUE
         END IF
         CASE li_x3
            WHEN 1 LET ga_dist[li_cnt].table = ls_temp
            WHEN 2 LET ga_dist[li_cnt].field = ls_temp
            WHEN 3 LET li_x1 = ls_temp.trim()
               LET ga_dist[li_cnt].notnul = FALSE #default
               CASE li_x1
                  WHEN 0   LET ga_dist[li_cnt].type = "NCHAR"
                  WHEN 1   LET ga_dist[li_cnt].type = "SMALLINT"
                  WHEN 2   LET ga_dist[li_cnt].type = "INTEGER"
                  WHEN 3   LET ga_dist[li_cnt].type = "FLOAT"
                  WHEN 4   LET ga_dist[li_cnt].type = "SMALLFLOAT"
                  WHEN 5   LET ga_dist[li_cnt].type = "DECIMAL"
                  WHEN 6   LET ga_dist[li_cnt].type = "SERIAL"
                  WHEN 7   LET ga_dist[li_cnt].type = "DATE"                  
                  WHEN 10  LET ga_dist[li_cnt].type = "DATE" ##sql 2005 is datetime
                  WHEN 11  LET ga_dist[li_cnt].type = "IMAGE"
                  WHEN 13  LET ga_dist[li_cnt].type = "NVARCHAR"
                  WHEN 15  LET ga_dist[li_cnt].type = "NCHAR"
                  WHEN 16  LET ga_dist[li_cnt].type = "NVARCHAR"
                  WHEN 52  LET ga_dist[li_cnt].type = "DECIMAL"  ## oralce is number(20)
                  	       LET ga_dist[li_cnt].length = 5120 
                  	       EXIT WHILE
                  WHEN 308 LET ga_dist[li_cnt].type = "DECIMAL"  ## oralce is number(20)
                  	       LET ga_dist[li_cnt].length = 5120 
                  	       LET ga_dist[li_cnt].notnul = TRUE
                  	       EXIT WHILE
                  WHEN 61  LET ga_dist[li_cnt].type = "NUMBER"
                  WHEN 201 LET ga_dist[li_cnt].type = "NVARCHAR"
                  WHEN 257 LET ga_dist[li_cnt].type = "SMALLINT"
                           LET ga_dist[li_cnt].notnul = TRUE
                  WHEN 258 LET ga_dist[li_cnt].type = "INTEGER"
                           LET ga_dist[li_cnt].notnul = TRUE
                  WHEN 261 LET ga_dist[li_cnt].type = "DECIMAL"
                           LET ga_dist[li_cnt].notnul = TRUE
                  WHEN 263 LET ga_dist[li_cnt].type = "DATE"
                           LET ga_dist[li_cnt].notnul = TRUE
                  WHEN 266 LET ga_dist[li_cnt].type = "DATE"  ##sql 2005 is datetime
                           LET ga_dist[li_cnt].notnul = TRUE                           
                  WHEN 457 LET ga_dist[li_cnt].type = "NVARCHAR"
                           LET ga_dist[li_cnt].notnul = TRUE
#                 OTHERWISE LET ga_dist[li_cnt].type = ls_temp
                END CASE
            WHEN 4 LET ga_dist[li_cnt].length = ls_temp
            WHEN 5 LET ga_dist[li_cnt].serial = ls_temp
         END CASE
         IF li_x4 THEN EXIT WHILE END IF
      END WHILE
      LET li_cnt = li_cnt + 1
   END WHILE

END FUNCTION

FUNCTION loadsch_d2s()

    DEFINE li_cnt   INTEGER

    CALL ga_source.clear()
    FOR li_cnt = 1 TO ga_dist.getLength()	    
	   IF ga_dist[li_cnt].table[1,2]="tt" AND ga_dist[li_cnt].table[4]<>"_" THEN
	      CONTINUE FOR
	   END IF
	   IF ga_dist[li_cnt].table[1,3]="tc_" OR ga_dist[li_cnt].table="syscolumns_file" THEN
	      CONTINUE FOR
	   END IF
       LET ga_source[li_cnt].table  = ga_dist[li_cnt].table 
       LET ga_source[li_cnt].field  = ga_dist[li_cnt].field 
       LET ga_source[li_cnt].type   = ga_dist[li_cnt].type  
       LET ga_source[li_cnt].length = ga_dist[li_cnt].length
       LET ga_source[li_cnt].serial = ga_dist[li_cnt].serial
       LET ga_source[li_cnt].notnul = ga_dist[li_cnt].notnul
    END FOR

END FUNCTION


FUNCTION loadsch_compare()
    DEFINE li_cnt   INTEGER
    DEFINE li_max   INTEGER
    DEFINE li_x1    INTEGER
    DEFINE li_x2    INTEGER
    DEFINE lc_chr1  CHAR(1)
    DEFINE ls_type  CHAR(1)
    DEFINE ls_temp  STRING    
    DEFINE ls_str   STRING    
    DEFINE l_temp_table STRING

    LET l_temp_table = "x"
    LET li_max = ga_source.getLength()
    FOR li_cnt = 1 TO li_max
       LET lc_chr1 = "U"   #unknow
       
       IF l_temp_table <> ga_source[li_cnt].table THEN   #one-time table build       	 
          LET ls_type = build_dynamic_table(ga_source[li_cnt].table)
          LET l_temp_table = ga_source[li_cnt].table          
       END IF
       
       IF ls_type = "Y" THEN 
          FOR li_x1 = 1 TO ga_temp.getLength()
             IF ga_source[li_cnt].table <> ga_temp[li_x1].table THEN          	 
                CONTINUE FOR
             END IF
             IF ga_source[li_cnt].field <> ga_temp[li_x1].field THEN
                CONTINUE FOR
             END IF
             LET lc_chr1 = "B"   #both
             IF ga_source[li_cnt].type <> ga_temp[li_x1].type  OR
                ga_source[li_cnt].length <> ga_temp[li_x1].length OR
                ga_source[li_cnt].notnul <> ga_temp[li_x1].notnul THEN
                CASE ga_source[li_cnt].type 
                   WHEN "DATE"
                      LET ls_temp = "alter table ",ga_source[li_cnt].table," alter column ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                   WHEN "INTEGER"
                      LET ls_temp = "alter table ",ga_source[li_cnt].table," alter column ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                   WHEN "SMALLINT" 
                      LET ls_temp = "alter table ",ga_source[li_cnt].table," alter column ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                   WHEN "DECIMAL" 
                      LET li_x2 = ga_source[li_cnt].length / 256
                      LET ls_str = ga_source[li_cnt].length MOD 256 
                      LET ls_temp = "alter table ",ga_source[li_cnt].table," alter column ",ga_source[li_cnt].field," ",ga_source[li_cnt].type,"(",
                                     li_x2 USING "<<<",",", ls_str CLIPPED,")"
                   OTHERWISE 
                      LET ls_temp = "alter table ",ga_source[li_cnt].table," alter column ",ga_source[li_cnt].field," ",ga_source[li_cnt].type,"(",ga_source[li_cnt].length USING "<<<<<" CLIPPED,")"
                END CASE
                IF ga_source[li_cnt].notnul THEN
                   LET ls_temp = ls_temp," NOT NULL"
                END IF
                EXIT FOR
             END IF  
          END FOR
          
          IF lc_chr1 = "U"  {source has}  THEN 
             CASE ga_source[li_cnt].type 
                WHEN "DATE"
                   LET ls_temp = "alter table ",ga_source[li_cnt].table," add ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                WHEN "INTEGER"
                   LET ls_temp = "alter table ",ga_source[li_cnt].table," add ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                WHEN "SMALLINT" 
                   LET ls_temp = "alter table ",ga_source[li_cnt].table," add ",ga_source[li_cnt].field," ",ga_source[li_cnt].type
                WHEN "DECIMAL" 
                   LET li_x2 = ga_source[li_cnt].length / 256
                   LET ls_str = ga_source[li_cnt].length MOD 256 
                   LET ls_temp = "alter table ",ga_source[li_cnt].table," add ",ga_source[li_cnt].field," ",ga_source[li_cnt].type,"(",
                                  li_x2 USING "<<<",",", ls_str  CLIPPED,")"
                OTHERWISE 
                   LET ls_temp = "alter table ",ga_source[li_cnt].table," add ",ga_source[li_cnt].field," ",ga_source[li_cnt].type,"(",ga_source[li_cnt].length USING "<<<<<" CLIPPED,")"
             END CASE
             IF ga_source[li_cnt].notnul THEN
             	  CASE ga_source[li_cnt].type 
             	  	 WHEN "NVARCHAR"
             	  	    LET ls_temp = ls_temp," NOT NULL DEFAULT '' "
             	  	 WHEN "DECIMAL" 
             	  		  LET ls_temp = ls_temp," NOT NULL DEFAULT '0' "
             	     OTHERWISE 
                      LET ls_temp = ls_temp," NOT NULL"
                END CASE                
             END IF
           END IF
           IF ls_temp is not null THEN 
              DISPLAY  ls_temp,";" 
              LET ls_temp = "" 
           END IF
        ELSE #create table
           IF ls_type = "N" THEN        
              IF ga_source[li_cnt].table = ga_source[li_cnt+1].table THEN #是否same table        		 	         		 	
        	 LET ls_temp= ls_temp, check_fld_type(li_cnt) , ",\n"
              ELSE #output table schema
        	 LET ls_temp= ls_temp, check_fld_type(li_cnt)
        	 LET ls_temp = "create table ",ga_source[li_cnt].table ," ( \n", ls_temp ," )"
        	 DISPLAY ""
        	 DISPLAY ls_temp
        	 LET ls_temp = ""
              END IF 
           END IF 
       END IF
    END FOR
END FUNCTION

FUNCTION check_fld_type(p_cnt) 
DEFINE p_cnt    INTEGER
DEFINE li_x2    INTEGER    
DEFINE ls_str   STRING
DEFINE ls_fld   STRING
    
   CASE ga_source[p_cnt].type
   	 
     WHEN "DATE"
        LET ls_fld = ga_source[p_cnt].field," ",ga_source[p_cnt].type
     WHEN "INTEGER"
        LET ls_fld = ga_source[p_cnt].field," ",ga_source[p_cnt].type
     WHEN "SMALLINT" 
        LET ls_fld = ga_source[p_cnt].field," ",ga_source[p_cnt].type
     WHEN "DECIMAL" 
        LET li_x2 = ga_source[p_cnt].length / 256
        LET ls_str = ga_source[p_cnt].length MOD 256 
        LET ls_fld = ga_source[p_cnt].field," ",ga_source[p_cnt].type,"(",
                       li_x2 USING "<<<",",", ls_str  CLIPPED,")"
     OTHERWISE 
        LET ls_fld = ga_source[p_cnt].field," ",ga_source[p_cnt].type,"(",ga_source[p_cnt].length USING "<<<<<" CLIPPED,")"
   END CASE
   IF ga_source[p_cnt].notnul THEN      
   	  IF ga_source[p_cnt].type = "DECIMAL" THEN 
   	  	 LET ls_fld = ls_fld," NOT NULL default '0' "      
   	  ELSE
         LET ls_fld = ls_fld," NOT NULL"      
      END IF
   END IF
   RETURN ls_fld
END FUNCTION
