--Function: gpSelect_Object_PaidKind(TVarChar)

--DROP FUNCTION gpSelect_Object_PaidKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PaidKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_PaidKind()
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , FALSE AS isErased
     ;
  
END;$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PaidKind('2')