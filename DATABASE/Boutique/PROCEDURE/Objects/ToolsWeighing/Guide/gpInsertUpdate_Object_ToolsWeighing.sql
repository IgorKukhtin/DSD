-- Function: gpInsertUpdate_Object_ToolsWeighing

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing(
 INOUT ioId                      Integer   , -- ключ
    IN inCode                    Integer   , -- Код
    IN inName                    TVarChar  , -- Название
    IN inNameUser                TVarChar  , -- Название для пользователя
    IN inValue                   TVarChar  , -- Значение
    IN inNameFull                TVarChar  , -- Полное название
    IN inParentId                Integer   , -- Группа
    IN inSession                 TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF TRIM (COALESCE (inName, '')) = '' THEN RAISE EXCEPTION 'Ошиибка. inName = <%>', inName; END IF;
   -- проверка
   IF inNameFull <> '' AND TRIM (COALESCE (inValue, '')) = '' THEN RAISE EXCEPTION 'Ошиибка. inValue = <%>   inName = <%>   inNameFull = <%>', inValue, inName, inNameFull; END IF;
   -- проверка
   IF inNameFull <> '' AND COALESCE (inParentId, 0) = 0 THEN RAISE EXCEPTION 'Ошиибка. inParentId не может быть null для inName = <%>', inName; END IF;
   -- проверка
   IF ioId <> 0 AND NOT EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = ioId AND DescId = zc_ObjectLink_ToolsWeighing_Parent() AND COALESCE (ChildObjectId, 0) <> COALESCE (inParentId, 0))
   THEN RAISE EXCEPTION 'Ошиибка. inParentId не может измениться для inName = <%>', inName; END IF;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ToolsWeighing());

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ToolsWeighing(), vbCode_calc);
   -- проверка уникальность <Наименование> для данной группы
   IF EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId
                                    AND TRIM (ObjectString.ValueData) = TRIM (inName)
              WHERE COALESCE (ObjectLink.ChildObjectId, 0) = COALESCE (inParentId, 0)
                AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_ToolsWeighing_Parent())
   THEN
       RAISE EXCEPTION 'Ошибка. Элемент <%> уже существует в группе <%>(%). inNameFull = <%>   inParentId = <%>', TRIM (inName), (SELECT ValueData FROM ObjectString WHERE ObjectId = inParentId AND DescId = zc_ObjectString_ToolsWeighing_Name()), (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = inParentId AND DescId = zc_ObjectBoolean_isLeaf()), inNameFull, inParentId;
   END IF;


   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink (ioId, zc_ObjectLink_ToolsWeighing_Parent(), inParentId);


   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), vbCode_calc, inValue, inAccessKeyId:= NULL);

   -- сохранили связь с <Настройки взвешивания>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ToolsWeighing_Parent(), ioId, inParentId);
   -- сохранили свойство <Полное название>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameFull(), ioId, inNameFull);
   -- сохранили свойство <название>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_Name(), ioId, inName);
   -- сохранили свойство <Название для пользователя>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameUser(), ioId
                                      , COALESCE ((SELECT OS_ToolsWeighing_NameUser.ValueData
                                                   FROM ObjectString AS OS_ToolsWeighing_Name
                                                        INNER JOIN ObjectString AS OS_ToolsWeighing_NameUser
                                                                                ON OS_ToolsWeighing_NameUser.ObjectId  = OS_ToolsWeighing_Name.ObjectId
                                                                               AND OS_ToolsWeighing_NameUser.DescId    = zc_ObjectString_ToolsWeighing_NameUser()
                                                                               AND OS_ToolsWeighing_NameUser.ValueData <> ''
                                                   WHERE OS_ToolsWeighing_Name.ValueData = inName
                                                     AND OS_ToolsWeighing_Name.ObjectId <> ioId
                                                     AND OS_ToolsWeighing_Name.DescId    = zc_ObjectString_ToolsWeighing_Name()
                                                   ORDER BY OS_ToolsWeighing_NameUser.ValueData DESC
                                                   LIMIT 1
                                                  )
                                                , inNameUser)
                                      );

   -- Установить свойство лист\папка у себя
   IF TRIM (inNameFull) <> ''
   THEN
      -- элемент
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
    ELSE
      -- группа 
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, FALSE);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= FALSE, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.01.15                                        * all
 12.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ToolsWeighing (0, 0, 'Name','NameUser', 'Value', 'NameFull', 0, '5')
