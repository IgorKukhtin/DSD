-- Function: gpInsertUpdate_Object_InfoMoneyGroup()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(
 INOUT ioId              Integer   ,   	-- ключ <Группы управленческих аналитик>
    IN inCode            Integer   ,    -- код
    IN inName            TVarChar  ,    -- Наименование  
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyGroup());


   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyGroup(), inName,vbUserId);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyGroup(), vbCode_max, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyGroup(), vbCode_max, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             
*/

-- тест  
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyGroup()                         