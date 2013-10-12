-- Function: gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Movement_Transport (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inStartRunPlan        TDateTime , -- Дата/Время выезда план
    IN inEndRunPlan          TDateTime , -- Дата/Время возвращения план
    IN inStartRun            TDateTime , -- Дата/Время выезда факт
    IN inEndRun              TDateTime , -- Дата/Время возвращения факт

    IN inHoursAdd            TFloat    , -- Кол-во добавленных рабочих часов
   OUT outHoursWork          TFloat    , -- Кол-во рабочих часов

    IN inComment             TVarChar  , -- Примечание
    
    IN inCarId                Integer   , -- Автомобиль
    IN inCarTrailerId         Integer   , -- Автомобиль (прицеп)
    IN inPersonalDriverId     Integer   , -- Сотрудник (водитель)
    IN inPersonalDriverMoreId Integer   , -- Сотрудник (водитель, дополнительный)
    IN inUnitForwardingId     Integer   , -- Подразделение (Место отправки)

    IN inSession              TVarChar    -- сессия пользователя

)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport());
     vbUserId := inSession;

     -- проверка
     IF inHoursAdd > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Проверьте знак для <Кол-во добавленных рабочих часов>.';
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Transport(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <Дата/Время выезда план>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), ioId, inStartRunPlan);
     -- сохранили связь с <Дата/Время возвращения план>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), ioId, inEndRunPlan);
     -- сохранили связь с <Дата/Время выезда факт>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), ioId, inStartRun);
     -- сохранили связь с <Дата/Время возвращения факт>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), ioId, inEndRun);

     -- расчитали свойство <Кол-во рабочих часов>
     outHoursWork := EXTRACT (DAY FROM (inEndRun - inStartRun)) * 24 + EXTRACT (HOUR FROM (inEndRun - inStartRun));
     -- сохранили свойство <Кол-во рабочих часов>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), ioId, outHoursWork);

     -- сохранили свойство <Кол-во добавленных рабочих часов>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursAdd(), ioId, inHoursAdd);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <Автомобиль>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Car(), ioId, inCarId);
     -- сохранили связь с <Автомобиль (прицеп)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarTrailer(), ioId, inCarTrailerId);

     -- сохранили связь с <Сотрудник (водитель)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);
     -- сохранили связь с <Сотрудник (водитель, дополнительный)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriverMore(), ioId, inPersonalDriverMoreId);
     
     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, inUnitForwardingId);


     -- Изменили свойства у подчиненных Документов
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, inCarId)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), Movement.Id, inPersonalDriverId)
     FROM Movement
     WHERE Movement.ParentId = ioId
       AND Movement.DescId   = zc_Movement_Income();



     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.13                                        * add IF inHoursAdd > 0
 06.10.13                                        * add zc_Movement_Income
 26.09.13                                        * changes in wiki                 
 25.09.13         * changes in wiki                 
 20.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Transport (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00', inStartRunPlan:= '30.09.2013 3:00:00', inEndRunPlan:= '30.09.2013 3:00:00', inStartRun:= '30.09.2013 3:00:00', inEndRun:= '30.09.2013 3:00:00', inHoursAdd:= 0, inComment:= ''    , inCarId:= 67657, inCarTrailerId:= 0, inPersonalDriverId:= 19476, inPersonalDriverMoreId:= 19476, inUnitForwardingId:= 1000, inSession:= '2')
