-- Function: gpGet_Movement_ConvertRemains()

DROP FUNCTION IF EXISTS gpGet_Movement_ConvertRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ConvertRemains(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT 0                            AS Id
              , CAST (NEXTVAL ('Movement_ConvertRemains_seq') AS TVarChar) AS InvNumber
              , CURRENT_DATE::TDateTime      AS OperDate
              , Object_Status.Code           AS StatusCode
              , Object_Status.Name           AS StatusName
              , Null::Integer                AS UnitCode
              , Null::TVarChar               AS UnitName
              , Null::TFloat                 AS TotalCount
              , Null::TFloat                 AS TotalSumm
              , Null::TVarChar               AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     
     RETURN QUERY
         SELECT Movement.Id                            AS Id
              , Movement.InvNumber                     AS InvNumber
              , Movement.OperDate                      AS OperDate
              , Object_Status.ObjectCode               AS StatusCode
              , Object_Status.ValueData                AS StatusName
              , Object_Unit.ObjectCode                 AS UnitCode
              , Object_Unit.ValueData                  AS UnitName
              , MovementFloat_TotalCount.ValueData     AS TotalCount
              , MovementFloat_TotalSumm.ValueData      AS TotalSumm
              , MovementString_Comment.ValueData       AS Comment
         FROM Movement
               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_ConvertRemains();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
 */

-- тест
-- SELECT * FROM gpGet_Movement_ConvertRemains (inMovementId:= 1, inSession:= '3')