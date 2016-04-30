-- Function: gpSelect_Movement_TransportChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost_Choice(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean   ,
    IN inUnitId      Integer   ,
    IN inInfoMoneyId Integer   ,
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
             , Comment TVarChar , DescName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

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
                                                          AND (MovementLinkObject_UnitForwarding.ObjectId = inUnitId OR inUnitId = 0)

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
                        )
                         
   , tmpService AS        (  SELECT Movement.Id AS MovementId
                                  , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                                  , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                                  , Movement.OperDate
                                  , Movement.StatusId                             AS StatusId
                                  , MovementItem.ObjectId                         AS PersonalDriverId   -- юр.лицо
                                  , MIString_Comment.ValueData                    AS Comment
                                  , 0                         AS CarId  
                                  , 0                         AS RouteId
                                  , MILinkObject_Unit.ObjectId                    AS UnitId
                                  , MovementDesc.ItemName                         AS DescName
                                  , MILinkObject_InfoMoney.ObjectId               AS InfoMoneyId
                                 
                             FROM tmpStatus
                                 INNER JOIN Movement ON Movement.DescId = zc_Movement_Service()
                                                    AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND Movement.StatusId = tmpStatus.StatusId
                                 LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased = False

                                 INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                  ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                                 AND (MILinkObject_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                            --AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)

                                 LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                            )


     , tmpList AS  (        SELECT tr1.MovementId, tr1.InvNumber, tr1.OperDate, tr1.PersonalDriverId, tr1.CarId, tr1.RouteId, tr1.Comment 
                                 , zfFormat_BarCode (zc_BarCodePref_Movement(), tr1.MovementId) AS IdBarCode
                                 , tr1.StatusId, tr1.InvNumber_Full, tr1.UnitId, tr1.DescName, tr1.InfoMoneyId
                            FROM tmpTransport AS tr1
                           UNION ALL
                            SELECT tr2.MovementId, tr2.InvNumber, tr2.OperDate, tr2.PersonalDriverId, tr2.CarId, tr2.RouteId, tr2.Comment 
                                , zfFormat_BarCode (zc_BarCodePref_Movement(), tr2.MovementId) AS IdBarCode
                                , tr2.StatusId, tr2.InvNumber_Full, tr2.UnitId, tr2.DescName, tr2.InfoMoneyId
                            FROM tmpService AS tr2
                            )

        SELECT tmpList.MovementId
             , tmpList.InvNumber
             , tmpList.InvNumber_Full
             , tmpList.OperDate 
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , Object_Car.Id                    AS CarId
             , Object_Car.ValueData             AS CarName
             , Object_CarModel.ValueData        AS CarModelName
             , Object_Route.ValueData           AS RouteName
             , Object_PersonalDriver.ValueData  AS PersonalDriverName
            -- , Object_UnitForwarding.ValueData  AS UnitForwardingName
             , Object_Unit.ValueData            AS UnitName
             , View_Unit.BranchName
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun
             , tmpList.Comment
             , tmpList.DescName
               
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

        FROM tmpList
            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = tmpList.MovementId
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = tmpList.MovementId
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = tmpList.MovementId
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId
           */
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpList.CarId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object_Unit_View AS View_Unit ON View_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
           
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = tmpList.PersonalDriverId
        
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpList.RouteId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpList.StatusId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpList.UnitId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpList.InfoMoneyId

      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.16         *
*/

-- тест
--SELECT * FROM gpSelect_Movement_Cost_Choice (inStartDate:= '01.09.2015', inEndDate:= '01.09.2015', inIsErased:= FALSE, inUnitId:=0,  inSession:= zfCalc_UserAdmin())
