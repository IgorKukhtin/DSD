--Function: gpSelect_ObjectDesc(TVarChar)

--DROP FUNCTION gpSelect_ObjectDesc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectDesc(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
   SELECT 
        ObjectDesc.Id,
        ObjectDesc.ItemName 
   FROM ObjectDesc;

  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ObjectDesc(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectDesc('2')