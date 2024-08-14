database ds 


MAIN
  DEFINE db_name CHAR(18)
  DEFINE l_sql CHAR(1000)
  LET db_name  = ARG_VAL(1)
  IF db_name[1] = ' ' OR db_name IS  NULL  THEN 
     ERROR "Please enter Database Name !!( EX: clr_shma ds ) "
     EXIT PROGRAM
  END IF 

# UPDATE systables  Table Owner

LET l_sql = "UPDATE  ",db_name,":systables SET owner = 'tiptop'",
            "  WHERE tabname matches '*_file'"

PREPARE pre1 FROM l_sql
IF STATUS THEN
   ERROR "Error no:1"
ELSE
   ERROR " update systables !!" 
END IF
EXECUTE pre1

# UPDATE sysindexes  index  Owneraa
LET l_sql = "SELECT *  FROM ",db_name,":sysindexes INTO TEMP sss_tmp"
PREPARE pre2 FROM l_sql
IF STATUS THEN
   ERROR "Error no:2"
END IF
EXECUTE pre2

LET l_sql = " UPDATE ",db_name,":sysindexes   SET owner = 'tiptop'",
  "where tabid IN ( SELECT unique a.tabid from sss_tmp a,",db_name,
       ":systables b ",
       "WHERE b.tabname matches  '*_file' AND ",
       " a.tabid = b.tabid) "

PREPARE pre3 FROM l_sql
IF STATUS THEN
   ERROR "Error no:3"
END IF
EXECUTE pre3

# UPDATE systabauth
LET l_sql = " DROP  TABLE sss_tmp "
PREPARE pre4 FROM l_sql
IF STATUS THEN
   ERROR "Error no:4"
END IF
EXECUTE pre4
 
LET l_sql =" SELECT * FROM ",db_name,":systabauth  INTO TEMP sss_tmp"
PREPARE pre41 FROM l_sql
IF STATUS THEN
   ERROR "Error no:41"
END IF
EXECUTE pre41

LET l_sql="UPDATE ",db_name,":systabauth  SET grantor = 'tiptop'",
      " WHERE tabid IN (SELECT UNIQUE a.tabid FROM sss_tmp a,",db_name,
      ":systables b",
      " WHERE a.tabid = b.tabid AND ",
         " b.tabname MATCHES '*_file' )"
PREPARE pre5 FROM l_sql
IF STATUS THEN
   ERROR "Error no:5"
END IF
EXECUTE pre5

# UPDATE syssyntable
LET l_sql = "UPDATE  ",db_name,":syssyntable SET owner = 'tiptop'",
            " WHERE tabname MATCHES '*_file' "
PREPARE pre6 FROM l_sql
IF STATUS THEN
   ERROR "Error no:6"
END IF
EXECUTE pre6

# UPDATE sysconstraints
LET l_sql = "DROP TABLE  sss_tmp"
PREPARE pre7 FROM l_sql
IF STATUS THEN
   ERROR "Error no:7"
END IF
EXECUTE pre7

LET l_sql= "SELECT *  FROM ",db_name,":sysconstraints INTO TEMP sss_tmp"
PREPARE pre71 FROM l_sql
IF STATUS THEN
   ERROR "Error no:71"
END IF
EXECUTE pre71

LET l_sql = "UPDATE ",db_name,":sysconstraints SET owner = 'tiptop'",
     " where tabid IN ( SELECT a.tabid FROM sss_tmp a,",db_name,
         ":systables b",
         " WHERE a.tabid = b.tabid AND ",
         "  b.tabname MATCHES '*_file' ) "
PREPARE pre8 FROM l_sql
IF STATUS THEN
   ERROR "Error no:8"
END IF
EXECUTE pre8


# UPDATE sysprocauth
LET l_sql = "DROP TABLE  sss_tmp"
PREPARE pre9 FROM l_sql
IF STATUS THEN
   ERROR "Error no:9"
END IF
EXECUTE pre9

LET  l_sql= "SELECT *  FROM ",db_name,":sysprocauth INTO TEMP sss_tmp"
PREPARE pre91 FROM l_sql
IF STATUS THEN
   ERROR "Error no:91"
END IF
EXECUTE pre91


LET l_sql = "UPDATE ",db_name,":sysprocauth SET grantor = 'tiptop'",
    " WHERE procid IN ( SELECT a.procid FROM sss_tmp a,",db_name,
        ":sysprocedures b",
        " WHERE a.procid = b.procid AND ",
        "     b.owner != 'informix' )"
PREPARE pre10 FROM l_sql
IF STATUS THEN
   ERROR "Error no:10"
END IF
EXECUTE pre10

# UPDATE sysprocedures
LET l_sql = "UPDATE ",db_name,":sysprocedures SET owner = 'tiptop'",
     " WHERE owner != 'informix'"
PREPARE pre11 FROM l_sql
IF STATUS THEN
   ERROR "Error no:11"
END IF
EXECUTE pre11

# UPDATE systriggers
LET l_Sql = "UPDATE ",db_name,":systriggers SET owner = 'tiptop'",
     " WHERE owner != 'informix'"
PREPARE pre12 FROM l_sql
IF STATUS THEN
   ERROR "Error no:12"
END IF
EXECUTE pre12

# UPDATE sysobjstate
LET l_sql = "DROP TABLE  sss_tmp"
PREPARE pre13 FROM l_sql
IF STATUS THEN
   ERROR "Error no:13"
END IF
EXECUTE pre13

LET l_sql =  "SELECT *  FROM ",db_name,":sysobjstate INTO TEMP sss_tmp"

PREPARE pre131 FROM l_sql
IF STATUS THEN
   ERROR "Error no:131"
END IF
EXECUTE pre131

LET l_sql = "UPDATE ",db_name,":sysobjstate  SET owner = 'tiptop'",
      " WHERE tabid IN ( SELECT  a.tabid FROM sss_tmp a,",db_name,
       ":systables b ",
       " WHERE a.tabid = b.tabid AND ",
       "  b.tabname MATCHES '*_file' ) "

PREPARE pre14 FROM l_sql
IF STATUS THEN
   ERROR "Error no:14"
END IF
EXECUTE pre14

#  更新 user 將多餘的 user  從 sysusers 中刪除

LET l_sql = "DROP TABLE  sss_tmp "
PREPARE pre15 FROM l_sql
IF STATUS THEN
   ERROR "Error no:15"
END IF
EXECUTE pre15

LET l_sql = "DELETE FROM ",db_name,":sysusers ",
            "  WHERE  username != 'tiptop'   AND ",
            "         username != 'top40'    AND ",
            "         username != 'topgui'   AND ",
            "         username != 'informix' AND ",
            "         username != 'public'       "

PREPARE pre151 FROM l_sql
IF STATUS THEN
   ERROR "Error no:151"
END IF
EXECUTE pre151
# grant  DBA

LET l_sql = "UPDATE ",db_name,":sysusers SET usertype ='D' ",
      "WHERE username = 'tiptop'   AND ",
      "      username = 'informix' AND ",
      "      username = 'topgui'   AND ",
      "      username = 'top40'        "

PREPARE pre16 FROM l_sql
IF STATUS THEN
   ERROR "Error no:16"
END IF
EXECUTE pre16

# grant all to Create/Alter/Drop Owner table and Owner index privilege

LET l_sql = "UPDATE ",db_name,":sysusers SET usertype ='R'",
             " WHERE username = 'public' "
PREPARE pre17 FROM l_sql
IF STATUS THEN
   ERROR "Error no:17"
END IF
EXECUTE pre17

 END MAIN 
