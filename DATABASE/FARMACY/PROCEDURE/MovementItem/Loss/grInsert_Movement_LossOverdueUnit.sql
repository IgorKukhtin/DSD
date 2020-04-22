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

      -- Временная таблица для товаров по переводу
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpcontaineoverdue'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdue (
        GoodsId             Integer,
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


                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = inUnitID
                            AND Container.Amount > 0
                            AND ObjectDate_ExpirationDate.ValueData <= date_trunc('month', CURRENT_DATE) - INTERVAL '90 day')
         -- Содержимое документа

    INSERT INTO tmpContainerOverdue (GoodsId, ContainerId, Amount)
    SELECT Container.GoodsId
         , Container.Id
         , Container.Amount
    FROM tmpContainer AS Container;

--    raise notice 'Value 05: %', (select Count(*) from tmpContainerOverdue);

    -- сохранили <Документ>
    outMovementID := lpInsertUpdate_Movement_Loss (ioId               := 0
                                                 , inInvNumber        := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                                 , inOperDate         := CURRENT_DATE
                                                 , inUnitId           := inUnitId
                                                 , inArticleLossId    := 13892113
                                                 , inComment          := ''
                                                 , inUserId           := vbUserId
                                                  );

    PERFORM lpInsertUpdate_MovementItem_Loss (ioId                := 0
                                            , inMovementId        := outMovementID
                                            , inGoodsId           := tmpContainerOverdue.GoodsId
                                            , inAmount            := Sum(tmpContainerOverdue.Amount)
                                            , inUserId            := vbUserId)
    FROM tmpContainerOverdue
    GROUP BY GoodsId
    HAVING Sum(tmpContainerOverdue.Amount) > 0;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.03.20                                                         *
   */

-- тест SELECT * FROM grInsert_Movement_LossOverdueUnit (inUnitID := 377610   , inSession:= '3')