-- Function: gpInsertUpdate_Object_ReceiptLevel()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptLevel(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptLevel(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptLevel(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inCode                Integer   ,    -- Код объекта 
    IN inName                TVarChar  ,    -- Название объекта 
    IN inFromId              Integer   ,    -- 
    IN inToId                Integer   ,    --
    IN inDocumentKindId      Integer   ,    -- 
    IN inMovementDesc        TFloat   ,     -- 
    IN inComment             TVarChar  ,    -- Примечание
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_ReceiptLevel()); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptLevel(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptLevel_Comment(), ioId, inComment);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_From(), ioId, inFromId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_To(), ioId, inToId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_DocumentKind(), ioId, inDocumentKindId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptLevel_MovementDesc(), ioId, inMovementDesc);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.23         *
 14.06.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptLevel()
