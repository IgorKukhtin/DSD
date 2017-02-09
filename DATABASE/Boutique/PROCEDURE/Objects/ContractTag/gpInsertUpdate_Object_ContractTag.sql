-- Function: gpInsertUpdate_Object_ContractTag(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTag(Integer,Integer,TVarChar,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTag(Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractTag(
 INOUT ioId	                 Integer,       -- ключ объекта <Призник договора>
    IN inCode                Integer,       -- Код объекта <>
    IN inName                TVarChar,      -- Название объекта <>
    IN inContractTagGroupId  Integer,       -- Группы признаков договоров
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractTag());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractTag());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractTag(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractTag(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractTag(), vbCode_calc, inName);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractTag_ContractTagGroup(), ioId, inContractTagGroupId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractTag (Integer,Integer,TVarChar,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.14                                        * add lpCheckRight
 21.04.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractTag ()
                            