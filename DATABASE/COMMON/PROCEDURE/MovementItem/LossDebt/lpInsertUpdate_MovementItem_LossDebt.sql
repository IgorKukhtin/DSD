-- Function: lpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inJuridicalId         Integer   , -- Юр.лицо
    IN inPartnerId           Integer   , -- Контрагент
    IN inBranchId            Integer   , -- Филиал
    IN inAmount              TFloat    , -- Сумма
    IN inSumm                TFloat    , -- Сумма остатка (долг)
    IN inIsCalculated        Boolean   , -- Сумма рассчитывается по остатку (да/нет)
    IN inContractId          Integer   , -- Договор
    IN inPaidKindId          Integer   , -- Вид форм оплаты
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inJuridicalId, 0) = 0 AND inPaidKindId <> zc_Enum_PaidKind_SecondForm()
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено <Юридическое лицо>.';
     END IF;
     IF COALESCE (inContractId, 0) = 0 AND COALESCE (inPartnerId, 0) <> 297029 -- ШТРАФЫ склад.реализ. -- AND inPaidKindId <> zc_Enum_PaidKind_SecondForm()
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <№ дог.>.';
     END IF;
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <Форма оплаты>.';
     END IF;
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <УП статья назначения>.';
     END IF;

     -- проверка
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                     JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                     AND MILinkObject_Contract.ObjectId = inContractId
                     JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                AND MILinkObject_PaidKind.ObjectId = inPaidKindId
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                      ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND (COALESCE (MILinkObject_Partner.ObjectId, 0) = COALESCE (inPartnerId, 0) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm()) -- AND inPartnerId <> 0
                  AND (COALESCE (MILinkObject_Branch.ObjectId, 0) = COALESCE (inBranchId, 0) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm()) -- AND inBranchId <> 0
                  AND MovementItem.Id <> COALESCE (ioId, 0)
                  AND MovementItem.isErased = FALSE
                )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе уже существует <%>% <%> <%> <%>% <%> <%> <%>.Дублирование запрещено.', lfGet_Object_ValueData (inJuridicalId), CASE WHEN inPartnerId <> 0 THEN ' <' || lfGet_Object_ValueData (inPartnerId) || '>' ELSE '' END, lfGet_Object_ValueData (inPaidKindId), lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inContractId), CASE WHEN inBranchId <> 0 THEN ' <' || lfGet_Object_ValueData (inBranchId) || '>' ELSE '' END, inJuridicalId, inPartnerId, inBranchId;
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Сумма рассчитывается по остатку (да/нет)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inIsCalculated);

     -- сохранили свойство <Сумма остатка (долг)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- сохранили связь с <Контрагенты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);

     -- сохранили связь с <Филиал>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Вид форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.09.14                                        * add inBranchId
 27.08.14                                        * add inPartnerId
 16.05.14                                        * add lpInsert_MovementItemProtocol
 10.03.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
