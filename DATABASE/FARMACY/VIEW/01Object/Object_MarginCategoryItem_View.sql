-- View: Object_Bank_View
DROP VIEW IF EXISTS Object_MarginCategoryItem_View;

CREATE OR REPLACE VIEW Object_MarginCategoryItem_View AS
     SELECT
             ObjectLink_MarginCategoryItem_MarginCategory.ObjectId      AS Id
           , ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId AS MarginCategoryId
           , ObjectFloat_MarginPercent.ValueData AS MarginPercent
           , ObjectFloat_MinPrice.ValueData      AS MinPrice

     FROM ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
               
          LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                               AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()  

          LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                               AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()
     WHERE ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory();


ALTER TABLE Object_MarginCategoryItem_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.04.15                         *
*/

-- тест
-- SELECT * FROM Object_MarginCategoryItem_View
