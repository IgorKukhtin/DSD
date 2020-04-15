-- Function: gpReport_Send_by_express_v2()

DROP FUNCTION IF EXISTS gpReport_Send_by_express_v2 (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_by_express_v2 (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_by_express_v2(
    IN inOperDate      TDateTime,
    IN inGoodsId       Integer,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE Cursor1 refcursor;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     OPEN Cursor1 FOR
      SELECT MovementLinkObject_From.ObjectId AS UnitId_from
           , Object_To.Id                     AS UnitId_to
           , Object_From.ValueData            AS FromName
           , Object_To.ValueData              AS ToName
           , MovementItem.ObjectId            AS GoodsId
           , MovementItem.Amount              AS Amount
           , Movement_Send.Id                 AS MovementId
           , MovementItem.Id                  AS MovementItemId
      FROM Movement AS Movement_Send
            INNER JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                       ON MovementBoolean_SUN_v3.MovementId = Movement_Send.Id
                                      AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                                      AND MovementBoolean_SUN_v3.ValueData = TRUE

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Send.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND (MovementItem.ObjectId = inGoodsId OR inGoodsId =0)

      WHERE Movement_Send.DescId = zc_Movement_Send()
        AND Movement_Send.StatusId <> zc_Enum_Status_Erased()
        AND Movement_Send.OperDate > inOperDate - INTERVAL '1 DAY'
      ;

     RETURN NEXT Cursor1;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.20         *
*/

-- тест
-- FETCH ALL "<unnamed portal 1>";
-- select * from gpReport_Send_by_express_v2(inOperDate := ('05.04.2020 12:00:00')::TDateTime ,  inSession := '3');
