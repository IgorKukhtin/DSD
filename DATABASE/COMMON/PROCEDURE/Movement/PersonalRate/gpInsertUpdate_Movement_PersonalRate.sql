-- Function: gpInsertUpdate_Movement_PersonalRate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalRate (Integer, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalRate (Integer, TVarChar, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalRate(
 INOUT ioId                     Integer   , -- Ключ объекта <Документ>
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата документа
    IN inComment                TVarChar  , -- Примечание
    IN inPersonalServiceListId  Integer   , --
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalRate());

     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalRate(), inInvNumber, inOperDate);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19          *
*/

-- тест
--