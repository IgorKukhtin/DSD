-- Function: gpInsertUpdate_Object_AssetGroup()

-- DROP FUNCTION gpInsertUpdate_Object_AssetGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AssetGroup(
 INOUT ioId                  Integer   ,    -- ключ объекта < Группы основных средств>
    IN inCode                Integer   ,    -- Код объекта 
    IN inName                TVarChar  ,    -- Название объекта 
    IN inParentId            Integer   ,    -- ссылка на группу основных средств
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_AssetGroup());
   vbUserId:= lpGetUserBySession (inSession);

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_AssetGroup()); 

   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AssetGroup(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AssetGroup(), vbCode_calc);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_AssetGroup_Parent(), inParentId);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_AssetGroup(), inCode, inName);
   -- сохранили связь с <группой>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_AssetGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AssetGroup(Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AssetGroup()
