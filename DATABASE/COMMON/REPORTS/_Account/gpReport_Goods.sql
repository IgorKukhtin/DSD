-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inAccountId    Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber Integer, OperDate TDateTime, MovementDescName TVarChar

              , GoodsCode Integer, GoodsName TVarChar
 
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar

    

              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS GoodsId, Container.Amount
                          FROM (SELECT Id AS GoodsId FROM Object WHERE DescId = zc_Object_Goods()) AS tmpGoods 
                               JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                             AND Container.DescId = zc_Container_Count()
                         )


  select  tmp_All.InvNumber
        , tmp_All.OperDate
        , MovementDesc.ItemName as MovementDescName
        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        
        , Object_CarModel.ValueData AS CarModelName
        , Object_Car.ObjectCode     AS CarCode
        , Object_Car.ValueData      AS CarName
        
        , tmp_All.SummStart
        , tmp_All.SummIn
        , tmp_All.SummOut
        , tmp_All.SummEnd 
  from (
       select  ContainerLO_Car.ObjectId as CarId
            , tmpContainer_All.ContainerId
            , tmpContainer_All.GoodsId
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
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate >'2013.01.04' THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementDescId
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , '' AS InvNumber

             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= '2013.01.01'
                                                                
             GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId, tmpContainer.Amount
             
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > '2013.01.04' THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)

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
                         , case when MIContainer.isactive = true then MIContainer.Amount else 0 end AS SummIn
                         , case when MIContainer.isactive = false then MIContainer.Amount else 0 end AS SummOut
                         , MIContainer.MovementId            
                    FROM tmpContainer
                     
                        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                      AND MIContainer.OperDate between  '2013.01.01' and '2013.01.04'

                   ) AS tmpMIContainer

            LEFT JOIN Movement ON Movement.Id = tmpMIContainer.MovementId         
              
            GROUP BY tmpMIContainer.ContainerId
                   , tmpMIContainer.GoodsId
                   , Movement.DescId
                   , tmpMIContainer.MovementId 
                   , Movement.OperDate
                   , Movement.InvNumber

    ) as tmpContainer_All
         
    LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpContainer_All.ContainerId
                                                            AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
 
    GROUP BY  ContainerLO_Car.ObjectId
            , tmpContainer_All.ContainerId
            , tmpContainer_All.GoodsId
            , tmpContainer_All.MovementDescId
            , tmpContainer_All.MovementId 
            , tmpContainer_All.OperDate
            , tmpContainer_All.InvNumber

    ) as tmp_All

      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp_All.GoodsId
      LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmp_All.CarId

      LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
      LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
      
      LEFT JOIN MovementDesc ON MovementDesc.Id = tmp_All.MovementDescId


    ;
    
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Goods (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.11.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.10.2013', inEndDate:= '31.10.2013', inAccountId:= null, inSession:= zfCalc_UserAdmin());
