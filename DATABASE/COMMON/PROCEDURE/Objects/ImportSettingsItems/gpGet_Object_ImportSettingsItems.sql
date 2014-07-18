-- Function: gpGet_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpGet_Object_ImportTypeItems(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportTypeItems(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ImportSettingsId Integer, ImportSettingsName TVarChar,
               ImportTypeItemsId Integer, ImportTypeItemsName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ImportTypeItems());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name
           
           , CAST (0 as Integer)    AS ImportSettingsId
           , CAST ('' as TVarChar)  AS ImportSettingsName 
                     
           , CAST (0 as Integer)    AS ImportTypeItemsId
           , CAST ('' as TVarChar)  AS ImportTypeItemsName 
           
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ImportTypeItems.Id         AS Id
           , Object_ImportTypeItems.ValueData  AS Name
         
           , Object_ImportSettings.Id          AS ImportSettingsId
           , Object_ImportSettings.ValueData   AS ImportSettingsName 
                     
           , Object_ImportTypeItems.Id         AS ImportTypeItemsId
           , Object_ImportTypeItems.ValueData  AS ImportTypeItemsName 
           
           , Object_ImportTypeItems.isErased   AS isErased
           
       FROM Object AS Object_ImportTypeItems
           LEFT JOIN ObjectLink AS ObjectLink_ImportTypeItems_ImportSettings
                                ON ObjectLink_ImportTypeItems_ImportSettings.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectLink_ImportTypeItems_ImportSettings.DescId = zc_ObjectLink_ImportTypeItems_ImportSettings()
           LEFT JOIN Object AS Object_ImportSettings ON Object_ImportSettings.Id = ObjectLink_ImportTypeItems_ImportSettings.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_ImportTypeItems_ImportTypeItems
                                ON ObjectLink_ImportTypeItems_ImportTypeItems.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectLink_ImportTypeItems_ImportTypeItems.DescId = zc_ObjectLink_ImportTypeItems_ImportTypeItems()
           LEFT JOIN Object AS Object_ImportTypeItems ON Object_ImportTypeItems.Id = ObjectLink_ImportTypeItems_ImportTypeItems.ChildObjectId           
                                  
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
 03.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ImportTypeItems(0,'2')