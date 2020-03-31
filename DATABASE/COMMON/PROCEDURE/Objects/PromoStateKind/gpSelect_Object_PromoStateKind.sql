-- Function: gpSelect_Object_PromoStateKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PromoStateKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoStateKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name
     , Object.isErased
     FROM Object
     WHERE Object.DescId = zc_Object_PromoStateKind();
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.03.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PromoStateKind('2')