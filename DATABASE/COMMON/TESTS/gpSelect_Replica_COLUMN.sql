-- Function: gpSelect_Replica_Column()

DROP FUNCTION IF EXISTS gpSelect_Replica_Column (Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Replica_Column(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (TABLE_NAME TVarChar, COLUMN_NAME TVarChar, COLUMN_NAME_full TVarChar
) AS
$BODY$
BEGIN

   RETURN QUERY 
    SELECT tmp.TABLE_NAME :: TVarChar
     , STRING_AGG (tmp.COLUMN_NAME , ',' ORDER BY COLUMN_POSITION)    :: TVarChar                   AS COLUMN_NAME
     , STRING_AGG ( tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME , '||'',''||' ORDER BY COLUMN_POSITION)  :: TVarChar AS  COLUMN_NAME_full
    FROM (
          SELECT 
                C.RELNAME          AS TABLE_NAME, 
                A.ATTNAME          AS COLUMN_NAME, 
                A.ATTNUM           AS COLUMN_POSITION, 
                A.ATTTYPID         AS COLUMN_DATATYPE, 
                T.TYPNAME          AS COLUMN_TYPENAME, 
                (16384 + CASE WHEN A.ATTNOTNULL THEN 0 ELSE 2 END + CASE WHEN A.ATTNUM > 0 THEN 0 ELSE 16 END + 
                	  CASE WHEN UPPER(A.ATTNAME) = 'OID' AND A.ATTNUM < 0 THEN 64 ELSE 0 END + 
                	  CASE WHEN UPPER(SUBSTR(PG_GET_EXPR(D.ADBIN, D.ADRELID), 1, 8)) = 'NEXTVAL(' THEN 32 WHEN D.ADBIN IS NOT NULL THEN 128 
                	  ELSE 0 END)::INTEGER AS COLUMN_ATTRIBUTES
          
          FROM PG_CATALOG.PG_CLASS C 
           INNER JOIN PG_CATALOG.PG_ATTRIBUTE A ON A.ATTRELID = C.OID 
           INNER JOIN PG_CATALOG.PG_TYPE T ON A.ATTTYPID = T.OID 
           LEFT JOIN PG_CATALOG.PG_ATTRDEF D ON D.ADNUM = A.ATTNUM AND D.ADRELID = C.OID  
          WHERE A.ATTNUM > 0 AND NOT A.ATTISDROPPED  AND C.RELNAME IN (select distinct table_update_data.table_name from _replica.table_update_data where table_update_data.id between inId_start AND inId_end) ORDER BY 3   
    ) AS tmp
    GROUP BY tmp.TABLE_NAME;
     
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
--SELECT * FROM gpSelect_Replica_Column(507132, 657179)