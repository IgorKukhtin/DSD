-- Function: gpGet_Movement_BankAccount_Personal()

--DROP FUNCTION IF EXISTS gpGet_Movement_PersonalBankAccount (Integer, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount_Personal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount_Personal (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccount_Personal(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inBankAccountId            Integer   , -- касса
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ParentId Integer, ParentName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , PersonalServiceListName TVarChar, PersonalServiceListId Integer
             , MemberId Integer, MemberName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_BankAccount_Personal());
     vbUserId := lpGetUserBySession (inSession);

    
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementPersonalService.Id         AS ParentId
           , MovementPersonalService.InvNumber  AS ParentName  
                    
           , MovementItem.Amount

           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_BankAccount.Id                    AS BankAccountId
           , Object_BankAccount.ValueData             AS BankAccountName
           , Object_PersonalServiceList.ValueData AS PersonalServiceListName
           , Object_PersonalServiceList.Id     AS PersonalServiceListId

           , Object_Member.Id                  AS MemberId
           , Object_Member.ValueData           AS MemberName
                    
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Movement AS MovementPersonalService 
                               ON MovementPersonalService.Id = Movement.ParentId
                              AND MovementPersonalService.DescId = zc_Movement_PersonalService()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = MovementPersonalService.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId
      
       WHERE Movement.Id =  inMovementId;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Movement_BankAccount_Personal (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.02.15         add Member
 16.09.14         * 

*/

-- тест
-- SELECT * FROM gpGet_Movement_BankAccount_Personal (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin());
