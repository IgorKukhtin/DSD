-- Function: gpSetUnErased_MovementItemChild_PUSH (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItemChild_PUSH (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItemChild_PUSH(
    IN inMovementId          Integer             , -- ключ объекта <Документ>
 INOUT ioMovementItemId      Integer              , -- ключ объекта <Элемент документа>
    IN inUnitId              Integer              , -- ключ объекта <Подразделение>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);
  
  IF (COALESCE (inMovementId, 0) = 0)
  THEN
    RAISE EXCEPTION 'Ошибка. Не заполнен номер оповещения.';
  END IF;

  IF COALESCE (ioMovementItemId, 0) = 0
  THEN

    IF (COALESCE (inUnitId, 0) = 0)
    THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено подразделение.';
    END IF;
    
    INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
    VALUES (zc_MI_Child(), inUnitId, inMovementId, 0, Null) RETURNING Id INTO ioMovementItemId;
      
    outIsErased:= False;
  ELSE
    -- устанавливаем новое значение
    outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= ioMovementItemId, inUserId:= vbUserId);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItemChild_PUSH (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItemChild_PUSH (inMovementItemId:= 0, inSession:= '2')


