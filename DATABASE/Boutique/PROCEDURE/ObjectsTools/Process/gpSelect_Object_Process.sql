-- Function: gpSelect_Object_Process()

DROP FUNCTION IF EXISTS gpSelect_Object_Process (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Process(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar, isErased boolean)
AS
$BODY$
BEGIN
  
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id              AS Id 
   , Object.ObjectCode      AS Code
   , Object.ValueData       AS Name
   , ObjectString.ValueData AS EnumName
   , Object.isErased        AS isErased
   FROM Object
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
   WHERE Object.DescId = zc_Object_Process()
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Process (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Process('2')
