##################################################
# Description  	: diffdb 比對兩個DB的SCHEMA OR INDEX
# Date & Author : 2004/12/14 by qazzaq
# Parameter   	: 
# Return   	: 
# Memo        	:
# Modify   	: No:FUN-7A0028 07/10/18 By Echo 功能調整:1.可直接指定schema、Index檔案路徑
#               :                                         2.選擇是否產生 table name 說明
# Modify   	: No:FUN-820073 08/03/06 By alexstar 不加null
# Modify        : No:FUN-830034 08/04/16 By saki 增加變數長度
##################################################
DATABASE ds

DEFINE   g_db_type       CHAR(3)
DEFINE   g_std_db        CHAR(255)       #No:FUN-830034
DEFINE   g_tag_db        CHAR(255)       #No:FUN-830034
DEFINE   g_std           CHAR(255)       #No:FUN-830034
DEFINE   g_tag           CHAR(255)       #No:FUN-830034
DEFINE   g_type          CHAR(1)
DEFINE   g_pid           STRING
DEFINE   g_isds          CHAR(1)
DEFINE   g_check         CHAR(1)                              ##FUN-7A0028
MAIN
   DEFINE   p_date        CHAR(8)
   DEFINE   l_result      SMALLINT
   DEFINE   l_result_idx  SMALLINT
   DEFINE   l_top         CHAR(30)
   DEFINE   l_dbpath      CHAR(255)      #No:FUN-830034
   DEFINE   l_cmd         STRING


   WHENEVER ERROR CONTINUE

   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET g_std_db = ARG_VAL(1)
   LET g_tag_db = ARG_VAL(2)
   LET g_type = ARG_VAL(3)
   LET g_pid= FGL_GETPID()
   CASE g_type
        WHEN 1 
             LET g_check  = ARG_VAL(4)                           #FUN-7A0028
             CALL diffdb_tab_schema_withdb()
             CALL diffdb_idx_schema_withdb()
        WHEN 2
             LET g_check  = ARG_VAL(4)                           #FUN-7A0028
             CALL diffdb_tab_schema_withdb()
        WHEN 3
             CALL diffdb_idx_schema_withdb()
        WHEN 4
             LET g_std    = ARG_VAL(6)
             LET g_tag    = ARG_VAL(7)
             LET g_check  = ARG_VAL(8)                           #FUN-7A0028
             CALL diffdb_tab_schema_withfile()
             LET g_std_db = ARG_VAL(4)
             LET g_tag_db = ARG_VAL(5)
             CALL diffdb_idx_schema_withfile()
        WHEN 5
             LET g_std    = ARG_VAL(4)
             LET g_tag    = ARG_VAL(5)
             LET g_check  = ARG_VAL(6)                           #FUN-7A0028
             LET g_isds   = ARG_VAL(7)
             IF g_isds is null THEN
                LET g_isds=0
             END IF
             CALL diffdb_tab_schema_withfile()
        WHEN 6
             LET g_std    = ARG_VAL(4)
             LET g_tag    = ARG_VAL(5)
             CALL diffdb_idx_schema_withfile()
   END CASE
END MAIN

FUNCTION diffdb_tab_schema_withdb()
DEFINE readfile_channel   base.channel,
       l_str              String,
       l_right            char(1),
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_command_max      integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       l_command   dynamic array of record
                   tabname char(20),
                   fldname char(15),
                   oldtype char(30),
                   newtype char(30),
                   action  char(25),
                   gaq03   char(100),
                   command string
                   end record,
       l_std       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   check  char(1)
                   end record,
       l_cus       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   check  char(1)
                   end record
