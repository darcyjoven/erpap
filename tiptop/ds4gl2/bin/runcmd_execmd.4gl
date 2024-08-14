##################################################
# Description   : 執行更新的sql命令
# Date & Author : 2005/01/18 by qazzaq
# Parameter     :
# Return        :
# Memo          :
# Modify        : 2005/01/24 by qazzaq 加入多資料庫的alter
##################################################
MAIN
define readfile_channel   base.channel,
       readsql_channel    base.channel,
       l_str              string,
       l_str1             dynamic array of string,
       l_right            smallint,
       l_i                integer,
       l_j                integer,
       l_x                integer,
       l_k                integer,
       l_n                smallint,
       l_flag             smallint,
       l_start            smallint,
       l_stop             smallint,
       l_loop             char(1),
       l_tabname          char(15),
       p_backup           char(1),
       l_command   dynamic array of record
                   cmd      string,
                   is_table char(1)
                   end record,
       p_db_type   CHAR(3),
       p_date      string,
       p_database  CHAR(20),
       p_cmdfile_loc char(100)
DEFINE tok     base.StringTokenizer


    WHENEVER ERROR CONTINUE
    CALL fgl_getenv("FGLPROFILE") RETURNING l_str
    DISPLAY "fglprofile:",l_str CLIPPED
    LET p_db_type=ARG_VAL(1)
    LET p_date=ARG_VAL(2)
    LET p_database=ARG_VAL(3)
    LET p_backup=ARG_VAL(4)
    LET p_cmdfile_loc=ARG_VAL(5)

--  讀取command
    LET l_k=1
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    LET l_str="patch_cust_command"
    LET l_str=p_cmdfile_loc
    CALL readfile_channel.openfile(l_str CLIPPED, "r" )
    WHILE readfile_channel.read(l_str)
          LET l_str = l_str.trim()
          IF l_str.subString(l_str.getLength(),l_str.getLength())=';' THEN
             LET l_command[l_k].cmd = l_str.subString(1,l_str.getLength()-1)
          ELSE
             LET l_command[l_k].cmd = l_str
          END IF
