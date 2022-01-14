-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inUnitId               Integer   , -- отдел 
    IN inParent_InfoMoneyId   Integer   , -- Статьи  группа
    IN inInfoMoney            TVarChar   , -- Статьи 
    IN inCommentInfoMoney     TVarChar   , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inInfoMoney,'') <> ''
     THEN
         --пробуем найти
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
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
                                                             , inInfoMoneyKindId := COALESCE ( (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inParent_InfoMoneyId AND OL.DescId = zc_ObjectLink_InfoMoney_InfoMoneyKind()), NULL) 
                                                             , inParentId := inParent_InfoMoneyId
                                                             , inSession := inSession
                                                             );
         END IF;
     END IF;

     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- пробуем найти CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney());
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId := 0
                                                                           , inSession := inSession
                                                                           );
         END IF;
     END IF;
                                                          
     
     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_Service (ioId                   := ioId
                                           , inInvNumber            := inInvNumber
                                           , inOperDate             := inOperDate
                                           , inServiceDate          := inServiceDate
                                           , inAmount               := inAmount
                                           , inUnitId               := inUnitId
                                           , inInfoMoneyId          := vbInfoMoneyId
                                           , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                           , inUserId               := vbUserId
                                            );
                                                

     -- 5.3. проводим Документ
     /*IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service())
     THEN
          PERFORM lpComplete_Movement_Service (inMovementId := ioId
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