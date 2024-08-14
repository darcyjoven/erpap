MAIN
define readfile_channel   base.channel,
       l_str              char(1000),
       l_right            smallint,
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_command_max      integer,
       l_command_idx_max  integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       l_command   dynamic array of varchar(1000),
       l_command_idx  dynamic array of varchar(1000),
       l_std       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   command char(1000),
                   check  char(1)
                   end record,
       l_cus       dynamic array of record
                   tabname char(20),
                   fldname char(20),
                   type    char(3), 
                   length  char(5),
                   serial  smallint,
                   command char(1000),
                   check  char(1)
                   end record,
       p_db_type   CHAR(3),
       p_date      CHAR(8)
DEFINE tok     base.StringTokenizer,
       tabn    base.StringTokenizer


    whenever error continue
    CALL fgl_getenv("FGLPROFILE") RETURNING l_str
    display l_str CLIPPED
    LET p_db_type=ARG_VAL(1)
    LET p_date=ARG_VAL(2)

    LET l_k=1
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/command"
    CALL readfile_channel.openfile(l_str CLIPPED, "r" )
    WHILE readfile_channel.read(l_str)
          LET l_command[l_k] = l_str CLIPPED
          LET l_k=l_k+1
    END WHILE
    LET l_command_max=l_k-1
    CALL readfile_channel.close()

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
    LET l_str="rm $TEMPDIR/",p_date CLIPPED,"/sqlerr_table.log > /dev/null 2>&1"
    RUN l_str
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_table.log"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max    
        EXECUTE IMMEDIATE l_command[l_k]
        IF SQLCA.SQLCODE THEN
display SQLCA.SQLCODE USING "--------",l_command[l_k] CLIPPED
           LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k] CLIPPED
           CALL readfile_channel.write(l_str)
           display l_str
        END IF
    END FOR
    CALL readfile_channel.close()

######################## index的execute命令 ###########################
    LET l_k=1
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/index"
    CALL readfile_channel.openfile(l_str CLIPPED, "r" )
    WHILE readfile_channel.read(l_str)
          LET l_command_idx[l_k] = l_str CLIPPED
          LET l_k=l_k+1
    END WHILE
    LET l_command_idx_max=l_k-1
    CALL readfile_channel.close()

    LET l_str="rm $TEMPDIR/",p_date,"/sqlerr_index.log > /dev/null 2>&1"
    RUN l_str
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_index.log"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_idx_max
        EXECUTE IMMEDIATE l_command_idx[l_k]
        IF l_command_idx[l_k][1,4] != "drop" THEN
           IF SQLCA.SQLCODE THEN
              LET l_str=SQLCA.SQLCODE USING "--------",l_command_idx[l_k] CLIPPED
              CALL readfile_channel.write(l_str)
              display l_str
           END IF
        END IF
    END FOR
    CALL readfile_channel.close()
    LET l_str="cat $TEMPDIR/",p_date CLIPPED,"/sqlerr_table.log ",
                  "$TEMPDIR/",p_date CLIPPED,"/sqlerr_index.log > ",
                  "$TEMPDIR/",p_date CLIPPED,"/sqlerr.log"
    RUN l_str

