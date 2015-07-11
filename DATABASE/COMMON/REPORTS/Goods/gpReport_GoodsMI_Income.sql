-- Function: gpReport_GoodsMI_Income ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, Integer, Integer,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Income (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId Integer   ,
    IN inUnitGroupId  Integer   ,
    IN inUnitId       Integer   ,
    IN inPaidKindId   Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , TradeMarkName TVarChar
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
    
    -- ограничиваем по виду документа и Юр.лицу
      WITH tmpMovement AS (SELECT Movement.Id AS MovementId
                                , MovementLinkObject_PaidKind.ObjectId AS PaidKindId 
                         FROM Movement 
                              JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = inDescId   
                         GROUP BY Movement.Id 
                                , MovementLinkObject_PaidKind.ObjectId
                         )


    SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Object_GoodsKind.ValueData  AS GoodsKindName
         , Object_TradeMark.ValueData  AS TradeMarkName
         , Object_PaidKind.ValueData   AS PaidKindName
         , Object_FuelKind.ValueData   AS FuelKindName
         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat AS Amount_Sh

         , CAST ((tmpOperationGroup.AmountPartner * (case when Object_Measure.Id = zc_Measure_Sh() then ObjectFloat_Weight.ValueData else 1 end )) AS TFloat) AS AmountPartner_Weight 
         , CAST ((case when Object_Measure.Id = zc_Measure_Sh() then tmpOperationGroup.AmountPartner else 0 end) AS TFloat) AS AmountPartner_Sh 

         , tmpOperationGroup.Summ :: TFloat AS Summ

     FROM (SELECT tmpOperation.PaidKindId
                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , tmpOperation.FuelKindId
                , ABS (SUM (tmpOperation.Amount)):: TFloat          AS Amount
                , ABS (SUM (tmpOperation.AmountPartner)):: TFloat   AS AmountPartner
                , ABS (SUM (tmpOperation.Summ)) :: TFloat           AS Summ

           FROM (SELECT tmpMovement.PaidKindId
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

                      GROUP BY tmpMovement.PaidKindId
                             , MovementItem.ObjectId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                             , COALESCE (ContainerLO_FuelKind.ObjectId, 0) 
              UNION
                
                 SELECT tmpMovement.PaidKindId
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
                                         
                     /* LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                    ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                   AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/

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
                      
                      GROUP BY tmpMovement.PaidKindId
                             , MovementItem.ObjectId    
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                             , COALESCE (Container.ObjectId, 0) 

               ) AS tmpOperation

           GROUP BY tmpOperation.PaidKindId
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
ALTER FUNCTION gpReport_GoodsMI_Income (TDateTime, TDateTime, Integer, Integer, Integer, Integer,Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.15         * add inUnitGroupId, inUnitId, inPaidKindId
 08.02.14         * 
    
*/

-- тест
--SELECT * FROM gpReport_GoodsMI_Income (inStartDate:= '01.01.2013', inEndDate:= '31.12.2013',  inDescId:= 1, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
