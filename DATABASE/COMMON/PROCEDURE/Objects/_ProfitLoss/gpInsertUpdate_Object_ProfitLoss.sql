-- Function: gpInsertUpdate_Object_ProfitLoss()

-- DROP FUNCTION gpInsertUpdate_Object_ProfitLoss();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLoss(
 INOUT ioId                     Integer,    -- ключ объекта <Статьи отчета о прибылях и убытках>
    IN inCode                   Integer,    -- Код объекта 
    IN inName                   TVarChar,   -- Название объекта 
    IN inProfitLossGroupId         Integer, -- Группа счетов
    IN inProfitLossDirectionId     Integer, -- Аналитика счета (место)
    IN inInfoMoneyDestinationId Integer,    -- Аналитика счета (назначение)
    IN inInfoMoneyId            Integer,    -- Управленческие аналитики
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_calc Integer;   

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLoss());
    UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());
  
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLoss(), Code_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLoss(), Code_calc, inName);
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossGroup(), ioId, inProfitLossGroupId);
   -- сохранили связь с <Аналитика счета (место)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   -- сохранили связь с <Аналитика счета (назначение)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProfitLoss(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, tvarchar) OWNER TO postgres;


  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());             
 18.06.13          *
 05.06.13          

*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProfitLoss()