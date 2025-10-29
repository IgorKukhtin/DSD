-- Function: gpMovementItem_Inventory_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Inventory_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Inventory_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Inventory());


  -- !!!Проверка - Инвентаризация - запрет на изменения (разрешено только проведение)!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11109744)
  THEN
       RAISE EXCEPTION 'Ошибка.Нет прав.';
  END IF;


  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 01.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_Inventory_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
