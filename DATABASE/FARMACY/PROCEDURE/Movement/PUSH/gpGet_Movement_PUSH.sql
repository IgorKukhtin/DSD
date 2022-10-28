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
             , isPoll Boolean
             , isPharmacist Boolean
             , RetailId Integer
             , RetailName TVarChar
             , Message TBlob
             , Function TVarChar
             , Form TVarChar
             , isAtEveryEntry Boolean
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
          , False::Boolean                                   AS Daily
          , False::Boolean                                   AS isPoll
          , False::Boolean                                   AS isPharmacist
          , Null::Integer                                    AS RetailId
          , Null::TVarChar                                   AS RetailName 
          , Null::TBlob                                      AS Message
          , Null::TVarChar                                   AS Function
          , Null::TVarChar                                   AS Form
          , False::Boolean                                   AS isPharmacist

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                AS StatusCode
          , Object_Status.ValueData                                 AS StatusName
          , MovementDate_DateEndPUSH.ValueData                      AS DateEndPUSH
          , MovementFloat_Replays.ValueData::Integer                AS Replays  
          , COALESCE(MovementBoolean_Daily.ValueData, False)        AS Daily
          , COALESCE(MovementBoolean_Poll.ValueData, False)         AS isPoll
          , COALESCE(MovementBoolean_Pharmacist.ValueData, False)   AS isPharmacist
          , Object_Retail.ID                                        AS RetailId
          , Object_Retail.ValueData                                 AS RetailName 
          , MovementBlob_Message.ValueData                          AS Message
          , MovementString_Function.ValueData                       AS Function  
          , MovementString_Form.ValueData                           AS Form  
          , COALESCE(MovementBoolean_AtEveryEntry.ValueData, False) AS isAtEveryEntry

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

            LEFT JOIN MovementBoolean AS MovementBoolean_Pharmacist
                                      ON MovementBoolean_Pharmacist.MovementId = Movement.Id
                                     AND MovementBoolean_Pharmacist.DescId = zc_MovementBoolean_Pharmacist()

            LEFT JOIN MovementBoolean AS MovementBoolean_Poll
                                      ON MovementBoolean_Poll.MovementId = Movement.Id
                                     AND MovementBoolean_Poll.DescId = zc_MovementBoolean_Poll()

            LEFT JOIN MovementBoolean AS MovementBoolean_AtEveryEntry
                                      ON MovementBoolean_AtEveryEntry.MovementId = Movement.Id
                                     AND MovementBoolean_AtEveryEntry.DescId = zc_MovementBoolean_AtEveryEntry()


            LEFT JOIN MovementString AS MovementString_Function
                                     ON MovementString_Function.MovementId = Movement.Id
                                    AND MovementString_Function.DescId = zc_MovementString_Function()

            LEFT JOIN MovementString AS MovementString_Form
                                     ON MovementString_Form.MovementId = Movement.Id
                                    AND MovementString_Form.DescId = zc_MovementString_Form()

            LEFT JOIN MovementLinkObject AS MLO_Retail
                                         ON MLO_Retail.MovementId = Movement.Id
                                        AND MLO_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Retail.ObjectId  

        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_EmployeeSchedule (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.03.20        *
 19.02.20        *
 11.05.19        *
 10.03.19        *
*/

-- select * from gpGet_Movement_PUSH(inMovementId := 17829304 , inOperDate := ('30.04.2021')::TDateTime ,  inSession := '3');