display "l_command[l_k].cmd:",l_command[l_k].cmd
          LET l_k=l_k+1
    END WHILE
    CALL readfile_channel.close()

    IF p_backup='Y' THEN  --需要備份的情況
       DATABASE qazzaq
       IF SQLCA.SQLCODE THEN
          DISPLAY SQLCA.SQLCODE,"切換資料庫發生錯誤,異常中止!!"
          DISPLAY "刪除測試資料庫中,依資料庫的大小時間會為之增減,請耐心等候..."
          DISPLAY "請勿任意中止程式,以免造成資料庫錯誤!!!"
          IF p_db_type='IFX' THEN
             RUN "echo 'drop database qazzaq'|dbaccess > /dev/null 2>&1"
          ELSE
             RUN "echo 'drop user qazzaq cascade;'|sqlplus '/as sysdba' > /dev/null 2>&1"
          END IF
          EXIT PROGRAM
       END IF
       LET l_str="rm $TEMPDIR/",p_date CLIPPED,"/sqlerr_test.log > /dev/null 2>&1"
       RUN l_str
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       LET l_str="mkdir $TEMPDIR/",p_date CLIPPED," > /dev/null 2>&1"
       RUN l_str
       CALL fgl_getenv("TEMPDIR") RETURNING l_str
       LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_test.log"
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       FOR l_k=1 TO l_command.getLength()    
           IF l_command[l_k].cmd.subString(1,12)="create table" THEN
              LET l_start=14
              FOR l_i=14 TO 100
                  IF l_command[l_k].cmd.subString(l_i,l_i)='(' THEN
                     LET l_stop=l_i-1
                     EXIT FOR
                  END IF
              END FOR
              LET l_tabname=l_command[l_k].cmd.subString(l_start,l_stop)
              IF p_db_type="IFX" THEN
                 select count(rowid) INTO l_n 
                   from systables 
                  where tabname=l_tabname
                    and tabtype='T'
              ELSE
                 select count(1) INTO l_n
                   from user_tables 
                  where lower(table_name)=l_tabname
              END IF
              IF l_n=1 THEN
                 LET l_command[l_k].is_table='Y'
                 EXECUTE IMMEDIATE l_command[l_k].cmd
                 IF SQLCA.SQLCODE THEN
                    LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].cmd CLIPPED
                    CALL readfile_channel.write(l_str)
                 END IF
              ELSE
                 LET l_command[l_k].is_table='N'
              END IF
           ELSE
              LET tok = base.StringTokenizer.create(l_command[l_k].cmd," ")
              LET l_x=1
              WHILE tok.hasMoreTokens()
                CASE 
                   WHEN l_command[l_k].cmd.subString(1,7)="alter t" 
                        IF l_x=3 THEN
                           CALL tok.nextToken() RETURNING l_tabname
                           DISPLAY l_tabname
                           EXIT WHILE
                        END IF
                   WHEN l_command[l_k].cmd.subString(1,6)="drop t" 
                        IF l_x=3 THEN
                           CALL tok.nextToken() RETURNING l_tabname
                           DISPLAY l_tabname
                           EXIT WHILE
                        END IF
                   WHEN l_command[l_k].cmd.subString(1,8)="create u" 
                        IF l_x=6 THEN
                           CALL tok.nextToken() RETURNING l_tabname
                           DISPLAY l_tabname
                           EXIT WHILE
                        END IF
                   WHEN l_command[l_k].cmd.subString(1,8)="create i" 
                        IF l_x=5 THEN
                           CALL tok.nextToken() RETURNING l_tabname
                           DISPLAY l_tabname
                           EXIT WHILE
                        END IF
                END CASE
                CALL tok.nextToken() RETURNING l_tabname
                LET l_x=l_x+1
              END WHILE
              IF p_db_type="IFX" THEN
                 select count(rowid) INTO l_n 
                   from systables 
                  where tabname=l_tabname
                    and tabtype='T'
              ELSE
                 select count(1) INTO l_n
                   from user_tables 
                  where lower(table_name)=l_tabname
              END IF
              IF l_n=1 THEN
                 LET l_command[l_k].is_table='Y'
                 EXECUTE IMMEDIATE l_command[l_k].cmd
                 IF SQLCA.SQLCODE THEN
                    LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].cmd CLIPPED
                    CALL readfile_channel.write(l_str)
                 END IF
              ELSE
                 LET l_command[l_k].is_table='N'
              END IF
           END IF
       END FOR
       CALL readfile_channel.close()
       
       DATABASE p_database
       DISPLAY "刪除測試資料庫中,依資料庫的大小時間會為之增減,請耐心等候..."
       DISPLAY "請勿任意中止程式,以免造成資料庫錯誤!!!"
     IF p_db_type='IFX' THEN
        RUN "echo 'drop database qazzaq'|dbaccess > /dev/null 2>&1"
     ELSE
        RUN "echo 'drop user qazzaq cascade;'|sqlplus '/as sysdba' > /dev/null 2>&1"
     END IF
       RUN "rm $TEMPDIR/result > /dev/null 2>&1"
       LET l_str="test -s $TEMPDIR/",p_date CLIPPED,"/sqlerr_test.log"
       RUN l_str RETURNING l_right
    ELSE   --不備份設成119
       DATABASE p_database
       LET l_right=119
    END IF
    WHILE TRUE
       IF l_right!=0 THEN
          IF l_right=119 THEN  --不備份直接run的情況
             LET l_str="rm $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,".log > /dev/null 2>&1"
             RUN l_str
             LET readfile_channel=base.channel.create()
             CALL readfile_channel.setdelimiter("")
             LET l_str="mkdir $TEMPDIR/",p_date CLIPPED," > /dev/null 2>&1"
             RUN l_str
             CALL fgl_getenv("TEMPDIR") RETURNING l_str
             LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,".log"
             CALL readfile_channel.openfile(l_str CLIPPED, "w" )
             FOR l_k=1 TO l_command.getLength()    
                 IF l_command[l_k].cmd.subString(1,12)="create table" THEN
                    FOR l_i=14 TO 100
                        IF l_command[l_k].cmd.subString(l_i,l_i)='(' THEN
                           LET l_stop=l_i-1
                           EXIT FOR
                        END IF
                    END FOR
                    LET l_tabname=l_command[l_k].cmd.subString(l_start,l_stop)
                    IF p_db_type="IFX" THEN
                       select count(rowid) INTO l_n 
                         from systables 
                        where tabname=l_tabname
                          and tabtype='T'
                    ELSE
                       select count(1) INTO l_n
                         from user_tables 
                        where lower(table_name)=l_tabname
                    END IF
                    IF l_n=1 THEN
                       LET l_command[l_k].is_table='Y'
                       EXECUTE IMMEDIATE l_command[l_k].cmd
                       IF SQLCA.SQLCODE THEN
                          LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].cmd CLIPPED
                          CALL readfile_channel.write(l_str)
                       END IF
                    ELSE
                       LET l_command[l_k].is_table='N'
                    END IF
                 ELSE
                    LET tok = base.StringTokenizer.create(l_command[l_k].cmd," ")
                    LET l_x=1
                    WHILE tok.hasMoreTokens()
                      CASE 
                         WHEN l_command[l_k].cmd.subString(1,7)="alter t" 
                              IF l_x=3 THEN
                                 CALL tok.nextToken() RETURNING l_tabname
                                 DISPLAY l_tabname
                                 EXIT WHILE
                              END IF
                         WHEN l_command[l_k].cmd.subString(1,6)="drop t" 
                              IF l_x=3 THEN
                                 CALL tok.nextToken() RETURNING l_tabname
                                 DISPLAY l_tabname
                                 EXIT WHILE
                              END IF
                         WHEN l_command[l_k].cmd.subString(1,8)="create u" 
                              IF l_x=6 THEN
                                 CALL tok.nextToken() RETURNING l_tabname
                                 DISPLAY l_tabname
                                 EXIT WHILE
                              END IF
                         WHEN l_command[l_k].cmd.subString(1,8)="create i" 
                              IF l_x=5 THEN
                                 CALL tok.nextToken() RETURNING l_tabname
                                 DISPLAY l_tabname
                                 EXIT WHILE
                              END IF
                      END CASE
                      CALL tok.nextToken() RETURNING l_tabname
                      LET l_x=l_x+1
                    END WHILE
                    IF p_db_type="IFX" THEN
                       select count(rowid) INTO l_n 
                         from systables 
                        where tabname=l_tabname
                          and tabtype='T'
                    ELSE
                       select count(1) INTO l_n
                         from user_tables 
                        where lower(table_name)=l_tabname
                    END IF
                    IF l_n=1 THEN
                       LET l_command[l_k].is_table='Y'
                       EXECUTE IMMEDIATE l_command[l_k].cmd
                       IF SQLCA.SQLCODE THEN
                          LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].cmd CLIPPED
                          CALL readfile_channel.write(l_str)
                       END IF
                    ELSE
                       LET l_command[l_k].is_table='N'
                    END IF
                 END IF
             END FOR
             CALL readfile_channel.close()


