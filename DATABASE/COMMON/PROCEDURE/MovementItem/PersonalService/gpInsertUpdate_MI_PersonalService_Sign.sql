-- Function: gpInsertUpdate_MI_PersonalService_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Sign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Sign(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIsSign              Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsInsert Boolean;

  DECLARE vbId             Integer;
  DECLARE vbSignInternalId Integer;
  DECLARE vbOrd            Integer;
  DECLARE vbStrIdSign      TVarChar;
  DECLARE vbStrIdSignNo    TVarChar;
  DECLARE vbStrMIIdSign    TVarChar;
  DECLARE vbIndex          Integer; -- № пользователя среди подписанных
  DECLARE vbIndexNo        Integer; -- № пользователя среди НЕ подписанных
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);

     
     -- выбираем все Id пользователей
     SELECT tmp.SignInternalId, tmp.strMIIdSign, tmp.strIdSign, tmp.strIdSignNo
          , zfCalc_WordNumber_Split (tmp.strIdSign,   ',', vbUserId :: TVarChar)
          , zfCalc_WordNumber_Split (tmp.strIdSignNo, ',', vbUserId :: TVarChar)
            INTO vbSignInternalId, vbStrMIIdSign, vbStrIdSign, vbStrIdSignNo, vbIndex, vbIndexNo
      FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp;


     -- проверка
     IF inIsSign = TRUE
     THEN -- если Подтвердил электронную подпись

         IF vbIndex > 0 -- если он среди подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователь <%> уже Подтвердил электронную подпись в документе № <%> от <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));

         ELSEIF vbIndexNo = 0 -- если его НЕТ среди НЕ подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователю <%> не назначена электронная подпись для документа № <%> от <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));

         ELSEIF vbIndexNo <> 1 -- если НЕ первый среди НЕ подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователь <%> сможет подтвердить электронную подпись для документа № <%> от <%> только после <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                           , lfGet_Object_ValueData (zfCalc_Word_Split (vbStrIdSignNo, ',', vbIndexNo - 1) :: Integer);

         END IF;

     ELSE -- если Отменил электронную подпись

         IF vbIndexNo > 0 -- если он среди НЕ подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователь <%> уже Отменил электронную подпись в документе № <%> от <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));

         ELSEIF vbIndex = 0 -- если его НЕТ среди подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователю <%> не назначена отмена электронной подписи для  документа № <%> от <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));

         ELSEIF zfCalc_Word_Split (vbStrIdSign, ',', vbIndex + 1) <> '' -- если НЕ последний среди подписанных
         THEN
             RAISE EXCEPTION 'Ошибка.Пользователь <%> сможет Отменить электронную подпись для документа № <%> от <%> только после <%>.', lfGet_Object_ValueData (vbUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                           , lfGet_Object_ValueData (zfCalc_Word_Split (vbStrIdSign, ',', vbIndex + 1) :: Integer);

         END IF;
     END IF;


     -- так определили Id строки
     vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) :: Integer END;
     -- так определили № п/п
     IF inIsSign = TRUE
     THEN vbOrd:= 1 + COALESCE ((SELECT MAX (Amount) :: Integer FROM MovementItem WHERE MovementId = inMovementId AND DescId = zc_MI_Sign() AND MovementItem.isErased = FALSE AND MovementItem.Amount > 0), 0);
     ELSE vbOrd:= 0;
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbId, 0) = 0;
 
     -- сохранили <Элемент документа>
     vbId:= lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), vbSignInternalId, inMovementId, vbOrd, NULL);
   
     -- сохранили ВСЕГДА
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);


     -- а теперь еще и УДАЛИМ
     IF inIsSign = FALSE
     THEN
         PERFORM lpSetErased_MovementItem (inMovementItemId:= vbId, inUserId:= vbUserId);
     END IF;

     -- для док.Акция,
     IF (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId) = zc_Movement_Promo()
     THEN
         IF inIsSign = TRUE
         THEN
             -- если подписыввет последний пользователь устанавливаем свойства по согласованию
             IF zfCalc_Word_Split (vbStrIdSignNo, ',', vbIndexNo + 1) = '' -- если последний среди неподписанных
             THEN
                  -- сохранили свойство <Согласовано>
                  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId, TRUE);
                  -- сохранили свойство <дата согласования>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId, CURRENT_DATE);
             END IF;
         ELSE 
             -- при отмене подписи отменяем согласование
             -- сохранили свойство <Согласовано>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId, FALSE);
             -- сохранили свойство <дата согласования>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId, NULL);
         END IF;
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 03.08.17         *
 23.08.16         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- Степаненко О.М.
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- Степаненко О.М.

-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- Махота Д.П.
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- Махота Д.П.
