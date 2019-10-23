-- Function: gpMovementItem_PersonalAccount_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalAccount_SetUnErased (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpMovementItem_PersonalAccount_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalAccount_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_PersonalAccount());

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalAccount_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.01.14                                        *
 19.12.13         *
*/

-- тест
-- SELECT * FROM gpMovementItem_PersonalAccount_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
