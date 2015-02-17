-- Function: lpUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_OrderExternal(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAmount_Param        TFloat    , -- 
    IN inDescId_Param        Integer  ,
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID AS--RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   --DECLARE vbinId Integer;   
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     IF COALESCE (inId, 0) = 0 
     THEN
       -- сохранили <Элемент документа>
       inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

       -- сохранили связь с <Виды товаров>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);
  
       -- сохранили свойство <Цена за количество>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, 1);

     END IF;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (inDescId_Param, inId, inAmount_Param);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.15         *
*/

-- тест
-- SELECT * FROM lpUpdate_MovementItem_OrderExternal (inId:= 10696633, inMovementId:= 869524, inGoodsId:= 7402,  inGoodsKindId := 8328 , inAmount:= 45::TFloat, inAmountParam:= 777::TFloat, inDescCode:= 'zc_MIFloat_AmountRemains'::TVarChar, inSession:= lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal()))

--select * from gpInsertUpdate_MovementItem_OrderExternal(ioId := 10696633 , inMovementId := 869524 , inGoodsId := 7402 , inAmount := 45 , inAmountSecond := 0 , inGoodsKindId := 8328 , inPrice := 68.75 , ioCountForPrice := 1 ,  inSession := '5');

-- select lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal());