-- Function: gpReport_GoodsMI_byMovementDif ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovementDif (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inJuridicalId  Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime

             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar

             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , TradeMarkName TVarChar
            
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Summ TFloat
             , Price TFloat
              )   
AS
$BODY$
BEGIN

  /*IF COALESCE (inJuridicalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицов!!!';
   END IF;*/
   
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
    
    -- ограничиваем по Юр.лицу
    WITH tmpMovement AS (SELECT Movement.Id AS MovementId
                              , Movement.InvNumber
                              , Movement.OperDate 
                         FROM ContainerLinkObject AS ContainerLO_Juridical
                              JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = ContainerLO_Juridical.ContainerId
                                                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate           -- AND MIContainer.OperDate BETWEEN '01.12.2013' and '31.12.2013'    --
                              JOIN Movement ON Movement.Id = MIContainer.MovementId
                                           AND Movement.DescId  = inDescId 
                         WHERE ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                           AND (ContainerLO_Juridical.ObjectId = inJuridicalId or inJuridicalId=0)
                         GROUP BY Movement.Id 
                                , Movement.InvNumber
                                , Movement.OperDate    
                         )

      SELECT AllGroupMovement.InvNumber
           , AllGroupMovement.OperDate
           , AllGroupMovement.JuridicalCode
           , AllGroupMovement.JuridicalName
           , AllGroupMovement.PartnerCode
           , AllGroupMovement.PartnerName
           , AllGroupMovement.PaidKindName
           , AllGroupMovement.GoodsGroupName 
           , AllGroupMovement.GoodsCode
           , AllGroupMovement.GoodsName
           , AllGroupMovement.GoodsKindName
           , AllGroupMovement.TradeMarkName
           , AllGroupMovement.Amount_Weight  AS Amount_Weight
           , AllGroupMovement.Amount_Sh AS Amount_Sh
           , AllGroupMovement.AmountPartner_Weight  AS AmountPartner_Weight
           , AllGroupMovement.AmountPartner_Sh :: TFloat AS AmountPartner_Sh
           , AllGroupMovement.Summ :: TFloat AS Summ
           , AllGroupMovement.Price
           /*, CAST (CASE WHEN (AllGroupMovement.Amount_Sh <> AllGroupMovement.AmountPartner_Sh 
                        OR AllGroupMovement.Amount_Weight <> AllGroupMovement.AmountPartner_Weight) 
                      THEN TRUE ELSE FALSE END AS Boolean) AS Difference*/
     From (SELECT tmpOperationGroup.InvNumber
         , tmpOperationGroup.OperDate

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         , Object_PaidKind.ValueData   AS PaidKindName
          
         , Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , Sum (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , Sum (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh
         , Sum (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , Sum (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat AS AmountPartner_Sh
         , Sum (tmpOperationGroup.Summ) :: TFloat AS Summ

         , MIFloat_Price.ValueData AS Price
         
     FROM (SELECT tmpOperation.MovementId
                , tmpOperation.InvNumber
                , tmpOperation.OperDate
                , tmpOperation.MovementItemId
                , MAX(tmpOperation.ContainerId) AS ContainerId
                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , ABS (SUM (tmpOperation.Amount))  AS Amount
                , SUM (tmpOperation.AmountPartner) AS AmountPartner
                , ABS (SUM (tmpOperation.Summ))    AS Summ
           FROM (SELECT tmpMovement.MovementId AS MovementId
                      , tmpMovement.InvNumber
                      , tmpMovement.OperDate
                      , MovementItem.Id AS MovementItemId
                      , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END AS ContainerId
                      , MovementItem.ObjectId AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , 0 AS  Amount
                      , 0 AS  AmountPartner
                      , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN MIReport.Amount ELSE -1 * MIReport.Amount END) AS Summ
                 FROM tmpMovement
                      JOIN MovementItemReport AS MIReport ON MIReport.MovementId = tmpMovement.MovementId

                      JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = MIReport.ReportContainerId--ReportContainerLink.ContainerId = tmpListContainer.ContainerId
                      
                      JOIN (SELECT Container.Id AS ContainerId
                            FROM ContainerLinkObject AS ContainerLO_ProfitLoss
                                 JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                            WHERE ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                              AND ContainerLO_ProfitLoss.ObjectId in ( zc_Enum_ProfitLoss_10101(), zc_Enum_ProfitLoss_10102() -- Сумма реализации: Продукция + Ирна
                                                                     , zc_Enum_ProfitLoss_10201(), zc_Enum_ProfitLoss_10202() -- Скидка по акциям: Продукция + Ирна
                                                                     , zc_Enum_ProfitLoss_10301(), zc_Enum_ProfitLoss_10302() -- Скидка дополнительная: Продукция + Ирна
                                                                     , zc_Enum_ProfitLoss_10701(), zc_Enum_ProfitLoss_10702() -- Сумма возвратов: Продукция + Ирна
                                                                      )
                           ) AS tmpListContainer ON  tmpListContainer.ContainerId = ReportContainerLink.ContainerId 
                      

                      JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                       AND MovementItem.DescId =  zc_MI_Master()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                 --WHERE  MIReport.OperDate BETWEEN inStartDate AND inEndDate
                 
                 GROUP BY tmpMovement.MovementId
                        , tmpMovement.InvNumber
                        , tmpMovement.OperDate
                        , MovementItem.Id
                        , MovementItem.ObjectId
                        , MILinkObject_GoodsKind.ObjectId
                        , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END
                UNION ALL    
                 SELECT tmpMovement.MovementId AS MovementId
                      , tmpMovement.InvNumber
                      , tmpMovement.OperDate
                      , MIContainer.MovementItemId AS MovementItemId
                      , 0 AS ContainerId 
                      , Container.ObjectId AS GoodsId       
                      , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , SUM (MIContainer.Amount)                            AS Amount
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                      , 0 AS Summ
                 FROM tmpMovement
                      Join MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId

                      JOIN Container ON Container.Id = MIContainer.ContainerId
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId

                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 WHERE MIContainer.DescId = zc_MIContainer_Count()
                 GROUP BY tmpMovement.MovementId
                        , tmpMovement.InvNumber
                        , tmpMovement.OperDate
                        , MIContainer.MovementItemId
                        , Container.ObjectId 
                        , ContainerLO_GoodsKind.ObjectId
               ) AS tmpOperation
           GROUP BY tmpOperation.MovementId
                  , tmpOperation.InvNumber
                  , tmpOperation.OperDate
                  , tmpOperation.MovementItemId
                  , tmpOperation.GoodsId
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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = tmpOperationGroup.MovementId
                                      AND MovementLinkObject_Partner.DescId = CASE WHEN inDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                        ON ContainerLinkObject_Juridical.ContainerId = tmpOperationGroup.ContainerId
                                       AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContainerLinkObject_Juridical.ObjectId 
         
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                        ON ContainerLinkObject_PaidKind.ContainerId = tmpOperationGroup.ContainerId
                                       AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ContainerLinkObject_PaidKind.ObjectId 

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = tmpOperationGroup.MovementItemId
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
          GROUP BY tmpOperationGroup.InvNumber
                 , tmpOperationGroup.OperDate
                 , Object_Juridical.ObjectCode
                 , Object_Juridical.ValueData
                 , Object_Partner.ObjectCode
                 , Object_Partner.ValueData 
                 , Object_PaidKind.ValueData
                 , Object_GoodsGroup.ValueData
                 , Object_Goods.ObjectCode
                 , Object_Goods.ValueData
                 , Object_GoodsKind.ValueData 
                 , Object_TradeMark.ValueData
                 , MIFloat_Price.ValueData
          ) AS AllGroupMovement 
          
          WHERE AllGroupMovement.Amount_Sh <> AllGroupMovement.AmountPartner_Sh 
             OR AllGroupMovement.Amount_Weight <> AllGroupMovement.AmountPartner_Weight
         
   ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.14         *

*/

-- тест
--SELECT * FROM gpReport_GoodsMI_byMovementDif (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013',  inDescId:= 5, inJuridicalId:= 15616, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());


--select * from gpReport_GoodsMI_byMovementDif(inStartDate := '01.01.2013'::TDateTime, inEndDate := '12.12.2013'::TDateTime, inDescId := 5 , inJuridicalId := 15594 , inGoodsGroupId := 1983 ,  inSession := zfCalc_UserAdmin());
