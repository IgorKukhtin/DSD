-- Function: gpInsertUpdate_MI_Cash_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Cash_Sign (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Cash_Sign(
    IN inMovementId           Integer   , -- идентификатор Документ
    IN inAmount               TFloat    , -- если <> 0, тогда подписание состоялось успешно
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbId_mi Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);


     -- пробуем найти строку если пользователь уже Разрешал корректировку
     vbId_mi := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Sign()
                   AND MovementItem.ObjectId   = vbUserId
                 --AND MovementItem.isErased   = FALSE
                );

     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;

     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbUserId AND OB.DescId = zc_ObjectBoolean_User_Sign() AND OB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав <Разрешение корректировки>.', lfGet_Object_ValueData_sh (vbUserId);
     END IF;
     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = vbId_mi AND MovementItem.isErased = FALSE)
     THEN
        RAISE EXCEPTION 'Ошибка.<Разрешение корректировки> уже существует.Дублирование запрещено.';
     END IF;
     -- Проверка - сумма
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId IN (zc_MI_Master(), zc_MI_Child())
                HAVING SUM (CASE WHEN MI.DescId = zc_MI_Master() THEN MI.Amount ELSE 0 END) <> SUM (CASE WHEN MI.DescId = zc_MI_Master() THEN MI.Amount ELSE 0 END)
               )
     THEN
        RAISE EXCEPTION 'Ошибка.Не соответствуют суммы корректировки 1.<%> и 2.<%>.'
                      , zfConvert_FloatToString ((SELECT ABS (SUM (MI.Amount)) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Master()))
                      , zfConvert_FloatToString ((SELECT SUM (CASE WHEN MI_master.Amount > 0 THEN 1 ELSE -1 END * MI.Amount)
                                                  FROM MovementItem AS MI
                                                       JOIN MovementItem AS MI_master ON MI_master.MovementId = inMovementId AND MI_master.isErased = FALSE AND MI_master.DescId = zc_MI_Master()
                                                  WHERE MI.MovementId = inMovementId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Child()
                                                ))
                        ;
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbId_mi, 0) = 0;

     -- сохранили <Элемент документа>
     vbId_mi := lpInsertUpdate_MovementItem (vbId_mi, zc_MI_Sign(), vbUserId, inMovementId, 1, NULL);

     -- сохранили свойство < Дата/время подписания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_mi, CURRENT_TIMESTAMP);


     -- если корректировка полностью подписана, делаем замену Master <-> Child
     IF (SELECT COUNT(DISTINCT MovementItem.ObjectId) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
         =
        (SELECT COUNT(*)
         FROM Object
              INNER JOIN ObjectBoolean AS ObjectBoolean_Sign
                                       ON ObjectBoolean_Sign.ObjectId  = Object.Id
                                      AND ObjectBoolean_Sign.DescId    = zc_ObjectBoolean_User_Sign()
                                      AND ObjectBoolean_Sign.ValueData = TRUE
         WHERE Object.DescId = zc_Object_User()
         )
     THEN
         -- меняем  Master <-> Child
         UPDATE MovementItem SET DescId = CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- только потом устанавливаем что <корректировка прошла, данные перенесены из ....>
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Master() END, MovementItem.Id, TRUE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child())
           AND MovementItem.isErased = FALSE
           ;

         -- Корректировка подтверждена
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, TRUE);
         

         -- если документ проведен
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             -- Распроводим Документ
             PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
         END IF;

         -- Проводим
         PERFORM lpComplete_Movement_Cash (inMovementId:= inMovementId, inUserId:= vbUserId);


     ELSE
         -- Корректировка НЕ подтверждена
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, FALSE);

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.22         *
 */

-- тест
--