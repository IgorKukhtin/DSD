-- Function: gpComplete_Movement_WriteOffHouseholdInventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_WriteOffHouseholdInventory  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WriteOffHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
  DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Complete_WriteOffHouseholdInventory());
           
    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

    -- проверка 
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Ошибка. Нет данных для проведения.';
    END IF;

    -- Проверяем первые переводы
    IF EXISTS (WITH
                   tmpMI AS (SELECT MI_Master.ObjectId AS PartionHouseholdInventoryID
                                  , MI_Master.Amount
                             FROM MovementItem AS MI_Master
                             WHERE MI_Master.MovementId = inMovementId
                               AND MI_Master.DescId     = zc_MI_Master()
                               AND MI_Master.Amount     > 0
                               AND MI_Master.IsErased   = FALSE),
                   tmpContainer AS (SELECT Container.ID
                                         , Container.ObjectId                     AS HouseholdInventoryId
                                         , Container.Amount                       AS Amount
                                         , Container.WhereobjectId                AS UnitID

                                         , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                                  FROM tmpMI 
                                              
                                       INNER JOIN ContainerLinkObject ON  ContainerLinkObject.ObjectId = tmpMI.PartionHouseholdInventoryID
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                                
                                       INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                           AND Container.DescId = zc_Container_CountHouseholdInventory()
                                                           AND Container.WhereobjectId = vbUnitId
                                                           AND Container.Amount > 0
                                             )
                                 
               SELECT 1 
               FROM tmpMI AS MI_Master

                    LEFT JOIN tmpContainer ON tmpContainer.PartionHouseholdInventoryID = MI_Master.PartionHouseholdInventoryID

               WHERE COALESCE (tmpContainer.Amount, 0) < MI_Master.Amount
              )
    THEN
      WITH
           tmpMI AS (SELECT MI_Master.ObjectId AS PartionHouseholdInventoryID
                          , MI_Master.Amount
                     FROM MovementItem AS MI_Master
                     WHERE MI_Master.MovementId = inMovementId
                       AND MI_Master.DescId     = zc_MI_Master()
                       AND MI_Master.Amount     > 0
                       AND MI_Master.IsErased   = FALSE),
           tmpContainer AS (SELECT Container.ID
                                 , Container.ObjectId                     AS HouseholdInventoryId
                                 , Container.Amount                       AS Amount
                                 , Container.WhereobjectId                AS UnitID

                                 , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                          FROM tmpMI 
                                              
                               INNER JOIN ContainerLinkObject ON  ContainerLinkObject.ObjectId = tmpMI.PartionHouseholdInventoryID
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                                
                               INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                   AND Container.DescId = zc_Container_CountHouseholdInventory()
                                                   AND Container.WhereobjectId = vbUnitId
                         )
                                 
       SELECT Object_HouseholdInventory.ValueData, Object_PartionHouseholdInventory.ObjectCode 
       INTO vbGoodsName, vbInvNumber
       FROM tmpMI AS MI_Master

            LEFT JOIN tmpContainer ON tmpContainer.PartionHouseholdInventoryID = MI_Master.PartionHouseholdInventoryID

            LEFT JOIN Object AS Object_PartionHouseholdInventory ON Object_PartionHouseholdInventory.Id = MI_Master.PartionHouseholdInventoryID

            LEFT JOIN Object AS Object_HouseholdInventory
                             ON Object_HouseholdInventory.ID = tmpContainer.HouseholdInventoryID

       WHERE COALESCE (tmpContainer.Amount, 0) < MI_Master.Amount;

      RAISE EXCEPTION 'Ошибка.Как минимум по одному хоз. инвентарю <%> <%> списание уже произведено.', vbInvNumber, vbGoodsName;
    END IF;
    
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm (inMovementId);
    -- собственно проводки
    PERFORM lpComplete_Movement_WriteOffHouseholdInventory (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
 */

-- тест
-- select * from gpUpdate_Status_WriteOffHouseholdInventory(inMovementId := 19480115  , inStatusCode := 2 ,  inSession := '3');