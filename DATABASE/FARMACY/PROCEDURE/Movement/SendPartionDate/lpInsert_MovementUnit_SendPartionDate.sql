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
     DECLARE vbMonth_6  TFloat;
     DECLARE vbDay_6  Integer;
  BEGIN

/*      vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                    FROM Object  AS Object_PartionDateKind
                         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

      -- даты + 6 месяцев, + 1 месяц
      vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL; */

      vbDay_6 := (SELECT ObjectFloat_Day.ValueData::Integer
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                             ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

      -- даты + 6 месяцев, + 1 месяц
      vbDate180 := CURRENT_DATE + (vbDay_6||' DAY' ) ::INTERVAL;


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
                                 WHERE Container.DescId        = zc_Container_Count()
                                   AND Container.WhereObjectId = inUnitId 
                                   AND Container.Amount > 0
                                   AND COALESCE (tmpContainer_PartionDate.ContainerId, 0) = 0
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
            -- остатки - все партии, если есть хоть один <= vbDate180
          , tmpContainer AS (SELECT tmpContainer_term.ContainerId
                                  , tmpContainer_term.MovementId_Income
                                  , tmpContainer_term.GoodsId
                                  , tmpContainer_term.ExpirationDate
                             FROM (SELECT DISTINCT tmpContainer_term.ContainerId
                                   FROM tmpContainer_term
                                   -- !!!ограничили!!!
                                   WHERE tmpContainer_term.ExpirationDate <= vbDate180
                                  ) AS tmpContainer
                                  LEFT JOIN tmpContainer_term        ON tmpContainer_term.ContainerId = tmpContainer.ContainerId
                            )
            SELECT 1
            FROM tmpContainer)
    THEN
      RETURN;
    END IF;


    SELECT gpInsertUpdate_Movement_SendPartionDate(ioId               := 0,
                                                   inInvNumber        := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar),
                                                   inOperDate         := CURRENT_DATE,
                                                   inUnitId           := inUnitID,
                                                   inChangePercent    := MovementFloat_ChangePercent.ValueData,
                                                   inChangePercentMin := MovementFloat_ChangePercentMin.ValueData,
                                                   inComment          := '',
                                                   inSession          := inSession
                                                   )
    INTO vbMovementID
    FROM Movement
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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
 15.07.19                                                         * 
 18.06.19                                                         *
   */

  -- тест
--