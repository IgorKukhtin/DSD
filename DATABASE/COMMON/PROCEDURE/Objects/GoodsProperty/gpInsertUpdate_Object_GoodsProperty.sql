﻿-- Function: gpInsertUpdate_Object_GoodsProperty()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsProperty();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsProperty(
 INOUT ioId                  Integer   ,   	-- ключ объекта <Классификатор свойств товаров> 
    IN inCode                Integer   ,    -- Код объекта <Классификатор свойств товаров> 
    IN inName                TVarChar  ,    -- Название объекта <Классификатор свойств товаров> 
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Route();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Классификатора>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsProperty(), inName);
   -- проверка прав уникальности для свойства <Код Классификатора>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsProperty(), Code_max);

   -- сохранили <Объект>  
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsProperty(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsProperty(Integer, Integer, TVarChar, TVarChar)
  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 00.06.13          
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsProperty()