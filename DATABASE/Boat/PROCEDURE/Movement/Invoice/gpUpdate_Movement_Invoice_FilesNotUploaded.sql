-- Function: gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_FilesNotUploaded(
    IN inMovementId                Integer   , -- ключ объекта <Документ>
 INOUT ioIsFilesNotUploaded        Boolean   , -- Отложить отправку в DropBox (Да/Нет)
   OUT outisPostedToDropBox        Boolean   , -- Отправлено в DropBox (Да/Нет)
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
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
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ не сохранен.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_FilesNotUploaded'
                                              , inUserId        := vbUserId
                                              );
   END IF;


   -- новое Значение <Отложить отправку в DropBox (Да/Нет)>
   ioIsFilesNotUploaded := NOT ioIsFilesNotUploaded;

   -- сохранили свойство <Отложить отправку в DropBox (Да/Нет)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FilesNotUploaded(), inMovementId, ioIsFilesNotUploaded);

   -- если убрали <Отложить отправку в DropBox>
   IF ioIsFilesNotUploaded = FALSE
   THEN
       -- сохранили свойство НЕ <Отправлено в DropBox>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), inMovementId, FALSE);
   END IF;

   -- еще Вернули <Отправлено в DropBox (Да/Нет)>
   outisPostedToDropBox := COALESCE((SELECT COALESCE (MovementBoolean_PostedToDropBox.ValueData, FALSE)
                                     FROM MovementBoolean AS MovementBoolean_PostedToDropBox
                                     WHERE MovementBoolean_PostedToDropBox.MovementId = inMovementId
                                       AND MovementBoolean_PostedToDropBox.DescId   = zc_MovementBoolean_PostedToDropBox()), FALSE);

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