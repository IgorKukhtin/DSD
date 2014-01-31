-- Function: gpReport_GoodsMI_byMovement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovement (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber TVarChar, OperDate TDateTime 
              , TradeMarkName TVarChar
              , GoodsGroupName TVarChar
              , GoodsId Integer, GoodsName TVarChar
              , JuridicalId Integer, JuridicalName TVarChar
              , PartnerId Integer, PartnerName TVarChar
              , PaidKindName TVarChar
              , Amount_Summ TFloat, Amount_CountWeight TFloat , Amount_CountSh TFloat
              , Price TFloat
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

    SELECT AllSale.invnumber, AllSale.OperDate
         , Object_TradeMark.ValueData  AS TradeMarkName
         , Object_GoodsGroup.ValueData AS GoodsGroupName 
         , AllSale.GoodsId AS GoodsId
         , Object_Goods.ValueData AS GoodsName

         , Object_Juridical.Id          AS JuridicalId
         , Object_Juridical.ValueData   AS JuridicalName

         , Object_Partner.Id          AS PartnerId
         , Object_Partner.ValueData   AS PartnerName

         , Object_PaidKind.ValueData AS PaidKindName

         , CAST (SUM(AllSale.Amount_Summ) AS TFloat) AS Amount_Summ
         , CAST (SUM(AllSale.Amount_Count * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS Amount_CountWeight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.Amount_Count else 0 end) AS TFloat) AS Amount_CountSh 

         , MIFloat_Price.ValueData AS Price
        

    FROM (
           SELECT AllContainer.invnumber
            , max(AllContainer.ContainerId) AS ContainerId 
            , AllContainer.MovementId
            , AllContainer.MovementItemId
            
            , AllContainer.OperDate, AllContainer.GoodsId
            , sum(AllContainer.Amount_Summ)  AS Amount_Summ
            , sum(AllContainer.Amount_Count) AS Amount_Count
           FROM (
                 SELECT Movement.invnumber
                      , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END AS ContainerId
                      , Movement.Id AS MovementId
                      , MIReport.MovementItemId AS MovementItemId
                      , MIReport.OperDate
                      , MovementItem.objectId AS GoodsId
                      , sum(CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN MIReport.Amount ELSE MIReport.Amount*(-1) END) AS Amount_Summ
                      , 0 AS  Amount_Count
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
           
                 WHERE Movement.DescId = inDescId 
                   AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
           
                 GROUP BY  Movement.invnumber, MIReport.OperDate, MovementItem.objectId, Movement.Id, MIReport.MovementItemId
                         , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END 
    
              UNION ALL    
                 SELECT Movement.invnumber
                      , 0 AS ContainerId 
                      , Movement.Id AS MovementId
                      , MIContainer.MovementItemId AS MovementItemId
                      
                      , MIContainer.OperDate
                      , Container.ObjectId AS GoodsId       
                      , 0 AS Amount_Summ
                      , sum(MIContainer. Amount) AS Amount_Count
    
                 FROM  Movement 
                   JOIN MovementItemContainer AS MIContainer 
                                              ON MIContainer.MovementId = Movement.Id
                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                
                   JOIN Container ON Container.Id = MIContainer.ContainerId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.ObjectId in (SELECT _tmpGoods.GoodsId FROM _tmpGoods)
                 WHERE Movement.DescId = inDescId 
    
                 GROUP BY Movement.invnumber
                        , Movement.Id
                        , MIContainer.MovementItemId 
                        , MIContainer.OperDate
                        , Container.ObjectId 
               ) AS AllContainer

          GROUP BY AllContainer.invnumber, AllContainer.OperDate, AllContainer.GoodsId, AllContainer.MovementItemId, AllContainer.MovementId
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
                                     AND MovementLinkObject_Partner.DescId = CASE WHEN inDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
            
         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = AllSale.MovementItemId
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price() 

         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                       ON ContainerLinkObject_Juridical.ContainerId = AllSale.ContainerId
                                      AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContainerLinkObject_Juridical.ObjectId 

         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                       ON ContainerLinkObject_PaidKind.ContainerId = AllSale.ContainerId
                                      AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ContainerLinkObject_PaidKind.ObjectId 
                                    
       GROUP BY
           AllSale.invnumber
         , AllSale.OperDate
         , Object_TradeMark.ValueData
         , Object_GoodsGroup.ValueData
         , Object_Goods.ObjectCode
         , AllSale.GoodsId 
         , Object_Goods.ValueData
         , MIFloat_Price.ValueData 
         , Object_Partner.Id
         , Object_Partner.ValueData   
         , Object_Juridical.Id
         , Object_Juridical.ValueData  
         , Object_PaidKind.ValueData  

       ORDER BY AllSale.OperDate
              , AllSale.invnumber
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData

                                       
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_byMovement (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.14         *

*/


--select * from gpReport_GoodsMI_byMovement(inStartDate := ('15.12.2013')::TDateTime , inEndDate := ('17.12.2013')::TDateTime , inDescId := 5 , inGoodsGroupId := 0 ,  inSession := '5');
