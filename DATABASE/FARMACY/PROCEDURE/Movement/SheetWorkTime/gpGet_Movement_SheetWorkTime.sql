-- Function: gpGet_Movement_SheetWorkTime()

-- DROP FUNCTION gpGet_Movement_SheetWorkTime (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SheetWorkTime(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SheetWorkTime());

     IF COALESCE (inMovementId, 0) = 0
     THEN
       RETURN QUERY 
         SELECT
             0                           AS Id
           , lfGet_InvNumber (0, zc_Movement_SheetWorkTime())::TVarChar AS InvNumber
           , (date_trunc('month', CURRENT_DATE) - interval '1 month')::TDateTime     AS OperDate
           
           , Object_Status.Code          AS StatusCode
           , Object_Status.Name          AS StatusName

           , 0                           AS UnitId
           , ''::TVarChar                AS UnitName
         FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           
           , Object_Status.ObjectCode    AS StatusCode
           , Object_Status.ValueData     AS StatusName

           , Object_Unit.Id                    AS UnitId
           , Object_Unit.ValueData             AS UnitName

       From Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
           
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_SheetWorkTime();
     END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_SheetWorkTime (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.13                         *       -- Установка Дефолтов
 01.10.13         *

*/

-- тест
-- SELECT * from gpGet_Movement_SheetWorkTime (inMovementId:= 0, inSession:= '2')
