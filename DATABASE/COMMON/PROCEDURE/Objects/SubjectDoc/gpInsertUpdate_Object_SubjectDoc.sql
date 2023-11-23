-- Function: gpInsertUpdate_Object_SubjectDoc()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SubjectDoc(
 INOUT ioId             Integer   ,     -- ключ объекта <Регионы> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inShort          TVarChar  ,     -- Сокращенное название
    IN inReasonId       Integer   ,     -- Причина возврата / перемещения
    IN inMovementDesc   TVarChar  , 
    IN inComment        TVarChar  ,
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
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_SubjectDoc(), inName);
   IF EXISTS (SELECT Object.ValueData 
              FROM Object
                   LEFT JOIN ObjectLink AS ObjectLink_Reason
                                        ON ObjectLink_Reason.ObjectId = Object.Id 
                                       AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
              WHERE Object.DescId = zc_Object_SubjectDoc() 
                AND TRIM (Object.ValueData) = TRIM (inName)
                AND Object.Id <> COALESCE(ioId, 0) 
                AND ((Object.ObjectCode < 1001 AND vbCode_calc < 1001) OR (Object.ObjectCode > 1001 AND vbCode_calc > 1000)) 
                AND COALESCE (inReasonId,0) = COALESCE (ObjectLink_Reason.ChildObjectId,0)
              )
   THEN
      RAISE EXCEPTION 'Значение "%" не уникально', inName;
   END IF; 

   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SubjectDoc(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SubjectDoc(), vbCode_calc, inName);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_Short(), ioId, inShort);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_MovementDesc(), ioId, inMovementDesc);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SubjectDoc_Comment(), ioId, inComment);

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
