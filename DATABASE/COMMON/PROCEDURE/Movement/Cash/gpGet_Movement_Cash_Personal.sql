-- Function: gpGet_Movement_Cash_Personal()

--DROP FUNCTION IF EXISTS gpGet_Movement_PersonalCash (Integer, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Personal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Personal (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Personal(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inCashId            Integer   , -- касса
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ParentId Integer, ParentName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , PersonalServiceListName TVarChar, PersonalServiceListId Integer
             , MemberId Integer, MemberName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash_Personal());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_cash_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                AS OperDate
           , inOperDate                                        AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
     
           , 0                      AS ParentId
           , '' :: TVarChar         AS ParentName
           
           , 0::TFloat                                         AS Amount

           , DATE_TRUNC ('Month', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
           , '' :: TVarChar         AS Comment
           , COALESCE (Object_Cash.Id, 0)                      AS CashId
           , COALESCE (Object_Cash.ValueData, '') :: TVarChar  AS CashName
           , '' :: TVarChar         AS PersonalServiceListName
           , 0                      AS PersonalServiceListId
           , 0                                                 AS MemberId
           , CAST ('' as TVarChar)                             AS MemberName

           , 0                                                 AS InfoMoneyId
           , CAST ('' as TVarChar)                             AS InfoMoneyName
           
       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
           LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = inCashId 
                                                                        -- IN (SELECT MIN (Object.Id) FROM Object WHERE Object.AccessKeyId IN (SELECT MIN (lpGetAccessKey) FROM lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Cash())))
            
      ;
     ELSE
     
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

           , COALESCE (MD_ServiceDate.ValueData, MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_Cash.Id                    AS CashId
           , (Object_Cash.ValueData || CASE WHEN Object_Currency.Id <> zc_Enum_Currency_Basis() THEN ' * ' || Object_Currency.ValueData ELSE '' END) :: TVarChar AS CashName

           , Object_PersonalServiceList.ValueData AS PersonalServiceListName
           , Object_PersonalServiceList.Id     AS PersonalServiceListId

           , Object_Member.Id                  AS MemberId
           , Object_Member.ValueData           AS MemberName    

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
                    
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN Movement AS MovementPersonalService 
                               ON MovementPersonalService.Id = Movement.ParentId
                              AND MovementPersonalService.DescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport())
            LEFT JOIN MovementDate AS MD_ServiceDate
                                   ON MD_ServiceDate.MovementId = MovementPersonalService.Id
                                  AND MD_ServiceDate.DescId     = zc_MovementDate_ServiceDate()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = COALESCE (MovementPersonalService.Id, Movement.Id)
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, MILinkObject_MoneyPlace.ObjectId)

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId


            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

       WHERE Movement.Id =  inMovementId
       LIMIT 1
      ;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.02.15         add Member
 16.09.14         * 

*/

-- тест
-- SELECT * FROM gpGet_Movement_Cash_Personal (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin());
