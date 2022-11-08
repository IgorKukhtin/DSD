-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inUnitId           Integer   , -- Подразделение
    IN inGoodsId          Integer   , -- Товар
    IN inPartionId        Integer   , -- Документ партия №
    IN inMovementId       Integer   , -- Документ партия №
    IN inGoodsSizeId      Integer   , -- Размер
    IN inIsGoodsSizeAll   Boolean   , -- ограничение по Всем Размерам (Да/Нет)
    IN inIsPartionAll     Boolean   , -- ограничение по Всем Партиям (Да/Нет)
    IN inIsPeriodAll      Boolean   , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId      Integer;

   DECLARE vbIsOperPrice Boolean;
   DECLARE vbIsBranch    Boolean;
   DECLARE Cursor1       refcursor;
   DECLARE Cursor2       refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
    vbUserId:= lpGetUserBySession (inSession);


    -- проверка может ли смотреть любой магазин, или только свой
    PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);

    -- Получили - показывать цену ВХ.
    vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId);


    -- !!!замена!!!
    inPartionId:= 0;

    -- !!!замена!!!
    IF COALESCE (inMovementId, 0) = 0 THEN
        inIsPartionAll := TRUE;
    END IF;
    -- !!!замена!!!
    IF COALESCE (inGoodsSizeId, 0) = 0 THEN
        inIsGoodsSizeAll := TRUE;
    END IF;


    -- если за весь период установин кон. дату  = текущей, для определения цены (прайс) для остатка
    IF COALESCE (inIsPeriodAll, FALSE) = TRUE THEN
        inEndDate := CURRENT_DATE;
    END IF;


    OPEN Cursor1 FOR
    WITH
     tmpWhere AS (SELECT lfSelect.UnitId               AS LocationId
                       , zc_ContainerLinkObject_Unit() AS DescId
                       , inGoodsId                     AS GoodsId
                  FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
                  WHERE COALESCE (inUnitId, 0) <> 0
                UNION
                  SELECT Object.Id                     AS LocationId
                       , zc_ContainerLinkObject_Unit() AS DescId
                       , inGoodsId                     AS GoodsId
                  FROM Object
                  WHERE Object.DescId = zc_Object_Unit() 
                    AND COALESCE (inUnitId, 0) = 0
                 )

   , tmpContainer_Count AS (SELECT Container.Id                    AS ContainerId
                                 , COALESCE (CLO_Client.ObjectId, CLO_Location.ObjectId) AS LocationId
                                 , Container.ObjectId              AS GoodsId
                                 , Container.PartionId             AS PartionId
                                 , CLO_PartionMI.ObjectId          AS PartionId_mi
                                 , COALESCE (CLO_GoodsSize.ObjectId, Object_PartionGoods.GoodsSizeId) AS GoodsSizeId
                                 , Container.Amount
                                 , CASE WHEN CLO_Client.ObjectId IS NULL THEN FALSE ELSE TRUE END AS isClient
                            FROM tmpWhere
                                 INNER JOIN Container ON Container.ObjectId = tmpWhere.GoodsId
                                                     AND Container.DescId = zc_Container_Count()
                                 INNER JOIN ContainerLinkObject AS CLO_Location ON CLO_Location.ContainerId = Container.Id
                                                                               AND CLO_Location.DescId      = tmpWhere.DescId
                                                                               AND CLO_Location.ObjectId    = tmpWhere.LocationId
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionMI ON CLO_PartionMI.ContainerId = Container.Id
                                                                               AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                                 LEFT JOIN ContainerLinkObject AS CLO_Client ON CLO_Client.ContainerId = Container.Id
                                                                            AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                 LEFT JOIN ContainerLinkObject AS CLO_GoodsSize
                                                               ON CLO_GoodsSize.ContainerId = Container.Id
                                                              AND CLO_GoodsSize.DescId      = zc_ContainerLinkObject_GoodsSize()
                                 LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                            WHERE ((COALESCE (CLO_GoodsSize.ObjectId, Object_PartionGoods.GoodsSizeId) = inGoodsSizeId AND inIsGoodsSizeAll = FALSE) OR (inIsGoodsSizeAll = TRUE))
                              AND (-- (Object_PartionGoods.MovementItemId = inPartionId   AND inIsPartionAll = FALSE)
                                   inIsPartionAll = FALSE
                                OR (inIsPartionAll = TRUE AND (Object_PartionGoods.MovementId = inMovementId OR inMovementId = 0 )))
                              -- AND CLO_Client.ContainerId IS NULL -- !!!т.е. без Долгов Покупателя!!!
                           )

   , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                          , tmpContainer_Count.LocationId
                          , MIContainer.ObjectExtId_Analyzer AS LocationId_by
                          , tmpContainer_Count.GoodsId
                          , tmpContainer_Count.PartionId
                          , tmpContainer_Count.PartionId_mi
                          , tmpContainer_Count.GoodsSizeId
                          , tmpContainer_Count.Amount
                          , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                      THEN MIContainer.ContainerId_Analyzer
                                 ELSE 0
                            END AS ContainerId_Analyzer
                          , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                      THEN MIContainer.MovementId
                                 ELSE 0
                            END AS MovementId
                          , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                      THEN MIContainer.MovementItemId
                                 ELSE 0
                            END AS MovementItemId
                          , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                           THEN MIContainer.Amount
                                      ELSE 0
                                 END) AS Amount_Period
                          , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                          , MIContainer.MovementDescId
                          , MIContainer.isActive
                          , tmpContainer_Count.isClient
                     FROM tmpContainer_Count
                          INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                        AND (MIContainer.OperDate >= inStartDate OR inIsPeriodAll = TRUE)
                     GROUP BY tmpContainer_Count.ContainerId
                            , tmpContainer_Count.LocationId
                            , MIContainer.ObjectExtId_Analyzer
                            , tmpContainer_Count.GoodsId
                            , tmpContainer_Count.PartionId
                            , tmpContainer_Count.PartionId_mi
                            , tmpContainer_Count.GoodsSizeId
                            , tmpContainer_Count.Amount
                            , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                     AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                        THEN MIContainer.ContainerId_Analyzer
                                   ELSE 0
                              END
                            , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                        THEN MIContainer.MovementId
                                   ELSE 0
                              END
                            , CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                                        THEN MIContainer.MovementItemId
                                   ELSE 0
                              END
                            , MIContainer.MovementDescId
                            , MIContainer.isActive
                            , tmpContainer_Count.isClient
                    )
      , tmpPrice AS (SELECT OHF_PriceListItem_Value_Start.ValueData AS Price_Start
                          , OHF_PriceListItem_Value.ValueData       AS Price_End
                     FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                          INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                               AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                               AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Start
                                                  ON ObjectHistory_PriceListItem_Start.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectHistory_PriceListItem_Start.DescId = zc_ObjectHistory_PriceListItem()
                                                 AND inStartDate >= ObjectHistory_PriceListItem_Start.StartDate AND inStartDate < ObjectHistory_PriceListItem_Start.EndDate
                          LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value_Start
                                                       ON OHF_PriceListItem_Value_Start.ObjectHistoryId = ObjectHistory_PriceListItem_Start.Id
                                                      AND OHF_PriceListItem_Value_Start.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                 AND inEndDate >= ObjectHistory_PriceListItem.StartDate AND inEndDate < ObjectHistory_PriceListItem.EndDate
                          LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value
                                                       ON OHF_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND OHF_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                     WHERE ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                       AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                    )

   , tmpMIContainer_group AS (SELECT tmpMIContainer_all.MovementId
                                   , tmpMIContainer_all.MovementItemId
                                   , tmpMIContainer_all.LocationId
                                   , tmpMIContainer_all.LocationId_by
                                   , tmpMIContainer_all.GoodsId
                                   , CASE WHEN inIsPartionAll = TRUE THEN tmpMIContainer_all.PartionId ELSE 0 END AS PartionId
                                   , tmpMIContainer_all.PartionId_mi
                                   , tmpMIContainer_all.GoodsSizeId
                                   , Object_PartionGoods.CurrencyId
                                   , tmpMIContainer_all.ContainerId_Analyzer
                                   , tmpMIContainer_all.isActive

                                   , COALESCE (Object_PartionGoods.CountForPrice, 1) AS CountForPrice

                                   , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
                                   , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
                                   , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
                                   , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut
                                   , SUM (CASE WHEN vbIsOperPrice = FALSE THEN 0
                                               ELSE CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                              THEN CAST (COALESCE (tmpMIContainer_all.AmountStart, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                                         ELSE CAST ( COALESCE (tmpMIContainer_all.AmountStart, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                                    END
                                          END) AS SummStart
                                   , SUM (CASE WHEN vbIsOperPrice = FALSE THEN 0
                                               ELSE CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                              THEN CAST (COALESCE (tmpMIContainer_all.AmountEnd, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                                         ELSE CAST ( COALESCE (tmpMIContainer_all.AmountEnd, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                                    END
                                          END) AS SummEnd
                                   , SUM (CASE WHEN vbIsOperPrice = FALSE THEN 0
                                               ELSE CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                              THEN CAST (COALESCE (tmpMIContainer_all.AmountIn, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                                         ELSE CAST ( COALESCE (tmpMIContainer_all.AmountIn, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                                    END
                                          END) AS SummIn

                                   , SUM (CASE WHEN vbIsOperPrice = FALSE THEN 0
                                               ELSE CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                              THEN CAST (COALESCE (tmpMIContainer_all.AmountOut, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                                         ELSE CAST ( COALESCE (tmpMIContainer_all.AmountOut, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                                    END
                                          END) AS SummOut
                                   , tmpMIContainer_all.isClient

                               FROM (
                                     -- 1.1. Остатки кол-во
                                     SELECT -1 AS MovementId
                                           , 0 AS MovementItemId
                                           , tmpMI_Count.ContainerId
                                           , tmpMI_Count.LocationId
                                           , 0 AS LocationId_by
                                           , tmpMI_Count.GoodsId
                                           , tmpMI_Count.PartionId
                                           , tmpMI_Count.PartionId_mi
                                           , tmpMI_Count.GoodsSizeId
                                           , 0     AS ContainerId_Analyzer
                                           , TRUE  AS isActive

                                           , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total)                                   AS AmountStart
                                           , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) + SUM (tmpMI_Count.Amount_Period) AS AmountEnd
                                           , 0 AS AmountIn
                                           , 0 AS AmountOut
                                           , tmpMI_Count.isClient
                                     FROM tmpMI_Count
                                     GROUP BY tmpMI_Count.ContainerId
                                            , tmpMI_Count.LocationId
                                            , tmpMI_Count.GoodsId
                                            , tmpMI_Count.PartionId
                                            , tmpMI_Count.PartionId_mi
                                            , tmpMI_Count.GoodsSizeId
                                            , tmpMI_Count.Amount
                                            , tmpMI_Count.isClient
                                     HAVING tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) <> 0
                                         OR SUM (tmpMI_Count.Amount_Period) <> 0
                                    UNION ALL
                                     -- 1.2. Движение кол-во
                                     SELECT tmpMI_Count.MovementId
                                           , tmpMI_Count.MovementItemId
                                           , tmpMI_Count.ContainerId
                                           , tmpMI_Count.LocationId
                                           , tmpMI_Count.LocationId_by
                                           , tmpMI_Count.GoodsId
                                           , tmpMI_Count.PartionId
                                           , tmpMI_Count.PartionId_mi
                                           , tmpMI_Count.GoodsSizeId
                                           , tmpMI_Count.ContainerId_Analyzer
                                           , tmpMI_Count.isActive

                                           , 0 AS AmountStart
                                           , 0 AS AmountEnd
                                           , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN      tmpMI_Count.Amount_Period ELSE 0 END AS AmountIn
                                           , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN -1 * tmpMI_Count.Amount_Period ELSE 0 END AS AmountOut
                                           , tmpMI_Count.isClient
                                     FROM tmpMI_Count
                                     WHERE tmpMI_Count.Amount_Period <> 0
                                     ) AS tmpMIContainer_all
                                     LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_all.PartionId

                               GROUP BY tmpMIContainer_all.MovementId
                                      , tmpMIContainer_all.MovementItemId
                                      , tmpMIContainer_all.LocationId
                                      , tmpMIContainer_all.LocationId_by
                                      , tmpMIContainer_all.GoodsId
                                      , CASE WHEN inIsPartionAll = TRUE THEN tmpMIContainer_all.PartionId ELSE 0 END
                                      , tmpMIContainer_all.PartionId_mi
                                      , tmpMIContainer_all.GoodsSizeId
                                      , Object_PartionGoods.CurrencyId
                                      , tmpMIContainer_all.ContainerId_Analyzer
                                      , tmpMIContainer_all.isActive
                                      , COALESCE (Object_PartionGoods.CountForPrice, 1)
                                      , tmpMIContainer_all.isClient
                              )

   SELECT Movement.Id                            AS MovementId
        , Movement.InvNumber
        , Movement.OperDate

        , MovementDesc.ItemName      :: TVarChar AS MovementDescName

        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN NULL ELSE tmpMIContainer_group.isActive END :: Boolean AS isActive
        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN TRUE ELSE FALSE END :: Boolean AS isRemains

        , ObjectDesc_Location.ItemName           AS LocationDescName
        , Object_Location.Id                     AS LocationId
        , Object_Location.ObjectCode             AS LocationCode
        , Object_Location.ValueData              AS LocationName

        , ObjectDesc_Location_by.ItemName        AS LocationDescName_by
        , Object_Location_by.Id                  AS LocationId_by
        , Object_Location_by.ObjectCode          AS LocationCode_by
        , Object_Location_by.ValueData           AS LocationName_by

        , Object_GoodsSize.ValueData             AS GoodsSizeName
        , Object_Currency.ValueData              AS CurrencyName

        , CAST (CASE WHEN Movement.DescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                     WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummIn / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummOut / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS OperPrice

        , CAST (tmpMIContainer_group.AmountStart AS TFloat) AS AmountStart
        , CAST (CASE WHEN tmpMIContainer_group.isClient = FALSE THEN tmpMIContainer_group.AmountIn ELSE 0 END AS TFloat)   AS AmountIn
        , CAST (CASE WHEN tmpMIContainer_group.isClient = FALSE THEN tmpMIContainer_group.AmountOut ELSE 0 END AS TFloat)  AS AmountOut
        --товар по покупателям
        , CAST (CASE WHEN tmpMIContainer_group.isClient = TRUE THEN tmpMIContainer_group.AmountIn ELSE 0 END AS TFloat)    AS AmountIn_cl
        , CAST (CASE WHEN tmpMIContainer_group.isClient = TRUE THEN tmpMIContainer_group.AmountOut ELSE 0 END AS TFloat)   AS AmountOut_cl
        
        , CAST (tmpMIContainer_group.AmountEnd AS TFloat)   AS AmountEnd

        , CAST (tmpMIContainer_group.SummStart AS TFloat)   AS SummStart
        , CAST (tmpMIContainer_group.SummIn AS TFloat)      AS SummIn
        , CAST (tmpMIContainer_group.SummOut AS TFloat)     AS SummOut

        , CAST (tmpMIContainer_group.SummEnd AS TFloat)     AS SummEnd

        , CAST (CASE WHEN tmpCurrency_Start.ParValue  > 0
                     THEN tmpMIContainer_group.SummStart * tmpCurrency_Start.Amount / tmpCurrency_Start.ParValue
                     ELSE tmpMIContainer_group.SummStart * tmpCurrency_Start.Amount
                END AS NUMERIC (16, 2) ) :: TFloat          AS SummStart_Balance

        , CAST (CASE WHEN COALESCE (MF_ParValue.ValueData, MIFloat_ParValue.ValueData) > 0
                     THEN tmpMIContainer_group.SummIn * COALESCE (MF_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData) / COALESCE (MF_ParValue.ValueData, MIFloat_ParValue.ValueData)
                     ELSE tmpMIContainer_group.SummIn * COALESCE (MF_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData)
                END AS NUMERIC (16, 2) ) :: TFloat          AS SummIn_Balance
        , CAST (CASE WHEN COALESCE (MF_ParValue.ValueData, MIFloat_ParValue.ValueData) > 0
                     THEN tmpMIContainer_group.SummOut * COALESCE (MF_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData) / COALESCE (MF_ParValue.ValueData, MIFloat_ParValue.ValueData)
                     ELSE tmpMIContainer_group.SummOut * COALESCE (MF_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData)
                END AS NUMERIC (16, 2) ) :: TFloat           AS SummOut_Balance

        , CAST (CASE WHEN tmpCurrency_End.ParValue  > 0
                     THEN tmpMIContainer_group.SummEnd * tmpCurrency_End.Amount / tmpCurrency_End.ParValue
                     ELSE tmpMIContainer_group.SummEnd * tmpCurrency_End.Amount
                END AS NUMERIC (16, 2) ) :: TFloat          AS SummEnd_Balance

        , CAST ( COALESCE (tmpPrice.Price_Start, 0) * tmpMIContainer_group.AmountStart AS NUMERIC (16, 2)) :: TFloat AS SummStart_PriceList
        , CAST ( COALESCE (MIFloat_OperPriceList.ValueData, 0) * tmpMIContainer_group.AmountIn    AS NUMERIC (16, 2)) :: TFloat AS SummIn_PriceList
        , CAST ( COALESCE (MIFloat_OperPriceList.ValueData, 0) * tmpMIContainer_group.AmountOut   AS NUMERIC (16, 2)) :: TFloat AS SummOut_PriceList
        , CAST ( COALESCE (tmpPrice.Price_End, 0) * tmpMIContainer_group.AmountEnd   AS NUMERIC (16, 2)) :: TFloat AS SummEnd_PriceList

        , tmpCurrency_Start.Amount   :: TFloat AS CurrencyValue_Start
        , tmpCurrency_Start.ParValue :: TFloat AS ParValue_Start
        , tmpCurrency_End.Amount     :: TFloat AS CurrencyValue_End
        , tmpCurrency_End.ParValue   :: TFloat AS ParValue_End

        , COALESCE (MF_CurrencyValue.ValueData, MIFloat_CurrencyValue.ValueData) ::TFloat AS CurrencyValue
        , COALESCE (MF_ParValue.ValueData, MIFloat_ParValue.ValueData)           ::TFloat AS ParValue

        , MI_PartionMI.Amount           AS Amount_PartionMI
        , Movement_PartionMI.OperDate   AS OperDate_PartionMI
        , Movement_PartionMI.InvNumber  AS InvNumber_PartionMI

        , tmpMIContainer_group.PartionId
        , tmpMIContainer_group.PartionId_mi
        , MI_PartionMI.Id AS MovementItemId_PartionMI
        , MovementItem.Id AS MovementItemId
        
        , tmpMIContainer_group.isClient :: Boolean

   FROM tmpMIContainer_group
        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN MovementItem ON MovementItem.Id = tmpMIContainer_group.MovementItemId

        -- курсы
        LEFT JOIN MovementFloat AS MF_ParValue
                                ON MF_ParValue.MovementId = Movement.Id
                               AND MF_ParValue.DescId = zc_MovementFloat_ParValue()
        LEFT JOIN MovementFloat AS MF_CurrencyValue
                                ON MF_CurrencyValue.MovementId =  Movement.Id
                               AND MF_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
        LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                    ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                   AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
        LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                    ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                   AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
        --
        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                    ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                   AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
        LEFT JOIN tmpPrice ON 1=1

        LEFT JOIN Object AS Object_PartionMI     ON Object_PartionMI.Id     = tmpMIContainer_group.PartionId_mi
        LEFT JOIN MovementItem AS MI_PartionMI   ON MI_PartionMI.Id         = Object_PartionMI.ObjectCode
        LEFT JOIN Movement AS Movement_PartionMI ON Movement_PartionMI.Id   = MI_PartionMI.MovementId

        LEFT JOIN Object AS Object_Location    ON Object_Location.Id    = tmpMIContainer_group.LocationId
        LEFT JOIN Object AS Object_Location_by ON Object_Location_by.Id = tmpMIContainer_group.LocationId_by
        LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = tmpMIContainer_group.GoodsSizeId
        LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = tmpMIContainer_group.CurrencyId
                                              AND vbIsOperPrice         = TRUE

        LEFT JOIN ObjectDesc AS ObjectDesc_Location    ON ObjectDesc_Location.Id    = Object_Location.DescId
        LEFT JOIN ObjectDesc AS ObjectDesc_Location_by ON ObjectDesc_Location_by.Id = Object_Location_by.DescId

        LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= inStartDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= tmpMIContainer_group.CurrencyId) AS tmpCurrency_Start ON 1=1
        LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= inEndDate,   inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= tmpMIContainer_group.CurrencyId) AS tmpCurrency_End   ON 1=1

   ;

     RETURN NEXT Cursor1;


    -- Результат 2

     OPEN Cursor2 FOR
      WITH tmpPrice AS (SELECT OHF_PriceListItem_Value_Start.ValueData AS Price
                        FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                             INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                   ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                  AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                  AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                             LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem_Start
                                                     ON ObjectHistory_PriceListItem_Start.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectHistory_PriceListItem_Start.DescId   = zc_ObjectHistory_PriceListItem()
                                                    AND ObjectHistory_PriceListItem_Start.EndDate  = zc_DateEnd()
                             LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value_Start
                                                          ON OHF_PriceListItem_Value_Start.ObjectHistoryId = ObjectHistory_PriceListItem_Start.Id
                                                         AND OHF_PriceListItem_Value_Start.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                        WHERE ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                          AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                       )
         , tmpWhere AS (SELECT lfSelect.UnitId               AS LocationId
                             , inGoodsId                     AS GoodsId
                        FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
                        WHERE COALESCE (inUnitId, 0) <> 0
                      UNION
                        SELECT Object.Id                     AS LocationId
                             , inGoodsId                     AS GoodsId
                        FROM Object
                        WHERE Object.DescId = zc_Object_Unit() 
                          AND COALESCE (inUnitId, 0) = 0
                       )

         , tmpDiscountList AS --(SELECT inUnitId AS UnitId, inGoodsId AS GoodsId)
                              (SELECT DISTINCT
                                      tmpWhere.LocationId AS UnitId
                                    , tmpWhere.GoodsId
                               FROM tmpWhere
                               )
        
                  , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId = inGoodsId
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
                                                     -- AND ObjectLink_DiscountPeriodItem_Goods.DescId       = zc_ObjectLink_DiscountPeriodItem_Goods()
                                INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                                  ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                 AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                                                     -- AND ObjectLink_DiscountPeriodItem_Unit.DescId       = zc_ObjectLink_DiscountPeriodItem_Unit()
                                INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                         ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                        AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                        AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                             ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                            AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                          )
         , tmpCurrency AS (SELECT lfSelect.*
                           FROM Object
                                CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate      := CURRENT_DATE
                                                                            , inCurrencyFromId:= zc_Currency_Basis()
                                                                            , inCurrencyToId  := Object.Id
                                                                             ) AS lfSelect
                           WHERE Object.DescId = zc_Object_Currency()
                             AND Object.Id     <> zc_Currency_Basis()
                             AND vbIsOperPrice = TRUE
                          )

      -- Результат
      SELECT DISTINCT
             zfCalc_PartionMovementName (0, '', Movement.InvNumber, Movement.OperDate) AS InvNumberAll
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName

           , Object_Partner.ValueData            AS PartnerName
           , Object_Unit.ValueData               AS UnitName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Juridical.ValueData          AS JuridicalName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.ValueData        AS CompositionName
           , Object_GoodsInfo.ValueData          AS GoodsInfoName
           , Object_LineFabrica.ValueData        AS LineFabricaName
           , Object_Label.ValueData              AS LabelName
           , Object_GoodsSize.ValueData          AS GoodsSizeName
           , Object_Currency.ValueData           AS CurrencyName

           , Object_PartionGoods.Amount    :: TFLoat AS Amount
             -- в магазине ограничиваем инфу
           , CASE WHEN vbIsOperPrice = FALSE THEN 0 ELSE Object_PartionGoods.OperPrice END :: TFLoat AS OperPrice

             -- !!!ВРЕМЕННО!!!
           , CASE WHEN COALESCE (Object_PartionGoods.OperPriceList, 0) <> COALESCE (tmpPrice.Price, 0)  THEN -1 * CASE WHEN tmpPrice.Price > 0 THEN tmpPrice.Price ELSE Object_PartionGoods.OperPriceList END ELSE Object_PartionGoods.OperPriceList END :: TFLoat AS OperPriceList

             -- % Сезонной скидки !!!НА!!! zc_DateEnd
           , tmpDiscount.DiscountTax         :: TFloat AS DiscountTax

             -- % наценки
           , CAST (CASE WHEN (Object_PartionGoods.OperPrice * tmpCurrency.Amount / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END)
                              <> 0
                        THEN (100 * COALESCE (Object_PartionGoods.OperPriceList, 0)
                            / (Object_PartionGoods.OperPrice * tmpCurrency.Amount / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END)
                              - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

      FROM Object_PartionGoods
           LEFT JOIN tmpPrice ON 1=1
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_PartionGoods.GoodsId

           LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = Object_PartionGoods.PartnerId
           LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = Object_PartionGoods.UnitId
           LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
           LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
           LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
           LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
           LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
           LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
           LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
           LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
           LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = Object_PartionGoods.JuridicalId
           LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
                                                      AND vbIsOperPrice              = TRUE

           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN Movement ON Movement.Id = Object_PartionGoods.MovementId

           LEFT JOIN tmpDiscount ON tmpDiscount.GoodsId = Object_PartionGoods.GoodsId
                                AND ((inUnitId =  0 AND tmpDiscount.UnitId = Object_PartionGoods.UnitId)
                                  OR (inUnitId <> 0 AND tmpDiscount.UnitId = inUnitId)
                                    )

           LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyToId = Object_PartionGoods.CurrencyId

      WHERE Object_PartionGoods.GoodsId = inGoodsId
        -- AND ((Object_PartionGoods.MovementItemId = inPartionId AND inIsPartionAll = FALSE) OR (inIsPartionAll = TRUE))
        AND ((Object_PartionGoods.GoodsSizeId = inGoodsSizeId AND inIsGoodsSizeAll = FALSE) OR (inIsGoodsSizeAll = TRUE) )
     ;

     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.18         *
 19.02.18         *
 26.06.17         *
*/

-- тест
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.06.2017', inEndDate:= '29.06.2017', inUnitId:= 506, inGoodsId:= 709, inPartionId:= 64, inMovementId:= 18, inGoodsSizeId:= 0, inIsGoodsSizeAll:= TRUE, inIsPartionAll:= TRUE, inIsPeriodAll:= TRUE, inSession:= zfCalc_UserAdmin());
