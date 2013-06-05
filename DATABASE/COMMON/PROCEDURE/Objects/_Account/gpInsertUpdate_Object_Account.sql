-- Function: gpInsertUpdate_Object_Account()

-- DROP FUNCTION gpInsertUpdate_Object_Account();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
 INOUT ioId                     Integer,    -- ключ объекта <Счет>
    IN inCode                   Integer,    --Код объекта <Счет>
    IN inName                   TVarChar,   --Название объекта <Счет>
    IN inAccountGroupId         Integer,    --Группа счетов
    IN inAccountDirectionId     Integer,    --Аналитика счета (место)
    IN inInfoMoneyDestinationId Integer,    --Аналитика счета (назначение)
    IN inSession                TVarChar    --сессия пользователя
)
  RETURNS integer AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Account(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountDirection(), ioId, inAccountDirectionId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/
