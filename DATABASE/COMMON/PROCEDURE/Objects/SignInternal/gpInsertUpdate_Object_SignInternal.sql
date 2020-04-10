-- Function: gpInsertUpdate_Object_SignInternal(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternal (Integer, Integer, TVarChar, Tfloat, Tfloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternal (Integer, Integer, TVarChar, Tfloat, Tfloat, TVarChar, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SignInternal(
 INOUT ioId               Integer   , -- Ключ объекта 
    IN inCode             Integer   , -- свойство <Код>
    IN inName             TVarChar  , -- свойство <Наименование>
    IN inMovementDescId   Tfloat    , -- 
    IN inObjectDescId     Tfloat    , -- 
    IN inComment          TVarChar  , -- 
    IN inObjectId         Integer   , -- ссылка на Подразделение
    IN inisMain           Boolean   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternal());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_SignInternal());

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_SignInternal(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SignInternal(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_SignInternal(), inObjectCode:= vbCode_calc, inValueData:= inName);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternal_Object(), ioId, inObjectId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SignInternal_MovementDesc(), ioId, inMovementDescId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SignInternal_ObjectDesc(), ioId, inObjectDescId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_SignInternal_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_SignInternal_Main(), ioId, inisMain);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.20         *
 22.08.16         *
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SignInternal()
