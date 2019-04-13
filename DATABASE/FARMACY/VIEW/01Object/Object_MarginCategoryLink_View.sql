-- View: Object_Bank_View
DROP VIEW IF EXISTS Object_MarginCategoryLink_View;

CREATE OR REPLACE VIEW Object_MarginCategoryLink_View AS
     SELECT
             ObjectLink_MarginCategoryLink_MarginCategory.ObjectId      AS Id
           , ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId AS MarginCategoryId
           , Object_MarginCategory.ValueData                            AS MarginCategoryName
           , ObjectLink_MarginCategoryLink_Unit.ChildObjectId           AS UnitId
           , Object_Unit.ValueData                                      AS UnitName
           , ObjectLink_MarginCategoryLink_Juridical.ChildObjectId      AS JuridicalId
           , Object_Juridical.ValueData                                 AS JuridicalName
           , Object_MarginCategoryLink.isErased                         AS isErased

     FROM ObjectLink AS ObjectLink_MarginCategoryLink_MarginCategory
           LEFT JOIN Object AS Object_MarginCategoryLink ON Object_MarginCategoryLink.Id = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
           LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                ON ObjectLink_MarginCategoryLink_Unit.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                               AND ObjectLink_MarginCategoryLink_Unit.DescId = zc_ObjectLink_MarginCategoryLink_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_MarginCategoryLink_Unit.ChildObjectId
               
           LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Juridical
                                ON ObjectLink_MarginCategoryLink_Juridical.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                               AND ObjectLink_MarginCategoryLink_Juridical.DescId = zc_ObjectLink_MarginCategoryLink_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_MarginCategoryLink_Juridical.ChildObjectId

     WHERE ObjectLink_MarginCategoryLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryLink_MarginCategory();


ALTER TABLE Object_MarginCategoryLink_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.04.15                         *
*/

-- тест
-- SELECT * FROM Object_MarginCategoryItem_View
