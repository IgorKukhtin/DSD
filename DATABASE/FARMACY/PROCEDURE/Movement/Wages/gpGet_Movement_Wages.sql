-- Function: gpGet_Movement_Wages()

DROP FUNCTION IF EXISTS gpGet_Movement_Wages (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Wages(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , EndDate TDateTime
             , DateCalculation TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    
     vbUserId:= lpGetUserBySession (inSession);
    -- zc_Enum_Process_InsertUpdate_MI_Wages

    vbOperDate := date_trunc('month', inOperDate);
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = vbOperDate AND Movement.DescId = zc_Movement_Wages())
      THEN
        SELECT Movement.ID
        INTO inMovementId  
        FROM Movement 
        WHERE Movement.OperDate = vbOperDate 
          AND Movement.DescId = zc_Movement_Wages();
      END IF;
    END IF;
    
    IF COALESCE (inMovementId, 0) = 0
    THEN

        -- проверка прав пользователя на вызов процедуры
        PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

        RETURN QUERY
        SELECT
            0                                                                 AS Id
          , CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar)                AS InvNumber
          , vbOperDate::TDateTime                                             AS OperDate
          , Object_Status.Code               	                              AS StatusCode
          , Object_Status.Name                             	                  AS StatusName
          , (vbOperDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::TDateTime   AS OperDate
          , Null::TDateTime                                                   AS DateCalculation

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                                 AS StatusCode
          , Object_Status.ValueData                                                  AS StatusName
          , (Movement.OperDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::TDateTime   AS OperDate
          , MovementDate_Calculation.ValueData       AS DateCalculation
        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementDate AS MovementDate_Calculation
                                   ON MovementDate_Calculation.MovementId = Movement.Id
                                  AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()

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
ALTER FUNCTION gpGet_Movement_Wages (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/

-- select * from gpGet_Movement_Wages(inMovementId := 0 , inOperDate := ('30.07.2018')::TDateTime ,  inSession := '3');
