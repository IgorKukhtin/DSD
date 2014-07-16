-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Tfloat, TVarChar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inJuridicalId             Integer   ,    -- ссылка на главное юр.лицо
    IN inContractId              Integer   ,    -- ссылка на 
    IN inFileTypeId              Integer   ,    -- ссылка на 
    IN inImportTypeId            Integer   ,    -- ссылка на  
    IN inStartRow                Tfloat    ,    -- 
    IN inDirectory               TVarChar  ,    --  
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Contract(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode_calc);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_FileType(), ioId, inFileTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_ImportType(), ioId, inImportTypeId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_StartRow(), ioId, inStartRow);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Contract_Directory(), ioId, inDirectory);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Tfloat, TVarChar, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportSettings ()                            
