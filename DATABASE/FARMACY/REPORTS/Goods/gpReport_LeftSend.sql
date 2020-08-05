-- Function: gpReport_LeftSend()

DROP FUNCTION IF EXISTS gpReport_LeftSend (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_LeftSend(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;
   DECLARE Cursor4 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     PERFORM gpReport_Movement_LeftSend (inStartDate, inEndDate, inSession);

     OPEN Cursor1 FOR
          SELECT Movement.Id
               , Movement.InvNumber
               , Movement.OperDate
               , Object_Unit.Id                                       AS UnitId
               , Object_Unit.ValueData                                AS UnitName
          FROM _tmpInvent
               LEFT JOIN Movement ON Movement.Id = _tmpInvent.Id

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

          ;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          SELECT _tmpWasGot.Id
               , _tmpWasGot.InventID
               , Object_Goods.Id                                       AS GoodsId
               , Object_Goods.ObjectCode                               AS GoodsCode
               , Object_Goods.ValueData                                AS GoodsName
               , _tmpWasGot.AmountReturn
          FROM _tmpWasGot

               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpWasGot.GoodsId
          WHERE _tmpWasGot.AmountReturn > 0
          ;
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
          SELECT Movement.Id
               , Movement.InvNumber
               , Movement.OperDate
               , Object_Unit.Id                                       AS UnitId
               , Object_Unit.ValueData                                AS UnitName
               , _tmpWasSentMovement.InventID
          FROM _tmpWasSentMovement
               LEFT JOIN Movement ON Movement.Id = _tmpWasSentMovement.Id

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

          ;
     RETURN NEXT Cursor3;

     OPEN Cursor4 FOR
          SELECT Movement.Id
               , Movement.InvNumber
               , Movement.OperDate
               , Object_Unit.Id                                       AS UnitId
               , Object_Unit.ValueData                                AS UnitName
               , _tmpResult.InventID
               , _tmpResult.ReturnRate
          FROM _tmpResult
               LEFT JOIN Movement ON Movement.Id = _tmpResult.Id

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

          ;
     RETURN NEXT Cursor4;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_LeftSend (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.08.20                                                       *
*/

-- тест
--
SELECT * FROM gpReport_LeftSend (inStartDate:= '21.09.2019', inEndDate:= '21.09.2019', inSession:= '3')