DEFINE tok     base.StringTokenizer,
       tabn    base.StringTokenizer,
       l_run_command String


    IF g_db_type="IFX" THEN
       LET l_str="cd $FGLDBPATH;fgldbsch -db ",g_std_db CLIPPED," -ie"
       RUN l_str
       LET l_str="cd $FGLDBPATH;fgldbsch -db ",g_tag_db CLIPPED," -ie"
       RUN l_str
    ELSE
       LET l_str="cd $FGLDBPATH;fgldbsch -db ",g_std_db CLIPPED," -ow ",g_std_db CLIPPED," -ie"
       RUN l_str
       LET l_str="cd $FGLDBPATH;fgldbsch -db ",g_tag_db CLIPPED," -ow ",g_tag_db CLIPPED," -ie"
       RUN l_str
    END IF
    LET l_str="cd $FGLDBPATH;diff ",g_tag_db CLIPPED,".sch ",g_std_db CLIPPED,".sch >$TEMPDIR/diffdb.out.",g_pid CLIPPED,";chmod 777 $TEMPDIR/diffdb.out.",g_pid CLIPPED
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_cus[l_i].tabname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_cus[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
#display l_cus[l_i].tabname CLIPPED," _>2"
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
#                              FOR x=1 TO 5
#                                  IF l_tabn_chk.a[x,x] matches "[0123456789]" THEN
#display l_cus[l_i].tabname CLIPPED," name error"
#                                     LET l_right='N'
#                                     CONTINUE WHILE
#                                  END IF
#                              END FOR
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='< aps' THEN
#display l_cus[l_i].tabname CLIPPED," not _file or aps"
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_cus[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_cus[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].tabname)
                      LET l_cus[l_i].tabname=l_cus[l_i].tabname[3,l_k]    
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
#已到一個穩定度,暫時拿掉
#    ELSE
#       display l_cus[1].tabname,l_cus[1].fldname,l_cus[1].type,l_cus[1].length,l_cus[1].serial
#       display l_cus[l_cus_max].tabname,l_cus[l_cus_max].fldname,l_cus[l_cus_max].type,l_cus[l_cus_max].length,l_cus[l_cus_max].serial
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_std[l_i].tabname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_std[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
#display l_std[l_i].tabname CLIPPED," _>2"
                      LET l_right='N'
#                      CONTINUE WHILE 
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
#                              FOR x=1 TO 5
#                                  IF l_tabn_chk.a[x,x] matches "[0123456789]" THEN
#display l_std[l_i].tabname CLIPPED," name error"
#                                     LET l_right='N'
#                                     CONTINUE WHILE
#                                  END IF
#                              END FOR
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='> aps' THEN
#display l_std[l_i].tabname CLIPPED," not _file or aps"
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_std[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_std[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].tabname)
                      LET l_std[l_i].tabname=l_std[l_i].tabname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()
    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
#已到一個穩定度,暫時拿掉
#    ELSE
#       display l_std[l_std_max].tabname,l_std[l_std_max].fldname,l_std[l_std_max].type,l_std[l_std_max].length,l_std[l_std_max].serial
    END IF

    LET l_k=1 #紀錄command數目
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].fldname=l_cus[l_j].fldname AND 
               l_std[l_i].tabname=l_cus[l_j].tabname THEN
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].type=l_cus[l_j].type THEN
                  IF l_std[l_i].type='7' OR l_std[l_i].type='11' OR
                     l_std[l_i].type='1' OR l_std[l_i].type='2' THEN
                     CONTINUE FOR
                  ELSE
                     IF l_std[l_i].length=l_cus[l_j].length THEN
                        CONTINUE FOR
                     ELSE
                        #FUN-7A0028
                        CASE l_std[l_i].type
                            WHEN 0 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 1 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 2 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 5 
                                 LET x=l_std[l_i].length/256
                                 LET l_str=x
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                 END IF
                                 LET l_str=l_std[l_i].length mod 256
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 7
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                 LET l_k=l_k+1
                            WHEN 11
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 13
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 201 --非informix db的varchar型態專用
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01= l_std[l_i].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                 LET l_k=l_k+1
                            OTHERWISE
                                 LET x=l_std[l_i].type-256
                                 CASE x
                                     WHEN 0 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 1 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 2 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 5 
                                          LET x=l_std[l_i].length/256
                                          LET l_str=x
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                          END IF
                                          LET l_str=l_std[l_i].length mod 256
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 7
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 11
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 13
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 201 --非informix db的varchar型態專用
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01= l_std[l_i].fldname
                                             AND gaq02='0'
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                          LET l_k=l_k+1
                                 END CASE
                        END CASE
                     END IF
                  END IF
               ELSE
                  CASE l_std[l_i].type
                      WHEN 0
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 1
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'   #FUN-820073 
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 2 
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'   #FUN-820073  
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 5 
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           LET x=l_std[l_i].length/256
                           LET l_str=x
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                           ELSE
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 7
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'   #FUN-820073 
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 11
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'   #FUN-820073 
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 13
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'   #FUN-820073 
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 201 --非informix db的varchar型態專用
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01= l_std[l_i].fldname
                              AND gaq02='0'
                           IF l_cus[l_j].type < 202 THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                             #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'   #FUN-820073 
                           END IF
                           LET l_k=l_k+1
                      OTHERWISE
                           LET x=l_std[l_i].type-256
                           IF l_cus[l_j].type < 202 THEN
                              CASE x
                                  WHEN 0 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 7
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       LET l_k=l_k+1
                                  WHEN 11
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 201 --非informix db的varchar型態專用
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                       LET l_k=l_k+1
                              END CASE
                           ELSE
                              CASE x
                                  WHEN 0 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 7
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 11
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 201 --非informix db的varchar型態專用
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01= l_std[l_i].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                       LET l_k=l_k+1
                              END CASE
                           END IF
                  END CASE
               END IF
            END IF
        END FOR
    END FOR
    LET l_loop='N' 
    FOR l_i=1 TO l_std_max
        IF l_std[l_i].check='N' THEN
           LET l_std[l_i].check='Y'
           IF l_std[l_i].serial=1 THEN
              IF l_loop='Y' THEN
                LET l_command[l_k].tabname=l_tabname CLIPPED
                LET l_command[l_k].fldname=""
                LET l_command[l_k].oldtype=""
                LET l_command[l_k].newtype=""
                SELECT gat03 INTO l_command[l_k].gaq03
                  FROM gat_file
                 WHERE gat01=l_std[l_i].tabname 
                   AND gat02='0'
                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,ASCII 10,')'
                 LET l_k=l_k+1
                 LET l_loop='N'
              END IF
              LET l_loop='Y'
              LET l_tabname=l_std[l_i].tabname
              #FUN-7A0028
              CASE l_std[l_i].type
                  WHEN 0 
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(', ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                  WHEN 1 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5)'
                       END IF
                  WHEN 2 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10)'
                       END IF
                  WHEN 5 
                       LET x=l_std[l_i].length/256
                       LET l_str=x
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                       END IF
                       LET l_str=l_std[l_i].length mod 256
                       LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,')'
                  WHEN 7
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date'
                  WHEN 11
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob'
                       END IF
                  WHEN 13
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                       END IF
                  WHEN 201 --非informix db的varchar型態專用
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                  OTHERWISE
                       LET x=l_std[l_i].type-256
                       CASE x
                           WHEN 0 
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                           WHEN 1
                                IF g_db_type='IFX' THEN 
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5) not null'
                                END IF
                           WHEN 2 
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                END IF
                           WHEN 5 
                                LET x=l_std[l_i].length/256
                                LET l_str=x
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                END IF
                                LET l_str=l_std[l_i].length mod 256
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null'
                           WHEN 7
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date not null'
                           WHEN 11
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob not null'
                                END IF
                           WHEN 13
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                END IF
                           WHEN 201 --非informix db的varchar型態專用
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                       END CASE
              END CASE
           ELSE
              IF l_loop='Y' THEN
                 IF l_tabname=l_std[l_i].tabname THEN
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                        WHEN 1
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' smallint'
                             ELSE                                                             
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' number(5)'
                             END IF
                        WHEN 2
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer'
                             ELSE                                                             
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10)'
                             END IF                                                           
                        WHEN 5                                                                
                             LET x=l_std[l_i].length/256                                      
                             LET l_str=x                                                      
                             IF g_db_type='IFX' THEN                                          
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE                                                             
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,')'
                        WHEN 7                                                             
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date'
                        WHEN 11
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' byte'
                             ELSE                                                             
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' blob'
                             END IF
                        WHEN 13
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                             ELSE                                                             
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                             END IF
                        WHEN 201 --非informix db的varchar型態專用
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,',', ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                                 WHEN 1 
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',ASCII 10,'     ', l_std[l_i].fldname CLIPPED,' number(5) not null'
                                      END IF
                                 WHEN 2
                                      IF g_db_type='IFX' THEN 
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                      END IF
                                 WHEN 5 
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null'
                                 WHEN 7
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date not null'
                                 WHEN 11
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob not null'
                                      END IF
                                 WHEN 13
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                      END IF
                                 WHEN 201 --非informix db的varchar型態專用
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                             END CASE
                    END CASE
                    #END FUN-7A0028
                 ELSE
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 1 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 2 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 5 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET x=l_std[l_i].length/256
                             LET l_str=x
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 7
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 11
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 13
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 201 --非informix db的varchar型態專用
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 1 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 2 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 5 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 7
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 11
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 13
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 201 --非informix db的varchar型態專用
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                             END CASE
                    END CASE
                 END IF
              ELSE
                 CASE l_std[l_i].type
                     WHEN 0 
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 1 
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 2
                          IF g_db_type='IFX' THEN 
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 5 
                          LET x=l_std[l_i].length/256
                          LET l_str=x
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                          END IF
                          LET l_str=l_std[l_i].length mod 256
                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 7
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                          LET l_k=l_k+1
                     WHEN 11
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                          END IF
                          LET l_k=l_k+1
                     WHEN 13
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 201 --非informix db的varchar型態專用
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                          LET l_k=l_k+1
                     OTHERWISE
                          LET x=l_std[l_i].type-256
                          CASE x
                              WHEN 0 
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 1 
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 2 
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 5 
                                   LET x=l_std[l_i].length/256
                                   LET l_str=x
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                   END IF
                                   LET l_str=l_std[l_i].length mod 256
                                   LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 7
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                   LET l_k=l_k+1
                              WHEN 11
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 13
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 201 --非informix db的varchar型態專用
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                   LET l_k=l_k+1
                          END CASE
                 END CASE
              END IF
           END IF
        END IF
    END FOR
    IF l_loop='Y' THEN 
       LET l_command[l_k].command=l_command[l_k].command CLIPPED,ASCII 10,')'
       LET l_k=l_k+1
    END IF
    LET l_tabname=''
