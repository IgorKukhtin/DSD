-- Function: gpDelete_Movement_Invoice_FilesNotUploaded(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Movement_Invoice_FilesNotUploaded(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Movement_Invoice_FilesNotUploaded(
    IN inId                        Integer   , -- ключ объекта <Документ>
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка! Договор не установлен!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка! Элемент документа не сохранен!'
                                              , inProcedureName := 'gpDelete_Movement_Invoice_FilesNotUploaded'
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   -- Удаление 
   DELETE FROM MovementBoolean 
   WHERE MovementBoolean.MovementId = inId
     AND MovementBoolean.DescId = zc_MovementBoolean_FilesNotUploaded();
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

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