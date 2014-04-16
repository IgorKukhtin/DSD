--select * from gpReport_GoodsMI(inStartDate := ('01.12.2013')::TDateTime , inEndDate := ('05.12.2013 23:59:00')::TDateTime , inDescId := 5 , inGoodsGroupId := 0 ,  inSession := '5');


-- Function: gpReport_GoodsMI ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  -- sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inUnitId  Integer   , 
    IN inSession      TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , SummChangePercent TFloat
             , SummPartner TFloat
              )   
AS
$BODY$
BEGIN
    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    IF inUnitId <> 0 
    THEN 
        INSERT INTO _tmpUnit (UnitId)
           SELECT inUnitId;
    ELSE 
        INSERT INTO _tmpUnit (UnitId)
           SELECT Id FROM Object WHERE DescId = zc_Object_Unit();    
    END IF;


    -- Результат
    RETURN QUERY
    SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName
         , Object_TradeMark.ValueData             AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat                                AS Amount_Sh

         , (tmpOperationGroup.AmountChangePercent * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountChangePercent_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountChangePercent ELSE 0 END) :: TFloat                                AS AmountChangePercent_Sh
         
         , (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat                                AS AmountPartner_Sh
         , tmpOperationGroup.SummChangePercent :: TFloat              AS SummChangePercent
         , tmpOperationGroup.SummPartner :: TFloat                    AS SummPartner

     FROM (SELECT tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , SUM (tmpOperation.Amount)               AS Amount
                , SUM (tmpOperation.AmountPartner)        AS AmountPartner
                , SUM (tmpOperation.AmountChangePercent)  AS AmountChangePercent
                , SUM (tmpOperation.SummChangePercent)    AS SummChangePercent
                , SUM (tmpOperation.SummPartner)          AS SummPartner
           FROM (SELECT MovementItem.ObjectId AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , 0 AS  Amount
                      , 0 AS  AmountChangePercent
                      , 0 AS  AmountPartner
                      , 0 AS SummChangePercent
                      , SUM (MIReport.Amount * CASE WHEN (ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                                      OR (ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                                         THEN -1
                                                    ELSE 1
                                               END) AS SummPartner
                 FROM MovementItemReport AS MIReport
                      JOIN Movement ON Movement.Id = MIReport.MovementId
                                   AND Movement.DescId = inDescId
                      JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId = (CASE WHEN inDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END)
                      JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                      
                      JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = MIReport.ReportContainerId
                      
                             JOIN (SELECT Container.Id AS ContainerId
                                   FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View) AS tmpProfitLoss
                                        JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                 ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                        JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                      AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                      AND Container.DescId = zc_Container_Summ()
                                  ) AS tmpListContainer ON  tmpListContainer.ContainerId = ReportContainerLink.ContainerId 

                      JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                       AND MovementItem.DescId =  zc_MI_Master()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            
                 WHERE  MIReport.OperDate BETWEEN inStartDate AND inEndDate
                 GROUP BY MovementItem.ObjectId
                        , MILinkObject_GoodsKind.ObjectId
                UNION ALL    
                 SELECT Container.ObjectId AS GoodsId       
                      , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , SUM (MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount
                      , SUM (CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END) AS AmountChangePercent
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                      , SUM (CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                                            -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                       THEN CASE WHEN MovementFloat_ChangePercent.ValueData < 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                 WHEN MovementFloat_ChangePercent.ValueData > 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                 ELSE CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2))
                                            END
                                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                                  ELSE CASE WHEN MovementFloat_ChangePercent.ValueData < 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                            WHEN MovementFloat_ChangePercent.ValueData > 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                            ELSE CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                       END
                                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                                       -- ...
                             END) AS SummChangePercent
                      , 0 AS SummPartner
                            
                 FROM MovementItemContainer AS MIContainer 
                      INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                         AND Movement.DescId = inDescId 
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                   AND MovementLinkObject_From.DescId = CASE WHEN inDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                      INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId

                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()

                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                              ON MovementFloat_VATPercent.MovementId =  MIContainer.MovementId
                                             AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                      LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                              ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                             AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                  ON MIFloat_AmountChangePercent.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                       
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
ALTER FUNCTION gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummChangePercent. AmountChangePercent
 04.02.14         * 
 01.02.14                                        * All
 22.01.14         *
*/


-- тест
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= 6, inGoodsGroupId:= 0, inUnitId:= 0, inSession:= zfCalc_UserAdmin());