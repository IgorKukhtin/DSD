-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDirectionId  Integer   , 
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE  (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar
              , DirectionDescName TVarChar, DirectionCode Integer, DirectionName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
               )  
AS
$BODY$
BEGIN

    RETURN QUERY

    WITH tmpContainer_Count AS (SELECT Container.Id AS ContainerId
                                     , COALESCE (CLO_Unit.ObjectId, COALESCE (CLO_Car.ObjectId, COALESCE (CLO_Member.ObjectId, 0))) AS DirectionId
                                     , Container.ObjectId AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
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
                                WHERE CLO_Unit.ObjectId = inDirectionId
                                   OR CLO_Car.ObjectId = inDirectionId
                                   OR CLO_Member.ObjectId = inDirectionId
                                   OR COALESCE (inDirectionId, 0) = 0
                               )
       , tmpMIContainer_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.DirectionId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
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
                                       , SUM (MIContainer.Amount) AS Amount_Total
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.DirectionId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementId
                                                ELSE 0
                                           END
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementItemId
                                                ELSE 0
                                           END
                                 )
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.DirectionId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.GoodsKindId
                                    , Container.Id AS ContainerId_Summ
                                    , Container.Amount
                               FROM tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                        AND Container.DescId = zc_Container_Summ()
                              )
       , tmpMIContainer_Summ AS (SELECT tmpContainer_Summ.ContainerId_Count AS ContainerId
                                      , tmpContainer_Summ.DirectionId
                                      , tmpContainer_Summ.GoodsId
                                      , tmpContainer_Summ.GoodsKindId
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
                                      , SUM (MIContainer.Amount) AS Amount_Total
                                 FROM tmpContainer_Summ
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId_Summ
                                                                                    AND MIContainer.OperDate >= inStartDate
                                 GROUP BY tmpContainer_Summ.ContainerId_Count
                                        , tmpContainer_Summ.DirectionId
                                        , tmpContainer_Summ.GoodsId
                                        , tmpContainer_Summ.GoodsKindId
                                        , tmpContainer_Summ.Amount
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementId
                                               ELSE 0
                                          END
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementItemId
                                               ELSE 0
                                          END
                                )
   SELECT Movement.InvNumber
        , Movement.OperDate
        , MovementDate_OperDatePartner.ValueData AS OperDatePartner
        , MovementDesc.ItemName AS MovementDescName

        , ObjectDesc.ItemName            AS DirectionDescName
        , Object_Direction.ObjectCode    AS DirectionCode
        , Object_Direction.ValueData     AS DirectionName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_By.ObjectCode           AS ObjectByCode
        , Object_By.ValueData            AS ObjectByName

        , Object_PaidKind.ValueData AS PaidKindName

        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        , Object_GoodsKind.ValueData AS GoodsKindName

        , CAST (CASE WHEN tmpMIContainer_group.MovementId = -1 AND tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                     WHEN tmpMIContainer_group.MovementId = -2 AND tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountEnd
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
              , tmpMIContainer_all.DirectionId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
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
                   , tmpMIContainer_Count.ContainerId
                   , tmpMIContainer_Count.DirectionId
                   , tmpMIContainer_Count.GoodsId
                   , tmpMIContainer_Count.GoodsKindId
                   , tmpMIContainer_Count.Amount - SUM (tmpMIContainer_Count.Amount_Total) AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMIContainer_Count
              GROUP BY tmpMIContainer_Count.ContainerId
                     , tmpMIContainer_Count.DirectionId
                     , tmpMIContainer_Count.GoodsId
                     , tmpMIContainer_Count.GoodsKindId
                     , tmpMIContainer_Count.Amount
              HAVING tmpMIContainer_Count.Amount - SUM (tmpMIContainer_Count.Amount_Total) <> 0
                  OR SUM (tmpMIContainer_Count.Amount_Period) <> 0
             UNION ALL
              SELECT -2 AS MovementId
                   , 0 AS MovementItemId
                   , tmpMIContainer_Count.ContainerId
                   , tmpMIContainer_Count.DirectionId
                   , tmpMIContainer_Count.GoodsId
                   , tmpMIContainer_Count.GoodsKindId
                   , 0 AS AmountStart
                   , tmpMIContainer_Count.Amount - SUM (tmpMIContainer_Count.Amount_Total) + SUM (tmpMIContainer_Count.Amount_Period) AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMIContainer_Count
              GROUP BY tmpMIContainer_Count.ContainerId
                     , tmpMIContainer_Count.DirectionId
                     , tmpMIContainer_Count.GoodsId
                     , tmpMIContainer_Count.GoodsKindId
                     , tmpMIContainer_Count.Amount
              HAVING tmpMIContainer_Count.Amount - SUM (tmpMIContainer_Count.Amount_Total) <> 0
                  OR SUM (tmpMIContainer_Count.Amount_Period) <> 0
             UNION ALL
              SELECT tmpMIContainer_Count.MovementId
                   , tmpMIContainer_Count.MovementItemId
                   , tmpMIContainer_Count.ContainerId
                   , tmpMIContainer_Count.DirectionId
                   , tmpMIContainer_Count.GoodsId
                   , tmpMIContainer_Count.GoodsKindId
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , CASE WHEN tmpMIContainer_Count.Amount_Period > 0 THEN tmpMIContainer_Count.Amount_Period ELSE 0 END AS AmountIn
                   , CASE WHEN tmpMIContainer_Count.Amount_Period < 0 THEN -1 * tmpMIContainer_Count.Amount_Period ELSE 0 END AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMIContainer_Count
             UNION ALL
              SELECT -1 AS MovementId
                   , 0 AS MovementItemId
                   , tmpMIContainer_Summ.ContainerId
                   , tmpMIContainer_Summ.DirectionId
                   , tmpMIContainer_Summ.GoodsId
                   , tmpMIContainer_Summ.GoodsKindId
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , tmpMIContainer_Summ.Amount - SUM (tmpMIContainer_Summ.Amount_Total) AS SummStart
                   , 0 AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMIContainer_Summ
              GROUP BY tmpMIContainer_Summ.ContainerId
                     , tmpMIContainer_Summ.DirectionId
                     , tmpMIContainer_Summ.GoodsId
                     , tmpMIContainer_Summ.GoodsKindId
                     , tmpMIContainer_Summ.Amount
              HAVING tmpMIContainer_Summ.Amount - SUM (tmpMIContainer_Summ.Amount_Total) <> 0
                  OR SUM (tmpMIContainer_Summ.Amount_Period) <> 0
             UNION ALL
              SELECT -2 AS MovementId
                   , 0 AS MovementItemId
                   , tmpMIContainer_Summ.ContainerId
                   , tmpMIContainer_Summ.DirectionId
                   , tmpMIContainer_Summ.GoodsId
                   , tmpMIContainer_Summ.GoodsKindId
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , tmpMIContainer_Summ.Amount - SUM (tmpMIContainer_Summ.Amount_Total) + SUM (tmpMIContainer_Summ.Amount_Period) AS SummEnd
                   , 0 AS SummIn
                   , 0 AS SummOut
              FROM tmpMIContainer_Summ
              GROUP BY tmpMIContainer_Summ.ContainerId
                     , tmpMIContainer_Summ.DirectionId
                     , tmpMIContainer_Summ.GoodsId
                     , tmpMIContainer_Summ.GoodsKindId
                     , tmpMIContainer_Summ.Amount
              HAVING tmpMIContainer_Summ.Amount - SUM (tmpMIContainer_Summ.Amount_Total) <> 0
                  OR SUM (tmpMIContainer_Summ.Amount_Period) <> 0
             UNION ALL
              SELECT tmpMIContainer_Summ.MovementId
                   , tmpMIContainer_Summ.MovementItemId
                   , tmpMIContainer_Summ.ContainerId
                   , tmpMIContainer_Summ.DirectionId
                   , tmpMIContainer_Summ.GoodsId
                   , tmpMIContainer_Summ.GoodsKindId
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummStart
                   , 0 AS SummEnd
                   , CASE WHEN tmpMIContainer_Summ.Amount_Period > 0 THEN tmpMIContainer_Summ.Amount_Period ELSE 0 END AS SummIn
                   , CASE WHEN tmpMIContainer_Summ.Amount_Period < 0 THEN -1 * tmpMIContainer_Summ.Amount_Period ELSE 0 END AS SummOut
              FROM tmpMIContainer_Summ
             ) AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.MovementId
                , tmpMIContainer_all.MovementItemId
                , tmpMIContainer_all.DirectionId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
        ) AS tmpMIContainer_group
        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
        LEFT JOIN MovementLinkObject AS MovementLinkObject_By
                                     ON MovementLinkObject_By.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_By.DescId = CASE WHEN Movement.DescId = zc_Movement_Income() THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                       END

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                               ON MovementDate_OperDatePartner.MovementId = tmpMIContainer_group.MovementId
                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Direction_find ON Object_Direction_find.Id = tmpMIContainer_group.DirectionId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Direction_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.DirectionId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = CASE WHEN Object_Direction_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.DirectionId END
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Direction_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.DirectionId END
        LEFT JOIN Object AS Object_By ON Object_By.Id = MovementLinkObject_By.ObjectId

   ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.14                                        * ALL
 10.04.14                                        * ALL
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *  
*/

-- ����
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDirectionId:=0, inGoodsId:= 1826, inSession:= zfCalc_UserAdmin());
