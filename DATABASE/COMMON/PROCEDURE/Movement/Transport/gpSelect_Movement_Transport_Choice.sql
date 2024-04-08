-- Function: gpSelect_Movement_TransportChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Transport_Choice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Transport_Choice(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar, RouteName TVarChar
             , PersonalDriverId Integer
             , PersonalDriverName TVarChar
             , PersonalName TVarChar
             , UnitForwardingName TVarChar
             , BranchName TVarChar
             , StartRunPlan TDateTime, StartRun TDateTime
             , Comment TVarChar 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
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
                              , MovementLinkObject_Personal.ObjectId          AS PersonalId
                              , MovementString_Comment.ValueData              AS Comment
                              , MovementLinkObject_Car.ObjectId               AS CarId  
                              , MovementItem.ObjectId                         AS RouteId
                         FROM tmpStatus
                             INNER JOIN Movement ON Movement.DescId = zc_Movement_Transport()
                                                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                AND Movement.StatusId = tmpStatus.StatusId
                             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                          ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
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
                                              AND MovementItem.isErased    = FALSE
                         )
   , tmpTransportService AS (SELECT Movement.Id AS MovementId
                                  , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                                  , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                                  , Movement.OperDate
                                  , Movement.StatusId                             AS StatusId
                                  , MovementItem.ObjectId                         AS PersonalDriverId   -- юр.лицо
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MILinkObject_Car.ObjectId                     AS CarId
                                  , MILinkObject_Route.ObjectId                   AS RouteId
                             FROM tmpStatus
                                 INNER JOIN Movement ON Movement.DescId = zc_Movement_TransportService()
                                                    AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND Movement.StatusId = tmpStatus.StatusId
                                 LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased = False
                                 LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                         )
     , tmpTransportList AS (SELECT tr1.MovementId, tr1.InvNumber, tr1.OperDate, tr1.PersonalDriverId, tr1.PersonalId, tr1.CarId, tr1.RouteId, tr1.Comment 
                                 , zfFormat_BarCode (zc_BarCodePref_Movement(), tr1.MovementId) AS IdBarCode
                                 , tr1.StatusId, tr1.InvNumber_Full
                            FROM tmpTransport AS tr1
                           UNION ALL
                            SELECT tr2.MovementId, tr2.InvNumber, tr2.OperDate, tr2.PersonalDriverId, 0 AS PersonalId, tr2.CarId, tr2.RouteId, tr2.Comment 
                                , zfFormat_BarCode (zc_BarCodePref_Movement(), tr2.MovementId) AS IdBarCode
                                , tr2.StatusId, tr2.InvNumber_Full
                            FROM tmpTransportService AS tr2
                           )
        -- Результат
        SELECT tmpTransportList.MovementId
             , tmpTransportList.InvNumber
             , tmpTransportList.InvNumber_Full
             , tmpTransportList.OperDate 
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , Object_Car.Id                    AS CarId
             , Object_Car.ValueData             AS CarName
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_Route.ValueData           AS RouteName
             , Object_PersonalDriver.Id         AS PersonalDriverId
             , Object_PersonalDriver.ValueData  AS PersonalDriverName
             , Object_Personal.ValueData        AS PersonalName
             , Object_UnitForwarding.ValueData  AS UnitForwardingName
             , View_Unit.BranchName
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun
             , tmpTransportList.Comment

        FROM tmpTransportList
            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = tmpTransportList.MovementId
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = tmpTransportList.MovementId
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = tmpTransportList.MovementId
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId
           
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpTransportList.CarId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object_Unit_View AS View_Unit ON View_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
 
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
          
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = tmpTransportList.PersonalDriverId
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpTransportList.PersonalId
        
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpTransportList.RouteId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpTransportList.StatusId

      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Transport_Choice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Transport_Choice (inStartDate:= '01.09.2015', inEndDate:= '01.09.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
