-- Function: gpMovementItem_ProductionUnion_Master_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionUnion_Master_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionUnion_Master_SetErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_ProductionUnion());

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionUnion_Master_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 04.05.15                                        *
 02.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_ProductionUnion_Master_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
