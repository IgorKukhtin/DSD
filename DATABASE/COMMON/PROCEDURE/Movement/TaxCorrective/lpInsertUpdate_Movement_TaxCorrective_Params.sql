-- Function: lpInsertUpdate_Movement_TaxCorrective_Params()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective_Params(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inDateRegistered      TDateTime , -- Дата регистрации
    IN inRegistered          Boolean   , -- Зарегестрирована (да/нет)
    IN inContractId          Integer   , -- Договора
    IN inUserId              Integer     -- пользователь
)
RETURNS INTEGER AS
$BODY$
  DECLARE vbStatusId  Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = ioId;
     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- сохранили свойство <Дата регистрации>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     -- сохранили свойство <Зарегестрирован (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), ioId, inRegistered);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.06.14                                        * add проверка - проведенные/удаленные документы Изменять нельзя
 01.05.14                                        * здесь надо сохранить только 2 параметра
 11.02.14                                                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inUserId:=24)
