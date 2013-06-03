-- Function: gpInsertUpdate_Object_ContractKind()

-- DROP FUNCTION gpInsertUpdate_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractKind(
INOUT ioId	                Integer,       -- ключ объекта < Виды договоров>
   IN inCode                Integer   ,    -- Код объекта <Виды договоров>
   IN inName                TVarChar  ,    -- Название объекта <Виды договоров>
   IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());

   -- проверка прав уникальности для свойства <Виды Договора>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractKind(), inName);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ContractKind(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            