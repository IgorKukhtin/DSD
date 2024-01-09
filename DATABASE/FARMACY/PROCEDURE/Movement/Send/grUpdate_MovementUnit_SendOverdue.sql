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
     DECLARE vbUnitOverdueID Integer;
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
        Movement_To.ObjectId AS Unit_To,
        MovementLinkObject_PartionDateKind.ObjectId
    INTO
        vbOperDate,
        vbStatusId,
        vbUnitId,
        vbUnitOverdueID,
        vbPartionDateKindID
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
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

    IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
    THEN
      RAISE EXCEPTION 'Ошибка.Документ отложен, выполненние операции запрещено запрещено!';
    END IF;

      -- Временная таблица для товаров по переводу
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainerOverdue'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdue (
        ID integer,
        GoodsID integer,
        Amount TFloat,
        ExpirationDate TDateTime,
        MasterID integer,
        ChildID integer
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpContainerOverdue;
    END IF;

    -- Востанавливаем удаленные записи
    UPDATE MovementItem SET IsErased = False
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.IsErased = TRUE;

    -- Обнуляем все записи Child
    UPDATE MovementItem set Amount = 0
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Child();


      -- Заполняем временную таблицу для товаров по переводу
    WITH
         -- просрочка
         tmpContainer AS (SELECT Container.Id                                         AS Id,
                                 Container.ObjectId                                   AS GoodsID,
                                 Container.Amount                                     AS Amount,
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
                          AND Container.WhereObjectId = vbUnitId
                          AND Container.Amount > 0
                          AND ObjectDate_ExpirationDate.ValueData <= vbOperDate
                          /*AND COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE*/)
         -- Содержиться в старом перемещении
       , tmpMovement AS (SELECT MovementItemMaster.ID                   AS MasterID
                              , MovementItemChild.ID                    AS ChildID
                              , MovementItemMaster.ObjectID             AS ObjectID
                              , MIFloat_ContainerId.ValueData::Integer  AS ContainerId
                         FROM Movement

                              INNER JOIN MovementItem AS MovementItemMaster
                                                      ON MovementItemMaster.MovementId = Movement.Id
                                                     AND MovementItemMaster.DescId = zc_MI_Master()

                              LEFT JOIN MovementItem AS MovementItemChild
                                                     ON MovementItemChild.MovementId = Movement.Id
                                                    AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                    AND MovementItemChild.DescId = zc_MI_Child()

                              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                          ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                         AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                        WHERE Movement.Id = inMovementId)

    INSERT INTO tmpContainerOverdue (ID, GoodsID, Amount, ExpirationDate, ChildID)
    SELECT Container.Id,
           Container.GoodsID,
           Container.Amount,

           Container.ExpirationDate,

           tmpMovement.ChildID
    FROM tmpContainer AS Container
         LEFT JOIN tmpMovement ON tmpMovement.ContainerId = Container.Id;

     -- Нечего создать выходим
    IF EXISTS(SELECT 1 FROM tmpContainerOverdue)
    THEN

        -- Прописуем во временную таблицу ID мастера если есть
      UPDATE tmpContainerOverdue SET MasterID = MovementItem.ID
      FROM (SELECT MovementItem.Id
                 , MovementItem.ObjectId
            FROM MovementItem
            WHERE MovementItem.MovementId = inMovementID
              AND MovementItem.DescId = zc_MI_Master()) AS MovementItem
      WHERE MovementItem.ObjectId = tmpContainerOverdue.GoodsId;    

        -- Заполняем данные мастера
      PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := COALESCE(tmpContainerOverdue.MasterID, 0),
                                                inMovementId           := inMovementId,
                                                inGoodsId              := tmpContainerOverdue.GoodsId,
                                                inAmount               := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                                inAmountManual         := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                                inAmountStorage        := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                                inReasonDifferencesId  := 0,
                                                inCommentSendID        := 0,
                                                inUserId               := vbUserId)
      FROM tmpContainerOverdue
      GROUP BY tmpContainerOverdue.GoodsId, tmpContainerOverdue.MasterID
      ORDER BY tmpContainerOverdue.GoodsId;

        --если цена получателя = 0 заменяем ее на цену отвравителя и записываем в прайс
      PERFORM lpInsertUpdate_Object_Price(inGoodsId := GoodsId,
                                          inUnitId  := vbUnitOverdueID,
                                          inPrice   := PriceFrom,
                                          inDate    := CURRENT_DATE::TDateTime,
                                          inUserId  := vbUserId)
      FROM ( WITH
             tmpPrice AS (SELECT MovementItem.ObjectId     AS GoodsId
                               , ObjectLink_Unit.ChildObjectId  AS UnitId
                               , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                          FROM MovementItem
                               INNER JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ChildObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                               INNER JOIN ObjectLink AS ObjectLink_Unit
                                                     ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                    AND ObjectLink_Unit.ChildObjectId in (vbUnitId, vbUnitOverdueID)
                                                    AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                     ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                    AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Master()
                         )

      SELECT MovementItem.ObjectId AS GoodsId
        , COALESCE (Object_Price_From.Price, 0) AS PriceFrom
        , COALESCE (Object_Price_To.Price, 0)   AS PriceTo

      FROM MovementItem

              LEFT JOIN tmpPrice AS Object_Price_From
                                 ON Object_Price_From.GoodsId = MovementItem.ObjectId
                                AND Object_Price_From.UnitId = vbUnitId
              LEFT JOIN tmpPrice AS Object_Price_To
                                 ON Object_Price_To.GoodsId = MovementItem.ObjectId
                                AND Object_Price_To.UnitId = vbUnitOverdueID


      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND COALESCE (Object_Price_To.Price, 0) = 0
        AND COALESCE (Object_Price_From.Price, 0) > 0) AS T1;

        -- Прописуем во временную таблицу ID мастера
      UPDATE tmpContainerOverdue SET MasterID = MovementItem.ID
      FROM (SELECT MovementItem.Id
                 , MovementItem.ObjectId
            FROM MovementItem
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()) AS MovementItem
      WHERE MovementItem.ObjectId = tmpContainerOverdue.GoodsId;

        -- Заполняем данные Child
      PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId            := COALESCE (tmpContainerOverdue.ChildID, 0),
                                                     inParentId      := tmpContainerOverdue.MasterID,
                                                     inMovementId    := inMovementId,
                                                     inGoodsId       := tmpContainerOverdue.GoodsId,
                                                     inAmount        := tmpContainerOverdue.Amount,
                                                     inContainerId   := tmpContainerOverdue.Id,
                                                     inUserId        := vbUserId)
      FROM tmpContainerOverdue
      WHERE COALESCE(tmpContainerOverdue.MasterID, 0) <> 0;
      
    END IF;
    
      -- Удалили записи Child с 0
    UPDATE MovementItem SET IsErased = True
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Child()
      AND MovementItem.Amount = 0;
      
      -- Правим данные мастера
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := tmpContainerOverdue.MasterID,
                                              inMovementId           := inMovementId,
                                              inGoodsId              := tmpContainerOverdue.GoodsId,
                                              inAmount               := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountManual         := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountStorage        := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inReasonDifferencesId  := 0,
                                              inCommentSendID        := 0,
                                              inUserId               := vbUserId)
    FROM tmpContainerOverdue
         INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                AND MovementItem.ID = tmpContainerOverdue.MasterID
    GROUP BY tmpContainerOverdue.MasterID, tmpContainerOverdue.GoodsId, MovementItem.Amount
    HAVING COALESCE(SUM(tmpContainerOverdue.Amount), 0) <> MovementItem.Amount;
      

    -- Отмечаем удаленным проданое мастеры
    UPDATE MovementItem SET IsErased = True
    FROM (SELECT MovementItemMaster.ID
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
          HAVING COALESCE(SUM(MovementItemChild.Amount), 0) = 0) AS T1
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.Id = T1.Id
      AND MovementItem.DescId = zc_MI_Master();

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (inMovementID);
    
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    /*IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;*/
    
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.06.19                                                         *
   */

-- тест select * from grUpdate_MovementUnit_SendOverdue(inMovementID := 24847865 ,  inSession := '3');


select * from grUpdate_MovementUnit_SendOverdue(inMovementID := 33683587 ,  inSession := '3');