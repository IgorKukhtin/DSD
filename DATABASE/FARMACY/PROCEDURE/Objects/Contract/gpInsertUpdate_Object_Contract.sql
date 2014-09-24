-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inJuridicalBasisId        Integer   ,    -- ссылка на главное юр.лицо
    IN inJuridicalId             Integer   ,    -- ссылка на  юр.лицо
    IN inDeferment               Integer   ,    -- Дней отсрочки
    IN inComment                 TVarChar  ,    --  
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Contract(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_Deferment(), ioId, inDeferment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.09.14                         * 
 01.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract ()                            
