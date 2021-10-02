-- Function: gpInsertUpdate_Object_MedicalProgramSPLink()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicalProgramSPLink (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicalProgramSPLink(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inMedicalProgramSPId            Integer   , -- 
    IN inUnitId                        Integer   , -- 
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MedicalProgramSPLink());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MedicalProgramSPLink());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MedicalProgramSPLink(), vbCode_calc, '');

 
   -- сохранили связь с <Проекты (дисконтные карты)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP(), ioId, inMedicalProgramSPId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MedicalProgramSPLink_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MedicalProgramSPLink (ioId:=0, inCode:=0, inMedicalProgramSPLinkKindId:=0, inSession:='2')
