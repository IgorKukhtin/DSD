-- Function: gpUpdate_Object_InvoicePdf_DateUnloading(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_InvoicePdf_DateUnloading(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_InvoicePdf_DateUnloading(
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
                                              , inProcedureName := 'gpUpdate_Object_InvoicePdf_DateUnloading'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_InvoicePdf_DateUnloading(), inId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


   -- сохранили свойство <Отправлено в DropBox (Да/Нет)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_InvoicePdf_MovementId()) :: Integer, TRUE);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_InvoicePdf_MovementId()) :: Integer, vbUserId, FALSE);

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