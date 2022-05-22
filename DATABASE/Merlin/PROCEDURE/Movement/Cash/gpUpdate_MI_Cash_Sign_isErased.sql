-- Function: gpUpdate_MI_Cash_Sign_isErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_Cash_Sign_isErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Cash_Sign_isErased(
    IN inMovementId          Integer              , -- ключ объекта <Элемент документа>
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId_mi Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- найти строку если пользователь уже Разрешил корректировку
     vbId_mi := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Sign()
                   AND MovementItem.ObjectId   = vbUserId
                   AND MovementItem.isErased   = FALSE
                );

     -- Проверка
     IF COALESCE (vbId_mi, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Нельзя отменить <Разрешение корректировки>.Элемент не найден.';
     END IF;


     -- Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
         -- Удаляем ВСЕ подписи
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Sign()
           AND MovementItem.isErased   = FALSE
          ;

         -- сначала отменяем что <корректировка прошла, данные перенесены из ....>
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Master() END, MovementItem.Id, FALSE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- Возвращаем обратно Child <-> Master
         UPDATE MovementItem SET DescId = CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- Корректировка НЕ подтверждена
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, FALSE);


         -- если документ проведен
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             -- Распроводим Документ
             PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
         END IF;

         -- Проводим
         PERFORM lpComplete_Movement_Cash (inMovementId:= inMovementId, inUserId:= vbUserId);

     ELSE
         -- Удаляем ОДНУ подпись
         PERFORM lpSetErased_MovementItem (inMovementItemId:= vbId_mi, inUserId:= vbUserId);
     END IF;

     -- сохранили свойство < Дата/время подписания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.22         *
*/

-- тест