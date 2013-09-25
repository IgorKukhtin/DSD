-- Function: gpInsertUpdate_Movement_Transport()

-- DROP FUNCTION gpInsertUpdate_Movement_Transport();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inStartRunPlan        TDateTime , -- Дата/Время выезда план
    IN inEndRunPlan          TDateTime , -- Дата/Время возвращения план
    IN inStartRun            TDateTime , -- Дата/Время выезда факт
    IN inEndRun              TDateTime , -- Дата/Время возвращения факт

    IN inHoursAdd            TFloat    , -- Кол-во добавленных рабочих часов
    IN inStartOdometre       TFloat    , -- Спидометр начальное показание, км
    IN inEndOdometre         TFloat    , -- Спидометр конечное показание, км
    
    IN inComment             TVarChar  , -- Затраты топлива на охлаждение
    
    IN inCarId               Integer   , -- Автомобиль 	
    IN inCarTrailerId        Integer   , -- Автомобиль (прицеп)
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inUnitForwardingId    Integer   , -- Подразделение (Место отправки)

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbHoursWork TFloat;
   DECLARE vbDistance TFloat;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport());
     vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Transport(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <Дата >
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- сохранили связь с <Дата >
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), ioId, inEndRunPlan);
     -- сохранили связь с <Дата >
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);
     -- сохранили связь с <Дата >
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), ioId, inEndRun);

     -- сохранили свойство <Кол-во рабочих часов>
     vbHoursWork:= round((inEndRun - inStartRun)*24));
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), ioId, vbHoursWork);

     -- сохранили свойство <Кол-во добавленных рабочих часов>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursAdd(), ioId, inHoursAdd);

     -- сохранили свойство <Одометр нач.показания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartOdometre(), ioId, inStartOdometre);

     -- сохранили свойство <Одометр кон.показания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_EndOdometre(), ioId, inEndOdometre);
     
     -- сохранили свойство <Пробег>
     vbDistance:= inEndOdometre-inStartOdometre;
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Distance(), ioId, vbDistance);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- сохранили связь с <Автомобиль (прицеп)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);

     -- сохранили связь с <Сотрудники>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     
     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * changes in wiki                 
 20.08.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Transport (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
