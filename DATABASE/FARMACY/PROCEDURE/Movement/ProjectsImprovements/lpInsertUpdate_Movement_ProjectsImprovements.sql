-- Function: lpInsertUpdate_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProjectsImprovements(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inTitle               TVarChar  , -- Название
    IN inDescription         Text      , -- Краткое описание 
    IN inComment             TVarChar  , -- Примечание 
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProjectsImprovements(), inInvNumber, inOperDate, NULL, 0);

     -- сохранили <Название>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Title(), ioId, inTitle);

     -- сохранили <раткое описание >
     PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Description(), ioId, inDescription);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.05.20                                                       *
 */
