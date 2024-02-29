-- Function: gpInsertUpdate_Movement_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalGroupSummAdd (Integer, TVarChar, TDateTime, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalGroupSummAdd(                               
 INOUT ioId                     Integer   , -- Ключ объекта <Документ>
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата документа 
    IN inNormHour               TFloat    , --NormHour
    IN inComment                TVarChar  , -- Примечание
    IN inPersonalServiceListId  Integer   , -- 
    IN inUnitId                 Integer   , -- 
    IN inPersonalGroupId        Integer   , -- 
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd());

     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- переопределяем дату документа - Месяц начислений = первое число месяца
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalGroupSummAdd(), inInvNumber, inOperDate, Null);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), ioId, inPersonalGroupId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NormHour(), ioId, inNormHour);
     
     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
--