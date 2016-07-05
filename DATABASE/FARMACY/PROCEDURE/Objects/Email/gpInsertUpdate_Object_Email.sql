-- Function: gpInsertUpdate_Object_Email()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Email (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Email (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Email(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inName                          TVarChar  , -- значение
    IN inErrorTo                       TVarChar  , -- Кому отправлять сообщение об ошибке при загрузке данных с п/я
    IN inEmailKindId                   Integer   , -- Тип почтового ящика
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Email());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Email());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Email(), vbCode_calc, inName);

   -- сохранили связь с <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Email_EmailKind(), ioId, inEmailKindId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Email_ErrorTo(), ioId, inErrorTo);
 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Email (ioId:=0, inCode:=0, inValue:='КУКУ', inEmailKindId:=0, inSession:='2')
