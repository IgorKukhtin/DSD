-- Function: gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Подразделения> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Подразделения> 
    IN inName                     TVarChar  ,    -- Название объекта <Подразделения>
    IN inPhone                    TVarChar  ,    -- Телефон
    IN inComment                  TVarChar  ,    -- Примечание
    IN inParentId                 Integer   ,    -- ключ объекта <Група> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его как последний+1
   ioCode:=lfGet_ObjectCode (ioCode, zc_Object_Unit()); 

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inParentId, zc_ObjectLink_Unit_Parent());

   -- сохранили Телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);
   -- сохранили Примечание
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Comment(), ioId, inComment);
   -- сохранили группа
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_GroupNameFull(), ioId, vbGroupNameFull);
      
   -- сохранили связь с <Група>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Parent(), ioId, inParentId);

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
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
--