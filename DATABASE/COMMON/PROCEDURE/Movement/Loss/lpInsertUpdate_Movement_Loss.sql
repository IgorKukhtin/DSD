-- Function: lpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loss(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inArticleLossId       Integer   , -- Статьи списания
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- ограничение прав для Рибалко Вікторія Віталіївна
     IF inUserId = 300550 AND inFromId NOT IN (8447   -- цех колбасный
                                             , 8448   -- ЦЕХ деликатесов
                                             , 8449)  -- цех с/к
     THEN
         RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на изменение документа списания № <%> от <%>.', lfGet_Object_ValueData (inUserId), inInvNumber, DATE (inOperDate);
     END IF;
     
     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= CASE WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 346093 -- Склад ГП ф.Одесса
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8413 -- Склад ГП ф.Кривой Рог
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8425 -- Склад ГП ф.Харьков
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 3080691 -- Склад ГП ф.Львов
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 

                          WHEN COALESCE (ioId, 0) = 0 AND inFromId = 8020714 -- Склад База ГП (Ирна)
                               THEN zc_Enum_Process_AccessKey_DocumentIrna() 

                          ELSE lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Loss())
                     END;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Loss(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Статьи списания>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ArticleLoss(), ioId, inArticleLossId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.03.17         *
 06.09.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
