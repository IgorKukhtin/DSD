-- Function: gpInsert_Movement_Pretension()

DROP FUNCTION IF EXISTS gpInsert_Movement_Pretension (Integer, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Pretension(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
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
     
     ioId := 0;
     
     IF COALESCE (inComment, '') = ''
     THEN
       RETURN;
     END IF;  
     
     ioId := lpInsertUpdate_Movement_Pretension(0
                                             , CAST (NEXTVAL ('movement_Pretension_seq') AS TVarChar) 
                                             , CURRENT_DATE
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
-- SELECT * FROM gpInsert_Movement_Pretension (ioId:= 0, inSession:= '2')