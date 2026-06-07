-- Function: lpInsertUpdate_MovementItem_Sale_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Detail (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale_Detail(
 INOUT ioId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inContractId_bonus        Integer   , -- Договор (условие бонуса)
    IN inContractId              Integer   , -- Договор(начисление)
    IN inContractConditionKindId Integer   , -- Вид Условия договора - Только % бонуса за отгрузку-возврат
    IN inBonusKindId             Integer   , -- Вид бонуса
    IN inPaidKindId              Integer   , -- Форма оплаты (Договор начисление)
    IN inInfoMoneyId             Integer   , -- 
    IN inBonusValue              TFloat    , -- % бонуса
    IN inUserId                  Integer     -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inContractId_bonus, inMovementId, inBonusValue, NULL, -12345);

     -- сохранили свойство <Договор(начисление)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioId, inContractConditionKindId);

     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BonusKind(), ioId, inBonusKindId);

     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);

     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.26                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale_Detail (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
