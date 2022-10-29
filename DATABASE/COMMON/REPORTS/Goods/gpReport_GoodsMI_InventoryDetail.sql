-- Function: gpReport_GoodsMI_InventoryDetail ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_InventoryDetail (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_InventoryDetail (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_InventoryDetail (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   ,
    IN inGoodsGroupId Integer   ,  
    IN inPriceListId  Integer   , 
    IN inisPartion    Boolean   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , AmountIn TFloat, AmountIn_Weight TFloat, AmountIn_Sh TFloat
             , AmountOut TFloat, AmountOut_Weight TFloat, AmountOut_Sh TFloat 
             , Amount TFloat, Amount_Weight TFloat, Amount_Sh TFloat
             , Summ TFloat
             , SummIn_zavod TFloat, SummIn_branch TFloat, SummIn_60000 TFloat
             , SummOut_zavod TFloat, SummOut_branch TFloat, SummOut_60000 TFloat
             , Summ_zavod TFloat, Summ_branch TFloat, Summ_60000 TFloat
             , PriceIn_zavod TFloat, PriceIn_branch TFloat
             , PriceOut_zavod TFloat, PriceOut_branch TFloat
             , Price_zavod TFloat, Price_branch TFloat
             , SummIn_RePrice TFloat, SummOut_RePrice TFloat
             , SummIn_RePrice_60000 TFloat, SummOut_RePrice_60000 TFloat 
             , Summ_pr TFloat
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_GoodsMI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!определяется!!!
     vbIsGroup:= (inSession = '');


     -- Бурмага М.Ф. + Гармаш С.М. + Горб Т.Г.
     IF vbUserId IN (5308086, 651642, 439887)
        AND inUnitId NOT IN (8458) -- Склад База ГП
        AND inUnitId NOT IN (8451) -- ЦЕХ упаковки
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> Нет прав формировать отчет для подразделения <%>'
                       , lfGet_Object_ValueData_sh (vbUserId)
                       , CASE WHEN inUnitId = 0 THEN '' ELSE lfGet_Object_ValueData_sh (inUnitId) END
                        ;
     END IF;


     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
          _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
          UNION
           SELECT Object.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )
    , _tmpUnit AS
          (-- подразделение
           SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
           WHERE COALESCE (inUnitId,0) <> 0
          UNION
           SELECT Object.Id AS UnitId FROM Object WHERE Object.DescId = zc_Object_Unit() AND COALESCE (inUnitId,0) = 0
          ) 

     -- цены по прайсу
    , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                          , lfObjectHistory_PriceListItem.GoodsKindId
                          , lfObjectHistory_PriceListItem.ValuePrice AS Price
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inEndDate) AS lfObjectHistory_PriceListItem
                     WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                    )


   -- Результат
    SELECT Movement.Id                                AS MovementId
         , Movement.InvNumber
         , Movement.OperDate
         , Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , tmpOperationGroup.AmountIn        :: TFloat AS AmountIn
         , tmpOperationGroup.AmountIn_Weight :: TFloat AS AmountIn_Weight
         , tmpOperationGroup.AmountIn_Sh     :: TFloat AS AmountIn_Sh

         , tmpOperationGroup.AmountOut        :: TFloat AS AmountOut
         , tmpOperationGroup.AmountOut_Weight :: TFloat AS AmountOut_Weight
         , tmpOperationGroup.AmountOut_Sh     :: TFloat AS AmountOut_Sh

         , (tmpOperationGroup.AmountIn        - tmpOperationGroup.AmountOut)        :: TFloat AS Amount
         , (tmpOperationGroup.AmountIn_Weight - tmpOperationGroup.AmountOut_Weight) :: TFloat AS Amount_Weight
         , (tmpOperationGroup.AmountIn_Sh     - tmpOperationGroup.AmountOut_Sh)     :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ       :: TFloat

         , tmpOperationGroup.SummIn_zavod  :: TFloat AS SummIn_zavod
         , tmpOperationGroup.SummIn_branch :: TFloat AS SummIn_branch
         , tmpOperationGroup.SummIn_60000  :: TFloat AS SummIn_60000

         , tmpOperationGroup.SummOut_zavod  :: TFloat AS SummOut_zavod
         , tmpOperationGroup.SummOut_branch :: TFloat AS SummOut_branch
         , tmpOperationGroup.SummOut_60000  :: TFloat AS SummOut_60000

         , (tmpOperationGroup.SummIn_zavod  - tmpOperationGroup.SummOut_zavod)  :: TFloat AS Summ_zavod
         , (tmpOperationGroup.SummIn_branch - tmpOperationGroup.SummOut_branch) :: TFloat AS Summ_branch
         , (tmpOperationGroup.SummIn_60000  - tmpOperationGroup.SummOut_60000)  :: TFloat AS Summ_60000

         , CASE WHEN tmpOperationGroup.AmountIn <> 0 THEN tmpOperationGroup.SummIn_zavod  / tmpOperationGroup.AmountIn ELSE 0 END :: TFloat AS PriceIn_zavod
         , CASE WHEN tmpOperationGroup.AmountIn <> 0 THEN tmpOperationGroup.SummIn_branch / tmpOperationGroup.AmountIn ELSE 0 END :: TFloat AS PriceIn_branch
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_zavod  / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_zavod
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_branch / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_branch
         , CASE WHEN (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) <> 0 THEN (tmpOperationGroup.SummIn_zavod  - tmpOperationGroup.SummOut_zavod)  / (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) ELSE 0 END :: TFloat AS Price_zavod
         , CASE WHEN (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) <> 0 THEN (tmpOperationGroup.SummIn_branch - tmpOperationGroup.SummOut_branch) / (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) ELSE 0 END :: TFloat AS Price_branch

         , tmpOperationGroup.SummIn_RePrice        :: TFloat AS SummIn_RePrice
         , tmpOperationGroup.SummOut_RePrice       :: TFloat AS SummOut_RePrice
         , tmpOperationGroup.SummIn_RePrice_60000  :: TFloat AS SummIn_RePrice_60000
         , tmpOperationGroup.SummOut_RePrice_60000 :: TFloat AS SummOut_RePrice_60000     
         
         , (tmpOperationGroup.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) :: TFloat AS Summ_pr --     Сумма (-)убыль (+)эконом. ПРАЙС

     FROM (SELECT tmpContainer.UnitId
                , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END AS GoodsId
                , tmpContainer.GoodsKindId
                , CASE WHEN inisPartion = TRUE THEN CLO_PartionGoods.ObjectId ELSE 0 END AS PartionGoodsId
                , tmpContainer.MovementId

                , SUM (tmpContainer.Amount)     AS Amount
                , SUM (tmpContainer.AmountIn)   AS AmountIn
                , SUM (tmpContainer.AmountIn * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS AmountIn_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.AmountIn ELSE 0 END) AS AmountIn_sh

                , SUM (tmpContainer.AmountOut)  AS AmountOut
                , SUM (tmpContainer.AmountOut * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS AmountOut_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.AmountOut ELSE 0 END) AS AmountOut_sh

                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.Summ ELSE 0 END) AS Summ
                
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() THEN tmpContainer.SummIn  ELSE 0 END) AS SummIn_zavod
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_zavod
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) AS SummIn_branch        -- zc_Enum_AccountGroup_60000 Прибыль будущих периодов
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_branch
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) AS SummIn_60000
                , SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_60000

                , SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) AS SummIn_RePrice
                , SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_RePrice
                , SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) AS SummIn_RePrice_60000
                , SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_RePrice_60000

           FROM (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                      , COALESCE (MIContainer.AnalyzerId, 0) AS AnalyzerId
                      , MIContainer.WhereObjectId_analyzer   AS UnitId
                      , MIContainer.ObjectId_Analyzer        AS GoodsId
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                      , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                      , CASE WHEN inisPartion = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId

                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END) AS AmountIn
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut 
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END)                                 AS Amount                                                     
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END) AS SummIn
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS SummOut
                      , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN MIContainer.Amount ELSE 0 END) AS Summ
                 FROM _tmpUnit
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND COALESCE (MIContainer.AccountId,0) <> zc_Enum_Account_100301() -- Прибыль текущего периода
                                                      AND MIContainer.MovementDescId = zc_Movement_Inventory()
                 GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                        , MIContainer.AnalyzerId
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectId_Analyzer
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                        , COALESCE (MIContainer.AccountId, 0)
                        , CASE WHEN inisPartion = TRUE THEN MIContainer.MovementId ELSE 0 END 
               ) AS tmpContainer
               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId
               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                             ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
               LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
           GROUP BY tmpContainer.UnitId
                  , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END
                  , tmpContainer.GoodsKindId
                  , CASE WHEN inisPartion = TRUE THEN CLO_PartionGoods.ObjectId ELSE 0 END
                  , tmpContainer.MovementId

          ) AS tmpOperationGroup

 
          LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.UnitId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull() 

          -- привязываем цены по прайсу 2 раза по виду товара и без
          LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                               ON tmpPricePR_Kind.GoodsId = Object_Goods.Id
                              AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (tmpOperationGroup.GoodsKindId,0)

          LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = Object_Goods.Id
                              AND tmpPricePR.GoodsKindId IS NULL

  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         * 
 30.11.21         * add inisPartion
 16.08.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_InventoryDetail (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inUnitId:= 8417, inGoodsGroupId:= 0, inisPartion:= FALSE, inSession:= zfCalc_UserAdmin()); -- Склад ГП ф.Одесса
-- SELECT * FROM gpReport_GoodsMI_InventoryDetail (inStartDate:= '12.11.2021', inEndDate:= '30.11.2021', inUnitId:= 8444, inGoodsGroupId:= 0, inisPartion:= false, inSession:= zfCalc_UserAdmin()) --8417
-- SELECT * FROM gpReport_GoodsMI_InventoryDetail (inStartDate:= '12.11.2021', inEndDate:= '30.11.2021', inUnitId:= 8444, inGoodsGroupId:= 0, inPriceListId := 0, inisPartion:= false, inSession:= zfCalc_UserAdmin()) --8417
