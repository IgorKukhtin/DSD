-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_MainGoods_View;

CREATE OR REPLACE VIEW Object_MainGoods_View AS
         SELECT 
             Object_Goods.Id           AS Id
           , Object_Goods.ObjectCode   AS ObjectCode
           , Object_Goods.ValueData    AS ValueData
           , Object_Goods.isErased     AS isErased

       FROM Object AS Object_Goods
       JOIN ObjectLink AS ObjectLink_Goods_Object ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
        AND ObjectLink_Goods_Object.ChildObjectId IS NULL
        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                   
       WHERE Object_Goods.DescId = zc_Object_Goods();


ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.14                         *
*/

-- тест
-- SELECT * FROM Object_Goods_View
