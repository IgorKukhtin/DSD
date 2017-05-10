-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
    IN inPartionId                          Integer   , -- Партия
    IN inAmount                             TFloat    , -- Количество магазин - факт. остаток
    IN inAmountSecond                       TFloat    , -- Количество склад - факт. остаток
   OUT outAmountRemains                     TFloat    , -- Количество магазин - Расчетный остаток
   OUT outAmountSecondRemains               TFloat    , -- Количество склад - Расчетный остаток
   OUT outCountForPrice                     TFloat    , -- Цена за количество
   OUT outOperPrice                         TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
   OUT outAmountSecondSumm                  TFloat    , -- Сумма расчетная (склад)
   OUT outAmountSummRemains                 TFloat    , -- Сумма расчетная остатка
   OUT outAmountSecondRemainsSumm           TFloat    , -- Сумма расчетная остатка (склад)
   OUT outOperPriceList                     TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm               TFloat    , -- Сумма по прайсу
   OUT outAmountSecondPriceListSumm         TFloat    , -- Сумма по прайсу
   OUT outAmountPriceListSummRemains        TFloat    , -- Сумма по прайсу остатка 
   OUT outAmountSecondRemainsPLSumm         TFloat    , -- Сумма по прайсу остатка

   OUT outAmountClient                      TFloat    , -- Количество у покупателя - Расчетный остаток
   OUT outAmountClientSumm                  TFloat    , -- сумма у покупателя - Расчетный остаток
   OUT outAmountClientPriceListSumm         TFloat    , -- сумма по прайсу у покупателя - Расчетный остаток

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
     -- данные из партии : OperPrice и CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
    INTO outCountForPrice, outOperPrice
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

      
     outAmountRemains := 1;        -- вставить расчет
     outAmountSecondRemains := 1;  -- вставить расчет
     outAmountClient := 1;         -- вставить расчет

     -- Заменили свойство <Цена за количество>
     --IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
      
      -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <Цена за количество>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);
     -- сохранили свойство <Остаток магазин>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, outAmountRemains);
     -- сохранили свойство <кол-во факт cклад>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- сохранили свойство <Остаток склад>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, outAmountSecondRemains);
     -- сохранили свойство <Остаток клиент>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountClient(), ioId, outAmountClient);

     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     outAmountSecondSumm := CASE WHEN outCountForPrice > 0
                                     THEN CAST (inAmountSecond * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (inAmountSecond * outOperPrice AS NUMERIC (16, 2))
                            END;
     outAmountSummRemains := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (outAmountRemains * outOperPrice AS NUMERIC (16, 2))
                             END;
     outAmountSecondRemainsSumm := CASE WHEN outCountForPrice > 0
                                            THEN CAST (outAmountSecondRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                        ELSE CAST (outAmountSecondRemains * outOperPrice AS NUMERIC (16, 2))
                                   END;
     outAmountClientSumm := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountClient * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (outAmountClient * outOperPrice AS NUMERIC (16, 2))
                            END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN outCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;
     outAmountSecondPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (inAmountSecond * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecond * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountPriceListSummRemains := CASE WHEN outCountForPrice > 0
                                                THEN CAST (outAmountRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                           ELSE CAST (outAmountRemains * outOperPriceList AS NUMERIC (16, 2))
                                      END;
     outAmountSecondRemainsPLSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountSecondRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountSecondRemains * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountClientPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountClient * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountClient * outOperPriceList AS NUMERIC (16, 2))
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
-- select * from gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inComment := '' ,  inSession := '2');