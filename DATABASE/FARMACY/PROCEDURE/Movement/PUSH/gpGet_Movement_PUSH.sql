-- Function: gpGet_Movement_PUSH()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , DateEndPUSH TDateTime
             , Replays Integer
             , Daily Boolean
             , Message TBlob
             )
AS
$BODY$
BEGIN
    
    
    IF COALESCE (inMovementId, 0) = 0
    THEN

        -- проверка прав пользователя на вызов процедуры
        IF 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 8001630 <> inSession::Integer AND 3 <> inSession::Integer
        THEN
  	      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
        END IF;

        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_EmployeeSchedule_seq')  AS TVarChar) AS InvNumber
          , CURRENT_TIMESTAMP::TDateTime                     AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , date_trunc('day', CURRENT_TIMESTAMP + INTERVAL '1 DAY')::TDateTime  AS DateEndPUSH
          , 1::Integer                                       AS Replays
          , False::Boolean                                   AS Message
          , Null::TBlob                                      AS Message

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                         AS StatusCode
          , Object_Status.ValueData                          AS StatusName
          , MovementDate_DateEndPUSH.ValueData               AS DateEndPUSH
          , MovementFloat_Replays.ValueData::Integer         AS Replays  
          , COALESCE(MovementBoolean_Daily.ValueData, False) AS Daily
          , MovementBlob_Message.ValueData                   AS Message

        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_Replays
                                   ON MovementFloat_Replays.MovementId = Movement.Id
                                  AND MovementFloat_Replays.DescId = zc_MovementFloat_Replays()

            LEFT JOIN MovementBlob AS MovementBlob_Message
                                   ON MovementBlob_Message.MovementId = Movement.Id
                                  AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

            LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                   ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                  AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()
                                              
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementBoolean AS MovementBoolean_Daily
                                      ON MovementBoolean_Daily.MovementId = Movement.Id
                                     AND MovementBoolean_Daily.DescId = zc_MovementBoolean_PUSHDaily()

        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_EmployeeSchedule (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 11.05.19         *
 10.03.19         *
*/

-- select * from gpGet_Movement_PUSH(inMovementId := 0 , inOperDate := ('30.07.2018')::TDateTime,  inSession := '3');

