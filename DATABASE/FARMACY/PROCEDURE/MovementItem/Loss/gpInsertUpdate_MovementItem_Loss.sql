-- Function: gpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inPriceIn             TFloat    , -- Цена закупки
   OUT outSumm               TFloat    , -- Сумма
   OUT outSummIn             TFloat    , -- Сумма закупки 
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());
    vbUserId:= lpGetUserBySession (inSession);
     --Проверили на корректность кол-ва

    IF (inAmount < 0)
    THEN
      RAISE EXCEPTION 'Ошибка. Количество <%> не может быть меньше нуля.', inAmount;
    END IF;    
     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Loss (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inUserId             := vbUserId
                                             );
    outSumm := ROUND(inAmount * inPrice,2);
    outSummIn := ROUND(inAmount * inPriceIn,2);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 20.07.15                                                                    *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Loss (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionGoodsId:= 0, inSession:= '2')
