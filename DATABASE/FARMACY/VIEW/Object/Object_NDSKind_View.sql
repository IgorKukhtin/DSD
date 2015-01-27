-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_NDSKind_View CASCADE;

CREATE OR REPLACE VIEW Object_NDSKind_View AS
         SELECT 
             Object_NDSKind.Id                                AS Id
           , Object_NDSKind.ValueData                         AS Name
           , ObjectFloat_NDSKind_NDS.ValueData                AS NDS

       FROM Object AS Object_NDSKind

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

       WHERE Object_NDSKind.DescId = zc_Object_NDSKind();

ALTER TABLE Object_NDSKind_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.15                         *
*/

-- тест
-- SELECT * FROM Object_Goods_View
