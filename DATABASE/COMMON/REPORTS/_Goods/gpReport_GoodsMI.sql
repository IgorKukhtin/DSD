-- Function: gpReport_GoodsMI ()

DROP FUNCTION IF EXISTS gpReport_SaleGoods (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleGoods (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Summ TFloat
              )   
AS
$BODY$
BEGIN
    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


    -- Результат
    RETURN QUERY
    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName
         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh
         , (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat AS AmountPartner_Sh
         , tmpOperationGroup.Summ :: TFloat AS Summ
     FROM (SELECT tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , ABS (SUM (tmpOperation.Amount))  AS Amount
                , SUM (tmpOperation.AmountPartner) AS AmountPartner
                , ABS (SUM (tmpOperation.Summ))    AS Summ
           FROM (SELECT MovementItem.ObjectId AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , 0 AS  Amount
                      , 0 AS  AmountPartner
                      , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN MIReport.Amount ELSE -1 * MIReport.Amount END) AS Summ
                 FROM (SELECT Container.Id AS ContainerId
                       FROM ContainerLinkObject AS ContainerLO_ProfitLoss
                            JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                          AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                       WHERE ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                         AND ContainerLO_ProfitLoss.ObjectId in ( zc_Enum_ProfitLoss_10101(), zc_Enum_ProfitLoss_10102() -- Сумма реализации: Продукция + Ирна
                                                                , zc_Enum_ProfitLoss_10201(), zc_Enum_ProfitLoss_10202() -- Скидка по акциям: Продукция + Ирна
                                                                , zc_Enum_ProfitLoss_10301(), zc_Enum_ProfitLoss_10302() -- Скидка дополнительная: Продукция + Ирна
                                                                , zc_Enum_ProfitLoss_10701(), zc_Enum_ProfitLoss_10702() -- Сумма возвратов: Продукция + Ирна
                                                                 )
                     ) AS tmpListContainer
                      JOIN ReportContainerLink ON ReportContainerLink.ContainerId = tmpListContainer.ContainerId

                      JOIN MovementItemReport AS MIReport
                                              ON MIReport.ReportContainerId = ReportContainerLink.ReportContainerId
                                             AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                      JOIN Movement ON Movement.Id = MIReport.MovementId
                                   AND Movement.DescId = inDescId

                      JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                       AND MovementItem.DescId =  zc_MI_Master()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 GROUP BY MovementItem.ObjectId
                        , MILinkObject_GoodsKind.ObjectId
                UNION ALL    
                 SELECT Container.ObjectId AS GoodsId       
                      , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , SUM (MIContainer.Amount)                            AS Amount
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                      , 0 AS Summ
                 FROM MovementItemContainer AS MIContainer 
                      JOIN Movement ON Movement.Id = MIContainer.MovementId
                                   AND Movement.DescId = inDescId 
                      JOIN Container ON Container.Id = MIContainer.ContainerId
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId

                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                   AND MIContainer.DescId = zc_MIContainer_Count()
                 GROUP BY Container.ObjectId 
                        , ContainerLO_GoodsKind.ObjectId
               ) AS tmpOperation
           GROUP BY tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId
          ) AS tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
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

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
   ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.14                                        * All
 22.01.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013',  inDescId:= 5, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
