-- Function: gpReport_GoodsMotion ()

DROP FUNCTION IF EXISTS gpReport_GoodsMotion (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMotion (TDateTime, TDateTime, Integer, Integer, Integer, Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMotion (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitGroupId  Integer   ,
    IN inGoodsId      Integer   ,
    IN inPartionId    Integer   ,
    IN inisPartNumber Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              --, ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
              --, PartionId Integer
              --, GoodsCode_parent Integer, GoodsName_parent TVarChar
              , PartnerName TVarChar
              , Article TVarChar
              , PartNumber TBlob
              , GoodsGroupNameFull TVarChar
              , GoodsGroupName TVarChar
              , MeasureName TVarChar
              , GoodsTagName TVarChar
              , GoodsTypeName TVarChar
              , ProdColorName TVarChar
              , TaxKindName TVarChar
              , GoodsSizeId Integer
              , GoodsSizeName TVarChar

              , Price TFloat, Price_end TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat, Amount TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat, Summ TFloat

              , OperPrice              TFloat -- Цена вх
              , OperPriceList          TFloat -- Цена по прайсу
              , OperPrice_cost         TFloat
              , CostPrice              TFloat
              , TotalSummEKPrice_in    TFloat -- Сумма по входным ценам
              , TotalSummPriceList_in  TFloat -- Сумма по прайсу -
              , Summ_Cost              TFloat
              , TotalSummPrice_cost_in TFloat
              , tmpDate TDateTime             -- надо вернуть дату, тогда в гриде не будет кривых данных
              )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


    RETURN QUERY
    WITH tmpWhere AS (SELECT lfSelect.UnitId               AS LocationId
                      FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect
                      wHERE COALESCE (inUnitGroupId,0) <> 0
                     UNION
                      SELECT Object.Id  AS LocationId
                      FROM Object
                      WHERE Object.DescId = zc_Object_Unit()
                        AND Object.isErased = FALSE
                        AND COALESCE (inUnitGroupId,0) = 0
                     )
       , tmpGoods AS (SELECT inGoodsId AS GoodsId
                      WHERE COALESCE (inGoodsId,0) <> 0
                     UNION
                      SELECT Object.Id  AS LocationId
                      FROM Object
                      WHERE Object.DescId = zc_Object_Goods()
                        AND Object.isErased = FALSE
                        AND COALESCE (inGoodsId,0) = 0
                     )
       , tmpPriceBasis AS (SELECT tmp.GoodsId
                                , tmp.ValuePrice
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                    , inOperDate   := CURRENT_DATE) AS tmp
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
                           )
       , tmpContainer_Count AS (SELECT Container.Id            AS ContainerId
                                     , Container.WhereObjectId AS LocationId
                                     , Container.ObjectId      AS GoodsId
                                     , COALESCE (Container.PartionId, 0) AS PartionId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND (Container.PartionId = inPartionId OR inPartionId = 0)
                                     INNER JOIN tmpWhere ON tmpWhere.LocationId = Container.WhereObjectId
                               )

       , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                              , tmpContainer_Count.LocationId
                              , tmpContainer_Count.GoodsId
                              , tmpContainer_Count.PartionId
                              , tmpContainer_Count.Amount
                              , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                          THEN MIContainer.ContainerId_Analyzer
                                     ELSE 0
                                END AS ContainerId_Analyzer
                              , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                          THEN MIContainer.MovementId
                                     ELSE 0
                                END AS MovementId
                              , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                          THEN MIContainer.MovementItemId
                                     ELSE 0
                                END AS MovementItemId
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                               THEN COALESCE (MIContainer.Amount, 0)
                                          ELSE 0
                                     END) AS Amount_Period
                              , SUM (COALESCE (COALESCE (MIContainer.Amount, 0), 0)) AS Amount_Total
                         FROM tmpContainer_Count
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                             AND MIContainer.OperDate >= inStartDate
                         GROUP BY tmpContainer_Count.ContainerId
                                , tmpContainer_Count.LocationId
                                , tmpContainer_Count.GoodsId
                                , tmpContainer_Count.PartionId
                                , tmpContainer_Count.Amount
                                , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                            THEN MIContainer.ContainerId_Analyzer
                                       ELSE 0
                                  END
                                , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            THEN MIContainer.MovementId
                                       ELSE 0
                                  END
                                , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            THEN MIContainer.MovementItemId
                                       ELSE 0
                                  END
                        )
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.LocationId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.PartionId
                                    , Container.Id AS ContainerId_Summ
                                    , COALESCE (Container.Amount,0) AS Amount
                               FROM tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                        AND Container.DescId = zc_Container_Summ()
                                )

       , tmpMI_Summ AS (SELECT tmpContainer_Summ.ContainerId_Count AS ContainerId
                             , tmpContainer_Summ.LocationId
                             , tmpContainer_Summ.GoodsId
                             , tmpContainer_Summ.PartionId
                             , tmpContainer_Summ.Amount
                             , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                         THEN MIContainer.AnalyzerId
                                    ELSE 0
                               END AS AnalyzerId
                             , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                     AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                         THEN MIContainer.ContainerId_Analyzer
                                    ELSE 0
                               END AS ContainerId_Analyzer
                             , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                         THEN MIContainer.MovementId
                                    ELSE 0
                               END AS MovementId
                             , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                         THEN MIContainer.MovementItemId
                                    ELSE 0
                               END AS MovementItemId
                             , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              THEN COALESCE (MIContainer.Amount,0)
                                         ELSE 0
                                    END) AS Amount_Period
                             , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                        FROM tmpContainer_Summ
                             LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId_Summ
                                                                           AND MIContainer.OperDate >= inStartDate
                        GROUP BY tmpContainer_Summ.ContainerId_Count
                               , tmpContainer_Summ.ContainerId_Summ
                               , tmpContainer_Summ.LocationId
                               , tmpContainer_Summ.GoodsId
                               , tmpContainer_Summ.PartionId
                               , tmpContainer_Summ.Amount
                               , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                           THEN MIContainer.AnalyzerId
                                      ELSE 0
                                 END
                               , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                           THEN MIContainer.ContainerId_Analyzer
                                      ELSE 0
                                 END
                               , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                           THEN MIContainer.MovementId
                                      ELSE 0
                                 END
                               , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                           THEN MIContainer.MovementItemId
                                      ELSE 0
                                 END
                       )

      , tmpMI_Summ_group AS (SELECT DISTINCT tmpMI_Summ.MovementId, tmpMI_Summ.MovementItemId, tmpMI_Summ.ContainerId_Analyzer FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0)

      , tmpMI_Id AS (SELECT DISTINCT tmpMI_Count.MovementItemId FROM tmpMI_Count WHERE tmpMI_Count.MovementItemId > 0
                    UNION
                     SELECT DISTINCT tmpMI_Summ.MovementItemId FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0
                    )

      , tmpMI_find AS (SELECT MovementItem.* FROM tmpMI_Id INNER JOIN MovementItem ON MovementItem.Id = tmpMI_Id.MovementItemId)

      , tmpMIContainer_all AS (-- 1.1. Остатки кол-во
                               SELECT -1 AS MovementId
                                    , 0 AS ParentId
                                    , tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , tmpMI_Count.PartionId
                                    , 0    AS ContainerId_Analyzer
                                    , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total)                                   AS AmountStart
                                    , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) + SUM (tmpMI_Count.Amount_Period) AS AmountEnd
                                    , 0 AS AmountIn
                                    , 0 AS AmountOut
                                    , 0 AS SummStart
                                    , 0 AS SummEnd
                                    , 0 AS SummIn
                                    , 0 AS SummOut
                               FROM tmpMI_Count
                               GROUP BY tmpMI_Count.ContainerId
                                      , tmpMI_Count.LocationId
                                      , tmpMI_Count.GoodsId
                                      , tmpMI_Count.PartionId
                                      , tmpMI_Count.Amount
                               HAVING tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) <> 0
                                   OR SUM (tmpMI_Count.Amount_Period) <> 0
                              UNION ALL
                               -- 1.2. Движение кол-во
                               SELECT tmpMI_Count.MovementId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , tmpMI_Count.PartionId
                                    , tmpMI_Count.ContainerId_Analyzer
                                    , 0 AS AmountStart
                                    , 0 AS AmountEnd
                                    , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN      tmpMI_Count.Amount_Period ELSE 0 END AS AmountIn
                                    , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN -1 * tmpMI_Count.Amount_Period ELSE 0 END AS AmountOut
                                    , 0 AS SummStart
                                    , 0 AS SummEnd
                                    , 0 AS SummIn
                                    , 0 AS SummOut
                               FROM tmpMI_Count
                                    LEFT JOIN tmpMI_find AS MovementItem ON MovementItem.Id = tmpMI_Count.MovementItemId
                               WHERE tmpMI_Count.Amount_Period <> 0
                              UNION ALL
                               -- 2.1. Остатки суммы
                               SELECT -1 AS MovementId
                                    , 0 ParentId
                                    , tmpMI_Summ.ContainerId
                                    , tmpMI_Summ.LocationId
                                    , tmpMI_Summ.GoodsId
                                    , tmpMI_Summ.PartionId
                                    , 0 AS ContainerId_Analyzer
                                    , 0 AS AmountStart
                                    , 0 AS AmountEnd
                                    , 0 AS AmountIn
                                    , 0 AS AmountOut
                                    , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) AS SummStart
                                    , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) + SUM (tmpMI_Summ.Amount_Period) AS SummEnd
                                    , 0 AS SummIn
                                    , 0 AS SummOut
                               FROM tmpMI_Summ
                               GROUP BY tmpMI_Summ.ContainerId
                                      , tmpMI_Summ.LocationId
                                      , tmpMI_Summ.GoodsId
                                      , tmpMI_Summ.PartionId
                                      , tmpMI_Summ.Amount
                               HAVING tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) <> 0
                                   OR SUM (tmpMI_Summ.Amount_Period) <> 0
                              UNION ALL
                               -- 2.2. Движение суммы
                               SELECT tmpMI_Summ.MovementId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Summ.ContainerId
                                    , tmpMI_Summ.LocationId
                                    , tmpMI_Summ.GoodsId
                                    , tmpMI_Summ.PartionId
                                    , tmpMI_Summ.ContainerId_Analyzer
                                    , 0 AS AmountStart
                                    , 0 AS AmountEnd
                                    , 0 AS AmountIn
                                    , 0 AS AmountOut
                                    , 0 AS SummStart
                                    , 0 AS SummEnd
                                    , CASE WHEN tmpMI_Summ.Amount_Period > 0 THEN tmpMI_Summ.Amount_Period ELSE 0 END AS SummIn
                                    , CASE WHEN tmpMI_Summ.Amount_Period < 0 THEN -1 * tmpMI_Summ.Amount_Period ELSE 0 END AS SummOut
                               FROM tmpMI_Summ
                                    LEFT JOIN tmpMI_find AS MovementItem ON MovementItem.Id = tmpMI_Summ.MovementItemId
                               WHERE tmpMI_Summ.Amount_Period <> 0
                              )

      , tmpMIContainer_group AS (SELECT tmpMIContainer_all.MovementId
                                      , tmpMIContainer_all.ParentId
                                      , tmpMIContainer_all.LocationId
                                      , tmpMIContainer_all.GoodsId
                                      , tmpMIContainer_all.PartionId
                                      , tmpMIContainer_all.ContainerId_Analyzer
                                      , SUM (COALESCE (tmpMIContainer_all.AmountStart,0))      AS AmountStart
                                      , SUM (COALESCE (tmpMIContainer_all.AmountEnd,0))        AS AmountEnd
                                      , SUM (COALESCE (tmpMIContainer_all.AmountIn,0))         AS AmountIn
                                      , SUM (COALESCE (tmpMIContainer_all.AmountOut,0))        AS AmountOut
                                      , SUM (COALESCE (tmpMIContainer_all.SummStart,0))        AS SummStart
                                      , SUM (COALESCE (tmpMIContainer_all.SummEnd,0))          AS SummEnd
                                      , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                                                  THEN SUM (tmpMIContainer_all.SummIn)
                                             WHEN SUM (tmpMIContainer_all.AmountIn) > 0 AND SUM (tmpMIContainer_all.AmountOut) = 0
                                                  THEN SUM (tmpMIContainer_all.SummIn - tmpMIContainer_all.SummOut)
                                             ELSE 0
                                        END AS SummIn
                                      , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                                                  THEN SUM (tmpMIContainer_all.SummOut)
                                             WHEN SUM (tmpMIContainer_all.AmountOut) > 0 AND SUM (tmpMIContainer_all.AmountIn) = 0
                                                  THEN SUM (tmpMIContainer_all.SummOut - tmpMIContainer_all.SummIn)
                                             ELSE 0
                                        END AS SummOut

                                FROM tmpMIContainer_all
                                 GROUP BY tmpMIContainer_all.MovementId
                                        , tmpMIContainer_all.ParentId
                                        , tmpMIContainer_all.LocationId
                                        , tmpMIContainer_all.GoodsId
                                        , tmpMIContainer_all.PartionId
                                        , tmpMIContainer_all.ContainerId_Analyzer
                               )

  ----
  , tmpMIString AS (SELECT *
                    FROM MovementItemString AS MIString_PartNumber
                    WHERE MIString_PartNumber.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.PartionId FROM tmpMIContainer_group)
                      AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                    )

   -- РЕЗУЛЬТАТ
  , tmpDataAll AS (SELECT tmpDataAll.LocationDescName
                        , tmpDataAll.LocationCode
                        , tmpDataAll.LocationName

                        , tmpDataAll.GoodsId
                        , tmpDataAll.GoodsCode
                        , tmpDataAll.GoodsName

                        , AVG (tmpDataAll.Price)            ::TFloat AS Price
                        , AVG (tmpDataAll.Price_end)        ::TFloat AS Price_end

                        , SUM (tmpDataAll.AmountStart)      ::TFloat  AS AmountStart
                        , SUM (tmpDataAll.AmountIn)         ::TFloat  AS AmountIn
                        , SUM (tmpDataAll.AmountOut)        ::TFloat  AS AmountOut
                        , SUM (tmpDataAll.AmountEnd)        ::TFloat  AS AmountEnd
                        , SUM (tmpDataAll.Amount)           ::TFloat  AS Amount
                        , SUM (tmpDataAll.SummStart)        ::TFloat  AS SummStart
                        , SUM (tmpDataAll.SummIn)           ::TFloat  AS SummIn
                        , SUM (tmpDataAll.SummOut)          ::TFloat  AS SummOut
                        , SUM (tmpDataAll.SummEnd)          ::TFloat  AS SummEnd
                        , SUM (tmpDataAll.Summ)             ::TFloat  AS Summ

                        --из партии
                        , tmpDataAll.PartnerId
                        , tmpDataAll.GoodsSizeId
                        , tmpDataAll.MeasureId
                        , tmpDataAll.GoodsGroupId
                        , tmpDataAll.GoodsTagId
                        , tmpDataAll.GoodsTypeId
                        , tmpDataAll.ProdColorId
                        , tmpDataAll.TaxKindId
                        , tmpDataAll.TaxKindValue
                        , tmpDataAll.OperPriceList
                        , SUM (tmpDataAll.CostPrice) AS CostPrice_summ
                          --  только для Ord = 1
                        , SUM (CASE WHEN tmpDataAll.Ord = 1 THEN tmpDataAll.AmountIn ELSE 0 END) AS Amount_in
                        , SUM (zfCalc_SummIn        (tmpDataAll.AmountIn, tmpDataAll.EKPrice, tmpDataAll.CountForPrice)) AS TotalSummEKPrice_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.OperPriceList))                     AS TotalSummPriceList_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.CostPrice))                         AS TotalSumm_cost_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.OperPrice_cost))                    AS TotalSummPrice_cost_in

                        , STRING_AGG (MIString_PartNumber.ValueData, '; ') AS PartNumber

                   FROM (SELECT ObjectDesc.ItemName            AS LocationDescName
                              , Object_Location.ObjectCode     AS LocationCode
                              , Object_Location.ValueData      AS LocationName

                              , Object_Goods.Id         AS GoodsId
                              , Object_Goods.ObjectCode AS GoodsCode
                              , Object_Goods.ValueData  AS GoodsName
                              , tmpMIContainer_group.PartionId
                              , ''::TVarChar AS GoodsKindName_parent

                              , CAST (CASE WHEN Movement.DescId = zc_Movement_Income() AND 1=0
                                                THEN 0
                                           WHEN tmpMIContainer_group.AmountStart <> 0
                                                THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                                           WHEN tmpMIContainer_group.AmountIn <> 0
                                                THEN tmpMIContainer_group.SummIn / tmpMIContainer_group.AmountIn
                                           WHEN tmpMIContainer_group.AmountOut <> 0
                                                THEN tmpMIContainer_group.SummOut / tmpMIContainer_group.AmountOut
                                           ELSE 0
                                      END AS TFloat) AS Price

                              , CAST (CASE WHEN tmpMIContainer_group.AmountEnd <> 0
                                                THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd
                                           ELSE 0
                                      END AS TFloat) AS Price_end

                              , CAST (tmpMIContainer_group.AmountStart AS TFloat) AS AmountStart
                              , CAST (tmpMIContainer_group.AmountIn AS TFloat)    AS AmountIn
                              , CAST (tmpMIContainer_group.AmountOut AS TFloat)   AS AmountOut
                              , CAST (tmpMIContainer_group.AmountEnd AS TFloat)   AS AmountEnd
                              , CAST ((tmpMIContainer_group.AmountIn - tmpMIContainer_group.AmountOut)
                                    * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
                                      AS TFloat) AS Amount

                              , CAST (tmpMIContainer_group.SummStart AS TFloat)   AS SummStart
                              , CAST (tmpMIContainer_group.SummIn AS TFloat)      AS SummIn
                              , CAST (tmpMIContainer_group.SummOut AS TFloat)     AS SummOut
                              , CAST (tmpMIContainer_group.SummEnd AS TFloat)     AS SummEnd
                              , CAST ((tmpMIContainer_group.SummIn - tmpMIContainer_group.SummOut)
                                    * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
                                      AS TFloat) AS Summ

                               -- из партии
                              , Object_PartionGoods.FromId AS PartnerId
                              , Object_PartionGoods.GoodsSizeId
                              , Object_PartionGoods.MeasureId
                              , Object_PartionGoods.GoodsGroupId
                              , Object_PartionGoods.GoodsTagId
                              , Object_PartionGoods.GoodsTypeId
                              , Object_PartionGoods.ProdColorId
                              , Object_PartionGoods.TaxKindId
                              , Object_PartionGoods.TaxValue AS TaxKindValue
                              , Object_PartionGoods.EKPrice
                              , Object_PartionGoods.CountForPrice
                              , COALESCE (tmpPriceBasis.ValuePrice, Object_PartionGoods.OperPriceList) AS OperPriceList
                                -- Цена без НДС затраты
                              , Object_PartionGoods.CostPrice     ::TFloat
                                -- Цена вх. с затратами без НДС
                              , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
                              , Object_PartionGoods.Amount     AS Amount_in
                                --  № п/п - только для = 1 возьмем Amount_in
                              , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer_group.PartionId ORDER BY CASE WHEN tmpMIContainer_group.LocationId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord

                         FROM tmpMIContainer_group
                              LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
                              LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                              INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId

                              LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
                              LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
                              LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpMIContainer_group.LocationId

                              LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_group.PartionId
                                                           AND Object_PartionGoods.ObjectId       = tmpMIContainer_group.GoodsId
                                                           AND Object_PartionGoods.isErased       = FALSE
                               -- цена из Прайс-листа
                              LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpMIContainer_group.GoodsId
                         ) AS tmpDataAll
                     LEFT JOIN tmpMIString AS MIString_PartNumber
                                           ON MIString_PartNumber.MovementItemId = tmpDataAll.PartionId
                                          AND COALESCE (MIString_PartNumber.ValueData,'') <> ''
                   GROUP BY tmpDataAll.LocationDescName
                          , tmpDataAll.LocationCode
                          , tmpDataAll.LocationName
                          , tmpDataAll.GoodsId
                          , tmpDataAll.GoodsCode
                          , tmpDataAll.GoodsName
                          , tmpDataAll.GoodsSizeId
                          , tmpDataAll.MeasureId
                          , tmpDataAll.GoodsGroupId
                          , tmpDataAll.GoodsTagId
                          , tmpDataAll.GoodsTypeId
                          , tmpDataAll.ProdColorId
                          , tmpDataAll.TaxKindId
                          , tmpDataAll.TaxKindValue
                          , tmpDataAll.OperPriceList
                          , tmpDataAll.PartnerId
                          , CASE WHEN inisPartNumber = TRUE THEN MIString_PartNumber.ValueData ELSE '' END
                   HAVING SUM (tmpDataAll.AmountStart) <> 0
                       OR SUM (tmpDataAll.AmountIn)    <> 0
                       OR SUM (tmpDataAll.AmountOut)   <> 0
                       OR SUM (tmpDataAll.AmountEnd)   <> 0
                       OR SUM (tmpDataAll.SummStart)   <> 0
                       OR SUM (tmpDataAll.SummIn)      <> 0
                       OR SUM (tmpDataAll.SummOut)     <> 0
                       OR SUM (tmpDataAll.SummEnd)     <> 0
                   )


   -- РЕЗУЛЬТАТ
   SELECT tmpDataAll.LocationDescName
        , tmpDataAll.LocationCode
        , tmpDataAll.LocationName
        , tmpDataAll.GoodsId
        , tmpDataAll.GoodsCode
        , tmpDataAll.GoodsName
        , (Object_Partner.ValueData || ' (' || Object_Partner.Id :: TVarChar || ')') :: TVarChar AS PartnerName
        , ObjectString_Article.ValueData        AS Article
        , tmpDataAll.PartNumber        :: TBlob AS PartNumber
        , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
        , Object_GoodsGroup.ValueData           AS GoodsGroupName
        , Object_Measure.ValueData              AS MeasureName
        , Object_GoodsTag.ValueData             AS GoodsTagName
        , Object_GoodsType.ValueData            AS GoodsTypeName
        , Object_ProdColor.ValueData            AS ProdColorName
        , Object_TaxKind.ValueData              AS TaxKindName
        , Object_GoodsSize.Id                   AS GoodsSizeId
        , Object_GoodsSize.ValueData ::TVarChar AS GoodsSizeName

        , tmpDataAll.Price            ::TFloat AS Price
        , tmpDataAll.Price_end        ::TFloat AS Price_end

        , CAST (tmpDataAll.AmountStart AS NUMERIC (16,2)) ::TFloat  AS AmountStart
        , CAST (tmpDataAll.AmountIn AS NUMERIC (16,2))    ::TFloat  AS AmountIn
        , CAST (tmpDataAll.AmountOut AS NUMERIC (16,2))   ::TFloat  AS AmountOut
        , CAST (tmpDataAll.AmountEnd AS NUMERIC (16,2))   ::TFloat  AS AmountEnd
        , CAST (tmpDataAll.Amount AS NUMERIC (16,2))      ::TFloat  AS Amount
        , CAST (tmpDataAll.SummStart AS NUMERIC (16,2))   ::TFloat  AS SummStart
        , CAST (tmpDataAll.SummIn AS NUMERIC (16,2))      ::TFloat  AS SummIn
        , CAST (tmpDataAll.SummOut AS NUMERIC (16,2))     ::TFloat  AS SummOut
        , CAST (tmpDataAll.SummEnd AS NUMERIC (16,2))     ::TFloat  AS SummEnd
        , CAST (tmpDataAll.Summ AS NUMERIC (16,2))        ::TFloat  AS Summ

           -- Цена вх
        , CASE WHEN tmpDataAll.Amountin  <> 0 THEN tmpDataAll.TotalSummEKPrice_in / tmpDataAll.Amountin ELSE 0 END :: TFloat AS OperPrice
          -- Цена по прайсу
        , tmpDataAll.OperPriceList            :: TFloat AS OperPriceList
        --, tmpData.OperPrice_cost   :: TFloat
        , CASE WHEN tmpDataAll.Amountin  <> 0 THEN COALESCE (tmpDataAll.TotalSummEKPrice_in,0) + COALESCE (tmpDataAll.CostPrice_summ,0) / tmpDataAll.Amountin
               ELSE 0
          END                                 :: TFloat AS OperPrice_cost
        , tmpDataAll.CostPrice_summ           :: TFloat AS CostPrice

          -- Сумма по входным ценам
        , tmpDataAll.TotalSummEKPrice_in     :: TFloat AS TotalSummEKPrice_in
          -- Сумма по прайсу -
        , tmpDataAll.TotalSummPriceList_in   :: TFloat AS TotalSummPriceList_in

        , tmpDataAll.TotalSumm_Cost_in       :: TFloat AS Summ_Cost
        , tmpDataAll.TotalSummPrice_cost_in  :: TFloat AS TotalSummPrice_cost_in
 
          -- надо вернуть дату, тогда в гриде не будет кривых данных
        , CURRENT_TIMESTAMP :: TDateTime   AS tmpDate

   FROM tmpDataAll
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpDataAll.PartnerId
            INNER JOIN Object AS Object_Goods  ON Object_Goods.Id   = tmpDataAll.GoodsId
                                              AND Object_Goods.DescId = zc_Object_Goods()
                                              AND Object_Goods.Id <> 0

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpDataAll.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpDataAll.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpDataAll.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpDataAll.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpDataAll.ProdColorId
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = tmpDataAll.TaxKindId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpDataAll.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpDataAll.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpDataAll.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.22         *
*/

-- тест
-- select * from gpReport_GoodsMotion(inStartDate := ('02.03.2020')::TDateTime , inEndDate := ('03.03.2022')::TDateTime , inUnitGroupId := 0 , inGoodsId := 5609 , inPartionId := 0, inisPartNumber:=False, inSession := '5');
