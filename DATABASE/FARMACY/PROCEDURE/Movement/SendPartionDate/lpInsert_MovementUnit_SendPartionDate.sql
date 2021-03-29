  -- Function: lpInsert_MovementUnit_SendPartionDate()

  DROP FUNCTION IF EXISTS lpInsert_MovementUnit_SendPartionDate (Integer,Integer, TVarChar);

  CREATE OR REPLACE FUNCTION lpInsert_MovementUnit_SendPartionDate(
      IN inUnitID              Integer  , -- Подразделение
      IN inMovementID          Integer  , -- Номер предыдущего документа
      IN inSession             TVarChar     -- пользователь
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbMovementID Integer;
     DECLARE vbDate180  TDateTime;
  BEGIN

      -- даты + 6 месяцев, + 1 месяц
     SELECT Date_6
     INTO vbDate180
     FROM lpSelect_PartionDateKind_SetDate ();

      IF NOT EXISTS(
            WITH
            -- просрочка
            tmpContainer_PartionDate AS (SELECT DISTINCT Container.ParentId AS ContainerId
                                         FROM Container
                                         WHERE Container.DescId        = zc_Container_CountPartionDate()
                                           AND Container.WhereObjectId = inUnitId 
                                        )
            -- остатки на начало
          , tmpContainer_all AS (SELECT Container.Id                                             AS ContainerId
                                      , Container.ObjectId                                       AS GoodsId
                                 FROM Container
                                      LEFT JOIN tmpContainer_PartionDate ON tmpContainer_PartionDate.ContainerId = Container.Id
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime
                                                              ON ObjectBoolean_Goods_NotTransferTime.ObjectId =  Container.ObjectId 
                                                             AND ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()
                                 WHERE Container.DescId        = zc_Container_Count()
                                   AND Container.WhereObjectId = inUnitId 
                                   AND Container.Amount > 0
                                   AND COALESCE (tmpContainer_PartionDate.ContainerId, 0) = 0
                                   AND COALESCE (ObjectBoolean_Goods_NotTransferTime.ValueData, False) = False
                                )
            -- остатки - нашли Срок годности
          , tmpContainer_term AS (SELECT tmp.ContainerId
                                       , MI_Income.MovementId                                       AS MovementId_Income
                                       , tmp.GoodsId
                                       , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate        --
                                  FROM tmpContainer_all AS tmp
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
                                                                  AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
       
                                     LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                       ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 )
            -- остатки - нашли Срок c перемещений
          , tmpContainer_In AS (SELECT tmp.ContainerId
                                       , tmp.MovementId_Income
                                       , tmp.GoodsId
                                       , tmp.ExpirationDate
                                       , MIC_Send.DescId                          AS MIC_DescId
                                       , MIC_Send.MovementDescId                  AS MIC_MovementDescId
                                       , MIC_Send.MovementItemId                  AS MIC_MovementItemId
                                  FROM tmpContainer_term AS tmp
                                       INNER JOIN MovementItemContainer AS MIC_Send
                                                                        ON MIC_Send.ContainerId = tmp.ContainerId
                                                                       AND MIC_Send.Amount > 0
                                 )
          , tmpContainer_Send AS (SELECT tmp.ContainerId
                                       , MAX(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))      AS ExpirationDateIn
                                  FROM tmpContainer_In AS tmp
                                       INNER JOIN MovementItemContainer AS MIC_Send
                                                                        ON MIC_Send.MovementItemId = tmp.MIC_MovementItemId
                                                                       AND MIC_Send.DescId = zc_Container_CountPartionDate()
                                                                       AND MIC_Send.Amount < 0
                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIC_Send.ContainerId
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                  WHERE tmp.MIC_DescId = zc_MIContainer_Count()
                                    AND tmp.MIC_MovementDescId = zc_Movement_Send()
                                  GROUP BY tmp.ContainerId
                                 )            -- остатки - все партии, если есть хоть один <= vbDate180
          , tmpContainer AS (SELECT tmpContainer_term.ContainerId
                                  , tmpContainer_term.MovementId_Income
                                  , tmpContainer_term.GoodsId
                                  , tmpContainer_term.ExpirationDate
                             FROM (SELECT DISTINCT tmpContainer_term.ContainerId
                                   FROM tmpContainer_term
                                   LEFT JOIN tmpContainer_Send ON tmpContainer_Send.ContainerId = tmpContainer_term.ContainerId
                                    -- !!!ограничили!!!
                                   WHERE COALESCE(tmpContainer_Send.ExpirationDateIn, tmpContainer_term.ExpirationDate) <= vbDate180
                                  ) AS tmpContainer
                                  LEFT JOIN tmpContainer_term        ON tmpContainer_term.ContainerId = tmpContainer.ContainerId
                            )

            SELECT 1
            FROM tmpContainer)
    THEN
      RETURN;
    END IF;

    SELECT gpInsertUpdate_Movement_SendPartionDate(ioId                := 0,
                                                   inInvNumber         := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar),
                                                   inOperDate          := CURRENT_DATE,
                                                   inUnitId            := inUnitID,
                                                   inChangePercent     := MovementFloat_ChangePercent.ValueData,
                                                   inChangePercentLess := MovementFloat_ChangePercentLess.ValueData,
                                                   inChangePercentMin  := MovementFloat_ChangePercentMin.ValueData,
                                                   inComment           := '',
                                                   inSession           := inSession
                                                   )
    INTO vbMovementID
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

    WHERE Movement.ID = inMovementID;

      -- Заполняем данные
    PERFORM gpInsert_MI_SendPartionDate (inMovementId  := vbMovementID,
                                         inUnitId      := inUnitID,
                                         inOperDate    := CURRENT_DATE,
                                         inSession     := inSession);
      -- Если есть содержимое проводим
    IF EXISTS(SELECT MovementItem.Id
              FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN
      PERFORM gpComplete_Movement_SendPartionDate(inMovementId  := vbMovementID,
                                                  inSession     := inSession);
    END IF;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.20                                                         *
 15.07.19                                                         * 
 18.06.19                                                         *
   */

  -- тест SELECT * FROM gpInsert_MovementUnit_SendPartionDate (inSession:= '3')    