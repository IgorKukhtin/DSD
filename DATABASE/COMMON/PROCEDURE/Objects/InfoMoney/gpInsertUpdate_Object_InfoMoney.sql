-- Function: gpInsertUpdate_Object_InfoMoney()
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ключ объекта <Статья назначения>
    IN inCode                   Integer   ,    -- Код объекта <Статья назначения>
    IN inName                   TVarChar  ,    -- Название объекта <Статья назначения>
    IN inInfoMoneyGroupId       Integer   ,    -- ссылка на <Группы управленческих назначений>
    IN inInfoMoneyDestinationId Integer   ,    -- ссылка на <Управленческие назначения>
    IN inCashFlowId_in          Integer   ,    -- ссылка на <Статья отчета ДДС расход>
    IN inCashFlowId_out         Integer   ,    -- ссылка на <Статья отчета ДДС приход>
    IN inisProfitLoss           Boolean   ,    -- затраты по оплате
    IN inSession                TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer; 
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId = zc_Object_InfoMoney());

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_InfoMoney());


   -- Если код не установлен, определяем его каи последний+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
   
   -- !!! проверка прав уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), Code_calc);

   -- сохранили объект
   ioId := lpInsertUpdate_Object( ioId, zc_Object_InfoMoney(), Code_calc, inName);
   -- сохранили связь с <Группы управленческих назначений>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   -- сохранили связь с <Управленческие назначения>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   
   -- сохранили связь с <Статья отчета ДДС расход>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_in(), ioId, inCashFlowId_in);
   -- сохранили связь с <Статья отчета ДДС приход>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_out(), ioId, inCashFlowId_out);
         
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), ioId, inisProfitLoss);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.20         * CashFlow
 28.08.15         * add inisProfitLoss
 18.04.14                                        * rem !!! это временно !!!
 21.09.13                                        * !!! это временно !!!
 21.06.13          *  Code_calc:=lfGet_ObjectCode (inCode, zc_Object_InfoMoney());               
 16.06.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InfoMoney()
