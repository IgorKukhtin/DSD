-- Function: _replica.gpSelect_Replica_Table()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_Table (Integer, Integer);
DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_Table (BigInt, BigInt);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_Table(
    IN inId_start     BigInt,
    IN inId_end       BigInt
)
RETURNS TABLE (TABLE_NAME Text, COLUMN_NAME Text, COLUMN_POSITION Integer, COLUMN_DATATYPE Integer, COLUMN_TYPENAME Text, COLUMN_ATTRIBUTES Integer)
AS
$BODY$
BEGIN

   RETURN QUERY 
      SELECT 
            C.RELNAME          :: Text    AS TABLE_NAME, 
            A.ATTNAME          :: Text    AS COLUMN_NAME, 
            A.ATTNUM           :: Integer AS COLUMN_POSITION, 
            A.ATTTYPID         :: Integer AS COLUMN_DATATYPE, 
            T.TYPNAME          :: Text    AS COLUMN_TYPENAME, 
            (16384 + CASE WHEN A.ATTNOTNULL THEN 0 ELSE 2 END + CASE WHEN A.ATTNUM > 0 THEN 0 ELSE 16 END + 
            	  CASE WHEN UPPER(A.ATTNAME) = 'OID' AND A.ATTNUM < 0 THEN 64 ELSE 0 END + 
            	  CASE WHEN UPPER(SUBSTR(PG_GET_EXPR(D.ADBIN, D.ADRELID), 1, 8)) = 'NEXTVAL(' THEN 32 WHEN D.ADBIN IS NOT NULL THEN 128 
            	  ELSE 0 END)::INTEGER AS COLUMN_ATTRIBUTES
      
      FROM PG_CATALOG.PG_CLASS C 
           INNER JOIN PG_CATALOG.PG_ATTRIBUTE A ON A.ATTRELID = C.OID 
           INNER JOIN PG_CATALOG.PG_TYPE T ON A.ATTTYPID = T.OID 
           LEFT JOIN PG_CATALOG.PG_ATTRDEF D ON D.ADNUM = A.ATTNUM AND D.ADRELID = C.OID  
      WHERE A.ATTNUM > 0 AND NOT A.ATTISDROPPED
        AND C.RELNAME IN (select distinct table_update_data.table_name from _replica.table_update_data where table_update_data.id between inId_start AND inId_end)
      ORDER BY 1, 2;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.20          *
*/

-- тест
--
-- SELECT * FROM _replica.gpSelect_Replica_Table(1, 657179)
