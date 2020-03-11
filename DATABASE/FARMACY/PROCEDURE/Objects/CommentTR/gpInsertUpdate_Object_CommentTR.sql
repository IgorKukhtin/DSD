-- Function: gpInsertUpdate_Object_CommentTR()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentTR(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentTR(
 INOUT ioId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название
    IN inisExplanation  Boolean   ,     -- Обязательное заполнение пояснения
    IN inisResort       Boolean   ,     -- Контроль пересорта
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CommentTR());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CommentTR());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CommentTR(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CommentTR(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CommentTR(), vbCode_calc, inName);
   
   -- сохранили Обязательное заполнение пояснения
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentTR_Explanation(), ioId, inisExplanation);

   -- сохранили Обязательное заполнение пояснения
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentTR_Resort(), ioId, inisResort);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.02.20                                                       *
*/

-- тест
