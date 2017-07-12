-- Function: lpInsertUpdate_Movement_Reestr()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Reestr (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Reestr(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCarId                Integer   , -- Автомобиль
    IN inPersonalDriverId     Integer   , -- Сотрудник (водитель)
    IN inMemberId             Integer   , -- Физические лица(экспедитор)
    IN inMovementId_Transport Integer   , -- Путевой лист/Начисления наемный транспорт
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- Проверка
     IF COALESCE (inMovementId_Transport, 0) = 0 AND COALESCE (inCarId, 0) = 0 AND inUserId > 0
     THEN 
         RAISE EXCEPTION 'Ошибка. Необходимо установить документ <Путевой лист> или выбрать из справочника <Автомобиль>.';
     END IF;


     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= CASE WHEN 1 = 1
                               THEN lpGetAccessKey (ABS (inUserId), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Reestr(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- признак что он НЕ "пустышка"
     IF inUserId > 0
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);

         -- сохранили связь с документом <Путевой лист> или <Начисления наемный транспорт>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);

         -- сохранили свойство <когда сформирована виза "Вывезено со склада" (т.е. добавлен последний документ в реестр)>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <кто сформировал визу "Вывезено со склада" (т.е. добавлен последний документ в реестр)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, ABS (inUserId), vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.10.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Reestr (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inMemberId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
