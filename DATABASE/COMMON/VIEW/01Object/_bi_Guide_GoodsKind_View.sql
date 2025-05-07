-- View: _bi_Guide_GoodsKind_View

-- DROP VIEW IF EXISTS _bi_Guide_GoodsKind_View;
--Справочник Виды товаров
CREATE OR REPLACE VIEW _bi_Guide_GoodsKind_View
AS
       SELECT 
             Object_GoodsKind.Id         AS Id 
           , Object_GoodsKind.ObjectCode AS Code
           , Object_GoodsKind.ValueData  AS Name
           , Object_GoodsKind.isErased   AS isErased
       FROM Object AS Object_GoodsKind
       WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind();
     
ALTER TABLE _bi_Guide_GoodsKind_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_GoodsKind_View
