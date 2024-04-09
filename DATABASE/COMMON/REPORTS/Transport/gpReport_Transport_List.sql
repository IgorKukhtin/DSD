-- Function: gpReport_Transport_List()

DROP FUNCTION IF EXISTS gpReport_Transport_List (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Transport_List (TDateTime, TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Transport_List(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inBranchId    Integer   , -- филиал
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (IdBarCode TVarChar, InvNumber Integer, OperDate TDateTime
             , CarName TVarChar, CarModelName TVarChar, RouteName TVarChar
             , PersonalDriverName TVarChar
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
   WITH tmpTransport AS (SELECT Movement.Id AS MovementId
                              , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                              , Movement.OperDate
                              , MovementLinkObject_PersonalDriver.ObjectId    AS PersonalDriverId
                              , MovementString_Comment.ValueData              AS Comment
                              , MovementLinkObject_Car.ObjectId               AS CarId  
                              , MovementItem.ObjectId                         AS RouteId
                         FROM Movement
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                          ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                         AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                          ON MovementLinkObject_Car.MovementId = Movement.Id
                                                         AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId =  Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                           WHERE Movement.DescId = zc_Movement_Transport()
                           AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
   , tmpTransportService AS (SELECT Movement.Id AS MovementId
                                  , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                                  , Movement.OperDate
                                  , MovementItem.ObjectId                         AS PersonalDriverId   -- юр.лицо
                                  , MIString_Comment.ValueData                    AS Comment
                                  , MILinkObject_Car.ObjectId                     AS CarId
                                  , MILinkObject_Route.ObjectId                   AS RouteId
                             FROM Movement
                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                 LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                             WHERE Movement.DescId = zc_Movement_TransportService()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
     , tmpTransportList AS (SELECT tr1.MovementId, tr1.InvNumber, tr1.OperDate, tr1.PersonalDriverId, tr1.CarId, tr1.RouteId, tr1.Comment 
                                 , zfFormat_BarCode (zc_BarCodePref_Movement(), tr1.MovementId) AS IdBarCode
                            FROM tmpTransport AS tr1
                           UNION ALL
                            SELECT tr2.MovementId, tr2.InvNumber, tr2.OperDate, tr2.PersonalDriverId, tr2.CarId, tr2.RouteId, tr2.Comment 
                                , zfFormat_BarCode (zc_BarCodePref_Movement(), tr2.MovementId) AS IdBarCode
                            FROM tmpTransportService AS tr2
                            )

        SELECT tmpTransportList.IdBarCode
             , tmpTransportList.InvNumber
             , tmpTransportList.OperDate    
             , Object_Car.ValueData             AS CarName
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_Route.ValueData           AS RouteName
             , Object_PersonalDriver.ValueData  AS PersonalDriverName
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
        
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpTransportList.RouteId

        WHERE COALESCE (View_Unit.BranchId, 0) = inBranchId 
           OR inBranchId = 0 
                
        
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.15         * 
*/

-- тест
-- SELECT * FROM gpReport_Transport_List (inStartDate:= '01.08.2015', inEndDate:= '10.08.2015', inBranchId:=0 ,inSession:= zfCalc_UserAdmin())
