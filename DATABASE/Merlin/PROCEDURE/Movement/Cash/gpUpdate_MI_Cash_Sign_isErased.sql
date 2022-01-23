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
   DECLARE vbMI_Id Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
  vbUserId:= lpGetUserBySession (inSession);

  --пробуем найти строку если пользователь уже подписывал корректировку
  vbMI_Id := (SELECT MovementItem.Id
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Sign()
                AND MovementItem.ObjectId = vbUserId
                AND MovementItem.isErased = FALSE
              );

  IF COALESCE (vbMI_Id,0) <> 0
  THEN
      -- устанавливаем новое значение
      --PERFORM lpSetErased_MovementItem (inMovementItemId:= vbMI_Id, inUserId:= vbUserId);
      UPDATE MovementItem SET isErased = TRUE
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.Id = vbMI_Id;
  END IF;

       -- проверка , если корректировка не полностью подписана переносим ее в обратно мастер  в чайлд а яайлд в мастер
     IF (SELECT COUNT(*) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
         <> 
        (SELECT COUNT(*) 
         FROM Object
              INNER JOIN ObjectBoolean AS ObjectBoolean_Sign
                                       ON ObjectBoolean_Sign.DescId = zc_ObjectBoolean_User_Sign() 
                                      AND ObjectBoolean_Sign.ObjectId = Object.Id
                                      AND COALESCE (ObjectBoolean_Sign.ValueData,FALSE) = TRUE
         WHERE Object.DescId = zc_Object_User()
         )
         AND (SELECT MovementBoolean_Sign.ValueData 
              FROM MovementBoolean AS MovementBoolean_Sign
              WHERE MovementBoolean_Sign.MovementId = inMovementId
                AND MovementBoolean_Sign.DescId = zc_MovementBoolean_Sign()
              ) = TRUE
     THEN
         UPDATE MovementItem SET DescId = CASE WHEN DescId = zc_MI_Master() THEN zc_MI_Child() ELSE zc_MI_Master() END
         WHERE MovementItem.MovementId = inMovementId AND DescId IN (zc_MI_Master(), zc_MI_Child());

         -- т.е. фиксируем что раньше это был Child или Master
         -- фиксируем , т.к. потом можно вернуть все обратно, и будет как было первоначально
         PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN zc_MIBoolean_Child() ELSE zc_MIBoolean_Child() END, MovementItem.Id, FALSE)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId IN (zc_MI_Master(), zc_MI_Child());
         
         --
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), inMovementId, FALSE);
         
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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.22         *
*/

-- тест