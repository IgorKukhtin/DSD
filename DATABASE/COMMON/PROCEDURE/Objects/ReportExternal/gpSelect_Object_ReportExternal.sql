-- Function: gpSelect_Object_ReportExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportExternal(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportExternal());

      RETURN QUERY
        SELECT Object.Id
             , Object.ObjectCode AS Code
             , Object.ValueData  AS Name
             , Object.isErased
        FROM Object
        WHERE Object.DescId     = zc_Object_ReportExternal()
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
  28.04.17                                                       *
*/

-- тест
-- update Object set ValueData = '' where Id = 1208446
-- SELECT * FROM gpSelect_Object_ReportExternal (inSession:= zfCalc_UserAdmin())
