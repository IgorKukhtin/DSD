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
             , Comment TVarChar
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
             , CURRENT_DATE::TDateTime          AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             , 0 :: TFloat                      AS TotalCount
             , 0 :: TFloat                      AS TotalSumm
             , 0                                AS UnitId
             , CAST ('' as TVarChar)            AS UnitName
             , False                            AS FullInvent
             , CAST ('' as TVarChar)            AS Comment
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
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
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
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Inventory();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Inventory (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 19.12.19                                                                                    * + Comment
 15.09.16         * add CURRENT_DATE::TDateTime 
 16.09.15                                                                     * + FullInvent
 11.07.15                                                                     *
 */

-- тест
-- SELECT * FROM gpGet_Movement_Inventory (inMovementId:= 1, inOperDate := '01.01.2019', inSession:= '2')
