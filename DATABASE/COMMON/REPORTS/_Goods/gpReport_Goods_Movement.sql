-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_Goods_Movement (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_Movement (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
 --   IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (TradeMarkName TVarChar
              , GoodsGroupName TVarChar
              , GoodsId Integer, GoodsName TVarChar
              , JuridicalId Integer, JuridicalName TVarChar
              , PartnerId Integer, PartnerName TVarChar
              , PaidKindName TVarChar
              , AmountSale_Summ TFloat, AmountSale_CountWeight TFloat , AmountSale_CountSh TFloat
              , AmountReturn_Summ TFloat, AmountReturn_CountWeight TFloat , AmountReturn_CountSh TFloat 
              )   
AS
$BODY$
BEGIN

    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
   
    IF inGoodsGroupId <> 0 
    THEN 
       INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId
          FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
       INSERT INTO _tmpGoods (GoodsId)
          SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
   END IF;

    RETURN QUERY

    SELECT Object_TradeMark.ValueData  AS TradeMarkName
         , Object_GoodsGroup.ValueData AS GoodsGroupName 
         , AllSale.GoodsId AS GoodsId
         , Object_Goods.ValueData AS GoodsName

         , Object_Juridical.Id          AS JuridicalId
         , Object_Juridical.ValueData   AS JuridicalName

         , Object_Partner.Id          AS PartnerId
         , Object_Partner.ValueData   AS PartnerName

         , Object_PaidKind.ValueData AS PaidKindName

         , CAST (SUM(AllSale.AmountSale_Summ) AS TFloat) AS AmountSale_Summ
         , CAST (SUM(AllSale.AmountSale_Count * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS AmountSale_CountWeight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.AmountSale_Count else 0 end) AS TFloat) AS AmountSale_CountSh 

         , CAST (SUM(AllSale.AmountReturn_Summ) AS TFloat) AS AmountReturn_Summ
         , CAST (SUM(AllSale.AmountReturn_Count * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS AmountReturn_CountWeight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.AmountReturn_Count else 0 end) AS TFloat) AS AmountReturn_CountSh 

    FROM (
           SELECT AllContainer.MovementDescId
            , max(AllContainer.ContainerId) AS ContainerId 
            , AllContainer.MovementId
            , AllContainer.MovementItemId
            
            , AllContainer.GoodsId

            , sum(AllContainer.AmountSale_Summ)  AS AmountSale_Summ
            , sum(AllContainer.AmountSale_Count) AS AmountSale_Count

            , sum(AllContainer.AmountReturn_Summ)  AS AmountReturn_Summ
            , sum(AllContainer.AmountReturn_Count) AS AmountReturn_Count

           FROM (
                 SELECT Movement.DescId AS MovementDescId
                      , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END AS ContainerId
                      , Movement.Id AS MovementId
                      , MIReport.MovementItemId AS MovementItemId
                      
                      , MovementItem.objectId AS GoodsId

                      , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN (sum(CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN MIReport.Amount ELSE MIReport.Amount*(-1) END)) ELSE 0 END AS AmountSale_Summ
                      , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN (sum(CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN MIReport.Amount ELSE MIReport.Amount*(-1) END)) ELSE 0 END AS AmountReturn_Summ

                      , 0 AS  AmountSale_Count
                      , 0 AS  AmountReturn_Count
                      
                 FROM Movement
                   JOIN MovementItemReport AS MIReport ON MIReport.MovementId = Movement.Id

                   JOIN ReportContainerLink ON  ReportContainerLink.ReportContainerId = MIReport.ReportContainerId 

                   JOIN (SELECT Container.Id AS ContainerId
                              , ContainerLO_ProfitLoss.ObjectId AS ProfitLossId
                         FROM Container  
                           JOIN ContainerLinkObject AS ContainerLO_ProfitLoss 
                                                    ON ContainerLO_ProfitLoss.ContainerId = Container.Id
                                                   AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                   AND ContainerLO_ProfitLoss.ObjectId in ( zc_Enum_ProfitLoss_10101(), zc_Enum_ProfitLoss_10102() -- Сумма реализации + Продукция OR Ирна
                                                                                          , zc_Enum_ProfitLoss_10201(), zc_Enum_ProfitLoss_10202() -- Скидка по акциям + Продукция OR Ирна
                                                                                          , zc_Enum_ProfitLoss_10301(), zc_Enum_ProfitLoss_10302()) -- Скидка дополнительная + Продукция OR Ирна
                         WHERE Container.ObjectId = zc_Enum_Account_100301() -- "прибыль текущего периода"
                         ) AS tmpContainer ON tmpContainer.ContainerId = ReportContainerLink.ContainerId

                   JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                    AND MovementItem.descid =  zc_MI_MASter()
                                    AND MovementItem.objectId in (SELECT _tmpGoods.GoodsId FROM _tmpGoods)
           
                 WHERE Movement.DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn())
                   AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
           
                 GROUP BY Movement.DescId, MovementItem.objectId, Movement.Id, MIReport.MovementItemId
                        , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END 
    
              UNION ALL    
                 SELECT Movement.DescId AS MovementDescId
                      , 0 AS ContainerId 
                      , Movement.Id AS MovementId
                      , MIContainer.MovementItemId AS MovementItemId
                      
                      , Container.ObjectId AS GoodsId     
  
                      , 0 AS AmountSale_Summ
                      , 0 AS AmountReturn_Summ

                      , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN sum(MIContainer. Amount) ELSE 0 END AS AmountSale_Count
                      , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN sum(MIContainer. Amount) ELSE 0 END AS AmountReturn_Count
    
                 FROM  Movement 
                   JOIN MovementItemContainer AS MIContainer 
                                              ON MIContainer.MovementId = Movement.Id
                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                
                   JOIN Container ON Container.Id = MIContainer.ContainerId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.ObjectId in (SELECT _tmpGoods.GoodsId FROM _tmpGoods)

                 WHERE Movement.DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn())  
    
                 GROUP BY Movement.DescId
                        , Movement.Id
                        , MIContainer.MovementItemId 
                        , Container.ObjectId 
               ) AS AllContainer

          GROUP BY AllContainer.GoodsId, AllContainer.MovementItemId, AllContainer.MovementId, AllContainer.MovementDescId
         ) AS AllSale
   
         JOIN object AS object_Goods on object_Goods.Id = AllSale.GoodsId

         LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                              ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                             AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()

         LEFT JOIN Object AS Object_TradeMark 
                          ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                         AND Object_TradeMark.DescId = zc_Object_TradeMark()

         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
   
         LEFT JOIN Object AS Object_GoodsGroup 
                          ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                         AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup()

         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

         LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                      ON MovementLinkObject_Partner.MovementId = AllSale.MovementId
                                     AND MovementLinkObject_Partner.DescId = CASE WHEN AllSale.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
            
         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                       ON ContainerLinkObject_Juridical.ContainerId = AllSale.ContainerId
                                      AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContainerLinkObject_Juridical.ObjectId 

         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                       ON ContainerLinkObject_PaidKind.ContainerId = AllSale.ContainerId
                                      AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ContainerLinkObject_PaidKind.ObjectId 
                                    
       GROUP BY
           Object_TradeMark.ValueData
         , Object_GoodsGroup.ValueData
         , Object_Goods.ObjectCode
         , AllSale.GoodsId 
         , Object_Goods.ValueData
         , Object_Partner.Id
         , Object_Partner.ValueData   
         , Object_Juridical.Id
         , Object_Juridical.ValueData  
         , Object_PaidKind.ValueData  

       ORDER BY Object_Partner.ValueData
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Goods_Movement (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.14         *

*/

--select * from gpReport_Goods_Movement(inStartDate := ('15.12.2013')::TDateTime , inEndDate := ('16.12.2013')::TDateTime , inGoodsGroupId := 1952 ,  inSession := '5');
--select * from gpReport_GoodsMI_byMovement(inStartDate := ('15.12.2013')::TDateTime , inEndDate := ('16.12.2013')::TDateTime , inDescId := 5 , inGoodsGroupId := 0 ,  inSession := '5');