-- Function: gpReport_GoodsMI_ProductionSeparate ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionSeparate (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGroupMovement      Boolean   ,
    IN inGroupPartion       Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- от кого 
    IN inToId               Integer   ,    -- кому
    IN inSession            TVarChar       -- сессия пользователя
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
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
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

    IF inChildGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpChildGoods (ChildGoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inChildGoodsId <> 0
         THEN
             INSERT INTO _tmpChildGoods (ChildGoodsId)
              SELECT inChildGoodsId;
         ELSE
             INSERT INTO _tmpChildGoods (ChildGoodsId)
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
			      JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId
			      
  			      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
				 		           ON MovementLinkObject_To.MovementId = Movement.Id
							  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
			      JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId
				  
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = zc_Movement_ProductionSeparate()
                            
                         GROUP BY Movement.Id
                                , Movement.InvNumber 
                                , Movement.OperDate  
                                , MovementString_PartionGoods.ValueData
                         )

, tmpMI_Container AS (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , MIContainer.ObjectId_Analyzer AS GoodsId
                            -- , 0 AS Summ
                             , SUM (MIContainer.Amount) AS Amount
                             , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                             , MIContainer.DescId  as MIContainerDescId
                             , MIContainer.isActive
                             
                        FROM tmpMovement
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.MovementId = tmpMovement.MovementId
	                     LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                         ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                                        AND MIContainer.isActive = FALSE
        
                        GROUP BY tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.DescId
                               , MIContainer.isActive
                        )
                         
      , tmpMI_Count AS (SELECT tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , 0 AS Summ
                             , SUM (tmpMI_Container.Amount) AS Amount
                             , SUM (tmpMI_Container.HeadCount) AS HeadCount
                             , tmpMI_Container.isActive
                        FROM tmpMI_Container
                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Count()
                        GROUP BY tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , tmpMI_Container.isActive
                           )

  , tmpMI_sum AS (SELECT tmpMI_Container.MovementId 
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoods
                             , tmpMI_Container.GoodsId 
                             , SUM (tmpMI_Container.Amount)  AS Summ
                             , 0 AS Amount
                             , tmpMI_Container.isActive
                        FROM tmpMI_Container
                          -- JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                          --       ) AS tmpAccount on tmpAccount.AccountID = tmpMI_Container.ContainerObjectId
                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Summ()
                        GROUP BY tmpMI_Container.MovementId 
                               , tmpMI_Container.InvNumber
                               , tmpMI_Container.OperDate
                               , tmpMI_Container.PartionGoods
                               , tmpMI_Container.GoodsId 
                               , tmpMI_Container.isActive
                           )
      -- РЕЗУЛЬТАТ
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

            FROM (SELECT  tmpMI_out.InvNumber
                        , tmpMI_out.OperDate
                        , tmpMI_out.PartionGoods 
                        , tmpMI_out.GoodsId as GoodsId       
                        , tmpMI_out.Summ
                        , tmpMI_out.Amount
                        , tmpMI_out.HeadCount
                        , tmpMI_in.GoodsId  as ChildGoodsId     
                        , tmpMI_in.Summ     as ChildSumm
                        , tmpMI_in.Amount   as ChildAmount
                  FROM tmpMI_Count AS tmpMI_out
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out.GoodsId
                       LEFT JOIN tmpMI_Count AS tmpMI_in on tmpMI_in.MovementId = tmpMI_out.MovementId
                                                        AND tmpMI_in.isActive = TRUE
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in.GoodsId
                  Where tmpMI_out.isActive = FALSE
                   AND COALESCE (tmpMI_in.Amount, -1 ) <> 0
              UNION
                  SELECT  tmpMI_out_Sum.InvNumber
                        , tmpMI_out_Sum.OperDate
                        , tmpMI_out_Sum.PartionGoods 
                        , tmpMI_out_Sum.GoodsId       
                        , tmpMI_out_Sum.Summ
                        , tmpMI_out_Sum.Amount
                        , 0 AS HeadCount
                        , tmpMI_in_Sum.GoodsId  AS ChildGoodsId     
                        , tmpMI_in_Sum.Summ AS ChildSumm
                        , tmpMI_in_Sum.Amount AS ChildAmount
                  FROM tmpMI_sum AS tmpMI_out_Sum
                       JOIN tmpMI_sum AS tmpMI_in_Sum on tmpMI_out_Sum.MovementId = tmpMI_in_Sum.MovementId
                                                       AND tmpMI_in_Sum.isActive = TRUE
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI_out_Sum.GoodsId
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMI_in_Sum.GoodsId
		                      --         
                  Where tmpMI_out_Sum.isActive = FALSE
                         
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
 27.11.14         *
 19.11.14         *
 21.08.14         * 
    
*/

-- тест
-- select * from gpReport_GoodsMI_ProductionSeparate(inStartDate := ('03.06.2014')::TDateTime , inEndDate := ('03.06.2014')::TDateTime , inGroupMovement := 'True' , inGroupPartion := 'False' , inGoodsGroupId := 0 , inGoodsId := 0 , inChildGoodsGroupId := 0 , inChildGoodsId := 2360 , inFromId := 0 , inToId := 0 ,  inSession := '5');
