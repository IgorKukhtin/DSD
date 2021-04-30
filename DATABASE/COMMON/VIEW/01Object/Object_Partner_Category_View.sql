-- View: Object_Partner_Category_View

-- DROP VIEW IF EXISTS Object_Partner_Category_View;

CREATE OR REPLACE VIEW Object_Partner_Category_View AS
   SELECT 
     Object.Id             AS Id
   , ObjectFloat.ValueData AS Category
   FROM Object
   JOIN ObjectFloat
     ON ObjectFloat.ObjectId = Object.Id
    AND ObjectFloat.DescId = zc_ObjectFloat_Partner_Category()
   WHERE Object.DescId = zc_Object_Partner();


ALTER TABLE Object_Partner_Category_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.04.12                                        *
*/

-- тест
-- SELECT * FROM Object_Partner_Category_View
