-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Cash_CommentInfoMoney(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Cash_CommentInfoMoney(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inKindName             TVarChar  , -- признак приход / расход
    IN inCommentInfoMoney     TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementItemId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Cash_CommentInfoMoney());
     --vbUserId:= lpGetUserBySession (inSession);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     
     -- Доступ
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- Проверка -
     IF COALESCE (inMI_Id,0) = 0 
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка не сохранена.';
     END IF;


     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() AND Object.isErased = FALSE AND 1=0)
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено Примечание с одинаковым значением <%>.', inCommentInfoMoney;
         END IF;

         -- пробуем найти CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() AND Object.isErased = FALSE ORDER BY 1 ASC LIMIT 1);
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (inId             := 0
                                                                           , inCode           := 0
                                                                           , inName           := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                           , inSession        := inSession
                                                                           );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

     
IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION 'Ошибка.test summa = <%>', vbCommentInfoMoneyId;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.22         *
 */

-- тест
--