-- Function: gpSelect_Object_ComputerAccessories()

DROP FUNCTION IF EXISTS gpSelect_Object_ComputerAccessories(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ComputerAccessories(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN


   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   SELECT
          Object_ComputerAccessories.Id                 AS Id
        , Object_ComputerAccessories.ObjectCode         AS Code
        , Object_ComputerAccessories.ValueData          AS Name
        
        , Object_ComputerAccessories.isErased           AS isErased

   FROM Object AS Object_ComputerAccessories

   WHERE Object_ComputerAccessories.DescId = zc_Object_ComputerAccessories();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ComputerAccessories(TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ComputerAccessories( '3')