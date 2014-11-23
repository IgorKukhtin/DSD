-- Function: gpReport_GoodsMI_ProductionSeparate ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Boolean, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionSeparate (
    IN inStartDate     TDateTime ,  
    IN inEndDate       TDateTime ,
    IN inGoodsGroupId  Integer   ,
    IN inGroupMovement Boolean   ,
    IN inGroupPartion  Boolean   ,
    IN inGoodsId       Integer   ,
    IN inFromId        Integer   ,    -- от кого 
    IN inToId          Integer   ,    -- кому
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, PartionGoods  TVarChar 
             , GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, HeadCount TFloat, Summ TFloat
             , ChildGoodsGroupName TVarChar, ChildGoodsCode Integer,  ChildGoodsName TVarChar
             , ChildAmount TFloat, ChildSumm TFloat, Price TFloat
             , ChildPrice TFloat, Percent TFloat
             )   
AS
$BODY$
    DECLARE vbDescId Integer;
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;
  
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;  --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

    -- ограничения по КОМУ
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;   --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

  
   -- Результат
    RETURN QUERY
    
    -- ограничиваем по виду документа  , по от кого / кому
      WITH tmpMovement AS 
                        (SELECT Movement.Id        AS MovementId
                              , Movement.InvNumber AS InvNumber
                              , Movement.OperDate  AS OperDate
                              , MovementString_PartionGoods.ValueData AS PartionGoods 
                         FROM Movement 
                              LEFT JOIN MovementString AS MovementString_PartionGoods
                                                       ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                      AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

			      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
				                           ON MovementLinkObject_From.MovementId = Movement.Id
						          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
			      LEFT JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId
			      
  			      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
				 		           ON MovementLinkObject_To.MovementId = Movement.Id
							  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
			      LEFT JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId
				  
						      
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = zc_Movement_ProductionSeparate() -- 9 --and   Movement.Id  = 386839 
                            
                         GROUP BY Movement.Id 
                                , Movement.InvNumber 
                                , Movement.OperDate  
                                , MovementString_PartionGoods.ValueData 
                         )
                         
     , tmpMI_Amount AS (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , MovementItem.ObjectId AS GoodsId       
                             , 0 AS Summ
                             , SUM (MIContainer.Amount) AS Amount
                             , MIFloat_HeadCount.ValueData AS HeadCount
                             , MovementItem.DescId 
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                            LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                                         
                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId   --MIMaster
				             --AND MovementItem.DescId = zc_MI_Master()
		            JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

		            LEFT JOIN MovementLinkObject AS MovementLO_From
                                                         ON MovementLO_From.MovementId = tmpMovement.MovementId
                                                        AND MovementLO_From.DescId = zc_MovementLinkObject_From()   
                            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                        GROUP BY MovementItem.ObjectId    
                               , COALESCE (Container.ObjectId, 0) 
                               , MIFloat_HeadCount.ValueData 
                               , tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MovementItem.DescId 
                           )

  
 , tmpMI_sum AS (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , MovementItem.ObjectId AS GoodsId       
                             , SUM (COALESCE (MIContainer.Amount,0)) AS Summ
                             , 0 AS Amount
                             , 0 AS HeadCount
                             , MovementItem.DescId 
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                                                      AND MIContainer.DescId = zc_MIContainer_Summ()
                            JOIN Container ON Container.Id = MIContainer.ContainerId
                            
                            JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                                 ) AS tmpAccount on tmpAccount.AccountID = Container.ObjectId

                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                            -- AND MovementItem.DescId = zc_MI_Master()
                                       
                            JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                        GROUP BY MovementItem.ObjectId    
                               , COALESCE (Container.ObjectId, 0) 
                               , tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MovementItem.DescId 
                       )



      SELECT CAST (tmpOperationGroup.InvNumber AS TVarChar) AS InvNumber
           , CAST (tmpOperationGroup.OperDate AS TDateTime)  AS OperDate
           , CAST (tmpOperationGroup.PartionGoods AS TVarChar) AS PartionGoods

           , Object_GoodsGroup.ValueData AS GoodsGroupName 
           , Object_Goods.ObjectCode     AS GoodsCode
           , Object_Goods.ValueData      AS GoodsName  

           , tmpOperationGroup.Amount :: TFloat AS Amount
           , tmpOperationGroup.HeadCount :: TFloat AS HeadCount

           , tmpOperationGroup.Summ :: TFloat AS Summ


           , Object_GoodsGroupChild.ValueData AS ChildGoodsGroupName 
           , Object_GoodsChild.ObjectCode     AS ChildGoodsCode
           , Object_GoodsChild.ValueData      AS ChildGoodsName

           , tmpOperationGroup.ChildAmount  :: TFloat AS ChildAmount

           , tmpOperationGroup.ChildSumm :: TFloat AS ChildSumm
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           
           , CASE WHEN tmpOperationGroup.ChildAmount <> 0 THEN COALESCE ((tmpOperationGroup.ChildSumm / tmpOperationGroup.ChildAmount) ,0) ELSE 0 END  :: TFloat         AS ChildPrice
           , CASE WHEN tmpOperationGroup.Amount <> 0 THEN COALESCE((tmpOperationGroup.ChildAmount * 100 / tmpOperationGroup.Amount) ,0) ELSE 0 END   ::TFloat   AS Percent  

      FROM (
            SELECT CASE when inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END AS InvNumber
                 , CASE when inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END AS OperDate
                 , CASE when inGroupPartion = True THEN tmpMI.PartionGoods ELSE '' END AS PartionGoods
                 , tmpMI.GoodsId       
                 , ABS (SUM(tmpMI.Summ)) as Summ
                 , ABS (SUM(tmpMI.Amount)) as Amount
                 , ABS (SUM(tmpMI.HeadCount)) as HeadCount
                 , tmpMI.ChildGoodsId     
                 , ABS (SUM(tmpMI.ChildSumm)) as ChildSumm
                 , ABS (SUM(tmpMI.ChildAmount)) as ChildAmount

            FROM (SELECT  tmpMIMaster_Sum.InvNumber
                        , tmpMIMaster_Sum.OperDate
                        , tmpMIMaster_Sum.PartionGoods 
                        , tmpMIMaster_Sum.GoodsId       
                        , tmpMIMaster_Sum.Summ
                        , tmpMIMaster_Sum.Amount
                        , tmpMIMaster_Sum.HeadCount
                        , tmpMIChild_Sum.GoodsId  AS ChildGoodsId     
                        , tmpMIChild_Sum.Summ AS ChildSumm
                        , tmpMIChild_Sum.Amount AS ChildAmount
                  FROM tmpMI_sum AS tmpMIMaster_Sum
                       JOIN tmpMI_sum AS tmpMIChild_Sum on tmpMIMaster_Sum.MovementId = tmpMIChild_Sum.MovementId
                                                       AND tmpMIChild_Sum.DescId = zc_MI_Child()
                                                       AND  tmpMIChild_Sum.Amount<>0
                  Where tmpMIMaster_Sum.DescId = zc_MI_Master()
            
              UNION
           
                  SELECT  tmpMIMaster.InvNumber
                        , tmpMIMaster.OperDate
                        , tmpMIMaster.PartionGoods 
                        , tmpMIMaster.GoodsId as GoodsId       
                        , tmpMIMaster.Summ
                        , tmpMIMaster.Amount
                        , tmpMIMaster.HeadCount
                        , tmpMIChild.GoodsId  as ChildGoodsId     
                        , tmpMIChild.Summ as ChildSumm
                        , tmpMIChild.Amount as ChildAmount
                  FROM tmpMI_Amount AS tmpMIMaster
                         JOIN tmpMI_Amount AS tmpMIChild on tmpMIMaster.MovementId = tmpMIChild.MovementId
                                                        AND tmpMIChild.DescId = zc_MI_Child()
                                                        AND tmpMIChild.Amount<>0
                  Where tmpMIMaster.DescId = zc_MI_Master()
                         
            ) AS tmpMI 
	    GROUP BY CASE when inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END
                   , CASE when inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END
                   , CASE when inGroupPartion = True THEN tmpMI.PartionGoods ELSE '' END 
                   , tmpMI.GoodsId       
                   , tmpMI.ChildGoodsId   
            ) AS tmpOperationGroup

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.ChildGoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupChild
                                  ON ObjectLink_Goods_GoodsGroupChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_GoodsGroupChild.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroupChild ON Object_GoodsGroupChild.Id = ObjectLink_Goods_GoodsGroupChild.ChildObjectId

             LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_ProductionSeparate(), inOperDate:= inEndDate)
                                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = Object_GoodsChild.Id

      ORDER BY tmpOperationGroup.InvNumber
             , tmpOperationGroup.OperDate
             , tmpOperationGroup.PartionGoods 
             , Object_GoodsGroup.ValueData 
             , Object_Goods.ObjectCode     
             , Object_Goods.ValueData      
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.14
 21.08.14         * 
    
*/

-- тест

--select * from gpReport_GoodsMI_ProductionSeparate(inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('01.06.2014')::TDateTime , inGoodsGroupId := 2006 , inGroupMovement := 'True' , inGoodsId := 0 , inFromId := 0 , inToId := 0,  inSession := '5');
--
--select * from gpReport_GoodsMI_ProductionSeparate(inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('01.06.2014')::TDateTime , inGoodsGroupId := 0 , inGroupMovement := 'false' , inGroupPartion := 'false' , inGoodsId := 0 , inFromId := 133049 , inToId := 8444 ,  inSession := '5');
--select * from gpReport_GoodsMI_ProductionSeparate(inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('01.06.2014')::TDateTime , inGoodsGroupId := 0 , inGroupMovement := 'False' , inGroupPartion := 'True' , inGoodsId := 0 , inFromId := 0 , inToId := 0 ,  inSession := '5');