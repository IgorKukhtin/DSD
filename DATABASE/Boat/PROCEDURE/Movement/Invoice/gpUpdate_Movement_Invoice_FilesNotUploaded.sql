-- Function: gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_FilesNotUploaded(
    IN inMovementId                Integer   , -- ключ объекта <Документ>
 INOUT ioisFilesNotUploaded        Boolean   , -- Временно не выгружать файлы в DropBox    
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- проверка
   IF COALESCE (inMovementId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка! Договор не установлен!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка! Элемент документа не сохранен!'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_FilesNotUploaded'
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   ioisFilesNotUploaded := NOT ioisFilesNotUploaded;
   
   -- сохранили свойство <Временно не выгружать файлы в DropBox  >
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FilesNotUploaded(), inMovementId, ioisFilesNotUploaded);
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.02.24                                                       *
*/

-- тест
--