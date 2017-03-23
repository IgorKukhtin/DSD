-- Function: gpInsertUpdateMobile_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_ReturnIn (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_ReturnIn(
    IN inGUID          TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inMovementGUID  TVarChar  , -- Глобальный уникальный идентификатор документа
    IN inGoodsId       Integer   , -- Товары
    IN inGoodsKindId   Integer   , -- Виды товаров
    IN inAmount        TFloat    , -- Количество
    IN inPrice         TFloat    , -- Цена
    IN inChangePercent TFloat    , -- (-)% Скидки (+)% Наценки
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbMovementId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_ReturnIn()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbMovementId, 0) = 0 
      THEN
           RAISE EXCEPTION 'Ошибка. Не заведена шапка документа.';
      END IF; 

      -- получаем Id строки документа по GUID
      SELECT MIString_GUID.MovementItemId 
      INTO vbId 
      FROM MovementItemString AS MIString_GUID
           JOIN MovementItem AS MovementItem_ReturnIn
                             ON MovementItem_ReturnIn.Id = MIString_GUID.MovementItemId
                            AND MovementItem_ReturnIn.DescId = zc_MI_Master()
                            AND MovementItem_ReturnIn.MovementId = vbMovementId
      WHERE MIString_GUID.DescId = zc_MIString_GUID() 
        AND MIString_GUID.ValueData = inGUID;

      SELECT ioId INTO vbId
      FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := vbId
                                               , inMovementId         := vbMovementId
                                               , inGoodsId            := inGoodsId
                                               , inAmount             := inAmount
                                               , inAmountPartner      := inAmount
                                               , inPrice              := inPrice
                                               , ioCountForPrice      := 0.0
                                               , inHeadCount          := 0.0
                                               , inMovementId_Partion := 0
                                               , inPartionGoods       := ''
                                               , inGoodsKindId        := inGoodsKindId
                                               , inAssetId            := 0
                                               , ioMovementId_Promo   := NULL
                                               , ioChangePercent      := NULL
                                               , inUserId             := vbUserId
                                                );

      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 22.03.17                                                        *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_ReturnIn (inGUID:= '{A2F91EC1-9A34-4A77-A145-5A3290DFDD70}'
                                                        , inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                        , inGoodsId:= 1
                                                        , inGoodsKindId:= 0
                                                        , inAmount:= 3
                                                        , inPrice:= 45.89 
                                                        , inChangePercent:= -5.0  
                                                        , inSession:= zfCalc_UserAdmin()
                                                         );
*/