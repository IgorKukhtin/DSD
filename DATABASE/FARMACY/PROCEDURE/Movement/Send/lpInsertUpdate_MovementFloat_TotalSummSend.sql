-- Function: lpInsertUpdate_MovementFloat_TotalSummSend (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSend (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummSend(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountSend TFloat;
  DECLARE vbTotalSummFrom  TFloat;
  DECLARE vbTotalSummTo    TFloat;

  DECLARE vbUnitId_from Integer;
  DECLARE vbUnitId_to   Integer;
  DECLARE vbIsAuto      Boolean;
  DECLARE vbIsSUN       Boolean;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     -- определяется данные из документа
     SELECT MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
          , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) :: Boolean
          , (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE) :: Boolean
            INTO vbUnitId_from
               , vbUnitId_to 
               , vbIsAuto
               , vbIsSUN
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.ID
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.ID
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
          LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                    ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                   AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
     WHERE Movement.Id = inMovementId;



     -- !!!временно!!! - Только для IsSUN
     IF vbIsSUN = TRUE
     THEN
         -- Сохранили PriceFrom + Price_To
         PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN tmpPrice.UnitId = vbUnitId_from THEN zc_MIFloat_PriceFrom()
                                                        WHEN tmpPrice.UnitId = vbUnitId_to   THEN zc_MIFloat_PriceTo()
                                                   END
                                                 , tmpPrice.MovementItemId
                                                 , COALESCE (tmpPrice.Price, 0)
                                                  )
         FROM (WITH tmpMI AS (SELECT MovementItem.Id
                                   , MovementItem.ObjectId
                                   , COALESCE(MovementItem.Amount,0) AS Amount
                              FROM MovementItem
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.DescId     = zc_MI_Master()
                             )
                  , tmpPrice AS (SELECT tmpMI.Id                                     AS MovementItemId
                                      , ObjectLink_Unit.ChildObjectId                AS UnitId
                                      , ROUND (ObjectFloat_Price_Value.ValueData, 2) AS Price
                                  FROM tmpMI
                                       INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = tmpMI.ObjectId
                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_Price_Goods()
                                       INNER JOIN ObjectLink AS ObjectLink_Unit
                                                             ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectLink_Unit.ChildObjectId IN (vbUnitId_from, vbUnitId_to)
                                                            AND ObjectLink_Unit.DescId = zc_ObjectLink_Price_Unit()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                             ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectFloat_Price_Value.DescId  = zc_ObjectFloat_Price_Value()
                                 )
               SELECT tmpPrice.MovementItemId, tmpPrice.UnitId, tmpPrice.Price FROM tmpPrice
              ) AS tmpPrice;
     END IF;


     -- получаем итоговые данные
     WITH
         tmpMI AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId
                        , COALESCE(MovementItem.Amount,0) AS Amount
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.DescId = zc_MI_Master()
                   )
       , tmpPrice AS (SELECT tmpMI.ObjectId                 AS GoodsId
                           , ObjectLink_Unit.ChildObjectId  AS UnitId
                           , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                      FROM (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI) AS tmpMI
                           INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = tmpMI.ObjectId
                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_Price_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.ChildObjectId in (vbUnitId_from, vbUnitId_to)
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_Price_Unit()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                 ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                         )

     -- получаем итоговые данные
     SELECT SUM (tmpMI.Amount)
          , SUM (tmpMI.Amount * (CASE WHEN vbIsAuto = FALSE /*OR vbIsSUN = TRUE*/ THEN Object_Price_From.Price ELSE COALESCE (MIFloat_PriceFrom.ValueData, 0) END)) :: TFloat
          , SUM (tmpMI.Amount * (CASE WHEN vbIsAuto = FALSE /*OR vbIsSUN = TRUE*/ THEN Object_Price_To.Price   ELSE COALESCE (MIFloat_PriceTo.ValueData, 0)   END)) :: TFloat
            INTO vbTotalCountSend, vbTotalSummFrom, vbTotalSummTo
     FROM tmpMI
          -- цена подразделений записанная при автоматическом распределении 
          LEFT JOIN MovementItemFloat AS MIFloat_PriceFrom
                 ON MIFloat_PriceFrom.MovementItemId = tmpMI.Id
                AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceTo
                 ON MIFloat_PriceTo.MovementItemId = tmpMI.Id
                AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

          LEFT JOIN tmpPrice AS Object_Price_From
                             ON Object_Price_From.GoodsId = tmpMI.ObjectId
                            AND Object_Price_From.UnitId = vbUnitId_from
          LEFT JOIN tmpPrice AS Object_Price_To
                             ON Object_Price_To.GoodsId = tmpMI.ObjectId
                            AND Object_Price_To.UnitId = vbUnitId_to
          ;


      -- Сохранили свойство <Итого количество>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountSend);

      -- Сохранили свойство <Итого Сумма накладной в ценах реализации точки-отправителя>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFrom(), inMovementId, vbTotalSummFrom);
      -- Сохранили свойство <Итого Сумма накладной в ценах реализации точки-получателя>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTo(), inMovementId, vbTotalSummTo);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummSend (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 21.03.17         * zc_MovementFloat_TotalSummFrom
                    zc_MovementFloat_TotalSummTo
 20.07.15                                                         * 
*/
