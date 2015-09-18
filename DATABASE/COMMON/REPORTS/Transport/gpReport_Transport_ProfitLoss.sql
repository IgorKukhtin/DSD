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
RETURNS TABLE (Invnumber TVarChar, OperDate TDateTime
             , FuelName TVarChar
             , CarModelName TVarChar
             , CarName TVarChar
             , UnitName TVarChar
             , BusinessName TVarChar
             , BranchName TVarChar
             , RouteName TVarChar, RouteKindName TVarChar
             , PersonalDriverName TVarChar
             
             , SumCount TFloat, SumAmount TFloat, PriceFuel TFloat
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
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumCount
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount
                                , MIContainer.WhereObjectId_Analyzer AS CarId
                                , MIContainer.ObjectIntId_Analyzer   AS UnitId
                                , MIContainer.ObjectExtId_Analyzer   AS BranchId
  
                           FROM MovementItemContainer AS MIContainer
                          
                           WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                             AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService())
                             AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                             AND (MIContainer.ObjectExtId_Analyzer = inBranchId OR inBranchId = 0)  -- филиал
                             AND (MIContainer.ObjectIntId_Analyzer = inUnitId OR inUnitId = 0)      -- подразделение
                             AND (MIContainer.WhereObjectId_Analyzer = inCarId OR inCarId = 0)      -- Автомобиль
                             
                           GROUP BY  MIContainer.MovementId 
                                   , MIContainer.MovementItemId 
                                   , MIContainer.ObjectId_Analyzer
                                   , MIContainer.WhereObjectId_Analyzer 
                                   , MIContainer.ObjectIntId_Analyzer 
                                   , MIContainer.ObjectExtId_Analyzer)

       SELECT COALESCE (Movement.Invnumber, '') :: TVarChar          AS Invnumber
            , COALESCE (Movement.OperDate, CAST (NULL as TDateTime)) AS OperDate
            , Object_Fuel.ValueData            AS FuelName
            , Object_CarModel.ValueData        AS CarModelName
            , Object_Car.ValueData             AS CarName
            , Object_Unit_View.Name            AS UnitName
            , Object_Unit_View.BusinessName 
            , Object_Unit_View.BranchName
            , Object_Route.ValueData           AS RouteName
            , Object_RouteKind.ValueData       AS RouteKindName
            , Object_PersonalDriver.ValueData  AS PersonalDriverName
            , SUM (tmpAll.SumCount) :: Tfloat  AS SumCount 
            , SUM (tmpAll.SumAmount):: Tfloat  AS SumAmount
            , CASE WHEN SUM (tmpAll.SumCount)<>0 THEN CAST (SUM (tmpAll.SumAmount)/SUM (tmpAll.SumCount) AS NUMERIC (16, 4)) ELSE 0 END :: Tfloat  AS PriceFuel
       FROM
            (SELECT tmpContainer.MovementId -- CASE WHEN /*inisMovement*/TRUE = TRUE THEN tmpContainer.MovementId ELSE 0 END AS MovementId
                  , tmpContainer.FuelId
                  , tmpContainer.CarId
                  , tmpContainer.UnitId
                  , tmpContainer.BranchId
                  , SUM (tmpContainer.SumCount)                 AS SumCount 
                  , SUM (tmpContainer.SumAmount)                AS SumAmount
                  , MovementItem.ObjectId                       AS RouteId
                  , MILinkObject_RouteKind.ObjectId             AS RouteKindId
                  , MovementLinkObject_PersonalDriver.ObjectId  AS PersonalDriverId

             FROM tmpContainer
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                              ON MovementLinkObject_PersonalDriver.MovementId =tmpContainer.MovementId
                                             AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
         
                 LEFT JOIN MovementItem ON MovementItem.MovementId = tmpContainer.MovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                                       
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                  ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id 
                                                 AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
             GROUP BY tmpContainer.MovementId --CASE WHEN /*inisMovement*/TRUE = TRUE THEN tmpContainer.MovementId ELSE 0 END
                    , tmpContainer.FuelId
                    , tmpContainer.CarId
                    , tmpContainer.UnitId, tmpContainer.BranchId
                    , MovementItem.ObjectId , MILinkObject_RouteKind.ObjectId
                    , MovementLinkObject_PersonalDriver.ObjectId
       
             ) tmpAll 
                 LEFT JOIN Object AS Object_Route on Object_Route.Id = tmpAll.RouteId
                 LEFT JOIN Object_Unit_View  on Object_Unit_View.Id = tmpAll.UnitId
                 LEFT JOIN Object AS Object_PersonalDriver on Object_PersonalDriver.Id = tmpAll.PersonalDriverId
                 LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id =tmpAll.FuelId
                 LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpAll.CarId
                 LEFT JOIN Movement ON Movement.Id = tmpAll.MovementId
                                   AND inisMovement = TRUE 
                                   
                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
                 LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = tmpAll.RouteKindId
                                                
       WHERE (Object_Unit_View.BusinessId = inBusinessId OR inBusinessId=0)
       GROUP BY COALESCE (Movement.Invnumber, '') 
              , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
              , Object_Fuel.ValueData 
              , Object_Car.ValueData 
              , Object_Unit_View.Name
              , Object_Unit_View.BusinessName 
              , Object_Unit_View.BranchName
              , Object_Route.ValueData 
              , Object_PersonalDriver.ValueData
              , Object_CarModel.ValueData
              , Object_RouteKind.ValueData 
  
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
-- SELECT * FROM gpReport_Transport_ProfitLoss (inStartDate:= '13.08.2015', inEndDate:= '13.08.2015', inBusinessId:= 0, inBranchId:= 0, inUnitId:= 0, inCarId:= 0, inIsMovement:= true, inSession := zfCalc_UserAdmin()); -- Склад Реализации
