-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inGoodsId              Integer   , -- Товары
    IN inPartionId            Integer   , -- Партия
    IN inAmount               TFloat    , -- Количество
   OUT outOperPrice           TFloat    , -- Цена
   OUT outCountForPrice       TFloat    , -- Цена за количество
 INOUT ioOperPriceList        TFloat    , -- Цена (прайс)
   OUT outTotalSumm           TFloat    , -- Сумма вх.
   OUT outTotalSummBalance    TFloat    , -- Сумма вх. (ГРН)
   OUT outTotalSummPriceList  TFloat    , -- Сумма по прайсу
   OUT outCurrencyValue       TFloat    , -- 
   OUT outParValue            TFloat    , -- 
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

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


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- Цена (прайс)
     IF ioOperPriceList <> 0
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF vbUserId <> zfCalc_UserAdmin() :: Integer THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Истории
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , inGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>.';
     END IF;

     -- данные из партии : OperPrice и CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis())
    INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;       
     END IF;

     IF COALESCE (outCurrencyValue, 0) = 0
        THEN
             outParValue:= 0;
             outCurrencyValue:= 1;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, ioOperPriceList);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, outParValue);

     -- расчитали сумму по элементу, для грида
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                     END;

     -- расчитали сумму вх. в грн по элементу, для грида
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;

     -- расчитали сумму по прайсу по элементу, для грида
     outTotalSummPriceList := CAST ((inAmount * ioOperPriceList) AS NUMERIC (16, 2));

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
 26.06.17         *
 09.05.17         *
 25.04.17         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_Send(ioId := 31 , inMovementId := 13 , inGoodsId := 349 , inPartionId := 41 , inAmount := 10 ,  inSession := '2');