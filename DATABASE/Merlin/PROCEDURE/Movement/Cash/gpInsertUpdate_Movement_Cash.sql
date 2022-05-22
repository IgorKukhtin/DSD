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
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyDetailId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;



     IF COALESCE (inInfoMoneyName,'') <> ''
     THEN
         --пробуем найти
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                           WHERE Object.ValueData = TRIM (inInfoMoneyName)
                             AND Object.DescId    = zc_Object_InfoMoney()
                             AND (COALESCE (ObjectLink_Parent.ChildObjectId, 0) = COALESCE (inParent_InfoMoneyId, 0))
                          );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId             := 0
                                                             , inCode           := 0
                                                             , inName           := TRIM (inInfoMoneyName)::TVarChar
                                                             , inIsService      := FALSE
                                                             , inIsUserAll      := NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
                                                             , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                             , inParentId       := inParent_InfoMoneyId
                                                             , inSession        := inSession
                                                             );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), vbInfoMoneyId, FALSE);
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), vbInfoMoneyId, NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE));

         END IF;
     END IF;

     IF COALESCE (inInfoMoneyDetailName,'') <> ''
     THEN
         -- пробуем найти InfoMoneyDetailId
         vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inInfoMoneyDetailName) AND Object.DescId = zc_Object_InfoMoneyDetail());
         IF COALESCE (vbInfoMoneyDetailId,0) = 0
         THEN
             vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId   := 0
                                                                         , inCode := 0
                                                                         , inName := TRIM (inInfoMoneyDetailName)::TVarChar
                                                                         , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                         , inSession := inSession
                                                                          );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoneyDetail_UserAll(), vbInfoMoneyDetailId, NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE));

         END IF;

     END IF;
     
     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- пробуем найти CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney());
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId             := 0
                                                                           , inCode           := 0
                                                                           , inName           := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                           , inSession        := inSession
                                                                           );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE));

         END IF;
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
                                        , inInfoMoneyDetailNameId    := vbInfoMoneyDetailId
                                        , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                        , inUserId               := vbUserId
                                         );
                                                


     -- проводим Документ
     PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                     , inUserId     := vbUserId
                                      );


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