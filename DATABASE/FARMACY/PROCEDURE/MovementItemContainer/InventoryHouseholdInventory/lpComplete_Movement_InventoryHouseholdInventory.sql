-- Function: lpComplete_Movement_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS lpComplete_Movement_InventoryHouseholdInventory (Integer, Integer);


CREATE OR REPLACE FUNCTION lpComplete_Movement_InventoryHouseholdInventory(
    IN inMovementItemId               Integer   , -- Ключ объекта <Документ>
    IN inUserId                       Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка. Нет определен элемент прихода.';     
     END IF;

     -- Определить
    SELECT MovementLinkObject.ObjectId, Movement.OperDate
    INTO vbUnitId, vbOperDate
    FROM MovementLinkObject
        JOIN Movement ON Movement.Id = MovementLinkObject.MovementId                          
    WHERE MovementLinkObject.MovementId = inMovementId 
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     
     -- А сюда товары
     WITH 
       tmpMI AS (SELECT MI_Master.ID
                      , MI_Master.ObjectId AS PartionHouseholdInventoryID
                      , MI_Master.Amount
                 FROM MovementItem AS MI_Master
                 WHERE MI_Master.MovementId = inMovementId
                   AND MI_Master.DescId     = zc_MI_Master()
                   AND MI_Master.IsErased   = FALSE),
       tmpContainer AS (SELECT Container.ID

                             , Container.ObjectId                     AS HouseholdInventoryId
                             , tmpMI.Amount - Container.Amount        AS Amount
                             , Container.WhereobjectId                AS UnitID

                             , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                             , tmpMI.ID                               AS MovementItemId
                      FROM tmpMI 
                                  
                           INNER JOIN ContainerLinkObject ON tmpMI.PartionHouseholdInventoryID = ContainerLinkObject.ObjectId
                                                        AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                    
                           INNER JOIN Container ON ContainerId = Container.Id 
                                               AND Container.DescId = zc_Container_CountHouseholdInventory()
                                               AND Container.WhereobjectId = vbUnitId
                      WHERE tmpMI.Amount <> Container.Amount
                     )

    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_CountHouseholdInventory()
              , zc_Movement_InventoryHouseholdInventory()  
              , inMovementId
              , tmpItem.MovementItemId
              , tmpItem.Id
              , Null
              , Amount
              , vbOperDate
           FROM tmpContainer AS tmpItem;

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_InventoryHouseholdInventory()
                                , inUserId     := inUserId
                                 );     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpComplete_Movement_InventoryHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
