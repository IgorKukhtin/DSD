-- Function: gpInsertUpdate_Object_Account()

-- DROP FUNCTION gpInsertUpdate_Object_Account();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
 INOUT ioId                     Integer,    -- ключ объекта <Счет>
    IN inCode                   Integer,    -- Код объекта <Счет>
    IN inName                   TVarChar,   -- Название объекта <Счет>
    IN inAccountGroupId         Integer,    -- Группа счетов
    IN inAccountDirectionId     Integer,    -- Аналитика счета (место)
    IN inInfoMoneyDestinationId Integer,    -- Аналитика счета (назначение)
    IN inInfoMoney              Integer,    -- Управленческие аналитики
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Account();
   ELSE
       Code_max := inCode;
   END IF; 
  
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Account(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Account(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountDirection(), ioId, inAccountDirectionId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/
