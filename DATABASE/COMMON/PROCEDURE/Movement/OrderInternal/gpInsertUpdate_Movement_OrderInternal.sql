-- Function: gpInsertUpdate_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal(Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа (формирование заказа)
   OUT outOperDatePartner    TDateTime , -- Дата документа (производства)
 INOUT ioOperDateStart       TDateTime , -- Дата прогноз (нач.)
 INOUT ioOperDateEnd         TDateTime , -- Дата прогноз (конечн.)
   OUT outDayCount           TFloat    , -- Количество дней прогноз
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inIsRemains           Boolean   , -- 
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());

     -- 1. эти параметры всегда +1 день
     IF inToId = 8451 -- Цех Упаковки
        OR inFromId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp) -- ЦЕХ колбаса+дел-сы
     THEN
         outOperDatePartner:= inOperDate;
     ELSE 
         outOperDatePartner:= inOperDate + INTERVAL '1 DAY';
     END IF;
     -- 1. эти параметры всегда -56 день
     -- ioOperDateStart:= inOperDate - INTERVAL '56 DAY';
     -- 1. эти параметры всегда -1 день
     -- ioOperDateEnd:= inOperDate - INTERVAL '1 DAY';
     -- 0.
     outDayCount:= 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (ioOperDateEnd) - zfConvert_DateTimeWithOutTZ (ioOperDateStart)));

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Дата производства>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, outOperDatePartner);
     -- сохранили свойство <Дата проноз с>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, ioOperDateStart);
     -- сохранили свойство <Дата проноз по>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, ioOperDateEnd);                                          

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- IsRemains
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), ioId, inIsRemains);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.15                                        * all
 02.03.15         * add OperDatePartner, OperDateStart, OperDateEnd, DayCount
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
