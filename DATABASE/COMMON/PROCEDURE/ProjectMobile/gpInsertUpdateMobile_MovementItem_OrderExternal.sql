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
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbCountForPrice TFloat;
   DECLARE vbStatusId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
      vbUserId:= lpGetUserBySession (inSession);


      -- поиск Id документа по GUID
      SELECT MovementString_GUID.MovementId
           , Movement_OrderExternal.StatusId
            INTO vbMovementId
               , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID()
        AND MovementString_GUID.ValueData = inMovementGUID;
      -- Проверка
      IF COALESCE (vbMovementId, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка. Не сохранена шапка документа.';
      END IF;

      -- получаем Id строки документа по GUID
      vbId:= (SELECT MovementItem.Id
              FROM MovementItem
                   JOIN MovementItemString
                     ON MovementItemString.MovementItemId = MovementItem.Id
                    AND MovementItemString.DescId         = zc_MIString_GUID()
                    AND MovementItemString.ValueData      = inGUID
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId     = zc_MI_Master()
             );



      -- !!! ВРЕМЕННО - 04.07.17 !!!
      IF vbStatusId = zc_Enum_Status_Complete() AND vbId <> 0
      THEN
           -- !!! ВРЕМЕННО !!!
           RETURN (vbId);
      END IF;
      -- !!! ВРЕМЕННО - 04.07.17 !!!



      IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
      THEN 
           -- Распроводим Документ
           PERFORM lpUnComplete_Movement_OrderExternal (inMovementId:= vbMovementId, inUserId:= vbUserId);
      END IF;


      -- если есть кол-во
      IF inAmount <> 0
      THEN
          -- сохранили элемент
          SELECT ioId INTO vbId FROM lpInsertUpdate_MovementItem_OrderExternal (ioId            := vbId
                                                                              , inMovementId    := vbMovementId
                                                                              , inGoodsId       := inGoodsId
                                                                              , inAmount        := inAmount
                                                                              , inAmountSecond  := 0
                                                                              , inGoodsKindId   := inGoodsKindId
                                                                              , ioPrice         := inPrice
                                                                              , ioCountForPrice := vbCountForPrice
                                                                              , inUserId        := vbUserId
                                                                               );
    
          -- сохранили свойство <Глобальный уникальный идентификатор>
          PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);
    
      END IF;

      -- сохранили свойство <Дата/время сохранения с мобильного устройства>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);


      -- !!! ВРЕМЕННО - 04.07.17 !!!
      -- !!!ВРЕМЕННО - УДАЛЯЕМ документ!!!
      PERFORM lpSetErased_Movement (inMovementId:= vbMovementId, inUserId:= vbUserId);
      -- !!! ВРЕМЕННО - 04.07.17 !!!


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
                                                                , inChangePercent:= 6.0
                                                                , inAmount:= 12.0
                                                                , inPrice:= 47.07
                                                                , inSession:= zfCalc_UserAdmin()
                                                                 )
*/
