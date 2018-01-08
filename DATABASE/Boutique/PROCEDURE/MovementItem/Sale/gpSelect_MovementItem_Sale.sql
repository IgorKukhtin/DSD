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
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , DiscountSaleKindId Integer, DiscountSaleKindName TVarChar
             , Amount TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , TotalSumm TFloat
             , TotalSummBalance TFloat
             , TotalSummPriceList TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , ChangePercent TFloat, SummChangePercent TFloat
             , TotalChangePercent TFloat, TotalChangePercentPay TFloat
             , TotalSummToPay TFloat, TotalSummDebt TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat
             , TotalPayOth TFloat
             , TotalCountReturn TFloat, TotalReturn TFloat
             , TotalPayReturn TFloat

             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat

             , BarCode TVarChar
             , Comment TVarChar
             , isClose Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- Параметры документа
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- Результат такой
     RETURN QUERY
     WITH
     tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId
                           , MILinkObject_DiscountSaleKind.ObjectId                AS DiscountSaleKindId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)             AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)         AS CountForPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                           , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)                       AS TotalSummPriceList

                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent     -- Дополнительная скидка в продаже ГРН
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent    -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки + 2)дополнительная
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay -- Дополнительная скидка в расчетах ГРН
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay              -- Итого оплата в продаже ГРН
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth           -- Итого оплата в расчетах ГРН
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn      -- Кол-во возврат
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn           -- Сумма возврата ГРН
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn        -- Сумма возврата оплаты ГРН
                           , MIString_BarCode.ValueData                            AS BarCode
                           , MIString_Comment.ValueData                            AS Comment
                           , COALESCE (MIBoolean_Close.ValueData, FALSE)           AS isClose
                           , MovementItem.isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
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

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                             ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_DiscountSaleKind.DescId = zc_MILinkObject_DiscountSaleKind()

                            LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                          ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Close.DescId         = zc_MIBoolean_Close()
                            LEFT JOIN MovementItemString AS MIString_BarCode
                                                         ON MIString_BarCode.MovementItemId = MovementItem.Id
                                                        AND MIString_BarCode.DescId         = zc_MIString_BarCode()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
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
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                     )
   , tmpContainer AS (SELECT Container.*
                      FROM tmpMI_Master
                           INNER JOIN Container ON Container.PartionId     = tmpMI_Master.PartionId
                                               AND Container.WhereObjectId = vbUnitId
                                               AND Container.DescId        = zc_Container_count()
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
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

           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName

           , Object_DiscountSaleKind.Id        AS DiscountSaleKindId
           , Object_DiscountSaleKind.ValueData AS DiscountSaleKindName

           , tmpMI.Amount         :: TFloat AS Amount
           , Container.Amount     :: TFloat AS Remains

           , tmpMI.OperPrice      :: TFloat AS OperPrice
           , tmpMI.CountForPrice  :: TFloat AS CountForPrice
           , tmpMI.OperPriceList  :: TFloat AS OperPriceList

           , tmpMI.TotalSumm           :: TFloat AS TotalSumm
           , zfCalc_CurrencyFrom (tmpMI.TotalSumm, tmpMI.CurrencyValue, tmpMI.ParValue) :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList  :: TFloat AS TotalSummPriceList

           , tmpMI.CurrencyValue            :: TFloat AS CurrencyValue
           , tmpMI.ParValue                 :: TFloat AS ParValue
           , tmpMI.ChangePercent            :: TFloat AS ChangePercent         -- % Скидки
           , tmpMI.SummChangePercent        :: TFloat AS SummChangePercent     -- Дополнительная скидка в продаже ГРН
           , tmpMI.TotalChangePercent       :: TFloat AS TotalChangePercent    -- Итого скидка в продаже ГРН
           , tmpMI.TotalChangePercentPay    :: TFloat AS TotalChangePercentPay -- Дополнительная скидка в расчетах ГРН

             -- Сумма к оплате ГРН
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList) - tmpMI.TotalChangePercent) :: TFloat AS TotalSummToPay
             -- Сумма долга в продаже ГРН
           , (zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList) - tmpMI.TotalChangePercent - tmpMI.TotalPay) :: TFloat AS TotalSummDebt

           , tmpMI_Child.Amount_GRN         :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD         :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR         :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank        :: TFloat AS TotalPay_Card

           , tmpMI.TotalPay                 :: TFloat AS TotalPay          -- Итого оплата в продаже ГРН
           , tmpMI.TotalPayOth              :: TFloat AS TotalPayOth       -- Итого оплата в расчетах ГРН
           , tmpMI.TotalCountReturn         :: TFloat AS TotalCountReturn  -- Кол-во возврат
           , tmpMI.TotalReturn              :: TFloat AS TotalReturn       -- Сумма возврата ГРН
           , tmpMI.TotalPayReturn           :: TFloat AS TotalPayReturn    -- Сумма возврата оплаты ГРН
           
           , tmpMI_Child_Exc.Amount_USD     :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR     :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN     :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.BarCode
           , tmpMI.Comment
           , tmpMI.isClose :: Boolean AS isClose
           , tmpMI.isErased

       FROM tmpMI_Master AS tmpMI
            LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId
                                               AND Container.ObjectId  = tmpMI.GoodsId   -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!

            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

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
-- SELECT * FROM gpSelect_MovementItem_Sale (inMovementId:= 7, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
