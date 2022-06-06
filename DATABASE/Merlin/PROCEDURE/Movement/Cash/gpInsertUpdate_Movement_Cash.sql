-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash(Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inMI_Id                Integer   , -- идентификатор строки
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inCashId               Integer   , -- касса 
    IN inUnitId               Integer   , -- отдел 
    IN inParent_InfoMoneyId   Integer   , -- Статьи  группа
    IN inInfoMoneyName        TVarChar  , -- Статьи 
    IN inInfoMoneyDetailName  TVarChar  , -- Детали 
    IN inCommentInfoMoney     TVarChar  , -- Примечание
    IN inKindName             TVarChar  , -- признак приход / расход
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyDetailId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Доступ
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;



     IF COALESCE (inInfoMoneyName,'') <> ''
     THEN
         -- Проверка
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_Parent
                                           ON ObjectLink_Parent.ObjectId = Object.Id
                                          AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                              ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                             AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                 WHERE Object.ValueData = TRIM (inInfoMoneyName)
                   AND Object.DescId    = zc_Object_InfoMoney()
                   AND (COALESCE (ObjectLink_Parent.ChildObjectId, 0) = COALESCE (inParent_InfoMoneyId, 0))
                   AND Object.isErased = FALSE
                   AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                   AND 1=0
                )
         THEN
             RAISE EXCEPTION 'Ошибка.Найдена Статья с одинаковым значением <%> <%>.', inInfoMoneyName, lfGet_Object_ValueData_sh (inParent_InfoMoneyId);
         END IF;
         
         -- пробуем найти
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                                        ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                                       AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                           WHERE Object.ValueData = TRIM (inInfoMoneyName)
                             AND Object.DescId    = zc_Object_InfoMoney()
                             AND (COALESCE (ObjectLink_Parent.ChildObjectId, 0) = COALESCE (inParent_InfoMoneyId, 0))
                             AND Object.isErased = FALSE
                             AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                           ORDER BY 1 ASC
                           LIMIT 1
                          );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId             := 0
                                                             , inCode           := 0
                                                             , inName           := TRIM (inInfoMoneyName)::TVarChar
                                                             , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                             , inParentId       := inParent_InfoMoneyId
                                                             , inSession        := inSession
                                                             );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), vbInfoMoneyId, FALSE);
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), vbInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;

     IF COALESCE (inInfoMoneyDetailName,'') <> ''
     THEN
         -- Проверка
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                 WHERE Object.ValueData = TRIM (inInfoMoneyDetailName) AND Object.DescId = zc_Object_InfoMoneyDetail()
                  AND Object.isErased = FALSE
                  AND 1=0
                )
         THEN
             RAISE EXCEPTION 'Ошибка.Найдена Статья детально с одинаковым значением <%>.', inInfoMoneyDetailName;
         END IF;

         -- пробуем найти InfoMoneyDetailId
         vbInfoMoneyDetailId := (SELECT Object.Id
                                 FROM Object
                                 WHERE Object.ValueData = TRIM (inInfoMoneyDetailName)
                                   AND Object.DescId = zc_Object_InfoMoneyDetail()
                                   AND Object.isErased = FALSE
                                 ORDER BY 1 ASC
                                 LIMIT 1
                                );
         IF COALESCE (vbInfoMoneyDetailId,0) = 0
         THEN
             vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId   := 0
                                                                         , inCode := 0
                                                                         , inName := TRIM (inInfoMoneyDetailName)::TVarChar
                                                                         , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                         , inSession := inSession
                                                                          );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoneyDetail_UserAll(), vbInfoMoneyDetailId, NOT vbUser_isAll);

         END IF;

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
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId             := 0
                                                                           , inCode           := 0
                                                                           , inName           := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                           , inSession        := inSession
                                                                           );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
     -- Если Проведен
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- Распровели
         PERFORM lpUnComplete_Movement (ioId, vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_Cash (ioId                   := ioId
                                        , inMI_Id                := inMI_Id
                                        , inInvNumber            := inInvNumber
                                        , inOperDate             := inOperDate
                                        , inServiceDate          := inServiceDate
                                        , inAmount               := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN inAmount ELSE -1 * inAmount END ::TFloat
                                        , inCashId               := inCashId
                                        , inUnitId               := inUnitId
                                        , inInfoMoneyId          := vbInfoMoneyId
                                        , inInfoMoneyDetailId    := vbInfoMoneyDetailId
                                        , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                        , inUserId               := vbUserId
                                         );
                                                
     -- проводим Документ
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
         PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                         , inUserId     := vbUserId
                                          );
     END IF;

IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION 'Ошибка.test summa = <%>', inAmount;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         *
 */

-- тест
--