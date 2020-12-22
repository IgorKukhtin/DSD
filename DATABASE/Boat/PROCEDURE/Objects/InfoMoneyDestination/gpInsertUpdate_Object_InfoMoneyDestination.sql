-- Function: gpInsertUpdate_Object_InfoMoneyDestination()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyDestination();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyDestination(
 INOUT ioId          Integer   ,    -- ключ  Управленческие аналитики - назначение
    IN inCode        Integer   ,    -- код
    IN inName        TVarChar  ,    -- Наименование
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   

BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId = zc_Object_InfoMoneyDestination());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoneyDestination()); 

   -- !!! проверка прав уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyDestination(), inName,vbUserId);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoneyDestination(), vbCode_max, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyDestination(), vbCode_max, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.14                                        * rem !!! это временно !!!
 21.09.13                                        * !!! это временно !!!
 21.06.13          * gpInsertUpdate_Object_InfoMoneyDestination(); vbCode_max
 19.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InfoMoneyDestination()
