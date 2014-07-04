-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Подразделение>
    IN inCode                    Integer   ,    -- Код объекта <Подразделение>
    IN inName                    TVarChar  ,    -- Название объекта <Подразделение>
    IN inParentId                Integer   ,    -- ссылка на подразделение
    IN inJuridicalId             Integer   ,    -- ссылка на Юридические лицо
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- сохранили
   vbOldId:= ioId;
   -- сохранили
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);

   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- Если добавляли подразделение
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- Точно теперь inParentId стал папкой 
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Unit_Parent());
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.14         * 
 25.06.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
