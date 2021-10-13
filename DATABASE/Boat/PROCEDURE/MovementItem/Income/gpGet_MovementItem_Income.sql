
-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Income(
    IN inId             Integer  , -- ключ
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar
             , Amount         TFloat
             , CountForPrice  TFloat
             , OperPrice_orig TFloat
             , DiscountTax    TFloat
             , OperPrice      TFloat
             , SummIn         TFloat
             , OperPriceList  TFloat
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
                               , MovementItem.ObjectId AS GoodsId
                               , MovementItem.PartionId
                               , MovementItem.Amount
                               , COALESCE (MIFloat_OperPrice_orig.ValueData, 0)  AS OperPrice_orig
                               , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                               , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                               , COALESCE (MIFloat_DiscountTax.ValueData, 0)     AS DiscountTax
                               , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                               , COALESCE (MIFloat_SummIn.ValueData, 0)          AS SummIn
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice_orig
                                                            ON MIFloat_OperPrice_orig.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice_orig.DescId = zc_MIFloat_OperPrice_orig()

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
                           WHERE MovementItem.Id     = inId
                             AND MovementItem.DescId = zc_MI_Master()
                          )

           -- Результат
           SELECT
                 tmpMI.Id
               , Object_Goods.Id                AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , ObjectString_Article.ValueData AS Article
               , tmpMI.Amount         ::TFloat
               , tmpMI.CountForPrice  ::TFloat
               , tmpMI.OperPrice_orig ::TFloat
               , tmpMI.DiscountTax    ::TFloat
               , tmpMI.OperPrice      ::TFloat
               , tmpMI.SummIn         ::TFloat
               , tmpMI.OperPriceList  ::TFloat
           FROM tmpMI
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()
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
-- select * from gpGet_MovementItem_Income(inId := 52387 ,  inSession := '5');