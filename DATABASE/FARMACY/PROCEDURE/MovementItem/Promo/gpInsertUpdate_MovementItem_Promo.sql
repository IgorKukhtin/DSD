-- Function: gpInsertUpdate_MovementItem_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo (Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
   OUT outSumm               TFloat    , -- Сумма
    IN inIsChecked           Boolean   , --
   OUT outIsReport           Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());
    vbUserId := inSession;
    
    --Посчитали сумму
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
    outIsReport := not inIsChecked;
    
     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Promo (ioId                 := ioId
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := inGoodsId
                                             , inAmount             := inAmount
                                             , inPrice              := inPrice
                                             , inIsChecked          := inIsChecked
                                             , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.11.18         *
 24.04.16         *
*/