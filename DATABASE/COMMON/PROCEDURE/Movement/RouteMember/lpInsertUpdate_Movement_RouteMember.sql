-- Function: lpInsertUpdate_Movement_RouteMember()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_RouteMember (Integer, TVarChar, TDateTime, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_RouteMember (
 INOUT ioId        Integer   , -- Ключ объекта <Документ>
    IN inInvNumber TVarChar  , -- Номер документа
    IN inOperDate  TDateTime , -- Дата документа
    IN inGPSN      TFloat    , -- GPS координаты маршрута (широта)
    IN inGPSE      TFloat    , -- GPS координаты маршрута (долгота)
    IN inUserId    Integer    -- пользователь
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- проверка
      IF inOperDate <> DATE_TRUNC('DAY', inOperDate)
      THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
      END IF;

      -- определяем ключ доступа
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_RouteMember());

      -- определяем признак Создание/Корректировка
      vbIsInsert := COALESCE(ioId, 0) = 0;

      -- сохранили <Документ>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_RouteMember(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert 
      THEN
           -- сохранили связь с <Пользователь>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), ioId, inUserId);
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
      END IF;

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSN(), ioId, inGPSN);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSE(), ioId, inGPSE);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol(ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 27.03.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_RouteMember (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inUserId:= 2, inPartnerId:= 17819, inGUID:= NULL, inComment:= 'Факт');
