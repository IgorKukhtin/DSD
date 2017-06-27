-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   ,
    IN inGoodsId      Integer   ,
    IN inGoodsSizeId  Integer,    --
    IN inisGoodsSize  Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
              , isActive Boolean, isRemains Boolean

              , LocationCode Integer, LocationName TVarChar
              , GoodsCode Integer, GoodsName TVarChar

              , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar
              , JuridicalName TVarChar
              , CompositionGroupName TVarChar
              , CompositionName TVarChar
              , GoodsInfoName TVarChar
              , LineFabricaName TVarChar
              , LabelName TVarChar
              , GoodsSizeName TVarChar
              , CurrencyName  TVarChar

              , Price TFloat--, Price_end TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
              , SummStart_Balance TFloat, SummIn_Balance TFloat, SummOut_Balance TFloat, SummEnd_Balance TFloat
        
              , SummStart_PriceList  TFloat
              , SummIn_PriceList     TFloat
              , SummOut_PriceList    TFloat
              , SummEnd_PriceList    TFloat

              , CurrencyValue_Start TFloat
              , ParValue_Start      TFloat
              , CurrencyValue_End   TFloat
              , ParValue_End        TFloat
              , CurrencyValue       TFloat
              , ParValue            TFloat
               )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsBranch Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
     vbUserId:= lpGetUserBySession (inSession);
     
    RETURN QUERY
    WITH tmpWhere AS (SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId, inGoodsId AS GoodsId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect )
                    
       , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                     , Container.PartionId   AS PartionId
                                     , Container.Amount
                                FROM tmpWhere
                                     INNER JOIN Container ON Container.ObjectId = tmpWhere.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN ContainerLinkObject AS CLO_Location ON CLO_Location.ContainerId = Container.Id
                                                                                   AND CLO_Location.DescId      = tmpWhere.DescId
                                                                                   AND CLO_Location.ObjectId    = tmpWhere.LocationId

                                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
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
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
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
                                   , tmpMIContainer_all.GoodsId
                                   , tmpMIContainer_all.PartionId
                                   , tmpMIContainer_all.ContainerId_Analyzer
                                   , tmpMIContainer_all.isActive
        
                                   , CASE WHEN inisGoodsSize = TRUE THEN Object_PartionGoods.GoodsSizeId ELSE 0 END  AS GoodsSizeId
                                   , Object_PartionGoods.MeasureId
                                   , Object_PartionGoods.GoodsGroupId
                                   , Object_PartionGoods.CompositionId
                                   , Object_PartionGoods.CompositionGroupId
                                   , Object_PartionGoods.GoodsInfoId
                                   , Object_PartionGoods.LineFabricaId 
                                   , Object_PartionGoods.LabelId
                                   , Object_PartionGoods.JuridicalId
                                   , Object_PartionGoods.CurrencyId
                                   , Object_PartionGoods.PeriodYear
                                   , COALESCE (Object_PartionGoods.CountForPrice, 1) AS CountForPrice

                                   , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
                                   , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
                                   , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
                                   , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut
                                   , SUM (CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                    THEN CAST (COALESCE (tmpMIContainer_all.AmountStart, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                               ELSE CAST ( COALESCE (tmpMIContainer_all.AmountStart, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                          END) AS SummStart
                                   , SUM (CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                    THEN CAST (COALESCE (tmpMIContainer_all.AmountEnd, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                               ELSE CAST ( COALESCE (tmpMIContainer_all.AmountEnd, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                          END) AS SummEnd
                                   , SUM (CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                    THEN CAST (COALESCE (tmpMIContainer_all.AmountIn, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                               ELSE CAST ( COALESCE (tmpMIContainer_all.AmountIn, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                          END) AS SummIn
                     
                                   , SUM (CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                                    THEN CAST (COALESCE (tmpMIContainer_all.AmountOut, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                               ELSE CAST ( COALESCE (tmpMIContainer_all.AmountOut, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                          END) AS SummOut
                     
                               FROM (
                                     -- 1.1. Остатки кол-во
                                     SELECT -1 AS MovementId
                                           , 0 AS MovementItemId
                                           , tmpMI_Count.ContainerId
                                           , tmpMI_Count.LocationId
                                           , tmpMI_Count.GoodsId
                                           , tmpMI_Count.PartionId
                                           , 0     AS ContainerId_Analyzer
                                           , TRUE  AS isActive

                                           , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total)                                   AS AmountStart
                                           , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) + SUM (tmpMI_Count.Amount_Period) AS AmountEnd
                                           , 0 AS AmountIn
                                           , 0 AS AmountOut
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
                                           , tmpMI_Count.MovementItemId
                                           , tmpMI_Count.ContainerId
                                           , tmpMI_Count.LocationId
                                           , tmpMI_Count.GoodsId
                                           , tmpMI_Count.PartionId
                                           , tmpMI_Count.ContainerId_Analyzer
                                           , tmpMI_Count.isActive

                                           , 0 AS AmountStart
                                           , 0 AS AmountEnd
                                           , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN      tmpMI_Count.Amount_Period ELSE 0 END AS AmountIn
                                           , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN -1 * tmpMI_Count.Amount_Period ELSE 0 END AS AmountOut
                                     FROM tmpMI_Count
                                     WHERE tmpMI_Count.Amount_Period <> 0
                                     ) AS tmpMIContainer_all
                                     LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_all.PartionId
                               WHERE (Object_PartionGoods.GoodsSizeId = inGoodsSizeId OR inGoodsSizeId = 0)
                               GROUP BY tmpMIContainer_all.MovementId
                                      , tmpMIContainer_all.MovementItemId
                                      , tmpMIContainer_all.LocationId
                                      , tmpMIContainer_all.GoodsId
                                      , tmpMIContainer_all.PartionId
                                      , tmpMIContainer_all.ContainerId_Analyzer
                                      , tmpMIContainer_all.isActive
  
                                      , CASE WHEN inisGoodsSize = TRUE THEN Object_PartionGoods.GoodsSizeId ELSE 0 END 
                                      , Object_PartionGoods.MeasureId
                                      , Object_PartionGoods.GoodsGroupId
                                      , Object_PartionGoods.CompositionId
                                      , Object_PartionGoods.CompositionGroupId
                                      , Object_PartionGoods.GoodsInfoId
                                      , Object_PartionGoods.LineFabricaId 
                                      , Object_PartionGoods.LabelId
                                      , Object_PartionGoods.JuridicalId
                                      , Object_PartionGoods.CurrencyId
                                      , Object_PartionGoods.PeriodYear
                                      , COALESCE (Object_PartionGoods.CountForPrice, 1) 
                              )

   -- РЕЗУЛЬТАТ
   SELECT Movement.Id                            AS MovementId
        , Movement.InvNumber
        , Movement.OperDate
        
        , MovementDesc.ItemName      :: TVarChar AS MovementDescName

        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN NULL ELSE tmpMIContainer_group.isActive END :: Boolean AS isActive
        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN TRUE ELSE FALSE END :: Boolean AS isRemains
     
        --, ObjectDesc.ItemName            AS LocationDescName
        , Object_Location.ObjectCode     AS LocationCode
        , Object_Location.ValueData      AS LocationName

        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName

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

        , CAST (CASE WHEN Movement.DescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpMIContainer_group.MovementId = -1 AND */tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                     /*WHEN tmpMIContainer_group.MovementId = -2 AND tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd*/
                     WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummIn / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummOut / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS Price

        , CAST (tmpMIContainer_group.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpMIContainer_group.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpMIContainer_group.AmountOut AS TFloat)   AS AmountOut
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
        --, CASE WHEN  Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MF_CurrencyValue.ValueData ELSE MIFloat_CurrencyValue.ValueData END ::TFloat AS CurrencyValue
        --, CASE WHEN  Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MF_ParValue.ValueData      ELSE MIFloat_ParValue.ValueData      END ::TFloat AS ParValue
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

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
       
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpMIContainer_group.LocationId
        
        LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_group.PartionId

        LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpMIContainer_group.GoodsGroupId
        LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpMIContainer_group.MeasureId
        LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpMIContainer_group.CompositionId
        LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpMIContainer_group.CompositionGroupId
        LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpMIContainer_group.GoodsInfoId
        LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpMIContainer_group.LineFabricaId 
        LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpMIContainer_group.LabelId
        LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpMIContainer_group.GoodsSizeId
        LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = tmpMIContainer_group.JuridicalId
        LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpMIContainer_group.CurrencyId

        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMIContainer_group.GoodsId
                              AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()



        LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= inStartDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= tmpMIContainer_group.CurrencyId) AS tmpCurrency_Start ON 1=1
        LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= inEndDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= tmpMIContainer_group.CurrencyId) AS tmpCurrency_End ON 1=1
             
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.17                                        * add inUnitGroupId AND inGoodsGroupId
*/

-- тест
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.01.2017', inEndDate:= '01.01.2017', inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 1826, inIsPartner:= FALSE, inSession:= zfCalc_UserAdmin());