#drop的部份,暫時先拿掉,要用時再去除mark,且需再經過測試
{    FOR l_j=1 TO l_cus_max
        IF l_cus[l_j].check='N' THEN
           LET l_cus[l_j].check='Y'
           IF l_cus[l_j].serial=1 THEN
              LET l_tabname=l_cus[l_i].tabname
              LET l_command[l_k].command='drop table ',l_cus[l_j].tabname CLIPPED
              LET l_k=l_k+1
           ELSE
--display "l_cus_fldname:",l_cus[l_j].fldname
--display "l_tabname:",l_tabname
--display "l_cus_tabname:",l_cus[l_j].tabname 
              IF l_tabname!=l_cus[l_j].tabname OR l_tabname is null THEN
                 LET l_command[l_k].command='alter table ',l_cus[l_j].tabname CLIPPED,' drop(',l_cus[l_j].fldname CLIPPED,')'
                 LET l_k=l_k+1
              END IF
           END IF
        END IF
    END FOR
}
    LET l_command_max=l_k-1
 
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/command"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        #FUN-7A0028
        IF g_check MATCHES "[yY]" THEN              
           IF g_db_type="IFX" THEN
              IF l_command[l_k].fldname is null  THEN
                 CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
              ELSE
                 IF l_command[l_k].oldtype IS NULL THEN
                    CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                 ELSE
                    CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                 END IF
              END IF
           ELSE
              IF l_command[l_k].fldname is null THEN
                 CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
              ELSE
                 IF l_command[l_k].oldtype IS NULL THEN
                    CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                 ELSE
                    CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                 END IF
              END IF
           END IF
        END IF
        #END FUN-7A0028
        CALL readfile_channel.write(l_command[l_k].command CLIPPED)
    END FOR
    CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command
   
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/command.sql"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        #FUN-7A0028
        IF g_check MATCHES "[yY]" THEN              
           IF g_db_type="IFX" THEN
              IF l_command[l_k].fldname is null  THEN
                 CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
              ELSE
                 IF l_command[l_k].oldtype IS NULL THEN
                    CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                 ELSE
                    CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                 END IF
              END IF
           ELSE
              IF l_command[l_k].fldname is null THEN
                 CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
              ELSE
                 IF l_command[l_k].oldtype IS NULL THEN
                    CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                 ELSE
                    CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                 END IF
              END IF
           END IF
        END IF
        #END FUN-7A0028
       LET l_command[l_k].command=l_command[l_k].command CLIPPED,';'
        CALL readfile_channel.write(l_command[l_k].command CLIPPED)
    END FOR
    CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command
    DISPLAY "已產生sql檔",l_str CLIPPED
END FUNCTION

