-- Function: grSelect_Snapshot_Insert_QueryV2()

DROP FUNCTION IF EXISTS _replica.grSelect_Snapshot_Insert_QueryV2(TVarChar);

CREATE OR REPLACE FUNCTION _replica.grSelect_Snapshot_Insert_QueryV2(IN inTableName TVarChar)
RETURNS TABLE (
    InsertPart          Text,
    ValuesPart          Text
) AS
$BODY$
BEGIN  
 
    RETURN QUERY
    SELECT
        'INSERT INTO ' || inTableName || ' (' || COLUMNS || ') ' :: Text AS InsertPart,
        'SELECT ''('' || '|| REPLACE(COLUMN_VALUES, '''', '''') || ' || ' || quote_literal(')') || ' AS Query' :: Text AS ValuesPart
        
    FROM
    (
        SELECT tmp.TABLE_NAME :: Text
             , STRING_AGG (tmp.COLUMN_NAME , ',' ORDER BY COLUMN_POSITION)    :: Text                   AS COLUMNS
             , STRING_AGG ( 'CASE WHEN CAST (' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || ' AS Text) IS NULL'
                            || ' THEN ' || _replica.zfStr_CHR_39 ('NULL')
                            || ' ELSE CAST (' || CASE 
                                                    WHEN tmp.COLUMN_TYPENAME ILIKE 'TVarChar'
                                                      OR tmp.COLUMN_TYPENAME ILIKE 'Text'
                                                      OR tmp.COLUMN_TYPENAME ILIKE 'TBlob'
                                                      THEN  '''''|| quote_literal(' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || ') ||'''''
                                                    WHEN tmp.COLUMN_TYPENAME ILIKE 'TDateTime'                                                        
                                                      OR tmp.COLUMN_TYPENAME ILIKE 'interval' 
                                                      OR tmp.COLUMN_TYPENAME ILIKE 'Timestamp'
                                                      THEN  '''''''''||' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || '||'''''''''
                                                    ELSE tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME
                                                 END || '  AS Text)'
                            || ' END' , '||'',''||' ORDER BY COLUMN_POSITION)  :: Text AS  COLUMN_VALUES

        FROM (SELECT 
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
            AND C.RELNAME ILIKE inTableName
          ORDER BY 1, 2) AS tmp
        GROUP BY tmp.TABLE_NAME
    ) T;
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Подмогильный В.В.
 21.10.20          *
*/