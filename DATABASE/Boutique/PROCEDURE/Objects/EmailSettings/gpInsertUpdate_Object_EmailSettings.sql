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
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_EmailSettings());

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_EmailSettings());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_EmailSettings(), vbCode_calc, inValue);

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
 23.03.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_EmailSettings (ioId:=0, inCode:=0, inValue:='КУКУ', inEmailKindId:=0, inEmailToolsId:=0, inSession:='2')
