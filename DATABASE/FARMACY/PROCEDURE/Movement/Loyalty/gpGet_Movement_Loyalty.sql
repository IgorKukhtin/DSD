-- Function: gpGet_Movement_Loyalty()

DROP FUNCTION IF EXISTS gpGet_Movement_Loyalty (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Loyalty(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusCode    Integer
             , StatusName    TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , StartSale     TDateTime
             , EndSale       TDateTime
             , StartSummCash TFloat
             , MonthCount    Integer
             , DayCount      Integer
             , SummLimit     TFloat
             , ChangePercent TFloat
             , ServiceDate   TDateTime
             , InsertId      Integer
             , InsertName    TVarChar
             , InsertDate    TDateTime
             , UpdateId      Integer
             , UpdateName    TVarChar
             , UpdateDate    TDateTime
             , Comment       TVarChar)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    vbUserId := inSession;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                           AS Id
          , CAST (NEXTVAL ('movement_Loyalty_seq') AS TVarChar) AS InvNumber
          , inOperDate		            AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , Null  :: TDateTime          AS StartPromo
          , Null  :: TDateTime          AS EndPromo 
          , Null  :: TDateTime          AS StartSale
          , Null  :: TDateTime          AS EndSale
          , 0     ::TFloat              AS StartSummCash
          , 0     ::Integer             AS MonthCount
          , 0     ::Integer             AS DayCount
          , 0     ::TFloat              AS SummLimit
          , 0     ::TFloat              AS ChangePercent
          , Null  :: TDateTime          AS ServiceDate
          , NULL  ::Integer             AS InsertId
          , Object_Insert.ValueData     AS InsertName
          , CURRENT_TIMESTAMP :: TDateTime AS InsertDate
          , NULL  ::Integer             AS UpdateId
          , NULL  ::TVarChar            AS UpdateName
          , Null  :: TDateTime          AS UpdateDate
          , NULL  ::TVarChar            AS Comment
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , MovementDate_StartSale.ValueData                               AS StartSale
          , MovementDate_EndSale.ValueData                                 AS EndSale
          , COALESCE(MovementFloat_StartSummCash.ValueData,0)::TFloat      AS StartSummCash
          , COALESCE(MovementFloat_MonthCount.ValueData,0)::Integer        AS MonthCount
          , COALESCE(MovementFloat_DayCount.ValueData,0)::Integer          AS DayCount
          , COALESCE(MovementFloat_Limit.ValueData,0)::TFloat              AS SummLimit
          , MovementFloat_ChangePercent.ValueData                          AS ChangePercent
          , MovementDate_ServiceDate.ValueData                             AS ServiceDate
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_StartSummCash
                                ON MovementFloat_StartSummCash.MovementId =  Movement.Id
                               AND MovementFloat_StartSummCash.DescId = zc_MovementFloat_StartSummCash()
        LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                ON MovementFloat_MonthCount.MovementId =  Movement.Id
                               AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
        LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                ON MovementFloat_DayCount.MovementId =  Movement.Id
                               AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
        LEFT JOIN MovementFloat AS MovementFloat_Limit
                                ON MovementFloat_Limit.MovementId =  Movement.Id
                               AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                               ON MovementDate_EndSale.MovementId = Movement.Id
                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
        LEFT JOIN MovementDate AS MovementDate_ServiceDate
                               ON MovementDate_ServiceDate.MovementId = Movement.Id
                              AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

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
        
     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.  Шаблий О.В.
 12.09.18                                                                                  *
 13.12.17         *
*/

--тест 
--select * from gpGet_Movement_Loyalty(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_Loyalty(inMovementId := 1923638 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');