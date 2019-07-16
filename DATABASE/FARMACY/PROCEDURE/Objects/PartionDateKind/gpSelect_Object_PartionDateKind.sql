-- Function: gpSelect_Object_PartionDateKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionDateKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionDateKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , AmountDay Integer
             , isErased Boolean
             ) AS
             
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_PartionDateKind());

   RETURN QUERY 
   SELECT
        Object_PartionDateKind.Id           AS Id 
      , Object_PartionDateKind.ObjectCode   AS Code
      , Object_PartionDateKind.ValueData    AS Name
      , ObjectString.ValueData              AS EnumName
      , COALESCE (ObjectFloat_Day.ValueData, 0)::Integer AS AmountDay
      , Object_PartionDateKind.isErased     AS isErased
   FROM Object AS Object_PartionDateKind
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_PartionDateKind.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day
                              ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                             AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
   WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.07.19                                                       *
 19.04.19         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionDateKind('2')