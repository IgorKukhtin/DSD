-- Function: lpInsertUpdate_MI_ProfitLossService_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProfitLossService_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , -- Ключ объекта 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId         Integer   , -- Юридические лица - на кого начислены затраты
    IN inJuridicalId_Child   Integer   , -- Юр лицо продаж
    IN inPartnerId           Integer   , -- Контрагент продаж
    IN inBranchId            Integer   , -- Филиал (для ОПиУ)
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAmount              TFloat    , -- распределенная сумма начислений
    IN inAmountPartner       TFloat    , -- Сумма продаж
    IN inSumm                TFloat    , -- База для начисления 
    IN inMovementId_child    TFloat    , -- Id документа продаж
    IN inOperDate            TDateTime , -- дата продажи покупателю
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inJuridicalId, inMovementId, inAmount, inParentId);

     -- сохранили свойство <дата продажи покупателю>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- сохранили свойство <Сумма продаж>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <База для начисления>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
     -- сохранили свойство <Id документа продаж>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_child);


     -- сохранили связь с <Юр лицо продаж>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId_Child);

     -- сохранили связь с <Товар>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили связь с <Контрагент продаж>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);

     -- сохранили связь с <Филиал (для ОПиУ)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);

      -- сохранили протокол
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProfitLossService_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
