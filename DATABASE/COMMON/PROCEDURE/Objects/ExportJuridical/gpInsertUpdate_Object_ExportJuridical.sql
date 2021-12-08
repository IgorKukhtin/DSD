 -- Function: gpInsertUpdate_Object_ExportJuridical(Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ExportJuridical (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ExportJuridical (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ExportJuridical(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar,
      IN inEmailKindId              Integer,  
      IN inRetailId                 Integer, 
      IN inJuridicalId              Integer, 
      IN inContractId               Integer, 
      IN inInfoMoneyId              Integer,
      IN inExportKindId             Integer,
      IN inContactPersonId          Integer,  
      IN inisAuto                   Boolean,      
      IN inSession                  TVarChar
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ExportJuridical());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ExportJuridical()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ExportJuridical(), vbCode_calc, inName, null);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_EmailKind(), ioId, inEmailKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_Retail(), ioId, inRetailId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_ExportKind(), ioId, inExportKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ExportJuridical_ContactPerson(), ioId, inContactPersonId);

   -- сохранили свойство <Автоотправка>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ExportJuridical_Auto(), ioId, inisAuto);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.21         *
 23.03.16         *
*/

-- тест
-- SELECT * FROM 
