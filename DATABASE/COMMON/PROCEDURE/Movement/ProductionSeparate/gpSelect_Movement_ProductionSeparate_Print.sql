-- Function: gpSelect_Movement_ProductionSeparate_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbstatusid Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE vbDescId Integer;
    
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);



     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
       INTO vbDescId, vbStatusId
     FROM Movement

     WHERE Movement.Id = inMovementId

    ;

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- ��� ��� �������� ������
        RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



     --
    OPEN Cursor1 FOR

  WITH tmpMovement AS (SELECT Movement.InvNumber                 AS InvNumber
                            , Movement.OperDate                  AS OperDate
                            , MovementString_PartionGoods.ValueData AS PartionGoods
                        FROM Movement 
                          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                        WHERE Movement.Id = inMovementId
                       )

   ,tmpMIContainer_Count AS (SELECT MIContainer.MovementItemId
                                     ,  MIContainer.ContainerId
                                    ,  MIContainer.ObjectId_analyzer as GoodsId
                                      ,  MIContainer.isActive
                                     , SUM (MIContainer.Amount)*(-1) AS Amount
         
                         FROM MovementItemContainer AS MIContainer 
                               
                        WHERE MIContainer.DescId = zc_MIContainer_Count()
                          AND MIContainer.MovementId = inMovementId
                        GROUP BY MIContainer.MovementItemId
                         ,  MIContainer.ContainerId
                                    ,  MIContainer.ObjectId_analyzer
                                      ,  MIContainer.isActive
                        )
                        
    , tmpMIContainer_Summ AS (SELECT MIContainer.MovementItemId
                            , SUM (MIContainer.Amount)  AS Amount
         
                        FROM MovementItemContainer AS MIContainer 
                               
                        WHERE MIContainer.DescId = zc_MIContainer_Summ()
                          AND MIContainer.MovementId = inMovementId
                        GROUP BY MIContainer.MovementItemId
                        )
                        
    , tmpMIMaster AS ( SELECT  Object_Goods.ValueData  AS GoodsNameMaster
                             , tmp.HeadCount, tmp.Count, tmp.Summ
                       FROM (SELECT  max (tmpMIContainer_Count.GoodsId)    AS GoodsId
                                   , SUM (tmpMIContainer_Count.Amount)     AS Count
                                   , SUM (MIFloat_HeadCount.ValueData)     AS HeadCount
                                   , SUM (tmpMIContainer_Summ.Amount)      AS Summ
                             FROM tmpMIContainer_Count
                                LEFT JOIN tmpMIContainer_Summ ON tmpMIContainer_Summ.MovementItemId = tmpMIContainer_Count.MovementItemId
                                LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = tmpMIContainer_Count.MovementItemId
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                             WHERE tmpMIContainer_Count.isActive = FALSE
                             ) AS tmp
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
                      
                        )
  , tmpContainer AS (SELECT CLO_PartionGoods.ContainerId , CLO_PartionGoods.objectId
                           , Container.DescId
                     FROM (SELECT  CLO_PartionGoods.ObjectId AS ObjectId

                           FROM tmpMIContainer_Count
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = tmpMIContainer_Count.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                         
                           WHERE tmpMIContainer_Count.isActive = FALSE  LIMIT 1
                           ) AS tmp
                         JOIN  ContainerLinkObject AS CLO_PartionGoods  
                                                   ON CLO_PartionGoods.ObjectId = tmp.ObjectId
                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods() 
                          left JOIN  Container on Container.id =  CLO_PartionGoods.ContainerId

                        GROUP BY CLO_PartionGoods.ContainerId , CLO_PartionGoods.objectId ,  Container.DescId
                         )
   
                 
      , tmpIncome AS (SELECT tmpContainer.ContainerId
                         , MIContainer.MovementId
                         , MIContainer.ObjectId_analyzer as GoodsId    , Object_Goods.ValueData  AS GoodsNameIncome  
                         , CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN SUM(MIContainer.Amount) ELSE 0 END AS Count
                         , CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN SUM(MIContainer.Amount) ELSE 0 END AS Summ
                         , SUM( MIFloat_AmountPacker.ValueData) AS CountPacker
                         , SUM( MIFloat_HeadCount.ValueData)    AS HeadCount
                    FROM tmpContainer
                        INNER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                 AND MIContainer.MovementDescId = zc_Movement_Income()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                         ON MIFloat_AmountPacker.MovementItemId = MIContainer.MovementItemId
                                       AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                                       AND MIContainer.DescId = zc_MIContainer_Count()
                                       AND AnalyzerId IS NULL
                        LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                       AND MIContainer.DescId = zc_MIContainer_Count()
                                       AND AnalyzerId IS NULL
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MIContainer.ObjectId_analyzer  
                    GROUP BY tmpContainer.ContainerId, MIContainer.MovementId, MIContainer.ObjectId_analyzer, MIContainer.DescId  , Object_Goods.ValueData  
                    )




