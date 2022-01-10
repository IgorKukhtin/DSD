-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Income (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_Income (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Income(
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
                               , COALESCE (MIFloat_OperPrice_orig.ValueData, MIFloat_OperPrice.ValueData, 0)  AS OperPrice_orig
                               , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                               , COALESCE (MIFloat_DiscountTax.ValueData, 0)     AS DiscountTax
                               , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                               , COALESCE (MIFloat_SummIn.ValueData, MovementItem.Amount * COALESCE (MIFloat_OperPrice_orig.ValueData, MIFloat_OperPrice.ValueData, 0)) AS SummIn

                               , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                               , Object_PartionGoods.EmpfPrice                   AS EmpfPrice

                               , COALESCE (MIString_PartNumber.ValueData, '')    AS PartNumber
                               , COALESCE (MIString_Comment.ValueData, '')       AS Comment

                           FROM MovementItem
                                LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.Id
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice_orig
                                                            ON MIFloat_OperPrice_orig.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice_orig.DescId = zc_MIFloat_OperPrice_orig()
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                                LEFT JOIN MovementItemFloat AS MIFloat_DiscountTax
                                                            ON MIFloat_DiscountTax.MovementItemId = MovementItem.Id
                                                           AND MIFloat_DiscountTax.DescId = zc_MIFloat_DiscountTax()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_SummIn
                                                            ON MIFloat_SummIn.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummIn.DescId = zc_MIFloat_SummIn()

                                LEFT JOIN MovementItemString AS MIString_PartNumber
                                                             ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                LEFT JOIN MovementItemString AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()

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
               , ObjectString_Article.ValueData AS Article

               , COALESCE (tmpMI.Amount, 1)                                        :: TFloat   AS Amount
               , CASE WHEN tmpMI.Id > 0 THEN tmpMI.Amount ELSE 0 END               :: TFloat   AS Amount_old
               
               , COALESCE (tmpMI.OperPrice_orig, ObjectFloat_EKPrice.ValueData, 0) :: TFloat   AS OperPrice_orig
               , COALESCE (tmpMI.CountForPrice, 1)                                 :: TFloat   AS CountForPrice
               , COALESCE (tmpMI.DiscountTax, 0)                                   :: TFloat   AS DiscountTax
               , COALESCE (tmpMI.OperPrice, ObjectFloat_EKPrice.ValueData, 0)      :: TFloat   AS OperPrice
               , COALESCE (tmpMI.SummIn, 0)                                        :: TFloat   AS SummIn
               , COALESCE (tmpMI.OperPriceList, tmpPriceBasis.ValuePrice, 0)       :: TFloat   AS OperPriceList
               , COALESCE (tmpMI.EmpfPrice, ObjectFloat_EmpfPrice.ValueData, 0)    :: TFloat   AS EmpfPrice
               , tmpMI.PartNumber                                                  :: TVarChar AS PartNumber
               , tmpMI.Comment                                                     :: TVarChar AS Comment
           FROM tmpGoods
                LEFT JOIN tmpMI ON tmpMI.Id > 0
                LEFT JOIN tmpPriceBasis ON tmpPriceBasis.ValuePrice > 0

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpMI.GoodsId, tmpGoods.GoodsId)
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
 12.10.21         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Income (inId:= 52387, inGoodsId:= 1, inSession:= '5');
