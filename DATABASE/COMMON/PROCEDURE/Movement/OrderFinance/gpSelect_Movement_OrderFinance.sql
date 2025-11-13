-- Function: gpSelect_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OrderFinanceId Integer, OrderFinanceName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar
             , WeekNumber TFloat
             , TotalSumm TFloat, TotalSumm_1 TFloat, TotalSumm_2 TFloat, TotalSumm_3 TFloat
             , AmountPlan_1 TFloat, AmountPlan_2 TFloat, AmountPlan_3 TFloat, AmountPlan_4 TFloat, AmountPlan_5 TFloat
             , StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime
             , DateUpdate_report TDateTime
             , UserUpdate_report TVarChar
             , UserMember_1      TVarChar
             , UserMember_2      TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , UnitName_insert     TVarChar
             , PositionName_insert TVarChar
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        /*, tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/

       --
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , Object_OrderFinance.Id                 AS OrderFinanceId
           , Object_OrderFinance.ValueData          AS OrderFinanceName

           , Object_BankAccount_View.Id             AS BankAccountId
           , Object_BankAccount_View.Name           AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

           , MovementFloat_WeekNumber.ValueData                            AS WeekNumber
           , COALESCE (MovementFloat_TotalSumm.Valuedata, 0)    ::TFloat   AS TotalSumm
           , COALESCE (MovementFloat_TotalSumm_1.Valuedata, 0)  ::TFloat   AS TotalSumm_1
           , COALESCE (MovementFloat_TotalSumm_2.Valuedata, 0)  ::TFloat   AS TotalSumm_2
           , COALESCE (MovementFloat_TotalSumm_3.Valuedata, 0)  ::TFloat   AS TotalSumm_3 
           
           , COALESCE (MovementFloat_AmountPlan_1.Valuedata, 0) ::TFloat   AS AmountPlan_1
           , COALESCE (MovementFloat_AmountPlan_2.Valuedata, 0) ::TFloat   AS AmountPlan_2
           , COALESCE (MovementFloat_AmountPlan_3.Valuedata, 0) ::TFloat   AS AmountPlan_3
           , COALESCE (MovementFloat_AmountPlan_4.Valuedata, 0) ::TFloat   AS AmountPlan_4
           , COALESCE (MovementFloat_AmountPlan_5.Valuedata, 0) ::TFloat   AS AmountPlan_5

           , DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', Movement.OperDate) + ((((7 * COALESCE (MovementFloat_WeekNumber.ValueData - 1, 0)) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL) ::TDateTime AS StartDate_WeekNumber
           , (DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', Movement.OperDate) + ((((7 * COALESCE (MovementFloat_WeekNumber.ValueData - 1, 0)) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL) + INTERVAL '6 DAY') ::TDateTime AS EndDate_WeekNumber

           , MovementDate_Update_report.ValueData ::TDateTime AS DateUpdate_report
           , Object_Update_report.ValueData       ::TVarChar  AS UserUpdate_report
           , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
           , Object_Member_2.ValueData            ::TVarChar  AS UserMember_2

           , MovementString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Update.ValueData                AS UpdateName
           , MovementDate_Update.ValueData          AS UpdateDate

           , Object_Unit_insert.ValueData      ::TVarChar AS UnitName_insert
           , Object_Position_insert.ValueData  ::TVarChar AS PositionName_insert

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_OrderFinance() AND Movement.StatusId = tmpStatus.StatusId
                  --JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


            LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                    ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

            LEFT JOIN MovementFloat AS MovementFloat_AmountPlan_1
                                    ON MovementFloat_AmountPlan_1.MovementId = Movement.Id
                                   AND MovementFloat_AmountPlan_1.DescId = zc_MovementFloat_AmountPlan_1()
            LEFT JOIN MovementFloat AS MovementFloat_AmountPlan_2
                                    ON MovementFloat_AmountPlan_2.MovementId = Movement.Id
                                   AND MovementFloat_AmountPlan_2.DescId = zc_MovementFloat_AmountPlan_2()
            LEFT JOIN MovementFloat AS MovementFloat_AmountPlan_3
                                    ON MovementFloat_AmountPlan_3.MovementId = Movement.Id
                                   AND MovementFloat_AmountPlan_3.DescId = zc_MovementFloat_AmountPlan_3()
            LEFT JOIN MovementFloat AS MovementFloat_AmountPlan_4
                                    ON MovementFloat_AmountPlan_4.MovementId = Movement.Id
                                   AND MovementFloat_AmountPlan_4.DescId = zc_MovementFloat_AmountPlan_4()
            LEFT JOIN MovementFloat AS MovementFloat_AmountPlan_5
                                    ON MovementFloat_AmountPlan_5.MovementId = Movement.Id
                                   AND MovementFloat_AmountPlan_5.DescId = zc_MovementFloat_AmountPlan_5()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_1
                                    ON MovementFloat_TotalSumm_1.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_1.DescId = zc_MovementFloat_TotalSumm_1()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_2
                                    ON MovementFloat_TotalSumm_2.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_2.DescId = zc_MovementFloat_TotalSumm_2()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_3
                                    ON MovementFloat_TotalSumm_3.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_3.DescId = zc_MovementFloat_TotalSumm_3()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                         ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                        AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
            LEFT JOIN Object AS Object_OrderFinance ON Object_OrderFinance.Id = MovementLinkObject_OrderFinance.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update_report
                                         ON MovementLinkObject_Update_report.MovementId = Movement.Id
                                        AND MovementLinkObject_Update_report.DescId = zc_MovementLinkObject_Update_report()
            LEFT JOIN Object AS Object_Update_report ON Object_Update_report.Id = MovementLinkObject_Update_report.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_1
                                         ON MovementLinkObject_Member_1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
            LEFT JOIN Object AS Object_Member_1 ON Object_Member_1.Id = MovementLinkObject_Member_1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_2
                                         ON MovementLinkObject_Member_2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member_2.DescId = zc_MovementLinkObject_Member_2()
            LEFT JOIN Object AS Object_Member_2 ON Object_Member_2.Id = MovementLinkObject_Member_2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit_insert ON Object_Unit_insert.Id = MovementLinkObject_Member_2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                         ON MovementLinkObject_Position.MovementId = Movement.Id
                                        AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position_insert ON Object_Position_insert.Id = MovementLinkObject_Position.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update_report
                                   ON MovementDate_Update_report.MovementId = Movement.Id
                                  AND MovementDate_Update_report.DescId = zc_MovementDate_Update_report()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.25         *
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance (inStartDate:= '01.11.2021', inEndDate:= '30.11.2021', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
