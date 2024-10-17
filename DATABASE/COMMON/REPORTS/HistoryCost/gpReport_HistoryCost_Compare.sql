-- Function: gpReport_HistoryCost_Compare()

/*
  Новый отчет - сравнение цен с/с за 2 периода - табл HistoryCost - колонка Price, 4 входящих параметра месяц1 и месяц2 + товар (если нет, тогда по всем) 
  + по товару да/нет (тогда группируется GoodsId + GoodsKindId, иначе по ContainerId), 
  
   из первого периода всегда sum (HistoryCost.Price) с группировкой GoodsId + GoodsKindId или GoodsId + GoodsKindId 
   + zc_ContainerLinkObject_Unit + zc_ContainerLinkObject_InfoMoneyDetail,
    в результате у нас Товар + вид+ ContainerId (если нет галки да/нет) + UnitId + InfoMoneyDetailId - из второго периода
     и поиск цены для Товар + вид + UnitId + InfoMoneyDetailId из первого периода

*/

DROP FUNCTION IF EXISTS gpReport_HistoryCost_Compare (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HistoryCost_Compare (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCost_Compare (
    IN inMonth1             TDateTime , --   прошлый период
    IN inMonth2             TDateTime , --   текущий период
    IN inUnitId             Integer,    --
    IN inGoodId             Integer,    -- 
    IN inisGoods            Boolean,    -- 
    IN inSession            TVarChar   -- пользователь
)
RETURNS TABLE (ContainerId Integer
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar 
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyDetailName TVarChar
             , PartionGoods TVarChar
             , Price_1        TFloat   --цена себестоимость период 1
             , Price_2        TFloat   --цена себестоимость период 2    
             , Price_diff     TFloat   --
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStartDate1 TDateTime;
  DECLARE vbStartDate2 TDateTime;
  DECLARE vbEndDate1 TDateTime;
  DECLARE vbEndDate2 TDateTime;
          
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

       
    vbStartDate1 := DATE_TRUNC ('MONTH', inMonth1);
    vbEndDate1   := vbStartDate1 + INTERVAL '1 Month' - INTERVAL '1 Day';  
    vbStartDate2 := DATE_TRUNC ('MONTH', inMonth2);
    vbEndDate2   := vbStartDate2 + INTERVAL '1 Month' - INTERVAL '1 Day';
 
    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (vbStartDate1, vbEndDate1, NULL, NULL, NULL, vbUserId);
  

    RETURN QUERY
    WITH
        --первый период    Container
        tmpHistoryCost1 AS (SELECT SUM (HistoryCost.Price)      AS Price   
                                 , Container_count.Id           AS ContainerId_count
                                 , CLO_InfoMoneyDetail.ObjectId AS InfoMoneyDetailId
                                 , CLO_Unit.ObjectId            AS UnitId
                                --  , HistoryCost.ContainerId
                                 , Container_count.ObjectId     AS GoodsId
                                 , CLO_GoodsKind.ObjectId       AS GoodsKindId
                            FROM HistoryCost 
                                JOIN Container AS Container_sum ON Container_sum.Id = HistoryCost.containerId
                                                               AND Container_sum.DescId = zc_Container_Summ()
                                JOIN Container AS Container_count ON Container_count.Id = Container_sum.ParentId 
                                                                 AND Container_count.DescId = zc_Container_Count()

                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container_count.Id
                                                             AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container_count.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                              ON CLO_InfoMoneyDetail.ContainerId = HistoryCost.containerId
                                                             AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = Container_count.Id
                                                             AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                            WHERE HistoryCost.StartDate <= vbEndDate1 
                              AND HistoryCost.EndDate >= vbStartDate1
                              -- без Товар в пути
                              AND CLO_Account.ObjectId IS NULL
                              AND (Container_count.ObjectId = inGoodId OR inGoodId = 0)
                              AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                            GROUP BY Container_count.Id
                                   , Container_count.ObjectId
                                  -- , HistoryCost.ContainerId
                                   , CLO_InfoMoneyDetail.ObjectId
                                   , CLO_Unit.ObjectId
                                   , CLO_GoodsKind.ObjectId 
                            )
  
      --второй переиод
      , tmpHistoryCost2 AS (SELECT SUM (HistoryCost.Price)      AS Price   
                                 , CLO_InfoMoneyDetail.ObjectId AS InfoMoneyDetailId
                                 , CLO_Unit.ObjectId            AS UnitId
                                 , Container_count.ObjectId     AS GoodsId
                                 , CLO_GoodsKind.ObjectId       AS GoodsKindId
                                 , CASE WHEN inisGoods = true THEN 0 ELSE HistoryCost.ContainerId END AS ContainerId 
                                 , ObjectCostLink_PartionGoods.ObjectId AS PartionGoodsId
                            FROM HistoryCost 
                                JOIN Container AS Container_sum ON Container_sum.Id = HistoryCost.containerId
                                                               AND Container_sum.DescId = zc_Container_Summ()
                                JOIN Container AS Container_count ON Container_count.Id = Container_sum.ParentId 
                                                                 AND Container_count.DescId = zc_Container_Count()

                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container_count.Id
                                                             AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container_count.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                              ON CLO_InfoMoneyDetail.ContainerId = HistoryCost.containerId
                                                             AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = Container_count.Id
                                                             AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS ObjectCostLink_PartionGoods
                                                              ON ObjectCostLink_PartionGoods.ContainerId = HistoryCost.containerId
                                                             AND ObjectCostLink_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                             AND inisGoods = FALSE
                            WHERE HistoryCost.StartDate <= vbEndDate2 
                              AND HistoryCost.EndDate >= vbStartDate2
                              -- без Товар в пути
                              AND CLO_Account.ObjectId IS NULL
                              AND (Container_count.ObjectId = inGoodId OR inGoodId = 0)
                              AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                            GROUP BY Container_count.ObjectId
                                   , CLO_InfoMoneyDetail.ObjectId
                                   , CLO_Unit.ObjectId
                                   , CLO_GoodsKind.ObjectId 
                                   , CASE WHEN inisGoods = true THEN 0 ELSE HistoryCost.ContainerId END 
                                   , ObjectCostLink_PartionGoods.ObjectId
                            )
  
      , tmpResult AS (SELECT tmpHistoryCost2.GoodsId
                           , COALESCE (tmpHistoryCost2.GoodsKindId,0) AS GoodsKindId
                           , tmpHistoryCost2.UnitId
                           , tmpHistoryCost2.InfoMoneyDetailId
                           , tmpHistoryCost2.ContainerId
                           , tmpHistoryCost2.PartionGoodsId
                           , tmpHistoryCost1.Price      AS Price_1
                           , tmpHistoryCost2.Price      AS Price_2
                      FROM tmpHistoryCost2
                          LEFT JOIN tmpHistoryCost1 ON tmpHistoryCost1.GoodsId = tmpHistoryCost2.GoodsId
                                              AND COALESCE (tmpHistoryCost1.GoodsKindId,0) = COALESCE (tmpHistoryCost2.GoodsKindId,0)
                                              AND tmpHistoryCost1.UnitId = tmpHistoryCost2.UnitId
                                              AND COALESCE (tmpHistoryCost1.InfoMoneyDetailId,0) = COALESCE (tmpHistoryCost2.InfoMoneyDetailId,0)
                      )
   --
   SELECT tmpResult.ContainerId          AS ContainerId
        , Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , Object_Goods.Id                AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , Object_Goods.ValueData         AS GoodsName
        , Object_GoodsKind.Id            AS GoodsKindId
        , Object_GoodsKind.ValueData     AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        
        , Object_Unit.Id                 AS UnitId
        , Object_Unit.ValueData          AS UnitName

        , Object_InfoMoneyDetail.ValueData AS InfoMoneyDetailName
        , Object_PartionGoods.ValueData ::TVarChar AS PartionGoods
        
        , tmpResult.Price_1 ::TFloat     AS Price_1
        , tmpResult.Price_2 ::TFloat     AS Price_2
        , (COALESCE (tmpResult.Price_2,0) - COALESCE (tmpResult.Price_1,0) ):: TFloat AS Price_diff 

   FROM tmpResult
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpResult.UnitId
        LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = tmpResult.InfoMoneyDetailId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpResult.PartionGoodsId
        
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure 
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.24         *
*/

-- тест
--SELECT * FROM gpReport_HistoryCost_Compare (inMonth1 := '01.08.2024' ::TDateTime, inMonth2 := '01.09.2024' ::TDateTime, inUnitId:= 428365, inGoodId := 0, inisGoods:= false, inSession := zfCalc_UserAdmin() )