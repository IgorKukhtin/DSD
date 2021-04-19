 -- Function: lpComplete_Movement_SendPartionDateChange (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_SendPartionDateChange (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendPartionDateChange(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUnitId      Integer;
   DECLARE vbGoodsName   TVarChar;
   DECLARE vbAmount      TFloat;
   DECLARE vbContainerId Integer;

   DECLARE vbMovementId  Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbMovementPrewId Integer;
   DECLARE vbInvNumber   TVarChar;
BEGIN


    --определяем данные документа
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId
    INTO vbUnitId
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    -- Проверка
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Подразделение не установлено.';
    END IF;

    -- проверка - Остатки Мастер и Чайлд должны совпадать, если нет - то корректировали не правильно или задним числом съехал остаток
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. Нет данных для проведения.';
    END IF;

    -- Проверяем первые переводы
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Master

                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                    LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount > 0
                 AND MI_Master.Amount <> Container.Amount
                 AND MI_Master.IsErased   = FALSE
                 AND Container.DescId = zc_Container_Count()
              )
    THEN
       SELECT Object_Goods.ValueData, MI_Master.Amount, MIFloat_ContainerId.ValueData::Integer
       INTO vbGoodsName, vbAmount, vbContainerId
       FROM MovementItem AS MI_Master

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.ID = MI_Master.ObjectId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.Amount > 0
         AND MI_Master.Amount <> Container.Amount
         AND MI_Master.IsErased   = FALSE
         AND Container.DescId = zc_Container_Count();

       RAISE EXCEPTION 'Ошибка.Как минимум у одного товара <%> количество <%> контейнер <%>. Количество не равно остатку.', vbGoodsName, vbAmount, vbContainerId;
    END IF;

    -- Проверяем чтоб не больше остатка
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Master

                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                    LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount > 0
                 AND MI_Master.Amount > COALESCE(Container.Amount, 0)
                 AND MI_Master.IsErased   = FALSE
              )
    THEN
       SELECT Object_Goods.ValueData, MI_Master.Amount, MIFloat_ContainerId.ValueData::Integer
       INTO vbGoodsName, vbAmount, vbContainerId
       FROM MovementItem AS MI_Master

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.ID = MI_Master.ObjectId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.Amount > 0
         AND MI_Master.Amount > COALESCE(Container.Amount, 0)
         AND MI_Master.IsErased   = FALSE;

       RAISE EXCEPTION 'Ошибка.Как минимум у одного товара <%> количество <%> контейнер <%>. Больше остатка.', vbGoodsName, vbAmount, vbContainerId;
    END IF;

    -- Проверяем чтоб не было в отложенных перемещениях
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Master

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                                AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                    INNER JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
                                        AND Container.DescId = zc_Container_Count() 

                    INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                                    AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                    AND MovementItemContainer.MovementDescId = zc_Movement_Send()                     
                                                    AND MovementItemContainer.Amount < 0 
    
                    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                               ON MovementBoolean_Deferred.MovementId = MovementItemContainer.MovementId
                                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                              AND MovementBoolean_Deferred.ValueData = True

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount > 0
                 AND MI_Master.IsErased   = FALSE
              )
    THEN
      RAISE EXCEPTION 'Ошибка. Закупка отложена в перемещениях: %.', (SELECT STRING_AGG('Номер '||Movement.InvNumber||' дата '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy'), ', ') 
                                                                      FROM MovementItem AS MI_Master

                                                                           INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                                                        ON MIFloat_ContainerId.MovementItemId = MI_Master.Id
                                                                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                                                           INNER JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
                                                                                               AND Container.DescId = zc_Container_Count() 

                                                                           INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                                                                                           AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                                                                           AND MovementItemContainer.MovementDescId = zc_Movement_Send()                     
                                                                                                           AND MovementItemContainer.Amount < 0 
                                                            
                                                                           INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                                                      ON MovementBoolean_Deferred.MovementId = MovementItemContainer.MovementId
                                                                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                                                                     AND MovementBoolean_Deferred.ValueData = True

                                                                           LEFT JOIN Movement ON Movement.ID = MovementItemContainer.MovementID
                                                                      WHERE MI_Master.MovementId = inMovementId
                                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                                        AND MI_Master.Amount > 0
                                                                        AND MI_Master.IsErased   = FALSE);
    END IF;

    -- 5.2. Формируем документ изменеия сроков

    SELECT MAX(Movement.ID)
    INTO vbMovementPrewId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                   ON MovementBoolean_Transfer.MovementId = Movement.Id
                                  AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

    WHERE Movement.DescId = zc_Movement_SendPartionDate()
      AND Movement.StatusId = zc_Enum_Status_Complete()
      AND MovementLinkObject_Unit.ObjectId = vbUnitId
      AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False;

    IF COALESCE (vbMovementPrewId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка.Не найден первый Документ изменения срока';
    END IF;

    IF EXISTS(SELECT Movement.ID
              FROM Movement
              WHERE Movement.DescId = zc_Movement_SendPartionDate()
                AND Movement.ParentId = inMovementId)
    THEN
      SELECT Movement.ID, Movement.StatusId, Movement.InvNumber
      INTO vbMovementId, vbStatusId, vbInvNumber
      FROM Movement
      WHERE Movement.DescId = zc_Movement_SendPartionDate()
        AND Movement.ParentId = inMovementId;

      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
        RAISE EXCEPTION 'Ошибка.Документ изменения срока <%> проведен.', vbInvNumber;
      ELSEIF vbStatusId = zc_Enum_Status_Erased()
      THEN
        PERFORM gpUnComplete_Movement_SendPartionDate (vbMovementId, inUserId::TVarChar);
      ELSEIF COALESCE(vbStatusId, 0) <> zc_Enum_Status_UnComplete()
      THEN
        RAISE EXCEPTION 'Ошибка.Документ изменения срока <%> в неизвестном состоянии.', vbInvNumber;
      END IF;

    ELSE
      vbInvNumber := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar);
      vbMovementId := 0;
    END IF;

    SELECT lpInsertUpdate_Movement_SendPartionDate(ioId                := vbMovementId,
                                                  inInvNumber         := vbInvNumber,
                                                  inOperDate          := CURRENT_DATE,
                                                  inUnitId            := vbUnitId,
                                                  inChangePercent     := MovementFloat_ChangePercent.ValueData,
                                                  inChangePercentLess := MovementFloat_ChangePercentLess.ValueData,
                                                  inChangePercentMin  := MovementFloat_ChangePercentMin.ValueData,
                                                  inComment           := 'Сформирован по заявке '||(SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId),
                                                  inParentId          := inMovementId,
                                                  inUserId            := inUserId
                                                  )
    INTO vbMovementId
    FROM Movement

              LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                      ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                     AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

              LEFT JOIN MovementFloat AS MovementFloat_ChangePercentLess
                                      ON MovementFloat_ChangePercentLess.MovementId =  Movement.Id
                                     AND MovementFloat_ChangePercentLess.DescId = zc_MovementFloat_ChangePercentLess()

              LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                      ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                     AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

    WHERE Movement.Id = vbMovementPrewId;

    -- сохранили <Изменение срока партии>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Transfer(), vbMovementId, True);


      -- Востановили и обнулили записи если есть старые
    UPDATE MovementItem SET amount = 0, isErased = False
    WHERE MovementItem.MovementId = vbMovementID
      AND MovementItem.DescId = zc_MI_Master();

    -- Залили товары
    PERFORM gpInsertUpdate_MI_SendPartionDate_Master(ioId               := MI_SendPartionDate.ID, -- Ключ объекта <Элемент документа>
                                                     inMovementId       := vbMovementId,          -- Ключ объекта <Документ>
                                                     inGoodsId          := MovementItem.ObjectId, -- Товары
                                                     inAmount           := CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount ELSE MovementItem.Amount END,   -- Количество
                                                     inAmountRemains    := Container.Amount,      --
                                                     inChangePercent    := COALESCE(ObjectFloat_PartionGoods_Value.ValueData, 0),     -- % (срок от 1 мес до 3 мес)
                                                     inChangePercentLess:= COALESCE(ObjectFloat_PartionGoods_ValueLess.ValueData, 0), -- % (срок от 3 мес до 6 мес)
                                                     inChangePercentMin := COALESCE(ObjectFloat_PartionGoods_ValueMin.ValueData, 0),  -- % (срок меньше месяца)
                                                     inContainerId      := MIFloat_ContainerId.ValueData::Integer,                    -- Контейнер для изменения срока
                                                     inSession          := inUserId::TVarChar     -- сессия пользователя
                                                     )
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

         LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                    ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()

         LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData::Integer

         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIFloat_ContainerId.ValueData::Integer
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                               ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

         LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                               ON ObjectFloat_PartionGoods_Value.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

         LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                               ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()

         LEFT JOIN (SELECT MovementItem.id,  MIFloat_ContainerId.ValueData::Integer AS ContainerId
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                    WHERE MovementItem.MovementId = vbMovementID
                      AND MovementItem.DescId = zc_MI_Master()) AS MI_SendPartionDate
                                                                ON MI_SendPartionDate.ContainerId = MIFloat_ContainerId.ValueData::Integer

    WHERE MovementItem.MovementId = inMovementID
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.iserased = False
      AND MovementItem.Amount > 0;

    -- Прописали сроки
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), MI_Child.Id, MIDate_ExpirationDate.ValueData)
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

         LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                    ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()

         LEFT JOIN (SELECT MovementItem.id,  MIFloat_ContainerId.ValueData::Integer AS ContainerId
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                    WHERE MovementItem.MovementId = vbMovementID
                      AND MovementItem.DescId = zc_MI_Master()) AS MI_SendPartionDate
                                                                ON MI_SendPartionDate.ContainerId = MIFloat_ContainerId.ValueData::Integer
                                                                
         LEFT JOIN MovementItem AS MI_Child
                                ON MI_Child.ParentId = MI_SendPartionDate.ID
                               AND MI_Child.MovementId = vbMovementID
                               AND MI_Child.DescId = zc_MI_Child()   
                                

    WHERE MovementItem.MovementId = inMovementID
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.iserased = False
      AND MovementItem.Amount > 0
      AND COALESCE (MI_Child.Id, 0) > 0;

      -- Удалили записи которые уже ненужны
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := MovementItem.ID,
                                           inSession               := inUserId::TVarChar)
    FROM MovementItem
    WHERE MovementItem.MovementId = vbMovementID
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.Amount = 0;

    -- Проводим документ сроков
    PERFORM gpUpdate_Status_SendPartionDate(inMovementId := vbMovementId , inStatusCode := 2 ,  inSession := inUserId::TVarChar);

  --  RAISE EXCEPTION 'Ошибка. В разработке.';

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_SendPartionDateChange()
                               , inUserId     := inUserId
                                );

    -- пересчитываем сумму документа по приходным ценам
    PERFORM lpInsertUpdate_SendPartionDateChange_TotalSumm(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.07.20                                                       *
*/

-- тест
-- select * from gpUpdate_Status_SendPartionDateChange(inMovementId := 19386934 , inStatusCode := 2 ,  inSession := '3');
