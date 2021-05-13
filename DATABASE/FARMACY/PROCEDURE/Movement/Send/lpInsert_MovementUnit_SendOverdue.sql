  -- Function: lpInsert_MovementUnit_SendOverdue()

  DROP FUNCTION IF EXISTS lpInsert_MovementUnit_SendOverdue (Integer,Integer, TVarChar);

  CREATE OR REPLACE FUNCTION lpInsert_MovementUnit_SendOverdue(
      IN inUnitID              Integer  , -- Подразделение
      IN inUnitOverdueID       Integer  , -- Подразделение куда перемещать
      IN inSession             TVarChar   -- пользователь
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbUserId Integer;
     DECLARE vbMovementID Integer;
     DECLARE vbOperDate TDateTime;
     DECLARE vbInvNumber TVarChar;
  BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);
    
--    raise notice 'Обработка: % %', inUnitID, (SELECT Object.ValueData FROM Object WHERE Object.ID = inUnitID);

    vbOperDate := CURRENT_DATE  - ('' ||CASE WHEN date_part('isodow', CURRENT_DATE) = 1 THEN 6
                                             WHEN date_part('isodow', CURRENT_DATE) = 2 THEN 0
                                             ELSE date_part('isodow', CURRENT_DATE) - 2 END|| 'DAY ')::INTERVAL;

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

      -- Ищем предыдущее перемещение
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

              WHERE Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
      SELECT Movement.ID,  Movement.InvNumber
      INTO vbMovementID, vbInvNumber
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                        AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        AND MovementLinkObject_From.ObjectId = inUnitID

      WHERE Movement.DescId = zc_Movement_Send()
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
      ORDER BY Movement.OperDate DESC
      LIMIT 1;

       -- проверка
       IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = vbMovementID)
       THEN
         PERFORM lpUnComplete_Movement (vbMovementID, vbUserId);
       END IF;

       -- сохранили признак
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), vbMovementID, False);

         -- Востанавливаем удаленные записи
       PERFORM gpMovementItem_Send_SetUnerased (inMovementItemId        := MovementItem.Id,
                                                inSession               := inSession)
       FROM MovementItem
       WHERE MovementItem.MovementId = vbMovementID
         AND MovementItem.IsErased = TRUE;

         -- Обнуляем все записи Child
       UPDATE MovementItem set Amount = 0
       WHERE MovementItem.MovementId = vbMovementID
         AND MovementItem.DescId = zc_MI_Child();

    ELSE
      vbMovementID := 0;
    END IF;

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
                          AND Container.WhereObjectId = inUnitID
                          AND Container.Amount > 0
                          AND ObjectDate_ExpirationDate.ValueData <= vbOperDate
                          AND COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
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

                        WHERE Movement.Id = vbMovementID)

    INSERT INTO tmpContainerOverdue (ID, GoodsID, Amount, ExpirationDate, ChildID)
    SELECT Container.Id,
           Container.GoodsID,
           Container.Amount,

           Container.ExpirationDate,

           tmpMovement.ChildID
    FROM tmpContainer AS Container
         LEFT JOIN tmpMovement ON tmpMovement.ContainerId = Container.Id;

     -- Нечего создать выходим
    IF NOT EXISTS(SELECT 1 FROM tmpContainerOverdue)
    THEN
      RETURN;
    END IF;

    IF vbMovementID = 0
    THEN
       vbInvNumber := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar);
    ELSE
        -- Прописуем во временную таблицу ID мастера если есть
      UPDATE tmpContainerOverdue SET MasterID = MovementItem.ID
      FROM (SELECT MovementItem.Id
                 , MovementItem.ObjectId
            FROM MovementItem
            WHERE MovementItem.MovementId = vbMovementID
              AND MovementItem.DescId = zc_MI_Master()) AS MovementItem
      WHERE MovementItem.ObjectId = tmpContainerOverdue.GoodsId;    
    END IF;

      -- Создаем перемещение
    vbMovementID := gpInsertUpdate_Movement_Send(ioId               := vbMovementID,
                                                 inInvNumber        := vbInvNumber,
                                                 inOperDate         := vbOperDate,
                                                 inFromId           := inUnitID,
                                                 inToId             := inUnitOverdueID,
                                                 inComment          := '',
                                                 inChecked          := FALSE,
                                                 inisComplete       := FALSE,
                                                 inNumberSeats      := 0,
                                                 inDriverSunId      := 0,
                                                 inSession          := inSession
                                                 );

     -- сохранили связь с <Срок просрочен>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), vbMovementId, zc_Enum_PartionDateKind_0());


      -- Заполняем данные мастера
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := COALESCE(tmpContainerOverdue.MasterID, 0),
                                              inMovementId           := vbMovementID,
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
                                        inUnitId  := inUnitOverdueID,
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
                                                  AND ObjectLink_Unit.ChildObjectId in (inUnitID, inUnitOverdueID)
                                                  AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                   ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                  AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                        WHERE MovementItem.MovementId = vbMovementID
                          AND MovementItem.DescId = zc_MI_Master()
                       )

    SELECT MovementItem.ObjectId AS GoodsId
      , COALESCE (Object_Price_From.Price, 0) AS PriceFrom
      , COALESCE (Object_Price_To.Price, 0)   AS PriceTo

    FROM MovementItem

            LEFT JOIN tmpPrice AS Object_Price_From
                               ON Object_Price_From.GoodsId = MovementItem.ObjectId
                              AND Object_Price_From.UnitId = inUnitID
            LEFT JOIN tmpPrice AS Object_Price_To
                               ON Object_Price_To.GoodsId = MovementItem.ObjectId
                              AND Object_Price_To.UnitId = inUnitOverdueID


    WHERE MovementItem.MovementId = vbMovementID
      AND MovementItem.DescId = zc_MI_Master()
      AND COALESCE (Object_Price_To.Price, 0) = 0
      AND COALESCE (Object_Price_From.Price, 0) > 0) AS T1;

      -- Прописуем во временную таблицу ID мастера
    UPDATE tmpContainerOverdue SET MasterID = MovementItem.ID
    FROM (SELECT MovementItem.Id
               , MovementItem.ObjectId
          FROM MovementItem
          WHERE MovementItem.MovementId = vbMovementID
            AND MovementItem.DescId = zc_MI_Master()) AS MovementItem
    WHERE MovementItem.ObjectId = tmpContainerOverdue.GoodsId;

      -- Заполняем данные Child
    PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId            := COALESCE (tmpContainerOverdue.ChildID, 0),
                                                   inParentId      := tmpContainerOverdue.MasterID,
                                                   inMovementId    := vbMovementID,
                                                   inGoodsId       := tmpContainerOverdue.GoodsId,
                                                   inAmount        := tmpContainerOverdue.Amount,
                                                   inContainerId   := tmpContainerOverdue.Id,
                                                   inUserId        := vbUserId)
    FROM tmpContainerOverdue
    WHERE COALESCE(tmpContainerOverdue.MasterID, 0) <> 0;
    
      -- Удалили записи Child с 0
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := MovementItem.ID,
                                           inSession               := inSession)
    FROM MovementItem
    WHERE MovementItem.MovementId = vbMovementID
      AND MovementItem.DescId = zc_MI_Child()
      AND MovementItem.Amount = 0;
      
      -- Правим данные мастера
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := tmpContainerOverdue.MasterID,
                                              inMovementId           := vbMovementID,
                                              inGoodsId              := tmpContainerOverdue.GoodsId,
                                              inAmount               := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountManual         := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountStorage        := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inReasonDifferencesId  := 0,
                                              inCommentSendID        := 0,
                                              inUserId               := vbUserId)
    FROM tmpContainerOverdue
         INNER JOIN MovementItem ON MovementItem.MovementId = vbMovementID
                                AND MovementItem.ID = tmpContainerOverdue.MasterID
    GROUP BY tmpContainerOverdue.MasterID, tmpContainerOverdue.GoodsId, MovementItem.Amount
    HAVING COALESCE(SUM(tmpContainerOverdue.Amount), 0) <> MovementItem.Amount;
      

      -- Отмечаем удаленным проданое мастеры
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := MovementItemMaster.ID,
                                           inSession               := inSession)
    FROM MovementItem AS MovementItemMaster

         LEFT JOIN MovementItem AS MovementItemChild
                                ON MovementItemChild.MovementId = vbMovementID
                               AND MovementItemChild.ParentId = MovementItemMaster.Id
                               AND MovementItemChild.DescId = zc_MI_Child()
                               AND MovementItemChild.IsErased = FALSE

    WHERE MovementItemMaster.MovementId = vbMovementID
      AND MovementItemMaster.DescId = zc_MI_Master()
      AND MovementItemMaster.IsErased = FALSE
    GROUP BY MovementItemMaster.ID
    HAVING COALESCE(SUM(MovementItemChild.Amount), 0) = 0;

      -- Если есть содержимое отлаживаем
    IF EXISTS(SELECT MovementItem.Id
              FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE) 
    THEN
      -- сохранили признак отложен с проведением
      PERFORM gpUpdate_Movement_Send_Deferred (vbMovementID, TRUE, inSession);
    END IF;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.08.19                                                         *
 25.06.19                                                         *
 18.06.19                                                         *
   */

-- тест  SELECT * FROM lpInsert_MovementUnit_SendOverdue (12607257, 11299914, '3')
-- тест SELECT * FROM gpInsert_MovementUnit_SendOverdue (inSession:= '3')