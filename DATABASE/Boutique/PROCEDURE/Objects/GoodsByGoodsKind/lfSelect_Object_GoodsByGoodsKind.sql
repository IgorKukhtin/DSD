-- Function: lfSelect_Object_GoodsByGoodsKind ()

-- DROP FUNCTION lfSelect_Object_GoodsByGoodsKind ();

CREATE OR REPLACE FUNCTION lfSelect_Object_GoodsByGoodsKind()

RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar)
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY 
       SELECT 
             ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName
           , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
           , Object_GoodsKind.ObjectCode                       AS GoodsKindCode
           , Object_GoodsKind.ValueData                        AS GoodsKindName
       FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
            JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
       WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_GoodsByGoodsKind () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.07.13                                        *
*/

-- тест
-- SELECT * FROM lfSelect_Object_GoodsByGoodsKind ()
