##################################################
# Description  	: 客戶客製更新
# Date & Author : 2007/10/01 by saki
# Parameter   	: 
# Return   	: 
# Memo        	:
##################################################
DATABASE ds

DEFINE   g_dir        STRING
DEFINE   g_db_type    CHAR(3)
DEFINE   g_dbspace    CHAR(10)
DEFINE   g_tempdir    STRING
DEFINE   g_do_rebuild CHAR(1)
DEFINE   g_syspass    STRING
DEFINE   g_systempass STRING
DEFINE   g_dbpass     STRING
DEFINE   g_doc_upload CHAR(1)

MAIN
   DEFINE   readfile_channel   base.channel
   DEFINE   p_str         STRING
   DEFINE   l_str         STRING
   DEFINE   l_rec_b       SMALLINT
   DEFINE   l_max_rec     SMALLINT
   DEFINE   l_result      SMALLINT
   DEFINE   l_result_idx  SMALLINT
   DEFINE   l_cust        STRING
   DEFINE   l_cmd         STRING
   DEFINE   l_sql         STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_result     STRING
   DEFINE   l_char        CHAR(1)
   DEFINE   ls_module     STRING
   DEFINE   ls_dir        STRING
   DEFINE   ls_prog       STRING
   DEFINE   li_index      SMALLINT
   DEFINE   li_index2     SMALLINT
   DEFINE   lr_prog       DYNAMIC ARRAY OF RECORD
               prog_name  STRING
                          END RECORD
   DEFINE   li_cnt        INTEGER
   DEFINE   l_database    DYNAMIC ARRAY OF RECORD
                          patch   CHAR(1),
                          backup  CHAR(1),
                          name    CHAR(20) 
                          END RECORD
   DEFINE   l_n           SMALLINT
   DEFINE   l_i           SMALLINT
   DEFINE   l_ac          SMALLINT
   DEFINE   ls_pathname   STRING
    

   DEFER INTERRUPT

   WHENEVER ERROR CONTINUE

   LET g_db_type=DB_GET_DATABASE_TYPE()
   LET p_str = ARG_VAL(1)
   LET g_syspass    = "change_on_install"
   LET g_systempass = "manager"
   
   IF p_str IS NULL THEN
      DISPLAY 'ex. $FGLRUN patch 051102170822'
      RETURN
   END IF
   PROMPT 'Input tablespace:' FOR g_dbspace
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
   IF g_dbspace IS NULL THEN
      LET g_dbspace="dbs1"
   END IF
   CALL fgl_getenv("TEMPDIR") RETURNING g_tempdir
   LET g_dir = p_str

   IF g_db_type="ORA" THEN
      CALL patch_get_custpass(null)
   END IF

   #No:FUN-840067 --start-- 相關文件上傳詢問
   LET l_cmd = "test -s gca_file.txt"
   RUN l_cmd RETURNING l_result
   IF NOT l_result THEN
      PROMPT 'Would you upload related document of this develop number? (Y/N)' FOR g_doc_upload
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         RETURN
      END IF
      LET g_doc_upload = UPSHIFT(g_doc_upload)
      IF g_doc_upload != "Y" OR g_doc_upload IS NULL THEN
         LET g_doc_upload = "N"
      END IF
   END IF
   #No:FUN-840067 ---end---

   # qazzaq function - schema produce
   LET l_cmd="test -s patch_cust_command" 
   RUN l_cmd RETURNING l_result
   IF l_result = 0 THEN
      IF FGL_GETENV("FGLPROFILE") IS NULL THEN
         DISPLAY "無FGLPROFILE環境變數, 無法繼續更新"
         RETURN
      END IF
      IF g_db_type="IFX" THEN
         LET l_sql="SELECT azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                   " AND azp03 in (select name from sysdatabases)"
         DATABASE sysmaster
      ELSE
         LET l_sql="SELECT azp03 FROM azp_file WHERE azp053='Y' AND azp03!='ds' ",
                   " AND UPPER(azp03) in (select username from all_users)"
      END IF
      DECLARE patch_sel_db CURSOR FROM l_sql
      LET l_database[1].name="ds"
      LET l_database[1].backup='Y'
      LET l_database[1].patch='Y'
      LET l_i=2
      FOREACH patch_sel_db INTO l_database[l_i].name
         LET l_database[l_i].backup='N'
         LET l_database[l_i].patch='N'
         -- ds重覆就不再放了
         IF l_database[l_i].name != 'ds' THEN 
            LET l_i=l_i+1
         END IF
      END FOREACH
      IF g_db_type="IFX" THEN
         DATABASE ds
      END IF
      CALL l_database.deleteElement(l_i)
      OPEN WINDOW db_backup AT 10,10 WITH FORM "patch_cust.42f"
      CLOSE WINDOW screen      

      INPUT ARRAY l_database WITHOUT DEFAULTS FROM s_check.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=l_max_rec,UNBUFFERED)
          BEFORE INPUT
              CALL fgl_set_arr_curr(l_ac)

          BEFORE ROW
              LET l_ac = ARR_CURR()
              LET l_n  = ARR_COUNT()

