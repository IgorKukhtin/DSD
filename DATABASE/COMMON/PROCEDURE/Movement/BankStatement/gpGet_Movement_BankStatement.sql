-- Function: gpGet_Movement_BankStatement()

DROP FUNCTION IF EXISTS gpGet_Movement_BankStatement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankStatement(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , ServiceDate TDateTime
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankStatement());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , CASE WHEN EXTRACT (DAY FROM Movement.OperDate) < 15
             THEN
                 DATE_TRUNC ('MONTH', Movement.OperDate - INTERVAL '1 MONTH')
             ELSE
                 DATE_TRUNC ('MONTH', Movement.OperDate)
             END :: TDateTime AS ServiceDate

           , Object_BankAccount_View.Id          AS BankAccountId
           , Object_BankAccount_View.Name        AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           --
           , 0            AS PersonalServiceListId
           , ''::TVarChar AS PersonalServiceListName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

       WHERE Movement.Id =  inMovementId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_BankStatement (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.13                        *              
 08.08.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_BankStatement (inMovementId:= 1, inSession:= '2')
