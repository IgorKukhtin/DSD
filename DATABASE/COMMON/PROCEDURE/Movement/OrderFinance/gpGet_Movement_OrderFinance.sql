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
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);


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
             , CAST ('' AS TVarChar) 		                AS OrderFinanceName

             , 0                                                AS BankAccountId
             , CAST ('' AS TVarChar)                            AS BankAccountName
             , 0                                                AS BankId
             , CAST ('' AS TVarChar)                            AS BankName
             , CAST ('' AS TVarChar)                            AS BankAccountNameAll

             , CAST ('' AS TVarChar) 		                AS Comment

             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate

             , CAST ('' AS TVarChar)                            AS UpdateName
             , CAST (NULL AS TDateTime)                         AS UpdateDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
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

           , MovementString_Comment.ValueData                   AS Comment

           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

           , Object_Update.ValueData                            AS UpdateName
           , MovementDate_Update.ValueData                      AS UpdateDate

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderFinance();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
