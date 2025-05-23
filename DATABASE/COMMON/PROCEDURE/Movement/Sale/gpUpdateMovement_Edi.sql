-- Function: gpUpdateMovement_EdiOrdspr 


DROP FUNCTION IF EXISTS gpUpdateMovement_Edi (Integer, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_Edi (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Edi (
    IN inId                  Integer   , -- Ключ объекта <Документ продажа - отправка в EDI>
   OUT ioValue               Boolean   , -- Проверен
    IN inDescCode            TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
     ioValue:= True;
     
     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (tmpDesc.Id, inId, ioValue)
           FROM MovementBooleanDesc AS tmpDesc
           WHERE LOWER (Code) = LOWER (inDescCode);
   
  -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.02.15         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Edi (inId:=  83674 , inDescCode := 'zc_MovementBoolean_EdiOrdspr', inSession:= '5')
