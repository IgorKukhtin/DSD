-- Function: gpSetUnErased_MovementItem_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem_TechnicalRediscount(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId  Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_TechnicalRediscount());


  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
  END IF;
    
  SELECT MovementItem.MovementId
  INTO vbMovementId
  FROM MovementItem 
  WHERE MovementItem.ID = inMovementItemId;

  -- устанавливаем новое значение
  outIsErased:= gpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- Пересчитываем суммы
  PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (vbMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem_TechnicalRediscount (inMovementItemId:= 0, inSession:= '2')
