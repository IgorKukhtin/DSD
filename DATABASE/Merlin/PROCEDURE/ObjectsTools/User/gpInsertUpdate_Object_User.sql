-- Function: gpInsertUpdate_Object_User()
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ключ объекта <Пользователь> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword    TVarChar  ,    -- пароль пользователя 
    IN inMemberId    Integer   ,    -- физ. лицо
    IN inLanguageId  Integer   ,    -- Язык
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;
  DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его как последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_User()); 
 
   -- проверка уникальности для свойства <Наименование Пользователя>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_User(), inCode, inUserName);

   -- сохранили свойство  <пароль>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), ioId, inPassword);

   -- сохранили свойство  <физ. лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Member(), ioId, inMemberId);
   -- сохранили свойство  <Подразделение>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), ioId, inLanguageId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыки А.А.
 22.10.20         *
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- тест
-- SELECT * FROM gpInsertUpdate_Object_User (zfCalc_UserAdmin())
