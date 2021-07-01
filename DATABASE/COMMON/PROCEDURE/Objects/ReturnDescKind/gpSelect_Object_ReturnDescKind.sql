--Function: gpSelect_Object_ReturnDescKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReturnDescKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReturnDescKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReturnDescKind());

   RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectString.ValueData AS EnumName
           , Object.isErased   AS isErased
       FROM Object
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
       WHERE Object.DescId = zc_Object_ReturnDescKind()
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , ''        :: TVarChar AS EnumName
            , FALSE AS isErased
     ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.21         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ReturnDescKind('2')