-- Function: gpGet_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpGet_Object_ImportTypeItems(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportTypeItems(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ImportTypeId Integer, ImportTypeName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ImportTypeItems());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_ImportTypeItems()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS ImportTypeId
           , CAST ('' as TVarChar) AS ImportTypeName 
           
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ImportTypeItems.Id           AS Id
           , Object_ImportTypeItems.ObjectCode   AS Code
           , Object_ImportTypeItems.ValueData    AS Name
         
           , Object_ImportType.Id         AS ImportTypeId
           , Object_ImportType.ValueData  AS ImportTypeName 
           
           , Object_ImportTypeItems.isErased  AS isErased
           
       FROM Object AS Object_ImportTypeItems
           LEFT JOIN ObjectLink AS ObjectLink_ImportTypeItems_ImportType
                                ON ObjectLink_ImportTypeItems_ImportType.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectLink_ImportTypeItems_ImportType.DescId = zc_ObjectLink_ImportTypeItems_ImportType()
           LEFT JOIN Object AS Object_ImportType ON Object_ImportType.Id = ObjectLink_ImportTypeItems_ImportType.ChildObjectId

     WHERE Object_ImportTypeItems.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ImportTypeItems (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportTypeItems(0,'2')