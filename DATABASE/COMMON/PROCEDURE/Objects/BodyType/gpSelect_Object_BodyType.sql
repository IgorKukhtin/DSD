-- Function: gpSelect_Object_BodyType()

DROP FUNCTION IF EXISTS gpSelect_Object_BodyType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BodyType(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_BodyType());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name
        , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_BodyType();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.07.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BodyType('2')