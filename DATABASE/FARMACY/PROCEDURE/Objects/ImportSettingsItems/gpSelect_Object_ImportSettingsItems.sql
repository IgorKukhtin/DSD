-- Function: gpSelect_Object_ImportSettingsItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettingsItems(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettingsItems(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar,
               ImportSettingsId Integer, ImportSettingsName TVarChar,
               ImportTypeItemsId Integer, ImportTypeItemsName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportSettingsItems());

   RETURN QUERY 
       SELECT 
             Object_ImportSettingsItems.Id           AS Id
           , Object_ImportSettingsItems.ValueData    AS Name
         
           , Object_ImportSettings.Id         AS ImportSettingsId
           , Object_ImportSettings.ValueData  AS ImportSettingsName 
                     
           , Object_ImportTypeItems.Id         AS ImportTypeItemsId
           , Object_ImportTypeItems.ValueData  AS ImportTypeItemsName 
           
           , Object_ImportSettingsItems.isErased   AS isErased
           
       FROM Object AS Object_ImportSettingsItems
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettingsItems_ImportSettings
                                ON ObjectLink_ImportSettingsItems_ImportSettings.ObjectId = Object_ImportSettingsItems.Id
                               AND ObjectLink_ImportSettingsItems_ImportSettings.DescId = zc_ObjectLink_ImportSettingsItems_ImportSettings()
           LEFT JOIN Object AS Object_ImportSettings ON Object_ImportSettings.Id = ObjectLink_ImportSettingsItems_ImportSettings.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettingsItems_ImportTypeItems
                                ON ObjectLink_ImportSettingsItems_ImportTypeItems.ObjectId = Object_ImportSettingsItems.Id
                               AND ObjectLink_ImportSettingsItems_ImportTypeItems.DescId = zc_ObjectLink_ImportSettingsItems_ImportTypeItems()
           LEFT JOIN Object AS Object_ImportTypeItems ON Object_ImportTypeItems.Id = ObjectLink_ImportSettingsItems_ImportTypeItems.ChildObjectId           

       WHERE Object_ImportSettingsItems.DescId = zc_Object_ImportSettingsItems();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportSettingsItems(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettingsItems ('2')