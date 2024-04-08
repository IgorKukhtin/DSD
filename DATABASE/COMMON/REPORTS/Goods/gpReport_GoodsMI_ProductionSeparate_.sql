   -- Function: gpReport_GoodsMI_ProductionSeparate ()
   old
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionSeparate (
    IN inStartDate     TDateTime ,  
    IN inEndDate       TDateTime ,
    IN inGoodsGroupId  Integer   ,
    IN inGroupMovement Boolean   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, PartionGoods  TVarChar 
             , GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , Amount_Sh TFloat, HeadCount TFloat, Summ TFloat
             , ChildGoodsGroupName TVarChar, ChildGoodsCode Integer,  ChildGoodsName TVarChar
             , ChildAmount_Sh TFloat, ChildSumm TFloat, Price TFloat
             , ChildPrice TFloat, Percent TFloat
             )   
AS
$BODY$
    DECLARE vbDescId Integer; 
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
    
    -- ограничиваем по виду документа 
      WITH tmpMovement AS 
                        (SELECT Movement.Id        AS MovementId
                              , Movement.InvNumber AS InvNumber
                              , Movement.OperDate  AS OperDate
                              , MovementString_PartionGoods.ValueData AS PartionGoods 
                         FROM Movement 
                              LEFT JOIN MovementString AS MovementString_PartionGoods
                                                       ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                      AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId  = zc_Movement_ProductionSeparate() -- 9 --and   Movement.Id  = 386839 
                         GROUP BY Movement.Id 
                                , Movement.InvNumber 
                                , Movement.OperDate  
                                , MovementString_PartionGoods.ValueData 
                         )


      SELECT CAST (tmpOperationGroup.InvNumber AS TVarChar) AS InvNumber
           , CAST (tmpOperationGroup.OperDate AS TDateTime)  AS OperDate
           , tmpOperationGroup.PartionGoods 

           , Object_GoodsGroup.ValueData AS GoodsGroupName 
           , Object_Goods.ObjectCode     AS GoodsCode
           , Object_Goods.ValueData      AS GoodsName  

           , tmpOperationGroup.Amount :: TFloat AS Amount_Sh
           , tmpOperationGroup.HeadCount :: TFloat AS HeadCount

           , tmpOperationGroup.Summ :: TFloat AS Summ


           , Object_GoodsGroupChild.ValueData AS ChildGoodsGroupName 
           , Object_GoodsChild.ObjectCode     AS ChildGoodsCode
           , Object_GoodsChild.ValueData      AS ChildGoodsName

           , tmpOperationGroup.ChildAmount  :: TFloat AS ChildAmount_Sh

           , tmpOperationGroup.ChildSumm :: TFloat AS ChildSumm
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           
           , CASE WHEN tmpOperationGroup.ChildAmount <> 0 THEN COALESCE ((tmpOperationGroup.ChildSumm / tmpOperationGroup.ChildAmount) ,0) ELSE 0 END  :: TFloat         AS ChildPrice
           , CASE WHEN tmpOperationGroup.Amount <> 0 THEN COALESCE((tmpOperationGroup.ChildAmount * 100 / tmpOperationGroup.Amount) ,0) ELSE 0 END   ::TFloat   AS Percent  

      FROM (
            SELECT CASE when inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END AS InvNumber
                 , CASE when inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END AS OperDate
                 , tmpMI.PartionGoods 
                 , tmpMI.GoodsId       
                 , ABS (SUM(tmpMI.Summ)) as Summ
                 , ABS (SUM(tmpMI.Amount)) as Amount
                 , ABS (SUM(tmpMI.HeadCount)) as HeadCount
                 , tmpMI.ChildGoodsId     
                 , ABS (SUM(tmpMI.ChildSumm)) as ChildSumm
                 , ABS (SUM(tmpMI.ChildAmount)) as ChildAmount
            FROM( 
                  SELECT  tmpMIMaster.InvNumber
                        , tmpMIMaster.OperDate
                        , tmpMIMaster.PartionGoods 
                        , tmpMIMaster.GoodsId       
                        , tmpMIMaster.Summ
                        , tmpMIMaster.Amount
                        , tmpMIMaster.HeadCount
                        , tmpMIChild.GoodsId  AS ChildGoodsId     
                        , tmpMIChild.Summ AS ChildSumm
                        , tmpMIChild.Amount AS ChildAmount
                  FROM (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , MovementItem.ObjectId AS GoodsId       
                             , SUM (COALESCE (MIContainer.Amount,0)) AS Summ
                             , 0 AS Amount
                             , 0 AS HeadCount
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                                                      AND MIContainer.DescId = zc_MIContainer_Summ()
                            JOIN Container ON Container.Id = MIContainer.ContainerId
                            
                            JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                                 ) AS tmpAccount on tmpAccount.AccountID = Container.ObjectId

                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                             AND MovementItem.DescId = zc_MI_Master()
                                       
                            JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                        GROUP BY MovementItem.ObjectId    
                               , COALESCE (Container.ObjectId, 0) 
                               , tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                        ) AS tmpMIMaster

                         JOIN (SELECT tmpMovement.MovementId AS MovementId
                                    , MovementItem.ObjectId AS GoodsId       
                                    , SUM (COALESCE (MIContainer.Amount,0)) AS Summ
                                    , 0 AS Amount
                               FROM tmpMovement

                         JOIN MovementItemContainer AS MIContainer 
                                                    ON MIContainer.MovementId = tmpMovement.MovementId
                                                   AND MIContainer.DescId = zc_MIContainer_Summ()
                         JOIN Container ON Container.Id = MIContainer.ContainerId

                         JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                              ) AS tmpAccount on tmpAccount.AccountID = Container.ObjectId

                         JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                          AND MovementItem.DescId = zc_MI_Child()
                                       
                         JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                  GROUP BY MovementItem.ObjectId    
                         , COALESCE (Container.ObjectId, 0) 
                         , tmpMovement.MovementId
                  ) AS tmpMIChild on tmpMIMaster.MovementId = tmpMIChild.MovementId
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
                  FROM (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , tmpMovement.PartionGoods
                             , MovementItem.ObjectId AS GoodsId       
                             , 0 AS Summ
                             , SUM (MIContainer.Amount) AS Amount
                             , MIFloat_HeadCount.ValueData AS HeadCount
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer 
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                            LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                                         
                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId   --MIMaster
				                             AND MovementItem.DescId = zc_MI_Master()
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
                        ) AS tmpMIMaster

                         JOIN (SELECT tmpMovement.MovementId          AS MovementId
                                        , MovementItem.ObjectId       AS GoodsId       
                                        , 0 AS Summ
                                        , SUM (MIContainer.Amount)    AS Amount
                                       
                               FROM tmpMovement
                                    JOIN MovementItemContainer AS MIContainer 
                                                               ON MIContainer.MovementId = tmpMovement.MovementId
                                                              AND MIContainer.DescId = zc_MIContainer_Count()
                                    LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                                         
                                    JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId          --MIMaster
				                                     AND MovementItem.DescId = zc_MI_Child()
		                    JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

		                    LEFT JOIN MovementLinkObject AS MovementLO_From
                                                                 ON MovementLO_From.MovementId = tmpMovement.MovementId
                                                                AND MovementLO_From.DescId = zc_MovementLinkObject_From()   
                                                                 
                               GROUP BY MovementItem.ObjectId    
                                      , COALESCE (Container.ObjectId, 0) 
                                      , tmpMovement.MovementId
                               ) AS tmpMIChild on tmpMIMaster.MovementId = tmpMIChild.MovementId
                        ) AS tmpMI 
	            	  GROUP BY CASE when inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END
                             , CASE when inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END
                             , tmpMI.PartionGoods 
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
                                   AS lfObjectHistory_PriceListItem 
                                   ON lfObjectHistory_PriceListItem.GoodsId = Object_GoodsChild.Id
                                  AND lfObjectHistory_PriceListItem.GoodsKindId IS NULL

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
ALTER FUNCTION gpReport_GoodsMI_ProductionSeparate (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.14         * 
    
*/

-- тест

--SELECT * FROM gpReport_GoodsMI_ProductionSeparate (inStartDate:= '19.06.2014', inEndDate:= '19.06.2014',  inGoodsGroupId:= 0, inGroupMovement:= True, inSession:= zfCalc_UserAdmin());
--	пр-4218-8992-17.06.2014	20.06.2014		 	 
--SELECT * FROM gpReport_GoodsMI_ProductionSeparate (inStartDate:= '19.06.2014', inEndDate:= '25.06.2014',  inGoodsGroupId:= 0, inGroupMovement:= False, inSession:= zfCalc_UserAdmin());


--select * from gpReport_GoodsMI_ProductionSeparate(inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('01.06.2014')::TDateTime , inGoodsGroupId := 0 , inGroupMovement := 'True' ,  inSession := '5');