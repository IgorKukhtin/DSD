-- Function: lpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inDayCount            Integer   , -- Дней без продаж от
    IN inProcGoods           TFloat    , -- % продажи для вып. 
    IN inProcUnit            TFloat    , -- % вып. по аптеке. 
    IN inPenalty             TFloat    , -- Штраф за 1% невып. 
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('month', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_IlliquidUnit(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Подразделение в документе>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили признак <Дней без продаж от>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);

     -- сохранили признак <% продажи для вып.>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ProcGoods(), ioId, inProcGoods);

     -- сохранили признак <% вып. по аптеке. >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ProcUnit(), ioId, inProcUnit);

     -- сохранили признак <Штраф за 1% невып. >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Penalty(), ioId, inPenalty);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
 */
