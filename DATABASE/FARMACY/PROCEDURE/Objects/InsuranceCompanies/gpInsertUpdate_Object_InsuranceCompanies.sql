-- Function: gpInsertUpdate_Object_InsuranceCompanies (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InsuranceCompanies (Integer,Integer,TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InsuranceCompanies(
 INOUT ioId              Integer   ,    -- ключ объекта < Медицинское учреждение>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inJuridicalId     Integer   ,    -- Юридические лица 	
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_InsuranceCompanies());
   vbUserId := inSession; 

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_InsuranceCompanies()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InsuranceCompanies(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InsuranceCompanies(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_InsuranceCompanies(), vbCode_calc, inName);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InsuranceCompanies_Juridical(), ioId, inJuridicalId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InsuranceCompanies()