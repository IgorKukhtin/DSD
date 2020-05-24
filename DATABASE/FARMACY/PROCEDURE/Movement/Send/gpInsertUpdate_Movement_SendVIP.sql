-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendVIP (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendVIP(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inisUrgently          Boolean   , -- Срочно
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                         , inOperDate         := CURRENT_DATE
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inComment          := ''
                                         , inChecked          := False
                                         , inisComplete       := False
                                         , inNumberSeats      := 0
                                         , inDriverSunId      := 0
                                         , inUserId           := vbUserId
                                          );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_VIP(), ioId, True);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Urgently(), ioId, inisUrgently);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.05.20                                                       *  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SendVIP (ioId:= 0, inFromId:= 1, inToId:= 2, inisUrgently := False; inSession:= '2')
