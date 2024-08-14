##################################################
# Description  	: Drop ds_report Temp tables (1 day ago)
# Date & Author : 2008/09/11 by jacklai
# Parameter   	: l_interval1 (days)
# Return        : none
# Usage        	: $FGLRUN drop_ds_report_temptable 1
# Modify        : No:FUN-880111 08/09/11 By jacklai Drop ds_report Temp tables (1 day ago)
# Modify        : No:TQC-890062 08/09/30 By jacklai 修正在Oracle 10g 上會因為開啟recycle bin機制而導致程式執行中斷
# Modify        : No:TQC-9A0083 09/10/15 By jacklai Oracle 10g在刪除Temp tables前需先執行PURGE RECYCLEBIN
# Modify        : No:XXXXXXXXXX 09/06/23 By jacklai 支援MSV版
##################################################

DATABASE ds

MAIN
  DEFINE l_dbtype     STRING
  DEFINE l_sql        STRING
  DEFINE l_dropsql    STRING
  DEFINE l_rec        RECORD
         l_tablename  VARCHAR(128),
         l_created    DATE
  END RECORD
  DEFINE l_interval1  INTERVAL DAY(5) TO DAY
  DEFINE l_interval2  INTERVAL DAY(5) TO DAY
  DEFINE l_version    VARCHAR(128)          #No:TQC-890062
  DEFINE l_tok        base.StringTokenizer  #No:TQC-890062
  DEFINE l_vermaj     INTEGER               #No:TQC-890062
  #DEFINE l_RecycleOff STRING                #No:TQC-890062
  
  WHENEVER ERROR CONTINUE #No:TQC-890062
  
  CLOSE DATABASE
  DATABASE ds_report
	
  #command line argument[1]: days (default: 1)
  IF NUM_ARGS() >= 1 THEN
    LET l_interval1 = ARG_VAL(1)
  ELSE
    LET l_interval1 = "1"
  END IF
  
  #get information of tables from database 
  LET l_dbtype = DB_GET_DATABASE_TYPE()
  CASE l_dbtype
  WHEN "ORA"
    #No:TQC-890062 --start--
    #Get Oracle version
    PREPARE pre0 FROM "SELECT VERSION FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle%'"
    DECLARE cur0 CURSOR FOR pre0
    OPEN cur0
    FETCH cur0 INTO l_version
    CLOSE cur0
    LET l_tok = base.StringTokenizer.create(l_version, ".")
    #get major version number
    IF l_tok.hasMoreTokens() THEN
      LET l_vermaj = l_tok.nextToken()
    END IF
    #No:TQC-890062 --end--
    LET l_sql = "SELECT OBJECT_NAME, CREATED FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' ORDER BY OBJECT_NAME"
  WHEN "IFX"
    LET l_sql = "SELECT TABNAME, CREATED FROM SYSTABLES WHERE TABID >= 100 AND TABTYPE='T' ORDER BY TABNAME"
  WHEN "MSV"    #090623
    LET l_sql = "SELECT name, create_date FROM sys.tables ORDER BY create_date, name"   #090623
  END CASE
  
  #No:TQC-890062 --start--
  #在oracle 10g以上版本在刪除Table前要關閉RecycleBin功能
  IF l_dbtype = "ORA" AND l_vermaj >= 10 THEN
    EXECUTE IMMEDIATE "PURGE USER_RECYCLEBIN"  #NO.TQC-9A0083
    EXECUTE IMMEDIATE "ALTER SESSION SET RECYCLEBIN=OFF"
  END IF
  #No:TQC-890062 --end--
  
  PREPARE pre1 FROM l_sql
  DECLARE cur1 CURSOR FOR pre1
  FOREACH cur1 INTO l_rec.*
    IF STATUS == NOTFOUND THEN
      EXIT FOREACH
    END IF
    LET l_interval2 =  CURRENT YEAR TO DAY - l_rec.l_created
    
    IF l_interval2 > l_interval1 THEN
      LET l_dropsql = "DROP TABLE ",l_rec.l_tablename
      EXECUTE IMMEDIATE l_dropsql
      IF SQLCA.SQLCODE THEN
        ERROR l_dropsql," ERROE: ",SQLCA.SQLCODE
      ELSE
        DISPLAY l_dropsql," OK."
      END IF
    END IF
  END FOREACH
  
  CLOSE DATABASE
END MAIN
