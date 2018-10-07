-- Function: gpExecSql_Value()

DROP FUNCTION IF EXISTS gpExecSql_Value (Text, TVarChar);
                                        
CREATE OR REPLACE FUNCTION gpExecSql_Value (IN inSqlText Text, IN inSession TVarChar) 
RETURNS TABLE (Value Text)
AS
$BODY$
BEGIN
  RETURN QUERY 
  EXECUTE inSqlText;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-- тест
-- SELECT * FROM gpExecSql_Value('SELECT 1 :: TVarChar AS test', '')
