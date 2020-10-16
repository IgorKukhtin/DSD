-- Function: gpInsertUpdate_Object_ProdOptPattern()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptPattern(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptPattern(
 INOUT ioId               Integer   ,    -- ключ объекта <>
    IN inCode             Integer   ,    -- Код объекта 
    IN inName             TVarChar  ,    -- Название объекта
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptPattern());
   vbUserId:= lpGetUserBySession (inSession);

    -- Если код не установлен, определяем его как последний+1, для каждой лодки начиная с 1
    vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ProdOptPattern()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptPattern(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdOptPattern_Comment(), ioId, inComment);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdOptPattern()

