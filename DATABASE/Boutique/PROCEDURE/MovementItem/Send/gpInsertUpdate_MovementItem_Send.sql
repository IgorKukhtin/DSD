-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                            Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                    Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                       Integer   , -- Товары
    IN inPartionId                     Integer   , -- Партия
    IN inAmount                        TFloat    , -- Количество
   OUT outOperPrice                    TFloat    , -- Цена
   OUT outCountForPrice                TFloat    , -- Цена за количество
 INOUT ioOperPriceList                 TFloat    , -- Цена (прайс)
 INOUT ioOperPriceListTo               TFloat    , -- Цена (прайс)(кому) --(для магазина получателя)
   OUT outTotalSumm                    TFloat    , -- Сумма вх.
   OUT outTotalSummBalance             TFloat    , -- Сумма вх. (ГРН)
   OUT outTotalSummPriceList           TFloat    , -- Сумма по прайсу
   OUT outTotalSummPriceListTo         TFloat    , -- Сумма (Кому, прайс)
   OUT outTotalSummPriceListBalance    TFloat    , -- Сумма ГРН (От кого, прайс)
   OUT outTotalSummPriceListToBalance  TFloat    , -- Сумма ГРН (Кому, прайс)
   OUT outCurrencyValue                TFloat    , --
   OUT outParValue                     TFloat    , --
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbCurrencyId_pl_to Integer;
   DECLARE vbToId Integer;
   DECLARE vbPriceListId_to Integer;
   DECLARE vbOperPriceListTo_find TFloat;
   DECLARE vbCurrencyValue_to TFloat;
   DECLARE vbParValue_to TFloat;
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

     -- Дата документа, подразделение Кому, прайс для подразд. кому
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId AS ToId
          , ObjectLink_Unit_PriceList_to.ChildObjectId AS PriceListId_to
          , COALESCE (ObjectLink_PriceList_Currency_to.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl_to
   INTO vbOperDate, vbToId, vbPriceListId_to, vbCurrencyId_pl_to
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList_to
                              ON ObjectLink_Unit_PriceList_to.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectLink_Unit_PriceList_to.DescId = zc_ObjectLink_Unit_PriceList()

         LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency_to
                              ON ObjectLink_PriceList_Currency_to.ObjectId = ObjectLink_Unit_PriceList_to.ChildObjectId
                             AND ObjectLink_PriceList_Currency_to.DescId   = zc_ObjectLink_PriceList_Currency()
     WHERE Movement.Id = inMovementId;

     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
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

     -- данные из партии : OperPrice и CountForPrice и CurrencyId
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     -- Если НЕ Базовая Валюта
     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue, 0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;
         -- проверка
         IF COALESCE (vbCurrencyId, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Валюта>.';
         END IF;
         -- проверка
         IF COALESCE (outCurrencyValue, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Курс>.';
         END IF;
         -- проверка
         IF COALESCE (outParValue, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Номинал>.';
         END IF;

     ELSE
         -- курс не нужен
         outCurrencyValue:= 0;
         outParValue     := 0;
     END IF;


     -- если есть цена и прайс для подр. кому определен сохраняем цену
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo,0) <> 0
     THEN
         -- если есть, оставим без изменений - из Истории
         vbOperPriceListTo_find := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                          , vbPriceListId_to
                                                                                                          , inGoodsId
                                                                                                           ) AS tmp), 0);
         -- если нет цены
         IF COALESCE (vbOperPriceListTo_find, 0) = 0
         THEN
             PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                               , inPriceListId:= vbPriceListId_to
                                                               , inGoodsId    := inGoodsId
                                                               , inOperDate   := zc_DateStart()
                                                               , inValue      := ioOperPriceListTo
                                                               , inUserId     := vbUserId
                                                                );
         ELSE
             -- иначе вернем ту что нашли
             ioOperPriceListTo:= vbOperPriceListTo_find;
         END IF;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, ioOperPriceList);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo(), ioId, ioOperPriceListTo);


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

     -- определяем валюту для Кому из Прайс-листа - vbPriceListId_to
    SELECT COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
 INTO vbCurrencyId_pl_to
    FROM ObjectLink AS OL_PriceListItem_Goods
         INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                               ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                              AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                              AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

         INNER JOIN ObjectHistory AS OH_PriceListItem
                                  ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                 AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                 AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
         LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                     ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                    AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
         LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                      ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                     AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
    WHERE OL_PriceListItem_Goods.ChildObjectId = inGoodsId
      AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods();
   
    -- получаем курс для Кому
    SELECT COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
         , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
   INTO vbCurrencyValue_to, vbParValue_to      
    FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                          , inCurrencyFromId:= zc_Currency_Basis()
                                          , inCurrencyToId  := vbCurrencyId_pl_to
                                           ) AS tmpCurrency

     -- расчитали сумму вх. в грн по элементу, для грида
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;


     -- расчитали сумму по прайсу по элементу, для грида
     outTotalSummPriceList := CAST ((inAmount * ioOperPriceList) AS NUMERIC (16, 2));

     -- расчитали Сумма (Кому, прайс)
     outTotalSummPriceListTo := CAST ((inAmount * ioOperPriceListTo) AS NUMERIC (16, 2));

     --Сумма ГРН (От кого, прайс)
     outTotalSummPriceListBalance   := (CAST (outTotalSummPriceList * CASE WHEN vbCurrencyId = zc_Currency_Basis()
                                                                           THEN 1
                                                                           ELSE outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END
                                                                      END AS NUMERIC (16, 2))) ;
     --Сумма ГРН (Кому, прайс)
     outTotalSummPriceListToBalance := (CAST (outTotalSummPriceListTo * CASE WHEN vbCurrencyId_pl_to = zc_Currency_Basis()
                                                                             THEN 1
                                                                             ELSE vbCurrencyValue_to / CASE WHEN vbParValue_to <> 0 THEN vbParValue_to ELSE 1 END
                                                                        END AS NUMERIC (16, 2))) ;


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
 25.04.20         *
 26.06.17         *
 09.05.17         *
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId := 31 , inMovementId := 13 , inGoodsId := 349 , inPartionId := 41 , inAmount := 10 ,  inSession := '2');
