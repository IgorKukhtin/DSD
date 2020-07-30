-- Function: lpComplete_Movement_IncomeHouseholdInventory (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeHouseholdInventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbNDS TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbContainerId_Partner Integer;
BEGIN

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- DELETE FROM _tmpMIReport_insert;

     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

    -- Определить
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);
    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

   -- данные по "приход кол-во" - !!!дата аптеки!!!
   INSERT INTO _tmpItem (MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId, Price, AnalyzerId)
      WITH -- только приход
           tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                          , MovementItem.ObjectId                     AS HouseholdInventoryId
                          , MovementItem.Amount
                          , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                          , MIFloat_CountForPrice.ValueData           AS CountForPrice
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                      ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                     AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.Amount     > 0
                       AND MovementItem.IsErased   = FALSE
                    )

      -- результат
      SELECT zc_Movement_IncomeHouseholdInventory()
           , tmpMI.MovementItemId
           , tmpMI.HouseholdInventoryId AS ObjectId
           , tmpMI.Amount
           , Null
           , Null
           , vbOperDate
           , vbUnitId AS UnitId
           , tmpMI.CountForPrice
           , tmpMI.InvNumber     AS AnalyzerId
       FROM tmpMI
      ;

    -- Результат - проводки по кол-во "Остатки"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer
                                       )
         SELECT zc_MIContainer_CountHouseholdInventory()
              , zc_Movement_IncomeHouseholdInventory()
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId   := zc_Container_CountHouseholdInventory(), -- DescId Остатка
                          inParentId          := NULL               , -- Главный Container
                          inObjectId          := ObjectId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId        := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId      := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.UnitId,
                          inDescId_2          := zc_ContainerLinkObject_PartionHouseholdInventory(), -- DescId для 2-ой Аналитики
                          inObjectId_2        := lpInsertUpdate_Object_PartionHouseholdInventory(ioId               := 0,                    -- ключ объекта <>
                                                                                                 inInvNumber        := _tmpItem.AnalyzerId,  -- Инвентарный номер
                                                                                                 inUnitId           := _tmpItem.UnitId,      -- Подразделение
                                                                                                 inMovementItemId   := _tmpItem.MovementItemId,                          -- Ключ элемента прихода хозяйственного инвентаря
                                                                                                 inUserId           := inUserId)
                          )
              , AccountId
              , OperSumm
              , OperDate
              , ObjectId AS ObjectId_analyzer
              , vbUnitId AS WhereObjectId_analyzer
           FROM _tmpItem;

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeHouseholdInventory()
                                , inUserId     := inUserId
                                 );

     -- сохранили свойство <Дата корректировки>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (корректировка)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, inUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.07.20                                                      *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_IncomeHouseholdInventory (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
