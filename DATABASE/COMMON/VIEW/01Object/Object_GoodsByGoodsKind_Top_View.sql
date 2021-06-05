-- View: Object_GoodsByGoodsKind_Top_View

DROP VIEW IF EXISTS Object_GoodsByGoodsKind_Top_View;

CREATE OR REPLACE VIEW Object_GoodsByGoodsKind_Top_View AS
       SELECT
             Object_GoodsByGoodsKind.Id
           , CASE WHEN COALESCE (ObjectBoolean_Top.ValueData, FALSE) = FALSE THEN '' ELSE 'Да' END ::TVarChar AS ValueData
       FROM Object AS Object_GoodsByGoodsKind
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                    ON ObjectBoolean_Top.ObjectId = Object_GoodsByGoodsKind.Id
                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()
       WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind();

ALTER TABLE Object_GoodsByGoodsKind_Top_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.21         *
*/

-- тест
-- SELECT * FROM Object_GoodsByGoodsKind_Top_View
