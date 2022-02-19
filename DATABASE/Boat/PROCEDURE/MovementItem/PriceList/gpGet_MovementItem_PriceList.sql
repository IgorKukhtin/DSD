-- Function: gpGet_Movement_PriceList()

DROP FUNCTION IF EXISTS gpGet_MovementItem_PriceList (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_PriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_PriceList(
    IN inId             Integer  , -- ключ
    IN inGoodsId        Integer  , -- ключ
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar
             , Amount         TFloat
             , Amount_old     TFloat
             , OperPrice_orig TFloat
             , CountForPrice  TFloat
             , DiscountTax    TFloat
             , OperPrice      TFloat
             , SummIn         TFloat
             , OperPriceList  TFloat
             , EmpfPrice      TFloat
             , PartNumber     TVarChar
             , Comment        TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

         -- Результат
         RETURN QUERY
           WITH tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.MovementId
                               , MovementItem.ObjectId AS GoodsId
                               , MovementItem.Amount
                              , COALESCE (MIFloat_PriceParent.ValueData, 0)     AS PriceParent
                              , COALESCE (MIFloat_EmpfPriceParent.ValueData, 0) AS EmpfPriceParent
                              , COALESCE (MIFloat_MeasureMult.ValueData, 0)     AS MeasureMult
                              , COALESCE (MIFloat_MinCount.ValueData, 0)        AS MinCount
                              , COALESCE (MIFloat_MinCountMult.ValueData, 0)    AS MinCountMult
                              , COALESCE (MIFloat_WeightParent.ValueData, 0)    AS WeightParent
                                --
                              , MovementItem.isErased

                              , MILO_DiscountParner.ObjectId   AS DiscountParnerId
                              , MILO_Measure.ObjectId          AS MeasureId
                              , MILO_MeasureParent.ObjectId    AS MeasureParentId
                              , MIString_CatalogPage.ValueData AS CatalogPage
                              , MIString_Comment.ValueData     AS Comment
                              , MIBoolean_Outlet.ValueData     AS isOutlet

                           FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                                          ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_EmpfPriceParent.DescId = zc_MIFloat_EmpfPriceParent()
                              LEFT JOIN MovementItemFloat AS MIFloat_MeasureMult
                                                          ON MIFloat_MeasureMult.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MeasureMult.DescId = zc_MIFloat_MeasureMult()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceParent
                                                          ON MIFloat_PriceParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PriceParent.DescId = zc_MIFloat_PriceParent()
                              LEFT JOIN MovementItemFloat AS MIFloat_MinCount
                                                          ON MIFloat_MinCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MinCount.DescId = zc_MIFloat_MinCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_MinCountMult
                                                          ON MIFloat_MinCountMult.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MinCountMult.DescId = zc_MIFloat_MinCountMult()
                              LEFT JOIN MovementItemFloat AS MIFloat_WeightParent
                                                          ON MIFloat_WeightParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_WeightParent.DescId = zc_MIFloat_WeightParent()

                              LEFT JOIN MovementItemBoolean AS MIBoolean_Outlet
                                                            ON MIBoolean_Outlet.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_Outlet.DescId = zc_MIBoolean_Outlet()

                              LEFT JOIN MovementItemString AS MIString_Comment
                                                           ON MIString_Comment.MovementItemId = MovementItem.Id
                                                          AND MIString_Comment.DescId = zc_MIString_Comment()
                              LEFT JOIN MovementItemString AS MIString_CatalogPage
                                                           ON MIString_CatalogPage.MovementItemId = MovementItem.Id
                                                          AND MIString_CatalogPage.DescId = zc_MIString_CatalogPage()

                              LEFT JOIN MovementItemLinkObject AS MILO_DiscountParner
                                                               ON MILO_DiscountParner.MovementItemId = MovementItem.Id
                                                              AND MILO_DiscountParner.DescId = zc_MILinkObject_DiscountParner()
                              LEFT JOIN MovementItemLinkObject AS MILO_Measure
                                                               ON MILO_Measure.MovementItemId = MovementItem.Id
                                                              AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                              LEFT JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                               ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                              AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()

                           WHERE MovementItem.Id     = inId
                             AND MovementItem.DescId = zc_MI_Master()
                          )
              , tmpGoods AS (SELECT inGoodsId AS GoodsId)
              , tmpPriceBasis AS (SELECT tmp.ValuePrice
                                  FROM lpGet_ObjectHistory_PriceListItem ((SELECT Movement.OperDate FROM tmpMI JOIN Movement ON Movement.Id = tmpMI.MovementId)
                                                                        , zc_PriceList_Basis()
                                                                        , COALESCE ((SELECT tmpMI.GoodsId FROM tmpMI WHERE tmpMI.GoodsId > 0), inGoodsId)
                                                                         ) AS tmp
                                 )
           -- Результат
           SELECT
                 tmpMI.Id
               , Object_Goods.Id                AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , ObjectString_Article.ValueData        AS Article
               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull

               , COALESCE (tmpMI.Amount, 1)                           :: TFloat   AS Amount
               , CASE WHEN tmpMI.Id > 0 THEN tmpMI.Amount ELSE 0 END  :: TFloat   AS Amount_old
               , MovementItem.MeasureMult     ::TFloat
               , MovementItem.PriceParent     ::TFloat
               , MovementItem.EmpfPriceParent ::TFloat
               , MovementItem.MinCount        ::TFloat
               , MovementItem.MinCountMult    ::TFloat
               , MovementItem.WeightParent    ::TFloat
 
               , MovementItem.CatalogPage     ::TVarChar
               , MovementItem.Comment         ::TVarChar
               , MovementItem.isOutlet        ::Boolean
           FROM tmpMI
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId   = zc_ObjectString_Article()

                LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                      ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                     AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                      ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                     AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()
               ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.22         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_PriceList (inId:= 52387, inGoodsId:= 1, inSession:= '5');
