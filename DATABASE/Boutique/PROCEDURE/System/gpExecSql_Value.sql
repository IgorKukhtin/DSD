-- Function: gpExecSql_Value()

DROP FUNCTION IF EXISTS gpExecSql_Value (TVarChar, TVarChar);
                                        
CREATE OR REPLACE FUNCTION gpExecSql_Value (IN inSqlText TVarChar, IN inSession TVarChar) 
RETURNS TABLE (Value TVarChar)
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
