-- Function: gpInsertUpdate_MI_Cash_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Cash_Sign (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Cash_Sign(
    IN inMovementId           Integer   , -- идентификатор Документ
    IN inAmount               TFloat    , -- если <> 0, тогда подписание состоялось успешно
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbMI_Id Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     --пробуем найти строку если пользователь уже подписывал корректировку
     vbMI_Id := (SELECT MovementItem.Id FROM MovementItem 
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Sign()
                   AND MovementItem.ObjectId = vbUserId
                   AND MovementItem.isErased = FALSE);

     --
   RAISE EXCEPTION 'Ошибка. <%>  -  <%> .', vbMI_Id, vbMI_Id;
     IF COALESCE (vbMI_Id, 0) <> 0 
     THEN
        -- RETURN;
            RAISE EXCEPTION 'Ошибка. <%>  -  <%> .', vbMI_Id, vbMI_Id;
     END IF;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMI_Id, 0) = 0;

     -- сохранили <Элемент документа>
     vbMI_Id := lpInsertUpdate_MovementItem (vbMI_Id, zc_MI_Sign(), vbUserId, inMovementId, inAmount, NULL);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMI_Id, CURRENT_TIMESTAMP);
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, vbIsInsert);

     -- проверка , если корректировка полностью подписана переносим ее в мастер а мастер в чайлд
     IF (SELECT COUNT(*) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
         = 
        (SELECT COUNT(*) 
         FROM Object
              INNER JOIN ObjectBoolean AS ObjectBoolean_Sign
                                       ON ObjectBoolean_Sign.DescId = zc_ObjectBoolean_User_Sign() 
                                      AND ObjectBoolean_Sign.ObjectId = Object.Id
                                      AND COALESCE (ObjectBoolean_Sign.ValueData,FALSE) = TRUE
         WHERE Object.DescId = zc_Object_User()
         )
     THEN
         UPDATE MovementItem SET DescId = CASE WHEN DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId AND DescId IN (zc_MI_Master(), zc_MI_Child());

         -- т.е. фиксируем что раньше это был Child или Master
         -- фиксируем , т.к. потом можно вернуть все обратно, и будет как было первоначально
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Child() END, MovementItem.Id, TRUE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child());
         
         --
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, TRUE);
         
         /*
         UPDATE zc_MIBoolean_Child SET ValueData = TRUE
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() --  т.е. фиксируем что раньше это был Child
         
         -- 
         UPDATE zc_MIBoolean_Master SET ValueData = TRUE
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() --  т.е. фиксируем что раньше это был Master
         */     
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