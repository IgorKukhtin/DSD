-- Function: gpInsertUpdate_Object_DiscountExternalTools()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalTools(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inUser                          TVarChar  , -- 
    IN inPassword                      TVarChar  , -- 
    IN inDiscountExternalId            Integer   , -- 
    IN inUnitId                        Integer   , -- 
    IN inExternalUnit                  TVarChar  , -- Подразделение проекта, идентификатор аптеки, который присваивается со стороны проекта
    IN inToken                         TVarChar  , -- API токен 
    IN inisNotUseAPI                   Boolean   , -- Не использовать АПИ  
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalTools());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalTools());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalTools(), vbCode_calc, '');

 
   -- сохранили связь с <Проекты (дисконтные карты)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalTools_DiscountExternal(), ioId, inDiscountExternalId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalTools_Unit(), ioId, inUnitId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_User(), ioId, inUser);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_Password(), ioId, inPassword);
   -- сохранили свойство <Подразделение проекта>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_ExternalUnit(), ioId, inExternalUnit);
   -- сохранили свойство <API токен>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_Token(), ioId, inToken);

   -- сохранили свойство <API токен>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiscountExternalTools_NotUseAPI(), ioId, inisNotUseAPI);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalTools (ioId:=0, inCode:=0, inDiscountExternalToolsKindId:=0, inSession:='2')