# 測試期間不備份
#         BEFORE FIELD a
#             IF l_database[l_ac].name="ds" THEN
#                NEXT FIELD azp03
#             END IF
      END INPUT
      CLOSE WINDOW db_backup
      IF INT_FLAG=1 THEN
         DISPLAY "patch中斷!!"
         RETURN
      END IF
      
      FOR l_i=1 TO l_database.getLength()
      IF l_database[l_i].patch='Y' THEN
         IF g_db_type="IFX" THEN
         DATABASE sysmaster
            IF SQLCA.SQLCODE THEN
               DISPLAY SQLCA.SQLCODE,"切換資料庫發生錯誤,異常中止!!"
               EXIT PROGRAM
            END IF
            select count(*) INTO l_n 
              from sysdatabases
             where name=l_database[l_i].name
            IF l_n=0 THEN
               CONTINUE FOR
            END IF
         ELSE
            SELECT COUNT(1) INTO l_n
              FROM all_users 
             WHERE lower(username)=l_database[l_i].name
            IF l_n=0 THEN
               DISPLAY l_database[l_i].name CLIPPED,"不存在，略過不予處理!!"
               CONTINUE FOR
            END IF
         END IF
         IF l_database[l_i].backup='Y' THEN
            CALL gencmd(l_database[l_i].name)
         ELSE
            RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.qaz"
            RUN "chmod 777 $TEMPDIR/fglprofile.qaz"
            LET l_str=g_tempdir CLIPPED,"/fglprofile.script"
            LET readfile_channel=base.channel.create()
            CALL readfile_channel.setdelimiter("")
            CALL readfile_channel.openfile(l_str CLIPPED, "w" )
            CALL readfile_channel.write("ex $TEMPDIR/fglprofile.qaz <<%%")
            CALL readfile_channel.write("g/ds2\.source")
            CALL readfile_channel.write("-1")
            CALL readfile_channel.write("a")
            
            CALL readfile_channel.write('dbi.database.qazzaq.source= "`echo ${ORACLE_SID}`" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.username= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.password= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.schema= "qazzaq" ## DVM320')
            CALL readfile_channel.write('dbi.database.qazzaq.ora.prefetch.rows = 1 # Add by Raymon 02/02')
            CALL readfile_channel.write("")
            CALL readfile_channel.write(".")
            CALL readfile_channel.write("w")
            CALL readfile_channel.write("q")
            CALL readfile_channel.write("%%")
            CALL readfile_channel.close() 
            RUN "chmod 777 $TEMPDIR/fglprofile.script"
            RUN "$TEMPDIR/fglprofile.script"
         END IF
         IF g_db_type='IFX' THEN
            LET l_cmd="$FGLRUN execmd_cust.42r ",g_db_type CLIPPED," ",
                      g_dir CLIPPED," ",l_database[l_i].name CLIPPED," ",
                      l_database[l_i].backup
            RUN l_cmd
         ELSE
            LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;$FGLRUN execmd_cust.42r ",g_db_type CLIPPED," ",g_dir CLIPPED," ",l_database[l_i].name CLIPPED," ",l_database[l_i].backup
display l_cmd
            RUN l_cmd
         END IF
         IF l_database[l_i].name='ds' THEN
            LET l_cmd = "test -s $TEMPDIR/",g_dir CLIPPED,"/sqlerr_ds.log"
            RUN l_cmd RETURNING l_result
            IF not l_result THEN
               DISPLAY 'ds資料庫未更新,程式資料不可更新'
               IF g_db_type="ORA" THEN
                  LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;rm $FGLPROFILE"
                  RUN l_cmd
               END IF
               RETURN
            END IF
         END IF
      END IF
      END FOR
