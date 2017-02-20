-- Function: gpSelect_Object_Fabrika()

DROP FUNCTION IF EXISTS gpSelect_Object_Fabrika (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Fabrika(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Fabrika());


   -- результат
   RETURN QUERY
      SELECT Object.Id                          AS Id
           , Object.ObjectCode                  AS Code
           , Object.ValueData                   AS Name
           , Object.isErased                    AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_Fabrika()
         AND (Object.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 19.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Fabrika (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
