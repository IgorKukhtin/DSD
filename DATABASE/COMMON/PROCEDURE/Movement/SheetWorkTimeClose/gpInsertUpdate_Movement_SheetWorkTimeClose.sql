-- Function: gpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата начала периода
    IN inOperDateEnd         TDateTime , -- Дата окончания периода
    IN inTimeClose           TDateTime , -- Время авто закрытия
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());


     -- сохранили <Документ>
      SELECT tmp.ioId
    INTO ioId
      FROM lpInsertUpdate_Movement_SheetWorkTimeClose (ioId           := ioId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inOperDateEnd  := inOperDateEnd
                                                     , inTimeClose    := inTimeClose
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.21         *
*/

-- тест
--