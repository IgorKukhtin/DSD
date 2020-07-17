 -- Function: lpInsertUpdate_MovementItemLinkContainer ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemLinkContainer (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkContainer(
    IN inMovementItemId    Integer  , -- ключ Строка документа
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- Пользователь
)
RETURNS Text
AS
$BODY$
   DECLARE vbMovementId        Integer; -- ключ Документа
   DECLARE vbStatusId          Integer ;
   DECLARE vbGoodsID           Integer ;
   DECLARE vbPartionDateKindID Integer ; -- Тип срок/не срок
   DECLARE vbAmount            TFloat ;
   DECLARE vbUnitId            Integer;

   DECLARE vbDate_0             TDateTime;
   DECLARE vbDate_1           TDateTime;
   DECLARE vbDate_3            TDateTime;
   DECLARE vbDate_6            TDateTime;

   DECLARE vbRemains           refcursor;
   DECLARE vbContainerId       Integer;
   DECLARE vbContainerAmount   TFloat;
   DECLARE vbMovChildId        Integer;
BEGIN

  outMessageText := '';

  -- Провкряем элемент по документу
  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION 'Документ не сохранен';
  END IF;

  SELECT Movement.Id, Movement.StatusId, MovementLinkObject_Unit.ObjectId,
         MovementItem.ObjectId, MI_PartionDateKind.ObjectId, MovementItem.Amount
  INTO vbMovementId, vbStatusId, vbUnitId,
         vbGoodsID, vbPartionDateKindID, vbAmount
  FROM MovementItem

       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

       LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                        ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                       AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()

  WHERE MovementItem.ID = inMovementItemId;

  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- Если мастер не сроковый то обнуляем все zc_MI_Child и выходим
  IF COALESCE (vbPartionDateKindID, 0) = 0
  THEN
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId)
    THEN
      UPDATE MovementItem SET isErased = True, Amount = 0
      WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId;
    END IF;

    RETURN;
  END IF;

  -- Если есть zc_MI_Child то проверяем товар и если распределено то выходим и нечиго не делаем
  IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId)
  THEN
    UPDATE MovementItem SET ObjectId = vbGoodsID WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                                   AND MovementItem.ParentId = inMovementItemId AND MovementItem.ObjectId <> vbGoodsID;
    IF (SELECT SUM(MovementItem.Amount)  FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                                             AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = FALSE) = vbAmount
    THEN
      RETURN;
    END IF;

    PERFORM lpSetErased_MovementItem(MovementItem.ID, inUserId)
    FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId;
  END IF;

  -- значения для разделения по срокам
  SELECT Date_6, Date_3, Date_1, Date_0
  INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
  FROM lpSelect_PartionDateKind_SetDate ();

  -- Прикрепление к контейнерам
  OPEN vbRemains FOR
  WITH  -- Остатки по срокам
       tmpPDContainer AS (SELECT Container.Id
                               , Container.Amount
                               , ContainerLinkObject.ObjectId  AS PartionGoodsId
                          FROM Container

                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.ObjectId = vbGoodsID
                            AND Container.Amount <> 0)
     , tmpPDGoodsRemains AS (SELECT Container.Id
                                  , Object_PartionDateKind.Id                                         AS PartionDateKindId
                                  , Container.Amount                                                  AS Amount
                                  , ObjectDate_ExpirationDate.ValueData                               AS MinExpirationDate
                             FROM tmpPDContainer AS Container

                                  LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                       ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                          ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5() 
                                                         
                                  LEFT OUTER JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id =
                                       CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                 COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE 
                                                                                                 THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1 THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3 THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6 THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                            ELSE zc_Enum_PartionDateKind_Good() END                                                    -- Востановлен с просрочки
                            )

    , tmpMov AS (
        SELECT Movement.Id
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                          AND MovementLinkObject_Unit.ObjectId = vbUnitId
        WHERE Movement.DescId = zc_Movement_Check()
          AND Movement.StatusId = zc_Enum_Status_UnComplete()
       )
  , RESERVE AS
      (
          SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
               , Sum(MovementItemChild.Amount)::TFloat       AS Amount
          FROM tmpMov
                       INNER JOIN MovementItem AS MovementItemMaster
                                               ON MovementItemMaster.MovementId = tmpMov.Id
                                              AND MovementItemMaster.DescId     = zc_MI_Master()
                                              AND MovementItemMaster.isErased   = FALSE

                       INNER JOIN MovementItem AS MovementItemChild
                                               ON MovementItemChild.MovementId = tmpMov.Id
                                              AND MovementItemChild.ParentId = MovementItemMaster.Id
                                              AND MovementItemChild.DescId     = zc_MI_Child()
                                              AND MovementItemChild.Amount     > 0
                                              AND MovementItemChild.isErased   = FALSE

                       LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                   ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                  AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
          GROUP BY MIFloat_ContainerId.ValueData
      )

  SELECT
         tmpPDGoodsRemains.ID
       , tmpPDGoodsRemains.Amount - COALESCE (RESERVE.Amount, 0) AS Amount
  FROM tmpPDGoodsRemains
       LEFT OUTER JOIN RESERVE ON RESERVE.ContainerId = tmpPDGoodsRemains.ID
  WHERE tmpPDGoodsRemains.PartionDateKindId = vbPartionDateKindId
    AND tmpPDGoodsRemains.Amount - COALESCE (RESERVE.Amount, 0) > 0
  ORDER BY tmpPDGoodsRemains.MinExpirationDate;

  LOOP
    FETCH vbRemains INTO vbContainerId, vbContainerAmount;
    IF NOT FOUND THEN EXIT; END IF;

    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                           AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = TRUE)
    THEN
      SELECT Min(MovementItem.ID)
      INTO vbMovChildId
      FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                          AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = TRUE;

      PERFORM lpSetUnErased_MovementItem(vbMovChildId, inUserId);
      vbMovChildId := lpInsertUpdate_MovementItem (vbMovChildId, zc_MI_Child(), vbGoodsID, vbMovementId,
                                                   CASE WHEN vbAmount > vbContainerAmount THEN vbContainerAmount ELSE vbAmount END, inMovementItemId);
    ELSE

      vbMovChildId := lpInsertUpdate_MovementItem (0, zc_MI_Child(), vbGoodsID, vbMovementId,
                                                   CASE WHEN vbAmount > vbContainerAmount THEN vbContainerAmount ELSE vbAmount END, inMovementItemId);
    END IF;

    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), vbMovChildId, vbContainerId);

    vbAmount := vbAmount - CASE WHEN vbAmount > vbContainerAmount THEN vbContainerAmount ELSE vbAmount END;

    IF vbAmount = 0 THEN EXIT; END IF;
  END LOOP;
  CLOSE vbRemains;

  IF vbAmount > 0
  THEN
    outMessageText:= 'Ошибка.Товара нет в наличии для прикрепления к пертии по сроку: ' || (SELECT OBJECT.ValueData FROM OBJECT WHERE ID = vbPartionDateKindId) ||
      ' товар ' || (SELECT OBJECT.ValueData FROM OBJECT WHERE ID = vbGoodsID) || ' нехватило ' || zfConvert_FloatToString (vbAmount);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 15.07.19                                                                   * 
 01.07.19                                                                   *
 03.06.19                                                                   *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := 129246402, inUserId := 3)
-- SELECT * FROM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := 129246398, inUserId := 3)