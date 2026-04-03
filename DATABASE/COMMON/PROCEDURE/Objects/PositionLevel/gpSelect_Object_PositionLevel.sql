-- Function: gpSelect_Object_PositionLevel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PositionLevel (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PositionLevel (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PositionLevel(
    IN inIsErased       Boolean ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isNoSheetCalc Boolean
             , isErased Boolean
             )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_PositionLevel());

   RETURN QUERY
       SELECT
             Object_PositionLevel.Id         AS Id
           , Object_PositionLevel.ObjectCode AS Code
           , Object_PositionLevel.ValueData  AS Name

           , COALESCE (ObjectBoolean_NoSheetCalc.ValueData, FALSE) ::Boolean AS isNoSheetCalc
           , Object_PositionLevel.isErased   AS isErased

       FROM Object AS Object_PositionLevel
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetCalc
                                ON ObjectBoolean_NoSheetCalc.ObjectId = Object_PositionLevel.Id
                               AND ObjectBoolean_NoSheetCalc.DescId = zc_ObjectBoolean_PositionLevel_NoSheetCalc()
       WHERE Object_PositionLevel.DescId = zc_Object_PositionLevel()
        AND (Object_PositionLevel.isErased = FALSE OR inIsErased = TRUE)

    UNION ALL
     SELECT
           NULL:: Integer        AS Id
         , NULL:: Integer        AS Code
         , '<ПУСТО>' :: TVarChar AS Name
         , FALSE :: Boolean      AS isNoSheetCalc
         , TRUE  :: Boolean      AS isErased
      ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.08.21          *
 17.10.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PositionLevel(FALSE, '2')
