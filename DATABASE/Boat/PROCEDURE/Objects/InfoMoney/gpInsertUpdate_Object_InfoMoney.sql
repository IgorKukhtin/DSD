-- Function: gpInsertUpdate_Object_InfoMoney()
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ключ объекта <Статья назначения>
    IN inCode                   Integer   ,    -- Код объекта <Статья назначения>
    IN inName                   TVarChar  ,    -- Название объекта <Статья назначения>
    IN inInfoMoneyGroupId       Integer   ,    -- ссылка на <Группы управленческих назначений>
    IN inInfoMoneyDestinationId Integer   ,    -- ссылка на <Управленческие назначения>
    IN inisProfitLoss           Boolean   ,    -- затраты по оплате
    IN inSession                TVarChar       -- сессия пользователя
)
  RETURNS integer 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer; 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
   
   -- !!! проверка прав уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), vbCode_max);

   -- сохранили объект
   ioId := lpInsertUpdate_Object( ioId, zc_Object_InfoMoney(), vbCode_max, inName);
   -- сохранили связь с <Группы управленческих назначений>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   -- сохранили связь с <Управленческие назначения>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), ioId, inisProfitLoss);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.15         * add inisProfitLoss
 18.04.14                                        * rem !!! это временно !!!
 21.09.13                                        * !!! это временно !!!
 21.06.13          *  vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());               
 16.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InfoMoney()
