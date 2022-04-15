-- Function: gpSelect_Object_UserByGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_UserByGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserByGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UserByGroup());

     RETURN QUERY 
     SELECT 
         Object.Id         AS Id 
       , Object.Id         AS ParentId
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased      

     FROM Object
    WHERE Object.DescId = zc_Object_UserByGroup();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UserByGroup('2')