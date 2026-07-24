-- Function: gpGet_Movement_SaleCommerc()

DROP FUNCTION IF EXISTS gpGet_Movement_SaleCommerc (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SaleCommerc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
          vbOperDate TDateTime;
          vbMemberId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
       SELECT
            0 AS Id
          , CAST (NEXTVAL ('Movement_SaleCommerc_seq') AS TVarChar) AS InvNumber
            -- Дата док.
          , inOperDate :: TDateTime                    AS OperDate
            --
          , Object_Status.Code                         AS StatusCode
          , Object_Status.Name                         AS StatusName

          , CAST ('' AS TVarChar) 	                  AS Comment

          , Object_Insert.ValueData         ::TVarChar AS InsertName
          , CURRENT_TIMESTAMP ::TDateTime              AS InsertDate

          , CAST ('' AS TVarChar)                      AS UpdateName
          , CAST (NULL AS TDateTime)                   AS UpdateDate

       FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
             -- Дата док.
           , Movement.OperDate                                  AS OperDate
             --
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName

           , MovementString_Comment.ValueData       AS Comment

           , COALESCE (Object_Insert.ValueData,'' ) ::TVarChar  AS InsertName
           , MovementDate_Insert.ValueData          ::TDateTime AS InsertDate
           , Object_Update.ValueData                AS UpdateName
           , MovementDate_Update.ValueData          AS UpdateDate

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

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_SaleCommerc();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.26         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_SaleCommerc (inMovementId:= 0, inOperDate:= CURRENT_DATE, inSession:= '9818')
