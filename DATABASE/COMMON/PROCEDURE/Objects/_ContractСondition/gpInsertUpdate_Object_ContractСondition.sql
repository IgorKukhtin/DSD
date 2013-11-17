-- Function: gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                        Integer   , -- ключ объекта <Условия договора>
    IN inValue                     TFloat    , -- значение
    IN inContractId                Integer   , -- Договор
    IN inContractConditionKindId   Integer   , -- Типы условий договоров 	
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition()());
   vbUserId := inSession;
   
    -- проверка
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка! Договор не установлен!';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractCondition(), 0, '');
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, TFloat, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
    