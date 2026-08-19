-- Function: gpSelect_MI_OrderRK_Detail()

 DROP FUNCTION IF EXISTS gpSelect_MI_OrderRK_Detail (Integer, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MI_OrderRK_Detail(
    IN inMovementId  Integer      , -- ключ Документа 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (key TVarChar
             , MovementId Integer, Invnumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , GoodsId Integer 
             , GoodsKindId Integer
             , Amount TFloat
             )
AS
$BODY$
  DECLARE vbUserId           Integer;
          vbMovementId_Order Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);

     vbMovementId_Order := (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     -- Результат
     RETURN QUERY

       -- все задания по Заявке vbMovementId_Order
       WITH
       tmpMovement AS (SELECT Movement.*
                       FROM Movement 
                       WHERE Movement.ParentId = vbMovementId_Order
                         AND Movement.DescId = zc_Movement_OrderRK()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()   --= zc_Enum_Status_Complete()
                         AND Movement.Id <> inMovementId    --????
                       )
     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   AND COALESCE (MovementItem.Amount,0) <> 0
                 )
     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                            )
       
       SELECT (MovementItem.ObjectId||'_'||COALESCE (MILinkObject_GoodsKind.ObjectId,0)) ::TVarChar AS Key
            , Movement.Id                            AS MovementId
            , Movement.Invnumber
            , Movement.OperDate
            , Object_Status.ObjectCode               AS StatusCode
            , Object_Status.ValueData                AS StatusName
            , MovementItem.ObjectId                  AS GoodsId
            , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId 
            , SUM (COALESCE (MovementItem.Amount,0)) ::TFloat AS Amount
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
       GROUP BY Movement.Id
              , Movement.Invnumber
              , Movement.OperDate
              , Object_Status.ObjectCode
              , Object_Status.ValueData
              , MovementItem.ObjectId
              , COALESCE (MILinkObject_GoodsKind.ObjectId,0) 
      ;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.08.26         *
*/

-- тест
--select * from gpSelect_MI_OrderRK_Detail(inMovementId := 34939264  , inSession := '5')


--(SELECT Movement.ParentId FROM Movement WHERE Movement.Id = 18298048);
