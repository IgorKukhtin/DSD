-- Function: gpInsertUpdate_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReturnIn_Child(
 INOUT inId                  Integer   , -- Ключ объекта <Элемент документа>   
    IN inParentId            Integer   , -- Ключ
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId             Integer   , -- Товар
    IN inMovementId_sale     Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    --IN inMovementItemId_sale Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
           vbUserId Integer;
           vbMovementItemId_sale Integer;
           vbGoodsKindId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     --проверка
     IF COALESCE (ioId, 0) <> 0 
        AND TRUE = COALESCE ( (SELECT MIBoolean_Calculated.ValueData
                               FROM MovementItemBoolean AS MIBoolean_Calculated
                               WHERE MIBoolean_Calculated.MovementItemId = ioId
                                 AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                               ), FALSE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Строка с автозаполнением, ручной режим не возможен.';
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;



     --вид товара, по inParentId
     vbGoodsKindId := (SELECT MILO.ObjectId
                       FROM MovementItemLinkObject AS MILO
                       WHERE MILO.MovementItemId= inParentId
                         AND MILO.DescId = zc_MILinkObject_GoodsKind()
                      );
     --определить строку док. продажи
     vbMovementItemId_sale := (SELECT tmp.Id 
                               FROM (SELECT MI.Id
                                          , ROW_NUMBER () OVER (PARTITION BY MI.Amount, MI.Id) AS Ord  
                                     FROM MovementItem AS MI
                                          INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                            ON MILinkObject_GoodsKind.MovementItemId = MI.Id
                                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                           AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (vbGoodsKindId,0)
                                     WHERE MI.MovementId = inMovementId_sale
                                       AND MI.DescId = zc_MI_Master()
                                       AND MI.isErased = FALSE
                                       AND MI.ObjectId = inGoodsId
                                    ) AS tmp
                               WHERE tmp.Ord = 1                               
                               );
     IF COALESCE (vbMovementItemId_sale,0) = 0 
     THEN
          RAISE EXCEPTION 'Ошибка.В выбранном док.Продажи не найден <%> <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (vbGoodsKindId);
     END IF;
     
     ioId := lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := ioId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := inParentId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := CASE WHEN inMovementId_sale > 0 AND vbMovementItemId_sale > 0 THEN COALESCE (inAmount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (inMovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (vbMovementItemId_sale, 0)
                                                       , inUserId              := vbUserId
                                                       , inIsRightsAll         := FALSE
                                                        );     
     IF vbUserId = 9457
     THEN
          RAISE EXCEPTION 'Test.Ok. <%>' , vbMovementItemId_sale;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.25         *
*/

-- тест
