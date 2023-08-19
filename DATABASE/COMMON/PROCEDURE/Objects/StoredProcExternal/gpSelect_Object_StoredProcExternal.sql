-- Function: gpSelect_Object_StoredProcExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_StoredProcExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoredProcExternal(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
        SELECT Object.Id
             , Object.ObjectCode AS Code
             , Object.ValueData  AS Name
             , Object.isErased
        FROM Object
        WHERE Object.DescId     = zc_Object_StoredProcExternal()
          AND Object.isErased   = FALSE
          AND Object.ValueData <> ''
        ORDER BY 3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  18.08.23                                                      *
*/

-- тест
-- update Object set ValueData = '' where Id = 1208446
-- SELECT * FROM gpSelect_Object_StoredProcExternal (inSession:= zfCalc_UserAdmin())
