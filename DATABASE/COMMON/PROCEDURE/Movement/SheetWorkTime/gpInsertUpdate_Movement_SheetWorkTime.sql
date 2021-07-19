-- Function: gpInsertUpdate_Movement_SheetWorkTime(Integer, TVarChar, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTime (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTime(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделения
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);


     PERFORM lpInsertUpdate_Movement_SheetWorkTime (ioId, inInvNumber, inOperDate, inUnitId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.13                         *
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SheetWorkTime (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inSession:= '2')
