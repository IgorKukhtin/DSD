-- Function: gpInsertUpdate_Object_InfoMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId	              Integer   ,    -- ключ объекта <> 
    IN inCode             Integer   ,    -- код объекта <> 
    IN inName             TVarChar  ,    -- Название объекта <>
    --IN inisService        Boolean   , 
    IN inInfoMoneyKindId  Integer   ,    --
    IN inParentId         Integer   ,    -- ключ объекта <Група>
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbGroupNameFull TVarChar;       
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
    
   -- проверка прав уникальности для свойства <Наименование >  
  -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), inCode);

   -- сохранили
   vbOldId:= ioId;
   -- сохранили
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_InfoMoney_Parent() AND ObjectId = ioId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InfoMoney(), inCode, inName);

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_InfoMoney_Parent());

   -- сохранили группа
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InfoMoney_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), ioId, inisService);
   -- сохранили
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), ioId, inisUserAll);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_InfoMoneyKind(), ioId, inInfoMoneyKindId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_Parent(), ioId, inParentId);

   -- Если добавляли статью
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- Точно теперь inParentId стал папкой
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_InfoMoney_Parent());
   END IF;
   
   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь корр>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);   
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.22         *
 11.01.22         *
*/

-- тест
--