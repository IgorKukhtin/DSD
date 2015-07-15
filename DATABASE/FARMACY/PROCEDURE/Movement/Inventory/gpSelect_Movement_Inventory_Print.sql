-- Function: gpSelect_Movement_Inventory_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
       INTO vbDescId, vbStatusId
     FROM Movement
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
      RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
    END IF;
     --
    OPEN Cursor1 FOR
    
    WITH tmpMIChild AS (SELECT SUM (MovementItem.Amount)  AS Count_Child
                        FROM MovementItem 
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                       )
        SELECT
           Movement.InvNumber             AS InvNumber
         , Movement.OperDate              AS OperDate

         , Object_Unit.ValueData          AS UnitName
         , tmpMIChild.Count_Child::TFloat AS TotalAmount
         , MovementFloat_Summ.ValueData   AS TotalSumm
         , MovementFloat_Count.ValueData  AS TotalCount
     FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

          LEFT JOIN tmpMIChild ON 1 = 1
		  
		  LEFT JOIN MovementFloat AS MovementFloat_Summ
		                          ON MovementFloat_Summ.MovementId = Movement.Id
								 AND MovementFloat_Summ.DescId = zc_MovementFloat_TotalSumm() 

		  LEFT JOIN MovementFloat AS MovementFloat_Count
		                          ON MovementFloat_Count.MovementId = Movement.Id
								 AND MovementFloat_Count.DescId = zc_MovementFloat_TotalCount()

       WHERE Movement.Id = inMovementId
         AND Movement.StatusId <> zc_Enum_Status_Erased();



    RETURN NEXT Cursor1;
    OPEN Cursor2 FOR
       SELECT Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName
           , Object_Measure.ValueData            AS MeasureName
           , MovementItem.Amount                 AS Amount
           , MIFloat_Price.ValueData             AS Price
           , MIFloat_Summ.ValueData              AS Summ
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Inventory_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.     Воробкало А.А.
 15.07.15                                                                          *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Inventory_Print (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
