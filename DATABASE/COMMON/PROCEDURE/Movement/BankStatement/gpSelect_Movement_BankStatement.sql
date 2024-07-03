-- Function: gpSelect_Movement_BankStatement()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatement (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatement (TDateTime, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatement (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankStatement (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankStatement(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- Главное юр.лицо   
    IN inAccountId         Integer   , -- (Павильоны) -  10895486   ()
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , JuridicalName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankStatement());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , Object_BankAccount_View.Id          AS BankAccountId
           , Object_BankAccount_View.Name        AS BankAccountName
           , Object_BankAccount_View.BankId
           , Object_BankAccount_View.BankName
           , Object_BankAccount_View.JuridicalName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_BankStatement()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId  
            
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Account
                                 ON ObjectLink_BankAccount_Account.ObjectId = Object_BankAccount_View.Id
                                AND ObjectLink_BankAccount_Account.DescId = zc_ObjectLink_BankAccount_Account()

       WHERE (  (inAccountId > 0 AND ObjectLink_BankAccount_Account.ChildObjectId = inAccountId)
             OR (inAccountId < 0 AND COALESCE (ObjectLink_BankAccount_Account.ChildObjectId,0) <> (-1) * inAccountId)
             OR inAccountId = 0
             --OR vbUserId = 5
             --OR vbUserId = 6604558
             )            
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.10.16         * add inJuridicalBasisId
 03.02.14                                        * add inIsErased
 23.01.14                        *              
 15.11.13                        *              
 08.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_BankStatement (inStartDate:= '01.05.2024', inEndDate:= '01.05.2024', inJuridicalBasisId:=0, inAccountId:=-10895486 ,inIsErased:= FALSE, inSession:= '2')
