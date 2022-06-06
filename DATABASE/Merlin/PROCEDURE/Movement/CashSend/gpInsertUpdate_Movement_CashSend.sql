-- Function: gpInsertUpdate_Movement_CashSend()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CashSend(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCurrencyValue        TFloat    , -- курс
    IN inParValue             TFloat    , -- номинал
    IN inAmountOut            TFloat    , -- Сумма (расход)
    IN inAmountIn             TFloat    , -- Сумма (приход)
    IN inCashId_from          Integer   , -- касса (расход) 
    IN inCashId_to            Integer   , -- касса (приход) 
    IN inCommentMoveMoney     TVarChar  , -- Примечание Движение денег
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbCommentMoveMoneyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     -- Доступ
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);
     
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
                                                          
     
       -- Если Проведен
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- Распровели
         PERFORM lpUnComplete_Movement (ioId, vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_CashSend (ioId                   := ioId
                                            , inInvNumber            := inInvNumber
                                            , inOperDate             := inOperDate
                                            , inCurrencyValue        := inCurrencyValue
                                            , inParValue             := inParValue
                                            , inAmountOut            := inAmountOut
                                            , inAmountIn             := inAmountIn
                                            , inCashId_from          := inCashId_from
                                            , inCashId_to            := inCashId_to
                                            , inCommentMoveMoneyId   := vbCommentMoveMoneyId
                                            , inUserId               := vbUserId
                                             );
                                                

     -- 5.3. проводим Документ
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
         PERFORM lpComplete_Movement_CashSend (inMovementId := ioId
                                             , inUserId     := vbUserId
                                              );
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