DATABASE ds
       IF g_db_type="ORA" THEN
          LET l_cmd="export FGLPROFILE=$TEMPDIR/fglprofile.qaz;rm $FGLPROFILE"
          RUN l_cmd
       END IF
       IF g_db_type="IFX" THEN
          RUN "cd $FGLDBPATH;fgldbsch -db ds -ie"
       ELSE
          RUN "cd $FGLDBPATH;fgldbsch -db ds -ow ds -ie"
       END IF
      #將zs資料匯入
      LOAD FROM "patch_zs_file.txt" INSERT INTO zs_file
      IF SQLCA.sqlcode THEN
         DISPLAY "檔案修改記錄無法正確匯入，請手動利用patch_zs_file.txt資料匯入"
      ELSE
         DISPLAY "匯入 ",SQLCA.sqlerrd[3]," 筆檔案修改記錄"
      END IF
   ELSE
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openPipe("pwd","r")
      WHILE lc_channel.read(ls_pathname)
      END WHILE
      CALL lc_channel.close()
      LET ls_pathname = ls_pathname.subString(ls_pathname.getLength()-3,ls_pathname.getLength())
      IF ls_pathname = "_tab" THEN
         DISPLAY '無法辨別此patch要處理schema或是程式資料, 請與打包人員確認'
         RETURN
      END IF

      # Data upload
      CALL patch_data_start()

      IF g_db_type='IFX' THEN
         LET l_cmd="$FGLRUN patch_load_custdata.42r ",g_dir," ",g_dbspace," customer"
         RUN l_cmd
      ELSE
         LET l_cmd="FGLPROFILE=$FGLDIR/etc/fglprofile.custtemp;export FGLPROFILE;$FGLRUN patch_load_custdata.42r ",g_dir," ",g_dbspace," customer;rm $FGLPROFILE"
         RUN l_cmd
      END IF

      DATABASE ds
      IF SQLCA.SQLCODE THEN
         DISPLAY "資料庫切換錯誤,無法切回ds資料庫"
      END IF

      LET l_cmd= "test -s $TEMPDIR/",g_dir,".log" 
      RUN l_cmd RETURNING l_result
      IF NOT l_result THEN
         DISPLAY "資料上載到DB時曾產生錯誤, 請查看$TEMPDIR下的",g_dir,".log檔"
      ELSE
         DISPLAY "資料上載成功"
      END IF
      CALL patch_delete_custtemp()

      #No:FUN-840067 --start-- 上傳相關文件
      IF g_doc_upload = "Y" THEN
         CALL patch_upload_related_document()
      END IF
      #No:FUN-840067 ---end---

      # Source upload
      LET l_cust = FGL_GETENV("CUST")
      LET l_cmd = "cp ",g_dir,"_source.tar ",l_cust,
                  ";cd ",l_cust,";tar xvf ",g_dir,"_source.tar;rm ",
                   l_cust,"/",g_dir,"_source.tar"
      RUN l_cmd

      LET lc_channel = base.Channel.create()
      LET l_cmd = "tar tvf ",g_dir,"_source.tar|awk '{print $NF}'"
      CALL lc_channel.openPipe(l_cmd,"r")

      LET li_cnt = 1
      CALL lr_prog.clear()
      WHILE (lc_channel.read(ls_result))
         LET li_index = ls_result.getIndexOf("/",1)
         LET ls_module = ls_result.subString(1,li_index-1)
         IF ls_module.equals("config") THEN
            CONTINUE WHILE
         END IF
         LET li_index2 = ls_result.getIndexOf("/",li_index + 1)
         LET ls_dir = ls_result.subString(li_index+1,li_index2-1)
         LET li_index = ls_result.getIndexOf("." || ls_dir,li_index2 + 1)
         LET ls_prog = ls_result.subString(li_index2+1,li_index -1)
         IF (ls_module IS NULL) OR (ls_dir IS NULL) OR (ls_prog IS NULL) THEN
            CONTINUE WHILE
         END IF
         IF ls_dir = "4gl" THEN
            LET l_cmd = "cd ",l_cust,"/",ls_module,"/4gl;r.c2 ",ls_prog
            RUN l_cmd
         END IF
         IF ls_dir = "4fd" THEN
            LET l_cmd = "cd ",l_cust,"/",ls_module,"/4fd;r.f2 ",ls_prog
            RUN l_cmd
         END IF
         LET lr_prog[li_cnt].prog_name = ls_prog
         LET li_cnt = li_cnt + 1
      END WHILE
      CALL lr_prog.deleteElement(li_cnt)

      IF g_do_rebuild = "Y" THEN
         CALL patch_rebuild_lib("lib")
         CALL patch_rebuild_lib("sub")
         CALL patch_rebuild_lib("qry")
      END IF

      FOR li_cnt = 1 TO lr_prog.getLength()
          LET l_cmd = "r.l2 ",lr_prog[li_cnt].prog_name
          RUN l_cmd
      END FOR
      CALL lc_channel.close()
      
      # Data上載結果 
      IF NOT l_result THEN
         DISPLAY "資料上載到DB時曾產生錯誤, 請查看$TEMPDIR下的",g_dir,".log檔"
         RETURN
      ELSE
         DISPLAY "資料上載成功"
      END IF
      DISPLAY "更新完畢"
   END IF
