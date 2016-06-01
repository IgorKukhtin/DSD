-- Function: gpUpdate_MI_ReturnIn_Child()

--DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReturnIn_Child(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId             Integer   , -- Товар
    IN inAmount              TFloat    , -- Количество
    IN inMovementId_sale     Integer   , -- 
    IN inMovementItemId_sale Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbParentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     vbParentId := (SELECT MovementItem.ParentId FROM MovementItem WHERE MovementItem.Id = inId);
     -- !!!сохранение!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := inId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := vbParentId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := CASE WHEN inMovementId_sale > 0 AND inMovementItemId_sale > 0 THEN COALESCE (inAmount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (inMovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (inMovementItemId_sale, 0)
                                                       , inUserId              := vbUserId
                                                       , inIsRightsAll         := FALSE
                                                        )
    ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.06.16         *
*/

--  select * from gpUpdate_MI_ReturnIn_Child(inId := '51658481' , inMovementId := 3734404 , inGoodsId := 2146 , inAmount := 0.376 , inMovementId_Sale := 3528244 , inMovementItemId_sale := 48941749 ,  inSession := '5');