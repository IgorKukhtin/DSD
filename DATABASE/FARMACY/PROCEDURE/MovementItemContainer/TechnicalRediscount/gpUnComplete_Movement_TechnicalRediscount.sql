-- Function: gpUnComplete_Movement_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_TechnicalRediscount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbInventoryID Integer;
  DECLARE vbStatusID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TechnicalRediscount());

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
                                 
    -- 5.1 Отменяем инвентаризацию
    IF EXISTS(SELECT *
              FROM Movement
              WHERE Movement.DescId = zc_Movement_Inventory()
                AND Movement.ParentId = inMovementId)
    THEN
        SELECT Movement.ID
             , Movement.StatusId
        INTO vbInventoryID
           , vbStatusID
        FROM Movement
        WHERE Movement.DescId = zc_Movement_Inventory()
          AND Movement.ParentId = inMovementId;

        IF vbStatusID = zc_Enum_Status_Complete()
        THEN
          PERFORM gpUnComplete_Movement_Inventory (vbInventoryID, inSession);
        END IF;

        IF vbStatusID <> zc_Enum_Status_Erased()
        THEN
          PERFORM gpSetErased_Movement_Inventory (vbInventoryID, inSession);
        END IF;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/