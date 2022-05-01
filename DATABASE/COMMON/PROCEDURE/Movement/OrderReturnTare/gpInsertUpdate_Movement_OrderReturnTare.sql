-- Function: gpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber               TVarChar  , -- Номер документа
    IN inOperDate                TDateTime , -- Дата документа
    IN inMovementId_Transport    Integer   , -- Путевой лист  
    IN inManagerId               Integer   , -- земеститель нач.отдела
    IN inSecurityId              Integer   , -- отдел безопасности
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
                                                 , inMovementId_Transport := inMovementId_Transport 
                                                 , inManagerId := inManagerId
                                                 , inSecurityId := inSecurityId
                                                 , inComment   := inComment
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