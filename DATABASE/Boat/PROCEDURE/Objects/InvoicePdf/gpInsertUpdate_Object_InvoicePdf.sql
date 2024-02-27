-- Function: gpInsertUpdate_Object_InvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InvoicePdf(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inMovementId                 Integer   , --  
    IN inInvoicePdfData            TBlob     , -- Файл
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer
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
       --RAISE EXCEPTION 'Ошибка! Документ не выбран!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ не выбран.'           :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_InvoicePdf' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- если пусто
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RETURN;
       -- попробуем найти
       --ioId:= (SELECT OL.ObjectId FROM ObjectFloat AS OL WHERE OL.ValueData ::Integer = inMovementItemId AND OL.DescId = zc_ObjectFloat_InvoicePdf_MovementItemId());
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InvoicePdf(), 0, inPhotoName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InvoicePdf_Data(), ioId, inInvoicePdfData);

   -- сохранили связь с <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InvoicePdf_PhotoTag(), ioId, inPhotoTagId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_InvoicePdf_MovementId(), ioId, inMovementId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.24         *
*/

-- тест
--