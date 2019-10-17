-- Function: gpInsertUpdate_Object_LabMark()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabMark (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabMark (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LabMark(
 INOUT ioId             Integer   ,     -- ключ объекта <> 
    IN inCode           Integer   ,     -- Код объекта <> 
    IN inName           TVarChar  ,     -- Название объекта <>
    IN inLabProductId   Integer   ,     -- 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_LabMark());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_LabMark());
   
   -- проверка прав уникальности для свойства <>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_LabMark(), inName);
   -- проверка прав уникальности для свойства <>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_LabMark(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LabMark(), vbCode_calc, inName);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabMark_LabProduct(), ioId, inLabProductId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LabMark()