END MAIN

FUNCTION patch_data_start()
   DEFINE   l_str        STRING
   DEFINE   readfile_channel   base.Channel


   IF g_db_type = "ORA" THEN
      RUN "cp $FGLPROFILE $FGLDIR/etc/fglprofile.custtemp"
      RUN "chmod 777 $FGLDIR/etc/fglprofile.custtemp"
      CALL fgl_getenv("TEMPDIR") RETURNING l_str
      LET l_str=l_str CLIPPED,"/fglprofile2.script"
      LET readfile_channel=base.channel.create()
      CALL readfile_channel.setdelimiter("")
      CALL readfile_channel.openfile(l_str CLIPPED, "w" )
      CALL readfile_channel.write("ex $FGLDIR/etc/fglprofile.custtemp <<%%")
      CALL readfile_channel.write("g/ds2\.source")
      CALL readfile_channel.write("-1")
      CALL readfile_channel.write("a")
      
      CALL readfile_channel.write('dbi.database.custtemp.source= "`echo ${ORACLE_SID}`" ## DVM320')
      CALL readfile_channel.write('dbi.database.custtemp.username= "custtemp" ## DVM320')
      CALL readfile_channel.write('dbi.database.custtemp.password= "custtemp" ## DVM320')
      CALL readfile_channel.write('dbi.database.custtemp.schema= "custtemp" ## DVM320')
      CALL readfile_channel.write('dbi.database.custtemp.ora.prefetch.rows = 1 # Add by Raymon 02/02')
      CALL readfile_channel.write("")
      CALL readfile_channel.write(".")
      CALL readfile_channel.write("w")
      CALL readfile_channel.write("q")
      CALL readfile_channel.write("%%")
      CALL readfile_channel.close() 
      RUN "chmod 777 $TEMPDIR/fglprofile2.script"
      RUN "$TEMPDIR/fglprofile2.script"
   END IF

END FUNCTION

FUNCTION patch_rebuild_lib(p_dir)
   DEFINE   p_dir        STRING
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   ls_top_path  STRING
   DEFINE   ls_prog      STRING
   DEFINE   ls_path      STRING
   DEFINE   li_s_inx     SMALLINT
   DEFINE   li_e_inx     SMALLINT

   LET ls_cmd = "r.gx ",p_dir
   RUN ls_cmd
END FUNCTION

FUNCTION patch_delete_custtemp()
   DEFINE l_cmd    STRING   #FUN-730047

   DISPLAY "刪除資料暫存的資料庫,依資料庫的大小時間會為之增減,請耐心等候..."
   IF g_db_type='IFX' THEN
      RUN "echo 'drop database custtemp'|dbaccess > /dev/null 2>&1"
   ELSE
     #LET l_cmd = "echo ""conn sys/", g_syspass ,"@$ORACLE_SID as sysdba\ndrop user custtemp cascade;""|sqlplus /nolog > /dev/null 2>&1"      #FUN-730047   #FUN-750075 mark
      LET l_cmd = "echo 'drop user patchtemp cascade;'|sqlplus system/", g_systempass , " > /dev/null 2>&1"  #FUN-750075
      RUN l_cmd   #FUN-730047
   END IF
END FUNCTION

