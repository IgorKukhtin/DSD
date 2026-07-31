-- Function: lpInsertUpdate_MI_SaleCommerc_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SaleCommerc_Detail (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SaleCommerc_Detail(
 INOUT ioId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inContractId_child        Integer   , -- Договор (БАЗА)
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
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractChild(), ioId, inContractId_child);

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
 31.07.26                                        *
*/

-- тест
-- 
