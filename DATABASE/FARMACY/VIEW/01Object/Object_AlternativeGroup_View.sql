-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_AlternativeGroup_View;

CREATE OR REPLACE VIEW Object_AlternativeGroup_View AS
         SELECT
            Object_AlternativeGroup.Id              AS Id
           , Object_AlternativeGroup.ValueData      AS Name
           , Object_AlternativeGroup.isErased       AS isErased
     FROM Object AS Object_AlternativeGroup
     WHERE Object_AlternativeGroup.DescId = zc_Object_AlternativeGroup();

ALTER TABLE Object_AlternativeGroup_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А. А
 28.06.15                                                         *
*/

-- тест
-- SELECT * FROM Object_AlternativeGroup_View
