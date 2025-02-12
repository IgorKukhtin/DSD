-- Function: gpSelect_Movement_ReestrIncome()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrIncome (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrIncome(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UpdateName TVarChar, UpdateDate TDateTime
             , CarName TVarChar, CarModelName TVarChar
             , PersonalDriverName TVarChar
             , MemberName TVarChar

             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime -- , InvNumber_Transport_Full TVarChar
             , StatusCode_Transport Integer, StatusName_Transport TVarChar

             , ReestrKindId Integer, ReestrKindName TVarChar
             , InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , StatusCode_Sale Integer, StatusName_Sale TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , InvNumberOrder TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , FromName TVarChar, ToName TVarChar
             , TotalCountPartner  TFloat, TotalSumm TFloat
             , PaidKindName TVarChar
             , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_from TVarChar, OKPO_To TVarChar 

             , Date_Insert      TDateTime
             , Date_Snab        TDateTime
             , Date_SnabRe      TDateTime
             , Date_Remake      TDateTime
             , Date_Econom      TDateTime
             , Date_Buh         TDateTime
             , Date_EconomIn    TDateTime
             , Date_EconomOut   TDateTime
             , Date_inBuh       TDateTime

             , Member_Insert      TVarChar
             , Member_Snab        TVarChar
             , Member_SnabRe      TVarChar
             , Member_Remake      TVarChar
             , Member_Econom      TVarChar
             , Member_Buh         TVarChar
             , Member_EconomIn    TVarChar
             , Member_EconomOut   TVarChar
             , Member_inBuh       TVarChar

             , PersonalName            TVarChar
             , PersonalTradeName       TVarChar
             , UnitName_Personal       TVarChar
             , UnitName_PersonalTrade  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReestrIncome());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
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

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ReestrIncome() AND Movement.StatusId = tmpStatus.StatusId
                               JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                          )

       -- Результат
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , Object_Update.ValueData           AS UpdateName
           , MovementDate_Update.ValueData     AS UpdateDate

           , Object_Car.ValueData              AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_PersonalDriver.ValueData   AS PersonalDriverName
           , Object_Member.ValueData           AS MemberName

           , Movement_Transport.Id             AS MovementId_Transport
           , Movement_Transport.InvNumber      AS InvNumber_Transport
           , Movement_Transport.OperDate       AS OperDate_Transport

           , Object_Status_Transport.ObjectCode AS StatusCode_Transport
           , Object_Status_Transport.ValueData  AS StatusName_Transport

           , Object_ReestrKind.Id              AS ReestrKindId
           , Object_ReestrKind.ValueData       AS ReestrKindName
           , Movement_Income.InvNumber         AS InvNumber_Income
           , Movement_Income.OperDate          AS OperDate_Income
           , Object_Status_Income.ObjectCode   AS StatusCode_Income
           , Object_Status_Income.ValueData    AS StatusName_Income

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , Movement_Order.InvNumber                  AS InvNumberOrder
           , Object_RouteGroup.ValueData               AS RouteGroupName
           , Object_Route.ValueData                    AS RouteName

           , Object_From.ValueData                     AS FromName
           , Object_To.ValueData                       AS ToName
           , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData         AS TotalSumm
           , Object_PaidKind.ValueData                 AS PaidKindName
           , View_Contract_InvNumber.ContractCode      AS ContractCode
           , View_Contract_InvNumber.InvNumber         AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalFrom.ValueData              AS JuridicalName_from
           , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

           , MIDate_Insert.ValueData         AS Date_Insert
           , MIDate_Snab.ValueData           AS Date_Snab
           , MIDate_SnabRe.ValueData         AS Date_SnabRe
           , MIDate_Remake.ValueData         AS Date_Remake
           , MIDate_Econom.ValueData         AS Date_Econom
           , MIDate_Buh.ValueData            AS Date_Buh
           , MIDate_EconomIn.ValueData       AS Date_EconomIn
           , MIDate_EconomOut.ValueData      AS Date_EconomOut
           , MIDate_inBuh.ValueData          AS Date_inBuh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_Snab.ValueData         AS Member_Snab
           , Object_SnabRe.ValueData       AS Member_SnabRe
           , Object_Remake.ValueData       AS Member_Remake
           , Object_Econom.ValueData       AS Member_Econom
           , Object_Buh.ValueData          AS Member_Buh
           , Object_EconomIn.ValueData     AS Member_EconomIn
           , Object_EconomOut.ValueData    AS Member_EconomOut
           , Object_inBuh.ValueData        AS Member_inBuh

           , Object_Personal.ValueData           AS PersonalName
           , Object_PersonalTrade.ValueData      AS PersonalTradeName
           , Object_UnitPersonal.ValueData       AS UnitName_Personal
           , Object_UnitPersonalTrade.ValueData  AS UnitName_PersonalTrade
       FROM tmpMovement AS Movement

            --LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN Object AS Object_Status_Transport ON Object_Status_Transport.Id = Movement_Transport.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            -- строчная часть реестра
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.isErased   = FALSE
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Snab
                                       ON MIDate_Snab.MovementItemId = MovementItem.Id
                                      AND MIDate_Snab.DescId = zc_MIDate_Snab()
            LEFT JOIN MovementItemDate AS MIDate_SnabRe
                                       ON MIDate_SnabRe.MovementItemId = MovementItem.Id
                                      AND MIDate_SnabRe.DescId = zc_MIDate_SnabRe()
            LEFT JOIN MovementItemDate AS MIDate_Remake
                                       ON MIDate_Remake.MovementItemId = MovementItem.Id
                                      AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN MovementItemDate AS MIDate_Econom
                                       ON MIDate_Econom.MovementItemId = MovementItem.Id
                                      AND MIDate_Econom.DescId = zc_MIDate_Econom()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN MovementItemDate AS MIDate_EconomIn
                                       ON MIDate_EconomIn.MovementItemId = MovementItem.Id
                                      AND MIDate_EconomIn.DescId = zc_MIDate_EconomIn()
            LEFT JOIN MovementItemDate AS MIDate_EconomOut
                                       ON MIDate_EconomOut.MovementItemId = MovementItem.Id
                                      AND MIDate_EconomOut.DescId = zc_MIDate_EconomOut()
            LEFT JOIN MovementItemDate AS MIDate_inBuh
                                       ON MIDate_inBuh.MovementItemId = MovementItem.Id
                                      AND MIDate_inBuh.DescId = zc_MIDate_inBuh()
                                      
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Snab
                                             ON MILinkObject_Snab.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Snab.DescId = zc_MILinkObject_Snab()
            LEFT JOIN Object AS Object_Snab ON Object_Snab.Id = MILinkObject_Snab.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_SnabRe
                                             ON MILinkObject_SnabRe.MovementItemId = MovementItem.Id
                                            AND MILinkObject_SnabRe.DescId = zc_MILinkObject_SnabRe()
            LEFT JOIN Object AS Object_SnabRe ON Object_SnabRe.Id = MILinkObject_SnabRe.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Remake
                                             ON MILinkObject_Remake.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Econom
                                             ON MILinkObject_Econom.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Econom.DescId = zc_MILinkObject_Econom()
            LEFT JOIN Object AS Object_Econom ON Object_Econom.Id = MILinkObject_Econom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_EconomIn
                                             ON MILinkObject_EconomIn.MovementItemId = MovementItem.Id
                                            AND MILinkObject_EconomIn.DescId = zc_MILinkObject_EconomIn()
            LEFT JOIN Object AS Object_EconomIn ON Object_EconomIn.Id = MILinkObject_EconomIn.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_EconomOut
                                             ON MILinkObject_EconomOut.MovementItemId = MovementItem.Id
                                            AND MILinkObject_EconomOut.DescId = zc_MILinkObject_EconomOut()
            LEFT JOIN Object AS Object_EconomOut ON Object_EconomOut.Id = MILinkObject_EconomOut.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_inBuh
                                             ON MILinkObject_inBuh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_inBuh.DescId = zc_MILinkObject_inBuh()
            LEFT JOIN Object AS Object_inBuh ON Object_inBuh.Id = MILinkObject_inBuh.ObjectId


            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id -- tmpMI.MovementItemId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementFloat_MovementItemId.MovementId
            LEFT JOIN Object AS Object_Status_Income ON Object_Status_Income.Id = Movement_Income.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement_Income.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            --
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitPersonal ON Object_UnitPersonal.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                 ON ObjectLink_PersonalTrade_Unit.ObjectId = Object_PersonalTrade.Id
                                AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitPersonalTrade ON Object_UnitPersonalTrade.Id = ObjectLink_PersonalTrade_Unit.ChildObjectId
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.25         * inBuh
 30.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrIncome (inStartDate:= '20.10.2016', inEndDate:= '25.10.2016', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
