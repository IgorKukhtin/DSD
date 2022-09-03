-- Function: gpGet_Movement_PersonalTransport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalTransport (Integer, TDateTime ,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalTransport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalTransport());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT 0 AS Id
            , CAST (NEXTVAL ('Movement_PersonalTransport_seq') as TVarChar) AS InvNumber
            , CURRENT_DATE ::TDateTime AS OperDate 
            , lfObject_Status.Code  AS StatusCode
            , lfObject_Status.Name  AS StatusName

            , DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 MONTH') ::TDateTime AS ServiceDate
            , ''       :: TVarChar  AS Comment

            , 0                     AS PersonalServiceListId
            , ''       :: TVarChar  AS PersonalServiceListName

            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyName
          --, View_InfoMoney.InfoMoneyName_all
            , ('(' || View_InfoMoney.InfoMoneyCode :: TVarChar || ') ' || View_InfoMoney.InfoMoneyGroupName || ' ' || View_InfoMoney.InfoMoneyName) :: TVarChar AS InfoMoneyName_all

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21421()
          
       ;
     ELSE
     RETURN QUERY 
       SELECT Movement.Id
            , Movement.InvNumber                 AS InvNumber
            , Movement.OperDate ::TDateTime      AS OperDate
            , Object_Status.ObjectCode           AS StatusCode
            , Object_Status.ValueData            AS StatusName

            , MovementDate_ServiceDate.ValueData AS ServiceDate
            , MovementString_Comment.ValueData   AS Comment

            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName

            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyName
            --, View_InfoMoney.InfoMoneyName_all
            , ('(' || View_InfoMoney.InfoMoneyCode :: TVarChar || ') ' || View_InfoMoney.InfoMoneyGroupName || ' ' || View_InfoMoney.InfoMoneyName) :: TVarChar AS InfoMoneyName_all
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21421()
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_PersonalTransport();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalTransport (inMovementId:= 0, inOperDate := CURRENT_DATE, inSession:= zfCalc_UserAdmin())
