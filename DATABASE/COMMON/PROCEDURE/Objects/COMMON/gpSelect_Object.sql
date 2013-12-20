--Function: gpSelect_Object(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object(
    IN inDescId      Integer,      -- сессия пользователя
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
   SELECT 
        Object.Id,
        Object.ObjectCode,
        Object.ValueData, 
        ObjectDesc.ItemName
   FROM Object 
   JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
  WHERE (Object.DescId = inDescId OR 0 = inDescId);

  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object(Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.13                         *
 04.11.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object('2')