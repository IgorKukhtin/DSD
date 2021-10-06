-- Function: gpInsertUpdate_Object_BanCommentSend()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BanCommentSend (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BanCommentSend(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inCommentSendId                 Integer   , -- 
    IN inUnitId                        Integer   , -- 
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BanCommentSend());
   vbUserId := inSession;

   IF COALESCE(inCommentSendId, 0) = 0 OR COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено подразделение или коммент.';            
   END IF;
   
   IF COALESCE (ioId, 0) = 0 AND
      EXISTS (SELECT Object_BanCommentSend.Id         AS Id
              FROM Object AS Object_BanCommentSend
                   INNER JOIN ObjectLink AS ObjectLink_CommentSend
                                         ON ObjectLink_CommentSend.ObjectId = Object_BanCommentSend.Id
                                        AND ObjectLink_CommentSend.DescId = zc_ObjectLink_BanCommentSend_CommentSend()
                                        AND ObjectLink_CommentSend.ChildObjectId = inCommentSendId
                   INNER JOIN ObjectLink AS ObjectLink_Unit
                                         ON ObjectLink_Unit.ObjectId = Object_BanCommentSend.Id
                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_BanCommentSend_Unit()
                                        AND ObjectLink_Unit.ChildObjectId = inUnitId
              WHERE Object_BanCommentSend.DescId = zc_Object_BanCommentSend()) 
   THEN
      SELECT Object_BanCommentSend.Id, Object_BanCommentSend.ObjectCode 
      INTO ioId, vbCode_calc
      FROM Object AS Object_BanCommentSend
           INNER JOIN ObjectLink AS ObjectLink_CommentSend
                                 ON ObjectLink_CommentSend.ObjectId = Object_BanCommentSend.Id
                                AND ObjectLink_CommentSend.DescId = zc_ObjectLink_BanCommentSend_CommentSend()
                                AND ObjectLink_CommentSend.ChildObjectId = inCommentSendId
           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_BanCommentSend.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_BanCommentSend_Unit()
                                AND ObjectLink_Unit.ChildObjectId = inUnitId
      WHERE Object_BanCommentSend.DescId = zc_Object_BanCommentSend();    

      IF EXISTS (SELECT Object_BanCommentSend.Id         AS Id
                 FROM Object AS Object_BanCommentSend
                 WHERE Object_BanCommentSend.DescId = zc_Object_BanCommentSend()
                   AND Object_BanCommentSend.Id = ioId
                   AND Object_BanCommentSend.isErased = TRUE) 
      THEN
         RAISE EXCEPTION 'Ошибка. По подразделению и коменту уже есть запись. Используйте ее.';            
      END IF;
      
      RETURN;
   ELSE   

     IF EXISTS (SELECT Object_BanCommentSend.Id         AS Id
                FROM Object AS Object_BanCommentSend
                     INNER JOIN ObjectLink AS ObjectLink_CommentSend
                                           ON ObjectLink_CommentSend.ObjectId = Object_BanCommentSend.Id
                                          AND ObjectLink_CommentSend.DescId = zc_ObjectLink_BanCommentSend_CommentSend()
                                          AND ObjectLink_CommentSend.ChildObjectId = inCommentSendId
                     INNER JOIN ObjectLink AS ObjectLink_Unit
                                           ON ObjectLink_Unit.ObjectId = Object_BanCommentSend.Id
                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_BanCommentSend_Unit()
                                          AND ObjectLink_Unit.ChildObjectId = inUnitId
                WHERE Object_BanCommentSend.DescId = zc_Object_BanCommentSend()
                  AND Object_BanCommentSend.Id <> ioId) 
     THEN
        RAISE EXCEPTION 'Ошибка. По подразделению и коменту уже есть запись. Используйте ее.';            
     END IF;
     
     -- Если код не установлен, определяем его как последний+1
     vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_BanCommentSend());
   
   END IF;
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BanCommentSend(), vbCode_calc, '');

 
   -- сохранили связь с <Проекты (дисконтные карты)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BanCommentSend_CommentSend(), ioId, inCommentSendId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BanCommentSend_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BanCommentSend (ioId:=0, inCode:=0, inBanCommentSendKindId:=0, inSession:='2')