FUNCTION diffdb_tab_schema_withfile()
DEFINE readfile_channel   base.channel,
       l_str              string,
       l_right            char(1),
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_command_max      integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabchk_result    smallint,
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       l_command   dynamic array of record
                   tabname char(20),
                   fldname char(15),
                   oldtype char(30),
                   newtype char(30),
                   action  char(25),
                   gaq03   char(100),
                   command string
                   end record,
       l_std       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   check  char(1)
                   end record,
       l_cus       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   check  char(1)
                   end record,
       tok     base.StringTokenizer,
       tabn    base.StringTokenizer,
       l_run_command String


    LET l_str="diff ",g_tag_db CLIPPED," ",g_std_db CLIPPED," >$TEMPDIR/diffdb.out.",g_pid CLIPPED,";chmod 777 $TEMPDIR/diffdb.out.",g_pid CLIPPED
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_cus[l_i].tabname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_cus[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='< aps' THEN
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_cus[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_cus[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].tabname)
                      LET l_cus[l_i].tabname=l_cus[l_i].tabname[3,l_k]    
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_std[l_i].tabname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET tabn=base.StringTokenizer.create(l_std[l_i].tabname CLIPPED,'_')
                   LET l_right='Y'
                   IF tabn.countTokens()>2 THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_k=1
                   WHILE tabn.hasMoreTokens()
                         CASE l_k
                            WHEN 1
                              LET l_tabn_chk.a=tabn.nextToken() 
                            WHEN 2
                              LET l_tabn_chk.b=tabn.nextToken() 
                              IF l_tabn_chk.b!='file' AND l_tabn_chk.a!='> aps' THEN
                                 LET l_right='N'
                                 CONTINUE WHILE
                              END IF
                         END CASE
                         LET l_k=l_k+1 
                   END WHILE
                WHEN 2
                   LET l_std[l_i].fldname=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].type=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].length=tok.nextToken()
                WHEN 5
                   LET l_std[l_i].serial=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].tabname)
                      LET l_std[l_i].tabname=l_std[l_i].tabname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()
    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
    END IF

    LET l_k=1 #紀錄command數目
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].fldname=l_cus[l_j].fldname AND 
               l_std[l_i].tabname=l_cus[l_j].tabname THEN
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].type=l_cus[l_j].type THEN
                  IF l_std[l_i].type='7' OR l_std[l_i].type='11' OR
                     l_std[l_i].type='1' OR l_std[l_i].type='2' THEN
                     CONTINUE FOR
                  ELSE
                     IF l_std[l_i].length=l_cus[l_j].length THEN
                        CONTINUE FOR
                     ELSE
                        CASE l_std[l_i].type
                            WHEN 0 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 1 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 2 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 5 
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 LET x=l_std[l_i].length/256
                                 LET l_str=x
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                 END IF
                                 LET l_str=l_std[l_i].length mod 256
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                 LET l_k=l_k+1
                            WHEN 7
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                 LET l_k=l_k+1
                            WHEN 11
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte)'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 13
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 IF g_db_type='IFX' THEN
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                                 ELSE
                                    LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                 END IF
                                 LET l_k=l_k+1
                            WHEN 201 --非informix db的varchar型態專用
                                 LET l_command[l_k].tabname=l_std[l_i].tabname
                                 LET l_command[l_k].fldname=l_std[l_i].fldname
                                 LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                 LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                 SELECT gaq03 INTO l_command[l_k].gaq03
                                   FROM gaq_file
                                  WHERE gaq01=l_command[l_k].fldname
                                    AND gaq02='0'
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                 LET l_k=l_k+1
                            OTHERWISE
                                 LET x=l_std[l_i].type-256
                                 CASE x
                                     WHEN 0 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 1 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 2 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 5 
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          LET x=l_std[l_i].length/256
                                          LET l_str=x
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                          END IF
                                          LET l_str=l_std[l_i].length mod 256
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 7
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 11
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 13
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          IF g_db_type='IFX' THEN
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                          ELSE
                                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                          END IF
                                          LET l_k=l_k+1
                                     WHEN 201 --非informix db的varchar型態專用
                                          LET l_command[l_k].tabname=l_std[l_i].tabname
                                          LET l_command[l_k].fldname=l_std[l_i].fldname
                                          LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                          SELECT gaq03 INTO l_command[l_k].gaq03
                                            FROM gaq_file
                                           WHERE gaq01=l_command[l_k].fldname
                                             AND gaq02='0'
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                          LET l_k=l_k+1
                                 END CASE
                        END CASE
                     END IF
                  END IF
               ELSE
                  CASE l_std[l_i].type
                      WHEN 0
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 1
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN 
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 2 
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 5 
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           LET x=l_std[l_i].length/256
                           LET l_str=x
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                           ELSE
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                              LET l_str=l_std[l_i].length mod 256
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'   #FUN-820073   
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 7
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'   #FUN-820073
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 11
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                              ELSE
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob null)'
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 13
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF g_db_type='IFX' THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                              IF l_cus[l_j].type < 202 THEN
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                              ELSE
                                #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                                 LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'   #FUN-820073  
                              END IF
                           END IF
                           LET l_k=l_k+1
                      WHEN 201 --非informix db的varchar型態專用
                           LET l_command[l_k].tabname=l_std[l_i].tabname
                           LET l_command[l_k].fldname=l_std[l_i].fldname
                           LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                           LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                           SELECT gaq03 INTO l_command[l_k].gaq03
                             FROM gaq_file
                            WHERE gaq01=l_command[l_k].fldname
                              AND gaq02='0'
                           IF l_cus[l_j].type < 202 THEN
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                           ELSE
                             #LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') null)'   #FUN-820073   mark
                              LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'   #FUN-820073   
                           END IF
                           LET l_k=l_k+1
                      OTHERWISE
                           LET x=l_std[l_i].type-256
                           IF l_cus[l_j].type < 202 THEN
                              CASE x
                                  WHEN 0 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                       LET l_k=l_k+1
                                  WHEN 7
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       LET l_k=l_k+1
                                  WHEN 11
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 201 --非informix db的varchar型態專用
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                       LET l_k=l_k+1
                              END CASE
                           ELSE
                              CASE x
                                  WHEN 0 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 1 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(5))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 2 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(10))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 5 
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET x=l_std[l_i].length/256
                                       LET l_str=x
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                       END IF
                                       LET l_str=l_std[l_i].length mod 256
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 7
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' date)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 11
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' blob)'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 13
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       IF g_db_type='IFX' THEN
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                       ELSE
                                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                       END IF
                                       LET l_k=l_k+1
                                  WHEN 201 --非informix db的varchar型態專用
                                       LET l_command[l_k].tabname=l_std[l_i].tabname
                                       LET l_command[l_k].fldname=l_std[l_i].fldname
                                       LET l_command[l_k].oldtype=dff_parse(l_cus[l_j].type,l_cus[l_j].length)
                                       LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                       SELECT gaq03 INTO l_command[l_k].gaq03
                                         FROM gaq_file
                                        WHERE gaq01=l_command[l_k].fldname
                                          AND gaq02='0'
                                       LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' modify(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                                       LET l_k=l_k+1
                              END CASE
                           END IF
                  END CASE
               END IF
            END IF
        END FOR
    END FOR
    LET l_loop='N' 
    FOR l_i=1 TO l_std_max
        IF l_std[l_i].check='N' THEN
           LET l_std[l_i].check='Y'
           IF l_std[l_i].serial=1 THEN
              IF l_loop='Y' THEN
                 LET l_command[l_k].tabname=l_tabname
                 LET l_command[l_k].fldname=""
                 LET l_command[l_k].oldtype=""
                 LET l_command[l_k].newtype=""
                 SELECT gat03 INTO l_command[l_k].gaq03
                   FROM gat_file
                  WHERE gat01=l_command[l_k].tabname
                    AND gat02='0'
                 LET l_command[l_k].command=l_command[l_k].command CLIPPED,ASCII 10,')'
                 LET l_k=l_k+1
                 LET l_loop='N'
              END IF
              LET l_loop='Y'
              LET l_tabname=l_std[l_i].tabname
              #FUN-7A0028
              CASE l_std[l_i].type
                  WHEN 0 
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                  WHEN 1 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5)'
                       END IF
                  WHEN 2 
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10)'
                       END IF
                  WHEN 5 
                       LET x=l_std[l_i].length/256
                       LET l_str=x
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                       END IF
                       LET l_str=l_std[l_i].length mod 256
                       LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,')'
                  WHEN 7
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date'
                  WHEN 11
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob'
                       END IF
                  WHEN 13
                       IF g_db_type='IFX' THEN
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                       ELSE
                          LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                       END IF
                  WHEN 201 --非informix db的varchar型態專用
                       LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                  OTHERWISE
                       LET x=l_std[l_i].type-256
                       CASE x
                           WHEN 0 
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                           WHEN 1
                                IF g_db_type='IFX' THEN 
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5) not null'
                                END IF
                           WHEN 2 
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                END IF
                           WHEN 5 
                                LET x=l_std[l_i].length/256
                                LET l_str=x
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                END IF
                                LET l_str=l_std[l_i].length mod 256
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null'
                           WHEN 7
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date not null'
                           WHEN 11
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob not null'
                                END IF
                           WHEN 13
                                IF g_db_type='IFX' THEN
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                ELSE
                                   LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                END IF
                           WHEN 201 --非informix db的varchar型態專用
                                LET l_command[l_k].command='create table ',l_std[l_i].tabname CLIPPED,'(',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                       END CASE
              END CASE
           ELSE
              IF l_loop='Y' THEN
                 IF l_tabname=l_std[l_i].tabname THEN
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,')'
                        WHEN 1
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint'
                             ELSE
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5)'
                             END IF
                        WHEN 2
                             IF g_db_type='IFX' THEN 
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer'
                             ELSE
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10)'
                             END IF
                        WHEN 5 
                             LET x=l_std[l_i].length/256
                             LET l_str=x
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,')'
                        WHEN 7
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date'
                        WHEN 11
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte'
                             ELSE
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob'
                             END IF
                        WHEN 13
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,')'
                             ELSE
                                LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                             END IF
                        WHEN 201 --非informix db的varchar型態專用
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,')'
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null'
                                 WHEN 1 
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' smallint not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(5) not null'
                                      END IF
                                 WHEN 2
                                      IF g_db_type='IFX' THEN 
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' integer not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(10) not null'
                                      END IF
                                 WHEN 5 
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null'
                                 WHEN 7
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' date not null'
                                 WHEN 11
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' byte not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' blob not null'
                                      END IF
                                 WHEN 13
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null'
                                      ELSE
                                         LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                                      END IF
                                 WHEN 201 --非informix db的varchar型態專用
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,', ',ASCII 10,'     ',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null'
                             END CASE
                             #END FUN-7A0028
                    END CASE
                 ELSE
                    CASE l_std[l_i].type
                        WHEN 0 
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 1 
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 2 
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 5 
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             LET x=l_std[l_i].length/256
                             LET l_str=x
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                             END IF
                             LET l_str=l_std[l_i].length mod 256
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 7
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 11
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 13
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             IF g_db_type='IFX' THEN
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                             ELSE
                                LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                             END IF
                             LET l_k=l_k+1
                             LET l_loop='N'
                        WHEN 201 --非informix db的varchar型態專用
                             LET l_command[l_k].tabname=l_tabname
                             LET l_command[l_k].fldname=""
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=""
                             SELECT gat03 INTO l_command[l_k].gaq03
                               FROM gat_file
                              WHERE gat01=l_command[l_k].tabname
                                AND gat02='0'
                             LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                             LET l_k=l_k+1
                             LET l_command[l_k].tabname=l_std[l_i].tabname
                             LET l_command[l_k].fldname=l_std[l_i].fldname
                             LET l_command[l_k].oldtype=""
                             LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                             SELECT gaq03 INTO l_command[l_k].gaq03
                               FROM gaq_file
                              WHERE gaq01=l_command[l_k].fldname
                                AND gaq02='0'
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                             LET l_k=l_k+1
                             LET l_loop='N'
                        OTHERWISE
                             LET x=l_std[l_i].type-256
                             CASE x
                                 WHEN 0 
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 1 
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 2 
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 5 
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      LET x=l_std[l_i].length/256
                                      LET l_str=x
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                      END IF
                                      LET l_str=l_std[l_i].length mod 256
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 7
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 11
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 13
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      IF g_db_type='IFX' THEN
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                      ELSE
                                         LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                      END IF
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                                 WHEN 201 --非informix db的varchar型態專用
                                      LET l_command[l_k].tabname=l_tabname
                                      LET l_command[l_k].fldname=""
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=""
                                      SELECT gat03 INTO l_command[l_k].gaq03
                                        FROM gat_file
                                       WHERE gat01=l_command[l_k].tabname
                                         AND gat02='0'
                                      LET l_command[l_k].command=l_command[l_k].command CLIPPED,')'
                                      LET l_k=l_k+1
                                      LET l_command[l_k].tabname=l_std[l_i].tabname
                                      LET l_command[l_k].fldname=l_std[l_i].fldname
                                      LET l_command[l_k].oldtype=""
                                      LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                      SELECT gaq03 INTO l_command[l_k].gaq03
                                        FROM gaq_file
                                       WHERE gaq01=l_command[l_k].fldname
                                         AND gaq02='0'
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                      LET l_k=l_k+1
                                      LET l_loop='N'
                             END CASE
                    END CASE
                 END IF
              ELSE
                 CASE l_std[l_i].type
                     WHEN 0 
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 1 
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 2
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          IF g_db_type='IFX' THEN 
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 5 
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          LET x=l_std[l_i].length/256
                          LET l_str=x
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                          END IF
                          LET l_str=l_std[l_i].length mod 256
                          LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,'))'
                          LET l_k=l_k+1
                     WHEN 7
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date)'
                          LET l_k=l_k+1
                     WHEN 11
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte)'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob)'
                          END IF
                          LET l_k=l_k+1
                     WHEN 13
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          IF g_db_type='IFX' THEN
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,'))'
                          ELSE
                             LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                          END IF
                          LET l_k=l_k+1
                     WHEN 201 --非informix db的varchar型態專用
                          LET l_command[l_k].tabname=l_std[l_i].tabname
                          LET l_command[l_k].fldname=l_std[l_i].fldname
                          LET l_command[l_k].oldtype=""
                          LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                          SELECT gaq03 INTO l_command[l_k].gaq03
                            FROM gaq_file
                           WHERE gaq01=l_command[l_k].fldname
                             AND gaq02='0'
                          LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,'))'
                          LET l_k=l_k+1
                     OTHERWISE
                          LET x=l_std[l_i].type-256
                          CASE x
                              WHEN 0 
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' char(',l_std[l_i].length CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 1 
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' smallint not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(5) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 2 
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' integer not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(10) not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 5 
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   LET x=l_std[l_i].length/256
                                   LET l_str=x
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' decimal(',l_str CLIPPED
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' number(',l_str CLIPPED
                                   END IF
                                   LET l_str=l_std[l_i].length mod 256
                                   LET l_command[l_k].command=l_command[l_k].command CLIPPED,',',l_str CLIPPED,') not null)'
                                   LET l_k=l_k+1
                              WHEN 7
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' date not null)'
                                   LET l_k=l_k+1
                              WHEN 11
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' byte not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' blob not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 13
                                   LET l_command[l_k].tabname=l_std[l_i].tabname
                                   LET l_command[l_k].fldname=l_std[l_i].fldname
                                   LET l_command[l_k].oldtype=""
                                   LET l_command[l_k].newtype=dff_parse(l_std[l_i].type,l_std[l_i].length)
                                   SELECT gaq03 INTO l_command[l_k].gaq03
                                     FROM gaq_file
                                    WHERE gaq01=l_command[l_k].fldname
                                      AND gaq02='0'
                                   IF g_db_type='IFX' THEN
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar(',l_std[l_i].length CLIPPED,') not null)'
                                   ELSE
                                      LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                   END IF
                                   LET l_k=l_k+1
                              WHEN 201 --非informix db的varchar型態專用
                                   LET l_command[l_k].command='alter table ',l_std[l_i].tabname CLIPPED,' add(',l_std[l_i].fldname CLIPPED,' varchar2(',l_std[l_i].length CLIPPED,') not null)'
                                   LET l_k=l_k+1
                          END CASE
                 END CASE
                 #END FUN-7A0028
              END IF
           END IF
        END IF
    END FOR
    IF l_loop='Y' THEN 
       LET l_command[l_k].tabname=l_std[l_i].tabname
       LET l_command[l_k].fldname=""
       LET l_command[l_k].oldtype=""
       LET l_command[l_k].newtype=""
       SELECT gat03 INTO l_command[l_k].gaq03
         FROM gat_file
        WHERE gat01=l_command[l_k].tabname
          AND gat02='0'
       LET l_command[l_k].command=l_command[l_k].command CLIPPED,ASCII 10,')'
       LET l_k=l_k+1
    END IF
    LET l_tabname=''