FUNCTION gencmd(p_database)
define readfile_channel   base.channel,
       l_str              string,
       l_right            char(1),
       l_i                integer,
       l_j                integer,
       l_k                integer,
       x                  smallint,
       l_std_max          integer,
       l_cus_max          integer,
       l_loop             char(1),
       l_tabname          char(20),
       l_tabn_chk  record
                   a  char(5),
                   b  char(4)
                   end record,
       p_database  char(20)


#產生shell要將ds複製一份出來模擬
    IF g_db_type='IFX' THEN
       LET l_str=g_tempdir CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       CALL readfile_channel.write("cd $TOP/tmp")
       CALL readfile_channel.write("if [[ -d qazzaq.exp ]] then")
       CALL readfile_channel.write("rm -rf qazzaq.exp")
       CALL readfile_channel.write("fi")
       LET l_str="if [[ -d ",p_database CLIPPED,".exp ]] then"
       CALL readfile_channel.write(l_str)
       LET l_str="rm -rf ",p_database CLIPPED,".exp"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("fi")
       CALL readfile_channel.write('echo "select name from sysdatabases"|dbaccess sysmaster|grep qazzaq > /dev/null 2>&1')
       CALL readfile_channel.write("if [[ $? = 0 ]] then")
       CALL readfile_channel.write('echo "drop database qazzaq"|dbaccess > /dev/null 2>&1')
       CALL readfile_channel.write("fi")
       CALL readfile_channel.write("export DBDATE=Y4MD/")
       LET l_str="dbexport ",p_database CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="ex $TOP/tmp/",p_database CLIPPED,".exp/",
                 p_database CLIPPED,".sql <<%%"
       CALL readfile_channel.write(l_str)
       LET l_str="g/DATABASE ",p_database CLIPPED,"/s//DATABASE qazzaq/g"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("wq")
       CALL readfile_channel.write("%%")
       LET l_str="mv $TOP/tmp/",p_database CLIPPED,".exp/",p_database CLIPPED,
                 ".sql $TOP/tmp/",p_database CLIPPED,".exp/qazzaq.sql"
       CALL readfile_channel.write(l_str)
       LET l_str="mv ",p_database CLIPPED,".exp qazzaq.exp"
       CALL readfile_channel.write(l_str)
       LET l_str="dbimport qazzaq -d ",g_dbspace CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="mv qazzaq.exp ",p_database CLIPPED,".exp"
       CALL readfile_channel.write(l_str)
       LET l_str="mv $TOP/tmp/",p_database CLIPPED,".exp/qazzaq.sql $TOP/tmp/",
                 p_database CLIPPED,".exp/",p_database CLIPPED,".sql"
       CALL readfile_channel.write(l_str)
       LET l_str="ex $TOP/tmp/",p_database CLIPPED,".exp/",
                 p_database CLIPPED,".sql <<%%"
       CALL readfile_channel.write(l_str)
       LET l_str="g/DATABASE qazzaq/s//DATABASE ",p_database CLIPPED,"/g"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("wq")
       CALL readfile_channel.write("%%")
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/exp.sh"
CLOSE DATABASE
       RUN "$TEMPDIR/exp.sh"
    ELSE
       CALL patch_get_custpass(p_database)     #FUN-730047
       LET l_str=g_tempdir CLIPPED,"/exp.sh"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("#!/bin/ksh")
       LET l_str="#up_priv.sh ",p_database CLIPPED
       CALL readfile_channel.write(l_str)
       LET l_str="exp ",p_database CLIPPED,"/",g_dbpass CLIPPED,"@$ORACLE_SID", #FUN-6B0082  #FUN-730047
                 " owner=",p_database CLIPPED," file='",g_tempdir CLIPPED,
                 "/",p_database CLIPPED,".dmp' direct=y"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       CALL readfile_channel.write("conn system/" || g_systempass || "@`echo $ORACLE_SID`;")   #FUN-730047
       CALL readfile_channel.write("drop user qazzaq cascade")
       CALL readfile_channel.write("create user qazzaq identified by qazzaq")
       LET l_str="default tablespace ",g_dbspace CLIPPED
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("temporary tablespace temp;")
       CALL readfile_channel.write("grant create session,create table to qazzaq;")
       CALL readfile_channel.write("grant resource to qazzaq;")
       CALL readfile_channel.write("grant create synonym to qazzaq;")
       CALL readfile_channel.write("conn sys/" ||  g_syspass || "@`echo $ORACLE_SID` as sysdba;")  #FUN-730047   
       CALL readfile_channel.write("grant select on sys.v_\\$session to qazzaq;")  
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       LET l_str="w! ",g_tempdir CLIPPED,"/createdb.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("ex - <<%%")
       CALL readfile_channel.write("a")
       CALL readfile_channel.write("conn qazzaq/qazzaq@`echo $ORACLE_SID`;")
       CALL readfile_channel.write("@alterazo;")
       CALL readfile_channel.write("exit;")
       CALL readfile_channel.write(".")
       LET l_str="w! ",g_tempdir CLIPPED,"/createdb1.sql"
       CALL readfile_channel.write(l_str CLIPPED)
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.write("sqlplus system/" || g_systempass || "@$ORACLE_SID < $TEMPDIR/createdb.sql") #FUN-730047
       CALL readfile_channel.write("cd $TOP/ora/work")
       LET l_str="imp system/",g_systempass ,"@$ORACLE_SID fromuser=",p_database CLIPPED,          #FUN-6B0082   #FUN-730047
                 " touser=qazzaq file='",g_tempdir CLIPPED,"/",p_database CLIPPED,".dmp' ignore=y"
       CALL readfile_channel.write(l_str)
       CALL readfile_channel.write("sqlplus system/" || g_systempass || "@$ORACLE_SID < $TEMPDIR/createdb1.sql")    #FUN-730047
