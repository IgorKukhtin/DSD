-- Function: gpInsertUpdate_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItem(Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItem(Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ServiceItem(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inUnitId               Integer   , -- отдел
    IN inInfoMoneyId          Integer   , -- Статьи  
    IN inAmount               TFloat    , -- Сумма
    IN inPrice                TFloat    , -- цена
    IN inArea                 TFloat    , -- площадь
    IN inCommentInfoMoney     TVarChar   , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCommentInfoMoneyId Integer; 
   DECLARE vbUser_isAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- Доступ
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

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
                                                                           , inInfoMoneyNameKindId := 0
                                                                           , inSession := inSession
                                                                            );
             -- сохранили
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
       -- Если Проведен
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- Распровели
         PERFORM gpUnComplete_Movement_ServiceItem (ioId, inSession);
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ServiceItem (ioId                 := ioId
                                               , inInvNumber          := inInvNumber
                                               , inOperDate           := inOperDate
                                               , inUnitId             := inUnitId
                                               , inInfoMoneyId        := inInfoMoneyId
                                               , inCommentInfoMoneyId := vbCommentInfoMoneyId
                                               , inAmount             := inAmount
                                               , inPrice              := inPrice
                                               , inArea               := inArea
                                               , inUserId             := vbUserId
                                                );
                                                

     -- 5.3. проводим Документ
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_ServiceItem())
     THEN
          PERFORM lpComplete_Movement_ServiceItem (inMovementId := ioId
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