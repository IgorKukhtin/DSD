-- Function: gpInsertUpdate_Object_ContractDocument(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractDocument(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractDocument(
 INOUT ioId                        Integer   , -- ключ объекта <Документ договора>
    IN inDocumentName              TVarChar  , -- Файл
    IN inContractId                Integer   , -- Договор
    IN inContractDocumentData      TBlob     , -- Тело документа 	
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   
    -- проверка
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка! Договор не установлен!';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractDocument(), 0, zfCalc_Text_replace(inDocumentName, CHR (39), '') :: TVarChar);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ContractDocument_Data(), ioId, inContractDocumentData);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractDocument_Contract(), ioId, inContractId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.14                                        * add lpCheckRight
 10.12.13                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractDocument (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
