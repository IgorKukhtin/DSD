-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , MeasureName TVarChar
             , GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_GuideTech()))
     SELECT
           Object_Goods.Id          AS Id
         , Object_Goods.ObjectCode  AS Code
         , Object_Goods.ValueData   AS Name

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_Measure.ValueData     AS MeasureName

         , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
         , Object_GoodsTag.ValueData                   AS GoodsTagName
         , Object_TradeMark.ValueData                  AS TradeMarkName

         , Object_Goods.isErased AS isErased

     FROM (SELECT ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId
           FROM ObjectLink AS ObjectLink_Receipt_GoodsKind
                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_GoodsKind.ObjectId
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased
                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                     ON ObjectLink_Receipt_Goods.ObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
           WHERE ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
             AND ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()
           GROUP BY ObjectLink_Receipt_Goods.ChildObjectId
                  , ObjectLink_Receipt_GoodsKind.ChildObjectId
          UNION
           SELECT ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId
           FROM ObjectLink AS ObjectLink_Receipt_GoodsKind
                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_GoodsKind.ObjectId
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased
                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                     ON ObjectLink_Receipt_Goods.ObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
           WHERE ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
             AND ObjectLink_Receipt_GoodsKind.ChildObjectId IS NULL
           GROUP BY ObjectLink_Receipt_Goods.ChildObjectId
                  , ObjectLink_Receipt_GoodsKind.ChildObjectId
          ) AS tmpGoods

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Goods.isErased
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptGoods (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.03.15                                      *all
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptGoods (FALSE, zfCalc_UserAdmin())
