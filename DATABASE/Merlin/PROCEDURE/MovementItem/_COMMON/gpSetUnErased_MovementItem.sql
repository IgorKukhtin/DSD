-- Function: gpSetUnErased_MovementItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
     vbUserId:= lpGetUserBySession (inSession);


     -- нашли
     vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId);

     -- Если Проведен
     /*IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- Распровели
         PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
     END IF;*/


     -- устанавливаем новое значение
     outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


     -- проводим Документ
     /*IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId AND Movement.DescId = zc_Movement_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := vbMovementId
                                          , inUserId     := vbUserId
                                           );
     ELSE
         RAISE EXCEPTION 'Ошибка.';
     END IF;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem (inMovementItemId:= 0, inSession:= '2')
