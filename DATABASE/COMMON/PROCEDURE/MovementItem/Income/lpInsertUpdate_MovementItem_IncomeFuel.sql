-- Function: lpInsertUpdate_MovementItem_IncomeFuel()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_IncomeFuel (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_IncomeFuel(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inUserId              Integer     -- Пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceListId_Fuel Integer;
   DECLARE vbIsInsert         Boolean;
BEGIN
     -- находим Дату
     vbOperDate:= (SELECT COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
                   FROM Movement
                        LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                               ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                              AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                   WHERE Movement.Id = inMovementId);
     -- находим PriceListId - Fuel
     vbPriceListId_Fuel:= (SELECT CASE WHEN vbOperDate >= ObjectDate_Juridical_StartPromo.ValueData THEN ObjectLink_Juridical_PriceList.ChildObjectId ELSE 0 END
                           FROM MovementLinkObject AS MovementLinkObject_From
                                LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                                     ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                    AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                     ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_CardFuel_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_PriceList.DescId   = zc_ObjectLink_Juridical_PriceList()
                                LEFT JOIN ObjectDate AS ObjectDate_Juridical_StartPromo
                                                     ON ObjectDate_Juridical_StartPromo.ObjectId = ObjectLink_CardFuel_Juridical.ChildObjectId
                                                    AND ObjectDate_Juridical_StartPromo.DescId   = zc_ObjectDate_Juridical_StartPromo()
                           WHERE MovementLinkObject_From.MovementId = inMovementId
                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                             -- AND inUserId = 5
                          );


     -- находим в Прайсе
     IF vbPriceListId_Fuel > 0
     THEN
         ioPrice:= (SELECT COALESCE (ObjectHistoryFloat_Value.ValueData, 0) AS ValuePrice
                    FROM ObjectLink AS ObjectLink_Goods
                         INNER JOIN ObjectLink AS ObjectLink_PriceList
                                               ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                              AND ObjectLink_PriceList.ChildObjectId = vbPriceListId_Fuel
                                              AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                         INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                 AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                         LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                      ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                     AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                    WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                      AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                   );
     END IF;

     -- проверка - для <Талоны на топливо> цена должна быть = 0, т.к. это типа Перемещение
     IF ioPrice <> 0 AND EXISTS (SELECT tmpFrom.ObjectId FROM (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From()) AS tmpFrom JOIN Object ON Object.Id = tmpFrom.ObjectId AND Object.DescId = zc_Object_TicketFuel())
     THEN
         RAISE EXCEPTION 'Ошибка.Для <Талоны на топливо> цену вводить не надо.';
     ELSEIF COALESCE (ioPrice, 0) = 0 AND vbPriceListId_Fuel > 0
     THEN
         -- проверка - для Цены ГСМ из Прайса
         RAISE EXCEPTION 'Ошибка.Для Топлива <%> НЕ установлена цена в прайсе <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (vbPriceListId_Fuel);
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmount);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);
     -- расчитали/сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * ioPrice AS NUMERIC (16, 2))
                      END;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.10.13                                        * add IF inPrice <> 0 AND ...
 04.10.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_IncomeFuel (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
