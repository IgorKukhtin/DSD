-- Function: grSelect_Snapshot_Insert_Query()

DROP FUNCTION IF EXISTS _replica.grSelect_Snapshot_Insert_Query(TVarChar);

CREATE OR REPLACE FUNCTION _replica.grSelect_Snapshot_Insert_Query(IN inTableName TVarChar)
RETURNS Text AS
$BODY$
DECLARE vbQuery Text;
BEGIN  
 
    vbQuery := (
    SELECT
        'SELECT ''INSERT INTO ' || inTableName || ' (' || COLUMNS || ') VALUES ('' || '|| REPLACE(COLUMN_VALUES, '''', '''')
                                || ' || ' || quote_literal(')') || ' || ' ||   
        WHERE_VALUES || ' AS Query, ' || KEY_COLUMNS || ' ' || 
        'FROM ' || inTableName AS QUERY
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
    ) T 
    LEFT JOIN 
    (
        SELECT
            table_name,
          /*''' WHERE NOT EXISTS(SELECT * FROM ' || table_name || ' WHERE '' || ' || 
            STRING_AGG ( 'CASE WHEN CAST (' || table_name ||'.'||key_column || ' AS Text) IS NULL'
                                    || ' THEN ''' || T.key_column || ' IS NULL ''' 
                                    || ' ELSE ''' || T.key_column || ' = '' || ' || 
                                                           CASE WHEN column_typename ILIKE 'TVarChar'
                                                                OR column_typename ILIKE 'TDateTime'
                                                                OR column_typename ILIKE 'Text'
                                                                OR column_typename ILIKE 'TBlob'
                                                           THEN  '''''''''||' || table_name ||'.'||key_column || '||'''''''''
                                                         ELSE table_name ||'.'||key_column
                                                         END || ' '
                                    || ' END ' , '||'' AND ''||' ORDER BY position)
                                    || ' || '')'' '  :: Text AS WHERE_VALUES,*/
            ''' ON CONFLICT DO NOTHING'' '  :: Text AS WHERE_VALUES,
            STRING_AGG (key_column, ',' ORDER BY position) AS KEY_COLUMNS
        FROM   
           (
              SELECT kcu.table_name,
                     kcu.ordinal_position AS position,
                     kcu.column_name AS key_column,
                     c.domain_name AS column_typename
              FROM information_schema.table_constraints tco
              JOIN information_schema.key_column_usage kcu 
                   ON kcu.constraint_name = tco.constraint_name
                   AND kcu.constraint_schema = tco.constraint_schema
                   AND kcu.constraint_name = tco.constraint_name
              JOIN information_schema.columns c 
                   ON c.table_name = kcu.table_name 
                   AND c.table_schema = kcu.table_schema 
                   AND c.column_name = kcu.column_name	
              WHERE tco.constraint_type = 'PRIMARY KEY' 
                AND kcu.table_schema = 'public'         
                AND kcu.table_name ILIKE inTableName
              ORDER BY kcu.table_name,
                       position
            ) T
        GROUP BY table_name
    ) P ON T.table_name = P.table_name);
    
    RETURN vbQuery;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               œÓ‰ÏÓ„ËÎ¸Ì˚È ¬.¬.
 07.10.20          *
*/