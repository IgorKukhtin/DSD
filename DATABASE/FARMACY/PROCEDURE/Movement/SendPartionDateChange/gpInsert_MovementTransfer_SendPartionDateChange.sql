-- Function: gpInsert_MovementTransfer_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpInsert_MovementTransfer_SendPartionDateChange (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransfer_SendPartionDateChange(
    IN inContainerID     Integer   , -- ID контейнера для изменения срока
    IN inExpirationDate  TDateTime , -- Новый срок
    IN inAmount          TFloat    , -- Количество
   OUT outMovementItemId Integer   , -- Созданная строка в перемещении
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbRemains TFloat;
   DECLARE vbExpirationDate TDateTime;
   DECLARE vbRetailId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);
  inExpirationDate := DATE_TRUNC ('DAY', inExpirationDate);

  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    in (zc_Container_Count(), zc_Container_CountPartionDate())
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
                           
  WHERE Container.DescId    in (zc_Container_Count(), zc_Container_CountPartionDate())
    AND Container.Id        = inContainerID;

  IF vbRemains < inAmount
  THEN
    RAISE EXCEPTION 'Ошибка. Количество на изменения срока <%> больше остатка <%>.', inAmount, vbRemains;
  END IF;

/*  IF vbExpirationDate > CURRENT_DATE
  THEN
    RAISE EXCEPTION 'Ошибка. Изменять срок можно только у просроченного товара.';
  END IF;

  IF inExpirationDate < CURRENT_DATE
  THEN
    RAISE EXCEPTION 'Ошибка. Изменять срок можно только на непросроченный.';
  END IF;
*/

  IF EXISTS(SELECT 1  FROM Movement

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            WHERE Movement.DescId = zc_Movement_SendPartionDateChange()
              AND Movement.StatusId = zc_Enum_Status_UnComplete()
              AND Movement.OperDate = CURRENT_DATE
              AND MovementLinkObject_Unit.ObjectId = vbUnitId)
  THEN
    SELECT MAX(Movement.Id)
    INTO vbMovementId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE Movement.DescId = zc_Movement_SendPartionDateChange()
      AND Movement.StatusId = zc_Enum_Status_UnComplete()
      AND Movement.OperDate = CURRENT_DATE
      AND MovementLinkObject_Unit.ObjectId = vbUnitId;
  ELSE
    vbMovementId :=  gpInsertUpdate_Movement_SendPartionDateChange(ioId               := 0,
                                                                   inInvNumber        := CAST (NEXTVAL ('Movement_SendPartionDateChange_seq') AS TVarChar),
                                                                   inOperDate         := CURRENT_DATE,
                                                                   inUnitId           := vbUnitId,
                                                                   inComment          := '',
                                                                   inSession          := inSession
                                                                   );
  END IF;
 
  outMovementItemId := gpInsertUpdate_MI_SendPartionDateChange(ioId                 := 0,                 -- Ключ объекта <Элемент документа>
                                                               inMovementId         := vbMovementId,      -- Ключ объекта <Документ>
                                                               inGoodsId            := vbGoodsId,         -- Товары
                                                               inAmount             := inAmount,          -- Количество
                                                               inNewExpirationDate  := inExpirationDate,  -- Новый срок
                                                               inContainerId        := inContainerID,     -- Контейнер
                                                               inSession            := inSession          -- сессия пользователя
                                                               );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.07.20                                                       *
*/

-- тест
-- select * from gpInsert_MovementTransfer_SendPartionDateChange(inContainerID := 21565365 , inExpirationDate := ('19.03.2021')::TDateTime , inAmount := 1 ,  inSession := '3');
