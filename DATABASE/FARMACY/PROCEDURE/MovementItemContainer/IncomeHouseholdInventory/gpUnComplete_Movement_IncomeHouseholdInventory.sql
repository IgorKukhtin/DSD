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
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() AND
       EXISTS (WITH
                   tmpContainer AS (SELECT Container.ID

                                         , Container.ObjectId                     AS HouseholdInventoryId
                                         , Container.Amount                       AS Amount
                                         , Container.WhereobjectId                AS UnitID

                                         , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                                  FROM Container
                                  
                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                    
                                       LEFT JOIN Object AS Object_PHI ON Object_PHI.ID = ContainerLinkObject.ObjectId

                                       LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                             ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                            AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                  WHERE Container.DescId = zc_Container_CountHouseholdInventory()
                                    AND Container.WhereobjectId = vbUnitId
                                    AND Container.Amount > 0
                                 )
                                 
               SELECT Object_HouseholdInventory.ValueData, MIFloat_InvNumber.ValueData::Integer
               FROM MovementItem AS MI_Master
               
                    LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MI_Master.Id

                    LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                               AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                               
                    LEFT JOIN Object AS Object_HouseholdInventory
                                     ON Object_HouseholdInventory.ID = MI_Master.ObjectId

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount     > 0 
                 AND COALESCE (tmpContainer.Amount, 0) <> 1
                 AND MI_Master.IsErased   = FALSE)
    THEN
       WITH
           tmpContainer AS (SELECT Container.ID

                                 , Container.ObjectId                     AS HouseholdInventoryId
                                 , Container.Amount                       AS Amount
                                 , Container.WhereobjectId                AS UnitID

                                 , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                          FROM Container
                          
                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                            
                               LEFT JOIN Object AS Object_PHI ON Object_PHI.ID = ContainerLinkObject.ObjectId

                               LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                     ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                    AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                          WHERE Container.DescId = zc_Container_CountHouseholdInventory()
                            AND Container.WhereobjectId = vbUnitId
                            AND Container.Amount > 0
                         )
                         
       SELECT Object_HouseholdInventory.ValueData, MIFloat_InvNumber.ValueData::Integer
       INTO vbGoodsName, vbInvNumber
       FROM MovementItem AS MI_Master
       
            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MI_Master.Id

            LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                        ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                       AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                       
            LEFT JOIN Object AS Object_HouseholdInventory
                             ON Object_HouseholdInventory.ID = MI_Master.ObjectId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.Amount     > 0 
         AND COALESCE (tmpContainer.Amount, 0) <> 1
         AND MI_Master.IsErased   = FALSE;

       RAISE EXCEPTION 'Ошибка.Как минимум один хоз. инвентарь <%> <%> списан.', vbInvNumber, vbGoodsName;
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
-- SELECT * FROM gpUnComplete_Movement_IncomeHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())