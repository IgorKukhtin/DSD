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
  vbisAdjustment Boolean;
  vbComment TVarChar;
  vbCommentTR TVarChar;
  vbAmountIn TFloat;
  vbAmountOut TFloat;
BEGIN

    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)  AS OperDate     -- при рассчете остатка добавил 1 день для условия >=
         , MLO_Unit.ObjectId                                      AS UnitId
         , Movement.InvNumber
         , COALESCE (MovementBoolean_RedCheck.ValueData, False)   AS isRedCheck
         , COALESCE (MovementBoolean_Adjustment.ValueData, False) AS isAdjustment
         , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
    INTO vbOperDate
       , vbUnitId
       , vbInvNumber
       , vbisRedCheck
       , vbisAdjustment
       , vbComment
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                   ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                  AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
         LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                   ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                  AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
         LEFT JOIN MovementString AS MovementString_Comment
                                  ON MovementString_Comment.MovementId = Movement.Id
                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()
    WHERE Movement.Id = inMovementId;

    IF vbComment = ''
    THEN
        RAISE EXCEPTION 'Ошибка. Не заполнено примечание.';
    END IF;
	
	CREATE TEMP TABLE tmpMovementItem ON COMMIT DROP AS
	   (SELECT *
		FROM MovementItem

		WHERE MovementItem.MovementId = inMovementId
		  AND MovementItem.DescId     = zc_MI_Master()
		  AND MovementItem.isErased   = FALSE);

    ANALYSE tmpMovementItem;

      -- Контроль заполнене пояснений
    SELECT Object_CommentTR.ValueData||COALESCE(' с пояснением '||MIString_Explanation.ValueData, '') AS CommentTR
    INTO vbCommentTR
    FROM tmpMovementItem AS MovementItem

         INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                           ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
         INNER JOIN Object AS Object_CommentTR
                           ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

         INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Explanation
                                  ON ObjectBoolean_CommentTR_Explanation.ObjectId = Object_CommentTR.Id
                                 AND ObjectBoolean_CommentTR_Explanation.DescId = zc_ObjectBoolean_CommentTR_Explanation()
                                 AND ObjectBoolean_CommentTR_Explanation.ValueData = TRUE

         LEFT JOIN MovementItemString AS MIString_Explanation
                                      ON MIString_Explanation.MovementItemId = MovementItem.Id
                                     AND MIString_Explanation.DescId = zc_MIString_Explanation()

    WHERE COALESCE(MIString_Explanation.ValueData, '') = '';

    IF (COALESCE(vbCommentTR,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более комментарию не заполнено пояснение.', vbCommentTR;
    END IF;

      -- Контроль пересортов
    SELECT Object_CommentTR.ValueData||COALESCE(' с пояснением '||MIString_Explanation.ValueData, '') AS CommentTR
    INTO vbCommentTR
    FROM tmpMovementItem AS MovementItem

         LEFT JOIN MovementItemString AS MIString_Explanation
                                      ON MIString_Explanation.MovementItemId = MovementItem.Id
                                     AND MIString_Explanation.DescId = zc_MIString_Explanation()

         INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                           ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
         INNER JOIN Object AS Object_CommentTR
                           ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

         INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Resort
                                  ON ObjectBoolean_CommentTR_Resort.ObjectId = Object_CommentTR.Id
                                 AND ObjectBoolean_CommentTR_Resort.DescId = zc_ObjectBoolean_CommentTR_Resort()
                                 AND ObjectBoolean_CommentTR_Resort.ValueData = TRUE

    GROUP BY Object_CommentTR.ValueData
           , MIString_Explanation.ValueData
    HAVING COUNT(MovementItem.Amount) = 1;

    IF (COALESCE(vbCommentTR,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более комментарию кол-во пересортов равно 1.', vbCommentTR;
    END IF;

      -- Сохраняем остаток и цену
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), T1.Id, COALESCE(T1.Price, 0))
         ,  lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), T1.Id, COALESCE(T1.Remains_Amount, 0))
    FROM (  WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased  = FALSE)
               , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId)
                 -- Текущий остаток
               , REMAINS AS (SELECT Container.ObjectId                                                    AS GoodsId
                                  , SUM (Container.Amount)                                                AS Amount
                             FROM (SELECT Container.Id   
                                        , Container.ObjectId   
                                        , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0)  AS Amount
                                   FROM (SELECT DISTINCT tmpMovementItem.GoodsId FROM tmpMovementItem) AS  tmpMovementItem
                                        LEFT OUTER JOIN Container ON Container.ObjectId = tmpMovementItem.GoodsId
                                                                 AND Container.DescID = zc_Container_Count()
                                                                 AND Container.WhereObjectId = vbUnitId
                                                                 AND Container.Amount <> 0
                                        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                             AND MovementItemContainer.Operdate >= vbOperDate + INTERVAL '1 DAY'
                                   GROUP BY Container.Id, Container.ObjectId) AS Container                                                                                                                                           
                             GROUP BY Container.ObjectId
                             HAVING SUM (Container.Amount) <> 0
                            )


            -- Результат
           SELECT
                MovementItem.Id                                           AS Id
              , COALESCE(tmpPrice.Price, 0)::TFloat                       AS Price
              , COALESCE(REMAINS.Amount, 0):: TFloat                      AS Remains_Amount
           FROM tmpMovementItem AS MovementItem

                LEFT JOIN REMAINS  ON REMAINS.GoodsId = MovementItem.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId) AS T1;

      -- Контроль остатка
    SELECT Object_Goods.ValueData                                                 AS CommentTR
         , COALESCE (Sum(MovementItem.Amount), 0)                                 AS Amount
         , COALESCE (Max(MIFloat_Remains.ValueData), 0)                           AS DifferenceSum
    INTO vbCommentTR, vbAmountIn, vbAmountOut
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                     ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                    AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

         INNER JOIN Object AS Object_Goods
                           ON Object_Goods.ID = MovementItem.ObjectId

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
    GROUP BY Object_Goods.ValueData 
    HAVING (COALESCE (Sum(MovementItem.Amount), 0) + COALESCE (Max(MIFloat_Remains.ValueData), 0)) < 0;

    IF (COALESCE(vbCommentTR,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более товаров недостачи <%> больше остаток <%>.', vbCommentTR, vbAmountIn, vbAmountOut;
    END IF;

/*      -- Контроль по сумме
    SELECT Object_CommentTR.ValueData                                                        AS CommentTR
         , Abs(SUM(MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0)))             AS Amount
         , COALESCE (ObjectFloat_DifferenceSum.ValueData, 0)                                 AS DifferenceSum
    INTO vbCommentTR, vbAmountIn, vbAmountOut
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

         INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                           ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
         INNER JOIN Object AS Object_CommentTR
                           ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

         INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_DifferenceSum
                                  ON ObjectBoolean_CommentTR_DifferenceSum.ObjectId = Object_CommentTR.Id
                                 AND ObjectBoolean_CommentTR_DifferenceSum.DescId = zc_ObjectBoolean_CommentTR_DifferenceSum()
                                 AND ObjectBoolean_CommentTR_DifferenceSum.ValueData = TRUE

         LEFT JOIN ObjectFloat AS ObjectFloat_DifferenceSum
                               ON ObjectFloat_DifferenceSum.ObjectId = Object_CommentTR.Id
                              AND ObjectFloat_DifferenceSum.DescId = zc_ObjectFloat_CommentTR_DifferenceSum()

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
    GROUP BY Object_CommentTR.ValueData
           , COALESCE (ObjectFloat_DifferenceSum.ValueData, 0)
    HAVING (Abs(SUM(MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0))) - COALESCE (ObjectFloat_DifferenceSum.ValueData, 0)) > 0;

    IF (COALESCE(vbCommentTR,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более комментарию разница суммы <%> превышает допустимую сумму <%>.', vbCommentTR, vbAmountIn, vbAmountOut;
    END IF;
*/
 
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
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), vbInventoryID, 'Сформировано по техническому переучету '||vbInvNumber::TVarChar);

    -- Загрузили товары
    PERFORM lpInsertUpdate_MovementItem_Inventory(ioId := COALESCE(MIInventory.ID, 0)
                                                , inMovementId := vbInventoryID
                                                , inGoodsId := MovementItem.ObjectId
                                                , inAmount := COALESCE(Max(MIFloat_Remains.ValueData), 0) + Sum(MovementItem.Amount)
                                                , inPrice := COALESCE (Max(MIFloat_Price.ValueData), 0)
                                                , inSumm := ROUND((COALESCE(Max(MIFloat_Remains.ValueData), 0) + Sum(MovementItem.Amount)) * COALESCE (Max(MIFloat_Price.ValueData), 0), 2)
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
         LEFT JOIN MovementItemFloat AS MIFloat_PriceInventory
                                     ON MIFloat_PriceInventory.MovementItemId = MIInventory.Id
                                    AND MIFloat_PriceInventory.DescId = zc_MIFloat_Price()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
    GROUP BY MovementItem.ObjectId, MIInventory.ID
    HAVING COALESCE(Max(MIInventory.Amount), 0) <> (COALESCE(Max(MIFloat_Remains.ValueData), 0) + Sum(MovementItem.Amount)) 
        OR COALESCE (Max(MIFloat_Price.ValueData), 0) <> COALESCE (Max(MIFloat_PriceInventory.ValueData), 0)
        OR Max(MIInventory.Amount) IS NULL;

     -- Удалили все лишнее в инвентаризации
    PERFORM gpMovementItem_Inventory_SetErased(MovementItem.ID, inUserId::TVarChar)
    FROM MovementItem
    WHERE MovementItem.MovementId = vbInventoryID
      AND MovementItem.ObjectId NOT IN (SELECT MovementItem.ObjectId FROM MovementItem
                                        WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE);

--    RAISE EXCEPTION 'Прошло.';

    -- Провели
    PERFORM gpComplete_Movement_Inventory (vbInventoryID, inUserId::TVarChar);

    -- Прописываем в зарплату
    IF vbisRedCheck = FALSE AND vbisAdjustment = FALSE
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, zfCalc_UserAdmin());
    END IF;

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inUserId = 3
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inMovementId, inUserId;
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

-- select * from gpUpdate_Status_TechnicalRediscount(inMovementId := 19801455 , inStatusCode := 2 ,  inSession := '3');



