-- Function: gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_PostedToDropBox(
    IN inMovementId                Integer   , -- ключ объекта <Документ>
 INOUT ioIsPostedToDropBox         Boolean   , -- Отправлено в DropBox (Да/Нет)
   OUT outIsFilesNotUploaded       Boolean   , -- Отложить отправку в DropBox (Да/Нет)
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
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ не сохранен.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   IF NOT EXISTS(SELECT ObjectFloat_InvoicePdf_MovmentId.ObjectId
                 FROM ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                 WHERE ObjectFloat_InvoicePdf_MovmentId.ValueData = inMovementId
                   AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId())
   THEN
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Изменение признака невозможно.Не сформированы PDF по счету.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   IF NOT EXISTS(SELECT MovementFloat_Amount.MovementId
                 FROM MovementFloat AS MovementFloat_Amount
                 WHERE MovementFloat_Amount.MovementId = inMovementId
                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                   AND COALESCE(MovementFloat_Amount.ValueData, 0) <> 0)
   THEN
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Изменение признака невозможно.Не установлена сумма счета.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   -- новое Значение <Отправлено в DropBox (Да/Нет)>
   -- ioIsPostedToDropBox := NOT ioIsPostedToDropBox;
   IF vbUserId = 262864 -- Import-Export"
   THEN
       ioIsPostedToDropBox := TRUE;
   ELSE
       ioIsPostedToDropBox := FALSE;
   END IF;

   -- сохранили свойство <Отправлено в DropBox (Да/Нет)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), inMovementId, ioIsPostedToDropBox);


   -- новое Значение <Отложить отправку в DropBox (Да/Нет)>
   outIsFilesNotUploaded:= FALSE;

   -- еще сохранили свойство <Отложить отправку в DropBox (Да/Нет)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FilesNotUploaded(), inMovementId, outIsFilesNotUploaded);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.24                                                       *
*/

-- тест
--