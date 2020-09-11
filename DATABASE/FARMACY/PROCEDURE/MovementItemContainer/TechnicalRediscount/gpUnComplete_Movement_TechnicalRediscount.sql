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
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbisRedCheck Boolean;
  DECLARE vbisAdjustment Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TechnicalRediscount());

    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)                  AS OperDate    
         , MLO_Unit.ObjectId                                      AS UnitId
         , COALESCE (MovementBoolean_RedCheck.ValueData, False)   AS isRedCheck
         , COALESCE (MovementBoolean_Adjustment.ValueData, False) AS isAdjustment
         , Movement.StatusID
    INTO vbOperDate
       , vbUnitId
       , vbisRedCheck
       , vbisAdjustment
       , vbStatusID
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                   ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                  AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
         LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                   ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                  AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
    WHERE Movement.Id = inMovementId;

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
                                 
    -- Прописываем в зарплату
    IF vbisRedCheck = FALSE AND vbisAdjustment = FALSE AND vbStatusID = zc_Enum_Status_Complete()
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, zfCalc_UserAdmin());
    END IF;

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