-- Function: gpInsertUpdate_Movement_StaffList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StaffList (Integer, TVarChar, TDateTime, Integer, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StaffList(
 INOUT ioId                     Integer   , -- Ключ объекта <Документ>
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата документа
    IN inUnitId                 Integer   , -- подразделение
    IN inComment                TVarChar  , -- Примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsInsert       Boolean;
   DECLARE vbPersonalHeadId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffList());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_StaffList(), inInvNumber, inOperDate, Null);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId); 
     
     --Руководитель подразделения
     vbPersonalHeadId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inUnitId AND OL.DescId = zc_ObjectLink_Unit_PersonalHead());
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalHead(), ioId, vbPersonalHeadId);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     ELSE
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId); 
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.25         *
*/

-- тест
--