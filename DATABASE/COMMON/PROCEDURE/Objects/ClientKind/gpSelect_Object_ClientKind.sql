-- Function: gpSelect_Object_ClientKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ClientKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_ClientKind());
   vbUserId:= lpGetUserBySession (inSession);

       RETURN QUERY 
          SELECT
               Object_ClientKind.Id           AS Id 
             , Object_ClientKind.ObjectCode   AS Code
             , Object_ClientKind.ValueData    AS Name
             , Object_ClientKind.isErased     AS isErased
          FROM Object AS Object_ClientKind
          WHERE Object_ClientKind.DescId = zc_Object_ClientKind();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ClientKind ('5')