#drop的部份,暫時先拿掉,要用時再去除mark,且需再經過測試
{    FOR l_j=1 TO l_cus_max
        IF l_cus[l_j].check='N' THEN
           LET l_cus[l_j].check='Y'
           IF l_cus[l_j].serial=1 THEN
              LET l_tabname=l_cus[l_j].tabname
              LET l_command[l_k].command='drop table ',l_cus[l_j].tabname CLIPPED
              LET l_k=l_k+1
           ELSE
--display "l_cus_fldname:",l_cus[l_j].fldname
--display "l_tabname:",l_tabname
--display "l_cus_tabname:",l_cus[l_j].tabname 
              IF l_tabname!=l_cus[l_j].tabname OR l_tabname is null THEN
                 LET l_command[l_k].command='alter table ',l_cus[l_j].tabname CLIPPED,' drop(',l_cus[l_j].fldname CLIPPED,')'
                 LET l_k=l_k+1
              END IF
           END IF
        END IF
    END FOR
}
    LET l_command_max=l_k-1

    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_tag CLIPPED,"_command"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        LET l_tabchk_result=chk_table(l_command[l_k].command CLIPPED)
        CASE l_tabchk_result
             WHEN 1
                  IF g_check MATCHES "[yY]" THEN              #FUN-7A0028
                     IF g_db_type="IFX" THEN
                        IF l_command[l_k].fldname is null  THEN
                           CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           ELSE
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           END IF
                        END IF
                     ELSE
                        IF l_command[l_k].fldname is null THEN
                           CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           ELSE
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           END IF
                        END IF
                     END IF
                  END IF
                  CALL readfile_channel.write(l_command[l_k].command CLIPPED)
             WHEN 2
                  IF g_check MATCHES "[yY]" THEN              #FUN-7A0028
                     IF g_db_type="IFX" THEN
                        IF l_command[l_k].fldname is null  THEN
                           CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           ELSE
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           END IF
                        END IF
                     ELSE
                        IF l_command[l_k].fldname is null THEN
                           CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           ELSE
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           END IF
                        END IF
                     END IF
                  END IF
                  CALL readfile_channel.write("create synonym "||l_command[l_k].tabname CLIPPED||" for ds."||l_command[l_k].tabname CLIPPED)
        END CASE  
    END FOR
    CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command

    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_tag CLIPPED,"_command.sql"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        LET l_tabchk_result=chk_table(l_command[l_k].command CLIPPED)
        CASE l_tabchk_result
             WHEN 1
                  IF g_check MATCHES "[yY]" THEN              #FUN-7A0028
                     IF g_db_type="IFX" THEN
                        IF l_command[l_k].fldname is null  THEN
                           CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           ELSE
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           END IF
                        END IF
                     ELSE
                        IF l_command[l_k].fldname is null THEN
                           CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           ELSE
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           END IF
                        END IF
                     END IF
                  END IF
                  CALL readfile_channel.write(l_command[l_k].command CLIPPED||";")
             WHEN 2
                  IF g_check MATCHES "[yY]" THEN              #FUN-7A0028
                     IF g_db_type="IFX" THEN
                        IF l_command[l_k].fldname is null  THEN
                           CALL readfile_channel.write("{ "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           ELSE
                              CALL readfile_channel.write("{ "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" }")
                           END IF
                        END IF
                     ELSE
                        IF l_command[l_k].fldname is null THEN
                           CALL readfile_channel.write("/* "||l_command[l_k].tabname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                        ELSE
                           IF l_command[l_k].oldtype IS NULL THEN
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           ELSE
                              CALL readfile_channel.write("/* "||l_command[l_k].fldname CLIPPED||" "||l_command[l_k].oldtype CLIPPED||" "||l_command[l_k].gaq03 CLIPPED||" */")
                           END IF
                        END IF
                     END IF
                  END IF
                  CALL readfile_channel.write("create synonym "||l_command[l_k].tabname CLIPPED||" for ds."||l_command[l_k].tabname CLIPPED||";")
        END CASE  
    END FOR
    CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command
    DISPLAY "已產生sql檔",l_str CLIPPED
END FUNCTION


FUNCTION diffdb_idx_schema_withdb()
DEFINE readfile_channel   base.channel,
       tok                base.StringTokenizer,
       l_str              String,
       l_right            CHAR(1),
       l_std              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          check  char(1)
                          end record,
       l_cus              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          check  char(1)
                          end record,
       l_cus_max          INTEGER,
       l_std_max          INTEGER,
       l_i                INTEGER,
       l_j                INTEGER,
       l_k                INTEGER,
       l_length           SMALLINT,
       l_command_max      INTEGER,
       l_command          dynamic array of record
                          tabname char(20),
                          fldname char(15),
                          oldtype char(30),
                          newtype char(30),
                          action  char(25),
                          gaq03   char(100),
                          command string
                          end record,
       l_run_command      String

    LET l_str="$FGLRUN $DS4GL/bin/gen_index.42r ",g_std_db CLIPPED,";$FGLRUN $DS4GL/bin/gen_index.42r ",g_tag_db CLIPPED,";diff $FGLDBPATH/",g_tag_db CLIPPED,"_idx.sch $FGLDBPATH/",g_std_db CLIPPED,"_idx.sch >$TEMPDIR/diffdb_idx.out.",g_pid CLIPPED,";chmod 777 $TEMPDIR/diffdb_idx.out.",g_pid CLIPPED    #FUN-7A0028
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb_idx.out.",g_pid CLIPPED 
    LET readfile_channel=base.channel.create() 
    CALL readfile_channel.openfile( l_str, "r" ) 
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].idxname=tok.nextToken()
                   IF l_cus[l_i].idxname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_cus[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].idxname)
                      LET l_cus[l_i].idxname=l_cus[l_i].idxname[3,l_k]
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb_idx.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].idxname=tok.nextToken()
                   IF l_std[l_i].idxname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_std[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].idxname)
                      LET l_std[l_i].idxname=l_std[l_i].idxname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()
    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
    END IF
    LET l_k=1
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].idxname=l_cus[l_j].idxname THEN 
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].unique=l_cus[l_j].unique THEN
                  IF l_std[l_i].columns=l_cus[l_j].columns THEN
                     CONTINUE FOR
                  ELSE
                     LET l_command[l_k].command="drop index ",l_cus[l_j].idxname CLIPPED
                     LET l_k=l_k+1
                     IF l_std[l_i].unique='U' THEN
                        LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     ELSE
                        LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     END IF
                     LET l_k=l_k+1
                  END IF
               ELSE
                  LET l_command[l_k].command="drop index ",l_cus[l_j].idxname CLIPPED
                  LET l_k=l_k+1
                  IF l_std[l_i].unique='U' THEN
                     LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                  ELSE
                     LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                  END IF
                  LET l_k=l_k+1
               END IF
            END IF
        END FOR
    END FOR
    FOR l_i=1 TO l_std_max 
        IF l_std[l_i].check='N' THEN
           LET l_std[l_i].check='Y' 
           IF l_std[l_i].unique='U' THEN
              LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
           ELSE
              LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
           END IF
           LET l_k=l_k+1
        END IF
    END FOR
    LET l_command_max=l_k-1
                     
LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/index"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    CALL readfile_channel.write(l_command[l_k].command CLIPPED)
END FOR
CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command

LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/index.sql"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    LET l_command[l_k].command=l_command[l_k].command CLIPPED,';'
    CALL readfile_channel.write(l_command[l_k].command CLIPPED)
END FOR
CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command
    DISPLAY "已產生sql檔:",l_str CLIPPED

{    LET l_str="rm $TEMPDIR/sqlerr_index.log > /dev/null 2>&1"
    RUN l_str
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_date CLIPPED,"/sqlerr_index.log"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
#        LET l_length=LENGTH(l_command[l_k].command)
#        LET l_command[l_k].command=l_command[l_k].command[1,l_length-1]
        EXECUTE IMMEDIATE l_command[l_k].command
        IF l_command[l_k].command[1,4] != "drop" THEN
           IF SQLCA.SQLCODE THEN
              LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].command CLIPPED
              CALL readfile_channel.write(l_str)
              display l_str
           END IF
        END IF
    END FOR
    CALL readfile_channel.close()
}
END FUNCTION


FUNCTION diffdb_idx_schema_withfile()
DEFINE readfile_channel   base.channel,
       tok                base.StringTokenizer,
       l_str              String,
       l_right            CHAR(1),
       l_std              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          check  char(1)
                          end record,
       l_cus              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          check  char(1)
                          end record,
       l_cus_max          INTEGER,
       l_std_max          INTEGER,
       l_i                INTEGER,
       l_j                INTEGER,
       l_k                INTEGER,
       l_length           SMALLINT,
       l_command_max      INTEGER,
       l_command          dynamic array of record
                          tabname char(20),
                          fldname char(15),
                          oldtype char(30),
                          newtype char(30),
                          action  char(25),
                          gaq03   char(100),
                          command string
                          end record,
       l_run_command      String

    LET l_str="diff ",g_tag_db CLIPPED," ",g_std_db CLIPPED," >$TEMPDIR/diffdb_idx.out.",g_pid CLIPPED,";chmod 777 $TEMPDIR/diffdb_idx.out.",g_pid CLIPPED
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb_idx.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create() 
    CALL readfile_channel.openfile( l_str, "r" ) 
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_cus[l_i].idxname=tok.nextToken()
                   IF l_cus[l_i].idxname[1,1] NOT MATCHES"[<]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_cus[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_cus[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_cus[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_cus[l_i].idxname)
                      LET l_cus[l_i].idxname=l_cus[l_i].idxname[3,l_k]
                      LET l_cus[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_cus_max=l_i-1
    CALL readfile_channel.close()
    IF l_cus_max=0 THEN
       CALL l_cus.deleteElement(1)
    END IF

    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/diffdb_idx.out.",g_pid CLIPPED
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.openfile( l_str, "r" )
    LET l_i=1
    WHILE readfile_channel.read(l_str)
       LET tok = base.StringTokenizer.create(l_str CLIPPED,'^')
       LET l_j=1
       WHILE tok.hasMoreTokens()
             CASE l_j
                WHEN 1
                   LET l_std[l_i].idxname=tok.nextToken()
                   IF l_std[l_i].idxname[1,1] NOT MATCHES"[>]" THEN
                      LET l_right='N'
                      EXIT CASE
                   END IF
                   LET l_right='Y'
                WHEN 2
                   LET l_std[l_i].unique=tok.nextToken()
                WHEN 3
                   LET l_std[l_i].columns=tok.nextToken()
                WHEN 4
                   LET l_std[l_i].tabname=tok.nextToken()
                   IF l_right='Y' THEN
                      LET l_k=LENGTH(l_std[l_i].idxname)
                      LET l_std[l_i].idxname=l_std[l_i].idxname[3,l_k]
                      LET l_std[l_i].check='N'
                      LET l_i=l_i+1
                   END IF
             END CASE
             LET l_j=l_j+1
       END WHILE
    END WHILE
    LET l_std_max=l_i-1
    CALL readfile_channel.close()
    IF l_std_max=0 THEN
       CALL l_std.deleteElement(1)
    END IF
    LET l_k=1
    FOR l_i=1 TO l_std_max
        FOR l_j=1 TO l_cus_max
            IF l_std[l_i].idxname=l_cus[l_j].idxname THEN 
               LET l_std[l_i].check='Y'
               LET l_cus[l_j].check='Y'
               IF l_std[l_i].unique=l_cus[l_j].unique THEN
                  IF l_std[l_i].columns=l_cus[l_j].columns THEN
                     CONTINUE FOR
                  ELSE
                     LET l_command[l_k].command="drop index ",l_cus[l_j].idxname CLIPPED
                     LET l_k=l_k+1
                     IF l_std[l_i].unique='U' THEN
                        LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     ELSE
                        LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     END IF
                     LET l_k=l_k+1
                  END IF
               ELSE
                  LET l_command[l_k].command="drop index ",l_cus[l_j].idxname CLIPPED
                  LET l_k=l_k+1
                  IF l_std[l_i].unique='U' THEN
                     LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                  ELSE
                     LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                  END IF
                  LET l_k=l_k+1
               END IF
            END IF
        END FOR
    END FOR
    FOR l_i=1 TO l_std_max 
        IF l_std[l_i].check='N' THEN
           FOR l_j=1 TO l_cus_max
               IF l_cus[l_j].check='N' THEN
                  IF l_std[l_i].columns=l_cus[l_j].columns THEN
                     LET l_std[l_i].check='Y' 
                     LET l_cus[l_j].check='Y' 
                     LET l_command[l_k].command="drop index ",l_cus[l_j].idxname CLIPPED
                     LET l_k=l_k+1
                     IF l_std[l_i].unique='U' THEN
                        LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     ELSE
                        LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
                     END IF
                     LET l_k=l_k+1
                  END IF
               END IF
           END FOR
           IF l_std[l_i].check='N' THEN
              LET l_std[l_i].check='Y' 
              IF l_std[l_i].unique='U' THEN
                 LET l_command[l_k].command="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
              ELSE
                 LET l_command[l_k].command="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED," (",l_std[l_i].columns CLIPPED,")"
              END IF
              LET l_k=l_k+1
           END IF
        END IF
    END FOR
    LET l_command_max=l_k-1
                     
LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/",g_tag CLIPPED,"_index"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    IF chk_table(l_command[l_k].command CLIPPED) THEN
       CALL readfile_channel.write(l_command[l_k].command CLIPPED)
    END IF
END FOR
CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command

LET readfile_channel=base.channel.create()
CALL readfile_channel.setdelimiter("")
CALL fgl_getenv("TEMPDIR") RETURNING l_str
LET l_str=l_str CLIPPED,"/",g_tag CLIPPED,"_index.sql"
CALL readfile_channel.openfile(l_str CLIPPED, "w" )
FOR l_k=1 TO l_command_max
    IF chk_table(l_command[l_k].command CLIPPED) THEN
       LET l_command[l_k].command=l_command[l_k].command CLIPPED,';'
       CALL readfile_channel.write(l_command[l_k].command CLIPPED)
    END IF
END FOR
CALL readfile_channel.close()
    LET l_run_command="chmod 777 ",l_str CLIPPED
    RUN l_run_command
    DISPLAY "已產生sql檔",l_str CLIPPED

{    LET l_str="rm $TEMPDIR/sqlerr_index.log > /dev/null 2>&1"
    RUN l_str
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_date CLIPPED,"/sqlerr_index.log"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
#        LET l_length=LENGTH(l_command[l_k].command)
#        LET l_command[l_k].command=l_command[l_k].command[1,l_length-1]
        EXECUTE IMMEDIATE l_command[l_k].command
        IF l_command[l_k].command[1,4] != "drop" THEN
           IF SQLCA.SQLCODE THEN
              LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].command CLIPPED
              CALL readfile_channel.write(l_str)
              display l_str
           END IF
        END IF
    END FOR
    CALL readfile_channel.close()
}
END FUNCTION

