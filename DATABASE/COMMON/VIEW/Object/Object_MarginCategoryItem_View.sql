-- View: Object_Bank_View
DROP VIEW IF EXISTS Object_MarginCategoryItem_View;

CREATE OR REPLACE VIEW Object_MarginCategoryItem_View AS
     SELECT
             Object_MarginCategoryItem.Id        AS Id
           , ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId AS MarginCategoryId
           , ObjectFloat_MarginPercent.ValueData AS MarginPercent
           , ObjectFloat_MinPrice.ValueData      AS MinPrice

     FROM Object AS Object_MarginCategoryItem
               JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                 ON ObjectLink_MarginCategoryItem_MarginCategory.ObjectId = Object_MarginCategoryItem.Id
                AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
               
          LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                ON ObjectFloat_MinPrice.ObjectId = Object_MarginCategoryItem.Id
                               AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()  

          LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                ON ObjectFloat_MarginPercent.ObjectId = Object_MarginCategoryItem.Id
                               AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()  

     WHERE Object_MarginCategoryItem.DescId = zc_Object_MarginCategoryItem();


ALTER TABLE Object_MarginCategoryItem_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.04.15                         *
*/

-- тест
-- SELECT * FROM Object_MarginCategoryItem_View