, tmpProductionSeparate AS (SELECT Object_Goods.ValueData  AS GoodsNameSeparate
                                 , MovementItem.Amount AS Count
                            FROM (SELECT MIContainer.MovementId
                               
                                  FROM (SELECT tmpIncome.ContainerId FROM tmpIncome GROUP BY tmpIncome.ContainerId) AS tmp
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.ContainerId = tmp.ContainerId
                                                 AND MIContainer.DescId = zc_MIContainer_Count()
                                                 AND MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                                  GROUP BY MIContainer.MovementId
                                  ) as tmp 
                               LEFT JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                   AND MovementItem.ObjectId in (SELECT GoodsId from lfSelect_Object_Goods_byGoodsGroup (2006))
                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  MovementItem.ObjectId 
                           )


    SELECT  tmpMovement.InvNumber, tmpMovement.OperDate, tmpMovement.PartionGoods
           ,tmpMIMaster.GoodsNameMaster, (tmpMIMaster.Summ * (-1)) AS SummMaster, tmpMIMaster.Count AS CountMaster, tmpMIMaster.HeadCount AS HeadCountMaster
           , (tmpMIMaster.Summ * (-1) / tmpMIMaster.Count) AS PriceMaster
          
           , Object_From.ValueData AS FromName
           , tmpIncomeAll.GoodsNameIncome, tmpIncomeAll.Count AS CountIncome, tmpIncomeAll.HeadCount AS HeadCountIncome
           , tmpIncomeAll.CountPacker AS CountPackerIncome, tmpIncomeAll.Summ AS SummIncome
           , (tmpIncomeAll.Count / tmpIncomeAll.HeadCount) AS HeadCount1, (tmpIncomeAll.Summ /tmpIncomeAll.HeadCount) AS SummHeadCount1                      -- �� ��� ������ � ��� ����
           , tmpIncomeAll.Summ / tmpIncomeAll.Count AS PriceIncome, tmpIncomeAll.Summ / (tmpIncomeAll.Count -tmpIncomeAll.CountPacker) AS PriceIncome1
           , (tmpIncomeAll.Count -tmpIncomeAll.CountPacker) AS Count_CountPacker
           , tmpProductionSeparate.GoodsNameSeparate, tmpProductionSeparate.Count AS CountSeparate
           , tmpProductionSeparate.Count *100 /tmpIncomeAll.Count PercentCount 
          
      FROM tmpMovement
         LEFT JOIN tmpMIMaster on 1=1
         LEFT JOIN (SELECT GoodsNameIncome, MovementLinkObject_From.ObjectId --Object_From.ValueData AS FromName
                             , Sum( tmpIncome.Count) AS Count, Sum( tmpIncome.Summ) AS Summ, Sum(tmpIncome.CountPacker) AS CountPacker, Sum(tmpIncome.HeadCount) AS HeadCount 
                        FROM tmpIncome 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = tmpIncome.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         GROUP BY GoodsNameIncome, MovementLinkObject_From.ObjectId) AS tmpIncomeAll on 1=1
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpIncomeAll.ObjectId
         LEFT JOIN  tmpProductionSeparate on 1=1
 

      ;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpContainer AS (SELECT MIContainer.MovementItemId
                            , SUM (MIContainer.Amount) AS Amount
         
                        FROM MovementItemContainer AS MIContainer 
                                                           
                        WHERE MIContainer.DescId = zc_MIContainer_Summ()
                          AND MIContainer.MovementId = inMovementId   --386509 --
                        GROUP BY MIContainer.MovementItemId
                        )
                        
      SELECT Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , SUM (MovementItem.Amount)::TFloat		 AS Amount
           , SUM (MIFloat_LiveWeight.ValueData)::TFloat  AS LiveWeight
           , SUM (MIFloat_HeadCount.ValueData)::TFloat	 AS HeadCount
           , SUM (COALESCE (tmpContainer.Amount,0))/SUM (MovementItem.Amount)       AS SummPrice
           , SUM (COALESCE (tmpContainer.Amount,0))      AS Summ
       FROM MovementItem
                      
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MovementItem.Id
                                  
                        

            where MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = false

            GROUP BY Object_Goods.ObjectCode
           , Object_Goods.ValueData
           , ObjectString_Goods_GoodsGroupFull.ValueData
           , Object_Measure.ValueData ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionSeparate_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.04.15         *
*/
-- ����
-- SELECT * FROM gpSelect_Movement_ProductionSeparate_Print (inMovementId := 597300, inSession:= zfCalc_UserAdmin());
