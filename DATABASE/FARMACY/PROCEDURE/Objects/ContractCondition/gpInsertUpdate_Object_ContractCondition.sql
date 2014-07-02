-- Function: gpInsertUpdate_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, Integer, TVarChar, Integer, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inContractId              Integer   ,    -- ссылка на главное юр.лицо
    IN inContractConditionKindId Integer   ,    -- ссылка на  юр.лицо
    IN inValue                   TFloat  ,    --  
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ContractCondition());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ContractCondition(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractCondition(), vbCode_calc);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, Integer, TVarChar, Integer, Integer, TFloat, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition ()                            
