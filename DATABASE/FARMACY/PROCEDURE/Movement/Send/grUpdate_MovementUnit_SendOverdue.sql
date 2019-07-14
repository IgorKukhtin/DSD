  -- Function: grUpdate_MovementUnit_SendOverdue()

  DROP FUNCTION IF EXISTS grUpdate_MovementUnit_SendOverdue (Integer, TVarChar);

  CREATE OR REPLACE FUNCTION grUpdate_MovementUnit_SendOverdue(
      IN inMovementID          Integer  , -- Подразделение
      IN inSession             TVarChar   -- пользователь
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbUserId Integer;
     DECLARE vbUnitId Integer;
     DECLARE vbStatusId Integer;
     DECLARE vbOperDate TDateTime;
     DECLARE vbPartionDateKindID Integer;
  BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId)
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не найден.';
    END IF;

      -- Получаем параметры
    SELECT
        Movement.OperDate,
        Movement.StatusId,
        Movement_From.ObjectId AS Unit_From,
        MovementLinkObject_PartionDateKind.ObjectId
    INTO
        vbOperDate,
        vbStatusId,
        vbUnitId,
        vbPartionDateKindID
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
    WHERE Movement.Id = inMovementId;

    IF COALESCE(vbPartionDateKindID, 0) <> zc_Enum_PartionDateKind_0()
    THEN
      RAISE EXCEPTION 'Допускаеться запускать только для документов перемещения просроченного товара.';
    END IF;

    -- Проверяем статус
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      RAISE EXCEPTION 'Допускаеться запускать только для распроведенных документов.';
    END IF;

      -- Временная таблица для товаров по переводу
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpcontaineoverdue'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdue (
        GoodsId             Integer,
        MIMasterID          Integer,
        MIChildId           Integer,
        ContainerId         Integer,
        Amount              TFloat
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpContainerOverdue;
    END IF;

      -- Заполняем временную таблицу для товаров по переводу
    WITH
         -- просрочка
         tmpContainer AS (SELECT Container.Id                                         AS Id,
                                 Container.ObjectId                                   AS GoodsID,
                                 Container.Amount                                     AS Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = vbUnitID
                            AND Container.Amount > 0)
         -- Содержимое документа
       , tmpMovement AS (SELECT
                                MovementItemMaster.ID                   AS MIMasterID
                              , MovementItemMaster.ObjectId             AS GoodsId
                              , MovementItemChild.ID                    AS MIChildId
                              , MIFloat_ContainerId.ValueData::Integer  AS ContainerId
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                        AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                           AND MovementLinkObject_From.ObjectId = vbUnitID

                              INNER JOIN MovementItem AS MovementItemMaster
                                                      ON MovementItemMaster.MovementId = Movement.Id
                                                     AND MovementItemMaster.DescId = zc_MI_Master()
                                                     AND MovementItemMaster.IsErased = FALSE

                              INNER JOIN MovementItem AS MovementItemChild
                                                      ON MovementItemChild.MovementId = Movement.Id
                                                     AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                     AND MovementItemChild.DescId = zc_MI_Child()
                                                     AND MovementItemChild.IsErased = FALSE

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                        WHERE Movement.Id = inMovementId)

    INSERT INTO tmpContainerOverdue (GoodsId, MIMasterID, MIChildId, ContainerId, Amount)
    SELECT Movement.GoodsId
         , Movement.MIMasterID
         , Movement.MIChildId
         , Movement.ContainerId
         , Container.Amount

    FROM tmpMovement AS Movement
         LEFT JOIN tmpContainer AS Container ON Movement.ContainerId = Container.Id
                                            AND Movement.GoodsId = Container.GoodsId;


      -- Правим данные мастера
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := tmpContainerOverdue.MIMasterID,
                                              inMovementId           := inMovementID,
                                              inGoodsId              := tmpContainerOverdue.GoodsId,
                                              inAmount               := SUM(tmpContainerOverdue.Amount)::TFloat,
                                              inAmountManual         := SUM(tmpContainerOverdue.Amount)::TFloat,
                                              inAmountStorage        := SUM(tmpContainerOverdue.Amount)::TFloat,
                                              inReasonDifferencesId  := 0,
                                              inUserId               := vbUserId)
    FROM tmpContainerOverdue
    WHERE COALESCE(tmpContainerOverdue.Amount, 0) > 0
    GROUP BY tmpContainerOverdue.MIMasterID, tmpContainerOverdue.GoodsId
    HAVING COALESCE(SUM(tmpContainerOverdue.Amount)) > 0;

      -- Правим данные Child
    PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId            := tmpContainerOverdue.MIChildId,
                                                   inParentId      := tmpContainerOverdue.MIMasterID,
                                                   inMovementId    := inMovementID,
                                                   inGoodsId       := tmpContainerOverdue.GoodsId,
                                                   inAmount        := tmpContainerOverdue.Amount,
                                                   inContainerId   := tmpContainerOverdue.ContainerId,
                                                   inUserId        := vbUserId)
    FROM tmpContainerOverdue
    WHERE COALESCE(tmpContainerOverdue.Amount, 0) > 0;

      -- Отмечаем удаленным проданое Child
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := tmpContainerOverdue.MIChildId,
                                           inSession               := inSession)
    FROM tmpContainerOverdue
    WHERE COALESCE(tmpContainerOverdue.Amount, 0) <= 0;

      -- Отмечаем удаленным проданое мастеры
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := MovementItemMaster.ID,
                                           inSession               := inSession)
    FROM MovementItem AS MovementItemMaster

         LEFT JOIN MovementItem AS MovementItemChild
                                ON MovementItemChild.MovementId = inMovementId
                               AND MovementItemChild.ParentId = MovementItemMaster.Id
                               AND MovementItemChild.DescId = zc_MI_Child()
                               AND MovementItemChild.IsErased = FALSE

    WHERE MovementItemMaster.MovementId = inMovementId
      AND MovementItemMaster.DescId = zc_MI_Master()
      AND MovementItemMaster.IsErased = FALSE
    GROUP BY MovementItemMaster.ID
    HAVING COALESCE(SUM(MovementItemChild.Amount), 0) = 0;


/*      -- Если есть содержимое проводим
    IF EXISTS(SELECT MovementItem.Id
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN
      -- сохранили признак отложен с проведением
      PERFORM gpUpdate_Movement_Send_Deferred (inMovementID, TRUE, inSession);
    END IF;
*/
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.06.19                                                         *
   */

  -- тест SELECT * FROM grUpdate_MovementUnit_SendOverdue (inMovementID := 7784783  , inSession:= '3')