-- Function: gpSelect_Movement_TransportGoods()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportGoods(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InvNumberMark TVarChar
             , InvNumber_Full TVarChar
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , InvNumberPartner_Sale TVarChar, OperDatePartner_Sale TDateTime
             , RouteName TVarChar
             , CarName TVarChar, CarModelName TVarChar, CarTrailerName TVarChar
             , PersonalDriverName TVarChar
             , CarJuridicalName TVarChar
             , MemberName1 TVarChar
             , MemberName2 TVarChar
             , MemberName3 TVarChar
             , MemberName4 TVarChar
             , MemberName5 TVarChar
             , MemberName6 TVarChar
             , MemberName7 TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindName TVarChar
             , TotalCountSh TFloat, TotalCountKg TFloat, TotalSumm TFloat

             , ReestrKindName TVarChar
             , OperDate_reestr TDateTime, InvNumber_reestr TVarChar
             , StatusCode_reestr Integer, StatusName_reestr TVarChar
             , CarName_reestr TVarChar, CarModelName_reestr TVarChar
             , PersonalDriverName_reestr TVarChar, MemberName_reestr TVarChar
             , InvNumber_Transport_reestr TVarChar, OperDate_Transport_reestr TDateTime

             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , PersonalDriverName_Transport TVarChar
             , CarName_Transport TVarChar
             , isExternal Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportGoods());
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
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT Object_RoleAccessKeyDocument_View.AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY Object_RoleAccessKeyDocument_View.AccessKeyId
                         -- UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementString_InvNumberMark.ValueData  AS InvNumberMark
           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full

           , Movement_Sale.Id        AS MovementId_Sale
           , Movement_Sale.InvNumber AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale
           , MovementString_InvNumberPartner_Sale.ValueData AS InvNumberPartner_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale

           , Object_Route.ValueData          AS RouteName
           , Object_Car.ValueData            AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_CarTrailer.ValueData     AS CarTrailerName
           , Object_PersonalDriver.ValueData AS PersonalDriverName
           , Object_CarJuridical.Valuedata   AS CarJuridicalName

           , Object_Member1.ValueData AS MemberName1
           , Object_Member2.ValueData AS MemberName2
           , Object_Member3.ValueData AS MemberName3
           , Object_Member4.ValueData AS MemberName4
           , Object_Member5.ValueData AS MemberName5
           , Object_Member6.ValueData AS MemberName6
           , Object_Member7.ValueData AS MemberName7

           , Object_From.Id                       AS FromId
           , Object_From.ValueData                AS FromName
           , Object_To.Id                         AS ToId
           , Object_To.ValueData                  AS ToName
           , Object_PaidKind.ValueData            AS PaidKindName
           , MovementFloat_TotalCountSh.ValueData AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData    AS TotalSumm

          --реестр
           , Object_ReestrKind.ValueData                AS ReestrKindName
           , Movement_reestr.OperDate                   AS OperDate_reestr
           , Movement_reestr.InvNumber                  AS InvNumber_reestr
           , Object_Status_reestr.ObjectCode            AS StatusCode_reestr
           , Object_Status_reestr.ValueData             AS StatusName_reestr

           , Object_Car_reestr.ValueData                AS CarName_reestr
           , (COALESCE (Object_CarModel_reestr.ValueData,'') || COALESCE (' ' || Object_CarType_reestr.ValueData, '') ) ::TVarChar AS CarModelName_reestr
           , Object_PersonalDriver_reestr.PersonalName  AS PersonalDriverName_reestr
           , Object_Member_reestr.ValueData             AS MemberName_reestr

           , Movement_Transport_reestr.InvNumber        AS InvNumber_Transport_reestr
           , Movement_Transport_reestr.OperDate         AS OperDate_Transport_reestr


           , Movement_Transport.Id                     AS MovementId_Transport
           , Movement_Transport.InvNumber              AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , Object_PersonalDriver_Transport.ValueData AS PersonalDriverName_Transport
           , Object_Car_Transport.ValueData            AS CarName_Transport

           , CASE WHEN Object_Car.DescId = zc_Object_Car() THEN FALSE ELSE TRUE END ::Boolean AS isExternal --свои (нет) или сторонние авто (Да)
       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_TransportGoods()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel                                            -- авто
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_CarModel                                    -- авто стороннее
                                 ON ObjectLink_CarExternal_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_CarExternal_CarModel.DescId = zc_ObjectLink_CarExternal_CarModel()

            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = COALESCE(ObjectLink_Car_CarModel.ChildObjectId, ObjectLink_CarExternal_CarModel.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

--          определяем юр.лицо
            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical                                                      -- юр.лицо авто
                                 ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical                                               -- юр.лицо авто стороннее
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit                                                           -- подразделение авто
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical                                                     -- юр.лицо подразделения авто
                             ON ObjectLink_Unit_Juridical.ObjectId =  ObjectLink_Car_Unit.ChildObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract                                                      --  подразделение  Договор (перевыставление затрат)
                                 ON ObjectLink_Unit_Contract.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

            LEFT JOIN Object AS Object_CarJuridical ON Object_CarJuridical.Id = COALESCE(ObjectLink_Car_Juridical.ChildObjectId, COALESCE(ObjectLink_CarExternal_Juridical.ChildObjectId, COALESCE(ObjectLink_Unit_Juridical.ChildObjectId, COALESCE(ObjectLink_Contract_Juridical.ChildObjectId,0))) )

--
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                         ON MovementLinkObject_Member1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member1()
            LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = MovementLinkObject_Member1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                         ON MovementLinkObject_Member2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member2()
            LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = MovementLinkObject_Member2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                         ON MovementLinkObject_Member3.MovementId = Movement.Id
                                        AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member3()
            LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = MovementLinkObject_Member3.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                         ON MovementLinkObject_Member4.MovementId = Movement.Id
                                        AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member4()
            LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = MovementLinkObject_Member4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                         ON MovementLinkObject_Member5.MovementId = Movement.Id
                                        AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member5()
            LEFT JOIN Object AS Object_Member5 ON Object_Member5.Id = MovementLinkObject_Member5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                         ON MovementLinkObject_Member6.MovementId = Movement.Id
                                        AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member6()
            LEFT JOIN Object AS Object_Member6 ON Object_Member6.Id = MovementLinkObject_Member6.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member7
                                         ON MovementLinkObject_Member7.MovementId = Movement.Id
                                        AND MovementLinkObject_Member7.DescId = zc_MovementLinkObject_Member7()
            LEFT JOIN Object AS Object_Member7 ON Object_Member7.Id = MovementLinkObject_Member7.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver_Transport
                                         ON MovementLinkObject_PersonalDriver_Transport.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver_Transport.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver_Transport ON Object_PersonalDriver_Transport.Id = MovementLinkObject_PersonalDriver_Transport.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car_Transport
                                         ON MovementLinkObject_Car_Transport.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car_Transport.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car_Transport ON Object_Car_Transport.Id = MovementLinkObject_Car_Transport.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Sale
                                     ON MovementString_InvNumberPartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                    AND MovementString_InvNumberPartner_Sale.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                   ON MovementDate_OperDatePartner_Sale.MovementId =  MovementLinkMovement_TransportGoods.MovementId
                                  AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement_Sale.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            -- реестр
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_reestr
                                   ON MI_reestr.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_reestr.isErased = FALSE
            LEFT JOIN Movement AS Movement_reestr ON Movement_reestr.Id = MI_reestr.MovementId
            LEFT JOIN Object AS Object_Status_reestr ON Object_Status_reestr.Id = Movement_reestr.StatusId

            LEFT JOIN MovementLinkObject AS MLO_Car_reestr
                                         ON MLO_Car_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Car_reestr.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car_reestr ON Object_Car_reestr.Id = MLO_Car_reestr.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel_reestr ON ObjectLink_Car_CarModel_reestr.ObjectId = Object_Car_reestr.Id
                                                                  AND ObjectLink_Car_CarModel_reestr.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel_reestr ON Object_CarModel_reestr.Id = ObjectLink_Car_CarModel_reestr.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType_reestr
                                 ON ObjectLink_Car_CarType_reestr.ObjectId = Object_Car_reestr.Id
                                AND ObjectLink_Car_CarType_reestr.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType_reestr ON Object_CarType_reestr.Id = ObjectLink_Car_CarType_reestr.ChildObjectId

            LEFT JOIN MovementLinkObject AS MLO_PersonalDriver_reestr
                                         ON MLO_PersonalDriver_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_PersonalDriver_reestr.DescId     = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS Object_PersonalDriver_reestr ON Object_PersonalDriver_reestr.PersonalId = MLO_PersonalDriver_reestr.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Member_reestr
                                         ON MLO_Member_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Member_reestr.DescId     = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member_reestr ON Object_Member_reestr.Id = MLO_Member_reestr.ObjectId
            -- инфа из П/л (реестр)
            LEFT JOIN MovementLinkMovement AS MLM_Transport_reestr
                                           ON MLM_Transport_reestr.MovementId = Movement_reestr.Id
                                          AND MLM_Transport_reestr.DescId     = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport_reestr ON Movement_Transport_reestr.Id = MLM_Transport_reestr.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_TransportGoods (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.10.16         * add inJuridicalBasisId
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportGoods (inStartDate:= '30.10.2015', inEndDate:= '01.12.2015', inIsErased:=false, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
