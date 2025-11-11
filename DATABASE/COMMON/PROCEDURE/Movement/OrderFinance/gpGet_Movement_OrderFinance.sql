-- Function: gpGet_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OrderFinanceId Integer, OrderFinanceName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar, BankAccountNameAll TVarChar
             , WeekNumber TFloat, StartDate_WeekNumber TDateTime, EndDate_WeekNumber TDateTime   
             , DateUpdate_report TDateTime
             , UserUpdate_report TVarChar 
             , UserMemberId_1 Integer, UserMember_1 TVarChar 
             , UserMemberId_2 Integer, UserMember_2 TVarChar 
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , UnitName_insert     TVarChar
             , PositionName_insert TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
          vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_OrderFinance_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                                                AS OrderFinanceId
             , CAST ('' AS TVarChar) 		                    AS OrderFinanceName

             , 0                                                AS BankAccountId
             , CAST ('' AS TVarChar)                            AS BankAccountName
             , 0                                                AS BankId
             , CAST ('' AS TVarChar)                            AS BankName
             , CAST ('' AS TVarChar)                            AS BankAccountNameAll

             , (EXTRACT (Week FROM inOperDate) +1)  ::TFloat    AS WeekNumber
             , DATE_TRUNC('week', inOperDate + INTERVAL'7 days')                     ::TDateTime AS StartDate_WeekNumber
             , (DATE_TRUNC('week', inOperDate + INTERVAL'7 days') + INTERVAL '6 days') ::TDateTime AS EndDate_WeekNumber
             , CAST (NULL AS TDateTime)                         AS DateUpdate_report
             , ''                                   ::TVarChar  AS UserUpdate_report
             , 0                                    ::Integer   AS UserMemberId_1
             , ''                                   ::TVarChar  AS UserMember_1
             , 0                                    ::Integer   AS UserMemberId_2
             , ''                                   ::TVarChar  AS UserMember_2
             , CAST ('' AS TVarChar) 	                        AS Comment

             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate

             , CAST ('' AS TVarChar)                            AS UpdateName
             , CAST (NULL AS TDateTime)                         AS UpdateDate
           
             , ''                                   ::TVarChar AS UnitName_insert
             , ''                                   ::TVarChar AS PositionName_insert
           
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
     WITH
     tmpWeekNumber AS (WITH
                       --берем от от даты документа + 300 дней, 
                       tmpDataWeek AS ( vbOperDate :: TDateTime , vbOperDate + INTERVAL '300 DAY', '1 week' :: INTERVAL) AS OperDate)
                       --(SELECT GENERATE_SERIES (DATE_TRUNC ('YEAR', vbOperDate) :: TDateTime , CURRENT_DATE + INTERVAL '100 DAY', '1 week' :: INTERVAL) AS OperDate)
                       
                       SELECT DATE_TRUNC ('WEEK', tmp.OperDate)                     :: TDateTime AS Monday
                            , (DATE_TRUNC ('WEEK', tmp.OperDate)+ INTERVAL '6 DAY') :: TDateTime AS Sunday
                            , (EXTRACT (Week FROM tmp.OperDate) )                   :: Integer   AS WeekNumber
                       FROM tmpDataWeek AS tmp
                       )

       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName

           , Object_OrderFinance.Id                             AS OrderFinanceId
           , Object_OrderFinance.ValueData                      AS OrderFinanceName

           , Object_BankAccount_View.Id                         AS BankAccountId
           , Object_BankAccount_View.Name                       AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , (Object_BankAccount_View.BankName || '' || Object_BankAccount_View.Name) :: TVarChar AS BankAccountNameAll

           , COALESCE (MovementFloat_WeekNumber.ValueData, (EXTRACT (Week FROM vbOperDate) +1)) ::TFloat    AS WeekNumber
           , tmpWeekNumber.Monday                 ::TDateTime AS StartDate_WeekNumber
           , tmpWeekNumber.Sunday                 ::TDateTime AS EndDate_WeekNumber

           , MovementDate_Update_report.ValueData ::TDateTime AS DateUpdate_report
           , Object_Update_report.ValueData       ::TVarChar  AS UserUpdate_report
           , Object_Member_1.Id                   ::Integer   AS UserMemberId_1
           , Object_Member_1.ValueData            ::TVarChar  AS UserMember_1
           , Object_Member_2.Id                   ::Integer   AS UserMemberId_2
           , Object_Member_2.ValueData            ::TVarChar  AS UserMember_2

           , MovementString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Update.ValueData                AS UpdateName
           , MovementDate_Update.ValueData          AS UpdateDate
           
           , Object_Unit_insert.ValueData      ::TVarChar AS UnitName_insert
           , Object_Position_insert.ValueData  ::TVarChar AS PositionName_insert

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                    ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()

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
            
            LEFT JOIN tmpWeekNumber ON tmpWeekNumber.WeekNumber = COALESCE (MovementFloat_WeekNumber.ValueData, (EXTRACT (Week FROM vbOperDate) +1))
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderFinance();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.25
 29.07.19         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance (inMovementId:= 0, inOperDate:= CURRENT_DATE, inSession:= '9818')
