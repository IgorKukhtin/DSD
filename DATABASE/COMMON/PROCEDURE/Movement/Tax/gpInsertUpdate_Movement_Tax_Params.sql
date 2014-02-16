-- gpInsertUpdate_Movement_Tax_Params()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_Params (
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inDateRegistered      TDateTime , -- Дата регистрации
    IN inRegistered          Boolean   , -- Зарегестрирована (да/нет)
    IN inContractId          Integer   , -- Договора
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());
     vbUserId:= 5;

     -- проверка - проведенный/удаленный документ не может корректироваться
     IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не может корректироваться т.к. он <%>.', lfGet_Object_ValueData ((SELECT StatusId FROM Movement WHERE Id = ioId));
     END IF;

     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен договор.';
     END IF;

     ioId := lpInsertUpdate_Movement_Tax_Params(ioId, inInvNumber, inOperDate, inDateRegistered, inRegistered, inContractId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')