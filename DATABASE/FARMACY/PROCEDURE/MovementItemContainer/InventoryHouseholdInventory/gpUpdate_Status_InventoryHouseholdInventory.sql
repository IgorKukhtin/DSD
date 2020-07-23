-- Function: gpUpdate_Status_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpUpdate_Status_InventoryHouseholdInventory (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_InventoryHouseholdInventory(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_InventoryHouseholdInventory (ioId:= 0, inSession:= zfCalc_UserAdmin())