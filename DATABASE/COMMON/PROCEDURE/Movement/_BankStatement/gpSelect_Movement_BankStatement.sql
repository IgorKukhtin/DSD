-- Function: gpSelect_Movement_BankStatement()

-- DROP FUNCTION gpSelect_Movement_BankStatement (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankStatement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , FileName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
              )
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankStatement());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , MovementString_FileName.ValueData AS FileName

           , Object_BankAccount.Id          AS BankAccountId
           , Object_BankAccount.ValueData   AS BankAccountName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_FileName
                                     ON MovementString_FileName.MovementId =  Movement.Id
                                    AND MovementString_FileName.DescId = zc_MovementString_FileName()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementLinkObject_BankAccount.ObjectId

       WHERE Movement.DescId = zc_Movement_BankStatement()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_BankStatement (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 08.08.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_BankStatement (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
