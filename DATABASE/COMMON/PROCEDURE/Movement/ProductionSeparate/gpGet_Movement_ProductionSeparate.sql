-- Function: gpGet_Movement_ProductionSeparate()

-- DROP FUNCTION gpGet_Movement_ProductionSeparate (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionSeparate (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionSeparate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionSeparate(
    IN inMovementId  Integer,       -- ключ Документа
    IN inOperDate    TDateTime,     -- дата Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             --, TotalCount TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PartionGoods TVarChar
             , isCalculated Boolean, isAuto Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionSeparate());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                        AS Id
             , CAST (NEXTVAL ('movement_productionseparate_seq') AS TVarChar) AS InvNumber
             , inOperDate               AS OperDate
             , Object_Status.Code       AS StatusCode
             , Object_Status.Name       AS StatusName
--             , CAST (0 AS TFloat)     AS TotalCount
             , 0                     	AS FromId
             , CAST ('' AS TVarChar) 	AS FromName
             , 0                     	AS ToId
             , CAST ('' AS TVarChar) 	AS ToName
             , CAST ('' AS TVarChar) 	AS PartionGoods
             , FALSE                    AS isCalculated
             , FALSE                    AS isAuto
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
     SELECT
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
         , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
--         , MovementFloat_TotalCount.ValueData                 AS TotalCount
         , Object_From.Id                                       AS FromId
         , Object_From.ValueData                                AS FromName
         , Object_To.Id                                         AS ToId
         , Object_To.ValueData                                  AS ToName
         , MovementString_PartionGoods.ValueData                AS PartionGoods
         , COALESCE (MovementBoolean_Calculated.ValueData, FALSE) :: Boolean AS isCalculated
         , COALESCE(MovementBoolean_isAuto.ValueData, False)      :: Boolean AS isAuto
     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
/*
          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
*/
          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_Calculated
                                    ON MovementBoolean_Calculated.MovementId = Movement.Id
                                   AND MovementBoolean_Calculated.DescId = zc_MovementBoolean_Calculated()
          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionSeparate();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.10.18         *
 28.05.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionSeparate (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')
