-- Function: gpGet_Movement_Inventory()

DROP FUNCTION IF EXISTS gpGet_Movement_Inventory (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Inventory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , --Дата документа (Для создания нового)
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , UnitId Integer, UnitName TVarChar, FullInvent Boolean
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Inventory());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Inventory_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             , 0 :: TFloat                      AS TotalCount
             , 0 :: TFloat                      AS TotalSumm
             , 0                                AS UnitId
             , CAST ('' as TVarChar)            AS UnitName
             ,False                             AS FullInvent
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           , MovementFloat_TotalCount.ValueData                   AS TotalCount
           , MovementFloat_TotalSumm.ValueData                    AS TotalSumm
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName
           , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS FullInvent
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                            ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                           AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Inventory();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Inventory (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 16.09.15                                                                     * + FullInvent
 11.07.15                                                                     *
 */

-- тест
-- SELECT * FROM gpGet_Movement_Inventory (inMovementId:= 1, inOperDate := '2015071', inSession:= '2')
