-- Function: gpSetUnErased_MovementItem_InventoryHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem_InventoryHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem_InventoryHouseholdInventory(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbAmount     TFloat;
   DECLARE vbSaldo      TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory());

  -- устанавливаем новое значение
  outIsErased:= gpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- пересчитали Итоговые суммы по документу
  PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.ID = inMovementItemId));
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.07.20                                                                      * 
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem_InventoryHouseholdInventory (inMovementItemId:= 0, inSession:= '2')
