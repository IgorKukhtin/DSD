-- Function: gpInsertUpdate_Object_InfoMoney()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoney();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId                     Integer   ,    -- ключ объекта <Статья назначения>
    IN inCode                   Integer   ,    -- Код объекта <Статья назначения>
    IN inName                   TVarChar  ,    -- Название объекта <Статья назначения>
    IN inInfoMoneyGroupId       Integer   ,    -- ссылка на <Группы управленческих назначений>
    IN inInfoMoneyDestinationId Integer   ,    -- ссылка на <Управленческие назначения>
    IN inSession                TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer; 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoney());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_InfoMoney();
   ELSE
       Code_max := inCode;
   END IF; 

   -- !!! проверка прав уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), Code_max);

   -- сохранили объект
   ioId := lpInsertUpdate_Object( ioId, zc_Object_InfoMoney(), inCode, inName);
   -- сохранили связь с <Группы управленческих назначений>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   -- сохранили связь с <Управленческие назначения>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.06.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract()
