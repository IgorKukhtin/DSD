-- Function: gpInsertUpdate_Object_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinance (Integer, Integer, TVarChar, TVarChar, Integer, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderFinance (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderFinance(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inComment                 TVarChar  ,    -- примечание
    IN inPaidKindId              Integer   ,    -- ФО
    IN inBankAccountId           Integer   ,    -- р/с
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderFinance());
   vbUserId := lpGetUserBySession (inSession); 

   -- Если код не установлен, определяем его как последний+1 
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_OrderFinance());

   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_OrderFinance(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderFinance(), vbCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderFinance(), vbCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_OrderFinance_Comment(), ioId, inComment);
   
   -- сохранили связь с <ФО>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinance_PaidKind(), ioId, inPaidKindId);

   -- сохранили связь с <р/с>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderFinance_BankAccount(), ioId, inBankAccountId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.19         *
 29.07.19         * 
*/

-- тест
--