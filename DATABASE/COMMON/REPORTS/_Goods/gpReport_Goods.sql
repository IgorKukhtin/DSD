-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inGoodsId    Integer   ,
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE  (InvNumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Unit_infCode Integer, Unit_infName TVarChar
              , DirectionCode Integer, DirectionName TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS GoodsId, Container.Amount
                          FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods 
                               JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                             AND Container.DescId = zc_Container_Count()
                         )


  select  CAST(tmp_All.InvNumber AS TVarChar) AS InvNumber
        , tmp_All.OperDate        AS OperDate
        
        , MovementDesc.ItemName   AS MovementDescName
        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        , Object_GoodsKind.ValueData AS GoodsKindName
        
        , Object_Unit_inf.ObjectCode     AS Unit_infCode
        , Object_Unit_inf.ValueData      AS Unit_infName
       
        , Object_Direction.ObjectCode     AS DirectionCode
        , Object_Direction.ValueData      AS DirectionName

                
        , CAST (SUM (tmp_All.SummStart) AS TFloat) AS SummStart
        , CAST (SUM (tmp_All.SummIn) AS TFloat)    AS SummIn
        , CAST (SUM (tmp_All.SummOut) AS TFloat)   AS SummOut
        , CAST (SUM (tmp_All.SummEnd) AS TFloat)   AS SummEnd 
  from (
       select  COALESCE(ContainerLO_Car.ObjectId, COALESCE(ContainerLO_Unit.ObjectId, ContainerLO_Member.ObjectId)) AS DirectionId
             , tmpContainer_All.ContainerId
             , tmpContainer_All.GoodsId
             , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
             , tmpContainer_All.MovementDescId
             , tmpContainer_All.MovementId 
             , tmpContainer_All.OperDate
             , tmpContainer_All.InvNumber
             , SUM (tmpContainer_All.SummStart) AS SummStart
             , SUM (tmpContainer_All.SummEnd) AS SummEnd
             , SUM (tmpContainer_All.SummIn)  AS SummIn
             , SUM (tmpContainer_All.SummOut) AS SummOut
       
       from (SELECT tmpContainer.ContainerId
                  , tmpContainer.GoodsId
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate >inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementDescId
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , '' AS InvNumber

             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= inStartDate
                                                                
             GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId, tmpContainer.Amount
             
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)

          union all
             select 
                    tmpMIContainer.ContainerId
                  , tmpMIContainer.GoodsId
                  , 0 AS SummStart
                  , 0 AS SummEnd
                  , SUM (tmpMIContainer.SummIn)  AS SummIn
                  , SUM (tmpMIContainer.SummOut) AS SummOut
                  , Movement.DescId AS MovementDescId
                  , tmpMIContainer.MovementId 
                  , Movement.OperDate
                  , Movement.InvNumber
                  
             from ( SELECT tmpContainer.ContainerId
                         , tmpContainer.GoodsId
                         , 0 AS SummStart
                         , 0 AS SummEnd
                         --, case when MIContainer.isactive = true then COALESCE(MIContainer.Amount,0) else 0 end AS SummIn
                         --, case when MIContainer.isactive = false then COALESCE(MIContainer.Amount,0) else 0 end AS SummOut
                         , case when COALESCE(MIContainer.Amount,0) >= 0 then COALESCE(MIContainer.Amount,0) else 0 end AS SummIn
                         , case when COALESCE(MIContainer.Amount,0) < 0  then COALESCE(MIContainer.Amount,0)*(-1) else 0 end AS SummOut
                         
                         , MIContainer.MovementId            
                    FROM tmpContainer
                     
                        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                      AND MIContainer.OperDate between  inStartDate and inEndDate

                   ) AS tmpMIContainer

            LEFT JOIN Movement ON Movement.Id = tmpMIContainer.MovementId         
              
            GROUP BY tmpMIContainer.ContainerId
                   , tmpMIContainer.GoodsId
                   , Movement.DescId
                   , tmpMIContainer.MovementId 
                   , Movement.OperDate
                   , Movement.InvNumber

    ) AS tmpContainer_All
         
    LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpContainer_All.ContainerId
                                                    AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
    LEFT JOIN ContainerLinkObject AS ContainerLO_Unit ON ContainerLO_Unit.ContainerId = tmpContainer_All.ContainerId
                                                     AND ContainerLO_Unit.DescId = zc_ContainerLinkObject_Unit()                                                          
    LEFT JOIN ContainerLinkObject AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpContainer_All.ContainerId
                                                       AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
    LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind ON ContainerLO_GoodsKind.ContainerId = tmpContainer_All.ContainerId
                                                          AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()                                                     
                                                          
    GROUP BY  COALESCE(ContainerLO_Car.ObjectId, COALESCE(ContainerLO_Unit.ObjectId, ContainerLO_Member.ObjectId))
            , tmpContainer_All.ContainerId
            , tmpContainer_All.GoodsId
            , tmpContainer_All.MovementDescId
            , tmpContainer_All.MovementId 
            , tmpContainer_All.OperDate
            , tmpContainer_All.InvNumber
            , ContainerLO_GoodsKind.ObjectId

    ) AS tmp_All

     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp_All.GoodsId

     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp_All.GoodsKindId

     LEFT JOIN MovementDesc ON MovementDesc.Id = tmp_All.MovementDescId

     LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmp_All.DirectionId

     LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmp_All.DirectionId
                                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
     LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit ON ObjectLink_Personal_Unit.ObjectId = tmp_All.DirectionId
                                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
     LEFT JOIN Object AS Object_Unit_inf on Object_Unit_inf.Id = COALESCE (ObjectLink_Car_Unit.ChildObjectId, ObjectLink_Personal_Unit.ChildObjectId)

   GROUP BY tmp_All.InvNumber
        , tmp_All.OperDate
        , MovementDesc.ItemName
        , Object_Goods.ObjectCode
        , Object_Goods.ValueData
        , Object_Unit_inf.ObjectCode
        , Object_Unit_inf.ValueData 
        , Object_Direction.ObjectCode
        , Object_Direction.ValueData
        , Object_GoodsKind.ValueData
        
   ORDER BY Object_Direction.ValueData
          , MovementDesc.ItemName
          , tmp_All.OperDate
          , tmp_All.InvNumber
          
 ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Goods (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *  
*/

-- òåñò
--SELECT * FROM gpReport_Goods (inStartDate:= '01.12.2013', inEndDate:= '01.12.2013', inGoodsId:= 1826, inSession:= zfCalc_UserAdmin());
