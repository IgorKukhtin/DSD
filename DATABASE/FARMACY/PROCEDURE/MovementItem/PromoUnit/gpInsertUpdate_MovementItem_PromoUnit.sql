-- Function: gpInsertUpdate_MovementItem_PromoUnit()
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPlanMax       TFloat    , -- кол-во для премии
    IN inPrice               TFloat    , -- Цена
   OUT outSumm               TFloat    , -- Сумма
   OUT outSummPlanMax        TFloat    , -- Сумма
    IN inComment             TVarChar  , -- примечание
    IN inisFixedPercent      Boolean   , -- Фиксированный процент выполнения
    IN inAddBonusPercent     TFloat    , -- Доп. процент бонусирования
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoUnit());
    vbUserId := lpGetUserBySession (inSession);

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    --Посчитали сумму
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(inPrice,0),2);
    outSummPlanMax := ROUND(COALESCE(inAmountPlanMax,0)*COALESCE(inPrice,0),2);

     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem_PromoUnit (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inAmountPlanMax      := inAmountPlanMax
                                                 , inPrice              := inPrice
                                                 , inComment            := inComment
                                                 , inisFixedPercent     := inisFixedPercent
                                                 , inAddBonusPercent    := inAddBonusPercent
                                                 , inUserId             := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 04.02.17         *
*/