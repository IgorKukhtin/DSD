-- Function: gpSelect_Movement_Layout_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Layout_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Layout_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDateEnd TDateTime;
    
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;
     --Определили подразделение для розничной цены
     SELECT MovementLinkObject_Unit.ObjectId
          , Movement.OperDate 
     INTO 
          vbUnitId
        , vbOperDate 
     from
         Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.ID
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;
     
     vbOperDateEnd :=  DATE_TRUNC('day',vbOperDate) + INTERVAL '1 DAY';
     
    OPEN Cursor1 FOR

       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate                   AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           , MovementFloat_TotalCount.ValueData  AS TotalCount
           , Object_Layout.Id                    AS LayoutId
           , Object_Layout.ValueData             AS LayoutName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
  
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Layout();
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        WITH
        tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId
                       , MovementItem.Amount
                       , MovementItem.IsErased
                  FROM MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  )
                  
       -- результат
       SELECT MovementItem.Id                    AS Id
            , Object_Goods.Id                    AS GoodsId
            , Object_Goods.ObjectCode            AS GoodsCode
            , Object_Goods.ValueData             AS GoodsName
            , MovementItem.Amount                AS Amount
       FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
       ORDER BY Object_Goods.ValueData;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.20         *
*/

/*
 SELECT * FROM gpSelect_Movement_Layout_Print (inMovementId := 570596, inSession:= '3');
*/
