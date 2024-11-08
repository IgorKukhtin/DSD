-- Function: gpMovementItem_PromoTrade_SetErased_all (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PromoTrade_SetErased_all (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PromoTrade_SetErased_all(
    IN inMovementId      Integer              , -- ключ объекта <Элемент документа>
    IN inSession         TVarChar               -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_PromoTrade());


  -- удаление
  PERFORM lpSetErased_MovementItem (MovementItem.Id, vbUserId)
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.DescId     = zc_MI_Master()
    AND MovementItem.isErased   = FALSE
   ;
  
  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.09.24         *
*/
