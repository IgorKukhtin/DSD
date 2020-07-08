-- Function: gpSelect_Replica_part11()

DROP FUNCTION IF EXISTS gpSelect_Replica_part11 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_part11(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Sort Integer, Value Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
   -- DELETE
   SELECT 11 AS Part, 1 AS Sort
      , ' WHEN table_update_data.Operation = ' || zfStr_CHR_39 ('DELETE')
          || ' THEN '
          || zfStr_CHR_39 ('DELETE FROM ')
          || ' || table_update_data.table_name || '
          || zfStr_CHR_39 (' WHERE ')
UNION SELECT 11, 2, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,1) <> '''' THEN table_update_data.table_name ||'|| zfStr_CHR_39 ('.') ||'|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,1) '
UNION SELECT 11, 3,
              '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica (table_update_data.pk_values,1)  ELSE '''' END'
UNION SELECT 11, 4, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,2) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.') ||'|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,2)'
UNION SELECT 11, 5,
              '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica (table_update_data.pk_values,2)  ELSE '''' END'
UNION SELECT 11, 6, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,3) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.') ||'|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,3)' 
UNION SELECT 11, 7,
              '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica (table_update_data.pk_values,3)  ELSE '''' END'
UNION SELECT 11, 8, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,4) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.') ||'|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,4)'
UNION SELECT 11, 9,
              '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica (table_update_data.pk_values,4)  ELSE '''' END'
          
       -- UPDATE
 UNION SELECT 11,10
      , ' WHEN table_update_data.Operation = ' || zfStr_CHR_39 ('UPDATE')
          || ' THEN '
          || zfStr_CHR_39 ('UPDATE ')
          || ' || table_update_data.table_name || '
          || zfStr_CHR_39 (' SET ')
UNION SELECT 11,11, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.upd_cols,1) <> '''' THEN  zfCalc_WordText_Split_replica (table_update_data.upd_cols,1)' 
UNION SELECT 11,12, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| ' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,1)  ELSE '''' END'
UNION SELECT 11,13, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.upd_cols,2) <> '''' THEN  '', '' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,2)' 
UNION SELECT 11,14, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| ' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,2)  ELSE '''' END'
UNION SELECT 11,15, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.upd_cols,3) <> '''' THEN '', '' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,3)' 
UNION SELECT 11,16, '' 
          '||'||zfStr_CHR_39 ( '=' )||'|| table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| ' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,3)  ELSE '''' END'
UNION SELECT 11,17, ''
          || '||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.upd_cols,4) <> '''' THEN '', '' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,4)'
UNION SELECT 11,18, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| ' || zfCalc_WordText_Split_replica (table_update_data.upd_cols,4)  ELSE '''' END'

UNION SELECT 11,19 ,
          '||'|| zfStr_CHR_39 (' WHERE ')
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,1) <> '''' THEN table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,1)'
UNION SELECT 11,20 ,''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,1) ELSE '''' END'
UNION SELECT 11,21, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,2) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,2)'
UNION SELECT 11,22, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,2) ELSE '''' END'
UNION SELECT 11,23, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,3) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,3)'
UNION SELECT 11,24, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,3) ELSE '''' END'
UNION SELECT 11,25, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,4) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,4)'
UNION SELECT 11,26, ''          
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,4) ELSE '''' END'


          -- INSERT
UNION SELECT 11,30, 
             ' WHEN table_update_data.Operation = ' || zfStr_CHR_39 ('INSERT')
          || ' THEN '
          || zfStr_CHR_39 ('INSERT INTO ')
          || ' || table_update_data.table_name  ||'' (''|| tmpColumn.COLUMN_NAME || '') VALUES (''|| tmpColumn.COLUMN_NAME_full||'')'''
UNION SELECT 11,31,
         '||'|| zfStr_CHR_39 (' WHERE ')
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,1) <> '''' THEN table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,1)'
UNION SELECT 11,32 ,''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,1) ELSE '''' END'
UNION SELECT 11,33, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,2) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,2)'
UNION SELECT 11,34, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,2) ELSE '''' END'
UNION SELECT 11,35, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,3) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,3)'
UNION SELECT 11,36, ''
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,3) ELSE '''' END'
UNION SELECT 11,37, ''
          || '|| CASE WHEN zfCalc_WordText_Split_replica (table_update_data.pk_keys,4) <> '''' THEN zfStr_CHR_39 (''AND'') ||table_update_data.table_name ||'|| zfStr_CHR_39 ('.')|| '|| zfCalc_WordText_Split_replica (table_update_data.pk_keys,4)'
UNION SELECT 11,38, ''          
          '||'||zfStr_CHR_39 ( '=' )||'|| zfCalc_WordText_Split_replica(table_update_data.pk_values,4) ELSE '''' END'
   /*FROM (SELECT DISTINCT Operation, table_name, upd_cols, pk_keys--, pk_values
         FROM _replica.table_update_data AS tmp
         WHERE tmp.Id BETWEEN inId_start AND inId_end
         ) AS table_update_data
         LEFT JOIN gpSelect_Replica_Column(inId_start,inId_end) AS tmpColumn ON tmpColumn.Table_Name = table_update_data.Table_Name*/

order by 1,2
   ;
     
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 04.07.20          *

*/
-- ÚÂÒÚ
--SELECT * FROM gpSelect_Replica_part11(507180, 907184)


---||CASE WHEN zfCalc_WordText_Split_replica (table_update_data.upd_cols,2) <> '' THEN  ', '|| zfCalc_WordText_Split_replica (table_update_data.upd_cols,2)