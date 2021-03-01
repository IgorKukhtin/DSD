 -- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId         Integer      , -- ключ Документа
    IN inStartDate          TDateTime    , --
    IN inEndDate            TDateTime    , --
    IN inIsErased           Boolean      , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , JuridicalName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat, Remains TFloat
             , PriceJur TFloat, OperPrice TFloat, CountForPrice TFloat
             , OperPriceList TFloat, OperPriceList_grn TFloat
             , TotalSumm TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat, TotalSummPriceList_grn TFloat, TotalSummPriceJur TFloat
             , PriceTax TFloat       -- % наценки
             , Color_Calc Integer
             , ContainerId Integer
             , isProtocol Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId         Integer;
  DECLARE vbCurrencyId_Doc Integer;
  DECLARE vbCurrencyValue  TFloat;
  DECLARE vbParValue       TFloat;
  DECLARE vbUnitId         Integer;
  DECLARE vbCurrencyId_pl  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_Income());


     -- Определили курс в документе
     SELECT MLO_CurrencyDocument.ObjectId AS CurrencyId_Doc
          , MF_CurrencyValue.ValueData    AS CurrencyValue
          , MF_ParValue.ValueData         AS ParValue
          , COALESCE (ObjectLink_currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl -- Получили валюту для прайса
            INTO vbCurrencyId_Doc, vbCurrencyValue, vbParValue, vbCurrencyId_pl
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_CurrencyDocument
                                       ON MLO_CurrencyDocument.MovementId = Movement.Id
                                      AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()

          LEFT JOIN MovementFloat AS MF_CurrencyValue
                                  ON MF_CurrencyValue.MovementId = MLO_CurrencyDocument.MovementId
                                 AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MF_ParValue
                                  ON MF_ParValue.MovementId = MLO_CurrencyDocument.MovementId
                                 AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_PriceList 
                               ON ObjectLink_PriceList.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
          LEFT JOIN ObjectLink AS ObjectLink_currency 
                               ON ObjectLink_currency.ObjectId = ObjectLink_PriceList.ChildObjectId
                              AND ObjectLink_currency.DescId   = zc_ObjectLink_PriceList_Currency()

     WHERE Movement.Id = inMovementId;

     -- Параметры документа - Подразделение
     SELECT MovementLinkObject_To.ObjectId
          INTO vbUnitId
     FROM MovementLinkObject AS MovementLinkObject_To
     WHERE MovementLinkObject_To.MovementId = inMovementId
       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();
     
     -- Результат
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_PriceJur.ValueData, 0)        AS PriceJur
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0) 
                             * (CASE WHEN vbCurrencyId_Doc <> zc_Currency_GRN() THEN 1 WHEN vbCurrencyValue <> 0 THEN vbCurrencyValue ELSE 1 END
                              / CASE WHEN vbCurrencyId_Doc <> zc_Currency_GRN() THEN 1 WHEN vbParValue <> 0 THEN vbParValue ELSE 1 END)         AS OperPriceList
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0) 
                             * (CASE WHEN vbCurrencyId_Doc = zc_Currency_GRN() THEN 1 WHEN vbCurrencyValue <> 0 THEN vbCurrencyValue ELSE 1 END
                              / CASE WHEN vbCurrencyId_Doc = zc_Currency_GRN() THEN 1 WHEN vbParValue <> 0 THEN vbParValue ELSE 1 END)          AS OperPriceList_grn
                             -- Сумма по Вх. в Валюте - с округлением до 2-х знаков
                           , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                             -- Сумма по Вх. в zc_Currency_Basis
                           , zfCalc_SummIn (MovementItem.Amount
                                            -- Цена Вх. в Валюте - сначала переводим в zc_Currency_Basis - с округлением до 2-х знаков
                                          , zfCalc_PriceIn_Basis (vbCurrencyId_Doc, MIFloat_OperPrice.ValueData, vbCurrencyValue, vbParValue)
                                          , MIFloat_CountForPrice.ValueData
                                           ) AS TotalSummBalance
                                           
                             -- ГРН Сумма по Прайсу - с округлением до 0/2-х знаков
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) 
                             * (CASE WHEN vbCurrencyId_Doc <> zc_Currency_GRN() THEN 1 WHEN vbCurrencyValue <> 0 THEN vbCurrencyValue ELSE 1 END
                              / CASE WHEN vbCurrencyId_Doc <> zc_Currency_GRN() THEN 1 WHEN vbParValue <> 0 THEN vbParValue ELSE 1 END)         AS TotalSummPriceList
                             -- ВАЛЮТА Сумма по Прайсу - с округлением до 0/2-х знаков
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                             * (CASE WHEN vbCurrencyId_Doc = zc_Currency_GRN() THEN 1 WHEN vbCurrencyValue <> 0 THEN vbCurrencyValue ELSE 1 END
                              / CASE WHEN vbCurrencyId_Doc = zc_Currency_GRN() THEN 1 WHEN vbParValue <> 0 THEN vbParValue ELSE 1 END)          AS TotalSummPriceList_grn

                              -- Сумма по Вх. без скидки 
                           , zfCalc_SummIn (MovementItem.Amount, MIFloat_PriceJur.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSummPriceJur
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
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceJur
                                                        ON MIFloat_PriceJur.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceJur.DescId         = zc_MIFloat_PriceJur()
                     )
   , tmpProtocol AS (SELECT DISTINCT MovementItemProtocol.MovementItemId
                     FROM MovementItemProtocol
                     WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                       AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                    )
     -- остатки
   , tmpContainer AS (SELECT DISTINCT Container.*
                      FROM tmpMI
                           INNER JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                               AND Container.WhereObjectId = vbUnitId
                                               AND Container.DescId        = zc_Container_Count()
                                               -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                               AND Container.ObjectId      = tmpMI.GoodsId
                                               -- !!!обязательно условие, т.к. мог меняться GoodsSizeId и тогда в Container - несколько строк!!!
                                               AND Container.Amount        <> 0
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                     )

       -- Результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , OL_Goods_GoodsGroup.ChildObjectId   AS GoodsGroupId
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData            AS MeasureName
           , Object_Juridical.ValueData          AS JuridicalName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.ValueData        AS CompositionName
           , Object_GoodsInfo.ValueData          AS GoodsInfoName
           , Object_LineFabrica.ValueData        AS LineFabricaName
           , Object_Label.ValueData              AS LabelName
           , Object_GoodsSize.Id                 AS GoodsSizeId
           , Object_GoodsSize.ValueData          AS GoodsSizeName

           , tmpMI.Amount
           , Container.Amount              :: TFloat AS Remains
           , tmpMI.PriceJur                :: TFloat AS PriceJur
           , tmpMI.OperPrice               :: TFloat AS OperPrice
           , tmpMI.CountForPrice           :: TFloat AS CountForPrice
           , tmpMI.OperPriceList           :: TFloat AS OperPriceList
           , tmpMI.OperPriceList_grn       :: TFloat AS OperPriceList_grn
           , tmpMI.TotalSumm               :: TFloat AS TotalSumm
           , tmpMI.TotalSummBalance        :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList      :: TFloat AS TotalSummPriceList
           , tmpMI.TotalSummPriceList_grn  :: TFloat AS TotalSummPriceList_grn
           , tmpMI.TotalSummPriceJur       :: TFloat AS TotalSummPriceJur
           
           -- % наценки
           , CAST (CASE WHEN tmpMI.TotalSummBalance <> 0
                        THEN (100 * tmpMI.TotalSummPriceList * CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE OR vbCurrencyId_Doc = zc_Currency_Basis()
                                                                         THEN 1
                                                                    ELSE CASE WHEN vbParValue > 0 THEN vbCurrencyValue / vbParValue ELSE vbCurrencyValue END
                                                               END
                            / tmpMI.TotalSummBalance
                              - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

           , CASE WHEN CAST (CASE WHEN tmpMI.TotalSummBalance <> 0
                                  THEN (100 * tmpMI.TotalSummPriceList * CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE OR vbCurrencyId_Doc = zc_Currency_Basis()
                                                                                   THEN 1
                                                                              ELSE CASE WHEN vbParValue > 0 THEN vbCurrencyValue / vbParValue ELSE vbCurrencyValue END
                                                                         END
                                      / tmpMI.TotalSummBalance
                                        - 100)
                                  ELSE 0
                             END AS NUMERIC (16, 0)) <= 10 
                 THEN zc_Color_Red() 
                 ELSE zc_Color_Black() 
              END :: Integer  AS Color_Calc

           , Container.Id  AS ContainerId

           , CASE WHEN tmpProtocol.MovementItemId > 0 THEN TRUE ELSE FALSE END AS isProtocol
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id

            LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId
                                               AND Container.ObjectId  = tmpMI.GoodsId

            LEFT JOIN Object_PartionGoods               ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id     = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId

            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id       = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id   = Object_PartionGoods.JuridicalId

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.02.19         *
 03.05.18         *
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 1, inStartDate:= '01.05.2018', inEndDate := '01.05.2018', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
