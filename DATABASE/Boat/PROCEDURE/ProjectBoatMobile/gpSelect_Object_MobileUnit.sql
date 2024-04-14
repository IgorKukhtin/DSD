-- Function: gpSelect_Object_Unit (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MobileUnit (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobileUnit(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY

       SELECT
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name

           , Object_Unit.isErased            AS isErased

       FROM Object AS Object_Unit
     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MobileUnit (TRUE, zfCalc_UserAdmin())


