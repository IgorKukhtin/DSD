-- Function: gpGet_Movement_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpGet_Movement_ServiceItemAdd (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ServiceItemAdd (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ServiceItemAdd(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,  
    IN inInfoMoneyId       Integer   ,
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime 
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime 
             , InfoMoneyId Integer, InfoMoneyName TVarChar 
             , Comment TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar)  AS InvNumber
           , CURRENT_DATE                          :: TDateTime       AS OperDate
           , Object_Status.ObjectCode                                 AS StatusCode
           , Object_Status.ValueData                                  AS StatusName
           , Object_Insert.ValueData               :: TVarChar        AS InsertName
           , CURRENT_TIMESTAMP                     :: TDateTime       AS InsertDate
           , ''                                    :: TVarChar        AS UpdateName
           , NULL                                  :: TDateTime       AS UpdateDate

           , Object_InfoMoney.Id         AS InfoMoneyId
           , Object_InfoMoney.ValueData  AS InfoMoneyName
           , ''                                    ::TVarChar         AS Comment
       FROM Object AS Object_Insert
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = zc_Enum_Status_UnComplete()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE (inInfoMoneyId, 76878)   -- _Аренда
       WHERE Object_Insert.Id = vbUserId
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate   

           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

           , Object_InfoMoney.Id         AS InfoMoneyId
           , Object_InfoMoney.ValueData  AS InfoMoneyName                        

           , COALESCE (MovementString_Comment.ValueData,'') ::TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE (inInfoMoneyId, 76878)   -- _Аренда 

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.Id = inMovementId_Value;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.22         *
 31.05.22         *
 */

-- тест
-- select * from gpGet_Movement_ServiceItemAdd(inMovementId := 0 , inMovementId_Value := 0 , inOperDate := ('01.06.2022')::TDateTime ,  inSession := '5');
