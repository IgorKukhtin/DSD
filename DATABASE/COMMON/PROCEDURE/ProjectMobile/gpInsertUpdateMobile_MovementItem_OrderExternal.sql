-- Function: gpInsertUpdateMobile_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_OrderExternal (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_OrderExternal(
    IN inGUID                TVarChar  , -- Глобальный уникальный идентификатор
    IN inMovementGUID        TVarChar  , -- Глобальный уникальный идентификатор шапки документа
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbIsInsert   Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      SELECT MovementId INTO vbMovementId FROM MovementString WHERE DescId = zc_MovementString_GUID() AND ValueData = inMovementGUID;

      IF COALESCE (vbMovementId, 0) = 0 
      THEN
           RAISE EXCEPTION 'Ошибка. Не заведена шапка документа.';
      END IF; 

      SELECT MovementItem.Id INTO vbId
      FROM MovementItem
           JOIN MovementItemString 
             ON MovementItemString.MovementItemId = MovementItem.Id
            AND MovementItemString.DescId = zc_MIString_GUID() 
            AND MovementItemString.ValueData = inGUID
      WHERE MovementItem.MovementId = vbMovementId;

      -- определяется признак Создание/Корректировка
      vbIsInsert:= COALESCE (vbId, 0) = 0;

      -- сохранили <Элемент документа>
      vbId:= lpInsertUpdate_MovementItem (vbId, zc_MI_Master(), inGoodsId, vbMovementId, inAmount, NULL);

      -- сохранили связь с <Виды товаров>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbId, inGoodsKindId);

      -- сохранили свойство <(-)% Скидки (+)% Наценки>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), vbId, inChangePercent);

      -- сохранили свойство <Цена>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, inPrice);

      IF COALESCE (inGoodsId, 0) <> 0
      THEN
          -- создали объект <Связи Товары и Виды товаров>
          PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, vbUserId);
      END IF;

      -- пересчитали Итоговые суммы по накладной
      PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (vbMovementId);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

      RETURN vbId; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 28.02.17                                                        *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_OrderExternal (inGUID:= '{FFA0D4A2-3278-4B3B-A477-692067AFB021}'
                                                                , inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                                , inGoodsId:= 460651
                                                                , inGoodsKindId:= 8335
                                                                , inChangePercent:= 5.0
                                                                , inAmount:= 10.0
                                                                , inPrice:= 45.56
                                                                , inSession:= zfCalc_UserAdmin()
                                                                 )
*/
