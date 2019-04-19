-- Function: gpSelect_Object_PartionDateKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionDateKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionDateKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , AmountMonth TFloat
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
      , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat AS AmountMonth 
      , Object_PartionDateKind.isErased     AS isErased
   FROM Object AS Object_PartionDateKind
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_PartionDateKind.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
        LEFT JOIN ObjectFloat AS ObjectFloat_Month
                              ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                             AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
   WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.19         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionDateKind('2')