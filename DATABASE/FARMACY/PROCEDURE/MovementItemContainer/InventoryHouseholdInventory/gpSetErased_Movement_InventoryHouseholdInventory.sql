-- Function: gpSetErased_Movement_InventoryHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_InventoryHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_InventoryHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_InventoryHouseholdInventory());

    -- Проверяем первые переводы
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() 
    THEN
       RAISE EXCEPTION 'Ошибка.Документ проведен удаление запрещено.';
    END IF;

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_InventoryHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
