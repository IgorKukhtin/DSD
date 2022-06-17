-- Function: gpUpdate_Movement_CashSend_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpUpdate_Movement_CashSend_CommentMoveMoney(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_CashSend_CommentMoveMoney(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inKindName             TVarChar  , -- признак приход / расход
    IN inCommentMoveMoney     TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbMovementItemId Integer;
   DECLARE vbCommentMoveMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney());
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


IF COALESCE (inCommentMoveMoney,'') <> ''
     THEN
         -- пробуем найти CommentMoveMoneyId
         vbCommentMoveMoneyId := (SELECT Object.Id
                                  FROM Object
                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                                               ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                                              AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                                  WHERE Object.ValueData = TRIM (inCommentMoveMoney)
                                    AND Object.DescId = zc_Object_CommentMoveMoney()
                                    AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                                  ORDER BY 1 ASC
                                  LIMIT 1
                                 );
         IF COALESCE (vbCommentMoveMoneyId,0) = 0
         THEN
             vbCommentMoveMoneyId := gpInsertUpdate_Object_CommentMoveMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentMoveMoney)::TVarChar
                                                                           , inSession := inSession
                                                                           );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentMoveMoney_UserAll(), vbCommentMoveMoneyId, NOT vbUser_isAll);
         END IF;
     END IF;                                                          
     
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, inCommentMoveMoneyId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

     
IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION 'Ошибка.test summa = <%>', vbCommentMoveMoneyId;
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