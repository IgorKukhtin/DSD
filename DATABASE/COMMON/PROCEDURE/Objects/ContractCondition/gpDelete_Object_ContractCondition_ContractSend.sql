-- Function: gpDelete_Object_ContractCondition_ContractSend(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractCondition_ContractSend (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpDelete_Object_ContractCondition_ContractSend(
    IN inId                        Integer   , -- ключ объекта <Условия договора>
   OUT outContractSendName         TVarChar  , -- 
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   
    -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN;
   END IF;

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractSend(), inId, NULL);   
 
   outContractSendName := ''::TVarChar;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.21         *
*/

-- тест
-- 