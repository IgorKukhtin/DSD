-- Function: lpUpdate_MI_OrderFinance_ByReport()

DROP FUNCTION IF EXISTS lpUpdate_MI_OrderFinance_ByReport (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpUpdate_MI_OrderFinance_ByReport (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_OrderFinance_ByReport (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_OrderFinance_ByReport(
    IN inId               Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId       Integer   ,
    IN inJuridicalId      Integer   ,
    IN inContractId       Integer   ,
    IN inBankAccountId    Integer   , --
    IN inAmountRemains    TFloat    , -- 
    IN inAmountPartner    TFloat    , -- 
    IN inComment          TVarChar ,
    IN inUserId           Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     IF COALESCE (inId, 0) = 0
     THEN 
         -- сохранили <Элемент документа>
         inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inJuridicalId, inMovementId, 0, NULL);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), inId, inContractId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), inId, inBankAccountId);
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), inId, inAmountRemains);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), inId, inAmountPartner);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);
     
     
     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), inId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     -- !!! времнно откл.!!!
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.20         *
 31.07.19         *
*/

-- тест
--