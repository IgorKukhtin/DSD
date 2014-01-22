-- Function: gpReport_SaleGoods ()

DROP FUNCTION IF EXISTS gpReport_SaleGoods (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleGoods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE  (InvNumber Integer, OperDate TDateTime 
              , TradeMarkName TVarChar
              , GoodsGroupName TVarChar
              , GoodsId Integer, GoodsName TVarChar
              , Amount_Summ TFloat, Amount_Count TFloat
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
         , AllSale.Amount_Summ
         , AllSale.Amount_Count 
    FROM (
           SELECT AllContainer.invnumber, AllContainer.OperDate, AllContainer.GoodsId
            , sum(AllContainer.Amount_Summ)  AS Amount_Summ
            , sum(AllContainer.Amount_Count) AS Amount_Count
           FROM (
                 SELECT Movement.invnumber
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
                                                   AND ContainerLO_ProfitLoss.ObjectId in ( zc_Enum_ProfitLoss_10101(), zc_Enum_ProfitLoss_10102()
                                                                                          , zc_Enum_ProfitLoss_10201(), zc_Enum_ProfitLoss_10202()
                                                                                          , zc_Enum_ProfitLoss_10301(), zc_Enum_ProfitLoss_10302())
                         WHERE Container.ObjectId = zc_Enum_Account_100301()
                         ) AS tmpContainer ON tmpContainer.ContainerId = ReportContainerLink.ContainerId

                   JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                    AND MovementItem.descid =  zc_MI_MASter()
                                    AND MovementItem.objectId in (SELECT GoodsId FROM _tmpGoods)
           
                 WHERE Movement.DescId = zc_Movement_Sale() 
                   AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
           
                 GROUP BY  Movement.invnumber, MIReport.OperDate, MovementItem.objectId
    
              UNION ALL    
                 SELECT Movement.invnumber
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
                                 AND Container.ObjectId in (SELECT GoodsId FROM _tmpGoods)
                 WHERE Movement.DescId = zc_Movement_Sale() 
    
                 GROUP BY Movement.invnumber
                        , MIContainer.OperDate
                        , Container.ObjectId 
               ) AS AllContainer

          GROUP BY AllContainer.invnumber, AllContainer.OperDate, AllContainer.GoodsId

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
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_SaleGoods (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 22.01.14         *

*/

-- òåñò
-- SELECT * FROM gpReport_SaleGoods (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013',  inSession:= zfCalc_UserAdmin());
