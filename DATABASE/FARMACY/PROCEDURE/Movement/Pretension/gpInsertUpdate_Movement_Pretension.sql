-- Function: gpInsertUpdate_Movement_Pretension()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Pretension
   (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Pretension(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inParentId            Integer   , -- Приходная накладная
    IN inComment             TBlob     , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Pretension());

     ioId := lpInsertUpdate_Movement_Pretension(ioId
                                             , inInvNumber
                                             , inOperDate
                                             , inFromId
                                             , inToId
                                             , inParentId
                                             , inComment
                                             , vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Pretension (ioId:= 0, inSession:= '2')
