-- Function: gpGet_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpGet_Movement_EmployeeSchedule (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_EmployeeSchedule(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             )
AS
$BODY$
   DECLARE vbOperDate TDateTime;
BEGIN
    
    vbOperDate := date_trunc('month', inOperDate);
    
    IF COALESCE (inMovementId, 0) = 0
    THEN

        -- проверка прав пользователя на вызов процедуры
        IF inSession::Integer NOT IN (3, 758920, 4183126, 9383066, 8037524)
        THEN
  	      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
        END IF;

        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_EmployeeSchedule_seq')  AS TVarChar) AS InvNumber
          , vbOperDate::TDateTime                            AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                 AS StatusCode
          , Object_Status.ValueData                  AS StatusName

        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_EmployeeSchedule (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.09.18         *
*/

-- select * from gpGet_Movement_EmployeeSchedule(inMovementId := 0 , inOperDate := ('30.07.2018')::TDateTime ,  inSession := '3');
