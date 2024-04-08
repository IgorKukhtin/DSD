-- Function: gpSelect_Movement_Transport()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportRoute (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportRoute (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TDateTime, StartRun TDateTime, EndRun TDateTime
             , HoursWork TFloat, HoursAdd TFloat
             , AmountCost TFloat, AmountMemberCost TFloat
             , Comment TVarChar
             , BranchCode Integer, BranchName TVarChar
             , CarName TVarChar, CarModelName TVarChar, CarTrailerName TVarChar
             , PersonalDriverName TVarChar
             , PersonalDriverMoreName TVarChar
             , PersonalName TVarChar
             , UnitForwardingName TVarChar
             , Cost_Info TVarChar
             , RouteCode    Integer
             , RouteName    TVarChar
             , FreightName  TVarChar
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
        , tmpMI AS (SELECT tmpMovement.Id           AS MovementId
                         , Object_Route.ObjectCode  AS RouteCode
                         , Object_Route.ValueData   AS RouteName
                         , Object_Freight.ValueData AS FreightName
                    FROM tmpMovement
                         JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                         LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementItem.ObjectId

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Freight
                                                          ON MILinkObject_Freight.MovementItemId = MovementItem.Id 
                                                         AND MILinkObject_Freight.DescId = zc_MILinkObject_Freight()
                         LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = MILinkObject_Freight.ObjectId
                   )

             
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementDate_StartRunPlan.ValueData AS StartRunPlan 
           , MovementDate_EndRunPlan.ValueData   AS EndRunPlan 
           , MovementDate_StartRun.ValueData     AS StartRun 
           , MovementDate_EndRun.ValueData       AS EndRun           
          
           , CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS HoursWork
           , MovementFloat_HoursAdd.ValueData      AS HoursAdd
                      
           , MovementFloat_AmountCost.ValueData       AS AmountCost
           , MovementFloat_AmountMemberCost.ValueData AS AmountMemberCost

           , MovementString_Comment.ValueData      AS Comment

           , View_Unit.BranchCode
           , View_Unit.BranchName
           , Object_Car.ValueData        AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_CarTrailer.ValueData AS CarTrailerName

           , View_PersonalDriver.PersonalName     AS PersonalDriverName
           , View_PersonalDriverMore.PersonalName AS PersonalDriverMoreName
           , View_Personal.PersonalName           AS PersonalName

           , Object_UnitForwarding.ValueData AS UnitForwardingName
           , tmpCost.Cost_Info ::TVarChar
           
           , tmpMI.RouteCode     ::Integer
           , tmpMI.RouteName     ::TVarChar
           , tmpMI.FreightName   ::TVarChar
           
   
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

            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId = Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()

            LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                    ON MovementFloat_AmountCost.MovementId = Movement.Id
                                   AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
            LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost
                                    ON MovementFloat_AmountMemberCost.MovementId = Movement.Id
                                   AND MovementFloat_AmountMemberCost.DescId     = zc_MovementFloat_AmountMemberCost()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
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

            LEFT JOIN tmpCost ON tmpCost.Id = Movement.Id
            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportRoute (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
