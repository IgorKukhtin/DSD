-- Function: gpInsertUpdate_Object_Account (Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Account (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
 INOUT ioId                     Integer,    -- ключ объекта <Счет>
    IN inCode                   Integer,    -- Код объекта <Счет>
    IN inName                   TVarChar,   -- Название объекта <Счет>
    IN inAccountGroupId         Integer,    -- Группа счетов
    IN inAccountDirectionId     Integer,    -- Аналитика счета (место)
    IN inInfoMoneyDestinationId Integer,    -- Аналитика счета (назначение)
    IN inInfoMoneyId            Integer,    -- Управленческие аналитики
    IN inIAccountKindId         Integer,    -- Виды счетов
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
    vbUserId := inSession;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Account()); 

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Account(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Account(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountDirection(), ioId, inAccountDirectionId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoney(), ioId, inInfoMoneyId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountKind(), ioId, inIAccountKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Account (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.13          * + AccountKind
 02.07.13                                        * change CodePage
 17.06.13          *
*/