FUNCTION chk_table(p_command)
DEFINE p_command CHAR(1000)
DEFINE p_cmd     STRING
DEFINE l_n       SMALLINT,
       l_start   SMALLINT,
       l_stop    SMALLINT,
       l_i       SMALLINT,
       l_tabname CHAR(15),
       l_x       SMALLINT
DEFINE tok       base.StringTokenizer

   LET p_cmd=p_command

CLOSE DATABASE                                         #FUN-7A0028
DATABASE g_tag

   IF p_cmd.subString(1,12)="create table" THEN
      LET l_start=14
      FOR l_i=14 TO 100
          IF p_cmd.subString(l_i,l_i)='(' THEN
             LET l_stop=l_i-1
             EXIT FOR
          END IF
      END FOR
      LET l_tabname=p_cmd.subString(l_start,l_stop)

      IF g_db_type="IFX" THEN
         select count(rowid) INTO l_n 
           from systables 
          where tabname=l_tabname
            and tabtype='S'
      ELSE
         select count(1) INTO l_n
           from user_synonyms 
          where lower(table_name)=l_tabname
      END IF
########## 1 is synonym 0 is not synonym ##############3
      IF l_n=1 THEN
         CLOSE DATABASE                                       #FUN-7A0028
         DATABASE g_std
         RETURN 0
      ELSE
         IF g_isds!='1' THEN
            #FUN-7A0028
            CLOSE DATABASE
            DATABASE dstest
            IF SQLCA.SQLCODE THEN
               CLOSE DATABASE
               DATABASE ds1
            END IF 
            #END FUN-7A0028
            IF g_db_type="IFX" THEN
               select count(rowid) INTO l_n 
                 from systables 
                where tabname=l_tabname
                  and tabtype='S'
            ELSE
               select count(1) INTO l_n
                 from user_synonyms 
                where lower(table_name)=l_tabname
            END IF
         ELSE
            LET l_n=0
         END IF
         CLOSE DATABASE                                     #FUN-7A0028
         DATABASE g_std
