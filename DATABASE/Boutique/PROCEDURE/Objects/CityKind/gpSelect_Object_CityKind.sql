-- Function: gpSelect_Object_CityKind()

DROP FUNCTION IF EXISTS gpSelect_Object_CityKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CityKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_CityKind());

   RETURN QUERY 
       SELECT 
             Object.Id            AS Id
           , Object.ObjectCode    AS Code
           , Object.ValueData     AS NAME
           , ShortName.ValueData  AS ShortName
           , Object.isErased      AS isErased
       FROM Object
            LEFT JOIN ObjectString AS ShortName
                                   ON ShortName.ObjectId = Object.Id 
                                  AND ShortName.DescId = zc_ObjectString_CityKind_ShortName()
   WHERE Object.DescId = zc_Object_CityKind();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CityKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.14         * add ShortName
 31.05.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CityKind('2')