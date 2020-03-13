-- Function: lpUpdate_Movement_TechnicalRediscount_TotalDiff (Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_TechnicalRediscount_TotalDiff (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_TechnicalRediscount_TotalDiff(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalDiff TFloat;
  DECLARE vbTotalDiffSumm TFloat;
  vbUnitId Integer;
BEGIN

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    -- вытягиваем подразделение ...
    SELECT MLO_Unit.ObjectId                                        AS UnitId
    INTO vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
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
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                     )

    -- Результат
    SELECT Sum(MovementItem.Amount)                                                 AS Amount
         , Sum(MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS DiffSumm
    INTO vbTotalDiff, vbTotalDiffSumm
    FROM tmpMovementItem AS MovementItem
         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price();


    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiff(), inMovementId, COALESCE (vbTotalDiff, 0));

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inMovementId, COALESCE (vbTotalDiffSumm, 0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 15.02.20                                                       *
*/