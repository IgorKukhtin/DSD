-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
 INOUT ioId          Integer   ,    -- ключ объекта <Пользователь> 
    IN inCode        Integer   ,    -- 
    IN inUserName    TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword    TVarChar  ,    -- пароль пользователя 
    --IN inPrinterName TVarChar  ,    -- Принтер (печать Ценников)
    IN inMemberId    Integer   ,    -- физ. лицо
    IN inгыукId  Integer   ,    -- Язык
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN inCode := NEXTVAL ('Object_User_seq'); END IF; 
 
   -- проверка уникальности для свойства <Наименование Пользователя>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_User(), inCode, inUserName);

   -- сохранили свойство  <пароль>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Password(), ioId, inPassword);
   -- сохранили свойство  <Принтер>
   --PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Printer(), ioId, inPrinterName);

   -- сохранили свойство  <физ. лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Member(), ioId, inMemberId);
   -- сохранили свойство  <Подразделение>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), ioId, inLanguageId);

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыки А.А.
 30.04.18         * inPrinterName
 15.02.18         *
 06.05.17                                                          *
 05.05.17                                                          *
 12.09.16         *
 07.06.13                                        * lpCheckRight
*/

-- select ObjectCode from Object where DescId = zc_Object_User() group by ObjectCode having count (*) > 1
-- select ValueData from Object where DescId = zc_Object_User() group by ValueData having count (*) > 1

-- тест
-- SELECT * FROM gpInsertUpdate_Object_User (zfCalc_UserAdmin())
