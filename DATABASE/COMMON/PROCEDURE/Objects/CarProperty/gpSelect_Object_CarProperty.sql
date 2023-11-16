-- Function: gpSelect_Object_CarProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_CarProperty(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CarProperty(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_CarProperty());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name
        , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_CarProperty();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CarProperty('2')