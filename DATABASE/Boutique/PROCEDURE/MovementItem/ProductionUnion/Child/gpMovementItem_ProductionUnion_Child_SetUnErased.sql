-- Function: gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionUnion_Child_SetUnErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_ProductionUnion());

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 04.05.15                                        *
 02.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_ProductionUnion_Child_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
