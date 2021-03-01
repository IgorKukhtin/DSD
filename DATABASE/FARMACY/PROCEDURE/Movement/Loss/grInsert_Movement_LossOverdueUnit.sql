  -- Function: grInsert_Movement_LossOverdueUnit()

  DROP FUNCTION IF EXISTS grInsert_Movement_LossOverdueUnit (Integer, TVarChar);

  CREATE OR REPLACE FUNCTION grInsert_Movement_LossOverdueUnit(
      IN inUnitID              Integer  , -- Подразделение
     OUT outMovementID         Integer  , -- Номер списания
      IN inSession             TVarChar   -- пользователь
  )
  RETURNS Integer AS
  $BODY$
     DECLARE vbUserId Integer;
  BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);
    outMovementID := 0;

    IF NOT EXISTS(SELECT 1 FROM ObjectBoolean
                  WHERE ObjectBoolean.ObjectId = inUnitID
                    AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
                    AND ObjectBoolean.ValueData = TRUE)
    THEN
      RETURN;
    END IF;

      -- Отменяем отложку со всех перемещений
    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                 ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                AND MovementLinkObject_From.ObjectId = inUnitID

                   INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                              ON MovementBoolean_Deferred.MovementId = Movement.Id
                                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

              WHERE Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE)
    THEN
      PERFORM gpUpdate_Movement_Send_Deferred (Movement.ID, FALSE, inSession)
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                        AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        AND MovementLinkObject_From.ObjectId = inUnitID

           INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

      WHERE Movement.DescId = zc_Movement_Send()
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
        AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE;
    END IF;

      -- Временная таблица для товаров по переводу
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpcontaineroverdueloss'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdueLoss (
        GoodsId             Integer,
        ContainerId         Integer,
        Amount              TFloat
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpContainerOverdueLoss;
    END IF;

      -- Заполняем временную таблицу для товаров по переводу
    WITH
         -- просрочка
         tmpContainer AS (SELECT Container.Id                                         AS Id,
                                 Container.ObjectId                                   AS GoodsID,
                                 Container.Amount                                     AS Amount,
                                 Container.ParentId                                   AS ParentId,
                                 ContainerLinkObject.ObjectId                         AS PartionGoodsId,
                                 ObjectDate_ExpirationDate.ValueData                  AS ExpirationDate

                          FROM Container

                             LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                             LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                  ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                 AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                     ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                    AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = inUnitID
                            AND Container.Amount > 0
                            AND ObjectDate_ExpirationDate.ValueData < date_trunc('month', CURRENT_DATE - INTERVAL '85 DAY')
                            AND COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
         -- Содержимое документа

    INSERT INTO tmpContainerOverdueLoss (GoodsId, ContainerId, Amount)
    SELECT Container.GoodsId
         , Container.Id
         , Container.Amount
    FROM tmpContainer AS Container;

    IF EXISTS(SELECT 1 FROM  tmpContainerOverdueLoss)
    THEN
        -- сохранили <Документ>
        outMovementID := lpInsertUpdate_Movement_Loss (ioId                 := 0
                                                     , inInvNumber          := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                                     , inOperDate           := CURRENT_DATE
                                                     , inUnitId             := inUnitId
                                                     , inArticleLossId      := 13892113
                                                     , inComment            := ''
                                                     , inConfirmedMarketing := ''
                                                     , inUserId             := vbUserId
                                                      );

        PERFORM lpInsertUpdate_MovementItem_Loss (ioId                := 0
                                                , inMovementId        := outMovementID
                                                , inGoodsId           := tmpContainerOverdueLoss.GoodsId
                                                , inAmount            := Sum(tmpContainerOverdueLoss.Amount)
                                                , inUserId            := vbUserId)
        FROM tmpContainerOverdueLoss
        GROUP BY GoodsId
        HAVING Sum(tmpContainerOverdueLoss.Amount) > 0;

        -- Проводим списание
        PERFORM gpComplete_Movement_Loss (inMovementId:= outMovementID, inIsCurrentData:= True, inSession:= inSession);
    END IF;

    -- Пересоздаем перемещение сроков
    PERFORM lpInsert_MovementUnit_SendOverdue (inUnitID         := Object_Unit.Id
                                             , inUnitOverdueID  := ObjectLink_Unit_UnitOverdue.ChildObjectId
                                             , inSession        := inSession)
    FROM Object AS Object_Unit

         INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                AND ObjectBoolean_DividePartionDate.ValueData = True

         INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                               ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND Object_Unit.Id = inUnitID
      AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.03.20                                                         *
   */

-- тест SELECT * FROM grInsert_Movement_LossOverdueUnit (inUnitID := 3457773    , inSession:= '3')