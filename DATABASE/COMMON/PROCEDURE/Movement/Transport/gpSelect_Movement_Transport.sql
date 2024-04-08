-- Function: gpSelect_Movement_Transport()

DROP FUNCTION IF EXISTS gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Transport (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Transport (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Transport(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , StartStop TDateTime, EndStop TDateTime
             , HoursWork TFloat, HoursAdd TFloat
             , HoursStop TFloat, HoursMove TFloat
             , PartnerCount TFloat, PartnerCount_no TFloat
             , AmountCost TFloat, AmountMemberCost TFloat
             , Comment TVarChar, CommentStop TVarChar
             , BranchCode_ProfitLoss Integer, BranchName_ProfitLoss TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , CarName TVarChar, CarModelName TVarChar, CarTrailerName TVarChar
             , PersonalDriverName TVarChar, PositionName TVarChar, PositionLevelName TVarChar
             , PersonalDriverMoreName TVarChar
             , PersonalName TVarChar
             , UnitName_Personal TVarChar
             , UnitName_PersonalMore TVarChar
             , UnitForwardingName TVarChar
             , Cost_Info TVarChar
             , UserId_ConfirmedKind Integer, UserName_ConfirmedKind TVarChar
             , Date_UserConfirmedKind TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- определяется - может ли пользовать видеть все документы
     IF zfCalc_AccessKey_TransportAll (vbUserId) = TRUE
     THEN vbAccessKeyId:= 0;
     ELSE vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport());
     END IF;


     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.DescId = zc_Movement_Transport()
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.StatusId = tmpStatus.StatusId
                                                  AND (Movement.AccessKeyId = vbAccessKeyId OR vbAccessKeyId = 0)
                         )
        , tmpCost AS (SELECT tmpMovement.Id
                           , STRING_AGG (DISTINCT '№ ' ||Movement_Income.InvNumber|| ' oт '|| zfConvert_DateToString (Movement_Income.OperDate)||'('||Object_From.ValueData||')' ,';') AS Cost_Info
                      FROM tmpMovement
                           INNER JOIN MovementFloat AS MovementFloat_MovementId
                                                    ON MovementFloat_MovementId.ValueData :: Integer  = tmpMovement.Id
                                                   AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
                           INNER JOIN Movement ON Movement.Id = MovementFloat_MovementId.MovementId
                                              AND Movement.DescId = zc_Movement_IncomeCost()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           
                           LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = Movement.ParentId
                                 
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                      GROUP BY tmpMovement.Id
                      )

       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           
           , MovementDate_StartRunPlan.ValueData  AS StartRunPlan 
           , MovementDate_EndRunPlan.ValueData    AS EndRunPlan 
           , MovementDate_StartRun.ValueData      AS StartRun 
           , MovementDate_EndRun.ValueData        AS EndRun           

           , CAST (MovementDate_StartStop.ValueData AS TDateTime) AS StartStop
           , CAST (MovementDate_EndStop.ValueData AS TDateTime)   AS EndStop

           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS HoursWork
           , MovementFloat_HoursAdd.ValueData     AS HoursAdd
           , COALESCE (MovementFloat_HoursStop.ValueData, 0) :: TFloat AS HoursStop
           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0)  AS TFloat) AS HoursMove
           , CAST (MovementFloat_PartnerCount.ValueData AS TFloat)     AS PartnerCount
           , CAST (MovementFloat_PartnerCount_no.ValueData AS TFloat)  AS PartnerCount_no

           , MovementFloat_AmountCost.ValueData       AS AmountCost
           , MovementFloat_AmountMemberCost.ValueData AS AmountMemberCost

           , MovementString_Comment.ValueData         AS Comment
           , (CASE WHEN Object_UserConfirmedKind.Id IS NULL
                    AND (TRIM (MovementString_CommentStop.ValueData) <> ''
                      OR MovementFloat_HoursStop.ValueData           <> 0
                        )
                   THEN '***НЕ ПОДТВЕРЖДЕНО - '
                   ELSE ''
              END || MovementString_CommentStop.ValueData) :: TVarChar  AS CommentStop

           , Object_Branch_pl.ObjectCode          AS BranchCode_ProfitLoss
           , Object_Branch_pl.ValueData           AS BranchName_ProfitLoss

           , Object_Branch_unit_car.ObjectCode    AS BranchCode
           , Object_Branch_unit_car.ValueData     AS BranchName

           , Object_Unit_car.Id          AS UnitId
           , Object_Unit_car.ObjectCode  AS UnitCode
           , Object_Unit_car.ValueData   AS UnitName

           , Object_Car.ValueData                 AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_CarTrailer.ValueData          AS CarTrailerName

           , (View_PersonalDriver.PersonalName /*|| ' ' || View_PersonalDriver.PositionName*/) :: TVarChar AS PersonalDriverName 
           , View_PersonalDriver.PositionName       :: TVarChar AS PositionName
           , View_PersonalDriver.PositionLevelName  :: TVarChar AS PositionLevelName
           , (View_PersonalDriverMore.PersonalName || ' ' || COALESCE (View_PersonalDriverMore.PositionName, '')  ||  COALESCE (View_PersonalDriverMore.PositionLevelName, '')) :: TVarChar AS PersonalDriverMoreName
           , (View_Personal.PersonalName || ' ' || View_Personal.PositionName) :: TVarChar AS PersonalName

           , View_PersonalDriver.UnitName     AS UnitName_Personal
           , View_PersonalDriverMore.UnitName AS UnitName_PersonalMore

           , Object_UnitForwarding.ValueData AS UnitForwardingName
           , tmpCost.Cost_Info ::TVarChar

           , Object_UserConfirmedKind.Id                           AS UserId_ConfirmedKind
           , Object_UserConfirmedKind.ValueData                    AS UserName_ConfirmedKind
           , MovementDate_UserConfirmedKind.ValueData :: TDateTime AS Date_UserConfirmedKind
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()

            LEFT JOIN MovementDate AS MovementDate_EndRunPlan
                                   ON MovementDate_EndRunPlan.MovementId = Movement.Id
                                  AND MovementDate_EndRunPlan.DescId = zc_MovementDate_EndRunPlan()

            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = Movement.Id
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()

            LEFT JOIN MovementDate AS MovementDate_EndRun
                                   ON MovementDate_EndRun.MovementId = Movement.Id
                                  AND MovementDate_EndRun.DescId = zc_MovementDate_EndRun()

            LEFT JOIN MovementDate AS MovementDate_StartStop
                                   ON MovementDate_StartStop.MovementId = Movement.Id
                                  AND MovementDate_StartStop.DescId = zc_MovementDate_StartStop()

            LEFT JOIN MovementDate AS MovementDate_EndStop
                                   ON MovementDate_EndStop.MovementId = Movement.Id
                                  AND MovementDate_EndStop.DescId = zc_MovementDate_EndStop()

            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId = Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()

            LEFT JOIN MovementFloat AS MovementFloat_HoursStop
                                    ON MovementFloat_HoursStop.MovementId =  Movement.Id
                                   AND MovementFloat_HoursStop.DescId = zc_MovementFloat_HoursStop()

            LEFT JOIN MovementFloat AS MovementFloat_PartnerCount
                                    ON MovementFloat_PartnerCount.MovementId =  Movement.Id
                                   AND MovementFloat_PartnerCount.DescId = zc_MovementFloat_PartnerCount()
            LEFT JOIN MovementFloat AS MovementFloat_PartnerCount_no
                                    ON MovementFloat_PartnerCount_no.MovementId =  Movement.Id
                                   AND MovementFloat_PartnerCount_no.DescId = zc_MovementFloat_PartnerCount_no()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                     ON MovementFloat_AmountCost.MovementId = Movement.Id
                                    AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
             LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost
                                     ON MovementFloat_AmountMemberCost.MovementId = Movement.Id
                                    AND MovementFloat_AmountMemberCost.DescId     = zc_MovementFloat_AmountMemberCost()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementString AS MovementString_CommentStop
                                     ON MovementString_CommentStop.MovementId =  Movement.Id
                                    AND MovementString_CommentStop.DescId = zc_MovementString_CommentStop()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId     = zc_MovementLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch_pl ON Object_Branch_pl.Id = MovementLinkObject_Branch.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_car ON Object_Unit_car.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_car
                                 ON ObjectLink_Unit_Branch_car.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                AND ObjectLink_Unit_Branch_car.DescId    = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch_unit_car ON Object_Branch_unit_car.Id = ObjectLink_Unit_Branch_car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriverMore
                                         ON MovementLinkObject_PersonalDriverMore.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriverMore.DescId = zc_MovementLinkObject_PersonalDriverMore()
            LEFT JOIN Object_Personal_View AS View_PersonalDriverMore ON View_PersonalDriverMore.PersonalId = MovementLinkObject_PersonalDriverMore.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                         ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                        AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
            LEFT JOIN Object AS Object_UserConfirmedKind ON Object_UserConfirmedKind.Id = MovementLinkObject_UserConfirmedKind.ObjectId

            LEFT JOIN MovementDate AS MovementDate_UserConfirmedKind
                                   ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                  AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

            LEFT JOIN tmpCost ON tmpCost.Id = Movement.Id
      
         -- AND tmpRoleAccessKey.AccessKeyId IS NOT NULL
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.04.21         *
 07.10.16         * add inJuridicalBasisId
 29.08.15         * add inIsErased
 06.02.14                                        * add Branch...
 14.12.13                                        * add lpGetUserBySession
 02.12.13         * add Personal (changes in wiki)
 23.10.13                                        * add zfConvert_StringToNumber
 18.10.13                                        * add CarModelName
 30.09.13                                        * add Object_Personal_View
 26.09.13                                        * changes in wiki
 25.09.13         * changes in wiki
 20.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Transport (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
