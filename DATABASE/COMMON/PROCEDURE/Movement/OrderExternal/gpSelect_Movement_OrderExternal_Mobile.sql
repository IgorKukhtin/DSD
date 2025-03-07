 -- Function: gpSelect_Movement_OrderExternal_Mobile()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Mobile (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Mobile (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_Mobile(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsMobileDate      Boolean   ,    
    IN inIsErased          Boolean   ,
    IN inJuridicalBasisId  Integer   ,
    IN inMemberId          Integer   , -- торговый агент
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDatePartner_sale TDateTime, OperDateMark TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , RouteGroupName TVarChar, RouteId Integer, RouteName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceWithVAT Boolean, isPrinted Boolean,VATPercent TFloat, ChangePercent TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , isEDI Boolean, isPromo Boolean
             , MovementPromo TVarChar
             , GUID    TVarChar
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
              )
AS
$BODY$
   DECLARE vbUserId        Integer;

   DECLARE vbUserId_Mobile Integer;
   DECLARE vbIsUserOrder   Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- определяется уровень доступа
     vbIsUserOrder:= EXISTS (SELECT Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder > 0);


     -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     SELECT lfGet.MemberId, lfGet.UserId INTO inMemberId, vbUserId_Mobile FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll() AND vbIsUserOrder = FALSE
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
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
         /*, tmpMovement AS (SELECT Movement.*, MovementLinkObject_Insert.ObjectId AS UserId_insert
                           FROM Movement
                                 INNER JOIN tmpStatus        ON tmpStatus.StatusId           = Movement.StatusId
                                 INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                               ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                              AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
                                                              AND (MovementLinkObject_Insert.ObjectId  = vbUserId_Mobile
                                                                OR vbUserId_Mobile = 0)
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId = zc_Movement_OrderExternal()
                          )*/
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
             , tmpUser AS (SELECT DISTINCT ObjectLink_User_Member_trade.ObjectId AS UserId
                           FROM ObjectLink AS ObjectLink_User_Member
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL
                                                      ON OL.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                INNER JOIN ObjectLink AS OL_Partner_PersonalTrade
                                                      ON OL_Partner_PersonalTrade.ObjectId = OL.ObjectId
                                                     AND OL_Partner_PersonalTrade.DescId   = zc_ObjectLink_Partner_PersonalTrade()
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member_trade
                                                      ON ObjectLink_Personal_Member_trade.ObjectId = OL_Partner_PersonalTrade.ChildObjectId
                                                     AND ObjectLink_Personal_Member_trade.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS ObjectLink_User_Member_trade
                                                      ON ObjectLink_User_Member_trade.ChildObjectId = ObjectLink_Personal_Member_trade.ChildObjectId
                                                     AND ObjectLink_User_Member_trade.DescId        = zc_ObjectLink_User_Member()
                           WHERE ObjectLink_User_Member.ObjectId = vbUserId_Mobile
                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                          UNION
                           SELECT DISTINCT ObjectLink_User_Member_trade.ObjectId AS UserId
                           FROM ObjectLink AS ObjectLink_User_Member
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL
                                                      ON OL.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                INNER JOIN ObjectLink AS OL_Partner_PersonalTrade
                                                      ON OL_Partner_PersonalTrade.ObjectId = OL.ObjectId
                                                     AND OL_Partner_PersonalTrade.DescId   = zc_ObjectLink_Partner_PersonalTrade()
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member_trade
                                                      ON ObjectLink_Personal_Member_trade.ObjectId = OL_Partner_PersonalTrade.ChildObjectId
                                                     AND ObjectLink_Personal_Member_trade.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS ObjectLink_User_Member_trade
                                                      ON ObjectLink_User_Member_trade.ChildObjectId = ObjectLink_Personal_Member_trade.ChildObjectId
                                                     AND ObjectLink_User_Member_trade.DescId        = zc_ObjectLink_User_Member()
                           WHERE ObjectLink_User_Member.ObjectId = 1130000 -- Люклянчук О.В.
                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                             AND vbUserId_Mobile = 4538468 -- Спічка Є.А.
                          UNION
                           SELECT vbUserId_Mobile AS UserId
                          UNION
                           SELECT Object.Id AS UserId FROM Object WHERE Object.DescId = zc_Object_User() AND vbUserId_Mobile = 0
                          )
       -- Результат
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate

           , CASE WHEN vbUserId = 5
                  THEN zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)
                  ELSE Object_Status.ObjectCode 
             END :: Integer AS StatusCode

           , CASE WHEN vbUserId = 5
                  THEN zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next)
                  ELSE Object_Status.ValueData
             END :: TVarChar AS StatusName

           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , (Movement.OperDate + ((COALESCE (ObjectFloat_PrepareDayCount.ValueData, 0) + COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0)) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
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
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.ValueData                     AS PriceListName
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , COALESCE (MovementBoolean_Print.ValueData, False) AS isPrinted

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

           , COALESCE (MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

           , MovementString_GUID.ValueData          AS GUID
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

           , Object_Member.ValueData   AS MemberName
           , Object_Unit.ObjectCode    AS UnitCode
           , Object_Unit.ValueData     AS UnitName
           , Object_Position.ValueData AS PositionName

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  
                               AND Movement.DescId = zc_Movement_OrderExternal() 
                               AND Movement.StatusId = tmpStatus.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             WHERE inIsMobileDate = FALSE
            UNION ALL
             SELECT MovementDate_InsertMobile.MovementId  AS Id
             FROM MovementDate AS MovementDate_InsertMobile
                  INNER JOIN Movement ON Movement.Id = MovementDate_InsertMobile.MovementId
                                     AND Movement.DescId = zc_Movement_OrderExternal()
                  INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
             WHERE inIsMobileDate = TRUE
               AND MovementDate_InsertMobile.ValueData >= inStartDate AND MovementDate_InsertMobile.ValueData < inEndDate + interval '1 day'
               AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()             
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement.Id
                                         AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN tmpUser ON tmpUser.UserId = MovementLinkObject_Insert.ObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Object AS Object_User ON Object_User.Id     = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId = Movement.Id
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

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId =  Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount  ON ObjectFloat_PrepareDayCount.ObjectId = Object_From.Id AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = Object_From.Id AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

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
                                      ON MovementBoolean_Print.MovementId =  Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

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

             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
       -- WHERE (tmpUser.UserId >0
       --     OR vbUserId_Mobile = 0)
       WHERE tmpUser.UserId > 0 OR vbUserId = 5
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.07.17         * add inIsMobileDate
 22.04.17         *
 07.03.17         * add inMemberId
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal_Mobile( instartdate:= '21.12.2025', inenddate:= '22.12.2025', inIsMobileDate:= FALSE, inIsErased:= FALSE, inJuridicalBasisId:= 9399 , inMemberId:= 0, inSession:= zfCalc_UserAdmin());