DATABASE ds
    DISPLAY "刪除測試資料庫中,依資料庫的大小時間會為之增減,請耐心等候..."
    DISPLAY "請勿任意中止程式,以免造成資料庫錯誤!!!"
    IF p_db_type='IFX' THEN
       RUN "echo 'drop database qazzaq'|dbaccess > /dev/null 2>&1"
    ELSE
       RUN "echo 'drop user qazzaq cascade;'|sqlplus '/as sysdba' > /dev/null 2>&1"
    END IF
    RUN "rm $TEMPDIR/result > /dev/null 2>&1"
    LET l_str="test -s $TEMPDIR/",p_date CLIPPED,"/sqlerr.log"
    RUN l_str RETURNING l_right
    WHILE TRUE
       IF l_right!=0 THEN
          DISPLAY "測試成功無異常,是否對ds進行處理(Y/N)?" 
          RUN "read answer;echo $answer > $TEMPDIR/answer"
          RUN "chmod 777 $TEMPDIR/answer"
          LET readfile_channel=base.channel.create()
          CALL fgl_getenv("TEMPDIR") RETURNING l_str
          LET l_str=l_str CLIPPED,"/answer"
          CALL readfile_channel.openfile(l_str,"r")
          WHILE readfile_channel.read(l_str)
          END WHILE
          CALL readfile_channel.close()

          IF l_str NOT MATCHES "[YyNn]" OR l_str IS NULL THEN
             CONTINUE WHILE
          ELSE
             IF l_str MATCHES "[Nn]" THEN
                DISPLAY "不對ds進行處理."
                RUN "echo 1 >$TEMPDIR/result"
                RUN "chmod 777 $TEMPDIR/result"
                EXIT WHILE
             ELSE
                LET l_str="rm $TEMPDIR/",p_date CLIPPED,"/sqlerr_table_ds.log > /dev/null 2>&1"
                RUN l_str
                LET readfile_channel=base.channel.create()
                CALL readfile_channel.setdelimiter("")
                CALL fgl_getenv("TEMPDIR") RETURNING l_str
                LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_table_ds.log"
                CALL readfile_channel.openfile(l_str CLIPPED, "w" )
                FOR l_k=1 TO l_command_max    
                    EXECUTE IMMEDIATE l_command[l_k]
                    IF SQLCA.SQLCODE THEN
                       LET l_str=SQLCA.SQLCODE USING "--------",l_command[l_k] CLIPPED
                       CALL readfile_channel.write(l_str)
                       display l_str
                    END IF
                END FOR
                CALL readfile_channel.close()
                LET l_str="rm $TEMPDIR/",p_date,"/sqlerr_index_ds.log > /dev/null 2>&1"
                RUN l_str
                LET readfile_channel=base.channel.create()
                CALL readfile_channel.setdelimiter("")
                CALL fgl_getenv("TEMPDIR") RETURNING l_str
                LET l_str=l_str CLIPPED,"/",p_date CLIPPED,"/sqlerr_index_ds.log"
                CALL readfile_channel.openfile(l_str CLIPPED, "w" )
                FOR l_k=1 TO l_command_idx_max
                    EXECUTE IMMEDIATE l_command_idx[l_k]
                    IF l_command_idx[l_k][1,4] != "drop" THEN
                       IF SQLCA.SQLCODE THEN
                          LET l_str=SQLCA.SQLCODE USING "--------",l_command_idx[l_k] CLIPPED
                          CALL readfile_channel.write(l_str)
                          display l_str
                       END IF
                    END IF
                END FOR
                CALL readfile_channel.close()
                LET l_str="cat $TEMPDIR/",p_date CLIPPED,"/sqlerr_table_ds.log ",
                              "$TEMPDIR/",p_date CLIPPED,"/sqlerr_index_ds.log > ",
                              "$TEMPDIR/",p_date CLIPPED,"/sqlerr_ds.log"
                RUN l_str
                LET l_str="test -s $TEMPDIR/",p_date CLIPPED,"/sqlerr_ds.log"
                RUN l_str RETURNING l_str
                IF l_str!=0 THEN
                   IF p_db_type="IFX" THEN
                      RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                   ELSE
                      RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                   END IF
                   DISPLAY "ds無異常更新成功!"
#                   DISPLAY "ds以外的資料庫請手動執行$TEMPDIR/",p_date CLIPPED,
#                           "/cmd4nds.sql來更新!"
#                   LET l_str="cmd4nds.sh $TEMPDIR/",p_date CLIPPED,"/command.sql"
#                   RUN l_str
                   EXIT WHILE
                ELSE
                   IF p_db_type="IFX" THEN
                      RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
                   ELSE
                      RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
                   END IF
                   LET l_str="chmod 777 $TEMPDIR/",p_date CLIPPED,"/sqlerr_table_ds.log"
                   RUN l_str
                   DISPLAY "ds更新出現異常!(請按enter鍵繼續)"
                   LET l_str="read;more $TEMPDIR/",p_date CLIPPED,"/sqlerr_table_ds.log"
                   RUN l_str
                   RUN "echo 1 >$TEMPDIR/result"
                   RUN "chmod 777 $TEMPDIR/result"
                   DISPLAY "請排除異常之後再次進行資料庫更新!"
                   DISPLAY "或參考$TEMPDIR/",p_date CLIPPED,
                           "/command.sql手動進行資料庫更新!"
                   EXIT WHILE
                END IF
             END IF
          END IF
       ELSE
          LET l_str="chmod 777 $TEMPDIR/",p_date CLIPPED,"/sqlerr.log"
          RUN l_str
          DISPLAY "測試更新出現異常!(請按enter鍵繼續)"
          LET l_str="read;more $TEMPDIR/",p_date CLIPPED,"/sqlerr.log"
          RUN l_str
          RUN "echo 1 >$TEMPDIR/result"
          RUN "chmod 777 $TEMPDIR/result"
          DISPLAY "請排除異常之後再次進行資料庫更新!"
          DISPLAY "或參考$TEMPDIR/",p_date CLIPPED,"/command.sql手動進行資料庫更新!"
          EXIT WHILE
       END IF
    END WHILE
END MAIN
