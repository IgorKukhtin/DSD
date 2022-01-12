-- Function: gpInsertUpdate_Object_InfoMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
 INOUT ioId	          Integer   ,    -- ключ объекта <> 
    IN inCode             Integer   ,    -- код объекта <> 
    IN inName             TVarChar  ,    -- Название объекта <>
    IN inisService        Boolean   , 
    IN inisUserAll        Boolean   , 
    IN inInfoMoneyKindId  Integer   ,    --
    IN inParentId         Integer   ,    -- ключ объекта <Група>
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbGroupNameFull TVarChar;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_InfoMoney());
    
   -- проверка прав уникальности для свойства <Наименование Касса>  
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inInfoMoneyName);
   -- проверка прав уникальности для свойства <Код Кассы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InfoMoney(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InfoMoney(), inCode, inInfoMoneyName);

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_InfoMoney_Parent());

   -- сохранили группа
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_InfoMoney_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), ioId, inisService);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), ioId, inisUserAll);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_InfoMoneyKind(), ioId, inInfoMoneyKindId);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InfoMoney_Parent(), ioId, inParentId);

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
 11.01.22         *
*/

-- тест
--