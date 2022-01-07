-- Function: gpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber               TVarChar  , -- Номер документа
    IN inOperDate                TDateTime , -- Дата документа
    IN inComment                 TVarChar  , -- Примечание
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisAuto Boolean;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderReturnTare());

     -- Сохранение
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_OrderReturnTare (ioId        := ioId
                                                 , inInvNumber := inInvNumber
                                                 , inOperDate  := inOperDate
                                                 , inComment   := inisPrintComment
                                                 , inUserId    := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.01.22         *
*/

-- тест
--