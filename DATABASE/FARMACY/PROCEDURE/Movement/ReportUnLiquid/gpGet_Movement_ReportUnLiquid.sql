-- Function: gpGet_Movement_ReportUnLiquid()

DROP FUNCTION IF EXISTS gpGet_Movement_ReportUnLiquid (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ReportUnLiquid(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartSale        TDateTime   --Дата начала отчета
             , EndSale          TDateTime   --Дата окончания отчета
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReportUnLiquid());
     vbUserId := inSession;

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , MovementDate_StartSale.ValueData     AS StartSale
           , MovementDate_EndSale.ValueData       AS EndSale
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , MovementString_Comment.ValueData     AS Comment
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementDate AS MovementDate_StartSale
                                   ON MovementDate_StartSale.MovementId = Movement.Id
                                  AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MovementDate_EndSale
                                   ON MovementDate_EndSale.MovementId = Movement.Id
                                  AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
            
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_ReportUnLiquid();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReportUnLiquid (inMovementId:= 1, inSession:= '9818')