############## 2表示需CREATE SYNONYM ||  1表示需CREATE TABLE ###########
         IF l_n=1 THEN
            RETURN 2
         ELSE
            RETURN 1
         END IF
      END IF
   ELSE
      LET tok = base.StringTokenizer.create(p_cmd," ")
      LET l_x=1
      WHILE tok.hasMoreTokens()
        CASE 
           WHEN p_cmd.subString(1,6)="drop i"
                RETURN 1
           WHEN p_cmd.subString(1,7)="alter t" 
                IF l_x=3 THEN
                   CALL tok.nextToken() RETURNING l_tabname
                   DISPLAY l_tabname
                   EXIT WHILE
                END IF
           WHEN p_cmd.subString(1,6)="drop t" 
                IF l_x=3 THEN
                   CALL tok.nextToken() RETURNING l_tabname
                   DISPLAY l_tabname
                   EXIT WHILE
                END IF
           WHEN p_cmd.subString(1,8)="create u" 
                IF l_x=6 THEN
                   CALL tok.nextToken() RETURNING l_tabname
                   DISPLAY l_tabname
                   EXIT WHILE
                END IF
           WHEN p_cmd.subString(1,8)="create i" 
                IF l_x=5 THEN
                   CALL tok.nextToken() RETURNING l_tabname
                   DISPLAY l_tabname
                   EXIT WHILE
                END IF
        END CASE
        CALL tok.nextToken() RETURNING l_tabname
        LET l_x=l_x+1
      END WHILE
      
      IF g_db_type="IFX" THEN
         select count(rowid) INTO l_n 
           from systables 
          where tabname=l_tabname
            and tabtype='T'
      ELSE
         select count(1) INTO l_n
           from user_tables 
          where lower(table_name)=l_tabname
      END IF
      CLOSE DATABASE                                         #FUN-7A0028
      DATABASE g_std
########## 1 is table 0 is not table ##############3
      IF l_n=1 THEN
         RETURN 1
      ELSE
         RETURN 0
      END IF
   END IF
END FUNCTION

FUNCTION dff_parse(p_type,p_length)
DEFINE p_type     CHAR(3),
       p_length   CHAR(5),
       l_str      STRING,
       x          smallint,
       l_result   CHAR(30)

CASE p_type
     WHEN '0'
          LET l_result="char(",p_length CLIPPED,")"
     WHEN '1'
          IF g_db_type="IFX" THEN
             LET l_result="smallint"
          ELSE
             LET l_result="number(5)"
          END IF
     WHEN '2'
          IF g_db_type="IFX" THEN
             LET l_result="integer"
          ELSE
             LET l_result="number(10)"
          END IF
     WHEN '5'
          LET x=p_length/256
          LET l_str=x
          IF g_db_type="IFX" THEN
             LET l_result="decimal(",l_str CLIPPED,','
          ELSE
             LET l_result="number(",l_str CLIPPED,','
          END IF
          LET l_str=p_length mod 256
          LET l_result=l_result CLIPPED,l_str CLIPPED,")"
     WHEN '7'
          LET l_result="date"
     WHEN '11'
          IF g_db_type="IFX" THEN
             LET l_result="byte"
          ELSE
             LET l_result="blob"
          END IF
     WHEN '13'
          IF g_db_type="IFX" THEN
             LET l_result="varchar(",p_length CLIPPED,")"
          ELSE
             LET l_result="varchar2(",p_length CLIPPED,")"
          END IF
     WHEN '201'
          LET l_result="varchar2(",p_length CLIPPED,")"
     OTHERWISE
          LET x=p_type-256
          CASE x
               WHEN 0
                    LET l_result="char(",p_length CLIPPED,")"
               WHEN 1
                    IF g_db_type="IFX" THEN
                       LET l_result="smallint"
                    ELSE
                       LET l_result="number(5)"
                    END IF
               WHEN 2
                    IF g_db_type="IFX" THEN
                       LET l_result="integer"
                    ELSE
                       LET l_result="number(10)"
                    END IF
               WHEN 5
                    LET l_str=p_length/256
                    IF g_db_type="IFX" THEN
                       LET l_result="decimal(",l_str CLIPPED,','
                    ELSE
                       LET l_result="number(",l_str CLIPPED,','
                    END IF
                    LET l_str=p_length mod 256
                    LET l_result=l_result CLIPPED,l_str CLIPPED,")"
               WHEN 7
                    LET l_result="date"
               WHEN 11
                    IF g_db_type="IFX" THEN
                       LET l_result="byte"
                    ELSE
                       LET l_result="blob"
                    END IF
               WHEN 13
                    IF g_db_type="IFX" THEN
                       LET l_result="varchar(",p_length CLIPPED,")"
                    ELSE
                       LET l_result="varchar2(",p_length CLIPPED,")"
                    END IF
               WHEN 201
                    LET l_result="varchar2(",p_length CLIPPED,")"
          END CASE
          LET l_result=l_result CLIPPED," not null"
END CASE
RETURN l_result
END FUNCTION

