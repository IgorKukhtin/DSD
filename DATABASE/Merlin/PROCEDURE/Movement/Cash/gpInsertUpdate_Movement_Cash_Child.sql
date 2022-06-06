-- Function: gpInsertUpdate_Movement_Cash()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Child(Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Child(Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_Child(
    IN inMovementId           Integer   , -- Ключ объекта <Документ>+
    IN inMI_Id                Integer   , -- идентификатор строки
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inCashId               Integer   , -- касса 
    IN inUnitId               Integer   , -- отдел 
    IN inParent_InfoMoneyId   Integer   , -- Статьи  группа
    IN inInfoMoneyId          Integer   , -- Статьи 
    IN inInfoMoneyDetailId    Integer   , -- Детали 
    IN inCommentInfoMoney     TVarChar   , -- Примечание
    IN inKindName             TVarChar   , --призрак приход / расход
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbCommentInfoMoneyId Integer;
   
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_master TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Доступ
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;



     /*IF COALESCE (inInfoMoney,'') <> ''
     THEN
         --пробуем найти
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
                           WHERE Object.ValueData = TRIM (inInfoMoney) AND Object.DescId = zc_Object_InfoMoney()
                             AND (ObjectLink_Parent.ChildObjectId = inParent_InfoMoneyId OR inParent_InfoMoneyId = 0)
                           );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId   := 0
                                                             , inCode := 0
                                                             , inName := TRIM (inInfoMoney)::TVarChar
                                                             , inisService := TRUE
                                                             , inisUserAll := COALESCE ( (SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inParent_InfoMoneyId AND OB.DescId = zc_ObjectBoolean_InfoMoney_UserAll()), FALSE)
                                                             , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                             , inParentId := inParent_InfoMoneyId
                                                             , inSession := inSession
                                                             );
         END IF;
     END IF;

     IF COALESCE (inInfoMoneyDetail,'') <> ''
     THEN
         -- пробуем найти InfoMoneyDetailId
         vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inInfoMoneyDetail) AND Object.DescId = zc_Object_InfoMoneyDetail());
         IF COALESCE (vbInfoMoneyDetailId,0) = 0
         THEN
             vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId   := 0
                                                                         , inCode := 0
                                                                         , inName := TRIM (inInfoMoneyDetail)::TVarChar
                                                                         , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                         , inSession := inSession
                                                                         );
         END IF;
     END IF;
     */


     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- пробуем найти CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() ORDER BY 1 ASC LIMIT 1);
         --
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId := 0
                                                                           , inSession := inSession
                                                                           );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
     -- сохранили <Документ>
     inMovementId:= lpInsertUpdate_Movement_Cash_Child (ioId                   := inMovementId
                                                      , inMI_Id                := inMI_Id
                                                      , inInvNumber            := inInvNumber
                                                      , inOperDate             := inOperDate
                                                      , inServiceDate          := inServiceDate
                                                      , inAmount               := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN inAmount ELSE inAmount * (-1) END ::TFloat
                                                      , inCashId               := inCashId
                                                      , inUnitId               := inUnitId
                                                      , inInfoMoneyId          := inInfoMoneyId
                                                      , inInfoMoneyDetailId    := inInfoMoneyDetailId
                                                      , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                                      , inUserId               := vbUserId
                                                       );
                                                
     -- проверка распределен ли весь документ
     vbAmount_master := (SELECT SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 ELSE 1 END * MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE);
     vbAmount        := (SELECT SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 ELSE 1 END * MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE);
     
     --RAISE EXCEPTION 'Ошибка. <%>  -  <%> .', vbAmount_master, vbAmount;
     
     IF vbAmount_master <> 0 AND vbAmount = vbAmount_master
        AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
     THEN
     
         PERFORM gpInsertUpdate_MI_Cash_Sign (inMovementId := inMovementId
                                            , inAmount     := vbAmount_master
                                            , inSession    := inSession
                                             );
     END IF;
     


     -- 5.3. проводим Документ
     /*IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := inMovementId
                                             , inUserId     := vbUserId);
     END IF;
*/
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