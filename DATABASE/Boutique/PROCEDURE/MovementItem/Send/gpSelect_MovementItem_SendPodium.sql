-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId       Integer      , -- ключ Документа
    IN inStartDate        TDateTime    , --
    IN inEndDate          TDateTime    , --
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (NPP Integer
             , Id Integer
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
             , Amount TFloat
             , Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat
             , OperPriceList TFloat, OperPriceListTo TFloat, OperPriceListTo_start TFloat
             , OperPriceListBalance TFloat

             , OperPriceList_disc TFloat
             , OperPriceListTo_disc TFloat
             , OperPriceListBalance_disc TFloat
             , OperPriceListToBalance_disc TFloat

             , TotalSumm TFloat , TotalSummBalance TFloat

             , TotalSummPLBalance TFloat, TotalSummPLToBalance TFloat, TotalSummPLToBalance_start TFloat
             , TotalSummPL TFloat, TotalSummPLTo TFloat, TotalSummPLTo_start TFloat 

             , TotalSummPL_disc TFloat
             , TotalSummPLTo_disc TFloat
             , TotalSummPLBalance_disc TFloat
             , TotalSummPLToBalance_disc TFloat

             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyName_pl TVarChar, CurrencyName_pl_to TVarChar
             , DiscountTax_From TFloat, DiscountTax_To TFloat
             , isProtocol Boolean
             , isOlap Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId_From        Integer;
  DECLARE vbUnitId_To          Integer;
  DECLARE vbPriceListId_from   Integer;
  DECLARE vbPriceListId_to     Integer;
  DECLARE vbCurrencyId_pl_from Integer;
  DECLARE vbCurrencyId_pl_to   Integer;
  DECLARE vbOperDate           TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_Send());


     -- !!!Замена!!!
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         -- inShowAll:= NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE);
         -- теперь попробуем в таком режиме
         inShowAll:= FALSE;
     END IF;


     -- данные из шапки
     SELECT Movement.OperDate                                                                AS OperDate
          , MovementLinkObject_From.ObjectId                                                 AS vbUnitId_From
          , MovementLinkObject_To.ObjectId                                                   AS vbUnitId_To
          , COALESCE (ObjectLink_Unit_PriceList_from.ChildObjectId, zc_PriceList_Basis())    AS PriceListId_from
          , COALESCE (ObjectLink_Unit_PriceList_to.ChildObjectId, zc_PriceList_Basis())      AS PriceListId_to
          , COALESCE (ObjectLink_PriceList_Currency_from.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl_from
          , COALESCE (ObjectLink_PriceList_Currency_to.ChildObjectId, zc_Currency_Basis())   AS CurrencyId_pl_to
            INTO vbOperDate, vbUnitId_From, vbUnitId_To, vbPriceListId_from, vbPriceListId_to, vbCurrencyId_pl_from, vbCurrencyId_pl_to
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList_from
                               ON ObjectLink_Unit_PriceList_from.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Unit_PriceList_from.DescId   = zc_ObjectLink_Unit_PriceList()
          LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency_from
                               ON ObjectLink_PriceList_Currency_from.ObjectId = ObjectLink_Unit_PriceList_from.ChildObjectId
                              AND ObjectLink_PriceList_Currency_from.DescId   = zc_ObjectLink_PriceList_Currency()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList_to
                               ON ObjectLink_Unit_PriceList_to.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Unit_PriceList_to.DescId   = zc_ObjectLink_Unit_PriceList()
          LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency_to
                               ON ObjectLink_PriceList_Currency_to.ObjectId = ObjectLink_Unit_PriceList_to.ChildObjectId
                              AND ObjectLink_PriceList_Currency_to.DescId   = zc_ObjectLink_PriceList_Currency()

     WHERE Movement.Id = inMovementId;


     IF inShowAll = TRUE
     THEN
        -- Показываем ВСЕ
        RETURN QUERY
        WITH
         tmpReportOLAP AS (SELECT DISTINCT ObjectLink_Object.ChildObjectId AS PartionId
                                --, Object_PartionGoods.GoodsId
                           FROM Object
                                INNER JOIN ObjectLink AS ObjectLink_User
                                                      ON ObjectLink_User.ObjectId      = Object.Id
                                                     AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                     AND ObjectLink_User.ChildObjectId = vbUserId

                                INNER JOIN ObjectLink AS ObjectLink_Object
                                                      ON ObjectLink_Object.ObjectId = Object.Id
                                                     AND ObjectLink_Object.DescId   = zc_ObjectLink_ReportOLAP_Object()
                                -- привязываем по партии, для партии определяем какой товар
                                --INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = ObjectLink_Object.ChildObjectId
                           WHERE Object.DescId = zc_Object_ReportOLAP()
                             AND Object.ObjectCode IN (3)
                             AND Object.isErased = FALSE
                           )

       , tmpMI AS (SELECT ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) AS NPP
                        , MovementItem.Id
                        , MovementItem.ObjectId AS GoodsId
                        , MovementItem.PartionId
                        , MovementItem.Amount
                        , COALESCE (MIFloat_CurrencyValue.ValueData, 0)   AS CurrencyValue
                        , COALESCE (MIFloat_ParValue.ValueData, 0)        AS ParValue
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                        , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                        , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                        , COALESCE (MIFloat_OperPriceListTo.ValueData, 0) AS OperPriceListTo
                        , COALESCE (MIFloat_OperPriceListTo_start.ValueData, 0) AS OperPriceListTo_start
                        , CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                          THEN MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                      ELSE MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0)
                                END AS NUMERIC (16, 2)) AS TotalSumm
                        , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS NUMERIC (16, 2)) AS TotalSummPriceList
                        , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceListTo.ValueData, 0)       AS NUMERIC (16, 2)) AS TotalSummPriceListTo
                        , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceListTo_start.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceListTo_start
                        , MovementItem.isErased

                    FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                         JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = tmpIsErased.isErased
                         LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                     ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                     ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo
                                                     ON MIFloat_OperPriceListTo.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceListTo.DescId = zc_MIFloat_OperPriceListTo()
                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo_start
                                                     ON MIFloat_OperPriceListTo_start.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceListTo_start.DescId = zc_MIFloat_OperPriceListTo_start()

                         LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                     ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

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
                           --, Object_PartionGoods.OperPriceList
                             , Container.Amount                   AS Remains
                             , COALESCE (tmp.Amount, 1)           AS CurrencyValue
                             , COALESCE (tmp.ParValue,0)          AS ParValue
                        FROM Object_PartionGoods
                             INNER JOIN Container ON Container.PartionId     = Object_PartionGoods.MovementItemId
                                                 AND Container.WhereObjectId = vbUnitId_From
                                                 AND Container.DescId        = zc_Container_count()
                                                 AND COALESCE (Container.Amount,0)  <> 0
                                                 -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                                 AND Container.ObjectId      = Object_PartionGoods.GoodsId
                             LEFT JOIN ContainerLinkObject AS CLO_Client
                                                           ON CLO_Client.ContainerId = Container.Id
                                                          AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                             LEFT JOIN tmpCurrency AS tmp ON 1=0
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                       )
    -- Последняя цена из Прайс-листа - vbPriceListId_from
  , tmpPriceList_from AS (SELECT tmp.GoodsId
                               , OHF_Value.ValueData AS OperPriceList
                               , COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_from) AS CurrencyId
                          FROM (SELECT DISTINCT tmpPartion.GoodsId FROM tmpPartion) AS tmp
                               INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                     ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                    AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                     ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                    AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_from
                                                    AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                               INNER JOIN ObjectHistory AS OH_PriceListItem
                                                        ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                       AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                       AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                               LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                                           ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                          AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                               LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                            ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                           AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                         )
      -- Последняя цена из Прайс-листа - vbPriceListId_to
    , tmpPriceList_to AS (SELECT tmp.GoodsId
                               , MAX (CASE WHEN OH_PriceListItem.EndDate   = zc_DateEnd()   THEN OHF_Value.ValueData ELSE 0 END) AS OperPriceList
                               , MAX (CASE WHEN OH_PriceListItem.StartDate = zc_DateStart() THEN OHF_Value.ValueData ELSE 0 END) AS OperPriceList_start
                               , COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
                          FROM (SELECT DISTINCT tmpPartion.GoodsId FROM tmpPartion) AS tmp
                               INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                     ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                    AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                     ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                    AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                                                    AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                               INNER JOIN ObjectHistory AS OH_PriceListItem
                                                        ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                       AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                     --AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                               LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                                           ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                          AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                               LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                            ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                           AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                          GROUP BY tmp.GoodsId
                                 , COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to)
                         )
     -- остатки
   , tmpContainer AS (SELECT Container.ObjectId
                           , Container.PartionId
                           , SUM (COALESCE(Container.Amount, 0)) AS Amount
                      FROM tmpMI
                           INNER JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                               AND Container.WhereObjectId = vbUnitId_From
                                               AND Container.DescId        = zc_Container_count()
                                               AND COALESCE(Container.Amount, 0) <> 0
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
     --- сезонная скидка
   , tmpDiscountList AS (SELECT DISTINCT vbUnitId_From AS UnitId, tmpPartion.GoodsId FROM tmpPartion
                        UNION
                         SELECT DISTINCT vbUnitId_To   AS UnitId, tmpPartion.GoodsId FROM tmpPartion
                         )

   , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpPartion.GoodsId FROM tmpPartion)
                                           AND ObjectLink.DescId        = zc_ObjectLink_DiscountPeriodItem_Goods()
               )
   , tmpOL2 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpOL1.ObjectId FROM tmpOL1)
                                           AND ObjectLink.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
               )

   , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Unit.ChildObjectId      AS UnitId
                          , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                     FROM tmpDiscountList
                          INNER JOIN tmpOL1 AS ObjectLink_DiscountPeriodItem_Goods
                                                ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                          INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                                ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                               AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                          INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                   ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                  AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                  -- AND vbOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND vbOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                                                  AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                       ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                      AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                    )

   , tmpProtocol AS (SELECT DISTINCT MovementItemProtocol.MovementItemId
                     FROM MovementItemProtocol
                     WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                       AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                    )

   -- Определили курс на Дату документа (Кому)
   , tmpCurrency_to AS (SELECT tmpCurrency.CurrencyToId           AS CurrencyId
                             , COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
                             , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
                        FROM (SELECT DISTINCT tmpPriceList_to.CurrencyId FROM tmpPriceList_to) AS tmp
                             LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                                        , inCurrencyFromId:= zc_Currency_Basis()
                                                                        , inCurrencyToId  := tmp.CurrencyId
                                                                         ) AS tmpCurrency ON tmpCurrency.CurrencyToId = tmp.CurrencyId
                       )

           -- результат
           SELECT
                 COALESCE (tmpMI.NPP, 0)  :: Integer  AS NPP
               , 0                                    AS Id
               , tmpPartion.PartionId                 AS PartionId
               , Movement_Partion.InvNumber           AS InvNumber_Partion
               , Movement_Partion.OperDate            AS OperDate_Partion
               , Object_Goods.Id                      AS GoodsId
               , Object_Goods.ObjectCode              AS GoodsCode
               , Object_Goods.ValueData               AS GoodsName
               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
               , Object_Measure.ValueData             AS MeasureName

               , Object_Composition.ValueData         AS CompositionName
               , Object_GoodsInfo.ValueData           AS GoodsInfoName
               , Object_LineFabrica.ValueData         AS LineFabricaName
               , Object_Label.ValueData               AS LabelName
               , Object_GoodsSize.Id                  AS GoodsSizeId
               , Object_GoodsSize.ValueData           AS GoodsSizeName
               , Object_Partner.ValueData             AS PartnerName
               , Object_Brand.ValueData               AS BrandName
               , Object_Period.ValueData              AS PeriodName
               , tmpPartion.PeriodYear                AS PeriodYear

               , 0                          :: TFloat AS Amount
               , tmpPartion.Remains         :: TFloat AS Remains
               , tmpPartion.OperPrice       :: TFloat AS OperPrice
               , tmpPartion.CountForPrice   :: TFloat AS CountForPrice
               , tmpPriceList_from.OperPriceList       :: TFloat AS OperPriceList
               , tmpPriceList_to.OperPriceList         :: TFloat AS OperPriceListTo
               , tmpPriceList_to.OperPriceList_start   :: TFloat AS OperPriceListTo_start
               , (CAST (tmpPriceList_from.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                          END AS NUMERIC (16, 2))
                 )                          :: TFloat AS OperPriceListBalance

               -- цены с учетом сезонной скидки
               , CAST (tmpPriceList_from.OperPriceList * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0)) :: TFloat AS OperPriceList_disc
               , CAST (tmpPriceList_to.OperPriceList * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceListTo_disc
               , CAST ((tmpPriceList_from.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                          END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                               :: TFloat AS OperPriceListBalance_disc
               , CAST ((tmpPriceList_to.OperPriceList * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                          END)
                        * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                                 :: TFloat AS OperPriceListToBalance_disc

               , 0                          :: TFloat AS TotalSumm
               , 0                          :: TFloat AS TotalSummBalance
               , 0                          :: TFloat AS TotalSummPriceListBalance
               , 0                          :: TFloat AS TotalSummPriceListToBalance
               , 0                          :: TFloat AS TotalSummPriceListToBalance_start

               , 0                          :: TFloat AS TotalSummPriceList
               , 0                          :: TFloat AS TotalSummPriceListTo
               , 0                          :: TFloat AS TotalSummPriceListTo_start

               , 0                          :: TFloat AS  TotalSummPriceList_disc
               , 0                          :: TFloat AS  TotalSummPriceListTo_disc
               , 0                          :: TFloat AS  TotalSummPriceListBalance_disc
               , 0                          :: TFloat AS  TotalSummPriceListToBalance_disc

               , tmpPartion.CurrencyValue   ::TFloat
               , tmpPartion.ParValue        ::TFloat

               , Object_Currency_pl_from.ValueData AS CurrencyName_pl
               , Object_Currency_pl_to.ValueData   AS CurrencyName_pl_to

                 -- сезонная скидка от кого
               , tmpDiscount_From.DiscountTax ::TFloat AS DiscountTax_From
                 -- сезонная скидка кому
               , tmpDiscount_To.DiscountTax   ::TFloat AS DiscountTax_To

               , FALSE                                 AS isProtocol
               , CASE WHEN tmpReportOLAP.PartionId > 0 THEN TRUE ELSE FALSE END AS isOlap

               , tmpMI.isErased                        AS isErased


           FROM tmpPartion
                LEFT JOIN tmpMI             ON tmpMI.PartionId           = tmpPartion.PartionId
                LEFT JOIN tmpPriceList_from ON tmpPriceList_from.GoodsId = tmpPartion.GoodsId
                LEFT JOIN tmpPriceList_to   ON tmpPriceList_to.GoodsId   = tmpPartion.GoodsId

                LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpPartion.MovementId

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

                LEFT JOIN Object AS Object_Currency_pl_from ON Object_Currency_pl_from.Id = tmpPriceList_from.CurrencyId
                LEFT JOIN Object AS Object_Currency_pl_to   ON Object_Currency_pl_to.Id   = tmpPriceList_to.CurrencyId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpPartion.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                -- для подразделения от кого
                LEFT JOIN tmpDiscount AS tmpDiscount_From
                                      ON tmpDiscount_From.UnitId = vbUnitId_From
                                     AND tmpDiscount_From.GoodsId = tmpPartion.GoodsId
                -- для подразделения кому
                LEFT JOIN tmpDiscount AS tmpDiscount_To
                                      ON tmpDiscount_To.UnitId = vbUnitId_To
                                     AND tmpDiscount_To.GoodsId = tmpPartion.GoodsId

                LEFT JOIN tmpReportOLAP ON tmpReportOLAP.PartionId = tmpPartion.PartionId
           WHERE tmpMI.PartionId IS NULL

          UNION ALL
           -- Показываем только строки документа
           SELECT
                 tmpMI.NPP           :: Integer AS NPP
               , tmpMI.Id
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
               , Container_From.Amount      ::TFloat AS Remains
                 -- Цена вх.
               , tmpMI.OperPrice            ::TFloat
               , tmpMI.CountForPrice        ::TFloat
                 -- Цена в прайсе для магазина От кого
               , tmpMI.OperPriceList        ::TFloat
                 -- Цена в прайсе для магазина Кому
               , tmpMI.OperPriceListTo      ::TFloat
                 -- Цена-start в прайсе для магазина Кому
               , tmpMI.OperPriceListTo_start ::TFloat

                 -- Цена в прайсе - ГРН для магазина От кого
               , (CAST (tmpMI.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                          END AS NUMERIC (16, 2))
                 ) :: TFloat AS OperPriceListBalance

               -- цены с учетом сезонной скидки
               , CAST (tmpMI.OperPriceList * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceList_disc
               , CAST (tmpMI.OperPriceListTo * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceListTo_disc
               , CAST ((tmpMI.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                   THEN 1
                                                   ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                              END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                               :: TFloat AS OperPriceListBalance_disc
               , CAST ((tmpMI.OperPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                          THEN 1
                                                          ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                     END)
                        * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                                 :: TFloat AS OperPriceListToBalance_disc


                 -- Сумма вх.
               , tmpMI.TotalSumm  :: TFloat AS TotalSumm
                 -- Сумма вх. - ГРН
               , (CAST (tmpMI.TotalSumm * tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummBalance

                 -- Сумма по прайсу - ГРН для магазина От кого
               , (CAST (tmpMI.TotalSummPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                        THEN 1
                                                        ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                   END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListBalance

                 -- Сумма по прайсу - ГРН для магазина Кому
               , (CAST (tmpMI.TotalSummPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                          THEN 1
                                                          ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                     END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListToBalance

                 -- Сумма-start по прайсу - ГРН для магазина Кому
               , (CAST (tmpMI.TotalSummPriceListTo_start * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                                THEN 1
                                                                ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                           END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListToBalance_start

                 -- Сумма по прайсу - для магазина От кого
               , tmpMI.TotalSummPriceList          :: TFloat
                 -- Сумма по прайсу - для магазина Кому
               , tmpMI.TotalSummPriceListTo        :: TFloat
                 -- Сумма-start по прайсу - для магазина Кому
               , tmpMI.TotalSummPriceListTo_start  :: TFloat
                
                --итого с учетом сезонной скидки
               , CAST (tmpMI.TotalSummPriceList * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceList_disc
               , CAST (tmpMI.TotalSummPriceListTo * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListTo_disc
               , CAST ((tmpMI.TotalSummPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                        THEN 1
                                                        ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                   END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListBalance_disc
  
               , CAST ((tmpMI.TotalSummPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                                THEN 1
                                                                ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                           END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListToBalance_disc
             
                 -- курс
               , tmpMI.CurrencyValue       ::TFloat
               , tmpMI.ParValue            ::TFloat

               , Object_Currency_pl_from.ValueData AS CurrencyName_pl
               , Object_Currency_pl_to.ValueData   AS CurrencyName_pl_to

                 -- сезонная скидка от кого
               , tmpDiscount_From.DiscountTax ::TFloat AS DiscountTax_From
                 -- сезонная скидка кому
               , tmpDiscount_To.DiscountTax   ::TFloat AS DiscountTax_To

               , CASE WHEN tmpProtocol.MovementItemId > 0 THEN TRUE ELSE FALSE END AS isProtocol
               , CASE WHEN tmpReportOLAP.PartionId > 0 THEN TRUE ELSE FALSE END    AS isOlap

               , tmpMI.isErased

           FROM tmpMI
                LEFT JOIN Object_PartionGoods           ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
                LEFT JOIN Movement  AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId

                LEFT JOIN tmpPriceList_from ON tmpPriceList_from.GoodsId = tmpMI.GoodsId
                LEFT JOIN tmpPriceList_to   ON tmpPriceList_to.GoodsId   = tmpMI.GoodsId
                LEFT JOIN tmpCurrency_to    ON tmpCurrency_to.CurrencyId = tmpPriceList_to.CurrencyId

                LEFT JOIN tmpContainer AS Container_From ON Container_From.PartionId = tmpMI.PartionId
                                                        AND Container_From.ObjectId  = tmpMI.GoodsId

            /*    LEFT JOIN Container AS Container_From
                                    ON Container_From.PartionId     = tmpMI.PartionId
                                   AND Container_From.ObjectId      = tmpMI.GoodsId
                                   AND Container_From.WhereObjectId = vbUnitId_From
                                   AND Container_From.DescId        = zc_Container_count()
*/
                LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpMI.GoodsId
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

                LEFT JOIN Object AS Object_Currency_pl_from ON Object_Currency_pl_from.Id = tmpPriceList_from.CurrencyId
                LEFT JOIN Object AS Object_Currency_pl_to   ON Object_Currency_pl_to.Id   = tmpPriceList_to.CurrencyId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                --для подразделения от кого
                LEFT JOIN tmpDiscount AS tmpDiscount_From
                                      ON tmpDiscount_From.UnitId  = vbUnitId_From
                                     AND tmpDiscount_From.GoodsId = tmpMI.GoodsId
                --для подразделения кому
                LEFT JOIN tmpDiscount AS tmpDiscount_To
                                      ON tmpDiscount_To.UnitId  = vbUnitId_To
                                     AND tmpDiscount_To.GoodsId = tmpMI.GoodsId

                LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                LEFT JOIN tmpReportOLAP ON tmpReportOLAP.PartionId = tmpMI.PartionId
           ;

     ELSE
       -- Результат такой - Показываем только строки документа
       RETURN QUERY
          WITH
          tmpReportOLAP AS (SELECT DISTINCT Object_PartionGoods.MovementItemId AS PartionId
                                 , Object_PartionGoods.GoodsId
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_User
                                                       ON ObjectLink_User.ObjectId      = Object.Id
                                                      AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                      AND ObjectLink_User.ChildObjectId = vbUserId

                                 INNER JOIN ObjectLink AS ObjectLink_Object
                                                       ON ObjectLink_Object.ObjectId = Object.Id
                                                      AND ObjectLink_Object.DescId   = zc_ObjectLink_ReportOLAP_Object()

                                 -- привязываем по партии, для партии определяем какой товар
                                 INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = ObjectLink_Object.ChildObjectId

                            WHERE Object.DescId = zc_Object_ReportOLAP()
                              AND Object.ObjectCode IN (3)
                              AND Object.isErased = FALSE
                            )

        , tmpMI AS (SELECT ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) AS NPP
                         , MovementItem.Id
                         , MovementItem.ObjectId AS GoodsId
                         , MovementItem.PartionId
                         , MovementItem.Amount
                         , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                         , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                         , COALESCE (MIFloat_CountForPrice.ValueData, 1)         AS CountForPrice
                         , COALESCE (MIFloat_OperPrice.ValueData, 0)             AS OperPrice
                         , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                         , COALESCE (MIFloat_OperPriceListTo.ValueData, 0)       AS OperPriceListTo
                         , COALESCE (MIFloat_OperPriceListTo_start.ValueData, 0) AS OperPriceListTo_start
                         , CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                           THEN MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                       ELSE MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0)
                                 END AS NUMERIC (16, 2)) AS TotalSumm
                         , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS NUMERIC (16, 2)) AS TotalSummPriceList
                         , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceListTo.ValueData, 0)       AS NUMERIC (16, 2)) AS TotalSummPriceListTo
                         , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceListTo_start.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceListTo_start
                         , MovementItem.isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = tmpIsErased.isErased
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                      ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                     AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo
                                                     ON MIFloat_OperPriceListTo.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceListTo.DescId = zc_MIFloat_OperPriceListTo()
                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListTo_start
                                                     ON MIFloat_OperPriceListTo_start.MovementItemId = MovementItem.Id
                                                    AND MIFloat_OperPriceListTo_start.DescId         = zc_MIFloat_OperPriceListTo_start()

                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                      ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                     )
    -- Последняя цена из Прайс-листа - vbPriceListId_from
    , tmpPriceList_from AS (SELECT tmp.GoodsId
                                 , COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_from) AS CurrencyId
                            FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp
                                 INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                       ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                      AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                 INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                       ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                      AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_from
                                                      AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                 INNER JOIN ObjectHistory AS OH_PriceListItem
                                                          ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                         AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                         AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                                 LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                                             ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                            AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                           )
      -- Последняя цена из Прайс-листа - vbPriceListId_to
    , tmpPriceList_to AS (SELECT tmp.GoodsId
                               , COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp
                               INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                     ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                    AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                     ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                    AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                                                    AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                               INNER JOIN ObjectHistory AS OH_PriceListItem
                                                        ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                       AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                       AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                               LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                                           ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                          AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                         )
    , tmpContainer AS (SELECT Container.ObjectId
                            , Container.PartionId
                            , SUM (COALESCE(Container.Amount, 0)) AS Amount
                       FROM tmpMI
                            INNER JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                                AND Container.WhereObjectId = vbUnitId_From
                                                AND Container.DescId        = zc_Container_count()
                                                AND COALESCE(Container.Amount, 0) <> 0
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

         ---сезонная скидка
        , tmpDiscountList AS (SELECT DISTINCT vbUnitId_From AS UnitId, tmpMI.GoodsId FROM tmpMI
                             UNION
                              SELECT DISTINCT vbUnitId_To   AS UnitId, tmpMI.GoodsId FROM tmpMI
                              )

        , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                                                AND ObjectLink.DescId        = zc_ObjectLink_DiscountPeriodItem_Goods()
                    )
        , tmpOL2 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpOL1.ObjectId FROM tmpOL1)
                                                AND ObjectLink.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
                    )

        , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Unit.ChildObjectId      AS UnitId
                               , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId     AS GoodsId
                               , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                          FROM tmpDiscountList
                               INNER JOIN tmpOL1 AS ObjectLink_DiscountPeriodItem_Goods
                                                     ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                               INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                                     ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                    AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                               INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                        ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                       AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                       AND vbOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND vbOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                                                      -- AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                            ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                           AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                         )

        , tmpProtocol AS (SELECT DISTINCT MovementItemProtocol.MovementItemId
                          FROM MovementItemProtocol
                          WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
                         )

        -- Определили курс на Дату документа (Кому)
        , tmpCurrency_to AS (SELECT tmpCurrency.CurrencyToId           AS CurrencyId
                                  , COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
                                  , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
                             FROM (SELECT DISTINCT tmpPriceList_to.CurrencyId FROM tmpPriceList_to) AS tmp
                                  LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                                             , inCurrencyFromId:= zc_Currency_Basis()
                                                                             , inCurrencyToId  := tmp.CurrencyId
                                                                              ) AS tmpCurrency ON tmpCurrency.CurrencyToId = tmp.CurrencyId
                            )


           -- результат
           SELECT
                 tmpMI.NPP           :: Integer AS NPP
               , tmpMI.Id
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
               , Container_From.Amount       ::TFloat AS Remains
                 -- Цена вх.
               , tmpMI.OperPrice             ::TFloat
               , tmpMI.CountForPrice         ::TFloat
                 -- Цена в прайсе для магазина От кого
               , tmpMI.OperPriceList         ::TFloat
                 -- Цена в прайсе для магазина Кому
               , tmpMI.OperPriceListTo       ::TFloat
                 -- Цена-start в прайсе для магазина Кому
               , tmpMI.OperPriceListTo_start ::TFloat

                 -- Цена в прайсе - ГРН для магазина От кого
               , (CAST (tmpMI.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                          END AS NUMERIC (16, 2))
                 ) :: TFloat AS OperPriceListBalance

                 -- цены с учетом сезонной скидки
               , CAST (tmpMI.OperPriceList * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceList_disc
               , CAST (tmpMI.OperPriceListTo * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS OperPriceListTo_disc
               , CAST ((tmpMI.OperPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                   THEN 1
                                                   ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                              END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                               :: TFloat AS OperPriceListBalance_disc
               , CAST ((tmpMI.OperPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                          THEN 1
                                                          ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                     END)
                        * (1 - COALESCE (tmpDiscount_To.DiscountTax, 0) / 100)  AS NUMERIC (16, 0))                                 :: TFloat AS OperPriceListToBalance_disc

                 -- Сумма вх.
               , tmpMI.TotalSumm           ::TFloat
                 -- Сумма вх. - ГРН
               , (CAST (tmpMI.TotalSumm * tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummBalance

                 -- Сумма по прайсу - ГРН для магазина От кого
               , (CAST (tmpMI.TotalSummPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                        THEN 1
                                                        ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                   END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListBalance

                 -- Сумма по прайсу - ГРН для магазина Кому
               , (CAST (tmpMI.TotalSummPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                          THEN 1
                                                          ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                     END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListToBalance

                 -- Сумма-start по прайсу - ГРН для магазина Кому
               , (CAST (tmpMI.TotalSummPriceListTo_start * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                               THEN 1
                                                               ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                          END AS NUMERIC (16, 2))
                 ) :: TFloat AS TotalSummPriceListToBalance_start

                 -- Сумма по прайсу - для магазина От кого
               , tmpMI.TotalSummPriceList         :: TFloat
                 -- Сумма по прайсу - для магазина Кому
               , tmpMI.TotalSummPriceListTo       :: TFloat
                 -- Сумма-start по прайсу - для магазина Кому
               , tmpMI.TotalSummPriceListTo_start :: TFloat

                --итого с учетом сезонной скидки
               , CAST (tmpMI.TotalSummPriceList * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceList_disc
               , CAST (tmpMI.TotalSummPriceListTo * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListTo_disc
               , CAST ((tmpMI.TotalSummPriceList * CASE WHEN tmpPriceList_from.CurrencyId = zc_Currency_Basis()
                                                        THEN 1
                                                        ELSE tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END
                                                   END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListBalance_disc
  
               , CAST ((tmpMI.TotalSummPriceListTo * CASE WHEN tmpPriceList_to.CurrencyId = zc_Currency_Basis()
                                                                THEN 1
                                                                ELSE tmpCurrency_to.CurrencyValue / CASE WHEN tmpCurrency_to.ParValue <> 0 THEN tmpCurrency_to.ParValue ELSE 1 END
                                                           END)
                        * (1 - COALESCE (tmpDiscount_From.DiscountTax, 0) / 100) AS NUMERIC (16, 0))     :: TFloat AS TotalSummPriceListToBalance_disc
             
                 -- курс
               , tmpMI.CurrencyValue       ::TFloat
               , tmpMI.ParValue            ::TFloat

               , Object_Currency_pl_from.ValueData AS CurrencyName_pl
               , Object_Currency_pl_to.ValueData   AS CurrencyName_pl_to

                 -- сезонная скидка от кого
               , tmpDiscount_From.DiscountTax ::TFloat AS DiscountTax_From
                 -- сезонная скидка кому
               , tmpDiscount_To.DiscountTax   ::TFloat AS DiscountTax_To

               , CASE WHEN tmpProtocol.MovementItemId > 0 THEN TRUE ELSE FALSE END AS isProtocol
               , CASE WHEN tmpReportOLAP.PartionId > 0 THEN TRUE ELSE FALSE END    AS isOlap
               , tmpMI.isErased

           FROM tmpMI
                LEFT JOIN Object_PartionGoods          ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
                LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId

                LEFT JOIN tmpPriceList_from ON tmpPriceList_from.GoodsId = tmpMI.GoodsId
                LEFT JOIN tmpPriceList_to   ON tmpPriceList_to.GoodsId   = tmpMI.GoodsId
                LEFT JOIN tmpCurrency_to    ON tmpCurrency_to.CurrencyId = tmpPriceList_to.CurrencyId

                LEFT JOIN tmpContainer AS Container_From ON Container_From.PartionId = tmpMI.PartionId
                                                        AND Container_From.ObjectId  = tmpMI.GoodsId

                LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpMI.GoodsId
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

                LEFT JOIN Object AS Object_Currency_pl_from ON Object_Currency_pl_from.Id = tmpPriceList_from.CurrencyId
                LEFT JOIN Object AS Object_Currency_pl_to   ON Object_Currency_pl_to.Id   = tmpPriceList_to.CurrencyId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                --для подразделения от кого
                LEFT JOIN tmpDiscount AS tmpDiscount_From
                                      ON tmpDiscount_From.UnitId  = vbUnitId_From
                                     AND tmpDiscount_From.GoodsId = tmpMI.GoodsId
                --для подразделения кому
                LEFT JOIN tmpDiscount AS tmpDiscount_To
                                      ON tmpDiscount_To.UnitId  = vbUnitId_To
                                     AND tmpDiscount_To.GoodsId = tmpMI.GoodsId

                LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                LEFT JOIN tmpReportOLAP ON tmpReportOLAP.PartionId = tmpMI.PartionId
          ;

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.08.20         *
 28.01.20         * add OperPriceListTo
 15.05.18         * add isOlap
 03.04.18         *
 18.04.17         *
 26.06.17         *
 21.06.17         *
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 241258, inStartDate:= '01.05.2018', inEndDate := '01.05.2018', inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- select * from gpSelect_MovementItem_Send(inMovementId := 6371 , inStartDate := ('27.04.2020')::TDateTime , inEndDate := ('27.04.2020')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '2');
-- select * from gpSelect_MovementItem_Send(inMovementId := 7232 , inStartDate := ('04.08.2020')::TDateTime , inEndDate := ('04.08.2020')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '2');
