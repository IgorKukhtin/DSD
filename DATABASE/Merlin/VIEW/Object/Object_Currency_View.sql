-- View: Object_Currency_View

-- DROP VIEW IF EXISTS Object_Currency_View;

CREATE OR REPLACE VIEW Object_Currency_View AS
   SELECT 
     Object.Id          AS Id
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , ObjectString_InternalName.ValueData AS InternalName
   FROM Object
        JOIN ObjectString AS ObjectString_InternalName 
                          ON ObjectString_InternalName.ObjectId = Object.Id
                         AND ObjectString_InternalName.DescId = zc_objectString_Currency_InternalName()
   WHERE Object.DescId = zc_Object_Currency();


ALTER TABLE Object_Currency_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
-- SELECT * FROM Object_Currency_View
