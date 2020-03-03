-- Function: lpComplete_Movement_TechnicalRediscount (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_TechnicalRediscount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TechnicalRediscount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
DECLARE
  vbUnitId Integer;
  vbOperDate TDateTime;
  vbInventoryID Integer;
  vbStatusID Integer;
  vbInvNumber TVarChar;
  vbInventoryNumber TVarChar;
  vbisRedCheck Boolean;
BEGIN


    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)  AS OperDate     -- при рассчете остатка добавил 1 день для условия >=
         , MLO_Unit.ObjectId                                        AS UnitId
         , Movement.InvNumber
         , COALESCE (MovementBoolean_RedCheck.ValueData, False) AS isRedCheck
    INTO vbOperDate
       , vbUnitId
       , vbInvNumber
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                   ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                  AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
    WHERE Movement.Id = inMovementId;

    IF date_part('DAY',  vbOperDate)::Integer <= 15
    THEN
        vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '14 DAY';
    ELSE
        vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
    END IF;

      -- Сохраняем остаток и цену
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), T1.Id, T1.Price)
         ,  lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), T1.Id, T1.Remains_Amount)
    FROM (  WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased  = FALSE)
               , tmpPrice AS (SELECT tmpMovementItem.GoodsId                                             AS GoodsId
                                   , ROUND(COALESCE (ObjectHistoryFloat_Price.ValueData, 0), 2)::TFloat  AS Price
                              FROM tmpMovementItem

                                   INNER JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ChildObjectId = tmpMovementItem.GoodsId
                                                        AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                       AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                       AND ObjectLink_Unit.ChildObjectId = vbUnitId

                                   -- получаем значения цены и НТЗ из истории значений на начало дня
                                   LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                           ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                          AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                          AND ObjectHistory_Price.EndDate >= vbOperDate
                                                          AND ObjectHistory_Price.StartDate < vbOperDate
                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                                ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                               AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (SELECT
                                    T0.GoodsId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                             FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id                                                          AS ContainerId
                                           , Container.ObjectId                                                    AS GoodsId
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM tmpMovementItem
                                            LEFT OUTER JOIN Container ON Container.ObjectId = tmpMovementItem.GoodsId
                                                                     AND Container.DescID = zc_Container_Count()
                                                                     AND Container.WhereObjectId = vbUnitId
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                    ) as T0

                                GROUP BY T0.GoodsId
                                HAVING SUM (T0.Amount) <> 0
                            )


            -- Результат
           SELECT
                MovementItem.Id                                           AS Id
              , COALESCE(tmpPrice.Price, 0)::TFloat                       AS Price
              , REMAINS.Amount :: TFloat                                  AS Remains_Amount
           FROM tmpMovementItem AS MovementItem

                LEFT JOIN REMAINS  ON REMAINS.GoodsId = MovementItem.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId) AS T1;

      -- Пересчитываем количество
    PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff(inMovementId);

    -- 5.1. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_TechnicalRediscount()
                               , inUserId     := inUserId
                                );

    -- 5.2 Формируем инвентаризацию
    IF EXISTS(SELECT *
              FROM Movement

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
              WHERE Movement.DescId = zc_Movement_Inventory()
                AND Movement.ParentId = inMovementId)
    THEN
        SELECT Movement.ID
             , Movement.StatusId
             , Movement.InvNumber
        INTO vbInventoryID
           , vbStatusID
           , vbInventoryNumber
        FROM Movement
        WHERE Movement.DescId = zc_Movement_Inventory()
          AND Movement.ParentId = inMovementId;

        IF vbStatusID = zc_Enum_Status_Complete()
        THEN
          RAISE EXCEPTION 'Ошибка. Инвентаризация проведена, обратитесь к системному администратору.';
        END IF;

        IF vbStatusID = zc_Enum_Status_Erased()
        THEN
          PERFORM gpUnComplete_Movement_Inventory (vbInventoryID, inUserId::TVarChar);
        END IF;

        -- сохранили <Документ>
        vbInventoryID := lpInsertUpdate_Movement (vbInventoryID, zc_Movement_Inventory(), vbInventoryNumber, vbOperDate, inMovementId);

        -- Востановили все удаленное в инвентаризации
        PERFORM gpMovementItem_Inventory_SetUnErased(MovementItem.ID, inUserId::TVarChar)
        FROM MovementItem
        WHERE MovementItem.MovementId = vbInventoryID
          AND MovementItem.isErased = True;

    ELSE
        vbInventoryNumber := CAST (NEXTVAL ('Movement_Inventory_seq') AS TVarChar);
        -- сохранили <Документ>
        vbInventoryID := lpInsertUpdate_Movement (0, zc_Movement_Inventory(), vbInventoryNumber, vbOperDate, inMovementId);
    END IF;


    -- сохранили связь с <Подразделение в документе>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), vbInventoryID, vbUnitId);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), vbInventoryID, 'Сформировано по технической инвентаризации '||vbInvNumber::TVarChar);

    -- Загрузили товары
    PERFORM lpInsertUpdate_MovementItem_Inventory(ioId := COALESCE(MIInventory.ID, 0)
                                                , inMovementId := vbInventoryID
                                                , inGoodsId := MovementItem.ObjectId
                                                , inAmount := COALESCE(MIFloat_Remains.ValueData, 0) + MovementItem.Amount
                                                , inPrice := COALESCE (MIFloat_Price.ValueData, 0)
                                                , inSumm := ROUND((COALESCE(MIFloat_Remains.ValueData, 0) + MovementItem.Amount) * COALESCE (MIFloat_Price.ValueData, 0), 2)
                                                , inComment := ''
                                                , inUserId := inUserId)
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
         LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                     ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                    AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
         LEFT JOIN MovementItem AS MIInventory ON MIInventory.MovementId = vbInventoryID
                                              AND MIInventory.ObjectId = MovementItem.ObjectId
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND COALESCE(MIInventory.Amount, 0) <> (COALESCE(MIFloat_Remains.ValueData, 0) + MovementItem.Amount)
      AND MovementItem.isErased   = FALSE;

     -- Удалили все лишнее в инвентаризации
    PERFORM gpMovementItem_Inventory_SetErased(MovementItem.ID, inUserId::TVarChar)
    FROM MovementItem
    WHERE MovementItem.MovementId = vbInventoryID
      AND MovementItem.ObjectId NOT IN (SELECT MovementItem.ObjectId FROM MovementItem
                                        WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE);

    -- Провели
    PERFORM gpComplete_Movement_Inventory (vbInventoryID, inUserId::TVarChar);

    -- Прописываем в зарплату
    IF vbisRedCheck = FALSE
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

--select * from gpUpdate_Status_TechnicalRediscount(inMovementId := 17785885 , inStatusCode := 2 ,  inSession := '3');