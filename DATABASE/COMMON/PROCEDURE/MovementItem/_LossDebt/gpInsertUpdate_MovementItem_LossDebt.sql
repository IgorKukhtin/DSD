-- Function: gpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inJuridicalId         Integer   , -- Юр.лицо
 INOUT ioAmountDebet         TFloat    , -- Сумма
 INOUT ioAmountKredit        TFloat    , -- Сумма
 INOUT ioSummDebet           TFloat    , -- Сумма остатка (долг)
 INOUT ioSummKredit          TFloat    , -- Сумма остатка (долг)
 INOUT ioIsCalculated        Boolean   , -- Сумма рассчитывается по остатку (да/нет)
    IN inContractId          Integer   , -- Договор
    IN inPaidKindId          Integer   , -- Вид форм оплаты
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossDebt());

     -- проверка
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено <Юридическое лицо>.';
     END IF;
     IF COALESCE (inContractId, 0) = 0
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
     IF (COALESCE (ioAmountDebet, 0) <> 0) AND (COALESCE (ioAmountKredit, 0) <> 0) THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;

     -- проверка
     IF (COALESCE (ioSummDebet, 0) <> 0) AND (COALESCE (ioSummKredit, 0) <> 0) THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма: <Дебет долг на дату> или <Кредит долг на дату>.';
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
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.Id <> COALESCE (ioId, 0))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%> <%> <%> .Дублирование запрещено.', lfGet_Object_ValueData (inJuridicalId), lfGet_Object_ValueData (inPaidKindId), lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inContractId);
     END IF;

     -- расчет
     IF ioAmountDebet <> 0 THEN
        vbAmount := ioAmountDebet;
     ELSE
        vbAmount := -1 * ioAmountKredit;
     END IF;
     -- расчет
     IF ioSummDebet <> 0 THEN
        vbSumm := ioSummDebet;
     ELSE
        vbSumm := -1 * ioSummKredit;
     END IF;

     -- расчет
     ioIsCalculated:= (vbSumm <> 0 OR vbAmount = 0);
     -- 
     IF vbSumm <> 0 THEN ioAmountDebet := 0; ioAmountKredit := 0; END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, vbAmount, NULL);

     -- сохранили свойство <Сумма рассчитывается по остатку (да/нет)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, ioIsCalculated);

     -- сохранили свойство <Сумма остатка (долг)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, vbSumm);

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
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.01.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

/*
SELECT MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                     JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                WHERE MovementItem.MovementId = 12055 
                  AND MovementItem.DescId = zc_MI_Master()

group by MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
having count (*) >1
*/