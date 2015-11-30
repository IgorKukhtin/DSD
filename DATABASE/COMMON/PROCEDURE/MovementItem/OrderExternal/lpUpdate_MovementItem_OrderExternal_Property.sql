-- Function: lpUpdate_MovementItem_OrderExternal_Property()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_OrderExternal_Property(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAmount_Param        TFloat    , -- 
    IN inDescId_Param        Integer  ,
    IN inAmount_ParamOrder   TFloat    , -- 
    IN inDescId_ParamOrder   Integer  ,
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     IF COALESCE (inId, 0) = 0 
     THEN
       -- сохранили <Элемент документа>
       inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

       -- сохранили связь с <Виды товаров>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);
  
       -- сохранили свойство <Цена>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), inId, inPrice);
       -- сохранили свойство <Цена за количество>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, inCountForPrice);

     END IF;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (inDescId_Param, inId, inAmount_Param);
     -- сохранили свойство
     IF inDescId_ParamOrder <> 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamOrder, inId, inAmount_ParamOrder);
     END IF;

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
-- SELECT * FROM lpUpdate_MovementItem_OrderExternal_Property (inId:= 10696633, inMovementId:= 869524, inGoodsId:= 7402,  inGoodsKindId := 8328 , inAmount:= 45::TFloat, inAmountParam:= 777::TFloat, inDescCode:= 'zc_MIFloat_AmountRemains'::TVarChar, inSession:= lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal()))
