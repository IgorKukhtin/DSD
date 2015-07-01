-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inLocationId   Integer   , 
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE  (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, PartionGoods TVarChar
              , Price TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
               )  
AS
$BODY$
BEGIN

    RETURN QUERY
    WITH tmpContainer_Count AS (SELECT Container.Id AS ContainerId
                                     , COALESCE (CLO_Unit.ObjectId, COALESCE (CLO_Car.ObjectId, COALESCE (CLO_Member.ObjectId, 0))) AS LocationId
                                     , Container.ObjectId AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , Container.Amount
                                FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods 
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = Container.Id
                                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = Container.Id
                                                                             AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = Container.Id
                                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                WHERE CLO_Unit.ObjectId = inLocationId
                                   OR CLO_Car.ObjectId = inLocationId
                                   OR CLO_Member.ObjectId = inLocationId
                                   OR COALESCE (inLocationId, 0) = 0
                               )
                , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
                                       , tmpContainer_Count.PartionGoodsId
                                       , tmpContainer_Count.Amount
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   THEN MIContainer.MovementId
                                              ELSE 0
                                         END AS MovementId
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   THEN MIContainer.MovementItemId
                                              ELSE 0
                                         END AS MovementItemId
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Period
                                       , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                                       , MIContainer.isActive
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.PartionGoodsId
                                         , tmpContainer_Count.Amount
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementId
                                                ELSE 0
                                           END
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementItemId
                                                ELSE 0
                                           END
                                        , MIContainer.isActive
                                 )
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.LocationId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.GoodsKindId
                                    , tmpContainer_Count.PartionGoodsId
                                    , Container.Id AS ContainerId_Summ
                                    , Container.Amount
                               FROM tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = NULL -- tmpContainer_Count.ContainerId
                                                        AND Container.DescId = zc_Container_Summ()
                              )
                , tmpMI_Summ AS (SELECT tmpContainer_Summ.ContainerId_Count AS ContainerId
                                      , tmpContainer_Summ.LocationId
                                      , tmpContainer_Summ.GoodsId
                                      , tmpContainer_Summ.GoodsKindId
                                      , tmpContainer_Summ.PartionGoodsId
                                      , tmpContainer_Summ.Amount
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  THEN MIContainer.MovementId
                                             ELSE 0
                                        END AS MovementId
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  THEN MIContainer.MovementItemId
                                             ELSE 0
                                        END AS MovementItemId
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Period
                                      , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                                      , MIContainer.isActive
                                 FROM tmpContainer_Summ
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId_Summ
                                                                                    AND MIContainer.OperDate >= inStartDate
                                 GROUP BY tmpContainer_Summ.ContainerId_Count
                                        , tmpContainer_Summ.ContainerId_Summ
                                        , tmpContainer_Summ.LocationId
                                        , tmpContainer_Summ.GoodsId
                                        , tmpContainer_Summ.GoodsKindId
                                        , tmpContainer_Summ.PartionGoodsId
                                        , tmpContainer_Summ.Amount
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementId
                                               ELSE 0
                                          END
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementItemId
                                               ELSE 0
                                          END
                                        , MIContainer.isActive
                                )
   SELECT Movement.InvNumber
        , Movement.OperDate
        , MovementDate_OperDatePartner.ValueData AS OperDatePartner
        , MovementDesc.ItemName AS MovementDescName

        , ObjectDesc.ItemName            AS LocationDescName
        , Object_Location.ObjectCode     AS LocationCode
        , Object_Location.ValueData      AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_By.ObjectCode           AS ObjectByCode
        , Object_By.ValueData            AS ObjectByName

        , Object_PaidKind.ValueData AS PaidKindName

        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        , Object_GoodsKind.ValueData AS GoodsKindName
        , COALESCE (Object_PartionGoods.ValueData, '*' || DATE (MIDate_PartionGoods.ValueData) :: TVarChar) :: TVarChar AS PartionGoods

        , CAST (CASE WHEN tmpMIContainer_group.MovementId = -1 AND tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                     WHEN tmpMIContainer_group.MovementId = -2 AND tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd
                     WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummIn / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummOut / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS Price
        , CAST (tmpMIContainer_group.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpMIContainer_group.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpMIContainer_group.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpMIContainer_group.AmountEnd AS TFloat)   AS AmountEnd 

        , CAST (tmpMIContainer_group.SummStart AS TFloat)   AS SummStart
        , CAST (tmpMIContainer_group.SummIn AS TFloat)      AS SummIn
        , CAST (tmpMIContainer_group.SummOut AS TFloat)     AS SummOut
        , CAST (tmpMIContainer_group.SummEnd AS TFloat)     AS SummEnd 

   FROM (SELECT tmpMIContainer_all.MovementId
              , tmpMIContainer_all.MovementItemId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.isActive
              , SUM (tmpMIContainer_all.AmountStart) AS AmountStart
              , SUM (tmpMIContainer_all.AmountEnd)   AS AmountEnd
              , SUM (tmpMIContainer_all.AmountIn)    AS AmountIn
              , SUM (tmpMIContainer_all.AmountOut)   AS AmountOut
              , SUM (tmpMIContainer_all.SummStart)   AS SummStart
              , SUM (tmpMIContainer_all.SummEnd)     AS SummEnd
              , SUM (tmpMIContainer_all.SummIn)      AS SummIn
              , SUM (tmpMIContainer_all.SummOut)     AS SummOut
        FROM (SELECT -1 AS MovementId
                   , 0 AS MovementItemId
                   , tmpMI_Count.ContainerId
                   , tmpMI_Count.LocationId
                   , tmpMI_Count.GoodsId
                   , tmpMI_Count.GoodsKindId
                   , tmpMI_Count.PartionGoodsId
                   , TRUE AS isActive
                   , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total)                                   AS AmountStart
                   , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) + SUM (tmpMI_Count.Amount_Period) AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMI_Count
              GROUP BY tmpMI_Count.ContainerId
                     , tmpMI_Count.LocationId
                     , tmpMI_Count.GoodsId
                     , tmpMI_Count.GoodsKindId
                     , tmpMI_Count.PartionGoodsId
                     , tmpMI_Count.Amount
              HAVING tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) <> 0
                  OR SUM (tmpMI_Count.Amount_Period) <> 0
             UNION ALL
              SELECT tmpMI_Count.MovementId
                   , tmpMI_Count.MovementItemId
                   , tmpMI_Count.ContainerId
                   , tmpMI_Count.LocationId
                   , tmpMI_Count.GoodsId
                   , tmpMI_Count.GoodsKindId
                   , tmpMI_Count.PartionGoodsId
                   , tmpMI_Count.isActive
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN      tmpMI_Count.Amount_Period ELSE 0 END AS AmountIn
                   , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN -1 * tmpMI_Count.Amount_Period ELSE 0 END AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMI_Count
              WHERE tmpMI_Count.Amount_Period <> 0
             UNION ALL
              SELECT -1 AS MovementId
                   , 0 AS MovementItemId
                   , tmpMI_Summ.ContainerId
                   , tmpMI_Summ.LocationId
                   , tmpMI_Summ.GoodsId
                   , tmpMI_Summ.GoodsKindId
                   , tmpMI_Summ.PartionGoodsId
                   , TRUE AS isActive
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) AS SummStart
                   , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) + SUM (tmpMI_Summ.Amount_Period) AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMI_Summ
              GROUP BY tmpMI_Summ.ContainerId
                     , tmpMI_Summ.LocationId
                     , tmpMI_Summ.GoodsId
                     , tmpMI_Summ.GoodsKindId
                     , tmpMI_Summ.PartionGoodsId
                     , tmpMI_Summ.Amount
              HAVING tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) <> 0
                  OR SUM (tmpMI_Summ.Amount_Period) <> 0
             UNION ALL
              SELECT tmpMI_Summ.MovementId
                   , tmpMI_Summ.MovementItemId
                   , tmpMI_Summ.ContainerId
                   , tmpMI_Summ.LocationId
                   , tmpMI_Summ.GoodsId
                   , tmpMI_Summ.GoodsKindId
                   , tmpMI_Summ.PartionGoodsId
                   , tmpMI_Summ.isActive
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , CASE WHEN tmpMI_Summ.Amount_Period > 0 THEN      tmpMI_Summ.Amount_Period ELSE 0 END AS SummIn
                   , CASE WHEN tmpMI_Summ.Amount_Period < 0 THEN -1 * tmpMI_Summ.Amount_Period ELSE 0 END AS SummOut
              FROM tmpMI_Summ
              WHERE tmpMI_Summ.Amount_Period <> 0
             ) AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.MovementId
                , tmpMIContainer_all.MovementItemId
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.isActive
        ) AS tmpMIContainer_group
        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
        LEFT JOIN MovementLinkObject AS MovementLinkObject_By
                                     ON MovementLinkObject_By.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_By.DescId = CASE WHEN Movement.DescId = zc_Movement_Income() THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId = zc_Movement_Loss() THEN zc_MovementLinkObject_ArticleLoss()
                                                                            WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN zc_MovementLinkObject_To()
                                                                       END

        LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                   ON MIDate_PartionGoods.MovementItemId = tmpMIContainer_group.MovementItemId
                                  AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                               ON MovementDate_OperDatePartner.MovementId = tmpMIContainer_group.MovementId
                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_By ON Object_By.Id = MovementLinkObject_By.ObjectId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId

   ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 30.05.14                                        * ALL
 10.04.14                                        * ALL
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *  
*/

-- òåñò
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inLocationId:=0, inGoodsId:= 1826, inSession:= zfCalc_UserAdmin());
