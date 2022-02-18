-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inUnitId               Integer   , -- Подразделения
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Inventory (ioId                := ioId
                                              , inInvNumber         := inInvNumber
                                              , inOperDate          := inOperDate
                                              , inUnitId            := inUnitId
                                              , inComment           := inComment
                                              , inUserId            := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
 */

-- тест
--