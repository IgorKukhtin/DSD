-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
    IN inPartionId                          Integer   , -- Партия
    IN inAmount                             TFloat    , -- Количество магазин - факт. остаток
    IN inAmountSecond                       TFloat    , -- Количество склад - факт. остаток
    IN inAmountRemains                      TFloat    , -- Количество магазин - Расчетный остаток
    IN inAmountSecondRemains                TFloat    , -- Количество склад - Расчетный остаток
 INOUT ioCountForPrice                      TFloat    , -- Цена за количество
    IN inOperPrice                          TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
   OUT outAmountSecondSumm                  TFloat    , -- Сумма расчетная (склад)
   OUT outAmountSummRemains                 TFloat    , -- Сумма расчетная остатка
   OUT outAmountSecondRemainsSumm           TFloat    , -- Сумма расчетная остатка (склад)
   OUT outOperPriceList                     TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm               TFloat    , -- Сумма по прайсу
   OUT outAmountSecondPriceListSumm         TFloat    , -- Сумма по прайсу
   OUT outAmountPriceListSummRemains        TFloat    , -- Сумма по прайсу остатка 
   OUT outAmountSecondRemainsPLSumm  TFloat    , -- Сумма по прайсу остатка
    IN inComment                            TVarChar  , -- примечание
    IN inSession                            TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);    
     -- получили цену из прайса на дату док. 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
      
      -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за количество>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);
     -- сохранили свойство <Остаток магазин>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);
     -- сохранили свойство <кол-во факт cклад>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- сохранили свойство <Остаток склад>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, inAmountSecondRemains);

     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inOperPrice AS NUMERIC (16, 2))
                      END;
     outAmountSecondSumm := CASE WHEN ioCountForPrice > 0
                                     THEN CAST (inAmountSecond * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (inAmountSecond * inOperPrice AS NUMERIC (16, 2))
                            END;
     outAmountSummRemains := CASE WHEN ioCountForPrice > 0
                                      THEN CAST (inAmountRemains * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (inAmountRemains * inOperPrice AS NUMERIC (16, 2))
                             END;
     outAmountSecondRemainsSumm := CASE WHEN ioCountForPrice > 0
                                            THEN CAST (inAmountSecondRemains * inOperPrice / ioCountForPrice AS NUMERIC (16, 2))
                                        ELSE CAST (inAmountSecondRemains * inOperPrice AS NUMERIC (16, 2))
                                   END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN ioCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;
     outAmountSecondPriceListSumm := CASE WHEN ioCountForPrice > 0
                                               THEN CAST (inAmountSecond * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecond * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountPriceListSummRemains := CASE WHEN ioCountForPrice > 0
                                                THEN CAST (inAmountRemains * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                           ELSE CAST (inAmountRemains * outOperPriceList AS NUMERIC (16, 2))
                                      END;
     outAmountSecondRemainsPLSumm := CASE WHEN ioCountForPrice > 0
                                               THEN CAST (inAmountSecondRemains * outOperPriceList / ioCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecondRemains * outOperPriceList AS NUMERIC (16, 2))
                                     END;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.17         *
 02.05.17         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inAmountRemains := 1 , inAmountSecondRemains := 1 , ioCountForPrice := 1 , inOperPrice := 87 , inComment := '' ,  inSession := '2');