#             FOR l_k=1 TO l_command.getLength()
#                 display l_command[l_k].is_table," ",l_command[l_k].cmd
#             END FOR


             LET l_str="test -s $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                       ".log"
             RUN l_str RETURNING l_str
             IF l_str!=0 THEN
                IF p_db_type="IFX" THEN
                   RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                ELSE
                   RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                END IF
                DISPLAY p_database CLIPPED,"無異常更新成功!"
#                DISPLAY "ds以外的資料庫請手動執行$TEMPDIR/",p_date CLIPPED,
#                        "/cmd4nds.sql來更新!"
#                LET l_str="cmd4nds.sh $TEMPDIR/",p_date CLIPPED,"/command.sql"
#                RUN l_str
                EXIT WHILE
             ELSE
                IF p_db_type="IFX" THEN
                   RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                ELSE
                   RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                END IF
                LET l_str="chmod 777 $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                          ".log"
                RUN l_str
--需要按enter                
--                DISPLAY p_database CLIPPED,"更新出現異常!(請按enter鍵繼續)"
                DISPLAY p_database CLIPPED,"更新出現異常!"
--需要按enter                
--              LET l_str="read;more $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED, ".log"
                RUN l_str
                RUN "echo 1 >$TEMPDIR/result"
                RUN "chmod 777 $TEMPDIR/result"
                DISPLAY "請參考$TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,".log檔來排除異常"
                DISPLAY "之後再次進行資料庫更新!"
                DISPLAY "或參考patch目錄下的patch_cust_command手動進行資料庫更新!"
                EXIT WHILE
             END IF
          ELSE
--             DISPLAY "測試成功無異常,是否對",p_database CLIPPED,"進行處理(Y/N)?" 
             DISPLAY "測試成功無異常,直接對",p_database CLIPPED,"進行處理" 
#             FOR l_k=1 TO l_command.getLength()
#                 display "ds:",l_command[l_k].is_table," ",l_command[l_k].cmd
#             END FOR
--             RUN "read answer;echo $answer > $TEMPDIR/answer"
--             RUN "chmod 777 $TEMPDIR/answer"
--             LET readfile_channel=base.channel.create()
--             CALL fgl_getenv("TEMPDIR") RETURNING l_str
--             LET l_str=l_str CLIPPED,"/answer"
--             CALL readfile_channel.openfile(l_str,"r")
--             WHILE readfile_channel.read(l_str)
--             END WHILE
--             CALL readfile_channel.close()
             
