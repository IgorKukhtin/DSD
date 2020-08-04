-- Function: gpUnComplete_Movement_IncomeHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_IncomeHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_UnComplete_IncomeHouseholdInventory());

    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

    -- Проверяем первые переводы
    IF EXISTS (WITH
                     tmpMIC AS (SELECT MIC.ContainerId
                               FROM MovementItemContainer AS MIC
                               WHERE MIC.MovementId = inMovementId
                                 AND MIC.DescId     = zc_MIContainer_CountHouseholdInventory()),
                     tmpContainer AS (SELECT Container.ID
                                           , Container.ObjectId                     AS HouseholdInventoryId
                                           , Container.Amount                       AS Amount
                                           , Container.WhereobjectId                AS UnitID

                                           , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                                    FROM tmpMIC 
                                                
                                         INNER JOIN Container ON Container.Id = tmpMIC.ContainerId
                                                             AND Container.DescId = zc_Container_CountHouseholdInventory()
                                                             AND Container.WhereobjectId = vbUnitId
                                                             AND Container.Amount < 1
                                                             
                                         INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()

                                   )
                                 
               SELECT 1 
               FROM tmpContainer

                    LEFT JOIN Object AS Object_PartionHouseholdInventory 
                                     ON Object_PartionHouseholdInventory.Id = tmpContainer.PartionHouseholdInventoryID

                    LEFT JOIN Object AS Object_HouseholdInventory
                                     ON Object_HouseholdInventory.ID = tmpContainer.HouseholdInventoryID
              )
    THEN
      WITH
           tmpMIC AS (SELECT MIC.ContainerId
                     FROM MovementItemContainer AS MIC
                     WHERE MIC.MovementId = inMovementId
                       AND MIC.DescId     = zc_MIContainer_CountHouseholdInventory()),
           tmpContainer AS (SELECT Container.ID
                                 , Container.ObjectId                     AS HouseholdInventoryId
                                 , Container.Amount                       AS Amount
                                 , Container.WhereobjectId                AS UnitID

                                 , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                          FROM tmpMIC 
                                      
                               INNER JOIN Container ON Container.Id = tmpMIC.ContainerId
                                                   AND Container.DescId = zc_Container_CountHouseholdInventory()
                                                   AND Container.WhereobjectId = vbUnitId
                                                   AND Container.Amount < 1
                                                   
                               INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()

                         )
                                 
       SELECT Object_HouseholdInventory.ValueData, Object_PartionHouseholdInventory.ObjectCode 
       INTO vbGoodsName, vbInvNumber
       FROM tmpContainer

            LEFT JOIN Object AS Object_PartionHouseholdInventory 
                             ON Object_PartionHouseholdInventory.Id = tmpContainer.PartionHouseholdInventoryID

            LEFT JOIN Object AS Object_HouseholdInventory
                             ON Object_HouseholdInventory.ID = tmpContainer.HouseholdInventoryID
       ;

      RAISE EXCEPTION 'Ошибка.Как минимум по одному хоз. инвентарю <%> <%> списание уже произведено.', vbInvNumber, vbGoodsName;
    END IF;

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    -- пересчитали Итоговые суммы по документу
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.07.20                                                       *
 09.07.20                                                       *
*/

-- тест
-- select * from gpUpdate_Status_IncomeHouseholdInventory(inMovementId := 19469516 , inStatusCode := 1 ,  inSession := '3');