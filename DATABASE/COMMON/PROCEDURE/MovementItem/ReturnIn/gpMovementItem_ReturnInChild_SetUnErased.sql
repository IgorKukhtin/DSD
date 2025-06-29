-- Function: gpMovementItem_ReturnInChild_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ReturnInChild_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ReturnInChild_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_ReturnIn());

     --проверка
     IF TRUE = COALESCE ( (SELECT MIBoolean_Calculated.ValueData
                           FROM MovementItemBoolean AS MIBoolean_Calculated
                           WHERE MIBoolean_Calculated.MovementItemId = inMovementItemId
                             AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                           ), FALSE)
     THEN 
          RAISE EXCEPTION 'Ошибка.Удаление/восстановление запрещено - Строка с автозаполнением .';
     END IF;
     
  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.25         *

*/

-- тест
-- 