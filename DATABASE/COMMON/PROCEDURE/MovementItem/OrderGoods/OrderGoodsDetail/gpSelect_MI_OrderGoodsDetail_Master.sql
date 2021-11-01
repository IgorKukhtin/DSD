-- Function: gpSelect_MI_OrderGoodsDetail_Master()


 DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Master (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderGoodsDetail_Master(
    IN inParentId    Integer      , -- ключ Документа OrderGoods
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , ReceiptId Integer
             , ReceiptCode Integer
             , ReceiptCode_str TVarChar
             , ReceiptName TVarChar
             , isMain Boolean
             , ReceiptBasisId Integer
             , ReceiptBasisCode Integer
             , ReceiptBasisCode_str TVarChar
             , ReceiptBasisName TVarChar
             , isMain_Basis Boolean
             , Amount                   TFloat
             , Amount_sh                TFloat
             , Amount_kg                TFloat
             , AmountForecast           TFloat
             , AmountForecastOrder      TFloat
             , AmountForecastPromo      TFloat
             , AmountForecastOrderPromo TFloat
             , AmountForecast_sh           TFloat
             , AmountForecastOrder_sh      TFloat
             , AmountForecastPromo_sh      TFloat
             , AmountForecastOrderPromo_sh TFloat

             , TradeMarkName         TVarChar
             , GoodsTagName          TVarChar
             , GoodsPlatformName     TVarChar
             , GoodsGroupAnalystName TVarChar
             , isTop Boolean

             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbMovementId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- Нашли документ
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());

     -- Результат
     RETURN QUERY
       WITH
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.ParentId                         AS ParentId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = vbMovementId-- MovementItem.ParentId = inParentId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                    )

     , tmpGoodsParam AS (SELECT tmp.GoodsId
                              , Object_TradeMark.ValueData      AS TradeMarkName
                              , Object_GoodsTag.ValueData       AS GoodsTagName
                              , Object_GoodsPlatform.ValueData  AS GoodsPlatformName
                              , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
                         FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                  ON ObjectLink_Goods_TradeMark.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                  ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                             LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                  ON ObjectLink_Goods_GoodsTag.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
                        )
             
     -- выбираем данные по признаку товара ТОП из GoodsByGoodsKind
     , tmpTOP AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                       , Object_GoodsByGoodsKind_View.GoodsKindId
                  FROM ObjectBoolean
                       LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean.ObjectId
                  WHERE ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()
                    AND COALESCE (ObjectBoolean.ValueData, FALSE) = TRUE
                   )

        -- Результат
        SELECT
             tmpMI.MovementItemId    :: Integer          AS Id
           , tmpMI.ParentId                              AS ParentId
           , Object_Goods.Id          	                 AS GoodsId
           , Object_Goods.ObjectCode  	                 AS GoodsCode
           , Object_Goods.ValueData   	                 AS GoodsName
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_Receipt.Id                           AS ReceiptId
           , Object_Receipt.ObjectCode                   AS ReceiptCode
           , ObjectString_Receipt_Code.ValueData         AS ReceiptCode_str
           , Object_Receipt.ValueData                    AS ReceiptName
           , ObjectBoolean_Main.ValueData                AS isMain

           , Object_ReceiptBasis.Id                      AS ReceiptBasisId
           , Object_ReceiptBasis.ObjectCode              AS ReceiptBasisCode
           , ObjectString_ReceiptBasis_Code.ValueData    AS ReceiptBasisCode_str
           , Object_ReceiptBasis.ValueData               AS ReceiptBasisName
           , ObjectBoolean_Main_Basis.ValueData          AS isMain_Basis

           , tmpMI.Amount                               :: TFloat AS Amount
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN tmpMI.Amount
                  ELSE 0
             END ::TFloat AS Amount_sh

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE tmpMI.Amount
             END ::TFloat AS Amount_kg

           --, tmpMI.Amount ::TFloat AS Amount_kg --CASE WHEN  Object_Measure.Id <> zc_Measure_Sh() THEN tmpMI.Amount ELSE 0 END ::TFloat AS Amount_kg

             -- Стат. вес (продажа)
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN (COALESCE (MIFloat_AmountForecast.ValueData, 0) + COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)) * COALESCE (ObjectFloat_Weight.ValueData, 1)
                  ELSE  COALESCE (MIFloat_AmountForecast.ValueData, 0) + COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)
             END ::TFloat AS AmountForecast
             -- Стат. вес  (заявка)
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN (COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) + COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)) * COALESCE (ObjectFloat_Weight.ValueData, 1)
                  ELSE  COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) + COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)
             END ::TFloat AS AmountForecastOrder

             -- Стат. вес (продажа Акции)
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN COALESCE (MIFloat_AmountForecastPromo.ValueData, 0) * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)
             END ::TFloat AS AmountForecastPromo
             -- Стат. вес (заявка Акции)
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0) * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)
             END ::TFloat AS AmountForecastOrderPromo

             -- Стат. , шт (продажа)
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN (COALESCE (MIFloat_AmountForecast.ValueData, 0) + COALESCE (MIFloat_AmountForecastPromo.ValueData, 0))
                  ELSE 0
             END AS NUMERIC (16,0)) ::TFloat AS AmountForecast_sh
             -- Стат. , шт (заявка)
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) + COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)
                  ELSE 0
             END AS NUMERIC (16,0)) ::TFloat AS AmountForecastOrder_sh

             -- Стат. , шт (продажа Акции)
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)
                  ELSE 0
             END AS NUMERIC (16,0)) ::TFloat AS AmountForecastPromo_sh
             -- Стат., шт (заявка Акции)
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                  THEN COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)
                  ELSE 0
             END AS NUMERIC (16,0)) ::TFloat AS AmountForecastOrderPromo_sh

           , tmpGoodsParam.TradeMarkName         :: TVarChar
           , tmpGoodsParam.GoodsTagName          :: TVarChar
           , tmpGoodsParam.GoodsPlatformName     :: TVarChar
           , tmpGoodsParam.GoodsGroupAnalystName :: TVarChar
           , CASE WHEN tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END :: Boolean AS isTop

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                        ON MIFloat_AmountForecast.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                        ON MIFloat_AmountForecastOrder.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                        ON MIFloat_AmountForecastPromo.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastPromo.DescId = zc_MIFloat_AmountForecastPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                        ON MIFloat_AmountForecastOrderPromo.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountForecastOrderPromo.DescId = zc_MIFloat_AmountForecastOrderPromo()

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                             ON MILO_Receipt.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_Receipt.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
                                             ON MILO_ReceiptBasis.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
            LEFT JOIN Object AS Object_ReceiptBasis ON Object_ReceiptBasis.Id = MILO_ReceiptBasis.ObjectId
            LEFT JOIN ObjectString AS ObjectString_ReceiptBasis_Code
                                   ON ObjectString_ReceiptBasis_Code.ObjectId = Object_ReceiptBasis.Id
                                  AND ObjectString_ReceiptBasis_Code.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                    ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                   AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Receipt_Main()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Basis
                                    ON ObjectBoolean_Main_Basis.ObjectId = Object_ReceiptBasis.Id
                                   AND ObjectBoolean_Main_Basis.DescId   = zc_ObjectBoolean_Receipt_Main()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpMI.GoodsId
            LEFT JOIN tmpTOP ON tmpTOP.GoodsId = tmpMI.GoodsId
                            AND COALESCE (tmpTOP.GoodsKindId,0) = COALESCE (MILO_GoodsKind.ObjectId,0)
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.21         *
 15.09.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderGoodsDetail_Master(inParentId := 18298048 , inIsErased := 'False' ,  inSession := '5')
