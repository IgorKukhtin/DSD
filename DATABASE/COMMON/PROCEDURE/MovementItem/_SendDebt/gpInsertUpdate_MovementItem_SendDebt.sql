-- Function: gpInsertUpdate_MovementItem_SendDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendDebt (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendDebt(
-- INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioMasterId            Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioChildId             Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inAmount              TFloat    , -- сумма  
    
    IN inJuridicalFromId     Integer   , -- Юр.лицо
    IN inContractFromId      Integer   , -- Договор
    IN inPaidKindFromId      Integer   , -- Вид форм оплаты
    IN inInfoMoneyFromId     Integer   , -- Статьи назначения

    IN inJuridicalToId       Integer   , -- Юр.лицо
    IN inContractToId        Integer   , -- Договор
    IN inPaidKindToId        Integer   , -- Вид форм оплаты
    IN inInfoMoneyToId       Integer   , -- Статьи назначения

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendDebt());
     vbUserId:= inSession;

     -- проверка
     IF (COALESCE (inJuridicalFromId, 0) = 0) OR (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юр.лицо>.';
     END IF;

     -- сохранили <Главный Элемент документа>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inJuridicalFromId, inMovementId, inAmount, NULL);

     -- сохранили <Второй Элемент документа>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), inJuridicalToId, ioMasterId, inAmount, NULL);

     -- сохранили связь с <Договор ОТ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- сохранили связь с <Вид форм оплаты ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- сохранили связь с <Статьи назначения ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);


     -- сохранили связь с <Договор КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- сохранили связь с <Вид форм оплаты КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- сохранили связь с <Статьи назначения КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);



     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioMasterId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendDebt (ioMasterId:= 0, inMovementId:= 10, inAmount:= 0, , inSession:= '2')
