-- Function: gpMovementItem_Loss_AddSend

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddSend (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddSend(
    IN inMovementId       Integer,   -- Списание
    IN inSendID          Integer,   -- перемещение
    IN inSession          TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Документ не созранен.';
    END IF;


    PERFORM lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := MovementItemSend.ObjectId
                                            , inAmount             := MovementItemSend.Amount
                                            , inUserId             := vbUserId)
    FROM (SELECT MovementItemSend.ObjectId
               , SUM(MovementItemSend.Amount) AS Amount
          FROM MovementItem AS MovementItemSend
          WHERE MovementItemSend.MovementId = inSendID
            AND MovementItemSend.IsErased = False
            AND MovementItemSend.DescId = zc_MI_Master()
          GROUP BY MovementItemSend.ObjectId) AS MovementItemSend

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemSend.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_Loss_AddSend (inMovementId:= 1, inOperDate:= NULL);
