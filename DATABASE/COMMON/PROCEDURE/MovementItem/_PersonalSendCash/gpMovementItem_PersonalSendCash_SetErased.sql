-- Function: gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalSendCash_SetErased(
    IN inMovementId          Integer              , -- ключ Документа
    IN inPersonalId          Integer              , -- Сотрудник
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
BEGIN

  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = outIsErased
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inPersonalId
    AND MovementItem.DescId = zc_MI_Master();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpMovementItem_PersonalSendCash_SetErased (inMovementId:= 55, inPersonalId = 1, inSession:= '2')
