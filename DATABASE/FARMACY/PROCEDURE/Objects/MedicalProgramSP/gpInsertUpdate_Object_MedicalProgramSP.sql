-- Function: gpInsertUpdate_Object_MedicalProgramSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicalProgramSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicalProgramSP(
 INOUT ioId	                       Integer   ,    -- ключ объекта <Медицинские программы соц. проектов> 
    IN inCode                      Integer   ,    -- код объекта 
    IN inName                      TVarChar  ,    -- Название объекта <>
    IN inSPKindId                  Integer   ,    -- Виды соц. проектов
    IN inGroupMedicalProgramSPId   Integer   ,    -- Медицинские программы соц. проектов
    IN inProgramId                 TVarChar  ,    -- Идентификатор медицинской программы
    IN inisFree                    Boolean   ,    -- Безплатно
    IN inisElectronicPrescript     Boolean   ,    -- Электронные рецепты
    IN inSession                   TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;

   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MedicalProgramSP());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MedicalProgramSP(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MedicalProgramSP(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MedicalProgramSP(), vbCode_calc, inName);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MedicalProgramSP_SPKind(), ioId, inSPKindId);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP(), ioId, inGroupMedicalProgramSPId);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MedicalProgramSP_ProgramId(), ioId, inProgramId);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MedicalProgramSP_Free(), ioId, inisFree);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript(), ioId, inisElectronicPrescript);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MedicalProgramSP()