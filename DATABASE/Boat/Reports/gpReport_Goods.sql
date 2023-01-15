-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inUnitGroupId      Integer   ,
    IN inGoodsId          Integer   ,
    IN inPartionId        Integer   , 
    IN inisPartNumber     Boolean  ,  -- по серийным номерам
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
              , MovementDescName TVarChar, MovementDescName_order TVarChar
              , isActive Boolean, isRemains Boolean, isRePrice Boolean, isInv Boolean
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, PartionId Integer
              , GoodsCode_parent Integer, GoodsName_parent TVarChar
              , PartnerName TVarChar
              , Article TVarChar, Article_all TVarChar
              , PartNumber TVarChar
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
               
              , OperPrice   TFloat           -- Цена вх
              , OperPriceList  TFloat        -- Цена по прайсу
              , OperPrice_cost TFloat
              , CostPrice TFloat
              , TotalSummEKPrice_in TFloat   -- Сумма по входным ценам
              , TotalSummPriceList_in TFloat -- Сумма по прайсу - 
              , Summ_Cost TFloat
              , TotalSummPrice_cost_in TFloat
             
              , InvNumberFull_OrderClient TVarChar, FromName_OrderClient TVarChar, ProductName_OrderClient TVarChar, CIN_OrderClient TVarChar
              )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
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
                                               THEN MIContainer.Amount
                                          ELSE 0
                                     END) AS Amount_Period
                              , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                              , MIContainer.MovementDescId
                              , MIContainer.isActive
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
                                , MIContainer.MovementDescId
                                , MIContainer.isActive
                        )
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.LocationId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.PartionId
                                    , Container.Id AS ContainerId_Summ
                                    , Container.Amount
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
                                              THEN MIContainer.Amount
                                         ELSE 0
                                    END) AS Amount_Period
                             , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                             , MIContainer.MovementDescId
                             , MIContainer.isActive
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
                               , MIContainer.MovementDescId
                               , MIContainer.isActive
                       )

         , tmpMI_Summ_group AS (SELECT DISTINCT tmpMI_Summ.MovementId, tmpMI_Summ.MovementItemId, tmpMI_Summ.ContainerId_Analyzer, tmpMI_Summ.isActive FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0)

      , tmpMI_Id AS (SELECT DISTINCT tmpMI_Count.MovementItemId FROM tmpMI_Count WHERE tmpMI_Count.MovementItemId > 0
                    UNION
                     SELECT DISTINCT tmpMI_Summ.MovementItemId FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0
                    )

      , tmpMI_find AS (SELECT MovementItem.* FROM tmpMI_Id INNER JOIN MovementItem ON MovementItem.Id = tmpMI_Id.MovementItemId)
      --, tmpMID_PartionGoods AS (SELECT MID.* FROM tmpMI_Id INNER JOIN MovementItemDate AS MID ON MID.MovementItemId = tmpMI_Id.MovementItemId AND MID.DescId = zc_MIDate_PartionGoods())
      --, tmpMIS_PartionGoods AS (SELECT MIS.* FROM tmpMI_Id INNER JOIN MovementItemString AS MIS ON MIS.MovementItemId = tmpMI_Id.MovementItemId AND MIS.DescId = zc_MIString_PartionGoods())

      , tmpMIContainer_all AS (-- 1.1. Остатки кол-во
                               SELECT -1 AS MovementId
                                    -- , 0 AS MovementItemId
                                    , 0 AS ParentId
                                    , tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , tmpMI_Count.PartionId
                                    , 0    AS ContainerId_Analyzer
                                    , TRUE  AS isActive
                                    , FALSE AS isReprice
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
                                    -- , tmpMI_Count.MovementItemId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , tmpMI_Count.PartionId
                                    , tmpMI_Count.ContainerId_Analyzer
                                    , tmpMI_Count.isActive
                                    , FALSE AS isReprice
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
                                    --LEFT JOIN tmpMID_PartionGoods AS MIDate_PartionGoods ON MIDate_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId
                                    --LEFT JOIN tmpMIS_PartionGoods AS MIString_PartionGoods ON MIString_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId

                                   /* LEFT JOIN MovementString AS MovementString_PartionGoods
                                                             ON MovementString_PartionGoods.MovementId = tmpMI_Count.MovementId
                                                            AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                            AND tmpMI_Count.MovementDescId = zc_Movement_ProductionSeparate()*/
                                    /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Count.MovementItemId
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                               WHERE tmpMI_Count.Amount_Period <> 0
                              UNION ALL
                               -- 2.1. Остатки суммы
                               SELECT -1 AS MovementId
                                    -- , 0 AS MovementItemId
                                    , 0 ParentId
                                    , tmpMI_Summ.ContainerId
                                    , tmpMI_Summ.LocationId
                                    , tmpMI_Summ.GoodsId
                                    , tmpMI_Summ.PartionId
                                    , 0 AS ContainerId_Analyzer
                                    , TRUE AS isActive
                                    , FALSE AS isReprice
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
                                    -- , tmpMI_Summ.MovementItemId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Summ.ContainerId
                                    , tmpMI_Summ.LocationId
                                    , tmpMI_Summ.GoodsId
                                    , tmpMI_Summ.PartionId
                                    , tmpMI_Summ.ContainerId_Analyzer
                                    , tmpMI_Summ.isActive
                                    , CASE WHEN tmpMI_Summ.AnalyzerId = zc_Enum_AccountGroup_60000() THEN TRUE ELSE FALSE END AS isReprice
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
                                    --LEFT JOIN tmpMID_PartionGoods AS MIDate_PartionGoods ON MIDate_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                    --LEFT JOIN tmpMIS_PartionGoods AS MIString_PartionGoods ON MIString_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                    /*LEFT JOIN MovementString AS MovementString_PartionGoods
                                                             ON MovementString_PartionGoods.MovementId = tmpMI_Summ.MovementId
                                                            AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                            AND tmpMI_Summ.MovementDescId = zc_Movement_ProductionSeparate()*/
                               WHERE tmpMI_Summ.Amount_Period <> 0
                              )

      , tmpMIContainer_group AS (SELECT tmpMIContainer_all.MovementId
                                      -- , 0 AS MovementItemId
                                      , tmpMIContainer_all.ParentId
                                      , tmpMIContainer_all.LocationId
                                      , tmpMIContainer_all.GoodsId
                                      , tmpMIContainer_all.PartionId
                                      , tmpMIContainer_all.ContainerId_Analyzer
                                      , tmpMIContainer_all.isActive
                                      , tmpMIContainer_all.isReprice
                                      , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
                                      , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
                                      , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
                                      , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut
                                      , SUM (tmpMIContainer_all.SummStart)        AS SummStart
                                      , SUM (tmpMIContainer_all.SummEnd)          AS SummEnd
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
                                        -- , tmpMIContainer_all.MovementItemId
                                        , tmpMIContainer_all.ParentId
                                        , tmpMIContainer_all.LocationId
                                        , tmpMIContainer_all.GoodsId
                                        , tmpMIContainer_all.PartionId
                                        , tmpMIContainer_all.ContainerId_Analyzer
                                        , tmpMIContainer_all.isActive
                                        , tmpMIContainer_all.isReprice
                               )

  ----
  
  , tmpMLO_By AS (SELECT MovementLinkObject_By.*
                  FROM MovementLinkObject AS MovementLinkObject_By
                   WHERE MovementLinkObject_By.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group) 
                     AND MovementLinkObject_By.DescId IN ( zc_MovementLinkObject_From()
                                                         , zc_MovementLinkObject_To()
                                                         , zc_MovementLinkObject_PaidKind()
                                                         )
                 )

  , tmpMovementDate AS (SELECT MovementDate_OperDatePartner.*
                        FROM MovementDate AS MovementDate_OperDatePartner
                        WHERE MovementDate_OperDatePartner.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group) 
                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        )

  , tmpMIString AS (SELECT *
                    FROM MovementItemString AS MIString_PartNumber
                    WHERE MIString_PartNumber.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.PartionId FROM tmpMIContainer_group)
                      AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                    ) 

  , tmpMIFloat_OrderClient AS (SELECT MIFloat_MovementId.MovementItemId   
                                    , MIFloat_MovementId.ValueData ::Integer
                                    , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber_OrderClient
                                    , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
                                    , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
                                    , Object_From.ValueData                                     AS FromName
                                    , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
                                    , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN  
                               FROM MovementItemFloat AS MIFloat_MovementId
                                    LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData ::Integer

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                                    LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

                                    LEFT JOIN ObjectString AS ObjectString_CIN
                                                           ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                          AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                               WHERE MIFloat_MovementId.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.PartionId FROM tmpMIContainer_group)
                                 AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                               )


   -- РЕЗУЛЬТАТ
  , tmpDataAll AS (SELECT tmpDataAll.MovementId AS MovementId
                        , tmpDataAll.InvNumber  ::TVarChar AS InvNumber
                        , tmpDataAll.OperDate
                        , tmpDataAll.OperDatePartner ::TDateTime AS OperDatePartner

                        , tmpDataAll.MovementDescName ::TVarChar AS MovementDescName
                        , tmpDataAll.MovementDescName_order  ::TVarChar AS MovementDescName_order

                        , tmpDataAll.isActive
                        , tmpDataAll.isRemains
                        , tmpDataAll.isRePrice
                        , tmpDataAll.isInv

                        , tmpDataAll.LocationDescName
                        , tmpDataAll.LocationCode
                        , tmpDataAll.LocationName

                        , tmpDataAll.ObjectByDescName
                        , tmpDataAll.ObjectByCode
                        , tmpDataAll.ObjectByName

                        , tmpDataAll.PaidKindName

                        , tmpDataAll.GoodsId
                        , tmpDataAll.GoodsCode
                        , tmpDataAll.GoodsName
                        , tmpDataAll.PartionId
                        , tmpDataAll.GoodsCode_parent
                        , tmpDataAll.GoodsName_parent

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
                        --, tmpDataAll.CountForPrice
                        --, tmpDataAll.UnitId_in
                          --  только для Ord = 1
                        , SUM (CASE WHEN tmpDataAll.Ord = 1 THEN tmpDataAll.AmountIn ELSE 0 END) AS Amount_in
                        , SUM (zfCalc_SummIn        (tmpDataAll.AmountIn, tmpDataAll.EKPrice, tmpDataAll.CountForPrice)) AS TotalSummEKPrice_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.OperPriceList))                     AS TotalSummPriceList_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.CostPrice))                         AS TotalSumm_cost_in
                        , SUM (zfCalc_SummPriceList (tmpDataAll.AmountIn, tmpDataAll.OperPrice_cost))                    AS TotalSummPrice_cost_in

                        , STRING_AGG (MIString_PartNumber.ValueData, ' ;') ::TVarChar AS PartNumber

                        --OrderClient
                        , CASE WHEN inisPartNumber = TRUE THEN MIFloat_MovementId.InvNumberFull_OrderClient ELSE '' END AS InvNumberFull_OrderClient
                        , CASE WHEN inisPartNumber = TRUE THEN MIFloat_MovementId.FromName ELSE '' END        AS FromName_OrderClient
                        , CASE WHEN inisPartNumber = TRUE THEN MIFloat_MovementId.ProductName ELSE '' END     AS ProductName_OrderClient
                        , CASE WHEN inisPartNumber = TRUE THEN MIFloat_MovementId.CIN ELSE '' END             AS CIN_OrderClient
                   FROM (SELECT Movement.Id AS MovementId
                        , Movement.InvNumber
                        , Movement.OperDate
                        , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                
                        , MovementDesc.ItemName :: TVarChar AS MovementDescName
                
                        , CASE WHEN Movement.DescId = zc_Movement_Income()
                                    THEN '01 ' || MovementDesc.ItemName
                               /*WHEN Movement.DescId = zc_Movement_ReturnOut()
                                    THEN '02 ' || MovementDesc.ItemName
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpMIContainer_group.isActive = TRUE
                                    THEN '03 ' || MovementDesc.ItemName
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpMIContainer_group.isActive = FALSE
                                    THEN '04 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ProductionUnion() AND tmpMIContainer_group.isActive = TRUE
                                    THEN '05 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ProductionUnion() AND tmpMIContainer_group.isActive = FALSE
                                    THEN '06 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ProductionSeparate() AND tmpMIContainer_group.isActive = TRUE
                                    THEN '07 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ProductionSeparate() AND tmpMIContainer_group.isActive = FALSE
                                    THEN '08 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_SendOnPrice() AND tmpMIContainer_group.isActive = TRUE
                                    THEN '109 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_SendOnPrice() AND tmpMIContainer_group.isActive = FALSE
                                    THEN '110 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Sale()
                                    THEN '111 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ReturnIn()
                                    THEN '112 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Loss()
                                    THEN '13 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = TRUE  AND tmpMIContainer_group.isRePrice = FALSE
                                    THEN '14 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = FALSE AND tmpMIContainer_group.isRePrice = FALSE
                                    THEN '15 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = TRUE  AND tmpMIContainer_group.isRePrice = TRUE
                                    THEN '16 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = FALSE AND tmpMIContainer_group.isRePrice = TRUE
                                    THEN '17 ' || MovementDesc.ItemName
                               */
                               ELSE '201 ' || MovementDesc.ItemName
                          END :: TVarChar AS MovementDescName_order
                
                        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN NULL ELSE tmpMIContainer_group.isActive END :: Boolean AS isActive
                        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN TRUE ELSE FALSE END :: Boolean AS isRemains
                        , tmpMIContainer_group.isRePrice
                        , CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN TRUE ELSE FALSE END :: Boolean AS isInv
                
                        , ObjectDesc.ItemName            AS LocationDescName
                        , Object_Location.ObjectCode     AS LocationCode
                        , Object_Location.ValueData      AS LocationName
                        , ObjectDesc_By.ItemName         AS ObjectByDescName
                        , Object_By.ObjectCode           AS ObjectByCode
                        , Object_By.ValueData            AS ObjectByName
             
                        , Object_PaidKind.ValueData AS PaidKindName
                
                        , Object_Goods.Id         AS GoodsId
                        , Object_Goods.ObjectCode AS GoodsCode
                        , Object_Goods.ValueData  AS GoodsName
                        , tmpMIContainer_group.PartionId
                        , Object_Goods_parent.ObjectCode AS GoodsCode_parent
                        , Object_Goods_parent.ValueData  AS GoodsName_parent
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
                             -- * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                                AS TFloat) AS Amount
                
                        , CAST (tmpMIContainer_group.SummStart AS TFloat)   AS SummStart
                        , CAST (tmpMIContainer_group.SummIn AS TFloat)      AS SummIn
                        , CAST (tmpMIContainer_group.SummOut AS TFloat)     AS SummOut
                        , CAST (tmpMIContainer_group.SummEnd AS TFloat)     AS SummEnd
                        , CAST ((tmpMIContainer_group.SummIn - tmpMIContainer_group.SummOut)
                              * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
                              --* CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
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
                        --, Object_PartionGoods.MovementId  -- приход
                        , Object_PartionGoods.EKPrice
                        , Object_PartionGoods.CountForPrice
                        , COALESCE (tmpPriceBasis.ValuePrice, Object_PartionGoods.OperPriceList) AS OperPriceList
                          -- Цена без НДС затраты
                        , Object_PartionGoods.CostPrice     ::TFloat
                          -- Цена вх. с затратами без НДС
                        , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
                        , Object_PartionGoods.Amount     AS Amount_in
                        --, Object_PartionGoods.UnitId     AS UnitId_in
                          --  № п/п - только для = 1 возьмем Amount_in
                        , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer_group.PartionId ORDER BY CASE WHEN tmpMIContainer_group.LocationId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord

                   FROM tmpMIContainer_group
                        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
                        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                
                        LEFT JOIN ContainerLinkObject AS CLO_Object_By
                                                      ON CLO_Object_By.ContainerId = tmpMIContainer_group.ContainerId_Analyzer
                                                     AND CLO_Object_By.DescId IN (zc_ContainerLinkObject_Partner(), zc_ContainerLinkObject_Member())
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_By
                                            ON MovementLinkObject_By.MovementId = tmpMIContainer_group.MovementId
                                           AND MovementLinkObject_By.DescId = CASE WHEN Movement.DescId = zc_Movement_Income() THEN zc_MovementLinkObject_From()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                                   --WHEN Movement.DescId = zc_Movement_Loss() THEN zc_MovementLinkObject_ArticleLoss()
                                                                                   --WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE THEN zc_MovementLinkObject_From()
                                                                                   --WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN zc_MovementLinkObject_To()
                                                                              END
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = tmpMIContainer_group.MovementId
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                
                        LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = tmpMIContainer_group.MovementId
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                
                        LEFT JOIN MovementItem AS MovementItem_parent ON MovementItem_parent.Id = tmpMIContainer_group.ParentId
                        LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MovementItem_parent.ObjectId
                
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
                
                        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
                        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
                        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpMIContainer_group.LocationId
                        LEFT JOIN Object AS Object_By ON Object_By.Id = CASE WHEN CLO_Object_By.ObjectId > 0 THEN CLO_Object_By.ObjectId ELSE MovementLinkObject_By.ObjectId END
                        LEFT JOIN ObjectDesc AS ObjectDesc_By ON ObjectDesc_By.Id = Object_By.DescId
                        --LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionId

                        LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_group.PartionId
                                                     AND Object_PartionGoods.ObjectId       = tmpMIContainer_group.GoodsId
                                                     AND Object_PartionGoods.isErased       = FALSE
                         -- цена из Прайс-листа
                        LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpMIContainer_group.GoodsId
                   ) AS tmpDataAll
                     LEFT JOIN tmpMIString AS MIString_PartNumber
                                           ON MIString_PartNumber.MovementItemId = tmpDataAll.PartionId

                     LEFT JOIN tmpMIFloat_OrderClient AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = tmpDataAll.PartionId
                                                     AND COALESCE (MIFloat_MovementId.ValueData,0) <> 0
                   GROUP BY tmpDataAll.MovementId
                          , tmpDataAll.InvNumber
                          , tmpDataAll.OperDate
                          , tmpDataAll.OperDatePartner
                          , tmpDataAll.MovementDescName
                          , tmpDataAll.MovementDescName_order
                          , tmpDataAll.isActive
                          , tmpDataAll.isRemains
                          , tmpDataAll.isRePrice
                          , tmpDataAll.isInv
                          , tmpDataAll.LocationDescName
                          , tmpDataAll.LocationCode
                          , tmpDataAll.LocationName
                          , tmpDataAll.ObjectByDescName
                          , tmpDataAll.ObjectByCode
                          , tmpDataAll.ObjectByName
                          , tmpDataAll.PaidKindName
                          , tmpDataAll.GoodsId
                          , tmpDataAll.GoodsCode
                          , tmpDataAll.GoodsName
                          , tmpDataAll.PartionId
                          , tmpDataAll.GoodsCode_parent
                          , tmpDataAll.GoodsName_parent

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
                          , MIFloat_MovementId.InvNumberFull_OrderClient
                          , MIFloat_MovementId.FromName
                          , MIFloat_MovementId.ProductName
                          , MIFloat_MovementId.CIN
                   )


   -- РЕЗУЛЬТАТ
   SELECT tmpDataAll.MovementId AS MovementId
        , tmpDataAll.InvNumber  ::TVarChar AS InvNumber
        , tmpDataAll.OperDate
        , tmpDataAll.OperDatePartner ::TDateTime AS OperDatePartner

        , tmpDataAll.MovementDescName ::TVarChar AS MovementDescName
        , tmpDataAll.MovementDescName_order  ::TVarChar AS MovementDescName_order

        , tmpDataAll.isActive
        , tmpDataAll.isRemains
        , tmpDataAll.isRePrice
        , tmpDataAll.isInv

        , tmpDataAll.LocationDescName
        , tmpDataAll.LocationCode
        , tmpDataAll.LocationName

        , tmpDataAll.ObjectByDescName
        , tmpDataAll.ObjectByCode
        , tmpDataAll.ObjectByName

        , tmpDataAll.PaidKindName

        , tmpDataAll.GoodsId
        , tmpDataAll.GoodsCode
        , tmpDataAll.GoodsName
        , tmpDataAll.PartionId
        , tmpDataAll.GoodsCode_parent
        , tmpDataAll.GoodsName_parent

        , Object_Partner.ValueData       AS PartnerName
        , ObjectString_Article.ValueData AS Article
        , zfCalc_Article_all (ObjectString_Article.ValueData)::TVarChar AS Article_all
        , tmpDataAll.PartNumber ::TVarChar
        , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , Object_Measure.ValueData       AS MeasureName
        , Object_GoodsTag.ValueData      AS GoodsTagName
        , Object_GoodsType.ValueData     AS GoodsTypeName
        , Object_ProdColor.ValueData     AS ProdColorName
        , Object_TaxKind.ValueData       AS TaxKindName
        , Object_GoodsSize.Id            AS GoodsSizeId
        , Object_GoodsSize.ValueData ::TVarChar AS GoodsSizeName


        , tmpDataAll.Price            ::TFloat AS Price
        , tmpDataAll.Price_end        ::TFloat AS Price_end

        , tmpDataAll.AmountStart      ::TFloat  AS AmountStart      
        , tmpDataAll.AmountIn         ::TFloat  AS AmountIn         
        , tmpDataAll.AmountOut        ::TFloat  AS AmountOut        
        , tmpDataAll.AmountEnd        ::TFloat  AS AmountEnd        
        , tmpDataAll.Amount           ::TFloat  AS Amount 
        , tmpDataAll.SummStart        ::TFloat  AS SummStart        
        , tmpDataAll.SummIn           ::TFloat  AS SummIn           
        , tmpDataAll.SummOut          ::TFloat  AS SummOut          
        , tmpDataAll.SummEnd          ::TFloat  AS SummEnd          
        , tmpDataAll.Summ             ::TFloat  AS Summ

           -- Цена вх
           , CASE WHEN tmpDataAll.Amountin  <> 0 THEN tmpDataAll.TotalSummEKPrice_in / tmpDataAll.Amountin ELSE 0 END :: TFloat AS OperPrice
             -- Цена по прайсу
           , tmpDataAll.OperPriceList :: TFloat
           --, tmpData.OperPrice_cost   :: TFloat
           , CASE WHEN tmpDataAll.Amountin  <> 0 THEN COALESCE (tmpDataAll.TotalSummEKPrice_in,0) + COALESCE (tmpDataAll.CostPrice_summ,0) / tmpDataAll.Amountin
                  ELSE 0
             END :: TFloat AS OperPrice_cost
           , tmpDataAll.CostPrice_summ        :: TFloat AS CostPrice

             -- Сумма по входным ценам
           , tmpDataAll.TotalSummEKPrice_in      :: TFloat AS TotalSummEKPrice_in
             -- Сумма по прайсу - 
           , tmpDataAll.TotalSummPriceList_in      :: TFloat AS TotalSummPriceList_in
           
           , tmpDataAll.TotalSumm_Cost_in   :: TFloat AS Summ_Cost
           , tmpDataAll.TotalSummPrice_cost_in  :: TFloat AS TotalSummPrice_cost_in

           , tmpDataAll.InvNumberFull_OrderClient   ::TVarChar
           , tmpDataAll.FromName_OrderClient        ::TVarChar
           , tmpDataAll.ProductName_OrderClient     ::TVarChar
           , tmpDataAll.CIN_OrderClient             ::TVarChar
   FROM tmpDataAll
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpDataAll.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpDataAll.GoodsId

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
 08.04.21         *
*/

-- тест
--select * from gpReport_Goods(inStartDate := ('02.03.2020')::TDateTime , inEndDate := ('03.03.2021')::TDateTime , inUnitGroupId := 0 , inGoodsId := 3780 , inPartionId := 28494, inisPartNumber := 'False', inSession := '5');