-- Function: gpGet_Movement_PermanentDiscount()

DROP FUNCTION IF EXISTS gpGet_Movement_PermanentDiscount (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PermanentDiscount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , RetailId Integer, RetailName TVarChar
             , StartPromo    TDateTime, EndPromo      TDateTime
             , ChangePercent TFloat
             , InsertId      Integer, InsertName    TVarChar, InsertDate    TDateTime
             , UpdateId      Integer, UpdateName    TVarChar, UpdateDate    TDateTime
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PermanentDiscount());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_PermanentDiscount_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate  --inOperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     				            AS RetailId
             , CAST ('' AS TVarChar) 				            AS RetailName
             , Null  :: TDateTime                               AS StartPromo
             , Null  :: TDateTime                               AS EndPromo 
             , CAST (0 AS TFloat)                               AS ChangePercent
             , NULL  ::Integer                                  AS InsertId
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP :: TDateTime                   AS InsertDate
             , NULL  ::Integer                                  AS UpdateId
             , NULL  ::TVarChar                                 AS UpdateName
             , Null  :: TDateTime                               AS UpdateDate
             , CAST ('' AS TVarChar) 		                    AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id                                              AS Id
           , Movement.InvNumber                                       AS InvNumber
           , Movement.OperDate                                        AS OperDate
           , Object_Status.ObjectCode                                 AS StatusCode
           , Object_Status.ValueData                                  AS StatusName
           , Object_Retail.Id                                         AS RetailId
           , Object_Retail.ValueData                                  AS RetailName
           , MovementDate_StartPromo.ValueData                        AS StartPromo
           , MovementDate_EndPromo.ValueData                          AS EndPromo
           , MovementFloat_ChangePercent.ValueData                    AS ChangePercent
           , Object_Insert.Id                                         AS InsertId
           , Object_Insert.ValueData                                  AS InsertName
           , MovementDate_Insert.ValueData                            AS InsertDate
           , Object_Update.Id                                         AS UpdateId
           , Object_Update.ValueData                                  AS UpdateName
           , MovementDate_Update.ValueData                            AS UpdateDate
           , COALESCE (MovementString_Comment.ValueData,'')::TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
                                  
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId  

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_PermanentDiscount();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PermanentDiscount (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.12.19                                                       *
 */

-- тест
-- select * from gpGet_Movement_PermanentDiscount(inMovementId := 16831188 , inOperDate := ('31.12.2019')::TDateTime ,  inSession := '3');