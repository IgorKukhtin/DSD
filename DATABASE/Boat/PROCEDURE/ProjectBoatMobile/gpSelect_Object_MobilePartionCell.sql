-- Function: gpSelect_Object_MobilePartionCell()

DROP FUNCTION IF EXISTS gpSelect_Object_MobilePartionCell (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobilePartionCell(
    IN inShowAll     Boolean,
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat
             , Comment TVarChar
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
       SELECT
             Object.Id                                 AS Id
           , Object.ObjectCode                         AS Code
           , Object.ValueData                          AS Name
           , ObjectFloat_Level.ValueData    ::TFloat   AS Level
           , ObjectString_Comment.ValueData ::TVarChar AS Comment
       FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_PartionCell_Comment()

        LEFT JOIN ObjectFloat AS ObjectFloat_Level
                              ON ObjectFloat_Level.ObjectId = Object.Id
                             AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()

       WHERE Object.DescId = zc_Object_PartionCell() 
         AND (Object.isErased = FALSE OR inShowAll= TRUE)
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.03.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MobilePartionCell (False, zfCalc_UserAdmin())