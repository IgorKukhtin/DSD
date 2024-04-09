-- Function: gpSelect_Movement_Cost_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean   ,
    IN inisOnlyService Boolean ,
    IN inUnitId        Integer   ,
    IN inInfoMoneyId   Integer   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar, RouteName TVarChar
             , PersonalDriverName TVarChar
             --, UnitForwardingName TVarChar
             , UnitName TVarChar
             , BranchName TVarChar
             , StartRunPlan TDateTime, StartRun TDateTime
             , Comment TVarChar , DescId Integer, DescName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AmountCost TFloat, AmountMemberCost TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )


     , tmpTransport AS (SELECT Movement.Id AS MovementId
                             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                             , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                             , Movement.OperDate
                             , Movement.StatusId                             AS StatusId
                             , MovementLinkObject_PersonalDriver.ObjectId    AS PersonalDriverId
                             , MovementString_Comment.ValueData              AS Comment
                             , MovementLinkObject_Car.ObjectId               AS CarId  
                             , MovementItem.ObjectId                         AS RouteId
                             , MovementLinkObject_UnitForwarding.ObjectId    AS UnitId
                             , MovementDesc.Id                               AS DescId
                             , MovementDesc.ItemName                         AS DescName
                             , 0                                             AS InfoMoneyId
                        FROM tmpStatus
                            INNER JOIN Movement ON Movement.DescId = zc_Movement_Transport()
                                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                               AND Movement.StatusId = tmpStatus.StatusId
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
      
                            INNER JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                                          ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                                         AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                                                         -- AND (MovementLinkObject_UnitForwarding.ObjectId = inUnitId OR inUnitId = 0)
      
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                            LEFT JOIN MovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId =  Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
      
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased = False
                        WHERE inisOnlyService = FALSE
                       )
                  
     , tmpTransportService AS (SELECT Movement.Id AS MovementId
                                    , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                                    , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                                    , Movement.OperDate
                                    , Movement.StatusId                             AS StatusId
                                    , ObjectLink_Car_PersonalDriver.ChildObjectId   AS PersonalDriverId
                                    , MIString_Comment.ValueData                    AS Comment
                                    , MILinkObject_Car.ObjectId                     AS CarId  
                                    , MILinkObject_Route.ObjectId                   AS RouteId
                                    , MovementLinkObject_UnitForwarding.ObjectId    AS UnitId
                                    , MovementDesc.Id                               AS DescId
                                    , MovementDesc.ItemName                         AS DescName
                                    , MILinkObject_InfoMoney.ObjectId               AS InfoMoneyId
                               FROM tmpStatus
                                   INNER JOIN Movement ON Movement.DescId = zc_Movement_TransportService()
                                                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND Movement.StatusId = tmpStatus.StatusId
                                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                                                 ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                                                AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                                                                -- AND (MovementLinkObject_UnitForwarding.ObjectId = inUnitId OR inUnitId = 0)

                                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 

                                   LEFT JOIN MovementItemString AS MIString_Comment
                                                                ON MIString_Comment.MovementItemId = MovementItem.Id 
                                                               AND MIString_Comment.DescId = zc_MIString_Comment()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id 
                                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                    ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                                                   AND MILinkObject_Route.DescId = zc_MILinkObject_Route()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                                    ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                                                   AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

                                   LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                                        ON ObjectLink_Car_PersonalDriver.ObjectId = MILinkObject_Car.ObjectId
                                                       AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                               WHERE inisOnlyService = FALSE
                              )

     , tmpService AS (SELECT Movement.Id AS MovementId
                           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                           , Movement.OperDate                             AS OperDate
                           , Movement.StatusId                             AS StatusId
                           , MovementItem.ObjectId                         AS PersonalDriverId
                           , MIString_Comment.ValueData                    AS Comment
                           , 0                                             AS CarId  
                           , 0                                             AS RouteId
                           , MILinkObject_Unit.ObjectId                    AS UnitId
                           , MovementDesc.Id                               AS DescId
                           , MovementDesc.ItemName                         AS DescName
                           , MILinkObject_InfoMoney.ObjectId               AS InfoMoneyId
                      FROM tmpStatus
                          INNER JOIN Movement ON Movement.DescId = zc_Movement_Service()
                                             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                             AND Movement.StatusId = tmpStatus.StatusId
                          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                         
                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 

                          LEFT JOIN MovementItemString AS MIString_Comment
                                                       ON MIString_Comment.MovementItemId = MovementItem.Id 
                                                      AND MIString_Comment.DescId = zc_MIString_Comment()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id 
                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                      WHERE inisOnlyService = TRUE
                     )

     , tmpList AS  (SELECT tr1.MovementId, tr1.InvNumber, tr1.OperDate, tr1.PersonalDriverId, tr1.CarId, tr1.RouteId, tr1.Comment 
                         , zfFormat_BarCode (zc_BarCodePref_Movement(), tr1.MovementId) AS IdBarCode
                         , tr1.StatusId, tr1.InvNumber_Full, tr1.UnitId, tr1.DescId, tr1.DescName, tr1.InfoMoneyId
                    FROM tmpTransport AS tr1
                   UNION ALL
                    SELECT tr2.MovementId, tr2.InvNumber, tr2.OperDate, tr2.PersonalDriverId, tr2.CarId, tr2.RouteId, tr2.Comment 
                         , zfFormat_BarCode (zc_BarCodePref_Movement(), tr2.MovementId) AS IdBarCode
                         , tr2.StatusId, tr2.InvNumber_Full, tr2.UnitId, tr2.DescId, tr2.DescName, tr2.InfoMoneyId
                    FROM tmpTransportService AS tr2
                   UNION ALL
                    SELECT tr2.MovementId, tr2.InvNumber, tr2.OperDate, tr2.PersonalDriverId, tr2.CarId, tr2.RouteId, tr2.Comment 
                         , zfFormat_BarCode (zc_BarCodePref_Movement(), tr2.MovementId) AS IdBarCode
                         , tr2.StatusId, tr2.InvNumber_Full, tr2.UnitId, tr2.DescId, tr2.DescName, tr2.InfoMoneyId
                    FROM tmpService AS tr2
                    )


        -- РЕЗУЛЬТАТ                         
        SELECT tmpList.MovementId
             , tmpList.InvNumber
             , tmpList.InvNumber_Full
             , tmpList.OperDate 
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , Object_Car.Id                    AS CarId
             , Object_Car.ValueData             AS CarName
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_Route.ValueData           AS RouteName
             , Object_PersonalDriver.ValueData  AS PersonalDriverName
             , Object_Unit.ValueData            AS UnitName
             , Object_Branch.ValueData          AS BranchName
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun
             , tmpList.Comment
             , tmpList.DescId
             , tmpList.DescName
               
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

             , MovementFloat_AmountCost.ValueData       AS AmountCost
             , MovementFloat_AmountMemberCost.ValueData AS AmountMemberCost

        FROM tmpList
            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = tmpList.MovementId
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = tmpList.MovementId
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()

            LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                    ON MovementFloat_AmountCost.MovementId = tmpList.MovementId
                                   AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
            LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost
                                    ON MovementFloat_AmountMemberCost.MovementId = tmpList.MovementId
                                   AND MovementFloat_AmountMemberCost.DescId     = zc_MovementFloat_AmountMemberCost()

            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpList.CarId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                 ON ObjectLink_Car_Unit.ObjectId = tmpList.CarId
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
           
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel 
                                 ON ObjectLink_Car_CarModel.ObjectId = tmpList.CarId
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = tmpList.CarId
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
           
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = tmpList.PersonalDriverId
        
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpList.RouteId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpList.StatusId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpList.UnitId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpList.InfoMoneyId
            

      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.03.19         *
 10.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cost_Choice (inStartDate:= '01.09.2015'::TDateTime, inEndDate:= '01.09.2015'::TDateTime, inIsErased:= FALSE, inisOnlyService:= FALSE, inUnitId:=0, inInfoMoneyId :=0, inSession:= zfCalc_UserAdmin())
