-- Function: gpSelect_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDatePartner_sale TDateTime, OperDateMark TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , RouteGroupName TVarChar, RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , CarInfoId Integer, CarInfoName TVarChar, CarComment TVarChar, OperDate_CarInfo TDateTime
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceWithVAT Boolean, isPrinted Boolean, isPrintComment Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , isEDI Boolean
             , IsRemains Boolean
             , isPromo Boolean
             , MovementPromo TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , UpdateMobileDate TDateTime
             , PeriodSecMobile Integer
             , MemberName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
             , StartBegin      TDateTime
             , EndBegin        TDateTime
             , diffBegin_sec   TFloat
             , StatusId_wms Integer, StatusCode_wms Integer, StatusName_wms TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsUserOrder  Boolean;
   DECLARE vbIsUserOrder_basis Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- определяется уровень доступа
     vbIsUserOrder:= EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder > 0);
     --
     vbIsUserOrder_basis:= EXISTS(SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_UserOrderBasis());


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = 402720 AND UserId = vbUserId -- Заявки-Днепр
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll() AND vbIsUserOrder = FALSE
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentKharkov() AS AccessKeyId WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         -- DocumentKrRog + DocumentDnepr
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentKrRog() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog())
                         -- Zaporozhye
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentZaporozhye() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                              )
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
           -- Участок мясного сырья
         , tmpUnit_basis AS (SELECT lfSelect.UnitId
                             FROM lfSelect_Object_Unit_byGroup (8439) AS lfSelect
                             WHERE vbIsUserOrder_basis = TRUE
                            )
       -- 
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           --, (Movement.OperDate + ((COALESCE (ObjectFloat_PrepareDayCount.ValueData, 0) + COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0)) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
           , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_Personal.Id                             AS PersonalId
           , Object_Personal.ValueData                      AS PersonalName
           , Object_RouteGroup.ValueData                    AS RouteGroupName
           , Object_Route.Id                                AS RouteId
           , Object_Route.ValueData                         AS RouteName
           , Object_RouteSorting.Id                         AS RouteSortingId
           , Object_RouteSorting.ValueData                  AS RouteSortingName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.ValueData                     AS PriceListName
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName
           , Object_CarInfo.Id                              AS CarInfoId
           , Object_CarInfo.ValueData                       AS CarInfoName
           , MovementString_CarComment.ValueData ::TVarChar AS CarComment
           , MovementDate_CarInfo.ValueData     ::TDateTime AS OperDate_CarInfo
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , COALESCE (MovementBoolean_Print.ValueData, False) AS isPrinted
           , COALESCE (MovementBoolean_PrintComment.ValueData, FALSE) AS isPrintComment

           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond

           , COALESCE (MovementLinkMovement_Order.MovementId, 0) <> 0 AS isEDI
           , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS IsRemains

           , COALESCE (MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

           , MovementString_Comment.ValueData       AS Comment

           , Object_User.ValueData                  AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           , MovementDate_UpdateMobile.ValueData    AS UpdateMobileDate
           , CASE WHEN MovementDate_UpdateMobile.ValueData IS NULL THEN NULL
                  ELSE EXTRACT (SECOND FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                     + 60 * EXTRACT (MINUTE FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                     + 60 * 60 * EXTRACT (HOUR FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
             END :: Integer AS PeriodSecMobile

           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_Member.ValueData ELSE '' END :: TVarChar AS MemberName
           , Object_Unit.ObjectCode                 AS UnitCode
           , Object_Unit.ValueData                  AS UnitName
           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_Position.ValueData ELSE '' END :: TVarChar AS PositionName

           , MovementDate_StartBegin.ValueData  AS StartBegin
           , MovementDate_EndBegin.ValueData    AS EndBegin
           , EXTRACT (EPOCH FROM (COALESCE (MovementDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MovementDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

           , Object_Status_wms.Id                       AS StatusId_wms
           , Object_Status_wms.ObjectCode               AS StatusCode_wms
           , Object_Status_wms.ValueData                AS StatusName_wms

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_OrderExternal() AND Movement.StatusId = tmpStatus.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = Movement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
            LEFT JOIN MovementDate AS MovementDate_UpdateMobile
                                   ON MovementDate_UpdateMobile.MovementId = Movement.Id
                                  AND MovementDate_UpdateMobile.DescId = zc_MovementDate_UpdateMobile()

            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_CarComment
                                     ON MovementString_CarComment.MovementId = Movement.Id
                                    AND MovementString_CarComment.DescId = zc_MovementString_CarComment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount  ON ObjectFloat_PrepareDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN tmpUnit_basis ON tmpUnit_basis.UnitId = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementBoolean AS MovementBoolean_PrintComment
                                      ON MovementBoolean_PrintComment.MovementId = Movement.Id
                                     AND MovementBoolean_PrintComment.DescId = zc_MovementBoolean_PrintComment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId = Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                      ON MovementBoolean_Remains.MovementId = Movement.Id
                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSecond
                                    ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()
            LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = MovementLinkObject_CarInfo.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Status_wms
                                         ON MovementLinkObject_Status_wms.MovementId = Movement.Id
                                        AND MovementLinkObject_Status_wms.DescId = zc_MovementLinkObject_Status_wms()
            LEFT JOIN Object AS Object_Status_wms ON Object_Status_wms.Id = MovementLinkObject_Status_wms.ObjectId

            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                -- AND MovementString_GUID.ValueData <> ''
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndSale
                                   ON MD_EndSale.MovementId =  Movement_Promo.Id
                                  AND MD_EndSale.DescId = zc_MovementDate_EndSale()

       WHERE COALESCE (Object_From.DescId, 0) <> zc_Object_Unit()
         AND (tmpUnit_basis.UnitId > 0  OR vbIsUserOrder_basis = FALSE)
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.21         *
 02.05.19         *
 05.10.16         * add inJuridicalBasisId
 25.11.15         * add isPromo
 26.05.15         * add Partner
 20.10.14                                        * add isEDI
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal(instartdate := ('20.04.2020')::TDateTime , inenddate := ('22.04.2020')::TDateTime , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inSession := '5');
