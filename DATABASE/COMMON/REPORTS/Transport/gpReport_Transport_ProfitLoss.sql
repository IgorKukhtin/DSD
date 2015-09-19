-- Function: gpReport_Transport_ProfitLoss ()

DROP FUNCTION IF EXISTS gpReport_Transport_ProfitLoss (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport_ProfitLoss (
    IN inStartDate        TDateTime ,  
    IN inEndDate          TDateTime ,
    IN inBusinessId       Integer   ,
    IN inBranchId         Integer   ,
    IN inUnitId           Integer   ,
    IN inCarId            Integer   ,
    IN inIsMovement       Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (Invnumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
             , FuelName TVarChar, CarModelName TVarChar, CarName TVarChar
             , RouteName TVarChar, PersonalDriverName TVarChar
             , UnitName TVarChar, BranchName TVarChar,  BusinessName TVarChar
             , ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName TVarChar, ProfitLossName_all TVarChar
             , SumCount_Transport TFloat, SumAmount_Transport TFloat, PriceFuel TFloat
             , SumAmount_TransportService TFloat, SumAmount_PersonalSendCash TFloat
             , SumTotal TFloat
             )   
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);

      vbIsGroup:= (inSession = '');

    -- Результат
    RETURN QUERY
    WITH tmpContainer AS  (SELECT MIContainer.MovementId AS MovementId
                                , MIContainer.ObjectId_Analyzer AS FuelId
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Transport()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumCount_Transport
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_Transport
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportService
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_PersonalSendCash()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_PersonalSendCash
                                , MIContainer.WhereObjectId_Analyzer          AS CarId
                                , MIContainer.ObjectIntId_Analyzer            AS UnitId
                                , MIContainer.ObjectExtId_Analyzer            AS BranchId
                                , MovementLinkObject_PersonalDriver.ObjectId  AS PersonalDriverId
                                , MILinkObject_Route.ObjectId                 AS RouteId
                                , CLO_ProfitLoss.ObjectId                     AS ProfitLossId
                                , CLO_Business.ObjectId                       AS BusinessId
                           FROM MovementItemContainer AS MIContainer
                                LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                              ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId_Analyzer
                                                             AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()   
                                LEFT JOIN ContainerLinkObject AS CLO_Business
                                                              ON CLO_Business.ContainerId = MIContainer.ContainerId
                                                             AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                           
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                             ON MovementLinkObject_PersonalDriver.MovementId =MIContainer.MovementId
                                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
         
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                 ON MILinkObject_Route.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                                
                           WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                             AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService(),zc_Movement_PersonalSendCash())
                             AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                             AND (MIContainer.ObjectExtId_Analyzer = inBranchId OR inBranchId = 0)  -- филиал
                             AND (MIContainer.ObjectIntId_Analyzer = inUnitId OR inUnitId = 0)      -- подразделение
                             AND (MIContainer.WhereObjectId_Analyzer = inCarId OR inCarId = 0)      -- Автомобиль
                             AND (CLO_Business.ObjectId = inBusinessId OR inBusinessId= 0)          -- Бизнес  
                             
                           GROUP BY  MIContainer.MovementId 
                                   , MIContainer.ObjectId_Analyzer
                                   , MIContainer.WhereObjectId_Analyzer 
                                   , MIContainer.ObjectIntId_Analyzer 
                                   , MIContainer.ObjectExtId_Analyzer
                                   , MILinkObject_Route.ObjectId           
                                   , CLO_ProfitLoss.ObjectId , CLO_Business.ObjectId 
                                   , MovementLinkObject_PersonalDriver.ObjectId      
                          )

       SELECT COALESCE (Movement.Invnumber, '') :: TVarChar          AS Invnumber
            , COALESCE (Movement.OperDate, CAST (NULL as TDateTime)) AS OperDate
            , COALESCE (MovementDesc.ItemName, '') :: TVarChar       AS MovementDescName
            , Object_Fuel.ValueData            AS FuelName
            , Object_CarModel.ValueData        AS CarModelName
            , Object_Car.ValueData             AS CarName
            , Object_Route.ValueData           AS RouteName
            , Object_PersonalDriver.ValueData  AS PersonalDriverName
            , Object_Unit_View.Name            AS UnitName
            , Object_Unit_View.BranchName
            , Object_Business.ValueData        AS BusinessName 
            , View_ProfitLoss.ProfitLossGroupName
            , View_ProfitLoss.ProfitLossDirectionName
            , View_ProfitLoss.ProfitLossName
            , View_ProfitLoss.ProfitLossName_all
                        
            , SUM (tmpContainer.SumCount_Transport) :: Tfloat  AS SumCount_Transport 
            , SUM (tmpContainer.SumAmount_Transport):: Tfloat  AS SumAmount_Transport
            , CASE WHEN SUM (tmpContainer.SumCount_Transport)<>0 THEN CAST (SUM (tmpContainer.SumAmount_Transport)/SUM (tmpContainer.SumCount_Transport) AS NUMERIC (16, 4)) ELSE 0 END :: Tfloat  AS PriceFuel
            , SUM (tmpContainer.SumAmount_TransportService):: Tfloat  AS SumAmount_TransportService
            , SUM (tmpContainer.SumAmount_PersonalSendCash):: Tfloat  AS SumAmount_PersonalSendCash
            , SUM (tmpContainer.SumAmount_Transport + tmpContainer.SumAmount_TransportService + tmpContainer.SumAmount_PersonalSendCash) :: Tfloat  AS SumTotal
       FROM tmpContainer
                 LEFT JOIN Object AS Object_Route on Object_Route.Id = tmpContainer.RouteId
                 LEFT JOIN Object_Unit_View  on Object_Unit_View.Id = tmpContainer.UnitId
                 LEFT JOIN Object AS Object_PersonalDriver on Object_PersonalDriver.Id = tmpContainer.PersonalDriverId
                 LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpContainer.FuelId
                 LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpContainer.CarId
                 LEFT JOIN Movement ON Movement.Id = tmpContainer.MovementId
                                   AND inisMovement = TRUE 
                 LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId                
                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
                 LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmpContainer.ProfitLossId
                 LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpContainer.BusinessId                               
                 
       GROUP BY COALESCE (Movement.Invnumber, '') , COALESCE (MovementDesc.ItemName, '')
              , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
              , Object_Fuel.ValueData 
              , Object_Car.ValueData 
              , Object_Unit_View.Name
              , Object_Unit_View.BusinessName 
              , Object_Unit_View.BranchName
              , Object_Route.ValueData 
              , Object_PersonalDriver.ValueData
              , Object_CarModel.ValueData
              , Object_Business.ValueData 
              , View_ProfitLoss.ProfitLossGroupName
              , View_ProfitLoss.ProfitLossDirectionName
              , View_ProfitLoss.ProfitLossName
              , View_ProfitLoss.ProfitLossName_all
            
       ORDER BY Object_Unit_View.BusinessName
              , Object_Unit_View.BranchName
              , Object_Unit_View.Name
              , COALESCE (Movement.Invnumber, '') 
              , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
              , Object_Car.ValueData 
              , Object_Fuel.ValueData 
              , Object_Route.ValueData 
              
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.09.15         * 
 
*/

-- тест
--SELECT * FROM gpReport_Transport_ProfitLoss (inStartDate:= '13.08.2015', inEndDate:= '13.08.2015', inBusinessId:= 0, inBranchId:= 0, inUnitId:= 0, inCarId:= 0, inIsMovement:= true, inSession := zfCalc_UserAdmin()); -- Склад Реализации
