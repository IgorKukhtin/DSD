-- Function: gpGet_Password_MoneyInCash()

DROP FUNCTION IF EXISTS gpGet_Password_MoneyInCash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Password_MoneyInCash(
   OUT outPassword   TVarChar,      -- Значение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TVarChar 
AS
$BODY$
BEGIN
  
  SELECT DefaultValue into outPassword
  FROM DefaultValue 
    JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
  WHERE DefaultKeys.Key = 'zc_Password_MoneyInCash'
  LIMIT 1;
  if COALESCE(outPassword,'') = '' THEN
    outPassword := 'qsxqsxw1';
  END IF;    
END;
$BODY$

LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION gpGet_Password_MoneyInCash(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.14                         * add LEFT для пользователя.
 20.12.13                         *

*/

-- тест
-- SELECT * FROM gpGet_Password_MoneyInCash('2')