-- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PartionId Integer, InvNumber_Partion TVarChar, OperDate_Partion TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , PartnerName  TVarChar
             , BrandName    TVarChar
             , PeriodName   TVarChar
             , PeriodYear   Integer
             , Amount TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat
             , OperPriceList TFloat
             , TotalSumm TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
  DECLARE vbPartnerId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_Loss());
     --vbUserId:= lpGetUserBySession (inSession);

     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbUnitId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     IF inShowAll = TRUE
     THEN
        -- Показываем ВСЕ
        RETURN QUERY 
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId AS GoodsId
                              , MovementItem.PartionId
                              , MovementItem.Amount 
                              , COALESCE (MIFloat_CurrencyValue.ValueData, 0)   AS CurrencyValue
                              , COALESCE (MIFloat_ParValue.ValueData, 0)        AS ParValue
                              , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                              , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                              , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                              , CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                THEN MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                            ELSE MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0)
                                      END AS NUMERIC (16, 2)) AS TotalSumm
                              , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceList
                              , MovementItem.isErased
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                           ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                           ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
   
                               LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                           ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                               LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                           ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
   
                          )
       , tmpCurrency AS (SELECT * FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                                        , inCurrencyFromId:= zc_Currency_Basis()
                                                                        , inCurrencyToId  := 0
                                                                         ) AS lfSelect
                        )
       , tmpPartion AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                             , Object_PartionGoods.MovementId
                             , Object_PartionGoods.GoodsId
                             , Object_PartionGoods.GoodsGroupId
                             , Object_PartionGoods.MeasureId
                             , Object_PartionGoods.CompositionId
                             , Object_PartionGoods.GoodsInfoId
                             , Object_PartionGoods.LineFabricaId
                             , Object_PartionGoods.LabelId
                             , Object_PartionGoods.GoodsSizeId
                             , Object_PartionGoods.PartnerId
                             , Object_PartionGoods.BrandId
                             , Object_PartionGoods.PeriodId
                             , Object_PartionGoods.PeriodYear
                             , Object_PartionGoods.OperPrice
                             , Object_PartionGoods.CountForPrice
                             , Object_PartionGoods.OperPriceList
                             , Container.Amount                   AS Remains
                             , COALESCE (tmp.Amount, 1)           AS CurrencyValue
                             , COALESCE (tmp.ParValue,0)          AS ParValue
                        FROM Object_PartionGoods
                             INNER JOIN Container ON Container.PartionId     = Object_PartionGoods.MovementItemId
                                                 AND Container.WhereObjectId = vbUnitId
                                                 AND Container.DescId        = zc_Container_count()
                                                 -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                                 AND Container.ObjectId      = Object_PartionGoods.GoodsId
                                                 -- !!!обязательно условие, т.к. мог меняться GoodsSizeId и тогда в Container - несколько строк!!!
                                                 AND Container.Amount        <> 0
                             LEFT JOIN ContainerLinkObject AS CLO_Client
                                                           ON CLO_Client.ContainerId = Container.Id
                                                          AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                             LEFT JOIN tmpCurrency AS tmp ON 1=0
                        WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                       )
         -- Последняя цена из Прайс-листа - zc_PriceList_Basis
      /* , tmpPriceList AS (SELECT tmp.GoodsId
                               , OHF_Value.ValueData AS OperPriceList
                          FROM (SELECT DISTINCT tmpPartion.GoodsId FROM tmpPartion) AS tmp
                               INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                     ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                    AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                     ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                    AND OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!Базовай Прайс!!!
                                                    AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_Goods()

                               INNER JOIN ObjectHistory AS OH_PriceListItem
                                                        ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                       AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                       AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                               LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                            ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                           AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                         )
        */
   
     -- остатки
   , tmpContainer AS (SELECT Container.ObjectId
                           , Container.PartionId
                           , SUM (COALESCE(Container.Amount, 0)) AS Amount
                      FROM tmpMI
                           INNER JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                               AND Container.WhereObjectId = vbUnitId
                                               AND Container.DescId        = zc_Container_count()
                                               -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                               AND Container.ObjectId      = tmpMI.GoodsId
                                               -- !!!обязательно условие, т.к. мог меняться GoodsSizeId и тогда в Container - несколько строк!!!
                                               AND Container.Amount        <> 0
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                      GROUP BY Container.ObjectId
                             , Container.PartionId
                     )
           -- результат
           SELECT 0                              AS Id
                , tmpPartion.PartionId
                , Movement_Partion.InvNumber     AS InvNumber_Partion
                , Movement_Partion.OperDate      AS OperDate_Partion
                , Object_Goods.Id                AS GoodsId
                , Object_Goods.ObjectCode        AS GoodsCode
                , Object_Goods.ValueData         AS GoodsName
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_Measure.ValueData AS MeasureName
     
                , Object_Composition.ValueData   AS CompositionName
                , Object_GoodsInfo.ValueData     AS GoodsInfoName
                , Object_LineFabrica.ValueData   AS LineFabricaName
                , Object_Label.ValueData         AS LabelName
                , Object_GoodsSize.Id            AS GoodsSizeId
                , Object_GoodsSize.ValueData     AS GoodsSizeName 
                , Object_Partner.ValueData       AS PartnerName
                , Object_Brand.ValueData         AS BrandName
                , Object_Period.ValueData        AS PeriodName
                , tmpPartion.PeriodYear          AS PeriodYear

                , 0                          :: TFloat AS Amount
                , tmpPartion.Remains         :: TFloat AS Remains
                , tmpPartion.OperPrice       :: TFloat AS OperPrice
                , tmpPartion.CountForPrice   :: TFloat AS CountForPrice
                --, tmpPriceList.OperPriceList :: TFloat AS OperPriceList
                , tmpPartion.OperPriceList   :: TFloat AS OperPriceList
                , 0                          :: TFloat AS TotalSumm
                , 0                          :: TFloat AS TotalSummBalance
                , 0                          :: TFloat AS TotalSummPriceList
 
                , tmpPartion.CurrencyValue   ::TFloat
                , tmpPartion.ParValue        ::TFloat

                , tmpMI.isErased
   
           FROM tmpPartion
                LEFT JOIN tmpMI        ON tmpMI.PartionId      = tmpPartion.PartionId
                --LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpPartion.GoodsId
                LEFT JOIN Movement  AS Movement_Partion ON Movement_Partion.Id  = tmpPartion.MovementId
                LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpPartion.GoodsId
                LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = tmpPartion.GoodsGroupId
                LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpPartion.MeasureId
                LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = tmpPartion.CompositionId
                LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = tmpPartion.GoodsInfoId
                LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = tmpPartion.LineFabricaId
                LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = tmpPartion.LabelId
                LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = tmpPartion.GoodsSizeId
                LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpPartion.PartnerId
                LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = tmpPartion.BrandId
                LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = tmpPartion.PeriodId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpPartion.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
           WHERE tmpMI.PartionId IS NULL

     UNION ALL
           -- Показываем только строки документа 
           SELECT
                 tmpMI.Id
               , tmpMI.PartionId
               , Movement_Partion.InvNumber     AS InvNumber_Partion
               , Movement_Partion.OperDate      AS OperDate_Partion
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
               , Object_Partner.ValueData       AS PartnerName
               , Object_Brand.ValueData         AS BrandName
               , Object_Period.ValueData        AS PeriodName
               , Object_PartionGoods.PeriodYear AS PeriodYear

               , tmpMI.Amount
               , Container.Amount          ::TFloat AS Remains
    
               , tmpMI.OperPrice           ::TFloat
               , tmpMI.CountForPrice       ::TFloat
               , tmpMI.OperPriceList       ::TFloat
               , tmpMI.TotalSumm           ::TFloat
               , (CAST (tmpMI.TotalSumm * tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance 
               , tmpMI.TotalSummPriceList  ::TFloat
    
               , tmpMI.CurrencyValue       ::TFloat
               , tmpMI.ParValue            ::TFloat
    
               , tmpMI.isErased
    
           FROM tmpMI
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id                    = tmpMI.GoodsId
                LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

                LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId
                                                   AND Container.ObjectId  = tmpMI.GoodsId
    
                LEFT JOIN Movement AS Movement_Partion      ON Movement_Partion.Id        = Object_PartionGoods.MovementId
                LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
                LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
                LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
                LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
                LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
                LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
                LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
                LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = Object_PartionGoods.PartnerId
                LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
                LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
          ;

     ELSE 
         -- Результат такой - Показываем только строки документа
         RETURN QUERY 
           WITH tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.ObjectId AS GoodsId
                               , MovementItem.PartionId
                               , MovementItem.Amount 
                               , COALESCE (MIFloat_CurrencyValue.ValueData, 0)   AS CurrencyValue
                               , COALESCE (MIFloat_ParValue.ValueData, 0)        AS ParValue
                               , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                               , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                               , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                               , CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                 THEN MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                             ELSE MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0)
                                       END AS NUMERIC (16, 2)) AS TotalSumm
                               , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceList
                               , MovementItem.isErased
                           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
    
                                LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                            ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                                LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                            ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
    
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
           -- результат
           SELECT
                 tmpMI.Id
               , tmpMI.PartionId
               , Movement_Partion.InvNumber     AS InvNumber_Partion
               , Movement_Partion.OperDate      AS OperDate_Partion
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
               , Object_Partner.ValueData       AS PartnerName
               , Object_Brand.ValueData         AS BrandName
               , Object_Period.ValueData        AS PeriodName
               , Object_PartionGoods.PeriodYear AS PeriodYear

               , tmpMI.Amount
               , Container.Amount          ::TFloat AS Remains
    
               , tmpMI.OperPrice           ::TFloat
               , tmpMI.CountForPrice       ::TFloat
               , tmpMI.OperPriceList       ::TFloat
               , tmpMI.TotalSumm           ::TFloat
               , (CAST (tmpMI.TotalSumm * tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance 
               , tmpMI.TotalSummPriceList  ::TFloat
    
               , tmpMI.CurrencyValue       ::TFloat
               , tmpMI.ParValue            ::TFloat
    
               , tmpMI.isErased
    
           FROM tmpMI
                LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId
                                                   AND Container.ObjectId  = tmpMI.GoodsId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 


                LEFT JOIN Movement AS Movement_Partion      ON Movement_Partion.Id        = Object_PartionGoods.MovementId
                LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
                LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
                LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
                LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
                LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
                LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
                LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
                LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = Object_PartionGoods.PartnerId
                LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
                LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.18         *
 21.06.17         *
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 7, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 7, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
