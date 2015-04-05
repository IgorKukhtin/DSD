-- Function: gpSelect_Movement_Cash_Personal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalCash (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_Personal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inCashId        Integer , --
    IN inIsErased      Boolean   ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , MemberId Integer, MemberName TVarChar
             , InvNumber_Service TVarChar, OperDate_Service TDateTime
             , ServiceDate_Service TDateTime
             , Comment_Service TVarChar
             , PersonalServiceListName TVarChar
             , TotalSummToPay_Service TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
          , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
          , tmpAccessKey_isCashAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                 UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_CashAll()
                                      )
          , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll)
                           UNION SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash() AND EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll) GROUP BY AccessKeyId
                                )
          , tmpAll AS (SELECT tmpStatus.StatusId, tmpStatus.StartDate, tmpStatus.EndDate, tmpRoleAccessKey.AccessKeyId FROM tmpStatus, tmpRoleAccessKey)
          , Movement AS (SELECT Movement.*
                              , Object_Status.ObjectCode AS StatusCode
                              , Object_Status.ValueData  AS StatusName
                         FROM tmpAll
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_Cash()
                                                 AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate -- inStartDate AND inEndDate
                                                 AND Movement.StatusId = tmpAll.StatusId
                                                 AND Movement.AccessKeyId = tmpAll.AccessKeyId
                                                 AND Movement.ParentId > 0
                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                        )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusCode
           , Movement.StatusName
           , (-1 * MovementItem.Amount) :: TFloat AS Amount
  
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName

           , Object_Member.Id                  AS MemberId
           , Object_Member.ValueData           AS MemberName

           , Movement_PersonalService.InvNumber         AS InvNumber_Service
           , Movement_PersonalService.OperDate          AS OperDate_Service
           , MovementDate_ServiceDate_Service.ValueData AS ServiceDate_Service
           , MovementString_Comment_Service.ValueData   AS Comment_Service
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0) - COALESCE (MovementFloat_TotalSummCard.ValueData, 0) - COALESCE (MovementFloat_TotalSummChild.ValueData, 0)) :: TFloat AS TotalSummToPay_Service

       FROM Movement
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.ObjectId = inCashId OR COALESCE (inCashId, 0) = 0)
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                                           
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN Movement AS Movement_PersonalService
                               ON Movement_PersonalService.Id = Movement.Id
                              AND Movement_PersonalService.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement_PersonalService.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                    ON MovementFloat_TotalSummToPay.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChild
                                    ON MovementFloat_TotalSummChild.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummChild.DescId = zc_MovementFloat_TotalSummChild()

            LEFT JOIN MovementDate AS MovementDate_ServiceDate_Service
                                   ON MovementDate_ServiceDate_Service.MovementId = Movement_PersonalService.Id
                                  AND MovementDate_ServiceDate_Service.DescId = zc_MovementDate_ServiceDate()
            LEFT JOIN MovementString AS MovementString_Comment_Service
                                     ON MovementString_Comment_Service.MovementId = Movement_PersonalService.Id
                                    AND MovementString_Comment_Service.DescId = zc_MovementString_Comment()

       WHERE Movement.DescId = zc_Movement_Cash()
         AND Movement.ParentId > 0
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
      ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.04.15                                        * all
 18.01.15         * add member
 17.01.15         * add inCashId
 16.09.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Cash_Personal (inStartDate:= '30.01.2015', inEndDate:= '01.01.2015', inCashId:= 14462, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
