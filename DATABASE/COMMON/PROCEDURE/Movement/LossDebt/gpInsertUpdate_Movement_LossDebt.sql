-- Function: gpInsertUpdate_Movement_LossDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LossDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LossDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LossDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inBusinessId          Integer   , -- Бизнес
    IN inJuridicalBasisId    Integer   , -- Главное юр. лицо
    IN inAccountId           Integer   , -- Счет
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inisList              Boolean   , 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_LossDebt());

     -- определяем ключ доступа
     -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_LossDebt());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_LossDebt(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Бизнес>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Business(), ioId, inBusinessId);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
          
     -- сохранили связь с <Главное юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JuridicalBasis(), ioId, inJuridicalBasisId);
     
     -- сохранили связь с <Счет>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Account(), ioId, inAccountId);

     -- сохранили свойство <только для списка (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inisList);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.04.16         *
 13.09.14                                        * add lpInsert_MovementProtocol
 25.03.14         * add PaidKind                   
 06.03.14         * add Account               
 14.01.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_LossDebt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
