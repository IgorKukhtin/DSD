-- Function: gpInsertUpdate_Movement_OrderRK()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderRK (Integer, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderRK(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderRK());
     
     -- сохранили <Документ>
      SELECT tmp.ioId
    INTO ioId
      FROM lpInsertUpdate_Movement_OrderRK (ioId           := ioId
                                          , inInvNumber    := inInvNumber
                                          , inOperDate     := inOperDate
                                          , inComment      := inComment
                                          , inUserId       := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
--