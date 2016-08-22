-- Function: gpInsertUpdate_Object_SignInternalItem(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternalItem (Integer, Integer, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SignInternalItem(
 INOUT ioId              Integer   , -- Ключ объекта 
    IN inCode            Integer   , -- свойство <Код>
    IN inName            TVarChar  , -- свойство <Наименование>
    IN inSignInternalId  Integer   , -- ссылка 
    IN inUserId          Integer   , -- ссылка  
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternalItem());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_SignInternalItem());

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_SignInternalItem(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_SignInternalItem(), inObjectCode:= vbCode_calc, inValueData:= inName);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternalItem_SignInternal(), ioId, inSignInternalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternalItem_User(), ioId, inUserId);

  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.16         *
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SignInternalItem()
