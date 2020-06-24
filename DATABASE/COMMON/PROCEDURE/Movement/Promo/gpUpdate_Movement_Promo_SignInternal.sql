-- Function: gpUpdate_Movement_Promo_SignInternal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_SignInternal(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_SignInternal(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inIsNull                 Boolean   , -- удалить Модель - тогда подписанты по-умолчанию и их ДВОЕ, инче - только ОДИН
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
     IF inIsNull = TRUE
     THEN
         -- нашли модель - с isMain = TRUE, там два подписанта
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = TRUE
                            );
     ELSE
         -- нашли модель - "другую" - с isMain = FALSE, там по идее только один подписант
         vbSignInternalId:= (SELECT gpSelect.Id
                             FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                             WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                               AND gpSelect.isMain         = FALSE
                            );
         -- проверка - второй подписи быть не должно
         IF zfCalc_Word_Split (vbStrMIIdSign, ',', 2) <> ''
         THEN
             RAISE EXCEPTION 'Ошибка.Документ уже подписан.Изменение модели запрещено.';
         END IF;

     END IF;

     -- надо поменять Модель
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);
     

     -- если подписан - меняем Модель у самой подписи
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