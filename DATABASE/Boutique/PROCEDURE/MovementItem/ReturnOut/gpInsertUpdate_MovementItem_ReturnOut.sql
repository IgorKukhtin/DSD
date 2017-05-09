-- Function: gpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inPartionId           Integer   , -- Партия
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outOperPriceList      TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm TFloat    , -- Сумма по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());

     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- цена продажи из прайса 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_ReturnOut (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inPartionId          := COALESCE(inPartionId,0)
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := outOperPriceList
                                              , inUserId             := vbUserId
                                               );

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inOperPrice AS NUMERIC (16, 2))
                      END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN ioCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.17         *
 10.04.17         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_ReturnOut(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , inOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');