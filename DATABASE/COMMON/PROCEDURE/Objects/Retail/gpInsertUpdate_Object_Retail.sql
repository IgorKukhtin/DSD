-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Retail(
 INOUT ioId                Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inCode              Integer   ,     -- Код объекта  
    IN inName              TVarChar  ,     -- Название объекта 
    IN inGLNCode           TVarChar  ,     -- Код GLN - Получатель
    IN inGLNCodeCorporate  TVarChar  ,     -- Код GLN - Поставщик 
    IN inGoodsPropertyId   Integer   ,    -- Классификаторы свойств товаров
    IN inSession           TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Retail());
   vbUserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Retail());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Retail(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Retail(), vbCode_calc);
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Retail(), vbCode_calc, inName);
   
   -- сохранили св-во <Код GLN - Получатель>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   -- сохранили св-во <Код GLN - Поставщик>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);
   
   -- сохранили связь с <Классификаторы свойств товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Retail (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.15         * add inGoodsPropertyId
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Retail(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')