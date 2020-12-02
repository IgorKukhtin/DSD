-- Function: gpInsertUpdate_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild(Integer, TVarChar, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModelChild(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inComment             TVarChar  ,    -- Название объекта
    IN inReceiptProdModelId  Integer   ,
    IN inObjectId            Integer   ,
    IN inValue               TFloat    , 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptProdModelChild(), 0, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptProdModelChild_Value(), ioId, inValue);
      
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel(), ioId, inReceiptProdModelId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_Object(), ioId, inObjectId);
   
   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModelChild()
