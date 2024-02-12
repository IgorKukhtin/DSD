-- Function: gpInsertUpdate_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EmailSettings (Integer, Integer, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_EmailSettings(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inValue                         TVarChar  , -- значение
    IN inEmailKindId                   Integer   , -- Вид почты 
    IN inEmailToolsId                  Integer   , -- Параметры установок для почты
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_EmailSettings());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_EmailSettings());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_EmailSettings(), inCode, inValue);

   -- сохранили связь с <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_EmailKind(), ioId, inEmailKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_EmailTools(), ioId, inEmailToolsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.24         *
*/

-- тест
--