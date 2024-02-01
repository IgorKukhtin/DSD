-- Function: gpInsertUpdate_Movement_ConvertRemains()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ConvertRemains (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ConvertRemains(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Дата документа
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   
   DECLARE vbOperDate TDateTime;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ConvertRemains());
     vbUserId := inSession;
	 
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- определяем дату и номер документа
     SELECT Movement.OperDate
          , Movement.InvNumber
     INTO vbOperDate, vbInvNumber
     FROM Movement
     WHERE Movement.Id = ioId;
    
     -- сохранили <Документ>
     IF vbIsInsert = TRUE OR vbOperDate <> inOperDate OR vbInvNumber <> inInvNumber
     THEN
       ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ConvertRemains(), inInvNumber, inOperDate, NULL);
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
 */

-- тест
--