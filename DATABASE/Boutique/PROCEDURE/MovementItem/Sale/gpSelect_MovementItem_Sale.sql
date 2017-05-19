-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId       Integer      , -- ключ Документа
--    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeName TVarChar
             , BarCode TVarChar
             , DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
             , Amount TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , AmountSumm TFloat, AmountPriceListSumm TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , ChangePercent TFloat, SummChangePercent TFloat
             , TotalChangePercent TFloat, TotalChangePercentPay TFloat
             , TotalSummPay TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat
             , TotalPayOth TFloat
             , TotalCountReturn TFloat, TotalReturn TFloat
             , TotalPayReturn TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат такой
     RETURN QUERY 
     WITH 
     tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId
                           , MILinkObject_DiscountSaleKind.ObjectId                AS DiscountSaleKindId
                           , MIString_BarCode.ValueData                            AS BarCode
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)             AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)         AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn
                           , MovementItem.isErased
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()  
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                        ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                        ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                        ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                        ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                        ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()    

                            LEFT JOIN MovementItemString AS MIString_BarCode
                                                         ON MIString_BarCode.MovementItemId = MovementItem.Id
                                                        AND MIString_BarCode.DescId         = zc_MIString_BarCode()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                             ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_DiscountSaleKind.DescId = zc_MILinkObject_DiscountSaleKind()
                       )

    , tmpMI_Child AS (SELECT MovementItem.ParentId
                         --, MILinkObject_Currency.ObjectId                AS CurrencyId
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MovementItem.Amount ELSE 0 END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS Amount_Bank
                           --, MovementItem.isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                      GROUP BY MovementItem.ParentId
                      )


       -- результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName 
           , tmpMI.BarCode

           , Object_DiscountSaleKind.Id        AS DiscountSaleKindId
           , Object_DiscountSaleKind.ValueData AS DiscountSaleKindName

           , tmpMI.Amount         ::TFloat

           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , tmpMI.OperPriceList  ::TFloat

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountPriceListSumm

           , tmpMI.CurrencyValue            ::TFloat
           , tmpMI.ParValue                 ::TFloat
           , tmpMI.ChangePercent            ::TFloat
           , tmpMI.SummChangePercent        ::TFloat
           , tmpMI.TotalChangePercent       ::TFloat
           , tmpMI.TotalChangePercentPay    ::TFloat

           , CAST ((CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList AS NUMERIC (16, 2))
                   END) - tmpMI.TotalChangePercent
                 AS TFloat) AS TotalSummPay

           , tmpMI_Child.Amount_GRN         ::TFloat AS TotalPay_Grn 
           , tmpMI_Child.Amount_USD         ::TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR         ::TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank        ::TFloat AS TotalPay_Card
           , tmpMI.TotalPay                 ::TFloat
           , tmpMI.TotalPayOth              ::TFloat
           , tmpMI.TotalCountReturn         ::TFloat
           , tmpMI.TotalReturn              ::TFloat
           , tmpMI.TotalPayReturn           ::TFloat

           , tmpMI.isErased

       FROM tmpMI_Master AS tmpMI
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpMI.DiscountSaleKindId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.05.17         *
*/

-- тест
--select * from gpSelect_MovementItem_Sale(inMovementId := 7 , inIsErased := 'False' ,  inSession := '2');