#       CALL readfile_channel.write("rm -f $TEMPDIR/createdb.sql $TEMPDIR/createdb1.sql")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/exp.sh"
       RUN "$TEMPDIR/exp.sh"
       RUN "chmod 777 $TEMPDIR/createdb.sql"
       RUN "chmod 777 $TEMPDIR/createdb1.sql"
       RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.qaz"
       RUN "chmod 777 $TEMPDIR/fglprofile.qaz"
       LET l_str=g_tempdir CLIPPED,"/fglprofile.script"
       LET readfile_channel=base.channel.create()
       CALL readfile_channel.setdelimiter("")
       CALL readfile_channel.openfile(l_str CLIPPED, "w" )
       CALL readfile_channel.write("ex $TEMPDIR/fglprofile.qaz <<%%")
       CALL readfile_channel.write("g/ds2\.source")
       CALL readfile_channel.write("-1")
       CALL readfile_channel.write("a")
       
       CALL readfile_channel.write('dbi.database.qazzaq.source= "`echo ${ORACLE_SID}`" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.username= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.password= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.schema= "qazzaq" ## DVM320')
       CALL readfile_channel.write('dbi.database.qazzaq.ora.prefetch.rows = 1 # Add by Raymon 02/02')
       CALL readfile_channel.write("")
       CALL readfile_channel.write(".")
       CALL readfile_channel.write("w")
       CALL readfile_channel.write("q")
       CALL readfile_channel.write("%%")
       CALL readfile_channel.close() 
       RUN "chmod 777 $TEMPDIR/fglprofile.script"
       RUN "$TEMPDIR/fglprofile.script"
    END IF
