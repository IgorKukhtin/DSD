-- Function: gpInsertUpdate_Object_ToolsWeighing

 DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing(
 INOUT ioId                      Integer   , -- ключ объекта
    IN inCode                    Integer   , -- Код объекта
    IN inValueData               TVarChar  , -- Значение
    IN inName                    TVarChar  , -- Название объекта
    IN inNameFull                TVarChar  , -- Полное название
    IN inNameUser                TVarChar  , -- Название для пользователя
    IN inParentId                Integer   , -- Parent Настройки взвешивания
    IN inSession                 TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ToolsWeighing());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

   -- проверка уникальности <Наименование>
--   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ToolsWeighing(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ToolsWeighing(), vbCode_calc);

   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_ToolsWeighing_Parent(), inParentId);

   -- сохранили
   vbOldId:= ioId;
   -- сохранили
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_ToolsWeighing_Parent() AND ObjectId = ioId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), vbCode_calc, inValueData, inAccessKeyId:= NULL);

   -- сохранили связь с <Настройки взвешивания>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ToolsWeighing_Parent(), ioId, inParentId);
   -- сохранили свойство <Полное название>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameFull(), ioId, inNameFull);
   -- сохранили свойство <название>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_Name(), ioId, inName);
   -- сохранили свойство <Название для пользователя>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- Если добавляли
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- Точно теперь inParentId стал папкой
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_ToolsWeighing_Parent());
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.03.14                                                         *
*/

-- тест
 SELECT * FROM gpInsertUpdate_Object_ToolsWeighing (0,0, '','Name','Name Full','Name User',88935,'2')