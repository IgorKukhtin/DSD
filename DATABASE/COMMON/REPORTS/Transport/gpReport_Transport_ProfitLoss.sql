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
             , FuelName TVarChar, CarModelName TVarChar, CarName TVarChar--, FuelMasterName TVarChar
             , RouteName TVarChar, PersonalDriverName TVarChar
             , UnitName TVarChar, BranchName TVarChar,  BusinessName TVarChar
             , ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName TVarChar, ProfitLossName_all TVarChar
             , SumCount_Transport TFloat, SumAmount_Transport TFloat, PriceFuel TFloat
             , SumAmount_TransportService TFloat, SumAmount_PersonalSendCash TFloat
             , SumTotal TFloat
             , Distance TFloat
             , WeightTransport TFloat, WeightSale TFloat
             ,One_KM TFloat, One_KG TFloat
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
    WITH tmpMIContainer AS  (SELECT MIContainer.MovementId               AS MovementId
                                , MIContainer.MovementDescId           AS MovementDescId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS FuelId
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Transport()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumCount_Transport
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_Transport
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportService
                                , SUM (CASE WHEN (MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_PersonalSendCash()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_PersonalSendCash
                                , MIContainer.WhereObjectId_Analyzer          AS CarId
                                , MIContainer.ObjectIntId_Analyzer            AS UnitId
                                , MIContainer.ObjectExtId_Analyzer            AS BranchId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END AS PersonalDriverId
                                , MILinkObject_Route.ObjectId                 AS RouteId
                                , CLO_ProfitLoss.ObjectId                     AS ProfitLossId
                                , CLO_Business.ObjectId                       AS BusinessId
                               
                           FROM MovementItemContainer AS MIContainer
                                JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                              ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId_Analyzer
                                                             AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()   
                                LEFT JOIN ContainerLinkObject AS CLO_Business
                                                              ON CLO_Business.ContainerId = MIContainer.ContainerId_Analyzer
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
                             
                           GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                   , MIContainer.ObjectId_Analyzer
                                   , MIContainer.WhereObjectId_Analyzer 
                                   , MIContainer.ObjectIntId_Analyzer 
                                   , MIContainer.ObjectExtId_Analyzer
                                   , MILinkObject_Route.ObjectId           
                                   , CLO_ProfitLoss.ObjectId , CLO_Business.ObjectId 
                                   , MovementLinkObject_PersonalDriver.ObjectId      
                          )
     , tmpContainer AS (SELECT tmpContainer.MovementId               
                                , tmpContainer.MovementDescId           
                                , tmpContainer.FuelId
                                , tmpContainer.SumCount_Transport
                                , tmpContainer.SumAmount_Transport
                                , tmpContainer.SumAmount_TransportService
                                , tmpContainer.SumAmount_PersonalSendCash
                                , tmpContainer.CarId
                                , tmpContainer.UnitId
                                , tmpContainer.BranchId
                                , tmpContainer.PersonalDriverId
                                , tmpContainer.RouteId
                                , tmpContainer.ProfitLossId
                                , tmpContainer.BusinessId
                   
                                , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_TransportService() THEN MIFloat_Distance.ValueData
                                       WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN (MovementItem.Amount + COALESCE(MIFloat_Distance.ValueData,0))
                                       ELSE 0 END)   AS Distance
                                , SUM (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN MIFloat_WeightTransport.ValueData ELSE 0 END)  AS WeightTransport
                                
                           FROM tmpMIContainer AS tmpContainer
                            LEFT JOIN MovementItem ON MovementItem.MovementId = tmpContainer.MovementId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = False
                                                    
                                  LEFT JOIN MovementItemFloat AS MIFloat_Distance
                                                            ON MIFloat_Distance.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Distance.DescId = CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN zc_MIFloat_DistanceFuelChild()
                                                                                              WHEN tmpContainer.MovementDescId = zc_Movement_TransportService() THEN zc_MIFloat_Distance() END

                                LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                            ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                           AND MIFloat_WeightTransport.DescId = zc_MIFloat_Weight()--zc_MIFloat_WeightTransport()

                                group by tmpContainer.MovementId               
                                , tmpContainer.MovementDescId           
                                , tmpContainer.FuelId
                                , tmpContainer.SumCount_Transport
                                , tmpContainer.SumAmount_Transport
                                , tmpContainer.SumAmount_TransportService
                                , tmpContainer.SumAmount_PersonalSendCash
                                , tmpContainer.CarId
                                , tmpContainer.UnitId
                                , tmpContainer.BranchId
                                , tmpContainer.PersonalDriverId
                                , tmpContainer.RouteId
                                , tmpContainer.ProfitLossId
                                , tmpContainer.BusinessId
                         )

   , tmpWeight       AS ( SELECT MLM_Transport.MovementChildId                  AS MovementTransportId
                               , SUM (MovementFloat_TotalCountKg.ValueData)     AS TotalCountKg
                          FROM MovementLinkMovement AS MLM_Transport
                               JOIN Movement ON Movement.Id = MLM_Transport.MovementId 
                                            AND Movement.DescId in (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                            AND Movement.StatusId = zc_Enum_Status_Complete()

                               LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

                          WHERE MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                            AND MLM_Transport.MovementChildId in (SELECT tmpContainer.MovementId FROM tmpContainer)
                          GROUP BY MLM_Transport.MovementChildId
                         )
                         
       SELECT COALESCE (Movement.Invnumber, '') :: TVarChar          AS Invnumber
            , COALESCE (Movement.OperDate, CAST (NULL as TDateTime)) AS OperDate
            , COALESCE (MovementDesc.ItemName, '') :: TVarChar       AS MovementDescName
            , COALESCE (Object_Fuel.ValueData, Object_FuelMaster.ValueData)    :: TVarChar         AS FuelName
            , Object_CarModel.ValueData        AS CarModelName
            , Object_Car.ValueData             AS CarName
           -- , CASE WHEN tmpContainer.MovementDescId in (zc_Movement_TransportService(),zc_Movement_PersonalSendCash()) THEN Object_FuelMaster.ValueData ELSE '' END :: TVarChar   AS FuelMasterName
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

            , SUM (tmpContainer.Distance):: Tfloat         AS Distance
            , SUM (tmpContainer.WeightTransport):: Tfloat  AS WeightTransport
            , SUM (tmpWeight.TotalCountKg):: Tfloat        AS WeightSale
            , CAST (CASE WHEN SUM (tmpContainer.Distance) <> 0 THEN  SUM (tmpContainer.SumAmount_Transport + tmpContainer.SumAmount_TransportService + tmpContainer.SumAmount_PersonalSendCash)/SUM (tmpContainer.Distance) 

                         ELSE 0 END  AS Tfloat)  AS One_KM
            , CAST (CASE WHEN SUM (tmpContainer.WeightTransport) <> 0 THEN  SUM (tmpContainer.SumAmount_Transport + tmpContainer.SumAmount_TransportService + tmpContainer.SumAmount_PersonalSendCash)/SUM (tmpContainer.WeightTransport)
                         ELSE 0 END AS Tfloat)  AS One_KG
       FROM tmpContainer
                 LEFT JOIN Object AS Object_Route on Object_Route.Id = tmpContainer.RouteId
                 LEFT JOIN Object_Unit_View  on Object_Unit_View.Id = tmpContainer.UnitId
                 LEFT JOIN Object AS Object_PersonalDriver on Object_PersonalDriver.Id = tmpContainer.PersonalDriverId
                 LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpContainer.FuelId

                 LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpContainer.CarId

                 LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster 
                                      ON ObjectLink_Car_FuelMaster.ObjectId = Object_Car.Id
                                     AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
                 LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId
 
                 LEFT JOIN Movement ON Movement.Id = tmpContainer.MovementId
                                   AND inisMovement = TRUE 
                                   
                 LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId                
                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
                 LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmpContainer.ProfitLossId
                 LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpContainer.BusinessId                               
                 LEFT JOIN tmpWeight ON tmpWeight.MovementTransportId = tmpContainer.MovementId

       GROUP BY COALESCE (Movement.Invnumber, '') , COALESCE (MovementDesc.ItemName, '')
              , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
              , Object_Fuel.ValueData 
              , Object_FuelMaster.ValueData
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
             -- , CASE WHEN tmpContainer.MovementDescId in (zc_Movement_TransportService(),zc_Movement_PersonalSendCash()) THEN Object_FuelMaster.ValueData ELSE '' END
            
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
--SELECT * FROM gpReport_Transport_ProfitLoss (inStartDate:= '31.07.2015', inEndDate:= '13.08.2015', inBusinessId:= 0, inBranchId:= 0, inUnitId:= 0, inCarId:= 0, inIsMovement:= true, inSession := zfCalc_UserAdmin()); -- Склад Реализации
