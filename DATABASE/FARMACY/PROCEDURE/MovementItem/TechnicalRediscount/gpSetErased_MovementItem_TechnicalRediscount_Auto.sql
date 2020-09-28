-- Function: gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_TechnicalRediscount_Auto(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId  Integer;
BEGIN

  SELECT MovementItem.MovementId
  INTO vbMovementId
  FROM MovementItem 
       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
  WHERE MovementItem.ID = inMovementItemId;
  
  
    -- устанавливаем новое значение
  PERFORM gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- Пересчитываем суммы
  PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (vbMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.09.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem_TechnicalRediscount_Auto (inMovementItemId:= 0, inSession:= '2')
