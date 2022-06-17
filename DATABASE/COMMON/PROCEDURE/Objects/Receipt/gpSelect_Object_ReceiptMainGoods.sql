-- Function: gpSelect_Object_ReceiptMainGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptMainGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptMainGoods(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsKindCompleteId Integer, GoodsKindCompleteCode Integer, GoodsKindCompleteName TVarChar
             , MeasureName TVarChar
             , GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar
             , ReceiptId Integer, ReceiptCode Integer, ReceiptCode_user TVarChar, ReceiptName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

   RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_GuideTech()))
     
        , tmpReceiptMain AS (SELECT ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId
                                  , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId
                                  , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindCompleteId
                                  , Object_Receipt.Id                          AS ReceiptId
                                  , Object_Receipt.ObjectCode                  AS ReceiptCode
                                  , ObjectString_Receipt_Code.ValueData        AS ReceiptCode_user
                                  , Object_Receipt.ValueData                   AS ReceiptName
                             FROM Object AS Object_Receipt
                                      INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                               ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                              AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                              AND ObjectBoolean_Main.ValueData = TRUE

                                      LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                           ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                          AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                                      LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                           ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                                                          AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                            

                                      LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                                           ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = Object_Receipt.Id
                                                          AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

                                      LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                                             ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                                            AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                                             ON ObjectBoolean_Guide_Irna.ObjectId = Object_Receipt.Id
                                                            AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

                                  WHERE Object_Receipt.DescId = zc_Object_Receipt()
                                    AND Object_Receipt.isErased = FALSE
                                    AND (ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress() OR ObjectLink_Receipt_GoodsKind.ChildObjectId IS NULL)
                                    AND (COALESCE (vbIsIrna, FALSE) = FALSE
                                      OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
                                        )
                            )

 
     SELECT
           Object_Goods.Id                      AS Id
         , Object_Goods.ObjectCode              AS Code
         , Object_Goods.ValueData               AS Name

         , Object_GoodsKind.Id                  AS GoodsKindId
         , Object_GoodsKind.ObjectCode          AS GoodsKindCode
         , Object_GoodsKind.ValueData           AS GoodsKindName

         , Object_GoodsKindComplete.Id          AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ObjectCode  AS GoodsKindCompleteCode
         , Object_GoodsKindComplete.ValueData   AS GoodsKindCompleteName

         , Object_Measure.ValueData             AS MeasureName

         , Object_GoodsGroupAnalyst.ValueData   AS GoodsGroupAnalystName
         , Object_GoodsTag.ValueData            AS GoodsTagName
         , Object_TradeMark.ValueData           AS TradeMarkName

         , tmpReceiptMain.ReceiptId        :: Integer
         , tmpReceiptMain.ReceiptCode      :: Integer
         , tmpReceiptMain.ReceiptCode_user :: TVarChar
         , tmpReceiptMain.ReceiptName      :: TVarChar
         , Object_Goods.isErased                AS isErased

     FROM (SELECT Object_Goods.Id             AS GoodsId
           FROM Object AS Object_Goods
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Goods.isErased
           WHERE Object_Goods.DescId = zc_Object_Goods()
          ) AS tmpGoods
          INNER JOIN tmpReceiptMain ON tmpReceiptMain.GoodsId = tmpGoods.GoodsId
          
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

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

          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReceiptMain.GoodsKindId
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpReceiptMain.GoodsKindCompleteId

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.03.15                                      *all
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptMainGoods (FALSE, zfCalc_UserAdmin())
