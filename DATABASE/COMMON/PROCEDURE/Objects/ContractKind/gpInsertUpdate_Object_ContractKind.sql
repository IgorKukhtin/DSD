-- Function: gpInsertUpdate_Object_ContractKind()

-- DROP FUNCTION gpInsertUpdate_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractKind(
INOUT ioId	                Integer,       -- ключ объекта <Виды договоров>
   IN inCode                Integer   ,    -- Код объекта <Виды договоров>
   IN inName                TVarChar  ,    -- Название объекта <Виды договоров>
   IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractKind()); 
   
   -- проверка прав уникальности для свойства <Виды Договора>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractKind(), inName);
   -- проверка прав уникальности для свойства <Код Вида Договора>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractKind(), vbCode_calc);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ContractKind(), vbCode_calc, inName);
   -- сохранили связь с <Типы Счетов>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKind_AccountKind(), ioId, CASE WHEN vbCode_calc < 100 THEN zc_Enum_AccountKind_Active() WHEN vbCode_calc < 200 THEN zc_Enum_AccountKind_Passive() END);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.13                                        * add zc_ObjectLink_ContractKind_AccountKind
 22.12.13                                        * Cyr1251
 21.10.13                                        * add vbCode_calc
 11.06.13          *
*/

-- тест
-- SELECT * FROM ()
