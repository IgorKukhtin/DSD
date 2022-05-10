-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
    IN inPartionId                          Integer   , -- Партия
 INOUT ioAmount                             TFloat    , -- Количество 
    IN inTotalCount                         TFloat    , -- Количество Итого
    IN inTotalCount_old                     TFloat    , -- Количество Итого
 INOUT ioPrice                              TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
    IN inPartNumber                         TVarChar  , -- 
    IN inComment                            TVarChar  , -- примечание
    IN inSession                            TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- замена
--     IF ioAmount = 0 THEN ioAmount:= 1; END IF;

     -- определяются параметры из документа
     SELECT tmp.ioId, tmp.ioAmount, tmp.ioPrice, tmp.outAmountSumm
            INTO ioId, ioAmount, ioPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Inventory (ioId              := ioId
                                               , inMovementId      := inMovementId
                                               , inGoodsId         := inGoodsId
                                               , ioAmount          := ioAmount
                                               , inTotalCount      := inTotalCount
                                               , inTotalCount_old  := inTotalCount_old
                                               , ioPrice           := ioPrice
                                               , inPartNumber      := inPartNumber
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- 