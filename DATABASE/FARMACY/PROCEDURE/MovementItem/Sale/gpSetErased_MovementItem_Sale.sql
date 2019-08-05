-- Function: gpSetErased_MovementItem_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_Sale(
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
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased:= gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- Убираем проводки для отложенных
  IF COALESCE ((SELECT ValueData FROM MovementBoolean 
                WHERE MovementId = (SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId)
                  AND DescId = zc_MovementBoolean_Deferred()), FALSE)= TRUE
  THEN
    -- Распроводим строку Документ
    PERFORM lpDelete_MovementItemContainerOne (inMovementId := (SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId)
                                             , inMovementItemId := inMovementItemId);  
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_Sale (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem_Sale (inMovementItemId:= 0, inSession:= '2')
