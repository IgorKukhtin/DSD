-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_Goods_Movement (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_Movement (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
 --   IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (GoodsGroupName TVarChar
              , GoodsCode Integer, GoodsName TVarChar
              , GoodsKindName TVarChar
              , TradeMarkName TVarChar
              , JuridicalCode Integer, JuridicalName TVarChar
              , PartnerCode Integer, PartnerName TVarChar
              , PaidKindName TVarChar
              , Sale_Summ TFloat, Sale_Amount_Weight TFloat , Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat , Sale_AmountPartner_Sh TFloat
              , Return_Summ TFloat, Return_Amount_Weight TFloat , Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat , Return_AmountPartner_Sh TFloat 
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

    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 

         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName

         , Object_PaidKind.ValueData AS PaidKindName

         , CAST (SUM(AllSale.Sale_Summ) AS TFloat) AS Sale_Summ
         , CAST (SUM(AllSale.Sale_Amount * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS Sale_Amount_Weight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.Sale_Amount else 0 end) AS TFloat) AS Sale_Amount_Sh 

         , CAST (SUM(AllSale.Sale_AmountPartner * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS Sale_AmountPartner_Weight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.Sale_AmountPartner else 0 end) AS TFloat) AS Sale_AmountPartner_Sh 



         , CAST (SUM(AllSale.Return_Summ) AS TFloat) AS Return_Summ
         , CAST (SUM(AllSale.Return_Amount * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS Return_Amount_Weight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.Return_Amount else 0 end) AS TFloat) AS Return_Amount_Sh 

         , CAST (SUM(AllSale.Return_AmountPartner * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS Return_AmountPartner_Weight 
         , CAST (SUM(case when Object_Measure.Id = zc_Measure_Sh() then AllSale.Return_AmountPartner else 0 end) AS TFloat) AS Return_AmountPartner_Sh 


    FROM ( SELECT MAX(AllContainer.ContainerId_Juridical) AS ContainerId_Juridical
                , MAX(AllContainer.PartnerId) AS PartnerId
             
                , AllContainer.GoodsId
                , AllContainer.GoodsKindId

                , ABS (SUM (AllContainer.Sale_Summ))   AS Sale_Summ
                , ABS (SUM (AllContainer.Sale_Amount)) AS Sale_Amount

                , ABS (sum(AllContainer.Return_Summ))   AS Return_Summ
                , ABS (sum(AllContainer.Return_Amount)) AS Return_Amount

                , ABS (sum(AllContainer.Sale_AmountPartner))   AS Sale_AmountPartner
                , ABS (sum(AllContainer.Return_AmountPartner)) AS Return_AmountPartner

           FROM (SELECT CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END AS ContainerId_Juridical
                      , 0 AS PartnerId
                      , MovementItem.objectId AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      
                      , sum (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MIReport.Amount * CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN 1 ELSE -1 END ELSE 0 END) AS Sale_Summ
                      , sum (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIReport.Amount * CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN 1 ELSE -1 END ELSE 0 END) AS Return_Summ
                      
                      , 0 AS  Sale_Amount
                      , 0 AS  Return_Amount
                      , 0 AS  Sale_AmountPartner
                      , 0 AS  Return_AmountPartner

                 FROM (SELECT zc_Movement_Sale() AS DescId UNION SELECT zc_Movement_ReturnIn() AS DescId) AS tmpDesc
                      JOIN Movement ON Movement.DescId = tmpDesc.DescId
                                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                      JOIN MovementItemReport AS MIReport ON MIReport.MovementId = Movement.Id

                      JOIN ReportContainerLink ON  ReportContainerLink.ReportContainerId = MIReport.ReportContainerId 

                      JOIN (SELECT Container.Id AS ContainerId
                                 , ContainerLO_ProfitLoss.ObjectId AS ProfitLossId
                            FROM Container  
                                 JOIN ContainerLinkObject AS ContainerLO_ProfitLoss 
                                                          ON ContainerLO_ProfitLoss.ContainerId = Container.Id
                                                         AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                         AND ContainerLO_ProfitLoss.ObjectId in ( zc_Enum_ProfitLoss_10101(), zc_Enum_ProfitLoss_10102() -- Сумма реализации: Продукция OR Ирна
                                                                                                , zc_Enum_ProfitLoss_10201(), zc_Enum_ProfitLoss_10202() -- Скидка по акциям: Продукция OR Ирна
                                                                                                , zc_Enum_ProfitLoss_10301(), zc_Enum_ProfitLoss_10302()) -- Скидка дополнительная: Продукция OR Ирна
                            WHERE Container.ObjectId = zc_Enum_Account_100301() -- "прибыль текущего периода"
                           ) AS tmpContainer ON tmpContainer.ContainerId = ReportContainerLink.ContainerId

                       JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                        AND MovementItem.descid =  zc_MI_Master()
                       
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.objectId
                       
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           
                 GROUP BY CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END
                        , MovementItem.objectId
                        , MILinkObject_GoodsKind.ObjectId
    
              UNION ALL    
                 SELECT 0 AS ContainerId_Juridical
                      , tmpMovement.PartnerId AS PartnerId

                      , Container.ObjectId AS GoodsId 
                      , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId    
  
                      , 0 AS Sale_Summ
                      , 0 AS Return_Summ

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Sale_Amount
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN MIContainer.Amount ELSE 0 END) AS Return_Amount
    
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Sale_AmountPartner
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Return_AmountPartner

                 FROM (SELECT Movement.Id AS MovementId
                            , Movement.DescId AS MovementDescId
                            , MovementLinkObject_Partner.ObjectId AS PartnerId 

                       FROM (SELECT zc_Movement_Sale() AS DescId UNION SELECT zc_Movement_ReturnIn() AS DescId) AS tmpDesc
                            JOIN Movement ON Movement.DescId = tmpDesc.DescId
                                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                 
                            LEFT JOIN (SELECT zc_MovementLinkObject_To() AS DescId, zc_Movement_Sale() AS MovementDescId
                                      UNION
                                       SELECT zc_MovementLinkObject_From() AS DescId, zc_Movement_ReturnIn() AS MovementDescId
                                      ) AS tmpDesc_Partner ON tmpDesc_Partner.MovementDescId = Movement.DescId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = tmpDesc_Partner.DescId
                      ) as tmpMovement
                      JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId
                                                
                      JOIN Container ON Container.Id = MIContainer.ContainerId
                                    AND Container.DescId = zc_Container_Count()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                      
                      LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()


                  GROUP BY tmpMovement.PartnerId
                        , Container.ObjectId 
                        , ContainerLO_GoodsKind.ObjectId

               ) AS AllContainer

          GROUP BY AllContainer.GoodsId, AllContainer.GoodsKindId

         ) AS AllSale
   
         JOIN object AS object_Goods on object_Goods.Id = AllSale.GoodsId

         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = AllSale.GoodsKindId

         LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                              ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                             AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
         LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId


         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

         LEFT JOIN ObjectFloat AS ObjectFloat_Weight 
                               ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = AllSale.PartnerId
            
         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                       ON ContainerLinkObject_Juridical.ContainerId = AllSale.ContainerId_Juridical
                                      AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContainerLinkObject_Juridical.ObjectId 

         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                       ON ContainerLinkObject_PaidKind.ContainerId = AllSale.ContainerId_Juridical
                                      AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ContainerLinkObject_PaidKind.ObjectId 
                                    
       GROUP BY
           Object_TradeMark.ValueData
         , Object_GoodsGroup.ValueData
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData
         , Object_Partner.ObjectCode
         , Object_Partner.ValueData   
         , Object_Juridical.ObjectCode
         , Object_Juridical.ValueData  
         , Object_PaidKind.ValueData  
         , Object_GoodsKind.ValueData

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
 03.02.14         *

*/

--select * from gpReport_Goods_Movement(inStartDate := ('15.12.2013')::TDateTime , inEndDate := ('16.12.2013')::TDateTime , inGoodsGroupId := 0 ,  inSession := '5');    --1952
--select * from gpReport_GoodsMI_byMovement(inStartDate := ('15.12.2013')::TDateTime , inEndDate := ('16.12.2013')::TDateTime , inDescId := 5 , inGoodsGroupId := 0 ,  inSession := '5');