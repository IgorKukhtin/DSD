-- Function: gpInsertUpdate_Object_InfoMoneyGroup()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(
 INOUT ioId	             Integer   ,   	-- ключ <Группы управленческих аналитик>
    IN inCode            Integer   ,    -- код
    IN inName            TVarChar  ,    -- Наименование  
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer;   

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyGroup());


   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyGroup(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyGroup(), Code_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyGroup(), Code_calc, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InfoMoneyGroup (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             
*/

-- тест  
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyGroup()                         