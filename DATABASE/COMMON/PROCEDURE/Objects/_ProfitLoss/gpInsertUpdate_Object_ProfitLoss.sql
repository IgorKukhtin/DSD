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
   DECLARE Code_max Integer;   

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProfitLoss());
    UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_ProfitLoss();
   ELSE
       Code_max := inCode;
   END IF; 
  
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLoss(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLoss(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossGroup(), ioId, inProfitLossGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *
 05.06.13          

*/
