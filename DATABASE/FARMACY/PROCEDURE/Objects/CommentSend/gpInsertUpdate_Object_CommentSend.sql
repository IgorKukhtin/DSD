-- Function: gpInsertUpdate_Object_CommentSend()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentSend(Integer, Integer, TVarChar, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentSend(
 INOUT ioId                 Integer   ,     -- ключ объекта <Покупатель> 
    IN inCode               Integer   ,     -- Код объекта  
    IN inName               TVarChar  ,     -- Название
    IN inCommentTRId        Integer   ,     -- Комментарий строк технического переучета
    IN inisPromo            Boolean   ,     -- Контроль количества по плану
    IN inisSendPartionDate  Boolean   ,     -- Контроль пересорта
    IN inisLostPositions    Boolean   ,     -- Утерянные позиции
    IN inSession            TVarChar        -- Формировать заявку на изменения срока
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CommentSend());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND (RoleId IN (zc_Enum_Role_Admin(), 13536335 )))
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CommentSend());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CommentSend(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CommentSend(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CommentSend(), vbCode_calc, inName);

   -- сохранили связь с <Комментарий строк технического переучета>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommentSend_CommentTR(), ioId, inCommentTRId);
   
   -- сохранили Контроль количества по плану
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentSun_Promo(), ioId, inisPromo);
   -- сохранили Формировать заявку на изменения срока
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentSun_SendPartionDate(), ioId, inisSendPartionDate);
   -- сохранили Формировать заявку на изменения срока
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentSun_LostPositions(), ioId, inisLostPositions);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.20                                                       *
*/

-- тест
