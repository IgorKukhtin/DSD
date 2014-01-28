-- Function: gpInsertUpdate_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

 INOUT ioMasterId            Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioChildId             Integer   , -- Ключ объекта <Элемент документа>

    IN inAmount              TFloat    , -- сумма  
    
    IN inJuridicalFromId     Integer   , -- Юр.лицо
    IN inContractFromId      Integer   , -- Договор
    IN inPaidKindFromId      Integer   , -- Вид форм оплаты
    IN inInfoMoneyFromId     Integer   , -- Статьи назначения

    IN inJuridicalToId       Integer   , -- Юр.лицо
    IN inContractToId        Integer   , -- Договор
    IN inPaidKindToId        Integer   , -- Вид форм оплаты
    IN inInfoMoneyToId       Integer   , -- Статьи назначения

    IN inComment             TVarChar  , -- Примечание
    
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt());
     vbUserId:= inSession;

     -- определяем ключ доступа
     -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_SendDebt());

     -- проверка
     IF (COALESCE (inJuridicalFromId, 0) = 0) OR (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юр.лицо>.';
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebt(), inInvNumber, inOperDate, NULL);

   
     -- сохранили <Главный Элемент документа>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inJuridicalFromId, ioId, inAmount, NULL);

    -- сохранили связь с <Договор ОТ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- сохранили связь с <Вид форм оплаты ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- сохранили связь с <Статьи назначения ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMasterId, inComment);


     -- сохранили <Второй Элемент документа>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), inJuridicalToId, ioId, inAmount, NULL);

     -- сохранили связь с <Договор КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- сохранили связь с <Вид форм оплаты КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- сохранили связь с <Статьи назначения КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);



     -- пересчитали Итоговые суммы по накладной
     -- PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SendDebt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')