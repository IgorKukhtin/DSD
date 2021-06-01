-- Function: gpSelect_Object_MethodsAssortment (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MethodsAssortment (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MethodsAssortment(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased Boolean
             ) AS
             
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_MethodsAssortment());

   RETURN QUERY 
   SELECT
        Object_MethodsAssortment.Id           AS Id 
      , Object_MethodsAssortment.ObjectCode   AS Code
      , Object_MethodsAssortment.ValueData    AS Name
      , ObjectString.ValueData                AS EnumName
      , Object_MethodsAssortment.isErased     AS isErased
   FROM Object AS Object_MethodsAssortment
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_MethodsAssortment.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
   WHERE Object_MethodsAssortment.DescId = zc_Object_MethodsAssortment();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.05.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MethodsAssortment('3')