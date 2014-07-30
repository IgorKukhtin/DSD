-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_ImportTypeItems_View;

CREATE OR REPLACE VIEW Object_ImportTypeItems_View AS
       SELECT 
             Object_ImportTypeItems.Id           AS Id
           , Object_ImportTypeItems.ObjectCode   AS ParamNumber
           , Object_ImportTypeItems.ValueData    AS Name
         
           , ObjectLink_ImportTypeItems_ImportType.ChildObjectId    AS ImportTypeId

           , ObjectString_ImportTypeItems_ParamType.ValueData  AS ParamType
     
           , Object_ImportTypeItems.isErased           AS isErased
           
       FROM Object AS Object_ImportTypeItems
           LEFT JOIN ObjectLink AS ObjectLink_ImportTypeItems_ImportType
                                ON ObjectLink_ImportTypeItems_ImportType.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectLink_ImportTypeItems_ImportType.DescId = zc_ObjectLink_ImportTypeItems_ImportType()

           LEFT JOIN ObjectString AS ObjectString_ImportTypeItems_ParamType
                                ON ObjectString_ImportTypeItems_ParamType.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectString_ImportTypeItems_ParamType.DescId = zc_ObjectString_ImportTypeItems_ParamType()

       WHERE Object_ImportTypeItems.DescId = zc_Object_ImportTypeItems();

ALTER TABLE Object_ImportTypeItems_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.14                         *
*/

-- тест
-- SELECT * FROM Object_Goods_View
