-- Function: gpInsertUpdate_MovementItem_Inventory_Code()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Code (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Code(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Инвентаризация>
    IN inGoodsCode           Integer   , -- Товар
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

       -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

            -- получаем GoodsMainId
     SELECT Object_Goods_Retail.Id
     INTO vbGoodsId
     FROM Object_Goods_Main
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                         AND Object_Goods_Retail.RetailId = vbObjectId
     WHERE Object_Goods_Main.ObjectCode = inGoodsCode;

     IF COALESCE (vbGoodsId, 0) = 0
     THEN
       RAISE EXCEPTION 'Не найден код товара.';
     END IF;

     IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbGoodsId)
     THEN
       SELECT MovementItem.ID, MovementItem.Amount + inAmount
       INTO ioId, inAmount
       FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbGoodsId;
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), vbGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Сумма>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, Round(inPrice * inAmount, 2));

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 21.08.200                                                                  *
*/

-- тест
-- UPDATE MovementItem set Amount = 0 WHERE MovementItem.MovementId = 19965583
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Code (ioId:= 0, inMovementId:= 19965583 , inGoodsCode:= 33618, inAmount:= 1, inPrice:= 247.5, inSession:= '14080152 ')