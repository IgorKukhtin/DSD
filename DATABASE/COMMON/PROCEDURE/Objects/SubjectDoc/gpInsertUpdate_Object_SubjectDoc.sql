-- Function: gpInsertUpdate_Object_SubjectDoc()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SubjectDoc(
 INOUT ioId             Integer   ,     -- ключ объекта <Регионы> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inShort          TVarChar  ,     -- Сокращенное название
    IN inReasonId       Integer   ,     -- Причина возврата / перемещения
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SubjectDoc());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SubjectDoc());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_SubjectDoc(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SubjectDoc(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SubjectDoc(), vbCode_calc, inName);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_Short(), ioId, inShort);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SubjectDoc_Reason(), ioId, inReasonId);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.23         *
 06.02.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SubjectDoc(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')
