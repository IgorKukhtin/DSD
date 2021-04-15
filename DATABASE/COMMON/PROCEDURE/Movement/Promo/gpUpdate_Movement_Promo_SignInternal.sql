-- Function: gpUpdate_Movement_Promo_SignInternal()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_SignInternal(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inCountNum               Integer   , -- удалить Модель - тогда подписанты по-умолчанию и их ДВОЕ, инче - только ОДИН
   OUT outSignInternalId        Integer   ,
   OUT outSignInternalName      TVarChar  ,
   OUT outStrSign               TVarChar  , -- ФИО пользователей. - есть эл. подпись
   OUT outStrSignNo             TVarChar  , -- ФИО пользователей. - ожидается эл. подпись
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbId             Integer;
   DECLARE vbStrMIIdSign    TVarChar;
   DECLARE vbSignInternalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

          
     -- данные - кто подписал/не подписал - MovementItemId
     vbStrMIIdSign:= (SELECT tmp.StrMIIdSign FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp);

     -- поиск
     IF inCountNum = 3
     THEN
         -- нашли модель - с isMain = TRUE, там 3 подписанта
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = TRUE
                               AND gpSelect.Count_member   = inCountNum
                               AND gpSelect.Id <> 1127098
                            );
     ELSEIF inCountNum IN (1, 2)
     THEN
         -- нашли модель - "другую" - с isMain = FALSE, там по идее только один/два подписанта
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = FALSE
                               AND gpSelect.Count_member   = inCountNum
                               AND gpSelect.Id <> 1127098
                            );
         -- проверка - второй подписи быть не должно
         IF zfCalc_Word_Split (vbStrMIIdSign, ',', 2) <> ''
         THEN
             RAISE EXCEPTION 'Ошибка.Документ уже подписан.Изменение модели запрещено.';
         END IF;

     END IF;

     -- проверка
     IF COALESCE (vbSignInternalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Модель для подписи <%> подписанта.', inCountNum;
     END IF;

     -- надо поменять Модель
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);
     

     -- если только одна подпись - меняем Модель у самой подписи
     IF vbStrMIIdSign <> ''
     THEN
         -- так определили Id строки
         vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) :: Integer END;
         -- проверка
         IF COALESCE (vbId, 0) = 0
         THEN
              RAISE EXCEPTION 'Ошибка.Не найдена строка ОДНОЙ электронной подписи в документе № <%> от <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
         END IF;
         -- поменяли
         PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, vbSignInternalId, MovementItem.MovementId, MovementItem.Amount, NULL)
         FROM MovementItem
         WHERE MovementItem.Id = vbId;

     -- Ставим первую подпись - Маркетинга
     -- ELSE
    
     END IF;


     -- если последний - В работе Отдел Маркетинга
     IF zc_Enum_PromoStateKind_Start() = (SELECT MI.ObjectId
                                          FROM MovementItem AS MI
                                               JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                          WHERE MI.MovementId = inMovementId
                                            AND MI.DescId     = zc_MI_Message()
                                            AND MI.isErased   = FALSE
                                          ORDER BY MI.Id DESC
                                          LIMIT 1
                                         )
     THEN
         -- добавили состояние
         PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                         , inMovementId          := inMovementId
                                                         , inPromoStateKindId    := zc_Enum_PromoStateKind_StartSign() -- zc_Enum_PromoStateKind_Head()
                                                         , inIsQuickly           := TRUE
                                                         , inComment             := ''
                                                         , inSession             := inSession
                                                          );
     ELSE
         RAISE EXCEPTION 'Ошибка.Изменение кол-ва подписантов возможно только для состояния <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Start());
     END IF;


     -- вернули информацию о подписи
     SELECT tmpRes.SignInternalId
          , tmpRes.SignInternalName
          , tmpRes.strSign
          , tmpRes.strSignNo
            INTO outSignInternalId
               , outSignInternalName
               , outStrSign
               , outStrSignNo
     FROM (WITH tmpSign AS (SELECT * FROM lpSelect_MI_Sign (inMovementId:= inMovementId))
           SELECT Object_SignInternal.Id        AS SignInternalId
                , Object_SignInternal.ValueData AS SignInternalName
                , tmpSign.strSign               AS strSign
                , tmpSign.strSignNo             AS strSignNo
           FROM tmpSign
                LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = tmpSign.SignInternalId
          ) AS tmpRes;
          

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.20         *
*/

-- тест
--