--             IF l_str NOT MATCHES "[YyNn]" OR l_str IS NULL THEN
--                CONTINUE WHILE
--             ELSE
--                IF l_str MATCHES "[Nn]" THEN
--                   DISPLAY "不對",p_database CLIPPED,"進行處理."
--                   RUN "echo 1 >$TEMPDIR/result"
--                   RUN "chmod 777 $TEMPDIR/result"
--                   EXIT WHILE
--                ELSE
                   LET l_str="rm $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                             ".log > /dev/null 2>&1"
                   RUN l_str
                   LET readfile_channel=base.channel.create()
                   CALL readfile_channel.setdelimiter("")
                   CALL fgl_getenv("TEMPDIR") RETURNING l_str
                   LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                             ".log"
                   CALL readfile_channel.openfile(l_str CLIPPED, "w" )
                   FOR l_k=1 TO l_command.getLength()    
                       IF l_command[l_k].cmd.subString(1,12)="create table" THEN
                          FOR l_i=1 TO l_j-1
                              EXECUTE IMMEDIATE l_str1[l_i]
                              IF SQLCA.SQLCODE THEN
                                 LET l_str=SQLCA.SQLCODE USING "--------",
                                           l_str1[l_i] CLIPPED
                                 CALL readfile_channel.write(l_str)
                              END IF
                          END FOR
                          IF SQLCA.SQLCODE = 0 THEN
#                             IF l_command[l_k].cmd.subString(1,12)="create table" THEN
                                LET l_str="cp ",l_command[l_k].cmd.subString(14,l_start-2),
                                          ".sch.src ",
                                          l_command[l_k].cmd.subString(l_start,l_start+3),
                                          "/sch"
                                RUN l_str
#                             END IF
                          END IF
                       ELSE
                          IF l_command[l_k].is_table='Y' THEN
                             EXECUTE IMMEDIATE l_command[l_k].cmd
                             IF SQLCA.SQLCODE THEN
                                LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k].cmd CLIPPED
                                CALL readfile_channel.write(l_str)
                             END IF
                          END IF
                       END IF
                   END FOR
                   CALL readfile_channel.close()
                   LET l_str="test -s $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                             ".log"
                   RUN l_str RETURNING l_str
                   IF l_str!=0 THEN
                      IF p_db_type="IFX" THEN
                         RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                      ELSE
                         RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                      END IF
                      DISPLAY p_database CLIPPED,"無異常更新成功!"
#                      DISPLAY "ds以外的資料庫請手動執行$TEMPDIR/",p_date CLIPPED,
#                              "/cmd4nds.sql來更新!"
#                      LET l_str="cmd4nds.sh $TEMPDIR/",p_date CLIPPED,"/command.sql"
#                      RUN l_str
                      EXIT WHILE
                   ELSE
                      IF p_db_type="IFX" THEN
                         RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                      ELSE
                         RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                      END IF
                      LET l_str="chmod 777 $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                                ".log"
                      RUN l_str
                      DISPLAY p_database CLIPPED,"更新出現異常!(請按enter鍵繼續)"
                      LET l_str="read;more $TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,
                                ".log"
                      RUN l_str
                      RUN "echo 1 >$TEMPDIR/result"
                      RUN "chmod 777 $TEMPDIR/result"
                      DISPLAY "請參考$TEMPDIR/",p_date CLIPPED,"/sqlerr_",p_database CLIPPED,".log檔來排除異常"
                      DISPLAY "之後再次進行資料庫更新!"
                      DISPLAY "或參考patch目錄下的patch_cust_command手動進行資料庫更新!"
                      EXIT WHILE
                   END IF
--                END IF
--             END IF
          END IF
       ELSE
          LET l_str="chmod 777 $TEMPDIR/",p_date CLIPPED,"/sqlerr_test.log"
          RUN l_str
          DISPLAY "測試更新出現異常!(請按enter鍵繼續)"
          LET l_str="read;more $TEMPDIR/",p_date CLIPPED,"/sqlerr_test.log"
          RUN l_str
          RUN "echo 1 >$TEMPDIR/result"
          RUN "chmod 777 $TEMPDIR/result"
          DISPLAY "請參考$TEMPDIR/",p_date CLIPPED,"/sqlerr_test.log檔來排除異常"
          DISPLAY "之後再次進行資料庫更新!"
          DISPLAY "或參考patch目錄下的patch_cust_command手動進行資料庫更新!"
          EXIT WHILE
       END IF
    END WHILE
END MAIN
