-- Function: _replica.gpSelect_PKFields()

DROP FUNCTION IF EXISTS _replica.gpSelect_PKFields (Text);

CREATE OR REPLACE FUNCTION _replica.gpSelect_PKFields (
    IN inTableName  Text
)
RETURNS TABLE (FieldName    Name,
               Data_Type    Text
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type
        FROM   pg_index i
        JOIN   pg_attribute a ON a.attrelid = i.indrelid
                             AND a.attnum = ANY(i.indkey)
        WHERE  i.indrelid = quote_ident(inTableName)::regclass
        AND    i.indisprimary;     
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 03.11.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_PKFields('container')