END FUNCTION
FUNCTION patch_index(p_dir)
DEFINE readfile_channel   base.channel,
       tok                base.StringTokenizer,
       l_str              CHAR(1000),
       l_right            CHAR(1),
       l_std              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          command char(1000),
                          check  char(1)
                          end record,
       l_cus              dynamic array of record
                          idxname char(20),
                          unique  char(1),
                          columns char(400), 
                          tabname char(15),
                          command char(1000),
                          check  char(1)
                          end record,
       l_cus_max          INTEGER,
       l_std_max          INTEGER,
       l_i                INTEGER,
       l_j                INTEGER,
       l_k                INTEGER,
       l_length           SMALLINT,
       l_command_max      INTEGER,
       l_command          dynamic array of varchar(1000),
       p_dir              STRING

    LET l_str="$FGLRUN gen_index.42r ds;diff $FGLDBPATH/ds_idx.sch std_idx.sch >$TEMPDIR/",p_dir,"/diff_idx.out;chmod 777 $TEMPDIR/",p_dir,"/diff_idx.out"
    RUN l_str
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",p_dir,"/diff_idx.out" 
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
    LET l_str=l_str CLIPPED,"/",p_dir,"/diff_idx.out"
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
                     LET l_command[l_k]="drop index ",l_cus[l_j].idxname CLIPPED
                     LET l_k=l_k+1
                     IF l_std[l_i].unique='U' THEN
                        LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                     ELSE
                        LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                     END IF
                     LET l_k=l_k+1
                  END IF
               ELSE
                  LET l_command[l_k]="drop index ",l_cus[l_j].idxname CLIPPED
                  LET l_k=l_k+1
                  IF l_std[l_i].unique='U' THEN
                     LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
                  ELSE
                     LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
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
              LET l_command[l_k]="create unique index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
           ELSE
              LET l_command[l_k]="create index ",l_std[l_i].idxname CLIPPED," on ",l_std[l_i].tabname CLIPPED,"(",l_std[l_i].columns CLIPPED,")"
           END IF
           LET l_k=l_k+1
        END IF
    END FOR
    LET l_command_max=l_k-1
                     
    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_dir,"/index"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        CALL readfile_channel.write(l_command[l_k] CLIPPED)
        display l_command[l_k] CLIPPED
    END FOR
    CALL readfile_channel.close()

    LET readfile_channel=base.channel.create()
    CALL readfile_channel.setdelimiter("")
    CALL fgl_getenv("TEMPDIR") RETURNING l_str
    LET l_str=l_str CLIPPED,"/",g_dir,"/index.sql"
    CALL readfile_channel.openfile(l_str CLIPPED, "w" )
    FOR l_k=1 TO l_command_max
        LET l_command[l_k]=l_command[l_k] CLIPPED,';'
        CALL readfile_channel.write(l_command[l_k] CLIPPED)
        display l_command[l_k] CLIPPED
    END FOR
    CALL readfile_channel.close()

END FUNCTION

FUNCTION patch_get_custpass(dbname)   #FUN-730047
  DEFINE lch_file       base.channel
  DEFINE l_fname        STRING
  DEFINE l_plist        STRING
  DEFINE l_db_buf       STRING
  DEFINE l_pass_buf     STRING
  DEFINE dbname         STRING

  LET dbname = dbname.trim()   

  IF dbname <> " " THEN                       #Set default value
    LET g_dbpass = dbname              
  END IF

  LET l_fname = FGL_GETENV("TOP")
  LET l_fname = l_fname,"/ds4gl2/bin/plist"

  LET lch_file = base.channel.create()
  CALL lch_file.openFile(l_fname,"r")
  IF STATUS THEN
     CALL lch_file.close()
     CALL patch_load_profile(dbname)   #FUN-740019 
  ELSE
     WHILE lch_file.read(l_plist)
       IF l_plist.getIndexOf(":",1) THEN                
          LET l_db_buf = l_plist.subString(1,l_plist.getIndexOf(":",1)-1)
          LET l_db_buf = l_db_buf.trim()
          LET l_pass_buf = l_plist.subString(l_plist.getIndexOf(":",1)+1,l_plist.getLength())
          LET l_pass_buf = l_pass_buf.trim()

          IF l_db_buf = "sys" THEN
             LET g_syspass = l_pass_buf
          END IF

          IF l_db_buf = "system" THEN
             LET g_systempass = l_pass_buf
          END IF

          IF dbname IS NOT NULL THEN
             IF l_db_buf = dbname THEN 
                 LET g_dbpass = l_pass_buf
             END IF
          END IF
       END IF 
     END WHILE
     CALL lch_file.close()
  END IF
 
END FUNCTION

FUNCTION patch_load_profile(p_dbname)   #FUN-740019 
  DEFINE l_cmd          STRING
  DEFINE p_dbname       STRING
  DEFINE lch_file       base.channel
  DEFINE l_fname        STRING
  DEFINE l_plist        STRING

  LET l_cmd = "grep " || p_dbname || ".password $FGLPROFILE|cut -d \\"" -f2 > /tmp/passtemp "
  RUN l_cmd

  LET l_fname = "/tmp/passtemp"

  LET lch_file = base.channel.create()
  CALL lch_file.openFile(l_fname,"r")
  IF STATUS THEN
     CALL lch_file.close()
  ELSE
     WHILE lch_file.read(l_plist)
       LET l_plist = l_plist.trim()
       LET g_dbpass = l_plist
     END WHILE
     CALL lch_file.close()
  END IF

END FUNCTION

#No:FUN-840067 --start--
FUNCTION patch_upload_related_document()
   
END FUNCTION
#No:FUN-840067 ---end---
