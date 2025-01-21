-- Function: gpInsertUpdate_Object_GoodsGroupProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupProperty(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupProperty(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupProperty(
 INOUT ioId               Integer   ,     -- ключ объекта <> 
    IN inCode             Integer   ,     -- Код объекта  
    IN inName             TVarChar  ,     -- Название объекта 
    IN inParentId         Integer   ,     -- Группа
    IN inQualityINN       TVarChar  ,     -- Ідентифікаційний номер тварини від якої отримано сировину  
    IN inSession          TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroupProperty());

   IF COALESCE (inCode,0) = 0 AND COALESCE (ioId,0) <> 0
   THEN
       inCode := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId AND Object.DescId = zc_Object_GoodsGroupProperty());
   END IF;
   
   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_GoodsGroupProperty());
                               
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroupProperty(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupProperty(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroupProperty(), inCode, inName);
         
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroupProperty_Parent(), ioId, inParentId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsGroupProperty_QualityINN(), ioId, inQualityINN);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.25         *
 19.12.23         *
*/

-- тест
-- 