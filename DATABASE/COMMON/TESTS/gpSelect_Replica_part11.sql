-- Function: gpSelect_Replica_part11()

DROP FUNCTION IF EXISTS gpSelect_Replica_part11 (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_part11(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (Part Integer, Sort Integer, Value Text
-- , Operation TEXT, table_name TEXT, upd_cols TEXT, pk_keys TEXT
) AS
$BODY$
BEGIN

   RETURN QUERY 
select 11, 1
      , case when a.operation ILIKE 'update'
                then ' when ' || zfStr_CHR_39 (a.Operation || '-' || a.table_name || '-' || a.upd_cols || '-' || a.pk_keys) || ' THEN '
                 ||  zfStr_CHR_39 ('update ' || a.table_name || ' SET ' || zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' = ')
                 || '||'
                 || a.table_name || '.' || zfCalc_WordText_Split_replica (a.upd_cols, 1) || ' :: TVarChar || '
                 || zfStr_CHR_39 (' where ' || zfCalc_WordText_Split_replica (a.pk_keys, 1)  || ' = ')
                 || '||'
                 || a.table_name || '.' || zfCalc_WordText_Split_replica (a.pk_keys, 1)|| ' :: TVarChar '
       end :: Text as res
--       ,a.Operation, a.table_name, a.upd_cols, a.pk_keys
-- , *
from
( SELECT DISTINCT tmp.Operation, tmp.table_name, tmp.upd_cols, tmp.pk_keys--, pk_values
         FROM _replica.table_update_data AS tmp
         WHERE tmp.Id BETWEEN inId_start AND inId_end
) as a

order by 1,2
   ;
     
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.20          *

*/
-- тест
-- SELECT * FROM gpSelect_Replica_part11 (594837 - 1000, 594837 + 100)
