
MAIN
   DEFINE lc_dbtype    CHAR(3)
   DEFINE ls_sql       STRING
   DEFINE lc_idx       DYNAMIC ARRAY OF RECORD
             tab_name  VARCHAR(12),
             idx_name  VARCHAR(10),
             idx_col   VARCHAR(20)
                   END RECORD

   CASE lc_dbtype
      WHEN "ORA"
         LET ls_sql = " SELECT ic.table_name,ic.index_name,ic.column_name ",
                        " FROM user_indexes ix,user_ind_columns ic ",
                       " WHERE ic.index_name=ix.index_name "
                       " ORDER BY ic.table_name,ic.index_name,ic.column_name "
      WHEN "MSV"
         LET ls_sql = " select a.name,d.name,c.name ",
                        " from sys.objects a, sys.index_columns b, sys.columns c,sys.indexes d ",
                       " where a.object_id = b.object_id ",
                         " and a.object_id = c.object_id and b.column_id = c.column_id ",
                         " and a.object_id = d.object_id and b.index_id = d.index_id ",
                       " order by a.name,b.index_id,b.index_column_id "
   END CASE

   PREPARE diff_idx_pre FROM ls_sql
   DECLARE diff_idx_cs CURSOR WITH HOLD FOR diff_idx_pre

   LET li_cnt = 1
   FOREACH diff_idx_cs INTO lc_idx[li_cnt]
      IF g_zz1.zz01 IS NULL THEN
         RETURN
      END IF
   END FOREACH

END MAIN

