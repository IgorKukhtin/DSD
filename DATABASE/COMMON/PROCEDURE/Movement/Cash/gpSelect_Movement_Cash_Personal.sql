-- Function: gpSelect_Movement_Cash_Personal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_Personal(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inCashId            Integer , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsServiceDate     Boolean ,
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
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
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     IF NOT EXISTS (SELECT 1 FROM Object_PersonalServiceList_User_View WHERE Object_PersonalServiceList_User_View.UserId = vbUserId AND Object_PersonalServiceList_User_View.PersonalServiceListId > 0)
     THEN PERFORM lpCheck_UserRole_8813637 (vbUserId);
     END IF;


     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     -- Результат
     RETURN QUERY 
         WITH tmpDate AS (SELECT inStartDate AS StartDate, inEndDate AS EndDate WHERE inIsServiceDate = FALSE
                         UNION
                          SELECT DATE_TRUNC ('MONTH', inStartDate)                                       AS StartDate
                               , DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
                          WHERE inIsServiceDate = TRUE
                         )
          , tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId, tmpDate.StartDate, tmpDate.EndDate FROM tmpDate
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId, tmpDate.StartDate, tmpDate.EndDate FROM tmpDate
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId, tmpDate.StartDate, tmpDate.EndDate FROM tmpDate WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
          , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
          , tmpAccessKey_isCashAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId AND vbUserId <> 6131893 -- Черняєва О.А.
                                 UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_CashAll() AND vbUserId <> 6131893 -- Черняєва О.А.
                                 UNION SELECT 1 WHERE vbUserId = 14599 -- Коротченко Т.Н.
                                      )
          , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll)
                           UNION SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash() AND EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll) GROUP BY AccessKeyId
                                )
          , tmpAll AS (SELECT tmpStatus.StatusId, tmpStatus.StartDate, tmpStatus.EndDate, tmpRoleAccessKey.AccessKeyId FROM tmpStatus, tmpRoleAccessKey)
          , tmpMovement AS (SELECT Movement.*
                                 , Object_Status.ObjectCode AS StatusCode
                                 , Object_Status.ValueData  AS StatusName
                            FROM tmpAll
                                 INNER JOIN Movement ON Movement.DescId = zc_Movement_Cash()
                                                    AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate -- inStartDate AND inEndDate
                                                    AND Movement.StatusId = tmpAll.StatusId
                                                    AND Movement.AccessKeyId = tmpAll.AccessKeyId
                                                    AND Movement.ParentId > 0
                                 LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                            WHERE inIsServiceDate = FALSE
                           UNION ALL
                            SELECT Movement.*
                                 , Object_Status.ObjectCode AS StatusCode
                                 , Object_Status.ValueData  AS StatusName
                            FROM tmpAll
                                 INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                         ON MovementDate_ServiceDate.ValueData BETWEEN tmpAll.StartDate AND tmpAll.EndDate
                                                        AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                 INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                    AND Movement.DescId = zc_Movement_Cash()
                                                    AND Movement.StatusId = tmpAll.StatusId
                                                    AND Movement.AccessKeyId = tmpAll.AccessKeyId
                                                    AND Movement.ParentId > 0
                                 LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                            WHERE inIsServiceDate = TRUE
                           )  
          , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)

            -- !!!права!!!
          , tmpPersonalServiceList_User AS (SELECT Object_PersonalServiceList_User_View.PersonalServiceListId FROM Object_PersonalServiceList_User_View WHERE Object_PersonalServiceList_User_View.UserId = vbUserId
                                           UNION
                                            SELECT Object_PersonalServiceList.Id
                                            FROM Object AS Object_PersonalServiceList
                                            WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                            AND EXISTS (SELECT 1 FROM tmpAccessKey_isCashAll)
                                           )


       SELECT
             tmpMovement.Id
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.StatusCode
           , tmpMovement.StatusName
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
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCard.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecond.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecondCash.ValueData, 0)
             ) :: TFloat AS TotalSummToPay_Service

           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           
       FROM tmpMovement
            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id 
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
                               ON Movement_PersonalService.Id = tmpMovement.ParentId
                              AND Movement_PersonalService.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement_PersonalService.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId
            
            LEFT JOIN tmpPersonalServiceList_User ON tmpPersonalServiceList_User.PersonalServiceListId = Object_PersonalServiceList.Id

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                    ON MovementFloat_TotalSummToPay.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                    ON MovementFloat_TotalSummCardSecond.MovementId =  Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondCash
                                    ON MovementFloat_TotalSummCardSecondCash.MovementId = Movement_PersonalService.Id
                                   AND MovementFloat_TotalSummCardSecondCash.DescId = zc_MovementFloat_TotalSummCardSecondCash()
                                   
            LEFT JOIN MovementDate AS MovementDate_ServiceDate_Service
                                   ON MovementDate_ServiceDate_Service.MovementId = Movement_PersonalService.Id
                                  AND MovementDate_ServiceDate_Service.DescId = zc_MovementDate_ServiceDate()
            LEFT JOIN MovementString AS MovementString_Comment_Service
                                     ON MovementString_Comment_Service.MovementId = Movement_PersonalService.Id
                                    AND MovementString_Comment_Service.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
       WHERE tmpPersonalServiceList_User.PersonalServiceListId > 0
          OR Object_PersonalServiceList.Id IS NULL
      ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.22         *
 07.10.16         * add inJuridicalBasisId
 04.04.15                                        * all
 18.01.15         * add member
 17.01.15         * add inCashId
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash_Personal (inStartDate:= '01.01.2024', inEndDate:= '01.01.2024', inCashId:= 14462, inJuridicalBasisId:=0, inIsServiceDate:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
