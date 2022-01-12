--Function: gpSelect_Object_PaidKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Status(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Status(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id integer, Code Integer, Name TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
   SELECT 
         Object.Id AS Id
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
   FROM Object
   WHERE Object.DescId = zc_Object_Status();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Status(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.10.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Status('2')