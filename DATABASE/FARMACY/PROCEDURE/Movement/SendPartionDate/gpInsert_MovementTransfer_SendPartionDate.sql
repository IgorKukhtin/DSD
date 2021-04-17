-- Function: gpInsert_MovementTransfer_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MovementTransfer_SendPartionDate (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransfer_SendPartionDate(
    IN inContainerID    Integer   , -- ID контейнера для изменения срока
    IN inExpirationDate TDateTime , -- Новый срок
    IN inAmount         TFloat    , -- Количество
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMIMasterId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbRemains TFloat;
   DECLARE vbExpirationDate TDateTime;
   DECLARE vbRetailId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);
  inExpirationDate := DATE_TRUNC ('DAY', inExpirationDate);

  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    = zc_Container_CountPartionDate()
                  AND Container.Id        = inContainerID)
  THEN
    RAISE EXCEPTION 'Ошибка. Контейнер не найден.';
  END IF;

  SELECT Container.WhereObjectId, Container.ObjectId, Container.Amount, ObjectDate_ExpirationDate.ValueData, ObjectLink_Juridical_Retail.ChildObjectId
  INTO vbUnitId, vbGoodsId, vbRemains, vbExpirationDate, vbRetailId
  FROM Container

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

       LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           
  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.Id        = inContainerID;

  IF inSession::Integer NOT IN (3, 375661, 4183126, 8001630, 9560329, 8051421, 14080152 ) AND vbRetailId = 4
  THEN
      RAISE EXCEPTION 'Ошибка. Изменять срока звпрещено.';
  END IF;

  IF vbRemains < inAmount
  THEN
    RAISE EXCEPTION 'Ошибка. Количество на изменения срока <%> больше остатка <%>.', inAmount, vbRemains;
  END IF;

  IF vbExpirationDate > CURRENT_DATE
  THEN
    RAISE EXCEPTION 'Ошибка. Изменять срок можно только у просроченного товара.';
  END IF;

  IF inExpirationDate < CURRENT_DATE
  THEN
    RAISE EXCEPTION 'Ошибка. Изменять срок можно только на непросроченный.';
  END IF;

  IF NOT EXISTS(SELECT 1  FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                                        ON MovementBoolean_Transfer.MovementId = Movement.Id
                                                       AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

                         WHERE Movement.DescId = zc_Movement_SendPartionDate()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                           AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False)
  THEN
    RAISE EXCEPTION 'Ошибка. Предыдущий документ изменения срока не найден.';
  END IF;

  SELECT MAX(Movement.ID)
  INTO vbMovementId
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

  SELECT gpInsertUpdate_Movement_SendPartionDate(ioId               := 0,
                                                          inInvNumber         := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar),
                                                          inOperDate          := CURRENT_DATE,
                                                          inUnitId            := vbUnitId,
                                                          inChangePercent     := COALESCE(MovementFloat_ChangePercent.ValueData, 0),
                                                          inChangePercentLess := COALESCE(MovementFloat_ChangePercentLess.ValueData, 0),
                                                          inChangePercentMin  := COALESCE(MovementFloat_ChangePercentMin.ValueData, 0),
                                                          inComment           := '',
                                                          inSession           := inSession
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

  WHERE Movement.Id = vbMovementId;

  -- сохранили <Изменение срока партии>
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Transfer(), vbMovementId, True);

  SELECT gpInsertUpdate_MI_SendPartionDate_Master(ioId               := 0,            -- Ключ объекта <Элемент документа>
                                                  inMovementId       := vbMovementId, -- Ключ объекта <Документ>
                                                  inGoodsId          := vbGoodsId, -- Товары
                                                  inAmount           := inAmount, -- Количество
                                                  inAmountRemains    := vbRemains, --
                                                  inChangePercent    := COALESCE(ObjectFloat_PartionGoods_Value.ValueData, 0),     -- % (срок от 1 мес до 3 мес)
                                                  inChangePercentLess:= COALESCE(ObjectFloat_PartionGoods_ValueLess.ValueData, 0), -- % (срок от 3 мес до 6 мес)
                                                  inChangePercentMin := COALESCE(ObjectFloat_PartionGoods_ValueMin.ValueData, 0),  -- % (срок меньше месяца)
                                                  inContainerId      := inContainerID, -- Контейнер для изменения срока
                                                  inSession          := inSession    -- сессия пользователя
                                                  )
  INTO vbMIMasterId
  FROM Container

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                             ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                             ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                             ON ObjectFloat_PartionGoods_Value.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.Id        = inContainerID;

  -- сохранили <Новый срок>
  PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), MovementItem.Id, inExpirationDate)
  FROM MovementItem
  WHERE MovementItem.MovementId = vbMovementId
    AND MovementItem.ParentId = vbMIMasterId
    AND MovementItem.DescId = zc_MI_Child()
    AND MovementItem.isErased = FALSE;

  PERFORM gpUpdate_Status_SendPartionDate(inMovementId := vbMovementId , inStatusCode := 2 ,  inSession := inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.20                                                       *
 26.06.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsert_MovementTransfer_SendPartionDate (inContainerID := 10016974, inExpirationDate := '01.01.2020', inAmount := 1,  inSession:= '3')       