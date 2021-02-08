-- Function: gpInsertUpdate_MovementItem_Income20202()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income20202 (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income20202(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Количество
 INOUT ioAmountPartner       TFloat    , -- Количество у контрагента
    IN inIsCalcAmountPartner Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>
    IN inPrice               TFloat    , -- Цена
    IN inMIId_Invoice        TFloat    , -- элемент документа Cчет               
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inPartionNumStart     TFloat    , -- Начальный № для Партии товара
 INOUT ioPartionNumEnd       TFloat    , -- Последний № для Партии товара
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ) 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());


     -- проверка - для 
     IF COALESCE (inPartionNumStart, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не введено значение <№ Партии с ...>.';
     END IF;
     -- проверка - для 
     IF COALESCE (TRIM (inPartionGoods), '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не введено значение <Шаблон для партии>.';
     END IF;
     -- проверка - для 
     IF COALESCE (ioAmount, 0) = 0
     THEN
         ioAmount:= 1;
       --RAISE EXCEPTION 'Ошибка.Не введено значение <Кол-во (склад)>.';
     END IF;
     -- меняем значение
     ioPartionNumEnd:= inPartionNumStart + ioAmount - 1;


     -- !!!Заменили значение!!!
     IF inIsCalcAmountPartner = TRUE OR 1 = 1 -- временно для Спецодежы ...
     THEN ioAmountPartner:= ioAmount;
     END IF;

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income20202 (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := ioAmount
                                                   , inAmountPartner      := ioAmountPartner
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inPartionNumStart    := inPartionNumStart
                                                   , inPartionNumEnd      := ioPartionNumEnd
                                                   , inPartionGoods       := inPartionGoods
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , inAssetId            := inAssetId
                                                   , inUserId             := vbUserId
                                                    );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_Invoice);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;
                      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.21         * 20202
 21.07.16         *
 29.06.15                                        * add inIsCalcAmountPartner
 29.05.15                                        *
*/

-- тест
--