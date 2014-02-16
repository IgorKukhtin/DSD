-- Function: gpReport_GoodsMI_IncomeByPartner ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_IncomeByPartner (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inJuridicalId  Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar
             , FuelKindName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountPartner_Weight TFloat , AmountPartner_Sh TFloat
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
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods()
         UNION 
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Fuel();
    END IF;


   -- Результат
    RETURN QUERY
    



    -- ограничиваем по Юр.лицу и по виду документа
    WITH tmpMovement AS (SELECT 
                             Movement.Id AS MovementId
                              , Movement.DescId AS MovementDescId
                              , ContainerLO_Juridical.ObjectId  AS JuridicalId 
                              , MovementLinkObject_Partner.ObjectId AS PartnerId
                              --, case when coalesce (ObjectLink_CardFuel_Juridical.ChildObjectId,0) = 0 then MovementLinkObject_Partner.ObjectId else ObjectLink_CardFuel_Juridical.ChildObjectId end  AS PartnerId 
                              , ContainerLinkObject_PaidKind.ObjectId AS PaidKindId 
                     
                         FROM Movement 
                              JOIN MovementItemContainer AS MIContainer 
                                                         ON MIContainer.MovementId =  Movement.Id

                              JOIN ContainerLinkObject AS ContainerLO_Juridical 
                                                       ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId
                                                      AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                      AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0) 
                            
                              LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                            ON ContainerLinkObject_PaidKind.ContainerId = MIContainer.ContainerId
                                                           AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                           ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_From()

                              /*LEFT JOIN Object AS Object_CardFuel ON Object_CardFuel.Id = MovementLinkObject_Partner.ObjectId
                                                                AND Object_CardFuel.DescId = zc_Object_CardFuel() 
                          
                              LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical 
                                                   ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                  AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
                              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId*/
                                                           
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate   
                           AND Movement.DescId = inDescId
                                          
                       GROUP BY Movement.Id 
                              , ContainerLO_Juridical.ObjectId
                              , MovementLinkObject_Partner.ObjectId
                              --, case when coalesce (ObjectLink_CardFuel_Juridical.ChildObjectId,0) = 0 then MovementLinkObject_Partner.ObjectId else ObjectLink_CardFuel_Juridical.ChildObjectId end
                              , ContainerLinkObject_PaidKind.ObjectId
                         )


    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName
         
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         
         , Object_PaidKind.ValueData   AS PaidKindName
         , Object_FuelKind.ValueData   AS FuelKindName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , CAST ((tmpOperationGroup.AmountPartner * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS AmountPartner_Weight 
         , CAST ((case when Object_Measure.Id = zc_Measure_Sh() then tmpOperationGroup.AmountPartner else 0 end) AS TFloat) AS AmountPartner_Sh 

         , tmpOperationGroup.Summ :: TFloat AS Summ

     FROM (SELECT tmpOperation.JuridicalId
                , tmpOperation.PartnerId
                , tmpOperation.PaidKindId

                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , tmpOperation.FuelKindId
                , ABS (SUM (tmpOperation.Amount)):: TFloat          AS Amount
                , ABS (SUM (tmpOperation.AmountPartner)):: TFloat   AS AmountPartner
                , ABS (SUM (tmpOperation.Summ)) :: TFloat           AS Summ

           FROM (SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId
                      , tmpMovement.PaidKindId 
                      , MovementItem.ObjectId AS GoodsId       
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , COALESCE (ContainerLO_FuelKind.ObjectId, 0)  AS FuelKindId
                      , SUM (COALESCE (MIContainer.Amount,0)) AS Summ
                      , 0 AS Amount
                      , 0 AS AmountPartner
                 FROM tmpMovement

                      JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId
                                                AND MIContainer.DescId = zc_MIContainer_Summ()
                      JOIN Container ON Container.Id = MIContainer.ContainerId

                      JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                           ) AS tmpAccount on tmpAccount.AccountID = Container.ObjectId

                      JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                       AND MovementItem.DescId =  zc_MI_Master()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                      LEFT JOIN ContainerLinkObject AS ContainerLO_FuelKind
                                                    ON ContainerLO_FuelKind.ContainerId = Container.Id
                                                   AND ContainerLO_FuelKind.DescId = zc_ContainerLinkObject_Goods()

                      GROUP BY tmpMovement.JuridicalId 
                             , tmpMovement.PartnerId
                             , tmpMovement.PaidKindId 
                             , MovementItem.ObjectId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                             , COALESCE (ContainerLO_FuelKind.ObjectId, 0) 
              UNION
                
                 SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId
                      , tmpMovement.PaidKindId 
                      , MovementItem.ObjectId AS GoodsId       
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , COALESCE (Container.ObjectId, 0)              AS FuelKindId
                      , 0 AS Summ
                      , SUM (MIContainer.Amount) AS Amount
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner                 
                 FROM tmpMovement

                      JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementId = tmpMovement.MovementId
                                                AND MIContainer.DescId = zc_MIContainer_Count()
                      LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                                         
                      JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                       AND MovementItem.DescId =  zc_MI_Master()
                      JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                      LEFT JOIN MovementLinkObject AS MovementLO_From
                                                   ON MovementLO_From.MovementId = tmpMovement.MovementId
                                                  AND MovementLO_From.DescId = zc_MovementLinkObject_From()   
                      LEFT JOIN Object ON Object.Id = MovementLO_From.ObjectId 
                                      AND Object.DescId = zc_Object_TicketFuel() 
                        
                      WHERE Object.Id IS NUll
                      
                      GROUP BY tmpMovement.JuridicalId 
                             , tmpMovement.PartnerId
                             , tmpMovement.PaidKindId 
                             , MovementItem.ObjectId    
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                             , COALESCE (Container.ObjectId, 0) 

               ) AS tmpOperation

           GROUP BY tmpOperation.JuridicalId
                  , tmpOperation.PartnerId
                  , tmpOperation.PaidKindId
                  , tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId
                  , tmpOperation.FuelKindId

          ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId

          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpOperationGroup.PaidKindId

          LEFT JOIN Object AS Object_FuelKind ON Object_FuelKind.Id = tmpOperationGroup.FuelKindId        
                  
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId 

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
ALTER FUNCTION gpReport_GoodsMI_IncomeByPartner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.14         * 
    
*/

-- тест
--SELECT * FROM gpReport_GoodsMI_IncomeByPartner (inStartDate:= '01.01.2013', inEndDate:= '31.12.2014',  inDescId:= 1, inJuridicalId:= 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());  --inJuridicalId:= 15039
