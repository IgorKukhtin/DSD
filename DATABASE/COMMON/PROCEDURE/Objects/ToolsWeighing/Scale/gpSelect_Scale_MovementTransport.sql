-- Function: gpSelect_Scale_MovementTransport()

DROP FUNCTION IF EXISTS gpSelect_Scale_MovementTransport (TDateTime, TDateTime, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_MovementTransport (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_MovementTransport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_MovementTransport(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inBranchCode        Integer   ,
    IN inMovementId_order  Integer   , --
    IN inMovementDescId    Integer   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime
             , RouteName TVarChar
             , CarName TVarChar, CarModelName TVarChar
             , PersonalDriverName TVarChar
             , PersonalName TVarChar
             , UnitForwardingName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRouteId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Scale_MovementTransport());
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск маршрута
     IF inMovementId_order = 0 AND inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
     THEN
         vbRouteId:= 0;
         --
         IF inMovementDescId = zc_Movement_Income()
         THEN vbUnitId:= 8464; -- 33010 Транспорт - снабжение
         ELSE vbUnitId:= 8405; -- 21110 Транспорт сбыт мясной отдел
         END IF;
     ELSE
         vbRouteId:= COALESCE ((SELECT MLO_Route.ObjectId FROM MovementLinkObject AS MLO_Route WHERE MLO_Route.MovementId = inMovementId_order AND MLO_Route.DescId = zc_MovementLinkObject_Route()), 0);
         -- 
         vbUnitId:= 0;
     END IF;


     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )

       SELECT  Movement.Id
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan

             , Object_Route.ValueData           AS RouteName
             , Object_Car.ValueData             AS CarName
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_PersonalDriver.ValueData  AS PersonalDriverName
             , Object_Personal.ValueData        AS PersonalName
             , Object_UnitForwarding.ValueData  AS UnitForwardingName

       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
            INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                            AND Movement.DescId = zc_Movement_TransportService()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                            AND Movement.DescId = zc_Movement_TransportService()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                 ON ObjectLink_Route_Unit.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()

            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = COALESCE (MovementLinkObject_PersonalDriver.ObjectId, CASE WHEN Movement.DescId = zc_Movement_TransportService() THEN MovementItem.ObjectId END)
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = COALESCE (MILinkObject_Car.ObjectId, MovementLinkObject_Car.ObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN Object AS Object_Route ON Object_Route.Id = COALESCE (MILinkObject_Route.ObjectId, CASE WHEN Movement.DescId = zc_Movement_Transport() THEN MovementItem.ObjectId END)

--       WHERE (Object_Route.Id = vbRouteId OR vbRouteId = 0)
--         AND (ObjectLink_Route_Unit.ChildObjectId = vbUnitId OR vbUnitId = 0)
       ORDER BY MovementDate_StartRunPlan.ValueData DESC
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_MovementTransport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 31.08.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_MovementTransport (inStartDate:= '01.05.2015', inEndDate:= '01.05.2015', inBranchCode:= 1, inMovementId_order:= 0, inMovementDescId:= 0, inSession:= zfCalc_UserAdmin())
