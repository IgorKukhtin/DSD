-- Function: gpInsertUpdate_Movement_Transport()

-- DROP FUNCTION gpInsertUpdate_Movement_Transport();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inWorkTime            TDateTime , -- Дата начисления

    IN inMorningOdometre     TFloat    , -- Одометр утро 
    IN inEveningOdometre     TFloat    , -- Одометр вечер
    IN inDistance            TFloat    , -- Пробег
    IN inCold                TFloat    , -- Затраты топлива на охлаждение
    IN inNorm                TFloat    , -- Норма расхода топлива
    
    IN inCarId               Integer   , -- Автомобиль 	
    IN inMemberId            Integer   , -- Сотрудники
    IN inRouteId             Integer   , -- Маршруты

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport());
     vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Transport(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <Дата начисления>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_WorkTime(), ioId, inWorkTime);

     -- сохранили свойство <Одометр утро>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MorningOdometre(), ioId, inMorningOdometre);

     -- сохранили свойство <Одометр вечер>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_EveningOdometre(), ioId, inEveningOdometre);

     -- сохранили свойство <Пробег>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Distance(), ioId, inDistance);

     -- сохранили свойство <Затраты топлива на охлаждение>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Cold(), ioId, inCold);

     -- сохранили свойство <Норма расхода топлива>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Norm(), ioId, inNorm);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- сохранили связь с <Сотрудники>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);
     
     -- сохранили связь с <Маршруты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Transport (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
