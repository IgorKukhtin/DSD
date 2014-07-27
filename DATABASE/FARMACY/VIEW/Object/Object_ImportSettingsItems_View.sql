-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_ImportSettingsItems_View;

CREATE OR REPLACE VIEW Object_ImportSettingsItems_View AS
SELECT Object_ImportSettingsItems.Id, 
       Object_ImportSettingsItems.ValueData,
       Object_ImportSettingsItems.isErased,
       ObjectLink_ImportSettingsItems_ImportSettings.ChildObjectId AS ImportSettingsId,
       ObjectLink_ImportSettingsItems_ImportTypeItems.ChildObjectId AS ImportTypeItemsId
FROM 

 Object AS Object_ImportSettingsItems 

           LEFT JOIN ObjectLink AS ObjectLink_ImportSettingsItems_ImportSettings
                                ON ObjectLink_ImportSettingsItems_ImportSettings.ObjectId = Object_ImportSettingsItems.Id
                               AND ObjectLink_ImportSettingsItems_ImportSettings.DescId = zc_ObjectLink_ImportSettingsItems_ImportSettings()

           LEFT JOIN ObjectLink AS ObjectLink_ImportSettingsItems_ImportTypeItems
                                ON ObjectLink_ImportSettingsItems_ImportTypeItems.ObjectId = Object_ImportSettingsItems.Id
                               AND ObjectLink_ImportSettingsItems_ImportTypeItems.DescId = zc_ObjectLink_ImportSettingsItems_ImportTypeItems()
                               
WHERE Object_ImportSettingsItems.DescId = zc_Object_ImportSettingsItems();

ALTER TABLE Object_ImportSettingsItems_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.14                         *
*/

-- тест
-- SELECT * FROM Object_Goods_View
