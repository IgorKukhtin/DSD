-- Function: lpInsertUpdate_Movement_LayoutFile()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LayoutFile (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_LayoutFile(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Выкладка>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inStartPromo          TDateTime , -- Дата начала показа
    IN inEndPromo            TDateTime , -- Дата окончания показа
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

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_LayoutFile());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_LayoutFile(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Дата начала показа>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
     -- сохранили связь с <Дата окончания показа>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

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
 05.02.22                                                       *
*/

-- тест
--