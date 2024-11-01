-- Function: gpSelect_Movement_OrderExternalUnit()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternalUnit (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternalUnit (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternalUnit(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDateMark TDateTime
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceWithVAT Boolean, isPrinted Boolean,VATPercent TFloat, ChangePercent TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , DayCount TFloat
             , isEDI Boolean
             , IsRemains Boolean
             , Comment TVarChar
             , StartBegin      TDateTime
             , EndBegin        TDateTime
             , diffBegin_sec   TFloat
             , StatusId_wms Integer, StatusCode_wms Integer, StatusName_wms TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);


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
                         -- DocumentKrRog + DocumentDnepr
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentKrRog() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog())
                         -- Zaporozhye
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentZaporozhye() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                              )
         , tmpUnit AS (SELECT ObjectLink.ObjectId AS UnitId FROM ObjectLink WHERE ObjectLink.ChildObjectId = vbObjectId_Branch_Constraint AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch())

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           , MovementDate_OperDateStart.ValueData           AS OperDateStart
           , MovementDate_OperDateEnd.ValueData             AS OperDateEnd
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_Personal.Id                             AS PersonalId
           , Object_Personal.ValueData                      AS PersonalName
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

           , Object_Retail.id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName

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
           
           , (1 + EXTRACT (DAY FROM (COALESCE (MovementDate_OperDateEnd.ValueData, Movement.OperDate - (INTERVAL '1 DAY')) :: TDateTime
                                   - COALESCE (MovementDate_OperDateStart.ValueData, Movement.OperDate - (INTERVAL '7 DAY')) :: TDateTime)
                          )) :: TFloat AS DayCount
           
           , COALESCE (MovementLinkMovement_Order.MovementId, 0) <> 0 AS isEDI 
           , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS IsRemains
           , MovementString_Comment.ValueData       AS Comment

           , MovementDate_StartBegin.ValueData  AS StartBegin
           , MovementDate_EndBegin.ValueData    AS EndBegin
           , EXTRACT (EPOCH FROM (COALESCE (MovementDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MovementDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

           , Object_Status_wms.Id                       AS StatusId_wms
           , Object_Status_wms.ObjectCode               AS StatusCode_wms
           , Object_Status_wms.ValueData                AS StatusName_wms

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_OrderExternal() AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                            AND Object_From.DescId = zc_Object_Unit()
            LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN tmpUnit AS tmpUnit_to ON tmpUnit_to.UnitId = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaIdKind
                                         ON MovementLinkObject_PaIdKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaIdKind.DescId = zc_MovementLinkObject_PaIdKind()
            LEFT JOIN Object AS Object_PaIdKind ON Object_PaIdKind.Id = MovementLinkObject_PaIdKind.ObjectId

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
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Status_wms
                                         ON MovementLinkObject_Status_wms.MovementId = Movement.Id
                                        AND MovementLinkObject_Status_wms.DescId = zc_MovementLinkObject_Status_wms()
            LEFT JOIN Object AS Object_Status_wms ON Object_Status_wms.Id = MovementLinkObject_Status_wms.ObjectId

       WHERE tmpRoleAccessKey.AccessKeyId > 0 OR tmpUnit_from.UnitId > 0 OR tmpUnit_to.UnitId > 0
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.08.20         *
 02.05.19         *
 05.10.16         * add inJurIdicalBasisId
 21.05.15         * add Retail, Partner
 19.02.15         * add OperDateStart, OperDateEnd
 20.10.14                                        * add isEDI
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternalUnit (inStartDate:= '01.01.2019', inEndDate:= '01.01.2019', inJuridicalBasisId:= 0, inIsErased := FALSE, inSession:= '2')
