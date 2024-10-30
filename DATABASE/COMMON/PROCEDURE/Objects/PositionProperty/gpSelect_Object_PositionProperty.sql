-- Function: gpSelect_Object_PositionProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_PositionProperty (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PositionProperty(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
    -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);
   
   RETURN QUERY 
   SELECT 
     Object.Id                       AS Id 
   , Object.ObjectCode               AS Code
   , Object.ValueData                AS Name
   , Object.isErased                 AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_PositionProperty();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PositionProperty('2')